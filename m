Return-Path: <kvm+bounces-58275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C592B8B945
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C19D4B63F30
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C28327A18;
	Fri, 19 Sep 2025 22:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EaJaKQdF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B794324B10
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321270; cv=none; b=RFvJsL6AHzurKXEdP53VwhtwTtuDaYJx9FNKi2t3A0fvmduv0sB+vA3DaLkjcbtYce/tyjuMZRnhtAEvrHIHX0IoiF/JjgcjonsgbPbTCLM11pVFvbUKopP3ehP4q4MeT7US5imJeH09dqCtjbE8OrtsHbZesD1wyBmrWAhz9oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321270; c=relaxed/simple;
	bh=9j7eMRNZfnKaut1MLIO4jNPk4U8qe/HJIqhBM9DKwnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCKESOmWv5hX0+d1uwEyxB/EhnBlNb3JbCeXaGTiOV5lkKP6FCU05e1eDUTCS68Rn67kwianwq5tuB/3yWQk5wibHyNO1tUs1fz9Vfh52vpKBC3nc+3zTWmnfOuTq51rubNDmUi1RnZA4zcZF/iqQsRjBRAA5b3a1p1VaNiAFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EaJaKQdF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25d21fddb85so45293035ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321268; x=1758926068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7eTiTbmyW2tvaAMI1jt358bJAngHDTuuFupNysw0qX0=;
        b=EaJaKQdF4WuNznfKYQKa4ELsJXge54W03s/NBuR84gP4LCOkKFlTv3KydLnNpUIgKW
         vGex3LQzo8yi6wGUJJYif0n0ItOeCUPiejS3uaIeNMgTERzzowo+IWrUIwFMZydX+FVj
         V3RkNqhr8+fc/JQM5P7Md9Pb5gItsQMalexvxwAAJkQbhhK99LTy1tyi23I7CDpvjOAl
         xFmStVdEPhoTuEvAJVJE2ZLnwdp+fDG4a5Ahs5UsunjFaPgKVVLEKXO6N1f/FjE6cwps
         3MX31xDx/hJ1/rc7yLXzdRmMKn2aNBcaUamitYTJ1ghBYi+7IGcNVaB23LavF6mz880i
         5tVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321268; x=1758926068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7eTiTbmyW2tvaAMI1jt358bJAngHDTuuFupNysw0qX0=;
        b=SdfK7KvwnR7nrYOvnlPNywjYpXr96QWaDOB2Vk++RzpmO+AczgpKz0jMLaT2jVp4nT
         HbeYYmWXB+An6+jLQ7iqsVW77xHR71cgNnEr2iONtRWCF7sMUkFTGi8Aszrdju1XBoHS
         CDi1fKfo4+wIpgfsr0+MyESfpb35V3MG2t7MvpDjqcgIjB50EjZQ9DbZXzVQ/Gn1klm5
         CecUm8pinu49O7BC+Ipebpt4IDQA3q+BgPxjeFOgoe0a9iVTJmj+ReQzIa3jGj25A9Zb
         xVoTmfJpdRhAdsaW1v6/ocO1neEq7U39qhXx2rn7ve7QDJz6YcuUluhKRq7lLssEr6rC
         5TQQ==
X-Gm-Message-State: AOJu0YxDMTdReuDfVMqieNO3InmugnSd1mURpBMVU2QHm0Hmixz9I5Fb
	+vOvHLocr72LwpoYQtzmykup9UpMbroH0iLtL+hC35UC9E6zX41jMH0kSd5YxcmyTWMmzdeOCut
	WdpkpCw==
X-Google-Smtp-Source: AGHT+IFXr8IRlLneO+WHx4jAfFZ2ebYEf5el1Mwif7m5GTJpYT1UbPToxu4FsdBBTNwL71GOUqmmaGJ/v64=
X-Received: from pjbsd13.prod.google.com ([2002:a17:90b:514d:b0:325:a8d:a485])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2285:b0:268:f83a:835a
 with SMTP id d9443c01a7336-269ba575f3emr58130475ad.60.1758321268664; Fri, 19
 Sep 2025 15:34:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:54 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-48-seanjc@google.com>
Subject: [PATCH v16 47/51] KVM: selftests: Extend MSRs test to validate vCPUs
 without supported features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add a third vCPUs to the MSRs test that runs with all features disabled in
the vCPU's CPUID model, to verify that KVM does the right thing with
respect to emulating accesses to MSRs that shouldn't exist.  Use the same
VM to verify that KVM is honoring the vCPU model, e.g. isn't looking at
per-VM state when emulating MSR accesses.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 28 ++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 952439e0c754..f69091ebd270 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -296,12 +296,17 @@ static void test_msrs(void)
 		MSR_TEST(MSR_IA32_PL3_SSP, canonical_val, canonical_val | 1, SHSTK),
 	};
 
+	const struct kvm_x86_cpu_feature feat_none = X86_FEATURE_NONE;
+	const struct kvm_x86_cpu_feature feat_lm = X86_FEATURE_LM;
+
 	/*
-	 * Create two vCPUs, but run them on the same task, to validate KVM's
+	 * Create three vCPUs, but run them on the same task, to validate KVM's
 	 * context switching of MSR state.  Don't pin the task to a pCPU to
-	 * also validate KVM's handling of cross-pCPU migration.
+	 * also validate KVM's handling of cross-pCPU migration.  Use the full
+	 * set of features for the first two vCPUs, but clear all features in
+	 * third vCPU in order to test both positive and negative paths.
 	 */
-	const int NR_VCPUS = 2;
+	const int NR_VCPUS = 3;
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct kvm_vm *vm;
 
@@ -316,6 +321,23 @@ static void test_msrs(void)
 	sync_global_to_guest(vm, msrs);
 	sync_global_to_guest(vm, ignore_unsupported_msrs);
 
+	/*
+	 * Clear features in the "unsupported features" vCPU.  This needs to be
+	 * done before the first vCPU run as KVM's ABI is that guest CPUID is
+	 * immutable once the vCPU has been run.
+	 */
+	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
+		/*
+		 * Don't clear LM; selftests are 64-bit only, and KVM doesn't
+		 * honor LM=0 for MSRs that are supposed to exist if and only
+		 * if the vCPU is a 64-bit model.  Ditto for NONE; clearing a
+		 * fake feature flag will result in false failures.
+		 */
+		if (memcmp(&msrs[idx].feature, &feat_lm, sizeof(feat_lm)) &&
+		    memcmp(&msrs[idx].feature, &feat_none, sizeof(feat_none)))
+			vcpu_clear_cpuid_feature(vcpus[2], msrs[idx].feature);
+	}
+
 	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
 		sync_global_to_guest(vm, idx);
 
-- 
2.51.0.470.ga7dc726c21-goog


