Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FCF640C5F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiLBRoc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiLBRo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:26 -0500
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0F9DEA48
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:23 -0800 (PST)
Received: by mail-wr1-x44a.google.com with SMTP id g14-20020adfa48e000000b00241f94bcd54so1256590wrb.23
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yhyawS7kJhQQSVgVJnQgPFltY+BVOYcIZhbJ8N9jvFw=;
        b=gtsqf+Tqym3zq8mDcVkCeMWUB8q2lSdEtTktCFzYsBVqLm2De7d4IHGD8TsO5nFgm8
         nQK38S/+XCyRIweXVhFDhaNgLD4UOUEBbtWpFcFJ7wsD3XVVeB4yUUHEBeJFEWdcPrLZ
         WeDF698pPg6ny61H+Vks0oJOz7cQM0KL7qN3AcICIdS7bGsPjI/PvSx+TwQgd6JBiBRG
         44TMojD+pefKthphiaGbuO/H5G+hqPtzuH4midb7Os0brCQEc2xHzsE8WGYtvZZfUVPX
         xlE/P7waif9w2bwOMp+AAmZCYtI+F++/YZGRLaCTmJwGPcaAE+ZzoBLNQfTJegYj/5nt
         Uvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhyawS7kJhQQSVgVJnQgPFltY+BVOYcIZhbJ8N9jvFw=;
        b=d5msfIPbes7BAYPj2woYtklAzue2LlJZknp/3vGlCzZmeOm4qe8pHMCKsGFEwU/Y4l
         iPD1cdFe56W0pYcWteASQK62LM7KXIvDC3yWrDkvzqAOwZAu4Yig7VZijz6Z0beOAQoA
         F1Ku9d/JGf073wuBQvG4UfjfRefNIHPo5VAddLY53sRzVXFt8MidU8RPsDvKarIPzSrb
         2PcQ9xlesQWYmkEWmhEFe6aru0+pBfXCWPJy/zAF96BTNTxmT68MzHoq0yNRVphIsHSE
         bZHU1cupiqqavkEsPGyTGpb46MpyKGNLkGpFIoK6KfwmmL0aFmvY+hJ7A0fZDXejp5rI
         A8Ww==
X-Gm-Message-State: ANoB5pm/uiHgUfRsTgja0PqcKG3DO4e5DupQUna0TPVJzbLIOcHuDtt6
        u63QTTVvH8ht+FeJABkBCfXbXf64W6I1CsTho0DtbaaAOZHsABTu+XEN4RTSJcsrrGeQK56ma49
        leUOIxjr3zdd6Zh3aODZzM/+vWsWyX3JXnfjX6kabdGZuqiMTIfB06QA=
X-Google-Smtp-Source: AA0mqf74e+cbmoJWL9Zi0NnL0rlr6BCAZZWZ2/NEBmLz2sjz91ObQB1kMw5ko7n/L/fnEyxUMcIzKAKVXQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3514:b0:3cf:a985:7692 with SMTP id
 h20-20020a05600c351400b003cfa9857692mr45930356wmq.104.1670003061592; Fri, 02
 Dec 2022 09:44:21 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:46 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-2-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 01/32] Initialize the return value in kvm__for_each_mem_bank()
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
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
 kvm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kvm.c b/kvm.c
index 42b8812..765dc71 100644
--- a/kvm.c
+++ b/kvm.c
@@ -381,14 +381,15 @@ u64 host_to_guest_flat(struct kvm *kvm, void *ptr)
  * their type.
  *
  * If one call to @fun returns a non-zero value, stop iterating and return the
- * value. Otherwise, return zero.
+ * value. If none of the bank types match, return -ENODEV. Otherwise, return
+ * zero.
  */
 int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
 			   int (*fun)(struct kvm *kvm, struct kvm_mem_bank *bank, void *data),
 			   void *data)
 {
-	int ret;
 	struct kvm_mem_bank *bank;
+	int ret = -ENODEV;
 
 	list_for_each_entry(bank, &kvm->mem_banks, list) {
 		if (type != KVM_MEM_TYPE_ALL && !(bank->type & type))
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

