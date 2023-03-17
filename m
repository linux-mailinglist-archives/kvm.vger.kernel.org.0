Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802796BE075
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCQFGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCQFGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:06:52 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526624A1E7
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:51 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id a9-20020a170902b58900b0019e2eafafddso2135423pls.7
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZEB1m53gFZBM6ivDePWUKW0Ym2zNIJxVqCGHxY2i+w=;
        b=gcO1qHHot9JIDDyrkjXtnvE0a/n/R9Q2wvkm4hmwA9WIBvSZVQR7I3sZMw4D9J7ENS
         +uqGC0/19vOeaxGMWh3gj18sjFlnwa+oagiMS2Fhoi4BA6Svm346hsxVaooVPjHexK9v
         ZIulrwEAajcbpCCBw3FzYPQm7t/A34x2zE0Sz5SkYtVOl19ax2AVUh6oFwEi3Jf2Fzn5
         3zejHsRjsic6qj3rsIQ/+2jN4P4e8jCs9WZfjlHjKegknmMu+/uPbN9luP0fq+LHujtE
         FDn/marpGXM6hUKrCSDYnSttjwzfZM+qRgzo2KhBw2KjVLrIEB72VmybKaJA0iowdxl6
         M/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029611;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZEB1m53gFZBM6ivDePWUKW0Ym2zNIJxVqCGHxY2i+w=;
        b=wjNVIgaLchQLmUHp1wmaKIJ661SZbVBVSin1CzRXKDZqRB2ckFzDV++uS4TCHAlw60
         t4xB5e26VDq1U4VeduTuUjClXekt0099GIEse7rEgfGcglG2sXLl4xiY//SksGjsIILR
         sxBcTfzSFZEEA0gugV2JqGI018jwSK7u8+qYLziJGGPGXwckHRWvKPLqOwQ230iDw41T
         zhq+doqwnb3wUto2Kv/+If/sl0RQWCgSoh075ghIKhOU8PHbsQ4233brDGBkyTVJVrza
         AjxzZEN+lDXKtZAK6qWF/M77iposoxO+7ZmdSOTaZZUQ3SQwvCoCushicQSYBXXqi1eO
         MLtA==
X-Gm-Message-State: AO0yUKWeNfm3iozXZMJBLHDbhNLy7tcLcWjAV2tZhtEtmPiwdrct1HoQ
        JmQlEAcQ6NA+qzYp6pNx5f/4WK6lrbNpTvx5FfUj/VAl8lWK3FhLhNVoVMNiWbrWqjfMPSREKOc
        cQ0yvrX8OWQM364JspOHpR0dBRhq6wralARLcsRdeWeqfZSRVCMe4QSCZ05t8y6Xx0uYDyZs=
X-Google-Smtp-Source: AK7set/EHeJ/LpIi8CyeNWVjFfI5VAcbXWYcGoamGR0S/Cq6q3ioHjokpVjO2bipV8CRDfT9aK8+oOjF2kSH7Q4xQQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a65:6449:0:b0:507:4737:cdb5 with SMTP
 id s9-20020a656449000000b005074737cdb5mr1489502pgv.8.1679029610705; Thu, 16
 Mar 2023 22:06:50 -0700 (PDT)
Date:   Fri, 17 Mar 2023 05:06:35 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-5-jingzhangos@google.com>
Subject: [PATCH v4 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
 arch/arm64/include/asm/kvm_host.h | 11 +++---
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/id_regs.c          | 61 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 ++-
 4 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e926ea91a73c..102860ba896d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -218,6 +218,12 @@ struct kvm_arch {
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
 
@@ -230,11 +236,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c78d68d011cb..fb2de2cb98cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_set_default_id_regs(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index b60ca1058301..3a87a3d2390d 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
-
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)]);
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	else
+		return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -256,10 +259,23 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->lock);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |= FIELD_PREP(
+				ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+		mutex_unlock(&vcpu->kvm->lock);
+	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -296,10 +312,23 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->lock);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon);
+
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+		mutex_unlock(&vcpu->kvm->lock);
+	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -543,4 +572,14 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	}
 
 	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+		~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..51c7f3e7bdde 100644
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
+		 vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)]) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

