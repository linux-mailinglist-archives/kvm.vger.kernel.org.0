Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48473640C60
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiLBRog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbiLBRo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:26 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C0DDEA58
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:25 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id e7-20020adf9bc7000000b00242121eebe2so1225179wrc.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=30AptmEOrxEptsR4xup5ZnAEVV6MngChT14ZxzqU+kw=;
        b=Rg/bRb7xUsh3ybr2HBnoYLk5EM9nkIyydg1oLPtBI4hpGSaYU5EdeC5v0n1ihyaI2U
         VfWifEPUHMCxGNzVYv+/aMXRvp35lV1KM+iTTrxs4bidFxXOK9YYv4sgEFgvJ15ioYiO
         04HDdY11JQjh35v5d8WRsbTRCu9AP28uuwMm8uAr+QuHybxSmW2c/G9IOK5fTgu54A1D
         CIBkZZIqj1xzn12w0Rz+tv7GVzMo+HDiRPJbr05M7xyDha23LQjyo7D4sU6AnseWKvom
         h9BtNqDtWwt9bciRE4jaXN9kV/WZZye/LENS4sbiwgjIJIU0HeWnIEHimzkwkrj200dr
         K+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30AptmEOrxEptsR4xup5ZnAEVV6MngChT14ZxzqU+kw=;
        b=rAc2T4NcApPrvhwg65nNL7IbS+8ywIzYtGdehfSRrxG7AfwQwmDH/VKXOuEoYZUIYk
         fQHQ6lOm2kPPDjlv9KbQ3kCpTIwrKsxe0Kwj89+Sf7jO90FNkcJugxh6BfJrPCpO+bj6
         Tg1la0k76LPPhtKTGyRBIXPmHoYJ7I8K/4u5MU0Z5LH1jvog889tb9Q96SXKHOYNCPj6
         pF7mzEe8L9zFKgk61YbmqqruN4Ky69arQovZcs/r0WlO5/zIdURlYFfriEuf8atLsrml
         Wb2i7GNcIm/GBpMFrsjDBJhn/1gDjEm94Wo12hgwnipylCkjCW4nimib2mH04nNW/sG5
         GdrQ==
X-Gm-Message-State: ANoB5pnrD+Nrnia2Hfvwkvivc+9WQ4zV48SstPx3/OQqoWgEI+Ic0asL
        cFDfETt0oesbttZOH1KOfkpLUs/tnHMZk11ipRX0Dh2Bbuu9vxa8fTkkYI4wsbCbJaSYVgy98z4
        rIEIQxldzb1raeT1ZGWm1b2OIA1iGB9+qCLLqVeYTnzBu4D0lTUfZhQU=
X-Google-Smtp-Source: AA0mqf4yVfa+tq3OK2llj3VIeUfB6d5/ddbIgqyenU673ogOKPz25MnpjYoMoERdQjQwfZkoMhFs3QCuGg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3c91:b0:3cf:6f23:a3e3 with SMTP id
 bg17-20020a05600c3c9100b003cf6f23a3e3mr3618369wmb.1.1670003063959; Fri, 02
 Dec 2022 09:44:23 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:47 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-3-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 02/32] Remove newline from end of die() aborts
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

die() already adds the newline at the end of the string.

Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/util/util.c b/util/util.c
index 1877105..786dfc5 100644
--- a/util/util.c
+++ b/util/util.c
@@ -90,14 +90,14 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	unsigned long blk_size;
 
 	if (statfs(htlbfs_path, &sfs) < 0)
-		die("Can't stat %s\n", htlbfs_path);
+		die("Can't stat %s", htlbfs_path);
 
 	if ((unsigned int)sfs.f_type != HUGETLBFS_MAGIC)
-		die("%s is not hugetlbfs!\n", htlbfs_path);
+		die("%s is not hugetlbfs!", htlbfs_path);
 
 	blk_size = (unsigned long)sfs.f_bsize;
 	if (sfs.f_bsize == 0 || blk_size > size) {
-		die("Can't use hugetlbfs pagesize %ld for mem size %lld\n",
+		die("Can't use hugetlbfs pagesize %ld for mem size %lld",
 			blk_size, (unsigned long long)size);
 	}
 
@@ -106,10 +106,10 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
 	fd = mkstemp(mpath);
 	if (fd < 0)
-		die("Can't open %s for hugetlbfs map\n", mpath);
+		die("Can't open %s for hugetlbfs map", mpath);
 	unlink(mpath);
 	if (ftruncate(fd, size) < 0)
-		die("Can't ftruncate for mem mapping size %lld\n",
+		die("Can't ftruncate for mem mapping size %lld",
 			(unsigned long long)size);
 	addr = mmap(NULL, size, PROT_RW, MAP_PRIVATE, fd, 0);
 	close(fd);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

