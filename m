Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597E34E570F
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245635AbiCWRFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245619AbiCWRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37774F461;
        Wed, 23 Mar 2022 10:03:32 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NGjij1005106;
        Wed, 23 Mar 2022 17:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rWbuFv4lGzl+y/2dTFlezS5g21Ok5kP3Q0CN9QF5nQ0=;
 b=Agb9SyTgtUdb8D2QDTw4Lwbmw3bxZQdfHEBS1UngltnTgQ5fDRJiwJTSj2wSpnAN3VFP
 NFOm6GAf0Ptx1va9gam2P2SMqBS8RnjZvKuBQVwacDY6ZYRBhXDhyaBzIollUkANTia5
 fVM1CIM88iT73dWZt6gLcvxYlVvLy+Ci3qbP5SbLCuJ4x2DwPZBdBg+EG/yVbnlyvRVK
 h4vTycp0DOwxh0Rm84L6Sep/NWTAFZiz9CO0Lr6wUFOB7U/FAE1nF4a3UKyWztKsE45X
 rxMMIxP+3+ZMGUAtb41qqf679IxMByQQSSVSH9uQxHchk1V+0uQ6ZAppE6lF4tMWpJQl 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f07bwgcnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:31 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGkjlk011231;
        Wed, 23 Mar 2022 17:03:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f07bwgcmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxiRb005859;
        Wed, 23 Mar 2022 17:03:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t911u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3Qgx21430646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7904C04A;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 168A54C050;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/9] s390x: smp: add tests for several invalid SIGP orders
Date:   Wed, 23 Mar 2022 18:03:17 +0100
Message-Id: <20220323170325.220848-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dHpqrpUkrC-9i1O0g_6dIa8zzuIIsRsc
X-Proofpoint-ORIG-GUID: RtrjIMMMTT2sNN_9Z0qObdUqDw0rn8cn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests with for intercepted SIGP orders with invalid values:

- SIGP_STOP with invalid CPU address
- SIGP_START with invalid CPU address
- SIGP_CPU_RESET with invalid CPU address
- SIGP_STOP_AND_STORE_STATUS with invalid CPU address
- SIGP_STORE_STATUS_AT_ADDRESS with invalid CPU address
- invalid order
- invalid order with invalid CPU address

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 068ac74dd28a..911a26c51b10 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -19,6 +19,47 @@
 #include <alloc_page.h>
 
 static int testflag = 0;
+#define INVALID_CPU_ADDRESS -4711
+#define INVALID_ORDER_CODE 0xFF
+struct sigp_invalid_cases {
+	int order;
+	char message[100];
+};
+static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
+	{ SIGP_STOP,                  "stop with invalid CPU address" },
+	{ SIGP_START,                 "start with invalid CPU address" },
+	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
+	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
+	{ SIGP_SENSE,                 "sense with invalid CPU address" },
+	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
+};
+static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
+	{ INVALID_ORDER_CODE,         "invalid order code" },
+};
+
+static void test_invalid(void)
+{
+	const struct sigp_invalid_cases *c;
+	uint32_t status;
+	int cc;
+	int i;
+
+	report_prefix_push("invalid parameters");
+
+	for (i = 0; i < ARRAY_SIZE(cases_invalid_cpu_addr); i++) {
+		c = &cases_invalid_cpu_addr[i];
+		cc = sigp(INVALID_CPU_ADDRESS, c->order, 0, &status);
+		report(cc == 3, c->message);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cases_valid_cpu_addr); i++) {
+		c = &cases_valid_cpu_addr[i];
+		cc = smp_sigp(1, c->order, 0, &status);
+		report(cc == 1, c->message);
+	}
+
+	report_prefix_pop();
+}
 
 static void wait_for_flag(void)
 {
@@ -123,10 +164,16 @@ static void test_store_status(void)
 {
 	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
 	uint32_t r;
+	int cc;
 
 	report_prefix_push("store status at address");
 	memset(status, 0, PAGE_SIZE * 2);
 
+	report_prefix_push("invalid CPU address");
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
+	report(cc == 3, "returned with CC = 3");
+	report_prefix_pop();
+
 	report_prefix_push("running");
 	smp_cpu_restart(1);
 	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
@@ -331,6 +378,7 @@ int main(void)
 	smp_cpu_stop(1);
 
 	test_start();
+	test_invalid();
 	test_restart();
 	test_stop();
 	test_stop_store_status();
-- 
2.31.1

