Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B80659411
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 02:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiL3Bg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 20:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbiL3Bgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 20:36:55 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5DA1649E
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:54 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y8-20020a170902b48800b00192a600df83so1269977plr.15
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3wGskcCyiYz5CCtqFByr0hpAIpWgYsQbsu2vOAdkTFQ=;
        b=VH4BlhLtUh7NNIHtveLcLoQzm00dpUqe/vWrdfl4wVlwjAAEdZDSls8kUoYlT2mEsu
         YHPG29Vm1Ty1zAzUjCtvEC68zllsb/6emETnG9x0Qzwyd1WRI45ZJhSxVf6QTlInbx5r
         rVt+4XB8fY/ilGWc95Tzc6ikK0H7J4w3fGe3KssTydQrxeaGilyFYlFIp2hSTWQKeyqa
         ziwl8j5EYwE6mjx6t8wLCNSEOfXqu5tBX5c3ZrY+wTYUrHHsZQUMCczwERFBn3VDACJu
         faw3Z+n5jCfyz6RRF/2mUlT9LWdPwihM52bKApFnOC17jc5iflo6s5aSomQVvg1gYGPT
         7Jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wGskcCyiYz5CCtqFByr0hpAIpWgYsQbsu2vOAdkTFQ=;
        b=BWtx1jUZAE0/GZHA6i4PnBxiZvzrh5TBfS59Tng8CnmAcshiE74n5+VVd+J+FTjNEJ
         6S9xrEV52elmFNN1gC80e+BCzIjZV7XZbP9yKBz73bYVeJ5RFaZiPVSlnyDuq0RkCIzi
         V13EYfnr24q9yR30wPbKkhiNb4RJXvfIhicUQq848b9f71pIBQ9WUrJmnPtO4imaJ4g8
         n2mXyxVy3cyJ4B9qASPkp66OuGFk2/nedPDcBx0igB6XYDQDxir6yfuXAVJ22Rh8RC68
         U/LC6NzUXE8hrhzKVrz6S2weSqL6CsagD6lsd5Bb97taYjXlIzbJLe/P5ErFXp1ANjFd
         PaUA==
X-Gm-Message-State: AFqh2kowKSJr7qZLYophCFIZb3UrigZWyMknWGuYAQOdLm5ZJ4M6tMLb
        hC65j2YOb1S9RtCBZ70YHTmyoxqg+dyxOSpP0/gDh3q0XrEuNh7+CKAUNiifoMEiPFtZmgxYAJr
        EKH1TXOITymhd0DumHSDPVLS7GNDnvEfsIQRq2dm09j7ZcK7qfDeT1GplyAHVcflpzB6z
X-Google-Smtp-Source: AMrXdXvZ30Q7JZa2DFQwpXkwjcxF+CxgqH8AdX9FfaaHAjk8AKJPIXRT4RzoMV+ODadBF9nqpU/Ix5/QaRoyrmfo
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:8c10:b0:21d:f016:5685 with SMTP
 id a16-20020a17090a8c1000b0021df0165685mr2800466pjo.27.1672364213902; Thu, 29
 Dec 2022 17:36:53 -0800 (PST)
Date:   Fri, 30 Dec 2022 01:36:47 +0000
In-Reply-To: <20221230013648.2850519-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230013648.2850519-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230013648.2850519-2-aaronlewis@google.com>
Subject: [PATCH v2 1/2] KVM: selftests: Assert that XSAVE supports XTILE in amx_test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The check in amx_test that ensures that XSAVE supports XTILE, doesn't
actually check anything.  It simply returns a bool which the test does
nothing with.

Assert that XSAVE supports XTILE.

Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b670..2f555f5c93e99 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -119,9 +119,9 @@ static inline void check_cpuid_xsave(void)
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 }
 
-static bool check_xsave_supports_xtile(void)
+static inline void check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
 }
 
 static void check_xtile_info(void)
-- 
2.39.0.314.g84b9a713c41-goog

