Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC38C640C61
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiLBRoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiLBRo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:29 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCF9DEA59
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:28 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id d6-20020adfa346000000b0024211c0f988so1229214wrb.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/131CUlG84aGb1aI35xcOB3PeBVwvnfM42yAaxe+WA=;
        b=SAB9ajEXUe02LaBAKG56vtO6rDrE0TzThndnZnsqxzi36+mNw+sAI55MV7Xvmr2JT8
         bzScXzi91GMWaRM24Cm6bk6fTvNiry75vXvWTJKFijkugwB1jQPsWq0vjjdKz4iN4v9h
         jItGzdjhnRW7yxQZbG6BTc/fnndwyoAb/33jvW4tP4ZliXzFvlZTrSzx9Ky8mWDhA1Bb
         +7PnFjry/6h45JgwPeNX/tf++J2Sfg7yPp+biUQ3xEawLSlJHMutk35I29Gx9zfIlcEf
         XqrPhAVyy4j8/jwtv95RFWyKPjdtHSgn6re6wUE6OaLKcqojLDHWcufjYiWv2aCwzumd
         oujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/131CUlG84aGb1aI35xcOB3PeBVwvnfM42yAaxe+WA=;
        b=pl6HyMceWTarKqBRyEy18c6/33Dm703CauuEt/ni4T4bteLcYsP6+8BUEH+/VRT9um
         uUl+YxKuZUPLsGm4/cfngP6+LxZ2bODtleosqhprGiDAREj15Ky3q4URnnKEJTYk53Jt
         Gs/AjgvgoaA8EI8/WQtMERgFkoi/yNI1B6ls3j++4V8HMBz4kTP/SepGbF7DSxtq6cHu
         XDU+zoQuTJxqKIHJV5tHhVb/Wjp5RCXh2pVJ50PUnNE1Ntl2YjTJlEAVzyjYxWHPRmIe
         ZUl7vfDOkkQO9LC2s8jikYADG/H0B7IPa6w3M6wuKjpV9iBS6RlOqCJNGxUFzWnhXCuH
         4Acg==
X-Gm-Message-State: ANoB5pkkWLB6i6eNZ7/0NsUYOHBFVeFdRXxMT50GR4bbjLL1MRCRvmBw
        gA9/hw73VNcJDaZChl0SfsKbAwAHP9qPXdTRvGRmhSxFibo/LNZVA6q14bF92JozNSGePMIpQ8A
        fBnBMsJQX8KMQhT9yWgu00ZkpyIuxO1auTzvy2ugu4ikQ6HMIbKU6vKI=
X-Google-Smtp-Source: AA0mqf6NI75EakafPWa3HDPXx0eLOkXYU/p5JuJom23fGd1R14vQNondI3f/LN9P9mkk48r+C5YUxgm+ew==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fcd:b0:3cf:7514:a80d with SMTP id
 o13-20020a05600c4fcd00b003cf7514a80dmr476111wmq.0.1670003066239; Fri, 02 Dec
 2022 09:44:26 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:48 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-4-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 03/32] Make mmap_hugetlbfs() static
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

This function isn't used outside of util.c.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/util.h | 1 -
 util/util.c        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/kvm/util.h b/include/kvm/util.h
index b494548..b0c3684 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -140,7 +140,6 @@ static inline int pow2_size(unsigned long x)
 }
 
 struct kvm;
-void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/util/util.c b/util/util.c
index 786dfc5..7a3fd62 100644
--- a/util/util.c
+++ b/util/util.c
@@ -81,7 +81,7 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
+static void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
 	char mpath[PATH_MAX];
 	int fd;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

