Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E445C2F8BBF
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 06:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbhAPFw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Jan 2021 00:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPFw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Jan 2021 00:52:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6294FC061757;
        Fri, 15 Jan 2021 21:51:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x18so5807683pln.6;
        Fri, 15 Jan 2021 21:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kJi8OyxBgJcmL4B472BQ0mzfLLWlPkT298GTPpTLjcA=;
        b=MQPEHpzZhuo0F9dqSaZPlcyUZIR0JKOP39ow70obWFY8IaxAwpUeak0QPJmG99bgRJ
         rBS/QfhW9ezk7B7Q8rlaFlsC7t4JRcbTAXzHyhWVztHbkRMzeIRxoYoq6FFfV7hzaNL3
         NaFT/FuuisnGWN59a6PocAnBAAjsd7Us06C1mmnJvMTcNzW9iFcaJsRPTJW+TTL5OLrJ
         EX5155ihjtMLEctBP3CIDAAOsEDzbWd2RlPktF2tRl0tUsaRyq+qc6yzcUU7wN6/fAj9
         QxX/gbPHElc9wBRLoQKA//LMlEyHhMhQAVWrmoHaYHT1jB/g8daOWJZrjkbFj9yBYirc
         zQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kJi8OyxBgJcmL4B472BQ0mzfLLWlPkT298GTPpTLjcA=;
        b=oFZEt4ulZXNuBbYIEhjC7M93B5/fnjBe2u1GByj0lwoVFbHizBMU0A0yLcVUiQ0KRZ
         RFYnHaPB5aOe2njYL8Uqec0ubn3q+Qr4hfgc9kqRfE7b/Hdtk0Vmo7369I1HkPHqylST
         5T4YF1UmaKtXXGGM2OK5nzGObPhLUUE8S8wmk0KHmrR46niBt4dvcAwEiZGV70s7yVMp
         RzlJ87Udm96lS7owPJmn9/VwRYnwZdHGvkvcD9SCEZ7nhO8/RRZideSO9cRgYvY3DAe4
         5UxyGyHHa4mAY/fX/grSlRCRX1xxLTe0tj99AYL6wsI3vbBVh4DryvzryGk3RrbDH5yX
         KogA==
X-Gm-Message-State: AOAM532vwRCN8kHhk3O4o/dFOZlDzxrH6v1WKP9160BQ0SPiK28XU9pl
        ZuvoyfR0FFT98vnOAQtgtab7UoUZ9zB6bdAT
X-Google-Smtp-Source: ABdhPJzpVgI2SDFxZr1C5Lo/baIDflCfeNcbWY7iuaozCumA2ar1xjeb66bG3LuL6byqpTDjxPk/7w==
X-Received: by 2002:a17:90a:13c8:: with SMTP id s8mr14696288pjf.6.1610776305616;
        Fri, 15 Jan 2021 21:51:45 -0800 (PST)
Received: from thinkerpad.loongson.cn ([114.242.206.180])
        by smtp.gmail.com with ESMTPSA id 4sm10242052pjn.14.2021.01.15.21.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:51:44 -0800 (PST)
From:   Cun Li <cun.jia.li@gmail.com>
To:     vkuznets@redhat.com
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cun Li <cun.jia.li@gmail.com>
Subject: [PATCH] KVM: update depracated and inappropriate jump label API
Date:   Sat, 16 Jan 2021 13:50:09 +0800
Message-Id: <20210116055009.118377-1-cun.jia.li@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87h7nn8ke8.fsf@vitty.brq.redhat.com>
References: <87h7nn8ke8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The use of 'struct static_key' and 'static_key_false' is
deprecated. Use the new API.

mmu_audit_key can only be true or false so it would be nice to use
static_branch_enable()/static_branch_disable() for it and not
static_key_slow_inc()/static_key_slow_dec().

Signed-off-by: Cun Li <cun.jia.li@gmail.com>
---
 arch/x86/kvm/lapic.h         | 6 +++---
 arch/x86/kvm/mmu/mmu_audit.c | 8 ++++----
 arch/x86/kvm/x86.c           | 6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

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
index c8d51a37e2ce..df3482784aa5 100644
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
 
@@ -259,7 +259,7 @@ static void mmu_audit_enable(void)
 	if (mmu_audit)
 		return;
 
-	static_key_slow_inc(&mmu_audit_key);
+	static_branch_enable(&mmu_audit_key);
 	mmu_audit = true;
 }
 
@@ -268,7 +268,7 @@ static void mmu_audit_disable(void)
 	if (!mmu_audit)
 		return;
 
-	static_key_slow_dec(&mmu_audit_key);
+	static_branch_disable(&mmu_audit_key);
 	mmu_audit = false;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..6f460c3b8fb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9955,7 +9955,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		if (kvm_apicv_activated(vcpu->kvm))
 			vcpu->arch.apicv_active = true;
 	} else
-		static_key_slow_inc(&kvm_no_apic_vcpu);
+		static_branch_inc(&kvm_no_apic_vcpu);
 
 	r = -ENOMEM;
 
@@ -10084,7 +10084,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
 	if (!lapic_in_kernel(vcpu))
-		static_key_slow_dec(&kvm_no_apic_vcpu);
+		static_branch_dec(&kvm_no_apic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -10339,7 +10339,7 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-struct static_key kvm_no_apic_vcpu __read_mostly;
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_no_apic_vcpu);
 EXPORT_SYMBOL_GPL(kvm_no_apic_vcpu);
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-- 
2.25.1

