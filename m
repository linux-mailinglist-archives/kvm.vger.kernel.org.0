Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1C327D84
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhCALsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234211AbhCALr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:57 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121BXGjq060575
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=7BVcL6nmNb9Ih0bIDSFpJBhc6rY8axTKd7rF67FM6X0=;
 b=iNLvhtdjyKfP14NhDnXq/fPk8eXmwx51M52ln/e7TIje4BkHkTC00xBxRdZt5sY7kEzx
 1CivO8XDHm/b9XN/S84e2xZ7yYTPBDpmB3MVAMI202JOlYu+N4awMlc5eMbIbQ1f9kv4
 jjJHCFQGAEEnzSSt9mXtORMfeVnNd7CZ8vSp9j8lXA3hDNooI5PKxG8HbExwN6HydURJ
 OJNAEf5kqPhpeyLiDVXoqTbhPMp5nQUZV2uXtmeL15uhFvDFtTPsMkBObytwReFYff/m
 bfOnvBtCBJFuqxSdEB7eIQWeJy4PxBo4BghKqLk2oMMQDkb5XLovVDAKvrYk/C1ZR1qS kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370vday0r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:15 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121BXTp4061480
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370vday0qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121Bgq9s014162;
        Mon, 1 Mar 2021 11:47:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 370c59rua7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121Bl9Rj34079092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:47:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C8AAE055;
        Mon,  1 Mar 2021 11:47:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20765AE045;
        Mon,  1 Mar 2021 11:47:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 6/6] s390x: css: testing measurement block format 1
Date:   Mon,  1 Mar 2021 12:47:05 +0100
Message-Id: <1614599225-17734-7-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_05:2021-02-26,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 clxscore=1015 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Measurement block format 1 is made available by the extended
measurement block facility and is indicated in the SCHIB by
the bit in the PMCW.

The MBO is specified in the SCHIB of each channel and the MBO
defined by the SCHM instruction is ignored.

The test of the MB format 1 is just skipped if the feature is
not available.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 15 +++++++++
 lib/s390x/css_lib.c |  2 +-
 s390x/css.c         | 75 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 40f9efa..c8c8e04 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -107,6 +107,7 @@ struct schib {
 	uint64_t mbo;
 	uint8_t  md[4];
 } __attribute__ ((aligned(4)));
+extern struct schib schib;
 
 struct irb {
 	struct scsw scsw;
@@ -387,4 +388,18 @@ struct measurement_block_format0 {
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
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 77b39c7..a43da5c 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -19,7 +19,7 @@
 #include <malloc_io.h>
 #include <css.h>
 
-static struct schib schib;
+struct schib schib;
 struct chsc_scsc *chsc_scsc;
 
 static const char * const chsc_rsp_description[] = {
diff --git a/s390x/css.c b/s390x/css.c
index 3915ed3..5723808 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -249,6 +249,80 @@ static void test_schm_fmt0(void)
 	free_io_mem(mb0, shared_mb_size);
 }
 
+static void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
+{
+	struct pmcw *pmcw = &schib.pmcw;
+	int cc;
+
+	/* Read the SCHIB for this subchannel */
+	cc = stsch(schid, &schib);
+	if (cc) {
+		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
+		return;
+	}
+
+	/* Update the SCHIB to enable the measurement block */
+	pmcw->flags |= PMCW_MBUE;
+	pmcw->flags2 |= PMCW_MBF1;
+	schib.mbo = mb;
+
+	/* Tell the CSS we want to modify the subchannel */
+	expect_pgm_int();
+	cc = msch(schid, &schib);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+}
+
+/*
+ * test_schm_fmt1:
+ * With measurement block format 1 the measurement block is
+ * dedicated to a subchannel.
+ */
+static void test_schm_fmt1(void)
+{
+	struct measurement_block_format1 *mb1;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	if (!css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
+		report_skip("Extended measurement block not available");
+		return;
+	}
+
+	/* Allocate zeroed Measurement block */
+	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
+	if (!mb1) {
+		report_abort("measurement_block_format1 allocation failed");
+		return;
+	}
+
+	schm(NULL, 0); /* Stop any previous measurement */
+	schm(0, SCHM_MBU);
+
+	/* Expect error for non aligned MB */
+	report_prefix_push("Unaligned MB origin");
+	msch_with_wrong_fmt1_mbo(test_device_sid, (uint64_t)mb1 + 1);
+	report_prefix_pop();
+
+	/* Clear the measurement block for the next test */
+	memset(mb1, 0, sizeof(*mb1));
+
+	/* Expect success */
+	report_prefix_push("Valid MB origin");
+	report(start_measuring((u64)mb1, 0, true) &&
+	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb1->ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Stop the measurement */
+	css_disable_mb(test_device_sid);
+	schm(NULL, 0);
+
+	free_io_mem(mb1, sizeof(struct measurement_block_format1));
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -260,6 +334,7 @@ static struct {
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
+	{ "measurement block format1", test_schm_fmt1 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

