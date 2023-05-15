Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F201D703A55
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244896AbjEORuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244850AbjEORuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD84C14E5A
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E93A162F35
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587EAC433A7;
        Mon, 15 May 2023 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172889;
        bh=PHs4gaxAaWQmUmtjbLODLMqbuuO3t58QTS/ww8BSn6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKT6iwm5XLO5MaS8SQKdQnAzDpbZFb+di0gNz2OW583gV2Oa1XgXHI2QJCJxmge2S
         XmekQJ3HiHt4IRkwWBG/NDZsaBHRCKdjCS7QuPm05+Boez7usZJzKqlrgXcihNUqK6
         +uaHyhiQ7ZHHmEujeop9FAzs8e+2zts4lOW+lKAz1oivLvswZ2HoxsiOkRB/N7oOk9
         8UWmpfFhpDaWpgmmUKtDNpjHw9JUg5uVhpLiruFIIZseR0jBjaSrp+tOX1EvGtvH7h
         m7s95lWA3kwblEqZAu9Rf5hLwaTnDdhpbVVAp+Hhyx64qoRTayT4ZhAN13LNNan0VQ
         AOcV/zbwfMEiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc37-00FJAF-1i;
        Mon, 15 May 2023 18:31:53 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 47/59] KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
Date:   Mon, 15 May 2023 18:30:51 +0100
Message-Id: <20230515173103.1017669-48-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
2.34.1

