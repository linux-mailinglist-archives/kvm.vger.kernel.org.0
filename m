Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19EE70CDAD
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjEVWSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbjEVWSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:18:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C7EAF
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:42 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1ae4ecb00feso36042725ad.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684793922; x=1687385922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/VrN2Ar+AOdWjfiYe/2nYRQITVL0veWRWCp7zOr2qyA=;
        b=rRVPR4tKxt43nlG+IuMkOLZRfyICGLMKSXLHPT1Qx704DFwmHi8y3V/jtWrcWQWyDa
         Jg7RAno6p7cTYfPopz/fP4DB4s1XWf1o5mwnPm2x+cgJzAYoGS0cVdkA03huXsbRTt16
         eB7Vi6DDXss9qKqpaClzs3Mb1MoOKxxiW8uNx3d0+WJv09ryABea+4IXSbc+MjpN6hAp
         4JBMpFryEKgYWK+S89VXuSAlusM6eGJE/IDZOCLBT1vpmJRF9kFZu9E3zt9ouZ995XyL
         Dd+CG5Nwffewy1PgXV7UKkiygvL/txsjlntDLImYdCwMGtwi8tGzgNH1Mu7CApfCv3QL
         xH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793922; x=1687385922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/VrN2Ar+AOdWjfiYe/2nYRQITVL0veWRWCp7zOr2qyA=;
        b=BN5o2l69bWo31JgJmW+RzDAEj+re/YbEz8S6zGP0SiWY9t+m9Ls3G8aq6O6oO5ezNW
         xs/+OoM5Of1Ktxbnyv0J6au08EVEm+5rK57nXGDJWB+PlhiJjNzjrU69s1NcTgpRmKb8
         EN/pDu3KhVkRRLf+sFlJpPPcjoyoyiUCZu16jiVrK8eYp5v5D8mXgPQ0kgbrQGnRqf6D
         Y9hwrn+sxi4gy8kXJqYVb5I0QCs7wIyRQR1DZs4OeizOkPYNXgoqLkJqEtb9/GZ5GJq7
         XJs1YlwrGpUruJgZ0tbRpKPnBKf5k8fzYPcfhmHr06BffW6eX7V2nhlNfnjxYD6/hY3i
         ARrg==
X-Gm-Message-State: AC+VfDwB7yST+RbfvtGWGSbTsGteEa3ME5Vhut4/RidxXJJXjDKcp3XQ
        Y6zk+MGwS352xk4McgIyqKmiTv8cugU6Nu7wG9otXWdE9h7rSkjW2GkcrldhmqVBtpeod6Rwq2U
        k1Hotyq/6AlrqvqCPiq/SC+NcB7lGRIzg4jsheFV4wHy+PE5u1Kuf9+az+C8wfsKI9hODaL8=
X-Google-Smtp-Source: ACHHUZ4HoO5hlOBsRNn24MoFNGIQjCDVVm3MB7aqK9lioRYeF9fvojdnGXslsxiJUFgurOBI1z0N7vVipd5ZsT5f9Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:33ce:b0:1ae:5bf5:1082 with
 SMTP id kc14-20020a17090333ce00b001ae5bf51082mr2854105plb.6.1684793922069;
 Mon, 22 May 2023 15:18:42 -0700 (PDT)
Date:   Mon, 22 May 2023 22:18:32 +0000
In-Reply-To: <20230522221835.957419-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230522221835.957419-3-jingzhangos@google.com>
Subject: [PATCH v10 2/5] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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
 arch/arm64/kvm/arm.c              | 17 ---------
 arch/arm64/kvm/sys_regs.c         | 58 +++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 069606170c82..8a2fde6c04c4 100644
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
index d2ee3a1c7f03..9fb1c2f8f5a5 100644
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
@@ -1359,7 +1355,11 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	u64 old_val = read_id_reg(vcpu, rd);
+	u64 new_val = val;
 	u8 csv2, csv3;
+	int ret = 0;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -1377,17 +1377,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
 		return -EINVAL;
 
+	mutex_lock(&arch->config_lock);
 	/* We can only differ with CSV[23], and anything else is an error */
-	val ^= read_id_reg(vcpu, rd);
+	val ^= old_val;
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
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (new_val != old_val)
+			ret = -EBUSY;
+	} else {
+		IDREG(vcpu->kvm, reg_to_encoding(rd)) = new_val;
+	}
+out:
+	mutex_unlock(&arch->config_lock);
+	return ret;
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
@@ -1479,7 +1488,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
 
@@ -3364,6 +3378,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 {
 	const struct sys_reg_desc *idreg;
 	struct sys_reg_params params;
+	u64 val;
 	u32 id;
 
 	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
@@ -3386,6 +3401,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
2.40.1.698.g37aff9b760-goog

