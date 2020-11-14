Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE81C2B2AA4
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 02:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKNBuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 20:50:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNBuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 20:50:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1o8KY027197;
        Sat, 14 Nov 2020 01:50:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RoY7vADXvZBH6eQ1YOmB9jmZ9jrthxlBzJHtzmbeFro=;
 b=pa4zURwm0Ng7ZkvNYA4+P0E7k/J+yMvUjUJol2Xy+AzFX9DQcrmjma5i/moJ3+sSG/sw
 fy49r9TZTKhC4gynA3Z1xoVyoCle4PAQiRC9x+tkC0vbwglMH3YDQp1hLoUINToQsSJm
 Ioegyp5TDHlHsVlmYOw9sXiqSu8a63zAkmLB6F8eAfla+0GmS9Xwoql5z5HZsqg8dLhG
 vqTJwlVaPgrMmQVPwaUSEP8XJd8rHrCSRbLZaKlRiilRFcEwpNCnvfIXFqlpnhZO4Dmp
 ZjesXpoKRSByulHb4NZknKVOBFxzaZxzTjLMtC8A3gCVSY07uM6anugn9elwuFvSx19O mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72f31cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 01:50:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1kJr6142811;
        Sat, 14 Nov 2020 01:50:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34t4bsbp8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 01:50:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE1o7Wp022745;
        Sat, 14 Nov 2020 01:50:07 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 17:50:06 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 3/5 v5] KVM: nSVM: Fill in conforming svm_nested_ops via macro
Date:   Sat, 14 Nov 2020 01:49:53 +0000
Message-Id: <20201114014955.19749-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
References: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140009
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The names of the nested_svm_ops functions do not have a corresponding
'nested_svm_' prefix. Generate the names using a macro so that the names are
conformant. Fixing the naming will help in better readability and
maintenance of the code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 200674190449..4cdeacaf768f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -196,7 +196,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
+static bool nested_svm_get_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	if (!nested_svm_vmrun_msrpm(svm)) {
@@ -834,7 +834,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
 		/*
 		 * Host-intercepted exceptions have been checked already in
 		 * nested_svm_exit_special.  There is nothing to do here,
-		 * the vmexit is injected by svm_check_nested_events.
+		 * the vmexit is injected by nested_svm_check_events.
 		 */
 		vmexit = NESTED_EXIT_DONE;
 		break;
@@ -965,7 +965,7 @@ static void nested_svm_init(struct vcpu_svm *svm)
 }
 
 
-static int svm_check_nested_events(struct kvm_vcpu *vcpu)
+static int nested_svm_check_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
@@ -1049,7 +1049,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
-static int svm_get_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_get_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
 {
@@ -1106,7 +1106,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 	return kvm_state.size;
 }
 
-static int svm_set_nested_state(struct kvm_vcpu *vcpu,
+static int nested_svm_set_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				struct kvm_nested_state *kvm_state)
 {
@@ -1209,9 +1209,11 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+#define KVM_X86_NESTED_OP_NAME(name) .name = nested_svm_##name
+
 struct kvm_x86_nested_ops svm_nested_ops = {
-	.check_events = svm_check_nested_events,
-	.get_pages = svm_get_nested_state_pages,
-	.get_state = svm_get_nested_state,
-	.set_state = svm_set_nested_state,
+	KVM_X86_NESTED_OP_NAME(check_events),
+	KVM_X86_NESTED_OP_NAME(get_pages),
+	KVM_X86_NESTED_OP_NAME(get_state),
+	KVM_X86_NESTED_OP_NAME(set_state),
 };
-- 
2.27.0

