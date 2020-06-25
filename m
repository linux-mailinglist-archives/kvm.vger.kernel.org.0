Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C24B209B07
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390519AbgFYIDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:03:34 -0400
Received: from 8bytes.org ([81.169.241.247]:48846 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390491AbgFYIDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 04:03:33 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3895C412; Thu, 25 Jun 2020 10:03:31 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4/4] KVM: SVM: Rename svm_nested_virtualize_tpr() to nested_svm_virtualize_tpr()
Date:   Thu, 25 Jun 2020 10:03:25 +0200
Message-Id: <20200625080325.28439-5-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
References: <20200625080325.28439-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Match the naming with other nested svm functions.

No functional changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/svm.c | 6 +++---
 arch/x86/kvm/svm/svm.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e0b0321d95d4..b0d551bcf2a0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3040,7 +3040,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm_nested_virtualize_tpr(vcpu))
+	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
 	clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
@@ -3234,7 +3234,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm_nested_virtualize_tpr(vcpu))
+	if (nested_svm_virtualize_tpr(vcpu))
 		return;
 
 	if (!is_cr_intercept(svm, INTERCEPT_CR8_WRITE)) {
@@ -3248,7 +3248,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (svm_nested_virtualize_tpr(vcpu) ||
+	if (nested_svm_virtualize_tpr(vcpu) ||
 	    kvm_vcpu_apicv_active(vcpu))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 003e89008331..8907efda0b0a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -365,7 +365,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
 #define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
 
-static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
+static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-- 
2.27.0

