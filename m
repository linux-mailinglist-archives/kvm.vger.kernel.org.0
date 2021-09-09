Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4C1405CE8
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhIISdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237595AbhIISdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79963C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k15-20020a25240f000000b0059efafc5a58so3505622ybk.11
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=NHYL+Lhe+hYmmYxZRAH7euQ1gX158VmYVwCZUT1w53U=;
        b=LvS99Bx7oDPIwlmKS1jrQ5FKAr6+5PPKaU8VhU6vGslxIUZyvkFFCHuQH7pA1OGnm0
         QMyOjTqaV7Gul8snbVpg6TFP2Rv21nek+dXLLFgHI7IQ4OZBR2T236haGAzBKJDD9ywO
         20jzoawmw95RVFuxm4e05ATYmODT+jKu8bo6leRbBQ9YsfIFfvtWvGOySpn+NTo+frVu
         P9d5npKQ+/bBDTjHibhLdBolLd5RDugqrRxjzeh6lvnnMjnH6+pe/4x6qAaafT5TsXjg
         5LYjvbylYU8ygTQ7uPwkhhI447xFdXBdqkmStVvFjX3XchMNev9SPOdnEutWL/4UkJsX
         Zzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=NHYL+Lhe+hYmmYxZRAH7euQ1gX158VmYVwCZUT1w53U=;
        b=dyWB5zSgu/yY3X7GriDAnabDuadF4f6ZesZb3qWl8jphjq3khv4ZhfyLdj6RtBNve3
         esKislMlTh2n2e1qAqR/w0TXjRMg81jV+nDaXbof2kEXvHKkTglHsdNWYLRr26AidV/E
         a/xAJxSRNEyFZIXl1aaJ3q+oBnl5ovrSLVtYiqVutE3OdxTaTDr9yNdf1HE5FOWF+5T1
         msgPvcZKm//yFO+5dzg9Xs9b0458tt1Aqd0BcY8DFby7V51BH/PVCtAVCRv9v9OrrIpx
         pyJj0WUbb0gTEhbwbmeMEn+i3N1L8Rs1I52SRZ9FB+OL/hzlqkPQPL6bHiTRP+4/SKJV
         o9RA==
X-Gm-Message-State: AOAM532iUg3d6WgosnM94YcVPMJfS9HpqmywLJcWLKVI/QahvVlHg/Iq
        McCfpsTm2Iqdaz8yeC5QxyHeyZt1odM=
X-Google-Smtp-Source: ABdhPJxMRUxApHR2S8cFUsW/b/MNYTNsqLegdG6XBsYjZNmAah6brHo5+MfNTBkKC42kmaqJv4F0cAZyfd4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a25:bacd:: with SMTP id a13mr6372300ybk.216.1631212345695;
 Thu, 09 Sep 2021 11:32:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:07 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 7/7] x86: vmx: mark some test_* functions as noinline
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

Some test_* functions use inline asm that define globally visible labels.
Clang decides that it can inline these functions, which causes the
assembler to complain about duplicate symbols. Mark the functions as
"noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
[sean: call out the globally visible aspect]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f0b853a..2a32aa2 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -426,7 +426,7 @@ static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
 	*old = handle_exception(PF_VECTOR, &pf_handler);
 }
 
-static void test_read_sentinel(void)
+static noinline void test_read_sentinel(void)
 {
 	void *vpage;
 	struct vmcs *vmcs;
@@ -474,7 +474,7 @@ static void test_vmread_flags_touch(void)
 	test_read_sentinel();
 }
 
-static void test_write_sentinel(void)
+static noinline void test_write_sentinel(void)
 {
 	void *vpage;
 	struct vmcs *vmcs;
@@ -1786,7 +1786,7 @@ static int exit_handler(union exit_reason exit_reason)
  * Tries to enter the guest, populates @result with VM-Fail, VM-Exit, entered,
  * etc...
  */
-static void vmx_enter_guest(struct vmentry_result *result)
+static noinline void vmx_enter_guest(struct vmentry_result *result)
 {
 	memset(result, 0, sizeof(*result));
 
-- 
2.33.0.309.g3052b89438-goog

