Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F216584D9E
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiG2Ip4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiG2Ipw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:45:52 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB94491D8;
        Fri, 29 Jul 2022 01:45:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b133so4068278pfb.6;
        Fri, 29 Jul 2022 01:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3W7hNFmAJEfXBo7DpbR7xQUy/ygc6BlRe7J3ZXgX4QI=;
        b=dQ+W+ksU7zadADK/7nZApQgG6i/N0vxl6+ss4UhEd0mmiBety/RiYD4ooYxZki6WTH
         2yXAO/lJ53RY3/DCRlGkPo9rIl+rjt52iGpRf/VywKr5jHzW1PXQst1+5WPYsz4Fmi/m
         Hl22mON2zMOPH3h9sqw4MNpMesyMFvkrRrfOSmg4juYYqCTXlMhn+zgJXu6T1dQfyP/v
         Y15CTJZnuonWA2r+dYCJV7MF/dUtcvl04HNEK10ensrHTUgzPHuNhF6pKTohsn7kt9Qf
         7Cw43E4+01H6SyCeh9GNMnoA6PRsliOEzwwhKpgZ+Lo70LwN4zh7a+Ws9dbHA2XCf1rC
         NBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=3W7hNFmAJEfXBo7DpbR7xQUy/ygc6BlRe7J3ZXgX4QI=;
        b=wXiDvhnzx8nikFyd/jlZvWi49UzTq/9nEmUEYfMmRFCN0+HbmOuBDf9ceSA7xXLa9h
         htz5FhPWOzuC0FKmVcMWsM9fcDAHk7i6uK792Dvl68SHn+1gLNd2DnROFBHudUzkqRUz
         XZpcZDIVISz4TfkRERJPbRhq3Z+usNPwDXT3aYjx49ko+pgh1Zp48/NNwp6fVcLh8K0L
         mz6VQhVEVbUJH7rLUjcz6CliJ9JFaUJOMYenFySQlLW65H8F8i5JK2sf0LKX34DRMLkk
         BUXGEgWfpWz08ea6w/A7T2pyglZxzNA940OPiyjnI//z+TqYU0PSRrN2D/X8ADT3Wz5W
         ViGg==
X-Gm-Message-State: AJIora/ZLk6uEp2yLhkYNNENCM+k+HvRXGX7jFYneJYZrLCVXdG5UxqV
        dLLZhbr9W60diGMgzQTuTEahpnEvfH0bZA==
X-Google-Smtp-Source: AGRyM1tlKis80ji4ijnWxaVFpz18EUUYJEthu+66QnUQ2I3TAcw2BwX7CuweFy0WxMP394RUW5iEdw==
X-Received: by 2002:a65:6bd6:0:b0:39d:4f85:9ecf with SMTP id e22-20020a656bd6000000b0039d4f859ecfmr2180776pgw.336.1659084350338;
        Fri, 29 Jul 2022 01:45:50 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y11-20020aa793cb000000b0052c89540659sm2208145pff.189.2022.07.29.01.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 01:45:49 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] KVM: x86: do not shadow apic global definition
Date:   Fri, 29 Jul 2022 17:45:33 +0900
Message-Id: <20220729084533.54500-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arch/x86/include/asm/apic.h declares a global variable named `apic'.

Many function arguments from arch/x86/kvm/lapic.h also uses the same
name and thus shadow the global declaration. For each case of
shadowing, rename the function argument from `apic' to `lapic'.

This patch silences below -Wshadow warnings:

| In file included from arch/x86/kernel/../kvm/vmx/capabilities.h:7,
|                  from arch/x86/kernel/../kvm/vmx/vmx.h:10:
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'kvm_lapic_set_irr':
| arch/x86/kernel/../kvm/vmx/../lapic.h:143:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   143 | static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
|       |                                               ~~~~~~~~~~~~~~~~~~^~~~
| In file included from ./arch/x86/include/asm/kvm_host.h:29,
|                  from ./include/linux/kvm_host.h:45:
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'kvm_lapic_get_reg':
| arch/x86/kernel/../kvm/vmx/../lapic.h:158:55: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   158 | static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
|       |                                     ~~~~~~~~~~~~~~~~~~^~~~
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'kvm_apic_hw_enabled':
| arch/x86/kernel/../kvm/vmx/../lapic.h:174:57: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   174 | static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
|       |                                       ~~~~~~~~~~~~~~~~~~^~~~
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'kvm_apic_sw_enabled':
| arch/x86/kernel/../kvm/vmx/../lapic.h:183:58: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   183 | static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
|       |                                        ~~~~~~~~~~~~~~~~~~^~~~
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'apic_x2apic_mode':
| arch/x86/kernel/../kvm/vmx/../lapic.h:200:54: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   200 | static inline int apic_x2apic_mode(struct kvm_lapic *apic)
|       |                                    ~~~~~~~~~~~~~~~~~~^~~~
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~
| arch/x86/kernel/../kvm/vmx/../lapic.h: In function 'kvm_xapic_id':
| arch/x86/kernel/../kvm/vmx/../lapic.h:249:49: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
|   249 | static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
|       |                               ~~~~~~~~~~~~~~~~~~^~~~
| ./arch/x86/include/asm/apic.h:357:21: note: shadowed declaration is here
|   357 | extern struct apic *apic;
|       |                     ^~~~

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 arch/x86/kvm/lapic.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 117a46df5cc1..55abd5e22462 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -156,14 +156,14 @@ static inline void kvm_lapic_set_vector(int vec, void *bitmap)
 	set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
+static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *lapic)
 {
-	kvm_lapic_set_vector(vec, apic->regs + APIC_IRR);
+	kvm_lapic_set_vector(vec, lapic->regs + APIC_IRR);
 	/*
 	 * irr_pending must be true if any interrupt is pending; set it after
 	 * APIC_IRR to avoid race with apic_clear_irr
 	 */
-	apic->irr_pending = true;
+	lapic->irr_pending = true;
 }
 
 static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
@@ -171,9 +171,9 @@ static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
 	return *((u32 *) (regs + reg_off));
 }
 
-static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
+static inline u32 kvm_lapic_get_reg(struct kvm_lapic *lapic, int reg_off)
 {
-	return __kvm_lapic_get_reg(apic->regs, reg_off);
+	return __kvm_lapic_get_reg(lapic->regs, reg_off);
 }
 
 DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
@@ -187,19 +187,19 @@ static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 
 extern struct static_key_false_deferred apic_hw_disabled;
 
-static inline int kvm_apic_hw_enabled(struct kvm_lapic *apic)
+static inline int kvm_apic_hw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_branch_unlikely(&apic_hw_disabled.key))
-		return apic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
+		return lapic->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
 	return MSR_IA32_APICBASE_ENABLE;
 }
 
 extern struct static_key_false_deferred apic_sw_disabled;
 
-static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
+static inline bool kvm_apic_sw_enabled(struct kvm_lapic *lapic)
 {
 	if (static_branch_unlikely(&apic_sw_disabled.key))
-		return apic->sw_enabled;
+		return lapic->sw_enabled;
 	return true;
 }
 
@@ -213,9 +213,9 @@ static inline int kvm_lapic_enabled(struct kvm_vcpu *vcpu)
 	return kvm_apic_present(vcpu) && kvm_apic_sw_enabled(vcpu->arch.apic);
 }
 
-static inline int apic_x2apic_mode(struct kvm_lapic *apic)
+static inline int apic_x2apic_mode(struct kvm_lapic *lapic)
 {
-	return apic->vcpu->arch.apic_base & X2APIC_ENABLE;
+	return lapic->vcpu->arch.apic_base & X2APIC_ENABLE;
 }
 
 static inline bool kvm_vcpu_apicv_active(struct kvm_vcpu *vcpu)
@@ -262,9 +262,9 @@ static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 	return apic_base & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE);
 }
 
-static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
+static inline u8 kvm_xapic_id(struct kvm_lapic *lapic)
 {
-	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
+	return kvm_lapic_get_reg(lapic, APIC_ID) >> 24;
 }
 
 #endif
-- 
2.35.1

