Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921744C301B
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbiBXPoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiBXPoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:44:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EE622A270;
        Thu, 24 Feb 2022 07:43:44 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFFbt9023429;
        Thu, 24 Feb 2022 15:43:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lp5H365CDZxhq0iKZViqibDNP0ljS1wYzotLTtqMBzU=;
 b=P/bgSiLQw5FIJaxecY2oNUjkMxhWNz2FSNTQJ7HHfZgO/gsJhomC3P9x0sN4jhD/sop/
 8cnvq521aHmf1S2YJsQfU/H9ZPo5BZq0RvietjEwatd9HbExI9PWSb/EkKAOX7ZG5IAs
 4IOjwqhY77y1UzrCDKOjTRuNq0hEGKo5UyEUr5wVDNt5WLXJJUsQe57nXpupJdUJMooF
 5F0VY3hEcJ6noa3620yTdeL+Hq5PokRvg7Gt8XL6/gGypoiVWAgie6DSNEyiRNjiZCsk
 dxuE05rPIYVVxrlFwc0qJhTxDF/Cuhp88Mz8YxaUf6gGC4tnuZO9Rzb9cUYeEedXsxJX bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edy03j3nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:43 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OFU5am022690;
        Thu, 24 Feb 2022 15:43:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edy03j3n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OFb6WF016957;
        Thu, 24 Feb 2022 15:43:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3ear69gtmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:43:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OFhcDL52953448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:43:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36E054204D;
        Thu, 24 Feb 2022 15:43:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA59042042;
        Thu, 24 Feb 2022 15:43:37 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:43:37 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v4 5/8] s390x: Add more tests for SSCH
Date:   Thu, 24 Feb 2022 16:43:33 +0100
Message-Id: <20220224154336.3459839-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220224154336.3459839-1-nrb@linux.ibm.com>
References: <20220224154336.3459839-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uG99Rsn7-U2IYiG9GZv9jJIuPPJbUJSa
X-Proofpoint-ORIG-GUID: TSXzVLYaX8q8Q3GIpXI4vSeFQk7F2yhc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some coverage of SSCH due to its use in
start_ccw1_chain() in css_lib, but two more cases deserve our
attention:

- unaligned operand address. We check for misalignment by 1 and 2 bytes.
- an invalid ORB structure.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index fcc264eecd4b..7fe5283c41d0 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -469,6 +469,38 @@ static void test_stcrw(void)
 	report_prefix_pop();
 }
 
+static void test_ssch(void)
+{
+	const int align_to = 4;
+	struct orb orb;
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
+		ssch(test_device_sid, (struct orb *)(alignment_test_page + i));
+		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+
+	report_prefix_push("Invalid ORB");
+
+	memset(&orb, 0xff, sizeof(orb));
+	expect_pgm_int();
+	ssch(test_device_sid, &orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -483,6 +515,7 @@ static struct {
 	{ "measurement block format1", test_schm_fmt1 },
 	{ "msch", test_msch },
 	{ "stcrw", test_stcrw },
+	{ "ssch", test_ssch },
 	{ NULL, NULL }
 };
 
-- 
2.31.1

