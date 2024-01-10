Return-Path: <kvm+bounces-5967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B37B0829212
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE85228A1B1
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2120879C5;
	Wed, 10 Jan 2024 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s54wu1cp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E48A3FEF
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdfa8dea37so3143725a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704850031; x=1705454831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uDSz3XZTGTdHd1XB0ese2a/q6yXzymb/AuDVpe3xIZo=;
        b=s54wu1cplNOmeztAv3PiqSXXjaJhFWU2OATKw9nQPrE3+0VGE9buzjDfBEGaAzTKzM
         13VWBYZoIvqyoqqe5yYLk71I4LJpTwYFVDbezEyYoEXPev/obiugqYwWl7MKhawmPGqe
         8BztRfX5OSuN+NaxvFdHRA4HIoi0dHrfW7DFhlb34ZB9IHqxxLpYijqeqxy1E0lbV1ns
         46+IH+JlJrtb7uaydSL0Lya2MXak9sU/ep1kA83pO+H7d8nfNBIrC0Xvb+adue4qV+u/
         rCacMQhq/UkVSFkt7gHJk6Daa519JHgxlhIWNBQjfID4xzzEp39KC/rB52vUI38zyd2Y
         4WFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850031; x=1705454831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDSz3XZTGTdHd1XB0ese2a/q6yXzymb/AuDVpe3xIZo=;
        b=ruONG4SEL9p0y0UULk4J/iBkP0jE12eNTqVh9nT1GsvlwEDwkYW3OJmwtgLt3aSlWt
         Ax5gnNdyYFZ/E5Vtw4CgQl5eFx9pNdH1SaNu93O8PNgq7Cc4w3VSnhA4zb0kP/DpKT0o
         0ouNZsH+sLVajGQS439k8EniiuhICH7QStFdjIr1RBsz6UQEuDiAl9XakuZvF8kACMeu
         iPNY6almxXhMvMITObCmb/HohNHgCCn3e2tKQD9Wi63bg1ePbzuUrsQW8Y4x/8MVgNiA
         ocVGYTaIug2I2FTlbVaF+AiLIDR7E7T1CHbDZzoqJc6A2MyQhbQ+70Gp8OqWuRtdf1kw
         jlag==
X-Gm-Message-State: AOJu0YwqpbC/HmSCLLzyTqJ5AwvjH2ji6iyQo5+tW8AmM2FHd6HuxlVo
	+8bILnoZov/BavHg7js074Gthlilt587ITSK3g==
X-Google-Smtp-Source: AGHT+IHMQGToTfzq5Il+OqaDv8F05pv4rv24DTaau8gLjNp+L0rsgUPbs8aaWg1c7lL/5TPqwD3CR/t9qqQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2382:b0:28d:adc5:ce08 with SMTP id
 mr2-20020a17090b238200b0028dadc5ce08mr19940pjb.2.1704850031487; Tue, 09 Jan
 2024 17:27:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:27:01 -0800
In-Reply-To: <20240110012705.506918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012705.506918-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012705.506918-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: VMX: Re-enter guest in fastpath for "spurious"
 preemption timer exits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Re-enter the guest in the fast path if VMX preeemption timer VM-Exit was
"spurious", i.e. if KVM "soft disabled" the timer by writing -1u and by
some miracle the timer expired before any other VM-Exit occurred.  This is
just an intermediate step to cleaning up the preemption timer handling,
optimizing these types of spurious VM-Exits is not interesting as they are
extremely rare/infrequent.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 51d0f3985463..4caad881d9a0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5995,8 +5995,15 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!vmx->req_immediate_exit &&
-	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
+	/*
+	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
+	 * due to the timer expiring while it was "soft" disabled, just eat the
+	 * exit and re-enter the guest.
+	 */
+	if (unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled))
+		return EXIT_FASTPATH_REENTER_GUEST;
+
+	if (!vmx->req_immediate_exit) {
 		kvm_lapic_expired_hv_timer(vcpu);
 		return EXIT_FASTPATH_REENTER_GUEST;
 	}
-- 
2.43.0.472.g3155946c3a-goog


