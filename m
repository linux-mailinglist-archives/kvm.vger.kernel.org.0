Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CCB4445B4
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhKCQSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 12:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232865AbhKCQSg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 12:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635956159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+Opb5XjIjvU4WythImF8wPWmsUb4lObJFswO1EWR5cA=;
        b=OpG1ZNVgnmFHF8a+VTvMExtlvfihYnJluM2KO+F8HvBzExVwowDWGEJs+EUPDDDxRCLT/C
        pczFN1W2qe1uRASVJPfQN1Cf4LBFXvtsci1TYaYGD1PvvQDoh/FcVSjmHgdki+X7jWcx71
        NrB9eTHuEuNpH5dnd52pb1JdG+7eLN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-G_MzGzteMOyKF7Qgby8XBw-1; Wed, 03 Nov 2021 12:15:57 -0400
X-MC-Unique: G_MzGzteMOyKF7Qgby8XBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4EB81808318;
        Wed,  3 Nov 2021 16:15:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5698A60C04;
        Wed,  3 Nov 2021 16:15:56 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v1] nested.c: replace spaces with tabs
Date:   Wed,  3 Nov 2021 12:15:13 -0400
Message-Id: <20211103161513.789230-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some reasons, some code blocks are indented with spaces
instead of tabs. Checkpatch also complains when having to
deal with this code. Fix this at least in nested.c

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f8b7bc04b3e7..3cf04ef8738a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -55,19 +55,20 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 
 static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
-       struct vcpu_svm *svm = to_svm(vcpu);
-       WARN_ON(!is_guest_mode(vcpu));
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	WARN_ON(!is_guest_mode(vcpu));
 
-       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
+	if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
 	   !svm->nested.nested_run_pending) {
-               svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
-               svm->vmcb->control.exit_code_hi = 0;
-               svm->vmcb->control.exit_info_1 = fault->error_code;
-               svm->vmcb->control.exit_info_2 = fault->address;
-               nested_svm_vmexit(svm);
-       } else {
-               kvm_inject_page_fault(vcpu, fault);
-       }
+		svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1 = fault->error_code;
+		svm->vmcb->control.exit_info_2 = fault->address;
+		nested_svm_vmexit(svm);
+	} else {
+		kvm_inject_page_fault(vcpu, fault);
+	}
 }
 
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
@@ -1175,7 +1176,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 		 * vmcb field, while delivering the pending exception.
 		 */
 		if (svm->nested.nested_run_pending)
-                        return -EBUSY;
+			return -EBUSY;
 		if (!nested_exit_on_exception(svm))
 			return 0;
 		nested_svm_inject_exception_vmexit(svm);
@@ -1376,7 +1377,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	 * valid for guest mode (see nested_vmcb_check_save).
 	 */
 	cr0 = kvm_read_cr0(vcpu);
-        if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
+	if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
 		goto out_free;
 
 	/*
-- 
2.27.0

