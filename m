Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8914953C2ED
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbiFCAqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiFCApG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:45:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444B3344E6
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:45:05 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id i4-20020a17090a718400b001e09f0af976so3513360pjk.9
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=t58xAAwB/ZnbYiHOUPJlMzJFx0EquVUcWcCWAkpdW/o=;
        b=BOfHWQq3Vor6mvg5pg6jhgJoW7+h8pcII5sT2DuQGjbM35rmwmvbDfDzB4bTjgmNaA
         ewrCxzlCvbZTtmiAW8wuAx4oqDKdubfORpDUNlAPuoKtgJuYruNWdggZ2m07YwFF2Ayi
         6UdUpla7XN33/wGE8id7NrgKwlh0QWVe/c4g0fJRNQqbhRyqROXDeb4unIdOpQLM3+fa
         be2C3zfx38VuiRRJ4Mf80WhssqyksN6+9gg3BuYl/mKtBArEuAQf5c1WmR/DO33ONpxx
         2D0KQPRHjFJykUI+LJ3vlMyhonmHY+zsGq5V8zoSbLyY6vR6HAMRybQPzVcqvS/x91jS
         J/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=t58xAAwB/ZnbYiHOUPJlMzJFx0EquVUcWcCWAkpdW/o=;
        b=fh0ohChQgtxcOlOPaC1q032Rovtb/8qOdeIxOeZ5+SSw3AwKEg64Z4d1r3VjGkcW5+
         sR+/Mksm8+mqeerGQQCUaQz2whJ9Ai9P/HiKatA9oykvUfxOgHbLxht1xWQ9aQv5EJZR
         IWZyJgJazsfbs1YKQHGP/5YOnRMFDpPPw3kKlaAvJs3BhzM/ISGHociYBo/SNjykUpUo
         gDar/affvvmHgJfROxi/0u0MeaaC1bSFRpni0jvLDyy0f2Dz1ibElvnIWzxMIQZ45nVm
         m0UmmWM2NKIoCvPnwAvuT89ihbskRMj3QLZVybmYcrDSDZHGpAgo8dwrL80ZAaU3GGRC
         v7+A==
X-Gm-Message-State: AOAM5300tOy71OBa3ZjWA2gUSzF93yEm9NjqHL9bzHR1EFdC4azoxZpB
        ba4GgvxKDxG0BZCQGML7CPaToRxYOe8=
X-Google-Smtp-Source: ABdhPJzQAhuFQefdny7WM7T7++3j+UHAQQOnvnYp3xh9aylN+U/KL1oYOcsqIY50vfWeite0nwrzeWOVLEs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr307302pje.0.1654217104430; Thu, 02 Jun
 2022 17:45:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:55 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-49-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 048/144] KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
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

Rename 'struct vcpu' to 'struct kvm_vcpu' to align with 'struct kvm_vm'
in the selftest, and to give readers a hint that the struct is specific
to KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 11 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++----------
 .../selftests/kvm/lib/s390x/processor.c       |  2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index b83c3327d0e4..d2c7fb391fc7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -16,6 +16,7 @@
 #include <linux/kvm.h>
 #include "linux/rbtree.h"
 
+
 #include <sys/ioctl.h>
 
 #include "sparsebit.h"
@@ -43,7 +44,7 @@ struct userspace_mem_region {
 	struct hlist_node slot_node;
 };
 
-struct vcpu {
+struct kvm_vcpu {
 	struct list_head list;
 	uint32_t id;
 	int fd;
@@ -92,7 +93,7 @@ struct kvm_vm {
 			continue;			\
 		else
 
-struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
+struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
 
 /*
  * Virtual Translation Tables Dump
@@ -644,17 +645,17 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
  * additional pages of guest memory.  Returns the VM and vCPU (via out param).
  */
-struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 					 uint64_t extra_mem_pages,
 					 void *guest_code);
 
-static inline struct kvm_vm *vm_create_with_one_vcpu(struct vcpu **vcpu,
+static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 						     void *guest_code)
 {
 	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
 }
 
-struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
+struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
 
 /*
  * Adds a vCPU with reasonable defaults (e.g. a stack)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index aca9ebffdc0e..99d6c5a8659e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -349,7 +349,7 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 					    (uint32_t []){ vcpuid });
 }
 
-struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 					 uint64_t extra_mem_pages,
 					 void *guest_code)
 {
@@ -393,7 +393,7 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
-struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
+struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
@@ -472,23 +472,23 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
-static struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
+static struct kvm_vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpu_id)
 {
-	struct vcpu *vcpu;
+	struct kvm_vcpu *vcpu;
 
 	list_for_each_entry(vcpu, &vm->vcpus, list) {
-		if (vcpu->id == vcpuid)
+		if (vcpu->id == vcpu_id)
 			return vcpu;
 	}
 
 	return NULL;
 }
 
-struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid)
+struct kvm_vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpu_id)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_find(vm, vcpu_id);
 
-	TEST_ASSERT(vcpu, "vCPU %d does not exist", vcpuid);
+	TEST_ASSERT(vcpu, "vCPU %d does not exist", vcpu_id);
 	return vcpu;
 }
 
@@ -504,7 +504,7 @@ struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid)
  *
  * Removes a vCPU from a VM and frees its resources.
  */
-static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
+static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	int ret;
 
@@ -526,7 +526,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 
 void kvm_vm_release(struct kvm_vm *vmp)
 {
-	struct vcpu *vcpu, *tmp;
+	struct kvm_vcpu *vcpu, *tmp;
 	int ret;
 
 	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
@@ -1078,7 +1078,7 @@ static int vcpu_mmap_sz(void)
  */
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu;
+	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
 	TEST_ASSERT(!vcpu_find(vm, vcpuid), "vCPU%d already exists\n", vcpuid);
@@ -1452,7 +1452,7 @@ void vm_create_irqchip(struct kvm_vm *vm)
  */
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return vcpu->run;
 }
@@ -1493,7 +1493,7 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int ret;
 
 	vcpu->run->immediate_exit = 1;
@@ -1537,7 +1537,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 		 unsigned long cmd, void *arg)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return ioctl(vcpu->fd, cmd, arg);
 }
@@ -1552,7 +1552,7 @@ void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
 
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	uint32_t size = vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
@@ -1684,9 +1684,7 @@ void vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
-
-	return __kvm_has_device_attr(vcpu->fd, group, attr);
+	return __kvm_has_device_attr(vcpu_get(vm, vcpuid)->fd, group, attr);
 }
 
 /*
@@ -1779,7 +1777,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int ctr;
 	struct userspace_mem_region *region;
-	struct vcpu *vcpu;
+	struct kvm_vcpu *vcpu;
 
 	fprintf(stream, "%*smode: 0x%x\n", indent, "", vm->mode);
 	fprintf(stream, "%*sfd: %i\n", indent, "", vm->fd);
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index df9d9650d916..aec15ca9d887 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -207,7 +207,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
 		indent, "", vcpu->run->psw_mask, vcpu->run->psw_addr);
-- 
2.36.1.255.ge46751e96f-goog

