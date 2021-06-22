Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD313AFF15
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFVIXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:23:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhFVIXv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M83Uck020691;
        Tue, 22 Jun 2021 04:21:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=17/ky+kFRnDh8Wevz9eO3A82JHOeyzzotomVJe+ma5o=;
 b=srCsGaiDZOGPnpKIbKM1+i1ecJM7jS2ozohWyPgc27010s5qq+54zjahiWI8/zAnYFuU
 po4v+ba9ImGAZOnfFgsC7pRdbgtDI0jxtAbLwn+t8oMSIqqYddAXzc3DLhbgzU6zK6JU
 qXued9HT29ezFNvU2W4OCw4IQE4rIuUJuOU4Bq0UhGMJTClmJGX+bSX4/GfuvzajXPro
 T6WAq7VlX13Gqgw9/odOz4BYvdiaG4jDRqi80Aj3BamFdoLQ8fYA0Qmnf5ZZV8kRPp3C
 lIqQqErLG83SFEM03k+y/z1hZpb6fz8l6/l+wjAxM2DpC1ZxQ0569RUer2vNyR5LMtWQ Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5ugh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:35 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M83ova022033;
        Tue, 22 Jun 2021 04:21:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5ufy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8DWpt003018;
        Tue, 22 Jun 2021 08:21:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3998789a7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8LUoM31129968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AAB3AE055;
        Tue, 22 Jun 2021 08:21:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71EE5AE053;
        Tue, 22 Jun 2021 08:21:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 01/12] s390x: sie: Only overwrite r3 if it isn't needed anymore
Date:   Tue, 22 Jun 2021 10:20:31 +0200
Message-Id: <20210622082042.13831-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b1_VbLabQqJ5IGC4lYjac4cj0iZgTts0
X-Proofpoint-ORIG-GUID: 3KdcAlejPgQQi8xRxodIHxsOMZld0A4J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=958
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The lmg overwrites r3 which we later use to reference the fprs and fpc.
Let's do the lmg at the end where overwriting is fine.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 s390x/cpu.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/cpu.S b/s390x/cpu.S
index e2ad56c8..82b5e25d 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -81,11 +81,11 @@ sie64a:
 	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
 
 	# Load guest's gprs, fprs and fpc
-	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
 	.endr
 	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
+	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
 
 	# Move scb ptr into r14 for the sie instruction
 	lg	%r14,__SF_SIE_CONTROL(%r15)
-- 
2.31.1

