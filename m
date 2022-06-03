Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8D53C284
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbiFCAth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240573AbiFCArV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9E037BFE
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id z11-20020a17090a468b00b001dc792e8660so3413896pjf.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TZYxxynXHC/vdgHYiFnTkVVG3+wGviuXEMnIuQ47b80=;
        b=YelKkGplq7prcLWfweU59tKSFgbLohX3lcoIf0muyB5yP3liX8mvBqSfSH6HrPFw0o
         ReclQ+KvtfZnmxFfpP6glMAtV8ZWuWOZStKK7KzIqpClE0V1xTFYH7hHi8LKBCn2SNlV
         h/yxToVrhCudbRVGqdZRd3Z8POu1XmCUgt0JjtmTJi41JiH+nHW2Lncrvr1PcpdNlyaB
         xyu+fn3LFbSzW/0fgZXoRO0xTvbLIq8XLBhcdFqRBhIPsMnSDO5e49tj17cAiKSnzIov
         6nLpqi4vX5IKZ2iw2K6MDRDZSnZwD7noUAotQsIaxd5aH2d42Whra2wI3WM6kEfF4ZUj
         rmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TZYxxynXHC/vdgHYiFnTkVVG3+wGviuXEMnIuQ47b80=;
        b=sLJHNrPhKvk0JDlX10/2VZS62SFYP7ZyW94c6fxUenzsMgk/Pw1R/6lv01yzzdpFu4
         Oe+VkJAooS7qeUkd6yY/VyTK/mclB4B6SvVfRtEHx7TJUTGTWwVcmh2o4lm1f4PMnGz5
         JufLfj568yVX/4u8qKvQhkn1zHDqC3M63SiKwUox3q3aQG2AkOVImCflyLRQwFUpElJ7
         RI/pmbuWLKSuOOohl6TT16Esn+B4urtbuwWkRnuDZ4l7Ni0rxmbloDxQcUzF2jhLASNj
         6bLjYrVc20cknCOuOlhirOMgejC2pfsxhaWBrA09EHhzY3ob/O44HKpAaHoTup389cy8
         YmZg==
X-Gm-Message-State: AOAM533OD4wkE27OTiByWqxvzJpxVoSGaMrEL8kq5xkn35iQM3BCzk3z
        7nX4VhjsesjAB8KFpYWt2m4uODgPrp0=
X-Google-Smtp-Source: ABdhPJw4+p8236APuKVMcPNpWUJceDZHECVL5tpvwAAgLULY3bhQU/a3606fdd1HCH2cMDL311s7IFkSRVc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr305586pja.1.1654217200943; Thu, 02 Jun
 2022 17:46:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:49 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-103-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 102/144] KVM: selftests: Rename vm_vcpu_add* helpers to
 better show relationships
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vm_vcpu_add() to __vm_vcpu_add(), and vm_vcpu_add_default() to
vm_vcpu_add() to show the relationship between the newly minted
vm_vcpu_add() and __vm_vcpu_add().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c     |  2 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c        |  4 ++--
 .../testing/selftests/kvm/aarch64/vcpu_width_config.c  |  8 ++++----
 tools/testing/selftests/kvm/aarch64/vgic_init.c        | 10 +++++-----
 tools/testing/selftests/kvm/dirty_log_test.c           |  2 +-
 tools/testing/selftests/kvm/hardware_disable_test.c    |  2 +-
 .../testing/selftests/kvm/include/aarch64/processor.h  |  5 ++---
 tools/testing/selftests/kvm/include/kvm_util_base.h    |  7 +++----
 tools/testing/selftests/kvm/kvm_binary_stats_test.c    |  2 +-
 tools/testing/selftests/kvm/kvm_create_max_vcpus.c     |  2 +-
 tools/testing/selftests/kvm/lib/aarch64/processor.c    |  9 ++++-----
 tools/testing/selftests/kvm/lib/kvm_util.c             |  6 +++---
 tools/testing/selftests/kvm/lib/riscv/processor.c      |  2 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c      |  2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c     |  2 +-
 tools/testing/selftests/kvm/set_memory_region_test.c   |  2 +-
 tools/testing/selftests/kvm/steal_time.c               |  2 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c       |  2 +-
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c   |  4 ++--
 tools/testing/selftests/kvm/x86_64/set_sregs_test.c    |  2 +-
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c |  8 ++++----
 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c  |  4 ++--
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c    |  2 +-
 23 files changed, 44 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index d0c37a1b2a1f..a8558e462efb 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -418,7 +418,7 @@ static void run_test(struct vcpu_config *c)
 
 	vm = vm_create_barebones();
 	prepare_vcpu_init(c, &init);
-	aarch64_vcpu_add_default(vm, 0, &init, NULL);
+	aarch64_vcpu_add(vm, 0, &init, NULL);
 	finalize_vcpu(vm, 0, c);
 
 	reg_list = vcpu_get_reg_list(vm, 0);
diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index fa4e6c3343d7..347cb5c130e2 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -84,8 +84,8 @@ static struct kvm_vm *setup_vm(void *guest_code)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
-	aarch64_vcpu_add_default(vm, VCPU_ID_SOURCE, &init, guest_code);
-	aarch64_vcpu_add_default(vm, VCPU_ID_TARGET, &init, guest_code);
+	aarch64_vcpu_add(vm, VCPU_ID_SOURCE, &init, guest_code);
+	aarch64_vcpu_add(vm, VCPU_ID_TARGET, &init, guest_code);
 
 	return vm;
 }
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
index 1757f44dd3e2..1dd856a58f5d 100644
--- a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -26,12 +26,12 @@ static int add_init_2vcpus(struct kvm_vcpu_init *init1,
 
 	vm = vm_create_barebones();
 
-	vm_vcpu_add(vm, 0);
+	__vm_vcpu_add(vm, 0);
 	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
 	if (ret)
 		goto free_exit;
 
-	vm_vcpu_add(vm, 1);
+	__vm_vcpu_add(vm, 1);
 	ret = __vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
 
 free_exit:
@@ -51,8 +51,8 @@ static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
 
 	vm = vm_create_barebones();
 
-	vm_vcpu_add(vm, 0);
-	vm_vcpu_add(vm, 1);
+	__vm_vcpu_add(vm, 0);
+	__vm_vcpu_add(vm, 1);
 
 	ret = __vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
 	if (ret)
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index f10596edd8ed..f8d41f12bdca 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -314,7 +314,7 @@ static void test_vgic_then_vcpus(uint32_t gic_dev_type)
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
-		vm_vcpu_add_default(v.vm, i, guest_code);
+		vm_vcpu_add(v.vm, i, guest_code);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
@@ -402,17 +402,17 @@ static void test_v3_typer_accesses(void)
 
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
-	vm_vcpu_add_default(v.vm, 3, guest_code);
+	vm_vcpu_add(v.vm, 3, guest_code);
 
 	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(ret && errno == EINVAL, "attempting to read GICR_TYPER of non created vcpu");
 
-	vm_vcpu_add_default(v.vm, 1, guest_code);
+	vm_vcpu_add(v.vm, 1, guest_code);
 
 	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(ret && errno == EBUSY, "read GICR_TYPER before GIC initialized");
 
-	vm_vcpu_add_default(v.vm, 2, guest_code);
+	vm_vcpu_add(v.vm, 2, guest_code);
 
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
@@ -576,7 +576,7 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
-		vm_vcpu_add_default(v.vm, i, guest_code);
+		vm_vcpu_add(v.vm, i, guest_code);
 
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 23e0c727e375..1a5c01c65044 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -676,7 +676,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	vm = __vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages);
 
 	log_mode_create_vm_done(vm);
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
+	vm_vcpu_add(vm, vcpuid, guest_code);
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index ccbbf8783e2d..31f6d408419f 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -108,7 +108,7 @@ static void run_test(uint32_t run)
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
 	for (i = 0; i < VCPU_NUM; ++i) {
-		vm_vcpu_add_default(vm, i, guest_code);
+		vm_vcpu_add(vm, i, guest_code);
 		payloads[i].vm = vm;
 		payloads[i].index = i;
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9dad391b4fec..f774609f7848 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -64,9 +64,8 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id, uint
 }
 
 void aarch64_vcpu_setup(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_vcpu_init *init);
-struct kvm_vcpu *aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpu_id,
-					  struct kvm_vcpu_init *init,
-					  void *guest_code);
+struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  struct kvm_vcpu_init *init, void *guest_code);
 
 struct ex_regs {
 	u64 regs[31];
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 622b09ec23dd..2c7a8a91ebe2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -288,7 +288,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
-struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
+struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
@@ -659,9 +659,8 @@ static inline void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  void *guest_code);
 
-static inline struct kvm_vcpu *vm_vcpu_add_default(struct kvm_vm *vm,
-						   uint32_t vcpu_id,
-						   void *guest_code)
+static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+					   void *guest_code)
 {
 	return vm_arch_vcpu_add(vm, vcpu_id, guest_code);
 }
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index edeb08239036..407e9ea8e6f3 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -223,7 +223,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < max_vm; ++i) {
 		vms[i] = vm_create_barebones();
 		for (j = 0; j < max_vcpu; ++j)
-			vm_vcpu_add(vms[i], j);
+			__vm_vcpu_add(vms[i], j);
 	}
 
 	/* Check stats read for every VM and VCPU */
diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
index acc92703f563..3ae0237e96b2 100644
--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -32,7 +32,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 
 	for (i = first_vcpu_id; i < first_vcpu_id + num_vcpus; i++)
 		/* This asserts that the vCPU was created. */
-		vm_vcpu_add(vm, i);
+		__vm_vcpu_add(vm, i);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 2b169b4ec29e..5b95fa2cce18 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -314,16 +314,15 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t in
 		indent, "", pstate, pc);
 }
 
-struct kvm_vcpu *aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpu_id,
-					  struct kvm_vcpu_init *init,
-					  void *guest_code)
+struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+				  struct kvm_vcpu_init *init, void *guest_code)
 {
 	size_t stack_size = vm->page_size == 4096 ?
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
-	struct kvm_vcpu *vcpu = vm_vcpu_add(vm, vcpu_id);
+	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	aarch64_vcpu_setup(vm, vcpu_id, init);
 
@@ -336,7 +335,7 @@ struct kvm_vcpu *aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpu_id,
 struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  void *guest_code)
 {
-	return aarch64_vcpu_add_default(vm, vcpu_id, NULL, guest_code);
+	return aarch64_vcpu_add(vm, vcpu_id, NULL, guest_code);
 }
 
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5f0030257b05..8ed1baf6b0eb 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -328,7 +328,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
 
-		vm_vcpu_add_default(vm, vcpuid, guest_code);
+		vm_vcpu_add(vm, vcpuid, guest_code);
 	}
 
 	return vm;
@@ -397,7 +397,7 @@ struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
-	return vm_vcpu_add(vm, 0);
+	return __vm_vcpu_add(vm, 0);
 }
 
 /*
@@ -1065,7 +1065,7 @@ static int vcpu_mmap_sz(void)
  * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
  * No additional vCPU setup is done.  Returns the vCPU.
  */
-struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
+struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_vcpu *vcpu;
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 5946101144eb..ba5761843c76 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -287,7 +287,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
 
-	vcpu = vm_vcpu_add(vm, vcpu_id);
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vm, vcpu_id);
 
 	/*
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index cf759844b226..f8170e97eeb7 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -170,7 +170,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
-	vcpu = vm_vcpu_add(vm, vcpu_id);
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	/* Setup guest registers */
 	vcpu_regs_get(vm, vcpu_id, &regs);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 8255042de0d0..440ea6e99f08 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -644,7 +644,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
-	vcpu = vm_vcpu_add(vm, vcpu_id);
+	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 1274bbb0e30b..d832fc12984e 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -315,7 +315,7 @@ static void test_zero_memory_regions(void)
 	pr_info("Testing KVM_RUN with zero added memory regions\n");
 
 	vm = vm_create_barebones();
-	vcpu = vm_vcpu_add(vm, 0);
+	vcpu = __vm_vcpu_add(vm, 0);
 
 	vm_ioctl(vm, KVM_SET_NR_MMU_PAGES, (void *)64ul);
 	vcpu_run(vm, vcpu->id);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 75303fe8359d..fd3533582509 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -275,7 +275,7 @@ int main(int ac, char **av)
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
-		vm_vcpu_add_default(vm, i, guest_code);
+		vm_vcpu_add(vm, i, guest_code);
 
 	steal_time_init(vm);
 
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 8b034a8617e1..eda4e02f92f6 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -343,7 +343,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
 
 	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
 
-	vcpu = vm_vcpu_add_default(vm, 0, guest_code);
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, vcpu->id);
 
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 9ba3cd4e7f20..e63709894030 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -92,9 +92,9 @@ static struct kvm_vm *create_vm(void)
 static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
 {
 	if (bsp_code)
-		vm_vcpu_add_default(vm, vcpuid, guest_bsp_vcpu);
+		vm_vcpu_add(vm, vcpuid, guest_bsp_vcpu);
 	else
-		vm_vcpu_add_default(vm, vcpuid, guest_not_bsp_vcpu);
+		vm_vcpu_add(vm, vcpuid, guest_not_bsp_vcpu);
 }
 
 static void run_vm_bsp(uint32_t bsp_vcpu)
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 8a5c1f76287c..2e67df3a95ba 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -95,7 +95,7 @@ int main(int argc, char *argv[])
 	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
 	 */
 	vm = vm_create_barebones();
-	vcpu = vm_vcpu_add(vm, 0);
+	vcpu = __vm_vcpu_add(vm, 0);
 
 	vcpu_sregs_get(vm, vcpu->id, &sregs);
 
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 245fd0755390..ec418b823273 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -56,7 +56,7 @@ static struct kvm_vm *sev_vm_create(bool es)
 	vm = vm_create_barebones();
 	sev_ioctl(vm->fd, es ? KVM_SEV_ES_INIT : KVM_SEV_INIT, NULL);
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
-		vm_vcpu_add(vm, i);
+		__vm_vcpu_add(vm, i);
 	if (es)
 		start.policy |= SEV_POLICY_ES;
 	sev_ioctl(vm->fd, KVM_SEV_LAUNCH_START, &start);
@@ -75,7 +75,7 @@ static struct kvm_vm *aux_vm_create(bool with_vcpus)
 		return vm;
 
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
-		vm_vcpu_add(vm, i);
+		__vm_vcpu_add(vm, i);
 
 	return vm;
 }
@@ -182,7 +182,7 @@ static void test_sev_migrate_parameters(void)
 	sev_es_vm = sev_vm_create(/* es= */ true);
 	sev_es_vm_no_vmsa = vm_create_barebones();
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
-	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
+	__vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
 	ret = __sev_migrate_from(sev_vm, sev_es_vm);
 	TEST_ASSERT(
@@ -278,7 +278,7 @@ static void test_sev_mirror(bool es)
 
 	/* Check that we can complete creation of the mirror VM.  */
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
-		vm_vcpu_add(dst_vm, i);
+		__vm_vcpu_add(dst_vm, i);
 
 	if (es)
 		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
index ea70ca2e63c3..2411215e7ae8 100644
--- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
@@ -51,10 +51,10 @@ static void *run_vcpu(void *_cpu_nr)
 	static bool first_cpu_done;
 	struct kvm_vcpu *vcpu;
 
-	/* The kernel is fine, but vm_vcpu_add_default() needs locking */
+	/* The kernel is fine, but vm_vcpu_add() needs locking */
 	pthread_spin_lock(&create_lock);
 
-	vcpu = vm_vcpu_add_default(vm, vcpu_id, guest_code);
+	vcpu = vm_vcpu_add(vm, vcpu_id, guest_code);
 
 	if (!first_cpu_done) {
 		first_cpu_done = true;
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index afbbc40df884..8b366652be31 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -425,7 +425,7 @@ int main(int argc, char *argv[])
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 
-	vm_vcpu_add_default(vm, SENDER_VCPU_ID, sender_guest_code);
+	vm_vcpu_add(vm, SENDER_VCPU_ID, sender_guest_code);
 
 	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
 	data =
-- 
2.36.1.255.ge46751e96f-goog

