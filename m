Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC0C6A52ED
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjB1GXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjB1GXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:23:18 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41565113D9
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:17 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id a23-20020a62bd17000000b0058db55a8d7aso4671353pff.21
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksmKTtmSjXd5Cz3+4oYXyLBynC+x6diBnvSRhIvjy0o=;
        b=n9XU35B8tynwKYgi4xrspPhRLm5F5nehMO6wT4NG0uyPuobSuNOYzFq91o6l2tjkql
         IYqjRrh7r0e5DFw2cGF19q5QUSUNFoUVl3jXo7fGRNl6tRgwEJ5R6AHouG8NsOFYoOwv
         4Pdu7m/Hfeja1fxuy6qaCpOVfPOHue7iEW682cl/a4etVYJPhL6si2fvXcaW7/G4LW0M
         tyitRYM8djmWZ/ZZn7XS4CEfx58+KAolwtbOApoCYWhAkacIQhT9F2tkWq2hmlZ87sY9
         TpG9kiwWEIRq5ux/SlaHB+DSngmSjnPeDSGqO08cdXllPXg8vIU17qEdkXXvEMmjmoUL
         Qe4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ksmKTtmSjXd5Cz3+4oYXyLBynC+x6diBnvSRhIvjy0o=;
        b=wTbowhM6P6/ZUyk12DHGYOgCn1o+Kdsg5J3akrFGs69FUFzzlhXxMrw9i1hUThfbnF
         vfKq+BZIlGCSiRIQhuSNSpLQYaQePi+EkxoVJAcqhVt1dhfjhwWFcX9need9UNUoiYqs
         kfsvHaqkP3QOXlJ+RUd0sXxDw2KXEAjhFSDMGnZDLabvYpVoALBhizPdMGLdgeB9WUCJ
         D8TD9Pz0JYP+DNsgc5hMadoa2wfF63DK5RCTqTwTTlu+eQx6BSXNAG/fXNEjFJlzdRYm
         n8lOGh5YXZ0QrqCWUNvdTwrXPeTZCbDpgdkL+6G6adJ6/ttEre0+A94Dfe5XFc2UxHSO
         wkJg==
X-Gm-Message-State: AO0yUKX1C0ssLdVCt3m9V6UciYbVDwYk1NTIKaTRqiLQFE3Rb255wTjZ
        yJBeZqDXwKspRvCbbpgB3flZ1CgQfJHVeNVA9V6+OffD8w7+NvLZ0/IPuUyaBKFuo1kUUnIXwmx
        3RrXCFdJhm8BupUT9Iq0y58V5dtLb73poJfvui6SpsUCGIFJOwomYKwfTvIy+kQMYBUH6o54=
X-Google-Smtp-Source: AK7set+5JyLrcmMolmaG7a5YGTJXYFOnxgrw77brtPDDmlnF5XevYDwEcIfwLazuMVLZM4ifJlQW4aedvahgXfdT1A==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:9482:b0:233:d64d:4c29 with
 SMTP id s2-20020a17090a948200b00233d64d4c29mr710336pjo.4.1677565396504; Mon,
 27 Feb 2023 22:23:16 -0800 (PST)
Date:   Tue, 28 Feb 2023 06:22:44 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-5-jingzhangos@google.com>
Subject: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 11 ++++---
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-------
 include/kvm/arm_pmu.h             |  6 ++--
 4 files changed, 51 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f64347eb77c2..effb61a9a855 100644
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
index 36859e4caf02..21ec8fc10d79 100644
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
+				IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	else
+		return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver);
+	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
+
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..eef67b7d9751 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	(kvm_vcpu_has_pmu(vcpu) &&								\
+	 FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.39.2.722.g9855ee24e9-goog

