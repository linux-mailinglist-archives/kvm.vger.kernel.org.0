Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3940D21F215
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 15:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgGNNAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 09:00:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23486 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727858AbgGNNAl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 09:00:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ECWiE9019117;
        Tue, 14 Jul 2020 09:00:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 327tna9myt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 09:00:39 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06ED08RC105947;
        Tue, 14 Jul 2020 09:00:38 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 327tna9mx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 09:00:38 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06ECxflm019277;
        Tue, 14 Jul 2020 13:00:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 327527hprr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 13:00:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06ED0Y6j39256552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 13:00:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D95BFAE085;
        Tue, 14 Jul 2020 13:00:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54F86AE07B;
        Tue, 14 Jul 2020 13:00:32 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.7.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 13:00:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [kvm-unit-tests PATCH v2 2/2] lib/alloc_page: Fix compilation issue on 32bit archs
Date:   Tue, 14 Jul 2020 15:00:30 +0200
Message-Id: <20200714130030.56037-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714130030.56037-1-imbrenda@linux.ibm.com>
References: <20200714130030.56037-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_03:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 impostorscore=0 suspectscore=2 lowpriorityscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The assert in lib/alloc_page is hardcoded to long.

Use the z modifier instead, which is meant to be used for size_t.

Fixes: 73f4b202beb39 ("lib/alloc_page: change some parameter types")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index fa3c527..74fe726 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -29,11 +29,11 @@ void free_pages(void *mem, size_t size)
 	assert_msg((unsigned long) mem % PAGE_SIZE == 0,
 		   "mem not page aligned: %p", mem);
 
-	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#lx", size);
+	assert_msg(size % PAGE_SIZE == 0, "size not page aligned: %#zx", size);
 
 	assert_msg(size == 0 || (uintptr_t)mem == -size ||
 		   (uintptr_t)mem + size > (uintptr_t)mem,
-		   "mem + size overflow: %p + %#lx", mem, size);
+		   "mem + size overflow: %p + %#zx", mem, size);
 
 	if (size == 0) {
 		freelist = NULL;
-- 
2.26.2

