Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6638B640C6C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiLBRo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiLBRo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:58 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA06EDEA63
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:51 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so4436826wmp.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tb2/i5z2SM49ghSm0/D7B5+7IVHEWxAtSa+JkItmtE8=;
        b=dxd4OPFsvb86d3Iq1zAP3skHvxX32mkUw3Sv9ToO46aFddL6Q2j8UHOVVqs2DLyLO8
         vvSsQsrnmGNfLvOJtC8J/yAEizF/JR/IYli/HV22CrpASLqdwlNf6DZKd4iWonuRCKbj
         k9B6UACXZ5iwdIV+JcISFA33XvpVQm/hUyWU6xwVx6vJROwi0DTSitCb+COxFp+y+DjE
         +6ycxKjG8Xd1qIXFFy6wByjPo3H4A+5AoflIIWxdaJhTZtAbxoAd7mwbnUiiduoxz2bL
         kHKjL2f6VWHgVNMEA+BnFxhZZ9H0ZWpcoGRqRXDg3Dg6WmQWBgDps0ZktzQbB6i8byos
         neiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tb2/i5z2SM49ghSm0/D7B5+7IVHEWxAtSa+JkItmtE8=;
        b=xq+0r7+yd5w+QQkTALlwUJTwt2NsA2QPcbaC8VMQmtPGhObXrsVJdOZNTXVLtNsW8t
         JmRaMwGTamQ3eXpxgEDjUey+H2doUEYq3RyIRQguXOxUdGJq5MvSysdtyq0xEVbIL5sT
         I0ad65xXhSEWP6fsRkYwV7TJU+VGK7bRwgl8rSbC5RsbLSPHaOYmQxeMsP8hmZzwY60G
         9DdU5VB6u/pHw76WH6WB2nZH+2rOHmfQiSamHR8ocurnVs8xnGX9JgF9vOXw8y0OJHqn
         7E4K7gwbHcsFrzUu5+vVaUis6i5F76y5DCKesAzIuO0les40TnaZawDRp80SSSjLKY3G
         jCGA==
X-Gm-Message-State: ANoB5plTuJiVieEDZuTayRGCezoPTWz3fypywLGlGYKto3hmPdP9NO38
        kOoIR2DOiVqrHo6RP2/UcgSrPeHwejCTNO6Z9HxzHAViF15WwfZjDq6e7JqbJNXIk6vjH5ZNn4N
        /4SpkCsGdjLqWZCVzT7xRxxb+tCNIMBe5XYvaQIvx+KLc1US8y1sVQpM=
X-Google-Smtp-Source: AA0mqf6FrWavDFFYV1M8keBaJIE2TsVugeLr/0Dq4N98C4cBZrsGtGfVj1uM7Num2k2KgPdqZqsIjy1K6g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1f1b:b0:3cf:35c8:289f with SMTP id
 bd27-20020a05600c1f1b00b003cf35c8289fmr45006220wmb.153.1670003090215; Fri, 02
 Dec 2022 09:44:50 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:59 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-15-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 14/32] Remove struct fields and code used for alignment
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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
2.39.0.rc0.267.gcb52ba06e7-goog

