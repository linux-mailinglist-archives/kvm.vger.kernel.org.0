Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012AF7012C8
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbjELXwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241365AbjELXwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:52:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F23BE721
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:20 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24deb9c5f8dso5541483a91.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935462; x=1686527462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eQC1WP9HfF32PBCDofAFgKjIRQz/i/Wsm+dGz45S7kY=;
        b=0z9ywKuRxK/XqqugSVuMPGre0/Po8fyCsSxJiFCIhtwbRrMCZJEhaBiGdn9Ds0ST1y
         aVSU/Gps3Oa+n6S6RXWn7V0u/AKgfEFdrOeLnrL60X6DkCPMxBOsXPOGC5b5S6FJnu4o
         UpOvqw1yFgIghLp5GskLHwrmqX0dEXdc0T/iIlFiFhCtSr6FGp+7TmLU9Kymq8+pD3J5
         mSlnN8TBlcRMsE38W3JUIuDvWUOHVdUD3B51yV90RNZz0clUKn+1xhb8u6vb1/9theYc
         Ew069Rnx5yUTW3ew+psj0mH+WQVv1UFjm98Qw4Hb/oA/wF0+qdH+j+WgUgzlqHlUroHs
         +qAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935462; x=1686527462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQC1WP9HfF32PBCDofAFgKjIRQz/i/Wsm+dGz45S7kY=;
        b=D7izRsKfIG7EUkzdvqPGOl+bsfrcBFSHCS0LVQkANIZM5kD8mmVAiZuiPBJCxeC95h
         DrQjrWgylXJba7cCyFwjOscCSihjNmDn6jfqWEw1oui4xoG956d5GlVAhq9SLEFn4m9s
         9uhF0/FAbIkwH//wdJ1ENK+wR0UR/hFe/n4T8uy0mXUBwpusFkIR7Qz6tHxSc9kDY81O
         YAZ6xXg3XjG4+V5Fvj5yFeYjC2ohyQKq73xQKfqtHbORW0XbRkidUdyiIZVbYJOOd+Zb
         u6Qi4jW5BQMoGJOBQKXxU/6seAOfDIH9Cvoveh0cv/Y9rltZ+EoEakXgMsExN1ca1MEx
         Iqcg==
X-Gm-Message-State: AC+VfDygRfwM/Bq2dZWDS0CL1NL0LW3qAolzAPv10vOJPiVZAk9JaE2w
        Q0bIklpTrU0+qrrYCXSv/0Xo086DVyU=
X-Google-Smtp-Source: ACHHUZ6Q5iYycxspH41azVUGb++smRyiNiIV0FKdKVgCrDxd4yD3BHLvKT9503TqoBtF75L7PEML+Y9aIJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:148:b0:246:f99b:fd65 with SMTP id
 em8-20020a17090b014800b00246f99bfd65mr8097081pjb.5.1683935462688; Fri, 12 May
 2023 16:51:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:26 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-19-seanjc@google.com>
Subject: [PATCH v3 18/18] KVM: SVM: Use "standard" stgi() helper when
 disabling SVM
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_rebooting is guaranteed to be true prior to disabling SVM
in an emergency, use the existing stgi() helper instead of open coding
STGI.  In effect, eat faults on STGI if and only if kvm_rebooting==true.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d00da133b14f..d94132898431 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -594,17 +594,10 @@ static inline void kvm_cpu_svm_disable(void)
 	rdmsrl(MSR_EFER, efer);
 	if (efer & EFER_SVME) {
 		/*
-		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
-		 * aren't blocked, e.g. if a fatal error occurred between CLGI
-		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
-		 * context between reading EFER and executing STGI.  In that
-		 * case, GIF must already be set, otherwise the NMI would have
-		 * been blocked, so just eat the fault.
+		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
+		 * NMI aren't blocked.
 		 */
-		asm_volatile_goto("1: stgi\n\t"
-				  _ASM_EXTABLE(1b, %l[fault])
-				  ::: "memory" : fault);
-fault:
+		stgi();
 		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
 	}
 }
-- 
2.40.1.606.ga4b1b128d6-goog

