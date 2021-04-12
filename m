Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B536A35C717
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 15:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhDLNKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 09:10:10 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:51081 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241768AbhDLNKE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 09:10:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 66D4B16A9;
        Mon, 12 Apr 2021 09:09:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 12 Apr 2021 09:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=1K0iw42KNFYBkLsYKyjD7325njwHj63G+RvjjAS+EuE=; b=R/IakVPV
        utKtTSlbR0+xhb25rcCLvulXpHR/hFfF3pvjb/uGYY7Kp9bxL00Iz35pdGilK65i
        J6pS7y2UxVqx6LqdM6IjpzpEs16qVcGDRfHF7gkm8Scc7uL7pJVDBTt7Oq116EH+
        UKodGf2pyc2DDSfTTjiKo/Y7v+n1I1qsuOfWOWUGx9PfySM0x2x8lcwXn0L1uZV/
        4j2saZCOT5PQwZDf8Ry+BKd3IntfCGnaBSK4F3311JbMV97WdZ0uqYZaksBfxNgX
        mp0XYPfn0dAsYD6YypG8a6Wvhv2N5ItLRqOjyZ9tTzsjtaJsQx3z+Jd4EfWnvNVu
        h3+rHPvDH+EvKA==
X-ME-Sender: <xms:l0Z0YF2iTGCtUCvBpq3qb_W_Yl_dMM0SDsn0KIqlkapURwU6lXrVhQ>
    <xme:l0Z0YMAwspY69FfKT9W3A5sRmInxf7dy4Pj54N2tp_puw5e_qHYmsKdOQRPqRme1w
    JjkaeNepAs5c1xt4II>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekjedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceouggrvhhiugdrvggumhhonhgushhonhesohhrrggtlhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpedufeetjefgfefhtdejhfehtdfftefhteekhefg
    leehfffhiefhgeelgfejtdehkeenucfkphepkedurddukeejrddviedrvdefkeenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegurghvihgurdgv
    ughmohhnughsohhnsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:l0Z0YCw30FNEJyZVp6N_fwRN24TPrIR-PE3k05nRP0Uj9Em40N318A>
    <xmx:l0Z0YKnyc4fn6tcs2gVEsA9aAnvrZ541KWkcprPgjUImV165os6Lwg>
    <xmx:l0Z0YHExLSkci2QFwThe0-EIRbZz3xLTkgh3iACoFgOvJrtOLn_KYQ>
    <xmx:mEZ0YJa2z4JJH0lPwCz1ctGNqBWrzA-WJEQYoXkyGUKtLBzx25IzsJCBaTnmtV6v>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9333B24005D;
        Mon, 12 Apr 2021 09:09:42 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id db9db3bc;
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
Subject: [PATCH 4/6] KVM: x86: pass a proper reason to kvm_emulate_instruction()
Date:   Mon, 12 Apr 2021 14:09:35 +0100
Message-Id: <20210412130938.68178-5-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412130938.68178-1-david.edmondson@oracle.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Declare various causes of emulation and use them as appropriate.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 arch/x86/kvm/mmu/mmu.c          | 4 ++--
 arch/x86/kvm/x86.c              | 5 +++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 556dc51e322a..79e9ca756742 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1529,6 +1529,12 @@ extern u64 kvm_mce_cap_supported;
 
 enum {
 	EMULREASON_UNKNOWN = 0,
+	EMULREASON_SKIP,
+	EMULREASON_GP,
+	EMULREASON_IO,
+	EMULREASON_IO_COMPLETE,
+	EMULREASON_UD,
+	EMULREASON_PF,
 };
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 515ff790b7c5..14ddf1a5ac12 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5056,8 +5056,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
 		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
 emulate:
-	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, 0,
-				       insn, insn_len);
+	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type,
+				       EMULREASON_PF, insn, insn_len);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88519bf6bd00..41020eba8e21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6197,7 +6197,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 		emul_type = EMULTYPE_TRAP_UD_FORCED;
 	}
 
-	return kvm_emulate_instruction(vcpu, emul_type, 0);
+	return kvm_emulate_instruction(vcpu, emul_type, EMULREASON_UD);
 }
 EXPORT_SYMBOL_GPL(handle_ud);
 
@@ -9343,7 +9343,8 @@ static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 	int r;
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE, 0);
+	r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE,
+				    EMULREASON_IO_COMPLETE);
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	return r;
 }
-- 
2.30.2

