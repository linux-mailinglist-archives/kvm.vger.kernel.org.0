Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854C8756051
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 12:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjGQKXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 06:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjGQKXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 06:23:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E8133
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 03:23:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-576d63dfc1dso40011287b3.3
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 03:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689589387; x=1692181387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O2goHzsn0D7HLr3tWD6DJt7oilv+gAdPmwXSb9fS+yQ=;
        b=gminds/ETQitdaI6YLgMMuWkwB0vHrFbaCDOofroPnvgn1GRmf3SiCRVn1pQeKiH42
         L5PK8D6TKoqpsd83MeLNGTJlKzpKzu2qmE2iV09lbahrySvT5rX3zsp6vnlacayu2sYG
         KJXnqXXcsCOz1FCj3sKP5IzwCSoLI2VoZwMdjw0s17P6ZOxsDnwHVLniozAx3Bc5q2AM
         q5NWEMrXp4zwErGUaKceRrOkjXFMzn3etZm7AxswQMO66I6bPeslqej+IZPZZ32lRKgW
         HkkrQWH49sYj3H41nlU2YlFX9ILLYZA5G3WC9V4JP+1RmIxCFYQzQ0vmm2DLjl3LZAp5
         I5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689589387; x=1692181387;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2goHzsn0D7HLr3tWD6DJt7oilv+gAdPmwXSb9fS+yQ=;
        b=gtYIVP8Qz8LCgiH9olOxTuHEfNIFK/onPsnsYTCKHFb8P13a7z9SwcO7zyqwUA2xe+
         iRuU5pWRw6aAY1XgVbVGWkafqGcMninpIENZYYJVmrgRZe/l8k+yhvQCA0XeocVg5b25
         mYYtATycNw0QyrgJYj5ww1ugjOMJGsUPCT8j9ZW+GtSKQh0f83nreOthW9tmyAB7k7uK
         uaVo7uSdcZCmeWjJfEpV4JHYbZQqs9vb0vV7EQJRawTxKXZvmL9JA8VhmxGpFT6ER7jF
         CEnoOxmu0TAu2GHN1MRRE0Skd+qWGWxfg9rHxF98YRxAmwCpzwEzGe5/yh1VEYfJTnnq
         DA2w==
X-Gm-Message-State: ABy/qLYQ4Ke5Rglkzc4NUeY3qu+RpgepR/OMkgRZkdAr0bbAdEajwvC8
        8emkA5ra1vMAEhWHUXGywQQjLYB8yN+bdjYQEKwcUaq+96ajwfwz3cY37KnKO7aA1Wsw9ivz1g4
        GzG1hx87qCHkypFdnTp/0HuZQ1QGz/zoueeSNwspT7q8xiLX06UnrbNA=
X-Google-Smtp-Source: APBJJlE6E020XdNxFiVnmjKsvkyxf/YWTfMmVWwpeoQcis4ViM6lLgwtoLC3BUWpTsG5CObCkTb2+/IqAw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:bd4a:0:b0:576:af04:3495 with SMTP id
 n10-20020a81bd4a000000b00576af043495mr140441ywk.9.1689589387459; Mon, 17 Jul
 2023 03:23:07 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:23:00 +0100
In-Reply-To: <20230717102300.3092062-1-tabba@google.com>
Mime-Version: 1.0
References: <20230717102300.3092062-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717102300.3092062-3-tabba@google.com>
Subject: [PATCH kvmtool v1 2/2] Align the calculated guest ram size to the
 host's page size
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

If host_ram_size() * RAM_SIZE_RATIO does not result in a value
aligned to the host page size, it triggers an error in
__kvm_set_memory_region(), called via the
KVM_SET_USER_MEMORY_REGION ioctl, which requires the size to be
page-aligned.

Fixes: 18bd8c3bd2a7 ("kvm tools: Don't use all of host RAM for guests by default")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 builtin-run.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/builtin-run.c b/builtin-run.c
index 2801735..ff8ba0b 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -406,7 +406,7 @@ static u64 get_ram_size(int nr_cpus)
 	if (ram_size > available)
 		ram_size	= available;
 
-	return ram_size;
+	return ALIGN(ram_size, host_page_size());
 }
 
 static const char *find_kernel(void)
-- 
2.41.0.255.g8b1d071c50-goog

