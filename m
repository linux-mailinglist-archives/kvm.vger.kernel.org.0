Return-Path: <kvm+bounces-5925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE7F829074
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FC2AB25E3B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A19140BE3;
	Tue,  9 Jan 2024 23:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M18ySga2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AD43FE3A
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ee11c69bb8so62739637b3.2
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841384; x=1705446184; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9LjGHaNIdIg3QzaGl/5dN2VdX2yHsiBWEBAmyUKtKyQ=;
        b=M18ySga2NGEfEhXdZvYUV5WBQGUXvJYOvVKexifeubFL2aUcYTpzQIumClEdZaInPh
         cWexXOZJ0MROf3lrySaPfo9xl5oGeU7snZA5Wm4vSzJGHyaDcb6L4wvm8bUDVuZvZsLe
         cM7o9Imfn4ZnU7oSvGvcmRmoMlmfUWP4oGTArbR7JyDI+j0Ayn4wfEzXY6fziQ2GI0y1
         lbmI9vWXXc602neoQprGchbRuEFUrWpyVDPEduCRvS937O14RZ69g5xC/nJXiWvIsWi8
         Sk4khaJFqASNIBp2SBKCbHMr4KpmGQdxdzKwQACZSc13tEBzTLGGVjfFYI2N4KMHj9xP
         L5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841384; x=1705446184;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LjGHaNIdIg3QzaGl/5dN2VdX2yHsiBWEBAmyUKtKyQ=;
        b=sPwqm3aB6nYYsb+wu2SrvSKxhG5zEang/rFR2x610DyiLiVlm8/HNv9DFRNyzt071i
         sXXdpOXZ8vCrMGlBwmkW2okh9UFgHKbKoXdho9pmwIcLxPKgg8xILfmocWyWksNBTAEH
         rG3Y4pRhBJmc/H6qLI2L6Owob8VHKEvwZMmJOq+yWcP43VmrsYR0z/Ab1XvMQdoiKVoC
         cl7mP8Ho9wm/YXVxW90JOCMj76jDe/2lZE4j9IM/c0/Sty5rMv3UFVCWWcoprl8jYiV5
         ZAfjlXp7wklfjqxtqGQIffus/yHPWxIXps6VfRyprdVivLa00D9S1+wxwIVpV6Gzij7o
         36DA==
X-Gm-Message-State: AOJu0Yx5DlE2xOAXEg47zWTYlrzIxB8EqWJGJ1nZylfFqEyCN74xqmKF
	xP78zgvrjwJfFDzIi0vycVkmLj9H7gB485OG3w==
X-Google-Smtp-Source: AGHT+IFFObObKoJ49JR0BCouG9QCxKOm8CG719bWT5WdSBNFPxsFOzY42TX2XHmhAWqxO4qZBMlbLn3e+8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3702:b0:5e5:5bfa:8257 with SMTP id
 fv2-20020a05690c370200b005e55bfa8257mr121585ywb.9.1704841384589; Tue, 09 Jan
 2024 15:03:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:26 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-7-seanjc@google.com>
Subject: [PATCH v10 06/29] KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC
 index on AMD
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Stop stripping bits 31:30 prior to validating/consuming the RDPMC index on
AMD.  Per the APM's documentation of RDPMC, *values* greater than 27 are
reserved.  The behavior of upper bits being flags is firmly Intel-only.

Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/pmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 1475d47c821c..1fafc46f61c9 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -77,8 +77,6 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	idx &= ~(3u << 30);
-
 	return idx < pmu->nr_arch_gp_counters;
 }
 
@@ -86,7 +84,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	unsigned int idx, u64 *mask)
 {
-	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
+	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx);
 }
 
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.43.0.472.g3155946c3a-goog


