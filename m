Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11037240663
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 15:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgHJNGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 09:06:43 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47978 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726545AbgHJNGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 09:06:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6DE9B4C8AA;
        Mon, 10 Aug 2020 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1597064794; x=1598879195; bh=YCHEH+2TNnwPMP800cfZDqgw/KJs3ms6w07
        6DKOG21k=; b=SVMVhPIPNEpVsv47d6d0gn/DxyQ7WECxqz+Tf4Mgu4CV0P1oEHp
        e2PzC2a9AegotNcKaOABI1LFJx34wb4Wa8sQlmWk1pB6mpBJJiy7GhTa3F49KONY
        Umf+5Ac/fNwt+bU7WFnyI0ZKHSdelaHl/NYbuK+TBAXj0T4BF+Dq8Cfc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kyjKu0Jdq00e; Mon, 10 Aug 2020 16:06:34 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 95A954C667;
        Mon, 10 Aug 2020 16:06:34 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 10
 Aug 2020 16:06:34 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [kvm-unit-tests PATCH 2/7] x86: Replace instruction prefixes with spaces
Date:   Mon, 10 Aug 2020 16:06:13 +0300
Message-ID: <20200810130618.16066-3-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200810130618.16066-1-r.bolshakov@yadro.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are three kinds of x86 prefix delimiters in GNU binutils:
'/', '\\' and a space.

The first works on Linux and few other platforms.  The second one is
SVR-4 compatible and works on the generic elf target. The last kind is
universal and works everywhere, it's also used in the GAS manual [1].
Space delimiters fix the build errors on x86_64-elf binutils:

  x86/cstart64.S:217: Error: invalid character '/' in mnemonic
  x86/cstart64.S:313: Error: invalid character '/' in mnemonic

1. https://sourceware.org/binutils/docs/as/i386_002dPrefixes.html

Cc: Cameron Esfahani <dirty@apple.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/cstart.S   |  4 ++--
 x86/cstart64.S |  4 ++--
 x86/emulator.c | 38 +++++++++++++++++++-------------------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index c0efc5f..489c561 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -149,7 +149,7 @@ save_id:
 ap_start32:
 	setup_segments
 	mov $-4096, %esp
-	lock/xaddl %esp, smp_stacktop
+	lock xaddl %esp, smp_stacktop
 	setup_percpu_area
 	call prepare_32
 	call reset_apic
@@ -206,7 +206,7 @@ ap_init:
 	lea sipi_entry, %esi
 	xor %edi, %edi
 	mov $(sipi_end - sipi_entry), %ecx
-	rep/movsb
+	rep movsb
 	mov $APIC_DEFAULT_PHYS_BASE, %eax
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%eax)
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%eax)
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 2d16688..25a296c 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -226,7 +226,7 @@ sipi_end:
 ap_start32:
 	setup_segments
 	mov $-4096, %esp
-	lock/xaddl %esp, smp_stacktop
+	lock xaddl %esp, smp_stacktop
 	setup_percpu_area
 	call prepare_64
 	ljmpl $8, $ap_start64
@@ -323,7 +323,7 @@ ap_init:
 	lea sipi_entry, %rsi
 	xor %rdi, %rdi
 	mov $(sipi_end - sipi_entry), %rcx
-	rep/movsb
+	rep movsb
 	mov $APIC_DEFAULT_PHYS_BASE, %eax
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT), APIC_ICR(%rax)
 	movl $(APIC_DEST_ALLBUT | APIC_DEST_PHYSICAL | APIC_DM_STARTUP), APIC_ICR(%rax)
diff --git a/x86/emulator.c b/x86/emulator.c
index 98743d1..e46d97e 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -61,71 +61,71 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
 
 	rsi = m1; rdi = m3; rcx = 30;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsb"
+		     "repe cmpsb"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsb (1)");
 
 	rsi = m1; rdi = m3; rcx = 30;
 	asm volatile("or $1, %[tmp]\n\t" // clear ZF
-		     "repe/cmpsb"
+		     "repe cmpsb"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30,
-	       "repe/cmpsb (1.zf)");
+	       "repe cmpsb (1.zf)");
 
 	rsi = m1; rdi = m3; rcx = 15;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsw"
+		     "repe cmpsw"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
-	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsw (1)");
+	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe cmpsw (1)");
 
 	rsi = m1; rdi = m3; rcx = 7;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsl"
+		     "repe cmpsl"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
-	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe/cmpll (1)");
+	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe cmpll (1)");
 
 	rsi = m1; rdi = m3; rcx = 4;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsq"
+		     "repe cmpsq"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
-	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe/cmpsq (1)");
+	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe cmpsq (1)");
 
 	rsi = m1; rdi = m3; rcx = 130;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsb"
+		     "repe cmpsb"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 29 && rsi == m1 + 101 && rdi == m3 + 101,
-	       "repe/cmpsb (2)");
+	       "repe cmpsb (2)");
 
 	rsi = m1; rdi = m3; rcx = 65;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsw"
+		     "repe cmpsw"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 14 && rsi == m1 + 102 && rdi == m3 + 102,
-	       "repe/cmpsw (2)");
+	       "repe cmpsw (2)");
 
 	rsi = m1; rdi = m3; rcx = 32;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsl"
+		     "repe cmpsl"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 6 && rsi == m1 + 104 && rdi == m3 + 104,
-	       "repe/cmpll (2)");
+	       "repe cmpll (2)");
 
 	rsi = m1; rdi = m3; rcx = 16;
 	asm volatile("xor %[tmp], %[tmp] \n\t"
-		     "repe/cmpsq"
+		     "repe cmpsq"
 		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
 		     : : "cc");
 	report(rcx == 3 && rsi == m1 + 104 && rdi == m3 + 104,
-	       "repe/cmpsq (2)");
+	       "repe cmpsq (2)");
 
 }
 
@@ -304,8 +304,8 @@ static void test_ljmp(void *mem)
     volatile int res = 1;
 
     *(unsigned long**)m = &&jmpf;
-    asm volatile ("data16/mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
-    asm volatile ("rex64/ljmp *%0"::"m"(*m));
+    asm volatile ("data16 mov %%cs, %0":"=m"(*(m + sizeof(unsigned long))));
+    asm volatile ("rex64 ljmp *%0"::"m"(*m));
     res = 0;
 jmpf:
     report(res, "ljmp");
-- 
2.26.1

