Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBD640C63
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiLBRok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiLBRoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:34 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FF5DEA5F
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:32 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id i8-20020a1c3b08000000b003d0683389daso4439287wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0buStrw79eK8dz6iyzCgpE2euqPvOQoxG6AVJwAz10Q=;
        b=Q+2RUqTAWTpNrDLho4QlBMCquPZbDqRk6wmZmtgjRRko9fyS3HKcRSNc1sFlTNahNa
         +12vO52zSgeEA6yRSi8at29VGEKOBxhtz38m7QAdqwVxAYb46W3/9fXQ+RZKXx6RLMCu
         3kKsFJdt3di4tC8h0hkXjxfKM751WGxzRbx1nvHZWXgUNmpJKL+5Tcs2vbw+xgfAEFhR
         wUl1J1TNRCtmxqXNriaQalL5VofDoe3TG+RtdQ+8UyjZ2qKEw0nOp9XGe+QvOfJ4yLrh
         zeJrDa/rYvkDGjfKygah+jTKBEGS1+gtFCKj+9uTvrkpP8fwp+IejPN/zqdivb9wgZmN
         0Rsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0buStrw79eK8dz6iyzCgpE2euqPvOQoxG6AVJwAz10Q=;
        b=iboIUx3SSzzszy88wkAQ63ijHkA6/enc6boyHt3eNlJfonl+bv/xEGuS68s5J6XMy7
         BdqNKmzJ8VfEyFgGofr2M2/5zo6zh35T2jwKhatZY/F0+grPCiTU5fvdiWGFiyKKaO6a
         11R2/GmpZ+kar7A8yfBkOTP3WNKwi0GkZrB9dJ4twZOh02MJv8FRXvKzEwvUf4kDwb8n
         9sU0oZ+SKzJ7QS8Ci66/X6ivzrvlFKgR8BmsPT1IWTMELgZc+S5yeVxpxC4O4P1S4+EW
         9rAViK5RbrGQG8OOej4LGv1D5+Nw28asHmhgTijHe4HS4er7PdrR/bbwleOEFP+lnJ6m
         5hyQ==
X-Gm-Message-State: ANoB5pnPiM71Pw84g8A6HRTh+QvdDCM4zuLfXsLNUN95IDWaMfIDeQ2J
        +chJ443SYo7BhJi5CcBhvQ91A8zLYBJMnypMeeBOX9shREo8XuhkQjdTMT4kqUxmMbrz73BIpjl
        pekBCwazUItiPlPxtou8D3uRJh2UDSspxrSZGDqTA5xvLofYkURsHcdo=
X-Google-Smtp-Source: AA0mqf5dgBuxpRqATope9i45YD8sA9sJxm/AGxkgi4zxY4fEY/gir2vDl3YBREoYbW2mMrX9IrkBL3/LJA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ef04:0:b0:242:4b9b:5201 with SMTP id
 e4-20020adfef04000000b002424b9b5201mr1201515wro.97.1670003071113; Fri, 02 Dec
 2022 09:44:31 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:50 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-6-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 05/32] Add hostmem va to debug print
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

Useful when debugging.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index d51cc15..c84983e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -66,8 +66,8 @@ void kvm__init_ram(struct kvm *kvm)
 
 	kvm->arch.memory_guest_start = phys_start;
 
-	pr_debug("RAM created at 0x%llx - 0x%llx",
-		 phys_start, phys_start + phys_size - 1);
+	pr_debug("RAM created at 0x%llx - 0x%llx (host_mem 0x%llx)",
+		 phys_start, phys_start + phys_size - 1, (u64)host_mem);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

