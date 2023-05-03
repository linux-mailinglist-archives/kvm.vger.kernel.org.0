Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F606F5CDA
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjECRQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjECRQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:16:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE3F40FA
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:16:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559e281c5dfso54505977b3.3
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 10:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683134190; x=1685726190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KXolz7Q2DIi1pPRNwoAhG/QZ2/DoPomr2tw+WOeyqjM=;
        b=Krx4K2yz31cozy94Ad+ISWFZFzeiscMeZ/ySRPe1hfz5I8x5ucApXkjuBgGUzTRIyF
         8/+3htr4qLs+LS7ovEoUeWVHQBHTc2V1SnSKEH+X7zJGtYCvOkGPcPcB1HHPdeoaOg3R
         KXA2w8RzANBuRFY9lgArZM63pt3YvEcJlYRMF8NfQH7vqBg9tMxo/Q0RqeyVmHMigH5c
         u4nk1qZ/C9X+Ck21rL+senCKLULZXnaXY9t72O+YHFW/YlzSf7rrfYy5oD3yb5KVfS8o
         SlnXkJV17TxnCrrQe6uk1WcJQ17Jl2j5El7NhZRx56BkuHFo91XZB2k9nF4abBKNI/Hy
         u+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683134190; x=1685726190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXolz7Q2DIi1pPRNwoAhG/QZ2/DoPomr2tw+WOeyqjM=;
        b=FA4C5wMjKywzs2da9IWHATgU+jh24rh6NbScdKyw6Y1IV9JcZOj2IqAPHjQeM+XsOi
         mt53FSAs6QumHSJrSjnSJdp7Hec5mLoXLm/PVp82H5QwOsyCGXHkX5UE9cXg5CqNbsMI
         Py/pwSuUDTlPudqEri++CVe7F8UHqUoAT5tEA+oipxgnzadSPzD+NtctU1pdwV3Tugsx
         Mnx5h+WOhflZr5MrdKF7vT+67JLnYcmFBzhnmZgoHOVYlqQRb80THUqGwlK9vo5x7AbG
         kUtU279bv08MUPdS5wRUY8rK58GDBCYUWgHrbr2p8RRCjhGN6WvWGftss6LSwjjcSYvE
         B5HQ==
X-Gm-Message-State: AC+VfDwD9mPs391rRH/x63HlepDby/g+3Cq/mjJOXRyRtgC0kHwoxoV3
        D5az3UmGCW3hgFYYN4sbdal1m6VyPQcK6YcB2ibF91ew3VWR+zcUjPdOsyOwMRoARaxOKmUo+IM
        rCUZFLRnKRbM7VA9kDL99IK7f4dq7WLRbTVkilphCWwqAQRnx1rxwJ+v7KC2SV0ZG9XhZGeM=
X-Google-Smtp-Source: ACHHUZ4Uis1L58miXkgjaeqj7MVHDaCS/lTmCIQ9EHFXnlUHG0VlmkhfuZTCMo/MRfsgCeCPIAmC9IBGfMLKebC4RA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:7649:0:b0:54f:646d:19bf with SMTP
 id j9-20020a817649000000b0054f646d19bfmr13354258ywk.1.1683134189629; Wed, 03
 May 2023 10:16:29 -0700 (PDT)
Date:   Wed,  3 May 2023 17:16:16 +0000
In-Reply-To: <20230503171618.2020461-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503171618.2020461-5-jingzhangos@google.com>
Subject: [PATCH v8 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/arm64/include/asm/kvm_host.h | 11 ++--
 arch/arm64/kvm/arm.c              |  6 --
 arch/arm64/kvm/id_regs.c          | 94 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 +-
 4 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4699f6b829b2..009f6ff41078 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -236,6 +236,12 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		6
 
 	unsigned long flags;
 
@@ -248,11 +254,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0f71b10a2f05..9ecd0c5d0754 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
index 5e0fd4c8b375..0a04a90a8676 100644
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
@@ -244,8 +247,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -265,26 +271,50 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PMUver, and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-	if (val)
-		return -EINVAL;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		if (valid_pmu) {
+			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+
+			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+			val &= ~ID_DFR0_EL1_PerfMon_MASK;
+			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+		} else {
+			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+				   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+		}
+	}
 
-	return 0;
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *rd,
 			   u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 perfmon, host_perfmon;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 
@@ -305,18 +335,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PerfMon, and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-	if (val)
-		return -EINVAL;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		if (valid_pmu) {
+			val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+			val &= ~ID_DFR0_EL1_PerfMon_MASK;
+			val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+
+			val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+			val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+			val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+		} else {
+			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+				   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+		}
+	}
 
-	return 0;
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
@@ -517,4 +568,15 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) = val;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..e486347b297d 100644
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
+		    IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.1.495.gc816e09b53d-goog

