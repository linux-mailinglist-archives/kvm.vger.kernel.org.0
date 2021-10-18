Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202A743194F
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJRMkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231645AbhJRMkS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:18 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBKYSL029683;
        Mon, 18 Oct 2021 08:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=k6bMroZ6gV/axiBUPhy7QmeuQnQJp4SvppQ/20GUXhQ=;
 b=hdxJ59IZjpCyxctHQAU6WthcRBppDKY1q22kcklHnZIefGy5HBff/XHSavov+GMqlAtV
 NxITzTziDRsyp8kQ0BTCZC0t7doQPLz1CNqHD2gOqYWUTiklq/HN5xKIn8vYxsl3BVGZ
 r+F8NT/1OlBOS3p7JGbE6IIlnwGwqGml6kFKOWBD/ALvInaVDkgD6d52UbsfzQazeJWB
 DYd2Cfe2FhUUW57yZDB3e6hW59LVzDnmoESA4x1pfSlQSfYgtZ4VtFgWryvIs48R4d/Y
 lQKGOrepCYukpcHhbMXkNR3LQmjz2mXlV9Mvgl/L/y2wcSa6FJIpNlKPo7AU+JrRQxwe Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICc6vm015870;
        Mon, 18 Oct 2021 08:38:06 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs7yg1m7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:06 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbJBe005210;
        Mon, 18 Oct 2021 12:38:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9cym1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc0J146268844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8493052054;
        Mon, 18 Oct 2021 12:38:00 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 165EF52051;
        Mon, 18 Oct 2021 12:38:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 05/17] s390x: mvpg-sie: Remove unused variable
Date:   Mon, 18 Oct 2021 14:26:23 +0200
Message-Id: <20211018122635.53614-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i8JbVhVFgpAZPNB4XJfiHbSQdohjpYup
X-Proofpoint-GUID: fsNFotcfKm-6k9qEDWrrSw5Vo3lq5nfx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The guest_instr variable is not used, which was likely a
copy-n-paste issue from the s390x/sie.c test.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/6b4b6ae0-6cee-e435-189a-8657159de97f@linux.ibm.com/T/#m8390c674f1b6a9fdf8055189d039c60c99a6899a
Message-Id: <20211007072136.768459-1-thuth@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg-sie.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index ccc273b4..5adcec1e 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -21,7 +21,6 @@
 #include <sie.h>
 
 static u8 *guest;
-static u8 *guest_instr;
 static struct vm vm;
 
 static uint8_t *src;
@@ -94,8 +93,6 @@ static void setup_guest(void)
 
 	/* Allocate 1MB as guest memory */
 	guest = alloc_pages(8);
-	/* The first two pages are the lowcore */
-	guest_instr = guest + PAGE_SIZE * 2;
 
 	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
-- 
2.31.1

