Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8D7777F9
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 14:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjHJMPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 08:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHJMPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 08:15:36 -0400
X-Greylist: delayed 1107 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Aug 2023 05:15:33 PDT
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3730D110
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 05:15:32 -0700 (PDT)
From:   Shiyuan Gao <gaoshiyuan@baidu.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, Shiyuan Gao <gaoshiyuan@baidu.com>
Subject: [PATCH] KVM: VMX: Rename vmx_get_max_tdp_level to vmx_get_max_ept_level
Date:   Thu, 10 Aug 2023 19:38:53 +0800
Message-ID: <20230810113853.98114-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex09.internal.baidu.com (172.31.51.49) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2023-08-10 19:39:02:844
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vmx, ept_level looks better than tdp level and is consistent with
svm get_npt_level().

Signed-off-by: Shiyuan Gao <gaoshiyuan@baidu.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index df461f387e20..f0cfd1f10a06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3350,7 +3350,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vmx->emulation_required = vmx_emulation_required(vcpu);
 }
 
-static int vmx_get_max_tdp_level(void)
+static int vmx_get_max_ept_level(void)
 {
 	if (cpu_has_vmx_ept_5levels())
 		return 5;
@@ -8526,7 +8526,7 @@ static __init int hardware_setup(void)
 	 */
 	vmx_setup_me_spte_mask();
 
-	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
+	kvm_configure_mmu(enable_ept, 0, vmx_get_max_ept_level(),
 			  ept_caps_to_lpage_level(vmx_capability.ept));
 
 	/*
-- 
2.36.1

