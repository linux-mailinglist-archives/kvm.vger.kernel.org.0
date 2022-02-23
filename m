Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4318F4C1431
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbiBWNaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240924AbiBWNaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:18 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB4FAB462;
        Wed, 23 Feb 2022 05:29:49 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NCgdI6008358;
        Wed, 23 Feb 2022 13:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=68I4S6GFdVgGnjLX7sZ3ZKG9pvsjOaVUcUPR9VmeUWk=;
 b=nvViFkIgTVsMWS8Ot5YvH5p4yPavqsmNb3nzOjAyVz8hQgZd/WpSUcUm6Mvs1FibKOe9
 nJBptaJlGdw7Up4DyCufhSc+qft1j4EfMKVb35hYtzwX+OrQAHcCLEqxnX6eW/ImOA7W
 Pro5ee9xuw6LmU0fdYZIqpl2Www5r9zZAvrI2wXD2J/QF5VmC8hONFZkangfm15kBGQT
 ZPSXogZ3PcZf30BE2ItSdHfRsUmhsgbSKWNqKw7ytgM2eT6ZEmnT17V6G8MnMJu/dYZv
 VUbGCqTFqjQrTfU44EWVYN/a5AXfmmdyVpVcgL2d/3lumbBQCdFa62JALrCGXt95fQsk sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edn5v906j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:48 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NDKqHx020623;
        Wed, 23 Feb 2022 13:29:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edn5v9063-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDOYMI002688;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3ear698nxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDJ2PD52494786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:19:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48C55A4040;
        Wed, 23 Feb 2022 13:29:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0827DA4055;
        Wed, 23 Feb 2022 13:29:41 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:40 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/8] s390x: Add more tests for MSCH
Date:   Wed, 23 Feb 2022 14:29:33 +0100
Message-Id: <20220223132940.2765217-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YULo7YBQvwKvOVo4FOOBrwZdE4_zkSCj
X-Proofpoint-ORIG-GUID: Il1rzpWNFeFzAEuVSb3vg8uM0csRt3QG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some coverage for MSCH, but there are more cases to test
for:

- invalid SCHIB structure. We cover that by setting reserved bits 0, 1,
  6 and 7 in the flags of the PMCW.
  Older QEMU versions require this bit to always be zero on msch,
  which is why this test may fail. A fix is available in QEMU master
  commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask").
- a pointer to an unaligned SCHIB. We cover misalignment by 1
  and 2 bytes. Using pointer to valid memory avoids messing up
  random memory in case of test failures.

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/css.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 881206ba1cef..932daf69bb36 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -27,6 +27,8 @@ static int test_device_sid;
 static struct senseid *senseid;
 struct ccw1 *ccw;
 
+char alignment_test_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
+
 static void test_enumerate(void)
 {
 	test_device_sid = css_enumerate();
@@ -331,6 +333,56 @@ static void test_schm_fmt1(void)
 	free_io_mem(mb1, sizeof(struct measurement_block_format1));
 }
 
+static void test_msch(void)
+{
+	const int align_to = 4;
+	int cc;
+	int invalid_pmcw_flags[] = {0, 1, 6, 7};
+	int invalid_flag;
+	uint16_t old_pmcw_flags;
+
+	if (!test_device_sid) {
+		report_skip("No device");
+		return;
+	}
+
+	cc = stsch(test_device_sid, &schib);
+	if (cc) {
+		report_fail("stsch: sch %08x failed with cc=%d", test_device_sid, cc);
+		return;
+	}
+
+	report_prefix_push("Unaligned");
+	for (int i = 1; i < align_to; i *= 2) {
+		report_prefix_pushf("%d", i);
+
+		expect_pgm_int();
+		msch(test_device_sid, (struct schib *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid SCHIB");
+	old_pmcw_flags = schib.pmcw.flags;
+	for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
+		invalid_flag = invalid_pmcw_flags[i];
+
+		report_prefix_pushf("PMCW flag bit %d set", invalid_flag);
+
+		schib.pmcw.flags = old_pmcw_flags | BIT(15 - invalid_flag);
+		expect_pgm_int();
+		msch(test_device_sid, &schib);
+		check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	schib.pmcw.flags = old_pmcw_flags;
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -343,6 +395,7 @@ static struct {
 	{ "measurement block (schm)", test_schm },
 	{ "measurement block format0", test_schm_fmt0 },
 	{ "measurement block format1", test_schm_fmt1 },
+	{ "msch", test_msch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

