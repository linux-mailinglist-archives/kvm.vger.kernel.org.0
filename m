Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA283B0F1D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFVVDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhFVVDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:18 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15695C061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:02 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id n195-20020a3740cc0000b02903b2ccb7bbe6so3059311qka.20
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oynEYjbfGkxcQKBEu63DRAhp5WXiHLm3vG69ktsWTSo=;
        b=SdYsFqUC3ouvIEWUZLppsCvI9Os2EWNH/JGnJlNTXqaJiKn+31YIO1RMcM8SDjhRmx
         63VYACUmhaxHV9bJ2XY8TmlLGcE88qTYs/OdY6Clc/6MUztdSxjdC/0J4nm5ztM8X5HT
         LrtoKIx533xncjDTcokYErGSwsnnWodUDbe1PgIqzxz+kUSX5kwLYvf0ciYTypxvpI4K
         rvOflPcIpmbmY4tENr6KAcUy0DjdgjGfllv4ATY46NXzdXcg5vwHlHIDHiNbBA1iCWLo
         IO5mWc4KjnTejly7YQrQtn562db7NuRBb8o9md2kLevui8JZikbYBhKbQREjiZcG9ApP
         URkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oynEYjbfGkxcQKBEu63DRAhp5WXiHLm3vG69ktsWTSo=;
        b=jgxrGWQjzCIan+uT9mpvuu7vj5rvw3hM7PrQksqqMheiYBXtSl9kuuldPl5oZFIiPc
         I2uSOG5nE723aItsYygeppFS9WEadIW8qYhTXzdACbBnB1LWDXBVMS8pInmr5D/CPjQO
         1sakAMrf3DyMB8jAGw7TmJlrKDuVlpoUlc+xSx/P+Snx69vIxdllQl26BsmbUruQQhYW
         S3UWoZy0MdQ/F5y1J6YxJNMt2z+4fpFKoNpuM0HYdxowdFmZoIeDfvXdofzUvlqFB/4Y
         P+lReeQcnP1z3LdFRtFPE+jWqw3ezO4HjooUDRFgPFV56Doiap0lIFAqM4XewM6Mw481
         DZ6A==
X-Gm-Message-State: AOAM532g/vheiNouAEtyCAVqASdzCFZo2mijp0ZtN9JMEL1F8Ui4zGpX
        tCP945Egoe1HC6S7I4fHIGars2AqJn0=
X-Google-Smtp-Source: ABdhPJyVMGEpOGPc/rF0OtugJz1tszDhOaeUQviXo8Od3tialiJGEMUhpZ+xifmDH6rQtkfcY8R+nrcaAks=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:4b:: with SMTP id
 c11mr808533qvr.18.1624395661257; Tue, 22 Jun 2021 14:01:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:40 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits tests
 (new one on the way)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove two of nSVM's NPT reserved bits test, a soon-to-be-added test will
provide a superset of their functionality, e.g. the current tests are
limited in the sense that they test a single entry and a single bit,
e.g. don't test conditionally-reserved bits.

The npt_rsvd test in particular is quite nasty as it subtly relies on
EFER.NX=1; dropping the test will allow cleaning up the EFER.NX weirdness
(it's forced for _all_ tests, presumably to get the desired PFEC.FETCH=1
for this one test).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 45 ---------------------------------------------
 1 file changed, 45 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 506bd75..96add48 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -774,28 +774,6 @@ static bool npt_us_check(struct svm_test *test)
            && (vmcb->control.exit_info_1 == 0x100000005ULL);
 }
 
-u64 save_pde;
-
-static void npt_rsvd_prepare(struct svm_test *test)
-{
-    u64 *pde;
-
-    pde = npt_get_pde((u64) null_test);
-
-    save_pde = *pde;
-    *pde = (1ULL << 19) | (1ULL << 7) | 0x27;
-}
-
-static bool npt_rsvd_check(struct svm_test *test)
-{
-    u64 *pde = npt_get_pde((u64) null_test);
-
-    *pde = save_pde;
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-            && (vmcb->control.exit_info_1 == 0x10000001dULL);
-}
-
 static void npt_rw_prepare(struct svm_test *test)
 {
 
@@ -844,23 +822,6 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 	   && (vmcb->control.exit_info_2 == read_cr3());
 }
 
-static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
-{
-    u64 *pdpe;
-
-    pdpe = npt_get_pml4e();
-    pdpe[0] |= (1ULL << 8);
-}
-
-static bool npt_rsvd_pfwalk_check(struct svm_test *test)
-{
-    u64 *pdpe = npt_get_pml4e();
-    pdpe[0] &= ~(1ULL << 8);
-
-    return (vmcb->control.exit_code == SVM_EXIT_NPF)
-            && (vmcb->control.exit_info_1 == 0x20000000fULL);
-}
-
 static void npt_l1mmio_prepare(struct svm_test *test)
 {
 }
@@ -2719,15 +2680,9 @@ struct svm_test svm_tests[] = {
     { "npt_us", npt_supported, npt_us_prepare,
       default_prepare_gif_clear, npt_us_test,
       default_finished, npt_us_check },
-    { "npt_rsvd", npt_supported, npt_rsvd_prepare,
-      default_prepare_gif_clear, null_test,
-      default_finished, npt_rsvd_check },
     { "npt_rw", npt_supported, npt_rw_prepare,
       default_prepare_gif_clear, npt_rw_test,
       default_finished, npt_rw_check },
-    { "npt_rsvd_pfwalk", npt_supported, npt_rsvd_pfwalk_prepare,
-      default_prepare_gif_clear, null_test,
-      default_finished, npt_rsvd_pfwalk_check },
     { "npt_rw_pfwalk", npt_supported, npt_rw_pfwalk_prepare,
       default_prepare_gif_clear, null_test,
       default_finished, npt_rw_pfwalk_check },
-- 
2.32.0.288.g62a8d224e6-goog

