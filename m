Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C93308B85
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhA2R3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhA2R0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:26:09 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FF4C061788
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 09:24:51 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cq1so6134948pjb.4
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 09:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9JwHZKN7IuEP8JQcuIlNN08rrng3LGs5w6sOoVE/E+Q=;
        b=fZMYkrxx+esCtt7HB5VW5fxx4/G39fYPJ9hpRMASHAUbb9M+2EdAcfeQW9NUKTCvfE
         nPKYtNCy5faqqSrL2TOTZbzBiPy/T6JCzWPjjyFBsBDFMfFiWECy6gNT/+MLZLFcC0Em
         7tUXd8m6662u2ywhbEGuNbCP1CLcAO0MMi3Z0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9JwHZKN7IuEP8JQcuIlNN08rrng3LGs5w6sOoVE/E+Q=;
        b=pAD1PbJ0jhEVGgZSzQ617b7tlNgSXe7ZpewISbzTpF1mAA8jezW2g+xgfVR0iumd/o
         1d1RHqqDV8kFC/CjEITVN0wCiet4CwHZs+Q1sPu0ewMHZHPZ7V3lORheo+RgDzqiOmv3
         AH/NjkBZ+4jh5xxvSMOwBcPvxdzS7J65LRAXzdLeWehFO8NvGwPJVLAnUgzMaVh582CY
         U3ByNl4yRozGlfBp3PdznwMQnO8q//3MWqm103vVJ9ndI+VS6D0RBM98xj4LzFcf+O5w
         D7rNlzzOCBs+RFEVIGbAuWeNjSID2Qiyewyh4xZSLHksemV6NwMeDID3ZQbONQa7DQVO
         v/Dw==
X-Gm-Message-State: AOAM533mhWoICLSVeIwvkopsC8J9qLrZyA3tzM2lFQpQvKER6VyRcVfD
        Y0xMsHknxvBPTiSv1BTrproJWA==
X-Google-Smtp-Source: ABdhPJw6NDJK8xRAfGxWmP5w7msd3QKMC9ZPlpS3UWjmJg+UxOkcQtIOKx6B76K4zzzDgSpi+yI9Rw==
X-Received: by 2002:a17:90a:f2c6:: with SMTP id gt6mr5414892pjb.35.1611941091086;
        Fri, 29 Jan 2021 09:24:51 -0800 (PST)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w11sm9739016pge.28.2021.01.29.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 09:24:50 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com, Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [RFC v4 3/3] vfio: platform: reset: add msi support
Date:   Fri, 29 Jan 2021 22:54:21 +0530
Message-Id: <20210129172421.43299-4-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210129172421.43299-1-vikas.gupta@broadcom.com>
References: <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002a281605ba0d48b8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--0000000000002a281605ba0d48b8

Add msi support for Broadcom FlexRm device.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 .../platform/reset/vfio_platform_bcmflexrm.c  | 72 ++++++++++++++++++-
 1 file changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
index 96064ef8f629..6ca4ca12575b 100644
--- a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
+++ b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
@@ -21,7 +21,9 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/msi.h>
 #include <linux/module.h>
+#include <linux/vfio.h>
 
 #include "../vfio_platform_private.h"
 
@@ -33,6 +35,9 @@
 #define RING_VER					0x000
 #define RING_CONTROL					0x034
 #define RING_FLUSH_DONE					0x038
+#define RING_MSI_ADDR_LS				0x03c
+#define RING_MSI_ADDR_MS				0x040
+#define RING_MSI_DATA_VALUE				0x064
 
 /* Register RING_CONTROL fields */
 #define CONTROL_FLUSH_SHIFT				5
@@ -105,8 +110,71 @@ static int vfio_platform_bcmflexrm_reset(struct vfio_platform_device *vdev)
 	return ret;
 }
 
-module_vfio_reset_handler("brcm,iproc-flexrm-mbox",
-			  vfio_platform_bcmflexrm_reset);
+static u32 bcm_num_msi(struct vfio_platform_device *vdev)
+{
+	struct vfio_platform_region *reg = &vdev->regions[0];
+
+	return (reg->size / RING_REGS_SIZE);
+}
+
+static void bcm_write_msi(struct vfio_platform_device *vdev,
+		struct msi_desc *desc,
+		struct msi_msg *msg)
+{
+	int i;
+	int hwirq = -1;
+	int msi_src;
+	void __iomem *ring;
+	struct vfio_platform_region *reg = &vdev->regions[0];
+
+	if (!reg)
+		return;
+
+	for (i = 0; i < vdev->num_irqs; i++)
+		if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
+			hwirq = vdev->irqs[i].ctx[0].hwirq;
+
+	if (hwirq < 0)
+		return;
+
+	msi_src = desc->irq - hwirq;
+
+	if (!reg->ioaddr) {
+		reg->ioaddr = ioremap(reg->addr, reg->size);
+		if (!reg->ioaddr)
+			return;
+	}
+
+	ring = reg->ioaddr + msi_src * RING_REGS_SIZE;
+
+	writel_relaxed(msg->address_lo, ring + RING_MSI_ADDR_LS);
+	writel_relaxed(msg->address_hi, ring + RING_MSI_ADDR_MS);
+	writel_relaxed(msg->data, ring + RING_MSI_DATA_VALUE);
+}
+
+static struct vfio_platform_reset_node vfio_platform_bcmflexrm_reset_node = {
+	.owner = THIS_MODULE,
+	.compat = "brcm,iproc-flexrm-mbox",
+	.of_reset = vfio_platform_bcmflexrm_reset,
+	.of_get_msi = bcm_num_msi,
+	.of_msi_write = bcm_write_msi
+};
+
+static int __init vfio_platform_bcmflexrm_reset_module_init(void)
+{
+	__vfio_platform_register_reset(&vfio_platform_bcmflexrm_reset_node);
+
+	return 0;
+}
+
+static void __exit vfio_platform_bcmflexrm_reset_module_exit(void)
+{
+	vfio_platform_unregister_reset("brcm,iproc-flexrm-mbox",
+				       vfio_platform_bcmflexrm_reset);
+}
+
+module_init(vfio_platform_bcmflexrm_reset_module_init);
+module_exit(vfio_platform_bcmflexrm_reset_module_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Anup Patel <anup.patel@broadcom.com>");
-- 
2.17.1


--0000000000002a281605ba0d48b8
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
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgrHdnIpcb7RdwHRp2
AZIE8Maf0g0SUFW2qHGvKxQdZ9kwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjEwMTI5MTcyNDUxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKiiO7enlReijWdRE+b4uf8lGnI6zgsu6dYq
NVJ5DdyHA/LbNf3xYnXTBPb/NPZqo+rGNMyE4Fg/MB8XdLiifdDfvgItltqtmjTvflNEBSRTlYvn
ABnrkZgy/jPRHnuXxeXaI+54P4MRN0/JlpFNOEq8wd7VHvqY7mn+msV3JNG9s6RQ0NVYf7so4YSJ
bxlRRAfC5u9fVky2isLT34Ek6fwclDcyzyQWHh4AYK9K/9Z9WEWjkJb+IoQ5OM8phcF5Cahf7/JM
c7vZe4ONZ1h0mG4P7qmhAmLygEzpCi+HTkPiEI7JemdCgbBV2YHxbWThnixQ18Hkqk7V+03ozmy+
EzE=
--0000000000002a281605ba0d48b8--
