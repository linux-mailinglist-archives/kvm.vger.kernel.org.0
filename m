Return-Path: <kvm+bounces-5930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A119982907F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:07:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CA591C2408F
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D6A47A45;
	Tue,  9 Jan 2024 23:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VU1MYyse"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897E746542
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f6c12872fbso53387357b3.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841394; x=1705446194; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ao+rVh1VlyuTP2cCyh0ane6i4PpAFuJ+32SEPc/mF8s=;
        b=VU1MYyseYHJJ8hdlmEpMUXE6GXGY+XibWofGAKKotUFS9wboiksOr6P7OAjAyIalDr
         +NY+dbC6qJbeFaFILyW3JV3LmimBdboLLQ+pPSjK1dLR8LJAi8DWFK+1YBebiDEsnnb9
         hS4UYIHZ+LZQAA+TJTPgM3t0/4PXaU5ZqqF2WwHmaBJGJE/7thkXotIMhMmGmxx2M/Ve
         Sc0nGcYOX87T8cvZihLPm2J4Yy1uSsLnZIzvU+ktVg/5T/5J3m+xJu+nq+m1eJGuizDJ
         LEkSjrzp0gFzQmhVQAh+wqG5zygZWNK34i7X/z4DIAdqevrPYwIoD+XmuDt5la5Z2njr
         NJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841394; x=1705446194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ao+rVh1VlyuTP2cCyh0ane6i4PpAFuJ+32SEPc/mF8s=;
        b=E8eVYrS42wX1Zo+myu0KMmTsW8wGHsYGBclXey0QgtuIasTtZxgIYuzpEAqJyYMXtK
         aZP6fDhohKYYeFTtH1+lyh8sNDe1uEAFykBB7d4MkIQn5QEsp2HH+1kp8t1YV3+7h9SH
         sRyEk62QYAWenP9wKL/J70LJ1XAudYcXGazhCxRgv3JOytgyyunyvnthAOBE3pBhtDQx
         I9H/XLnLTwdnFaqyevq/CmrTAn0sxviom/6GBRR+Jrxenh/aLsUT2lsWTAQLvfypCj5L
         gh2a3buwUlWWmmKBfAy8p5VtS6ypDBAKt7flZgT59BWqkSLrlq93Q0zRGvRjoBxLHqXW
         TpEw==
X-Gm-Message-State: AOJu0Yxn02TpVz8A9zx+5spCKxMhqKmv714pXOdk4jtn4fp1kvuNNwhE
	FWeXMEpjC9xrKFkPL65TEDf9xySvS7xiazuzLw==
X-Google-Smtp-Source: AGHT+IHQunJwCiuuIH4D/UuntDa5wBMua6iLjzokPhDZ3Bl7FweK8+CkwoqLFFGYnjhgM24OP0zHXGFl2pc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d1b:b0:5e6:27ee:67fb with SMTP id
 cn27-20020a05690c0d1b00b005e627ee67fbmr105239ywb.4.1704841394439; Tue, 09 Jan
 2024 15:03:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:31 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-12-seanjc@google.com>
Subject: [PATCH v10 11/29] KVM: x86/pmu: Explicitly check for RDPMC of
 unsupported Intel PMC types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly check for attempts to read unsupported PMC types instead of
letting the bounds check fail.  Functionally, letting the check fail is
ok, but it's unnecessarily subtle and does a poor job of documenting the
architectural behavior that KVM is emulating.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index c37dd3aa056b..b41bdb0a0995 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -26,6 +26,7 @@
  * further confuse things, non-architectural PMUs use bit 31 as a flag for
  * "fast" reads, whereas the "type" is an explicit value.
  */
+#define INTEL_RDPMC_GP		0
 #define INTEL_RDPMC_FIXED	INTEL_PMC_FIXED_RDPMC_BASE
 
 #define INTEL_RDPMC_TYPE_MASK	GENMASK(31, 16)
@@ -89,21 +90,29 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 		return NULL;
 
 	/*
-	 * Fixed PMCs are supported on all architectural PMUs.  Note, KVM only
-	 * emulates fixed PMCs for PMU v2+, but the flag itself is still valid,
-	 * i.e. let RDPMC fail due to accessing a non-existent counter.
+	 * General Purpose (GP) PMCs are supported on all PMUs, and fixed PMCs
+	 * are supported on all architectural PMUs, i.e. on all virtual PMUs
+	 * supported by KVM.  Note, KVM only emulates fixed PMCs for PMU v2+,
+	 * but the type itself is still valid, i.e. let RDPMC fail due to
+	 * accessing a non-existent counter.  Reject attempts to read all other
+	 * types, which are unknown/unsupported.
 	 */
-	idx &= ~INTEL_RDPMC_FIXED;
-	if (type == INTEL_RDPMC_FIXED) {
+	switch (type) {
+	case INTEL_RDPMC_FIXED:
 		counters = pmu->fixed_counters;
 		num_counters = pmu->nr_arch_fixed_counters;
 		bitmask = pmu->counter_bitmask[KVM_PMC_FIXED];
-	} else {
+		break;
+	case INTEL_RDPMC_GP:
 		counters = pmu->gp_counters;
 		num_counters = pmu->nr_arch_gp_counters;
 		bitmask = pmu->counter_bitmask[KVM_PMC_GP];
+		break;
+	default:
+		return NULL;
 	}
 
+	idx &= INTEL_RDPMC_INDEX_MASK;
 	if (idx >= num_counters)
 		return NULL;
 
-- 
2.43.0.472.g3155946c3a-goog


