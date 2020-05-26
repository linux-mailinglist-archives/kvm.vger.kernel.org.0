Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69831A5E96
	for <lists+kvm@lfdr.de>; Sun, 12 Apr 2020 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgDLMvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Apr 2020 08:51:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31573 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgDLMvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Apr 2020 08:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586695860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=J+P6WFvAHjtNNYxSujhikQ/SLnkXm6oAjgZY+UpbQI8=;
        b=boqULPck+2ZVamI2iBA3qBi3H36o8AJE3Tv1e7Gm+bYamCF0VSvHa2UpHnaiCGxLS1lo0/
        3OZibIUI2yAjCyUqy0TkiL+QAVGQ7zIwv+DTpgT3o8kldkYj5gHgiY99c3v2bWvTN0eSUL
        BF+KudVeERpXvvcVtuDmaU7wTBE/MUQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-SiryCZSNOkefZPMtMjnwDg-1; Sun, 12 Apr 2020 08:50:56 -0400
X-MC-Unique: SiryCZSNOkefZPMtMjnwDg-1
Received: by mail-wr1-f71.google.com with SMTP id m5so1811194wru.15
        for <kvm@vger.kernel.org>; Sun, 12 Apr 2020 05:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=J+P6WFvAHjtNNYxSujhikQ/SLnkXm6oAjgZY+UpbQI8=;
        b=FFkr9mfWIGm/hpE2JcgFhfzKhaCGMdwGVrjJhs16b8FOR49frQy/f2kckXicglcr3/
         4/4U1756SdStZ+Xcijq791RUabZvHz+Jub/9vBi8KcS6LYmM3Y8U/ipRONiw9xrZEDo6
         YfBF0M+MC3LeWHSQxDCwvgmLuyWPdb9TxmT56UjSzE6G68781S6yozjvOGihPwCS2Tbd
         qKofgkSE5BFV3JpTvnWJonlGAYTBJxzSujxF0W0mKSpc1HX1wl1p7KKig/tfQw68pNaa
         YBWmibTl/U4kP2b3dSMobAjbOepguM+K6/42uTKeKZ+PdFyo6INe7F481vILz7zD3gUo
         YMSg==
X-Gm-Message-State: AGi0PubgA4r+hZXI5zzYRkwWI5eadaECEAWgv61qzll/JOqwwLWwTxCs
        N5ZEtNSX/s0Fh2mh8JHLxve41nYKW2+ZtAN/U1MqNmR8E6yhAhX6i2moy6mqH/7JU8E0UFKq5Bw
        X8JjpF1eYZ8c+
X-Received: by 2002:adf:ed01:: with SMTP id a1mr14380004wro.18.1586695855375;
        Sun, 12 Apr 2020 05:50:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypIUhlFj+KOcSj2QR37FIgHBt0IwiNyC4XwCoIuZzbiBL5BykeS8EPIx8I2HyZxUPmIjnjTv0Q==
X-Received: by 2002:adf:ed01:: with SMTP id a1mr14379984wro.18.1586695855098;
        Sun, 12 Apr 2020 05:50:55 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id b11sm10866184wrq.26.2020.04.12.05.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 05:50:54 -0700 (PDT)
Date:   Sun, 12 Apr 2020 08:50:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] vdpa: make vhost, virtio depend on menu
Message-ID: <20200412125018.74964-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If user did not configure any vdpa drivers, neither vhost
nor virtio vdpa are going to be useful. So there's no point
in prompting for these and selecting vdpa core automatically.
Simplify configuration by making virtio and vhost vdpa
drivers depend on vdpa menu entry. Once done, we no longer
need a separate menu entry, so also get rid of this.
While at it, fix up the IFC entry: VDPA->vDPA for consistency
with other places.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

changes from v1:
	fix up virtio vdpa Kconfig

 drivers/vdpa/Kconfig   | 16 +++++-----------
 drivers/vhost/Kconfig  |  2 +-
 drivers/virtio/Kconfig |  2 +-
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index d0cb0e583a5d..71d9a64f2c7d 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -1,21 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VDPA
-	tristate
+menuconfig VDPA
+	tristate "vDPA drivers"
 	help
 	  Enable this module to support vDPA device that uses a
 	  datapath which complies with virtio specifications with
 	  vendor specific control path.
 
-menuconfig VDPA_MENU
-	bool "VDPA drivers"
-	default n
-
-if VDPA_MENU
+if VDPA
 
 config VDPA_SIM
 	tristate "vDPA device simulator"
 	depends on RUNTIME_TESTING_MENU && HAS_DMA
-	select VDPA
 	select VHOST_RING
 	select VHOST_IOTLB
 	default n
@@ -25,9 +20,8 @@ config VDPA_SIM
 	  development of vDPA.
 
 config IFCVF
-	tristate "Intel IFC VF VDPA driver"
+	tristate "Intel IFC VF vDPA driver"
 	depends on PCI_MSI
-	select VDPA
 	default n
 	help
 	  This kernel module can drive Intel IFC VF NIC to offload
@@ -35,4 +29,4 @@ config IFCVF
 	  To compile this driver as a module, choose M here: the module will
 	  be called ifcvf.
 
-endif # VDPA_MENU
+endif # VDPA
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index cb6b17323eb2..e79cbbdfea45 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -64,7 +64,7 @@ config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
 	depends on EVENTFD
 	select VHOST
-	select VDPA
+	depends on VDPA
 	help
 	  This kernel module can be loaded in host kernel to accelerate
 	  guest virtio devices with the vDPA-based backends.
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 2aadf398d8cc..395c3f4d49cb 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -45,7 +45,7 @@ config VIRTIO_PCI_LEGACY
 
 config VIRTIO_VDPA
 	tristate "vDPA driver for virtio devices"
-	select VDPA
+	depends on VDPA
 	select VIRTIO
 	help
 	  This driver provides support for virtio based paravirtual
-- 
MST

