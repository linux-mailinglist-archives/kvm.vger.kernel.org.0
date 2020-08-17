Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F2E245B34
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHQDsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgHQDsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:48:38 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B4AC061388;
        Sun, 16 Aug 2020 20:48:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 1B33B1FEFE;
        Mon, 17 Aug 2020 03:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636117; bh=PFWiObevUs0vhYw4Mg5ewb9+RYTJ10CHEuPDj8cUb9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xj7xpPzDm8qy25IFVABsByjJvvvFmneQRtrtAKsHX35ONBcOxwSQ0TxcLH0fgmpWS
         DrvfeB0G1ZhMBYEUIMqSh+/1ecjudXLyzx6J4a+KAUqoITD0xOYHKWtNyHEY3u0yk7
         M89THOB3ubkXkkEAB7zVL6brMFTSl+2oy3cHqEVIB3d3LeGt9RQqLln0H8GsIauHFl
         YHMFTz+NUxLiMorUDY1LyHdRJt7NBPZNZ4747sRhpEeG6titAtmLvuukTH+kPKYtTE
         Akn1qCAHOI4H8TvVYh8xj3RBERDsMFzj8Ta4cOmdv54DpUUs/Lk+Az2CZoow4cj134
         j8+jj/kJkqRZg==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Steven Price <steven.price@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 3/7] MIPS: Kconfig: Always select SYNC_R4K if both SMP and r4k timer is enabled
Date:   Mon, 17 Aug 2020 11:46:42 +0800
Message-Id: <20200817034701.3515721-4-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now all platforms are sharing sync-r4k procdure, there is no need to let
platform to select it.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/Kconfig | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 880680c0df31..7674f4379d39 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -234,7 +234,6 @@ config BMIPS_GENERIC
 	select USE_OF
 	select CEVT_R4K
 	select CSRC_R4K
-	select SYNC_R4K
 	select COMMON_CLK
 	select BCM6345_L1_IRQ
 	select BCM7038_L1_IRQ
@@ -291,7 +290,6 @@ config BCM63XX
 	select BOOT_RAW
 	select CEVT_R4K
 	select CSRC_R4K
-	select SYNC_R4K
 	select DMA_NONCOHERENT
 	select IRQ_MIPS_CPU
 	select SYS_SUPPORTS_32BIT_KERNEL
@@ -726,7 +724,6 @@ config SGI_IP30
 	select BOOT_ELF64
 	select CEVT_R4K
 	select CSRC_R4K
-	select SYNC_R4K if SMP
 	select ZONE_DMA32
 	select HAVE_PCI
 	select IRQ_MIPS_CPU
@@ -979,7 +976,6 @@ config NLM_XLR_BOARD
 	select CSRC_R4K
 	select IRQ_MIPS_CPU
 	select ZONE_DMA32 if 64BIT
-	select SYNC_R4K
 	select SYS_HAS_EARLY_PRINTK
 	select SYS_SUPPORTS_ZBOOT
 	select SYS_SUPPORTS_ZBOOT_UART16550
@@ -1006,7 +1002,6 @@ config NLM_XLP_BOARD
 	select CSRC_R4K
 	select IRQ_MIPS_CPU
 	select ZONE_DMA32 if 64BIT
-	select SYNC_R4K
 	select SYS_HAS_EARLY_PRINTK
 	select USE_OF
 	select SYS_SUPPORTS_ZBOOT
@@ -1076,6 +1071,7 @@ config CEVT_GT641XX
 	bool
 
 config CEVT_R4K
+	select SYNC_R4K if SMP
 	bool
 
 config CEVT_SB1250
@@ -1091,6 +1087,7 @@ config CSRC_IOASIC
 	bool
 
 config CSRC_R4K
+	select SYNC_R4K if SMP
 	select CLOCKSOURCE_WATCHDOG if CPU_FREQ
 	bool
 
@@ -2361,7 +2358,6 @@ config MIPS_MT_SMP
 	depends on SYS_SUPPORTS_MULTITHREADING && !CPU_MIPSR6 && !CPU_MICROMIPS
 	select CPU_MIPSR2_IRQ_VI
 	select CPU_MIPSR2_IRQ_EI
-	select SYNC_R4K
 	select MIPS_MT
 	select SMP
 	select SMP_UP
@@ -2465,7 +2461,6 @@ config MIPS_CMP
 	bool "MIPS CMP framework support (DEPRECATED)"
 	depends on SYS_SUPPORTS_MIPS_CMP && !CPU_MIPSR6
 	select SMP
-	select SYNC_R4K
 	select SYS_SUPPORTS_SMP
 	select WEAK_ORDERING
 	default n
@@ -2483,7 +2478,6 @@ config MIPS_CPS
 	select MIPS_CM
 	select MIPS_CPS_PM if HOTPLUG_CPU
 	select SMP
-	select SYNC_R4K if (CEVT_R4K || CSRC_R4K)
 	select SYS_SUPPORTS_HOTPLUG_CPU
 	select SYS_SUPPORTS_SCHED_SMT if CPU_MIPSR6
 	select SYS_SUPPORTS_SMP
-- 
2.28.0.rc1

