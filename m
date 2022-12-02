Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35822640C75
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiLBRpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiLBRpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:32 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465DCE1187
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:19 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id 6-20020a1c0206000000b003d082ecf13cso1472547wmc.3
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QdoCj1rXjeYFBHU/71+LGjI2Pw5KPr0Z0Mp1yJyEH1U=;
        b=nw+A+Zto29NK4MH+ZRrCcHGW0bmlkqhVbApKNOsLf5Wxd1R16e4ooLsAOljrvyq/Xv
         NzB54iGsvo8dHUrOj+UZEYm/XemLehZIp52YjOnOnSqvZeWxJnXMqZc1Bo6DLbtRx0Ix
         IYowBkYWo0vc4W6+HGxtDHEkwaoDY9XM9h9ZAETzuNFGjbPhO7M/VPqfMtULbsTe29WM
         lqsts+Ok4Tq5ooI3RTwTwA5qsWx/VENMMQRvTCAqr8Nm8hGcdcDNCofo5vbg4Ao7NG/8
         c3CEK/XMeQWbv9zLK212XOL9sSoqHL6s466ih0U9DQVjhZ6P/SVl+jDUpaeEZbBvlsYy
         mj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QdoCj1rXjeYFBHU/71+LGjI2Pw5KPr0Z0Mp1yJyEH1U=;
        b=xtmGus3y2NB5EJXDq5LIaxLtix+9NlO6TVQWR7iHo7CyMpdn2WSo+63UkNjOmj1DNZ
         2Cs+iX0yqrHAhLTbqM5vYdQxA70A6yU/9rGSyp0FFOlNjzWdT+2QH8ao41ilmm2hTmco
         eaj5M6g8ujz1qbphAY44HZIORCnnLyTE22IVShu0632RWeRsONxM3FHh43xJSkEJLimI
         hK9TD0QqHtzocSIlT6CzWaQehOYund+xKldk0S1ZfohaiLSJ/CjI1mfspIj3EwRWR4jR
         V5uw+0O2tiwL4a8QwzDnuXGhJ1u+WLlRx5324f7dVyjBuUn44HXLyKus5WEQG2cImMJg
         b8Ug==
X-Gm-Message-State: ANoB5pkQF9GX0WY/h0Xv5rnB4oYorMjZddXQEw/IuZEcA7M35BCN8ffp
        izqFsUhwVXbjURY4QlwML2EOjzFAAntEk2Smvxl0pVZZakjWa2phoeQxY1WbvbpupbJwVP0GebD
        dM0haXEQgkCngCXlcwL61SJaqzc13Up4JrffcmaqrhlAPu4guGY+opDU=
X-Google-Smtp-Source: AA0mqf4vIE2Zt55ftcwKznK3RCYnIs6pMePm7ZMmo22ZArU9tSH4UfvFg3QjK82403NACEneGHuunVvCrQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e13:b0:3cf:86b8:71f7 with SMTP id
 b19-20020a05600c4e1300b003cf86b871f7mr58403563wmq.76.1670003106698; Fri, 02
 Dec 2022 09:45:06 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:07 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-23-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 22/32] Change guest ram mapping from private to shared
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

Private mappings don't work with restricted memory since it might
be COWed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 util/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/util.c b/util/util.c
index 1424815..107f34d 100644
--- a/util/util.c
+++ b/util/util.c
@@ -173,7 +173,7 @@ void *mmap_anon_or_hugetlbfs_align(struct kvm *kvm, const char *hugetlbfs_path,
 
 	/* Map the allocated memory in the fd to the specified alignment. */
 	addr_align = (void *)ALIGN((u64)addr_map, align_sz);
-	if (mmap(addr_align, size, PROT_RW, MAP_PRIVATE | MAP_FIXED, fd, 0) ==
+	if (mmap(addr_align, size, PROT_RW, MAP_SHARED | MAP_FIXED, fd, 0) ==
 	    MAP_FAILED) {
 		close(fd);
 		return MAP_FAILED;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

