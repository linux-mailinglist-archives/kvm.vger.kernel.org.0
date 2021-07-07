Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99B3BE945
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhGGOGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15980 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231978AbhGGOGW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:22 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167E2tms092899;
        Wed, 7 Jul 2021 10:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9vJW1xY/yVXNBv5NFffilsez3d1UMJ/XV3ibK0BKCwY=;
 b=gVfMXVN1W477s0yQ8w3CrtZMmb6Y9zrOyV/RvKHwvxVZd1g06HutiDJKakXRy7HRKIPL
 ddaP/WVhM+mRXV2/I0kE0LfsYNfxm6D4mQedXV4oBYGhuY1itHd3MPSDwOjKm1rZwqV1
 8xRW4r1oiNyXSxq1nxQ+McukXxcsZ+nKljZxNxcb+9bMeAnN+rXFBSgwGM+hBZ3W8Gcu
 yPetm/cA2UoZ6mC+iN2BZJyNNeHz5IgM7T9xo2dcqcDMmM8t+fcqck/zqNQXBCvfb/Wt
 r+rMIUMaW+NgkxzbKuarml9wyjo2ZM6w26uWh/hdhZLRSQCHC/jBMyp0JaVKDNVFZnKl gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mm66gddw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:41 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167E33WW093473;
        Wed, 7 Jul 2021 10:03:40 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mm66gdan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:40 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E2gPQ005808;
        Wed, 7 Jul 2021 14:03:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E3VtK30671140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:03:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B1CA4055;
        Wed,  7 Jul 2021 14:03:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC7E2A404D;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 7/8] lib: s390x: Print if a pgm happened while in SIE
Date:   Wed,  7 Jul 2021 16:03:17 +0200
Message-Id: <20210707140318.44255-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lzo9eXhdtGlc_JZzh5uXJ2XpDFBIKKHe
X-Proofpoint-ORIG-GUID: vT0rIrVXsNpFcNNa9Unvx0iKdpWyIgK2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For debugging it helps if you know if the PGM happened while being in
SIE or not.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/interrupt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index b627942f..109f2907 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -141,10 +141,15 @@ static void print_int_regs(struct stack_frame_int *stack)
 static void print_pgm_info(struct stack_frame_int *stack)
 
 {
+	bool in_sie;
+
+	in_sie = (lc->pgm_old_psw.addr >= (uintptr_t)sie_entry &&
+		  lc->pgm_old_psw.addr <= (uintptr_t)sie_exit);
+
 	printf("\n");
-	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
-	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
-	       lc->pgm_int_id);
+	printf("Unexpected program interrupt %s: %d on cpu %d at %#lx, ilen %d\n",
+	       in_sie ? "in SIE" : "",
+	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr, lc->pgm_int_id);
 	print_int_regs(stack);
 	dump_stack();
 	report_summary();
-- 
2.31.1

