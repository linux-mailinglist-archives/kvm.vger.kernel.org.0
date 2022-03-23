Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB684E5717
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbiCWRFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbiCWRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014926C1F6;
        Wed, 23 Mar 2022 10:03:33 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NFseUh021560;
        Wed, 23 Mar 2022 17:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ku5mum89MeiOG+2S3KhMEcq374+2hP9TAvSqWhYse5A=;
 b=WM39C5UVGOJM5oTmDRPZIZtYoUXkwZFHWm4rGEFyvmnygnK3T9SvV2LQPoWEddaSQIWN
 44tt9W9ghJMZD25KkMSKdd0Bw3bgNPaiMCL6bZE4ah+RxD1hfX6rdT3ZzDACWubwrMtV
 m7KuOwAoBvYmKGBDKZ0gRkcVnml1zbOOpnC+jigcFIRxOnPJXxtd/SkMQOeTD3gYg2pr
 WEuwIBkJBjhTCkySBSHVV8nBY1KyjgxhSQFgoiMjX7wrJqD9zoP0//VgOb+HLoZ/39Xe
 6Rg+MMIxn/jvSru+aU3uX4UzWEF2BYmwQFtqtDLWRO2Yus07Ln+VNjNlmS+h2XuBGCFd ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f06kyhfha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGt1bY026154;
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f06kyhfgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NH0H73032019;
        Wed, 23 Mar 2022 17:03:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ew6t9fry8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3RaS22544740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 941F04C044;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 554DA4C05A;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/9] s390x: smp: add tests for SET_PREFIX
Date:   Wed, 23 Mar 2022 18:03:21 +0100
Message-Id: <20220323170325.220848-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O3WJCALswOsgxRz6vc1hoAhNWEdGNBWA
X-Proofpoint-ORIG-GUID: wVKRvs1VjS1w3OpqKwDSvpZ-GahxUPL6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

We cover the following cases:

- running CPU
- illegal CPU id

The order should be rejected in both cases.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 344f508a245d..36014e809f2e 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -55,6 +55,8 @@ static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
 static struct gs_cb gs_cb;
 static struct gs_epl gs_epl;
 
+static uint32_t cpu1_prefix;
+
 static int memisset(void *s, int c, size_t n)
 {
 	uint8_t *p = s;
@@ -537,6 +539,76 @@ out:
 	report_prefix_pop();
 }
 
+static void loop(void)
+{
+	while (1)
+		;
+}
+
+static void stpx_and_set_flag(void)
+{
+	asm volatile (
+		"	stpx %[prefix]\n"
+		: [prefix] "=Q" (cpu1_prefix)
+		:
+		:
+	);
+
+	set_flag(1);
+}
+
+static void test_set_prefix(void)
+{
+	struct lowcore *new_lc = alloc_pages_flags(1, AREA_DMA31);
+	struct cpu *cpu1 = smp_cpu_from_idx(1);
+	uint32_t status = 0;
+	struct psw new_psw;
+	int cc;
+
+	report_prefix_push("set prefix");
+
+	assert(new_lc);
+
+	memcpy(new_lc, cpu1->lowcore, sizeof(struct lowcore));
+	new_lc->restart_new_psw.addr = (unsigned long)loop;
+
+	report_prefix_push("running");
+	set_flag(0);
+	new_psw.addr = (unsigned long)stpx_and_set_flag;
+	new_psw.mask = extract_psw_mask();
+	smp_cpu_start(1, new_psw);
+	wait_for_flag();
+	cpu1_prefix = 0xFFFFFFFF;
+
+	cc = smp_sigp(1, SIGP_SET_PREFIX, (unsigned long)new_lc, &status);
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
+
+	/*
+	 * If the prefix of the other CPU was changed it will enter an endless
+	 * loop. Otherwise, it should eventually set the flag.
+	 */
+	smp_cpu_stop(1);
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+	report(cpu1_prefix == (uint64_t)cpu1->lowcore, "prefix unchanged");
+
+	report_prefix_pop();
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_SET_PREFIX, (unsigned long)new_lc, &status);
+	report(cc == 3, "CC = 3");
+
+	report_prefix_pop();
+
+	free_pages(new_lc);
+
+	report_prefix_pop();
+
+}
+
 static void ecall(void)
 {
 	unsigned long mask;
@@ -729,6 +801,7 @@ int main(void)
 	test_store_adtl_status_vector();
 	test_store_adtl_status_gs();
 	test_store_adtl_status();
+	test_set_prefix();
 	test_ecall();
 	test_emcall();
 	test_sense_running();
-- 
2.31.1

