Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4E03F04AF
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbhHRN12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236732AbhHRN1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:08 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID34KW003999;
        Wed, 18 Aug 2021 09:26:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hw2W77z6/PD99yD1oIx6PHkg+jw33VvlI2yFLVFYYNk=;
 b=LVkRJ3TKv7QcJUNu0Zuc5eCNOWy8bel9U7n1rgY7yB9rQ21rRJ5Estn+JSYzBh59FFXt
 131lv9rn2feKga1iUYFhXj+7jjDlkGAyvOzfvbYTVhc+uPxuNbQx4JIl+MKJpOvMqpef
 /F1KGPlQKbwSLmyYvT+miL9WbIaXpBOyxcyVNncWoByn1uRTKBiJywZUPgxPxCBCSHVq
 93fmGGsC5rxL4imFbwetOn38wUE6UPeckAyNig2MKbDWs8PzPHlm7aLUol8a5QIdg3N0
 2ykwnhZKdv7aoOdgVn4AcETRGzmc0WffUmV4azeqOL+1dC6BHJzDWeats8tnwv7pSDD7 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ah1mt2qqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:33 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID3NVu006649;
        Wed, 18 Aug 2021 09:26:33 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ah1mt2qpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:33 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDDHaq022071;
        Wed, 18 Aug 2021 13:26:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ae53hxnv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDQQ9N52298022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:26:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA7E4C075;
        Wed, 18 Aug 2021 13:26:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDA904C040;
        Wed, 18 Aug 2021 13:26:25 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 08/14] KVM: s390: pv: handle secure storage exceptions for normal guests
Date:   Wed, 18 Aug 2021 15:26:14 +0200
Message-Id: <20210818132620.46770-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818132620.46770-1-imbrenda@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Irk7J93CZveIGdj4LWcJtkpEmtEymxrQ
X-Proofpoint-GUID: Ne0BHqLwfJQtTeYO7Eccdd--YAu3RS1a
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=738 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, normal guests might touch secure pages.

This patch extends the existing exception handler to convert the pages
to non secure also when the exception is triggered by a normal guest.

This can happen for example when a secure guest reboots; the first
stage of a secure guest is non secure, and in general a secure guest
can reboot into non-secure mode.

If the secure memory of the previous boot has not been cleared up
completely yet, a non-secure guest might touch secure memory, which
will need to be handled properly.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/mm/fault.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index eb68b4f36927..74784581f42d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -767,6 +767,7 @@ void do_secure_storage_access(struct pt_regs *regs)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 	struct page *page;
+	struct gmap *gmap;
 	int rc;
 
 	/*
@@ -796,6 +797,14 @@ void do_secure_storage_access(struct pt_regs *regs)
 	}
 
 	switch (get_fault_type(regs)) {
+	case GMAP_FAULT:
+		gmap = (struct gmap *)S390_lowcore.gmap;
+		addr = __gmap_translate(gmap, addr);
+		if (IS_ERR_VALUE(addr)) {
+			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
+			break;
+		}
+		fallthrough;
 	case USER_FAULT:
 		mm = current->mm;
 		mmap_read_lock(mm);
@@ -824,7 +833,6 @@ void do_secure_storage_access(struct pt_regs *regs)
 		if (rc)
 			BUG();
 		break;
-	case GMAP_FAULT:
 	default:
 		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
 		WARN_ON_ONCE(1);
-- 
2.31.1

