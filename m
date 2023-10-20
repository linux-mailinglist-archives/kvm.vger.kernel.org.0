Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1C7D1854
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbjJTVll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345410AbjJTVlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A22D10DF
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:10 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7bbe0a453so18181107b3.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838069; x=1698442869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OrkUb5e6f7M9UeNAstnZgH452akYrJ8pbLmUt7I8ZGI=;
        b=m0LOjaqsJG6WUA44qmHUQgL1iVXJNlpjFv5iS7kgiv5VRMueTW40/ijPGiGAa8YGf+
         UwYIm/s/Zbs0JLSvKVKCtNBGZZfU9Aq8hLQnaTrafefCS9v+cv0jXAAhC+m+HStmp0vp
         0lUg0FOQd1CfD5Ou9aLZw2IAAu71FcDwMeD8+VCQVjNP9EMZ1pudVomeVpSKj6d3qrBG
         aQpGIfhrO29hevkrrO/EJQcB4xXod8jy9MJOjETEDbcLBvIcT1DpAPLNlEDc8uUYuAoW
         Xu2GKPNllhFaG3WrwDsojg1uTmgnll2e3/qsr2uM5rA0w1dAsLfE2YNRzYRzMeSxdJr/
         dsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838069; x=1698442869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OrkUb5e6f7M9UeNAstnZgH452akYrJ8pbLmUt7I8ZGI=;
        b=F/LbXZxBnUiKqM7AHn+Ne+gW+VrPgf5JQyUdYBcqxNKS0xBeCD6k/r8FoLqABxHSz/
         FiG0lVWwGgxhMXGeX4rDEJQMV+6ECxfkCH7GHvja4XXYFyatZ+H2wLPfrXIlVErnbVzg
         MWa4ybe5hOYNVjv7SkORovgz17Gd/XuY7T1O3yzGz0XKduvcIJprJ+JoS1UjMXBCo5Fh
         3wAFFeLsMNIpWaS+08VdpfnYgsmpIGtfD9lLHuHWP/OyaWIKecoptOdSKR8rCas3HUVp
         TE8dDZ8bpP8f7Bd8iIKFoLfzR30zI8uRtVrXkIvxIbxAl91qVE3O+bUGcmk3nah/YmOf
         DTEw==
X-Gm-Message-State: AOJu0YyQ5gZkyD23GDdaMRfJd6u12OvLZpfvCFaxs/vqm0Jk9tZCOycm
        esyJX3AIFUGz9oVuHt9LfgknzV38WDdH
X-Google-Smtp-Source: AGHT+IF8vIJpYXDnhqI5NKgDVDHoabvTZ450+oSs7hhl9zUr4cDiZmkB1WBSoXWjbK4iwRe+sAFoloM6sPH/
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a81:6cc3:0:b0:5a7:b8d1:ef65 with SMTP id
 h186-20020a816cc3000000b005a7b8d1ef65mr73650ywc.3.1697838069760; Fri, 20 Oct
 2023 14:41:09 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:53 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-14-rananta@google.com>
Subject: [PATCH v8 13/13] KVM: selftests: aarch64: vPMU test for immutability
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM marks some of the vPMU registers as immutable to
userspace once the vCPU has started running. Add a test
scenario to check this behavior.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 47 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 2b697b144e677..f87d76c614e8b 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -9,7 +9,8 @@
  * those counters, and if the guest is prevented from accessing any
  * other counters.
  * It also checks if the userspace accesses to the PMU regsisters honor the
- * PMCR.N value that's set for the guest.
+ * PMCR.N value that's set for the guest and if these accesses are immutable
+ * after KVM has run once.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -648,6 +649,48 @@ static void run_error_test(uint64_t pmcr_n)
 	destroy_vpmu_vm();
 }
 
+static uint64_t immutable_regs[] = {
+	SYS_PMCR_EL0,
+	SYS_PMCNTENSET_EL0,
+	SYS_PMCNTENCLR_EL0,
+	SYS_PMINTENSET_EL1,
+	SYS_PMINTENCLR_EL1,
+	SYS_PMOVSSET_EL0,
+	SYS_PMOVSCLR_EL0,
+};
+
+/*
+ * Create a guest with one vCPU, run it, and then make an attempt to update
+ * the registers in @immutable_regs[] (with their complements). KVM shouldn't
+ * allow updating these registers once vCPU starts running. Hence, the test
+ * fails if that's not the case.
+ */
+static void run_immutable_test(uint64_t pmcr_n)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	uint64_t reg_id, reg_val, reg_val_orig;
+
+	create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm.vcpu;
+
+	run_vcpu(vcpu, pmcr_n);
+
+	for (i = 0; i < ARRAY_SIZE(immutable_regs); i++) {
+		reg_id = immutable_regs[i];
+
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), &reg_val_orig);
+		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), ~reg_val_orig);
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(reg_id), &reg_val);
+
+		TEST_ASSERT(reg_val == reg_val_orig,
+			    "Register 0x%llx value updated after vCPU run: 0x%lx; expected: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(reg_id), reg_val, reg_val_orig);
+	}
+
+	destroy_vpmu_vm();
+}
+
 /*
  * Return the default number of implemented PMU event counters excluding
  * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
@@ -677,5 +720,7 @@ int main(void)
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		run_error_test(i);
 
+	run_immutable_test(pmcr_n);
+
 	return 0;
 }
-- 
2.42.0.655.g421f12c284-goog

