Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B880E629709
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiKOLQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKOLQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:11 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38006544
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:10 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso7660688wms.8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=njesv85jjjP239HDinbsD6hTH1OvT+B1Z4Pu9bNEgcM=;
        b=cXYHdWr7aoXpAlfKObEkBwypfuREwEsdSFAOKOMVEZMfFEkZoiU3Czz8ay9I7M4IFm
         4Skw6jZnBXsdh1Z1fY8fUHw2ottmaWTZtbtq3KBq+C/KfjpLyc7ufgVMpjR4x3yuXRKn
         JERqyA/L4x5bF2xPOc0iGvhdc8Pl3YDYebsUGSkZfjOZcjk17wzlUfrY6TCkiwPNtraT
         vT4tlvCHflWw1h0s2HSIjSm1/A2Suy9f8IyvJyB0D2/UAdArClCCFw2lL3p17epbtOkt
         7mYRxCQpsDOkPiZnNLEpgNye5wQ6AQXKkyth4BiQqps1nRqccQGBkvUBRBC44OTNsVXE
         U1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=njesv85jjjP239HDinbsD6hTH1OvT+B1Z4Pu9bNEgcM=;
        b=zjx6dDcocjj7ol9p1rIg9zZDsn9VdWOqlUhzE4oJZF8aKrwMK6Ha1qUxipy1B+p3ik
         GsYferepqN2zGHEsycBZw91bGrwlgPG5kLTi0xsQeCUx3EsNBmZlXf8qSAeAsdejb2op
         rfp+F/4oJ2sM/uXtm9WO/0DL2Xeb7NPmQVp1M47rRY7mja/e29myF/L2sb+arAHccxeT
         X4+9PW+/S2US7wvmdfrHQSkznMT8vHqm3XMngQYOz2k9qwE3onrUJxd7r4ZlghlH9EZN
         R9f3c+sSRpA3e73rzpBqWN7IM+puQK6XpDu7evZ4QCALGaRMXMVxiL7lhI44ymGM5lGC
         B0Hg==
X-Gm-Message-State: ANoB5pnG73rPZC3ucTMdxBLwj5JhVDEEnDLLw+b3qp72F60NL6m+oMLy
        Vw6J9oXDy9wa/VLag4B88eelzPTWIjkFAxjo1arpzFPcazT3sbiDPnQ/AAWDUWbwUdAp2ynyU6G
        69Poym7TgNiyP48GA/sO9hBGjZsJ0ZKho8MhKnhvTdQ0cymHq0J1tZL8=
X-Google-Smtp-Source: AA0mqf7ME0nM78asXz1TaaB0fkOWJ0iQV7M6gwDQS1d4ZCujhn76mFPDmhiVoqubfqOke8Xn0kCva7piGg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c92:b0:3cf:7b65:76c5 with SMTP id
 k18-20020a05600c1c9200b003cf7b6576c5mr1065873wms.166.1668510969270; Tue, 15
 Nov 2022 03:16:09 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:40 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-9-tabba@google.com>
Subject: [PATCH kvmtool v1 08/17] Use memfd for all guest ram allocations
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

Allocate all guest ram backed by memfd/ftruncate instead of
anonymous mmap. This will make it easier to use kvm with fd-based
kvm guest memory proposals [*]. It also would make it easier to
use ipc memory sharing should that be needed in the future.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.intel.com/
---
 include/kvm/kvm.h  |  1 +
 include/kvm/util.h |  3 +++
 kvm.c              |  4 ++++
 util/util.c        | 33 ++++++++++++++++++++-------------
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 3872dc6..d0d519b 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -87,6 +87,7 @@ struct kvm {
 	struct kvm_config	cfg;
 	int			sys_fd;		/* For system ioctls(), i.e. /dev/kvm */
 	int			vm_fd;		/* For VM ioctls() */
+	int			ram_fd;		/* For guest memory. */
 	timer_t			timerid;	/* Posix timer for interrupts */
 
 	int			nrcpus;		/* Number of cpus to run */
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 61a205b..369603b 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
+int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
+void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *htlbfs_path,
+				   u64 size, u64 align);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/kvm.c b/kvm.c
index 78bc0d8..ed29d68 100644
--- a/kvm.c
+++ b/kvm.c
@@ -160,6 +160,7 @@ struct kvm *kvm__new(void)
 	mutex_init(&kvm->mem_banks_lock);
 	kvm->sys_fd = -1;
 	kvm->vm_fd = -1;
+	kvm->ram_fd = -1;
 
 #ifdef KVM_BRLOCK_DEBUG
 	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
@@ -174,6 +175,9 @@ int kvm__exit(struct kvm *kvm)
 
 	kvm__arch_delete_ram(kvm);
 
+	if (kvm->ram_fd >= 0)
+		close(kvm->ram_fd);
+
 	list_for_each_entry_safe(bank, tmp, &kvm->mem_banks, list) {
 		list_del(&bank->list);
 		free(bank);
diff --git a/util/util.c b/util/util.c
index d3483d8..278bcc2 100644
--- a/util/util.c
+++ b/util/util.c
@@ -102,36 +102,38 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
 	return sfs.f_bsize;
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size, u64 blk_size)
+int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
 {
 	const char *name = "kvmtool";
 	unsigned int flags = 0;
 	int fd;
-	void *addr;
-	int htsize = __builtin_ctzl(blk_size);
 
-	if ((1ULL << htsize) != blk_size)
-		die("Hugepage size must be a power of 2.\n");
+	if (hugetlb) {
+		int htsize = __builtin_ctzl(blk_size);
 
-	flags |= MFD_HUGETLB;
-	flags |= htsize << MFD_HUGE_SHIFT;
+		if ((1ULL << htsize) != blk_size)
+			die("Hugepage size must be a power of 2.\n");
+
+		flags |= MFD_HUGETLB;
+		flags |= htsize << MFD_HUGE_SHIFT;
+	}
 
 	fd = memfd_create(name, flags);
 	if (fd < 0)
-		die("Can't memfd_create for hugetlbfs map\n");
+		die("Can't memfd_create for memory map\n");
+
 	if (ftruncate(fd, size) < 0)
 		die("Can't ftruncate for mem mapping size %lld\n",
 			(unsigned long long)size);
-	addr = mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
-	close(fd);
 
-	return addr;
+	return fd;
 }
 
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
 	u64 blk_size = 0;
+	int fd;
 
 	/*
 	 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
@@ -146,9 +148,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 		}
 
 		kvm->ram_pagesize = blk_size;
-		return mmap_hugetlbfs(kvm, htlbfs_path, size, blk_size);
 	} else {
 		kvm->ram_pagesize = getpagesize();
-		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
+
+	fd = memfd_alloc(size, htlbfs_path, blk_size);
+	if (fd < 0)
+		return MAP_FAILED;
+
+	kvm->ram_fd = fd;
+	return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0);
 }
-- 
2.38.1.431.g37b22c650d-goog

