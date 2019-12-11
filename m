Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A85E11A482
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 07:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfLKG1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 01:27:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40728 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727901AbfLKG0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 01:26:53 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9114AA216BE70CAC0B20;
        Wed, 11 Dec 2019 14:26:50 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 14:26:42 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 6/6] KVM: Fix some writing mistakes
Date:   Wed, 11 Dec 2019 14:26:25 +0800
Message-ID: <1576045585-8536-7-git-send-email-linmiaohe@huawei.com>
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

Fix some writing mistakes in the comments.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 virt/kvm/kvm_main.c             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 159a28512e4c..efba864ed42d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -606,7 +606,7 @@ struct kvm_vcpu_arch {
 	 * Paging state of an L2 guest (used for nested npt)
 	 *
 	 * This context will save all necessary information to walk page tables
-	 * of the an L2 guest. This context is only initialized for page table
+	 * of the L2 guest. This context is only initialized for page table
 	 * walking and not for faulting since we never handle l2 page faults on
 	 * the host.
 	 */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1be3854f1090..dae712c8785e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1922,7 +1922,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 
 /*
- * Writes msr value into into the appropriate "register".
+ * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
  * Assumes vcpu_load() was already called.
  */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f0501272268f..1a6d5ebd5c42 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1519,7 +1519,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 /*
  * The fast path to get the writable pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
- * only part that runs if we can are in atomic context.
+ * only part that runs if we can in atomic context.
  */
 static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
-- 
2.19.1

