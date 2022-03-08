Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B924D1BC7
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347812AbiCHPe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243576AbiCHPe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:34:27 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3037E27B00
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 07:33:30 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id 10-20020a1c020a000000b0037fae68fcc2so1298220wmc.8
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 07:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
        b=pddi0OSiiw8dazmXtcwiTq02d0DXNRhXP19P0GEVAifH0Ov4Ygmouk8WLBNsu9/q+v
         Dj9KRSeqnZVQ7vnXFR5DjUv4Fk1xnfLYZ1cTi0r8sesB5VhXx6UA+PAhnDj/YuljOv+k
         tdGjM5YV/zTBAxZegz2pex89Qls2gA7Q6Md36Yu2vtwXZEHH0ylU0J9GZ4MXfqEuKMZr
         qxp+lvB07oZK+8N1oa7Rk6CiX5jp+cHL0j2i2xyZ8scfVf3tzCiGROaKUfaYC3bi/iWk
         H1tjc54tOH3qeYPD4OsY2+qmUO+jQ+5URHgCDXEhGIt9Kiue8pjF+MrBsm0zWe7F2Yxl
         QF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=txkn166+EfY7PppLWw4qc4C+/p2UR63wD9i9h0OJBgQ=;
        b=4kupuU+1PEGmC+GZd0sNeqrMnTemHXdqCoonHSisRs8Fz5GHHCBPf3oWy6zokycOIL
         OG7CmUPm3lGWpM+z12a6ylgDUwwHZhqBibqk9TxKrvTaBDu/htQalNraENvrMJxWe3KK
         fSxLArPQA5r6wiBNX3wgOzB5v9RxbyxPjHqO33mmyNkS/oVR4U4rjP0I9SMvMNbESfxF
         7WFV+Kf/fNv+P6k93eKdeYa+HtkmKp1KWdQtUKnNhENEGEdMHaSbv2auhsJAsM820V8k
         /QUD9Jfq6upQKB7aAB8z2PL+Mm+LBd/hBfC+YyB0OsX8W8fgdjjWqTXUXgWAS/MKak0j
         G8iQ==
X-Gm-Message-State: AOAM533DkstXEXmBfEWMjMrCxzGTrxdLkjvZFPg9EiCR9AZ7EL3RaQrH
        /MOp/ZXqy+e91VCLTh8YPZHQ62muEO8saqvLFkui8DVcZXDABJhMFdXt1Dff9XQk0WuqpZf4oA5
        TTsDD8mItSLWUP6yD2mDDMAuFRuhMn7kMpTOr4ZOEAIxKEG2WxRqxRXbTU9OgcPjQvIt8Ay75Gg
        ==
X-Google-Smtp-Source: ABdhPJz9IthMw6tJSFg3E2QKBXXnsfAhoYP/pCCNOHYFKDxtU/RBheveh/HjrORqAbwIF/t6jLK8FonxU9aCB67mCdI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:27cb:b0:381:400d:3bba with
 SMTP id l11-20020a05600c27cb00b00381400d3bbamr4165855wmb.60.1646753608731;
 Tue, 08 Mar 2022 07:33:28 -0800 (PST)
Date:   Tue,  8 Mar 2022 15:32:30 +0000
In-Reply-To: <20220308153227.2238533-1-sebastianene@google.com>
Message-Id: <20220308153227.2238533-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220308153227.2238533-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The command line argument disables the stolen time functionality when is
specified.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.616.g0bdcbb4464-goog

