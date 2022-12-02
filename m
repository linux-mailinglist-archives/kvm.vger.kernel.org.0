Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE298640C78
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiLBRp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiLBRpd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:33 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FD2E0740
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:23 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id v188-20020a1cacc5000000b003cf76c4ae66so4440515wme.7
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tfiJ2mCVxWsxcWxP4lFGuce8U8ci+ACFUdji+1DMoMo=;
        b=dVmyIp1ooDfs+sq2MVmdV6sxUyN6x3Pc3lnTq80AlOv62NL7B7sM0KTJ7QCcgaqoQO
         jX9UVbi5QEuPYbRuzb3ObdfCcJSnx0dmKya4GPLtLNzedWGpM2ReWdTtD5xpImZ5Zk5P
         Rb8IsgC1auAJQmmSQysKmQhhhwOVIeobIusXA52rc43M19YGNNsJrqzh6Qb3XBHKmtFg
         vH85Ov692x55iCJo1FH1+BGEIk/dXFB5MU5W/nzz2i9E16VJLndxGbh/NZqDM8EU6P16
         FFwFtBpBALPQFylFgLRQrDAx5cfeB5GhCC0gM2enbwH6hqFhLzRgK5eDbBezgAK4vNJu
         5Q7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tfiJ2mCVxWsxcWxP4lFGuce8U8ci+ACFUdji+1DMoMo=;
        b=OQULs6SahYza36+JBFO4XBxfJ/nyr/jTii4QKxHoWgJWXkr5BwgenDLqkS0xU8OE7F
         p1W2hi4+OJpGnYeXQcw8B1TZbBAeCimCFyDhuafAGyJF+mY2e1VWXgQ7NU4hUbrNhhL4
         3bRKYkJMJpDozXALWLkHMpjAxF6Zlu6CkUk1apbZdc2eDx8szkR9PI58OllJLGt7D5R0
         7ygsKJiRcFiHqtStJwboUjETtk6hmCrvfr8zfh60Yp/2fQjIBd0spGiHBTnNmWorBVhm
         Q/9n4dt7eSEZE4V/LCpmGZIhIPirnNk+baavzMuT52pmKWl31KXsiVvAyXb4JCRnJ/Ce
         Km7Q==
X-Gm-Message-State: ANoB5pmuzYQYE0AdsYJ7oxwVIhNJziImoobJ9bhnMtAomPtqo4KIRYbE
        N2YeTjwNgCpEM0gyQ5Fl6G46/kDGD1v8MMzJxxnIyBtrNuOihrxgs/X44pAZ58DUDtzaz55Yvz1
        5pQ50p6MhL6ALdfcZbS+2bJYFj8zAEcm2BsRLF77r/JkGqoQGJGv0Atg=
X-Google-Smtp-Source: AA0mqf6vYZf7PTbisFcht2A4L79+L4Lho4V6MeOta9c5Pfs53CZcGoaaQTDWkjciRgh105QRhv8usiYkxg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d4:b0:3cf:84e9:e722 with SMTP id
 r20-20020a05600c35d400b003cf84e9e722mr51385974wmq.8.1670003112844; Fri, 02
 Dec 2022 09:45:12 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:10 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-26-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 25/32] Allocate guest memory as restricted if needed
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

If specified by the option and supported by KVM, allocate guest
memory as restricted with the new system call.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch64/pvtime.c |  2 +-
 hw/vesa.c            |  2 +-
 include/kvm/util.h   |  2 +-
 util/util.c          | 12 ++++++++----
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index a452938..8247c52 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -16,7 +16,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
 	int mem_fd;
 	int ret = 0;
 
-	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0);
+	mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0);
 	if (mem_fd < 0)
 		return -errno;
 
diff --git a/hw/vesa.c b/hw/vesa.c
index 3233794..6c5287a 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -90,7 +90,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 	if (r < 0)
 		goto unregister_ioport;
 
-	mem_fd = memfd_alloc(ARM_PVTIME_SIZE, false, 0, 0);
+	mem_fd = memfd_alloc(kvm, ARM_PVTIME_SIZE, false, 0, 0);
 	if (mem_fd < 0) {
 		r = -errno;
 		goto unregister_device;
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 79275ed..5a98d4a 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -139,7 +139,7 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
-int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
+int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 hugepage_size);
 void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
 				   u64 size, u64 align);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
diff --git a/util/util.c b/util/util.c
index 107f34d..13b3e82 100644
--- a/util/util.c
+++ b/util/util.c
@@ -17,7 +17,7 @@
 __SYSCALL(__NR_memfd_restricted, sys_memfd_restricted)
 #endif
 
-static inline int memfd_restricted(unsigned int flags)
+static int memfd_restricted(unsigned int flags)
 {
 	return syscall(__NR_memfd_restricted, flags);
 }
@@ -106,7 +106,7 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
 	return sfs.f_bsize;
 }
 
-int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
+int memfd_alloc(struct kvm *kvm, size_t size, bool hugetlb, u64 blk_size)
 {
 	const char *name = "kvmtool";
 	unsigned int flags = 0;
@@ -120,7 +120,11 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
 		flags |= blk_size << MFD_HUGE_SHIFT;
 	}
 
-	fd = memfd_create(name, flags);
+	if (kvm->cfg.restricted_mem)
+		fd = memfd_restricted(flags);
+	else
+		fd = memfd_create(name, flags);
+
 	if (fd < 0)
 		die_perror("Can't memfd_create for memory map");
 
@@ -167,7 +171,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
 	if (addr_map == MAP_FAILED)
 		return MAP_FAILED;
 
-	fd = memfd_alloc(size, hugetlbfs_path, blk_size);
+	fd = memfd_alloc(kvm, size, hugetlbfs_path, blk_size);
 	if (fd < 0)
 		return MAP_FAILED;
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

