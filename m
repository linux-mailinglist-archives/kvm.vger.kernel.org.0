Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9729A6D39DB
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjDBSiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 14:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjDBSiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 14:38:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D39014
        for <kvm@vger.kernel.org>; Sun,  2 Apr 2023 11:37:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so26857420ybw.13
        for <kvm@vger.kernel.org>; Sun, 02 Apr 2023 11:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680460679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+3V14Sr2+1lCIh3sH1nXbek8TQF8lGQd6t0XW5kdx0=;
        b=W74IGaA6QUP8FKkEcjGqUzRt+vWF7gCkK0EAIcHTziobmcyarumGHKyu8BNeLE3Kq0
         7Be9z4vnIzSz5s6otL6NI4AJasE7J9mhUjMKhtF7Zjj2fVg5Y/u+qairdP5q+FvCpery
         oV9WeT+dc58Lnw0u7ESqbWA+RfhPcNqnzKhW+gNY9Tku3M9MV8VFKOw2J38tU71WsRdW
         dKuq0ZGHccdjO61depB3wDcKVwkJ4pxLbV6JI5DmGuzOOu46xmdtONtPk1BPibVNw2xA
         OzN2AGLe2xo9Fb/4F+cc2HUWuqpBisbfbHAbaGdFXqI8JVs0kK2hzW46c271Spt1XVQB
         VIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680460679;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+3V14Sr2+1lCIh3sH1nXbek8TQF8lGQd6t0XW5kdx0=;
        b=490yUul3wJt2MY5bA8pHBuRhiOk4Sqx52FH0G1p7FXS1jwT5UfZ/LolWRPwnnIMkKJ
         ud7zGAI71Hc4APZ1ERRsTCfvlUD5gkEZOHCpsbZ6IOCesZzU6MMmRYpS/vZwKB59fTL8
         PQIrnzD9+9sB72eP29C4+81rOAkAxiU13/r8a0URSAwy5EsDK7au3cxgi8+pcZ0vOJgK
         EFv2OBVOfnaIlo/Q+WOM7Ka0L4elqNVLcsR4sRAZSZmcNU7ncJqT0D4N+VzWbT14MFEx
         ylrQ2ZJuwnUJcKT8MGTalzIPUjQx6fqZtwMJOIUmQFFvJXBsA+cvlVTgKH1dxpxrH0CH
         He5Q==
X-Gm-Message-State: AAQBX9fnAldmfScpmYrtlzkMxUuQK0FDW92/JTfs3CofMuf/HEV5HEYf
        azZuF/AKbqSNjQdrrwOBdhHl6saC46QYqbUWTmyr46kDUmk9b3doBTz0f5VEqlJdFMROhsstUpd
        xTSjVBFk8YAW5GpTw0HAMu+aLr0Wnrlnq/uQTJB8zbjHDStRuW4nTgqpBuf66S0N3EOYdHM4=
X-Google-Smtp-Source: AKy350ZRbPyLsghYCHvOMRh1Ua+yVMkWfHoSelFjdtLZ5hlHjkJrbfTAstEdGGOlLhumftRMOAkSa1Zmi4OThk/OfQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:344:0:b0:b27:4632:f651 with SMTP
 id 65-20020a250344000000b00b274632f651mr16006329ybd.3.1680460679072; Sun, 02
 Apr 2023 11:37:59 -0700 (PDT)
Date:   Sun,  2 Apr 2023 18:37:34 +0000
In-Reply-To: <20230402183735.3011540-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230402183735.3011540-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230402183735.3011540-6-jingzhangos@google.com>
Subject: [PATCH v5 5/6] KVM: arm64: Introduce ID register specific descriptor
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

Introduce an ID feature register specific descriptor to include ID
register specific fields and callbacks besides its corresponding
general system register descriptor.

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c  | 233 ++++++++++++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c |   2 +-
 arch/arm64/kvm/sys_regs.h |   1 +
 3 files changed, 178 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index e92eacb0ad32..af86001e2686 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -18,6 +18,27 @@
 
 #include "sys_regs.h"
 
+struct id_reg_desc {
+	const struct sys_reg_desc	reg_desc;
+	/*
+	 * ftr_bits points to the feature bits array defined in cpufeature.c for
+	 * writable CPU ID feature register.
+	 */
+	const struct arm64_ftr_bits *ftr_bits;
+	/*
+	 * Only bits with 1 are writable from userspace.
+	 * This mask might not be necessary in the future whenever all ID
+	 * registers are enabled as writable from userspace.
+	 */
+	const u64 writable_mask;
+	/*
+	 * This function returns the KVM sanitised register value.
+	 * The value would be the same as the host kernel sanitised value if
+	 * there is no KVM sanitisation for this id register.
+	 */
+	u64 (*read_kvm_sanitised_reg)(const struct id_reg_desc *idr);
+};
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
@@ -193,6 +214,11 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
 	return id_visibility(vcpu, r);
 }
 
+static u64 general_read_kvm_sanitised_reg(const struct id_reg_desc *idr)
+{
+	return read_sanitised_ftr_reg(reg_to_encoding(&idr->reg_desc));
+}
+
 static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
@@ -328,21 +354,31 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
+#define ID_SANITISED(name) {						\
+	.reg_desc = {							\
+		SYS_DESC(SYS_##name),					\
+		.access	= access_id_reg,				\
+		.get_user = get_id_reg,					\
+		.set_user = set_id_reg,					\
+		.visibility = id_visibility,				\
+	},								\
+	.ftr_bits = NULL,						\
+	.writable_mask = 0,						\
+	.read_kvm_sanitised_reg = general_read_kvm_sanitised_reg,	\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
+#define AA32_ID_SANITISED(name) {					\
+	.reg_desc = {							\
+		SYS_DESC(SYS_##name),					\
+		.access	= access_id_reg,				\
+		.get_user = get_id_reg,					\
+		.set_user = set_id_reg,					\
+		.visibility = aa32_id_visibility,			\
+	},								\
+	.ftr_bits = NULL,						\
+	.writable_mask = 0,						\
+	.read_kvm_sanitised_reg = general_read_kvm_sanitised_reg,	\
 }
 
 /*
@@ -350,12 +386,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
  * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
  * (1 <= crm < 8, 0 <= Op2 < 8).
  */
-#define ID_UNALLOCATED(crm, op2) {			\
-	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
-	.access = access_id_reg,			\
-	.get_user = get_id_reg,				\
-	.set_user = set_id_reg,				\
-	.visibility = raz_visibility			\
+#define ID_UNALLOCATED(crm, op2) {				\
+	.reg_desc = {						\
+		Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
+		.access = access_id_reg,			\
+		.get_user = get_id_reg,				\
+		.set_user = set_id_reg,				\
+		.visibility = raz_visibility			\
+	},							\
+	.ftr_bits = NULL,					\
+	.writable_mask = 0,					\
+	.read_kvm_sanitised_reg = NULL,				\
 }
 
 /*
@@ -363,15 +404,20 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
  * For now, these are exposed just like unallocated ID regs: they appear
  * RAZ for the guest.
  */
-#define ID_HIDDEN(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access = access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = raz_visibility,		\
+#define ID_HIDDEN(name) {				\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access = access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = raz_visibility,		\
+	},						\
+	.ftr_bits = NULL,				\
+	.writable_mask = 0,				\
+	.read_kvm_sanitised_reg = NULL,			\
 }
 
-static const struct sys_reg_desc id_reg_descs[] = {
+static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
 	 * entries in arm64_ftr_regs[].
@@ -381,9 +427,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
 	/* CRm=1 */
 	AA32_ID_SANITISED(ID_PFR0_EL1),
 	AA32_ID_SANITISED(ID_PFR1_EL1),
-	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
-	  .visibility = aa32_id_visibility, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_DFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_dfr0_el1,
+		.visibility = aa32_id_visibility, },
+	},
 	ID_HIDDEN(ID_AFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR0_EL1),
 	AA32_ID_SANITISED(ID_MMFR1_EL1),
@@ -412,8 +462,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
 	/* AArch64 ID registers */
 	/* CRm=4 */
-	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_AA64PFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_aa64pfr0_el1, },
+	},
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4, 2),
 	ID_UNALLOCATED(4, 3),
@@ -423,8 +477,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 	ID_UNALLOCATED(4, 7),
 
 	/* CRm=5 */
-	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
-	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
+	{ .reg_desc = {
+		SYS_DESC(SYS_ID_AA64DFR0_EL1),
+		.access = access_id_reg,
+		.get_user = get_id_reg,
+		.set_user = set_id_aa64dfr0_el1, },
+	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5, 2),
 	ID_UNALLOCATED(5, 3),
@@ -454,6 +512,17 @@ static const struct sys_reg_desc id_reg_descs[] = {
 	ID_UNALLOCATED(7, 7),
 };
 
+static const struct sys_reg_desc *id_params_to_desc(struct sys_reg_params *params)
+{
+	u32 id;
+
+	id = reg_to_encoding(params);
+	if (is_id_reg(id))
+		return &id_reg_descs[IDREG_IDX(id)].reg_desc;
+
+	return NULL;
+}
+
 /**
  * emulate_id_reg - Emulate a guest access to an AArch64 CPU ID feature register
  * @vcpu: The VCPU pointer
@@ -465,9 +534,9 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 {
 	const struct sys_reg_desc *r;
 
-	r = find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	r = id_params_to_desc(params);
 
-	if (likely(r)) {
+	if (r) {
 		perform_access(vcpu, params, r);
 	} else {
 		print_sys_reg_msg(params,
@@ -481,32 +550,91 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	return kvm_sys_reg_get_user(vcpu, reg,
-				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	u64 val;
+	int ret;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+
+	r = id_params_to_desc(&params);
+	if (!r)
+		return -ENOENT;
+
+	if (r->get_user) {
+		ret = (r->get_user)(vcpu, r, &val);
+	} else {
+		ret = 0;
+		val = IDREG(vcpu->kvm, reg_to_encoding(r));
+	}
+
+	if (!ret)
+		ret = put_user(val, uaddr);
+
+	return ret;
 }
 
 int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	return kvm_sys_reg_set_user(vcpu, reg,
-				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	u64 val;
+	int ret;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+
+	r = id_params_to_desc(&params);
+	if (!r)
+		return -ENOENT;
+
+	if (get_user(val, uaddr))
+		return -EFAULT;
+
+	if (sysreg_user_write_ignore(vcpu, r))
+		return 0;
+
+	if (r->set_user) {
+		ret = (r->set_user)(vcpu, r, val);
+	} else {
+		WARN_ONCE(1, "ID register set_user callback is NULL\n");
+		ret = 0;
+	}
+
+	return ret;
 }
 
 bool kvm_arm_check_idreg_table(void)
 {
-	return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs), false);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
+		const struct sys_reg_desc *r = &id_reg_descs[i].reg_desc;
+
+		if (!is_id_reg(reg_to_encoding(r))) {
+			kvm_err("id_reg table %pS entry %d not set correctly\n",
+				&id_reg_descs[i].reg_desc, i);
+			return false;
+		}
+	}
+
+	return true;
 }
 
 int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 {
-	const struct sys_reg_desc *i2, *end2;
+	const struct id_reg_desc *i2, *end2;
 	unsigned int total = 0;
 	int err;
 
 	i2 = id_reg_descs;
 	end2 = id_reg_descs + ARRAY_SIZE(id_reg_descs);
 
-	while (i2 != end2) {
-		err = walk_one_sys_reg(vcpu, i2++, &uind, &total);
+	for (; i2 != end2; i2++) {
+		err = walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &total);
 		if (err)
 			return err;
 	}
@@ -524,21 +652,12 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	u64 val;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
-		id = reg_to_encoding(&id_reg_descs[i]);
-		if (WARN_ON_ONCE(!is_id_reg(id)))
-			/* Shouldn't happen */
-			continue;
-
-		/*
-		 * Some hidden ID registers which are not in arm64_ftr_regs[]
-		 * would cause warnings from read_sanitised_ftr_reg().
-		 * Skip those ID registers to avoid the warnings.
-		 */
-		if (id_reg_descs[i].visibility == raz_visibility)
-			/* Hidden or reserved ID register */
-			continue;
-
-		val = read_sanitised_ftr_reg(id);
+		id = reg_to_encoding(&id_reg_descs[i].reg_desc);
+
+		val = 0;
+		if (id_reg_descs[i].read_kvm_sanitised_reg)
+			val = id_reg_descs[i].read_kvm_sanitised_reg(&id_reg_descs[i]);
+
 		IDREG(kvm, id) = val;
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3af9f85aa976..1d7fb0acf154 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2541,7 +2541,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
  * Userspace API
  *****************************************************************************/
 
-static bool index_to_params(u64 id, struct sys_reg_params *params)
+bool index_to_params(u64 id, struct sys_reg_params *params)
 {
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U64:
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 326ca28c1117..15a0a1e2fe99 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -223,6 +223,7 @@ static inline bool is_id_reg(u32 id)
 
 void perform_access(struct kvm_vcpu *vcpu, struct sys_reg_params *params,
 		    const struct sys_reg_desc *r);
+bool index_to_params(u64 id, struct sys_reg_params *params);
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.40.0.348.gf938b09366-goog

