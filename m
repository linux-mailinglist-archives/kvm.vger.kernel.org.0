Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB2A30941D
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 11:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhA3KMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 05:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhA3Byd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 20:54:33 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B679CC061573
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:07 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m13so10618265wro.12
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 17:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pL3VFUfes4LLPpgaJDy8jU3gYau+sjFrKic4/sFvnNY=;
        b=QlPx5vk/bo8ydtxxW9jNTxI4BE08Ejo8IlC/WMnhi4Wbme1fYmhJgyU1Upki/92NmF
         WC2DbHcdeOoGbbqkX3uzvTl8MPRzbcKjiR9DkW3t+gelrCpi6lbR+YljJPOX4B/pNnJR
         jLROfdsvWr2JLoQ3ukaZTPfmPpHIQ2tX5RT3QafM9bvIGcGYCZ4JbSGyIOolFM9zj2wp
         8Lk2wKKiOifSwg1YsFs8CXFAh+ZPmwh7tkYJaYlPsNhSagHtmcD7TetDYtI5mpUQKEuJ
         UxtEsewFWr9ZiT2uXhIw/Szt607GBXaZ6aLcK0stqf2PdjzbROXSDKfZ0OHCM4ASM64Z
         ZiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=pL3VFUfes4LLPpgaJDy8jU3gYau+sjFrKic4/sFvnNY=;
        b=LvjCMycpsE6PFOR/qhH+P3v+/IqyPo4O3e6QRErPsCmXo4cWejyvOifk/zPWHs/77A
         D9Dw2LUbdeN0Um4W2hWXuDaHbRSBrx1LcMyy18dy9Zg6mS4kEaDkFPrt7xuZYrma3zIK
         ZNf80A997fomszWJ8MB1BmNufxm66qzJ2k4BfEZwiq0UT5uaWhglYBH4VQIqySF1Eybh
         cGkt/aGw4g430/UbdXM5J/coH+Le75AXt56Im9DDj4iKTyv9qb14u83A/mP854KCAaGf
         JkPHAk6k34eIWWaXBWI6WKiSkbshyJucNSoxfzqQ79Hjqw3lY+rZeJ/tpsMoCta9Z53m
         NnXQ==
X-Gm-Message-State: AOAM531OAdkF+GmZpa8m7qazvpDmfdtcrs06FY7dJT0snY/w4rMX4GNm
        omnV9W/mX3urzHFmZZIltoU=
X-Google-Smtp-Source: ABdhPJwbM5w0TDBpvxYm44nUc4AYAH45EnulcrjfYKeG5PWB96HJ5mDacgEs5qWvrmDx0pRxmhlO2w==
X-Received: by 2002:adf:a31d:: with SMTP id c29mr7307582wrb.306.1611971586564;
        Fri, 29 Jan 2021 17:53:06 -0800 (PST)
Received: from localhost.localdomain (13.red-83-57-169.dynamicip.rima-tde.net. [83.57.169.13])
        by smtp.gmail.com with ESMTPSA id f13sm8277528wmf.1.2021.01.29.17.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 17:53:05 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Claudio Fontana <cfontana@suse.de>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v5 07/11] target/arm: Restrict ARMv7 M-profile cpus to TCG accel
Date:   Sat, 30 Jan 2021 02:52:23 +0100
Message-Id: <20210130015227.4071332-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130015227.4071332-1-f4bug@amsat.org>
References: <20210130015227.4071332-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A KVM-only build won't be able to run M-profile cpus.

Only enable the following ARMv7 M-Profile CPUs when TCG is available:

  - Cortex-M0
  - Cortex-M3
  - Cortex-M4
  - Cortex-M33

The following machines are no more built when TCG is disabled:

  - emcraft-sf2          SmartFusion2 SOM kit from Emcraft (M2S010)
  - highbank             Calxeda Highbank (ECX-1000)
  - lm3s6965evb          Stellaris LM3S6965EVB
  - lm3s811evb           Stellaris LM3S811EVB
  - midway               Calxeda Midway (ECX-2000)
  - mps2-an385           ARM MPS2 with AN385 FPGA image for Cortex-M3
  - mps2-an386           ARM MPS2 with AN386 FPGA image for Cortex-M4
  - mps2-an500           ARM MPS2 with AN500 FPGA image for Cortex-M7
  - mps2-an505           ARM MPS2 with AN505 FPGA image for Cortex-M33
  - mps2-an511           ARM MPS2 with AN511 DesignStart FPGA image for Cortex-M3
  - mps2-an521           ARM MPS2 with AN521 FPGA image for dual Cortex-M33
  - musca-a              ARM Musca-A board (dual Cortex-M33)
  - musca-b1             ARM Musca-B1 board (dual Cortex-M33)
  - netduino2            Netduino 2 Machine
  - netduinoplus2        Netduino Plus 2 Machine

We don't need to enforce CONFIG_ARM_V7M in default-configs anymore.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 11 -----------
 hw/arm/Kconfig                          | 17 +++++++++++++----
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index ee80bf15150..b72926b8fce 100644
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
 CONFIG_ARM_COMPATIBLE_SEMIHOSTING=y
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 320428bf97e..f56c05c00a8 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -16,6 +16,12 @@ config ARM_V7R
     depends on TCG
     select ARM_COMPATIBLE_SEMIHOSTING
 
+config ARM_V7M
+    bool
+    depends on TCG
+    select ARM_COMPATIBLE_SEMIHOSTING
+    select PTIMER
+
 config ARM_VIRT
     bool
     imply PCI_DEVICES
@@ -78,6 +84,7 @@ config EXYNOS4
 
 config HIGHBANK
     bool
+    default y if TCG
     select A9MPCORE
     select A15MPCORE
     select AHCI
@@ -113,6 +120,7 @@ config MAINSTONE
 
 config MUSCA
     bool
+    default y if TCG
     select ARMSSE
     select PL011
     select PL031
@@ -133,10 +141,12 @@ config MUSICPAL
 
 config NETDUINO2
     bool
+    default y if TCG
     select STM32F205_SOC
 
 config NETDUINOPLUS2
     bool
+    default y if TCG
     select STM32F405_SOC
 
 config NSERIES
@@ -258,6 +268,7 @@ config SABRELITE
 
 config STELLARIS
     bool
+    default y if TCG
     select ARM_V7M
     select CMSDK_APB_WATCHDOG
     select I2C
@@ -331,10 +342,6 @@ config ZYNQ
     select XILINX_SPIPS
     select ZYNQ_DEVCFG
 
-config ARM_V7M
-    bool
-    select PTIMER
-
 config ALLWINNER_A10
     bool
     select AHCI
@@ -463,6 +470,7 @@ config ASPEED_SOC
 
 config MPS2
     bool
+    default y if TCG
     select ARMSSE
     select LAN9118
     select MPS2_FPGAIO
@@ -516,6 +524,7 @@ config NRF51_SOC
 
 config EMCRAFT_SF2
     bool
+    default y if TCG
     select MSF2
     select SSI_M25P80
 
-- 
2.26.2

