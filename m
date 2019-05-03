Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A655012E3B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfECMrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:00 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60834 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfECMrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8F3F15AD;
        Fri,  3 May 2019 05:46:59 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 718F83F220;
        Fri,  3 May 2019 05:46:56 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 39/56] KVM: arm/arm64: Clean up vcpu finalization function parameter naming
Date:   Fri,  3 May 2019 13:44:10 +0100
Message-Id: <20190503124427.190206-40-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Currently, the internal vcpu finalization functions use a different
name ("what") for the feature parameter than the name ("feature")
used in the documentation.

To avoid future confusion, this patch converts everything to use
the name "feature" consistently.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/kvm/reset.c            | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 7feddacbc207..fe7754315e9c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -412,7 +412,7 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
-static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what)
+static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 {
 	return -EINVAL;
 }
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6adf08ba9277..7a096fdb333d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -627,7 +627,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
-int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what);
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 8847f389f56d..3402543fdcd3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -186,9 +186,9 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what)
+int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
 {
-	switch (what) {
+	switch (feature) {
 	case KVM_ARM_VCPU_SVE:
 		if (!vcpu_has_sve(vcpu))
 			return -EINVAL;
-- 
2.20.1

