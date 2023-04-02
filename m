Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBE76D39DA
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 20:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjDBSiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 14:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjDBSh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 14:37:59 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B66A58
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 11:37:57 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54161af1984so268025547b3.3
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 11:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680460677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7wtNV4K4ZwIpWUK33TxV8u73OVvahKHvisjWHKx0+HU=;
        b=qCo30+Zon7/M+jNmJGM6AiB17N/0f4hrSzETL6yj9pwxPHeubnb2TVIwQz05UlCMX9
         GF77ugIkcJdx/76zRnhkwJujNyoQHS+8a+yU/UxHRJIUB9GECfnyXHJ195Fy3Y2Q96X4
         oaa1ADraPWiNA6httrhBtJHspbK4gKnMfynqpAJbkez4NqrHT6kVMbQiglumJm7Eq2IB
         tfPcdJXdtaY5KIZEuWVc/TRxF9rYI5m4BaAfRoPTESKKZ9lFXpSd1Wz44YxW62iNRN9t
         l26LMbYiN9PmFwv2261rbD9ywV1VA9Qq7U2jh3Hlaqlf2LGsegA4jmhgwKgkQSBweGdX
         C9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680460677;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wtNV4K4ZwIpWUK33TxV8u73OVvahKHvisjWHKx0+HU=;
        b=PrDqCYPIuGSOqQk/b9+f7KAlmHjFNkjQE8Ol9OvWwFHDHl6sX3kCvuhjOHidqJ+mZ2
         LvVoVpb2rosuqLXeGZ5ExyQibddSJKdj18BM6tXTmIwgaBj15Woqbk6sC2u8AM9inOlh
         CnYcZiNkG+FeTR5pTl5Sq/jJJHbIa+gv6NL0R7AO3FBxiHVGjlWW/+9doQ6CNX0ALDtz
         aziuWsI5C2gtv9XsknO+lhnqYnGkezMBoD34x6tA0B3+MvWF7tI2e8ZzuNC2HvQ+Jrue
         iPLWVPX+g/9hc2RcWg26flQs/WbecjMPvN/sHxv5IgyVeylUGr9314cNEdXlQD24KVgV
         QB1Q==
X-Gm-Message-State: AAQBX9cNG9OaOQs5OUhHISXzKiO2+ehf8PK/sMKnNOGL5GgABn6OG8zd
        kTaa+JAwGp6tDIaSyfrrP9u/52zrqozQifTDaIjTwbP+4zv+3CHgpdLwhmygHu2me+BuIPJhwS5
        8QFMmBgCg21qEPZFMiVZmwUlT1Lv6SD9h02LP58MYopQkE1xIfPBGbIaPR/MLfqYo0VhJVTc=
X-Google-Smtp-Source: AKy350ZiyV6l/P96zSakTb2JACzW+Bf7btFQhwO1yArev8ReOE6Qv+4D4Z2k84cTHx/rbaTUmiSMtlDy9vqFyy2R5Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:d784:0:b0:b76:3b21:b1dc with SMTP
 id o126-20020a25d784000000b00b763b21b1dcmr9741672ybg.0.1680460676989; Sun, 02
 Apr 2023 11:37:56 -0700 (PDT)
Date:   Sun,  2 Apr 2023 18:37:33 +0000
In-Reply-To: <20230402183735.3011540-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230402183735.3011540-5-jingzhangos@google.com>
Subject: [PATCH v5 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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

With per guest ID registers, PMUver settings from userspace
can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++---
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/id_regs.c          | 51 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 +--
 4 files changed, 50 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 283e1f30cec5..28448e53bbf3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -244,6 +244,12 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
 	/* Timer PPIs made immutable */
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		8
 
 	unsigned long flags;
 
@@ -256,11 +262,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 483c7377e092..48d738148e84 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -150,12 +150,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index c6525efe8058..e92eacb0ad32 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -256,10 +259,20 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	}
 
 	return 0;
 }
@@ -296,10 +309,20 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon);
+
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+	}
 
 	return 0;
 }
@@ -539,4 +562,12 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..856ac59b6821 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	 (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.0.348.gf938b09366-goog

