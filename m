Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD692640C7A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiLBRqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbiLBRpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:45:35 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31DE1196
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:45:24 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso2815493wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ThRYodwzO4HlBh5q1CYryWQzrraRJD2u7VnaCxXbdY=;
        b=A+2T7WRHYTGIS3MKZCWzunj489VwfelhrmYewv6d8sJJ2/jP3QiFtG1YqS4Uwnm/by
         xQ9MG3TSBQwfCmXSU5oB3EYF7C6SwI+0G7xQ8H6P56AKuyebYZdyF/rucRBXmxbER9vD
         m3bGgYj7iSMjxiAOFF86uyAbETmwOezIduHzn3j7aXKbJtq0rTm+txsBfFMBrCTNKQ4w
         62Dp1Vl6X5F6o2eMOU0WMaTga++AbCWfAvfLGAyZ6OeP18IQmlzeI2/oXeK9kzEZ3JsZ
         Hl0k+5bpXRYGpFdQMj70/mp0kTTwQpKcLrGejNbNLFuHUUHWgSgZ3RXZssM7CTLE5Te+
         AXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ThRYodwzO4HlBh5q1CYryWQzrraRJD2u7VnaCxXbdY=;
        b=Hh1KXxIM04POp0Xtxr49KiSuvBQ7Br78MSinva5ziUYibiz36sdj/qkusSQbOYMZIA
         Kv16T67/kHXJAHw8qVsVDD3L0efc9VZh3Z408RVjJxdesV21utukvw5Dq+80jVGD/r5w
         HpgIb7eQTdLSBI8aWcgRbhVuDca3x9U/hRy/Akwgi3qQQ3OkkRQnHnG9kEBfdksPMaOW
         L1UNUVOwncMn058o71KbhnpW15uKxwvKbwXUZSacMN1/AuD85249MWj7S7DE33FGV0Oo
         QTSiVEwAVhQUlUX3E2HBpJulswzYEH7j45+rTxr7KHCzgh82mpEDjrqr6frbUXrEKROI
         8i5A==
X-Gm-Message-State: ANoB5pkjM+e6DQc35aqPQARdj24WjBj5fl5KbgOvsF4H50TbBSoRjKS1
        BVkFiOxyPEWDAJEPcJb6wEj2YlEFFoyYr80xVBiFJeivmIH1CPAz0xdGriQHmL7NyxAML86pHda
        Httk8qb+k1IkFg2LtvrY8s5dVZkoqdDbMKRteb5gz7bekJ5a+EllwBAs=
X-Google-Smtp-Source: AA0mqf5P1OxcbmXmwUL2lbMOwW30hpJxCjWwQ5bMVjlZ0i22PpPkwbPtviFKfRwzzOGQ+FECnmrnGqcFfA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3421:b0:3cf:ac8a:d43e with SMTP id
 y33-20020a05600c342100b003cfac8ad43emr41493887wmp.65.1670003116803; Fri, 02
 Dec 2022 09:45:16 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:44:12 +0000
In-Reply-To: <20221202174417.1310826-1-tabba@google.com>
Mime-Version: 1.0
References: <20221202174417.1310826-1-tabba@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-28-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 27/32] Track the memfd in the bank
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

Guest memory is canonically represented by the fd, so use it to
refer to guest memory in the kvmtool guest memory banks.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/kvm/kvm.h | 2 ++
 kvm.c             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 33cae9d..6192f6c 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -80,6 +80,8 @@ struct kvm_mem_bank {
 	u64			size;
 	enum kvm_mem_type	type;
 	u32			slot;
+	int			memfd;
+	u64			memfd_offset;
 };
 
 struct kvm {
diff --git a/kvm.c b/kvm.c
index bde6708..a0bddf4 100644
--- a/kvm.c
+++ b/kvm.c
@@ -374,6 +374,8 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
 	bank->size			= size;
 	bank->type			= type;
 	bank->slot			= slot;
+	bank->memfd			= memfd;
+	bank->memfd_offset		= offset;
 
 	if (type & KVM_MEM_TYPE_READONLY)
 		flags |= KVM_MEM_READONLY;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

