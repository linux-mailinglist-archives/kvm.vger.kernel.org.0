Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FF8629701
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiKOLQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiKOLQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:03 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84DD21245
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:58 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id e8-20020a05600c218800b003cf634f5280so3661731wme.8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g3Dqg5oaANYsw5kvQe0hPdcfy+Ftql0DSTHDS61yT+o=;
        b=GDCeTkd/EHU5mNYUXMJgBs5syjSYqt69jcUeKReb+x6soAiPky3Ex9xxbtkLHu4Ko5
         wXBvlN/QNs8DPzBfEolIk/KtUXwZLNdqpx4h8AZzUCNLP0ojlcOwPv9/xppRA+wXlCoD
         99N7LiVU1qQ3ZA4h3rSRz3RrrVJLc3NGf9VJufvCXD/+YzwPhzGzhMhvngesRlLCA/bJ
         OSyfMZssgXfn+6hDuq2844WnFKQPxpcKkXDIkuDSwKGOgWF6a+7k4bhqFImWXmHbMVpR
         8pOYDongkHgvz54x1kcFWRoYWFLnnfJHRjC91+DvggumA5070t9Wi/BHkA6buJTmJ85k
         bk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g3Dqg5oaANYsw5kvQe0hPdcfy+Ftql0DSTHDS61yT+o=;
        b=ZKOv8itwizRFCX9EACYMHvR5g0Q7ihCUo80iPoeoHgC8t3iXFYOvuaZi+eIq5tbrub
         sYykinCRJZPHSVheLP1OhWdD9/QPCIoxQb5/DLCQ7YccCe2CDN6j39qGp9xKPEmVLW/m
         NFyFJG3kuub8GTeG4QP8wRyVUElXbucaxMNQAuTUgG0h6fvl5Tgb4Yn3muNAVs3N3WYz
         yZ4ig4PEuRSA8F5e7upHFtBA2fPlaxVY2NcyzRjwI1J3SalAs4rpgP88p8UY7iJ3VXhB
         dKOy4HhLqJGZ+hXDP6SbnsNfUxcjwqWmkSKk++/p5lQKJm+xCPWS/Zywdn97S/597kOu
         2bvg==
X-Gm-Message-State: ANoB5pk9EbCTJePtjjv0yq1IToLOvW0GX11SkeFnibV+hsEvisXVxy6b
        nPEwlVbPz/PnnSoXgm95BckIVZWS4Q9TGMFImYAN0z+rhHZH2h3Y6HTq/2N5juLVrYIHVfVbLza
        MaUMl6NLdNAOn89ag4B9hscSZsYX6ZYsmidNEKTvH5D/7DwaR/K/RsXU=
X-Google-Smtp-Source: AA0mqf4VeI1LbGM7ZGkgpAyFad1HNZyx6QxLUQdhQykv6h+1GjjmAvnYdmpwqKAh3B+53VHovpNGbAfCuA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f489:0:b0:236:5102:bd4c with SMTP id
 l9-20020adff489000000b002365102bd4cmr10067270wro.415.1668510957448; Tue, 15
 Nov 2022 03:15:57 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:35 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-4-tabba@google.com>
Subject: [PATCH kvmtool v1 03/17] Rename parameter in mmap_anon_or_hugetlbfs()
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

For consistency with other similar functions in the same file and
for brevity.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/util.h | 2 +-
 util/util.c        | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index b0c3684..61a205b 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -140,6 +140,6 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
-void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/util/util.c b/util/util.c
index 093bd3b..22b64b6 100644
--- a/util/util.c
+++ b/util/util.c
@@ -118,14 +118,14 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 }
 
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
-void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
-	if (hugetlbfs_path)
+	if (htlbfs_path)
 		/*
 		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
 		 * if the user specifies a hugetlbfs path.
 		 */
-		return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
+		return mmap_hugetlbfs(kvm, htlbfs_path, size);
 	else {
 		kvm->ram_pagesize = getpagesize();
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
-- 
2.38.1.431.g37b22c650d-goog

