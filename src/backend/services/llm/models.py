"""
Minimal LLM integration for homework problem solving.
"""

from typing import Any

from langchain_openai import ChatOpenAI


def get_llm(model_name: str = "gpt-4.1-nano") -> ChatOpenAI:
    """Get OpenAI chat model instance."""
    return ChatOpenAI(
        model=model_name,
        temperature=0.1,
    )


async def call_llm(messages: list[Any], model_name: str = "gpt-4.1-nano") -> str:
    """
    Call OpenAI LLM with messages and return response.
    
    Args:
        messages: List of LangChain message objects
        model_name: Model to use
        
    Returns:
        str: AI response content
    """
    llm = get_llm(model_name)
    response = await llm.ainvoke(messages)
    return response.content