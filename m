Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE374309BE8
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 13:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhAaL7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 06:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbhAaLxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:53:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B168BC0617A7
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:05 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o5so601505wmq.2
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7kgwIK0JyvDkmF9iFWkCY48/6oYK9JNsR3MYb3v4QG8=;
        b=n9AyWszsjAaoRnFwXuUuw7rPY7wzSZ+hzO0UZXdKnF4wDfUQB4I9DojR0AhRbjsTLK
         RErB2otDkUoKNEiWYP7Yrt2aw15d+dA9Y+3SPIUOmfZEwJvOXmWuZDbs9Uev0LzyKGeJ
         yDVt/DifjreigZ5eStSOamXH4eV9/eir1F4f2l6Fn9Nlx5Z843nIFbYQOvaXPCTWSr/m
         ImY/2H/l+FJF6NVSjLklW8AsZtX3R2VsCSVDWXo9WA0Q9unws98XkDEzUeay/3mKFLGR
         S3ffbtd2B9J1qthp8co9d2yLBB0wOHCn1rfSTDfa7bbKiVPnqcucletQRJHJusUlHlUL
         EDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=7kgwIK0JyvDkmF9iFWkCY48/6oYK9JNsR3MYb3v4QG8=;
        b=ltzs2iys3McdDZ8RTJnkgu65PVrH5hC6znF34CDsIz47FYDQd41xtbkFzIbqKA7blV
         zSGGmOdge9ELBsO7aTnfNeXJp3KA3qtaxKU0dpH92ZnFWeTWKK7cKZ/lxJ+YjNsw+QMO
         eklHVwVRJq/LAI1KX39654rMkoRPbKCUM+qvjEPSFAVETHeR7JqwlW2PdBtv02x3L5AK
         yvC6T51/4HfLPvBIsCnIrta+fdf6qEO9bnrkt5+S/CfGHKd8hudxJZ6rh+GNLWTV5KS8
         YMxBJeUQ3brMP9eXVA6UyzDjQ52t6niOH6cFwrnDilCPsXkPvlJ/Fxm32v+/liepdcUY
         a13w==
X-Gm-Message-State: AOAM530o50SS9//d1AouCcjnDG40FIMBWuONAouBdwlVvEz3qvZEmycC
        ISHu/XdhZgZt+cr6vt/MTGE=
X-Google-Smtp-Source: ABdhPJz3tlrMcRRpjd4PUI1yHaP/ipcEQ3/LURnJ6uV5ubC8GeKt0km9ort6jH4+M4qdcEM7EgRM5g==
X-Received: by 2002:a05:600c:4f07:: with SMTP id l7mr5555519wmq.111.1612093864376;
        Sun, 31 Jan 2021 03:51:04 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id b3sm19907224wme.32.2021.01.31.03.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:51:03 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 07/11] target/arm: Restrict ARMv7 M-profile cpus to TCG accel
Date:   Sun, 31 Jan 2021 12:50:18 +0100
Message-Id: <20210131115022.242570-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires the target cpu to be at least ARMv8 architecture
(support on ARMv7 has been dropped in commit 82bf7ae84ce:
"target/arm: Remove KVM support for 32-bit Arm hosts").

Beside, KVM only supports A-profile, thus won't be able to run
M-profile cpus.

Only enable the following ARMv7 M-Profile CPUs when TCG is available:

  - Cortex-M0
  - Cortex-M3
  - Cortex-M4
  - Cortex-M33

The following machines are no more built when TCG is disabled:

  - emcraft-sf2          SmartFusion2 SOM kit from Emcraft (M2S010)
  - highbank             Calxeda Highbank (ECX-1000)
  - lm3s6965evb          Stellaris LM3S6965EVB (Cortex-M3)
  - lm3s811evb           Stellaris LM3S811EVB (Cortex-M3)
  - midway               Calxeda Midway (ECX-2000)
  - mps2-an385           ARM MPS2 with AN385 FPGA image for Cortex-M3
  - mps2-an386           ARM MPS2 with AN386 FPGA image for Cortex-M4
  - mps2-an500           ARM MPS2 with AN500 FPGA image for Cortex-M7
  - mps2-an505           ARM MPS2 with AN505 FPGA image for Cortex-M33
  - mps2-an511           ARM MPS2 with AN511 DesignStart FPGA image for Cortex-M3
  - mps2-an521           ARM MPS2 with AN521 FPGA image for dual Cortex-M33
  - musca-a              ARM Musca-A board (dual Cortex-M33)
  - musca-b1             ARM Musca-B1 board (dual Cortex-M33)
  - netduino2            Netduino 2 Machine (Cortex-M3)
  - netduinoplus2        Netduino Plus 2 Machine(Cortex-M4)

We don't need to enforce CONFIG_ARM_V7M in default-configs anymore.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 11 -----------
 hw/arm/Kconfig                          |  7 +++++++
 target/arm/Kconfig                      |  1 +
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index 175530595ce..0fc80d7d6df 100644
--- a/default-configs/devices/arm-softmmu.mak
+++ b/default-configs/devices/arm-softmmu.mak
@@ -1,28 +1,17 @@
 # Default configuration for arm-softmmu
 
-# TODO: ARM_V7M is currently always required - make this more flexible!
-CONFIG_ARM_V7M=y
-
 # CONFIG_PCI_DEVICES=n
 # CONFIG_TEST_DEVICES=n
 
 CONFIG_ARM_VIRT=y
 CONFIG_CUBIEBOARD=y
 CONFIG_EXYNOS4=y
-CONFIG_HIGHBANK=y
-CONFIG_MUSCA=y
-CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
 CONFIG_VEXPRESS=y
 CONFIG_ZYNQ=y
 CONFIG_NPCM7XX=y
-CONFIG_NETDUINO2=y
-CONFIG_NETDUINOPLUS2=y
-CONFIG_MPS2=y
 CONFIG_RASPI=y
 CONFIG_SABRELITE=y
-CONFIG_EMCRAFT_SF2=y
-CONFIG_MICROBIT=y
 CONFIG_FSL_IMX7=y
 CONFIG_FSL_IMX6UL=y
 CONFIG_ALLWINNER_H3=y
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 4baf1f97694..62f8b0d24e7 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -60,6 +60,7 @@ config EXYNOS4
 
 config HIGHBANK
     bool
+    default y if TCG && ARM
     select A9MPCORE
     select A15MPCORE
     select AHCI
@@ -95,6 +96,7 @@ config MAINSTONE
 
 config MUSCA
     bool
+    default y if TCG && ARM
     select ARMSSE
     select PL011
     select PL031
@@ -115,10 +117,12 @@ config MUSICPAL
 
 config NETDUINO2
     bool
+    default y if TCG && ARM
     select STM32F205_SOC
 
 config NETDUINOPLUS2
     bool
+    default y if TCG && ARM
     select STM32F405_SOC
 
 config NSERIES
@@ -240,6 +244,7 @@ config SABRELITE
 
 config STELLARIS
     bool
+    default y if TCG && ARM
     select ARM_V7M
     select CMSDK_APB_WATCHDOG
     select I2C
@@ -443,6 +448,7 @@ config ASPEED_SOC
 
 config MPS2
     bool
+    default y if TCG && ARM
     select ARMSSE
     select LAN9118
     select MPS2_FPGAIO
@@ -496,6 +502,7 @@ config NRF51_SOC
 
 config EMCRAFT_SF2
     bool
+    default y if TCG && ARM
     select MSF2
     select SSI_M25P80
 
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index 4dc96c46520..07a2fad7a2b 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -24,4 +24,5 @@ config ARM_V7R
 
 config ARM_V7M
     bool
+    depends on TCG && ARM
     select PTIMER
-- 
2.26.2

