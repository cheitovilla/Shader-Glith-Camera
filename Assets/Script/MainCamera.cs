using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainCamera : MonoBehaviour
{
    [SerializeField] private RawImage img = default;
    private WebCamTexture webCam;
    // Start is called before the first frame update
    private void Start()
    {
        webCam = new WebCamTexture();
        if(!webCam.isPlaying) webCam.Play();
        img.texture = webCam;
    }

}
