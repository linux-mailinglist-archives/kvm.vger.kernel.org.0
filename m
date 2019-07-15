Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6169CD4
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 22:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbfGOUbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 16:31:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731366AbfGOUbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 16:31:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKSp8Q074893;
        Mon, 15 Jul 2019 20:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=RuM/We33y5F3BvETPVybUIg9CkokQhhTxjuZp3Os5As=;
 b=CC2DSTDRDj7UIsxQ7NCGKhTxZ+GdI/kdxr19b9HDnVO8JDZ+V85R8gFHs1ZDJZ5pH+N+
 dWKpmy1/PMTraQglMRbOyYgz0NmRtPvhYoaLdnHlCUI6rbf4Bh0466coxDlvCzBFpS/A
 6LkGqfQ0Ae/3AkO69UQbuIVt5jsZmXPlz84x49M5RcZdT9OnUd1cL+lJJA5VNYsC9SWs
 cnlhBDGfBfrn7Cn4i9xE/XflPmaEevipyyThBAnTUEPOJ3X2RvIWBckza0r9KVF/OWYI
 PEyYxePhyIupoHyA08xFD4JBvAoTBcaTm/V19wzxLCNDtDl4SflETXovDGJGUJ2P4N6b ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tq7xqrp6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FKRn52015404;
        Mon, 15 Jul 2019 20:31:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tq6mmfw6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 20:31:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6FKV5ZN008601;
        Mon, 15 Jul 2019 20:31:05 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 13:31:04 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     brijesh.singh@amd.com, Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 2/2] KVM: x86: Rename need_emulation_on_page_fault() to handle_no_insn_on_page_fault()
Date:   Mon, 15 Jul 2019 23:30:43 +0300
Message-Id: <20190715203043.100483-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715203043.100483-1-liran.alon@oracle.com>
References: <20190715203043.100483-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150234
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think this name is more appropriate to what the x86_ops method does.
In addition, modify VMX callback to return true as #PF handler can
proceed to emulation in this case. This didn't result in a bug
only because the callback is called when DecodeAssist is supported
which is currently supported only on SVM.

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu.c              | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 6 +++---
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 450d69a1e6fa..536fd56f777d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1201,7 +1201,8 @@ struct kvm_x86_ops {
 				   uint16_t *vmcs_version);
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
-	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+	/* Returns true if #PF handler can proceed to emulation */
+	bool (*handle_no_insn_on_page_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81accba..889de3ccf655 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5423,7 +5423,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
 	 */
 	if (unlikely(insn && !insn_len)) {
-		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
+		if (!kvm_x86_ops->handle_no_insn_on_page_fault(vcpu))
 			return 1;
 	}
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 79023a41f7a7..ab89bb0de8df 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7118,7 +7118,7 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return -ENODEV;
 }
 
-static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
+static bool svm_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
 {
 	bool is_user, smap;
 
@@ -7291,7 +7291,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = nested_enable_evmcs,
 	.nested_get_evmcs_version = nested_get_evmcs_version,
 
-	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+	.handle_no_insn_on_page_fault = svm_handle_no_insn_on_page_fault,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f64bcbb03906..088fc6d943e9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7419,9 +7419,9 @@ static int enable_smi_window(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static bool vmx_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
+static bool vmx_handle_no_insn_on_page_fault(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	return true;
 }
 
 static __init int hardware_setup(void)
@@ -7726,7 +7726,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_nested_state = NULL,
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
-	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.handle_no_insn_on_page_fault = vmx_handle_no_insn_on_page_fault,
 };
 
 static void vmx_cleanup_l1d_flush(void)
-- 
2.20.1

