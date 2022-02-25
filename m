Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E298A4C46C0
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 14:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiBYNjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 08:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbiBYNjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 08:39:39 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A132028B0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:39:06 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id r206-20020a1c44d7000000b00380e36c6d34so1571196wma.4
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 05:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=SaLP7VFxlAAUSia04NKVwItE0Qp3jy3z06hhaS2eREtAb5mr5fQwCWzyDOA+oFvIBq
         XJp4dqQy2yi0jDI37+KerSkKj7sPmC3shqY8Iwuh1MHl4P3C+iE2LPtsgSiU1qkdLguN
         HUN/kz1uWommFn626N//gt0SF1rLHQshWsq6gWgSQAsU/slveGGwzko8mZKIgTRE2BZo
         CJD7z2E7BRkWBU2zy/es714usPf9lZLeaFP5Y/Xcn/Dj+xAVokOQsCCOHAk+KXcBaPva
         MuLd/l1BdWGbW1ozOaN4mHRlolXEmygO/tHvospbu3b/tg6GkAjYAu2PLqrdp+j8LVzH
         tEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=ZTbvOw/Ud5eP+SIXxsWB93LimDCpISAm6/jfg/XvwZY7xA3Ksj/R5JXngRO0tAptVr
         ZwL0pemTf3d+96od7Fkobqy90iXhVUSvv4lfTb7cRwQrCNJy8pSNeiVU/wh+OChgdXXc
         XdVZi7IyIjadSTHpWH3GGAorOLDCGfMC+A9NJicfjZ5kxvuHUXICc7fwz2qWA9AfGocG
         pYU71G5SIn+/zwRm9SSmTiH+p1U1cb3JzNIHzt1RsIMRKjJS2L+iQ89sU2R64tMrSZMw
         0b9WvedQhXCVGTbEaPooCHUzj1vJrJYkulcG6wxMB/DM0Fhs0eNj5GRvqTuEMJxHvTsC
         N0YQ==
X-Gm-Message-State: AOAM5313j6gB4GWMAEwpkVw1KMyOHVG/eBqGR+w0fyLUmFLjBtDs69kl
        Lp+Xhz8w11JYZ5Tu9LYdeuX7P8bpG2fzV+G/7zuOjVPg5Tigia13G5Fdt7yAVPNkj0pxT03Ao58
        8ztC6AZJ+cXGYG1qpx41vHrat1rnCytGH3xEeKWAvmyd+qWqCU022ozdtWFxrJzSaGYUfyLDk5g
        ==
X-Google-Smtp-Source: ABdhPJy2oC2R+v03jw69Q2wfAhlKqs4s0XFmL1++/WHIYOv2lwosSEHRypfQAewDVOInZXLXHe3u1i2DFny47DUwwBU=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:19c9:b0:352:d507:9e89 with
 SMTP id u9-20020a05600c19c900b00352d5079e89mr2736990wmq.92.1645796345279;
 Fri, 25 Feb 2022 05:39:05 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:37:47 +0000
In-Reply-To: <20220225133743.41207-1-sebastianene@google.com>
Message-Id: <20220225133743.41207-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220225133743.41207-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
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
2.35.1.574.g5d30c73bfb-goog

