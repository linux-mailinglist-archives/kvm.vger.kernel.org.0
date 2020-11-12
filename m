Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97072B0C13
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKLSBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgKLR7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 12:59:16 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53177C0613D1
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 09:59:16 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id j5so3184473plk.7
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 09:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+2E0mvmNgJ7XpC+sQ+NOvEv+zkMfA4r/PTBbUkrbL/w=;
        b=SKQzcMGrPfPgREcyg033sqfNVqFUwNzXgH/CVdrrVXb1iTFbbTk1+cPuqrDKjQYs0w
         xnPD55nG8D87cwQVtxPsx3x/WbSnBVplloQcnEu8eJnGo6dA9c7wzV3od6915RU/GwKp
         aFWK1ZewW7QrX57B5tiz1dFgCJA3e8fmqZSHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+2E0mvmNgJ7XpC+sQ+NOvEv+zkMfA4r/PTBbUkrbL/w=;
        b=DJA9uk2uKm9q83R89a6tC1cVreqDCrU1Eo1cBx86qqDx8VVc24sem4qVLDEzFf+8i2
         QRjfL7mrAJLQ3CUnvsG89yCTD7yZm6bDzdtvFRQ2N6h66MDNX4POQQYEb32BpbAEE2K6
         PRWYoNWSWif/yqSkdjmjMGI5cvs6FfSxWFfgq7ZJtaUGZpr0npw5/DobT9F2lOjfwoBl
         W/KrBZ5U52pMpChwSK6LhbaMWbNAuuqx0u6MwPHt4yq20oYFX6NNlgFrFRtAUPgDJTT3
         VSKiaSWfm7CuxaAB0oIoM1jZK5iUxrE3V5M12ApzL5SbI072rwK1MQYf0dFNapqTK6y4
         B9Dw==
X-Gm-Message-State: AOAM530efZDAYAWmEra3jsxY3AVneBA4YCAoLt1xwcP4LmBEdZfsKHlQ
        oQVBTONaSygu70SGSYkfqOB14sTs0e2/wLJhJck=
X-Google-Smtp-Source: ABdhPJz+gu5zf5HyLECfUNwTCTiyTQEeeU4UhsPMYECZ7Nh+H4xbEhqG9jst4d/d27y2Oj/DU3b0+A==
X-Received: by 2002:a17:902:c10c:b029:d8:c028:5ceb with SMTP id 12-20020a170902c10cb02900d8c0285cebmr532571pli.36.1605203955729;
        Thu, 12 Nov 2020 09:59:15 -0800 (PST)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r6sm7237894pjd.39.2020.11.12.09.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 09:59:15 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [RFC v1 3/3] vfio/platform: add Broadcom msi module
Date:   Thu, 12 Nov 2020 23:28:52 +0530
Message-Id: <20201112175852.21572-4-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112175852.21572-1-vikas.gupta@broadcom.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000098d31105b3ecabc0"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000098d31105b3ecabc0

Add Broadcom msi module for platform devices.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/vfio/platform/Kconfig                 |  1 +
 drivers/vfio/platform/Makefile                |  1 +
 drivers/vfio/platform/msi/Kconfig             |  9 +++
 drivers/vfio/platform/msi/Makefile            |  2 +
 .../vfio/platform/msi/vfio_platform_bcmplt.c  | 74 +++++++++++++++++++
 5 files changed, 87 insertions(+)
 create mode 100644 drivers/vfio/platform/msi/Kconfig
 create mode 100644 drivers/vfio/platform/msi/Makefile
 create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index dc1a3c44f2c6..7b8696febe61 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -21,3 +21,4 @@ config VFIO_AMBA
 	  If you don't know what to do here, say N.
 
 source "drivers/vfio/platform/reset/Kconfig"
+source "drivers/vfio/platform/msi/Kconfig"
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 3f3a24e7c4ef..9ccdcdbf0e7e 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -5,6 +5,7 @@ vfio-platform-y := vfio_platform.o
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
 obj-$(CONFIG_VFIO_PLATFORM) += reset/
+obj-$(CONFIG_VFIO_PLATFORM) += msi/
 
 vfio-amba-y := vfio_amba.o
 
diff --git a/drivers/vfio/platform/msi/Kconfig b/drivers/vfio/platform/msi/Kconfig
new file mode 100644
index 000000000000..54d6b70e1e32
--- /dev/null
+++ b/drivers/vfio/platform/msi/Kconfig
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config VFIO_PLATFORM_BCMPLT_MSI
+	tristate "MSI support for Broadcom platform devices"
+	depends on VFIO_PLATFORM && (ARCH_BCM_IPROC || COMPILE_TEST)
+	default ARCH_BCM_IPROC
+	help
+	  Enables the VFIO platform driver to handle msi for Broadcom devices
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/msi/Makefile b/drivers/vfio/platform/msi/Makefile
new file mode 100644
index 000000000000..27422d45cecb
--- /dev/null
+++ b/drivers/vfio/platform/msi/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_VFIO_PLATFORM_BCMPLT_MSI) += vfio_platform_bcmplt.o
diff --git a/drivers/vfio/platform/msi/vfio_platform_bcmplt.c b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
new file mode 100644
index 000000000000..7f44d7d0c95d
--- /dev/null
+++ b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2020 Broadcom.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/msi.h>
+#include <linux/vfio.h>
+
+#include "../vfio_platform_private.h"
+
+#define RING_SIZE		(64 << 10)
+
+#define RING_MSI_ADDR_LS	0x03c
+#define RING_MSI_ADDR_MS	0x040
+#define RING_MSI_DATA_VALUE	0x064
+
+static u32 bcm_num_msi(struct vfio_platform_device *vdev)
+{
+	struct vfio_platform_region *reg = &vdev->regions[0];
+
+	return (reg->size / RING_SIZE);
+}
+
+static int bcm_write_msi(struct vfio_platform_device *vdev,
+			 struct msi_desc *desc,
+			 struct msi_msg *msg)
+{
+	void __iomem *ring;
+	int msi_off = vdev->num_irqs - 1;
+	int ring_num = desc->irq - vdev->irqs[msi_off].hwirq;
+	struct vfio_platform_region *reg = &vdev->regions[0];
+
+	if (!reg->ioaddr) {
+		reg->ioaddr = ioremap(reg->addr, reg->size);
+		if (!reg->ioaddr)
+			return -ENOMEM;
+	}
+
+	ring = reg->ioaddr + ring_num * RING_SIZE;
+
+	writel_relaxed(msg->address_lo, ring + RING_MSI_ADDR_LS);
+	writel_relaxed(msg->address_hi, ring + RING_MSI_ADDR_MS);
+	writel_relaxed(msg->data, ring + RING_MSI_DATA_VALUE);
+
+	return 0;
+}
+
+static struct vfio_platform_msi_node vfio_platform_bcmflexrm_msi_node = {
+	.owner = THIS_MODULE,
+	.compat = "brcm,iproc-flexrm-mbox",
+	.of_get_msi = bcm_num_msi,
+	.of_msi_write = bcm_write_msi
+};
+
+static int __init vfio_platform_bcmflexrm_msi_module_init(void)
+{
+	__vfio_platform_register_msi(&vfio_platform_bcmflexrm_msi_node);
+
+	return 0;
+}
+
+static void __exit vfio_platform_bcmflexrm_msi_module_exit(void)
+{
+	vfio_platform_unregister_msi("brcm,iproc-flexrm-mbox");
+}
+
+module_init(vfio_platform_bcmflexrm_msi_module_init);
+module_exit(vfio_platform_bcmflexrm_msi_module_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Broadcom");
-- 
2.17.1


--00000000000098d31105b3ecabc0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2lQ6rFUP408r38ha7ieLj9GoHHitwSmKYwUIGObe2Y57xYNj855BF4wx44Z80uM2ugKCZwIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUnmgVV8btvFtO
FD3kFjPWxD/aB8MwDQYJKoZIhvcNAQELBQADggEBAGCcuBN7G3mbQ7xMF8g8Lpz6WE+UFmkSSqU3
FZLC2I92SA5lRIthcdz4AEgte6ywnef3+2mG7HWMoQ1wriSG5qLppAD02Uku6yRD52Sn67DB2Ozk
yhBJayurzUxN1+R5E/YZtj2fkNajS5+i85e83PZPvVJ8/WnseIADGvDoouWqK7mxU/p8hELdb3PW
JH2nMg39SpVAwmRqfs6mYtenpMwKtQd9goGkIFXqdSvOPATkbS1YIGtU2byLK+/1rIWPoKNmRddj
WOu/loxldI1sJa1tOHgtb93YpIe0HEmgxLGS0KEnbM+rn9vXNKCe+9n0PhxJIfqcf6rAtK0prRwr
Y2MxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDDTZ
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgmHWIJHv95Wl6tAcm
YKTRFawhiNuDVgrpgORPjbLhEJswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTEyMTc1OTE2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGUlnOUY9AfPMO8lmV6sk0b4Ig8Aeq/cVOsf
RhO8JjIydXkMMpoiu43n8JkihQQy8wp5AVOAvAXVqi3Dzu9rHYXJ4cT7AoAHeZQ7RVJeLMXja5NI
/TdWs3bnunzOWoeE4LODWKKw5+nNvD3PgIZSfmtCqmYBwVKJtFcI7SgG8wVc7klpRInhHtIFuQSc
N2OhtSpHHuwSvZvynyRfcrjE9XmnRAtPdoXUR3LHdux3mD5lc26uE7zUzRhueilx0BX6FJ0b6F3w
E/Z0nekjY0m/mkPGiGcUHSUY2L0ThsvOSOvazc2JL+umujUwJnweNpwkPjjroMoQOjzRTjq5ycrN
Oew=
--00000000000098d31105b3ecabc0--
