Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53004373684
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhEEIoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14026 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232169AbhEEIoe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:34 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458Y5hB161603;
        Wed, 5 May 2021 04:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=YBTV/l4zouVP0SmCeJ7pC2K09Fnld51eVOEdvtR5exg=;
 b=pkGcjToR3iS3aA0zY4TzHt5wp/6oALurfXPm9p/qhrtbPH9fL14XxPRWlnYvku74WUk3
 3z/rAeu9xZEXTo/N4FcNqRBlNiXU6LQTiOf+/+9yIC3qGG88oHXeQlbzdJKjavL6npbL
 sa+QvhBXYreEUXNdU6U2DoKKHtnO0r5TRZqycpS1jh4SYNTE5KhyNfBWTBNR0Vb9H8+n
 ERg6SJMaPwrdwcd4DiX+26goIo+UCiZhTLSIIv0O3+74hM6Qa4HFQUsTBLB7zwyWNrA8
 MfiTxkPOpz0mHydhP0PTztlnVqXxz90jXY3tKUPChRT7taXMoEuitykmgeGfDd5Wf2VO aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bn7ym7ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:38 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458YaIE163435;
        Wed, 5 May 2021 04:43:37 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bn7ym7ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458gTmf010449;
        Wed, 5 May 2021 08:43:34 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 38bee2g3nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hVF642402048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73345A4054;
        Wed,  5 May 2021 08:43:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBFE6A405B;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 6/9] s390x: css: testing measurement block format 0
Date:   Wed,  5 May 2021 10:42:58 +0200
Message-Id: <20210505084301.17395-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9jls_FrfeVP2TCTadB3LEk1-OT5WKzTQ
X-Proofpoint-ORIG-GUID: dmRfBIbwc4SfspiD5OgMlzS5VxVb0VOU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_02:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We test the update of the measurement block format 0, the
measurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/1615545714-13747-6-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 12 +++++++
 s390x/css.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7158423c..335bc705 100644
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
diff --git a/s390x/css.c b/s390x/css.c
index af68266d..658c5f87 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -133,6 +133,13 @@ error_ccw:
 	free_io_mem(senseid, sizeof(*senseid));
 }
 
+static void sense_id(void)
+{
+	assert(!start_ccw1_chain(test_device_sid, ccw));
+
+	assert(wait_and_check_io_completion(test_device_sid) >= 0);
+}
+
 static void css_init(void)
 {
 	assert(register_io_int_func(css_irq_io) == 0);
@@ -175,6 +182,81 @@ static void test_schm(void)
 	report_prefix_pop();
 }
 
+#define SCHM_UPDATE_CNT 10
+static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
+{
+	int i;
+
+	senseid = alloc_io_mem(sizeof(*senseid), 0);
+	assert(senseid);
+
+	ccw = ccw_alloc(CCW_CMD_SENSE_ID, senseid, sizeof(*senseid), CCW_F_SLI);
+	assert(ccw);
+
+	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
+		report_abort("Enabling measurement block failed");
+		return false;
+	}
+
+	for (i = 0; i < SCHM_UPDATE_CNT; i++)
+		sense_id();
+
+	free_io_mem(ccw, sizeof(*ccw));
+	free_io_mem(senseid, sizeof(*senseid));
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
@@ -185,6 +267,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.30.2

