Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E016970CDAE
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjEVWSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjEVWSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:18:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7518BB3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1ae40139967so64848525ad.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684793924; x=1687385924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxLJmdcsmtgg168Jc6B1bzOdGO2WKNd0sf7sUU3rn4I=;
        b=KYtKplk7fUQ4Ma46edslbFA2ELgsLccmDqy1O6Q5cLB5ipd+bWUDD1SJvhRclhvE/E
         leuzOn6DO0jen6zgCIoIk0dyYwTV+m1Tbu9uTrWvrxwCMAaRnHHmlVLqHhrOgmzZog9S
         NUGzYb7jJb9iSev6rWoKLS5/iDw+CwGO44sGHOpnFrhtmDopH04OPLZGVlfUmJET4GZl
         UG3AiUILbFkWN0HqBfPKaN1Y16fFtZuavi955hCLMf+uQxMRr+aXedRmFlvtsowxVG+/
         ibhXxWo1A60PjHuI/eJbZDxDXy59LgkW8jwq8jaZXuc2X6bjNM4/o/Or88ExGTEDtspW
         Eosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793924; x=1687385924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxLJmdcsmtgg168Jc6B1bzOdGO2WKNd0sf7sUU3rn4I=;
        b=iQVITfJvhSaGe6jN2K/r6exTL27X5bYhONh4o/Ny0vfqIK3MlRqi58acjRiCCdg3OC
         vambld5CFC5N8LZ/KS1dpBYHXOPVVbhHQma5NOoZNB2CZUpLjltd9mEyKOVakvQYPy6i
         tvjX4emqS9QUbjVkTcp1OT71Wt1Jyz3paawnRX28tf+HB3qHP2jqv7oS+PL+EARaDc7f
         fVZcfynbhGPTSu6Y42z4JI6g4doOVADfDH051RYAUBdvK3Xc1O1Xq5DI3kv4cJQ+MaMU
         FLdW90ZRkfGe/L1WEhPZtZSS7hzVHGHuMHgGnMStPrFS4oDI4/N/wGcta3cNb0xEnPA1
         EAeA==
X-Gm-Message-State: AC+VfDx99P5Iu070DvCr/V3iS89wGMRy7ZsQwNZuz+UYY0dcWkH8x6By
        C2q5Bhbl0t8qnb+UJHvb58V/ZV5n6pNE7WWrk1yqd0V1UYLDQr7dav9kKDXQwdCXXCVbetUOp8i
        xp7ANBeVuMmOewDfbknllfdOelH2SAcxfpP39wVRJUlFadkWUOl5l1NAqmcxCDNppVg98nLk=
X-Google-Smtp-Source: ACHHUZ7vx9TiuHYd6N9l2BaA+GQI8XZH+xGQ3r2UG1t2m1J+GAhg41hHiNsa/NEYQ0+MwgY6G9MvNUCVzMlDN5C02w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:d14c:b0:1a9:baa8:359f with
 SMTP id t12-20020a170902d14c00b001a9baa8359fmr2762897plt.6.1684793923933;
 Mon, 22 May 2023 15:18:43 -0700 (PDT)
Date:   Mon, 22 May 2023 22:18:33 +0000
In-Reply-To: <20230522221835.957419-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522221835.957419-4-jingzhangos@google.com>
Subject: [PATCH v10 3/5] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h |  12 ++--
 arch/arm64/kvm/arm.c              |   6 --
 arch/arm64/kvm/sys_regs.c         | 100 ++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |   5 +-
 4 files changed, 92 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8a2fde6c04c4..7b0f43373dbe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -246,6 +246,13 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
 	/* SMCCC filter initialized for the VM */
 #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		9
+
 	unsigned long flags;
 
 	/*
@@ -257,11 +264,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5114521ace60..ca18c09ccf82 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -148,12 +148,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9fb1c2f8f5a5..84d9e4baa4f8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1178,9 +1178,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
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
@@ -1403,8 +1406,12 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	u64 old_val = read_id_reg(vcpu, rd);
 	u8 pmuver, host_pmuver;
+	u64 new_val = val;
 	bool valid_pmu;
+	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -1424,26 +1431,51 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PMUver, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= old_val;
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
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (new_val != old_val)
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
+	u64 old_val = read_id_reg(vcpu, rd);
 	u8 perfmon, host_perfmon;
+	u64 new_val = val;
 	bool valid_pmu;
+	int ret = 0;
 
 	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 
@@ -1464,18 +1496,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with PerfMon, and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= old_val;
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
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (new_val != old_val)
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
 
 /*
@@ -3422,6 +3475,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
 
 int __init kvm_sys_reg_table_init(void)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a6a695ca67a..8d70dbdc1e0a 100644
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
2.40.1.698.g37aff9b760-goog

