Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B274209B12
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390743AbgFYIEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:04:32 -0400
Received: from 8bytes.org ([81.169.241.247]:48816 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390452AbgFYIDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 04:03:32 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9AD44249; Thu, 25 Jun 2020 10:03:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/4] KVM: SVM: Rename struct nested_state to svm_nested_state
Date:   Thu, 25 Jun 2020 10:03:22 +0200
Message-Id: <20200625080325.28439-2-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625080325.28439-1-joro@8bytes.org>
References: <20200625080325.28439-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Renaming is only needed in the svm.h header file.

No functional changes.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kvm/svm/svm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..6a1864a1f029 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -81,7 +81,7 @@ struct kvm_svm {
 
 struct kvm_vcpu;
 
-struct nested_state {
+struct svm_nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
@@ -133,7 +133,7 @@ struct vcpu_svm {
 
 	ulong nmi_iret_rip;
 
-	struct nested_state nested;
+	struct svm_nested_state nested;
 
 	bool nmi_singlestep;
 	u64 nmi_singlestep_guest_rflags;
-- 
2.27.0

