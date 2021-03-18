Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63EA340547
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCRMQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:30 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40673 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhCRMQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:16:00 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 8EBB9FDD;
        Thu, 18 Mar 2021 08:08:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Mar 2021 08:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/o083KAjWsyDdhb923HKJx22tiblDJalUrxbE1F/Sn8=; b=DuOPmlMh
        8Mp+WKwItGoaC41oncWP5JD+6xYSgbnjyvicjnj3ibB4PDmO4JkodqSVAX+qRwnr
        k0Mp85VghZB/gavnWD4YBlU6Gvd5lAl8VqYFtIaabyzlPX+3OdJMAmks0iHCDOxC
        aa8VLppx4C9AuB+YWHOra1CiSTrWs9+rDuS3My8lOKNjgS083zIj3rt7BaCoT5cs
        8kjxlVD9QckWZ3RL/2tScPSIWHPaIPvFx757Ou5Bznohmhj2dSkjleOK8esIHhDT
        CHaSo4sBVFR8iwYr2S21t4nAyuQ2a3vO/WCNKkWjj3uURi2JrkCwav56g4qEsstN
        u250J73kCElzVA==
X-ME-Sender: <xms:zkJTYI9tkPF74NTPVKzAgWqGgAqtfpxLxePUcCB8TXdWh3isUhAEag>
    <xme:zkJTYAs8t-YeKpyoqOLqO-1YZYrutfhzOONi21MVhP_Nn7TovPKJFMvCq2OCnsncC
    U7ZRWXv2R1Wq7Fvj5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:zkJTYODKerdergfFRx8kaLQx_G7KbB1AeBFCMyyqvXcoO1CIW6PFXQ>
    <xmx:zkJTYIcN8fyozGnHVviHK2ixuZtjGiSt8KaxLGOpx_0y3lixHS9mxw>
    <xmx:zkJTYNPQgQv-fw2OSIFz8S7sl2HaVSUHZwIjyMcpqY6d8H7QqD886A>
    <xmx:z0JTYIGqmhAQItf4vbBa8szWxFQgRI5g5a4GJCqKh04rsd7_FDuMBGkIiVCg4kCw>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id E5FC1240057;
        Thu, 18 Mar 2021 08:08:44 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 332509b3;
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
Subject: [PATCH v5 2/5] KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
Date:   Thu, 18 Mar 2021 12:08:38 +0000
Message-Id: <20210318120841.133123-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Show EFER and PAT based on their individual entry/exit controls.

Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b0ee9d240f73..6ab9e4d69aac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5837,11 +5837,12 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
-	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
-	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
-		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(GUEST_IA32_EFER),
-		       vmcs_read64(GUEST_IA32_PAT));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
+	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
+	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
 	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
@@ -5878,10 +5879,10 @@ void dump_vmcs(void)
 	       vmcs_readl(HOST_IA32_SYSENTER_ESP),
 	       vmcs_read32(HOST_IA32_SYSENTER_CS),
 	       vmcs_readl(HOST_IA32_SYSENTER_EIP));
-	if (vmexit_ctl & (VM_EXIT_LOAD_IA32_PAT | VM_EXIT_LOAD_IA32_EFER))
-		pr_err("EFER = 0x%016llx  PAT = 0x%016llx\n",
-		       vmcs_read64(HOST_IA32_EFER),
-		       vmcs_read64(HOST_IA32_PAT));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_EFER)
+		pr_err("EFER= 0x%016llx\n", vmcs_read64(HOST_IA32_EFER));
+	if (vmexit_ctl & VM_EXIT_LOAD_IA32_PAT)
+		pr_err("PAT = 0x%016llx\n", vmcs_read64(HOST_IA32_PAT));
 	if (cpu_has_load_perf_global_ctrl() &&
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
-- 
2.30.2

