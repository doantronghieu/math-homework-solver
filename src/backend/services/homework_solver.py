"""
Simple stateless homework solver service.
"""

import base64
import time
import asyncio
from typing import Dict, Any

from .llm import call_llm, create_human_image_message


class HomeworkSolver:
    """Simple stateless service for solving homework problems using AI."""
    
    def __init__(self):
        # Structured prompt for homework problem solving
        self.solution_prompt = """
Analyze this homework problem image and provide a comprehensive step-by-step solution:

**Instructions:**
1. **Problem Identification**: Identify what type of problem this is (math, science, literature, etc.)
2. **Given Information**: List all the information provided in the problem
3. **Solution Strategy**: Explain your approach to solving this problem
4. **Step-by-Step Solution**: Break down the solution into clear, numbered steps with explanations
5. **Calculations**: Show all mathematical work and reasoning using simple text (avoid LaTeX/complex formatting)
6. **Final Answer**: Provide the complete, clear answer
7. **Verification**: Briefly explain how to check if the answer is correct

**Formatting Guidelines:**
- Use simple text for mathematical expressions (e.g., "5 × 10,000 = 50,000" instead of LaTeX)
- Use Unicode symbols when helpful (×, ÷, ≤, ≥, π, etc.)
- Avoid complex LaTeX formatting that may not render properly
- Use code blocks for step-by-step calculations
- Make it educational and easy to read for students

**Format your response clearly with headers and make it educational for the student.**
        """.strip()
    
    def solve_homework_problem(self, image_data: bytes) -> Dict[str, Any]:
        """
        Solve a homework problem from an uploaded image.
        
        Args:
            image_data: Image bytes
            
        Returns:
            Dict[str, Any]: Solution result with solution text and processing time
        """
        start_time = time.time()
        
        try:
            # 1. Encode image as base64
            image_base64 = base64.b64encode(image_data).decode('utf-8')
            
            # 2. Create LLM message with image and prompt
            image_message = create_human_image_message(
                image_base64, self.solution_prompt
            )
            
            # 3. Call LLM to solve the problem
            solution = asyncio.run(call_llm([image_message]))
            
            # 4. Calculate processing time
            processing_time = time.time() - start_time
            
            return {
                'success': True,
                'solution': solution,
                'processing_time': processing_time
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'processing_time': time.time() - start_time
            }