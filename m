Return-Path: <kvm+bounces-5969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFA082921B
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B6651F26B35
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363BA137E;
	Wed, 10 Jan 2024 01:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ccVJjRaF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA0DDAE
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e8d966fbc0so40394727b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704850036; x=1705454836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KWtjxcr+sKa83fwm9XKbhXp8mShZD+B5e+jlbLU3DeA=;
        b=ccVJjRaFTBIbpymyx7OVq27nXMk8/0OJ2Sc6lwat/YpE4VDQtqKqQNaMmjGUlLLtPd
         1PU4P48OjsFL6QKX0/Kk1dGySee7Chk8FEyhTgYqntcD2GVhwFcpRfX8ua50kXAr3qzx
         +jn6LTGqBK1iQplCi3HGbYUPG9WAqt4+NkdjYQMnLoo5NIy4UWqs5W/wTaaCgSJ/eOkp
         bWLu/u0uTRMjshv5FA06ryIZt4OAIVJGkK8he7BsFV+t4UH71q2igLimZ/90Xuvigd6S
         lo5xr8JnsNr0gUYTjUprK8MaN8dHMkCdv5J73R8na4J1lr6vf0X3URclJKUTn9LwFrPU
         MzSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850036; x=1705454836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWtjxcr+sKa83fwm9XKbhXp8mShZD+B5e+jlbLU3DeA=;
        b=fgvSkohmdjplGVuaxvBhPoxtb8Kvjyc8pZj7/MGzf7r9K36LtWSq/FeAQLBZo8xX4h
         sHkpIj7mCbM6BKzdk+oUvVFstYPwCACnVS+TBwG2y5amDvXCiGANoVFK7EYAAHdkAIkj
         sRCQ171pzFm5Vr6PsP6WFdyG9snViACYLZS+cOPCGkJm8MTQQMjiFTWuo+evnOMZ4Rut
         k2m6rEQuWZze7JA+K40hP45ZFEO8MLCwegZ8SQKXENOK16SYrqMUCLLWNJcoiRaWhvfe
         1XRQGrLnjBU8mLdlt99z0g1j8m8aCv6PdmisUnxbJAhNAFod2Dwfp2c3TjDkSviy24ZA
         TgUQ==
X-Gm-Message-State: AOJu0YySsThWkmcWylUnryvKHEPFIEHoG+jdGyU8Zen15ZE4Xnl1jq7k
	cLYOFVrE43nsSCIY0/jyVWVLFC9bYgrYMUrE9w==
X-Google-Smtp-Source: AGHT+IFcAWQuBc3tZqBZxZIOMH1LF2jE9lNRYGm7n/qlagDrLr0lHXn2P3l8tjHdwxamBYe1l5cex6xTw4k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:f00d:0:b0:5f0:92a1:18b2 with SMTP id
 p13-20020a81f00d000000b005f092a118b2mr577842ywm.2.1704850036153; Tue, 09 Jan
 2024 17:27:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:27:03 -0800
In-Reply-To: <20240110012705.506918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012705.506918-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012705.506918-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86: Move handling of is_guest_mode() into fastpath
 exit handlers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Let the fastpath code decide which exits can/can't be handled in the
fastpath when L2 is active, e.g. when KVM generates a VMX preemption
timer exit to forcefully regain control, there is no "work" to be done and
so such exits can be handled in the fastpath regardless of whether L1 or
L2 is active.

Moving the is_guest_mode() check into the fastpath code also makes it
easier to see that L2 isn't allowed to use the fastpath in most cases,
e.g. it's not immediately obvious why handle_fastpath_preemption_timer()
is called from the fastpath and the normal path.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 6 +++---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f5f3301d2a01..c32576c951ce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4092,6 +4092,9 @@ static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
 	    to_svm(vcpu)->vmcb->control.exit_info_1)
 		return handle_fastpath_set_msr_irqoff(vcpu);
@@ -4238,9 +4241,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 
 	svm_complete_interrupts(vcpu);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return svm_exit_handlers_fastpath(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c4a10d46d7a8..a602c5b52c64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7217,6 +7217,9 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	switch (to_vmx(vcpu)->exit_reason.basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
@@ -7428,9 +7431,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
-	if (is_guest_mode(vcpu))
-		return EXIT_FASTPATH_NONE;
-
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.43.0.472.g3155946c3a-goog


