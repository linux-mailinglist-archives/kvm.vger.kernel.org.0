Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3867776B880
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 17:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbjHAPUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 11:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbjHAPUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 11:20:34 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6D01FE5
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 08:20:32 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-686b7576e2bso4107352b3a.0
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 08:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903232; x=1691508032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOQlfrEkHv1KCOutWxQMHSJN66sEWJdKLL9dkLR+1ns=;
        b=stgrN/8lEG7lHfIRWXmkIbC/TYvN3Ec8d7DCfau4GYKROo2q5gQ8DB2dGt/6E0QbSt
         4qWt8fE5KrsdhepuUqVbE5Tocc7S+QkYzJKZqBdi70arhp0X7KuQmvm697yQLTge9+xU
         wuFCGJpXVtHZoWlXzphXAH3xFY1uuqo36T8rkk99rEfgDk3ItVsOTPlygIacOLHBUMLX
         vooDlJrDDP5GtYcUa02FDQHAA6C9Jb6Z/XwEUowUVSOHvF6jSGgq4t4u2rGUabKwltQV
         XEtmHb6iurrHOxfa5gN3zGP/LUnC0/QHCQfP9AaWAERdIHxj95+5Dx0RTIWsN49tSG6D
         cIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903232; x=1691508032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOQlfrEkHv1KCOutWxQMHSJN66sEWJdKLL9dkLR+1ns=;
        b=lKWODaK9m84KTrA6cSALXEKyOenDoYrJ4fYk5BFJW0UPoybIWm26HSarJ3ZA93kmAe
         lItW1qey3Pneewi4JmqdoDvWf0PJbvjHjuCGRe+cTktDE8NkuEn6NPW7UOomUIbgvW4J
         oLV9XeKUtm8inBfsH/Ye8sOOsK1kZoArCnJy8ckdHxqKvO2Z3dHde7KFGAC/ovRvIfmO
         Aa758HjbEbzhC2mb+doJ8BHGjEbdA384ur9XOusY8ZOPvkb0DVeoT/c73J44CO2SEwL9
         KohQPd2g3hOTqcgPyj6z2CxbdZDIy4d1Q57Vky795jDniR2FEjeA1QVZbLZ7nVZH5Vz7
         tAhQ==
X-Gm-Message-State: ABy/qLYfWnWJ9pRLJ7yF+7LrDdRwXYmql9O++bhjczzq1pa9cLzHgoTM
        KNb0LRnoYj91MWysxlFJnQxT1+rellFwylhF3pK4bqAwZ8Ubmi/g6WoDnyXklyxxe4G7QZ6mdBJ
        mRo56HC43yAGF3atOvWZIQ6T/W+52zZtlpv0PVHs6FNZ4sZPlTV1w5W1plEupTzo+s3lEdbo=
X-Google-Smtp-Source: APBJJlFFBkYQ1vkD4oIJI0bUuuUsibxWCIoQEvfrCGbX9RzxI2lXuU6m0Tl630XabSncC86BH+p9ibmVyEWQk7B5sA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2e07:b0:686:2b60:3361 with
 SMTP id fc7-20020a056a002e0700b006862b603361mr106830pfb.4.1690903231621; Tue,
 01 Aug 2023 08:20:31 -0700 (PDT)
Date:   Tue,  1 Aug 2023 08:20:06 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-11-jingzhangos@google.com>
Subject: [PATCH v7 10/10] KVM: arm64: selftests: Test for setting ID register
 from usersapce
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests to verify setting ID registers from userapce is handled
correctly by KVM. Also add a test case to use ioctl
KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS to get writable masks.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/arch/arm64/include/uapi/asm/kvm.h       |  25 +++
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 191 ++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index f7ddd73a8c0f..2970c0d792ee 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -505,6 +505,31 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/* Get feature ID registers userspace writable mask. */
+/*
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all R/O registers that indicate anything useful feature
+ * wise, including the ID registers.
+ */
+#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+struct feature_id_writable_masks {
+	__u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f089ab290978..9abe69cf4001 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1555,6 +1555,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS \
+			_IOR(KVMIO,  0xb6, struct kvm_arm_feature_id_masks)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..87ceadc1292a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -144,6 +144,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/set_id_regs
 TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
new file mode 100644
index 000000000000..9c8f439ac7b3
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * set_id_regs - Test for setting ID register from usersapce.
+ *
+ * Copyright (c) 2023 Google LLC.
+ *
+ *
+ * Test that KVM supports setting ID registers from userspace and handles the
+ * feature set correctly.
+ */
+
+#include <stdint.h>
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include <linux/bitfield.h>
+
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffsl(_mask) - 1))
+#define field_prep(_mask, _val) (((_val) << (ffsl(_mask) - 1)) & (_mask))
+
+struct reg_feature {
+	uint64_t reg;
+	uint64_t ftr_mask;
+};
+
+static void guest_code(void)
+{
+	for (;;)
+		GUEST_SYNC(0);
+}
+
+static struct reg_feature lower_safe_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL3) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_FGT) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR1_PAN) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR2_FWB) },
+};
+
+static void test_user_set_lower_safe(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = lower_safe_reg_ftrs + i;
+		uint64_t val, new_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+
+		/* Set a safe value for the feature */
+		if (ftr > 0)
+			ftr--;
+
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+
+		vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &new_val);
+		ASSERT_EQ(new_val, val);
+	}
+}
+
+static void test_user_set_fail(struct kvm_vcpu *vcpu)
+{
+	int i, r;
+
+	for (i = 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = lower_safe_reg_ftrs + i;
+		uint64_t val, old_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+
+		/* Set a invalid value (too big) for the feature */
+		if (ftr >= GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0))
+			continue;
+		ftr++;
+
+		old_val = val;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+	}
+}
+
+static struct reg_feature exact_reg_ftrs[] = {
+	/* Items will be added when there is appropriate field of type
+	 * FTR_EXACT enabled writing from userspace later.
+	 */
+};
+
+static void test_user_set_exact(struct kvm_vcpu *vcpu)
+{
+	int i, r;
+
+	for (i = 0; i < ARRAY_SIZE(exact_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = exact_reg_ftrs + i;
+		uint64_t val, old_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+		old_val = val;
+
+		/* Exact match */
+		vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+
+		/* Smaller value */
+		if (ftr > 0) {
+			ftr--;
+			val &= ~reg_ftr->ftr_mask;
+			val |= field_prep(reg_ftr->ftr_mask, ftr);
+			r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+			TEST_ASSERT(r < 0 && errno == EINVAL,
+				    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+			vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+			ASSERT_EQ(val, old_val);
+			ftr++;
+		}
+
+		/* Bigger value */
+		ftr++;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+	}
+}
+
+static uint32_t writable_regs[] = {
+	SYS_ID_DFR0_EL1,
+	SYS_ID_AA64DFR0_EL1,
+	SYS_ID_AA64PFR0_EL1,
+	SYS_ID_AA64MMFR0_EL1,
+	SYS_ID_AA64MMFR1_EL1,
+	SYS_ID_AA64MMFR2_EL1,
+};
+
+void test_user_get_writable_masks(struct kvm_vm *vm)
+{
+	struct feature_id_writable_masks masks;
+
+	vm_ioctl(vm, KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS, &masks);
+
+	for (int i = 0; i < ARRAY_SIZE(writable_regs); i++) {
+		uint32_t reg = writable_regs[i];
+		int idx = ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(reg),
+				sys_reg_Op1(reg), sys_reg_CRn(reg),
+				sys_reg_CRm(reg), sys_reg_Op2(reg));
+
+		ASSERT_EQ(masks.mask[idx], GENMASK_ULL(63, 0));
+	}
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	ksft_print_header();
+	ksft_set_plan(4);
+
+	test_user_get_writable_masks(vm);
+	ksft_test_result_pass("test_user_get_writable_masks\n");
+
+	test_user_set_exact(vcpu);
+	ksft_test_result_pass("test_user_set_exact\n");
+
+	test_user_set_fail(vcpu);
+	ksft_test_result_pass("test_user_set_fail\n");
+
+	test_user_set_lower_safe(vcpu);
+	ksft_test_result_pass("test_user_set_lower_safe\n");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.41.0.585.gd2178a4bd4-goog

