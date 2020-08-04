Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99423BAA8
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgHDMqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgHDMo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 08:44:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B82AC0617A0
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 05:44:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so2548582wmi.2
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bN3d8Ia77BH2nBiHDQ6zBNPByWQO01hAGf1Nc3k/FjU=;
        b=T8YDxwS+GAi/l87EqEDVnHA6L2vWdoJLRomogp4zswguktwRhtfY6a3S80oC+la+7Y
         uBOGZPkWUazcUyhEPQsfO3QZ16muTbOfxNxa4uXdYwfXdmkfVzoMRSW4m/T7f0i4RLf7
         dX+k8C7kUSi09yoGq/WkXRUuQWQIUOu80qSJ8B9K9QLhl5toYoFUrNUqUcTwdRw8GrmH
         fMUA0SnmjEveRBv57i02a+TxYyxNXCrEDBzYs7JuFuOONWrjDdCFY0ND5r47wpeLc24V
         fJMl0bur8BNgusZj++pQeoEnXBDmf1q7b4PbFj3Wzq0ri29fof8CCFp8ai4icK9pDdY1
         JhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bN3d8Ia77BH2nBiHDQ6zBNPByWQO01hAGf1Nc3k/FjU=;
        b=NkaEweb9yetJcUncRn7xsPJo7ymD3GUjbl9IZe+2HEpVuVFV+IE6UcvnyaXluCL3Tx
         g6zXtw1z/iuMXszvN7OD7dRELw5wee+EEal0x8odhMV0HhLDQsmQzTONs71Sh81tFGbY
         dBGyh+hTBFr0HvIKirwoQdAJ6ebGGhSrmoyVfnFRLldz0vFIfcCkMeSqDNMVn2Ohc4z7
         7LXzQgKlC73DwJ96ZtdzFCCBTomrM4iU9YPdVjBxrvw0kBtb9ehc/v4sXKk/uU/mRmHc
         L8kdK6hZoAm0lta5pzetmygQcISg04wq7RoAr8t3ktQ2wj+aCbq+0DeaNAgWM0pTTHLs
         YZnQ==
X-Gm-Message-State: AOAM532/u1CQkhlqOb3Obxr5KFWmE7p8WuffHQxzYGATSZjoephTTEYS
        06XLg+jjBTF/ziO2hWYs8wLudg==
X-Google-Smtp-Source: ABdhPJz9A0fUr0s+57vaSQaPT8GQEVwMIBWtT6cib6RQGYxAGZypLJ4R2NHV8/yEEKGRo0R1n0bqCQ==
X-Received: by 2002:a7b:c257:: with SMTP id b23mr3829607wmj.164.1596545062751;
        Tue, 04 Aug 2020 05:44:22 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id b137sm4843577wmb.9.2020.08.04.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 860581FF87;
        Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Robert Richter <rrichter@marvell.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH  v1 1/3] arm64: allow de-selection of ThunderX PCI controllers
Date:   Tue,  4 Aug 2020 13:44:15 +0100
Message-Id: <20200804124417.27102-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804124417.27102-1-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For a pure VirtIO guest bringing in all the PCI quirk handling adds a
significant amount of bloat to kernel we don't need. Solve this by
adding a CONFIG symbol for the ThunderX PCI devices and allowing it to
be turned off. Saving over 300k from the uncompressed vmlinux:

  -rwxr-xr-x 1 alex alex  85652472 Aug  3 16:48 vmlinux*
  -rwxr-xr-x 1 alex alex  86033880 Aug  3 16:39 vmlinux.orig*

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/Kconfig.platforms    | 2 ++
 arch/arm64/configs/defconfig    | 1 +
 drivers/pci/controller/Kconfig  | 7 +++++++
 drivers/pci/controller/Makefile | 4 ++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 8dd05b2a925c..a328eebdaa59 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -253,12 +253,14 @@ config ARCH_SPRD
 
 config ARCH_THUNDER
 	bool "Cavium Inc. Thunder SoC Family"
+        select PCI_THUNDER
 	help
 	  This enables support for Cavium's Thunder Family of SoCs.
 
 config ARCH_THUNDER2
 	bool "Cavium ThunderX2 Server Processors"
 	select GPIOLIB
+        select PCI_THUNDER
 	help
 	  This enables support for Cavium's ThunderX2 CN99XX family of
 	  server processors.
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 2ca7ba69c318..d840cba99941 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -199,6 +199,7 @@ CONFIG_PCI_HOST_GENERIC=y
 CONFIG_PCI_XGENE=y
 CONFIG_PCIE_ALTERA=y
 CONFIG_PCIE_ALTERA_MSI=y
+CONFIG_PCI_THUNDER=y
 CONFIG_PCI_HOST_THUNDER_PEM=y
 CONFIG_PCI_HOST_THUNDER_ECAM=y
 CONFIG_PCIE_ROCKCHIP_HOST=m
diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
index adddf21fa381..28335ffa5d48 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -286,6 +286,13 @@ config PCI_LOONGSON
 	  Say Y here if you want to enable PCI controller support on
 	  Loongson systems.
 
+config PCI_THUNDER
+       bool "Thunder X PCIE controllers"
+       depends on ARM64
+       select PCI_QUIRKS
+       help
+          Say Y here to enable ThunderX ECAM and PEM PCI controllers.
+
 source "drivers/pci/controller/dwc/Kconfig"
 source "drivers/pci/controller/mobiveil/Kconfig"
 source "drivers/pci/controller/cadence/Kconfig"
diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makefile
index efd9733ead26..8fad4781a5d3 100644
--- a/drivers/pci/controller/Makefile
+++ b/drivers/pci/controller/Makefile
@@ -45,8 +45,8 @@ obj-y				+= mobiveil/
 # ARM64 and use internal ifdefs to only build the pieces we need
 # depending on whether ACPI, the DT driver, or both are enabled.
 
+obj-$(CONFIG_PCI_THUNDER) += pci-thunder-ecam.o
+obj-$(CONFIG_PCI_THUNDER) += pci-thunder-pem.o
 ifdef CONFIG_PCI
-obj-$(CONFIG_ARM64) += pci-thunder-ecam.o
-obj-$(CONFIG_ARM64) += pci-thunder-pem.o
 obj-$(CONFIG_ARM64) += pci-xgene.o
 endif
-- 
2.20.1

