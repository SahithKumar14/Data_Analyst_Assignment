def minutes_to_human(minutes):
    """
    Convert integer minutes to 'X hrs Y minutes' string.

    Examples:
      130 -> "2 hrs 10 minutes"
      110 -> "1 hr 50 minutes"
      60  -> "1 hr 0 minutes"
      0   -> "0 hr 0 minutes"
    """
    if minutes is None:
        raise ValueError("minutes must be an integer")
    if not isinstance(minutes, int):
        try:
            minutes = int(minutes)
        except Exception:
            raise ValueError("minutes must be convertible to int")
    if minutes < 0:
        raise ValueError("minutes must be non-negative")

    hours = minutes // 60
    mins = minutes % 60
    hr_label = "hr" if hours == 1 else "hrs"
    min_label = "minute" if mins == 1 else "minutes"
    return f"{hours} {hr_label} {mins} {min_label}"


# Example usage
if __name__ == "__main__":
    examples = [130, 110, 60, 0, 1, 121]
    for ex in examples:
        print(f"{ex} -> {minutes_to_human(ex)}")
