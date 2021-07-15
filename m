Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756493C997B
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 09:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbhGOHTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 03:19:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhGOHTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 03:19:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16F74A2m192525;
        Thu, 15 Jul 2021 03:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GizgIYywcAux3zcCVCy3Hw6aVXD7ZoaHT+6raTBhXr0=;
 b=l4zggzNzudJchz2CxmO6tgwrwCtEm6gtQLl0pEVem3hCYR0TiP++gqI80ps/ZNyIsaKp
 QsCQhMYkTILOeKG7MsmEGtW318rhMICOj6YVzyTs1vhLVPpYlA8o6Z4AGsPA7zq3Tr9S
 qjc4Fl+bhChv3lSCwI6auZXdDnaNA9JH/jQNmJJ+FghbU+WhzuH7y2uCwbkhdNFuN6TV
 sL2wGeQKCCcTyLAzOBChv6ibih2LuKhI2V4M/yie2cza+bOYWgwrJj+bPF+bOiZDPcxm
 Il671OQsppEmDJE2xVBXzsnPk4X0q++QqDeoi6hrE1l/jRxsy+Qu8qYmVajoHC9QkJBm rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39suek9sfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 03:16:58 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16F74PVP193867;
        Thu, 15 Jul 2021 03:16:58 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39suek9sf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 03:16:58 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16F77ZVD018014;
        Thu, 15 Jul 2021 07:16:56 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 39q36dqq2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 07:16:56 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16F7GuAx29229526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 07:16:56 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CB5928059;
        Thu, 15 Jul 2021 07:16:56 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B87C2805E;
        Thu, 15 Jul 2021 07:16:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.2.130.16])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 07:16:56 +0000 (GMT)
From:   Dov Murik <dovmurik@linux.ibm.com>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Dov Murik <dovmurik@linux.ibm.com>
Subject: [PATCH] target/i386/kvm: Remove unused workaround for kernel header typo
Date:   Thu, 15 Jul 2021 07:16:56 +0000
Message-Id: <20210715071656.3592604-1-dovmurik@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bo2U5SZSJfKrQ3sGXL1UWAY6ATdcqKiZ
X-Proofpoint-ORIG-GUID: nNQ6IL6vqOuu259ppnuJBt7_grBDcuEZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_02:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 6f131f13e68d ("kvm: support -overcommit cpu-pm=on|off",
2018-06-22) introduced a workaround for a kernel header typo
(KVM_X86_DISABLE_EXITS_HTL instead of KVM_X86_DISABLE_EXITS_HLT).

The problematic kernel header was fixed by commit 77d361b13c19
("linux-headers: Update to kernel mainline commit b357bf602",
2018-06-22).  The wrong name doesn't appear anywhere in the QEMU code.

Remove the unused typo workaround.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
---
 target/i386/kvm/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 59ed8327ac..42d54b1c63 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2327,10 +2327,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
         int ret;
 
-/* Work around for kernel header with a typo. TODO: fix header and drop. */
-#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
-#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
-#endif
         if (disable_exits) {
             disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
                               KVM_X86_DISABLE_EXITS_HLT |
-- 
2.25.1

