Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3997E47A98A
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 13:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhLTMZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 07:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLTMZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 07:25:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A2C061574;
        Mon, 20 Dec 2021 04:25:25 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e3so37580979edu.4;
        Mon, 20 Dec 2021 04:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TMIJnVk4dZLOr0YeCdZ246af/U8JTKTMb6EjWcwUlX8=;
        b=D96VdLW37qOoSccFsxwgyqgKr906TXlxdrxhk2mh/A8O72o+z/bwxVHdXdaPm719wc
         QxmxyuCiY0i7M/ft0Z/4NM2AhtRaEVltvHDuviskO9tJnqkswYJLezNAAn2sFarJNWQT
         Jv9nnYDOpgn+sWFtZseMyMTwuKsXz3IgJZ2bD3B9Z7ZvfEDXUXVCC8bEOGlVTb/8rgjo
         HyXFDzKPHC9p1VpjuyRIcx4CR+98JtluxOqKYwjzLZLWmAIpBqdl/RTMO1BZFTMlFcHl
         mSC8XnOVnQHJslRWIHAE7XgO6VZbSKx2lyz5qdiLLemfmEbjdcQXBlFMWrpfvTTttxi3
         norg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TMIJnVk4dZLOr0YeCdZ246af/U8JTKTMb6EjWcwUlX8=;
        b=DBWzeeoiju4Ac6HlVdT1eFRW8yJ+VjZdkUby6tT5kQCUkSOh7c8Cr4LTxyS8wVBFoC
         uPBbDqwmY3bsvNdozeEuAov60s5hXlqQK4UsLjN6ib6Lzs8OHxCxLDz+8OnYvmdAFqI7
         GZ1I9nl0x3ZRR+IqWgQ6WEM9nmogmrQn7iIVeFSx8w8b07xMxOfjubiEZe2Vl9SThxXZ
         avX+6XKm46sr5URdSxVF2tgtS+460UcFyICBmGT1chzd8xhk6Ja9ncryHwx6j5/ncLlA
         vjIWRBCBkfPpac1o6ATYRA0c228+YDTL3iiGpUz1r5kGfWo62cg+70s3aUJ1V/ZKcfdZ
         9IbQ==
X-Gm-Message-State: AOAM532TXc6V/ffPb9EKvTQuyl2f5AwWIz5Bfto3LdMZttLnR5xhQ245
        Y+ZlXf4ohsMkRdRuC8aXiVw=
X-Google-Smtp-Source: ABdhPJyMZAK5f4qOOQGdvCeaBxuoRUePb/aEH6Ez224wka/aIL9xy0Y4Xxv3fkqjZB75d2YQF47wyA==
X-Received: by 2002:a17:906:31d5:: with SMTP id f21mr13314351ejf.514.1640003123895;
        Mon, 20 Dec 2021 04:25:23 -0800 (PST)
Received: from ubuntu.localdomain ([185.37.253.175])
        by smtp.gmail.com with ESMTPSA id nd23sm5257034ejc.217.2021.12.20.04.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 04:25:23 -0800 (PST)
From:   Quanfa Fu <quanfafu@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Quanfa Fu <quanfafu@gmail.com>
Subject: [PATCH v2] KVM/X86: Remove unneeded variable
Date:   Mon, 20 Dec 2021 20:24:59 +0800
Message-Id: <20211220122459.181542-1-quanfafu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unneeded variable used to store return value.
Replace `gpa >> PAGE_SHIFT` with `gpa_to_gfn(gpa)`

No functional change intended.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Quanfa Fu <quanfafu@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2e1d012df22..61e35170ee2e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2553,16 +2553,13 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa;
-	int r;
 
 	if (vcpu->arch.mmu->direct_map)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
 
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-
-	return r;
+	return kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
 }
 
 static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
-- 
2.25.1

