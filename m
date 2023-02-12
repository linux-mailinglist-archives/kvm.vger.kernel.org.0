Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8AB693A5B
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 22:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBLV64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 16:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjBLV6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 16:58:54 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC13EEFB6
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:53 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id ik17-20020a170902ab1100b00198d8abcbcdso6232116plb.2
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 13:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=605ra7J+yn3Ift2jw6B1GLMWDOOAzHC0AtkxvlfXieM=;
        b=ho3vqUNX3LblnD/J1RDyHiENdpy6D4e+9kw4E7fofHblS+p5wWVVQ8qe4cOQFcl5CB
         GKIvP+hW0sQQO4J/XYJRf7FA0Ap+LN/v+V0cJwAuYK44fTdZLsRcIPbaY79FVZH0W+r6
         nV+CrR9hOARKGaqZOsDAm3F0LBMcHWOcbvRe0sVLB+d4NU6gOlnXo3ZG1WY/+HNkweW3
         tg9Q9qEa0MemSdWUDV5ulEB3AHLaZ4GyGEYzBMv3hjBbDSz2w83OorloSCBCZB18Tog6
         EjvV+otgWjjopOtTCB4zcDTXHb3h9/pAJdzp/aIIqs8MX6ebvsRCKtJ1pyXPKuebg8iA
         c+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=605ra7J+yn3Ift2jw6B1GLMWDOOAzHC0AtkxvlfXieM=;
        b=gbdpfOgthSx/J8a4YB/4xvdHiyNHc4WleTd0EwE4bnnNC9yH/ot4XGe+/W+MfKJ6aF
         4/rGPLJq1mk8XAtrhGYTu1OE+82Og7pYo5NiqUs1yMN6o4xfpjrt6dfzsCXUF2sYm81v
         wWUNGPdkBktSSwM1vRbI+h5Vu7A5WJBpiBrnGv5iWmblVNVLyYOoSSGFWf9nt6EPDJ//
         gecYNPy/oQolUMhBZhdXcBQ7O5976Tb7HICgH0y5W5yE1z6+BLMq3LK+J28qyupWSj/O
         pX6hAwflxaOx1h5C1pEE3iAOovV53ulp9cSM+KTF04XN/I9Vs2SLU4nFhs8d6xQwMlRH
         JDHg==
X-Gm-Message-State: AO0yUKV+ggQiQFbucHPUuk3all8WzeLSz8CG+J8nUlZp551OggYARyQ0
        xEfiNxL634x0EyGqmfxFEEKVlqqATTqRBexkeY+LHAsD0eRT/+PlWEVmpghuL0MaBL5iPLLLn1U
        b75vQUDjA7H3VaPY6Og4ke13xaJptFlDWeagwwF1ySyrn7ajsrSXUIs/fKhrVsYYAdMpbgGo=
X-Google-Smtp-Source: AK7set9ruIVFvM5fBQR8fEp02TlaMRA7rGNImd0iRNCsGAWOEXtOrSyzAjdkw7yTYqV7w8J6KdEiIUBci3qPnDWfCQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:7289:b0:199:1852:d21 with SMTP
 id d9-20020a170902728900b0019918520d21mr5534463pll.0.1676239133083; Sun, 12
 Feb 2023 13:58:53 -0800 (PST)
Date:   Sun, 12 Feb 2023 21:58:28 +0000
In-Reply-To: <20230212215830.2975485-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230212215830.2975485-5-jingzhangos@google.com>
Subject: [PATCH v2 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 11 ++++----
 arch/arm64/kvm/arm.c              |  6 -----
 arch/arm64/kvm/id_regs.c          | 44 +++++++++++++++++++++++--------
 include/kvm/arm_pmu.h             |  6 +++--
 4 files changed, 43 insertions(+), 24 deletions(-)

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
index bc4c408a43eb..14ae03a1d8d0 100644
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
@@ -267,10 +270,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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
+	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -307,10 +315,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
+	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -534,4 +547,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
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
2.39.1.581.gbfd45094c4-goog

