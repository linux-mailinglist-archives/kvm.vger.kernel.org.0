Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC2A190B0C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgCXKeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbgCXKeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:34:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94B9F20870;
        Tue, 24 Mar 2020 10:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585046041;
        bh=twI+FrhMAk/LCQP/xGXohCa10/7aYbpXUmUJDbB9Bfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zt9FY9xddS08bQoH+uIDFiRKNTrG15fNN/iWBNJA1jSMAbh9TlygGM/8ScZZiRpyf
         xBusuhmGDlKbUKnBFehqhxlHo8H+Ri2XM31+SGLOTdqBJtCa+6bsOETHBF/mt1FEg0
         QqanZY8CBPn2iAEA3iqJE65jwMeDqW3Yvm3HBAMY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGgsh-00FE8V-IV; Tue, 24 Mar 2020 10:34:00 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stefan Agner <stefan@agner.ch>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Takashi Yoshi <takashi@yoshi.email>,
        Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH v2 1/7] arm: Unplug KVM from the build system
Date:   Tue, 24 Mar 2020 10:33:44 +0000
Message-Id: <20200324103350.138077-2-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200324103350.138077-1-maz@kernel.org>
References: <20200324103350.138077-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, olof@lixom.net, arnd@arndb.de, will@kernel.org, vladimir.murzin@arm.com, catalin.marinas@arm.com, linus.walleij@linaro.org, christoffer.dall@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, pbonzini@redhat.com, qperret@google.com, linux@arm.linux.org.uk, stefan@agner.ch, jan.kiszka@siemens.com, krzk@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, takashi@yoshi.email, daniel@makrotopia.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're about to drop KVM/arm on the floor, carefully unplug
it from the build system.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Olof Johansson <olof@lixom.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/Kconfig             | 2 --
 arch/arm/Makefile            | 1 -
 arch/arm/mach-exynos/Kconfig | 2 +-
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 97864aabc2a6..a07bec7f4d8d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2091,5 +2091,3 @@ source "drivers/firmware/Kconfig"
 if CRYPTO
 source "arch/arm/crypto/Kconfig"
 endif
-
-source "arch/arm/kvm/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index db857d07114f..b4ce96f55ddd 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -278,7 +278,6 @@ core-$(CONFIG_FPE_NWFPE)	+= arch/arm/nwfpe/
 core-$(CONFIG_FPE_FASTFPE)	+= $(patsubst $(srctree)/%,%,$(wildcard $(srctree)/arch/arm/fastfpe/))
 core-$(CONFIG_VFP)		+= arch/arm/vfp/
 core-$(CONFIG_XEN)		+= arch/arm/xen/
-core-$(CONFIG_KVM_ARM_HOST) 	+= arch/arm/kvm/
 core-$(CONFIG_VDSO)		+= arch/arm/vdso/
 
 # If we have a machine-specific directory, then include it in the build.
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index cbbe03e96de8..76838255b5fa 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -21,7 +21,7 @@ menuconfig ARCH_EXYNOS
 	select EXYNOS_SROM
 	select EXYNOS_PM_DOMAINS if PM_GENERIC_DOMAINS
 	select GPIOLIB
-	select HAVE_ARM_ARCH_TIMER if ARCH_EXYNOS5 && VIRTUALIZATION
+	select HAVE_ARM_ARCH_TIMER if ARCH_EXYNOS5
 	select HAVE_ARM_SCU if SMP
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
-- 
2.25.0

