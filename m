Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB56BA514
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCOCSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjCOCSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:12 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB602FCC4
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-544781e30easo8996057b3.1
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ouQZR3jCVX1NbJ8ErcgopfTDmNVdxDovSmR7v+Aq4kA=;
        b=g0erQilp5jzVdp4J++yfeRLeAhQ2A11SNqKjG2KZNejaQ6l0iIHhNi2VpQWbbltPv1
         YL/ceVpZW1jkuGD35U9tw06jFQUdHNFFCER/ikGa2MrhzmIkRFqX6WggO4CJN40Am3/q
         pXVess640l0ZILiEd/wa+Ce+DkzrURrvsc+M0lTHcuNd9ExWo5WR1jLuBRk3vP+NQ80N
         49QSzg4c4CMTQnpmouHde8dGZrl9qWsuIsvTtC02MHqu4xw/W5wcFt1E6otSxBU80dwR
         32Tg5gUG4roLDaHwm8cpv9azbiwAuD9+6xBJodz+25Rig2lQwV595E8JxB9Fg4WkcQTg
         M8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouQZR3jCVX1NbJ8ErcgopfTDmNVdxDovSmR7v+Aq4kA=;
        b=bOdehPIsF2Lp2PXZAqu/dDD+svcGV9LPLVbA2yq5SjwsWtCjEuwvTSAEzf0Xf2Kl5m
         yNMt/1Mzqy5WwcOTUl61iSv5SMfFU9qlCoiCHPAKRnR9x6WErjEobwX7/GBD+p2ZPonK
         GFPtqjr8nhhatmQNnExXXy53UkBsKTedhdI6kGTw8exFfE4O2gpSgswzKPnDVzCZTiFh
         J4nD7DsCYfVGZmOg3xtrDkJc6e9J5BD2UAZn5SO1F8tGC7bjJA1YowhUHGVc73ALLxHg
         vpIGf8Vw3+oldiImJQ9/C7KuRaBLH5BGhGhstkMRDSzoUO+fvebTyB0LnczFDsFjemfy
         wvOQ==
X-Gm-Message-State: AO0yUKXAc9WsQvBqVZxivwiljbsx3diydpR+vtGR8pBUB4lQtVB8vkM3
        xcflcqy7hp6//2gPKGWto0ob6FGt0rP2wg==
X-Google-Smtp-Source: AK7set8HZsEmEXQslqIfABZ1D2Z2udCh07S5JB6g10ppnAuASIpmeFrInci4YQxuaMjh/bbJxj/OglHQMwk/xA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:2c5:b0:b45:5cbe:48b3 with SMTP
 id w5-20020a05690202c500b00b455cbe48b3mr2518477ybh.0.1678846689068; Tue, 14
 Mar 2023 19:18:09 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:33 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-10-amoorthy@google.com>
Subject: [WIP Patch v2 09/14] KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT
 without implementation
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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
userfaultfd-based live migration postcopy. When many vCPUs fault upon a
single userfaultfd the faults can take a while to surface to userspace
due to having to contend for uffd wait queue locks. Bypassing the uffd
entirely by triggering a vCPU exit avoids this contention and can improve
the fault rate by as much as 10x.
---
 Documentation/virt/kvm/api.rst | 37 +++++++++++++++++++++++++++++++---
 include/linux/kvm_host.h       |  6 ++++++
 include/uapi/linux/kvm.h       |  3 +++
 tools/include/uapi/linux/kvm.h |  2 ++
 virt/kvm/kvm_main.c            |  7 ++++++-
 5 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f9ca18bbec879..4932c0f62eb3d 100644
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
+3.  KVM_MEM_ABSENT_MAPPING_FAULT: see KVM_CAP_MEMORY_FAULT_NOWAIT for details.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
@@ -7702,10 +7706,37 @@ Through args[0], the capability can be set on a per-exit-reason basis.
 Currently, the only exit reasons supported are
 
 1. KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
+2. KVM_MEMFAULT_REASON_ABSENT_MAPPING (1 << 1)
 
 Memory fault exits with a reason of UNKNOWN should not be depended upon: they
 may be added, removed, or reclassified under a stable reason.
 
+7.35 KVM_CAP_MEMORY_FAULT_NOWAIT
+--------------------------------
+
+:Architectures: x86, arm64
+:Returns: -EINVAL.
+
+The presence of this capability indicates that userspace may pass the
+KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
+to exit to populate 'kvm_run.memory_fault' and exit to userspace (*) in response
+to page faults for which the userspace page tables do not contain present
+mappings. Attempting to enable the capability directly will fail.
+
+The 'gpa' and 'len' fields of kvm_run.memory_fault will be set to the starting
+address and length (in bytes) of the faulting page. 'flags' will be set to
+KVM_MEMFAULT_REASON_ABSENT_MAPPING.
+
+Userspace should determine how best to make the mapping present, then take
+appropriate action. For instance, in the case of absent mappings this might
+involve establishing the mapping for the first time via UFFDIO_COPY/CONTINUE or
+faulting the mapping in using MADV_POPULATE_READ/WRITE. After establishing the
+mapping, userspace can return to KVM to retry the previous memory access.
+
+(*) NOTE: On x86, KVM_CAP_X86_MEMORY_FAULT_EXIT must be enabled for the
+KVM_MEMFAULT_REASON_ABSENT_MAPPING_reason: otherwise userspace will only receive
+a -EFAULT from KVM_RUN without any useful information.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d3ccfead73e42..c28330f25526f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -593,6 +593,12 @@ static inline bool kvm_slot_dirty_track_enabled(const struct kvm_memory_slot *sl
 	return slot->flags & KVM_MEM_LOG_DIRTY_PAGES;
 }
 
+static inline bool kvm_slot_fault_on_absent_mapping(
+	const struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_ABSENT_MAPPING_FAULT;
+}
+
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
 {
 	return ALIGN(memslot->npages, BITS_PER_LONG) / 8;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0ba1d7f01346e..2146b27cdd61a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -1197,6 +1198,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_X86_MEMORY_FAULT_EXIT 227
+#define KVM_CAP_MEMORY_FAULT_NOWAIT 228
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2252,5 +2254,6 @@ struct kvm_s390_zpci_op {
 
 /* Exit reasons for KVM_EXIT_MEMORY_FAULT */
 #define KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
+#define KVM_MEMFAULT_REASON_ABSENT_MAPPING (1 << 1)
 
 #endif /* __LINUX_KVM_H */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 2b468345f25c3..1a1707d9f442a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -102,6 +102,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -2242,5 +2243,6 @@ struct kvm_s390_zpci_op {
 
 /* Exit reasons for KVM_EXIT_MEMORY_FAULT */
 #define KVM_MEMFAULT_REASON_UNKNOWN (1 << 0)
+#define KVM_MEMFAULT_REASON_ABSENT_MAPPING (1 << 1)
 
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00aec43860ff1..aa3b59410a356 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+	if (kvm_vm_ioctl_check_extension(NULL, KVM_CAP_MEMORY_FAULT_NOWAIT))
+		valid_flags |= KVM_MEM_ABSENT_MAPPING_FAULT;
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -6196,7 +6199,9 @@ inline int kvm_memfault_exit_or_efault(
 
 bool kvm_memfault_exit_flags_valid(uint64_t reasons)
 {
-	uint64_t valid_flags = KVM_MEMFAULT_REASON_UNKNOWN;
+	uint64_t valid_flags
+		= KVM_MEMFAULT_REASON_UNKNOWN
+		| KVM_MEMFAULT_REASON_ABSENT_MAPPING;
 
 	return !(reasons & !valid_flags);
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

