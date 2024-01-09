Return-Path: <kvm+bounces-5928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84070829079
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A82B71C24942
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1C645BEB;
	Tue,  9 Jan 2024 23:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nyOOpjhB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7234177B
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9b8fef16aso2586660b3a.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841391; x=1705446191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erkcQ6/oHyd7DZXbuvn3kFPsgNm/N3hXlrwK4Xzlp1A=;
        b=nyOOpjhBzFAE5DyVT+D4ZNJt5TapbffmsQY0qNgo/WiiG/WCTDcCJmOnAF7GO7rH2Q
         XHZlC+MtO8js9RuXGn6PKUQtd7y7yqABuThknMzu1Th6LOdldA25ivbqWYz7fVj7URLH
         xsm99FDs0LSFnphMtONVrT0b3Q/2W7/Bum8igTwo8OAA/H45t9YDO7TmtQlm1Np8QwOi
         kf5vEP4pxLFKdqt8oxctK2b3urwbAtl6zVcxoCHsUWc6gWccFM/zkTDyvwdeWGPbkRSW
         U7/LQSRnxpocIaHhFtRn2NvIHkLbg010jN9U42o1MCrkBA6FEyxgZYbB9+3uytgXw9V7
         a1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841391; x=1705446191;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=erkcQ6/oHyd7DZXbuvn3kFPsgNm/N3hXlrwK4Xzlp1A=;
        b=LItSHgU7AZA2E1JJM0mAvFzrt8YaIbNvpch8KULiCvW5z+cjqz2MaOrRS4gx4pFRQJ
         aN+63PO5+ovmY0VoMsUPN6KVIALreSRBFiE6KMyJYLaVWA4wnwPM9A5tx513hVtajm88
         8HcTDUyncI5xBlV5lBDs8EX+4iC1lIHCRhLDgyEJ4zwrT07RRbd/kUr6cy3dpXo5DVIR
         F7jMCNXru3WgXkPyF/kjHo3CY9Lg3uqabS3SuL1Zh+6ppAgMJj1rkk89LpUPkG1lw7CV
         iR8j0WOw000ueumcUG438Oed0DWr7EFLEPjYY7uGtbgih3Dw4qoQ6qwRk/0w8owHIIoP
         VfUQ==
X-Gm-Message-State: AOJu0Yx7WX7E/yqELMNhQHpC6Cz+wxiLTSG438kty+sCT7zBVb6329JB
	MPCt+ASv2fY36UkvFKZSRSCt9XfqUTfVz+EO1Q==
X-Google-Smtp-Source: AGHT+IGaLcoqDY9PT2uXe4DrFLqWRCjt+ZckH9qsb1mNb2wkvE8WXPwMismtoMk6Ox+U/XSDj3qW55olhoo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1896:b0:6da:bf5b:bd4e with SMTP id
 x22-20020a056a00189600b006dabf5bbd4emr27892pfh.3.1704841390674; Tue, 09 Jan
 2024 15:03:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:29 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-10-seanjc@google.com>
Subject: [PATCH v10 09/29] KVM: x86/pmu: Disallow "fast" RDPMC for
 architectural Intel PMUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Inject #GP on RDPMC if the "fast" flag is set for architectural Intel
PMUs, i.e. if the PMU version is non-zero.  Per Intel's SDM, and confirmed
on bare metal, the "fast" flag is supported only for non-architectural
PMUs, and is reserved for architectural PMUs.

  If the processor does not support architectural performance monitoring
  (CPUID.0AH:EAX[7:0]=3D0), ECX[30:0] specifies the index of the PMC to be
  read. Setting ECX[31] selects =E2=80=9Cfast=E2=80=9D read mode if support=
ed. In this mode,
  RDPMC returns bits 31:0 of the PMC in EAX while clearing EDX to zero.

  If the processor does support architectural performance monitoring
  (CPUID.0AH:EAX[7:0] =E2=89=A0 0), ECX[31:16] specifies type of PMC while =
ECX[15:0]
  specifies the index of the PMC to be read within that type. The following
  PMC types are currently defined:
  =E2=80=94 General-purpose counters use type 0. The index x (to read IA32_=
PMCx)
    must be less than the value enumerated by CPUID.0AH.EAX[15:8] (thus
    ECX[15:8] must be zero).
  =E2=80=94 Fixed-function counters use type 4000H. The index x (to read
    IA32_FIXED_CTRx) can be used if either CPUID.0AH.EDX[4:0] > x or
    CPUID.0AH.ECX[x] =3D 1 (thus ECX[15:5] must be 0).
  =E2=80=94 Performance metrics use type 2000H. This type can be used only =
if
    IA32_PERF_CAPABILITIES.PERF_METRICS_AVAILABLE[bit 15]=3D1. For this typ=
e,
    the index in ECX[15:0] is implementation specific.

Opportunistically WARN if KVM ever actually tries to complete RDPMC for a
non-architectural PMU, and drop the non-existent "support" for fast RDPMC,
as KVM doesn't support such PMUs, i.e. kvm_pmu_rdpmc() should reject the
RDPMC before getting to the Intel code.

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests=
")
Fixes: 67f4d4288c35 ("KVM: x86: rdpmc emulation checks the counter incorrec=
tly")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 03bd188b5754..5a5dfae6055c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -27,7 +27,6 @@
  * "fast" reads, whereas the "type" is an explicit value.
  */
 #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
-#define INTEL_RDPMC_FAST	BIT(31)
=20
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
=20
@@ -72,10 +71,25 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kv=
m_vcpu *vcpu,
 	struct kvm_pmc *counters;
 	unsigned int num_counters;
=20
-	if (idx & INTEL_RDPMC_FAST)
-		*mask &=3D GENMASK_ULL(31, 0);
+	/*
+	 * The encoding of ECX for RDPMC is different for architectural versus
+	 * non-architecturals PMUs (PMUs with version '0').  For architectural
+	 * PMUs, bits 31:16 specify the PMC type and bits 15:0 specify the PMC
+	 * index.  For non-architectural PMUs, bit 31 is a "fast" flag, and
+	 * bits 30:0 specify the PMC index.
+	 *
+	 * Yell and reject attempts to read PMCs for a non-architectural PMU,
+	 * as KVM doesn't support such PMUs.
+	 */
+	if (WARN_ON_ONCE(!pmu->version))
+		return NULL;
=20
-	idx &=3D ~(INTEL_RDPMC_FIXED | INTEL_RDPMC_FAST);
+	/*
+	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
+	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
+	 * i.e. let RDPMC fail due to accessing a non-existent counter.
+	 */
+	idx &=3D ~INTEL_RDPMC_FIXED;
 	if (fixed) {
 		counters =3D pmu->fixed_counters;
 		num_counters =3D pmu->nr_arch_fixed_counters;
--=20
2.43.0.472.g3155946c3a-goog


