Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7863AFF18
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhFVIXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:23:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhFVIXx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:53 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8Esl2023927;
        Tue, 22 Jun 2021 04:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yolfqXsSRROPjoxHzVs4uFNfRvvy1PgequUTAwAHZK8=;
 b=hGbiyEMX5DSasw7zTbcFd2KnRYfVSpIUGzcAoTznwurV0Sio9UJcYN0XwkxLXXSTtzal
 mkQg5Mm+RxkxLEy/dXv/swDtbmUVFFSQZn/ujd4PvMNtAJ9ZUJdywZOLVIwLq17yPAGN
 kT6QCCmEAlYIQfyphzoxnGl6OsF+DLmupj///N7cQd3YQ2jcsZXlKUNjX2LUrn8tEXLE
 Qr1VzhTIFNXk5bNIxqQNPeD5cDMinQnRfHKCO6dUd9MR/1kPVVpIHWsYFCFt1KKigaVP
 mHI7A5CG/TahXDQhX3coYxP72rAqkrwFxN/tN3erwetvtkJjiG7obOCNzwxdm7WauWG6 pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc6ar5nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:36 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M8G0Js030547;
        Tue, 22 Jun 2021 04:21:36 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bc6ar5n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:36 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8F5BY000874;
        Tue, 22 Jun 2021 08:21:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3998788q37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8LUqO31129970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA4EEAE053;
        Tue, 22 Jun 2021 08:21:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BE20AE051;
        Tue, 22 Jun 2021 08:21:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 02/12] s390x: selftest: Add prefixes to fix report output
Date:   Tue, 22 Jun 2021 10:20:32 +0200
Message-Id: <20210622082042.13831-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TsmFsf6KOfgIRcCCdxGOymlYxTyuF88y
X-Proofpoint-ORIG-GUID: -Op6_UvHxfywlQJQGCXAC7n1VFRp-Pd9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make our TAP parser (and me) happy we don't want to have two reports
with exactly the same wording so I added in two new prefix pushes.

Also moving the code inside of the region of a prefix will give us
more data when a problem arises.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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
2.31.1

