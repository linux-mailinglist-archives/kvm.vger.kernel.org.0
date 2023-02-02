Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5636688763
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjBBTNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjBBTNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:13:23 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEEC279B9
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 11:13:19 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h16so2617034wrz.12
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+5h3FkVGZK/7lAnqoj4IKq8jVgYNfiIxmZ5AdTxbqy4=;
        b=cc0S8bjZSFXWekcGl3QY+lPa/L7uBNVrSBX1z9QoJsg4Xc9ig6VxpFzPwI88NLtp7m
         /wnaYAa6SiJwFG22DIpal1NCpamIbyjNzGFUxjdbOj+GJy88Pgj5MUheWbCCOrMKyB2M
         7Rd1byT+jYfY42rQ9NHr5+rJYNoQt68WDk2UMFxd/NVk/BzYCUPEYoy2Zppd+mY99TMw
         9xb/xiX4VrtSKrm75izpnuyXdXkAF4NNmtZ/dGKP2HZTljTrdBKl9+lyLkUf+IjFQyvt
         esTLCj7UBeUv1ZqrAcxvwLWV0tAtrxZIlqfCamzFYaNCg6/SyZP+qFdtA4RXRo/qpSyQ
         DgmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+5h3FkVGZK/7lAnqoj4IKq8jVgYNfiIxmZ5AdTxbqy4=;
        b=YdYsDt5Zg+hFDEzutNMguTBYxR+KWEn8tuldWloz3OVp6S7/2AsphExa1X+fQUD8cC
         IaHvzaVUKcABTqLc9sn8TBn2LAOw98t8SS+yNzRMB9eKs3D5eLVz1Nv2dNt9PodOriYd
         fxyy78B/BGfw2aLmMDsxkCzI9Sj5DoLWMQgPNpF+3PG6U3o8fbYO8IC+2HcWwr9+jOPN
         YODWTbDKRC6NRSZEnooJSePZc8VL9GQi1J4BRR4otQjOjLw+PJnNYM0BnrNVUOI00xd5
         NhP+xwZwNSasS7FZo8j+v1mApOeShegegGaW66Mz0b7iFsBzIZ8/fNUyCEnhZm9lslvq
         1X7Q==
X-Gm-Message-State: AO0yUKU54mRthAbvkW8CfLA7pzk7ZbkDOhMQLOFCedh2D19moHMib+xV
        wXaossMO55qvib+x6qIuWFCR1vgKoaW+scxA
X-Google-Smtp-Source: AK7set+dDmzpveLA95ZhCN+Reb9G9Qs4HSmSluiqBaq9+/NG6aNJEGv3fL3TMNPkjG1Bzock6ZtxmQ==
X-Received: by 2002:a5d:6481:0:b0:2bf:e895:3839 with SMTP id o1-20020a5d6481000000b002bfe8953839mr8541082wri.39.1675365198364;
        Thu, 02 Feb 2023 11:13:18 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id z11-20020adfd0cb000000b002bfd09f2ca6sm252809wrh.3.2023.02.02.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 11:13:17 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH v3 kvmtool 1/1] riscv: Move serial and rtc from IO port space to MMIO area.
Date:   Thu,  2 Feb 2023 19:13:01 +0000
Message-Id: <20230202191301.588804-1-rkanwal@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The default serial and rtc IO region overlaps with PCI IO bar
region leading bar 0 activation to fail. Moving these devices
to MMIO region similar to ARM.

Given serial has been moved from 0x3f8 to 0x10000000, this
requires us to now pass earlycon=uart8250,mmio,0x10000000
from cmdline rather than earlycon=uart8250,mmio,0x3f8.

To avoid the need to change the address every time the tool
is updated, we can also just pass "earlycon" from cmdline
and guest then finds the type and base address by following
the Device Tree's stdout-path property.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
v3: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
    Incorporated feedback from Andre Przywara and Alexandru Elisei.
      Mainly updated the commit message to specify that we can simply pass
      just "earlycon" from cmdline and avoid the need to specify uart address.
    Also added Tested-by and Reviewed-by tags by Atish Patra.

v2: https://lore.kernel.org/all/20230201160137.486622-1-rkanwal@rivosinc.com/
    Added further details in the commit message regarding the
    UART address change required in kernel cmdline parameter.

v1: https://lore.kernel.org/all/20230124155251.1417682-1-rkanwal@rivosinc.com/

 hw/rtc.c                     |  3 +++
 hw/serial.c                  |  4 ++++
 riscv/include/kvm/kvm-arch.h | 10 ++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/hw/rtc.c b/hw/rtc.c
index 9b8785a..da696e1 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -9,6 +9,9 @@
 #if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 #define RTC_BUS_TYPE		DEVICE_BUS_MMIO
 #define RTC_BASE_ADDRESS	ARM_RTC_MMIO_BASE
+#elif defined(CONFIG_RISCV)
+#define RTC_BUS_TYPE		DEVICE_BUS_MMIO
+#define RTC_BASE_ADDRESS	RISCV_RTC_MMIO_BASE
 #else
 /* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
 #define RTC_BUS_TYPE		DEVICE_BUS_IOPORT
diff --git a/hw/serial.c b/hw/serial.c
index 3d53362..b6263a0 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -17,6 +17,10 @@
 #define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
 #define serial_irq(nr)		(32 + (nr))
 #define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
+#elif defined(CONFIG_RISCV)
+#define serial_iobase(nr)	(RISCV_UART_MMIO_BASE + (nr) * 0x1000)
+#define serial_irq(nr)		(1 + (nr))
+#define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
 #else
 #define serial_iobase_0		(KVM_IOPORT_AREA + 0x3f8)
 #define serial_iobase_1		(KVM_IOPORT_AREA + 0x2f8)
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 3f96d00..620c796 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -11,7 +11,7 @@
 #define RISCV_IOPORT		0x00000000ULL
 #define RISCV_IOPORT_SIZE	SZ_64K
 #define RISCV_IRQCHIP		0x08000000ULL
-#define RISCV_IRQCHIP_SIZE		SZ_128M
+#define RISCV_IRQCHIP_SIZE	SZ_128M
 #define RISCV_MMIO		0x10000000ULL
 #define RISCV_MMIO_SIZE		SZ_512M
 #define RISCV_PCI		0x30000000ULL
@@ -35,10 +35,16 @@
 #define RISCV_MAX_MEMORY(kvm)	RISCV_LOMAP_MAX_MEMORY
 #endif
 
+#define RISCV_UART_MMIO_BASE	RISCV_MMIO
+#define RISCV_UART_MMIO_SIZE	0x10000
+
+#define RISCV_RTC_MMIO_BASE	(RISCV_UART_MMIO_BASE + RISCV_UART_MMIO_SIZE)
+#define RISCV_RTC_MMIO_SIZE	0x10000
+
 #define KVM_IOPORT_AREA		RISCV_IOPORT
 #define KVM_PCI_CFG_AREA	RISCV_PCI
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
-#define KVM_VIRTIO_MMIO_AREA	RISCV_MMIO
+#define KVM_VIRTIO_MMIO_AREA	(RISCV_RTC_MMIO_BASE + RISCV_UART_MMIO_SIZE)
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
-- 
2.25.1

