Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD6D2DC78D
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgLPUNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65411 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727434AbgLPUNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:10 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK4mpL127166
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5GwpfX7vOVAQ5bd6U7k77kV7Gd6L+tM3O9qamNvSuIY=;
 b=i/7CIJB/eHjb4I3O9/Wxt6ToZ9fTE4vyYiZSFVPrs8f3NGOW4J1qNSCwdvLG0x7N0+0g
 b9pVB1pRsP9duWMlUm6bkR3QzCzhqveqfv+dqUhnBPo2vbK7hKaF/N5y7kN8r7bPUS98
 3WfQhP8x5sHanm6ge3qAAARhjkI+u6iS0zzlNn51OyzRUtdSuRPEKyEITaxricsjEf6E
 ECyZJDteHKN43O/AGpjIpjuoRSANx/uc45Li8o6jmbO4EeMN7c7QcJ/VeC8WKp2A6pwy
 3kQrglinPHJL5h8oMlLssGD9J3VSL1JLdRlXLfsQjeLQlwfkMFKWQON3lO3Rq0FAMg8Q AA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35frmfrnr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:29 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK52kY128693
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:29 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35frmfrnqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:29 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK8xJr003942;
        Wed, 16 Dec 2020 20:12:27 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 35d310a4u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCP5o31064466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04C3F42047;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D48642045;
        Wed, 16 Dec 2020 20:12:24 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:24 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 10/12] lib/alloc_page: Wire up ZERO_FLAG
Date:   Wed, 16 Dec 2020 21:11:58 +0100
Message-Id: <20201216201200.255172-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memory allocated with the ZERO_FLAG will now be zeroed before being
returned to the caller.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index d850b6a..8c79202 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -372,6 +372,8 @@ static void *page_memalign_order_flags(u8 ord, u8 al, u32 flags)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, ord, al);
 	spin_unlock(&lock);
+	if (res && (flags & FLAG_ZERO))
+		memset(res, 0, BIT(ord) * PAGE_SIZE);
 	return res;
 }
 
-- 
2.26.2

