Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59156340551
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCRMQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:36 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56909 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhCRMQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:16:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 0BF1010DE;
        Thu, 18 Mar 2021 08:08:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Mar 2021 08:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1tDfeZNzarbZPIdRl+chseNu1T4hPmJuxutIG/HKblo=; b=ew1adpk8
        4K1DD6XVy+7Jsn2aCifh+qvcH3Tz75eb2KGFdBgVb6+CUQ79Kklcl+vjpa9pHBQ/
        Eywy5x+mpsYPRCdJXtKS+pa9buCN4axxaCyWHA9fyUlrc9UQMjJItXk9/6WmkISG
        +HU+YH9hneGxVmY04YDR3zHxSX7t5s74yBqGwNm4pEPXnWj3gTp4gDlmY1uPvcgY
        hQX50UHmHg4Qeya24WTcZD7OCfU/4v/MNelmN+qsMkVaeGmhiWgXoqsb2x9Kg+aE
        NZtcYk68PTk/s3AYOfBNTtjn5QXhBOtm0BT1OGoKjktkWV21CXqNuUP67C3oXGnx
        qZmmEZlY4qfahA==
X-ME-Sender: <xms:z0JTYC0LUpgFh-6VkEhmbv4bNqcgug3DOHvJOzk7bQu3EsY_WR3jtg>
    <xme:z0JTYFFMayysJUamWLZPSpFwOWT5AIHsMCpS7zyZt_MZJWqqwGVkobAPiqROmAyXi
    VWE05ljs97jwxiiRXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:z0JTYK6cTOC9BmR2Haf8VNhVsiCOCJ8QMzb_cr5j8YGCnPpUhzYMuA>
    <xmx:z0JTYD12ru7Qw486eU0dezgMpjZr8Wwe4T_b8TbqqG-CmjgV3VMdEQ>
    <xmx:z0JTYFHqAoGN6zRsHShkrtsHgu6ke0nJyAm9OXgrYxgFin8tD_LnGQ>
    <xmx:z0JTYD-BW3kZk_Rhq2zUmFh3XNnsffcDX9DxQw0uxwbyDnD3hi-MJRNC0IXdZvKV>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F1A324005A;
        Thu, 18 Mar 2021 08:08:46 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 45a94d5e;
        Thu, 18 Mar 2021 12:08:41 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v5 4/5] KVM: x86: dump_vmcs should show the effective EFER
Date:   Thu, 18 Mar 2021 12:08:40 +0000
Message-Id: <20210318120841.133123-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If EFER is not being loaded from the VMCS, show the effective value by
reference to the MSR autoload list or calculation.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 67e574deced1..0a41a8ec2bd9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5787,11 +5787,13 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
-void dump_vmcs(void)
+void dump_vmcs(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
+	int efer_slot;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5837,8 +5839,18 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
+	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
+	else if (efer_slot >= 0)
+		pr_err("EFER= 0x%016llx (autoload)\n",
+		       vmx->msr_autoload.guest.val[efer_slot].value);
+	else if (vmentry_ctl & VM_ENTRY_IA32E_MODE)
+		pr_err("EFER= 0x%016llx (effective)\n",
+		       vcpu->arch.efer | (EFER_LMA | EFER_LME));
+	else
+		pr_err("EFER= 0x%016llx (effective)\n",
+		       vcpu->arch.efer & ~(EFER_LMA | EFER_LME));
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT)
 		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
@@ -5993,7 +6005,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (exit_reason.failed_vmentry) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= exit_reason.full;
@@ -6002,7 +6014,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	if (unlikely(vmx->fail)) {
-		dump_vmcs();
+		dump_vmcs(vcpu);
 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason
 			= vmcs_read32(VM_INSTRUCTION_ERROR);
@@ -6088,7 +6100,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 unexpected_vmexit:
 	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
 		    exit_reason.full);
-	dump_vmcs();
+	dump_vmcs(vcpu);
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 89da5e1251f1..c35af2daa0bd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -543,6 +543,6 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 	return is_unrestricted_guest(vcpu) || __vmx_guest_state_valid(vcpu);
 }
 
-void dump_vmcs(void);
+void dump_vmcs(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_X86_VMX_H */
-- 
2.30.2

