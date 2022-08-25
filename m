Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017E15A19EB
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243180AbiHYT7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242861AbiHYT7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:47 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4595270
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:45 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id j19-20020a9d7393000000b00639226c791fso4759421otk.6
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=azHCMaPpRjsZ7o1tI0eFgrUVScvptX6/vV1yqtW6ZYg=;
        b=JfB3HaxMEKG5rx8DVVBW4E50VcwD+rD2PkVh771daH70JAbYyuun9vIvPlv1xtGn9z
         l8W/QkqlkiRRXCkworwmV+i4aSzSBot+zHTxrVrhPPqDnXfgd4PGkYRk5cAG/VGTyDSj
         FEiJ1QTTy+7OFtkrOZ4GfYW2F7Nsyr2BVaYPstlZLiUU6b3tw6BJoRXlp0bCZXOmW6t8
         V4DTvIRyLtCWyUkFVe4i0kqObix713y6bpzbcN6jrp2S3iitslGk5akPfqm9XXswr4XS
         d4u21m4UasgI46OoLw7A5GIohDuVfJyDGzac3XPbNJs9aXu0cpo95u4gvQbBzTjF5AjP
         Ulow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=azHCMaPpRjsZ7o1tI0eFgrUVScvptX6/vV1yqtW6ZYg=;
        b=cWEuIHzV4wok2F4JRs+U/v9IuG33mZT+zCYx5czDWhAcDTWsgh5Zu5FTLBRC6ZIjWY
         INYMlVgCGb8f8jC9bTFYW3tEhAcoHVcsEM0t6zS3u26ERfULKANBjl8DbWe5kkXNtjEY
         8+AqVZ8ho+3lEq3abcKbjYERT9BCiEUi1i3Gfm9s8jmcPtDejcSFt1X+wfrMFHHFRv8Y
         a9v0UY92UvC0iaVkteviIX9g6Q7r3jKbp4G6/1a4/zgNpoRtYnUd3R3pRpbNduXg4hxT
         zvrUD6A8Dq3ac2tNTte7Cnbu4DOXut+dEmD8P5FbKIV4Nh8OxExOUreppN28TnjEJekB
         7nsA==
X-Gm-Message-State: ACgBeo12eTR+rbF6zJ1AmyvxfB+FkXJRj6oXImqROMBahqBVMlm7TTLV
        449YtyME5i1HFVb1Of63WznlX1yuBe4=
X-Google-Smtp-Source: AA6agR4M8VDqDLbYtalftWriJsGQuT+KPC3NOCeu51ZxR+DTNmyfIhGAAEbm7Hauo1Fn0xNFJV2UgMwL2+Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6870:d785:b0:11c:4362:64c9 with SMTP id
 bd5-20020a056870d78500b0011c436264c9mr337767oab.155.1661457584690; Thu, 25
 Aug 2022 12:59:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:35 +0000
In-Reply-To: <20220825195939.3959292-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825195939.3959292-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 1/5] x86/emulator: Delete unused
 declarations (copy-pasted from realmode.c)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Delete unused declarations that were likely copy-pasted from realmode.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 7d97774..322c466 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -17,20 +17,6 @@
 
 static int exceptions;
 
-struct regs {
-	u64 rax, rbx, rcx, rdx;
-	u64 rsi, rdi, rsp, rbp;
-	u64 r8, r9, r10, r11;
-	u64 r12, r13, r14, r15;
-	u64 rip, rflags;
-};
-struct regs inregs, outregs, save;
-
-struct insn_desc {
-	u64 ptr;
-	size_t len;
-};
-
 static char st1[] = "abcdefghijklmnop";
 
 static void test_stringio(void)
-- 
2.37.2.672.g94769d06f0-goog

