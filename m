Return-Path: <kvm+bounces-5955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6008D829189
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:40:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9DADB257A3
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC23D613D;
	Wed, 10 Jan 2024 00:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSWtWN7f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE2469E
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbed6083a91so4540033276.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847184; x=1705451984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6xnKyEv4OBvotGnyOqTbS4nPA0NPUNoMw8n+LkAwHEU=;
        b=XSWtWN7fzQbbzIAWT1B2BF6Rik9aDdNQwqiBQYaglkEYF9/kL4ySWJKtEqxVcU0Q6h
         pHwuPqrAlH2dVU2o1GoOkk2E9GmumodNOpx7kAt0sC5LAizstjgCp95Fo9m+hEhOAKS9
         J0YmrRRGwrgTrLZYWkhE7AbvXVD51ZaW6H+iL0OjbX2L91abrNhlS4TcU19J8VGra3we
         HKX1qpkn0nVmD9hqJqJNIqAUTrYJzuzkeU+dhe2D7vkyR4fN3ShQdAUEMOjFfo1ra313
         RTGhtvCLyTQTwUCJtpa7qcLGkIrKjPLQVh2TLxtqk+0kQtrYN5+rKcfgFx8UcdtAhknj
         oV9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847184; x=1705451984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6xnKyEv4OBvotGnyOqTbS4nPA0NPUNoMw8n+LkAwHEU=;
        b=kMIYHVGq7mv05M1KrM/oH9Pe1h16noY8Se6VPWmB411y55/T5VphQ76//s49Lg61ng
         y5IZNibcWGvFd4/+f79pbOlU6ymea2CN3hf2pteG7zn4SRWPCh88d2e2CDfmwIzNJmwe
         isntOke5wM1i5FQJkkvcOXVQowXVZzh3juSHwCrBd2TajbXOXi+HoywvXdar9QkeFAb7
         WJ5DWLCMPd+cpuODW9FtUKCZ6jLM0Y6hla9nR0ji1T1nILQ+g7uwUIyXV33B4GdeJ/y3
         wwHLo7vYEiCXd7mfWHPuPUehnVb8gBvsIyDWWfuacgzJR4IIWHUq5FKCxUdHW0+c0Pm7
         Fw0w==
X-Gm-Message-State: AOJu0YzbVvV4nI4TqtuHaTRU+AQfmdDspR9jQXXiNudkmJDwfBTzGD4e
	/uI024IpJrC3+eLPib890j1HrLazLGuGUlizAw==
X-Google-Smtp-Source: AGHT+IGJdgMga5DZLPUMl5FS/PauMfNNe4vf3zX11dmX3/7XA4baZSYAUHhTmPFHLa7ontbom+AG5NPk4tM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1348:b0:dbc:c697:63bd with SMTP id
 g8-20020a056902134800b00dbcc69763bdmr83934ybu.0.1704847184802; Tue, 09 Jan
 2024 16:39:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:39:36 -0800
In-Reply-To: <20240110003938.490206-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003938.490206-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: x86: Rely solely on preempted_in_kernel flag for
 directed yield
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Snapshot preempted_in_kernel using kvm_arch_vcpu_in_kernel() so that the
flag is "accurate" (or rather, consistent and deterministic within KVM)
for guest with protected state, and explicitly use preempted_in_kernel
when checking if a vCPU was preempted in kernel mode instead of bouncing
through kvm_arch_vcpu_in_kernel().

Drop the gnarly logic in kvm_arch_vcpu_in_kernel() that redirects to
preempted_in_kernel if the target vCPU is not the "running", i.e. loaded,
vCPU, as the only reason that code existed was for the directed yield case
where KVM wants to check the CPL of a vCPU that may or may not be loaded
on the current pCPU.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 415509918c7f..77494f9c8d49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5062,8 +5062,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	int idx;
 
 	if (vcpu->preempted) {
-		if (!vcpu->arch.guest_state_protected)
-			vcpu->arch.preempted_in_kernel = !static_call(kvm_x86_get_cpl)(vcpu);
+		vcpu->arch.preempted_in_kernel = kvm_arch_vcpu_in_kernel(vcpu);
 
 		/*
 		 * Take the srcu lock as memslots will be accessed to check the gfn
@@ -13093,7 +13092,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
 {
-	return kvm_arch_vcpu_in_kernel(vcpu);
+	return vcpu->arch.preempted_in_kernel;
 }
 
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
@@ -13116,9 +13115,6 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_state_protected)
 		return true;
 
-	if (vcpu != kvm_get_running_vcpu())
-		return vcpu->arch.preempted_in_kernel;
-
 	return static_call(kvm_x86_get_cpl)(vcpu) == 0;
 }
 
-- 
2.43.0.472.g3155946c3a-goog


