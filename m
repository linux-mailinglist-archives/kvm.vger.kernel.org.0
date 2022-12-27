Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE7656E01
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 19:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiL0Six (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 13:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiL0Siu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 13:38:50 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E691086
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:49 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d7-20020a170902b70700b0018f4bf00569so10554336pls.4
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTGOdyPMxhXd2dAkF3P4Vp+/HdYInboGKUBhJwFRkts=;
        b=L1/OrLGCQnK6Lb+P9AnCl7UxwZL7ycYtIh/0Q+Q/t3W7lQkk9kQS5sxaqAUrCP/1Js
         YLbAw3DXKs141ZbRQs0YN4xTLDBhq6vq7xwETewtPJX6mX9t6jWuDUm0LV4IplCSGh+T
         vQ4ZFPnxSAduquR/hWi55Eqi4YO8/owC2OlMJAo8PaGyNrebWqHJpCXw3w5mrODIb+Ki
         3y/sWaaa2n+72TsL71+oMUqYjnu3S3V5ASXtu+8UeTzrLUwZV1olwAJHzZKIVniVvipa
         UhsGvkyMgcb48+T/K2XTEGL1roBRelpJODwBrjdylfq0+N3HXzmmYFChl06rqVBSw+00
         9Udw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTGOdyPMxhXd2dAkF3P4Vp+/HdYInboGKUBhJwFRkts=;
        b=NMbWd200K6wkHIxlFdrPhrOwx6vAFQ12dVop4dI9kMdu6bvfZjQvQNHJWjXNHYJ5UY
         03Jt8J6o3A8QDRAWQ2wYJLjqCv7C0/T+5RNt0+lDiHUA7BwF1wq0mHWJZhnQs/9f8AbT
         MXqZHmAM5h7n88s3zbwyxnOeLolwXeZEQ8fCcLTjQTTgIdmo23JidyInWlXeHzV0DzxB
         HY/r4r1Re1iOTCmQd/CSv/Xnyvf0hV5lFJPoiRzgrzCJBfLZJ/f64KqufN05tUC+iyKW
         ZrlVu/4Y/9q0SZDdECFjrmBuoxrSBgBeVBVOMDB5I2Z1uRKWtFqWEGsCUWmC2sfK8cH1
         c+ag==
X-Gm-Message-State: AFqh2koKMRqg5tfGdsKpeATjJ1XSN8O2S2vKRVuTuuiLlb2ocDxJVosz
        u5WvZ3iwNLeHvf4Aw88otnKvj5+cIZJevOVXRuc+WJlzISrDa7dUjkU4ltmFcrxmgIsZ0NYthEU
        olKJcumYUDEFcdH0RwYsviHWLA1OL7Pn9HgsLSaSNArThnMomf8Tc6wUGLIavWZE0DlZA
X-Google-Smtp-Source: AMrXdXs35b9Clat4VzqhPNUpMqJKcuxrVYT+KcZ1b/vx+sLlXBQNpngvzHpJhm2kHLDw22l1JxBqeB54G9YYzAha
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:4e02:0:b0:581:1542:23b0 with SMTP
 id c2-20020a624e02000000b00581154223b0mr542596pfb.7.1672166329079; Tue, 27
 Dec 2022 10:38:49 -0800 (PST)
Date:   Tue, 27 Dec 2022 18:37:13 +0000
In-Reply-To: <20221227183713.29140-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227183713.29140-2-aaronlewis@google.com>
Subject: [PATCH 1/3] KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

Be good citizens by clearing both
CPUID.(EAX=0DH,ECX=0):EAX.XTILECFG[bit-17] and
CPUID.(EAX=0DH,ECX=0):EAX.XTILEDATA[bit-18] if they are both not set.
That way userspace or a guest doesn't fail if it attempts to set XCR0
with the user xfeature bits, i.e. EDX:EAX of CPUID.(EAX=0DH,ECX=0).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/cpuid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b5bf013fcb8e..2d9910847786a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -977,6 +977,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
 		u64 permitted_xss = kvm_caps.supported_xss;
 
+		if (!(permitted_xcr0 & XFEATURE_MASK_XTILE_CFG) ||
+		    !(permitted_xcr0 & XFEATURE_MASK_XTILE_DATA))
+			permitted_xcr0 &= ~XFEATURE_MASK_XTILE;
+
 		entry->eax &= permitted_xcr0;
 		entry->ebx = xstate_required_size(permitted_xcr0, false);
 		entry->ecx = entry->ebx;
-- 
2.39.0.314.g84b9a713c41-goog

