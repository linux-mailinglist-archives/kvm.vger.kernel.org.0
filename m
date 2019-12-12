Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7101011C828
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfLLITO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:19:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728207AbfLLITN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:19:13 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3D6F785B90A2B857FD5C;
        Thu, 12 Dec 2019 16:19:12 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 16:19:05 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2 2/4] KVM: x86: Fix some comment typos and grammar mistakes
Date:   Thu, 12 Dec 2019 16:18:36 +0800
Message-ID: <1576138718-32728-3-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
References: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix some typos and grammar mistakes in comments.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/ioapic.c           | 2 +-
 arch/x86/kvm/lapic.c            | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 159a28512e4c..e714e281e17a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -606,7 +606,7 @@ struct kvm_vcpu_arch {
 	 * Paging state of an L2 guest (used for nested npt)
 	 *
 	 * This context will save all necessary information to walk page tables
-	 * of the an L2 guest. This context is only initialized for page table
+	 * of an L2 guest. This context is only initialized for page table
 	 * walking and not for faulting since we never handle l2 page faults on
 	 * the host.
 	 */
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 77538fd77dc2..7312aab33298 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -189,7 +189,7 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 	/*
 	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
 	 * this only happens if a previous edge has not been delivered due
-	 * do masking.  For level interrupts, the remote_irr field tells
+	 * to masking.  For level interrupts, the remote_irr field tells
 	 * us if the interrupt is waiting for an EOI.
 	 *
 	 * RTC is special: it is edge-triggered, but userspace likes to know
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 679692b55f6d..88c3c0c6d1e3 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -964,12 +964,12 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 }
 
 /*
- * This routine tries to handler interrupts in posted mode, here is how
+ * This routine tries to handle interrupts in posted mode, here is how
  * it deals with different cases:
  * - For single-destination interrupts, handle it in posted mode
  * - Else if vector hashing is enabled and it is a lowest-priority
  *   interrupt, handle it in posted mode and use the following mechanism
- *   to find the destinaiton vCPU.
+ *   to find the destination vCPU.
  *	1. For lowest-priority interrupts, store all the possible
  *	   destination vCPUs in an array.
  *	2. Use "guest vector % max number of destination vCPUs" to find
-- 
2.19.1

