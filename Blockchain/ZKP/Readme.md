The prover generates two random numbers, "r1" and "r2".
The prover computes "y1" and "y2" as follows:
y1 = r1^2
y2 = x * r2^2
The prover sends "y1" and "y2" to the verifier.
The verifier generates a random bit "b" (0 or 1) and sends it to the prover.
The prover computes "s" as follows:
s = r1 * (r2^b)
The prover sends "s" to the verifier.
The verifier checks whether:
y1 * (s^2) = y2 * (r1^2)^b
If the check passes, the verifier accepts the proof, and if not, the verifier rejects the proof.