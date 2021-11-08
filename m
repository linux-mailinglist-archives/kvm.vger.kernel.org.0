Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6633447FA3
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhKHMrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbhKHMrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:47:22 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E3C061714;
        Mon,  8 Nov 2021 04:44:38 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n8so15719385plf.4;
        Mon, 08 Nov 2021 04:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zRUfb/3+n4txROifqZnPMWD7jD3Jwrb0pGPJoTs4U1E=;
        b=R/LjmUf7ZtvWkjtPcKo0z8b1EfUP1fC0HAlDh45bUwoIaZTKbUwROxcrhOPrFroyxF
         CRO797xKq2PavRMmkMIqbc99SHvO/TiaLfqF9hm0X6yNEFTEA5hYSDux/bNKdYI45K2+
         YTk5pTzD/rLxBC8+QlhDPC5QB4W1eTfo2MYqKts74T9HJ7SUoN2hnmSE0fgYkvKqigu5
         8KqcsCLg9tVqfUl/gdaDA4IQEF7b7QOu5/+W4khUbzOfKa2/lWc63r3+NlJPCfLiz8/z
         ew+C1cPHoQJDlvsyfGvW0ByEHWvKLS9nFqOEfpc64Ngo6/gPXaUU6tBNIRnBLIyCqtda
         jL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zRUfb/3+n4txROifqZnPMWD7jD3Jwrb0pGPJoTs4U1E=;
        b=yI2cRO8ohqrNC4kn/2lKtNf/t5IRpamGX32KQJBciDFkL09Mmgz9rZN7q3ZfpWGqi0
         lmNWlNBYEd6hf7Ot4SnLsNOs2+95obO3Fp305jUzfnoHesyC3a07TNzfvlK4JdOlWVKz
         PIYywbExIozxbW26T2dmnE/pp5nJmJnHs0Xt31gZ/8tUj187KKUbv/iYmyiT4Wl+yGPu
         wP7338KG06y/uUVaXhdGOCJLY7pSlzJ6MK9gYvf1fiO3kzYgzakW4WyVgPKvBndV40c2
         +rddqoCgUHVuHjfcXop29cUOn5X9m9fvlHGekIz6yP7DjpeowmiOuZlNSHcmMV00gp7c
         J/nw==
X-Gm-Message-State: AOAM531ziRiQRw5tZ++Td9sBLWAjDcc88ZhP3OWzKHAfk+7i+baHaG2/
        kbHH4GNu6Urz5hg8WKRONCXcrb56RiA=
X-Google-Smtp-Source: ABdhPJwdRk4VpIam22mSI0kPqvhTvJ3rEsCCtAsbqOrakl1pRJEHDeA4ulKNu6yJzZ0t9P58vRs9OA==
X-Received: by 2002:a17:902:b209:b0:141:a755:79de with SMTP id t9-20020a170902b20900b00141a75579demr64101844plr.7.1636375478008;
        Mon, 08 Nov 2021 04:44:38 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id i2sm7742696pfe.70.2021.11.08.04.44.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:44:37 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 05/15] KVM: VMX: Add and use X86_CR4_PDPTR_BITS when !enable_ept
Date:   Mon,  8 Nov 2021 20:43:57 +0800
Message-Id: <20211108124407.12187-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In set_cr4_guest_host_mask(), all cr4 pdptr bits are already set to be
intercepted in an unclear way.

Add X86_CR4_PDPTR_BITS to make it clear and self-documented.

No functionality changed.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 1 +
 arch/x86/kvm/vmx/vmx.c        | 4 +++-
 arch/x86/kvm/x86.c            | 4 +---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 8fe036efa654..592f9eb9753b 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -10,6 +10,7 @@
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
 #define X86_CR4_TLB_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
+#define X86_CR4_PDPTR_BITS (X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_SMEP)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1795702dc6de..d94e51e9c08f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4106,8 +4106,10 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 
 	vcpu->arch.cr4_guest_owned_bits = KVM_POSSIBLE_CR4_GUEST_BITS &
 					  ~vcpu->arch.cr4_guest_rsvd_bits;
-	if (!enable_ept)
+	if (!enable_ept) {
 		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_TLB_BITS;
+		vcpu->arch.cr4_guest_owned_bits &= ~X86_CR4_PDPTR_BITS;
+	}
 	if (is_guest_mode(&vmx->vcpu))
 		vcpu->arch.cr4_guest_owned_bits &=
 			~get_vmcs12(vcpu)->cr4_guest_host_mask;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 034c233ea5a1..b92d4241b4d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1052,8 +1052,6 @@ EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
-	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
-				   X86_CR4_SMEP;
 
 	if (!kvm_is_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1064,7 +1062,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		if ((cr4 ^ old_cr4) & X86_CR4_LA57)
 			return 1;
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
-		   && ((cr4 ^ old_cr4) & pdptr_bits)
+		   && ((cr4 ^ old_cr4) & X86_CR4_PDPTR_BITS)
 		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
 				   kvm_read_cr3(vcpu)))
 		return 1;
-- 
2.19.1.6.gb485710b

