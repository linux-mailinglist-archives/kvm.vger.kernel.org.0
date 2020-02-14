Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5846A15D018
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 03:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgBNCmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 21:42:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10619 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728004AbgBNCmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 21:42:35 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7FACC6BB37394EE36B5A;
        Fri, 14 Feb 2020 10:42:31 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 14 Feb 2020
 10:42:23 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: nVMX: Fix some obsolete comments and grammar error
Date:   Fri, 14 Feb 2020 10:44:05 +0800
Message-ID: <1581648245-8414-1-git-send-email-linmiaohe@huawei.com>
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

Fix wrong variable names and grammar error in comment.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..f2d8cb68dce8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3160,10 +3160,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
  * or KVM_SET_NESTED_STATE).  Otherwise it's called from vmlaunch/vmresume.
  *
  * Returns:
- *	NVMX_ENTRY_SUCCESS: Entered VMX non-root mode
- *	NVMX_ENTRY_VMFAIL:  Consistency check VMFail
- *	NVMX_ENTRY_VMEXIT:  Consistency check VMExit
- *	NVMX_ENTRY_KVM_INTERNAL_ERROR: KVM internal error
+ *	NVMX_VMENTRY_SUCCESS: Entered VMX non-root mode
+ *	NVMX_VMENTRY_VMFAIL:  Consistency check VMFail
+ *	NVMX_VMENTRY_VMEXIT:  Consistency check VMExit
+ *	NVMX_VMENTRY_KVM_INTERNAL_ERROR: KVM internal error
  */
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 							bool from_vmentry)
@@ -5301,7 +5301,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
 }
 
 /*
- * Return 1 if we should exit from L2 to L1 to handle an MSR access access,
+ * Return 1 if we should exit from L2 to L1 to handle an MSR access,
  * rather than handle it ourselves in L0. I.e., check whether L1 expressed
  * disinterest in the current event (read or write a specific MSR) by using an
  * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
-- 
2.19.1

