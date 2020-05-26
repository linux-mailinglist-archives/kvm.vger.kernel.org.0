Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1E1AD2C3
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 00:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgDPWUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 18:20:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35729 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728817AbgDPWUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 18:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587075636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=LKcXo+p/uaeU/hsHRyKbdRNMgG4/p28XvmGbqiu1vto=;
        b=RgeU1BKY/zuiMPVHB2Z5lLwz3iphXI6PQXbCfYUHzm/F2sUxh+kmK3RFbxHsrlbWD+XBte
        mHCWrXsu1mAstv2Cik200wiTwC5c9hwyE8trqL4uUptXnaOTMv7LoLJ5rzWa2bmS7z6541
        9lMxjYYLp+UOWYQvJsw/E+Itv0ccjgY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-VMzsqttjMWq6OdaiSCkvTA-1; Thu, 16 Apr 2020 18:20:24 -0400
X-MC-Unique: VMzsqttjMWq6OdaiSCkvTA-1
Received: by mail-wr1-f71.google.com with SMTP id s11so2478954wru.6
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 15:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=LKcXo+p/uaeU/hsHRyKbdRNMgG4/p28XvmGbqiu1vto=;
        b=XoWf/E0UGvDo/yqVuniYxdlx67/UFeSOo9QY90QbzyPVbkZOv6YORDYy5VZBcjqUpU
         Xrv4nG4cx5iC2XvMm6PCvfqC8YxTAa35Ma+XoKf6XsjdnMn9Z4INxTU4Q2zNiX/xQ7O8
         EbxcNuDjfoIdrscaKq06W4JUC3lX3DrmBU9V1rB/MRFQJUFR6LiCTA7htHtc/NObJoE1
         ded72e8dlo3zwx5nMiK+/HN8k1Ser9fQ3gajV4AoB6AFfRqrkKcxyyukLryidlpJPsI3
         ZXL968nrZ5lDZpRgT97TgFTiLM26kzpwZHZfCt+rErJsrCAzwFo2ifjrS2kyszcUGp5m
         XRWA==
X-Gm-Message-State: AGi0PuYThYtuStsbMRac545JT7/qtTVlVxMQ+DAxdmUEs4e//yfJzntY
        9GIQk/prrber/5Kd99GcI26zMEgN1N2qefHxf3yssw6fArUyKJYKElbSgV3sc8AUCBrMlcZ63Hi
        SKGBqB3k/3bYP
X-Received: by 2002:a7b:c955:: with SMTP id i21mr43720wml.25.1587075622982;
        Thu, 16 Apr 2020 15:20:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypLTMzBiCaoZdbA9StOEic7q7PuNDUniFaAXDS0fu05xLaJzs2UfTHwtFzY0cbIA235H0bagiw==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr43692wml.25.1587075622724;
        Thu, 16 Apr 2020 15:20:22 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id g186sm5712499wmg.36.2020.04.16.15.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 15:20:22 -0700 (PDT)
Date:   Thu, 16 Apr 2020 18:20:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v3] vhost: disable for OABI
Message-ID: <20200416221902.5801-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vhost is currently broken on the some ARM configs.

The reason is that that uses apcs-gnu which is the ancient OABI that is been
deprecated for a long time.

Given that virtio support on such ancient systems is not needed in the
first place, let's just add something along the lines of

	depends on !ARM || AEABI

to the virtio Kconfig declaration, and add a comment that it has to do
with struct member alignment.

Note: we can't make VHOST and VHOST_RING themselves have
a dependency since these are selected. Add a new symbol for that.

Link: https://lore.kernel.org/r/20200406121233.109889-3-mst@redhat.com
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Suggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Changes from v2:
	- drop prompt from VHOST_DPN
	- typo fix in commit log
	- OABI is a possible ARM config but not the default one

 drivers/misc/mic/Kconfig |  2 +-
 drivers/net/caif/Kconfig |  2 +-
 drivers/vdpa/Kconfig     |  2 +-
 drivers/vhost/Kconfig    | 17 +++++++++++++----
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index 8f201d019f5a..3bfe72c59864 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -116,7 +116,7 @@ config MIC_COSM
 
 config VOP
 	tristate "VOP Driver"
-	depends on VOP_BUS
+	depends on VOP_BUS && VHOST_DPN
 	select VHOST_RING
 	select VIRTIO
 	help
diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index 9db0570c5beb..661c25eb1c46 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -50,7 +50,7 @@ config CAIF_HSI
 
 config CAIF_VIRTIO
 	tristate "CAIF virtio transport driver"
-	depends on CAIF && HAS_DMA
+	depends on CAIF && HAS_DMA && VHOST_DPN
 	select VHOST_RING
 	select VIRTIO
 	select GENERIC_ALLOCATOR
diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
index 71d9a64f2c7d..ee35f8261a88 100644
--- a/drivers/vdpa/Kconfig
+++ b/drivers/vdpa/Kconfig
@@ -10,7 +10,7 @@ if VDPA
 
 config VDPA_SIM
 	tristate "vDPA device simulator"
-	depends on RUNTIME_TESTING_MENU && HAS_DMA
+	depends on RUNTIME_TESTING_MENU && HAS_DMA && VHOST_DPN
 	select VHOST_RING
 	select VHOST_IOTLB
 	default n
diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index e79cbbdfea45..d9b3a3ec765a 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -12,6 +12,15 @@ config VHOST_RING
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
 
+config VHOST_DPN
+	bool
+	depends on !ARM || AEABI
+	default y
+	help
+	  Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
+	  This excludes the deprecated ARM ABI since that forces a 4 byte
+	  alignment on all structs - incompatible with virtio spec requirements.
+
 config VHOST
 	tristate
 	select VHOST_IOTLB
@@ -27,7 +36,7 @@ if VHOST_MENU
 
 config VHOST_NET
 	tristate "Host kernel accelerator for virtio net"
-	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
+	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP) && VHOST_DPN
 	select VHOST
 	---help---
 	  This kernel module can be loaded in host kernel to accelerate
@@ -39,7 +48,7 @@ config VHOST_NET
 
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
-	depends on TARGET_CORE && EVENTFD
+	depends on TARGET_CORE && EVENTFD && VHOST_DPN
 	select VHOST
 	default n
 	---help---
@@ -48,7 +57,7 @@ config VHOST_SCSI
 
 config VHOST_VSOCK
 	tristate "vhost virtio-vsock driver"
-	depends on VSOCKETS && EVENTFD
+	depends on VSOCKETS && EVENTFD && VHOST_DPN
 	select VHOST
 	select VIRTIO_VSOCKETS_COMMON
 	default n
@@ -62,7 +71,7 @@ config VHOST_VSOCK
 
 config VHOST_VDPA
 	tristate "Vhost driver for vDPA-based backend"
-	depends on EVENTFD
+	depends on EVENTFD && VHOST_DPN
 	select VHOST
 	depends on VDPA
 	help
-- 
MST

