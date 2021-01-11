Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AAE2F199B
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 16:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbhAKP0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 10:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbhAKP0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 10:26:13 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA678C061786;
        Mon, 11 Jan 2021 07:25:33 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id h10so98806pfo.9;
        Mon, 11 Jan 2021 07:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hOSDGgkDnFPvYf9DJjuBTyvbvtjcYcDYsmPDVQCkDg=;
        b=UYN45O/J9mSramH9w5A9EwdD7SdqZrbkVsBvZHKdukFzZvoUQ8NPzR3XFh3mGR6z/i
         B7MEu+YU/RyTVyS2oLtsnq1SGSadC/KQxyEmWOxSQVu7kwuE+yHnjmetvc3GNZvCyDPv
         CU6HoCkun1F1Hz7vQL9wTCSn2HZHSOnLGTKTSrrwxUtxhk6Sg9DG8uG2VWNZMwilGTdi
         lWfgz6f4HDziUBO+AQOhQPhbmc/6jIxd/Eczybx2eB22l5YjXA1ps+JNZ3jwq3eR1vhj
         lebnTVdPunwuctwSPFzlY9/fn7XFUHfkBM0ZswUU2bGLq3x0XiSlp5aU0J/YerYb8kVA
         wK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hOSDGgkDnFPvYf9DJjuBTyvbvtjcYcDYsmPDVQCkDg=;
        b=F8wqvrn5KsA5ckC3pxH12Ls7F0rQLJTUynfKL+LD7oXiG+OT0sQ8+D8qOfYrv4GH02
         dNSd0zl3JN0D5Rn9YIt7toolkQ/JNLaMUiOCXK/imDNUVqmp3kzt/Zxh1Bc9NU2P4o26
         2oqEv6ePSmdvw4HpWxmYy2nRdO5sRuyb65OiMsnkH0ejfPhWacZKE/Coy8H2H/PrqvZp
         /iNyYW4VXUSxmTbvsf29WzR0oGCgXKxYGNDMxrh3TWNsUH/SYmm8/MwFLG8b3S2O+0MT
         gmXMs1RK3Xjcm1FCv48IGoIOA+56UayurdjERFknOWixwE5+nFsW0LsykM0GRvQBWWB0
         IDXA==
X-Gm-Message-State: AOAM5313q4DUdzmYd5sIGJsJJoPPVoCzKp3wAXauy+dSadayAtscyhF1
        t3AK7Su9vqc42lHRyrNOeR8YfdUDU2k6cjiFmHw=
X-Google-Smtp-Source: ABdhPJzMtPA8XCAbsqXwOgxYVDFx82LNqlBqMJ08fv6H1UuzMk2ut3SjFMdj2C+USgOUZlnP3Y7A2A==
X-Received: by 2002:a62:5e44:0:b029:1a4:daae:e765 with SMTP id s65-20020a625e440000b02901a4daaee765mr16733227pfb.8.1610378733172;
        Mon, 11 Jan 2021 07:25:33 -0800 (PST)
Received: from localhost.localdomain ([117.136.0.45])
        by smtp.gmail.com with ESMTPSA id h17sm18791126pfo.220.2021.01.11.07.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:25:32 -0800 (PST)
From:   Cun Li <cun.jia.li@gmail.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cun Li <cun.jia.li@gmail.com>
Subject: [PATCH] KVM: update depracated jump label API
Date:   Mon, 11 Jan 2021 23:24:35 +0800
Message-Id: <20210111152435.50275-1-cun.jia.li@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The use of 'struct static_key' and 'static_key_false' is
deprecated. Use the new API.

Signed-off-by: Cun Li <cun.jia.li@gmail.com>
---
 arch/x86/kvm/lapic.h         | 6 +++---
 arch/x86/kvm/mmu/mmu_audit.c | 4 ++--
 arch/x86/kvm/x86.c           | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4fb86e3a9dd3..b7aa76e2678e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -176,7 +176,7 @@ extern struct static_key kvm_no_apic_vcpu;
 
 static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 {
-	if (static_key_false(&kvm_no_apic_vcpu))
+	if (static_branch_unlikely(&kvm_no_apic_vcpu))
 		return vcpu->arch.apic;
 	return true;
 }
@@ -185,7 +185,7 @@ extern struct static_key_deferred apic_hw_disabled;
 
 static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
 {
-	if (static_key_false(&apic_hw_disabled.key))
+	if (static_branch_unlikely(&apic_hw_disabled.key))
 		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 	return MSR_IA32_APICBASE_ENABLE;
 }
@@ -194,7 +194,7 @@ extern struct static_key_deferred apic_sw_disabled;
 
 static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
 {
-	if (static_key_false(&apic_sw_disabled.key))
+	if (static_branch_unlikely(&apic_sw_disabled.key))
 		return apic->sw_enabled;
 	return true;
 }
diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index c8d51a37e2ce..8a4b3510151a 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -234,7 +234,7 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
 }
 
 static bool mmu_audit;
-static struct static_key mmu_audit_key;
+static DEFINE_STATIC_KEY_FALSE(mmu_audit_key);
 
 static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
@@ -250,7 +250,7 @@ static void __kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 
 static inline void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
 {
-	if (static_key_false((&mmu_audit_key)))
+	if (static_branch_unlikely((&mmu_audit_key)))
 		__kvm_mmu_audit(vcpu, point);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..b8c05ef26942 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10339,7 +10339,7 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-struct static_key kvm_no_apic_vcpu __read_mostly;
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_no_apic_vcpu);
 EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-- 
2.25.1

