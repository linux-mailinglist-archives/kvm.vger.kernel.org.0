Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB38B36759C
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343681AbhDUXNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 19:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244043AbhDUXNr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 19:13:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DEEC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 16:13:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e8-20020a2587480000b02904e5857564e2so17716242ybn.16
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 16:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uQidMMizh5NxKxSXlbJhlcp7tcm0hjWSy8HrT3lIpeE=;
        b=INJSifMcwnPsWZPNI/jT7ZAvRTZ/tfkmKOZn7uW3oGpNfvCLx22ybu2zkNQLgJIUzM
         Omk9eJyr8vyptqzA7/QKTM+HwwSvMbxYyKPsOnnuxmLUGic4hKQd9aoenkrfZAygzok/
         s9ycGjbi/yCd3yXGDcHPTp0Hj/fBqVfkNoX9J8L6P1H+ASpQqmKBnbGDXz95EMWSByK6
         X2XOIT6oNUrQR6TEnZdWJKogSoKgj4jfo4TwAuPx9m9Y7nxWFc00Kp8b+Tpw0kluD/Zy
         giPWtJJTqLgqokrCbBeRHbumVspqsHPBpEWTeohO8rdNx94mx6T2LscYOwymfzeFfNbx
         ktHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uQidMMizh5NxKxSXlbJhlcp7tcm0hjWSy8HrT3lIpeE=;
        b=pPhthyMkweArCla0SpjJQsgPjIIH49As2JRTZCbaDLOvAPa0onKPH2/iw/NYSo9OZA
         dDepQKZ8ZTDdwErdbiJF3yy/oqoTTezWXVeIP6IipxXE29QfrFyegyAiHzKeaD/9M8v7
         goKZ+LZNjInZRZsGGedRTSgRZXAfpRcRHpjihaya9bW2LCzTDBbOanvult44SMmS7SzG
         K1v9ZdBlLq4xC3znZtL1tflRhDiH+gPgdZKx+pTrgJ/IgoJMxdoQUMTOHHfaOeMKwRTp
         tOgvbF8KkYGoNZRiP95f3FIWlls44c3OLeYwnud9B+iGuDun2Y21pEeOCrZHQhPctL0v
         9/Kg==
X-Gm-Message-State: AOAM532vzZ/0seoCXu73oyddIkHlSPWHfTQj6WtinODkgMYz+LNdmoWA
        bte+N5sWcpAzzZxbRR5FVkRWTOoCjGWMCw==
X-Google-Smtp-Source: ABdhPJwp8QLbrOw45m8Hx7ZOEraS54lylwCoysIY9ItTeVzfCbg4V8NWALr5CSBa4sk1y24FlAE50HTh7PClnA==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:c919:a1bb:1eab:984c])
 (user=jacobhxu job=sendgmr) by 2002:a25:da4a:: with SMTP id
 n71mr525076ybf.351.1619046793271; Wed, 21 Apr 2021 16:13:13 -0700 (PDT)
Date:   Wed, 21 Apr 2021 16:12:58 -0700
In-Reply-To: <20210421231258.2583654-1-jacobhxu@google.com>
Message-Id: <20210421231258.2583654-2-jacobhxu@google.com>
Mime-Version: 1.0
References: <20210421231258.2583654-1-jacobhxu@google.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [kvm-unit-tests PATCH 2/2] x86: add additional test cases for sse
 exceptions to emulator.c
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add additional test cases for sse instructions for doing unaligned
accesses and accesses that cross page boundaries.

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 x86/emulator.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index ff3c2bf..9705073 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -686,6 +686,75 @@ static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 #undef TEST_RW_SSE
 }
 
+static void unaligned_movaps_handler(struct ex_regs *regs)
+{
+	extern char unaligned_movaps_cont;
+
+	++exceptions;
+	regs->rip = (ulong)&unaligned_movaps_cont;
+}
+
+static void cross_movups_handler(struct ex_regs *regs)
+{
+	extern char cross_movups_cont;
+
+	++exceptions;
+	regs->rip = (ulong)&cross_movups_cont;
+}
+
+static __attribute__((target("sse2"))) void test_sse_exceptions(void *cross_mem)
+{
+	sse_union v;
+	sse_union *mem;
+	uint8_t *bytes = cross_mem; // aligned on PAGE_SIZE*2
+	void *page2 = (void *)(&bytes[4096]);
+	struct pte_search search;
+	pteval_t orig_pte;
+
+	// setup memory for unaligned access
+	mem = (sse_union *)(&bytes[8]);
+
+	// test unaligned access for movups, movupd and movaps
+	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
+	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
+	report(sseeq(&v, mem), "movups unaligned");
+
+	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
+	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+	asm("movupd %1, %0" : "=m"(*mem) : "x"(v.sse));
+	report(sseeq(&v, mem), "movupd unaligned");
+	exceptions = 0;
+	handle_exception(GP_VECTOR, unaligned_movaps_handler);
+	asm("movaps %1, %0\n\t unaligned_movaps_cont:"
+			: "=m"(*mem) : "x"(v.sse));
+	handle_exception(GP_VECTOR, 0);
+	report(exceptions == 1, "unaligned movaps exception");
+
+	// setup memory for cross page access
+	mem = (sse_union *)(&bytes[4096-8]);
+	v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
+	mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
+
+	asm("movups %1, %0" : "=m"(*mem) : "x"(v.sse));
+	report(sseeq(&v, mem), "movups unaligned crosspage");
+
+	// invalidate second page
+	search = find_pte_level(current_page_table(), page2, 1);
+	orig_pte = *search.pte;
+	install_pte(current_page_table(), 1, page2, 0, NULL);
+	invlpg(page2);
+
+	exceptions = 0;
+	handle_exception(PF_VECTOR, cross_movups_handler);
+	asm("movups %1, %0\n\t cross_movups_cont:" : "=m"(*mem) : "x"(v.sse));
+	handle_exception(PF_VECTOR, 0);
+	report(exceptions == 1, "movups crosspage exception");
+
+	// restore invalidated page
+	install_pte(current_page_table(), 1, page2, orig_pte, NULL);
+}
+
 static void test_mmx(uint64_t *mem)
 {
     uint64_t v;
@@ -1057,6 +1126,7 @@ int main(void)
 	void *mem;
 	void *insn_page;
 	void *insn_ram;
+	void *cross_mem;
 	unsigned long t1, t2;
 
 	setup_vm();
@@ -1070,6 +1140,7 @@ int main(void)
 	install_page((void *)read_cr3(), IORAM_BASE_PHYS, mem + 4096);
 	insn_page = alloc_page();
 	insn_ram = vmap(virt_to_phys(insn_page), 4096);
+	cross_mem = vmap(virt_to_phys(alloc_pages(2)), 2 * PAGE_SIZE);
 
 	// test mov reg, r/m and mov r/m, reg
 	t1 = 0x123456789abcdef;
@@ -1102,6 +1173,7 @@ int main(void)
 	test_imul(mem);
 	test_muldiv(mem);
 	test_sse(mem);
+	test_sse_exceptions(cross_mem);
 	test_mmx(mem);
 	test_rip_relative(mem, insn_ram);
 	test_shld_shrd(mem);
-- 
2.31.1.368.gbe11c130af-goog

