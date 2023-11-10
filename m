Return-Path: <kvm+bounces-1446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E990B7E7783
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC5A8B20D10
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312646121;
	Fri, 10 Nov 2023 02:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g1Wmfa/6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5F539E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:19 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2522B46A2
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:19 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc23aa0096so15696395ad.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583358; x=1700188158; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDXmprU9Q2uJ1P2ZcBSz5/xZE4cUzlnzK3sR8+dOOk=;
        b=g1Wmfa/6C6BFSkjQ/aTj/HWNjTE5L0IP32bwcFxXycGtynuqUozvRb7LLkI9Hp+b4N
         4do0qPR60+Nvb3um+hwpVaLKMb1qIY3rfV82sb7rKRBiLe/fE+3287+EN5LyfMGTCrkR
         Fh//GeAGFsBxIzTEqrSkuE5NshS/9WfSdsK39Vm1ie0+6En9lgM+YtrRPySrvoUTiVyf
         KiYe609q7hrYgUWuhUYu+YxF7VCJy7TndTt3h/3cz3JqRBJSgAWWW2V6cjsP3T7K9La7
         IIlX7zEDYk3I8hBgRm74myvOTay5G4aqee578bKaPfc/S3ljZdvr1X7h+n4pes7nOGaT
         +N4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583358; x=1700188158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjDXmprU9Q2uJ1P2ZcBSz5/xZE4cUzlnzK3sR8+dOOk=;
        b=C/8fBWtatQ7KHGHoMRmAI7yZ5bq9Rw2U61YcE/ruWk8YjwzMz4r1IrkO0NfvuwzvNb
         PvqJMOSXX0WbZcGUgzez707hggUvZfOJoeUIWNXRiycomDl7J5/q1UzeEgjE+cAXhnae
         Z+83Efq3bpGhJr6jMlBmuWcaLvwmqSxTG+R45iyS7rOP6v3i5iFzM6uPUSbDIftNoGI+
         /BcpmvzUpL/i4zFWecpUXZ1+UifC4413pDOPdefbSsJF0xRIddfjkQKMaPDONTQqb0KF
         3+S6bPGvbAz+IwrtD8q0MalhnWeTc9HhjCykQFhyT3YZ8vPEsLvOBekR4EFrpfFoswTO
         uBxg==
X-Gm-Message-State: AOJu0Yzh5AaFELBbwlnLQs/1TNN0Fi6ua8kNWqmvDtOJQuiZ9EFc3MGa
	CWlZNYuHxN3mgKjctT+/lPxEcwnAbgE=
X-Google-Smtp-Source: AGHT+IF8gdeQdC2vix2B9j35/6cn/ogiC7i3MtASLOgt733RFCpaQp4XZVOTIKgNYM7TT4sAmY3DEPPy3HQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2591:b0:1cb:d9ff:e26f with SMTP id
 jb17-20020a170903259100b001cbd9ffe26fmr829172plb.5.1699583358643; Thu, 09 Nov
 2023 18:29:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:56 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: x86/pmu: Check eventsel first when emulating
 (branch) insns retired
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When triggering events, i.e. emulating PMC events in software, check for
a matching event selector before checking the event is allowed.  The "is
allowed" check *might* be cheap, but it could also be very costly, e.g. if
userspace has defined a large PMU event filter.  The event selector check
on the other hand is all but guaranteed to be <10 uops, e.g. looks
something like:

   0xffffffff8105e615 <+5>:	movabs $0xf0000ffff,%rax
   0xffffffff8105e61f <+15>:	xor    %rdi,%rsi
   0xffffffff8105e622 <+18>:	test   %rax,%rsi
   0xffffffff8105e625 <+21>:	sete   %al

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index ba561849fd3e..a5ea729b16f2 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -847,9 +847,6 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		return;
 
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
-		if (!pmc_event_is_allowed(pmc))
-			continue;
-
 		/*
 		 * Ignore checks for edge detect (all events currently emulated
 		 * but KVM are always rising edges), pin control (unsupported
@@ -864,11 +861,11 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 		 * might be wrong if they are defined in the future, but so
 		 * could ignoring them, so do the simple thing for now.
 		 */
-		if ((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB)
+		if (((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB) ||
+		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
 			continue;
 
-		if (cpl_is_matched(pmc))
-			kvm_pmu_incr_counter(pmc);
+		kvm_pmu_incr_counter(pmc);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
-- 
2.42.0.869.gea05f2083d-goog


