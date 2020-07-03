Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBE213998
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgGCLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:51:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbgGCLvR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 07:51:17 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BWxVo087192
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320ss4wtrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 07:51:16 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063BXb9a088923
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 320ss4wtr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:51:16 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BpE1a000713;
        Fri, 3 Jul 2020 11:51:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 321vnvg75f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 11:51:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063BpBFr55378056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 11:51:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EC2D11C052;
        Fri,  3 Jul 2020 11:51:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C2D311C050;
        Fri,  3 Jul 2020 11:51:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 11:51:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] lib/vmalloc: fix pages count local variable to be size_t
Date:   Fri,  3 Jul 2020 13:51:06 +0200
Message-Id: <20200703115109.39139-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703115109.39139-1-imbrenda@linux.ibm.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 cotscore=-2147483648 spamscore=0 clxscore=1015 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since size is of type size_t, size >> PAGE_SHIFT might still be too big
for a normal unsigned int.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 10f15af..9237a0f 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -40,7 +40,7 @@ void *alloc_vpage(void)
 void *vmap(phys_addr_t phys, size_t size)
 {
 	void *mem, *p;
-	unsigned pages;
+	size_t pages;
 
 	size = PAGE_ALIGN(size);
 	pages = size / PAGE_SIZE;
@@ -58,7 +58,7 @@ void *vmap(phys_addr_t phys, size_t size)
 static void *vm_memalign(size_t alignment, size_t size)
 {
 	void *mem, *p;
-	unsigned pages;
+	size_t pages;
 
 	assert(alignment <= PAGE_SIZE);
 	size = PAGE_ALIGN(size);
-- 
2.26.2

