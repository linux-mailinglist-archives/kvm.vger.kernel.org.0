Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EBE34054F
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCRMQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:35 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60597 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhCRMP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:15:59 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2021 08:15:58 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id A999B10F1;
        Thu, 18 Mar 2021 08:08:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 18 Mar 2021 08:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=NGzHtoARk93S0Tgw0eEPpKCgVsQ+Q4Wm9hnrZZO4FmY=; b=jZHqVPOU
        UecSYHxGkA8BUHgLPS7Iehd62BtEPK66AfLFc7gHhzUSgdB+oE81FnW7Vdq1Rqte
        Bwh3V0/WLtGKdeD6eIizkXT0vwcxhnoOhtlD+MWqBrcVZY9nz/Lm9XN68AzjO9f7
        Asu6R3OH9kZKF/o9XGRumKmTt2HH0JADdIwKTjEOa2vRa+CKfyK7z//evAXsxqo1
        4cSDHtinxly8eU/iQJ4/j7Rwqv8+Yt+xbGgRcmEHLlFp5J4qo6AQIieSB9H4QQPR
        OZg4li6SFQAnKJNOeEsycc9HnQJfXsEAmDCcEE6x1JHfrx52GdM5NNiP7OD1KEih
        i8QKMgpYKFoVuw==
X-ME-Sender: <xms:z0JTYDqdtwU8It-iOdcXVepIy1YkLhe-x2DuCQpQ3cIMV5lmolah8Q>
    <xme:z0JTYNmOXQzb6sRVLez_7O640ZUW2cJxWy4GdL8eq1VZpwL5xtDpk_009-wREePd-
    Ht9q-_0Qjn5go-2nmk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:z0JTYNG9XdFxX5dNr3VJDIRumOvXs2GXu5TwVssF3LcEYBxNPXVwrg>
    <xmx:z0JTYOqEylkh8h5bc7FAfSXjV6TesRKdGwgsiFrifOr-OPbNP1CGDw>
    <xmx:z0JTYB7dW7Fcwhi_qXM2M7u9mWcX7fKJYtIv1w3jz7aOxA5p5gtFZA>
    <xmx:0UJTYCP45hf2rGOR98g2F2FFr5qYssEok7oc216lJefqInepHOGjy26frW7fY2wz>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id B17311080068;
        Thu, 18 Mar 2021 08:08:46 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id a47fd1a8;
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
Subject: [PATCH v5 5/5] KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
Date:   Thu, 18 Mar 2021 12:08:41 +0000
Message-Id: <20210318120841.133123-6-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dumping the current VMCS state, include the MSRs that are being
automatically loaded/stored during VM entry/exit.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0a41a8ec2bd9..e001c3bb4334 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5787,6 +5787,16 @@ static void vmx_dump_dtsel(char *name, uint32_t limit)
 	       vmcs_readl(limit + GUEST_GDTR_BASE - GUEST_GDTR_LIMIT));
 }
 
+static void vmx_dump_msrs(char *name, struct vmx_msrs *m)
+{
+	unsigned int i;
+	struct vmx_msr_entry *e;
+
+	pr_err("MSR %s:\n", name);
+	for (i = 0, e = m->val; i < m->nr; ++i, ++e)
+		pr_err("  %2d: msr=0x%08x value=0x%016llx\n", i, e->index, e->value);
+}
+
 void dump_vmcs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5868,6 +5878,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
+	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
+	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
+		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
@@ -5897,6 +5911,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	    vmexit_ctl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
+	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
+		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
 	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
-- 
2.30.2

