Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3456D3B21
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 02:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjDCAhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 20:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDCAha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 20:37:30 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30916A26A
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 17:37:29 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y186-20020a62cec3000000b00627df3d6ec4so12544192pfg.12
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 17:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n9hPEYzgNXRlO9uoyqPqxQh7PdJy06R+RDjdkmdpz/c=;
        b=AGXUIGMBmN5rSe/0Nz4L0+pm76utrqJeD6klyHWSE0unOIVKatrMXv+ZDHKrQY1LLL
         xdh6zgSDbBEi31cpwWg7JbTY0PWWUq/P2ohZtJ/KvXATXPnTl3xNeOnh2bKOJI2CXPXh
         nhEBgnGFVLiWZXMT+ZFa4bRg4vEFCfMyNMaPLtvxH3Bkhkb7kGxqnFWVHnZHHZnPzRzR
         t+M3hY/RqGqKwzDDQnKyj3rX3awymAUqvhrZlVWwFxDwHVPgtgHkiCwoAgHCCVL3IDh8
         FzDa+2N94/3LYSbFacnV0oWbhyE2HloL2X5yzgYiy+EP35H4UZMLFGxuqMazX6iUpAJE
         GRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n9hPEYzgNXRlO9uoyqPqxQh7PdJy06R+RDjdkmdpz/c=;
        b=w7RXVB5Q1YXRc1pwjFOTNHZ/wAVJaEkM9P+XsNSu5aJOQKgLKqddCEwmptTS3wfmbp
         N4a65Cu8IFTjIheAEmkcd9ziTT1zRI2idM4vLcHJ0IQ3wOfK4d8uqPWck2fqep6A9hBu
         6oZzxV58fJP3DlGi2TDs2t5YPyA6Zj1xtiLC32gB+F1gD4eB9k14Uua90gplFz+y9PZW
         ZVjcoXiKJyhwKz9jpEwemLbZmE4NzmjDxR8Zk51jZo0bRXl6AE6fZ1dDBz3YggRNSVoR
         gXEUiS4bDZ6Db8zJFFsuahM5eNqgCWF4qs0KN6PJsaGtdz1r0oyfBp2bG1QddHzOS9Y0
         55jQ==
X-Gm-Message-State: AAQBX9dvAwnXr1FKV3tAskigZt/gSI5Linwgj2rkFWo14qjst2mJRY/z
        4gHEU1sPb9E2cKGU0Kj19CxRgo80ODMT3J4UghaxUyeHYEgBY0lGVDSDtcMWFD6bg9zZytAHOJm
        gTfZQ6JM1U/yBiWKpY+2NwoMQQRg17zc9BshMSkHjA1ZcSUpjE7zDVPm6XCYU8GgYfT8iPnY=
X-Google-Smtp-Source: AKy350YvYZD4xlcGV3J9XFyvItXlNeRUnWMXoeihnesDdqKMO8h8/ozUdcGAtvsc5vhiQSgXaBt6M2uddrnRjkBf+w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d8f:b0:62d:ccc4:2e03 with
 SMTP id fb15-20020a056a002d8f00b0062dccc42e03mr6387878pfb.4.1680482247647;
 Sun, 02 Apr 2023 17:37:27 -0700 (PDT)
Date:   Mon,  3 Apr 2023 00:37:22 +0000
In-Reply-To: <20230403003723.3199828-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230403003723.3199828-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-2-jingzhangos@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 43 ++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 395eaf84a0ab..7ca76a167c90 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -355,10 +355,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 	int ret;
 
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), val);
+	ctx_cmps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_CTX_CMPs), val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -377,28 +382,28 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	if (valid_pmu) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-		ret = set_id_reg(vcpu, rd, val);
-		if (ret) {
-			mutex_unlock(&vcpu->kvm->arch.config_lock);
-			return ret;
-		}
+	if (!valid_pmu) {
+		/* Igore the pmuver field in val */
+		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, read_id_reg(vcpu, rd));
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+	}
 
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = set_id_reg(vcpu, rd, val);
+	if (ret) {
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
-		/* We can only differ with PMUver, and anything else is an error */
-		val ^= read_id_reg(vcpu, rd);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		if (val)
-			return -EINVAL;
+		return ret;
+	}
 
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
-	}
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
 }
@@ -610,7 +615,7 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
 	  .ftr_bits = ftr_id_aa64dfr0,
-	  .writable_mask = ID_AA64DFR0_EL1_PMUVer_MASK,
+	  .writable_mask = GENMASK(63, 0),
 	  .read_kvm_sanitised_reg = read_sanitised_id_aa64dfr0_el1,
 	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
-- 
2.40.0.348.gf938b09366-goog

