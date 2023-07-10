Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF9B74DE20
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjGJTYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjGJTYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56101BC
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-57320c10635so56374007b3.3
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017079; x=1691609079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ6ya0NEnIa5aVQX1AiBY2Ns/ppVJUg4kBKaquDN4C0=;
        b=OdWaI8UetC5xlsDbivt/wI1RqtD2Ol3BBLHnxQ9/Cf9Go9SKNCN7pvoug5MOr8pFRE
         Jr0HJYE6+lJIFXqJiZFwE62NlyzEhmli/QtYehhll8htzke3R17cDFmL4EWRtVDdtxpj
         v/3b49yRvxDs3842p5I92zZ1Nxbg+u3MD2SrWdYVKspzUMp2ZxinKiQymdYZdCuRoei2
         Fav1CzDCizrzfvxke6uiRWaXz9+d3t/p+qH5BHFH/8Hkr4CYv5kH/Gm2210yjr/D/U2A
         OJ34jvPSX4bqdF8X1d/o/dTD9bTQ9+/d/P8r54rZ+w2wkDB97xWCkJgaW1vJvrm1zxUo
         Dz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017079; x=1691609079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ6ya0NEnIa5aVQX1AiBY2Ns/ppVJUg4kBKaquDN4C0=;
        b=e8OyPJjJ85EODWn7oldcQmU1rCkNqf9kVEBGlRjdDp/hexSoWWsl5Isu7X4u/l6W2T
         5bNq0dU1bLeSw11C4RvcV0tL+5nkkajs8aWG19jhlWsg4lhtIBU46HogLO2y1omohxE4
         kGoP2LNBNyNHgpzjTjSY1LuFnKR4qn/I2hky4C1m5SRhLTRFWKMtsKgOzPEQYoSehZAe
         Q1Cn4mrBDpjK60VAsxTPW7FShkV6ZO/rEbxEvgrfkfdlOGBcp3PEUydYgQ1cfkzZ/Dvo
         eflPSe9SYPsV9AxWmD1v8M/dcP3NG+a6xYcI9SCo2OKm7wxbnjpiTWU3Skg7e3z3qe47
         FNOQ==
X-Gm-Message-State: ABy/qLaKg+8Csymn0q8boXscsED035Jd92RdO/ctUqs6pFxZ+YoaqhEX
        S7CTqgcZQPOsEdOo1K30o0TUUlAsD0J33J6ejcQvff6xV7wqbzXiRTQhuj+/rVTN8lg+ZN9xdDr
        tDrr7g8EYX2aTKRBvs3JCdJbEBPQIRCyGv94WUrjfG8sWTnk5Sxb8hHc7lP/UJjSFfPDeysg=
X-Google-Smtp-Source: APBJJlGrizomlrXrfIIBON5g1LdEHWOUxmR3lblulK7dG7BSaVkBpJJIgLVla3mrwr0NssOyEnvwpwXcUtXHepnUaA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:508:0:b0:c66:b847:544d with SMTP
 id 8-20020a250508000000b00c66b847544dmr113736ybf.1.1689017079311; Mon, 10 Jul
 2023 12:24:39 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:26 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-4-jingzhangos@google.com>
Subject: [PATCH v5 3/6] KVM: arm64: Reject attempts to set invalid debug arch version
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oliver.upton@linux.dev>

The debug architecture is mandatory in ARMv8, so KVM should not allow
userspace to configure a vCPU with less than that. Of course, this isn't
handled elegantly by the generic ID register plumbing, as the respective
ID register fields have a nonzero starting value.

Add an explicit check for debug versions less than v8 of the
architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0160ef9cfe18..c44504038ae9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1496,6 +1496,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
 	/*
@@ -1515,6 +1516,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
+	/*
+	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
+	 * nonzero minimum safe value.
+	 */
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
@@ -1536,6 +1544,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1551,6 +1560,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

