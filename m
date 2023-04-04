Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0426D5755
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjDDDyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjDDDx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:53:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1451BFB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 20:53:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ie21-20020a17090b401500b0023b4ba1e433so9662347pjb.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 20:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680580434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPaRDrnezSi3/msZhxMLLcFkaO1ENnHVHYvRu1cKR0E=;
        b=ctKwbFgnE63agOAOwGkVQVgxB/0XPe+4jBzzK6GGjXvzsokFATZFjRxV0bY6CmVFi4
         Yaq96UDN5hnBrlqXajLOUvwDkMn6ZV89ATys4qI0F6cyCWhHodjC1JAuPF6pc8uk3n0o
         Nzrly8wq3WdqzsbqdXnChJ0QEri3IQy/f5mr10b+RbahX/Pw0wsntknDrEecrmNKKbmo
         /kus23Q0lnMF2fPqXvWrRndXVsFwLFGhlwCNgCh9cyQaXl3azEaSlSppfLMdojC1IVBr
         kMTicbhX7d+JC5G4bwfenajzF1h/2kWMvyvoMVYG8J7Erj+cCjeS62VO9Kd0w+afPiC+
         8WkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680580434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPaRDrnezSi3/msZhxMLLcFkaO1ENnHVHYvRu1cKR0E=;
        b=RFaYFsxizDV7XU7SWLMfJCPw456/GicabIel2VqM6iNtd8bWJALsILaiG6e9zCeh/9
         6O3DlAXH16JmObAOW/cgdExcBl9fEUB8qyihP0O2Dsl/d5bMwMFSshGtMqaYCXTrBkyS
         i4OtGspDqrO775R8HIq9EpdtnltZe4vCpZfA273WMVi7WMdXVxt6B6xtu6/Tqp2lsSpX
         xu5hH/qT/PXvuzBKuD/ZC0bHt4omi56PNhAqY9Y1FD2hFQ2VR0gVKZdLH9n2iKs2pT5V
         49a6m5ieZDvRGkWAEl1KxRq1bz+07Zvrsu5IWUXsxCv9PPMhCP1asBQjBG4r5R4UZtss
         dsiA==
X-Gm-Message-State: AAQBX9fVEBlV4DS55j0P6vRGO2w8b1GQl61r4ATVUpl+mHCQAq+/Ouby
        Xpsl5zk6CUwd6r4DmKywPjlGYKEOXHE3ue1DaxZ8RXbsG6Eqfb9pP+a2bB3enxfXhoUepf8NkCP
        vyPMVuElm00v6ujO1ja5/yOha22eIiZK0QBmGz02EZxL/oPSNrakYwhTsgCt3l0OBHAUKrBQ=
X-Google-Smtp-Source: AKy350bu/wdRHgiw5cjAVFxUC7KPVk1p2Li/D4upy7yFfd7BF+P2LPYVKvyTuVZsogdqH0Ef5BYttAHkWSA14wQUPQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:b09:b0:240:f09c:fae8 with SMTP
 id bf9-20020a17090b0b0900b00240f09cfae8mr414619pjb.2.1680580434077; Mon, 03
 Apr 2023 20:53:54 -0700 (PDT)
Date:   Tue,  4 Apr 2023 03:53:42 +0000
In-Reply-To: <20230404035344.4043856-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404035344.4043856-5-jingzhangos@google.com>
Subject: [PATCH v6 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 11 +++----
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/id_regs.c          | 50 ++++++++++++++++++++++++-------
 include/kvm/arm_pmu.h             |  5 ++--
 4 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 67a55177fd83..da46a2729581 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -237,6 +237,12 @@ struct kvm_arch {
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
 
@@ -249,11 +255,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 64e1c19e5a9b..3fe28d545b54 100644
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
index 291311b1ecca..6f65d30693fe 100644
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
@@ -254,10 +257,20 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
+								    pmuver);
+
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
+								pmuver_to_perfmon(pmuver));
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	}
 
 	return 0;
 }
@@ -294,10 +307,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
+								    perfmon_to_pmuver(perfmon));
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+	}
 
 	return 0;
 }
@@ -503,4 +525,12 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+						      kvm_arm_pmu_get_pmuver_limit());
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

