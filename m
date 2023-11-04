Return-Path: <kvm+bounces-554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6057E0C79
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EF8DB217D3
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE345384;
	Sat,  4 Nov 2023 00:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LBDed+xn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEDC4426
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:56 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B552095
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc5ef7e815so20406075ad.3
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056174; x=1699660974; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5i9f3RYw+3rq1epr4QQj/W0ALWCCMiQAE1rG5bd7znE=;
        b=LBDed+xncv04uLfvYR92fVlIknYGjtt4+rLKhCClBBmCsqur31PsyPcV4yXUjg5SCq
         PnhVKCUtMJ3bFrSbdR9WwOFsfxiJPW/v46AZvbQot33n4fYscEBaM/5KvAUsb91K/CeW
         7Hy3IbPgyR3QkeLeL1AP0zByPNMuiy6lkGJce6m80BIIK4MQaRITWrOeoKJjQi2HlNnG
         mK7JuiRrfn7o4IFkjk3SKaTGMzqrBcE9cfaFdES9PMrtUqLMIktm4fdJs5f2QiWq46UE
         F8XcEjK2mhRmHGJsiSAN4sL+3PvPWhYyQHxtGfcaIwzhO8LXK0jM9l5rrk52PhUYPhIF
         b8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056174; x=1699660974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5i9f3RYw+3rq1epr4QQj/W0ALWCCMiQAE1rG5bd7znE=;
        b=u5umCPYFqyzhfUw44AJEmLH4lHO6vzr+uhQxf0KEzzuZUTFK5bZr2PYwXBf0wIQ71j
         rmFdyrxXSNu91P45NwRzW2O9MObX3mTgl3Mt97GBY7VAPd292Iuo4wPklDcffhOsN2x9
         6xTuIgQGGZngeFsuUp3AgLAVoBPykKPgXt1wg8+eEU/ZAQvU9iBn8t9XbL+RIgxegfQc
         4Ing+2aXLbDytSWtwi35eRe+Nt+AclvkU49WKBxm/XT4NoueieDV68baoLIkB7rLS7RY
         oDLXMy64ryr1/lGfoDPIIDIyJTTeY3NhPu3zVeWPZYWt/N9xZIz4X7oIw6t97KXnpt2b
         TFkg==
X-Gm-Message-State: AOJu0YzLdE8jKwr4uuPeMBjuZ6gwHF7yk+PtGFachGr81bM6TXreDj4K
	ijnvIU6o353rpoFA9ZKnbvTxpfmtiYM=
X-Google-Smtp-Source: AGHT+IE1eWH7pXBbLchwQEff990m3l+n8cZsTNJyIs2lE9v5Z9AluM1XnWKc74yLZ7JL/oXNCsem7ErGVKE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2609:b0:1b8:8c7:31e6 with SMTP id
 jd9-20020a170903260900b001b808c731e6mr430898plb.1.1699056174214; Fri, 03 Nov
 2023 17:02:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:25 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-8-seanjc@google.com>
Subject: [PATCH v6 07/20] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
the name is redundant with the macro, i.e. it's truly useless.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index a01931f7d954..2d9771151dd9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -289,7 +289,7 @@ struct kvm_x86_cpu_property {
 struct kvm_x86_pmu_feature {
 	struct kvm_x86_cpu_feature anti_feature;
 };
-#define	KVM_X86_PMU_FEATURE(name, __bit)					\
+#define	KVM_X86_PMU_FEATURE(__bit)						\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
 		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
@@ -298,7 +298,7 @@ struct kvm_x86_pmu_feature {
 	feature;								\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-- 
2.42.0.869.gea05f2083d-goog


