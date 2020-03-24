Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA95190736
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 09:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCXING (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 04:13:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbgCXINF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 04:13:05 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O83xVu009116
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:05 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywewtr7ms-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 04:13:05 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 08:13:03 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 08:13:00 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02O8D07l20512888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 08:13:00 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2251EA4064;
        Tue, 24 Mar 2020 08:13:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AB5EA4060;
        Tue, 24 Mar 2020 08:12:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 08:12:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
Subject: [kvm-unit-tests PATCH 01/10] s390x: smp: Test all CRs on initial reset
Date:   Tue, 24 Mar 2020 04:12:42 -0400
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324081251.28810-1-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032408-0028-0000-0000-000003EA6E2D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032408-0029-0000-0000-000024AFD6F2
Message-Id: <20200324081251.28810-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_01:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240039
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
---
 s390x/smp.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index fa40753524f321d4..8c9b98aabd9e8222 100644
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
+	uint64_t nullp[12] = {};
 	struct psw psw;
 
 	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)test_func;
+	psw.addr = (unsigned long)test_func_initial;
 
 	report_prefix_push("reset initial");
+	set_flag(0);
 	smp_cpu_start(1, psw);
+	wait_for_flag();
 
 	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
 	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
@@ -202,6 +214,8 @@ static void test_reset_initial(void)
 	report(!status->fpc, "fpc");
 	report(!status->cputm, "cpu timer");
 	report(!status->todpr, "todpr");
+	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12), "cr1-13 == 0");
+	report(status->crs[15] == 0, "cr15 == 0");
 	report_prefix_pop();
 
 	report_prefix_push("initialized");
-- 
2.25.1

