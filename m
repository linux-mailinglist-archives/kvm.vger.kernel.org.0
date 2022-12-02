Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F0B640C67
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiLBRoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiLBRom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:42 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E20ADEA5B
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:41 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id h4-20020a1c2104000000b003d01b66fe65so4456192wmh.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mo9Hvguu8h16c/AUECuaAHaIG4PTEnHfuKBpU6xwF0=;
        b=PCIOZi62Y0UTBF/YESMprw6PGKgiXgx9zgBz156PqwP5jTuq+bAJ3dwHTkB0J9krqS
         Sxdyxq8AELHX4pL1+6ZQVKcfl/TWFgJUwiPDFZ+Cja5VVaQZ1+i6LGsaVDNU1Wc96YRF
         5CxKb7ft2b3oczw6lKgf9/owM2z2g459NM+gCiDBh67y57fVgwA/lYeXIQBPp9BWDJQH
         AuphDwz9Xr3gWkaCmF+wMoBpkgXttcxGTqyE4lb6t4S5vmJ8QG6CNCz95az1mnxz0VWZ
         ekbxUy6s28nBw3jVVeR+nIveN7bu6e1EndOx9c9P5p1PGc2janMUI0hHIxBq7JTfRkZ0
         PPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7mo9Hvguu8h16c/AUECuaAHaIG4PTEnHfuKBpU6xwF0=;
        b=gIDuR2MwUZKVbqoil0IvjvgHLobX13yFpH6XqA1Xw7pJ3dSA4HNFY2BpzMRcS6YYB/
         /i05+NSZR43CEagDeCyHZ6UdGelfVgaXSh2GL3b0OQd026yiq/Cr5TbF838dRs4mANHI
         mcm9Z7a/zDmf4o02ByA5HB403loNGn4fOiDrNoVhwmB867bpSrwEkLa3f9dRoGNMfw+n
         v1RYwo6lhuWcvVPr0Mtsmk5nxs0dTkA3Z7cvjf+4pD805By+cN8Gkn0sSY7MAOSEOuIx
         2itR7wN0uFZWsD1AueUQ6NGQxvEeTQNb6vPq0aTKlPED34nzp9I8gdKCFZ7t/DUMwQK6
         YvYA==
X-Gm-Message-State: ANoB5pnXuuixrCYqGnMCmXDL/0bqYc0TMz3L32AEXgMeMLsQMn12MP2w
        v/pYBTl08D29GZ7dqh+uaaFBvPH716NLnFzJ+AfZKYd5SVM/9zyE3t+f+l7A0xtR1mWKKB21PCt
        yN6Vs/AF66WAZW2rCPwczMizXZ68DtaECQ+L8OVTqmnrZ+8UEzFytZCs=
X-Google-Smtp-Source: AA0mqf4/IWzVyPS1V+YdpUkdDFQsK5YpaG/BIzsYKCGydfH8dp/mdYUXHsSFfTvFClrIdoxvlmC39aNuRg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3c91:b0:3cf:6f23:a3e3 with SMTP id
 bg17-20020a05600c3c9100b003cf6f23a3e3mr3618433wmb.1.1670003079610; Fri, 02
 Dec 2022 09:44:39 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:54 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-10-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 09/32] Use memfd for all guest ram allocations
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

Allocate all guest ram backed by memfd/ftruncate instead of
anonymous mmap. This will make it easier to use kvm with fd-based
kvm guest memory proposals [*]. It also would make it easier to
use ipc memory sharing should that be needed in the future.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
---
 include/kvm/kvm.h  |  1 +
 include/kvm/util.h |  3 +++
 kvm.c              |  4 ++++
 util/util.c        | 30 ++++++++++++++++++------------
 4 files changed, 26 insertions(+), 12 deletions(-)

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
index b0c3684..74713d9 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -140,6 +140,9 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
+int memfd_alloc(u64 size, bool hugetlb, u64 blk_size);
+void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
+				   u64 size, u64 align);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/kvm.c b/kvm.c
index 765dc71..84a8675 100644
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
index 93f895a..54c2b26 100644
--- a/util/util.c
+++ b/util/util.c
@@ -95,35 +95,36 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
 	return sfs.f_bsize;
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size, u64 blk_size)
+int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
 {
 	const char *name = "kvmtool";
 	unsigned int flags = 0;
 	int fd;
-	void *addr;
 
-	if (!is_power_of_two(blk_size))
-		die("Hugepage size must be a power of 2");
+	if (hugetlb) {
+		if (!is_power_of_two(blk_size))
+			die("Hugepage size must be a power of 2");
 
-	flags |= MFD_HUGETLB;
-	flags |= blk_size << MFD_HUGE_SHIFT;
+		flags |= MFD_HUGETLB;
+		flags |= blk_size << MFD_HUGE_SHIFT;
+	}
 
 	fd = memfd_create(name, flags);
 	if (fd < 0)
-		die_perror("Can't memfd_create for hugetlbfs map");
+		die_perror("Can't memfd_create for memory map");
+
 	if (ftruncate(fd, size) < 0)
 		die("Can't ftruncate for mem mapping size %lld",
 			(unsigned long long)size);
-	addr = mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
-	close(fd);
 
-	return addr;
+	return fd;
 }
 
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
 {
 	u64 blk_size = 0;
+	int fd;
 
 	/*
 	 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
@@ -138,9 +139,14 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
 		}
 
 		kvm->ram_pagesize = blk_size;
-		return mmap_hugetlbfs(kvm, hugetlbfs_path, size, blk_size);
 	} else {
 		kvm->ram_pagesize = getpagesize();
-		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
+
+	fd = memfd_alloc(size, hugetlbfs_path, blk_size);
+	if (fd < 0)
+		return MAP_FAILED;
+
+	kvm->ram_fd = fd;
+	return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0);
 }
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

