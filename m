Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83031EE51
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBRSab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:30:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234311AbhBRR1v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:27:51 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNISu051184
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rccwYr/FNYBGPmRKj5jsXZ1yNUt/GYo10XHAfyEHpRA=;
 b=j3UMT5LLUIvjyGEBTObDMJ8Z8xScl5Dqa5N8HgbCzBE9tR+vBpGESYai9DCf5+b0DMXD
 aMeLRGiN60iD9mm88SijP3LqwrvQabweJcG1gnkW66ImjyyjIq6eSyYWkO4fiJbQQTVw
 TO329sbcAFi0GZXF3LC3Tev1cP1s5L0JBfTbTijw9rLjvHx1d3xIMPyv30rWHMhZf2EA
 uMmDqOpdGMm5GmSNLY0Ry5Sfhd2I3aaKrsE0O+VktXZbqHhiQXWN4f6mAw9m32yyXevP
 PHmTDH61OFxikgOXC9qc0Ar4Ez/B7zIQtpQW703CMYJlIwjXK/gUXWJgzyup6OWY1mBL uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36svke83qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHQrTI078534
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36svke83pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:26:53 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNooX013888;
        Thu, 18 Feb 2021 17:26:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u9fy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:26:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHQm2x39059954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:26:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 231F3A4040;
        Thu, 18 Feb 2021 17:26:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA00EA4053;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 5/5] s390x: css: testing measurement block format 1
Date:   Thu, 18 Feb 2021 18:26:44 +0100
Message-Id: <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_07:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180141
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
 lib/s390x/css.h     | 16 ++++++++++++++
 lib/s390x/css_lib.c | 25 ++++++++++++++++++++-
 s390x/css.c         | 53 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index dabe54a..1e5e4b5 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -387,4 +387,20 @@ struct measurement_block_format0 {
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
+void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb);
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 4c8a6ae..1f09f93 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -298,7 +298,7 @@ static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
 			pmcw->flags2 &= ~PMCW_MBF1;
 
 		pmcw->mbi = mbi;
-		schib.mbo = mb;
+		schib.mbo = mb & ~0x3f;
 	} else {
 		pmcw->flags &= ~(PMCW_MBUE | PMCW_DCTME);
 	}
@@ -527,3 +527,26 @@ void enable_io_isc(uint8_t isc)
 	value = (uint64_t)isc << 24;
 	lctlg(6, value);
 }
+
+void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
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
diff --git a/s390x/css.c b/s390x/css.c
index b65aa89..576df48 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -257,6 +257,58 @@ end:
 	report_prefix_pop();
 }
 
+/*
+ * test_schm_fmt1:
+ * With measurement block format 1 the mesurement block is
+ * dedicated to a subchannel.
+ */
+static void test_schm_fmt1(void)
+{
+	struct measurement_block_format1 *mb1;
+
+	report_prefix_push("Format 1");
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		goto end;
+	}
+
+	if (!css_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK)) {
+		report_skip("Extended measurement block not available");
+		goto end;
+	}
+
+	/* Allocate zeroed Measurement block */
+	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
+	if (!mb1) {
+		report_abort("measurement_block_format1 allocation failed");
+		goto end;
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
+	report_prefix_push("Valid MB address and index");
+	report(start_measure((u64)mb1, 0, true) &&
+	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb1->ssch_rsch_count);
+	report_prefix_pop();
+
+	schm(NULL, 0); /* Stop the measurement */
+	free_io_mem(mb1, sizeof(struct measurement_block_format1));
+end:
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -268,6 +320,7 @@ static struct {
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
+	{ "measurement block format1", test_schm_fmt1 },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

