Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446AF640C62
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiLBRoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiLBRob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:31 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F72DEA48
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:30 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id e19-20020adfa453000000b0024209415034so1242132wra.18
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ageV4gcuMu78Wx+6GrTJMvvsI3Mnk9DOcmBuuESKpA=;
        b=V9KWsUEGAe5MVZZlQ+w5H05acUS9wcWLm1VK2fNULxwiEzXtZgC6VBZhCJhR3pdYEW
         I7vO5WkDVMJCjKCHoVmKxhrmTlUh+jkEFdL5oRmg9MgLEcVxSFpDAnUcb5fZig2lLCLC
         0tPtNbLdhgsJbsHc0xig7Z6Ar4mETWX+GuyX82VFG/wVO3P0ccNcKTx7lOdP5p3YAiT4
         +pZ8eIhxqSxQUTHArcCoNd+8cQA+JR5b0XWPcXW60D6UBQPahQzru9vqIa42q/eHsLk9
         O2lrN0r25XgpuJUa2LpRxFg/bLrYymu9tGbtqbzTrlGh298yLEcWzjXLaQBQKqZZiX9J
         QbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ageV4gcuMu78Wx+6GrTJMvvsI3Mnk9DOcmBuuESKpA=;
        b=xehFmlei8TuhJU/Lxr7WCjph+urGKdgGMtRBhk74QWu468VuVOPi5DB1nJcqR1vjW0
         faiDDGcikLr6I+U7IxxlmK756Y3jtF0q+rTSOi8KVCBC3wFgSzIQoeok/HbK8u/4tQTY
         UwGccSQCjUF1CvbWdU4F9j7LRhhH1+0+UIgj75AFI1fXkuFH2OHHEv8hawC4Og4odH5K
         QN3BRNlOuA/Sv+nGzVEiC8a4hVH68r8q4iecI32l+NUsOFnswZF5kLxEntqEfaZq95Fy
         jvikDFZxzngTsZ8JC9J2mUYCrUyyBUlwKTdL4NAJlaR6NWiahMP0ZUllN2wcNiiJ5lNB
         yBqQ==
X-Gm-Message-State: ANoB5pllyKKms15sQB4TnqYRT/PaBWY6hJzHhGXKu2edgNVV5hYtZbEK
        9hsH4kclTHD9YAAht2Ngw9qZEXmGL3W+s34xCJEh/IHI575pL6GHguEAYBRoln0bAUxS4KKsluF
        Q8FO4f1c3JJaG8hgNCovBgB5BqhKCCBC8i+Wlv7r1b+N9bjbT2ZtqVhY=
X-Google-Smtp-Source: AA0mqf5SAkRxyTG1Zcv6Zsrl0pU201UkEIDGKk1CdHEDWwh++q7zIxAxIK/jXtSXJ1BV8Ee1xZU6Z1Alfg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4f83:b0:3cf:8b32:a52 with SMTP id
 n3-20020a05600c4f8300b003cf8b320a52mr57650596wmq.72.1670003068911; Fri, 02
 Dec 2022 09:44:28 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:49 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-5-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 04/32] Rename parameter in mmap_anon_or_hugetlbfs()
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

For consistency with other similar functions in the same file.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/util/util.c b/util/util.c
index 7a3fd62..9f9642e 100644
--- a/util/util.c
+++ b/util/util.c
@@ -81,7 +81,7 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
 {
 	char mpath[PATH_MAX];
 	int fd;
@@ -89,11 +89,11 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	void *addr;
 	unsigned long blk_size;
 
-	if (statfs(htlbfs_path, &sfs) < 0)
-		die("Can't stat %s", htlbfs_path);
+	if (statfs(hugetlbfs_path, &sfs) < 0)
+		die("Can't stat %s", hugetlbfs_path);
 
 	if ((unsigned int)sfs.f_type != HUGETLBFS_MAGIC)
-		die("%s is not hugetlbfs!", htlbfs_path);
+		die("%s is not hugetlbfs!", hugetlbfs_path);
 
 	blk_size = (unsigned long)sfs.f_bsize;
 	if (sfs.f_bsize == 0 || blk_size > size) {
@@ -103,7 +103,7 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 
 	kvm->ram_pagesize = blk_size;
 
-	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
+	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", hugetlbfs_path);
 	fd = mkstemp(mpath);
 	if (fd < 0)
 		die("Can't open %s for hugetlbfs map", mpath);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

