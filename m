Return-Path: <kvm+bounces-5970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1010829220
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C3D31F26B97
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71823C464;
	Wed, 10 Jan 2024 01:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ag7RqRUc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F15DF6B
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso4634744276.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704850038; x=1705454838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k0JgZYlV862UBpJdBl46NmXu7uSEFhCrwQYmZnAf8Ko=;
        b=Ag7RqRUc4WvdQUfp0Zu2M2XGRCxv6mklAK9WArWJoF3XuN+5/Y90Q74X1/NXP5JpDn
         yCgZ6k80Y14eo8C87Q0ta5OmRin+HKHH0FxNjWpCbPcqCg+CopN8tPIJXPoHeWB7gPry
         xv/7mp59bUvjr/4ADCteJqnhCbJH6j0c9cjDxCRfUdvGSJvIFbJSfenGIn+cDqzM7231
         KAyfph4Qd9bYOvFrGVis9FJgArNLuClifd5c0QcfrajRkDkfZk0djFibVzCvXOl5Gb1I
         i5/gBCBV8lb58vPbbrWOSAHcHGTxiouRSdjggkZXIPG9uJIvljuePUV6IKqtxJmMFZXI
         WFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850038; x=1705454838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k0JgZYlV862UBpJdBl46NmXu7uSEFhCrwQYmZnAf8Ko=;
        b=Hp5sGbS1qKsw5YbWF1mssQtVNzItuI5vjLrFBuOtEt8ka1QnBBwN9YjCK3s0w5U1Xp
         dGnDgc0X7knm1ZNdiS/mLPcsDO3AxfUKVW0L+9GdAv1NKX707HGP6uMqWalOYneHRfaj
         ZpkM/iLi6vPMY9Gnobeg60j4JJwkjpRwpy7N5IMKmZXvPzjCcf/ap0+x9Gnp/F8vwfRF
         bHPITEsxdDjIlpBuJBojwLv7dcbbfroa+T/I/5JZyVXXrCMq+wyTFRwxugD9vMUQCIBH
         6oMwVnpgDJ24VsiGKQmtuwvstPwefIrk29Y//MTkfK5asHhy1rhoKsOGH27dK6Vj1dVL
         1ldQ==
X-Gm-Message-State: AOJu0Yy6Nz8jDF2tJE7xCdEoY2cxqyaDpQVJNnj61BkUGVrJ3bOy4mwz
	qM4F13WljoOd/EFzpkhBD0rh15/jmJedc5rkNA==
X-Google-Smtp-Source: AGHT+IGWAcwjVR8XpeKCAnAGeisfwwzsu3mhpl/Ax5HkJqILeyjO1rCYv1Byr1KFDJNIOUptBvRBQZBeXds=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8142:0:b0:dbd:ae61:8dd2 with SMTP id
 j2-20020a258142000000b00dbdae618dd2mr98656ybm.4.1704850037937; Tue, 09 Jan
 2024 17:27:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:27:04 -0800
In-Reply-To: <20240110012705.506918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012705.506918-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012705.506918-6-seanjc@google.com>
Subject: [PATCH 5/6] KVM: VMX: Handle KVM-induced preemption timer exits in
 fastpath for L2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Eat VMX treemption timer exits in the fastpath regardless of whether L1 or
L2 is active.  The VM-Exit is 100% KVM-induced, i.e. there is nothing
directly related to the exit that KVM needs to do on behalf of the guest,
thus there is no reason to wait until the slow path to do nothing.

Opportunistically add comments explaining why preemption timer exits for
emulating the guest's APIC timer need to go down the slow path.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a602c5b52c64..14658e794fbd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6010,13 +6010,26 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	if (vmx->req_immediate_exit)
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
+	/*
+	 * If L2 is active, go down the slow path as emulating the guest timer
+	 * expiration likely requires synthesizing a nested VM-Exit.
+	 */
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	kvm_lapic_expired_hv_timer(vcpu);
 	return EXIT_FASTPATH_REENTER_GUEST;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	handle_fastpath_preemption_timer(vcpu);
+	/*
+	 * This non-fastpath handler is reached if and only if the preemption
+	 * timer was being used to emulate a guest timer while L2 is active.
+	 * All other scenarios are supposed to be handled in the fastpath.
+	 */
+	WARN_ON_ONCE(!is_guest_mode(vcpu));
+	kvm_lapic_expired_hv_timer(vcpu);
 	return 1;
 }
 
@@ -7217,7 +7230,12 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
+	/*
+	 * If L2 is active, some VMX preemption timer exits can be handled in
+	 * the fastpath even, all other exits must use the slow path.
+	 */
+	if (is_guest_mode(vcpu) &&
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_PREEMPTION_TIMER)
 		return EXIT_FASTPATH_NONE;
 
 	switch (to_vmx(vcpu)->exit_reason.basic) {
-- 
2.43.0.472.g3155946c3a-goog


