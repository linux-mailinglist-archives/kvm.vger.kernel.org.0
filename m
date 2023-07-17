Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4756C75628F
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 14:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjGQMMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 08:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjGQMMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 08:12:43 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986AD8
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:42 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id ffacd0b85a97d-31444df0fafso2729621f8f.2
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 05:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689595961; x=1692187961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NLms2yNMjCb4l7NoGPMRYQDTCpmy6IHTKw/97o5lGBU=;
        b=QmdHU+U4emA+GF2AYjkPJ8VNkHxwvF6P/IkZuWjfuMREq1MqlRp9XyUJl96wFibCok
         N8Xps3Gf4PBDnVCEz6YfzdXe+Y9ZMkZ1/OfCbet02uikl017K/8RK+gWani522JPDmsu
         U9jTpyqE3hB6/5cvdyNSVWK1Y0d1EJOXCOgnhoYvjAYjFM+SrMwP1FYljnJQHT5rJDw2
         93PgtjTkJN+fvW3hPDopAbY29Gm2/l2NAnLVvvhl8vehPa2iQmCkKIWMLgfTwz7n0gWW
         Ugoy++xUdGDWRS9x7IJh7qIK7gkcdK1nk1VL0D7x71Zi6jMGJZAvnO0q9h17pHW+UAVu
         FY7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689595961; x=1692187961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NLms2yNMjCb4l7NoGPMRYQDTCpmy6IHTKw/97o5lGBU=;
        b=gqbQmUBlsb8CpvbZhAYw5BvE9OD1YgNFgEoqICfvvzOr4TxrFD+oM7NHrX52zpt8hC
         u4WcnuK+3zUyGUVrm94RnKZUX9F+4uEIQ1mPWqvQlncxtUqJYl8bHJGIAcciyijSeuGU
         WzemlwIOsWCtBVqklq0Uhwk0otFBW4b5g+gyHRi/WzXRMcKwMj9ng8oCjro41SFG0+X/
         /HF7pl9NqhCnVvkMtOyrp/4AaMBUi7ftBj7FFTTea9S9peprbhkz/xRJz2ytzyLzMQFp
         Li9R8UvD+WnjgstRNwA9W+qtivVNwrj8JNd5Es3PGma4JMkGco9RxG9XQob7pEOZfNYG
         FEVw==
X-Gm-Message-State: ABy/qLYU/DZB5vzJr65gqWPUt86WV7S651Mm2eYpl3VmwZ6SijsiDk0G
        EwoVJR2yZT3esh2CUH69Sc4/k0tzb0NDGHFjow6mANjNEgoWOk2OhGJW/bZNwBcmfyit1kfSkko
        aQE0mAMpusty5iHZYVGraWLoyrBxTnDyYPa/SgpxyaFuj7p7vQFUOAsk=
X-Google-Smtp-Source: APBJJlHla9QvfvGoaIP/iegIGu34wNmyMyC6f5qHUv/oj86f6Vckg8aIeeIkC5Qtf2mpkdQo1kYF+6MPYQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5603:0:b0:30f:c589:8779 with SMTP id
 l3-20020a5d5603000000b0030fc5898779mr79353wrv.5.1689595961142; Mon, 17 Jul
 2023 05:12:41 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:12:32 +0100
In-Reply-To: <20230717121232.3559948-1-tabba@google.com>
Mime-Version: 1.0
References: <20230717121232.3559948-1-tabba@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230717121232.3559948-4-tabba@google.com>
Subject: [PATCH kvmtool v2 3/3] Apply scaling down the calculated guest ram
 size to the number of pages
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

Calculate the guest ram size based a ratio proportional to the
number of pages available, rather than the amount of memory
available in bytes, in the host. This is to ensure that the
result is always page-aligned.

If the result of get_ram_size() isn't aligned to the host page
size, it triggers an error in __kvm_set_memory_region(), called
via the KVM_SET_USER_MEMORY_REGION ioctl, which requires the size
to be page-aligned.

Fixes: 18bd8c3bd2a7 ("kvm tools: Don't use all of host RAM for guests by default")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 builtin-run.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 44ea690..21373d4 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -400,17 +400,15 @@ static u64 host_ram_size(void)
 
 static u64 get_ram_size(int nr_cpus)
 {
-	u64 available;
-	u64 ram_size;
+	long nr_pages_available = host_ram_nrpages() * RAM_SIZE_RATIO;
+	u64 ram_size = (u64)SZ_64M * (nr_cpus + 3);
+	u64 available = MIN_RAM_SIZE;
 
-	ram_size	= (u64)SZ_64M * (nr_cpus + 3);
-
-	available	= host_ram_size() * RAM_SIZE_RATIO;
-	if (!available)
-		available = MIN_RAM_SIZE;
+	if (nr_pages_available)
+		available = nr_pages_available * host_page_size();
 
 	if (ram_size > available)
-		ram_size	= available;
+		ram_size = available;
 
 	return ram_size;
 }
-- 
2.41.0.255.g8b1d071c50-goog

