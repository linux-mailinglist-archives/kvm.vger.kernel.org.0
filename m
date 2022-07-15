Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028E75782B4
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiGRMth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 08:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbiGRMtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 08:49:35 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41132AF6;
        Mon, 18 Jul 2022 05:49:29 -0700 (PDT)
X-QQ-mid: bizesmtp62t1658148541t65169v9
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 20:48:58 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: lp8jUtqYSiCRmGXYztO0RgbjA3uQo8uRvgMHZyS2mQe441Acv474BceSwKVO9
        +Sc/2PaFPF0PKIljKVCunicC494RSNV8lI+KPctq0eb025yYPOhN7dpaNTyVsEwNX7muUAW
        kVO1EbJ2UuBu85xL8CnjkZVe1izY4L3NGeWiiPGgQc3dH3BukVCMjojAOJZw3ZZF/mMa8f5
        HbGOxyJsQEZNGkrxg6PdvOc37y1GzvzAtOsSMFYJlCNakrXs3ufBlaik+3/FruHAngJauyz
        0lv8rgrjbUa613HxbnOx8tPDdOmMjHKjx3HM61j1dAdMWldfqelIxOIGV01eQZ9LQl0v6n2
        i2WUE57O+qJrtFNkzw2RV8FUfNHm2GlRjlsO2VyLAkvgUuIdlwX5F2+mrOPr/pDudfeHk8m
        /gw7Vf4VPlY=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     mingo@redhat.com
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] KVM: nVMX: Fix comment typo
Date:   Fri, 15 Jul 2022 12:46:59 +0800
Message-Id: <20220715044659.20282-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The double `we' is duplicated in line 2569, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fbeda5aa72e1..cd99e49d7ff1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2566,7 +2566,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bits which we consider mandatory enabled.
 	 * The CR0_READ_SHADOW is what L2 should have expected to read given
 	 * the specifications by L1; It's not enough to take
-	 * vmcs12->cr0_read_shadow because on our cr0_guest_host_mask we we
+	 * vmcs12->cr0_read_shadow because on our cr0_guest_host_mask we
 	 * have more bits than L1 expected.
 	 */
 	vmx_set_cr0(vcpu, vmcs12->guest_cr0);
-- 
2.35.1


