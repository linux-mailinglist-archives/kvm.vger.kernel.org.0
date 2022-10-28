Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2371610F77
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJ1LQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 07:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJ1LQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 07:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBCC137390
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 04:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47EBC627C1
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 11:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7462C433C1;
        Fri, 28 Oct 2022 11:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666955791;
        bh=/w3KQ4ekRSwyFLr5poURdPuohsmeyxZIMN9hwP3KB9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EE/9K5kkUA+bl/IuQ3v1Ncivdi6gSGVgUnlZLFq8bhIRzNYeZOcKpbgCJ3dPPvhH3
         I0Ub/aW1u2z9WdjYnR+qXmSYP1btH3Ia94iUX+9gZsFVk1oeDJMqjeMTvXvfskoMhE
         WiE/U2aqKH3Irl4hyWcpHWrGwX+eD51TwJKNEc0rWY313ZBVTGFfJTI5RjZsx8ClsL
         tRSMgvEdizwhvCTv+brkuntkdD5ycyFuP9KpN6s9PBqtWJzXdVEHpuWcceTgzarcit
         OBRbrA+sEQg0ebMfMw60G/ojyIxOR0ZoXw2aUszHyCBT+QIwK9n3S9Rys0BYzuJEdV
         RCZXIxMzWF0xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ooN0A-002E4C-Ku;
        Fri, 28 Oct 2022 11:54:14 +0100
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
Subject: [PATCH v2 14/14] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest
Date:   Fri, 28 Oct 2022 11:54:02 +0100
Message-Id: <20221028105402.2030192-15-maz@kernel.org>
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

Now that the infrastructure is in place, bump the PMU support up
to PMUv3p5.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index dc163e1a1fcf..26293f842b0f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1059,6 +1059,6 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	tmp = cpuid_feature_cap_perfmon_field(tmp,
 					      ID_AA64DFR0_EL1_PMUVer_SHIFT,
-					      ID_AA64DFR0_EL1_PMUVer_V3P4);
+					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
-- 
2.34.1

