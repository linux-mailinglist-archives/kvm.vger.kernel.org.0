Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DD63325D4
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhCIMvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42128 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231181AbhCIMv2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:28 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129CXWJu189390
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=NowY+b02fjSQpxuIn/cKH3cmWZ93gHrdFglfZfK6/ck=;
 b=mh66GjyUvAJVd00P/riGznOxpaoD17LmeAXnPf68qqATi/+I+SHNm5/s3SSHnSsz/65s
 Bf0LeUvWtkpQpmQW7G62vqU9+o8Noluy48vznxQvrJLJ/FYkpBB7AMTK4CTWNNBn9O1/
 BQn9/rz7l2EbQl7gwUEfVbOOV2iQHD8MEwkdJwtfLuyT64EBuCtkr53tunVVyIz+Q7sy
 ZMTkBnemsSmnZWiFbZqlLlEvVucO1wis10KXTB6rO6b1SnvMJBNUxdFsCzi0+8PCW4jl
 t3+QVkHJLPK8NTSxJ5P5xI+rrn+Mf2EFwe5U+NGLVY3ZTpKRp0ViFzkh7yoHDlc/BiBK mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375wcm8q0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:27 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CXeLo189719
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:27 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375wcm8pyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:26 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CSdtO027447;
        Tue, 9 Mar 2021 12:51:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3768t4g12n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpKOC23069124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 831BB52057;
        Tue,  9 Mar 2021 12:51:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 365F852054;
        Tue,  9 Mar 2021 12:51:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 5/6] s390x: css: testing measurement block format 0
Date:   Tue,  9 Mar 2021 13:51:16 +0100
Message-Id: <1615294277-7332-6-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We test the update of the measurement block format 0, the
measurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h     | 12 ++++++
 lib/s390x/css_lib.c |  4 --
 s390x/css.c         | 95 ++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 98 insertions(+), 13 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7158423..335bc70 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -374,4 +374,16 @@ static inline void schm(void *mbo, unsigned int flags)
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
 bool css_disable_mb(int schid);
 
+struct measurement_block_format0 {
+	uint16_t ssch_rsch_count;
+	uint16_t sample_count;
+	uint32_t device_connect_time;
+	uint32_t function_pending_time;
+	uint32_t device_disconnect_time;
+	uint32_t cu_queuing_time;
+	uint32_t device_active_only_time;
+	uint32_t device_busy_time;
+	uint32_t initial_cmd_resp_time;
+};
+
 #endif
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 95d9a78..8f09383 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -365,10 +365,6 @@ void css_irq_io(void)
 		       lowcore_ptr->io_int_param, sid);
 		goto pop;
 	}
-	report_info("subsys_id_word: %08x io_int_param %08x io_int_word %08x",
-			lowcore_ptr->subsys_id_word,
-			lowcore_ptr->io_int_param,
-			lowcore_ptr->io_int_word);
 	report_prefix_pop();
 
 	report_prefix_push("tsch");
diff --git a/s390x/css.c b/s390x/css.c
index a763814..b63826e 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -74,18 +74,12 @@ static void test_sense(void)
 		return;
 	}
 
-	ret = register_io_int_func(css_irq_io);
-	if (ret) {
-		report(0, "Could not register IRQ handler");
-		return;
-	}
-
 	lowcore_ptr->io_int_param = 0;
 
 	senseid = alloc_io_mem(sizeof(*senseid), 0);
 	if (!senseid) {
 		report(0, "Allocation of senseid");
-		goto error_senseid;
+		return;
 	}
 
 	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
@@ -137,8 +131,24 @@ error:
 	free_io_mem(ccw, sizeof(*ccw));
 error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
-error_senseid:
-	unregister_io_int_func(css_irq_io);
+}
+
+static void sense_id(void)
+{
+	struct ccw1 *ccw;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+
+	assert(!start_ccw1_chain(test_device_sid, ccw));
+
+	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+
+	free_io_mem(ccw, sizeof(*ccw));
+	free_io_mem(senseid, sizeof(*senseid));
 }
 
 static void css_init(void)
@@ -183,6 +193,72 @@ static void test_schm(void)
 	report_prefix_pop();
 }
 
+#define SCHM_UPDATE_CNT 10
+static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
+{
+	int i;
+
+	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
+		report_abort("Enabling measurement block failed");
+		return false;
+	}
+
+	for (i = 0; i < SCHM_UPDATE_CNT; i++)
+		sense_id();
+
+	return true;
+}
+
+/*
+ * test_schm_fmt0:
+ * With measurement block format 0 a memory space is shared
+ * by all subchannels, each subchannel can provide an index
+ * for the measurement block facility to store the measurements.
+ */
+static void test_schm_fmt0(void)
+{
+	struct measurement_block_format0 *mb0;
+	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	/* Allocate zeroed Measurement block */
+	mb0 = alloc_io_mem(shared_mb_size, 0);
+	if (!mb0) {
+		report_abort("measurement_block_format0 allocation failed");
+		return;
+	}
+
+	schm(NULL, 0); /* Stop any previous measurement */
+	schm(mb0, SCHM_MBU);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 0");
+	report(start_measuring(0, 0, false) &&
+	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0->ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Clear the measurement block for the next test */
+	memset(mb0, 0, shared_mb_size);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 1");
+	if (start_measuring(0, 1, false))
+		report(mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
+		       "SSCH measured %d", mb0[1].ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Stop the measurement */
+	css_disable_mb(test_device_sid);
+	schm(NULL, 0);
+
+	free_io_mem(mb0, shared_mb_size);
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -193,6 +269,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

