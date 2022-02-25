Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046AA4C41C4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 10:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiBYJuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 04:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiBYJuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 04:50:22 -0500
Received: from out0-142.mail.aliyun.com (out0-142.mail.aliyun.com [140.205.0.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812BD24FA2C
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 01:49:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047190;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---.Mvv.A6N_1645782587;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.Mvv.A6N_1645782587)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Feb 2022 17:49:48 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>
Subject: [kvm-unit-tests PATCH v4 2/3] x86/emulator: Rename test_ljmp() as test_far_jmp()
Date:   Fri, 25 Feb 2022 17:49:26 +0800
Message-Id: <6b975c25ce066a9c344b1fedca3bc4826b1878c3.1645672780.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1645672780.git.houwenlong.hwl@antgroup.com>
References: <cover.1645672780.git.houwenlong.hwl@antgroup.com>
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
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
---
 x86/emulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index c62dcedac991..7925ad48c36d 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -359,7 +359,7 @@ static void test_pop(void *mem)
 	       "enter");
 }
 
-static void test_ljmp(void *mem)
+static void test_far_jmp(void *mem)
 {
     unsigned char *m = mem;
     volatile int res = 1;
@@ -369,7 +369,7 @@ static void test_ljmp(void *mem)
     asm volatile ("rex64 ljmp *%0"::"m"(*m));
     res = 0;
 jmpf:
-    report(res, "ljmp");
+    report(res, "far jmp, via emulated MMIO");
 }
 
 static void test_incdecnotneg(void *mem)
@@ -1296,7 +1296,7 @@ int main(void)
 
 	test_smsw(mem);
 	test_lmsw();
-	test_ljmp(mem);
+	test_far_jmp(mem);
 	test_far_ret(mem);
 	test_stringio();
 	test_incdecnotneg(mem);
-- 
2.31.1

