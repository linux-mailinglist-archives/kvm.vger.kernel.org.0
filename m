Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1820D143E5C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgAUNn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:43:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729293AbgAUNn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:43:27 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LDgYU7133666
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:26 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xp0s6uncx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:25 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 21 Jan 2020 13:43:24 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Jan 2020 13:43:21 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00LDgUY944171690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 13:42:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E44DA4062;
        Tue, 21 Jan 2020 13:43:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D50DA405F;
        Tue, 21 Jan 2020 13:43:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jan 2020 13:43:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 8/9] s390x: smp: Test all CRs on initial reset
Date:   Tue, 21 Jan 2020 08:42:53 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200121134254.4570-1-frankja@linux.ibm.com>
References: <20200121134254.4570-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20012113-0008-0000-0000-0000034B6610
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012113-0009-0000-0000-00004A6BCBD9
Message-Id: <20200121134254.4570-9-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-21_04:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=1 mlxlogscore=999 phishscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001210114
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
index 45f1d80..e36ab8c 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -176,16 +176,28 @@ static void test_emcall(void)
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
@@ -196,6 +208,8 @@ static void test_reset_initial(void)
 	report(!status->fpc, "fpc");
 	report(!status->cputm, "cpu timer");
 	report(!status->todpr, "todpr");
+	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12), "cr1-13 == 0");
+	report(status->crs[15] == 0, "cr15 == 0");
 	report_prefix_pop();
 
 	report_prefix_push("initialized");
-- 
2.20.1

