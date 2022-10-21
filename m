Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD67606CB9
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 02:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJUA6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 20:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJUA55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 20:57:57 -0400
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7FE220F9D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 17:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1666313868;
        bh=dl6yBMYwe2DpRerjx1DwIpqPoeEi77jJTwJJ4yakXcw=;
        h=From:To:Cc:Subject:Date;
        b=OXrU6QK7H88OGpncfbeF9Atn5gBx7fntYNuupXmO34GFm/DA/r5qv9bb7GKczMCsq
         YmHJoq81bURH2r+AAhJv7MOqg++jx1bSei77QhJTyqq/6UdIjRBlny3c9+YV4c5Kym
         ORLsfpaFM84nOdcXl9NYFquhTUDBUDqcsNNLGsCA=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrsza32.qq.com (NewEsmtp) with SMTP
        id E6C0F64A; Fri, 21 Oct 2022 08:57:44 +0800
X-QQ-mid: xmsmtpt1666313864toqnf29sc
Message-ID: <tencent_768ACEEBE1E803E29F4191906956D065B806@qq.com>
X-QQ-XMAILINFO: N7h1OCCDntujVo9Hfi8wbg9LPgS406+zvQTITmAD8nORjvpp5imfSfXMri5wj2
         UGkC1dgWu75HAPm4Be98DV1aokEVMPBFiLBNYNEtIqdmNWbZJ1mnsINioGFkoRZvFFlbf2cqVS/P
         TKe+XeRC/wEUvIFDkAharLneEpucmpKvk7TTfjaf6CcmYjFOBAGPYganYWaJOTfCnXvXl0g61usk
         zONKzkcwlenZts7hjaX091E5F8xAlVC+VdwS6mmhB1nlwROloZWJ/rqur5o0ngZrkdd3cmiyuldq
         5xvzgY3hYEFqba57v7i2p1n5LGnafMCRm74DjxbOBGlwcFVu9TyKX2DeY2Mf/AQxiLNEKcvkrwLp
         nF6nIlR+H825OsZFIjEzNKVDEv4mfQlOlKyuQJZWnwk54CdfU1fmnCu+xJ84c4LZxnyudxJkN/vt
         bHVTwIeU91qy3ERq7YpepX43uYX1aeJ4JdEZh4TWOxg7JmnHz4k6G3bEoeVCrAfLqQwHAtg1yW+C
         sLGxnNRcuQGnm/rkPJXtE6ZdW5HpzVy9ne7FNTcTYuVSEvWXIxLUmw+8fiBOhKSKQ/MJliqWSO+T
         1zfFaX7ZSqnvYWXZd07qw7oE2FRzcC533AB27bpaWguNmMhDrZ9Ifc4nrenEu8tQwoO6FxjQ6t/K
         Rwgm094erd6KWHi9d9vnUt6U36+/0k1o20s2L6Q52aRDb9u5R7IWsNzIfSl7zdOzMS5GizRWB1YK
         35Dij5670IMz/yn0glJAQHNQ/vCFWfbmm0T9fPL1fd8kp7mN5Z7P1wbWNjByeAjMX2TgwXVxk+Xt
         DvedF3uUzdPJ5geaI7s8ezRFQ7MPRTosbJQKRhwrMc4IEDCE8KEYMgpe/aiVyf/t0xGCJvUKrZnm
         yxAlrDCHxCK8hCaFYAv9NoSlHdR0xeZZ/NKHe0TOyp59rYktnjqlqIYAdjf53ed4ShVSNetuuAC+
         5hxj45G3Ku6xzOMDjBqeT/u6bgisv68ZSRFANOdBQ+qw9HNTkmSMel90NboXgF
From:   Rong Tao <rtoax@foxmail.com>
Cc:     rtoax@foxmail.com, Rong Tao <rongtao@cestc.cn>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: vmenter: Use tabs instead of spaces for indentation
Date:   Fri, 21 Oct 2022 08:57:41 +0800
X-OQ-MSGID: <20221021005741.12240-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Code indentation should use tabs where possible and miss a '*'.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
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
2.31.1

