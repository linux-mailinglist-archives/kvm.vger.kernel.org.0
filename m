Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD93F04A4
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbhHRN1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235943AbhHRN1G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:06 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID2dLc068178;
        Wed, 18 Aug 2021 09:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6eOiGibZdhHMDVRHKt6bVfmaZCJUOA1fvvP8U7H1cV0=;
 b=gyJNWlX3idShaQhS6qk6+nisabqIf+0UMzqwcRwYBTpjo9KwMuwB4HcRreCqkZGElFfd
 AHqYFUDU0u8asqge3t6SLdOsTplagp9ToOJeJp6bYN0klysMfsie7cJ7WBsdskhqqnM9
 oCuVSTqAxaeDQX8F79z35PEHKvBJtnn2cxdmhZuf3xuzcjJLQdTITYRfXvvBUSCqjPSg
 fHaacM6ZFPFfj4PdTLkUM/uG0MpT0TWPAwwMmVKMvK7qzJXltmWEioebKzvvdprGuQUZ
 4Q9nrYg+INnp1wPdekESXSaVZ7s+bKLgrosuZQwM8p+XG6mNS/jEE20NU4fsSjtaQEk/ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvmqm9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:31 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID3Hql070311;
        Wed, 18 Aug 2021 09:26:30 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvmqm8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:30 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDCnKm019195;
        Wed, 18 Aug 2021 13:26:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3agh2xh6b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDMrNg56754432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:22:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5BDA4C05A;
        Wed, 18 Aug 2021 13:26:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37E824C058;
        Wed, 18 Aug 2021 13:26:23 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 04/14] KVM: s390: pv: avoid stalls when making pages secure
Date:   Wed, 18 Aug 2021 15:26:10 +0200
Message-Id: <20210818132620.46770-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818132620.46770-1-imbrenda@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2M-n8KDoYeZNt5RkwZ3JpA99AMb8JUHy
X-Proofpoint-GUID: 6QECtlvLqhtMEpmlA4zj13t0wNQWCiVI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve make_secure_pte to avoid stalls when the system is heavily
overcommitted. This was especially problematic in kvm_s390_pv_unpack,
because of the loop over all pages that needed unpacking.

Due to the locks being held, it was not possible to simply replace
uv_call with uv_call_sched. A more complex approach was
needed, in which uv_call is replaced with __uv_call, which does not
loop. When the UVC needs to be executed again, -EAGAIN is returned, and
the caller (or its caller) will try again.

When -EAGAIN is returned, the path is the same as when the page is in
writeback (and the writeback check is also performed, which is
harmless).

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
---
 arch/s390/kernel/uv.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index aeb0a15bcbb7..68a8fbafcb9c 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 {
 	pte_t entry = READ_ONCE(*ptep);
 	struct page *page;
-	int expected, rc = 0;
+	int expected, cc = 0;
 
 	if (!pte_present(entry))
 		return -ENXIO;
@@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	if (!page_ref_freeze(page, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &page->flags);
-	rc = uv_call(0, (u64)uvcb);
+	/*
+	 * If the UVC does not succeed or fail immediately, we don't want to
+	 * loop for long, or we might get stall notifications.
+	 * On the other hand, this is a complex scenario and we are holding a lot of
+	 * locks, so we can't easily sleep and reschedule. We try only once,
+	 * and if the UVC returned busy or partial completion, we return
+	 * -EAGAIN and we let the callers deal with it.
+	 */
+	cc = __uv_call(0, (u64)uvcb);
 	page_ref_unfreeze(page, expected);
-	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
-	if (rc)
-		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
-	return rc;
+	/*
+	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * If busy or partially completed, return -EAGAIN.
+	 */
+	if (cc == UVC_CC_OK)
+		return 0;
+	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
+		return -EAGAIN;
+	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
 /*
@@ -254,6 +267,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	mmap_read_unlock(gmap->mm);
 
 	if (rc == -EAGAIN) {
+		/*
+		 * If we are here because the UVC returned busy or partial
+		 * completion, this is just a useless check, but it is safe.
+		 */
 		wait_on_page_writeback(page);
 	} else if (rc == -EBUSY) {
 		/*
-- 
2.31.1

