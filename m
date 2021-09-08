Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04A404049
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 22:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352342AbhIHUrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351341AbhIHUrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 16:47:15 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3F2C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 13:46:06 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ib9-20020a0562141c8900b003671c3a1243so6202799qvb.21
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 13:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qF97yXgsRzV3ungMdG5bG6G9jBC93ohJ5yc9P1yXLE4=;
        b=fCb07BEebrrPVhj8Kva9S5BiI68NfTpzb9aflRw0iTJ3rdAzk399DXy0gyr+OhSHqk
         qP5/tMTOBi1jsmBnhGwF8zScUaxqUPHJ4taY+1jrveZNgf5yhSrv7zYKqF3iH7LKIENy
         dCsKfXaICxlg+Jnx8DTpmkFMKb03bJBcM56kI7yaflsa9Oc5RN+gOrmFJqIM9UVfD+Db
         kIHvsDcklZXpLOBFo6+9+XWHDjDN3TcjXeOTcD8Dstz8GDYKqG3ydX/oYWbBXRvkep2k
         Uw5cx7Krvr4qusl6pSKldw+AcPLKWclhBKCvfvTpn9okrN7yfDYZjphMgUlcbaEVqh59
         oNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qF97yXgsRzV3ungMdG5bG6G9jBC93ohJ5yc9P1yXLE4=;
        b=PuYljwtDL1Odu39sFw/IeZGxyddzP4gn7z/1ZyohdMW3Pmtq5pFbN53ia/uYtSwc98
         vFyDMLxoq8U6P+dIcyAvHQKurH0mWhY4CXyq1SOEk+BWPL9JO1i+mfuHqMSwUb2gLScc
         CFyxT75z4yobLzb7FA6TzJx5vQd4nqa6TW0sSGsynyQ2mJJGKjX99EWRhpnmlGlALubx
         ZprJFw5Pf5RrvzKzhLu4RWvKgIUFuY4zIgbJZOWwd/bkXpkqRhKbdmFFIQK/uCt3xe+q
         bUcc8sJnkqbAmVjyEWeaIUczspKvCJOIEXJp8tlX3FfMxXD59v1EPZz4Is6VyOdzi9xT
         5ccA==
X-Gm-Message-State: AOAM5332bLy5v2DxG1Bf6zJRKgCUVMtodn9PM+WPRTbTOgXf24tVT1dl
        e0iT+Hn6ZINLy9nbTD2IXUsUhzHSFmx386S8M3FuQfBq8ney5EO3SHPSuD49+JNBJvkvFyHuGSP
        VaSVYW5WizYFXp0qJoPaf4XaVsPHuIvnD7fFD5ae3cmTrzS3QcyfcJA==
X-Google-Smtp-Source: ABdhPJyotN0uz30zafOpzWsrscr6mo4X/vcaNNZa2skhfgdh+6I1ZP2minhV44MjcZiJLjo23IHALu1XhA==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:2d44:9018:fc46:57b])
 (user=morbo job=sendgmr) by 2002:a05:6214:130a:: with SMTP id
 a10mr164851qvv.53.1631133965837; Wed, 08 Sep 2021 13:46:05 -0700 (PDT)
Date:   Wed,  8 Sep 2021 13:45:41 -0700
In-Reply-To: <20210908204541.3632269-1-morbo@google.com>
Message-Id: <20210908204541.3632269-6-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com> <20210908204541.3632269-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v2 5/5] x86: vmx: mark some test_* functions as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some test_* functions use inline asm that has labels. Clang decides that
it can inline these functions, which causes the assembler to complain
about duplicate symbols. Mark the functions as "noinline" to prevent
this.

Signed-off-by: Bill Wendling <morbo@google.com>
---
v2: Use "noinline" instead of "__attribute__((noinline)).
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

