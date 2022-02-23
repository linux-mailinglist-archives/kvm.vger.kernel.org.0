Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097F14C142D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiBWNaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240914AbiBWNaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D622AB45B;
        Wed, 23 Feb 2022 05:29:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NCIhZM022939;
        Wed, 23 Feb 2022 13:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Od4b6AYb+IaGL5C0vSIYTYTxbKRFRG3P9DuR6jrW144=;
 b=ImHv7xv2Y0wN9CCUCbknbowQegAgSq5Ov56EZ1KXFxAG4tRhLyF/7Zyrl+zuKBrPeK5J
 okmU9bbeLWaViRhWEDCY2kFImRlzLSU3+h/XQVxjnaoXVUeUNcglaOqiQOInk1BFuy10
 W+3S/VCmRmM1svdknOljIsyaUGUhQc2cDtoUj57yE1aN6YpEEfiNWANrnpdKOjCvGeE5
 Rhy/qPhAYj89h7EqEtPK2scoTpMvCL6oEc6WfzVkrle6FV4stf0BcgHMfzEPJfdDOT84
 tFW+O6Q88QbBL4xLomlsyKDfhrJj7JZPIDKbrjMNgk2GOqLtdlJ8gfJr56iljEzlfyrx zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edmtesee1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NDQbQD021058;
        Wed, 23 Feb 2022 13:29:47 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edmtesedg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:47 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDOYAl015426;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3ear698pa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDTgnb54460806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:29:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9E34A4065;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9358FA4053;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/8] s390x: Add more tests for STSCH
Date:   Wed, 23 Feb 2022 14:29:38 +0100
Message-Id: <20220223132940.2765217-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4UZv4cyBytxv6zHNFhMx5kDxZNrftCrJ
X-Proofpoint-ORIG-GUID: 7adhBHAU5x_RdQGVDcfNWgHRIkAaVZmY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

  Older QEMU versions require this bit to always be zero on msch,
  which is why this test may fail. A fix is available in QEMU master
  commit 2df59b73e086 ("s390x/css: fix PMCW invalid mask").

Here's the QEMU PMCW invalid mask fix: https://lists.nongnu.org/archive/html/qemu-s390x/2021-12/msg00100.html

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/css.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index a90a0cd64e2b..021eb12573c0 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -496,6 +496,78 @@ static void test_ssch(void)
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
@@ -511,6 +583,8 @@ static struct {
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
 	{ "ssch", test_ssch },
+	{ "stsch", test_stsch },
+	{ "pmcw bit 5 ignored", test_pmcw_bit5 },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

