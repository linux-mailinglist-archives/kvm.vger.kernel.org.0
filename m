Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7BB405CE7
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237355AbhIISde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237771AbhIISde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1C6C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so3513932yba.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dKU8VzzL+xz5htacVnCtCEbBjFjEJD2qbf+9NLc7kB0=;
        b=sRC3/eth51sPtmJe7bqhgNFjYTcqQX3RZAIUYkMl16nsPbu8mMyxQXlAfJoXdG4Kk8
         uyiNI53x++eq/1CkiEDqPBnXBhCMMR6oFwQMURdBRGXnm42SrWmHJfz8MxRi5PiTCDN+
         cERd6RKheDnPYlGobe3xPWPsEO8QEvWUGF9d/St+3okAbcKB3a0yKTabdjZwBg8GQo3l
         iLKbIvEHUsZ4L+AgZPGBLRBTAp08uUTruHQzYvubsZzAbrrnUESFCkv7aCt4RdrdTUN/
         bBxQ2iyjhkdq8+bMZGcc4AuM1fycHiQyDpfqGuBZIvKESSl8cadNiO5iaCp9qx+ff1Rz
         CxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dKU8VzzL+xz5htacVnCtCEbBjFjEJD2qbf+9NLc7kB0=;
        b=aall3Cxf4+4puNjV4hFj9bl1S0h4RQiLkshVY6ITiHHJzG0seDSR28ggbs3Cq5gVRo
         s/gNUPjDUGrDEQVDvW4W2CpWRFFxIX3hEmpIUsSK8Grkat9AmmWGsh7rMRJIV6u2fR/u
         6ZE+CxfAa5qPiNGCnb3UKZzHk9F8xCqdQEEo4pjIJTZVH3CFAEhEeAf5IGEPmpB3Fcq/
         Z1IKH8Rlg/xcTcZVIAEZH4NRsXoSytcgkgA0EkEetq9G7MCCkhahD35IWvw420pysD9l
         KeBEdW34zaOFVC9PsEylUK2UH3GF0fTh69GrgZVed1O5MonZAqJfu6cBxjon8GlbwnGa
         ysgg==
X-Gm-Message-State: AOAM530bMExUJGO1cxEdT2/7nstbC4R/Y/UZrwNqr6OD2G9/kcRSErXO
        bm8Nx56Zp1JBPeMjXav+6cIxdy56r1w=
X-Google-Smtp-Source: ABdhPJyHCJFelDJq2Mcq6614/I8wXfBFob0qLQ24WqCYoT+nSgUR9shNwMUMz01HhaVKLMO1eM8/wSnCvDM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a25:55d6:: with SMTP id j205mr5608678ybb.395.1631212343716;
 Thu, 09 Sep 2021 11:32:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:06 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 6/7] x86: umip: mark do_ring3 as noinline
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

do_ring3 uses inline asm that defines globally visible labels. Clang
decides that it can inline this function, which causes the assembler to
complain about duplicate symbols. Mark the function as "noinline" to
prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
[sean: call out the globally visible aspect]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/umip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/umip.c b/x86/umip.c
index c5700b3..0fc1f65 100644
--- a/x86/umip.c
+++ b/x86/umip.c
@@ -114,7 +114,7 @@ static void test_umip_gp(const char *msg)
 
 /* The ugly mode switching code */
 
-static int do_ring3(void (*fn)(const char *), const char *arg)
+static noinline int do_ring3(void (*fn)(const char *), const char *arg)
 {
     static unsigned char user_stack[4096];
     int ret;
-- 
2.33.0.309.g3052b89438-goog

