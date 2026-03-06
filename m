Return-Path: <kvm+bounces-73110-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MJgKKoKq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73110-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:11:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 84744225B01
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5D129303BF72
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF5441C0C6;
	Fri,  6 Mar 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkRgzD6b"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9E53FD13C;
	Fri,  6 Mar 2026 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817000; cv=none; b=PIr8VlP80Jg04cuPz0mwfNcORXCY/w85QVJVj+XrLcA4DFY4HM+qr06SVGm45/+X+cAzl4JAsB9qsZDIjNllPQ6tBhF25qMj/cw/X/hZqP5iur+pWwogjFcayrEmKCHDMTXcCMoWf00lxM/hmC6QhJA2uak28zp9sGcQQVSm2+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817000; c=relaxed/simple;
	bh=f0y3ZrqdfWVPI/Jsnnhbn6AtnKCJ+CtCh3h35iuBQCM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L9OFcKCiAKbGEs2nvUmZYYN/5Xb0i3/MDw7wMyA2mJPI7mE/Poa5Z4ObHewQsKufS/APYwzDkG5xXlDHAimgoewhAnGr/onrvTTCOHWeG4H3OQyfdmAbYxa+TKOSwVs84/jwNW1+Jd9KWNQDSmO0Kp+Dt98EQE/pl913oXBRfg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkRgzD6b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A8C4CEF7;
	Fri,  6 Mar 2026 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817000;
	bh=f0y3ZrqdfWVPI/Jsnnhbn6AtnKCJ+CtCh3h35iuBQCM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YkRgzD6b7pjsL/uTiNW3Fh+qFqxXf59o0kHrEx8XiLvkAUbf3t5oCySw/hK47y2O0
	 Ta/UqJP3exDa2aGUB78euP4xSKwHhbQgolgaI1A/4C0SJwc38L3JqAx7Du1DEd959p
	 F5VoDpkgb7D/3UDrdb29/B1jMK0fG4bErfUNihED5FAtlLghFbBvuH9ETSrBHM6GYL
	 ssR5cWJLG+rsLl6jzFQ5Hxv2hr0L0cXvX384Hxe0UvAckU8N8OLy5Ja8qrLLAlQZLu
	 KawzRsw668pkwegd+MiZS8ZltcNe4Ps8QN8Ej+KZm6HSsqoF2Rc4v/y23AQuToyvQ5
	 mzUNZmwqGYKFQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:00 +0000
Subject: [PATCH v10 08/30] KVM: arm64: Rename SVE finalization constants to
 be more general
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-8-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=7266; i=broonie@kernel.org;
 h=from:subject:message-id; bh=f0y3ZrqdfWVPI/Jsnnhbn6AtnKCJ+CtCh3h35iuBQCM=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwou1FPKpniXenBABFoKrKVWGqIIrJo4jB4G6
 54/77FT4xaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKLgAKCRAk1otyXVSH
 0B3LB/wLbXV1VxRQ/1il2H8ETlbxoETQ0GEdfSBbiK8fjb6jP4TUqxpH0mGi1MDLrbHGJCJ2fXe
 MaHMZB098RuCCB9z0u8G4pffojlkGDkZZLhUkySfIwyE73GEagcdDhMHXC9E3IHbJen6pZo9er5
 +Lw6qsLn0+0YXdIZBt5Kl0t91ZT0kOj3v7zN4svOIp8vuDjYwntIjJduw77vvzrAZoxjZ49pX4k
 /e3AI/3pU3KcD2INMD5pl7LI1CZ8SF9Ieex3G6o0tta/qXZsf81jWBDkq7uKF3m+20kX381ed1j
 rlGc/nqDi0g0nFAWcahENLRydBhjy7utulis9o9OrNgBO9vB
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 84744225B01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73110-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.909];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Due to the overlap between SVE and SME vector length configuration
created by streaming mode SVE we will finalize both at once.  Rename the
existing finalization to use _VEC (vector) for the naming to avoid
confusion.

Since this includes the userspace API we create an alias
KVM_ARM_VCPU_VEC for the existing KVM_ARM_VCPU_SVE capability, existing
code which does not enable SME will be unaffected and any SME only code
will not need to use SVE constants.

No functional change.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  8 +++++---
 arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
 arch/arm64/kvm/guest.c            | 10 +++++-----
 arch/arm64/kvm/hyp/nvhe/pkvm.c    |  2 +-
 arch/arm64/kvm/reset.c            | 20 ++++++++++----------
 5 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3e7247b3890c..656464179ba8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1012,8 +1012,8 @@ struct kvm_vcpu_arch {
 
 /* KVM_ARM_VCPU_INIT completed */
 #define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
-/* SVE config completed */
-#define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
+/* Vector config completed */
+#define VCPU_VEC_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
 /* pKVM VCPU setup completed */
 #define VCPU_PKVM_FINALIZED	__vcpu_single_flag(cflags, BIT(2))
 
@@ -1086,6 +1086,8 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu)	kvm_has_sve((vcpu)->kvm)
 #endif
 
+#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
+
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
 	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
@@ -1482,7 +1484,7 @@ struct kvm *kvm_arch_alloc_vm(void);
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
+#define kvm_arm_vcpu_vec_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_VEC_FINALIZED)
 
 #define kvm_has_mte(kvm)					\
 	(system_supports_mte() &&				\
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index a792a599b9d6..c67564f02981 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -107,6 +107,12 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 
+/*
+ * An alias for _SVE since we finalize VL configuration for both SVE and SME
+ * simultaneously.
+ */
+#define KVM_ARM_VCPU_VEC		KVM_ARM_VCPU_SVE
+
 struct kvm_vcpu_init {
 	__u32 target;
 	__u32 features[7];
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1c87699fd886..d15aa2da1891 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -342,7 +342,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
 
-	if (kvm_arm_vcpu_sve_finalized(vcpu))
+	if (kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM; /* too late! */
 
 	if (WARN_ON(vcpu->arch.sve_state))
@@ -497,7 +497,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (ret)
 		return ret;
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
 	if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
@@ -523,7 +523,7 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (ret)
 		return ret;
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu))
+	if (!kvm_arm_vcpu_vec_finalized(vcpu))
 		return -EPERM;
 
 	if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
@@ -599,7 +599,7 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
 	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
 		+ 1; /* KVM_REG_ARM64_SVE_VLS */
@@ -617,7 +617,7 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 		return 0;
 
 	/* Policed by KVM_GET_REG_LIST: */
-	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
+	WARN_ON(!kvm_arm_vcpu_vec_finalized(vcpu));
 
 	/*
 	 * Enumerate this first, so that userspace can save/restore in
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2f029bfe4755..24acbe5594e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -445,7 +445,7 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	int ret = 0;
 
 	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
-		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
+		vcpu_clear_flag(vcpu, VCPU_VEC_FINALIZED);
 		return 0;
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..f7c63e145d54 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -92,7 +92,7 @@ static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
  * Finalize vcpu's maximum SVE vector length, allocating
  * vcpu->arch.sve_state as necessary.
  */
-static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
+static int kvm_vcpu_finalize_vec(struct kvm_vcpu *vcpu)
 {
 	void *buf;
 	unsigned int vl;
@@ -122,21 +122,21 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	}
 	
 	vcpu->arch.sve_state = buf;
-	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
+	vcpu_set_flag(vcpu, VCPU_VEC_FINALIZED);
 	return 0;
 }
 
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 {
 	switch (feature) {
-	case KVM_ARM_VCPU_SVE:
-		if (!vcpu_has_sve(vcpu))
+	case KVM_ARM_VCPU_VEC:
+		if (!vcpu_has_vec(vcpu))
 			return -EINVAL;
 
-		if (kvm_arm_vcpu_sve_finalized(vcpu))
+		if (kvm_arm_vcpu_vec_finalized(vcpu))
 			return -EPERM;
 
-		return kvm_vcpu_finalize_sve(vcpu);
+		return kvm_vcpu_finalize_vec(vcpu);
 	}
 
 	return -EINVAL;
@@ -144,7 +144,7 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
+	if (vcpu_has_vec(vcpu) && !kvm_arm_vcpu_vec_finalized(vcpu))
 		return false;
 
 	return true;
@@ -163,7 +163,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.ccsidr);
 }
 
-static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_reset_vec(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_has_sve(vcpu))
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
@@ -203,11 +203,11 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_put(vcpu);
 
-	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
+	if (!kvm_arm_vcpu_vec_finalized(vcpu)) {
 		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
 			kvm_vcpu_enable_sve(vcpu);
 	} else {
-		kvm_vcpu_reset_sve(vcpu);
+		kvm_vcpu_reset_vec(vcpu);
 	}
 
 	if (vcpu_el1_is_32bit(vcpu))

-- 
2.47.3


