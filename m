Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02FC756052
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 12:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjGQKXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 06:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjGQKXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 06:23:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A23D1BE
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 03:23:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfae0f532e4so4185523276.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 03:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689589385; x=1692181385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6m73ah1DVsdVA++i2FD7fWY/5U/zHmxaCEfOABOAT1I=;
        b=E+d6u7bagGYn313L7xU9vf+hfckEtby6XpI4RNJjQotn0tyYMltVlmxNYf4aP5o+xr
         1AAVK0rRfu4pr9QCs8eVVIQYt4TgBYrxBiY6A9eXMaOvfBEkn5/oYxLgEu1teRgxlhVK
         jP/ieTcTuQFowfjn2MidaQkFAjdqLBmS2b3fTr2Ek8Wz/SWeGzklIysmnNHgkJq9J+Bd
         wEdZ8KL1cxxDMN5pN1RTskEoqLgQWDYvOOPFK1Tu3PMs4v6C7mT00X2w1XGz4GRtVh9s
         K0zzg4uDPsi7fnIOhdApT23Vc5z9XnHKgeMTrzTUFC6H8kjUpqSWE0LIkZniD3EETvHl
         rquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689589385; x=1692181385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6m73ah1DVsdVA++i2FD7fWY/5U/zHmxaCEfOABOAT1I=;
        b=cj4R3WUIO7/k66ceLNHwu0y7vz/FKYvRTuhyKiaANzFE7TKPixaR1Xu5TYdA0D6cD5
         sxO5EuWBWKngCB+cuNd3qMSx0K3IpKj7iz3/pOgEvcFS5fKE6S5zUEezGaTDfAbwUucA
         bABaPXU+XowvfS+tG2yyrbjeA3hhSVwXOjdDW3kTm+kH6MwoWZ0zZJAOq40DouvXq8vF
         WG/ra4v67JE/rL3jZDEpMe93dmw/vHakPK/qldfrvxF9rHnY9G8wGzEeJbjoVy70MAgo
         E7lTjxEJmcJbp0wwrAQ14HYjMTt9mnrDdI5Tth/FsyXr73W8j8vL3J+4MDZPeg3uUiiE
         L9/w==
X-Gm-Message-State: ABy/qLZb1gu2bLF6JNdS/YAEkKFSD3wmxgtzaZpIm3KRjcINx9IdAjll
        rzh2QMMbqyTEHuiGWUnEE9KtxShKzC/FrRBLyaU5lzwYCgkP/Gl51R/tzn81tEas3Rr7H74zv7J
        N2kkIrMXEw21Iqva2oOZnCjIqkESfaS7fWCW7EWpf2qajk1KpQEmLyvc=
X-Google-Smtp-Source: APBJJlFX3h2KG9PglQ6lM7KzM8ctojxlqh8xlyE9tsoCoe9MzKquqyColBF8Zl2BSdDsFN6LChe20jsCSA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:e755:0:b0:cca:e68d:29aa with SMTP id
 e82-20020a25e755000000b00ccae68d29aamr64913ybh.12.1689589384703; Mon, 17 Jul
 2023 03:23:04 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:22:59 +0100
In-Reply-To: <20230717102300.3092062-1-tabba@google.com>
Mime-Version: 1.0
References: <20230717102300.3092062-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717102300.3092062-2-tabba@google.com>
Subject: [PATCH kvmtool v1 1/2] Factor out getting the host page size
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, will@kernel.org, penberg@kernel.org,
        alexandru.elisei@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out getting the page size of the host into a separate
function. This will be used in the subsequent patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 builtin-run.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index b1a27fd..2801735 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -360,9 +360,21 @@ static void kernel_usage_with_options(void)
 		KVM_BINARY_NAME);
 }
 
+static long host_page_size(void)
+{
+	long page_size = sysconf(_SC_PAGE_SIZE);
+
+	if (page_size < 0) {
+		pr_warning("sysconf(_SC_PAGE_SIZE) failed");
+		return 0;
+	}
+
+	return page_size;
+}
+
 static u64 host_ram_size(void)
 {
-	long page_size;
+	long page_size = host_page_size();
 	long nr_pages;
 
 	nr_pages	= sysconf(_SC_PHYS_PAGES);
@@ -371,12 +383,6 @@ static u64 host_ram_size(void)
 		return 0;
 	}
 
-	page_size	= sysconf(_SC_PAGE_SIZE);
-	if (page_size < 0) {
-		pr_warning("sysconf(_SC_PAGE_SIZE) failed");
-		return 0;
-	}
-
 	return (u64)nr_pages * page_size;
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

