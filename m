Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1073B62970A
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiKOLQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiKOLQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:09 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEA6BFB
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:08 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id d10-20020adfa34a000000b00236616a168bso2687022wrb.18
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VnpKPHd0WqzilqfZYFGWkNsglW1G66eTYlBNQL3waBI=;
        b=BJ68z9BMC0rBTARUE4noUnIfUJiSVxacaiiddIFRrBgVJ6QY5X9ME2GHyJzunkFyfi
         SIGos5w75aHiqc2HUiZXzsXikE/jjAxr7Kqw1z/R8Zb1l34lHY4UJ0hxUFf1/m4PqSmm
         wpDj07m2gV2xu6Hq5qCzbMILFKSP2xsdoKXcfVV2kWllSjryvTvY7KJni/xS9r1C7ml/
         jjNW3joTZzvmod+M7mh4JlNaTWgrcYGmGfRA/0WNmPp96BEg6XCgTLzxsOuvZKk5FqRD
         5JVvHF2aCcWKcFUUrv29WtO1i7VuCn2a+NUObZl3yMSyV79Soa6CwV/tv0f8N0cj7dIy
         J2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VnpKPHd0WqzilqfZYFGWkNsglW1G66eTYlBNQL3waBI=;
        b=HqIFfTOIMgA7hTPGjCQLnWIzCch89vBPhAEx2QWQRxhX6i51aM/Q+7QNkYWWMPJfjS
         xg4Sy8+tWWt5/dXpkSpRY3LjuPSQCcFCJ1+LfcSUkKPIrEojPYzIZBQcOKbDlDtTD7Ws
         gMlx1j2OOkHiyNx5BmTDBy9TSLN7JQZbf0BDa+U3chy44kgZaX3MfaDiU6nJz9y8o4mx
         wRKyt4zEumokqVyTdeyVcVZzux9ZOESwiYYmT3fTn5GUVQ3Z+hU6gES85WXYq5UvFTRj
         VsdX9kQ+1/K6aQVwKB+UH6f4VeYXYPPGQGMh8/v/GIGpH5My748YWDz8IEpbsJXxAtO7
         q0JQ==
X-Gm-Message-State: ANoB5pnXwJ6ndDsuPHyPNx0pMRdhO7QgTdmUqaA7xfiC/0zIQTbQ9q5U
        fXGPA/DRZpadY74cNWOmE4vv992G+JnkeTM6B5PlCmA3sEIw2nxemp88+auCeTlrPk2Yc4SpOC8
        rFcbM3BIqUhc+pBQ7OwK7mkohmT80yvY1KaXud5PzaqwLfICwtbP6iIE=
X-Google-Smtp-Source: AA0mqf4uXEjPUR5fqWyXjU4A8An6oy4Rc5zjenX84xLderJoclJQH13I95iwsTwYJOCViDFKlSlNCYAREw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a1c:f70d:0:b0:3c5:a867:e59f with SMTP id
 v13-20020a1cf70d000000b003c5a867e59fmr48816wmh.146.1668510967216; Tue, 15 Nov
 2022 03:16:07 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:39 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-8-tabba@google.com>
Subject: [PATCH kvmtool v1 07/17] Make blk_size a parameter and pass it to mmap_hugetlbfs()
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

This is the first step of making this function more generic.

The main purpose of this patch is to make it easier to review the
next one.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/util/util.c b/util/util.c
index d6ceb5d..d3483d8 100644
--- a/util/util.c
+++ b/util/util.c
@@ -102,30 +102,20 @@ static u64 get_hugepage_blk_size(const char *htlbfs_path)
 	return sfs.f_bsize;
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size, u64 blk_size)
 {
 	const char *name = "kvmtool";
 	unsigned int flags = 0;
 	int fd;
 	void *addr;
-	u64 blk_size;
-	int htsize;
+	int htsize = __builtin_ctzl(blk_size);
 
-	blk_size = get_hugepage_blk_size(htlbfs_path);
-	if (blk_size == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %lld for mem size %lld\n",
-			(unsigned long long)blk_size, (unsigned long long)size);
-	}
-
-	htsize = __builtin_ctzl(blk_size);
 	if ((1ULL << htsize) != blk_size)
 		die("Hugepage size must be a power of 2.\n");
 
 	flags |= MFD_HUGETLB;
 	flags |= htsize << MFD_HUGE_SHIFT;
 
-	kvm->ram_pagesize = blk_size;
-
 	fd = memfd_create(name, flags);
 	if (fd < 0)
 		die("Can't memfd_create for hugetlbfs map\n");
@@ -141,13 +131,23 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
-	if (htlbfs_path)
-		/*
-		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
-		 * if the user specifies a hugetlbfs path.
-		 */
-		return mmap_hugetlbfs(kvm, htlbfs_path, size);
-	else {
+	u64 blk_size = 0;
+
+	/*
+	 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
+	 * if the user specifies a hugetlbfs path.
+	 */
+	if (htlbfs_path) {
+		blk_size = get_hugepage_blk_size(htlbfs_path);
+
+		if (blk_size == 0 || blk_size > size) {
+			die("Can't use hugetlbfs pagesize %lld for mem size %lld\n",
+				(unsigned long long)blk_size, (unsigned long long)size);
+		}
+
+		kvm->ram_pagesize = blk_size;
+		return mmap_hugetlbfs(kvm, htlbfs_path, size, blk_size);
+	} else {
 		kvm->ram_pagesize = getpagesize();
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
-- 
2.38.1.431.g37b22c650d-goog

