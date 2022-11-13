Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6A06270CE
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiKMQi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 11:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiKMQiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 11:38:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6E610FC6
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 08:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C89A160B3F
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 16:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21097C433D7;
        Sun, 13 Nov 2022 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668357530;
        bh=Y6xxfM4ND10MuEIQCLvziXMSdXkZfkvKinsYllpKaj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxSEug68DAT0jMRx3Il7LtSkqO3zwVd6Sbn/khEspP5iwEsbcIgWcEKtIE+A5ynpH
         V1KDaT0LhFvFbqssyOGuZRO+O1kKZ/Ak0eJammye/mR76e1+f5GB4XWz2DuAcvHgi+
         b/Wr5Q2ZVN1YK6BBnpWosxLBMcX/fNsr9CBzycn8JhvCmq+ND24ek5jvYmoGg6szF8
         cV6UIxXGRXB4H3VodexdNKjAfi445Crwv2U9uH2c2AroM4XcJM1YPHkjtlYm97sw3p
         56IyQf5fKYFtSsYzUnwdulyF/obKTcHzZRVL3/FBSVKlFTYkenjoxkOOjC2CZ1mvXG
         0iQHTvbEhH3aQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ouG0N-005oYZ-Tn;
        Sun, 13 Nov 2022 16:38:47 +0000
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
Subject: [PATCH v4 01/16] arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
Date:   Sun, 13 Nov 2022 16:38:17 +0000
Message-Id: <20221113163832.3154370-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221113163832.3154370-1-maz@kernel.org>
References: <20221113163832.3154370-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
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

