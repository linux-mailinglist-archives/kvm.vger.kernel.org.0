Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE335C714
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241791AbhDLNKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:05 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:55157 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241746AbhDLNKD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id CA7041664;
        Mon, 12 Apr 2021 09:09:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 12 Apr 2021 09:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=XPQNUQKEXupnV63KWZ9Hhwvi3ppqpPrjyh3rpylALHE=; b=aM0WZ6Oq
        GYhemC17mMmRqflfeG+bRPqUL3JAwGcaMQP75i0iYjXJdoH0x/1MKrRBeNj5xJL0
        qkmo7XzwxBh5Y+RsAaLj6VhvtB+oEw0ZuRp4EPmfxZf+Nqw70jOMfQ7JBnDp7T7i
        2OjPBjUlLRhOwar2fVCewM+xZ4D1W256pRPOY1r87EY4ljB9ThxKsCq7aRED+YXr
        4woCEEgD2m2qPTuyxyYhI+W0JzvfJ/MOzN5Z5Ws3+TOOvEXJXBld4Di7huHLtYiS
        jLodJWKtQOu0Aa3cbGSTEacx0OzzSz97eI38igykUBmxgHmbZAEzB73+aBtOmNgj
        OFuSFurOTH064g==
X-ME-Sender: <xms:lkZ0YI8rVEqm6Tj7zwSACQYXzAFwHyVcCXgitLFlf5Zm7tVL_Wl7GA>
    <xme:lkZ0YAsiw7bQwFFIDEhjgmJ-rDDEobTyM7gWIUrAnm8dnjZjPzCNrGCv0n3l5l5Vd
    9NzVfPrnGHxdP5ZQV0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:lkZ0YOC4LwUROWBBwsuV_BxSk_hhSKt2Mmv1PG244DdD8CxNy1ITHg>
    <xmx:lkZ0YIdjzgjjCpHio2AsHDfBaTOMWm3yP0nU4gRymGy67IcwKxmdvA>
    <xmx:lkZ0YNNuAzw675wERetS1OfgTVKaq8TJe4dGXk03Ifv4twVRW4xwWw>
    <xmx:l0Z0YIGIBeW2KMtck9JPTMdgIY23FD0pY0hPbv-8ptVksN7V03ke48QKPLfp6S5t>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A00F240066;
        Mon, 12 Apr 2021 09:09:41 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id d79b2990;
        Mon, 12 Apr 2021 13:09:38 +0000 (UTC)
From:   David Edmondson <david.edmondson@oracle.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH 2/6] KVM: x86: pass emulation_reason to handle_emulation_failure()
Date:   Mon, 12 Apr 2021 14:09:33 +0100
Message-Id: <20210412130938.68178-3-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Make the emulation_reason available up stack when reporting an
emulation failure.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87e76f3aee64..b9225012ebd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7119,7 +7119,8 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
+static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type,
+				    int emulation_reason)
 {
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
@@ -7132,7 +7133,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	if (emulation_type & EMULTYPE_SKIP) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		vcpu->run->internal.data[0] = emulation_reason;
+		vcpu->run->internal.ndata = 1;
 		return 0;
 	}
 
@@ -7141,7 +7143,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		vcpu->run->internal.data[0] = emulation_reason;
+		vcpu->run->internal.ndata = 1;
 		return 0;
 	}
 
@@ -7490,7 +7493,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				inject_emulated_exception(vcpu);
 				return 1;
 			}
-			return handle_emulation_failure(vcpu, emulation_type);
+			return handle_emulation_failure(vcpu, emulation_type,
+							emulation_reason);
 		}
 	}
 
@@ -7547,7 +7551,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					emulation_type))
 			return 1;
 
-		return handle_emulation_failure(vcpu, emulation_type);
+		return handle_emulation_failure(vcpu, emulation_type,
+						emulation_reason);
 	}
 
 	if (ctxt->have_exception) {
-- 
2.30.2

