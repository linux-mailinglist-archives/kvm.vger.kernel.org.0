Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004A4221E4
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhJEJN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:13:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10574 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233608AbhJEJNy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 05:13:54 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1957at0P010880;
        Tue, 5 Oct 2021 05:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=USma80Gcc4fN35YcSZnm/LYN7TaaljDi2S6Ne+LfKeo=;
 b=QSPbhZolrION31nmuRWG2hGtPMQsj+rMTa7dh0OVK5CfBeesahOn1tksw+4xLFqypkcm
 qBBLUAzOXOeHU5buwN96rJd2QNgiSSLEKy/4CgMg326z99k3yGBb+K0VpbES7bFLVa+0
 Aqf4vcyskJFckXQCNIWQnFEFpa10SG/eyRLim30GWRbTvBfYH6RIF+f167z4I9VPOEW5
 cayo+CQi9akTGlrNZt+My2gsMwk3ORQhnw3m6Wqo91g5S4oWsZnFgRarv3YVzpiF4S+p
 yVbccxCEzHOykM3LV9/ZywIWpmsfzbPo143LxxnD5bDXZ4TEWWqRijwpRLGSfUXs72sh Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bghr0k08g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:12:03 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1958soMj006300;
        Tue, 5 Oct 2021 05:12:03 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bghr0k071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 05:12:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19596cNj015840;
        Tue, 5 Oct 2021 09:11:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bef2ar8pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:11:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1959Btpp58589630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 09:11:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C65DC52050;
        Tue,  5 Oct 2021 09:11:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 53DCF52052;
        Tue,  5 Oct 2021 09:11:55 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/2] s390x: Remove assert from arch_def.h
Date:   Tue,  5 Oct 2021 11:11:52 +0200
Message-Id: <20211005091153.1863139-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005091153.1863139-1-scgl@linux.ibm.com>
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dJyElW6YRvKFwL1CQ4y6gethsAlZUeuf
X-Proofpoint-GUID: tftUSbTG6iF8BzoDT1Kost-1vdtvrSrA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 mlxscore=0 clxscore=1015 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not use asserts in arch_def.h so it can be included by snippets.
The caller in stsi.c does not need to be adjusted, returning -1 causes
the test to fail.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 302ef1f..4167e2b 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -334,7 +334,7 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
-static inline unsigned long stsi_get_fc(void)
+static inline int stsi_get_fc(void)
 {
 	register unsigned long r0 asm("0") = 0;
 	register unsigned long r1 asm("1") = 0;
@@ -346,7 +346,8 @@ static inline unsigned long stsi_get_fc(void)
 		     : "+d" (r0), [cc] "=d" (cc)
 		     : "d" (r1)
 		     : "cc", "memory");
-	assert(!cc);
+	if (cc != 0)
+		return -1;
 	return r0 >> 28;
 }
 
-- 
2.31.1

