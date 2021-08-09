Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FFE3E41D2
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhHIItd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 04:49:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234060AbhHIIt1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 04:49:27 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1798YqGo045087;
        Mon, 9 Aug 2021 04:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6+6ELF7atY8iBAVtsC7aXKLl3Z44aoVuUI+MvxNZEio=;
 b=I82gQ+GupGGhq41oUwn8GUT8Xa1BJOxY+Hsgtt6h7aW3zZVUSCqjpubWSiN3UpR/Gb2B
 LiK7Ya/0BiMNqsJU6csX0X2jvg0Jzoy5SH2sHqAhWKyQ36ayy7rT8NXxsxJ7WPWoljRK
 UyPy/Asc5Jf1Yvw+OgjdNH+pEXchSjupeSFLtkWuq2baI1+tXHwrofdnmmZcWKS2TAGC
 go+EahoXq03CUQcJKL6Mj14xOZmcF0J/BrE5NPBrEJll+Aa9/W6+zw2KdCBMHXKjAl99
 B3g3LzsyviV9rYYxXQ/CyYTN+HhMx9CqzOdyZ/SQIy5Hvr7eT9afT6lX0DbSVtD3LEel hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aam0kwg97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1798ZU1x048635;
        Mon, 9 Aug 2021 04:49:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aam0kwg7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:49:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798m90H006407;
        Mon, 9 Aug 2021 08:49:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3a9hehbp7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:49:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798mvQZ9306520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27AC842047;
        Mon,  9 Aug 2021 08:48:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEEB542049;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.151.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:48:56 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/4] s390x: lib: Move stsi_get_fc to library
Date:   Mon,  9 Aug 2021 10:48:52 +0200
Message-Id: <1628498934-20735-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
References: <1628498934-20735-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nh934kVQdRF7iqfOP7dEwLCYVdVymWKp
X-Proofpoint-ORIG-GUID: kn6CAGjlJwy41vyttdi_TnmyBtjwVgaX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's needed in multiple tests now.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 16 ++++++++++++++++
 s390x/stsi.c             | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15cf7d48..57d7ddac 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -328,6 +328,22 @@ static inline int stsi(void *addr, int fc, int sel1, int sel2)
 	return cc;
 }
 
+static inline unsigned long stsi_get_fc(void *addr)
+{
+	register unsigned long r0 asm("0") = 0;
+	register unsigned long r1 asm("1") = 0;
+	int cc;
+
+	asm volatile("stsi	0(%[addr])\n"
+		     "ipm	%[cc]\n"
+		     "srl	%[cc],28\n"
+		     : "+d" (r0), [cc] "=d" (cc)
+		     : "d" (r1), [addr] "a" (addr)
+		     : "cc", "memory");
+	assert(!cc);
+	return r0 >> 28;
+}
+
 static inline int servc(uint32_t command, unsigned long sccb)
 {
 	int cc;
diff --git a/s390x/stsi.c b/s390x/stsi.c
index 87d48047..11986d13 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -71,22 +71,6 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
-static inline unsigned long stsi_get_fc(void *addr)
-{
-	register unsigned long r0 asm("0") = 0;
-	register unsigned long r1 asm("1") = 0;
-	int cc;
-
-	asm volatile("stsi	0(%[addr])\n"
-		     "ipm	%[cc]\n"
-		     "srl	%[cc],28\n"
-		     : "+d" (r0), [cc] "=d" (cc)
-		     : "d" (r1), [addr] "a" (addr)
-		     : "cc", "memory");
-	assert(!cc);
-	return r0 >> 28;
-}
-
 static void test_fc(void)
 {
 	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");
-- 
2.25.1

