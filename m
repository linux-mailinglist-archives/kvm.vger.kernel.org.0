Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8BC640C66
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiLBRoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiLBRoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:37 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA6EDEA48
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:36 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id h10-20020adfaa8a000000b0024208cf285eso1258976wrc.22
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u2mYeRLqrkrCVPKSHkXjmzqbL6Z26iJ6Ebt+DZZD59Y=;
        b=SsqqvxTAAq+beCl42UIw2OmG7mWy2DMJEV/OH/CErcjJjvORQcgatScBmUAG7aqE7w
         ZBAQtkeUwXBgrAiQfnaHTxqX0sFcTrqJEgmAod5cHYeeQ/0JQpjfHTUf/yXvKZkqgCAG
         VxgXpt2IuO5+M5gbgUWC0xXmfWhbaQUofpZcfPyEDOz1eUjDBn6X9n2Xo07pS2XXRZLp
         9MmWDgnvI1fl4wuqo7lRY1p7N7swHvemnrgRjOpWwb0P/6XWXaMG0vK9/1GO5AvFtnY1
         H2FPvSrNCVLWIL5fHh1EaSLqYMmJ7h5qsqWN54YcevrFBDJ3D6tyiy/wQObAVb5OHVUR
         lDGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u2mYeRLqrkrCVPKSHkXjmzqbL6Z26iJ6Ebt+DZZD59Y=;
        b=uN8PNa7SE4MEPz7ZPbONgte08KT3viabNCjHxSkxvc1ubflkmX96RtrZ8dJHZqtALZ
         GgW8BJFe3scTt4Tqe9gVn5fL5T2KzlkAjb18SQ85UTPadv3hx/tdRUtoteSg9kYblnSf
         j12AhrogKVkQMHftbdzzXTG2IajWl0maElHKDhbZIQY2X+RrUY0idhUaVqNKU9Sk3pxm
         VgKOOy+VgJ4RbPJfOI5of6GFlOfckPi+1CX23Mvt9lFEUGukMuZRiygtl+dT1tDyJrBb
         h30KNBPXkykdgdL8qzfzQStUxtQIUP8jnLW4uSn3BfXHlM/vFJwfOksqXahmTEZ/V9l9
         k2oA==
X-Gm-Message-State: ANoB5pm+YEqU0WaEoPnGrpo7Wosnb0PEIWIPM8LuyvAxQQa+UZCmBcH4
        3izEcaWcFwojEhAoOOEPFvmB1i8RMbKpRRe6DA0f0tlBjXomV1vtNVUX1hpmgkKTWetdnwcpwRh
        jl1MHvdIel9uY16/3M7/2knA+fJ0Lvsm+ExjEzgKmwhR2w72ZLJ1oA9s=
X-Google-Smtp-Source: AA0mqf6PE6ZAuEeIt+AcQisNNpuvL7G8vZZcAAF24cMc5fkIhr/2XntJdXwwqo+o3mYjluFb4OgY64C9Qg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:cd8a:0:b0:3cf:e0f0:9e8 with SMTP id
 y10-20020a7bcd8a000000b003cfe0f009e8mr45753705wmj.156.1670003075380; Fri, 02
 Dec 2022 09:44:35 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:52 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-8-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 07/32] Use memfd for hugetlbfs when allocating
 guest ram
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

This removes the need of using a temporary file for the fd, and
is the first step towards using memfd_create() across this
series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/util/util.c b/util/util.c
index 2c6fcc5..b347fa3 100644
--- a/util/util.c
+++ b/util/util.c
@@ -6,6 +6,7 @@
 
 #include <kvm/kvm.h>
 #include <linux/magic.h>	/* For HUGETLBFS_MAGIC */
+#include <linux/memfd.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
@@ -96,7 +97,8 @@ static u64 get_hugepage_blk_size(const char *hugetlbfs_path)
 
 static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
 {
-	char mpath[PATH_MAX];
+	const char *name = "kvmtool";
+	unsigned int flags = 0;
 	int fd;
 	void *addr;
 	u64 blk_size;
@@ -107,13 +109,17 @@ static void *mmap_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 siz
 			(unsigned long long)blk_size, (unsigned long long)size);
 	}
 
+	if (!is_power_of_two(blk_size))
+		die("Hugepage size must be a power of 2");
+
+	flags |= MFD_HUGETLB;
+	flags |= blk_size << MFD_HUGE_SHIFT;
+
 	kvm->ram_pagesize = blk_size;
 
-	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", hugetlbfs_path);
-	fd = mkstemp(mpath);
+	fd = memfd_create(name, flags);
 	if (fd < 0)
-		die("Can't open %s for hugetlbfs map", mpath);
-	unlink(mpath);
+		die_perror("Can't memfd_create for hugetlbfs map");
 	if (ftruncate(fd, size) < 0)
 		die("Can't ftruncate for mem mapping size %lld",
 			(unsigned long long)size);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

