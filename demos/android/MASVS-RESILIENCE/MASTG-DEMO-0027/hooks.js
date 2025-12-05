var target = {
  category: "STORAGE",
  demo: "0002",
  hooks: [
    {
      class: "android.app.KeyguardManager",
      method: "isDeviceSecure",
      overloads: [
        {
          "args": []
        }
      ]
    },
    {
      class: "android.hardware.biometrics.BiometricManager",
      method: "canAuthenticate",
      overloads: [
        {
          args: ["int"]
        }
      ]
    }
  ]
};
