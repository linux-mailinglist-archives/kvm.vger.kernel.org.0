Return-Path: <kvm+bounces-1415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96697E7722
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93CEE281357
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD234A24;
	Fri, 10 Nov 2023 02:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bXDhMts0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5723D4
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:25 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD546AF
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6b31cb3cc7eso1601532b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582404; x=1700187204; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2PzRa92RKIbv75Ni9RyZiiDqwO+fW7tfrLRiix/ZeFk=;
        b=bXDhMts0VFGhCFMxQcwTJVIpNNRQB12quF39HGoUaMnmJmBF0/zLs4fGEaw0vXQwQ8
         srxHHbZo1ALBhjPibLVsZYibRdWluMyosvRKnaFTWVAtGd0JCtYNz5ETg+gid6qwuq/W
         1fBTkAheO5sp0JakE8iE2utTx5uWe0nTeAj9b/cDAdbKYijTHIsl7bZCuyRN8ghONMXq
         89dexPCJVqATkG9NA8QjTvLvBKDgvSvOzCRRJqzPIB8RoRjmYc9fLaAOheKHIcz5Pkro
         RvW4j08WGNOnaIcJkcshTPxNTJ4c7nxXV/xThqWoQj0Pb68oL3bs14hJ/zVrWpP384PL
         SMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582404; x=1700187204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2PzRa92RKIbv75Ni9RyZiiDqwO+fW7tfrLRiix/ZeFk=;
        b=MJheQ5ZMpx7DUlW8s8StvntfUD4RRRh/GEmKIkPvdVONiZyMF+h7rUqvDi65Y4nE2o
         UVzg0eiN8MTA5QRAsewhwMRXr5n5qgHnmp+DrQwvhjnCQldio7zpZDxXVQ3nk+YDDmsu
         pScLrEG+O0ptSrbG7v1De8kwiWTt039b5gcFAMOE7aqlm+bXvYqia9VkwSO+UlreoC3S
         s95btfcYA6sTTTPGHveZOgFJNUxC0l5XKPhssic/BABdlQGXz/0xqBBuTnfQkCAZKTM4
         3Z9AuNuV4XPyz83pT6VFDg80S2HGvBgOnpveDqx/NGgYkU+1y59ja5KlMTv7/gIrg/d2
         Pxng==
X-Gm-Message-State: AOJu0Yzbef123917UPPg7+L4oJFUlEMo+wDhigz8FMH/3Jp09Lrlo/R8
	4xAmsWj+rr5eV3Rpmq4QRokc9xL++FY=
X-Google-Smtp-Source: AGHT+IFjMVC/vL2pU3SSoINJ741BNz003DY1pTOT7iibCLJDeq38xp0tH0BXTrYYKRiMMFG+NllhGbbPf2o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a09:b0:6c3:9efc:6747 with SMTP id
 p9-20020a056a000a0900b006c39efc6747mr428065pfh.3.1699582404364; Thu, 09 Nov
 2023 18:13:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:46 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-7-seanjc@google.com>
Subject: [PATCH v8 06/26] KVM: x86/pmu: Don't ignore bits 31:30 for RDPMC
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
index 5596fe816ea8..427ec055c8bb 100644
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
2.42.0.869.gea05f2083d-goog


