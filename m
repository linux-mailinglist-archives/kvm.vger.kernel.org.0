Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C1F75628B
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 14:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjGQMMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 08:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjGQMMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:12:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9934D118
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c361777c7f7so8671579276.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689595957; x=1692187957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4azJb86a4WmgALvbmR8yn/1ad4s0HlGtDbq1VbhmENs=;
        b=Kho+0sGzwcpR++Nyb0731VhgCw9eC1gMeJSDCUZZn+kRwGfUZdPMPY1psSGFZ5FhDA
         pLy9d1gew+FB1lTr9DBeXx2LgpJX9bq9NDlcnEA+epOR2I24IzeLY4bNeZjGWhDI6wHU
         F8KFmGIRtfwg5bUwCspGeEsbN5nBqctNB6stT2cJyPd/IJ6f9zhctYEuY7RAA+zF29of
         ohTS8Z0u8nq2P0IcQOgs6AkGOIrRnkowTTo4Ux3cZ5RACPKuIrywYJ3I6jUlo4yM3tBl
         g1X+vEdnCK45mel97vvyBjT7NRYGfBqYomWKtf/At9JbD8A/qNdGRsBzowmDRDL4gSFe
         dwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689595957; x=1692187957;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4azJb86a4WmgALvbmR8yn/1ad4s0HlGtDbq1VbhmENs=;
        b=BpNneNpIa8g06x8zbPETYsBy6Di2uGrN5dnzHttzQ6fIg4nShtFMw8ghXqaBui7UFt
         iRqEQD62FOqFvyRAw3PKaCfRjzxSGUa3E3stGfPY7vGOh5Go2wYeSrpc6hmPDxQDpiqZ
         6uHhe0p1oHdZaFydjq5qfOGkAT22PBFhEnSur3syPLs1NaUNmi+fkzoekXyEUjhTzcD4
         efj+BZmgcoNY8QucrJ5/twnnYjqOJOE7P54aUFAPP8k0PVw31AcCWZnTMtlab1PUmfax
         s2KAmqs8Q9u8/omY4x+KRxIWGVg7AdbGi0pQOdF9a+9sOuNNdxbYJUJD5ihJHm9Elix2
         U5EA==
X-Gm-Message-State: ABy/qLbeIokL/0D9D4FH2v4LeLaB0X+Pgc4aT1HaNdyYOAHFjs93ZZIt
        OVSBmE2TDsc8b1WzW4n23JDhYyZulnptmFgEaBBekLWiotwwitKFPnuBUJyDt211WBbzIesxgSO
        pbH/2FynTHOBEmZW1GJ/JHkJJB7O8cFigs2EqXmGG7B1WPCXYzvWkwLs=
X-Google-Smtp-Source: APBJJlFndxcL0vcK05hAIkrh+dLL0psAj8yDKxmv6Ipl7looOvfOW65abdEM3mbQD0ZhqHFCErpxwqKJZw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:11c9:b0:c2c:1b68:99b0 with SMTP id
 n9-20020a05690211c900b00c2c1b6899b0mr187313ybu.5.1689595956747; Mon, 17 Jul
 2023 05:12:36 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:12:30 +0100
In-Reply-To: <20230717121232.3559948-1-tabba@google.com>
Mime-Version: 1.0
References: <20230717121232.3559948-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717121232.3559948-2-tabba@google.com>
Subject: [PATCH kvmtool v2 1/3] Factor out getting the host page size
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
function. This will be used in a subsequent patch.

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

