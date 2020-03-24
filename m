Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2667190B18
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCXKeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgCXKeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:34:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB070208DB;
        Tue, 24 Mar 2020 10:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585046046;
        bh=ugisv1NLx5lkMOol7N8eoN+aF+PTHkSjV2ZOtSqDBPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRZUbqteoP532RqH4dQiOTOjIHD1pH7VhxO4KImWEafN3bMTlkYSu4r6KBLuoZv2E
         vgVVL/sfTgX0qbAPJmiI3zrHBukurUy9hjerEqN2gbWx3xprJY/s7p/9NGp7BH4C91
         1YAimnfvwqZ3AQAS69Y+9ohzcaIC75AXdte75a0Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGgsm-00FE8V-2l; Tue, 24 Mar 2020 10:34:04 +0000
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
Subject: [PATCH v2 5/7] arm: Remove GICv3 vgic compatibility macros
Date:   Tue, 24 Mar 2020 10:33:48 +0000
Message-Id: <20200324103350.138077-6-maz@kernel.org>
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

We used to use a set of macros to provide support of vgic-v3 to 32bit
without duplicating everything. We don't need it anymore, so drop it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Olof Johansson <olof@lixom.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h | 114 ------------------------------
 1 file changed, 114 deletions(-)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index c815477b4303..413abfb42989 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -38,71 +38,6 @@
 #define ICC_AP1R2			__ICC_AP1Rx(2)
 #define ICC_AP1R3			__ICC_AP1Rx(3)
 
-#define ICC_HSRE			__ACCESS_CP15(c12, 4, c9, 5)
-
-#define ICH_VSEIR			__ACCESS_CP15(c12, 4, c9, 4)
-#define ICH_HCR				__ACCESS_CP15(c12, 4, c11, 0)
-#define ICH_VTR				__ACCESS_CP15(c12, 4, c11, 1)
-#define ICH_MISR			__ACCESS_CP15(c12, 4, c11, 2)
-#define ICH_EISR			__ACCESS_CP15(c12, 4, c11, 3)
-#define ICH_ELRSR			__ACCESS_CP15(c12, 4, c11, 5)
-#define ICH_VMCR			__ACCESS_CP15(c12, 4, c11, 7)
-
-#define __LR0(x)			__ACCESS_CP15(c12, 4, c12, x)
-#define __LR8(x)			__ACCESS_CP15(c12, 4, c13, x)
-
-#define ICH_LR0				__LR0(0)
-#define ICH_LR1				__LR0(1)
-#define ICH_LR2				__LR0(2)
-#define ICH_LR3				__LR0(3)
-#define ICH_LR4				__LR0(4)
-#define ICH_LR5				__LR0(5)
-#define ICH_LR6				__LR0(6)
-#define ICH_LR7				__LR0(7)
-#define ICH_LR8				__LR8(0)
-#define ICH_LR9				__LR8(1)
-#define ICH_LR10			__LR8(2)
-#define ICH_LR11			__LR8(3)
-#define ICH_LR12			__LR8(4)
-#define ICH_LR13			__LR8(5)
-#define ICH_LR14			__LR8(6)
-#define ICH_LR15			__LR8(7)
-
-/* LR top half */
-#define __LRC0(x)			__ACCESS_CP15(c12, 4, c14, x)
-#define __LRC8(x)			__ACCESS_CP15(c12, 4, c15, x)
-
-#define ICH_LRC0			__LRC0(0)
-#define ICH_LRC1			__LRC0(1)
-#define ICH_LRC2			__LRC0(2)
-#define ICH_LRC3			__LRC0(3)
-#define ICH_LRC4			__LRC0(4)
-#define ICH_LRC5			__LRC0(5)
-#define ICH_LRC6			__LRC0(6)
-#define ICH_LRC7			__LRC0(7)
-#define ICH_LRC8			__LRC8(0)
-#define ICH_LRC9			__LRC8(1)
-#define ICH_LRC10			__LRC8(2)
-#define ICH_LRC11			__LRC8(3)
-#define ICH_LRC12			__LRC8(4)
-#define ICH_LRC13			__LRC8(5)
-#define ICH_LRC14			__LRC8(6)
-#define ICH_LRC15			__LRC8(7)
-
-#define __ICH_AP0Rx(x)			__ACCESS_CP15(c12, 4, c8, x)
-#define ICH_AP0R0			__ICH_AP0Rx(0)
-#define ICH_AP0R1			__ICH_AP0Rx(1)
-#define ICH_AP0R2			__ICH_AP0Rx(2)
-#define ICH_AP0R3			__ICH_AP0Rx(3)
-
-#define __ICH_AP1Rx(x)			__ACCESS_CP15(c12, 4, c9, x)
-#define ICH_AP1R0			__ICH_AP1Rx(0)
-#define ICH_AP1R1			__ICH_AP1Rx(1)
-#define ICH_AP1R2			__ICH_AP1Rx(2)
-#define ICH_AP1R3			__ICH_AP1Rx(3)
-
-/* A32-to-A64 mappings used by VGIC save/restore */
-
 #define CPUIF_MAP(a32, a64)			\
 static inline void write_ ## a64(u32 val)	\
 {						\
@@ -113,21 +48,6 @@ static inline u32 read_ ## a64(void)		\
 	return read_sysreg(a32); 		\
 }						\
 
-#define CPUIF_MAP_LO_HI(a32lo, a32hi, a64)	\
-static inline void write_ ## a64(u64 val)	\
-{						\
-	write_sysreg(lower_32_bits(val), a32lo);\
-	write_sysreg(upper_32_bits(val), a32hi);\
-}						\
-static inline u64 read_ ## a64(void)		\
-{						\
-	u64 val = read_sysreg(a32lo);		\
-						\
-	val |=	(u64)read_sysreg(a32hi) << 32;	\
-						\
-	return val; 				\
-}
-
 CPUIF_MAP(ICC_PMR, ICC_PMR_EL1)
 CPUIF_MAP(ICC_AP0R0, ICC_AP0R0_EL1)
 CPUIF_MAP(ICC_AP0R1, ICC_AP0R1_EL1)
@@ -138,40 +58,6 @@ CPUIF_MAP(ICC_AP1R1, ICC_AP1R1_EL1)
 CPUIF_MAP(ICC_AP1R2, ICC_AP1R2_EL1)
 CPUIF_MAP(ICC_AP1R3, ICC_AP1R3_EL1)
 
-CPUIF_MAP(ICH_HCR, ICH_HCR_EL2)
-CPUIF_MAP(ICH_VTR, ICH_VTR_EL2)
-CPUIF_MAP(ICH_MISR, ICH_MISR_EL2)
-CPUIF_MAP(ICH_EISR, ICH_EISR_EL2)
-CPUIF_MAP(ICH_ELRSR, ICH_ELRSR_EL2)
-CPUIF_MAP(ICH_VMCR, ICH_VMCR_EL2)
-CPUIF_MAP(ICH_AP0R3, ICH_AP0R3_EL2)
-CPUIF_MAP(ICH_AP0R2, ICH_AP0R2_EL2)
-CPUIF_MAP(ICH_AP0R1, ICH_AP0R1_EL2)
-CPUIF_MAP(ICH_AP0R0, ICH_AP0R0_EL2)
-CPUIF_MAP(ICH_AP1R3, ICH_AP1R3_EL2)
-CPUIF_MAP(ICH_AP1R2, ICH_AP1R2_EL2)
-CPUIF_MAP(ICH_AP1R1, ICH_AP1R1_EL2)
-CPUIF_MAP(ICH_AP1R0, ICH_AP1R0_EL2)
-CPUIF_MAP(ICC_HSRE, ICC_SRE_EL2)
-CPUIF_MAP(ICC_SRE, ICC_SRE_EL1)
-
-CPUIF_MAP_LO_HI(ICH_LR15, ICH_LRC15, ICH_LR15_EL2)
-CPUIF_MAP_LO_HI(ICH_LR14, ICH_LRC14, ICH_LR14_EL2)
-CPUIF_MAP_LO_HI(ICH_LR13, ICH_LRC13, ICH_LR13_EL2)
-CPUIF_MAP_LO_HI(ICH_LR12, ICH_LRC12, ICH_LR12_EL2)
-CPUIF_MAP_LO_HI(ICH_LR11, ICH_LRC11, ICH_LR11_EL2)
-CPUIF_MAP_LO_HI(ICH_LR10, ICH_LRC10, ICH_LR10_EL2)
-CPUIF_MAP_LO_HI(ICH_LR9, ICH_LRC9, ICH_LR9_EL2)
-CPUIF_MAP_LO_HI(ICH_LR8, ICH_LRC8, ICH_LR8_EL2)
-CPUIF_MAP_LO_HI(ICH_LR7, ICH_LRC7, ICH_LR7_EL2)
-CPUIF_MAP_LO_HI(ICH_LR6, ICH_LRC6, ICH_LR6_EL2)
-CPUIF_MAP_LO_HI(ICH_LR5, ICH_LRC5, ICH_LR5_EL2)
-CPUIF_MAP_LO_HI(ICH_LR4, ICH_LRC4, ICH_LR4_EL2)
-CPUIF_MAP_LO_HI(ICH_LR3, ICH_LRC3, ICH_LR3_EL2)
-CPUIF_MAP_LO_HI(ICH_LR2, ICH_LRC2, ICH_LR2_EL2)
-CPUIF_MAP_LO_HI(ICH_LR1, ICH_LRC1, ICH_LR1_EL2)
-CPUIF_MAP_LO_HI(ICH_LR0, ICH_LRC0, ICH_LR0_EL2)
-
 #define read_gicreg(r)                 read_##r()
 #define write_gicreg(v, r)             write_##r(v)
 
-- 
2.25.0

