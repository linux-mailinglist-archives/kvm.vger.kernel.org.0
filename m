Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785D6640C6A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiLBRow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiLBRov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:51 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CF2DEA64
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:47 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso2822944wmb.4
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zQKiDjoP71FNxadoa0X576EGf59j0KZM9aNu/7L6Fz4=;
        b=rWAiEzlM8ILw3AV5CTC1SdN6uxvD5Nvbi+Oh5Znh+kPd6y2m/vPoazMEuVESVlihCb
         f3s/6DImPMlJAQFuf1BiX7S4MYZVL4cCVRJQw5HIfqJRnjHu8Oq4i9KQPcd0bHYqftnt
         9PBaMVrrebaYG03g1Kz+eIn08PilsiX+1DvbHevW+wKXwWJX/VQX3f7SsAl2ESxAwmJI
         g0YdH6bZj2PYJONcdZ5QIQELl2MKrKhRtV3YmCfy+B32QiCAOrk1BajXoHZQDLKLPBPH
         Hpazd/nC69Z6zPoRuku4z+QqYjtWJT8RvYDyRn2cbHQSa7eOkwkRtJ8vwth+WJ641sf8
         i7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQKiDjoP71FNxadoa0X576EGf59j0KZM9aNu/7L6Fz4=;
        b=KUpMfc+XqJaq2v7+Iz8JGZKn8mhyNEoF5R6D3/0t8tpTr/fW8oVWabsLxpqOg2YV9Y
         kd22p6RCOTwON6TleyiKn/L87QMbQeL68z4/CqgCRyXhxS38KdZKzT5gOK7xGhjaWJ7I
         NEMTL+hvRMxFX+AIDaWNzogxiNIWOhP+qSNFFAk+PSmLhJzAu5tw9gDQK+sK18tO3jJ9
         oyaH56xy6k08vwHGtm2ucnLku29KZnvoEUXC6izs9Fxnf53BMYc4lEeSXp0Lm8Bl5vYW
         cfEFANrDmdTKv6f+CGrm8bbna0EEZIDhbjMMWzVltlNF6U+jPDmtWciTPJMyGbTIJLXm
         dXcg==
X-Gm-Message-State: ANoB5pm5f3B8J2xkhiDBJd1NvdE4XU3gOPLAc2ZDrigbWIWGehBi64cV
        5YPBotMuvfbp5NJrkre8w6/W1Uhlsixar9H1bjSpw9VgjA7F/X5f63n4v+XNfm7RLaXN/KFQXtI
        mL3GC/wnBjm/FhZ0cRIqnnRlLwjwh1rgYiV6C0yuT2vfctccx8rwpEK0=
X-Google-Smtp-Source: AA0mqf7CQ6hw5ZWdpHIXPIXksD0oKnoM4dVHvD661QNWM+YV2Lo1nBdwPFcVzckXOzhEnwQyjp4uGFjv0Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c04:b0:3cf:ecdb:bcb7 with SMTP id
 j4-20020a05600c1c0400b003cfecdbbcb7mr50768653wms.180.1670003086111; Fri, 02
 Dec 2022 09:44:46 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:57 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-13-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 12/32] Add a function that allocates aligned
 memory if specified
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

Add a variant of mmap_anon_or_hugetlbfs() that allocates memory
aligned as specified. This function doesn't map or allocate more
memory than the requested amount.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/util/util.c b/util/util.c
index 54c2b26..9f83d70 100644
--- a/util/util.c
+++ b/util/util.c
@@ -120,10 +120,17 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
 	return fd;
 }
 
-/* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
-void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+/*
+ * This function allocates memory aligned to align_sz.
+ * It also wraps the decision between hugetlbfs (if requested) or normal mmap.
+ */
+void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
+				   u64 size, u64 align_sz)
 {
 	u64 blk_size = 0;
+	u64 total_map = size + align_sz;
+	u64 start_off, end_off;
+	void *addr_map, *addr_align;
 	int fd;
 
 	/*
@@ -143,10 +150,38 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 si
 		kvm->ram_pagesize = getpagesize();
 	}
 
+	/* Create a mapping with room for alignment without allocating. */
+	addr_map = mmap(NULL, total_map, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
+			-1, 0);
+	if (addr_map == MAP_FAILED)
+		return MAP_FAILED;
+
 	fd = memfd_alloc(size, hugetlbfs_path, blk_size);
 	if (fd < 0)
 		return MAP_FAILED;
 
+	/* Map the allocated memory in the fd to the specified alignment. */
+	addr_align = (void *)ALIGN((u64)addr_map, align_sz);
+	if (mmap(addr_align, size, PROT_RW, MAP_PRIVATE | MAP_FIXED, fd, 0) ==
+	    MAP_FAILED) {
+		close(fd);
+		return MAP_FAILED;
+	}
+
+	/* Remove the mapping for unused address ranges. */
+	start_off = addr_align - addr_map;
+	if (start_off)
+		munmap(addr_map, start_off);
+
+	end_off = align_sz - start_off;
+	if (end_off)
+		munmap((void *)((u64)addr_align + size), end_off);
+
 	kvm->ram_fd = fd;
-	return mmap(NULL, size, PROT_RW, MAP_PRIVATE, kvm->ram_fd, 0);
+	return addr_align;
+}
+
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+{
+	return mmap_anon_or_hugetlbfs_align(kvm, hugetlbfs_path, size, 0);
 }
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

