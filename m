Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F150C2FFB6F
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 04:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbhAVDuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 22:50:44 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50331 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbhAVDum (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 22:50:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UMUXRqj_1611287391;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMUXRqj_1611287391)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Jan 2021 11:49:56 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] KVM: nSVM: Assign boolean values to a bool variable
Date:   Fri, 22 Jan 2021 11:49:49 +0800
Message-Id: <1611287389-63591-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following coccicheck warnings:

./arch/x86/kvm/svm/nested.c:752:2-32: WARNING: Assignment of
0/1 to bool variable.

./arch/x86/kvm/svm/nested.c:545:1-31: WARNING: Assignment of
0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cb4c6ee..3b2b445 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -534,7 +534,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 
 	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
-	svm->nested.nested_run_pending = 1;
+	svm->nested.nested_run_pending = true;
 
 	if (enter_svm_guest_mode(svm, vmcb12_gpa, vmcb12))
 		goto out_exit_err;
@@ -543,7 +543,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		goto out;
 
 out_exit_err:
-	svm->nested.nested_run_pending = 0;
+	svm->nested.nested_run_pending = false;
 
 	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
 	svm->vmcb->control.exit_code_hi = 0;
-- 
1.8.3.1

