Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79897610F0F
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiJ1KyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJ1KyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:54:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D0F111BAA
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C052DB8294B
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 10:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7140BC433D6;
        Fri, 28 Oct 2022 10:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666954453;
        bh=LDpHOoUTLZOBS0Pn/x1kE1SGXF+8M+SGG+sMaN5hl2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4EWI+TQq5fmgULaW+sIXpNP+PF4oQ4f/wMoSPvZOhsck9f8lgPDq/mzxGfU4RByN
         MIBzH3C8hwubTEoWYPkNt0tr3EsvCIlppVrP2T3GCz4z1I/UN/B8svKqZXXfJDt8VT
         jHR9AhSSIRrm1XwzoCR9f+oezqa05LO4GdrZ+FgPYtRsLZ3hDxmGZQG8+zonoWlkKB
         1ZU9MPxsKW8cQ5tvhRw8wIPJ70UxoNku/YTlt/9PMMv7a59g15I/ZwYBYQEE59Mjd0
         veM9z8PZD+MXZ8oZsMs/1GFoGMaIUzAVh7BB06rXCiC1p2Vu08A5OB/LlWz4tcQEze
         muZ+bG/ZkRMYQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ooN07-002E4C-E3;
        Fri, 28 Oct 2022 11:54:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
Date:   Fri, 28 Oct 2022 11:53:49 +0100
Message-Id: <20221028105402.2030192-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028105402.2030192-1-maz@kernel.org>
References: <20221028105402.2030192-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..84f59ce1dc6d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -698,6 +698,8 @@
 #define ID_DFR0_PERFMON_8_1		0x4
 #define ID_DFR0_PERFMON_8_4		0x5
 #define ID_DFR0_PERFMON_8_5		0x6
+#define ID_DFR0_PERFMON_8_7		0x7
+#define ID_DFR0_PERFMON_IMP_DEF		0xf
 
 #define ID_ISAR4_SWP_FRAC_SHIFT		28
 #define ID_ISAR4_PSR_M_SHIFT		24
-- 
2.34.1

