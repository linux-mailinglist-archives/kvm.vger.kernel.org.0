Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECCA7567ED
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjGQP2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjGQP2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:28:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6631FFC
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-cca32102e3cso1997687276.1
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689607655; x=1692199655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=fTXxWsjy2fj3dCWmJRB8+pKR7YU4HN+o9t5i1jBHWIJBIgftdCFVjLY8k4VscrgKeF
         ld9HfZWYnWiO8sb5cNjRhTqQawHEXObcC2T8tIBr/tpWy11reIeM0+fNz3LzlwhyfR37
         B3W/2mXFZ4L5gw6QcG0vrz+e/4jc5aPBX+xKVwJCowbNvb5VKZ7QIqX6zrrZi2cguE/R
         UZVeIOzMe/Y5CcT6hhqKuObMhL3ejfV1wFT1Te4JQmmdJxaxhMuFZhCQJrSeg7GZRnZa
         FhgqUn9WwQKpPowlFwJInFU8Dsu74nWx+6ITfR3uVeEcIfnW6rHTUeCYAglKAY1TdYt4
         z3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607655; x=1692199655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6NXlz6D/782SdBzr3IeFN6HXvUmoGCjaw12aI23xnw=;
        b=fIvZSHDf8UjW3gAuixThBzmn+UQZLd93HG81eSZt0lO9qjaUXCzgAQi8rMq5wfaijW
         nstQ1nj0haqKxwZ1tSE9PoD3ZuFIrQ8i2n+oIVJ+Mxz+XMWH+DwOzoIOIJXM+anVyC3z
         z9aCkq3yJ4TzmDdWxaKfhZdFgyc/W1Ujy44SDH9tUOfKCLLTzGxFSFMc30ktn++phetO
         llj6A6EbLp9rcsNEYmSuD9sidxPENeE8F/SEhDUAVFDuM48IIBqlK9lE2F967lQjFraI
         WqYfTd+BGnoNPZ0+sQ/QCMIETAf34FpyK99CboOP9VcX7AKsipSAaNDxkXMjE7f1OzQc
         zJzA==
X-Gm-Message-State: ABy/qLZ+vdBx4QRIIHHlsPaeANnSnePfrCalT1Bcb6ojtyXCyIet2G+H
        7YhMeaxoeq28gcdCyzfekSL1Dg4M3y0UrlIHHdaY0i+mON8haHvt/9pQjhc35UdS4K/666OzV3V
        zmNBv/lK8iKfk46AcSiIn9bE7raM3VlpQHuCet6zlByVLuI/jFn5/pEfLeNjE9ldNCeu1wgw=
X-Google-Smtp-Source: APBJJlF3cxpzVOg9LwCHj7hwb/mAEZR+Q9sZBO8IIoT23QelKe14r7txg0BFneGIB+3nZvq6vqm9qDaGYg8FYmDm5w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:50d4:0:b0:ca7:8c92:4f62 with SMTP
 id e203-20020a2550d4000000b00ca78c924f62mr117694ybb.9.1689607654579; Mon, 17
 Jul 2023 08:27:34 -0700 (PDT)
Date:   Mon, 17 Jul 2023 15:27:22 +0000
In-Reply-To: <20230717152722.1837864-1-jingzhangos@google.com>
Mime-Version: 1.0
References: <20230717152722.1837864-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717152722.1837864-6-jingzhangos@google.com>
Subject: [PATCH v6 5/5] KVM: arm64: selftests: Test for setting ID register
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

