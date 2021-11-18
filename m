Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B14559D4
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343742AbhKRLQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343737AbhKRLOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:14:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23415C061234;
        Thu, 18 Nov 2021 03:09:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k4so4909890plx.8;
        Thu, 18 Nov 2021 03:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QMJpdANKm3zzFJkHU2o6JES7gSuM78lfiMvwlP1M7hQ=;
        b=TUWpZnMATYowjtDyJrxWeFHWT2q5M+vo43yTHkUrhiwoDJXW4mrtG+HjdXPDpCmSg9
         mGWB8OpUxRGKpkfThcmw9bjL8sVDttRifo3k8EX9RVxrqOyL+2ZYxugqUkYN3sW9FBMa
         kNVq8c0CuylX/c3R/MgOlEMkKGKEK3wnOl15WYOiKpCvajZzamnH45titr/Nn0EzecJD
         vClr/39ocKuc418xN/rL4RnluWYpdlh1WK3IpM1QtVZ6kjshVnm8lTmUzB6TO1bOMutj
         ScljtztudiE9oE7s420Zwri7SvOxYqzTG4hNiznKgA8u9ApaxDo1eoEDmaMrMpepUTfo
         9wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMJpdANKm3zzFJkHU2o6JES7gSuM78lfiMvwlP1M7hQ=;
        b=M92Es7un8Xy1dMftI+kym11vSsPi3QdzSKbm7LPrwwp9B3q5tkDyp/ShsfuLo9sEX9
         xZ96nWutqcESDbfhew5o2eLKRr6vrv8mi6obrxhbCIqrdXqqmNP/mPIAbwxe8TmD2v5D
         9oLwaokQdOdduyxSfP6m/aKDdFoCyMcRtQFy+X6okyR4nvfXIax4IhFs7gTYAKpZ75a8
         PG1xEeFoprbdhD0uKcY4T1vTFz3GcD7MTbN8Z/kGnNaTUX64Raqlavv5+u1gDm/CJ4LO
         ZYIISpAyjjWfG+bWdGL77ajv6ZAm8m+MwOG+WVYJZJvCBi9QWFitOOCuEiIpEDIi27Pf
         DrCA==
X-Gm-Message-State: AOAM530wzcF52v9XBP4Mxvt6UerrD2k7+SE9Y8Vkmt9/V7lrslPo5cmG
        2lYUllHD0G7cAiXjYK59zLY3D9qa6bQ=
X-Google-Smtp-Source: ABdhPJwBg4A8+SJOCWpd/OCKYuMUyZ/P5eh4Q8aP2BtAP4CoEDstpDR0P+Vre9ySD5GxkwR3zVcBAw==
X-Received: by 2002:a17:90a:df01:: with SMTP id gp1mr9389566pjb.28.1637233755578;
        Thu, 18 Nov 2021 03:09:15 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id q13sm3255133pfj.26.2021.11.18.03.09.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:09:15 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/15] KVM: X86: Remove unused declaration of __kvm_mmu_free_some_pages()
Date:   Thu, 18 Nov 2021 19:08:11 +0800
Message-Id: <20211118110814.2568-13-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The body of __kvm_mmu_free_some_pages() has been removed.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4cbb402f5636..eb6ef0209ee6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1760,7 +1760,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
-void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu);
-- 
2.19.1.6.gb485710b

