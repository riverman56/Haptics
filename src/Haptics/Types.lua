export type sequenceNode = {
    amplitude: number,
    length: number,
    delay: number,
}

export type vibrationSequence = {[number]: sequenceNode}

export type vibration = {
    input: Enum.UserInputType,
    motor: Enum.VibrationMotor,
    _sequence: vibrationSequence,
}

return {}