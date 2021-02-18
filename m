Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B3B31EE52
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhBRSbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:31:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32502 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234309AbhBRR1v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:27:51 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHKeC7029334
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=XUwDHpTntPh1TiCgBp2pODsbSW8lhSi1XIVSN1O2HVk=;
 b=qxMyyd0lwDM63uv7bpZXAgtArwun7vPi3tza6b6QE4H2wUK8tjqQHp3hxByObi1xDamU
 EErLheK715ptJ+tqXZwjC2EzDAmyyPuAdGolUX/GtXpVRxZMPxdv0TLUy3vdJNZZAiox
 9t4cK3OymWAR1Ngwx1TsOeoscSx2jghCnRlvcC+32/rIGAABdsuzzj7R8e097oEh5hpV
 vzStnn0UjSBTrYUIyQS3DXQopu8xHwfwMCkJgmom7T51I6Y1sN+kgA+ujnoBIos2AROk
 x8UQ30FwmJ2Nf4wFzMZ542T9nqChiTHCWU4ExXdN3XgafMHT2VsDb4r3pC1zsxSt0fgY cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36stphvxn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHKkTg029778
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:53 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36stphvxmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:26:52 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNKsO008696;
        Thu, 18 Feb 2021 17:26:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 36p6d8ahnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:26:50 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHQlmf54198754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:26:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B99D7A4040;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 639A9A4053;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:26:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 4/5] s390x: css: testing measurement block format 0
Date:   Thu, 18 Feb 2021 18:26:43 +0100
Message-Id: <1613669204-6464-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_08:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We test the update of the measurement block format 0, the
measurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 12 +++++++++
 s390x/css.c     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 17b917f..dabe54a 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -375,4 +375,16 @@ static inline void schm(void *mbo, unsigned int flags)
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
index fc693f3..b65aa89 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -191,6 +191,72 @@ static void test_schm(void)
 	report_prefix_pop();
 }
 
+#define SCHM_UPDATE_CNT 10
+static bool start_measure(uint64_t mbo, uint16_t mbi, bool fmt1)
+{
+	int i;
+
+	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
+		report(0, "Enabling measurement_block_format");
+		return false;
+	}
+
+	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
+		if (!do_test_sense()) {
+			report(0, "Error during sense");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/*
+ * test_schm_fmt0:
+ * With measurement block format 0 a memory space is shared
+ * by all subchannels, each subchannel can provide an index
+ * for the measurement block facility to store the measures.
+ */
+static void test_schm_fmt0(void)
+{
+	struct measurement_block_format0 *mb0;
+	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
+
+	report_prefix_push("Format 0");
+
+	/* Allocate zeroed Measurement block */
+	mb0 = alloc_io_mem(shared_mb_size, 0);
+	if (!mb0) {
+		report_abort("measurement_block_format0 allocation failed");
+		goto end;
+	}
+
+	schm(NULL, 0); /* Stop any previous measurement */
+	schm(mb0, SCHM_MBU);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 0");
+	report(start_measure(0, 0, false) &&
+	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0->ssch_rsch_count);
+	report_prefix_pop();
+
+	/* Clear the measurement block for the next test */
+	memset(mb0, 0, shared_mb_size);
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index 1");
+	report(start_measure(0, 1, false) &&
+	       mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0[1].ssch_rsch_count);
+	report_prefix_pop();
+
+	schm(NULL, 0); /* Stop the measurement */
+	free_io_mem(mb0, shared_mb_size);
+end:
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -201,6 +267,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.25.1

