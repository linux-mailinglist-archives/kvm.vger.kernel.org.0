Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C416FB456
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbjEHPt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjEHPtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:49:10 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39439AD35
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:48:50 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9661a1ff1e9so338464866b.1
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683560906; x=1686152906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTjF2g8AG30VF1JiAmV3qLANPxqhYhgw+CZ7n5LpFOg=;
        b=npzr5E2AtlhYYeRtRhD0GNjc8RuIDXcv9/wHRfDCdHBanmUNxMznH5ijmT5HIBAEMq
         Hn6r26T/BY95aVHlgvam6U65zD1eYeoQvid2Zwl6Bx5xrXAE0eKycCsqrPMUBxybUfhg
         HaBlmIJGM4H34OOfPWCufg/sFhjni0PnITeO+1XYoCCEr5xSsx7WHjm56jRcP780xAoE
         queTy38rgdyqgdYjrwGuUBR9L+VvNnNKm2rCqAw3p5tZMn5AIbupOcVCaDpcgHncWeW0
         nRme13uvCa5ofTAnP2k/v3elpdjZ2rI8fsFtkUK+84Acko/3wxC28tUYdJpIV3Xi7+Sq
         zmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683560906; x=1686152906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TTjF2g8AG30VF1JiAmV3qLANPxqhYhgw+CZ7n5LpFOg=;
        b=iDQqvmN5kd38jVRmjV19GqRXa1uTakCbsGIYt7W4wT+hqnx1SCN1cJkeH+Fm5uie2h
         NLRiyjqaFcfx8jhozhei1QaMoK17A+bbS04e/GRIGXKN/quj69uYY+P8Gmh/TpGgkJ7R
         gly2z+6GpnDqsm4XEmEo+1cgj/cyGQ4luxamB6wb/hD+Yd0odIy1cJAPEDAl19OlyBJY
         F4LHPQmze/2Y49PhTDQJIimyssFBhOuvbY+7/dOXo9zRek0otIVHNlDRHLDZ27iDfqO6
         PzoOTbGQgVxkPMulMU5R549nuWrYfP6YD53uNGh7ILqdgFWhRuttZTIW4KPulkoX3Qkr
         Erjg==
X-Gm-Message-State: AC+VfDyIbIlN/mW9+S6RMZObfCs2PtyVu0+fON535Mp+R1Yf29xlrN/p
        kyJe0QD1Vg6G0MxE6AteekASOw==
X-Google-Smtp-Source: ACHHUZ4HkxXAZofVoOxKX0VjlGu4xRFEy3ypDBB/+2Zm5Dltwz14RJuPJeiJuzPpdUFAhb+bzZDyxQ==
X-Received: by 2002:a17:907:743:b0:94e:e574:6021 with SMTP id xc3-20020a170907074300b0094ee5746021mr8902153ejb.7.1683560906028;
        Mon, 08 May 2023 08:48:26 -0700 (PDT)
Received: from localhost.localdomain (p549211c7.dip0.t-ipconnect.de. [84.146.17.199])
        by smtp.gmail.com with ESMTPSA id k21-20020a170906055500b009584c5bcbc7sm126316eja.49.2023.05.08.08.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 08:48:25 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 5.10 09/10] KVM: x86/mmu: Reconstruct shadow page root if the guest PDPTEs is changed
Date:   Mon,  8 May 2023 17:48:03 +0200
Message-Id: <20230508154804.30078-10-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
References: <20230508154804.30078-1-minipli@grsecurity.net>
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

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 6b123c3a89a90ac6418e4d64b1e23f09d458a77d ]

For shadow paging, the page table needs to be reconstructed before the
coming VMENTER if the guest PDPTEs is changed.

But not all paths that call load_pdptrs() will cause the page tables to be
reconstructed. Normally, kvm_mmu_reset_context() and kvm_mmu_free_roots()
are used to launch later reconstruction.

The commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
load_pdptrs() when rewriting the CR3 with the same value.

The commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Guests like linux would keep the PDPTEs unchanged for every instance of
pagetable, so this missing reconstruction has no problem for linux
guests.

Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211216021938.11752-3-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 038ac5bbdd19..065e1a5b3b94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -792,6 +792,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	}
 	ret = 1;
 
+	/*
+	 * Marking VCPU_EXREG_PDPTR dirty doesn't work for !tdp_enabled.
+	 * Shadow page roots need to be reconstructed instead.
+	 */
+	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
+		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
+
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
-- 
2.39.2

