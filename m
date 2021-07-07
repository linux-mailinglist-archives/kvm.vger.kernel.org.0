Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6FC3BE943
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhGGOGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhGGOGT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167DXtSO165557;
        Wed, 7 Jul 2021 10:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LhHNKzf8eC+sDyppNRXNGnKxuTjdSeuQRNVuyJxGYLA=;
 b=UUYok74q2KO8pkr2kzeutDIxV+2e4BhCNrrxJFEA6RntGGC4QfT9dFX4WydAdpFUqS1Q
 8RC7MI4itrFeztxxaVBa1GXResxApbNBlTUboCQHmkfbMSI667gXQzjYWBOSwvfWzWr4
 FAqPs4EvicLhKJIBJV8v8zh0Bt+tU63cdhx+7yiPpQIQiY6tBkN13z/mZDdNWww/giYk
 OeYV95W7X6iWk+NF1NhxOzpDI8Qv8H0ahTJVgCxGMnakyNJ1EzQS/udacpFe7m2J+Hso
 CW6FuydtDbLUWVIwdqmpzCuTVSifiAgaKmOUYaoaGVi3/+UZLabEQDzJMaOvjgeCZL8r /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mts0m220-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:39 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167DYD4k166854;
        Wed, 7 Jul 2021 10:03:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mts0m20e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:38 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E1YY3004282;
        Wed, 7 Jul 2021 14:03:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9sn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E3VSX33554758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:03:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA31EA4055;
        Wed,  7 Jul 2021 14:03:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BCE2A404D;
        Wed,  7 Jul 2021 14:03:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 8/8] lib: s390x: Remove left behing PGM report
Date:   Wed,  7 Jul 2021 16:03:18 +0200
Message-Id: <20210707140318.44255-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B7_u8As3iXNTnuHLd-88L8fyLLeh47nO
X-Proofpoint-GUID: qzbHSJjNx4395mVd9fZjWC6wzi8-me3m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I added the backtrace support I forgot to remove the PGM report.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/interrupt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 109f2907..785b7355 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -162,9 +162,6 @@ void handle_pgm_int(struct stack_frame_int *stack)
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
 		print_pgm_info(stack);
-		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
-			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
-			     lc->pgm_int_id);
 	}
 
 	pgm_int_expected = false;
-- 
2.31.1

