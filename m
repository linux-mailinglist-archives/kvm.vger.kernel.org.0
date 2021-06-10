Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0D3A2DF3
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhFJOWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:22:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6549 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230084AbhFJOWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:22:02 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AE3bhv096619;
        Thu, 10 Jun 2021 10:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hjL552Ig2sktrHftFzN1dDJ1btbi/msqXjCaJCTaUIQ=;
 b=Ukp0UTxMXqBOYKnaXXXqpLz2w0a2DxKbOmxuPWKgBKIzpfXtzHLOHy0VseCAtHkOnHDs
 +DHO/wXH/WeioiqEfz0mxJbhn5dSU3wvlULMqSJhJOI6coFFlPYtIAvszNxwFsmnSEj7
 shFWpD6t2gXX+WT3rE7sFtSDAHxNYwz9B2KDY53sVYAFlbhwHq5p/iWRvtT/Ep3hgPB+
 HeSv/3PBbyvf6DU+9NmbzXZsIeVgjttzswuDDRRX54+yA3lv25YcWBBaATDs0rD4qd3c
 iJdiLBkQvyVjFa5AVZWaoKGdj5eJnZhka7R4aiyUtuTp54Lwr3s0tvWeX6o3oARuQERE iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393kksj2xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 10:20:05 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AE4OwE103549;
        Thu, 10 Jun 2021 10:20:04 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393kksj2x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 10:20:04 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AEGURK003473;
        Thu, 10 Jun 2021 14:20:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3900w89kmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 14:20:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AEJ9LS26542396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 14:19:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389ACA405B;
        Thu, 10 Jun 2021 14:20:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91BF9A408A;
        Thu, 10 Jun 2021 14:19:59 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 14:19:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2] s390x: selftest: Add prefixes to fix report output (was "s390x: selftest: Fix report output")
Date:   Thu, 10 Jun 2021 14:19:13 +0000
Message-Id: <20210610141913.61553-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C6rwW3NCkBONvO-pC4k9vfKA5SFVDmND
X-Proofpoint-GUID: _EpD5b9Kdty1uYTtrpS1K6yL3TWEmzyU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_07:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make our TAP parser (and me) happy we don't want to have two reports
with exactly the same wording so I added in two new prefix pushes.

Also moving the code inside of the region of a prefix will give us
more data when a problem arises.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/selftest.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/s390x/selftest.c b/s390x/selftest.c
index b2fe2e7b..0f099ca0 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -40,19 +40,28 @@ static void test_pgm_int(void)
 
 static void test_malloc(void)
 {
-	int *tmp = malloc(sizeof(int));
-	int *tmp2 = malloc(sizeof(int));
+	int *tmp, *tmp2;
 
+	report_prefix_push("malloc");
+
+	report_prefix_push("ptr_0");
+	tmp = malloc(sizeof(int));
+	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
 	*tmp = 123456789;
+	mb();
+	report(*tmp == 123456789, "wrote allocated memory");
+	report_prefix_pop();
+
+	report_prefix_push("ptr_1");
+	tmp2 = malloc(sizeof(int));
+	report((uintptr_t)tmp2 & 0xf000000000000000ul,
+	       "allocated memory");
 	*tmp2 = 123456789;
 	mb();
+	report((*tmp2 == 123456789), "wrote allocated memory");
+	report_prefix_pop();
 
-	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
-	report(*tmp == 123456789, "malloc: access works");
-	report((uintptr_t)tmp2 & 0xf000000000000000ul,
-	       "malloc: got 2nd vaddr");
-	report((*tmp2 == 123456789), "malloc: access works");
-	report(tmp != tmp2, "malloc: addresses differ");
+	report(tmp != tmp2, "allocated memory addresses differ");
 
 	expect_pgm_int();
 	configure_dat(0);
@@ -62,6 +71,7 @@ static void test_malloc(void)
 
 	free(tmp);
 	free(tmp2);
+	report_prefix_pop();
 }
 
 int main(int argc, char**argv)
-- 
2.30.2

