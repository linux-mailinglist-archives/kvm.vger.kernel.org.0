Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC0D6BE076
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 06:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCQFG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 01:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQFGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 01:06:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C38B43904
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:53 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544b71b3114so25251137b3.13
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 22:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kgPyqr/q0gDjusIFoqgQanf7sMQvD/5tjY88iiTDhlM=;
        b=ZFCBze+qB5JYCJLS2SQzWoOfdda4KfdB2YskxmjjWfg/yMh6SMH40QDJqRESl4+4Su
         m+CTLZYl7hHVni0RDHzRg3ZzPtQkfo4d0F1RzQEeGJGWR6Q6AWoSo7Un91G/D7O5aMsc
         SXsh2TKxCoAKkMi0Zq1cfdPDcFtVTjxcfA9Nd4o9e7X8qDM94uAN6mDIRkDuQUVv/NmY
         bmQl3aU7yY1B+ms/rF8M93TUXqOS36cpYJiN+ubLzPFyfckWDXYYY1nlK7bAx41hEU6C
         Zz1GJ3Du/Wg4apaeHvBZLv83TZrpuaZfdZV3A14CfyUtUzyxmXHK1gDi5k0I0bcRu7QS
         udpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgPyqr/q0gDjusIFoqgQanf7sMQvD/5tjY88iiTDhlM=;
        b=8DBV6mS2F2hXdcTzY8K/vsaqEJdgAfGso0a7UQaU/wx7rm4jgV7dea4XnWJscqqzNc
         guXXSCNAh5GKYg1MMsU3Fs5skaA/gBp5n5tYVoMaIJyeWHhxrLhtqbz7bhZWH+61PCDk
         DVd8fSX7Bo6Dg6olfEHSzbma0p3R7TE26+Oi6JnXaJ52aEPPJE4S8tcz5Au6GnY7+unL
         6sdU8tuZI4dYMoZrXataFfj0oXHX3KYk3qijN+4lQRdl5Znn0hVyeeou3/YcDo6vCaXP
         gJrUHHg6i5l34FDRa41ByN6F917zQsGAz0So/75jMaXe7YSRUgioLSt+UmmkblKQX5yQ
         WKiA==
X-Gm-Message-State: AO0yUKXmKx3aKb+eZeEEevcFGaRoHMlN4VP0ju4QpZYYfC8so4WUI9W+
        GcHlAtO14RmilLQ40vw2JBcSY+TVK47ZMRPxh63K3DpGr0uJuPjBnWg/guQbW4KYsf2DEn14VMS
        QZRK1Pzqwsa+gpck6eCvOe3LZ3x3XT4BSWgKqXlgXZkEXnczvefdjeUHtE4fmHhzf9Ovu4OY=
X-Google-Smtp-Source: AK7set9SL0OqxX8wAftY2RxrewTvwJ+CVA9tvXCW9V/awmifb0L6/6gygUykXl79qiV803Q7QYhlafsmR60t/OGswg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:9888:0:b0:a88:ba7:59b with SMTP id
 l8-20020a259888000000b00a880ba7059bmr29687408ybo.9.1679029612446; Thu, 16 Mar
 2023 22:06:52 -0700 (PDT)
Date:   Fri, 17 Mar 2023 05:06:36 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-6-jingzhangos@google.com>
Subject: [PATCH v4 5/6] KVM: arm64: Introduce ID register specific descriptor
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

Introduce an ID feature register specific descriptor to include ID
register specific fields and callbacks besides its corresponding
general system register descriptor.
New fields for ID register descriptor would be added later when it
is necessary to support a writable ID register.

No functional change intended.

Co-developed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++-----------
 arch/arm64/kvm/sys_regs.c |   2 +-
 arch/arm64/kvm/sys_regs.h |   1 +
 3 files changed, 138 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 3a87a3d2390d..9956c99d20f7 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -18,6 +18,10 @@
 
 #include "sys_regs.h"
 
+struct id_reg_desc {
+	const struct sys_reg_desc	reg_desc;
+};
+
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
@@ -334,21 +338,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define ID_SANITISED(name) {			\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = id_visibility,		\
+#define ID_SANITISED(name) {				\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access	= access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = id_visibility,		\
+	},						\
 }
 
 /* sys_reg_desc initialiser for known cpufeature ID registers */
-#define AA32_ID_SANITISED(name) {		\
-	SYS_DESC(SYS_##name),			\
-	.access	= access_id_reg,		\
-	.get_user = get_id_reg,			\
-	.set_user = set_id_reg,			\
-	.visibility = aa32_id_visibility,	\
+#define AA32_ID_SANITISED(name) {			\
+	.reg_desc = {					\
+		SYS_DESC(SYS_##name),			\
+		.access	= access_id_reg,		\
+		.get_user = get_id_reg,			\
+		.set_user = set_id_reg,			\
+		.visibility = aa32_id_visibility,	\
+	},						\
 }
 
 /*
@@ -356,12 +364,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
 }
 
 /*
@@ -369,15 +379,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
 }
 
-static const struct sys_reg_desc id_reg_descs[] = {
+static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
 	 * entries in arm64_ftr_regs[].
@@ -387,9 +399,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -418,8 +434,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
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
@@ -429,8 +449,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -469,12 +493,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
  */
 int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
 {
-	const struct sys_reg_desc *r;
+	u32 id;
 
-	r = find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	id = reg_to_encoding(params);
 
-	if (likely(r)) {
-		perform_access(vcpu, params, r);
+	if (likely(is_id_reg(id))) {
+		perform_access(vcpu, params, &id_reg_descs[IDREG_IDX(id)].reg_desc);
 	} else {
 		print_sys_reg_msg(params,
 				  "Unsupported guest id_reg access at: %lx [%08lx]\n",
@@ -491,38 +515,102 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
 	unsigned long i;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++)
-		if (id_reg_descs[i].reset)
-			id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
+		if (id_reg_descs[i].reg_desc.reset)
+			id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_descs[i].reg_desc);
 }
 
 int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
-	return kvm_sys_reg_get_user(vcpu, reg,
-				    id_reg_descs, ARRAY_SIZE(id_reg_descs));
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	const struct sys_reg_desc *r;
+	struct sys_reg_params params;
+	u64 val;
+	int ret;
+	u32 id;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+	id = reg_to_encoding(&params);
+
+	if (!is_id_reg(id))
+		return -ENOENT;
+
+	r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
+	if (r->get_user) {
+		ret = (r->get_user)(vcpu, r, &val);
+	} else {
+		ret = 0;
+		val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
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
+	u32 id;
+
+	if (!index_to_params(reg->id, &params))
+		return -ENOENT;
+	id = reg_to_encoding(&params);
+
+	if (!is_id_reg(id))
+		return -ENOENT;
+
+	if (get_user(val, uaddr))
+		return -EFAULT;
+
+	r = &id_reg_descs[IDREG_IDX(id)].reg_desc;
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
@@ -540,12 +628,9 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	u64 val;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
-		id = reg_to_encoding(&id_reg_descs[i]);
-		if (WARN_ON_ONCE(!is_id_reg(id)))
-			/* Shouldn't happen */
-			continue;
+		id = reg_to_encoding(&id_reg_descs[i].reg_desc);
 
-		if (id_reg_descs[i].visibility == raz_visibility)
+		if (id_reg_descs[i].reg_desc.visibility == raz_visibility)
 			/* Hidden or reserved ID register */
 			continue;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3243c924527e..608a0378bdae 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2519,7 +2519,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
  * Userspace API
  *****************************************************************************/
 
-static bool index_to_params(u64 id, struct sys_reg_params *params)
+bool index_to_params(u64 id, struct sys_reg_params *params)
 {
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U64:
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index ee136ba28fa5..8fd0020c67ca 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -239,6 +239,7 @@ static inline bool is_id_reg(u32 id)
 
 void perform_access(struct kvm_vcpu *vcpu, struct sys_reg_params *params,
 		    const struct sys_reg_desc *r);
+bool index_to_params(u64 id, struct sys_reg_params *params);
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.40.0.rc1.284.g88254d51c5-goog

