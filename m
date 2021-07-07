Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA0B3BE941
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhGGOGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 10:06:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50450 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231953AbhGGOGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 10:06:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167DXuYN029266;
        Wed, 7 Jul 2021 10:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VjWbFmSusGCVD1IlgIZ+7NMx8EG2dNAaY2SG5bD1jWc=;
 b=mvpFaF0sIjBkqVen1R1LBZ/F/Q07LJEOZ+PivYY9XA4nbfibywI3fCJukjt3XpdtamRD
 TGidnQORtFWX8d5ti5kKLzPrzwb9VCA6qVwzLTw/+O9zsdxudFoHyVZCOAp6otZfL9m8
 6c4AN5FlUNIdg9IVcr2zaGXcqi86lMAJFG4r1drTC3hDCc6fhDbg+fffzcdmtZ58QLSc
 axpynnAGRgbDzv6nnS/KURwaF1uVaEFFU9xGl9WLfFNAmMytfHaoa8NSCmCuoqCe60Ow
 lcq51mh6Q/2A5vbrfKuAJUyVDUDonQOctkrk/5WIPABhKAOl/5WCP0zROb6vmeqya8pj oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8fq8pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:35 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167DXuE1029215;
        Wed, 7 Jul 2021 10:03:35 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn8fq8n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 10:03:35 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167E3X3T006276;
        Wed, 7 Jul 2021 14:03:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgycx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 14:03:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167E3U0f35324314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 14:03:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05634A4051;
        Wed,  7 Jul 2021 14:03:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83298A404D;
        Wed,  7 Jul 2021 14:03:29 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.29.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 14:03:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 5/8] s390x: sie: Fix sie.h integer types
Date:   Wed,  7 Jul 2021 16:03:15 +0200
Message-Id: <20210707140318.44255-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210707140318.44255-1-frankja@linux.ibm.com>
References: <20210707140318.44255-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uaMg5ZCjMIM3_6JlmL8GDUHXzQlXkrAE
X-Proofpoint-GUID: 7uwfEj70pceva-Y7AeM2hJ_X4IXBmbcn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's only use the uint*_t types.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/sie.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index b4bb78c3..6ba858a2 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -173,9 +173,9 @@ struct kvm_s390_sie_block {
 } __attribute__((packed));
 
 struct vm_save_regs {
-	u64 grs[16];
-	u64 fprs[16];
-	u32 fpc;
+	uint64_t grs[16];
+	uint64_t fprs[16];
+	uint32_t fpc;
 };
 
 /* We might be able to nestle all of this into the stack frame. But
@@ -191,7 +191,7 @@ struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
 	/* Ptr to first guest page */
-	u8 *guest_mem;
+	uint8_t *guest_mem;
 };
 
 extern void sie_entry(void);
-- 
2.31.1

