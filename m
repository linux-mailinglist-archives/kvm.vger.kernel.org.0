Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7904E610695
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiJ0X5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 19:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiJ0X52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 19:57:28 -0400
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7126EF1F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 16:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1666915043;
        bh=eEZocbdq7Joiz0PpdyuALdGYXBfjSh8tuhffgVCHeMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=D/ugxse2bGS4DvaM/j9m43rSLCMqinijCvR3PCsomnxo9PFwFXCMVINAO2OMeMMCO
         2PWssioaoGiWe55hrJvevuPUgQHoZm2MKV/eEETwf0etBq3TdI7Kf+lGTDaIpZ9+W7
         /hzz21kPyIlUsvoRoE5x6hvGBy1/3ymBmKYi7yVA=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id E53814BE; Fri, 28 Oct 2022 07:57:19 +0800
X-QQ-mid: xmsmtpt1666915039tehk9lwxx
Message-ID: <tencent_A54B1715F957805155C449831821B3ACD207@qq.com>
X-QQ-XMAILINFO: N7h1OCCDntuj7ZDten010uQiKjwB4LQwOQQjsVRVWR7BBp/rIsC+6RQxYJuXdf
         n6B9my7rFhKAIvUHJdIYPRdW2yvEKk9Bq0flevNrUlLpi7I2ByVZMB9NofsOx2VOF5z9KuwgFher
         00qbSgyFsb67hZE2fjX9Wo+EWXum4yOTzfTll4rPntpPb8RuzXQWdCjNo/j8De4lwdSOBVaxd4E6
         SQ/hHqPkMMRz8Xl3v3uznJTcX/Jl6jK/0eNqWPforkM/Q8YxJlafsBeWTHTF3btNssSqiOIKBYdq
         kLtwlDm0TqF9dfM5v4WH8jOzlIoU6503OZSLjUUUHYhgm24ElpTykmK1uQGU+HG5IQuE7Uj2XPnt
         MJeGsqcKRPJ9g5geXPw6/pximC1WKCuaayN4RQopLgaGyRPKmXx7Zw8aUbRaPgLgAJMWAf3zntDN
         i+uSUkoxadkyCnnreg+eOSMcZIZA8K0EyPim87nL0afJXre42G1YZSO63EKEJ4w9T7ru0jv+utL4
         25RLmVQMoz7LN+qYTS5IJLXbZ9Ahh54pMlmLLU7cSTV5htU7oKuGwvc4ytU9wp9N0XwV4VNGyJ2m
         xpt56OCUYji0wUT3A+SxlshFdZb/V7IWt/LXpZWawjojJxpDkm1htMuZCOD3gYoODeWEA4OJB8ZJ
         SdxtBdWRI+hcCulOIc4ZVf9v+jU1JC2fpXZE0tpu3lY74Qt/RRSkiO4mMSwU1nAdIspnHZON4WBx
         s7pHMx1uTo6sz1MtNe2NAa9pQauS0rIQ/Piq9vrF7DrxXOhx6HwEQhNihGXjOdp/miWJtVh5i/mP
         3ugw0bpcQa07JbzlTnT8J2P6ltxCThoWBy1cwxWRSdT0M3m8VXWypER3p4bdCDkyYpPDFw9rkIXg
         z4Us0gm8aPJFf7FZpyg5tt6kh52BihjD7tVduLsDhs5iBVs8G0fmEGDxPCC0/D8afyx6JgNlHKIx
         g3kbTS4uDuZidKvnEEBQ==
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
Subject: [PATCH] KVM: VMX: Fix indentation coding style issue
Date:   Fri, 28 Oct 2022 07:57:00 +0800
X-OQ-MSGID: <20221027235700.85710-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <Y1sMuSqh+oY/XtjY@google.com>
References: <Y1sMuSqh+oY/XtjY@google.com>
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

Code indentation should use tabs where possible.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 arch/x86/kvm/vmx/vmx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dba04b6b019..c5c954fb0273 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -806,7 +806,7 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 	 */
 	if (is_guest_mode(vcpu))
 		eb |= get_vmcs12(vcpu)->exception_bitmap;
-        else {
+	else {
 		int mask = 0, match = 0;
 
 		if (enable_ept && (eb & (1u << PF_VECTOR))) {
@@ -1214,7 +1214,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		}
 	}
 
-    	if (vmx->nested.need_vmcs12_to_shadow_sync)
+	if (vmx->nested.need_vmcs12_to_shadow_sync)
 		nested_sync_vmcs12_to_shadow(vcpu);
 
 	if (vmx->guest_state_loaded)
@@ -4934,10 +4934,10 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return -EBUSY;
 
-       /*
-        * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
-        * e.g. if the IRQ arrived asynchronously after checking nested events.
-        */
+	/*
+	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
+	 * e.g. if the IRQ arrived asynchronously after checking nested events.
+	 */
 	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(vcpu))
 		return -EBUSY;
 
-- 
2.31.1

