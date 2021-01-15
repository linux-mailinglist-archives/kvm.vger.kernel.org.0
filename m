Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E352F7A21
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbhAOMpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:45:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729011AbhAOMpT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:45:19 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXKKW064866;
        Fri, 15 Jan 2021 07:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OxhQfdgTKMXXCUVdhNU9fQldxM61VSS3UBG2RIXAQ1U=;
 b=Fu1Mfr/dDf10gEPlwJToNe40F1y0kFOUmfcHCP7i4c+UVK6h4K5EPc5fkj7/LQOGxGHD
 YVVQKEACxWHDpjUoJydopXBBZZLuyYTG1dAWdR9ZvNYcg9hFl6ppR8haoPKtGXbfn6Xb
 ShUdtvb1f5Jb3d4WnMbf7Wn+3RDeMAHvzSFgbkodFydnaYrDOcEyqvG77deuSlN3S6cy
 tCM6yhHUh60XUei9phn3bapN3qUKYPYMz00kEBT0tQLAi51y+fIOKihVJ3ykP1ooxkW/
 CUHYAdKnWA1XpTf3tzJIn3veBMUKGkMBuv18yuneE8xpjTAWTcksMlQfmmiJJ4jq44RE SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:42 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXr8q066955;
        Fri, 15 Jan 2021 07:37:41 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363akfh8gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:41 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCbYhg001564;
        Fri, 15 Jan 2021 12:37:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3604h9b8re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbVuQ34013536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10673AE051;
        Fri, 15 Jan 2021 12:37:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98D5CAE056;
        Fri, 15 Jan 2021 12:37:36 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 10/11] lib/alloc_page: Wire up FLAG_DONTZERO
Date:   Fri, 15 Jan 2021 13:37:29 +0100
Message-Id: <20210115123730.381612-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memory allocated without FLAG_DONTZERO will now be zeroed before being
returned to the caller.

This means that by default all allocated memory is now zeroed, restoring the
default behaviour that had been accidentally removed by a previous commit.

Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page allocator")
Reported-by: Nadav Amit <nadav.amit@gmail.com>

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 47e2981..95d957b 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -372,6 +372,8 @@ static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, al, ord);
 	spin_unlock(&lock);
+	if (res && !(flags & FLAG_DONTZERO))
+		memset(res, 0, BIT(ord) * PAGE_SIZE);
 	return res;
 }
 
-- 
2.26.2

