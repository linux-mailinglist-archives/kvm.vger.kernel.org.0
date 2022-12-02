Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7BC640C6F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiLBRph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiLBRpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:24 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEDEEDD67
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:07 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id o8-20020adfba08000000b00241e80f08e0so1242658wrg.12
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+AbD6eW9Ewpp9J8IQbS9YAmB+Rhm6ksZAMygNcR9t8c=;
        b=EqAA7GvZjA3UQUsiM1sFAaY3+Lc9qdPmYo9pQT/hppuVBWNJBekOUoeh48RG1U/2r7
         ISk0VDTjQs+yss+qj/Jn8rwoOKVbZk1gFucEoh8GvnI+SqWzwsCJcjCY6rq/l3xzw5MA
         VxgU41jzXvPvvqXgqxJDGH5Ja99YnKB/iunHg/oo05W1nHb2+tSBd1fAFQQIuAGbjyTE
         qy0Xvp4rwnqkB8WU3YBTa+jcrZjOI0lYd6WiHZ6ljZqJEm+wvc+6FfjXBrlPZFhyrJNR
         ytMun4VrlAGN3/AFA9tTHwk4w4rB8z4QbYa65kxiqua0RkmQCSbGxU03STJXIcK+1GQ9
         6/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+AbD6eW9Ewpp9J8IQbS9YAmB+Rhm6ksZAMygNcR9t8c=;
        b=fWGd1LLpsETBOXGKsJHDNpl8bPb2QsrcnkfimdgGBkH+qmrMlaCaK7ew3az+ruP6kQ
         20TzZQB/Q1p5HK6DXNApiagbGdZRyLdLkMfPAvndHzCNFuZODQmyupSlzb37lQaTl59m
         DjNNT7pNuggKFqQz2AGphpdKh4mN2hDTCvDZZmL2gMrgHdlh/Ik4X0iV5RNIPv1IJjnB
         WhDCZzencIMGvmy3bI8HvYWbUkmJhDw+crC5Gr3Ks3abhdHtM7sJ1ULhx05tz646U+NC
         bv8gd/lQDNfMS8vWcK1/ZR6rJe8/i4PibTnTRfROny4VF8PUIp68VMlhIvh+/P1YDM0h
         fWnw==
X-Gm-Message-State: ANoB5pkoTy7kZL4/eoc5X5MjfwNk/u8P+MXWQmnPDydNPemlHRZhyx9k
        pwxVFlWBbrvuNVbE/KjiNP/OhrGitr5m2SnwowoNTTFUZKYeinv4GmVuS/aqERqNhDLg9ntrxz8
        MHKQl9+urgY6GkXMm3IdPUzGBJeCg28UvfS7AD+EEvqnfcgqBLsDxlas=
X-Google-Smtp-Source: AA0mqf7R2VP/tC7C+nsn7l94H4EkFZm2cjbL5Ywl8fXgv8dPRI1bKyYJ/EH7XGxzZBSHGt2EhIYJ7C3tRg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1e0c:b0:242:3fa4:820d with SMTP id
 bj12-20020a0560001e0c00b002423fa4820dmr3875733wrb.564.1670003096056; Fri, 02
 Dec 2022 09:44:56 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:02 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-18-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 17/32] Factor out set_user_memory_region code
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

This is common code, and will be reused in the future when
setting memory regions using file descriptors.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 kvm.c       | 53 ++++++++++++++++++++++++++++-------------------------
 util/util.c |  2 +-
 2 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/kvm.c b/kvm.c
index 3a3383a..c71646f 100644
--- a/kvm.c
+++ b/kvm.c
@@ -193,10 +193,30 @@ int kvm__exit(struct kvm *kvm)
 }
 core_exit(kvm__exit);
 
+
+static int set_user_memory_region(int vm_fd, u32 slot, u32 flags,
+				  u64 guest_phys, u64 size,
+				  u64 userspace_addr)
+{
+	int ret = 0;
+	struct kvm_userspace_memory_region mem = {
+		.slot			= slot,
+		.flags			= flags,
+		.guest_phys_addr	= guest_phys,
+		.memory_size		= size,
+		.userspace_addr		= (unsigned long)userspace_addr,
+	};
+
+	ret = ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
+	if (ret < 0)
+		ret = -errno;
+
+	return ret;
+}
+
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		     void *userspace_addr)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *bank;
 	int ret;
 
@@ -220,18 +240,10 @@ int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		goto out;
 	}
 
-	mem = (struct kvm_userspace_memory_region) {
-		.slot			= bank->slot,
-		.guest_phys_addr	= guest_phys,
-		.memory_size		= 0,
-		.userspace_addr		= (unsigned long)userspace_addr,
-	};
-
-	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
-	if (ret < 0) {
-		ret = -errno;
+	ret = set_user_memory_region(kvm->vm_fd, bank->slot, 0, guest_phys, 0,
+				     (u64) userspace_addr);
+	if (ret < 0)
 		goto out;
-	}
 
 	list_del(&bank->list);
 	free(bank);
@@ -246,7 +258,6 @@ out:
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		      void *userspace_addr, enum kvm_mem_type type)
 {
-	struct kvm_userspace_memory_region mem;
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
 	struct list_head *prev_entry;
@@ -327,19 +338,11 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 		flags |= KVM_MEM_READONLY;
 
 	if (type != KVM_MEM_TYPE_RESERVED) {
-		mem = (struct kvm_userspace_memory_region) {
-			.slot			= slot,
-			.flags			= flags,
-			.guest_phys_addr	= guest_phys,
-			.memory_size		= size,
-			.userspace_addr		= (unsigned long)userspace_addr,
-		};
-
-		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
-		if (ret < 0) {
-			ret = -errno;
+		ret = set_user_memory_region(kvm->vm_fd, slot, flags,
+					     guest_phys, size,
+					     (u64) userspace_addr);
+		if (ret < 0)
 			goto out;
-		}
 	}
 
 	list_add(&bank->list, prev_entry);
diff --git a/util/util.c b/util/util.c
index 9f83d70..1f2e1a6 100644
--- a/util/util.c
+++ b/util/util.c
@@ -141,7 +141,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
 		blk_size = get_hugepage_blk_size(hugetlbfs_path);
 
 		if (blk_size == 0 || blk_size > size) {
-			die("Can't use hugetlbfs pagesize %lld for mem size %lld\n",
+			die("Can't use hugetlbfs pagesize %lld for mem size %lld",
 				(unsigned long long)blk_size, (unsigned long long)size);
 		}
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

