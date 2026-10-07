"""
title: Учебник в каждом вопросе
description: Автоматически подключает к каждому сообщению базы знаний, прикреплённые к модели (как если бы ребёнок набрал #).
version: 1.0
"""

from typing import Optional

from pydantic import BaseModel, Field


class Filter:
    class Valves(BaseModel):
        priority: int = Field(default=0, description="Порядок выполнения фильтра")
        knowledge_ids: str = Field(
            default="",
            description=(
                "Необязательно. ID баз знаний через запятую — если нужно подключать "
                "базы, не прикреплённые к модели. Обычно оставьте пустым."
            ),
        )

    def __init__(self):
        self.valves = self.Valves()

    def _model_knowledge(self, model: Optional[dict]) -> list:
        """Базы знаний, прикреплённые к модели в её настройках (блок «Знания»)."""
        meta = ((model or {}).get("info") or {}).get("meta") or {}
        items = []
        for k in meta.get("knowledge") or []:
            if isinstance(k, dict) and k.get("id"):
                items.append(
                    {
                        "type": k.get("type") or "collection",
                        "id": k["id"],
                        "name": k.get("name", ""),
                    }
                )
        return items

    def inlet(self, body: dict, __model__: Optional[dict] = None) -> dict:
        wanted = self._model_knowledge(__model__)
        for kid in (i.strip() for i in self.valves.knowledge_ids.split(",")):
            if kid:
                wanted.append({"type": "collection", "id": kid, "name": ""})
        if not wanted:
            return body

        files = list(body.get("files") or [])
        present = {f.get("id") for f in files if isinstance(f, dict)}
        for item in wanted:
            if item["id"] not in present:
                files.append(item)
                present.add(item["id"])

        body["files"] = files
        # В новых версиях Open WebUI файлы запроса читаются также из metadata
        if isinstance(body.get("metadata"), dict):
            body["metadata"]["files"] = files
        return body
