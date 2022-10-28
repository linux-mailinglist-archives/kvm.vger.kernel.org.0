Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4961069F
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiJ1ADv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ1ADt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:03:49 -0400
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FE67434D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1666915425;
        bh=dl6yBMYwe2DpRerjx1DwIpqPoeEi77jJTwJJ4yakXcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BQVBffIiI/5QS4W0/kOUAAlOZmMlFtlRBCUpmdAkLl5XLUI40DFEYu7MEOyry6yAK
         jA8dScFX39B3tG+5rPo4iGVkF/cLruITsCW41zOyZb/7jNGJs6kf5EK5p4XINf0nYE
         RgxjZrHmWdnPzzjd/pgebs+NYxxkK0ett2aFkBn0=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrszc2-0.qq.com (NewEsmtp) with SMTP
        id EA272E7; Fri, 28 Oct 2022 08:03:42 +0800
X-QQ-mid: xmsmtpt1666915422tyxflzaif
Message-ID: <tencent_1E036FA19AACC8CB3915EBD7AA5127C42107@qq.com>
X-QQ-XMAILINFO: N+tZcXNNUKPOx9aF/32esR5b5Obql5Yi4lm//cVYJcwGbLo9alD9QoYI3afM5j
         vCp2hNQcBrJZpFPWoSHrFL+jF4VRrhUfYY4TjvaBt/8o3VpcktWSAFqRNlf3LspM4uvmczGGsDe4
         lhgtSuxu20DoTmTTMXddhZ8GzWCCexWcmVdV5/3ZFA6CtH84szVfvK5QCRQuF23PEzT0ewqcG1pb
         UoThM90R4ndki4rc+TruJP09wes4kc4XwzI9FIyNVMTQngFPH1vj++34TdwxoLDaS7gq9h5ByRua
         81bDoRJiMjzACJ+MRyt8RFeb5U6+AGdXxfwiN2FtFJLp9anZ4d/2Exi3UcMT5D5+w2OBuYdUKD86
         3hDFGtfevVVaO3QX97F+ZY9QyFmHGtDi6L8b9Rj0RcXsE2HNbNiijMS+m1YwZAzi0SL2n8SM+eCM
         kikO8ngkum/YoFIWW1BOG06ZKBjiuZdMyutA1xWRnBY3ic5KQxdC61O6GBQOdpChyYk0Vdr3PVrv
         CtWv75n0RY/vJ2G7WRz4hPT/tPZgXSlHIWJr4czUn+M2hiWsLcqKEfwyDjV6WsHszhS0sCSxOsdl
         HRu8mHkH1tERFdo0GBQ4YKKyNBDx7R+6VTX8dWGRZaIzIqFiiKFt/06PBXeExtGBrSQRK1Hfl4sw
         RI01NgrAlp1ITnDGCHofZDTQbAemBVJA4oM1cY98IO6Q2Xt4ykeEI5ificUZLBaG/WbS+T1qnxFO
         ldwyNRKXOAlruE2lI4iIrZU2byn+soc0F/SB726CbBxwrfsShTlxu81xw03dSgtP/m9BjsXVY/CU
         U5wvpsy5h6qOzzTUuctyONSSuqMFbstyTaZu4Dfta4Ecy7+HolcEMT/w259IA/MB8BzBEIW2b9uN
         LC6+NC/5JXISyFaZ4plFOBTmNRkAoMajDQIiFRACviIDoK347/8EcKx1YQSOckhy2Nau9ZEYokIZ
         MHUE4ZmnM4B2RoNR/qnsrJGi2MbfIu
From:   Rong Tao <rtoax@foxmail.com>
To:     seanjc@google.com
Cc:     Rong Tao <rongtao@cestc.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] KVM: VMX: Use tabs instead of spaces for indentation
Date:   Fri, 28 Oct 2022 08:03:40 +0800
X-OQ-MSGID: <20221028000340.86450-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <Y1sMPJvZDj6hGvih@google.com>
References: <Y1sMPJvZDj6hGvih@google.com>
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

