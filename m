Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236A0431953
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhJRMkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63118 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231707AbhJRMkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:19 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBwEOx007216;
        Mon, 18 Oct 2021 08:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GCWDAo+2mYFqxOJX/JYVDPhcH0+vFG5rZzZzCoRfhgg=;
 b=mXjqUb5MBwNGLFizlKdMEFHeUMUEvZFhoajxCPkih0g0ltjskrJTWGlGqityE15c1TAz
 Z1gKYIBT6DvOK7sf870XF7DncwgN1Xwr4jnM87ocezcDiklRHk9FqB4cMGw9qXPKK9jo
 FIGquC3vtjWhUskdtUgb1YSz4yRuqD5wAibr6yz9iIU0gED5LZTJFfLYNnaGZSDEvyep
 WkmDOmqDKLZJkLDvj5xY2mnYnZ7wn65E95bKgmcVeczKAObTOVg0WskSirCA58f5gJSf
 wIc2SeXg9Tq+EMRpd1Z4pLRwrcxXxOmKZY3otvc98bX6XDTC72gUfh755O6pKwvL3q1T 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs3gv7kb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBuNUa020517;
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs3gv7ka9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbJP5005201;
        Mon, 18 Oct 2021 12:38:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3bqpc9cym6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc1O43801624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17B3052052;
        Mon, 18 Oct 2021 12:38:01 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 983825205A;
        Mon, 18 Oct 2021 12:38:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 06/17] s390x: uv: Tolerate 0x100 query return code
Date:   Mon, 18 Oct 2021 14:26:24 +0200
Message-Id: <20211018122635.53614-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uv0RQNeuIX4VTee52y33X8hIj-GNjWGh
X-Proofpoint-ORIG-GUID: zFLVaC2aCBy9IHyke-Wp6swWp0gGqyRu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RC 0x100 is not an error but a notice that we could have gotten more
data from the Ultravisor if we had asked for it. So let's tolerate
them in our tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 s390x/uv-guest.c | 4 +++-
 s390x/uv-host.c  | 8 +++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index f05ae4c3..44ad2154 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -71,7 +71,9 @@ static void test_query(void)
 
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
-	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "successful query");
+	report((!cc && uvcb.header.rc == UVC_RC_EXECUTED) ||
+	       (cc == 1 && uvcb.header.rc == 0x100),
+		"successful query");
 
 	/*
 	 * These bits have been introduced with the very first
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 28035707..4b72c24d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -385,7 +385,7 @@ static void test_init(void)
 
 static void test_query(void)
 {
-	int i = 0;
+	int i = 0, cc;
 
 	uvcb_qui.header.cmd = UVC_CMD_QUI;
 	uvcb_qui.header.len = sizeof(uvcb_qui);
@@ -400,8 +400,10 @@ static void test_query(void)
 	report(uvcb_qui.header.rc == 0x100, "insf length");
 
 	uvcb_qui.header.len = sizeof(uvcb_qui);
-	uv_call(0, (uint64_t)&uvcb_qui);
-	report(uvcb_qui.header.rc == UVC_RC_EXECUTED, "successful query");
+	cc = uv_call(0, (uint64_t)&uvcb_qui);
+	report((!cc && uvcb_qui.header.rc == UVC_RC_EXECUTED) ||
+	       (cc == 1 && uvcb_qui.header.rc == 0x100),
+		"successful query");
 
 	for (i = 0; cmds[i].name; i++)
 		report(uv_query_test_call(cmds[i].call_bit), "%s", cmds[i].name);
-- 
2.31.1

