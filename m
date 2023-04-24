Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA66ED8F0
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 01:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjDXXrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 19:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbjDXXrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 19:47:16 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9543AAB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:15 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a697b1a71aso57126715ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 16:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682380035; x=1684972035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RIy+HzYxVdD9wg5y3WVcnsXEaA4ZDP3kYn5Iam7xw70=;
        b=bGM7JAtgvhlwpfOLnHiMC4Skh35UX1c3KZE9nB1vqzQt9kVdnCbIIHc267lwOHPLU3
         EtKwny7BzN/DqqGK31zy4oIvYdaveQUtYd5UcLAlLaX0gWOThSSGKNwcBC1BTTTILTKj
         I7/2JhiPwFLN5qhKJ+CC387bT3GvCDYbCqmj9LwM+ebJ+HH3gVodtFbrU6QIi8ZEfcrj
         gfbxbP76pAX655ZpHddBpkdaBgllFhFjpRvTA2uEGLOz1ZBEfB3M2AsK1Rxc1ZmfMzvq
         Vxw4zNqKWvb/2gZ6Ha8aEkOHd2Ted7nIR1h3z+ppkxd4//5QhAvvftUaY0Vb3jPeqeqc
         y2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682380035; x=1684972035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RIy+HzYxVdD9wg5y3WVcnsXEaA4ZDP3kYn5Iam7xw70=;
        b=MZ3OEDOU7rLRfboT8l9z0p5eZUYHY0k4c3vwiYb8P5J1yQ9GYJhf8wKKY42+2ESm8u
         c+VciQ6gTFq2B6kF5Sx6wGelFKGqVxoeEPazSGBGF4F8ZbQWOl7ijyCSRwJBqmwhHWn/
         Xfrz+qCoVhayPXi06lPKXioSJ8wtueRY06rCiII6lDd6C/FATf7/XezN07GAENibYNmS
         TFUq8/ytZ4mPGfiqrAe4DZLxwUM3csf1ldgm37z36swt+mCPr5GbCRGwhkcC7MRRIKJZ
         VVEI1MKPPbkxy8YLCr0ISmKK0yKHyGUpMMLTLLcra0LUjgl19EGmDmbStosRr2pklTHQ
         lcIw==
X-Gm-Message-State: AAQBX9dBTjPNVr1ic+LTGo6byWukmn2tSUcE+283Y4E6qz+62ouy3gNt
        IM+wBWfxQjDNsjWYh8ZEEdXFC2aO7tKFV21Gj2ZVpHbMG+EmOvqO/+uWYon/DVttrwM8wBBhYYq
        r66RSIKeppNMZiSTKCgv3a21gTcYEQIZsNDOWs+ldi3keK7wYOl5EEsrz3nPa1UnJD1ocogs=
X-Google-Smtp-Source: AKy350a7BJBMaUH21SnPtBI5rgAd4sPJoigUViak0LTLAgVA96CWiVCY8QqJgIq5ts1if0CFDp5OhHpM1TQk13UxtQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:c411:b0:1a6:b221:daa1 with
 SMTP id k17-20020a170902c41100b001a6b221daa1mr5344183plk.0.1682380034902;
 Mon, 24 Apr 2023 16:47:14 -0700 (PDT)
Date:   Mon, 24 Apr 2023 23:47:02 +0000
In-Reply-To: <20230424234704.2571444-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424234704.2571444-5-jingzhangos@google.com>
Subject: [PATCH v7 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h | 11 +++---
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/id_regs.c          | 66 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 ++-
 4 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c719c34f5b4..3b583b055d07 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -235,6 +235,12 @@ struct kvm_arch {
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
 
@@ -247,11 +253,6 @@ struct kvm_arch {
 
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
index 18c39af3e319..15f79a654be8 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				 idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -254,10 +257,24 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	}
 
 	return 0;
 }
@@ -294,10 +311,24 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->arch.config_lock);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_DFR0_EL1);
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_DFR0_EL1, val);
+
+		val = _idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1);
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
+		_idreg_write(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
+	}
 
 	return 0;
 }
@@ -483,6 +514,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg_write(&kvm->arch, id, val);
 	}
 
+	mutex_lock(&kvm->arch.config_lock);
 	/*
 	 * The default is to expose CSV2 == 1 if the HW isn't affected.
 	 * Although this is a per-CPU feature, we make it global because
@@ -491,8 +523,6 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	 * Userspace can override this as long as it doesn't promise
 	 * the impossible.
 	 */
-	mutex_lock(&kvm->arch.config_lock);
-
 	val = _idreg_read(&kvm->arch, SYS_ID_AA64PFR0_EL1);
 
 	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
@@ -506,5 +536,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 
 	_idreg_write(&kvm->arch, SYS_ID_AA64PFR0_EL1, val);
 
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val = _idreg_read(&kvm->arch, SYS_ID_AA64DFR0_EL1);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	_idreg_write(&kvm->arch, SYS_ID_AA64DFR0_EL1, val);
+
 	mutex_unlock(&kvm->arch.config_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..e850432f8c09 100644
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
+		 idreg_read(&vcpu->kvm->arch, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.0.634.g4ca3ef3211-goog

