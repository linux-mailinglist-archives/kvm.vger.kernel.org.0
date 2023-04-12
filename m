Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C966E0104
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDLVfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDLVff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE6E86BA
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f9df9ebc5so27948487b3.13
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335330; x=1683927330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH4ZRYVMjQ/mFRBZ49V9jlN8+sDpTIhwIJQUsNqRO4=;
        b=a0WlNccitJbMxtr99iHu5o5qhkB8GZPfinmSqjqpd26vcPKVaA0f8FWlEXKgCaCozq
         lZcKVgjiloiKSP+94bh2Asa7Rzt96bF9dgcd7xvBR9IN2QY3eGcsL5+7G0vaHw7y+FCU
         YgnCKxCxaH1bVVo0XNIEPCMbmMyjUJbRPv+T/soClb8P7YAtwnOZugsxGgf8KiCyzHuL
         h/ds/bxsBNMyYc7iboS3PftQei5tre/9z7VYV0idgPUC9U9r2QqY5lg+8y0PAlsDn/wn
         KFRtSyB7hPb4UnfDKhIcEXaAML6W3xbjI47GD83yBNOdQOBq53dlKy9GgKj/qJPSYue4
         vLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335330; x=1683927330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IWH4ZRYVMjQ/mFRBZ49V9jlN8+sDpTIhwIJQUsNqRO4=;
        b=RHGH1mj/te5XoxRqUpukryQ+Suoq6vP32A6qHGnWIPgMKDsXukbV0bcL/2zBqROTc4
         Yhs53qt1bahcfqramGUCC2Kx2HGhBq65ZBs3jBspHyqG61o/P2d+hABQIkP627G3yO4U
         YFGwM4jwYAQWH3fntHLt7b9CRA+pdZreWbXFKT6ffPCC/dm5yo5oZFKR96X0CzSAQ/Qw
         TpJ7oN2/Yn4AINFe8son4V0l01vJ/NlnxS6bYu9lzII/hY9+HtMyv5wQiFa04p7sco3a
         BMt8T9kGuGbdh5bLFu/HJm16ErRUthYz1iQt0yJfogPbqq8adHKHHO5jksFKUNyBJiEe
         IaKA==
X-Gm-Message-State: AAQBX9fsj2WIiyfeCiR66SXWU1EHj/1xWiHDd4mEBZeCC32we6V4sTUF
        SZDJnlv1QKdpUPr6nkSYym39LGXdz6ShVA==
X-Google-Smtp-Source: AKy350ar/HxRwT7YIUsCVGv0rPiDiH7lT+T3hSEZTIraxERXKIZKg70zugZhlLgV06/iho9mUA0D+Oe1xt+ZXA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:cc07:0:b0:b8b:fe5f:2eaa with SMTP id
 l7-20020a25cc07000000b00b8bfe5f2eaamr15871ybf.2.1681335330526; Wed, 12 Apr
 2023 14:35:30 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:05 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-18-amoorthy@google.com>
Subject: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT without implementation
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Add documentation, memslot flags, useful helper functions, and the
actual new capability itself.

Memory fault exits on absent mappings are particularly useful for
userfaultfd-based postcopy live migration. When many vCPUs fault on a
single userfaultfd the faults can take a while to surface to userspace
due to having to contend for uffd wait queue locks. Bypassing the uffd
entirely by returning information directly to the vCPU exit avoids this
contention and improves the fault rate.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
 include/linux/kvm_host.h       |  7 +++++++
 include/uapi/linux/kvm.h       |  2 ++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/kvm_main.c            |  3 +++
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f174f43c38d45..7967b9909e28b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
   /* for kvm_userspace_memory_region::flags */
   #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
   #define KVM_MEM_READONLY	(1UL << 1)
+  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
 
 This ioctl allows the user to create, modify or delete a guest physical
 memory slot.  Bits 0-15 of "slot" specify the slot id and this value
@@ -1342,12 +1343,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
+The flags field supports three flags
+
+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
 writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
+use it.
+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
+3.  KVM_MEM_ABSENT_MAPPING_FAULT: see KVM_CAP_ABSENT_MAPPING_FAULT for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -7705,6 +7709,27 @@ userspace may receive "bare" EFAULTs (i.e. exit reason !=
 KVM_EXIT_MEMORY_FAULT) from KVM_RUN. These should be considered bugs and
 reported to the maintainers.
 
+7.35 KVM_CAP_ABSENT_MAPPING_FAULT
+---------------------------------
+
+:Architectures: None
+:Returns: -EINVAL.
+
+The presence of this capability indicates that userspace may pass the
+KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
+to fail (-EFAULT) in response to page faults for which the userspace page tables
+do not contain present mappings. Attempting to enable the capability directly
+will fail.
+
+The range of guest physical memory causing the fault is advertised to userspace
+through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).
+
+Userspace should determine how best to make the mapping present, then take
+appropriate action. For instance, in the case of absent mappings this might
+involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
+faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
+mapping, userspace can return to KVM to retry the previous memory access.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 776f9713f3921..2407fc1e52ab8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2289,4 +2289,11 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
  */
 inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
 					uint64_t gpa, uint64_t len);
+
+static inline bool kvm_slot_fault_on_absent_mapping(
+							const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_ABSENT_MAPPING_FAULT;
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index bc73e8381a2bb..21df449e74648 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1196,6 +1197,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_MEMORY_FAULT_INFO 227
+#define KVM_CAP_ABSENT_MAPPING_FAULT 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 5c57796364d65..59219da95634c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f3be5aa49829a..7cd0ad94726df 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_ABSENT_MAPPING_FAULT))
+		valid_flags |= KVM_MEM_ABSENT_MAPPING_FAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.40.0.577.gac1e443424-goog

