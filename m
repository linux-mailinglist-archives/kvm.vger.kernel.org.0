Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0920D16B7E6
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 04:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgBYDEI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 22:04:08 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:56774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728011AbgBYDEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 22:04:08 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 859766DCF82F09E0D887;
        Tue, 25 Feb 2020 11:04:04 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Feb 2020
 11:03:56 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: Fix some obsolete comments
Date:   Tue, 25 Feb 2020 11:05:15 +0800
Message-ID: <1582599915-425-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Remove some obsolete comments, fix wrong function name and description.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/svm.c        | 3 ---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fd3fc9fbefff..ee114a9913eb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3228,9 +3228,6 @@ static int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
-/*
- * If this function returns true, this #vmexit was already handled
- */
 static int nested_svm_intercept(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0946122a8d3b..46c5f63136a8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2960,7 +2960,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	/*
 	 * Induce a consistency check VMExit by clearing bit 1 in GUEST_RFLAGS,
 	 * which is reserved to '1' by hardware.  GUEST_RFLAGS is guaranteed to
-	 * be written (by preparve_vmcs02()) before the "real" VMEnter, i.e.
+	 * be written (by prepare_vmcs02()) before the "real" VMEnter, i.e.
 	 * there is no need to preserve other bits or save/restore the field.
 	 */
 	vmcs_writel(GUEST_RFLAGS, 0);
@@ -4382,7 +4382,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
  * Decode the memory-address operand of a vmx instruction, as recorded on an
  * exit caused by such an instruction (run by a guest hypervisor).
  * On success, returns 0. When the operand is invalid, returns 1 and throws
- * #UD or #GP.
+ * #UD, #GP or #SS.
  */
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 69948aa1b127..8d91fa9acbb2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -808,7 +808,7 @@ void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	if (to_vmx(vcpu)->rmode.vm86_active)
 		eb = ~0;
 	if (enable_ept)
-		eb &= ~(1u << PF_VECTOR); /* bypass_guest_pf = 0 */
+		eb &= ~(1u << PF_VECTOR);
 
 	/* When we are running a nested L2 guest and L1 specified for it a
 	 * certain exception bitmap, we must trap the same exceptions and pass
-- 
2.19.1

