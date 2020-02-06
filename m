Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9F1153CF3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 03:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBFC1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 21:27:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10155 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727307AbgBFC1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 21:27:46 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D2F2FD7277A99D30D65F;
        Thu,  6 Feb 2020 10:27:42 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Feb 2020
 10:27:32 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: nVMX: Fix some comment typos and coding style
Date:   Thu, 6 Feb 2020 10:29:22 +0800
Message-ID: <1580956162-5609-1-git-send-email-linmiaohe@huawei.com>
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

Fix some typos in the comments. Also fix coding style.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..8196a4a0df8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -782,7 +782,7 @@ struct kvm_vcpu_arch {
 
 	/*
 	 * Indicate whether the access faults on its page table in guest
-	 * which is set when fix page fault and used to detect unhandeable
+	 * which is set when fix page fault and used to detect unhandleable
 	 * instruction.
 	 */
 	bool write_fault_to_shadow_pgtable;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..e7faebccd733 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -544,7 +544,8 @@ static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
 	}
 }
 
-static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap) {
+static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
+{
 	int msr;
 
 	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
@@ -1981,7 +1982,7 @@ static int nested_vmx_handle_enlightened_vmptrld(struct kvm_vcpu *vcpu,
 	}
 
 	/*
-	 * Clean fields data can't de used on VMLAUNCH and when we switch
+	 * Clean fields data can't be used on VMLAUNCH and when we switch
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
 	if (from_launch || evmcs_gpa_changed)
-- 
2.19.1

