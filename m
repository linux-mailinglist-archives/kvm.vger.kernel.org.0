Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2F51B276
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379375AbiEDWzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379507AbiEDWyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257B31BEBE
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s2-20020a17090302c200b00158ea215fa2so1378231plk.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ztjnvpybo6qyJr4BCUQZplU60TknzqXz63x+EIsC6l4=;
        b=HEVRh7Qi/0VDYfBHYfpsJkhYsINB2+4swUPsCXzbh+ISGOSwGRPMape+yG7EB4u1HP
         smlhkd9XnBFtCVA+Y6W9RQiQILtcwy6J6In9Lc/U06e/LxkSGbtb2gv0gTwP1eKZhjwz
         Fa3OUF0LPi4fIvh+feElOnNdE/ydNIaVEIMU9CiFmJaORRE4HRLaR4r/EKJDs4ffKSOc
         dQ68r5nk/kiAFOdq12W+V59N3qLhlFypcWVp6lil4pVwBXuAwJpxEwLvjQ07EPjrqW8n
         hVCXbrfOfEpxTxPqZqAr1/6W6znhpAcOyU7Lp9V6OZzMOgehlQH89sa5k+VlAcjG6nsw
         +H8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ztjnvpybo6qyJr4BCUQZplU60TknzqXz63x+EIsC6l4=;
        b=xVICkbDUA9nOAIzmJ5tqjUeMgQ6a1RspGowjAyUIJOrhwfVpNi2EJEEuHoG07Ukn+R
         d01bh9+zTfdO8HM0AGj6sSM7A7qTa8bkdonN4OF4eLM2oIzIPsMCjQo1D10I+QNY63L1
         vI2Oj3xprR6MaV5NPqiNqOVSPvQEKCV2BFiraCB6wRkWz7DwVRoN2DpNz8NhZxo/B16J
         iqxXum+FY2+rqtLdBPLz6Lu9pUIcQtedGUlllaL78ySYcFwxgTp2wozhxi+GqUQbBjIg
         wa0xRVPkMDIXY5udVx39DFO1QFnpBvLOYhefiV4SZHfHW19OIwSR7JnRClGP0oQKD9hr
         FstQ==
X-Gm-Message-State: AOAM5300B/M1c4a/eHaBZOnkoroBX/EmMtkV2x4Uxjdc1hIfOTN6Lg1j
        FCwTLMQ1p4UVdbnHP4fVDtOQXj+amIE=
X-Google-Smtp-Source: ABdhPJwnm6QCl8AXKbY5Y6wBKFPEVscShpEWXNkccFP3F3CbQjoBjoM6LK+D+BXDp5vX6jLW/1iGIZdXO+o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec83:b0:15e:b5d2:a81b with SMTP id
 x3-20020a170902ec8300b0015eb5d2a81bmr10949310plg.64.1651704640674; Wed, 04
 May 2022 15:50:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:46 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-41-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 040/128] KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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
 .../selftests/kvm/lib/x86_64/processor.c      |  6 ++--
 4 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 96e08c9be013..ca65771388e7 100644
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
@@ -643,17 +644,17 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
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
index d31ac35a86f3..911869b350ea 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -353,7 +353,7 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
 					    (uint32_t []){ vcpuid });
 }
 
-struct kvm_vm *__vm_create_with_one_vcpu(struct vcpu **vcpu,
+struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 					 uint64_t extra_mem_pages,
 					 void *guest_code)
 {
@@ -397,7 +397,7 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 	}
 }
 
-struct vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
+struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm)
 {
 	kvm_vm_restart(vm);
 
@@ -476,23 +476,23 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
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
 
@@ -508,7 +508,7 @@ struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid)
  *
  * Removes a vCPU from a VM and frees its resources.
  */
-static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
+static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	int ret;
 
@@ -530,7 +530,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 
 void kvm_vm_release(struct kvm_vm *vmp)
 {
-	struct vcpu *vcpu, *tmp;
+	struct kvm_vcpu *vcpu, *tmp;
 	int ret;
 
 	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
@@ -1082,7 +1082,7 @@ static int vcpu_mmap_sz(void)
  */
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu;
+	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
 	TEST_ASSERT(!vcpu_find(vm, vcpuid), "vCPU%d already exists\n", vcpuid);
@@ -1456,7 +1456,7 @@ void vm_create_irqchip(struct kvm_vm *vm)
  */
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return vcpu->run;
 }
@@ -1497,7 +1497,7 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int ret;
 
 	vcpu->run->immediate_exit = 1;
@@ -1541,7 +1541,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 		 unsigned long cmd, void *arg)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 
 	return ioctl(vcpu->fd, cmd, arg);
 }
@@ -1556,7 +1556,7 @@ void _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long cmd,
 
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	uint32_t size = vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
@@ -1677,9 +1677,7 @@ void vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 			  uint64_t attr)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
-
-	return __kvm_has_device_attr(vcpu->fd, group, attr);
+	return __kvm_has_device_attr(vcpu_get(vm, vcpuid)->fd, group, attr);
 }
 
 /*
@@ -1772,7 +1770,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
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
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1e3d68bdfc7d..91b326cd43a2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -938,7 +938,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
 	return list;
 }
 
-static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
+static int vcpu_save_xsave_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 				 struct kvm_x86_state *state)
 {
 	int size;
@@ -956,7 +956,7 @@ static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
 
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	struct kvm_msr_list *list;
 	struct kvm_x86_state *state;
 	int nmsrs, r, i;
@@ -1037,7 +1037,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *state)
 {
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
+	struct kvm_vcpu *vcpu = vcpu_get(vm, vcpuid);
 	int r;
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
-- 
2.36.0.464.gb9c8b46e94-goog

