Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC55D445C24
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 23:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhKDWfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 18:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKDWfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 18:35:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BC1C061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 15:33:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x5-20020a1709028ec500b0013a347b89e4so4142290plo.3
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 15:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=U10nFEQE4DJnIq8sS39FwZrJXHt8X4aab8x3+/jzKTM=;
        b=VwZmK7TE5vpYoLK9WEr2YAI2bySoo+T9KeeQkW5Bujub9bn3SQVBTwdmHNn5kOD9xZ
         wXaPKqvYQ62d73wEJwxT8HON+C+SERBeDDDJzg9DBdq6Lb2seQEV7mCQ05l/0QsY6SKx
         Gj18PHaD/PIhK2CXNi16dvCEdR9iEuVZhaT3jaYb4GMkhdXl9ElHugnxHVo5zY6t/T38
         YZnfH4CWdChlgEjybD7QlmZYfQsmyhwwuDkUMzq+aWRtomD7TghkJkiy7M75bdmEffZ4
         MD96YOw98Mw6WvVruIiPCMenG1GGhDpnztHpOjkLnlrBSz3hcZUkFIue1oWKWHyt9paG
         60rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=U10nFEQE4DJnIq8sS39FwZrJXHt8X4aab8x3+/jzKTM=;
        b=iNZ2OlevRIkmFIxl4vq0Gt8r/gp9ZXYy7XGPsdwqz6PZY6OvCcEnSLrdzkSB3QAEV9
         M40pDyEIVLa7VPjxD9jqx22U/bC4pBMQMi4VM+RhtoBAxwZcUGxtW/e0w2WgvBLNkZf3
         rcccy0vvVYz3cFNBSljs4yILXZ+gqNYSXqUPjoXLNxLpfELMvKOTCpSqa46X7QalA2l5
         UANpcbjm1pn0bLeMwgwtoKAHHQbr8GakJhpApCiruMbFf1YOwuEaS3YOKkiL8C5lo+8I
         9qEKs0pQpDSJSmiFoBN0+24K35OGu5p/DY/WsIDo68wFBWm9nB8Kcd2FJKXLzBrbnesk
         qZcQ==
X-Gm-Message-State: AOAM530pb1Q+ov4r8SbaZwNWsrGyvaJzS12Ofde0d6cgjh3EAPmDvJxE
        hCFdJMZ/qYC/55aFSSYAUEAKZBgxFr+0gqTrodFZ/H+GyzX4MXYiBKNK9Cb2JzyiJcY+fMLWjOb
        HfFIFeZ7e5+AmFjc3Aj9x658bg9bOv2xTnuTvfeco3QstXxFg/HvqUZtRdYegEVA=
X-Google-Smtp-Source: ABdhPJwPp9QclmALHfHbJvCrjw6DYMunQ3BJQBeJo6Q7PZuoDs8KX0wBYVrqMr1zbCs62Slwx6suN3zVbttFIA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a63:a552:: with SMTP id
 r18mr29658452pgu.408.1636065180629; Thu, 04 Nov 2021 15:33:00 -0700 (PDT)
Date:   Thu,  4 Nov 2021 15:32:46 -0700
Message-Id: <20211104223246.443738-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH] kvm: x86: Convert return type of *is_valid_rdpmc_ecx() to bool
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These function names sound like predicates, and they have siblings,
*is_valid_msr(), which _are_ predicates. Moreover, there are comments
that essentially warn that these functions behave unexpectedly.

Flip the polarity of the return values, so that they become
predicates, and convert the boolean result to a success/failure code
at the outer call site.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.c           | 2 +-
 arch/x86/kvm/pmu.h           | 4 ++--
 arch/x86/kvm/svm/pmu.c       | 5 ++---
 arch/x86/kvm/vmx/pmu_intel.c | 7 +++----
 arch/x86/kvm/x86.c           | 4 +++-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..09873f6488f7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -319,7 +319,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 }
 
 /* check if idx is a valid index to access PMU */
-int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0e4f2b1fa9fb..59d6b76203d5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -32,7 +32,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
-	int (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
+	bool (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
@@ -149,7 +149,7 @@ void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
+bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fdf587f19c5f..871c426ec389 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -181,14 +181,13 @@ static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
 }
 
-/* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	idx &= ~(3u << 30);
 
-	return (idx >= pmu->nr_arch_gp_counters);
+	return idx < pmu->nr_arch_gp_counters;
 }
 
 /* idx is the ECX register of RDPMC instruction */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b8e0d21b7c8a..1b7456b2177b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -118,16 +118,15 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-/* returns 0 if idx's corresponding MSR exists; otherwise returns 1. */
-static int intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
 
 	idx &= ~(3u << 30);
 
-	return (!fixed && idx >= pmu->nr_arch_gp_counters) ||
-		(fixed && idx >= pmu->nr_arch_fixed_counters);
+	return fixed ? idx < pmu->nr_arch_fixed_counters
+		     : idx < pmu->nr_arch_gp_counters;
 }
 
 static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c1c4e2b05a63..d7def720227d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7328,7 +7328,9 @@ static void emulator_set_smbase(struct x86_emulate_ctxt *ctxt, u64 smbase)
 static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
 			      u32 pmc)
 {
-	return kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc);
+	if (kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc))
+		return 0;
+	return -EINVAL;
 }
 
 static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
-- 
2.34.0.rc0.344.g81b53c2807-goog

