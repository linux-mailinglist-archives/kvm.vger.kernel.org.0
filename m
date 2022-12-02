Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE3D640C74
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiLBRpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiLBRpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:32 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB12E118B
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:19 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id bg25-20020a05600c3c9900b003cf3ed7e27bso2823404wmb.4
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RcceNNV74mWRvfNnRdRHxXqpLA5rMluXWpmCinfrAO4=;
        b=dB2jQjNAjKHWVg6i2fnn5DYvoUYPTOPe6g6D5NDlYPmNLCbbdXurDG7l3tBGmRnQZJ
         MmSpeH1WV+l4j0pXh9UNhpAAjNFD1HCx2tFJt2KGZRr/hVn37Kn3Hn5M1w67mQcUrI7s
         oNtH20bjZXFBXWxM8V0eisKyqzF8PB3azf32mCa72QZHBqxGsinAgKfqD92GAy0fnjTg
         pBCDck7PnknriEPt7tg9S7PJfZGMrUnYTe7pyMHZKDub5OtyZCH/6USI5JilBofzXBZP
         DV2VuCjK84UrMNyyNNI2Sr0IvJZ9zDkmEZHodOsaU4XlqikU2k+7ZnkTC0KpEdJRNVTs
         Fhkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RcceNNV74mWRvfNnRdRHxXqpLA5rMluXWpmCinfrAO4=;
        b=5HrQna3JHMf/U0XJSGwueJYfwzeAz6XPS/BBhsYBZDrm55hIqzTIP2tXsTa7d+pbn0
         eWdEO6ItRpkNd82ExersYIxu3mn43lfRDdhajvgqyGDUnIDuS8CdMQ2Gbbunnr3cxL9w
         tBchFUwtjNgHTFlcd1POFjiFrdj+PNzLwpMbFs7JnqZISfyJlHX6weUfPXuALRl3mJgk
         Pax/hTgo6gYyv280y5uu4myF5bVrYnkui4LcrTaofsQiHYAe/J1GTOECoB325LNRjjdk
         TiVN1zD721D2IJZopYMYVPORVX+oCEDP71ldc8CPixC048uaQ1rLaDtdvFbV25Tzjx5m
         HMIg==
X-Gm-Message-State: ANoB5pmfzGSVeZvDzpsu5SiB70BJydlfmu7uR6wdwj7CVOvwKRYCo3Mu
        crOzqupgDCHDD3YBxa/1bM2VOr7ycU0e0Qxt7JS7BnKvxyEfIpWreWe/7aiSaADXuiETyEOCP7f
        DOh5cpTRIlL9x0tm2yB6U9BLeAEKXEr4bKBxCCQRDWqqkIdE+qnWEXg4=
X-Google-Smtp-Source: AA0mqf5FGBvWE56xTYlHasc5VW7hiCKk/l7OhpAKHcUOs/2SBAsfGGs5U5hXFyAYei7anzRyTSsOzDM5Ug==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5251:0:b0:242:39bc:497 with SMTP id
 k17-20020a5d5251000000b0024239bc0497mr5369114wrc.411.1670003108672; Fri, 02
 Dec 2022 09:45:08 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:08 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-24-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 23/32] Change pvtime mapping from private to shared
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

Private mappings don't work with restricted memory since it
might be COWed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/aarch64/pvtime.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index 9b06ee4..a452938 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -20,7 +20,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
 	if (mem_fd < 0)
 		return -errno;
 
-	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW, MAP_PRIVATE, mem_fd, 0);
+	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW, MAP_SHARED, mem_fd, 0);
 	if (mem == MAP_FAILED) {
 		ret = -errno;
 		close(mem_fd);
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

