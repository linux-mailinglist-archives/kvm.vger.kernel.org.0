Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF95640C64
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiLBRol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiLBRog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:36 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1622DEA4E
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:34 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id u9-20020a05600c00c900b003cfb12839d6so2194056wmm.5
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n9DP7lADh4c+E7x+otRAyP30/DemjSDCvHJYlgZT93I=;
        b=J7ua18QZPVZaLUzWblK6o+MbcbETRh+/PeykvEOiyVDv/S5qQxPk4h7b/FwUoMkenU
         bw6l4A7MYoWwHGbn8YjiENVAcq3p9vz/PgsBGjaFretVVVcsEvblKBDsssiNBNJuvayq
         yHUh2xqDZ/SVQ4ufK5EAmtlr/c6mFfQ8I9LH/F4FsX2NCq+FMScYzpsQow1M/LU01a0u
         NpO/zcGuuKAOfMyWs0avbn5lKLibWQ/txAaX1+UnSd3ObMOd5RWBgPWw2bfdw93iB/fc
         9QP+NMYBtp44z2aBxVTHIQmbm1k7FgooU9AqYhZGgBoCUo0c2Wh877Gi7y0w1nTwZB8x
         iZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n9DP7lADh4c+E7x+otRAyP30/DemjSDCvHJYlgZT93I=;
        b=m0DdC4M4siQ4hfB0Ke/cWqYKWzB0WA7DGLVfk309JivOXZuMbCQykc3O5lFLxWX+yT
         rcnm/zoNZZGp4m0vguAR28Gt3h/wwlGADx3zEeaZkraGeaRyyY7r+nUUREi2ChStU8ru
         orPKfXU9ARNTvKD9TjXvkr3yIG+zMOVz7Q+UGF3KGPNy+25roszZXgYIlAw/eu0uzxwF
         UW5wpkYucfz6eTypvQ8QxHebilw5h0M6K1vKl0lWIxNM7Aj6na6r7oPzs97dHXfr7FIn
         obO3HXR0sSkuUp16QC2BOnZ8c2lee0/mqfynN1RUwST9Z2EqdPBMbx1rjQUkcFmtIlFl
         Xt2w==
X-Gm-Message-State: ANoB5plytq6zezx91/4WAN5bsg8E6OI4gLd/tedATnL3VXD0MhsH2Sed
        pSt1y9C/iDXDj9E5XXyNnbL+Ng03YoeyRnIiygC8ccPce8oevD3ibYEglEuZ3tJJtTVPNuNVD3X
        yrRR4mXA7qtVIeAk83BxvyPyegCGkWTrLupTXsypCKYAfj1S3t+TnG+w=
X-Google-Smtp-Source: AA0mqf5LpF6NWYMYBw1TBS14fejpiDfduxi9uGhOiD7AXLwIjfWP68XRX39l2O5+aWEvYNd0nIDLp8epbg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c456:0:b0:3a5:f600:502e with SMTP id
 l22-20020a7bc456000000b003a5f600502emr44127495wmi.39.1670003073443; Fri, 02
 Dec 2022 09:44:33 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:51 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-7-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 06/32] Factor out getting the hugetlb block size
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

This functionality will be needed separately in a future patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/util/util.c b/util/util.c
index 9f9642e..2c6fcc5 100644
--- a/util/util.c
+++ b/util/util.c
@@ -81,13 +81,9 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
 {
-	char mpath[PATH_MAX];
-	int fd;
 	struct statfs sfs;
-	void *addr;
-	unsigned long blk_size;
 
 	if (statfs(hugetlbfs_path, &sfs) < 0)
 		die("Can't stat %s", hugetlbfs_path);
@@ -95,10 +91,20 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 siz
 	if ((unsigned int)sfs.f_type != HUGETLBFS_MAGIC)
 		die("%s is not hugetlbfs!", hugetlbfs_path);
 
-	blk_size = (unsigned long)sfs.f_bsize;
-	if (sfs.f_bsize == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %ld for mem size %lld",
-			blk_size, (unsigned long long)size);
+	return sfs.f_bsize;
+}
+
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+{
+	char mpath[PATH_MAX];
+	int fd;
+	void *addr;
+	u64 blk_size;
+
+	blk_size = get_hugepage_blk_size(hugetlbfs_path);
+	if (blk_size == 0 || blk_size > size) {
+		die("Can't use hugetlbfs pagesize %lld for mem size %lld",
+			(unsigned long long)blk_size, (unsigned long long)size);
 	}
 
 	kvm->ram_pagesize = blk_size;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

