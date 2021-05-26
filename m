Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259AD391AEC
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhEZO5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52488 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235221AbhEZO5b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:31 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEXMqA110902;
        Wed, 26 May 2021 10:56:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vcREnjPwI2Mgoeiw2rGhFb+6/uFe6268dw7vtHlM+sA=;
 b=Kl8VLE1w3AwE2TRJxkFSyJwKp6VzUNgeFoP3a4ZwIrUjhebVQ5JNhg6wivnkpBS5iqOo
 eZ5XvTc6WMviGsYXIT8GIArfpwUHBgP7w4EZdGH6v9kMdRbITSEicjELbkEKZBxywU5Y
 TbZsdq8x49D2qltZDQaVqqFFyqO5Yqf6ZsmzJgK8MQQg+5MnwW77DfRfpeTvvFYzxTpJ
 TL+d4mIqWK6CT0qhDWd+uOy4j/SG6oAjE7XmWY/U1aSKikUpmIvLHzra9VXL5AFE3AQv
 1u3hFD+zUyWklfL/FbKcoMb1+TtVD/WHpjOSBg7gFrynQ13kCG0Pqgn4z2L7P65Rfbcj 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sq8njy1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEXMnI110913;
        Wed, 26 May 2021 10:55:59 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sq8njxym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:59 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QEqjZZ004046;
        Wed, 26 May 2021 14:55:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 38s1ssrbnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtrAd12976494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2335BA40A6;
        Wed, 26 May 2021 14:55:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B375A408C;
        Wed, 26 May 2021 14:55:52 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 7/9] s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
Date:   Wed, 26 May 2021 16:55:37 +0200
Message-Id: <20210526145539.52008-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
References: <20210526145539.52008-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pfm1oy7PJUFuREpjVH772Lntih9fOwUS
X-Proofpoint-ORIG-GUID: IRjB9-Q5xFMuugf_wFVTpqEY-7cmWMM5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpu offset tells us where the cpu entries are in the sclp read
info structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/sclp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7a9b2c52..f11c2035 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -138,7 +138,8 @@ void sclp_facilities_setup(void)
 	assert(read_info);
 
 	cpu = sclp_get_cpu_entries();
-	sclp_facilities.has_diag318 = read_info->byte_134_diag318;
+	if (read_info->offset_cpu > 134)
+		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
 	for (i = 0; i < read_info->entries_cpu; i++, cpu++) {
 		/*
 		 * The logic for only reading the facilities from the
-- 
2.31.1

