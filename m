Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70939705FBF
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjEQGKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjEQGKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:10:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DB40E1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba81b24c1deso644747276.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684303823; x=1686895823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=763U1ZlOf3Ut13MaIhCrRP1vSJUxMKLridX08yEHzqg=;
        b=PZWqhkvw2HYl4/osFqQQ61vuxGVnMOZ8q2X17ySrdYXP2OMb8yZI/AkI3WDXJlqQU7
         /3hkWXh0chmR0N5kw2yfKKKXQR3oJXPwrla6O7gauAAPz/KZgS/+xbWyFgwYOU49Fhol
         L/bhqXMjdGnYdZ+me9x5BnVWoIjvVKrVBFvsA/cqcuNTw9fZbaCwXj/LJXj047MrwK5C
         ln6ydrT9/xFr4lAMsci/jLsusFKb5WUmdd4tHf9s7QA/OwFIyd8iOmw3scbl/tnBbj+p
         eZVdi6qDO+UUUvxc+HqlwXaPr/04yisgJXzEKSf/SiGD2gk0cKjySJkHZHHo/rLN1bLu
         28kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684303823; x=1686895823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=763U1ZlOf3Ut13MaIhCrRP1vSJUxMKLridX08yEHzqg=;
        b=dYJbXp6fFMp1reC9wGWscDtHjCP1aEgfyDKOMKoWa2jCFq+PJkdfQugAdWeWWZHKnb
         sfD1HKCM8YppgAMF9RHlMlIawCA9rW65nDEOvAdEcg3L0kVkJzO4EWCOc3oinhU9HRFs
         iX1pOH/j8UHi0LjEtpZifz2YP6LmjfsuuFPelQckz3H61Aqz7qFq65GRS8WDWHmpJwxW
         HpMxDKJFLDH3UYqSk0HGR4BIHrCciHi1o6YO0/aS7WqQZYnZ/x81N5MAaXflRVre2SVe
         gyKm+aup0kxICRUSuLKxw68156W5qZX3Tp146jmHiBYuK5rgO0j/dfE9hCABdMTdQypz
         MVuw==
X-Gm-Message-State: AC+VfDzj5w70pZVEPwg9pyyxzxTMvslLxcP2K6JEBdyH+L8W8NBYdKuJ
        jjAmjmRCPfsls55nAYKO/Qcb05ii9q4+fFg5UfAXPf8pPYBPHBTXc6jsuAWaE9JwdAmGbdJiwqD
        uyazyP2jFzbfn5HuHlRPTZiWOb0/fenBoQJb7xHvEIzucUbO0bbWLybJhSaOtAB+jolONN6A=
X-Google-Smtp-Source: ACHHUZ47YtMv5cGQAcr1mx0MB9siSR6C4RqWPiBc4q6udHjCIb1pvJmYTd5MjM1V32dEA6gisIJQlZcp470XyXQ0pA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:aa61:0:b0:ba8:6422:bbec with SMTP
 id s88-20020a25aa61000000b00ba86422bbecmr287046ybi.4.1684303822745; Tue, 16
 May 2023 23:10:22 -0700 (PDT)
Date:   Wed, 17 May 2023 06:10:11 +0000
In-Reply-To: <20230517061015.1915934-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517061015.1915934-3-jingzhangos@google.com>
Subject: [PATCH v9 2/5] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
userspace can be stored in its corresponding ID register.

The setting of CSV bits for protected VMs are removed according to the
discussion from Fuad below:
https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com

Besides the removal of CSV bits setting for protected VMs, No other
functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/arm.c              | 17 ----------
 arch/arm64/kvm/sys_regs.c         | 55 +++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 949a4a782844..07f0e091ae48 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -257,8 +257,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	u8 pfr0_csv2;
-	u8 pfr0_csv3;
 	struct {
 		u8 imp:4;
 		u8 unimp:4;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 774656a0718d..5114521ace60 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -102,22 +102,6 @@ static int kvm_arm_default_max_vcpus(void)
 	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 }
 
-static void set_default_spectre(struct kvm *kvm)
-{
-	/*
-	 * The default is to expose CSV2 == 1 if the HW isn't affected.
-	 * Although this is a per-CPU feature, we make it global because
-	 * asymmetric systems are just a nuisance.
-	 *
-	 * Userspace can override this as long as it doesn't promise
-	 * the impossible.
-	 */
-	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv2 = 1;
-	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
-		kvm->arch.pfr0_csv3 = 1;
-}
-
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -161,7 +145,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
-	set_default_spectre(kvm);
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d2ee3a1c7f03..3c52b136ade3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1218,10 +1218,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		if (!vcpu_has_sve(vcpu))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
-		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		if (kvm_vgic_global_state.type == VGIC_V3) {
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
 			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
@@ -1359,7 +1355,10 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	u64 sval = val;
 	u8 csv2, csv3;
+	int ret = 0;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -1377,17 +1376,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with CSV[23], and anything else is an error */
 	val ^= read_id_reg(vcpu, rd);
 	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
 		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
-	if (val)
-		return -EINVAL;
-
-	vcpu->kvm->arch.pfr0_csv2 = csv2;
-	vcpu->kvm->arch.pfr0_csv3 = csv3;
+	if (val) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	return 0;
+	/* Only allow userspace to change the idregs before VM running */
+	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {
+		if (sval != read_id_reg(vcpu, rd))
+			ret = -EBUSY;
+	} else {
+		IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
+	}
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1479,7 +1487,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 *val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+
+	mutex_lock(&arch->config_lock);
 	*val = read_id_reg(vcpu, rd);
+	mutex_unlock(&arch->config_lock);
+
 	return 0;
 }
 
@@ -3364,6 +3377,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	const struct sys_reg_desc *idreg;
 	struct sys_reg_params params;
+	u64 val;
 	u32 id;
 
 	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
@@ -3386,6 +3400,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 		idreg++;
 		id = reg_to_encoding(idreg);
 	}
+
+	/*
+	 * The default is to expose CSV2 == 1 if the HW isn't affected.
+	 * Although this is a per-CPU feature, we make it global because
+	 * asymmetric systems are just a nuisance.
+	 *
+	 * Userspace can override this as long as it doesn't promise
+	 * the impossible.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
+
+	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
+	}
+	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
+		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
+	}
+
+	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
 }
 
 int __init kvm_sys_reg_table_init(void)
-- 
2.40.1.606.ga4b1b128d6-goog

