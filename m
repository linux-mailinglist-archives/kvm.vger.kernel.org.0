Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7031731E774
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 09:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhBRI25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 03:28:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhBRIZq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 03:25:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11I82xs1073958;
        Thu, 18 Feb 2021 03:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pHf1GQg/rDXhUhPT7iQkQ9FeW+N/gnO3ojXYnxwBWAI=;
 b=LMjuI39zAwHP3meDCCOH2uPUIE5N/17JlWfqy4YE04/xWRdscgrdijA++pQ2ecMOk10/
 EqmXqhcIG/WS/fS1Wm0A58MccXkpTYFgYQ4Vf3muIIBgPr1pISbjEfuXsdS5RCSgV8I8
 Rp+ypDnqgHI6WWOZYBxBly3QHL1l7TxE+HVvHdzPziKTZEVpkGKngrUlPLDu1S3r4TJU
 9cOFF+KG2KmAoEZqNbMNGXxFIsS5iyWR6wL7n0/aNmkTNwUad0XbEfX3WmFmZQhYDzw1
 l6zlv31fFOfRAF/j7yrFpNTr7XomxNVyvIj551bCQOQAQVfBl3n5IVFLU1AY1xbrQb2u aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36smbp8qjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 03:25:01 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11I82wcR073893;
        Thu, 18 Feb 2021 03:25:01 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36smbp8qht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 03:25:01 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11I8LvJQ008135;
        Thu, 18 Feb 2021 08:24:59 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u912g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 08:24:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11I8OvX933882508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 08:24:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F27244203F;
        Thu, 18 Feb 2021 08:24:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5487F42042;
        Thu, 18 Feb 2021 08:24:56 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 08:24:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Remove sthyi partition number check
Date:   Thu, 18 Feb 2021 03:24:49 -0500
Message-Id: <20210218082449.29876-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_03:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=871 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turns out that partition numbers start from 0 and not from 1 so a 0
check doesn't make sense here.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/sthyi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/s390x/sthyi.c b/s390x/sthyi.c
index d8dfc854..db90b56f 100644
--- a/s390x/sthyi.c
+++ b/s390x/sthyi.c
@@ -128,7 +128,6 @@ static void test_fcode0_par(struct sthyi_par_sctn *par)
 		report(sum, "core counts");
 
 	if (par->INFPVAL1 & PART_STSI_SUC) {
-		report(par->INFPPNUM, "number");
 		report(memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)),
 		       "name");
 	}
-- 
2.25.1

