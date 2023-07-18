Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33CC758260
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjGRQpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjGRQpk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 12:45:40 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419A110F1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:39 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-573d70da2dcso53367427b3.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 09:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689698738; x=1692290738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=UgpR3zd8Vwdo9jKsFeX+C8lfGVgsHVsC93K4Srj+qwQBEmH4IbeK9gCIxkC2gkmyzF
         sVYc7CatQ4EcZD82XuyUrFD/d8AsOlh52qlFYCTLHGf2FcZEBLtW7Sw3ZTAx2xSxCvkj
         gKoiKRD5CQzXa7Y9oLNTgyZBNgau9c9v4bZyYcZPXwjFYABruk+nl92hUHkVeXFlY3dX
         6wPEyCuU75lk5fLn0FGaX4rur/c8ZRuSrfqpq6s8rDvsYwlr9xzXiBcBZd1uZhKMQ6Oi
         efspitsNXWraehwYFLxevmEQMMUOTGFO/rsSshN/hvf5ThmySgFOQVR67x/lXMsTaMyJ
         GmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689698738; x=1692290738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=UDiLgncf/tfC29JeM/8kCAWxi3h3ti2sy80pw3QP/TepwZPbUM1ZdonXEy1/kHYyTq
         OG8x6IySaTll1xnOq6SrjtSS5tW+EmubF+f//LixDKbuW2jHdl5TDohYJ/dldl6nSLCD
         kfPGVvzVvUbt14zrOzUAEuuyTPOB8iXBvZtdTNjW8KqEiuqY2jewvT/Mf17cZeySeJK1
         A+u/Nkaczn07GPlV5n6QgFg7nEspVF1ovoqJNt7oyStxQ9bcvCaxDvWbsH0PNDZS8oZl
         0PZRE+DdBUuJ0kMVwOEQpqgc3xVs3HePxLkJu/+LWiTFSXWsenyeMB3hrHc7joetrGtg
         Dwrw==
X-Gm-Message-State: ABy/qLaLFg+8rw0kq2uQcZnVuhvBG/kmPswzku63o/hba2c+dUCw4YMw
        W61NhtrDbpsfPq9YIIGDYhu/MN3+jJScj4aXsV+exXM0aXmJ/mseWJYitAlKOzsSfiucBP1xbW+
        j1FIm30f6FxXIsThUKAlWZlMctwwLql1IKJDT2SFJnbWPOnZPsbayOSBDACoBBo+bAATKZbY=
X-Google-Smtp-Source: APBJJlFQfOABzqiiF7DAq8fLGdHU4mtWhNKbQb0rOFTg9K46DQvwrbM/DePnnn41SzrwvpIZDYuIXA5dFNd5TFmZVA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:b70d:0:b0:581:7b58:5e70 with SMTP
 id v13-20020a81b70d000000b005817b585e70mr3233ywh.5.1689698738270; Tue, 18 Jul
 2023 09:45:38 -0700 (PDT)
Date:   Tue, 18 Jul 2023 16:45:22 +0000
In-Reply-To: <20230718164522.3498236-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718164522.3498236-7-jingzhangos@google.com>
Subject: [PATCH v6 6/6] KVM: arm64: selftests: Test for setting ID register
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test to verify setting ID registers from userapce is handled
correctly by KVM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 2 files changed, 164 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c

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
index 000000000000..e2242ef36bab
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -0,0 +1,163 @@
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
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
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
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1), ARM64_FEATURE_MASK(ID_DFR0_COPDBG) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL3) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4) },
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
+static struct reg_feature exact_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER) },
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
+		if (ftr > 0)
+			ftr--;
+		val &= ~reg_ftr->ftr_mask;
+		val |= field_prep(reg_ftr->ftr_mask, ftr);
+		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
+		TEST_ASSERT(r < 0 && errno == EINVAL,
+			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ASSERT_EQ(val, old_val);
+
+		/* Bigger value */
+		ftr += 2;
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
+static struct reg_feature fail_reg_ftrs[] = {
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_DFR0_EL1), ARM64_FEATURE_MASK(ID_DFR0_MPROFDBG) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL2) },
+	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64) },
+};
+
+static void test_user_set_fail(struct kvm_vcpu *vcpu)
+{
+	int i, r;
+
+	for (i = 0; i < ARRAY_SIZE(fail_reg_ftrs); i++) {
+		struct reg_feature *reg_ftr = fail_reg_ftrs + i;
+		uint64_t val, old_val, ftr;
+
+		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
+		ftr = field_get(reg_ftr->ftr_mask, val);
+
+		/* Set a invalid value (too big) for the feature */
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
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	test_user_set_lower_safe(vcpu);
+	ksft_test_result_pass("test_user_set_lower_safe\n");
+
+	test_user_set_exact(vcpu);
+	ksft_test_result_pass("test_user_set_exact\n");
+
+	test_user_set_fail(vcpu);
+	ksft_test_result_pass("test_user_set_fail\n");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.41.0.255.g8b1d071c50-goog

