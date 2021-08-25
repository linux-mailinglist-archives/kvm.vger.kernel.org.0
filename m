Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC0A3F7E90
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhHYW1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhHYW1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41A2C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r15-20020a056902154f00b00598b87f197cso1025407ybu.13
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jV1kADjIBEEvbrOctYQDKImdyJm/A2BVxHX6boTXWrw=;
        b=Xuu8RQGxf/o9KwmX0aEMYdCh92QhyC6oEQ1sNlrvrFzRc8nsTlUlZZrqIsvwJVoTKC
         Yu5Kauhl1LtjLES+f67B8caIKpyh0DlUcewOvvJYZwG1j9xdQ4WZxN5v3PA/Fvqwkjt8
         1G/ALsxaD6j8rWVSW974AYW4WTWzPNjiXMDebXatuZHJDhY8BSTlxDDYCaxPJgFHIW4K
         dckDhp9jc83W2PG1RpQ+HBSAjRuSMDDFs3GkVN1IlmC9Nm9ZRa2M1PpOSciA0TYjbMAB
         1K1qLvgJ20NZe4h0VDyGO38/WKJe4VVyapRsyTlnb/GEqHggrNxaF6f2bJeFlzLdT7Tk
         8ZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jV1kADjIBEEvbrOctYQDKImdyJm/A2BVxHX6boTXWrw=;
        b=pIl6xiZtrYHXLl64miAmNol8nn2fFY6i8Rbg1KLDVvX4jncjGTvSzVz/UECMVydB68
         plg8/SfTkGSI8SKYpykSOWmUiXSTGzG+ornwA/m46/Y97sf3jfxszVQghrsBLfqh5Obq
         QPp5NpPY3T4vSr1Fmffp6bmR367nIauen0yWHumz7BBPV97oJmiP6tYqxZ+Z+17ImSgw
         DTd6RSgWqsdbQKlXSqx71V05Tk97HFinAk65YowReuzEbmTDPrwtfGLEPU48yPeswVIS
         hQbAO97RTB0vVLBCLxNHZ3TFGPtEtBbvutfiGQbGt4w8rblR7ncZvRv/Ny1lylrRwIkV
         PZyQ==
X-Gm-Message-State: AOAM530XeRC122+tz0tkieb/LDssUNGgyrXj2jWc7Y+dqkApS7JbqKPM
        L7xbsja28EEpSwX+rpcyFjKhfI9TX3W6JhCOiexhe11d94sc5qZ8PeNbX4cGYq+sD7a5Xg7sJtW
        L+eQfsFnjqoQpYMXw0Ry3a3pBK2wII9jeh9GO5ojpLMV2Hxh3n+LWcA==
X-Google-Smtp-Source: ABdhPJwz/xcBXN+lkW50vLtXvvM2KUnfxHRwx7T015dYeTGFCkHiShDv9eW4lYcz8pSfF8RAZamYenlIMA==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:bb35:184f:c54d:280c])
 (user=morbo job=sendgmr) by 2002:a25:4c07:: with SMTP id z7mr1335268yba.350.1629930383009;
 Wed, 25 Aug 2021 15:26:23 -0700 (PDT)
Date:   Wed, 25 Aug 2021 15:26:02 -0700
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Message-Id: <20210825222604.2659360-3-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/4] x86: svm: mark test_run as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

test_run() uses inline asm that has labels. Clang decides that it can
inline this function, which causes the assembler to complain about
duplicate symbols. Mark the function as "noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index beb40b7..68fd29b 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -256,7 +256,7 @@ int svm_vmrun(void)
 
 extern u8 vmrun_rip;
 
-static void test_run(struct svm_test *test)
+static void __attribute__((noinline)) test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

