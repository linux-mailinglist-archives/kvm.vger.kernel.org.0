Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3684D76B7
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 17:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbiCMQWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 12:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiCMQWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 12:22:04 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B607818BF
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:56 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id r83-20020a1c4456000000b0038a12dbc23bso13060wma.5
        for <kvm@vger.kernel.org>; Sun, 13 Mar 2022 09:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xRLNPKWQW7+hC65Qmnbks6vmJGfKu2nEu3sFlAXyPE4=;
        b=qAX6/PuWTV9ML3ZFV7QIy8MGiQZMNO6Km4UEh/pTL3k+sy2PiP9RK5nlk7kovOe+JU
         +qkkwGr70ZKhUfNO2nMaAuWyQo9m5vdVEa5eO+ZunDafhs8+VmzUGXvNbujGKbhy0y//
         ajC0/QHCsN8lcboZjcmUt8hkFznzX24El+3nR0YtsQK2SqDyv7mQkunwa3TM2Bt1pb/Z
         aHtXPO/qb9fcWm5tq7NbnuMkJLiIUNdCen4SqwdxF8NI6ITjZGh4UiBiDqT9nNyYqlKF
         wMuqHOzUhpZpj4vcAOghsHdjVCdryXQCgfG8ZAvv4Js1FCiHM39DbE1fulTQfIEkzks4
         jGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xRLNPKWQW7+hC65Qmnbks6vmJGfKu2nEu3sFlAXyPE4=;
        b=2PX0ZzjivphfgvlvhtjF5QHs38mrPO3FWdVflcs1tsQLsj/eQSy7GI93tMGx8R7CKD
         nyT35nZVl0a1VzQhGoL33cEO247kkDMdTCs83q9oLoOAEkNwHaeebuxEXvKo3wjNbUT7
         oqxEkCmObKbHzvU7QMMM2vwC/Dm8P0cm00OSVfBKKO1CbFyHyUjkfuUfgXMr5hn4zqq3
         MwgIUjHKQhFRo78d6STngGJPnY0Li915bng+cUtI7fk+c3fqbW6rvN+n8dsmJzxmj5tR
         6Mmao/MfzkBQhmIsY5Nqk54TJG2Xjgjuahyt/fQFYFH9H/1puacKEaKu4KvXXu83Suh8
         RfMQ==
X-Gm-Message-State: AOAM530d9FB88Mbg1FR/bL/0h4954p1fj5d5KqHXukIp3wqj1y1tGNif
        feol0Ggsr1yPQXCxaSwKjFf+BeBlQZmipQsfNeJJBkjTZ8VKQYMLbPYbw2Im9hZJi7AUmATmcNy
        gS9dvrSGf7NXBbLGAwyqjYd0itdAnezjjmreI1MnD9cLJDm4OSWc9aQTs0QERse2cwU2r97Tw3A
        ==
X-Google-Smtp-Source: ABdhPJwkNB5tp5JuBAYpr2hqSLOs1R8ei9Eat8+26nfA36LM3Juy+JWHu4KJRiwxUWPq0xOBMLw4cKS5rx7nB+uv5ds=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a7b:c2f7:0:b0:389:860c:6d3d with SMTP
 id e23-20020a7bc2f7000000b00389860c6d3dmr14429441wmk.116.1647188455050; Sun,
 13 Mar 2022 09:20:55 -0700 (PDT)
Date:   Sun, 13 Mar 2022 16:19:50 +0000
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
Message-Id: <20220313161949.3565171-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220313161949.3565171-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 3/3] Add --no-pvtime command line argument
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
2.35.1.723.g4982287a31-goog

