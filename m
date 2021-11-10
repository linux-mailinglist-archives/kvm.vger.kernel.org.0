Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34744CB3A
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhKJVXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhKJVXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:23:01 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7B8C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:13 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id i25-20020a631319000000b002cce0a43e94so2182415pgl.0
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OYAqhY2w+ME/rfsDBI9bkEdCt8BXorqX5vKVexmADCg=;
        b=fa50fXLugidGg7IlljrqB0sdclm3f3m2kL1FGfN27n1VK3E74cSUqxM+l7BkYgOf/G
         F3tAHpz89wUc5wv+DScw7uCs9Sp9hkK6p/24HAqrMaGh1jJfOoaR1Tl7fld1P2+VgyEZ
         8KPp1pPYPMYVDqdBhCLORlighj9eLcwHhTdNWmhO2U4YLDD3SseB9PGv6k4wUIwJBf3I
         WI9GYl+2ZCx//DHMo5N57yYkg3kK7oWnejjsxTw69kZJTLRnHLPmbfNBzfvHApABS66q
         ZhkqvDNuen6VaO+eLnO1QnBklH3TinVYgQ7A1NsQvhsY5n1sScTNVmhPfJMo6RCC4gaa
         qvrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OYAqhY2w+ME/rfsDBI9bkEdCt8BXorqX5vKVexmADCg=;
        b=PeNLFi2bYMjx82kXeXmx0c3GneP4LTlbogtKoBTWRr6KaW4DEB5EHJcSKkjcihtyG4
         lw359JkgSk6LbMT7dZYvWW9KSLvzE7ERJ9aloWcdfWoLHeBk+MDMfGo13ngzc6haWJrY
         s+gHR3bb/pnHRLrmRxxE9qntAmDZRQpsFOdGCq8SCLIzZsn9UXEaqoTawu0xIHGEFksD
         gMvXyW54n6hM15MQ7KqwOr7ZCrWEIdBN6vswAm7rzZM7uWCZvI/MZLeUT/AX5wtXN6nh
         010pg5Zb+Q0ei7J/6zvj4S3d1ujwO6hFf1MviAFRoqjeMJJu/e/UtpYAp24CUTxHigjp
         6IyA==
X-Gm-Message-State: AOAM530VAZJfmUtisk3BCLUYrLeF6WWo6/dxUhTNPeFlxJCeDy+/r1KZ
        URQzvEHSzGY9BaVwK6xl0B0zXoY8tjY0MGAP3XZtmo910CUUnG+DSJeUUvlkEXs1uiAU6ecXqmY
        jce+sMuYjBmvsUZCnT/jN6D8mGrOXB+KC8L9kbz8XV3oxXAzQcJq9IA+UxBc72PDopeRB
X-Google-Smtp-Source: ABdhPJxmqL3ZbwwKKf9Z65291K14EtBpzB7ej0Ido6BhPMlBNIrDEfmfTP+1BNWq7xECWpGJqzfD+V2NGFzsXLuu
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:e613:: with SMTP id
 j19mr2401973pjy.182.1636579212932; Wed, 10 Nov 2021 13:20:12 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:50 +0000
In-Reply-To: <20211110212001.3745914-1-aaronlewis@google.com>
Message-Id: <20211110212001.3745914-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20211110212001.3745914-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 03/14] unify field names and definitions for
 GDT descriptors
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the same names and definitions (apart from the high base field)
for GDT descriptors in both 32-bit and 64-bit code.  The next patch
will also reuse gdt_entry_t in the 16-byte struct definition, for now
some duplication remains.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c   | 18 +++++++-----------
 lib/x86/desc.h   | 28 +++++++++++++++++++++-------
 x86/taskswitch.c |  2 +-
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index b691c9b..ba0db65 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -280,22 +280,18 @@ bool exception_rflags_rf(void)
 static char intr_alt_stack[4096];
 
 #ifndef __x86_64__
-void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
+void set_gdt_entry(int sel, u32 base,  u32 limit, u8 type, u8 flags)
 {
 	int num = sel >> 3;
 
 	/* Setup the descriptor base address */
-	gdt32[num].base_low = (base & 0xFFFF);
-	gdt32[num].base_middle = (base >> 16) & 0xFF;
-	gdt32[num].base_high = (base >> 24) & 0xFF;
+	gdt32[num].base1 = (base & 0xFFFF);
+	gdt32[num].base2 = (base >> 16) & 0xFF;
+	gdt32[num].base3 = (base >> 24) & 0xFF;
 
-	/* Setup the descriptor limits */
-	gdt32[num].limit_low = (limit & 0xFFFF);
-	gdt32[num].granularity = ((limit >> 16) & 0x0F);
-
-	/* Finally, set up the granularity and access flags */
-	gdt32[num].granularity |= (gran & 0xF0);
-	gdt32[num].access = access;
+	/* Setup the descriptor limits, type and flags */
+	gdt32[num].limit1 = (limit & 0xFFFF);
+	gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((flags & 0xF0) << 8) | type;
 }
 
 void set_gdt_task_gate(u16 sel, u16 tss_sel)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 1755486..c339e0e 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -164,14 +164,27 @@ typedef struct {
 } idt_entry_t;
 
 typedef struct {
-	u16 limit_low;
-	u16 base_low;
-	u8 base_middle;
-	u8 access;
-	u8 granularity;
-	u8 base_high;
-} gdt_entry_t;
+	uint16_t limit1;
+	uint16_t base1;
+	uint8_t  base2;
+	union {
+		uint16_t  type_limit_flags;      /* Type and limit flags */
+		struct {
+			uint16_t type:4;
+			uint16_t s:1;
+			uint16_t dpl:2;
+			uint16_t p:1;
+			uint16_t limit2:4;
+			uint16_t avl:1;
+			uint16_t l:1;
+			uint16_t db:1;
+			uint16_t g:1;
+		} __attribute__((__packed__));
+	} __attribute__((__packed__));
+	uint8_t  base3;
+} __attribute__((__packed__)) gdt_entry_t;
 
+#ifdef __x86_64__
 struct system_desc64 {
 	uint16_t limit1;
 	uint16_t base1;
@@ -194,6 +207,7 @@ struct system_desc64 {
 	uint32_t base4;
 	uint32_t zero;
 } __attribute__((__packed__));
+#endif
 
 #define DESC_BUSY ((uint64_t) 1 << 41)
 
diff --git a/x86/taskswitch.c b/x86/taskswitch.c
index 889831e..b6b3451 100644
--- a/x86/taskswitch.c
+++ b/x86/taskswitch.c
@@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
 
 	tss.eip += 2;
 
-	gdt32[TSS_MAIN / 8].access &= ~2;
+	gdt32[TSS_MAIN / 8].type &= ~2;
 
 	set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

