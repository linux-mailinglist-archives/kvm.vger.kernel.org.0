Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8774961CF
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351288AbiAUPKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:10:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27636 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381510AbiAUPJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 10:09:42 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LEoUY1021233;
        Fri, 21 Jan 2022 15:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=P/aB9PBzGRAzSbgRv0AWhS3zl8/qtXWJKpfP9jb8U4g=;
 b=hda+QrndPpAy7KLWRknQxklE0eKLq+sw6g/WDZil79vjrThk0p9NMhvGWt2doOOlVkDn
 4CH+XGAB9M/7DWWEJVpHHtnJbaXS0dU+gfx50533yZ1slehH9LPuEyNYh16YTQBS/P1B
 kYQeMSmj37hs1SJjlwW+HXl0qz1S+JbFzWlWUSsqwXMPexZ78pGDf5V+/OqyR7E6JLk1
 OEW9hxl2HZFUjuQVdAnjSfNVjxl9S/RfauSH5Zs7Vmw/N5nUZTE53Btug2Ldp3KtaDlo
 a+LM/caE9+U+FB8hj/YGrgu8ejlSuthQUFLmYa9O9Y/wuISsdEaeMQDoVRaqur7qN/hz JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqwgf2ge1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:42 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LEq5cr032388;
        Fri, 21 Jan 2022 15:09:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqwgf2gdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LF2Qgq032404;
        Fri, 21 Jan 2022 15:09:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3dqj1k5pj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 15:09:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LF9Y8e25887134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 15:09:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEB5D42059;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B29A542057;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 15:09:33 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [PATCH kvm-unit-tests v1 6/8] s390x: Add more tests for STSCH
Date:   Fri, 21 Jan 2022 16:09:29 +0100
Message-Id: <20220121150931.371720-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121150931.371720-1-nrb@linux.ibm.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tnlhSQWLXb7BhuA7bQz9osIJEOUe89tT
X-Proofpoint-ORIG-GUID: PkdsHHU3TUq8FScORYucDqc3TDFNe4-2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

css_lib extensively uses STSCH, but two more cases deserve their own
tests:

- unaligned address for SCHIB. We check for misalignment by 1 and 2
  bytes.
- channel not operational
- bit 47 in SID not set
- bit 5 of PMCW flags.
  As per the principles of operation, bit 5 of the PMCW flags shall be
  ignored by msch and always stored as zero by stsch.

  Currently, QEMU requires this bit to always be zero on msch, which is
  why this test currently fails. A fix was posted upstream
  ("[PATCH qemu] s390x/css: fix PMCW invalid mask").

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/css.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index aa3c22eb91bd..7a0a9ddc28ce 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -494,6 +494,78 @@ static void test_ssch(void)
 	report_prefix_pop();
 }
 
+static void test_stsch(void)
+{
+	const int align_to = 4;
+	struct schib schib;
+	int cc;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		stsch(test_device_sid, (struct schib *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid subchannel number");
+	cc = stsch(0x0001ffff, &schib);
+	report(cc == 3, "Channel not operational");
+	report_prefix_pop();
+
+	report_prefix_push("Bit 47 in SID is zero");
+	expect_pgm_int();
+	stsch(0x0000ffff, &schib);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+}
+
+static void test_pmcw_bit5(void)
+{
+	int cc;
+	uint16_t old_pmcw_flags;
+
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
+		return;
+	}
+	old_pmcw_flags = schib.pmcw.flags;
+
+	report_prefix_push("Bit 5 set");
+
+	schib.pmcw.flags = old_pmcw_flags | BIT(15 - 5);
+	cc = msch(test_device_sid, &schib);
+	report(!cc, "MSCH cc == 0");
+
+	cc = stsch(test_device_sid, &schib);
+	report(!cc, "STSCH cc == 0");
+	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
+
+	report_prefix_pop();
+
+	report_prefix_push("Bit 5 clear");
+
+	schib.pmcw.flags = old_pmcw_flags & ~BIT(15 - 5);
+	cc = msch(test_device_sid, &schib);
+	report(!cc, "MSCH cc == 0");
+
+	cc = stsch(test_device_sid, &schib);
+	report(!cc, "STSCH cc == 0");
+	report(!(schib.pmcw.flags & BIT(15 - 5)), "STSCH PMCW Bit 5 is clear");
+
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -509,6 +581,8 @@ static struct {
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
 	{ "ssch", test_ssch },
+	{ "stsch", test_stsch },
+	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

