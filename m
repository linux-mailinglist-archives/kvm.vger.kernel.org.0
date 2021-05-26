Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3457391AEB
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhEZO5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235182AbhEZO53 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:29 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEiNU1058385;
        Wed, 26 May 2021 10:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qdPGVyRnVabvWWc/ZVmFVrMfcFHbAjPiuJZTaWiVdRs=;
 b=L8BMMETNGCjCQVnejcerV5N0rsZwpjuH57kr3nZ00dq4IYqqTcWMywcAGaD23TicAdDc
 IkaluQQM6rUB8FXDchn/Wxf2HwwyrU6WQpVQ/x/WylOTNHYe7l+f8A3mHcjE78AqtkkC
 6DfxQ9PhOlA185EWKkHaVEf8KNEbgBNl/Zy2ZyNkOeoon5KVb3qiC7kBXdQnT1LoBK4W
 IVzb7a4MNC0j9u4+A5IRiNtGpNdKycLIjisuk0lRgnA2d/fuAFmiKCEgBSm2ykZFLJ0Y
 Hbbb+kQb/8RNLXp2eJa1K1x2XEhW9pjlUlGCoMixbHjb0eGPZNGMP3hvqsaIgHnLHZm7 ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srbu8cah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:57 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEiSoP058603;
        Wed, 26 May 2021 10:55:57 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38srbu8c9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:57 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QErN8d024002;
        Wed, 26 May 2021 14:55:55 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 38s1ukgmcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtqti20578796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 056ACA40A5;
        Wed, 26 May 2021 14:55:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72CEEA40A6;
        Wed, 26 May 2021 14:55:50 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:50 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 4/9] s390x: Test for share/unshare call support before using them
Date:   Wed, 26 May 2021 16:55:34 +0200
Message-Id: <20210526145539.52008-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
References: <20210526145539.52008-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lEvGRMCD7ArtcrWgXNafgAwJQLbCN3nq
X-Proofpoint-GUID: n4vidrZ2295-Nd9equJZFfXkDRfjh2ab
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing for facility only means the UV Call facility is available.
The UV will only indicate the share/unshare calls for a protected
guest 2, so lets also check that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/malloc_io.c | 5 +++--
 s390x/uv-guest.c      | 6 ++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
index 1dcf1691..78582eac 100644
--- a/lib/s390x/malloc_io.c
+++ b/lib/s390x/malloc_io.c
@@ -19,6 +19,7 @@
 #include <alloc_page.h>
 #include <asm/facility.h>
 #include <bitops.h>
+#include <uv.h>
 
 static int share_pages(void *p, int count)
 {
@@ -47,7 +48,7 @@ void *alloc_io_mem(int size, int flags)
 	assert(size);
 
 	p = alloc_pages_flags(order, AREA_DMA31 | flags);
-	if (!p || !test_facility(158))
+	if (!p || !uv_os_is_guest())
 		return p;
 
 	n = share_pages(p, 1 << order);
@@ -65,7 +66,7 @@ void free_io_mem(void *p, int size)
 
 	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
 
-	if (test_facility(158))
+	if (uv_os_is_guest())
 		unshare_pages(p, 1 << order);
 	free_pages(p);
 }
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 393d7f5c..e99029a7 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -16,6 +16,7 @@
 #include <asm/facility.h>
 #include <asm/uv.h>
 #include <sclp.h>
+#include <uv.h>
 
 static unsigned long page;
 
@@ -142,6 +143,11 @@ int main(void)
 		goto done;
 	}
 
+	if (!uv_os_is_guest()) {
+		report_skip("Not a protected guest");
+		goto done;
+	}
+
 	page = (unsigned long)alloc_page();
 	test_priv();
 	test_invalid();
-- 
2.31.1

