Return-Path: <kvm+bounces-5954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B099829187
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44A2D289372
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1C54689;
	Wed, 10 Jan 2024 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E6lIprKj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790F82915
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9bd2deabfso2094009b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847183; x=1705451983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ePMAACFe2MrWq1DNaP6F2TM5DnJ2ZLx/mnijbLthbpo=;
        b=E6lIprKjPCtPRRdwnoIxtEsxJQ8n/4jQgGAXVfiyYDu2sDnAbVzdXlgaDoVRcJxWGf
         KReekSIarPOLgOw5RU6Wirk3bYpxKqSuFwhy6Ov0n56TeppuG0gtI3kVW6IKgh399gj+
         qsEgBrTh1azkW892HlSAcYoI0QgQ0zs5ehV3vDtkQYYejAzB2eJNiniMnxfSoNBAZQPB
         oo0w5jxocV97czR84GLg+4NmEUBN1XwJnFc7Exfzv2Q8iQMvCXWoKf4pcKfHNSfIjo7S
         ROcPCmLWm0VbnIHz/puEggHHPcFcAwweOtaBgIUMqH7wsKZe08bATIl5SP6ODw/jduKs
         QuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847183; x=1705451983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePMAACFe2MrWq1DNaP6F2TM5DnJ2ZLx/mnijbLthbpo=;
        b=WDTYY2uJY74RnsEefMMrBUlZ94/5Z6Q9Fv410hKVbP4Y+m429L3RRJAVDCZNteJ4Zb
         KL/PlD7FKTzwlX3L53W/hBORFg1xkM2RDRJBr/i7/HrbiVUDUwLaQyTQEFS1cVbAqbrF
         t1urX6s5ccKZXQAZOpDK3GUEG08R3Y1GPLhxcxS/jwkyKRQBb2HNMRIQ7AYpYQA9d2Cc
         e0BM3aW8/6fJiZ6JgpPbWhQjvyMUWxY1v3+2vv6FLL2gkvgZImTrY6qpfCMhhUc7cBkB
         p8eyEhW75wa9YRNUvfY/xZTmDVzt1YCgKt1Aaahl3Nb60qahq7vxqKZ406HDLWX8DxcC
         AGcA==
X-Gm-Message-State: AOJu0YyfGVlzcuFYiyPTwUvJK09wurVgZYpTaS01138J7TAMbJRMsUUO
	ZHXufWZJA9Kg7eoKvLsbtkzIfRtYKEfzsRwA0g==
X-Google-Smtp-Source: AGHT+IHOtJaaLG3E7ais7QPCemsOQWravXElMjvqSYr4650maL97nrx0BDvmc6awukPm55MRPpouDk2C+R0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce8b:b0:1d3:e449:fb53 with SMTP id
 f11-20020a170902ce8b00b001d3e449fb53mr1035plg.4.1704847182436; Tue, 09 Jan
 2024 16:39:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:39:35 -0800
In-Reply-To: <20240110003938.490206-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110003938.490206-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003938.490206-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: Add dedicated arch hook for querying if vCPU was
 preempted in-kernel
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Plumb in a dedicated hook for querying whether or not a vCPU was preempted
in-kernel.  Unlike literally every other architecture, x86's VMX can check
if a vCPU is in kernel context if and only if the vCPU is loaded on the
current pCPU.

x86's kvm_arch_vcpu_in_kernel() works around the limitation by querying
kvm_get_running_vcpu() and redirecting to vcpu->arch.preempted_in_kernel
as needed.  But that's unnecessary, confusing, and fragile, e.g. x86 has
had at least one bug where KVM incorrectly used a stale
preempted_in_kernel.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  5 +++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 15 +++++++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..415509918c7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13091,6 +13091,11 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_in_kernel(vcpu);
+}
+
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
 {
 	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7e7fd25b09b3..28b020404a41 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1505,6 +1505,7 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
+bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..6326852bfb3d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4042,11 +4042,22 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+/*
+ * By default, simply query the target vCPU's current mode when checking if a
+ * vCPU was preempted in kernel mode.  All architectures except x86 (or more
+ * specifical, except VMX) allow querying whether or not a vCPU is in kernel
+ * mode even if the vCPU is NOT loaded, i.e. using kvm_arch_vcpu_in_kernel()
+ * directly for cross-vCPU checks is functionally correct and accurate.
+ */
+bool __weak kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return kvm_arch_vcpu_in_kernel(vcpu);
+}
+
 bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
-
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -4080,7 +4091,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
-			    !kvm_arch_vcpu_in_kernel(vcpu))
+			    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
-- 
2.43.0.472.g3155946c3a-goog


