Return-Path: <kvm+bounces-1513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8BA7E86C2
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C69F11C20ACA
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0000C3E46E;
	Fri, 10 Nov 2023 23:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HkEaraVM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923403A28D
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:50 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846546AA
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a90d6ab944so36314007b3.2
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660547; x=1700265347; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UULTl/CyX49jqhiU5nSfvUmNnB7m6080sqG/jitSL4w=;
        b=HkEaraVMU8Q1Xv6qlJMKTXr3R1QZdSZDUhjMTeXdlphPZBIvOABKFefoexphcPV207
         9zudU26QRzrrBbtmlGKdI+JM6D06F7Y+bvKH5yqhuE7vBYzfBtuMxgj0w2mxL9R/0crL
         cc6OKPxeYSOb4Z/BC22uLZWRNMRrDYTDxMsO+BPAoJcKdlZnxRP+wRFofkpg0PAyom1U
         rC43d7XjW/6He/+pdX+J9CrJeev5+3YerO020Ywg7q3l9VVbFStsvnGv/xf+lQhd0jE3
         J3RNw+FtKfEDxhudsIsTpiNzCI5zDYqtza1WJRUvzDcZTIJn4CikRmWCKlHAgv5TLGZW
         Ht7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660547; x=1700265347;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UULTl/CyX49jqhiU5nSfvUmNnB7m6080sqG/jitSL4w=;
        b=FG3ZrRQdzrRjuQ+1ZI0wDOECV0f00vktfsDH7X7vaDiRo6tXo50gDbSEzbP8rXBpq2
         FSNlzDHMSaeSDMB+ki3ZOrfIgdkesuNImBAlT0Vzo1m/vhlouyXh0RetsfkbAUjo3WL2
         2BFGYyenN4203uUUyLPIyXS2Abqo4PhkD7atlnl0GDn3f7P+XJnjt/+VgufN0qf46q9R
         MOpp/UXzA2qCtyCguGHE7D6+s4b272klsRQ0+2JZ0RfOSuZPL48DbsOEsqyWT5SrmE2+
         nrG/AFQKVzJRwjsc4XotbKp2v/f1e5kPcCLU2wIRfR0CU14PYA69YAwEMOaRY4qy9Wx7
         9/0g==
X-Gm-Message-State: AOJu0YzfCXAT0J2j0di9ptUX46dI4aZC/wUKqitkKDWNupLbbNZ7rBSW
	UY6xiNQv6CkpTcimkuiGtmA6g+/SNcE=
X-Google-Smtp-Source: AGHT+IEmMZEklqzEl46skV0jCyEKXRJqMj1H5jtFG7Z2uM2pVcO1WJh448Dutk6lRZZB//FZxGGR0+c/Kxk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aba7:0:b0:dae:292e:68de with SMTP id
 v36-20020a25aba7000000b00dae292e68demr16244ybi.6.1699660547065; Fri, 10 Nov
 2023 15:55:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:26 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-8-seanjc@google.com>
Subject: [PATCH 7/9] KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Move the implementations of guest_has_{spec_ctrl,pred_cmd}_msr() down
below guest_cpu_cap_has() so that their use of guest_cpuid_has() can be
replaced with calls to guest_cpu_cap_has().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 1707ef10b269..bebf94a69630 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -163,21 +163,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 	return x86_stepping(best->eax);
 }
 
-static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
-}
-
-static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
-}
-
 static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -298,4 +283,19 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
+static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+}
+
+static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
+}
+
 #endif
-- 
2.42.0.869.gea05f2083d-goog


