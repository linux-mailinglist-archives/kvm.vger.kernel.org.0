Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7CC199621
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbgCaMRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730380AbgCaMRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:17:12 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C3EE20848;
        Tue, 31 Mar 2020 12:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657031;
        bh=twI+FrhMAk/LCQP/xGXohCa10/7aYbpXUmUJDbB9Bfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxikxnfTRAqv+N2cVrFMz8nFFqVt3OJ9YQzX7PsXES/4hGfMO3W+PIy8Oy5XFJt4g
         egm7KJeN87t8yYeRuNHX01MHHrtW/u8yLVBZwV7XEA/OKMbTMH+uICHASL1BEWTveN
         Pw7fMeTJ3brGnwQwj/g7r4kmWj5VNsh53mLHCbvU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpN-00HBlI-Jc; Tue, 31 Mar 2020 13:17:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 02/15] arm: Unplug KVM from the build system
Date:   Tue, 31 Mar 2020 13:16:32 +0100
Message-Id: <20200331121645.388250-3-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de, linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

