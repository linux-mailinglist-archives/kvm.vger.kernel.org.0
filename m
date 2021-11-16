Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F76445321C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhKPM3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:29:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27968 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236128AbhKPM3D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:29:03 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGBgZAL022966
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=qOs//QHoWOopFMVE4LAXB7AzNcXBeFEHRb+Y1EnUdss=;
 b=Cd9u7ggsZS3wvXixq5y0Fax56EZbScy7stMr34FH0WAmJLovRvfx64DDwZeSXiL86Ivj
 yhV/wCTmHrqVexzhORkVzPYRgf08evmJyTPMunVZZc9qod5nboRQzTLfBIEBvzlbMFVn
 5P6odMSXXfhY+DF4jg4RyiARz9K9HaD779pQXa8YuRKv2q6NVEkixUrilUnofffFSI1g
 INv9zhu9Xs0K+LZFpud0J/tw8nmOB67zLB5RymFRDZ7RqQrqLZKLF48nRzIcxFSu1ejX
 MvcDw97yndJ9UYGve3gzzjzID8uQNRbFTqUAQhOQo6PPCS3J/uQnlSiQKc/iJx026h1f TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccc0q8ykb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:26:04 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGBgd56023028
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 12:26:04 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccc0q8yjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 12:26:04 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGCCREU015975;
        Tue, 16 Nov 2021 12:26:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ca509x4uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 12:26:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGCJ2Gt58917366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 12:19:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A795E11C04C;
        Tue, 16 Nov 2021 12:25:57 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4650911C058;
        Tue, 16 Nov 2021 12:25:57 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.115])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Nov 2021 12:25:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2] s390x: fixing I/O memory allocation
Date:   Tue, 16 Nov 2021 13:26:29 +0100
Message-Id: <20211116122629.257689-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sfZJpcf7gusg52zwNhPfJWw7UAEj3TbH
X-Proofpoint-GUID: cr5yN3pi57IUsdOWblurP0agGjj3NSxq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_01,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The allocator allocate pages it follows the size must be rounded
to pages before the allocation.

Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
index 78582eac..080fc694 100644
--- a/lib/s390x/malloc_io.c
+++ b/lib/s390x/malloc_io.c
@@ -41,7 +41,7 @@ static void unshare_pages(void *p, int count)
 
 void *alloc_io_mem(int size, int flags)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 	void *p;
 	int n;
 
@@ -62,7 +62,7 @@ void *alloc_io_mem(int size, int flags)
 
 void free_io_mem(void *p, int size)
 {
-	int order = get_order(size >> PAGE_SHIFT);
+	int order = get_order(PAGE_ALIGN(size) >> PAGE_SHIFT);
 
 	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
 
-- 
2.25.1

