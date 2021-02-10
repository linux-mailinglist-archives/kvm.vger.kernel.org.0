Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E113167E0
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhBJNVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:21:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31644 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhBJNVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 08:21:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AD64Xa091553;
        Wed, 10 Feb 2021 08:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=HbEBOZqdv9etvu0vZuKmz+75jYENVs/tQaaUC9wfzPI=;
 b=f2RBu4WR8XptbuwiTjUJypKWnh7P1zrqfFNW8xYn+0IkV3Q60w2cV6WsRomjlQ9JkRk/
 TQd746zh7SySuFAOsXbZgMOpYpkFtpsymUjoC3XoFeZQWzrbRAA0nUc8GVyW7AyFs9nu
 G84cGLxZD3bewlO2YLpzmUJ/nF8zcQ+2cwkfvUvZjrPItCQD+ngn+Tw7cPR3lcPa0kL0
 G6E+jP/X+mu90rok1LOEh+6G4zXKYyhn+MJZjczACZLmzyQasKjYtqucN0a5aLyXORA3
 1MyK0HPeFGo4Fb8AQ6nWbpaFR+5ckNtKwleQ/H50qdhmxEgoJB+d+hovvoL9VsWkShhh 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfuv8thw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11ADKMue173326;
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfuv8tgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:22 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADGcHM025825;
        Wed, 10 Feb 2021 13:20:20 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2ry2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:20:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADK7lj21758282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:20:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A087B4C044;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3713F4C040;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.174.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 13:20:17 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/5] s390x: css: testing measurement block format 0
Date:   Wed, 10 Feb 2021 14:20:13 +0100
Message-Id: <1612963214-30397-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We tests the update of the mesurement block format 0, the
mesurement block origin is calculated from the mbo argument
used by the SCHM instruction and the offset calculated using
the measurement block index of the SCHIB.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 14 +++++++++++++
 s390x/css.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 0e3254a..5478f45 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -374,5 +374,19 @@ static inline void schm(void *mbo, unsigned int flags)
 }
 
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
+#define SCHM_DCTM	1 /* activate Device Connection TiMe */
+#define SCHM_MBU	2 /* activate Measurement Block Update */
+
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
 
 #endif
diff --git a/s390x/css.c b/s390x/css.c
index a382235..f3fdc0c 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -189,7 +189,61 @@ static void test_schm(void)
 	schm(NULL, SCHM_MBU);
 	report(1,"SCHM call without address");
 	report_prefix_pop();
+}
+
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
+static void test_schm_fmt0(void)
+{
+	struct measurement_block_format0 *mb0;
+
+	report_prefix_push("Format 0");
+
+	mb0 = alloc_io_mem(sizeof(struct measurement_block_format0), 0);
+	if (!mb0) {
+		report_abort("measurement_block_format0 allocation failed");
+		goto end;
+	}
+
+	schm(NULL, 0); /* Clear previous MB address */
+	schm(mb0, SCHM_MBU);
 
+	/* Expect error for non aligned MB */
+	report_prefix_push("Unaligned MB index");
+	report_xfail(start_measure(0, 0x01, false), mb0->ssch_rsch_count != 0,
+		     "SSCH measured %d", mb0->ssch_rsch_count);
+	report_prefix_pop();
+
+	memset(mb0, 0, sizeof(*mb0));
+
+	/* Expect success */
+	report_prefix_push("Valid MB address and index");
+	report(start_measure(0, 0, false) &&
+	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
+	       "SSCH measured %d", mb0->ssch_rsch_count);
+	report_prefix_pop();
+
+	free_io_mem(mb0, sizeof(struct measurement_block_format0));
+end:
+	report_prefix_pop();
 }
 
 static struct {
@@ -202,6 +256,7 @@ static struct {
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
 	{ "measurement block (schm)", test_schm },
+	{ "measurement block format0", test_schm_fmt0 },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

