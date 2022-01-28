Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DEB49F9FF
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348701AbiA1Mur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiA1Muq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:50:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4F5C06174E
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE051B8258F
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEE6C340E0;
        Fri, 28 Jan 2022 12:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374243;
        bh=DODeF9o8Sl2vkui25obN2Ct4mXtkcYS1+9H7aC1HxUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCTWqJCfwI202ExJ0XgYw6eqmW9biV0iPa4FPbQId4aKlzLcLWEvoOBbpuH1Brn+r
         t+7hyp4BUSNS7dQkITGMXmjArsRl5Mw7espg7ORu8hPdqqwPObzv0mGJcv6jMBA+j/
         t2s0dvo5qAWWyhO+j3NmMYeQeaboZGMqyzL4CJu1Avsx1j2otxglzu4R3DhXjMKg3B
         4JQxXQyaB784u/3rGJiIMC8/EAFhdKjBC9fxCfdEyNEdNR/l8Q3rDam+sY95Er5uBN
         3nM6lWU7U42FvYwgGDq/xIUnV2f+jjOrtTzfzHW6PNwvFipInmlv8ik5XP2aFhc165
         MvQ3CThhCnDgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQEY-003njR-Uf; Fri, 28 Jan 2022 12:20:07 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 56/64] KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
Date:   Fri, 28 Jan 2022 12:19:04 +0000
Message-Id: <20220128121912.509006-57-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNCR_EL2 points to a page containing a number of system registers
accessed by a guest hypervisor when ARMv8.4-NV is enabled.

Let's document the offsets in that page, as we are going to use
this layout.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 74 +++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
new file mode 100644
index 000000000000..c0a2acd5045c
--- /dev/null
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * System register offsets in the VNCR page
+ * All offsets are *byte* displacements!
+ */
+
+#ifndef __ARM64_VNCR_MAPPING_H__
+#define __ARM64_VNCR_MAPPING_H__
+
+#define VNCR_VTTBR_EL2          0x020
+#define VNCR_VTCR_EL2           0x040
+#define VNCR_VMPIDR_EL2         0x050
+#define VNCR_CNTVOFF_EL2        0x060
+#define VNCR_HCR_EL2            0x078
+#define VNCR_HSTR_EL2           0x080
+#define VNCR_VPIDR_EL2          0x088
+#define VNCR_TPIDR_EL2          0x090
+#define VNCR_VNCR_EL2           0x0B0
+#define VNCR_CPACR_EL1          0x100
+#define VNCR_CONTEXTIDR_EL1     0x108
+#define VNCR_SCTLR_EL1          0x110
+#define VNCR_ACTLR_EL1          0x118
+#define VNCR_TCR_EL1            0x120
+#define VNCR_AFSR0_EL1          0x128
+#define VNCR_AFSR1_EL1          0x130
+#define VNCR_ESR_EL1            0x138
+#define VNCR_MAIR_EL1           0x140
+#define VNCR_AMAIR_EL1          0x148
+#define VNCR_MDSCR_EL1          0x158
+#define VNCR_SPSR_EL1           0x160
+#define VNCR_CNTV_CVAL_EL0      0x168
+#define VNCR_CNTV_CTL_EL0       0x170
+#define VNCR_CNTP_CVAL_EL0      0x178
+#define VNCR_CNTP_CTL_EL0       0x180
+#define VNCR_SCXTNUM_EL1        0x188
+#define VNCR_TFSR_EL1		0x190
+#define VNCR_ZCR_EL1            0x1E0
+#define VNCR_TTBR0_EL1          0x200
+#define VNCR_TTBR1_EL1          0x210
+#define VNCR_FAR_EL1            0x220
+#define VNCR_ELR_EL1            0x230
+#define VNCR_SP_EL1             0x240
+#define VNCR_VBAR_EL1           0x250
+#define VNCR_ICH_LR0_EL2        0x400
+//      VNCR_ICH_LRN_EL2(n)     VNCR_ICH_LR0_EL2+8*((n) & 7)
+#define VNCR_ICH_AP0R0_EL2      0x480
+//      VNCR_ICH_AP0RN_EL2(n)   VNCR_ICH_AP0R0_EL2+8*((n) & 3)
+#define VNCR_ICH_AP1R0_EL2      0x4A0
+//      VNCR_ICH_AP1RN_EL2(n)   VNCR_ICH_AP1R0_EL2+8*((n) & 3)
+#define VNCR_ICH_HCR_EL2        0x4C0
+#define VNCR_ICH_VMCR_EL2       0x4C8
+#define VNCR_VDISR_EL2          0x500
+#define VNCR_PMBLIMITR_EL1      0x800
+#define VNCR_PMBPTR_EL1         0x810
+#define VNCR_PMBSR_EL1          0x820
+#define VNCR_PMSCR_EL1          0x828
+#define VNCR_PMSEVFR_EL1        0x830
+#define VNCR_PMSICR_EL1         0x838
+#define VNCR_PMSIRR_EL1         0x840
+#define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_TRFCR_EL1          0x880
+#define VNCR_MPAM1_EL1          0x900
+#define VNCR_MPAMHCR_EL2        0x930
+#define VNCR_MPAMVPMV_EL2       0x938
+#define VNCR_MPAMVPM0_EL2       0x940
+#define VNCR_MPAMVPM1_EL2       0x948
+#define VNCR_MPAMVPM2_EL2       0x950
+#define VNCR_MPAMVPM3_EL2       0x958
+#define VNCR_MPAMVPM4_EL2       0x960
+#define VNCR_MPAMVPM5_EL2       0x968
+#define VNCR_MPAMVPM6_EL2       0x970
+#define VNCR_MPAMVPM7_EL2       0x978
+
+#endif /* __ARM64_VNCR_MAPPING_H__ */
-- 
2.30.2

