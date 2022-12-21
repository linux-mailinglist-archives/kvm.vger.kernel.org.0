Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD46530CB
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 13:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiLUM3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 07:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiLUM27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 07:28:59 -0500
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB42823150;
        Wed, 21 Dec 2022 04:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1671625734;
        bh=AFdOwjgElA0eVy7l9HQ7225RQz+4S6ABdjqCdlZNIhE=;
        h=From:To:Cc:Subject:Date;
        b=tw6kYs0OmI6AhCcSoNrD/2NXnGjZQjDSbfpwnZAmeTJT68jobrgORpjxl3srBUIsh
         /lGoGBRK3w5gv0e/bivplkjTuH+enPc52kxqJ6VgUzeC8OHRYzQ8phi6sHs5Sxp3aB
         4rToUFc0IlgJsvsjqCMATq6FQGuggI9GIHG9EUcs=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrszb1-0.qq.com (NewEsmtp) with SMTP
        id 732BAE55; Wed, 21 Dec 2022 20:28:50 +0800
X-QQ-mid: xmsmtpt1671625730t6gewc676
Message-ID: <tencent_A492CB3F9592578451154442830EA1B02C07@qq.com>
X-QQ-XMAILINFO: MyHh0PQai9Fp55N85Mprq5cqwqbSGPRN4ij7NV1aatKhjs13keIoWdefELgoRH
         Of1pucblIq9+mT+7KZJBZZBwDtWAVtmikJL8r5LNVS+HnwVHwg961R8yLc6py/mEJmaHgKRwbbkt
         NzCzwaZT/qJuF6OhAr200ctxmy967DAySPFqrvwJ2hn+/JXPOntaQL9So89Isy0HJmoJ4dns6q9u
         L88U8wDuS98WimEutfC9OY51vVNjLwihLCp4blnTYueL+5SoYzhdqWkA7RMZI8i6YuGn+TZ15dfw
         SZURqnGhxvmJsLe3R4efPL5+Wa8I2OSNLhtdZsyGVRKoo+kEZlPpgMShiOY64mnNq8gZkqXDP95Z
         8FdJNQ1RW5pnohOpxyCt3LQYmKSHORprzISYywVcQSd8YoEViJyZi5AvpUl6zNzWXsgppqH+z/Ty
         jpx/eCup6XeN5rXnKBB7mnWdsaJNZxWgXEltm0FVYrFOJXd2ULLbZHgeU1a9v2Q2MsVkT3sRqali
         uVjmOv/nNh545FqE+nc8vl1OTLXVSFoDwyXVZ9NBJVal0oMCXtmG9/6p+U/7HSgpI01Wb54P/iem
         SeECaQM80kOPZmyEmnKvzGwJtKzuJD2vAtV13LpFADV6HffNlStEZq0SAap+VpqT4Jy2AzlX/iM8
         May22tpbAtVRZ1F6Y4nlS86zteyXeDSyq19/ZSoPyPbED7+/v8SEtiouoPHwXa6OWYP4UGUFUnEo
         u6S2QtNuY2kA91N7AsPOcAwT9LssYqElGXL3zZT5guOWY/PwgoO69IsRh4CSMiCa72ZghDqbJ1JN
         pqCU+quqCNKCorzbqbAXkDbpQzk7qRlojOL6259oiTetOnFVAEF1jAWziCUI/B8jWmosQM+lgYgE
         IcVTZJVWfMOslxBoYU1I26/nXUTobxrq103qZNDTMRS5ud/hYKa1SWUoD5zE56KYtcTGMOPoRTWu
         1KSC9FBC5ooZPlFX3P19eWmHXT0uc9KW9EEtg9xhXIFtZh3Q06UQrw2Negkhi9J/MVXA3bwr7N6W
         aIwJEeGg==
From:   Rong Tao <rtoax@foxmail.com>
To:     seanjc@google.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rongtao@cestc.cn,
        rtoax@foxmail.com, tglx@linutronix.de, x86@kernel.org
Subject: [PATCH v2] KVM: VMX: Use tabs instead of spaces for indentation
Date:   Wed, 21 Dec 2022 20:28:49 +0800
X-OQ-MSGID: <20221221122849.80994-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Code indentation should use tabs where possible and miss a '*'.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
v2: KVM: VMX: for case-insensitive searches
v1: https://lore.kernel.org/lkml/tencent_768ACEEBE1E803E29F4191906956D065B806@qq.com/
---
 arch/x86/kvm/vmx/vmenter.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..f09e3aaab102 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -229,7 +229,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
 	 * need the RSB filling sequence.  But it does need to be enabled, and a
 	 * single call to retire, before the first unbalanced RET.
-         */
+	 */
 
 	FILL_RETURN_BUFFER %_ASM_CX, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_VMEXIT,\
 			   X86_FEATURE_RSB_VMEXIT_LITE
@@ -273,7 +273,7 @@ SYM_FUNC_END(__vmx_vcpu_run)
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
  * @fault:	%true if the VMREAD faulted, %false if it failed
-
+ *
  * Save and restore volatile registers across a call to vmread_error().  Note,
  * all parameters are passed on the stack.
  */
-- 
2.39.0

