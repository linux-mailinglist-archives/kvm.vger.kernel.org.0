Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E677915FC65
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 03:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBOCnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 21:43:04 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:50706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727416AbgBOCnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 21:43:04 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 836E95F4E3E86090DA44;
        Sat, 15 Feb 2020 10:43:00 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sat, 15 Feb 2020
 10:42:54 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: x86: Fix print format and coding style
Date:   Sat, 15 Feb 2020 10:44:22 +0800
Message-ID: <1581734662-970-1-git-send-email-linmiaohe@huawei.com>
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

Use %u to print u32 var and correct some coding style.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/i8254.c      | 2 +-
 arch/x86/kvm/mmu/mmu.c    | 3 +--
 arch/x86/kvm/vmx/nested.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index b24c606ac04b..febca334c320 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -367,7 +367,7 @@ static void pit_load_count(struct kvm_pit *pit, int channel, u32 val)
 {
 	struct kvm_kpit_state *ps = &pit->pit_state;
 
-	pr_debug("load_count val is %d, channel is %d\n", val, channel);
+	pr_debug("load_count val is %u, channel is %d\n", val, channel);
 
 	/*
 	 * The largest possible initial count is 0; this is equivalent
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7011a4e54866..9c228b9910b1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3568,8 +3568,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * write-protected for dirty-logging or access tracking.
 		 */
 		if ((error_code & PFERR_WRITE_MASK) &&
-		    spte_can_locklessly_be_made_writable(spte))
-		{
+		    spte_can_locklessly_be_made_writable(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
 
 			/*
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f2d8cb68dce8..6f3e515f28fd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4367,7 +4367,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	if (base_is_valid)
 		off += kvm_register_read(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_read(vcpu, index_reg)<<scaling;
+		off += kvm_register_read(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*
-- 
2.19.1

