Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1092FF73D0
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKMZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:25:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKMZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:25:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCOTI5017521;
        Mon, 11 Nov 2019 12:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=P0K6cU96LNxUK1pAoLlienSjeAcEI6JVMleECctv77I=;
 b=I5FhCS6VeYZpYGJLChbpahladJdORA4yX29aW2vCzypq9c0Sn4E9+0opWoXU7iXMUT9V
 D2OKPvOeXmtrvNoVkzZSjt7hshc27O5t1WeRdxp6oDUpdRgqzrV1dn+pHc4u1AqsuzJu
 DcndsCUUDiw2qEeN2TgaU0flWYtHPLeyXpTPRLq/7GwMA/T+eU3XKdu0nrb+cCSTXZoV
 hn42ROh7IYR5jJcI/r8CMJk0oK4lYiIiHlQJI2XlLrKbb4sydE95fQXl6HTvyMhVlq9d
 /DlwJmsA+tcjbLGQq+4loyPHt9WZ1PzumAzXd5SLalTUFG5onMvi7xL9NktjOpskSna3 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndpxr5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:25:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCNND7057998;
        Mon, 11 Nov 2019 12:25:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w67kkww6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:25:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCPbZm004494;
        Mon, 11 Nov 2019 12:25:37 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 04:25:37 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: VMX: Fix comment to specify PID.ON instead of PIR.ON
Date:   Mon, 11 Nov 2019 14:25:25 +0200
Message-Id: <20191111122525.93098-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=428
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110118
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=499 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Outstanding Notification (ON) bit is part of the Posted Interrupt
Descriptor (PID) as opposed to the Posted Interrupts Register (PIR).
The latter is a bitmap for pending vectors.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d21a4ab28cf..f53b0c74f7c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6137,7 +6137,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	if (pi_test_on(&vmx->pi_desc)) {
 		pi_clear_on(&vmx->pi_desc);
 		/*
-		 * IOMMU can write to PIR.ON, so the barrier matters even on UP.
+		 * IOMMU can write to PID.ON, so the barrier matters even on UP.
 		 * But on x86 this is just a compiler barrier anyway.
 		 */
 		smp_mb__after_atomic();
-- 
2.20.1

