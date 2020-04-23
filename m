Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D461B5AF1
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 14:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgDWMBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 08:01:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDWMBX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 08:01:23 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NBVk61022527
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:01:22 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30k3xuc465-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:01:21 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Thu, 23 Apr 2020 13:01:14 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Apr 2020 13:01:11 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03NC1FlJ63373404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 12:01:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6DA2A4055;
        Thu, 23 Apr 2020 12:01:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29D1BA405B;
        Thu, 23 Apr 2020 12:01:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.4.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 12:01:15 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, gor@linux.ibm.com,
        cohuck@redhat.com, david@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Philipp Rudo <prudo@linux.ibm.com>
Subject: [PATCH v1 1/1] s390/protvirt: fix compilation issue
Date:   Thu, 23 Apr 2020 14:01:14 +0200
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042312-0028-0000-0000-000003FD8FB9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042312-0029-0000-0000-000024C35A9B
Message-Id: <20200423120114.2027410-1-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_07:2020-04-22,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=1
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel fails to compile with CONFIG_PROTECTED_VIRTUALIZATION_GUEST
set but CONFIG_KVM unset.

This patch fixes the issue by making the needed variable always available.

Fixes: a0f60f8431999bf5 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Philipp Rudo <prudo@linux.ibm.com>
Suggested-by: Philipp Rudo <prudo@linux.ibm.com>
CC: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/boot/uv.c   | 2 --
 arch/s390/kernel/uv.c | 3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index 8fde561f1d07..f887a479cdc7 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -7,9 +7,7 @@
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 int __bootdata_preserved(prot_virt_guest);
 #endif
-#if IS_ENABLED(CONFIG_KVM)
 struct uv_info __bootdata_preserved(uv_info);
-#endif
 
 void uv_query_info(void)
 {
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c86d654351d1..4c0677fc8904 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -23,10 +23,11 @@
 int __bootdata_preserved(prot_virt_guest);
 #endif
 
+struct uv_info __bootdata_preserved(uv_info);
+
 #if IS_ENABLED(CONFIG_KVM)
 int prot_virt_host;
 EXPORT_SYMBOL(prot_virt_host);
-struct uv_info __bootdata_preserved(uv_info);
 EXPORT_SYMBOL(uv_info);
 
 static int __init prot_virt_setup(char *val)
-- 
2.25.3

