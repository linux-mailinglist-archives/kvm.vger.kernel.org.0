Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB053188F3A
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 21:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgCQUoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 16:44:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCQUoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 16:44:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKi1w1096892;
        Tue, 17 Mar 2020 20:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YaEWJRYmTz3xvGH/0lUtNUZOBaSClgLzgeRw5k7RCSc=;
 b=hg87H2yXn+pp8f++mJfwFXPXek/nbAdPqOianarkt7I7Z9WWydJYk5CMJYvR0mOmyvE4
 AFiiI2RrgktVehxejH2ToDNL43J9G+inove+NuwfyeJg3ohLun65Z8+zHiDC5JrzDDUz
 5p155XD5+M/AjKJu5MzZAzQUzNdnHiHZSHW7fiEg3TbBJ7mD9FpzmknLxmT1SD1U1QYc
 Qu7VAUQi1Wz07dJogd99dR6PFY4uoeyp20NJ6oHf26UaLEkNPhVgfztBGc7nRbtTYyvn
 x4jQD7cbslb+LofHK1xjzr/r8Z91bDdStt9Scpx+V2Yoznyl0i0ZDXQeQuJ6TImRfhHa Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yrqwn73ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HKbZSd005211;
        Tue, 17 Mar 2020 20:44:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92e3244-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 20:44:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HKiTZX030758;
        Tue, 17 Mar 2020 20:44:29 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Tue, 17 Mar 2020 13:43:16 -0700
MIME-Version: 1.0
Message-ID: <20200317200537.21593-2-krish.sadhukhan@oracle.com>
Date:   Tue, 17 Mar 2020 13:05:35 -0700 (PDT)
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/3] kvm-unit-test: nSVM: Add alternative (v2) test format for
 nested guests
References: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200317200537.21593-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=15
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9563 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=15
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..so that we can add tests such as VMCB consistency tests, that require
  the tests to only proceed up to the execution of the first guest (nested)
  instruction and do not require us to define all the functions that the
  current format dictates.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.c       | 75 ++++++++++++++++++++++++++++++++++++++++++---------------
 x86/svm.h       |  6 +++++
 x86/svm_tests.c |  2 ++
 3 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 07571e9..7ce33a6 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -110,9 +110,16 @@ inline void vmmcall(void)
 	asm volatile ("vmmcall" : : : "memory");
 }
 
+static test_guest_func guest_main;
+
+void test_set_guest(test_guest_func func)
+{
+	guest_main = func;
+}
+
 static void test_thunk(struct svm_test *test)
 {
-	test->guest_func(test);
+	guest_main(test);
 	vmmcall();
 }
 
@@ -191,14 +198,49 @@ struct regs get_regs(void)
 
 #define LOAD_GPR_C      SAVE_GPR_C
 
-static void test_run(struct svm_test *test, struct vmcb *vmcb)
+struct svm_test *v2_test;
+struct vmcb *vmcb;
+
+#define ASM_VMRUN_CMD                           \
+                "vmload %%rax\n\t"              \
+                "mov regs+0x80, %%r15\n\t"      \
+                "mov %%r15, 0x170(%%rax)\n\t"   \
+                "mov regs, %%r15\n\t"           \
+                "mov %%r15, 0x1f8(%%rax)\n\t"   \
+                LOAD_GPR_C                      \
+                "vmrun %%rax\n\t"               \
+                SAVE_GPR_C                      \
+                "mov 0x170(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs+0x80\n\t"      \
+                "mov 0x1f8(%%rax), %%r15\n\t"   \
+                "mov %%r15, regs\n\t"           \
+                "vmsave %%rax\n\t"              \
+
+u64 guest_stack[10000];
+
+int svm_vmrun(void)
+{
+	vmcb->save.rip = (ulong)test_thunk;
+	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
+	regs.rdi = (ulong)v2_test;
+
+	asm volatile (
+		ASM_VMRUN_CMD
+		:
+		: "a" (virt_to_phys(vmcb))
+		: "memory");
+
+	return (vmcb->control.exit_code);
+}
+
+static void test_run(struct svm_test *test)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
-	u64 guest_stack[10000];
 
 	irq_disable();
 	test->vmcb = vmcb;
 	test->prepare(test);
+	guest_main = test->guest_func;
 	vmcb->save.rip = (ulong)test_thunk;
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 	regs.rdi = (ulong)test;
@@ -210,19 +252,7 @@ static void test_run(struct svm_test *test, struct vmcb *vmcb)
 			"sti \n\t"
 			"call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
 			"mov %[vmcb_phys], %%rax \n\t"
-			"vmload %%rax\n\t"
-			"mov regs+0x80, %%r15\n\t"  // rflags
-			"mov %%r15, 0x170(%%rax)\n\t"
-			"mov regs, %%r15\n\t"       // rax
-			"mov %%r15, 0x1f8(%%rax)\n\t"
-			LOAD_GPR_C
-			"vmrun %%rax\n\t"
-			SAVE_GPR_C
-			"mov 0x170(%%rax), %%r15\n\t"  // rflags
-			"mov %%r15, regs+0x80\n\t"
-			"mov 0x1f8(%%rax), %%r15\n\t"  // rax
-			"mov %%r15, regs\n\t"
-			"vmsave %%rax\n\t"
+			ASM_VMRUN_CMD
 			"cli \n\t"
 			"stgi"
 			: // inputs clobbered by the guest:
@@ -303,7 +333,6 @@ extern struct svm_test svm_tests[];
 int main(int ac, char **av)
 {
 	int i = 0;
-	struct vmcb *vmcb;
 
 	setup_vm();
 	smp_init();
@@ -318,9 +347,15 @@ int main(int ac, char **av)
 	vmcb = alloc_page();
 
 	for (; svm_tests[i].name != NULL; i++) {
-		if (!svm_tests[i].supported())
-			continue;
-		test_run(&svm_tests[i], vmcb);
+		if (svm_tests[i].v2 == NULL) {
+			if (!svm_tests[i].supported())
+				continue;
+			test_run(&svm_tests[i]);
+		} else {
+			vmcb_ident(vmcb);
+			v2_test = &(svm_tests[i]);
+			svm_tests[i].v2();
+		}
 	}
 
 	return report_summary();
diff --git a/x86/svm.h b/x86/svm.h
index ccc5172..25514de 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -337,6 +337,8 @@ struct svm_test {
 	struct vmcb *vmcb;
 	int exits;
 	ulong scratch;
+	/* Alternative test interface. */
+	void (*v2)(void);
 };
 
 struct regs {
@@ -359,6 +361,8 @@ struct regs {
 	u64 rflags;
 };
 
+typedef void (*test_guest_func)(struct svm_test *);
+
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
 u64 *npt_get_pdpe(void);
@@ -374,5 +378,7 @@ void inc_test_stage(struct svm_test *test);
 void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
+int svm_vmrun(void);
+void test_set_guest(test_guest_func func);
 
 #endif
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 264f8de..580bce6 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1195,6 +1195,8 @@ static bool pending_event_check_vmask(struct svm_test *test)
     return get_test_stage(test) == 2;
 }
 
+#define TEST(name) { #name, .v2 = name }
+
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
       default_prepare_gif_clear, null_test,
-- 
1.8.3.1

