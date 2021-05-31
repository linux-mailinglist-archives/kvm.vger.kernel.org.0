Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A8B39593B
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhEaKwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:52:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29498 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230518AbhEaKwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:52:17 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VAXs8a076717;
        Mon, 31 May 2021 06:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2+nrFyx6S43CHiLPYIp2Ak+zvfJkcKxsC5zMZR9SbwY=;
 b=Bk+XVkGgNBKZoT6rgQU856mh1gqA1jy/+L4fF3BLvsg5HAlGck4q7wTiU0zpObO5cw5E
 4wpSW5HQURJzRlbsOUHUBWt4RgK3VIAXh4sKT6Q6I3GCPb8Z/ozN6p6P2xBKuoYjkL4B
 lOTkmcFgA1r2bzcX5OqPqssxZoaEaHXttPG+D1yBX+rc4/F+ZqQ8urTnAaOW6AJVFn0P
 HIWj95fu5wh84rTop7pKP+1ShIOx/Zf0ufwdLe2auAVjcS+wwJk9OhXkUxDH2VvLqY/Q
 s5DSK4oxzIStkFbtuGBeV2QFcuyoh5omJgkXD6T3cbO2OiQCBgv/7yvTPzUTp3ohwtcS 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vs1rg2ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 06:50:36 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14VAZ85g083187;
        Mon, 31 May 2021 06:50:36 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vs1rg2e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 06:50:36 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14VAh01H030773;
        Mon, 31 May 2021 10:50:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 38ud888yfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 10:50:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14VAoWAu11141450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 10:50:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E29D52050;
        Mon, 31 May 2021 10:50:32 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6C1DE5204E;
        Mon, 31 May 2021 10:50:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
Date:   Mon, 31 May 2021 10:50:03 +0000
Message-Id: <20210531105003.44737-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aa-pZdmFiLd__BFdukLpMD9GVM4hsX2f
X-Proofpoint-GUID: oug8H962GbdrlhyOhE1LcRkDXBhs-ayQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_07:2021-05-31,2021-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105310075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make our TAP parser (and me) happy we don't want to have to reports
with exactly the same wording.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/selftest.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/s390x/selftest.c b/s390x/selftest.c
index b2fe2e7b..c2ca9896 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -47,12 +47,19 @@ static void test_malloc(void)
 	*tmp2 = 123456789;
 	mb();
 
-	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
-	report(*tmp == 123456789, "malloc: access works");
+	report_prefix_push("malloc");
+	report_prefix_push("ptr_0");
+	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
+	report(*tmp == 123456789, "wrote allocated memory");
+	report_prefix_pop();
+
+	report_prefix_push("ptr_1");
 	report((uintptr_t)tmp2 & 0xf000000000000000ul,
-	       "malloc: got 2nd vaddr");
-	report((*tmp2 == 123456789), "malloc: access works");
-	report(tmp != tmp2, "malloc: addresses differ");
+	       "allocated memory");
+	report((*tmp2 == 123456789), "wrote allocated memory");
+	report_prefix_pop();
+
+	report(tmp != tmp2, "allocated memory addresses differ");
 
 	expect_pgm_int();
 	configure_dat(0);
@@ -62,6 +69,7 @@ static void test_malloc(void)
 
 	free(tmp);
 	free(tmp2);
+	report_prefix_pop();
 }
 
 int main(int argc, char**argv)
-- 
2.30.2

