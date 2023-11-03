Return-Path: <kvm+bounces-538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBF57E0BDD
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B58F282000
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829EA250EB;
	Fri,  3 Nov 2023 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LIecUdMS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA31125104
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:05:51 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E036D6A
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:05:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da3dd6a72a7so3001639276.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052749; x=1699657549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PIc07kH91+cPU8S0NDLhNr7u04OQXkw6B524JpAs8r4=;
        b=LIecUdMSlswrzia4Txqh2//zY8sAsGqtlQ4x4TypDl+bX2sS0H5zEoCSlMMZvkxEFb
         iMG/xdWze67S5ICqEUYDpaqrn4UeZa52hCRNHo/4n9JSYUCCqEuJ7iiDzyyGmmYsCkiB
         GNZjYxKI1l2ShDGRWevk3TZ4WCC9+YHngLlI2gKlXjE8LYdg3QIQgNWuUmu/G29mB3JD
         6Kpk9yrUhndlSec3XuQpbhFPs7oOq5t2lzgB2KBgzK8OJ3iHuYNUJ94VjoBa0R/u6qSx
         OR97+ELUC6bwMeSMz9Zo2d9PRPIsiGv58J9Qk02MUWiLtVMD8+w3WVJ85UybPo5MRDcn
         AdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052749; x=1699657549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PIc07kH91+cPU8S0NDLhNr7u04OQXkw6B524JpAs8r4=;
        b=kzAKJ6NMlw8/nJ9puocJuHkwBl8XBqn0H0Ia6CaDQQLvgE8mWNZlR2PXnEkWV0T6i7
         R2IJwOW3o8nRIPQnKJiExf62KK76erie/Nbv07TA5zZfJt7K22xvMzPg/JH1UAUAG7BH
         3bZxqmdn0I/cvxZV0Aj2BaRdoXJim/J8Mxwc3PLZQZdNnkRmi5offkkm/FIwN5ekTfiQ
         HpCVHj2452UCMlxwh1+s3idHjQJMsbGQrnPCehtaUstMDRN/EJx4s9ZCvKdxzWk+BgxC
         vc5Mkd2y2JshcCn1oWNlCP2AkIBHk/24Z/VEBbSpwRkMgINnbjA0S3QKL2YFaOMQ2ctj
         e35g==
X-Gm-Message-State: AOJu0YzRzzC1xTKoPq/bFCgzx+3QMuJ4/2hKc3Fm7xIo3DCaznJVkpvZ
	586536UyFtc7zaS2OXiB8LVSaFchzaI=
X-Google-Smtp-Source: AGHT+IGQH3rOOCQXNPi400rdIixp/HhKqhN6bqEr4nOXrmGJC/CyNts/C5TL6ESngadKiAbSBsjqTJSWLWc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2083:0:b0:da0:c584:def4 with SMTP id
 g125-20020a252083000000b00da0c584def4mr428586ybg.1.1699052749410; Fri, 03 Nov
 2023 16:05:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 16:05:38 -0700
In-Reply-To: <20231103230541.352265-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103230541.352265-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103230541.352265-4-seanjc@google.com>
Subject: [PATCH v2 3/6] KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET
 (it's redundant)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop kvm_vcpu_reset()'s call to kvm_pmu_reset(), the call is performed
only for RESET, which is really just the same thing as vCPU creation,
and kvm_arch_vcpu_create() *just* called kvm_pmu_init(), i.e. there can't
possibly be any work to do.

Unlike Intel, AMD's amd_pmu_refresh() does fill all_valid_pmc_idx even if
guest CPUID is empty, but everything that is at all dynamic is guaranteed
to be '0'/NULL, e.g. it should be impossible for KVM to have already
created a perf event.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 arch/x86/kvm/pmu.h | 1 -
 arch/x86/kvm/x86.c | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index dc8e8e907cfb..458e836c6efe 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -657,7 +657,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-void kvm_pmu_reset(struct kvm_vcpu *vcpu)
+static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a46aa9b25150..db9a12c0a2ef 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -243,7 +243,6 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu);
-void kvm_pmu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..efbf52a9dc83 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12207,7 +12207,6 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 
 	if (!init_event) {
-		kvm_pmu_reset(vcpu);
 		vcpu->arch.smbase = 0x30000;
 
 		vcpu->arch.msr_misc_features_enables = 0;
-- 
2.42.0.869.gea05f2083d-goog


