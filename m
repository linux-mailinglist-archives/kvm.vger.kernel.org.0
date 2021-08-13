Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C07B3EB19B
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhHMHiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhHMHiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7Whtq048340;
        Fri, 13 Aug 2021 03:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MY95BHSRozJZTcRpwvoslnplJSwCGmTxBEimIieDAno=;
 b=OwUXTpo6PtvI7wchYPPJ+5Zan+IDI+04f++864AvUXa77+fSXdVgIGUdGd7iHtEct7B4
 Z+HTEXUdHAlI3ts9sOUNY++H0IW9P22W1RMwpRSx0e+ETZNtq7ipTYy/8vGuVD89ETRz
 ubfLe9gFrh8mtCovQci2Tnqm5I+JbHBHb1DfskGj+k+f1EhOCBY8N60j2rLIAVw1q2ls
 BGPHnfAdqDjFtKE/HcLO+FBBVmwtETL9I2Oay9DHup63SPXTpgPYnCLdSbD7hQWA7sa6
 8dP31lxfo3Ulxqm2WeGvWs64ceiVusECsFzvg5oKpYa9Q2fn/vBtdPcpbTJ94s8sf6TI +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1r15uts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7XBqD050142;
        Fri, 13 Aug 2021 03:37:36 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad1r15us9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:35 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7MWZ6003185;
        Fri, 13 Aug 2021 07:37:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3ada8sgjmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bVEa51380688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FBD24204F;
        Fri, 13 Aug 2021 07:37:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B869B4203F;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 2/8] lib: s390x: Add 0x3d, 0x3e and 0x3f PGM constants
Date:   Fri, 13 Aug 2021 07:36:09 +0000
Message-Id: <20210813073615.32837-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210813073615.32837-1-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -mueoyQH7zW3DzkgykEOIGnia_foDmZB
X-Proofpoint-ORIG-GUID: buVezn8skMzFyvDgPsabWF9QXGmTfwS7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For UV and format 4 SIE tests we need to handle the following PGM exceptions:
0x3d Secure Storage Access (non-secure CPU accesses secure storage)
0x3e Non-Secure Storage Access (secure CPU accesses non-secure storage)
0x3f Mapping of secure guest is wrong

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 3 +++
 lib/s390x/interrupt.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15cf7d48..4ca02c1d 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -177,6 +177,9 @@ _Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
 #define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
 #define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
 #define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
+#define PGM_INT_CODE_SECURE_STOR_ACCESS		0x3d
+#define PGM_INT_CODE_NON_SECURE_STOR_ACCESS	0x3e
+#define PGM_INT_CODE_SECURE_STOR_VIOLATION	0x3f
 #define PGM_INT_CODE_MONITOR_EVENT		0x40
 #define PGM_INT_CODE_PER			0x80
 #define PGM_INT_CODE_CRYPTO_OPERATION		0x119
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 785b7355..01ded49d 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -115,6 +115,9 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	case PGM_INT_CODE_REGION_THIRD_TRANS:
 	case PGM_INT_CODE_PER:
 	case PGM_INT_CODE_CRYPTO_OPERATION:
+	case PGM_INT_CODE_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
+	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
 		/* The interrupt was nullified, the old PSW points at the
 		 * responsible instruction. Forward the PSW so we don't loop.
 		 */
-- 
2.30.2

