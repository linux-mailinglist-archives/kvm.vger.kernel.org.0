Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E431E3F7E8F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhHYW1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhHYW1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:27:16 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAC5C0617A8
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:28 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y185-20020a3764c20000b02903d2c78226ceso797737qkb.6
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/TGLoHJp/GNJCZkxwqIqR8sGm7XTBt8H94lWI2VSCiw=;
        b=KTBVvRBATy8yFyJ6tj0ixwHpwlqBleZ0ieX1VPPDirRpqRSbv042UGhmqVm4nVincg
         ulJ2wlzPBpG7DlsqAtD4JjuPy7vy3Y2HW5YEJ3aORJby+1iGVSno8FQbHsj+n3FApMl+
         yCBrkRQbcjRWuM5UzBYhmPm9d4g2z2gCVU3WvIajXWvd/3XfeA+BUxmEgQqenKFQll/l
         Sqp5z3bN8PYOJ70u8karwpCFfuEWdUgsX6O2cLWoLsMqMWat82Ke9OPa27t8Oq43ZM2P
         mwVIijJZmChZD0wBNTo4FW2hUycCcxWha56CDf+8+a2SmKrxoVfZyIoVKNJsT1jDIhiS
         vyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/TGLoHJp/GNJCZkxwqIqR8sGm7XTBt8H94lWI2VSCiw=;
        b=S9aKlG2liF73DuIZNNtShRAGlP7lUAY+72bI1eDG62sp9jdPqCCi8hVfZnTHVn5zF9
         KprbYRT+UnnAFHfHX2UzAbMVWBR1Twch5mMxkobS48JIiFceX+Y+dfaHQ+E6TbfXY3Du
         CYED6qwYV4At3mw+DJc1ya32NRTxFGmVs8iDTRxeEmgagMMDmQ7iAWqBim0lMcGM6cgL
         vzz7roUnJhUcWZTIDz2ZCqxmYCHesnKTEYjLjqWrHij99/VnENkx1rFTPoXBGXkaVZjV
         HAJ5UgVhPmL+5ScdMyBFJKhpP/2H1/0xUufk1Z1B1WOtfLe8XfMQnAyObFPGmKECYV1k
         bdZA==
X-Gm-Message-State: AOAM530UM4f1D8kPaGkfeuSnWpVc5x5aM9igK52tZXafwuhNP1zQjxd2
        VHIqooKcSAI5hQCIbUc+6Pv1nUkzhyccNy9IjCyvJkq9L08nLVJJFGytBcoYPNQokOVxQijISIu
        ttu8kbT2Bk4KVEhYG5DeGIwa4SNS7Wu2TZZfhQ6+Zlz5n++Zx4sZ6dw==
X-Google-Smtp-Source: ABdhPJz0G/rWGyg5K1F3xoBIogfQGWh9v8usrQJHrENji6SLl0Vs7jCyqvX67AF6oyyXNK/2kyyaO0eEmw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:bb35:184f:c54d:280c])
 (user=morbo job=sendgmr) by 2002:a05:6214:922:: with SMTP id
 dk2mr937780qvb.36.1629930387575; Wed, 25 Aug 2021 15:26:27 -0700 (PDT)
Date:   Wed, 25 Aug 2021 15:26:04 -0700
In-Reply-To: <20210825222604.2659360-1-morbo@google.com>
Message-Id: <20210825222604.2659360-5-morbo@google.com>
Mime-Version: 1.0
References: <20210825222604.2659360-1-morbo@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 4/4] x86: vmx: mark some test_* functions as noinline
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
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
 x86/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f0b853a..a264136 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -426,7 +426,7 @@ static void prep_flags_test_env(void **vpage, struct vmcs **vmcs, handler *old)
 	*old = handle_exception(PF_VECTOR, &pf_handler);
 }
 
-static void test_read_sentinel(void)
+static void __attribute__((noinline)) test_read_sentinel(void)
 {
 	void *vpage;
 	struct vmcs *vmcs;
@@ -474,7 +474,7 @@ static void test_vmread_flags_touch(void)
 	test_read_sentinel();
 }
 
-static void test_write_sentinel(void)
+static void __attribute__((noinline)) test_write_sentinel(void)
 {
 	void *vpage;
 	struct vmcs *vmcs;
@@ -1786,7 +1786,7 @@ static int exit_handler(union exit_reason exit_reason)
  * Tries to enter the guest, populates @result with VM-Fail, VM-Exit, entered,
  * etc...
  */
-static void vmx_enter_guest(struct vmentry_result *result)
+static void __attribute__((noinline)) vmx_enter_guest(struct vmentry_result *result)
 {
 	memset(result, 0, sizeof(*result));
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

