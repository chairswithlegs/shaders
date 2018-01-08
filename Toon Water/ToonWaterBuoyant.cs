using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Using the same algorithm as the ToonWater shader, this script gives objects the appearance of buoyancy.
public class ToonWaterBuoyant : MonoBehaviour {
	[Range(0,1)]
	public float Frequency;
	[Range(0,1)]
	public float Amplitude;

	// Update is called once per frame.
	void Update () {
		float y = WaveHeight (transform.position.x, transform.position.z, Amplitude, Frequency, Time.time);
		transform.position = new Vector3 (transform.position.x, y, transform.position.z);
	}

	//Applies an algorithm to determine the wave height given a world position.
	float WaveHeight (float x, float z, float Amplitude, float Frequency, float time) {
		float y = (Mathf.Sin((x * 1 + time) * Frequency) + Mathf.Sin((x * 2f + time * 1.5f) * Frequency) + Mathf.Sin((x * 3f + time * 0.4f) * Frequency) / 3f);
		y += (Mathf.Sin((z * 1 + time) * Frequency) + Mathf.Sin((z * 2f + time * 1.5f) * Frequency) + Mathf.Sin((z * 3f + time * 0.4f) * Frequency) / 3f);

		return y * Amplitude / 2;
	}
}
