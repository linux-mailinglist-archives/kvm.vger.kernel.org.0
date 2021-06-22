Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762ED3B0BF8
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhFVSAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhFVSAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:24 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC8C06175F
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:08 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id f11-20020a056214164bb029026bc7adaae8so12449007qvw.2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aT64cUHXT6dp41D10XTHz8018dt0NmEcWWEMJr3d1uw=;
        b=v51wOygFZrNku7rVxKLTi0sdbT8P6eE9TRRoSpgd9idvUUeZzScIheIG3y9gBe97Em
         rb+mUSN0c1WFJyrdnjV+RIZYptSeavZ/B3zZ0H3e7vqroQ1owEp0wlMwGcunpDW8zKpP
         qKlPqDIODviw+R4hiV2F5HvqsNDcDDoiarAtZzDYCgW8Z+iNu1K+U/VXNDWvlm6/r2Rr
         aFFxrGOld5R/e6JH8Jk1OSWj9m1vQ5bvzdSd8x5yQZmMUa2o81+0Qq5z614QOty+TlGk
         0Dkz9cNdrj5djFlcP4M39aO9X3YCCFkjxgYA6bwAg7h3WIeHfvhQ029xhgc03g4LPRkO
         PkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aT64cUHXT6dp41D10XTHz8018dt0NmEcWWEMJr3d1uw=;
        b=GLIr6/cDFw6N0n87RCVOAo1KMq+//m7IkA+8kBgXtLD7qUw8OT/25xC88oU02PRgG5
         uSDDAOEHFXCRdkA3K8r3jCSifxFSZmTK8HOU81hhFlsozF6s/LWnpVNZj8uqceQTe6G4
         0yDt/bb7NI4ktfyMCGPCGVXpExY4HNtAPCEGiDYGbts8J5HOlVZarz0u1e0fT/D8nrl3
         gO0Ptkogk5kQrClTQV6RjCt2+SvOLBB/Y6mVXpiYSaGihERTt0yB/HyrcZSAfncWf8jC
         ZsObtDqiIyoVefHILI6cjzbJAZXzGmYsFxMCXLry1l+UiyU2u2fDktTHw24vNVTGgibt
         Mjiw==
X-Gm-Message-State: AOAM530IDRm/i2l51+5kToUnQLdilyIjDcpxvIRfOE7lp7ayteMuoYhG
        NV30CTIgo2OHkWTmux375gpaXe2dHog=
X-Google-Smtp-Source: ABdhPJwwAwFbfISpq/EYG7173lVaWK9r9UnVQlH1SZxJ8QnY5vnyH2+2J1GpKrB3vtZjR4v64KEISAlRCsg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:c6cb:: with SMTP id k194mr6257503ybf.286.1624384687156;
 Tue, 22 Jun 2021 10:58:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:50 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 05/54] Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57
 hack"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore CR4.LA57 to the mmu_role to fix an amusing edge case with nested
virtualization.  When KVM (L0) is using TDP, CR4.LA57 is not reflected in
mmu_role.base.level because that tracks the shadow root level, i.e. TDP
level.  Normally, this is not an issue because LA57 can't be toggled
while long mode is active, i.e. the guest has to first disable paging,
then toggle LA57, then re-enable paging, thus ensuring an MMU
reinitialization.

But if L1 is crafty, it can load a new CR4 on VM-Exit and toggle LA57
without having to bounce through an unpaged section.  L1 can also load a
new CR3 on exit, i.e. it doesn't even need to play crazy paging games, a
single entry PML5 is sufficient.  Such shenanigans are only problematic
if L0 and L1 use TDP, otherwise L1 and L2 share an MMU that gets
reinitialized on nested VM-Enter/VM-Exit due to mmu_role.base.guest_mode.

Note, in the L2 case with nested TDP, even though L1 can switch between
L2s with different LA57 settings, thus bypassing the paging requirement,
in that case KVM's nested_mmu will track LA57 in base.level.

This reverts commit 8053f924cad30bf9f9a24e02b6c8ddfabf5202ea.

Fixes: 8053f924cad3 ("KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e11d64aa0bcd..916e0f89fdfc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -320,6 +320,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0db12f461c9d..5024318dec45 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4537,6 +4537,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
-- 
2.32.0.288.g62a8d224e6-goog

