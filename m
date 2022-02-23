Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647AF4C1424
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240919AbiBWNaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbiBWNaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:30:15 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E034AA2CF;
        Wed, 23 Feb 2022 05:29:47 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NAHpJh018219;
        Wed, 23 Feb 2022 13:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KrHgcefxFkJNDSHdEUfFE4b1KWfOLQhgZfB62ZWZEGw=;
 b=QWmNQjQocNX9Sm+HE2Alwqt3ud1himpUYyaPAPr9lRRoC236OG2WmaePTSIABDt7rfN1
 7JIkYtmTWwsLoZxBsW4v5WgGcpM0kNx/QbjVVdRUBwSx3hC6aE8R3NGkAY3/jr0BmytV
 7RLzFBFiEtV9kbgjDdSJpJCWWjy6CIaph60Z3v/Gps0zBKywy8D72K20EKyhusA207cH
 0iGmilZwAsLRKOGT1MioRfcJW3jATaDKJKNkFGlQjtkHoKqe4ekmhM551Q+wiN2QwBsc
 dr3qTJM1fUj81LI2wVRV37Fx5vUgNRz2PUFpszrn7S9C8PCP40VzBHfx8SU0CqdTlS0u Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edk21bnrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:47 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NCOvnE026408;
        Wed, 23 Feb 2022 13:29:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edk21bnr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NDPjZ0022161;
        Wed, 23 Feb 2022 13:29:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69a7by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 13:29:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NDJ2UL52494788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 13:19:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96A7AA4055;
        Wed, 23 Feb 2022 13:29:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54E81A4051;
        Wed, 23 Feb 2022 13:29:41 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 13:29:41 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/8] s390x: Add test for PFMF low-address protection
Date:   Wed, 23 Feb 2022 14:29:34 +0100
Message-Id: <20220223132940.2765217-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220223132940.2765217-1-nrb@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HtvDW2vtu6W-Kp8OlpFg6zPRR6ATF4Zk
X-Proofpoint-GUID: DPeZtx6Xm0SEL_jT_9mzNZxvXyxR5_6w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_05,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=728 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

PFMF should respect the low-address protection when clearing pages, hence
add some tests for it.

When low-address protection fails, clearing frame 0 is a destructive
operation. It messes up interrupts and thus printing test results won't
work properly. Hence, we first attempt to clear frame 1 which is not as
destructive.

Doing it this way around increases the chances for the user to see a
proper failure message instead of QEMU randomly quitting in the middle
of the test run.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/pfmf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index 2f3cb110dc4c..aa1305292ee8 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -113,6 +113,34 @@ static void test_1m_clear(void)
 	report_prefix_pop();
 }
 
+static void test_low_addr_prot(void)
+{
+	union pfmf_r1 r1 = {
+		.reg.cf = 1,
+		.reg.fsc = PFMF_FSC_4K
+	};
+
+	report_prefix_push("low-address protection");
+
+	report_prefix_push("0x1000");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, (void *)0x1000);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_push("0x0");
+	expect_pgm_int();
+	low_prot_enable();
+	pfmf(r1.val, 0);
+	low_prot_disable();
+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
+	report_prefix_pop();
+
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	bool has_edat = test_facility(8);
@@ -124,6 +152,7 @@ int main(void)
 	}
 
 	test_priv();
+	test_low_addr_prot();
 	/* Force the buffer pages in */
 	memset(pagebuf, 0, PAGE_SIZE * 256);
 
-- 
2.31.1

