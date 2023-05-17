Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F15705FC0
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjEQGKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjEQGKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:10:38 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8894494
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25345cf3343so170168a91.0
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303825; x=1686895825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XO3TUGalcBEoGqQoQgLnoXNy9a4rhPSsy38V7ktJx3Q=;
        b=r3nMNlDNL6820r3a6fNjeFQTuOSyGK3Z/F20VL4QLmpeJxwaaIVjOOpL/Rd7nYKSGm
         tAbYDJ5MKavnnmRISe5Zrgh12LaJ2jOZQx32wASMJVHSRU2Pv9fR9xe/Z8jh6Iuuqt/g
         MjFCNPBsWwlFB0Cra1TQNQzslAsars1YfDcbj0UbU5evCZkC4foc73fDBCpd9yqLT9Yz
         T9HXyTBncCznW0CSYJtce4Qz44KZo+gGG/A4rKjHFk521QYWNmO1dT7fIz2CkeesB6Di
         YPBlcaKjYOBFsQ6NxH6bDVPsraG7M3BOgHXX5lG4xDJ3PeDWNvTY/axjhV8W9xV5ALw6
         LkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303825; x=1686895825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XO3TUGalcBEoGqQoQgLnoXNy9a4rhPSsy38V7ktJx3Q=;
        b=GJ7FOlDT7tO8vxMA2zZLVZj/ne5jcz0+NNYUXkdvr6E5TMfgXqUgIXFrj2VnA9If/l
         iVOVwixE8BmazlH1Cd/qvx+PKQoyvkjQAFjPH3iq1QS1szmJgg3Se4HhgxB/W3E35DbB
         Mh1w8fD/76clg+ziYwiaKiu8vPOTMoBbgyrUG4Zao1SWGNZURclthmJ1gQoqOQtnzBP+
         JMeaKKHMZXTVwn2/54A3DDMf/cX4M/Nhg7IpX/i6JVhhbLAROTYRlAgg70SSEDTPePkL
         fMLCVtaK2aa0kicvsYjkRdrkD33TohBbeMj8JyeZSHnM9Dq8RKJNiZOyKWZTEM7bOPn1
         rQBg==
X-Gm-Message-State: AC+VfDyGTf+7q1bjF2RuXWXxXKhuynWhvOeyoFEliQG1YOw6cZsgJqkA
        e7GwqOp/iSMh+R1QfbLMKQeAIlNdbld0dhAvpz6LNP7Bs7+94AD6r24YAcFj1v5BDMahT6mnZoW
        BEz5qzHK1ZLmEUTowx1+XyF/YSwW2zA+Za3g1i6POyffraIZfwJk/HU9aMmAtEe5kIhoCviU=
X-Google-Smtp-Source: ACHHUZ5h2ONPiwwVa1h3dyukSZOXybejqgzKNQ4sINXkhYMzo67UaHc6YRMvOsticuRp43xAsi184TLeQXVwGB5/mQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:9b8b:b0:246:7023:2ee6 with
 SMTP id g11-20020a17090a9b8b00b0024670232ee6mr11507162pjp.8.1684303824522;
 Tue, 16 May 2023 23:10:24 -0700 (PDT)
Date:   Wed, 17 May 2023 06:10:12 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-4-jingzhangos@google.com>
Subject: [PATCH v9 3/5] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 12 ++--
 arch/arm64/kvm/arm.c              |  6 --
 arch/arm64/kvm/sys_regs.c         | 94 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 +-
 4 files changed, 88 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 07f0e091ae48..9a5f82161083 100644
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
index 3c52b136ade3..fefe83f8deda 100644
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
@@ -1402,8 +1405,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
 	u8 pmuver, host_pmuver;
 	bool valid_pmu;
+	u64 sval = val;
+	int ret = 0;
 
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
@@ -1423,26 +1429,50 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
 
@@ -1463,18 +1493,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
 
 /*
@@ -3421,6 +3472,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
2.40.1.606.ga4b1b128d6-goog

