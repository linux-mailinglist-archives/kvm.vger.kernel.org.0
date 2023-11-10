Return-Path: <kvm+bounces-1443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D157E777F
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFEB6281385
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633BA4C60;
	Fri, 10 Nov 2023 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxd9OyhR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E6123D7
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:13 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52446B0
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:13 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6b31cb3cc7eso1613578b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583353; x=1700188153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oUplQH4QKJNeOGVBIGmyoAKP+5jCzgTgFjMw0NNsbV8=;
        b=bxd9OyhRQfuVpkEeKnGJO9SydgcnMgzqO0QovgXETG/z0aCw3KhdoLNYUMUiwxCx3Z
         mho76pDdNhzA1TR0VsXvgZ7Lsg5+4z+ZGkwt5cXC3vIJWXb2FjhRlcpByRsx7dIMexEr
         45hD/HNiouVhXQ1YdZkzonuwFZ9mM0tTvpnh1aD7wJZmxRWpsi+92dv36pQl/LASUU6i
         +5zC+9EispEhTtKs7C0mtKaLnWVaw8bjBV4C7MakHq7i6tBhSGLygXiAYoT5WryMck0J
         xaTtnXPsngXix9N/bvseKFhdG3puqm/nRWFeXll13Xy0qKY8ZFXxkm2VbzX9ZJwPabZZ
         BDPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583353; x=1700188153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oUplQH4QKJNeOGVBIGmyoAKP+5jCzgTgFjMw0NNsbV8=;
        b=wIKIs3RUmfSK+e7rCwGbuWxwW20h7XRg21YiwnNQ8Ce+qEd94l6Im+BN+FRmydkdJx
         0IXO1Rk9Zl4qVQx9Pcyn05qpHhWwXBHSs3rdF/qJfqyoRO6YQsyUk/rsSfYez/J2cTAM
         CiNS9tHpeDqvp4/MGnD13QDISFieY7ANLFR0Npx1xdJXWQB0XO4rR+3/n7JHlBwc2rsM
         d04c1xJI/WEP/nR8B7W5204g1cWQ5JMIHL/lA3hB59WnfARmPDYlCSZtVg+Wv+yqIS3t
         PEV9YzFDeLlEolSBSywhM7W3Mf0qMr5JYupabyvzedoyIVYSYTmTAdv5/beWeZAZizQ2
         LVHA==
X-Gm-Message-State: AOJu0Yxtj0CGs+VPlFFpwPBwJMGtKSiv28yHh5PdrrkdWJnSd8p1cEz4
	rux/Qap0FoHTZl1zyu2nsaUGHGPnTkA=
X-Google-Smtp-Source: AGHT+IEucuu8/wKbjkKW4lLWW91QLJUJ5SOAPQg86CMbuYGjka0qEOMY6aBvXFhk7y3bJLf4TgCoQArYkak=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:850a:b0:690:29c0:ef51 with SMTP id
 ha10-20020a056a00850a00b0069029c0ef51mr307317pfb.1.1699583352940; Thu, 09 Nov
 2023 18:29:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:53 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-7-seanjc@google.com>
Subject: [PATCH 06/10] KVM: x86/pmu: Process only enabled PMCs when emulating
 events in software
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Mask off disabled counters based on PERF_GLOBAL_CTRL *before* iterating
over PMCs to emulate (branch) instruction required events in software.  In
the common case where the guest isn't utilizing the PMU, pre-checking for
enabled counters turns a relatively expensive search into a few AND uops
and a Jcc.

Sadly, PMUs without PERF_GLOBAL_CTRL, e.g. most existing AMD CPUs, are out
of luck as there is no way to check that a PMC isn't being used without
checking the PMC's event selector.

Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0e2175170038..488d21024a92 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -837,11 +837,20 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 {
+	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	int i;
 
-	kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx) {
+	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
+
+	if (!kvm_pmu_has_perf_global_ctrl(pmu))
+		bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
+			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
+		return;
+
+	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
 		if (!pmc_event_is_allowed(pmc))
 			continue;
 
-- 
2.42.0.869.gea05f2083d-goog


