Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0109975628E
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjGQMMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjGQMMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:12:43 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6AC118
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:40 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id ffacd0b85a97d-3144bf68a03so2462470f8f.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689595959; x=1692187959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9rW4nK/BV1RMi69g81MFe255uXHx50GdISNGnF/xOhk=;
        b=S0hQv11THvUz7i6nWCQ3ScH1iGlPllP3xj9+uvpiPJ6b/Z9xCe0Df2ba+O/H7/3jQ1
         YcGoPxP/Mpj2EFtbaVc3F4djkkG1s3sz0umDKrfwREBJ6/3iiaqEjqxUHvLVR8yV42S4
         2SL7xW5cwoqPkBdmJNKia9k8o6QrXf0/giSuucshA1BUAJ8QBaAActN0Q659CviB2UtE
         PcYcpr8AB2CEu3OvbKPWIZWJZmL/+rv3atg9OwWgD3K6sRUTn6Y6DHizbFgVtxmjxWAP
         0Wdysc7bAYM+YRGi14AJxAXLnkmmbucrcGGYQVswilj2BM/lblPoVwDKt+E0IWTtsEjj
         U3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689595959; x=1692187959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rW4nK/BV1RMi69g81MFe255uXHx50GdISNGnF/xOhk=;
        b=K/MNSfjPTEgHPl5gIrgVgqStOgHvoWQlDw4Fkvz7Pe5Vgd2578UyZelEW4hmlLKKnh
         EIO4OklnNySFtMJYoUBM5/oydZDD8DDgGBe19rU3V/db2Gsj75Q+Wjwnvv2KEFYmSB5i
         /1UyAwo2nsdlbtVHASitpKrysh3M4N75pHciqHdc4oTQ3Awnj8Ao2gGP1JM6WkdMxWMy
         9IPDdbc005PteOlehbXWH/0EJzQVAwwxvZuR8vnskjxsX8Y4XMAZmLgcQEHXJv862NqH
         BuAoj0ZkZADbrJBP4hBD/90YUZGQfAj0NiW74Y3cD/ETVz0POiKGpSZW2gHc+X6DIhwr
         X2OQ==
X-Gm-Message-State: ABy/qLYZkY29Pd+2E3Kk9S9xeAhJl+AirXBvYX0bWIx3BqYWEnZuyVIK
        drnJ2O8AkG2n7FNAqrCs6DCEPJFTQZn3KZ3kbHczj2MBD7UfwIjwpkdB4tAh6A7akJ/A3VjBnvd
        uF5yDCfQK8FfDQOYsRyCELeN7827QvLsXCbBhZEf0ui1eKeo+NQXwyC4=
X-Google-Smtp-Source: APBJJlHyDkVoY1Ob4ztLHt0+dMzJdr/O6DlQOmekssoXdZknKA8Zjo8tf3jXOPBSSQQtcxlzsvVn7Q7Xlw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:524b:0:b0:314:35c:a91 with SMTP id
 k11-20020a5d524b000000b00314035c0a91mr86957wrc.2.1689595958904; Mon, 17 Jul
 2023 05:12:38 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:12:31 +0100
In-Reply-To: <20230717121232.3559948-1-tabba@google.com>
Mime-Version: 1.0
References: <20230717121232.3559948-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717121232.3559948-3-tabba@google.com>
Subject: [PATCH kvmtool v2 2/3] Factor out getting the number of physical
 memory host pages
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

Factor out getting the number of physical pages available for the
host into a separate function. This will be used in a subsequent
patch.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 builtin-run.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 2801735..44ea690 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -372,17 +372,23 @@ static long host_page_size(void)
 	return page_size;
 }
 
-static u64 host_ram_size(void)
+static long host_ram_nrpages(void)
 {
-	long page_size = host_page_size();
-	long nr_pages;
+	long nr_pages = sysconf(_SC_PHYS_PAGES);
 
-	nr_pages	= sysconf(_SC_PHYS_PAGES);
 	if (nr_pages < 0) {
 		pr_warning("sysconf(_SC_PHYS_PAGES) failed");
 		return 0;
 	}
 
+	return nr_pages;
+}
+
+static u64 host_ram_size(void)
+{
+	long page_size = host_page_size();
+	long nr_pages = host_ram_nrpages();
+
 	return (u64)nr_pages * page_size;
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

