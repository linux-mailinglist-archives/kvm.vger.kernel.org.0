Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3226811A47C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 07:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfLKG1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 01:27:05 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727891AbfLKG0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 01:26:53 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6482EFD870D407DBC639;
        Wed, 11 Dec 2019 14:26:50 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 14:26:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 3/6] KVM: Fix some comment typos and missing parentheses
Date:   Wed, 11 Dec 2019 14:26:22 +0800
Message-ID: <1576045585-8536-4-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
References: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix some typos and add missing parentheses in the comments.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/hyperv.c     | 2 +-
 arch/x86/kvm/lapic.c      | 2 +-
 arch/x86/kvm/vmx/nested.c | 2 +-
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c7d4640b7b1c..a48d5708f1f8 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1122,7 +1122,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 
 		/*
-		 * Clear apic_assist portion of f(struct hv_vp_assist_page
+		 * Clear apic_assist portion of struct hv_vp_assist_page
 		 * only, there can be valuable data in the rest which needs
 		 * to be preserved e.g. on migration.
 		 */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 679692b55f6d..ea402e741bd5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -969,7 +969,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
  * - For single-destination interrupts, handle it in posted mode
  * - Else if vector hashing is enabled and it is a lowest-priority
  *   interrupt, handle it in posted mode and use the following mechanism
- *   to find the destinaiton vCPU.
+ *   to find the destination vCPU.
  *	1. For lowest-priority interrupts, store all the possible
  *	   destination vCPUs in an array.
  *	2. Use "guest vector % max number of destination vCPUs" to find
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b01ef1d87e6..63ab49de324d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3427,7 +3427,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 
 /*
  * On a nested exit from L2 to L1, vmcs12.guest_cr0 might not be up-to-date
- * because L2 may have changed some cr0 bits directly (CRO_GUEST_HOST_MASK).
+ * because L2 may have changed some cr0 bits directly (CR0_GUEST_HOST_MASK).
  * This function returns the new value we should put in vmcs12.guest_cr0.
  * It's not enough to just return the vmcs02 GUEST_CR0. Rather,
  *  1. Bits that neither L0 nor L1 trapped, were set directly by L2 and are now
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bf24fbb2056c..1be3854f1090 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6720,7 +6720,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	 * If PML is turned on, failure on enabling PML just results in failure
 	 * of creating the vcpu, therefore we can simplify PML logic (by
 	 * avoiding dealing with cases, such as enabling PML partially on vcpus
-	 * for the guest, etc.
+	 * for the guest), etc.
 	 */
 	if (enable_pml) {
 		vmx->pml_pg = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-- 
2.19.1

