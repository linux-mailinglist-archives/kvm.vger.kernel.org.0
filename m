Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FD1640C65
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiLBRon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiLBRok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:40 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF700DEA5B
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:38 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso2814635wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EtUwd18qcwkJhEJATUqJ5o4gXc9dWFfkzT8XmPE9Hrs=;
        b=Hl4biVTHwFhm5UBcmOLpRL0wGKh1S//eqRaddMd9fcqIYpIKpX8UlH1qgBUkCfvCIN
         WHuoMUtoigkD2E1SkEyRxn0W0gnMwrXZInySIpTCYK+OomiOoNw4QoyCBdhvtKwsBHwK
         1ODFaFUVK6an+Yu772MCNvSqaXEZNVCbiOsyKW+UjirbA/nPV7MD0uxNSlS53tS3ARbA
         gAkX3WZWsQoV1jrJFMh6BqsbXzN7N2Yas8OzorLR75ebnsiob3LamlpnsA0H2yBqSX3K
         7gwjld/miRAgonXzSepcaanOnL6KZKSAUyqijyJsHGGMLJyG5TMf4oeWpKiSTkuTlajp
         rbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EtUwd18qcwkJhEJATUqJ5o4gXc9dWFfkzT8XmPE9Hrs=;
        b=uYQVSjR5z7i5s+s5j6z0Htnc6Vpo1cANNxtSjal8+4+Ig6J6UUpcdOZoY1ine+zWg8
         Dqq6DWEpptpY+kUuxr0oFrvfyUfhvTkRlAP1KqODDIHEdSsy/mSWYoWnZXfx/RgyOC5T
         Ge3Q5mi7NQ+sWqOz8uabjR7/4f4SnZv6U7I849lAk3Jg2R7Ob+9PHwhs89vICzFB3w78
         Dit8ei+AoBuFI2AXpnMSDTOT2JXRFvETd2/7TJM7M3szPNP8amVybR6/pJeIHQdJxZL5
         MXWd2FOWZAzrP3uTqTjTmcj08mmACk5gM6yFOxG6tBjw4crzswyvameu3vdJ6yV69qWn
         xRiQ==
X-Gm-Message-State: ANoB5pkNgNLtavIaYPvk8jERgyaqxBv2hwXC72miVq9l/jeoZLubpZTt
        nBSyguU8glvKQK3EIL9Agw8Ne0K86oXzxfVwBDQ1gAJ7Lopxfo53CZYVFwQxseOC8hhWmZ3/VTY
        mbxB8NX8Kxq33+9lHiAe7gCYMaYb04MOMSeor8+G5z8iWs/vefbwQrgE=
X-Google-Smtp-Source: AA0mqf6tizpquIiG1q3fA9ZtGVu+coyn9gZNDl8lFNyzDFaKd/1g1zPx+Jm4zNUp9OR+9vKYNN6acWmq/g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:508:b0:242:34c1:1fd1 with SMTP id
 a8-20020a056000050800b0024234c11fd1mr6064844wrf.218.1670003077423; Fri, 02
 Dec 2022 09:44:37 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:53 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-9-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 08/32] Make blk_size a parameter and pass it to mmap_hugetlbfs()
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

This is the first step of making this function more generic.

The main purpose of this patch is to make it easier to review the
next one.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/util/util.c b/util/util.c
index b347fa3..93f895a 100644
--- a/util/util.c
+++ b/util/util.c
@@ -95,19 +95,12 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
 	return sfs.f_bsize;
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size, u64 blk_size)
 {
 	const char *name = "kvmtool";
 	unsigned int flags = 0;
 	int fd;
 	void *addr;
-	u64 blk_size;
-
-	blk_size = get_hugepage_blk_size(hugetlbfs_path);
-	if (blk_size == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %lld for mem size %lld",
-			(unsigned long long)blk_size, (unsigned long long)size);
-	}
 
 	if (!is_power_of_two(blk_size))
 		die("Hugepage size must be a power of 2");
@@ -115,8 +108,6 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 siz
 	flags |= MFD_HUGETLB;
 	flags |= blk_size << MFD_HUGE_SHIFT;
 
-	kvm->ram_pagesize = blk_size;
-
 	fd = memfd_create(name, flags);
 	if (fd < 0)
 		die_perror("Can't memfd_create for hugetlbfs map");
@@ -132,13 +123,23 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 siz
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
 {
-	if (hugetlbfs_path)
-		/*
-		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
-		 * if the user specifies a hugetlbfs path.
-		 */
-		return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
-	else {
+	u64 blk_size = 0;
+
+	/*
+	 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
+	 * if the user specifies a hugetlbfs path.
+	 */
+	if (hugetlbfs_path) {
+		blk_size = get_hugepage_blk_size(hugetlbfs_path);
+
+		if (blk_size == 0 || blk_size > size) {
+			die("Can't use hugetlbfs pagesize %lld for mem size %lld\n",
+				(unsigned long long)blk_size, (unsigned long long)size);
+		}
+
+		kvm->ram_pagesize = blk_size;
+		return mmap_hugetlbfs(kvm, hugetlbfs_path, size, blk_size);
+	} else {
 		kvm->ram_pagesize = getpagesize();
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

