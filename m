Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8034054C
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhCRMQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:35 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60899 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230408AbhCRMP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:15:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 700C4FE1;
        Thu, 18 Mar 2021 08:08:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 18 Mar 2021 08:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=96PabhJDlstmRC7dsrIRYNFjrVdwNrnjmP8hw9NXnxQ=; b=gzroBiHF
        qtKZ/V+qgg6VQWfsiGz3OwmJk+/mhZXRjAL+iE/lPyCYea4CEojkDHc6h0V3mBPp
        lMtQ+qtnX+l/d9AVVoLLFp46EHrDmse48kZplwapjKSbswhT/WU87JjnOkPZxu7B
        03giZCHs7LJu47ufOfE7iH75AVAZbSp142j2sSngZbNe/U5Tirxlu2cE1rk/J71e
        z37uHxoB6BBxOYAxWcwz95WC1jQmLo1E78WFNF7aNxZzAj6UsuhL+rV58eEGf/Iz
        CKosx45COMf/yWb+12mh729xSSKIZqexuAd7ZW+MSwaTmRuzUbzBB0CjGA8OBORP
        t5/NeT3ajAx+rQ==
X-ME-Sender: <xms:zUJTYEF62at7RsElDYuQ-v8aZ3bxLWwGrcsIwxpgT4_c73zgYTFCJQ>
    <xme:zUJTYLBab6pO21IkejnAIGNg81ArA23T-LtnxXUJm4QrxlFtlCX1LzAGJ-n_hojkx
    pYiM4G2id3iYMO2nI4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:zUJTYP6mliqJOinKMipiE7m_5D2MwN8YeCLWIXz0cJVNTq9kJqB9yg>
    <xmx:zUJTYCkHwS3NblqAHrGF-_SmZ_z_tNRTdC-PVpPP9GN3J5eTWzXxKw>
    <xmx:zUJTYA55xs_xBk49O8mtdy6VBV2XsM-ZINool5QjXkMNPs8ZOOo5Xw>
    <xmx:z0JTYDzgkDSCbvUuj4unM-9eBhEl6YfpxG58Gv3omuFCZOjCcdhj9OJ3E1oTRJ8V>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B23B108005F;
        Thu, 18 Mar 2021 08:08:43 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 08d61faf;
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
Subject: [PATCH v5 1/5] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
Date:   Thu, 18 Mar 2021 12:08:37 +0000
Message-Id: <20210318120841.133123-2-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the VM entry/exit controls for loading/saving MSR_EFER are either
not available (an older processor or explicitly disabled) or not
used (host and guest values are the same), reading GUEST_IA32_EFER
from the VMCS returns an inaccurate value.

Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
whether to print the PDPTRs - always do so if the fields exist.

Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..b0ee9d240f73 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5792,7 +5792,6 @@ void dump_vmcs(void)
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
 	unsigned long cr4;
-	u64 efer;
 
 	if (!dump_invalid_vmcs) {
 		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
@@ -5804,7 +5803,6 @@ void dump_vmcs(void)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	efer = vmcs_read64(GUEST_IA32_EFER);
 	secondary_exec_control = 0;
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
@@ -5816,9 +5814,7 @@ void dump_vmcs(void)
 	pr_err("CR4: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
 	       cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
 	pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
-	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
-	    (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
-	{
+	if (cpu_has_vmx_ept()) {
 		pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
 		       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
 		pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
@@ -5844,7 +5840,8 @@ void dump_vmcs(void)
 	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
 	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
 		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       efer, vmcs_read64(GUEST_IA32_PAT));
+		       vmcs_read64(GUEST_IA32_EFER),
+		       vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
-- 
2.30.2

