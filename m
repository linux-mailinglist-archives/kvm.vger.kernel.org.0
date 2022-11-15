Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52108629708
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiKOLQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKOLQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:18 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F171B6D
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:17 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id bi19-20020a05600c3d9300b003cf9d6c4016so10366541wmb.8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NIh7hm1vgq4axzRzMsuAHgxMQ1Qyi0g563BuecOU0iE=;
        b=o/Jm+iBUclqgHWET7gEwK75p2CjV30bgbQzC70E902kLfWQgtP44WMCJ0lCGQqmDsK
         BkhQCaFXmTT6VQwO03RVgDIaKaPqybik6PgGWyf3IYT4nAMwa5yVjGCSbfCAiXHNHJLT
         II7lS9qvGkpgd+0D1+oq09Ug7VgotF7yYOm6RV+XzHMYwzdMBHFWy5zB4v5ziRjIm2Ef
         l95IWqLwDLgnQ73kYtckKrDKTNUD2QXd9SipslLlxZrscMStpAH5JpaQMZzP0TypFgAk
         ZSbJlvLM1JIX2bmz6WhU2muRiE8uuukk3dMyPjvNfeFTNf++M17He9b/kIlhfz5Fl1na
         qTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NIh7hm1vgq4axzRzMsuAHgxMQ1Qyi0g563BuecOU0iE=;
        b=waVs5W4PDehJ1fPrRF0z/kmcunNlkxbbpuHxX/Vfz3G4TwoufupCYJlhsrWpcRZ4aT
         /wE5XcuGucO+yb1HoGSa6kHJw07NcZzAdo7evDSoRBz9pkcrm2iVTTnQvD0iLJRT8p6j
         ojstkocaCQL9+u6wEaAwzJU3q00sqJt1cukgvgd/XrKNs2TKIN6wSFxuNdh8DMVa+zsE
         He5Fx9GDTu/7tqxDsf5xlyKh8ZoJZT97h94jXqpcKonzOAycTOG29P/hkhIHHMMMujl6
         0oud1ATAaFXncfSc6wNJMkIZPe5fEzyW9FdD//daD9jC5XuE7Dh/6YniSU7XCFCc6wAD
         UiTA==
X-Gm-Message-State: ANoB5plykhUIh6nz79zdHrSqRdwUWB9vri4lbZKOIhrGAOhpYgWqNSKs
        RjDsI9/04cKKpYpdksQ9hl/gAwPX7/hagQEO1g9n7AiuvJVKiZvAdUVwwXd/X5KmmYHI9QEvmrZ
        eoYlbrErSkAYOy9uT/KxZxHHt7zS87WSnOh90Cs/mPL/lcrmyaWiDpZA=
X-Google-Smtp-Source: AA0mqf5wOnNfPMSuwQH//NTcL25qBdsbJ1MQADv5FF1HKdx1IxtXGrKCoiQ9oiCnCxXlBzmsAxpp76icwQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a1c:a302:0:b0:3c4:5806:104e with SMTP id
 m2-20020a1ca302000000b003c45806104emr1108716wme.42.1668510975995; Tue, 15 Nov
 2022 03:16:15 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:43 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-12-tabba@google.com>
Subject: [PATCH kvmtool v1 11/17] Add a function that allocates aligned memory
 if specified
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

Add a variant of mmap_anon_or_hugetlbfs() that allocates memory
aligned as specified. This function doesn't map or allocate more
memory than the requested amount.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/util/util.c b/util/util.c
index 278bcc2..953e2d8 100644
--- a/util/util.c
+++ b/util/util.c
@@ -129,10 +129,17 @@ int memfd_alloc(u64 size, bool hugetlb, u64 blk_size)
 	return fd;
 }
 
-/* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
-void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+/*
+ * This function allocates memory aligned to align_sz.
+ * It also wraps the decision between hugetlbfs (if requested) or normal mmap.
+ */
+void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *htlbfs_path,
+				   u64 size, u64 align_sz)
 {
 	u64 blk_size = 0;
+	u64 total_map = size + align_sz;
+	u64 start_off, end_off;
+	void *addr_map, *addr_align;
 	int fd;
 
 	/*
@@ -152,10 +159,38 @@ void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 		kvm->ram_pagesize = getpagesize();
 	}
 
+	/* Create a mapping with room for alignment without allocating. */
+	addr_map = mmap(NULL, total_map, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS,
+			-1, 0);
+	if (addr_map == MAP_FAILED)
+		return MAP_FAILED;
+
 	fd = memfd_alloc(size, htlbfs_path, blk_size);
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
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+{
+	return mmap_anon_or_hugetlbfs_align(kvm, htlbfs_path, size, 0);
 }
-- 
2.38.1.431.g37b22c650d-goog

