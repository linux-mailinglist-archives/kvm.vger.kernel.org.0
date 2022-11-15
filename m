Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90832629705
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiKOLQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiKOLQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:07 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65395D4B
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:06 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id e21-20020adfa455000000b002365c221b59so2714631wra.22
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=26VBHozH/ssHVsrP9L0J/EmUTUmUD0yTnS7gQZzHSbA=;
        b=JaVSiVDblGruLINE/fEkVVoNILKUmiZNdYmy1+Ma4W7gV/2jUmEmtUjUdvf3oqfgX9
         uD1kOaXeCwP8jt/mHzvxgudBxhQlFBKak6VZ4QyYirRjEztkVj/Vewp2B2BB2sK+v363
         7hJPdsjvtzHXpkMKJvPZKKZBqL8bQCcnfYJJCZ82hH7ygSGhq6xq/DlOsoh6wI2gz7kR
         JeoZMCZ2HIun1QQxQGf3J4IrEDN99lVx71UQOCxRVjPj9ZpxZUFeo5ZJubKj429nbaba
         vQedRN13pXh6AidrXv82HaQQTq9XM70SVwtLHxwiyerY1+r/bdN2zPQcbk7fO/X8uxtm
         TRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=26VBHozH/ssHVsrP9L0J/EmUTUmUD0yTnS7gQZzHSbA=;
        b=irG7px0+IIsf0uVvpBSfHwFBPStl4xUWnnDokjS7eDS9QvfQAX/XW4tW6lMUQabUlj
         3Ai62Vn8v9qMhdrp7yW8qhEf8ccRNfG6o5NDGxhR5bojhNqU0ivoOGdwapT6NWwao5f5
         W+5AreXAWWtJASVweZoxcmsZa0+B4eXvaUEULTjHY3PSe5N1vARyUlS5c/HkkMNIc4Dt
         zuCJnSzwyjKyHdKimX786ntnNN1IY3H/KdUgaMwlIIpPjBjhf+Dznf++V2Qbxa83rY9g
         L18UvNH2cRzZ9NnHxQBIvvYu7nLWOmTtfE8fvFdWKaTY5s7Ihe/BTCNFsBPwyu5Vo0Eh
         DYZA==
X-Gm-Message-State: ANoB5pkgF+QQYIxHBGgeFDIHEJqUXahdqxYsUNs2NW2qMhKvgNrlqLFW
        /Hg6lHl/+oZXy+yV6GHXFLAKFNI1uhJ4nNQL5C/25t+pRUOHgtX/U7DKkSglheRtDDcYK9ZgYhn
        33SfTHU1NjKT1t9wAoYKUhOgwX5E9U3NuG+Q0xG86Ncxs3Y96Kjxp+78=
X-Google-Smtp-Source: AA0mqf4XO9C7Oo358sPPZ583/1GcxF7fOVepdBvRLiczdWYGhKSWftJgBGy3kuBy7Non1Oq+ImBV246TxA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c013:0:b0:3cf:90de:7724 with SMTP id
 c19-20020a7bc013000000b003cf90de7724mr55710wmb.18.1668510964918; Tue, 15 Nov
 2022 03:16:04 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:38 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-7-tabba@google.com>
Subject: [PATCH kvmtool v1 06/17] Use memfd for hugetlbfs when allocating
 guest ram
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

This removes the need of using a temporary file for the fd.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/util/util.c b/util/util.c
index e6c0951..d6ceb5d 100644
--- a/util/util.c
+++ b/util/util.c
@@ -10,6 +10,14 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 
+#ifndef MFD_HUGETLB
+#define MFD_HUGETLB	0x0004U
+#endif
+
+#ifndef MFD_HUGE_SHIFT
+#define MFD_HUGE_SHIFT	26
+#endif
+
 static void report(const char *prefix, const char *err, va_list params)
 {
 	char msg[1024];
@@ -96,10 +104,12 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
 
 static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
-	char mpath[PATH_MAX];
+	const char *name = "kvmtool";
+	unsigned int flags = 0;
 	int fd;
 	void *addr;
 	u64 blk_size;
+	int htsize;
 
 	blk_size = get_hugepage_blk_size(htlbfs_path);
 	if (blk_size == 0 || blk_size > size) {
@@ -107,13 +117,18 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 			(unsigned long long)blk_size, (unsigned long long)size);
 	}
 
+	htsize = __builtin_ctzl(blk_size);
+	if ((1ULL << htsize) != blk_size)
+		die("Hugepage size must be a power of 2.\n");
+
+	flags |= MFD_HUGETLB;
+	flags |= htsize << MFD_HUGE_SHIFT;
+
 	kvm->ram_pagesize = blk_size;
 
-	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
-	fd = mkstemp(mpath);
+	fd = memfd_create(name, flags);
 	if (fd < 0)
-		die("Can't open %s for hugetlbfs map\n", mpath);
-	unlink(mpath);
+		die("Can't memfd_create for hugetlbfs map\n");
 	if (ftruncate(fd, size) < 0)
 		die("Can't ftruncate for mem mapping size %lld\n",
 			(unsigned long long)size);
-- 
2.38.1.431.g37b22c650d-goog

