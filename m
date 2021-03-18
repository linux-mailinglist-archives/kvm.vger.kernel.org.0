Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179B134054D
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhCRMQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:16:34 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:32901 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhCRMP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 08:15:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1239410D1;
        Thu, 18 Mar 2021 08:08:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 18 Mar 2021 08:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Upd0zRsjoJwY7jlVfN/xjZg6awL8Tqwhxn1QfDa6lTU=; b=gI3JNQ1L
        SfAjA1zltjbv6VkYGFjG8lRDoQsNfkLR4rzRZ8EDCh1O+8evgEqsRykp8GVh2cEj
        wYRTlxJW8mpLlti2CrT3Yf1NbMreGpGk1TIrsLUh13dzDveYKC3g2QwckDKi7YpN
        LotqOlgPAe3Z6c29CboxqB9qWzZgWaWB7ym0WPZI7vSIEf+wpHqO2ZxIwYbt4z0F
        hSHHFplxOSmu98ZynYmcjNaHpINhz4YWAMgX5SuqCemaUpjXANNIOY+l6oE8bY2L
        /2URv4O3/Uq4DM5HJUsSfW1xemb9bTyPf1Br3GPb4QXaF/FKLKtH7XH9D338a/vt
        5mCTZs+GlXlIGw==
X-ME-Sender: <xms:zkJTYBNE6l33mEJk5JVzhAIJC0bl9xXsCNK5KOwxV9JtEIbWJsv2Wg>
    <xme:zkJTYF68hQt7cCWA27X3xda_6XPF_3KD0fqvIfBgmaCmVsnLR3l1hYbeuuj2Zgs3j
    j1_cE3wnIBFznXFn04>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefiedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:zkJTYKqbW-mDnsAIpVQYsqcDF0ZjE6SG3WlTNfGb2gOlRB95VwENAQ>
    <xmx:zkJTYLApBnoIh5Ru7aDeFOpjhjWLPOHDk6z72R6vM2L2ouCqOTgh8g>
    <xmx:zkJTYIfh5oX4pIXwpwvAnOKEEtTiIpteTRx7oxfSaIdfClEZdyEzwQ>
    <xmx:zkJTYFu14J5H_l6rVUDhqj5AEUdlpt92S3ArMG8ok8VJJ63VaWx9zVwf2cDNsDB8>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6662C108006F;
        Thu, 18 Mar 2021 08:08:45 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 8284f0a0;
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
Subject: [PATCH v5 3/5] KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
Date:   Thu, 18 Mar 2021 12:08:39 +0000
Message-Id: <20210318120841.133123-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318120841.133123-1-david.edmondson@oracle.com>
References: <20210318120841.133123-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When deciding whether to dump the GUEST_IA32_EFER and GUEST_IA32_PAT
fields of the VMCS, examine only the VM entry load controls, as saving
on VM exit has no effect on whether VM entry succeeds or fails.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ab9e4d69aac..67e574deced1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5837,11 +5837,9 @@ void dump_vmcs(void)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
-	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_EFER) ||
-	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER))
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
-	if ((vmexit_ctl & VM_EXIT_SAVE_IA32_PAT) ||
-	    (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT))
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_PAT)
 		pr_err("PAT = 0x%016llx\n", vmcs_read64(GUEST_IA32_PAT));
 	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
 	       vmcs_read64(GUEST_IA32_DEBUGCTL),
-- 
2.30.2

