Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE3D4C0ADF
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiBWETc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiBWETb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:19:31 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF993B2BD
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:04 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id z23-20020a5ec917000000b0064142c95dc1so4075764iol.20
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hgAQAdRcLSzomebV7T5zWpSf8Sqv0crdtVr6zMUFKdo=;
        b=kLwPfeDgRiC06/LMgqmn21pwYTrxD8wWyQPGPXcy9D5sejy59RpWLZLIQfhAB+7zbc
         UY8NGRAIA/uzhchPlRZh02gB57nAAh+rHFQ/fKY8iCPv11qjGweXN7axa5k0LChl838B
         75ogCb4VXicj9FhFFZ1Yj+9NhwvxVqHXXotu2QrkDDsmktMKg5iAkGgKBksVa2CwESXI
         zIYzPofAe8tu+R+Ku5SZaCoqWoGZtlDJUgJpwH1cUKKMKUTh2JBs0D3DMLG0s6Y2v9gu
         BNgkm7kVQI3AicbTSQlDah8CFngEj49pKQFj0cYsXbMu6gUt2u9IY6KgORJo+1rdQi7m
         OkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hgAQAdRcLSzomebV7T5zWpSf8Sqv0crdtVr6zMUFKdo=;
        b=s5R05SeRISZSvH10qWTqzQaa7z8/KAvtopdAhUGGQFK9i0JsHpXjOPaTtHIE4+mgq3
         veEg9xazNmwtKN2coy2kK08m2r0K6bHuhNVJNixjx+aC1Blj0taLWgQkEsaJU3QI7U02
         PTY4GpZlUVx+WyGDs5VIW4Qe5zPeQOHta1mdK/1Ht8JU2PSe8c5qvunV2t07pHy/XFOs
         eY3HSAVb/D8mb9Yh9qb8CrCqVBq665qllp3nKUVdo/MEmKhNyxw4pmcu0LjmB4hfG1O8
         QHu9p9dDRwBTm1RP/Mxiugbgp7F+8BHCtaeMDkTVp4mLihrAPNjFo7mvLOrPOvVLGnxI
         f4uw==
X-Gm-Message-State: AOAM530DKwEnQ2ATmtTZUMQYzUEKk5ZctRhvryleLtzhmOyBe+CMkEbg
        pUBe5vVZkhrQJNmB5B8KVqBeqotUhXY=
X-Google-Smtp-Source: ABdhPJzesx/F3VdiTU8q8DAYdFAI9MvGQ2hrEzXrG+QY121eCCuyEw1mDHNKhI3wKWR0nN2+nmdX/YoCJRw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:378c:b0:313:f08c:e4df with SMTP id
 w12-20020a056638378c00b00313f08ce4dfmr21162221jal.192.1645589943753; Tue, 22
 Feb 2022 20:19:03 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:26 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-2-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 01/19] KVM: arm64: Drop unused param from kvm_psci_version()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_psci_version() consumes a pointer to struct kvm in addition to a
vcpu pointer. Drop the kvm pointer as it is unused. While the comment
suggests the explicit kvm pointer was useful for calling from hyp, there
exist no such callsite in hyp.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220208012705.640444-1-oupton@google.com
---
 arch/arm64/kvm/psci.c  | 6 +++---
 include/kvm/arm_psci.h | 6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 3eae32876897..a0c10c11f40e 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -85,7 +85,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 	if (!vcpu->arch.power_off) {
-		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
+		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
 			return PSCI_RET_INVALID_PARAMS;
@@ -392,7 +392,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
+	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
@@ -471,7 +471,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	switch (reg->id) {
 	case KVM_REG_ARM_PSCI_VERSION:
-		val = kvm_psci_version(vcpu, vcpu->kvm);
+		val = kvm_psci_version(vcpu);
 		break;
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
 	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 5b58bd2fe088..297645edcaff 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -16,11 +16,7 @@
 
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
-/*
- * We need the KVM pointer independently from the vcpu as we can call
- * this from HYP, and need to apply kern_hyp_va on it...
- */
-static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
+static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Our PSCI implementation stays the same across versions from
-- 
2.35.1.473.g83b2b277ed-goog

