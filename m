Return-Path: <kvm+bounces-1510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D359F7E86BE
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 891C61F20F2D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1453E47E;
	Fri, 10 Nov 2023 23:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dAzZU6Cd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A033E468
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:42 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4ED3C39
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:41 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afa86b8d66so36474117b3.3
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660541; x=1700265341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oLHGbgMEnF7UGu+6KnCI0TJhWQAK6x2mt0wz6s7ykc4=;
        b=dAzZU6CdykaoHdvYARoV6neDZVvw7hVI4xpMyWN7gM9IWzVKxO3zkFNR6kFkTQfyvq
         uk566WTmbyYGz1Ljxvqph6xCL+KLLH/6Pc5/OKOUonEk1sLodD1LwU2uYSTQ5Flm6Pax
         1bNebUib4UWKL6dqJSWIeUrkdmNToszAAbcGvmeOe7qwkRPgrMbXMeaAlRnsdlJDkJhL
         Klql/IVqWc3zUmXd1nYq1Mup4Yqi3CpqSofs379JcCLQPC+jGGvksi4SHbDJAVLErZ7u
         IeGMavAkJFGf9LtblTyFq5U4B5p+98N736XPDXISA0xIt1XnNF3xF31IqotaPcFuxpqf
         IMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660541; x=1700265341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLHGbgMEnF7UGu+6KnCI0TJhWQAK6x2mt0wz6s7ykc4=;
        b=Jg3y8SzcnXSN7GDpse7vaxpCA/47NYFEcToi2x2RwdWoj6OJGra+8p73CHvt2APSO1
         0bwsX7tPF/hM5hrphN9MCPRp0PK6JvlS48mz6RW3c4CHbpRYREWX46xSkj1k9eCLHBq5
         UZs9i7pba3zgSjADjS0RNBPDRxV2iVEXoh5TxVoC0jzmMWq2gHPQ+3VPhuvZutNvuR+E
         z/tH24mtOIh95E1D6gY2QwYSM4WO0ZDuhW+ALQH+LTI7+Qjap3kigh0uOoyQR2y+W0PA
         dmp2Q30WEiGwoYpCwCTMNuqwCoqW4IgEG/hW39WGrRiMFx1+Ok/bRa5AQm3cAtFIzNMV
         4eew==
X-Gm-Message-State: AOJu0YzYlX0LJiODCGdJIy01unkpX6tumeBGphEZJk5uq64REp6tGCh0
	CRrKUDDhh5LzQpLxW01VmYrR9RFsPfs=
X-Google-Smtp-Source: AGHT+IESTak3Kvc+5R2t9g4ghv/O+uX4mJqcQgiYQ6ovjTnEqtz6DMMF2xAoZX/ZzdZFBnD+aha49EHQq5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a18b:0:b0:5be:94a6:d84b with SMTP id
 y133-20020a81a18b000000b005be94a6d84bmr23544ywg.5.1699660540914; Fri, 10 Nov
 2023 15:55:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:23 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: x86: Avoid double CPUID lookup when updating MWAIT
 at runtime
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
utilize the lookup done for other CPUID.0x1 features.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5cf3d697ecb3..6777780be6ae 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -276,6 +276,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+			cpuid_entry_change(best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr &
+					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	best = cpuid_entry2_find(entries, nent, 7, 0);
@@ -296,14 +301,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
-
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
-		if (best)
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
-	}
 }
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
-- 
2.42.0.869.gea05f2083d-goog


