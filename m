Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C63100C04
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 20:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRTLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 14:11:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfKRTLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 14:11:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIJ4QBo069769;
        Mon, 18 Nov 2019 19:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=jqntQIYG1FyyXBP32zeHpN8TlRj0EAJHe6PAVy5wr/8=;
 b=IN9Rq1CzqwihzGmKHXqcvKmlLsHVUGfVlHjBKJa11eMsvB9j3RuBU2gyjb2avDnmRniF
 QKDpie2150Eu8h4yo/nmNuNb9HVezqzXqA5cVJ+Ripyf7DWq6j2YhtVl2hFu4tSQzoiR
 QBJ48D42me74nwRKz5aCAbzQ3+aKR8hQcbRO5S/KVqGkPkXtQxAauoYD21LU+VgKHmuF
 QQIWsXr9J5KKQIRLKZGUKFffGAeMiH5Y9eUQ/bnj6sbSrAmQm/Sw//dRnCppbjLcWLma
 kskObHkwztzM0+VibZ8s2O5iPoVhwZFYmU025Z+p0rVhgfix6+ayS1R4Iv2wlKKZwg8D jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8htjbxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 19:11:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAIJ940Z062644;
        Mon, 18 Nov 2019 19:11:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wc0af2rmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 19:11:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAIJBZIC028813;
        Mon, 18 Nov 2019 19:11:35 GMT
Received: from Lirans-MBP.Home (/79.181.226.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 11:11:35 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>
Subject: [PATCH] KVM: nVMX: Use semi-colon instead of comma for exit-handlers initialization
Date:   Mon, 18 Nov 2019 21:11:21 +0200
Message-Id: <20191118191121.43440-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=724
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=784 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc11fcbbe12b..229ca7164318 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6051,23 +6051,23 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 		init_vmcs_shadow_fields();
 	}
 
-	exit_handlers[EXIT_REASON_VMCLEAR]	= handle_vmclear,
-	exit_handlers[EXIT_REASON_VMLAUNCH]	= handle_vmlaunch,
-	exit_handlers[EXIT_REASON_VMPTRLD]	= handle_vmptrld,
-	exit_handlers[EXIT_REASON_VMPTRST]	= handle_vmptrst,
-	exit_handlers[EXIT_REASON_VMREAD]	= handle_vmread,
-	exit_handlers[EXIT_REASON_VMRESUME]	= handle_vmresume,
-	exit_handlers[EXIT_REASON_VMWRITE]	= handle_vmwrite,
-	exit_handlers[EXIT_REASON_VMOFF]	= handle_vmoff,
-	exit_handlers[EXIT_REASON_VMON]		= handle_vmon,
-	exit_handlers[EXIT_REASON_INVEPT]	= handle_invept,
-	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid,
-	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc,
+	exit_handlers[EXIT_REASON_VMCLEAR]	= handle_vmclear;
+	exit_handlers[EXIT_REASON_VMLAUNCH]	= handle_vmlaunch;
+	exit_handlers[EXIT_REASON_VMPTRLD]	= handle_vmptrld;
+	exit_handlers[EXIT_REASON_VMPTRST]	= handle_vmptrst;
+	exit_handlers[EXIT_REASON_VMREAD]	= handle_vmread;
+	exit_handlers[EXIT_REASON_VMRESUME]	= handle_vmresume;
+	exit_handlers[EXIT_REASON_VMWRITE]	= handle_vmwrite;
+	exit_handlers[EXIT_REASON_VMOFF]	= handle_vmoff;
+	exit_handlers[EXIT_REASON_VMON]		= handle_vmon;
+	exit_handlers[EXIT_REASON_INVEPT]	= handle_invept;
+	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
+	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
 
 	kvm_x86_ops->check_nested_events = vmx_check_nested_events;
 	kvm_x86_ops->get_nested_state = vmx_get_nested_state;
 	kvm_x86_ops->set_nested_state = vmx_set_nested_state;
-	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages,
+	kvm_x86_ops->get_vmcs12_pages = nested_get_vmcs12_pages;
 	kvm_x86_ops->nested_enable_evmcs = nested_enable_evmcs;
 	kvm_x86_ops->nested_get_evmcs_version = nested_get_evmcs_version;
 
-- 
2.20.1

