Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7538C3EF687
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhHRAJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhHRAJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB54C0613CF
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:20 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so494315qkl.9
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lwL3WMeevdHjxtB6KbtK7vO+5d7emdE2VE60dSqlYBQ=;
        b=JAcnAW4UvmxzgriKy71j0vAcq7ss/731SVZEwz/wYxIlvqWyvnPI0yCNLH6TeirjrG
         fFuAE7zK0R0WvneJzmW9n6bhfds1bwSTuTRKptBYovw58kFr8TQ2XyFCRB5onWGuhcGE
         1VJTuUIqC7Adqaj1DERR2MIBkL+ZG2VLyCzNzCR+q+g2gttNllzC3sRKFxxcCz5i247F
         w/Q0QacMkiAvn70KAv9MLJTRNavQjFyH6aQw+ka8GDaVwi4DmEnrOPk3agnZuYhEE8x5
         A9KNiqVdwLOoSaX2oI2p2K/kTE3EGYslHhM/SttB7JiGhYLXP7CBr+IrlksGmrz+/d8H
         lMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lwL3WMeevdHjxtB6KbtK7vO+5d7emdE2VE60dSqlYBQ=;
        b=pn6VFa4zHJTH8zjFOora7tR2bzEV7IiZHbmzvfxERpowBnH8MYnKxVrt4e0l+Bv+VA
         AiC7EUrmAn7CXR9KejIeUEVjvcyXhUia5y0gXOeBrmvCc5UYF2zoYLzbeXiK2uAi8Tru
         wC3DNGIVFYqjtSFmztvElnA3O/DO0tkeGm18tC70/EBJGFTtxzqX0jRCg/sXV8Nnq+0D
         TCnQiTwSMf+OGDIMN10QuBqbiD2vvRcJV6I4K1CLtWhHyiWkDwwYwH8r4HLyqYiIpsyr
         dXQaeYDrNa/r92pLp9F9lDe4OcSDAPmEB1AtVEkschQ5vqNYyB2cr9RQTR3ggaPCh719
         aOew==
X-Gm-Message-State: AOAM533zoey8pzb3KaEMSv9gnuNpiQ0oOiidn+ixNqEXPJ4eUUpMCF66
        qakgtdmT3T3MUPAjIb45Bk2/Xzd8QCyMPIIFYlvkatG1ulGGKE0cy53qL7/gHd51Iq+DYDe67dp
        FqLNhUCJCAXwMECU23lCKlnL6Je2IfgHvUtQoo84i2R1VfrcomDsOgq0BEDuVX8i1j7Ci
X-Google-Smtp-Source: ABdhPJxJIywvwXxBsTWHulkbOO2gxAaC3RZ80zJHrb9RT9DWJy3RWJF3Ldd4QbV/WmaT4nZp4Z7/cxKZJHDLdIap
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a05:6214:5012:: with SMTP id
 jo18mr6084743qvb.31.1629245359609; Tue, 17 Aug 2021 17:09:19 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:52 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-4-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 03/16] x86 UEFI: Move setjmp.h out of desc.h
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previous desc.h includes setjmp.h, and this causes duplicate definition
when compiling with UEFI header efi.h. This is because setjmp() function
is defined both in KVM-Unit-Tests and UEFI. When including both desc.h
and efi.h, the setjmp() is found in both headers and causes this error.

The easy solution is to move setjmp.h from desc.h to desc.c, so
including desc.h does not bring in setjmp.h, so that we can include
both desc.h and efi.h in lib/x86/setup.c.

This commit also includes setjmp.h in x86/vmx.c, because this test case
previously assumed setjmp.h is included by desc.h and did not include
setjmp.h explicitly.

This commit does not change any test case behavior.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/desc.c | 4 ++++
 lib/x86/desc.h | 5 -----
 x86/vmx.c      | 1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..eb4d2bc 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -3,6 +3,10 @@
 #include "processor.h"
 #include <setjmp.h>
 
+void __set_exception_jmpbuf(jmp_buf *addr);
+#define set_exception_jmpbuf(jmpbuf) \
+	(setjmp(jmpbuf) ? : (__set_exception_jmpbuf(&(jmpbuf)), 0))
+
 #ifndef __x86_64__
 __attribute__((regparm(1)))
 #endif
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a6ffb38..9fda20d 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -1,8 +1,6 @@
 #ifndef _X86_DESC_H_
 #define _X86_DESC_H_
 
-#include <setjmp.h>
-
 void setup_idt(void);
 void setup_alt_stack(void);
 
@@ -226,9 +224,6 @@ void unhandled_exception(struct ex_regs *regs, bool cpu);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
-void __set_exception_jmpbuf(jmp_buf *addr);
-#define set_exception_jmpbuf(jmpbuf) \
-	(setjmp(jmpbuf) ? : (__set_exception_jmpbuf(&(jmpbuf)), 0))
 
 static inline void *get_idt_addr(idt_entry_t *entry)
 {
diff --git a/x86/vmx.c b/x86/vmx.c
index f0b853a..4469b31 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -38,6 +38,7 @@
 #include "msr.h"
 #include "smp.h"
 #include "apic.h"
+#include "setjmp.h"
 
 u64 *bsp_vmxon_region;
 struct vmcs *vmcs_root;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

