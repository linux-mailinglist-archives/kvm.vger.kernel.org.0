Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EA74ACE90
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 03:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiBHBr5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiBHB1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 20:27:18 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00FDC061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 17:27:17 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id i7-20020a056e020ec700b002be118c9b21so3733919ilk.20
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 17:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gGfwXYlGCeVdn9VPRh3V4tDKjPW4ZQjqWRu/l1nGaXA=;
        b=Rn6x40CqNhj7S3R3b9SiwvoWmH3ai4cKbllf15bsoxy4gRJWCfi7N6Oc9xQaITcyeS
         U9tGKNBkNTBZxAleegnM25vsRDWOE6hvT2Gq5GzWuUTf9n7VJHAubVx3dQijV/DtiJ9w
         tqXba1ti7uChPUXnpq8L4OW4qh89Gw+GlVRfyjPNMPULYh44MCunrH6kYlQB43SCyZPN
         BdY14rb8oYBNOlvPWqsBOeETx8XwvOIvpCiDTvZL/27CZJBgaGOqFPDWI18JKvdVn+kk
         O5X5HYo0/P7rIiWyfbiDTyPIW6zgHs1UQYfSsYyFN1L6U/ds8hG1BbP+TEM6WWjeCk1d
         z51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gGfwXYlGCeVdn9VPRh3V4tDKjPW4ZQjqWRu/l1nGaXA=;
        b=nwmznxSTSmHSSTvg7F6G+rpyeeCvxUDgE6QHbNQjSfS98IxHYevK2N81btkP1+F6iu
         HizRRZyM/bZpIcvBKVRkQNt+jvVwFMD/UxzQgxR75c0Dxa2oEL4Prm7zSvwkS8e+dzvi
         c7hycQGmjh+mQ0CA5woreXgSmRiNpAMeZ3bkWU44AVGCasOykAVyRvnlvt9U3jAdxPTa
         t0YX/P5Qe8ptCgZD0uV50wYbxp6xaFBmHKqC71DSVdTExe4HdkrbwTXTavcF+bPB8nW8
         TyBnfNTOBOxvisW8VgmMEnh1UhKAtTJU9AobbfJPbxZKV0PyOmC28M4N/ZLmL1MNYSWI
         3mqQ==
X-Gm-Message-State: AOAM531WyIli8oA8BH+Y7mgrpuD2gPDMG8EuSklPx8fNWPEmbhpvtd3p
        Jev5pOFHT9QZiCR4Obr8qa9EiaYiRE0=
X-Google-Smtp-Source: ABdhPJz67NVxJW2vaoMGx286+lfyUve0UxOOQS00muAMBgCrDOPr5VxvwaPFBQxM9shyB9jvw/hfAhJ3jr4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:2506:: with SMTP id
 v6mr1140464jat.94.1644283637128; Mon, 07 Feb 2022 17:27:17 -0800 (PST)
Date:   Tue,  8 Feb 2022 01:27:05 +0000
Message-Id: <20220208012705.640444-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH] KVM: arm64: Drop unused param from kvm_psci_version()
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
---

Applies to 5.17-rc3.

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
2.35.0.263.gb82422642f-goog

