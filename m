Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3AC53C204
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiFCApp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbiFCAo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395E7344DC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so2543670plg.15
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=F8n0o2nxBITSX3BZca6o4o/SeAktx+CXkgwW00hJp/Q=;
        b=ex2+igQlrRG2zLyxUap1yZHHBIuylg/zYDa9oFUD/tBU+87p9Gkzlb60DA98hE6D4o
         mHF7ejXDDURG7MoYLeFgCwwLed8o7ebObnxUJKHq8HFHqe7R7iF4ynQ9QZ5Wuxb2yyTK
         TJVGZwpVdb3YNKsO0gHP0GhgrMvFMjmA3EeHUeKqT0jMAsHvI1xhYZyx3W9TkNggia+Q
         +VNwDW5DixJOvnq3YRlEU/vjgkfUBq567IgM6KCQF80L2WXb8Y5rPS34ozQFuEh+0bRa
         NDCHKrNpQ6CZoDsKQ11bkA1/q2mmTCnLkDaN8PM5iirruHPf7y8u/wCR26/R3bIKYzCo
         VVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=F8n0o2nxBITSX3BZca6o4o/SeAktx+CXkgwW00hJp/Q=;
        b=h9EXS1Kw3ldIQsqXJa0SneZ8lF+jwOs6H1SMXwtzosViSVjLrcPhAJ3UIjKe0aM2/u
         wSl5QaVeOxLeXtgeMPLoVebFMcuJiYkWT/1kqOCLXgt2SNkv/AMW6F2zIHh0j5QLQQ+0
         mfRbk9i9wB9+bPh/l4KIXOj2/mxGjpWq+kSmGNl8cQY0V06VOChqy8l8FXKwQ+oEaMAe
         c8aC9mo5JY8WU3fgfQ5WOyiOqsWeXJDqAtMfEYVIlTqF11dPvE56Sv7ZWs1TI1MkSjKa
         5b3EICEZOzC3j854eFb/V+4nEFE/ulacTf5kEclNwI8xJjoyWINmPaHPxV6PCmNaZXiN
         rmrg==
X-Gm-Message-State: AOAM532nEqmBo84l2iB0YaPts3B8332CBEBY/GjLh0O5bJHYXj1Ict2t
        NJQ1pEy+C/AXsc2HZeVIQ4d+h1QEYpY=
X-Google-Smtp-Source: ABdhPJybXp5Ljxdm8fFfbYrqvoieT1p+el3PdXA0tb1QHlU0B61DLzf6ZPPPyShLMGq3x1voRHz0B8OIHzg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:17c6:b0:1e8:2c09:d006 with SMTP id
 me6-20020a17090b17c600b001e82c09d006mr1328631pjb.31.1654217097704; Thu, 02
 Jun 2022 17:44:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:51 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-45-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 044/144] KVM: selftests: Rename vm_create_without_vcpus()
 => vm_create()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vm_create_without_vcpus() to vm_create() so that it's not
misconstrued as helper that creates a VM that can never have vCPUs, as
opposed to a helper that "just" creates a VM without vCPUs added at time
zero.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c            | 2 +-
 tools/testing/selftests/kvm/dirty_log_test.c               | 2 +-
 tools/testing/selftests/kvm/hardware_disable_test.c        | 2 +-
 tools/testing/selftests/kvm/include/kvm_util_base.h        | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                 | 4 ++--
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c       | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index c9b82c0cc8d5..ffa0cdc0ab3d 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -78,7 +78,7 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	struct kvm_vcpu_init init;
 	struct kvm_vm *vm;
 
-	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 	ucall_init(vm, NULL);
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 13962d107948..b921d0b45647 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -674,7 +674,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	vm = vm_create_without_vcpus(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
+	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
 	vm_vcpu_add_default(vm, vcpuid, guest_code);
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 32837207fe4e..299862a85b8d 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -104,7 +104,7 @@ static void run_test(uint32_t run)
 	for (i = 0; i < VCPU_NUM; i++)
 		CPU_SET(i, &cpu_set);
 
-	vm  = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm  = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c119726ba018..b09ef551d61b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -630,7 +630,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 				    uint32_t vcpuids[]);
 
 /* Create a default VM without any vcpus. */
-struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages);
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages);
 
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ec2dfaa83af3..227b306b6efe 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -258,7 +258,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t phy_pages)
 	return vm;
 }
 
-struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
+struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t pages)
 {
 	struct kvm_vm *vm;
 
@@ -323,7 +323,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	vm = vm_create_without_vcpus(mode, pages);
+	vm = vm_create(mode, pages);
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 4f4519c0cdb1..7eb325466fbc 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -339,7 +339,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 	if (!(r & KVM_PMU_CAP_DISABLE))
 		return;
 
-	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
 
 	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 4c5775a8de6a..6bc13cf17220 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -86,7 +86,7 @@ static struct kvm_vm *create_vm(void)
 	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * N_VCPU;
 	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
-	return vm_create_without_vcpus(VM_MODE_DEFAULT, pages);
+	return vm_create(VM_MODE_DEFAULT, pages);
 }
 
 static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
-- 
2.36.1.255.ge46751e96f-goog

