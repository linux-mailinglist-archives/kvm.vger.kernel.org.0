Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B7367A7
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfFEWzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 18:55:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEWzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 18:55:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MsU5c192234;
        Wed, 5 Jun 2019 22:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=1/Rf+Uia91GwLefsV7NXX/5Bg+edmw1IcgH4UE0k70Q=;
 b=GlvadEvgYC3OVeg6AOgdWxDzm4ZD1HE9IHvgh7oeK0XikDqAdD2KaB/b7EYR5PCPrQ+9
 ucpyt4gY9BPwR9wkGALyEsxOf8JJ7qKt/mMvMKYh9qcbCv2ECzz4Be75jKpzuLv8IlT7
 oq7C2076uBtbNJTQuX+fA+2fQB6C7YTg4ElabAjnccjRfZOkxreIhZqgn8QWYuAum6W9
 cg4KVowGvDoAFsGHjwjTm/MTr+l6tdyn8nrov8zh5YKDnlyZs26cj72sCLKnM/UXfD63
 C+AaQEeC2tzmlDlNL7rQI4DOXHcBSEY/PnikEwr3MyaKScl3lODgxIl7NhWYYhCMFFUM IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstnc4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 22:55:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x55MsW2G055779;
        Wed, 5 Jun 2019 22:55:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnhaekws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jun 2019 22:55:21 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x55MtKfD026486;
        Wed, 5 Jun 2019 22:55:20 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Jun 2019 15:55:20 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: x86: Use DR_TRAP_BITS instead of hard-coded 15
Date:   Thu,  6 Jun 2019 01:54:47 +0300
Message-Id: <20190605225447.12192-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906050146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9279 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906050146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make all code consistent with kvm_deliver_exception_payload() by using
appropriate symbolic constant instead of hard-coded number.

Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/x86.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0d5dd44b4f4..199cd2cf7254 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4260,7 +4260,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
 		ulong dr6;
 
 		ctxt->ops->get_dr(ctxt, 6, &dr6);
-		dr6 &= ~15;
+		dr6 &= ~DR_TRAP_BITS;
 		dr6 |= DR6_BD | DR6_RTM;
 		ctxt->ops->set_dr(ctxt, 6, dr6);
 		return emulate_db(ctxt);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b93e36ddee5e..f64bcbb03906 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4521,7 +4521,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 		dr6 = vmcs_readl(EXIT_QUALIFICATION);
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
-			vcpu->arch.dr6 &= ~15;
+			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			if (is_icebp(intr_info))
 				skip_emulated_instruction(vcpu);
@@ -4766,7 +4766,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
 			return 0;
 		} else {
-			vcpu->arch.dr6 &= ~15;
+			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= DR6_BD | DR6_RTM;
 			kvm_queue_exception(vcpu, DB_VECTOR);
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd759846..db9dc011965b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6381,7 +6381,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
 					   vcpu->arch.db);
 
 		if (dr6 != 0) {
-			vcpu->arch.dr6 &= ~15;
+			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			kvm_queue_exception(vcpu, DB_VECTOR);
 			*r = EMULATE_DONE;
-- 
2.20.1

