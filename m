Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9BB605EB6
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJTLVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJTLUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:20:54 -0400
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 04:20:49 PDT
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68A71863E0
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 04:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1666264846;
        bh=eEZocbdq7Joiz0PpdyuALdGYXBfjSh8tuhffgVCHeMA=;
        h=From:To:Cc:Subject:Date;
        b=YMIytKlv/x3HasFMFvZ0npQoSYxHZAhg86Pbkb8gKe0NaGOB3Xw1U7+4nIoRXvrFO
         GcOHElYbOoWsDKTkvaf9rx+bdDZzGIa2GlyCftjeCembzq2WWsI4CqeKScGFaGFZXT
         l5St0mhNwOb5i6veo/u7myplfiNHXi2XXuiYqa2Q=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrsza35.qq.com (NewEsmtp) with SMTP
        id 347A8CC4; Thu, 20 Oct 2022 19:13:07 +0800
X-QQ-mid: xmsmtpt1666264387tbkyy2laf
Message-ID: <tencent_4D21B619F00AE966BD5DD2ABA4BC7A8F060A@qq.com>
X-QQ-XMAILINFO: Mm/8i8/T4ynenpIQIWrciErp1i32et/xZsB2D0sKkowwr8FJ4RMs7zaX/ClB1E
         SBAKM3yvcHzqGkQC2orXrhL4FjiNbV9e+NAkyJRQ0iafVKnS9qL/BFtcFOAvacrc998MU96sCxxF
         776kD4hDolGCq67ImcamJEjN+v25dKDnd8sSpmXQO5rlT4Foe+m08ttKbTzhYsJbzn+Kj8Bce7TQ
         B6QcVmQd3gCobPQnX00Orqx6h4yCJNDKczS7JreyfnGL1xpd2CRVzlF52ewAlJ5NMS3Wdj9k2wDN
         Lg/07GC0C2c2Hb1R/iYKYH9ODOdF4BvRY0aTBVD2I/bcQPh+gKDcaFXS6bmFFErOwiPSwCkD+LfG
         fZp43HMLk1tsQ4T4T2mxpb50kmeJMl4jBCq1nssaHca6rz6nVchz3tOmd0zWz6Ivx42LzJE05AE4
         KmjKjDpv+bONw9X3OXG0FREu/1llBPVu0Zv8tBMcFifxxl2ZCQ/kfMTHv/R6YBsw01qlBCp40bMf
         g6hPo5ezbohlCYPB5HOJW6ER0eelMrJEfIKxcl8XojSIxBnXQCCVGsxOSHbTbv1LM1WaSn4dbndF
         LxvE517ySqkim+LEZ+saqEj17nXZzpTRpssXdSbVi3WiUZCLtRp1WZE1WY24riMNcV2HDIl66XQS
         6TvWKc+qRHv85EnRzQnOT4Qt1OULso2NTfrneHYsUdyqiPGvSfi25Gj+uk/Z4UrZgBdVgy0g6sd8
         SBz6n2h+WAfKl7Fbor/SkJ3weQNyAGyrrVmuOrw/NJFNCBM/Nqaq53lBfoStWMapVkBzH2aOAcaX
         ekEJcJCkFLcDCp5u8I9qc5GP+d2MlAwK0YcJVhym5Bk7cNLm72m4Mfdlmf8T3JVzRMk5KxEqDU/3
         l/SrJIIA5o8zaiZ4vR2XNTwOmX28dsfCpjStnuWT30TD5xps50iC3VlK0a8RQckjXwX1BvC4iNJW
         G2eYI3A+MgTVcwRfOFtlSKQ8QL8GRgEtISlJ4q9Fjf2RYnogi4PMmk7F4QxwT0acYNsClGatp4Zt
         CkDDcaxbWzXXQBkXzz
From:   Rong Tao <rtoax@foxmail.com>
Cc:     rtoax@foxmail.com, Rong Tao <rongtao@cestc.cn>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: vmx: Fix indentation coding style issue
Date:   Thu, 20 Oct 2022 19:13:06 +0800
X-OQ-MSGID: <20221020111306.164162-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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

