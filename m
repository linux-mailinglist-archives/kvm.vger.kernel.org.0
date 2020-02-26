Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09D17093E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgBZUNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:12 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:54895 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:11 -0500
Received: by mail-pj1-f73.google.com with SMTP id a31so137648pje.4
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P0e2ipiL6n+VrTnPl5Byp+QGQep34dwDl9B8PERVjfw=;
        b=TioLfC1MhQGyEFcxspDYuSYLf+ArzkJHbrBRXHn7lXIRFjknUBtVosQ934e9h63WLF
         GEwRoDsu66F81+O4yvVsQLFZuOpYJladYzq8sVNHCY5wMqspnsrfsY44noYPgxAImjRT
         UBi59e1DIHB5PA7/0x23HEuvtWm78v3TFduLJfnqddBXPP8GmusxxH6F+t4NiS7RQevR
         jj39f5L6eYygcESz2voreMZDmeE/spW2f2h6Wh2ZznDvmbcYc7xCVNMyIy7Jy/A/cNVi
         gQFSJ1hn5vZR5df3HxOu5m3FfQ4nvEnVF/HWW3f/AaDbQcNBBLxyPd2ZJaaK2lCq6+RC
         mCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P0e2ipiL6n+VrTnPl5Byp+QGQep34dwDl9B8PERVjfw=;
        b=IIfjximF3Eu/D0CPEv9Q1+TkkQ11o7qXKYeqH9DREB6VJGZv121iSjD5ImNT78LhMV
         ykvZMsf6r43smg6I81d0cg+cQBt26B3z/zJdUdt6s+6gYPXDx1P8oMCg+XncDxDXAoYM
         SvpcdYyKM4DLMQAkTFIJu1ubL1stSKrpBbx9YTEjx2ONuLKEMg0NWXrDzoc4xscws6ek
         nT8bp2YZIgOFGOOAI3YAtqRb0DEf/C0iyzL5kn1DZSP2neS+GTonAebaJg0TXhEc/UlB
         q5LqWbxWrQbyhllxuQANt7Dxe6dK4ojKlssrta3yub+m9gJA3VUXF2+cJx4uwBWIn2a9
         uvbg==
X-Gm-Message-State: APjAAAUzTKXKWvyYD65oBVQ0PIG+rB07+4VmOo/tEklGRJ7X6a2vxLkK
        FD5+JcrcVxabSypQssibIG1roIw8qjryrZsoREt/Gj/o27iMIbOscrpXpr0kA4GjeOBYo6fMiPS
        5+r2esjOIWLWveIVAfEPCrwl0JLxZ652IwHJJ1172aQxtk+Xf5BkEJA==
X-Google-Smtp-Source: APXvYqy1BLT3SljsAvplIDvETxsC26mvbI1joOdR0I51FFJfjPZFg+X9baD5/Q+DW3uw85t7DgY/9HKFEw==
X-Received: by 2002:a63:f10c:: with SMTP id f12mr541826pgi.386.1582747990141;
 Wed, 26 Feb 2020 12:13:10 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:39 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-4-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 3/7] x86: realmode: syscall: add explicit
 size suffix to ambiguous instructions
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang requires explicit size suffixes for potentially ambiguous
instructions:

x86/realmode.c:1647:2: error: ambiguous instructions require an explicit suffix (could be 'cmpb', 'cmpw', or 'cmpl')
        MK_INSN_PERF(perf_memory_load, "cmp $0, (%edi)");
        ^
x86/realmode.c:1591:10: note: expanded from macro 'MK_INSN_PERF'
                      "1:" insn "\n"                            \
                       ^
<inline asm>:8:3: note: instantiated into assembly here
1:cmp $0, (%edi)
  ^

The 'w' and 'l' suffixes generate code that's identical to the gcc
version without them.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/realmode.c | 6 +++---
 x86/syscall.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index f5967ef..31f84d0 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1644,7 +1644,7 @@ static void test_perf_memory_load(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_load, "cmp $0, (%edi)");
+	MK_INSN_PERF(perf_memory_load, "cmpw $0, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
@@ -1657,7 +1657,7 @@ static void test_perf_memory_store(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_store, "mov %ax, (%edi)");
+	MK_INSN_PERF(perf_memory_store, "movw %ax, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
@@ -1670,7 +1670,7 @@ static void test_perf_memory_rmw(void)
 {
 	u32 cyc, tmp;
 
-	MK_INSN_PERF(perf_memory_rmw, "add $1, (%edi)");
+	MK_INSN_PERF(perf_memory_rmw, "addw $1, (%edi)");
 
 	init_inregs(&(struct regs){ .edi = (u32)&tmp });
 
diff --git a/x86/syscall.c b/x86/syscall.c
index b4f5ac0..b7e29d6 100644
--- a/x86/syscall.c
+++ b/x86/syscall.c
@@ -38,7 +38,7 @@ static void handle_db(struct ex_regs *regs)
 
 /* expects desired ring 3 flags in rax */
 asm("syscall32_target:\n"
-    "   cmp $0, code_segment_upon_db(%rip)\n"
+    "   cmpl $0, code_segment_upon_db(%rip)\n"
     "   jne back_to_test\n"
     "   mov %eax,%r11d\n"
     "   sysretl\n");
-- 
2.25.1.481.gfbce0eb801-goog

