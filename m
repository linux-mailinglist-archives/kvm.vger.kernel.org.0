Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0030F3945F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbfFGScs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 14:32:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47542 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbfFGScs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 14:32:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57ITL6p054648;
        Fri, 7 Jun 2019 18:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=Fw3SdGK6AUcy8ufifD2WpeRlL8K9PLFnG4RodHamVIg=;
 b=m4GKNYerbsGM7qRVxIpBK74IvpySQr8acoyCwVyNTeSb4rCd+Lfdp8DwqYsUnu2Ek0yq
 IJgtXEJ9j3m72CdQnHSH2mnEsHUb6CHc7uTeN79X1E7KBImnwcXgjHkUhkFudZmoVAmA
 1Cqhz0eLhr4uvDNAXJSU6Dap5zHnHhE2wCN66YOmvpvnGnP3RqC3fgLwmdQkWdvZczP/
 amsW1m8XR/z/6mrVQ8UZlYDA14w4oPMDESNva8Suxnr+ewqL0pXXi1U7lcgMHttmLXbl
 tTvRYjAJW49/WasMd1RRZ+R1cs6aC2RbehbmN4UmKHH9BbCJ9imYpceiFcREDtPodzZR uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sueve06rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 18:32:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57IVxpu041744;
        Fri, 7 Jun 2019 18:32:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2swngk5nfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 18:32:00 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57IVwXT028486;
        Fri, 7 Jun 2019 18:31:59 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 11:31:58 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com
Subject: [PATCH] nVMX: Get rid of prepare_vmcs02_early_full and inline its content in the caller
Date:   Fri,  7 Jun 2019 14:05:44 -0400
Message-Id: <20190607180544.17241-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=721
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=757 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..as there is no need for a separate function

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..4643eb3a97f7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1963,28 +1963,24 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	vmx_set_constant_host_state(vmx);
 }
 
-static void prepare_vmcs02_early_full(struct vcpu_vmx *vmx,
-				      struct vmcs12 *vmcs12)
-{
-	prepare_vmcs02_constant_state(vmx);
-
-	vmcs_write64(VMCS_LINK_POINTER, -1ull);
-
-	if (enable_vpid) {
-		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
-			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid02);
-		else
-			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
-	}
-}
-
 static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
 	u32 exec_control, vmcs12_exec_ctrl;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
-	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
-		prepare_vmcs02_early_full(vmx, vmcs12);
+	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
+		prepare_vmcs02_constant_state(vmx);
+
+		vmcs_write64(VMCS_LINK_POINTER, -1ull);
+
+		if (enable_vpid) {
+			if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
+				vmcs_write16(VIRTUAL_PROCESSOR_ID,
+					     vmx->nested.vpid02);
+			else
+				vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
+		}
+	}
 
 	/*
 	 * PIN CONTROLS
-- 
2.20.1

