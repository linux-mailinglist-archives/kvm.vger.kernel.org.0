Return-Path: <kvm+bounces-5932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3A0829083
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67E59B26089
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3681B47F6D;
	Tue,  9 Jan 2024 23:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f0GbSmzp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A91F47A72
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5efb07ddb0fso48664277b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841398; x=1705446198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1kUdagJS0RkwSIGsouIbjCNUHXTtDF8gUa99CW8Gru4=;
        b=f0GbSmzpYP+33Jvp0fC6ebWL69OIh1Zmrq0XRjXlFYhxzSAknu5Tvy7H97AW7P/lVV
         mJvZJG2gsBo1F3g5dQgJOCeWCcN8Sudi29YVi0YsqekdniDOj6ZKXgEkNpw5mpRNBvER
         AYrL6gptOBEle8pzG1fUzKtApkdo62DkMVMNqvRxTO1KkfJ3Su9QhZKFvuH0s3I9qMo6
         n7qDRZSD70opkx4ZpcCbz4oYkLrdJ1gx4ApRQUbUetgQFX7tqjQDPOxxCXr46CV6XAZT
         8Kpj4Alxaz1I3Wi0t5zHKHTaZ6HyxXjaGWTFqZt5t/6iWQDsh6oiJb5nYm7fi8REoN70
         F4mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841398; x=1705446198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1kUdagJS0RkwSIGsouIbjCNUHXTtDF8gUa99CW8Gru4=;
        b=gVfjDhhnJePMgH5rsVKB6Dp9Ffx87uM6Djdk/+ug5pMmPexUyVN3ocY5/w2tvaJOOV
         sF/2kNLRyaZoMyCNcoWzwwfe0jVb8rOgkIc7MbCscdiSWaSOzJesZzyafjtXRkZ2I72h
         SuJJ73gtQovDs7qDoCPYNBgDH5deb/VpLh8BpFrPZUAI23DOOAw6w3jaw6Vww+L4lvor
         cqC4mpFcFrKqSByjnPfGViaia6bOgQ3AQoaQq3oa4qZKUHUPGntizUgb1sQ9fLoBufSM
         4y2BaO5qk1TCFdAod7Es9+SDDTMej7jeiHfmOW5MsvdCnNOrH7Kd1wVv6LjNX/2LQBf1
         rgGA==
X-Gm-Message-State: AOJu0Ywy+FAXmnBSKw6O6aTwByyQ1N405Fwc337Fb259Pb9yHoLs2w5f
	koBCuSFEl+UTT+UtghGSxQ2DVoqBWCQYRktz/A==
X-Google-Smtp-Source: AGHT+IFsXlkZ/mWbUUU9rSMx5+slIt6MS5Dp98xqW8gbGhoVNbmoxfLEh3pqfw8x0zQGWEJxxkp/3+iECYE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8211:0:b0:dbe:387d:a8ef with SMTP id
 q17-20020a258211000000b00dbe387da8efmr5333ybk.1.1704841398399; Tue, 09 Jan
 2024 15:03:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:33 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-14-seanjc@google.com>
Subject: [PATCH v10 13/29] KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Drop the "name" parameter from KVM_X86_PMU_FEATURE(), it's unused and
the name is redundant with the macro, i.e. it's truly useless.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 932944c4ea01..4f737d3b893c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -290,7 +290,7 @@ struct kvm_x86_cpu_property {
 struct kvm_x86_pmu_feature {
 	struct kvm_x86_cpu_feature anti_feature;
 };
-#define	KVM_X86_PMU_FEATURE(name, __bit)					\
+#define	KVM_X86_PMU_FEATURE(__bit)						\
 ({										\
 	struct kvm_x86_pmu_feature feature = {					\
 		.anti_feature = KVM_X86_CPU_FEATURE(0xa, 0, EBX, __bit),	\
@@ -299,7 +299,7 @@ struct kvm_x86_pmu_feature {
 	feature;								\
 })
 
-#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(BRANCH_INSNS_RETIRED, 5)
+#define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED	KVM_X86_PMU_FEATURE(5)
 
 static inline unsigned int x86_family(unsigned int eax)
 {
-- 
2.43.0.472.g3155946c3a-goog


