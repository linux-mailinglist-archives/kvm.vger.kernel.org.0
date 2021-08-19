Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68F43F2331
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhHSWhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhHSWhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:22 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736F2C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:45 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id u34-20020a0568081522b02902681e945a49so2817945oiw.3
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t7LGVP554kQR/vFvXnoLO0aCqVqH2J9lOsbFtuSIcI4=;
        b=DLI1eqQzEY0keU0Orx7pME9tox5Hvur8IuWHPfTx+TTKqi2uO/ML4CE9piZNe25md6
         olqvrWP8NtlBAC71qgsBVDpcGssFvzk/ndE74qecXRzZvAGHOgBOEp3sWs6pwvrUpP4G
         W+FaQHw5lkFoY7nkPYfpqLPNDmrIa4NaGwi99zBIzahLXGQQJJdusjc+BgbUHnnHfr6S
         Ie/Ww2IOQr+yDkNlgH6Ww4iitlywmC9DIMUYmWqIju1KJT5Wquu/GkhkAuJ9pSxK193H
         vLUZYmTsFJVDFm/Niydj1hZ9mWzk+HKshim0XBlmQNEsVIcyckgzsdTe6llZ4wNL6wVb
         6Eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t7LGVP554kQR/vFvXnoLO0aCqVqH2J9lOsbFtuSIcI4=;
        b=ZDeqgUaSycnROnw/rrqU+l83sHkldCnqaZx4pbZ6OOcvnPYtYXBASpE1aafaS7Zkev
         WXSpwpjmGSJ+BCGyMGL8MjEUxf8rgseK1hb8o5IfoB9LcqKijKBvFonVDm8g4dGxqMkA
         mz+VaJYo9GPvI9/QAxfS5cfUawXjbcRCWIdgAe2HvXiBVh7rfRyKp+8lJLfqwol4Yhbv
         h64zl+ttTx4FmFxuBF5ag2gRpDP9zNoVojwxcGdRGzeCxd74fYs4z8a8Qumwmqr+gUzU
         Q1SLmBtV4QiYbgzVW21PyqLE8FEF7oMtztR+Lqb6rhIsoZqrmgOY/fYb2Q7KXoYWcIzo
         q42Q==
X-Gm-Message-State: AOAM532rPTC31VZqbCsHwCthSOUk38bnUBgOcGXRjHT+Q4fwTHnjwTh7
        Y39pPaIBfYwVUWdZKKYdl/9fj6TcG2wS/HFyzZl/+un6lvwnolV4SiPLfkdqjNvtbqQOd8KzIxU
        a6l18melisveYnM1zCZwiGD4xO7qmtpcCr1C9MUOm1M+UN+JHs1WYwccidw==
X-Google-Smtp-Source: ABdhPJy6FTCFvhaf0mQy7xMNvESNDrcZSCkWNkPa6rAsPIGBY1VYRlZ/B+ES23ZKv0Zz9rtSfEUmMv83/Qg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6830:1589:: with SMTP id
 i9mr11062299otr.196.1629412604681; Thu, 19 Aug 2021 15:36:44 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:35 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-2-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 1/6] KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The helper function does not need a pointer to the vCPU, as it only
consults a constant mask; drop the unused vcpu parameter.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 74c47d420253..d46842f45b0a 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -59,8 +59,7 @@ static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 	kvm_vcpu_kick(vcpu);
 }
 
-static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
-					   unsigned long affinity)
+static inline bool kvm_psci_valid_affinity(unsigned long affinity)
 {
 	return !(affinity & ~MPIDR_HWID_BITMASK);
 }
@@ -73,7 +72,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
-	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
+	if (!kvm_psci_valid_affinity(cpu_id))
 		return PSCI_RET_INVALID_PARAMS;
 
 	vcpu = kvm_mpidr_to_vcpu(kvm, cpu_id);
@@ -132,7 +131,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 	target_affinity = smccc_get_arg1(vcpu);
 	lowest_affinity_level = smccc_get_arg2(vcpu);
 
-	if (!kvm_psci_valid_affinity(vcpu, target_affinity))
+	if (!kvm_psci_valid_affinity(target_affinity))
 		return PSCI_RET_INVALID_PARAMS;
 
 	/* Determine target affinity mask */
-- 
2.33.0.rc2.250.ged5fa647cd-goog

