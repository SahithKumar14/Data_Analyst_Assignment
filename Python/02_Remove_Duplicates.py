def remove_duplicates_keep_order(s):
    """
    Remove duplicate characters from the string `s` preserving first occurrence order.
    Uses a loop (no set comprehensions that reorder).
    Example:
      "banana" -> "ban"
      "AaBbAa" -> "AaBb" (case-sensitive)
    """
    if s is None:
        return s
    result = []
    seen = set()
    for ch in s:
        if ch not in seen:
            result.append(ch)
            seen.add(ch)
    return ''.join(result)


# Example usage
if __name__ == "__main__":
    samples = ["banana", "mississippi", "aabbcc", "ABaB", ""]
    for s in samples:
        print(f"'{s}' -> '{remove_duplicates_keep_order(s)}'")
