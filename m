Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7786FB440
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbjEHPr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbjEHPrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:47:47 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA4F6A64
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:47:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50c8d87c775so5660153a12.3
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560846; x=1686152846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJQV64QBH17naeT8eJx/a1qVgb7IkGF2ZlDgCUBkk4s=;
        b=TwbgjZiYe9cpmD+emVUQTuUI8nafgnvS88tLdrHRvPplTOB9nbzzNpH05SryOH0PBJ
         6tqchoL9WCOftm/N3iq+hVKEXA4y6dtBSgC9QpB5vMtL6wb13MkUTNFUxofqx3lhAMYe
         br74B5+2bCVK18QXLsAZgS283moCwRikgwen7WTppS7f+xkjiHX+YfVONd0WtVO4oq3t
         LJMmYDabUtgl7J0aIIDmgb5ZCdiU63jJagTtjoYQKW+3C/04eKL0EDXinu/JN5y1IIuP
         AaagYu9s+/Fvz6pMEJuZEIOwyA2dPVN6wzFFxsQs6ZpSDPHgqNxmYzxbJmHBG7Ffa3Fd
         GG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560846; x=1686152846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJQV64QBH17naeT8eJx/a1qVgb7IkGF2ZlDgCUBkk4s=;
        b=ljjI/V5zEg4n5yZpLgsl5bEBqwRv0RqaTNWgajmdmDbBbBuXCBGIhheudqu/9h8jee
         EG55MEZjR2zgkLMi2kGde/VOt2KVCV66vEcjjX5OvO7+4udbEP3zINKTAo0JxUPuVHJR
         wpS1830xmSqSjp7V82T2RyI4XKgSr+i8CGqAOpnP0V3oiMIlVgsqsCi8j/gVuLe3RkDn
         XfAzIxvOn4JTbzojRP8csQVybYoN/lwtXYU9NVgz/IUdqUjm/1RQ41pCT743lr8vykCJ
         VTkuNcQJ6PlOHyBcA0TBonGj11VR2dy5GmLQrdY7ho5Upc6paNRL7w3u7h18LPdk12n1
         VbJQ==
X-Gm-Message-State: AC+VfDyHJzEhIIc7nxKnLIv558e7dL94Vzq+y21pkhFMCp99j/9G5rXq
        o4saIudPIeYD/GaGmGzejUQr8Q==
X-Google-Smtp-Source: ACHHUZ6bi7QivlhACIL7oOIhZay7sHr9dfOsk9A7F5DJm1wgDJ5xrltXLfX0LARUZwbalbRVxKpvtA==
X-Received: by 2002:a17:907:7fa8:b0:969:8d19:74 with SMTP id qk40-20020a1709077fa800b009698d190074mr1068811ejc.57.1683560845756;
        Mon, 08 May 2023 08:47:25 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm121822ejb.85.2023.05.08.08.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:47:25 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 5.15 8/8] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
Date:   Mon,  8 May 2023 17:47:09 +0200
Message-Id: <20230508154709.30043-9-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154709.30043-1-minipli@grsecurity.net>
References: <20230508154709.30043-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cf9f4c0eb1699d306e348b1fd0225af7b2c282d3 ]

Refresh the MMU's snapshot of the vCPU's CR0.WP prior to checking for
permission faults when emulating a guest memory access and CR0.WP may be
guest owned.  If the guest toggles only CR0.WP and triggers emulation of
a supervisor write, e.g. when KVM is emulating UMIP, KVM may consume a
stale CR0.WP, i.e. use stale protection bits metadata.

Note, KVM passes through CR0.WP if and only if EPT is enabled as CR0.WP
is part of the MMU role for legacy shadow paging, and SVM (NPT) doesn't
support per-bit interception controls for CR0.  Don't bother checking for
EPT vs. NPT as the "old == new" check will always be true under NPT, i.e.
the only cost is the read of vcpu->arch.cr4 (SVM unconditionally grabs CR0
from the VMCB on VM-Exit).

Reported-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lkml.kernel.org/r/677169b4-051f-fcae-756b-9a3e1bb9f8fe%40grsecurity.net
Fixes: fb509f76acc8 ("KVM: VMX: Make CR0.WP a guest owned bit")
Tested-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20230405002608.418442-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>	# backport to v5.15.x
---
- the MMU role wasn't folded into the CPU role yet in this kernel
  version and the "not_smap" handling was done slightly different,
  however, independent of the permission bitmap handling, so refreshing
  the bitmap prior to determining the fault state is still sufficient

 arch/x86/kvm/mmu.h     | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 03a9e37e446a..a3c0dc07fc96 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -76,6 +76,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
@@ -176,6 +178,24 @@ static inline bool is_writable_pte(unsigned long pte)
 	return pte & PT_WRITABLE_MASK;
 }
 
+static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+						    struct kvm_mmu *mmu)
+{
+	/*
+	 * When EPT is enabled, KVM may passthrough CR0.WP to the guest, i.e.
+	 * @mmu's snapshot of CR0.WP and thus all related paging metadata may
+	 * be stale.  Refresh CR0.WP and the metadata on-demand when checking
+	 * for permission faults.  Exempt nested MMUs, i.e. MMUs for shadowing
+	 * nEPT and nNPT, as CR0.WP is ignored in both cases.  Note, KVM does
+	 * need to refresh nested_mmu, a.k.a. the walker used to translate L2
+	 * GVAs to GPAs, as that "MMU" needs to honor L2's CR0.WP.
+	 */
+	if (!tdp_enabled || mmu == &vcpu->arch.guest_mmu)
+		return;
+
+	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
+}
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
@@ -207,8 +227,12 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	unsigned long smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
 	int index = (pfec >> 1) +
 		    (smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
-	bool fault = (mmu->permissions[index] >> pte_access) & 1;
 	u32 errcode = PFERR_PRESENT_MASK;
+	bool fault;
+
+	kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
+
+	fault = (mmu->permissions[index] >> pte_access) & 1;
 
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkru_mask)) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7c3b809f24b3..0e50b4dd01e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4713,6 +4713,21 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	return role;
 }
 
+void __kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
+					struct kvm_mmu *mmu)
+{
+	const bool cr0_wp = !!kvm_read_cr0_bits(vcpu, X86_CR0_WP);
+
+	BUILD_BUG_ON((KVM_MMU_CR0_ROLE_BITS & KVM_POSSIBLE_CR0_GUEST_BITS) != X86_CR0_WP);
+	BUILD_BUG_ON((KVM_MMU_CR4_ROLE_BITS & KVM_POSSIBLE_CR4_GUEST_BITS));
+
+	if (is_cr0_wp(mmu) == cr0_wp)
+		return;
+
+	mmu->mmu_role.base.cr0_wp = cr0_wp;
+	reset_guest_paging_metadata(vcpu, mmu);
+}
+
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
-- 
2.39.2

