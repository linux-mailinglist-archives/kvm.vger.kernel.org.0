Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F93ED6C7
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhHPNYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238754AbhHPNVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:52 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD3e5F190351;
        Mon, 16 Aug 2021 09:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VjWWzTpUn6+biZX9mmVU+a9U7Jp5XHOAmEoOqznkpK8=;
 b=lVTLPt4xRPAlWPC9ceThhc8g2gNWLwQg4/yg7szZJU448nerzzSoZz8bp3O7UNZMgVTq
 mX8GhhXsP2I1yamMHJNihInYdiduc+X1PBLYjNqxqGxXim40/WhEqORfZBZeT6kIC3aS
 Bdtxm1Ko2940pj8OKjrrDnpf8kPK5a++t+7otLBYAgwhqjDRp0PN9gDlFU71KH59sWRo
 E1Nez9XoozUWCDkY280/Ko8V0ZcZvQURY4aRdY5iugER2AbYctMkP9V/2a9Y3XNBj4HI
 Ijj4bEr4ViNRC1wqDfv/9dEC9eKEWwyJL83cKw/0vZpj86x6vaQduVKT8gaFm3fvZirh /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3afjmgamw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD3sWF191470;
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3afjmgamvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCnKw020365;
        Mon, 16 Aug 2021 13:21:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8ba02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDHn1O50004262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:17:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B927B11C052;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CAA511C058;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 09/11] lib: s390x: Add 0x3d, 0x3e and 0x3f PGM constants
Date:   Mon, 16 Aug 2021 15:20:52 +0200
Message-Id: <20210816132054.60078-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hyD8jk88Ab38uOkHw_0rjs_IxvjcVIvT
X-Proofpoint-ORIG-GUID: SrIZqMkILJ0eDeMpzkh3wAo7fLLlCMdt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1015 phishscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For UV and format 4 SIE tests we need to handle the following PGM exceptions:
0x3d Secure Storage Access (non-secure CPU accesses secure storage)
0x3e Non-Secure Storage Access (secure CPU accesses non-secure storage)
0x3f Mapping of secure guest is wrong

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 3 +++
 lib/s390x/interrupt.c    | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 2f70d840..d9f51efb 100644
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
2.31.1

