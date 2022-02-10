Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7213D4B08C5
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiBJIrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:47:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiBJIrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:47:09 -0500
Received: from out0-146.mail.aliyun.com (out0-146.mail.aliyun.com [140.205.0.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D881E7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 00:47:10 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.MntXQXa_1644482825;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.MntXQXa_1644482825)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Feb 2022 16:47:05 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v3 2/3] x86/emulator: Rename test_ljmp() as test_far_jmp()
Date:   Thu, 10 Feb 2022 16:46:34 +0800
Message-Id: <8d712b48c0b5c2f0e4c3a0126321a083d850591e.1644481282.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
References: <cover.1644481282.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename test_ljmp() as test_far_jmp() to better match the SDM. Also
change the output of test to explain what it is doing.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 x86/emulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index c56b32be8baa..45972c2fe940 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -358,7 +358,7 @@ static void test_pop(void *mem)
 	       "enter");
 }
 
-static void test_ljmp(void *mem)
+static void test_far_jmp(void *mem)
 {
     unsigned char *m = mem;
     volatile int res = 1;
@@ -368,7 +368,7 @@ static void test_ljmp(void *mem)
     asm volatile ("rex64 ljmp *%0"::"m"(*m));
     res = 0;
 jmpf:
-    report(res, "ljmp");
+    report(res, "far jmp, via emulated MMIO");
 }
 
 static void test_incdecnotneg(void *mem)
@@ -1295,7 +1295,7 @@ int main(void)
 
 	test_smsw(mem);
 	test_lmsw();
-	test_ljmp(mem);
+	test_far_jmp(mem);
 	test_far_ret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
-- 
2.31.1

