"""
Message utilities for creating LLM messages with images.
"""

from langchain_core.messages import HumanMessage


def create_human_image_message(image_base64: str, text: str) -> HumanMessage:
    """
    Create a human message with base64 image and text.
    
    Args:
        image_base64: Base64 encoded image data
        text: Text prompt to accompany the image
        
    Returns:
        HumanMessage: Message containing image and text
    """
    content = [
        {"type": "text", "text": text},
        {
            "type": "image_url",
            "image_url": {
                "url": f"data:image/jpeg;base64,{image_base64}"
            }
        }
    ]
    
    return HumanMessage(content=content)