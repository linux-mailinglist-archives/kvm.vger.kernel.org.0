Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90498573593
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiGMLgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236122AbiGMLgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:36:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923B9102722;
        Wed, 13 Jul 2022 04:36:29 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBLQqT023526;
        Wed, 13 Jul 2022 11:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rFXL5Z38uPZ4gU1+y6hkT7AR9bjyyQrBbbckGUP5koA=;
 b=bc27VY+cGhewoAUXM4D/oar5TCUxDH63FIeIjBTMylP/uJ/0G/JWtQaARrRyXnWveFLV
 jpHJXpgRAao3sFsrdGBN7P4x+7znsivsapdCpttGd3dashiWdDmW+rpt0+4gPPP0+Ne2
 PDkPKfS096ss9JmVIDxHfVqrjTjh93aqOkKkZKHj2tXRIOBwiG49l+tXTcesTL4V7PKV
 169I9RBQC/7xvnkku1vqsmYiNdXyqemU4vwV5GaiFINGQPHWLrhHom6Ewx0Sbbc7qqsr
 jPqv1d6cwP6CSm3yQUEr3vdHzaFwSBZCWBFH6VcM4cuSNbaLhgDuqU1HClJm3knk7psW vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3q8abq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBPbm8006898;
        Wed, 13 Jul 2022 11:36:28 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3q8aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBZPMN001133;
        Wed, 13 Jul 2022 11:36:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3h71a8mup1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBaXag33030524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:36:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2514011C054;
        Wed, 13 Jul 2022 11:36:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E31A911C050;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/4] s390x: smp: use an array for sigp calls
Date:   Wed, 13 Jul 2022 13:36:20 +0200
Message-Id: <20220713113621.14778-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713113621.14778-1-nrb@linux.ibm.com>
References: <20220713113621.14778-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 43P6-9FKvQfzGDP3frBT9Tylx-vn1jN6
X-Proofpoint-GUID: dU3Qp-17jvOomMOo89MxG9j-B3gl9etF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests for the SIGP calls are quite similar, so we have a lot of code
duplication right now. Since upcoming changes will add more cases,
refactor the code to iterate over an array, similarily as we already do
for test_invalid().

The receiving CPU is disabled for IO interrupts. This makes sure the
conditional emergency signal is accepted and doesn't hurt the other
orders.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 130 ++++++++++++++++++----------------------------------
 1 file changed, 44 insertions(+), 86 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index ea811087587e..857eae206daa 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -43,6 +43,20 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
 
 static uint32_t cpu1_prefix;
 
+struct sigp_call_cases {
+	char name[20];
+	int call;
+	uint16_t ext_int_expected_type;
+	uint32_t cr0_bit;
+	bool supports_pv;
+};
+static const struct sigp_call_cases cases_sigp_call[] = {
+	{ "emcall",      SIGP_EMERGENCY_SIGNAL,      0x1201, CTL0_EMERGENCY_SIGNAL, true },
+	{ "cond emcall", SIGP_COND_EMERGENCY_SIGNAL, 0x1201, CTL0_EMERGENCY_SIGNAL, false },
+	{ "ecall",       SIGP_EXTERNAL_CALL,         0x1202, CTL0_EXTERNAL_CALL,    true },
+};
+static const struct sigp_call_cases *current_sigp_call_case;
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -289,105 +303,51 @@ static void test_set_prefix(void)
 
 }
 
-static void ecall(void)
-{
-	unsigned long mask;
-
-	expect_ext_int();
-	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
-	mask = extract_psw_mask();
-	mask |= PSW_MASK_EXT;
-	load_psw_mask(mask);
-	set_flag(1);
-	while (lowcore.ext_int_code != 0x1202) { mb(); }
-	report_pass("received");
-	set_flag(1);
-}
-
-static void test_ecall(void)
-{
-	struct psw psw;
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)ecall;
-
-	report_prefix_push("ecall");
-	set_flag(0);
-
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
-	wait_for_flag();
-	smp_cpu_stop(1);
-	report_prefix_pop();
-}
-
-static void emcall(void)
+static void call_received(void)
 {
 	unsigned long mask;
 
 	expect_ext_int();
-	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
+	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
 	mask = extract_psw_mask();
 	mask |= PSW_MASK_EXT;
+	/* make sure conditional emergency is accepted by disabling IO interrupts */
+	mask &= ~PSW_MASK_IO;
 	load_psw_mask(mask);
 	set_flag(1);
-	while (lowcore.ext_int_code != 0x1201) { mb(); }
+	while (lowcore.ext_int_code != current_sigp_call_case->ext_int_expected_type)
+		mb();
 	report_pass("received");
 	set_flag(1);
 }
 
-static void test_emcall(void)
+static void test_calls(void)
 {
+	int i;
 	struct psw psw;
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)emcall;
-
-	report_prefix_push("emcall");
-	set_flag(0);
-
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	wait_for_flag();
-	smp_cpu_stop(1);
-
-	report_prefix_pop();
-}
-
-static void test_cond_emcall(void)
-{
-	uint32_t status = 0;
-	struct psw psw;
-	int cc;
-	psw.mask = extract_psw_mask() & ~PSW_MASK_IO;
-	psw.addr = (unsigned long)emcall;
-
-	report_prefix_push("conditional emergency call");
 
-	if (uv_os_is_guest()) {
-		report_skip("unsupported under PV");
-		goto out;
+	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
+		current_sigp_call_case = &cases_sigp_call[i];
+
+		report_prefix_push(current_sigp_call_case->name);
+		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
+			report_skip("Not supported under PV");
+			report_prefix_pop();
+			continue;
+		}
+
+		set_flag(0);
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_received;
+
+		smp_cpu_start(1, psw);
+		wait_for_flag();
+		set_flag(0);
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+		wait_for_flag();
+		smp_cpu_stop(1);
+		report_prefix_pop();
 	}
-
-	report_prefix_push("success");
-	set_flag(0);
-
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	cc = smp_sigp(1, SIGP_COND_EMERGENCY_SIGNAL, 0, &status);
-	report(!cc, "CC = 0");
-
-	wait_for_flag();
-	smp_cpu_stop(1);
-
-	report_prefix_pop();
-
-out:
-	report_prefix_pop();
-
 }
 
 static void test_sense_running(void)
@@ -511,9 +471,7 @@ int main(void)
 	test_stop_store_status();
 	test_store_status();
 	test_set_prefix();
-	test_ecall();
-	test_emcall();
-	test_cond_emcall();
+	test_calls();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.35.3

