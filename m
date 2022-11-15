Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8686862970D
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiKOLQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiKOLQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:22 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A6A1FA
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:21 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id az40-20020a05600c602800b003cfa26c40easo632337wmb.1
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNbzIEZR7wJQWpPy5wb7w4cFM9l/Az4OUx7XpiY0a/o=;
        b=LZE0OOUOxX2awpOp9ovpgPE7+BEXi2XQ3RiEpfNWqDi1/2dILneWoT+VmCqN4hvMlT
         RAZH+H84/KNhWzDy3KYJCmkqmIt25lH0kV90aEyK6I3BkAf0RT4q0cqqg5qT2+8sliiL
         xt/zaKteHtYtUnFk9+6HeD3Jo8D+uw9A1UafnZr8TNBoPvLhVf7y0CzDOqGhuLYPyiNN
         tl7hi7Z/zaNmk6dV6N4CyFQ1xMU656P5StVe2KelNLLUgAMIuKFmtXxogjQPgn9wzDuC
         D2RwHjtunnifTiubY/ASfH+pkApPEIsHMV4ms5zCk5ybtLO8ODaVDvnisL8eMk+idmZB
         PbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNbzIEZR7wJQWpPy5wb7w4cFM9l/Az4OUx7XpiY0a/o=;
        b=ILuwxDvxwYtJGbRSxVktHb1SJEECUtZAR4TzTyFaMXpbGhDTEXEbIdcU1JZkLzgD7s
         1xjSFlhZ6SkPMHqiLfXdBtAg0yktn80i6fLTN9/AOwKCmG7hIuYeOplEBBkidxd75CjT
         36LWGKA8Ldqsbdft+SurMcKSsRD3BwWzQDY+dSD4NalS1m/zfMfWJmXn7OCqx/NKNiZX
         rXtlVdBvN6R6welQ0gWuo2jqCwPYnDPb/X61djbDUsCEgdWt4H9MQdmlUblcEjiHoLTP
         FpfHngHY6MS+fIGAdHuymejHhpmAEtsvGcBLWZrGFDVrva66I1BL7mNz2qR23a18iSs+
         xKaw==
X-Gm-Message-State: ANoB5pk02SzycKAKNbR3k48TQ2ZB3ByEFBkQ9rzNBd5Xj6unYte9BI40
        IZODR3YTPK4pyihFTQ3zo2KvJjfYWq918i+b9RgVpOo67OXO06zwdfA+5x8GTKGIGR8ZIE2aDq5
        gW9Xb+m8AaESlTZWkQoBy3Jd+DNKrAj3cKkrOOTYcOFk52OTgzVq726I=
X-Google-Smtp-Source: AA0mqf63HJyuuNJh7tu8T03eM+GLeZVO/WaAg0LuJIISepyJGYgwGubPHYiK1ZPMYhQpLHv9noLyDvNzqQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:524f:0:b0:236:77f4:6e19 with SMTP id
 k15-20020a5d524f000000b0023677f46e19mr10659949wrc.638.1668510980290; Tue, 15
 Nov 2022 03:16:20 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:45 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-14-tabba@google.com>
Subject: [PATCH kvmtool v1 13/17] Remove struct fields and code used for alignment
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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

Now that the allocator allocates aligned memory, remove
arch-specific code and struct fields used for alignment.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/include/arm-common/kvm-arch.h |  7 -------
 arm/kvm.c                         | 31 +++++++++++--------------------
 riscv/include/kvm/kvm-arch.h      |  7 -------
 riscv/kvm.c                       | 21 +++++++--------------
 4 files changed, 18 insertions(+), 48 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b2ae373..654abc9 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -96,13 +96,6 @@ static inline bool arm_addr_in_ioport_region(u64 phys_addr)
 }
 
 struct kvm_arch {
-	/*
-	 * We may have to align the guest memory for virtio, so keep the
-	 * original pointers here for munmap.
-	 */
-	void	*ram_alloc_start;
-	u64	ram_alloc_size;
-
 	/*
 	 * Guest addresses for memory layout.
 	 */
diff --git a/arm/kvm.c b/arm/kvm.c
index 0e5bfad..770075e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -27,7 +27,6 @@ bool kvm__arch_cpu_supports_vm(void)
 void kvm__init_ram(struct kvm *kvm)
 {
 	u64 phys_start, phys_size;
-	void *host_mem;
 	int err;
 
 	/*
@@ -37,42 +36,34 @@ void kvm__init_ram(struct kvm *kvm)
 	 * 2M trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = kvm->cfg.ram_size;
-	kvm->arch.ram_alloc_size = kvm->ram_size;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs_align(kvm,
-						kvm->cfg.hugetlbfs_path,
-						kvm->arch.ram_alloc_size,
-						SZ_2M);
+	kvm->ram_start = mmap_anon_or_hugetlbfs_align(kvm,
+						      kvm->cfg.hugetlbfs_path,
+						      kvm->ram_size, SZ_2M);
 
-	if (kvm->arch.ram_alloc_start == MAP_FAILED)
+	if (kvm->ram_start == MAP_FAILED)
 		die("Failed to map %lld bytes for guest memory (%d)",
-		    kvm->arch.ram_alloc_size, errno);
+		    kvm->ram_size, errno);
 
-	kvm->ram_start = kvm->arch.ram_alloc_start;
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_HUGEPAGE);
+	madvise(kvm->ram_start, kvm->ram_size, MADV_MERGEABLE);
+	madvise(kvm->ram_start, kvm->ram_size, MADV_HUGEPAGE);
 
 	phys_start	= kvm->cfg.ram_addr;
 	phys_size	= kvm->ram_size;
-	host_mem	= kvm->ram_start;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	err = kvm__register_ram(kvm, phys_start, phys_size, kvm->ram_start);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
 
 	kvm->arch.memory_guest_start = phys_start;
 
-	pr_debug("RAM created at 0x%llx - 0x%llx (host_mem 0x%llx)",
-		 phys_start, phys_start + phys_size - 1, (u64)host_mem);
+	pr_debug("RAM created at 0x%llx - 0x%llx (host ram_start 0x%llx)",
+		 phys_start, phys_start + phys_size - 1, (u64)kvm->ram_start);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
-	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+	munmap(kvm->ram_start, kvm->ram_size);
 }
 
 void kvm__arch_read_term(struct kvm *kvm)
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 1e130f5..5bb7eee 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -56,13 +56,6 @@
 struct kvm;
 
 struct kvm_arch {
-	/*
-	 * We may have to align the guest memory for virtio, so keep the
-	 * original pointers here for munmap.
-	 */
-	void	*ram_alloc_start;
-	u64	ram_alloc_size;
-
 	/*
 	 * Guest addresses for memory layout.
 	 */
diff --git a/riscv/kvm.c b/riscv/kvm.c
index e26b4f0..d05b8e4 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -48,7 +48,7 @@ void kvm__init_ram(struct kvm *kvm)
 
 void kvm__arch_delete_ram(struct kvm *kvm)
 {
-	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+	munmap(kvm->ram_start, kvm->ram_size);
 }
 
 void kvm__arch_read_term(struct kvm *kvm)
@@ -70,23 +70,16 @@ void kvm__arch_init(struct kvm *kvm)
 	 * 2M trumps 64K, so let's go with that.
 	 */
 	kvm->ram_size = min(kvm->cfg.ram_size, (u64)RISCV_MAX_MEMORY(kvm));
-	kvm->arch.ram_alloc_size = kvm->ram_size;
-	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs_align(kvm,
-						kvm->cfg.hugetlbfs_path,
-						kvm->arch.ram_alloc_size,
-						SZ_2M);
+	kvm->ram_start = mmap_anon_or_hugetlbfs_align(kvm,
+						      kvm->cfg.hugetlbfs_path,
+						      kvm->ram_size, SZ_2M);
 
-	if (kvm->arch.ram_alloc_start == MAP_FAILED)
+	if (kvm->ram_start == MAP_FAILED)
 		die("Failed to map %lld bytes for guest memory (%d)",
 		    kvm->arch.ram_alloc_size, errno);
 
-	kvm->ram_start = kvm->arch.ram_alloc_start;
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
-
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_HUGEPAGE);
+	madvise(kvm->ram_start, kvm->ram_size, MADV_MERGEABLE);
+	madvise(kvm->ram_start, kvm->ram_size, MADV_HUGEPAGE);
 }
 
 #define FDT_ALIGN	SZ_4M
-- 
2.38.1.431.g37b22c650d-goog

