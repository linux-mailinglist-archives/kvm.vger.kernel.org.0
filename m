Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DD55A68B
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 23:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF1Vso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 17:48:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfF1Vso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 17:48:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SLj3w9050942
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 21:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=ARdEGOD/IsGur8tC25YXUy4xoLtoRvpg4bMSU+/9J/s=;
 b=y32BUfpdRlpR+FitdF15/7l/lLFwxfgSRrJg64bbjQ3+2v7OkzzTXvnPJO9dsAmBNxS7
 vbo8iFRMpyWqR0MtPz1QF4ukRY9F+2x3xUbOSgr+HFNo/bYWnL3/B5Gye+lYbi6ztsnm
 w4f/qNsFZtfz4tsOFDlWwwdMkIWnRXqOsiyewDqu2kuvw+uSaNptPkya/dubFJsUqNTe
 jCxzEcwKy62uoiSFrjjRHOfvatkkPfCQXS/6OhzUAjhBHr0lwQnUJ0OBau71kiBJLQYs
 JLVQffLzkuKTRtH7kG31BLDLoXFWSnr2UFnpnNAuukW0NKktXUvGmEqVt3ofI6nNM2Sm WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyqyj41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 21:48:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SLm47w015848
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 21:48:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7e5r3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 21:48:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5SLmgFG021086
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 21:48:42 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 14:48:42 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Subject: [PATCH] kvm-unit-test: x86: Remove duplicate definitions of write_cr4_checking() and put it in library
Date:   Fri, 28 Jun 2019 17:21:08 -0400
Message-Id: <20190628212108.23203-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280248
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280248
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..so that it can be re-used.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>

---
 lib/x86/desc.c  | 8 ++++++++
 lib/x86/desc.h  | 1 +
 x86/access.c    | 8 --------
 x86/pcid.c      | 8 --------
 x86/vmx_tests.c | 8 --------
 x86/xsave.c     | 8 --------
 6 files changed, 9 insertions(+), 32 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 0108555..5f37cef 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -251,6 +251,14 @@ unsigned exception_vector(void)
     return vector;
 }
 
+int write_cr4_checking(unsigned long val)
+{
+    asm volatile(ASM_TRY("1f")
+            "mov %0,%%cr4\n\t"
+            "1:": : "r" (val));
+    return exception_vector();
+}
+
 unsigned exception_error_code(void)
 {
     unsigned short error_code;
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 7a7358a..9cf823a 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -207,6 +207,7 @@ extern tss64_t tss;
 #endif
 
 unsigned exception_vector(void);
+int write_cr4_checking(unsigned long val);
 unsigned exception_error_code(void);
 bool exception_rflags_rf(void);
 void set_idt_entry(int vec, void *addr, int dpl);
diff --git a/x86/access.c b/x86/access.c
index 9412300..f0d1879 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -171,14 +171,6 @@ typedef struct {
 
 static void ac_test_show(ac_test_t *at);
 
-static int write_cr4_checking(unsigned long val)
-{
-    asm volatile(ASM_TRY("1f")
-            "mov %0,%%cr4\n\t"
-            "1:": : "r" (val));
-    return exception_vector();
-}
-
 static void set_cr0_wp(int wp)
 {
     unsigned long cr0 = read_cr0();
diff --git a/x86/pcid.c b/x86/pcid.c
index c04fd09..dfabe0e 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -21,14 +21,6 @@ static int write_cr0_checking(unsigned long val)
     return exception_vector();
 }
 
-static int write_cr4_checking(unsigned long val)
-{
-    asm volatile(ASM_TRY("1f")
-                 "mov %0, %%cr4\n\t"
-                 "1:": : "r" (val));
-    return exception_vector();
-}
-
 static int invpcid_checking(unsigned long type, void *desc)
 {
     asm volatile (ASM_TRY("1f")
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c48e7fc..7184b06 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7090,14 +7090,6 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
-static int write_cr4_checking(unsigned long val)
-{
-	asm volatile(ASM_TRY("1f")
-		     "mov %0, %%cr4\n\t"
-		     "1:": : "r" (val));
-	return exception_vector();
-}
-
 static void vmx_cr_load_test(void)
 {
 	struct cpuid _cpuid = cpuid(1);
diff --git a/x86/xsave.c b/x86/xsave.c
index 00787bb..ca41bbf 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -33,14 +33,6 @@ static int xsetbv_checking(u32 index, u64 value)
     return exception_vector();
 }
 
-static int write_cr4_checking(unsigned long val)
-{
-    asm volatile(ASM_TRY("1f")
-            "mov %0,%%cr4\n\t"
-            "1:": : "r" (val));
-    return exception_vector();
-}
-
 #define CPUID_1_ECX_XSAVE	    (1 << 26)
 #define CPUID_1_ECX_OSXSAVE	    (1 << 27)
 static int check_cpuid_1_ecx(unsigned int bit)
-- 
2.20.1

