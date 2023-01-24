Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4508679DFF
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 16:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjAXPxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 10:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjAXPw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 10:52:58 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397FD4957E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:52:57 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso11264240wmq.5
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYZNOer8XJPZvFVKYrNmJaUtsvc8OotdT9jt+nQK3S0=;
        b=lUCLQU3lURZFuNu2q0oiIgfROslxhSjmlcNJmu3eDQPNWozZ5jebd6RBmnsoFtQ4l2
         r5EThZTS06gfK7/sLR6OhXEWuQcle9Oum+U/eTeKTNaA10kbRAZ1QnaFCii+KTjK0upr
         tgxUbmn/K9P0gXJnpiCugb5VAJ/rkwLluIhdZxCfF1y6kfkNTgDfrL42FTjaDYD6uFg7
         qn/w6f+BPmtNFs7eRItQ09xaAOBL7XOLBog2iCkeQv2KvIwaWws/iyeM8CmHAtrGmSMC
         MvCox72Qdg0oR1hk7VL7A/xLsGAtQSuSvofh/UZkp6aSUQJF8R2qMvm2+YH3WebD0T9l
         LSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYZNOer8XJPZvFVKYrNmJaUtsvc8OotdT9jt+nQK3S0=;
        b=Oe+r4xN03+EULk3WedptNYH6OigAWyoTwBO3Lbu1VlU/VbO6buXmvMinpCY5zDlvbd
         mwFFXBLzw5YoaFJwK1UpqE/VsMpdw/IjxgSO+vH/caIV3D+rrHp58tvkSXfVYA4XccaR
         cGo4Ip8TksqvgwcklyKrN47ct9CsDmpJJMRg9XwpksnyDQmZZNTNWLzqKOGSJz6/CQaI
         be+xFEQSwt0V9aqbgauswWU1T+D2embghxZPOXwPpAHUQamFSLlPJfhtifq9mYz4U1FG
         Gct3o+2EN01sMAklhyBj6ELQnLLwxYSfie8+6eA+NTfTg3s9XRwv8kz0FmDjXAdhsTX5
         emew==
X-Gm-Message-State: AFqh2kqkp/L4wERklmy5Q21y6shHF12uwBt1Ouwz4halvfrsajK406Tz
        ArmmdKLDo1AWq/7o3kTtrikm2g==
X-Google-Smtp-Source: AMrXdXsqIGZzmFNEQ/236Bwy4cXZmvFQ82xYncgxTV9VwP2mYfHmXK5lwlyV+75lxP7/PG6Q404K8Q==
X-Received: by 2002:a05:600c:35ce:b0:3db:1caf:1020 with SMTP id r14-20020a05600c35ce00b003db1caf1020mr21760190wmq.35.1674575575762;
        Tue, 24 Jan 2023 07:52:55 -0800 (PST)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c26d500b003d9b87296a9sm12992381wmv.25.2023.01.24.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:52:55 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     apatel@ventanamicro.com, atishp@rivosinc.com,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Subject: [PATCH kvmtool 1/1] riscv: Move serial and rtc from IO port space to MMIO area.
Date:   Tue, 24 Jan 2023 15:52:51 +0000
Message-Id: <20230124155251.1417682-1-rkanwal@rivosinc.com>
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

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
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
index 3d53362..46280d3 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -17,6 +17,10 @@
 #define serial_iobase(nr)	(ARM_UART_MMIO_BASE + (nr) * 0x1000)
 #define serial_irq(nr)		(32 + (nr))
 #define SERIAL8250_BUS_TYPE	DEVICE_BUS_MMIO
+#elif defined(CONFIG_RISCV)
+#define serial_iobase(nr)	(RISCV_UART_MMIO_BASE + (nr) * 0x1000)
+#define serial_irq(nr)		(1 + nr)
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

