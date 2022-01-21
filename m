Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A90749682A
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 00:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiAUXTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 18:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiAUXTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 18:19:03 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496E6C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:03 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020aa7918b000000b004bd70cde509so6806820pfa.9
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 15:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gAiYTlDomFLhaAbXuzA8ZYvN5J2ZcjhlHOIQldpQdgc=;
        b=Og4Ep44yuXN9d66fJdhvAg1nF7Zj8m3uZPOQKZ4r7SCWqoDqBNDt1oOKxtxEGPIrhO
         XUeI4xdvI07blXnRn7GT8ihCo//pjEkrVbZMr/E0Byz5JkOzkmYn2FglkXt1ofIxCToH
         8hdjb5rKKG0UrvCDLR0z1z8zmGEAbKWFL5u3iOgjNVUpZEIzUcoVUKdIYMyAcmcxsHaX
         UW5XLXsz7frDO1V77toQRPJ73qh3OF1OG15XiYxXVZYWTlIVFxIZa04BzePQzQjOx4MT
         1MUbf6cfzNFgrVb9WiD6GvMGXpp0/6davryMzXok8r9JEb5D9VIUPTSbAvp76nerNOS4
         KxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gAiYTlDomFLhaAbXuzA8ZYvN5J2ZcjhlHOIQldpQdgc=;
        b=zBEgrLpo1EYT8NIAvsHMJMKILyrXSWUvYcVtcacFuv+NwD4QGThaBgFUBSTWcebRHW
         wnicU9EV0Dj6ZhnIlgJlRzs1tt7ejNJ4WmMsgo1sGX3rI9u01g5gHe43t0JtR+N7ZUfH
         2r7s7AVjjzKjWi+tVMAxDdECqk3u8RxKnfsEmrumYvL3nrpaw4ThUr/mcSXOdlmvC8rU
         jFfggKCH42HfFjIyfbNGlVwooqLhf8acOvHOXksAz1hiHcrnzMOqXAunEn3VKY6/sWiq
         v9WZMJ5MHwt8XxnQbNdsZ3VOiaViyyd3D5RsmfDJbk1YkiwD7py1OZbOKSJeXeKN63yz
         FjIA==
X-Gm-Message-State: AOAM532Airzsgv1jsvRjtm82OlOS7+5JGFBptokNrVGu1M1u0sOE/8eq
        7z8y6egTgv9lPs6IoAvOZiz7kgYWUXQ=
X-Google-Smtp-Source: ABdhPJyeTjPeGuE0moS5ZpAMqO5AYy0YltiUbBUfXcTvsRfCUT//E3YISSM7FqX0iVI8mAqhAi70SR0o1aA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7e82:b0:149:9714:699e with SMTP id
 z2-20020a1709027e8200b001499714699emr5907598pla.66.1642807142820; Fri, 21 Jan
 2022 15:19:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jan 2022 23:18:48 +0000
In-Reply-To: <20220121231852.1439917-1-seanjc@google.com>
Message-Id: <20220121231852.1439917-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220121231852.1439917-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH 4/8] x86: desc: Replace spaces with tabs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace spaces with tabs in smp.c, and opportunistically clean up a
handful of minor coding style violations.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c | 121 +++++++++++++++++++++++++------------------------
 lib/x86/desc.h |  68 +++++++++++++--------------
 2 files changed, 95 insertions(+), 94 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b72562..25c5ac55 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -58,35 +58,35 @@ void do_handle_exception(struct ex_regs *regs);
 
 void set_idt_entry(int vec, void *addr, int dpl)
 {
-    idt_entry_t *e = &boot_idt[vec];
-    memset(e, 0, sizeof *e);
-    e->offset0 = (unsigned long)addr;
-    e->selector = read_cs();
-    e->ist = 0;
-    e->type = 14;
-    e->dpl = dpl;
-    e->p = 1;
-    e->offset1 = (unsigned long)addr >> 16;
+	idt_entry_t *e = &boot_idt[vec];
+	memset(e, 0, sizeof *e);
+	e->offset0 = (unsigned long)addr;
+	e->selector = read_cs();
+	e->ist = 0;
+	e->type = 14;
+	e->dpl = dpl;
+	e->p = 1;
+	e->offset1 = (unsigned long)addr >> 16;
 #ifdef __x86_64__
-    e->offset2 = (unsigned long)addr >> 32;
+	e->offset2 = (unsigned long)addr >> 32;
 #endif
 }
 
 void set_idt_dpl(int vec, u16 dpl)
 {
-    idt_entry_t *e = &boot_idt[vec];
-    e->dpl = dpl;
+	idt_entry_t *e = &boot_idt[vec];
+	e->dpl = dpl;
 }
 
 void set_idt_sel(int vec, u16 sel)
 {
-    idt_entry_t *e = &boot_idt[vec];
-    e->selector = sel;
+	idt_entry_t *e = &boot_idt[vec];
+	e->selector = sel;
 }
 
 struct ex_record {
-    unsigned long rip;
-    unsigned long handler;
+	unsigned long rip;
+	unsigned long handler;
 };
 
 extern struct ex_record exception_table_start, exception_table_end;
@@ -154,20 +154,20 @@ void unhandled_exception(struct ex_regs *regs, bool cpu)
 
 static void check_exception_table(struct ex_regs *regs)
 {
-    struct ex_record *ex;
-    unsigned ex_val;
+	struct ex_record *ex;
+	unsigned ex_val;
 
-    ex_val = regs->vector | (regs->error_code << 16) |
+	ex_val = regs->vector | (regs->error_code << 16) |
 		(((regs->rflags >> 16) & 1) << 8);
-    asm("mov %0, %%gs:4" : : "r"(ex_val));
+	asm("mov %0, %%gs:4" : : "r"(ex_val));
 
-    for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
-        if (ex->rip == regs->rip) {
-            regs->rip = ex->handler;
-            return;
-        }
-    }
-    unhandled_exception(regs, false);
+	for (ex = &exception_table_start; ex != &exception_table_end; ++ex) {
+		if (ex->rip == regs->rip) {
+			regs->rip = ex->handler;
+			return;
+		}
+	}
+	unhandled_exception(regs, false);
 }
 
 static handler exception_handlers[32];
@@ -278,51 +278,52 @@ static void *idt_handlers[32] = {
 
 void setup_idt(void)
 {
-    int i;
-    static bool idt_initialized = false;
+	int i;
+	static bool idt_initialized = false;
 
-    if (idt_initialized) {
-        return;
-    }
-    idt_initialized = true;
-    for (i = 0; i < 32; i++)
-	    if (idt_handlers[i])
-		    set_idt_entry(i, idt_handlers[i], 0);
-    handle_exception(0, check_exception_table);
-    handle_exception(6, check_exception_table);
-    handle_exception(13, check_exception_table);
+	if (idt_initialized)
+		return;
+
+	idt_initialized = true;
+	for (i = 0; i < 32; i++) {
+		if (idt_handlers[i])
+			set_idt_entry(i, idt_handlers[i], 0);
+	}
+	handle_exception(0, check_exception_table);
+	handle_exception(6, check_exception_table);
+	handle_exception(13, check_exception_table);
 }
 
 unsigned exception_vector(void)
 {
-    unsigned char vector;
+	unsigned char vector;
 
-    asm volatile("movb %%gs:4, %0" : "=q"(vector));
-    return vector;
+	asm volatile("movb %%gs:4, %0" : "=q"(vector));
+	return vector;
 }
 
 int write_cr4_checking(unsigned long val)
 {
-    asm volatile(ASM_TRY("1f")
-            "mov %0,%%cr4\n\t"
-            "1:": : "r" (val));
-    return exception_vector();
+	asm volatile(ASM_TRY("1f")
+		"mov %0,%%cr4\n\t"
+		"1:": : "r" (val));
+	return exception_vector();
 }
 
 unsigned exception_error_code(void)
 {
-    unsigned short error_code;
+	unsigned short error_code;
 
-    asm volatile("mov %%gs:6, %0" : "=r"(error_code));
-    return error_code;
+	asm volatile("mov %%gs:6, %0" : "=r"(error_code));
+	return error_code;
 }
 
 bool exception_rflags_rf(void)
 {
-    unsigned char rf_flag;
+	unsigned char rf_flag;
 
-    asm volatile("movb %%gs:5, %b0" : "=q"(rf_flag));
-    return rf_flag & 1;
+	asm volatile("movb %%gs:5, %b0" : "=q"(rf_flag));
+	return rf_flag & 1;
 }
 
 static char intr_alt_stack[4096];
@@ -352,20 +353,20 @@ void set_gdt_entry(int sel, unsigned long base,  u32 limit, u8 type, u8 flags)
 #ifndef __x86_64__
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
 {
-    set_gdt_entry(sel, tss_sel, 0, 0x85, 0); // task, present
+	set_gdt_entry(sel, tss_sel, 0, 0x85, 0); // task, present
 }
 
 void set_idt_task_gate(int vec, u16 sel)
 {
-    idt_entry_t *e = &boot_idt[vec];
+	idt_entry_t *e = &boot_idt[vec];
 
-    memset(e, 0, sizeof *e);
+	memset(e, 0, sizeof *e);
 
-    e->selector = sel;
-    e->ist = 0;
-    e->type = 5;
-    e->dpl = 0;
-    e->p = 1;
+	e->selector = sel;
+	e->ist = 0;
+	e->type = 5;
+	e->dpl = 0;
+	e->p = 1;
 }
 
 /*
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0c..2660300b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -7,20 +7,20 @@ void setup_idt(void);
 void setup_alt_stack(void);
 
 struct ex_regs {
-    unsigned long rax, rcx, rdx, rbx;
-    unsigned long dummy, rbp, rsi, rdi;
+	unsigned long rax, rcx, rdx, rbx;
+	unsigned long dummy, rbp, rsi, rdi;
 #ifdef __x86_64__
-    unsigned long r8, r9, r10, r11;
-    unsigned long r12, r13, r14, r15;
+	unsigned long r8, r9, r10, r11;
+	unsigned long r12, r13, r14, r15;
 #endif
-    unsigned long vector;
-    unsigned long error_code;
-    unsigned long rip;
-    unsigned long cs;
-    unsigned long rflags;
+	unsigned long vector;
+	unsigned long error_code;
+	unsigned long rip;
+	unsigned long cs;
+	unsigned long rflags;
 #ifdef __x86_64__
-    unsigned long rsp;
-    unsigned long ss;
+	unsigned long rsp;
+	unsigned long ss;
 #endif
 };
 
@@ -80,19 +80,19 @@ typedef struct  __attribute__((packed)) {
 } tss64_t;
 
 #ifdef __x86_64
-#define ASM_TRY(catch)                                  \
-    "movl $0, %%gs:4 \n\t"                              \
-    ".pushsection .data.ex \n\t"                        \
-    ".quad 1111f, " catch "\n\t"                        \
-    ".popsection \n\t"                                  \
-    "1111:"
+#define ASM_TRY(catch)			\
+	"movl $0, %%gs:4 \n\t"		\
+	".pushsection .data.ex \n\t"	\
+	".quad 1111f, " catch "\n\t"	\
+	".popsection \n\t"		\
+	"1111:"
 #else
-#define ASM_TRY(catch)                                  \
-    "movl $0, %%gs:4 \n\t"                              \
-    ".pushsection .data.ex \n\t"                        \
-    ".long 1111f, " catch "\n\t"                        \
-    ".popsection \n\t"                                  \
-    "1111:"
+#define ASM_TRY(catch)			\
+	"movl $0, %%gs:4 \n\t"		\
+	".pushsection .data.ex \n\t"	\
+	".long 1111f, " catch "\n\t"	\
+	".popsection \n\t"		\
+	"1111:"
 #endif
 
 /*
@@ -152,18 +152,18 @@ typedef struct  __attribute__((packed)) {
 #define TSS_MAIN 0x80
 
 typedef struct {
-    unsigned short offset0;
-    unsigned short selector;
-    unsigned short ist : 3;
-    unsigned short : 5;
-    unsigned short type : 4;
-    unsigned short : 1;
-    unsigned short dpl : 2;
-    unsigned short p : 1;
-    unsigned short offset1;
+	unsigned short offset0;
+	unsigned short selector;
+	unsigned short ist : 3;
+	unsigned short : 5;
+	unsigned short type : 4;
+	unsigned short : 1;
+	unsigned short dpl : 2;
+	unsigned short p : 1;
+	unsigned short offset1;
 #ifdef __x86_64__
-    unsigned offset2;
-    unsigned reserved;
+	unsigned offset2;
+	unsigned reserved;
 #endif
 } idt_entry_t;
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

