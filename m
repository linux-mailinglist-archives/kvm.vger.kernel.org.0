Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1404E3167E8
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhBJNV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:21:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231873AbhBJNVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 08:21:13 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11ADDLjW196273;
        Wed, 10 Feb 2021 08:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7CrLF66ZHGGi/L45r0MaJGuTVuMHsrdqG5zOCFD/PiI=;
 b=eG2XtSL/G5o1BwIlOUIF9glOUPXHpDbzNw+GHqjS6mNPg79nIB10Rxoi57Z1g49e3eoN
 sKvqPkcaIb48rx7vJlMgVMkPRgL5hciWn+XfsxsM6uz1pRbRJnzfmHbg7wkHLRArUh6G
 e81HZuxck2bTFDjzDolf6pPfBm7d9+jsvAu3YVoFJGELy2LO9g3LU69sCDfA2T51MfeU
 mAuq++VaD45lSuUcpFa3xBV4bmguHjlMHvSrAWLTyR7n/DrAKkKNGxVg/s/TsbaA5Ze2
 rvKHf9EHAjKgYjr0UYaEFuQUwjFNwC2E3DBjaTpllRsjY7X3/gfnOevnmMddKgzbBTLF hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mg66r6ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:25 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11ADEx5N009338;
        Wed, 10 Feb 2021 08:20:23 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mg66r6n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:23 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADHFqe026292;
        Wed, 10 Feb 2021 13:20:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2ry2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:20:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADK8fO29950390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:20:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B51D4C04A;
        Wed, 10 Feb 2021 13:20:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B332F4C040;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.174.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/5] s390x: css: testing measurement block format 1
Date:   Wed, 10 Feb 2021 14:20:14 +0100
Message-Id: <1612963214-30397-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Measurement block format 1 is made available by the extended
mesurement block facility and is indicated in the SCHIB by
the bit in the PMCW.

The MBO is specified in the SCHIB of each channel and the MBO
defined by the SCHM instruction is ignored.

The test of the MB format 1 is just skipped if the feature is
not available.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 14 ++++++++++++++
 s390x/css.c     | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 5478f45..ee525f1 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -389,4 +389,18 @@ struct measurement_block_format0 {
 	uint32_t initial_cmd_resp_time;
 };
 
+struct measurement_block_format1 {
+	uint32_t ssch_rsch_count;
+	uint32_t sample_count;
+	uint32_t device_connect_time;
+	uint32_t function_pending_time;
+	uint32_t device_disconnect_time;
+	uint32_t cu_queuing_time;
+	uint32_t device_active_only_time;
+	uint32_t device_busy_time;
+	uint32_t initial_cmd_resp_time;
+	uint32_t irq_delay_time;
+	uint32_t irq_prio_delay_time;
+};
+
 #endif
diff --git a/s390x/css.c b/s390x/css.c
index f3fdc0c..ec5e365 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -246,6 +246,41 @@ end:
 	report_prefix_pop();
 }
 
+static void test_schm_fmt1(void)
+{
+	struct measurement_block_format1 *mb1;
+
+	report_prefix_push("Format 1");
+
+	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
+	if (!mb1) {
+		report_abort("measurement_block_format1 allocation failed");
+		goto end;
+	}
+
+	schm(NULL, 0); /* Clear previous MB address */
+	schm(0, SCHM_MBU);
+
+	/* Expect error for non aligned MB */
+	report_prefix_push("Unaligned MB origin");
+	report_xfail(start_measure((u64)mb1 + 1, 0, true), mb1->ssch_rsch_count != 0,
+		     "SSCH measured %d", mb1->ssch_rsch_count);
+	report_prefix_pop();
+
+	memset(mb1, 0, sizeof(*mb1));
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index");
+	report(start_measure((u64)mb1, 0, true) &&
+	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb1->ssch_rsch_count);
+	report_prefix_pop();
+
+	free_io_mem(mb1, sizeof(struct measurement_block_format1));
+end:
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -257,6 +292,7 @@ static struct {
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
+	{ "measurement block format1", test_schm_fmt1 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

