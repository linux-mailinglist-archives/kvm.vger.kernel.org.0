Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D86A52EE
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 07:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjB1GXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 01:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjB1GXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 01:23:21 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E373125AF
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:19 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bbaeceeaso189416297b3.11
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 22:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hsnxwH3HlkdWJXjZ8A6A7W0Th8Htp6CqQw1NclxamXI=;
        b=HeBtcxckNYals4VqX4TJwaQ3NiAi2b3l9cE+nAKHwrdfzqBETgO71foJdR9nLI2U70
         Bw9YybL7aVzExnKc0UHOCts4zv/Or/QSHcQHWrvncmuTGmgirLbtgJLDKnD1soehNnQb
         la6tAA99cjG8POvV4764iu8b5W38RGw8zxbPXidmyNu4eFfjjbIZUQm7ikRwp53/ucEL
         RTsgqWulYi47L2jzSpMPvBttyUUU9UFKZCYTPzGw5SNnagCNsC/VzbsNAGU9AAc+G/cy
         D1TREbx6esHIFrV/SnrWQAO9EGx0cJh37fMyseIahFTUP8uuWuzG4RF+Gl3j0+y+BNTP
         7dzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hsnxwH3HlkdWJXjZ8A6A7W0Th8Htp6CqQw1NclxamXI=;
        b=OljJwzEk0Nm/34YMZEZB8f0BJWq/B9raukOik3qpcB6vMlRNdbRFdleJIF8yk2rUyu
         2opiiX2vdcKfPiAg5CcbD5K2tuKCVX/1wIaSNSmYxxkYhb8mMV/LzP65lIZnO6Bwi9AN
         0XSzk4mp0tIanAyJNFUiPl+qPQYJow5bF79F8cBTtxVx4332ZwzgCThVUYgJ1whHTOHp
         MZoQW4vbkjJhaPKK99svtwWqocUkyY0A4tUykDvxXpt9El0tsfK2L8YfDx4lGB/GlSp0
         oj7XRUIN7DU01aK40bR62GZStAC60Kk4b2F+zWbFj003hiCPX2HWer+rihw0YS4UBDL8
         6zJg==
X-Gm-Message-State: AO0yUKVC7YWAJQSHSGEJxugUF9W/WiS1PlFES/u9XvDshdnepA1Qdpn9
        XdWV/bmLywl7LBGNEJUjXUYW42uRrN41//uapRvEvsZCVVZ/ymcoJ13pFMA94JNcug0sMNTM+Di
        INg/bZPzQIAZQMcM2NlxPbfgJvEjcu622TQOXDNOkmbk2RKnHs2nb/J1vHzSvkxlTjx9vR+I=
X-Google-Smtp-Source: AK7set+bXEIqdkFU1yB7FFCeehq3jX191RFxT1juzbwTCekpIQj0ipoQfOlt3UzRhjBUslbDwUQO0mSmftfCHKyE2g==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a5b:a10:0:b0:87a:957b:fd67 with SMTP
 id k16-20020a5b0a10000000b0087a957bfd67mr774390ybq.10.1677565398291; Mon, 27
 Feb 2023 22:23:18 -0800 (PST)
Date:   Tue, 28 Feb 2023 06:22:45 +0000
In-Reply-To: <20230228062246.1222387-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228062246.1222387-6-jingzhangos@google.com>
Subject: [PATCH v3 5/6] KVM: arm64: Introduce ID register specific descriptor
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
 arch/arm64/kvm/id_regs.c  | 184 ++++++++++++++++++++++++++++----------
 arch/arm64/kvm/sys_regs.c |   2 +-
 arch/arm64/kvm/sys_regs.h |   1 +
 3 files changed, 138 insertions(+), 49 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 21ec8fc10d79..fc0dcd557cbb 100644
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
@@ -326,21 +330,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -348,12 +356,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -361,15 +371,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -379,9 +391,13 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -410,8 +426,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
 
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
@@ -421,8 +441,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -461,12 +485,12 @@ static const struct sys_reg_desc id_reg_descs[] = {
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
@@ -483,38 +507,102 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
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
+		val = IDREG(vcpu->kvm, id);
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
+		if (IDREG_IDX(reg_to_encoding(r)) != i) {
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
@@ -532,12 +620,12 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	u64 val;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
-		id = reg_to_encoding(&id_reg_descs[i]);
+		id = reg_to_encoding(&id_reg_descs[i].reg_desc);
 		if (WARN_ON_ONCE(!is_id_reg(id)))
 			/* Shouldn't happen */
 			continue;
 
-		if (id_reg_descs[i].visibility == raz_visibility)
+		if (id_reg_descs[i].reg_desc.visibility == raz_visibility)
 			/* Hidden or reserved ID register */
 			continue;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 568ebc0fb15c..7b63d9038639 100644
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
index 9231d89889c7..094a7f19d93f 100644
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
2.39.2.722.g9855ee24e9-goog

