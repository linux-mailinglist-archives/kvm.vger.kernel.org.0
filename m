Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F8C1E8A04
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 23:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgE2V0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 17:26:49 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44996 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbgE2V0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 17:26:48 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 20E934C879;
        Fri, 29 May 2020 21:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1590787602; x=
        1592602003; bh=Cb10YADitQjUlinhJpS9kzmAGFapgQSiz48tUUd3bQU=; b=Y
        LFffMDZloaEszcT0wpzE1xE1wb9oaLmLVcIUFRN4CAQnfw1xnrn6PzK1WT5J+Yx4
        go6s6fwyf09hXqRWILUyWC+EJaWVcldKXoIeQ0u1m8x3lFMDrl45ZJ8qFdMDojoa
        4N448NXc7KkDM42t0lg/yLPs+3XWYgzYl9p7C5BEds=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2V6LZO_XZXdt; Sat, 30 May 2020 00:26:42 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7D7DB4C856;
        Sat, 30 May 2020 00:26:42 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 30
 May 2020 00:26:44 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH] x86: realmode: Add suffixes for push, pop and iret
Date:   Sat, 30 May 2020 00:26:37 +0300
Message-ID: <20200529212637.5034-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.26.1
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

binutils 2.33 and 2.34 changed generation of PUSH and POP for segment
registers and IRET in '.code16gcc' [1][2][3][4]. gas also yields the
following warnings during the build of realmode.c:

snip.s: Assembler messages:
snip.s:2279: Warning: generating 32-bit `push', unlike earlier gas versions
snip.s:2296: Warning: generating 32-bit `pop', unlike earlier gas versions
snip.s:3633: Warning: generating 16-bit `iret' for .code16gcc directive

This change fixes warnings and failures of the tests:

  push/pop 3
  push/pop 4
  iret 1
  iret 3

1. https://sourceware.org/bugzilla/show_bug.cgi?id=24485
2. https://sourceware.org/git/?p=binutils-gdb.git;h=7cb22ff84745
3. https://sourceware.org/git/?p=binutils-gdb.git;h=06f74c5cb868
4. https://sourceware.org/git/?p=binutils-gdb.git;h=13e600d0f560

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 x86/realmode.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 3518224..234d607 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -649,24 +649,24 @@ static void test_push_pop(void)
 	MK_INSN(push_es, "mov $0x231, %bx\n\t" //Just write a dummy value to see if it gets overwritten
 			 "mov $0x123, %ax\n\t"
 			 "mov %ax, %es\n\t"
-			 "push %es\n\t"
+			 "pushw %es\n\t"
 			 "pop %bx \n\t"
 			 );
 	MK_INSN(pop_es, "push %ax\n\t"
-			"pop %es\n\t"
+			"popw %es\n\t"
 			"mov %es, %bx\n\t"
 			);
-	MK_INSN(push_pop_ss, "push %ss\n\t"
+	MK_INSN(push_pop_ss, "pushw %ss\n\t"
 			     "pushw %ax\n\t"
 			     "popw %ss\n\t"
 			     "mov %ss, %bx\n\t"
-			     "pop %ss\n\t"
+			     "popw %ss\n\t"
 			);
-	MK_INSN(push_pop_fs, "push %fs\n\t"
+	MK_INSN(push_pop_fs, "pushl %fs\n\t"
 			     "pushl %eax\n\t"
 			     "popl %fs\n\t"
 			     "mov %fs, %ebx\n\t"
-			     "pop %fs\n\t"
+			     "popl %fs\n\t"
 			);
 	MK_INSN(push_pop_high_esp_bits,
 		"xor $0x12340000, %esp \n\t"
@@ -752,7 +752,7 @@ static void test_iret(void)
 			"pushl %cs\n\t"
 			"call 1f\n\t" /* a near call will push eip onto the stack */
 			"jmp 2f\n\t"
-			"1: iret\n\t"
+			"1: iretl\n\t"
 			"2:\n\t"
 		     );
 
@@ -771,7 +771,7 @@ static void test_iret(void)
 			      "pushl %cs\n\t"
 			      "call 1f\n\t"
 			      "jmp 2f\n\t"
-			      "1: iret\n\t"
+			      "1: iretl\n\t"
 			      "2:\n\t");
 
 	MK_INSN(iret_flags16, "pushfw\n\t"
@@ -1340,10 +1340,10 @@ static void test_lds_lss(void)
 {
 	init_inregs(&(struct regs){ .ebx = (unsigned long)&desc });
 
-	MK_INSN(lds, "push %ds\n\t"
+	MK_INSN(lds, "pushl %ds\n\t"
 		     "lds (%ebx), %eax\n\t"
 		     "mov %ds, %ebx\n\t"
-		     "pop %ds\n\t");
+		     "popl %ds\n\t");
 	exec_in_big_real_mode(&insn_lds);
 	report("lds", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
@@ -1356,28 +1356,28 @@ static void test_lds_lss(void)
 		outregs.eax == (unsigned long)desc.address &&
 		outregs.ebx == desc.sel);
 
-	MK_INSN(lfs, "push %fs\n\t"
+	MK_INSN(lfs, "pushl %fs\n\t"
 		     "lfs (%ebx), %eax\n\t"
 		     "mov %fs, %ebx\n\t"
-		     "pop %fs\n\t");
+		     "popl %fs\n\t");
 	exec_in_big_real_mode(&insn_lfs);
 	report("lfs", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
 		outregs.ebx == desc.sel);
 
-	MK_INSN(lgs, "push %gs\n\t"
+	MK_INSN(lgs, "pushl %gs\n\t"
 		     "lgs (%ebx), %eax\n\t"
 		     "mov %gs, %ebx\n\t"
-		     "pop %gs\n\t");
+		     "popl %gs\n\t");
 	exec_in_big_real_mode(&insn_lgs);
 	report("lgs", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
 		outregs.ebx == desc.sel);
 
-	MK_INSN(lss, "push %ss\n\t"
+	MK_INSN(lss, "pushl %ss\n\t"
 		     "lss (%ebx), %eax\n\t"
 		     "mov %ss, %ebx\n\t"
-		     "pop %ss\n\t");
+		     "popl %ss\n\t");
 	exec_in_big_real_mode(&insn_lss);
 	report("lss", R_AX | R_BX,
 		outregs.eax == (unsigned long)desc.address &&
-- 
2.26.1

