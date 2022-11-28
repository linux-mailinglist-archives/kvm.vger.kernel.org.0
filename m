Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D8063A804
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 13:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbiK1MRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 07:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiK1MRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 07:17:15 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661DF1D65D;
        Mon, 28 Nov 2022 04:08:23 -0800 (PST)
Received: from mxde.zte.com.cn (unknown [10.35.20.121])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NLPPd1lCrz1DxY;
        Mon, 28 Nov 2022 20:08:21 +0800 (CST)
Received: from mxus.zte.com.cn (unknown [10.207.168.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxde.zte.com.cn (FangMail) with ESMTPS id 4NLPPL6dmRz9vSnv;
        Mon, 28 Nov 2022 20:08:06 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4NLPP52dXsz9tyD8;
        Mon, 28 Nov 2022 20:07:53 +0800 (CST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NLPLr3vXtz5BNS0;
        Mon, 28 Nov 2022 20:05:56 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NLPJs1MyVz4y0vQ;
        Mon, 28 Nov 2022 20:04:13 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2ASC3aJB077098;
        Mon, 28 Nov 2022 20:03:36 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp02[null])
        by mapi (Zmail) with MAPI id mid31;
        Mon, 28 Nov 2022 20:03:38 +0800 (CST)
Date:   Mon, 28 Nov 2022 20:03:38 +0800 (CST)
X-Zmail-TransId: 2afa6384a39affffffffe970c9cc
X-Mailer: Zmail v1.0
Message-ID: <202211282003389362484@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <seanjc@google.com>
Cc:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIEtWTTogU1ZNOiByZW1vdmUgcmVkdW5kYW50IHJldCB2YXJpYWJsZQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2ASC3aJB077098
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.14.novalocal with ID 6384A4B4.000 by FangMail milter!
X-FangMail-Envelope: 1669637301/4NLPPd1lCrz1DxY/6384A4B4.000/10.35.20.121/[10.35.20.121]/mxde.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6384A4B4.000/4NLPPd1lCrz1DxY
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

Return value from svm_nmi_blocked() directly instead of taking
this in another redundant variable.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 arch/x86/kvm/svm/svm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..416812f971f2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3572,7 +3572,6 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
        struct vmcb *vmcb = svm->vmcb;
-       bool ret;

        if (!gif_set(svm))
                return true;
@@ -3580,10 +3579,8 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
        if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
                return false;

-       ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
-             (vcpu->arch.hflags & HF_NMI_MASK);
-
-       return ret;
+       return (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
+              (vcpu->arch.hflags & HF_NMI_MASK);
 }

 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
--
2.15.2
