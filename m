Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77DD6296FF
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiKOLQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiKOLQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:01 -0500
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676B1B9C8
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:54 -0800 (PST)
Received: by mail-wr1-x449.google.com with SMTP id d10-20020adfa34a000000b00236616a168bso2686859wrb.18
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e/OndFv4+hmhVq9SAVUchluz3WYiOe7MOTmH3Il+F48=;
        b=oY2omYev3mrlBBTVldpbIhtG22X/nKyTJ1jQBLLaBiCeiy/7D8Y0Ze4Jt6xynz/yX6
         dMVKV3QHNU3fuWygsEi5tYYv0cgnAjyg4Qjl75kjPJ9tB6TWXcr74j0R0h4pE1cGifVx
         fH0StiT4CBP8KNjA6OnkiohMQQLdlkgqhPziEYsXSXjPcRT2v0iKamvpxEfIPJ0jej24
         wyeDW3xmA2Zu/b/0iSm2z2sUdcBlI85/ErtDdeCGpv+kOmRBtEjZFoOUkzBzavMVRYFj
         lHQAR46oZbArdSkamgJF6Cff59aA8RCXGVdVPs7UhbDEpmWMzZ/eJQbBc8ghXJ5gA9Ax
         vI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e/OndFv4+hmhVq9SAVUchluz3WYiOe7MOTmH3Il+F48=;
        b=SPMKBMtV86AAw4g6qr497FZC29kFpmE35Felp0cIxJAsIkaUGzJQ9G9z8Kdm416DGq
         1TnQhsYbk8jYyRv8uUvSNBLNQfnTgpNS8l8OQGpoGHu4vKNdIsr6OR4SJlKf9KxVG19g
         /dqKqfojpz/eUpx83bNwgna+mCaVMsHvT2liGGGz+9I+JMiTJQzLVi/DzZ/v8mJExLPX
         +RYt4Y9lny3tNolklonSJr7Ea/yix/FR2FxYQrC+KofQM1vZBt23BBG/imhh+GPCgUJ6
         dkJdF/rtsADXkbpB8tXIsD+WOY+H1c+lWj2n+Ywp+kdhMK+NBRX8jhqjC1GhNp90e9KG
         Tkig==
X-Gm-Message-State: ANoB5pk8EcyCyeoyPhmGU4jvNLx+M19eskE8gfLUWM5UF7rVrhxKhd/O
        ZfRLAWttGGy10QVacg0xWjsf/m0ALjRqT2SerDJ5P7uHQNICFUmjYd5maTTYzvgnhDfOr6rAhe7
        Mb+UIrtBZ7irehAg7VUAy7gg4xj4LEPk6gsU78IN+wQVxLeRjdTOLFN8=
X-Google-Smtp-Source: AA0mqf6RT95dr1Vf9xPW5BAQMoH5P1aV0LZZy0wCQmxtWHHyEaYShHsd7tPEc7+NoI7KBqMUMn14vEyOAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:cc8a:0:b0:3b4:7e87:895f with SMTP id
 p10-20020a7bcc8a000000b003b47e87895fmr1099830wma.30.1668510953176; Tue, 15
 Nov 2022 03:15:53 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:33 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-2-tabba@google.com>
Subject: [PATCH kvmtool v1 01/17] Initialize the return value in kvm__for_each_mem_bank()
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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

If none of the bank types match, the function would return an
uninitialized value.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm.c b/kvm.c
index 42b8812..78bc0d8 100644
--- a/kvm.c
+++ b/kvm.c
@@ -387,7 +387,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
 			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
 			   void *data)
 {
-	int ret;
+	int ret = 0;
 	struct kvm_mem_bank *bank;
 
 	list_for_each_entry(bank, &kvm->mem_banks, list) {
-- 
2.38.1.431.g37b22c650d-goog

