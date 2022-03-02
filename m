Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAC84CA713
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242641AbiCBOFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242622AbiCBOFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:05:02 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DF07F6EC
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:04:15 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id a5-20020adfdd05000000b001f023fe32ffso671539wrm.18
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=o82nPL0gjuRITu2Bpvs73uaFUhovxw6j9Yj+PwDYqJVsUrJl8yGIqUHkLQEbjbZGuj
         musFv7EoafDf3+YQUZh1aClP174TK1/Fw246qwJF/2Xjg9ZzeXxv/t6qjBzDnxSXfLSB
         TlWck78RV+WJhh+fRYwBWnTqc7PHznX3qV1dNWH+ZjZ423onbPqKfE8SHqAqisRqPh/V
         qskswbtXL9ZLVbsuz81ckiZh8IxZRCY6OiyRItCZjLu9zG2eQzMRUpGv9+yHt7TU81Wc
         bCJeOT1u7DMko70QurcxhI+OX5xY1Pn4D/0msQgy7sdBeRTgG1FsMZFwn/HBUDCm1iMO
         amRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98qRkgzqUA4uIyFb6DyG2/PM4ohLc28A3d+n2FMoR2g=;
        b=acXSJ9hYlkcCOFJsbwMteHLyV/RWz6SwjvzN/AJFYzHutu9ouwlWwNzVHIR2coD6p0
         FiDyrufYyLV0FOUqar2maiRs+mahU/Hn/rMnwLOrz8Qo/CoPMoRV56oujUkcZSe+uiDO
         h7Pc3BUOxgIX6TS1RdJSwwkVmhoifHnAYposPkHrDECRaaKTdzOnlUIsbz2UtpyZ2KZV
         AI4CyzbZOuHGRuMaLjDFBdLOkuEE0qJaE4PdjumwKkYqDd/k8qCIFdymX8RCNZtS2cbc
         nDFainooW2zdDe1Sm8QT6n+68drnMcebFoqdwBjFJy/WwftBOwtFA+KpSPHniOlTIU7E
         bFZQ==
X-Gm-Message-State: AOAM533lASppztvyC+FDKMNVIzLBHXf5DSz/cG+wdwM3cqCTWDbOpcUz
        IYydjJLfUDWYhrVVf8QAr3/iBnlVbhCPrJKYztk9mwdO6mDFq4Iq/N3alAdOXeID6LhIqO5LMB6
        SZVilHGxU5LnifsdXUEWkcanxmsGCjUjdNAJ6tq0nCshkjmk7Nny7mV1LUM1lBOlAmywsbW8yTQ
        ==
X-Google-Smtp-Source: ABdhPJycryaeuYs8h0GXiIUO1a3dPk719+zggvGmtMKCP/FVfX3wD6UQPMkWO3x74478oMpaY38LQr8H34MwKJcEff8=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:adf:f201:0:b0:1ed:c254:c1a2 with SMTP
 id p1-20020adff201000000b001edc254c1a2mr22939127wro.106.1646229853496; Wed,
 02 Mar 2022 06:04:13 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:03:25 +0000
In-Reply-To: <20220302140324.1010891-1-sebastianene@google.com>
Message-Id: <20220302140324.1010891-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140324.1010891-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 3/3] Add --no-pvtime command line argument
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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

