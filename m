Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C135A19E9
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243291AbiHYUAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbiHYT75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:59:57 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7352DFA0
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e9-20020aa78249000000b00537a62a6175so852528pfn.20
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=WCanU/WvurWlCk0haGu24nPC8b5BSQpGv4G8wUSLb0E=;
        b=Mcd107OosjddvTS4i09OTt7HigFVU4ChHjtjQqF+Mw142rTNj/m0uGOABhXLmODlB4
         y7eVAF5lbMIi45AvMEBp2Fo1R2oyJJIwUQJFP96txW8hunvU/IBsyHo3qcO4c/sQ6Ld4
         gHMqyQ6HezTuiiHCw6gO16YOsvT/mvAQUwYPF7hGb2KxGTpuiUsp2Lc8JE64ytc8T2J3
         o/7iCMt/Wll6kqIE+hfHQxeEz4dyR5L2PQdxx1ebtOhRLgoSiKHBCGwkBEtc6inu/nft
         WmSzosA2cxqLYrBKsy+3HfWyIuzdMmXLwqPVVKU4HUbyIv+4jh8KgSdxUhIbFS4payJN
         JOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=WCanU/WvurWlCk0haGu24nPC8b5BSQpGv4G8wUSLb0E=;
        b=3YWiFX7cZ9PP7pSztfX3ABzWmswdMPyGXY+8WiEa2TQui2L799Vud/jSsin8RiiNbO
         fXotCEjOdM08amD2jdJlcO6FNktxeMT6ocjd+VNASkQ3Wc10O9Fy8bEZgW8T1qKbY+3e
         y+UB2MpmE71qW+k73VKInwfOE2nn+IBlk3pi/mm+Qjtf6lzXXbDuBFl2mEbTQl4FPSP3
         ZphhlmCUCt9u/7D5smkiOhCN9nEcZ/xZH4C4EMkDeUiZ6e9xDnWsbTTXVOuKI9ilbBdE
         0vJWJdORyw1sXrXJucHfReJWDRXFsJoL2SU4ZHI6sx3R3VvICV6fIQiRozZ5cRL2Hkxm
         2LUQ==
X-Gm-Message-State: ACgBeo1tgUGFIn1uUBIMaGbYHjqLRxcGxvgajlhb+cccPeVhFxfgeYvo
        pEA5x4nlT66i9xmxttvts2COb/VDgbs=
X-Google-Smtp-Source: AA6agR45kDIkdI6X9IQHDcjiebTB62mSsgtOm+ORuQ2MhwaZxC4EL98S1bcmnnKOv24AydVColMLXUxR5Cs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e7c2:b0:1f5:85ab:938c with SMTP id
 kb2-20020a17090ae7c200b001f585ab938cmr732119pjb.133.1661457591417; Thu, 25
 Aug 2022 12:59:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Aug 2022 19:59:39 +0000
In-Reply-To: <20220825195939.3959292-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825195939.3959292-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825195939.3959292-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 5/5] x86/emulator: Convert remaining spaces
 to tabs (indentation)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the remaining instances of bad indentation in the emulator test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 238 ++++++++++++++++++++++++-------------------------
 1 file changed, 118 insertions(+), 120 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index a92fc19..ad94374 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -176,44 +176,44 @@ static void test_scas(void *mem)
 
 static void test_incdecnotneg(void *mem)
 {
-    unsigned long *m = mem, v = 1234;
-    unsigned char *mb = mem, vb = 66;
+	unsigned long *m = mem, v = 1234;
+	unsigned char *mb = mem, vb = 66;
 
-    *m = 0;
+	*m = 0;
 
-    asm volatile ("incl %0":"+m"(*m));
-    report(*m == 1, "incl");
-    asm volatile ("decl %0":"+m"(*m));
-    report(*m == 0, "decl");
-    asm volatile ("incb %0":"+m"(*m));
-    report(*m == 1, "incb");
-    asm volatile ("decb %0":"+m"(*m));
-    report(*m == 0, "decb");
+	asm volatile ("incl %0":"+m"(*m));
+	report(*m == 1, "incl");
+	asm volatile ("decl %0":"+m"(*m));
+	report(*m == 0, "decl");
+	asm volatile ("incb %0":"+m"(*m));
+	report(*m == 1, "incb");
+	asm volatile ("decb %0":"+m"(*m));
+	report(*m == 0, "decb");
 
-    asm volatile ("lock incl %0":"+m"(*m));
-    report(*m == 1, "lock incl");
-    asm volatile ("lock decl %0":"+m"(*m));
-    report(*m == 0, "lock decl");
-    asm volatile ("lock incb %0":"+m"(*m));
-    report(*m == 1, "lock incb");
-    asm volatile ("lock decb %0":"+m"(*m));
-    report(*m == 0, "lock decb");
+	asm volatile ("lock incl %0":"+m"(*m));
+	report(*m == 1, "lock incl");
+	asm volatile ("lock decl %0":"+m"(*m));
+	report(*m == 0, "lock decl");
+	asm volatile ("lock incb %0":"+m"(*m));
+	report(*m == 1, "lock incb");
+	asm volatile ("lock decb %0":"+m"(*m));
+	report(*m == 0, "lock decb");
 
-    *m = v;
+	*m = v;
 
 #ifdef __x86_64__
-    asm ("lock negq %0" : "+m"(*m)); v = -v;
-    report(*m == v, "lock negl");
-    asm ("lock notq %0" : "+m"(*m)); v = ~v;
-    report(*m == v, "lock notl");
+	asm ("lock negq %0" : "+m"(*m)); v = -v;
+	report(*m == v, "lock negl");
+	asm ("lock notq %0" : "+m"(*m)); v = ~v;
+	report(*m == v, "lock notl");
 #endif
 
-    *mb = vb;
+	*mb = vb;
 
-    asm ("lock negb %0" : "+m"(*mb)); vb = -vb;
-    report(*mb == vb, "lock negb");
-    asm ("lock notb %0" : "+m"(*mb)); vb = ~vb;
-    report(*mb == vb, "lock notb");
+	asm ("lock negb %0" : "+m"(*mb)); vb = -vb;
+	report(*mb == vb, "lock negb");
+	asm ("lock notb %0" : "+m"(*mb)); vb = ~vb;
+	report(*mb == vb, "lock notb");
 }
 
 static void test_smsw(unsigned long *h_mem)
@@ -387,14 +387,13 @@ typedef unsigned __attribute__((vector_size(16))) sse128;
 
 static bool sseeq(uint32_t *v1, uint32_t *v2)
 {
-    bool ok = true;
-    int i;
+	bool ok = true;
+	int i;
 
-    for (i = 0; i < 4; ++i) {
-	ok &= v1[i] == v2[i];
-    }
+	for (i = 0; i < 4; ++i)
+		ok &= v1[i] == v2[i];
 
-    return ok;
+	return ok;
 }
 
 static __attribute__((target("sse2"))) void test_sse(uint32_t *mem)
@@ -497,12 +496,12 @@ static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
 
 static void test_shld_shrd(u32 *mem)
 {
-    *mem = 0x12345678;
-    asm("shld %2, %1, %0" : "+m"(*mem) : "r"(0xaaaaaaaaU), "c"((u8)3));
-    report(*mem == ((0x12345678 << 3) | 5), "shld (cl)");
-    *mem = 0x12345678;
-    asm("shrd %2, %1, %0" : "+m"(*mem) : "r"(0x55555555U), "c"((u8)3));
-    report(*mem == ((0x12345678 >> 3) | (5u << 29)), "shrd (cl)");
+	*mem = 0x12345678;
+	asm("shld %2, %1, %0" : "+m"(*mem) : "r"(0xaaaaaaaaU), "c"((u8)3));
+	report(*mem == ((0x12345678 << 3) | 5), "shld (cl)");
+	*mem = 0x12345678;
+	asm("shrd %2, %1, %0" : "+m"(*mem) : "r"(0x55555555U), "c"((u8)3));
+	report(*mem == ((0x12345678 >> 3) | (5u << 29)), "shrd (cl)");
 }
 
 static void test_smsw_reg(uint64_t *mem)
@@ -561,15 +560,15 @@ static void test_illegal_lea(void)
 
 static void test_crosspage_mmio(volatile uint8_t *mem)
 {
-    volatile uint16_t w, *pw;
+	volatile uint16_t w, *pw;
 
-    pw = (volatile uint16_t *)&mem[4095];
-    mem[4095] = 0x99;
-    mem[4096] = 0x77;
-    asm volatile("mov %1, %0" : "=r"(w) : "m"(*pw) : "memory");
-    report(w == 0x7799, "cross-page mmio read");
-    asm volatile("mov %1, %0" : "=m"(*pw) : "r"((uint16_t)0x88aa));
-    report(mem[4095] == 0xaa && mem[4096] == 0x88, "cross-page mmio write");
+	pw = (volatile uint16_t *)&mem[4095];
+	mem[4095] = 0x99;
+	mem[4096] = 0x77;
+	asm volatile("mov %1, %0" : "=r"(w) : "m"(*pw) : "memory");
+	report(w == 0x7799, "cross-page mmio read");
+	asm volatile("mov %1, %0" : "=m"(*pw) : "r"((uint16_t)0x88aa));
+	report(mem[4095] == 0xaa && mem[4096] == 0x88, "cross-page mmio write");
 }
 
 static void test_string_io_mmio(volatile uint8_t *mem)
@@ -588,33 +587,31 @@ static void test_string_io_mmio(volatile uint8_t *mem)
 #if 0
 static void test_lgdt_lidt(volatile uint8_t *mem)
 {
-    struct descriptor_table_ptr orig, fresh = {};
+	struct descriptor_table_ptr orig, fresh = {};
 
-    sgdt(&orig);
-    *(struct descriptor_table_ptr *)mem = (struct descriptor_table_ptr) {
-	.limit = 0xf234,
-	.base = 0x12345678abcd,
-    };
-    cli();
-    asm volatile("lgdt %0" : : "m"(*(struct descriptor_table_ptr *)mem));
-    sgdt(&fresh);
-    lgdt(&orig);
-    sti();
-    report(orig.limit == fresh.limit && orig.base == fresh.base,
-           "lgdt (long address)");
+	sgdt(&orig);
+	*(struct descriptor_table_ptr *)mem = (struct descriptor_table_ptr) {
+		.limit = 0xf234,
+		.base = 0x12345678abcd,
+	};
+	cli();
+	asm volatile("lgdt %0" : : "m"(*(struct descriptor_table_ptr *)mem));
+	sgdt(&fresh);
+	lgdt(&orig);
+	sti();
+	report(orig.limit == fresh.limit && orig.base == fresh.base, "lgdt (long address)");
 
-    sidt(&orig);
-    *(struct descriptor_table_ptr *)mem = (struct descriptor_table_ptr) {
-	.limit = 0x432f,
-	.base = 0xdbca87654321,
-    };
-    cli();
-    asm volatile("lidt %0" : : "m"(*(struct descriptor_table_ptr *)mem));
-    sidt(&fresh);
-    lidt(&orig);
-    sti();
-    report(orig.limit == fresh.limit && orig.base == fresh.base,
-           "lidt (long address)");
+	sidt(&orig);
+	*(struct descriptor_table_ptr *)mem = (struct descriptor_table_ptr) {
+		.limit = 0x432f,
+		.base = 0xdbca87654321,
+	};
+	cli();
+	asm volatile("lidt %0" : : "m"(*(struct descriptor_table_ptr *)mem));
+	sidt(&fresh);
+	lidt(&orig);
+	sti();
+	report(orig.limit == fresh.limit && orig.base == fresh.base, "lidt (long address)");
 }
 #endif
 
@@ -622,40 +619,41 @@ static void test_lgdt_lidt(volatile uint8_t *mem)
 #if 0
 static void test_lldt(volatile uint16_t *mem)
 {
-    u64 gdt[] = { 0, /* null descriptor */
+	u64 gdt[] = { 0, /* null descriptor */
 #ifdef __X86_64__
-		  0, /* ldt descriptor is 16 bytes in long mode */
+		0, /* ldt descriptor is 16 bytes in long mode */
 #endif
-		  0x0000f82000000ffffull /* ldt descriptor */ };
-    struct descriptor_table_ptr gdt_ptr = { .limit = sizeof(gdt) - 1,
-					    .base = (ulong)&gdt };
-    struct descriptor_table_ptr orig_gdt;
+		0x0000f82000000ffffull /* ldt descriptor */
+	};
+	struct descriptor_table_ptr gdt_ptr = { .limit = sizeof(gdt) - 1,
+						.base = (ulong)&gdt };
+	struct descriptor_table_ptr orig_gdt;
 
-    cli();
-    sgdt(&orig_gdt);
-    lgdt(&gdt_ptr);
-    *mem = 0x8;
-    asm volatile("lldt %0" : : "m"(*mem));
-    lgdt(&orig_gdt);
-    sti();
-    report(sldt() == *mem, "lldt");
+	cli();
+	sgdt(&orig_gdt);
+	lgdt(&gdt_ptr);
+	*mem = 0x8;
+	asm volatile("lldt %0" : : "m"(*mem));
+	lgdt(&orig_gdt);
+	sti();
+	report(sldt() == *mem, "lldt");
 }
 #endif
 
 static void test_ltr(volatile uint16_t *mem)
 {
-    struct descriptor_table_ptr gdt_ptr;
-    uint64_t *gdt, *trp;
-    uint16_t tr = str();
-    uint64_t busy_mask = (uint64_t)1 << 41;
+	struct descriptor_table_ptr gdt_ptr;
+	uint64_t *gdt, *trp;
+	uint16_t tr = str();
+	uint64_t busy_mask = (uint64_t)1 << 41;
 
-    sgdt(&gdt_ptr);
-    gdt = (uint64_t *)gdt_ptr.base;
-    trp = &gdt[tr >> 3];
-    *trp &= ~busy_mask;
-    *mem = tr;
-    asm volatile("ltr %0" : : "m"(*mem) : "memory");
-    report(str() == tr && (*trp & busy_mask), "ltr");
+	sgdt(&gdt_ptr);
+	gdt = (uint64_t *)gdt_ptr.base;
+	trp = &gdt[tr >> 3];
+	*trp &= ~busy_mask;
+	*mem = tr;
+	asm volatile("ltr %0" : : "m"(*mem) : "memory");
+	report(str() == tr && (*trp & busy_mask), "ltr");
 }
 
 static void test_mov(void *mem)
@@ -674,27 +672,27 @@ static void test_mov(void *mem)
 
 static void test_simplealu(u32 *mem)
 {
-    *mem = 0x1234;
-    asm("or %1, %0" : "+m"(*mem) : "r"(0x8001));
-    report(*mem == 0x9235, "or");
-    asm("add %1, %0" : "+m"(*mem) : "r"(2));
-    report(*mem == 0x9237, "add");
-    asm("xor %1, %0" : "+m"(*mem) : "r"(0x1111));
-    report(*mem == 0x8326, "xor");
-    asm("sub %1, %0" : "+m"(*mem) : "r"(0x26));
-    report(*mem == 0x8300, "sub");
-    asm("clc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
-    report(*mem == 0x8400, "adc(0)");
-    asm("stc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
-    report(*mem == 0x8501, "adc(0)");
-    asm("clc; sbb %1, %0" : "+m"(*mem) : "r"(0));
-    report(*mem == 0x8501, "sbb(0)");
-    asm("stc; sbb %1, %0" : "+m"(*mem) : "r"(0));
-    report(*mem == 0x8500, "sbb(1)");
-    asm("and %1, %0" : "+m"(*mem) : "r"(0xfe77));
-    report(*mem == 0x8400, "and");
-    asm("test %1, %0" : "+m"(*mem) : "r"(0xf000));
-    report(*mem == 0x8400, "test");
+	*mem = 0x1234;
+	asm("or %1, %0" : "+m"(*mem) : "r"(0x8001));
+	report(*mem == 0x9235, "or");
+	asm("add %1, %0" : "+m"(*mem) : "r"(2));
+	report(*mem == 0x9237, "add");
+	asm("xor %1, %0" : "+m"(*mem) : "r"(0x1111));
+	report(*mem == 0x8326, "xor");
+	asm("sub %1, %0" : "+m"(*mem) : "r"(0x26));
+	report(*mem == 0x8300, "sub");
+	asm("clc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
+	report(*mem == 0x8400, "adc(0)");
+	asm("stc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
+	report(*mem == 0x8501, "adc(0)");
+	asm("clc; sbb %1, %0" : "+m"(*mem) : "r"(0));
+	report(*mem == 0x8501, "sbb(0)");
+	asm("stc; sbb %1, %0" : "+m"(*mem) : "r"(0));
+	report(*mem == 0x8500, "sbb(1)");
+	asm("and %1, %0" : "+m"(*mem) : "r"(0xfe77));
+	report(*mem == 0x8400, "and");
+	asm("test %1, %0" : "+m"(*mem) : "r"(0xf000));
+	report(*mem == 0x8400, "test");
 }
 
 static void test_illegal_movbe(void)
-- 
2.37.2.672.g94769d06f0-goog

