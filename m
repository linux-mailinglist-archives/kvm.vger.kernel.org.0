Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407221B70FE
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 11:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDXJeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 05:34:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726770AbgDXJeH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 05:34:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O9Xm7S025353;
        Fri, 24 Apr 2020 05:34:06 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30k7rd0dqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 05:34:06 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03O9Y6aL028083;
        Fri, 24 Apr 2020 05:34:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30k7rd0dpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 05:34:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03O9PxKP001321;
        Fri, 24 Apr 2020 09:34:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 30fs658ypv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 09:34:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03O9Y1wa57278508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 09:34:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E38C142042;
        Fri, 24 Apr 2020 09:34:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E68D42045;
        Fri, 24 Apr 2020 09:34:00 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 09:34:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v3] s390x: smp: Test all CRs on initial reset
Date:   Fri, 24 Apr 2020 05:33:56 -0400
Message-Id: <20200424093356.11931-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2ebdf5d6-74ac-d9e5-d329-29611a5f87cd@redhat.com>
References: <2ebdf5d6-74ac-d9e5-d329-29611a5f87cd@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_03:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 impostorscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
so we also need to test 1-13 and 15 for 0.

And while we're at it, let's also set some values to cr 1, 7 and 13, so
we can actually be sure that they will be zeroed.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 s390x/smp.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index fa40753..7144c9b 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -182,16 +182,28 @@ static void test_emcall(void)
 	report_prefix_pop();
 }
 
+/* Used to dirty registers of cpu #1 before it is reset */
+static void test_func_initial(void)
+{
+	lctlg(1, 0x42000UL);
+	lctlg(7, 0x43000UL);
+	lctlg(13, 0x44000UL);
+	set_flag(1);
+}
+
 static void test_reset_initial(void)
 {
 	struct cpu_status *status = alloc_pages(0);
 	struct psw psw;
+	int i;
 
 	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
+	psw.addr = (unsigned long)test_func_initial;
 
 	report_prefix_push("reset initial");
+	set_flag(0);
 	smp_cpu_start(1, psw);
+	wait_for_flag();
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
@@ -202,6 +214,10 @@ static void test_reset_initial(void)
 	report(!status->fpc, "fpc");
 	report(!status->cputm, "cpu timer");
 	report(!status->todpr, "todpr");
+	for (i = 1; i <= 13; i++) {
+		report(status->crs[i] == 0, "cr%d == 0", i);
+	}
+	report(status->crs[15] == 0, "cr15 == 0");
 	report_prefix_pop();
 
 	report_prefix_push("initialized");
-- 
2.25.1

