Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C132D57DB0F
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiGVHUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiGVHUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:20:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75B35FAB
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:20:12 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M5mtdm002315
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cSBFyfdib2hJEvGO0BCRevfig+XiziwXIGsdgFird/M=;
 b=I4NSw8nSVP58+FKkbh8jP1XDxLYyktbkXwvp3M/ZKUVGihQfgaOSZnaQNhzzYVttbwzU
 1jlWbR+8QjP6byAY0ACznmnpmmKnR++lXbtvEBnH8qwNs7V18DNf4+MdaH1gShozK9eB
 0OVnvF07jfviwcaIai7DNE837qHvopRlkYdHM4b0KAi1NNe7IbIW8pkwTOaQft4+0Swz
 mM5IOEpoPivY/D3UOzDRfvXI3WiHiwpTOa4rrj73KbXPlqNYgMapWQKM5x22RGWsv/Fm
 ADoZldhCoxOS6+2SOLn1PV7d+fX6F0CDUGLyLQ5o6Ya2kyWUh8b9UKkAihDd/rXWGJWI pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp2ya87n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26M6XKhk006027
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 07:20:11 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfp2ya86m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:11 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26M76ntR013408;
        Fri, 22 Jul 2022 07:20:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj7xu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jul 2022 07:20:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26M7K62n21627382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 07:20:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109FD4C044;
        Fri, 22 Jul 2022 07:20:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFF994C04A;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jul 2022 07:20:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/3] s390x: smp: add tests for calls in wait state
Date:   Fri, 22 Jul 2022 09:20:04 +0200
Message-Id: <20220722072004.800792-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220722072004.800792-1-nrb@linux.ibm.com>
References: <20220722072004.800792-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GVr-5-3JO85ztsNtnFUdwN7t9519cBu_
X-Proofpoint-GUID: IV638KdXxbBh0DZE4h13fJ0iRjzz0BCW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 mlxlogscore=888 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under PV, SIGP ecall requires some special handling by the hypervisor
when the receiving CPU is in enabled wait. Hence, we should have
coverage for the various SIGP call orders when the receiving CPU is in
enabled wait.

The ecall test currently fails under PV due to a KVM bug under
investigation.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 683b0e618a48..eed7aa3564de 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -347,6 +347,80 @@ static void test_calls(void)
 	}
 }
 
+static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
+{
+	/* leave wait after returning */
+	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
+
+	stack->crs[0] &= ~current_sigp_call_case->cr0_bit;
+}
+
+static void call_in_wait_setup(void)
+{
+	expect_ext_int();
+	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
+	register_ext_cleanup_func(call_in_wait_ext_int_fixup);
+
+	set_flag(1);
+}
+
+static void call_in_wait_received(void)
+{
+	report(lowcore.ext_int_code == current_sigp_call_case->ext_int_expected_type, "received");
+	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);
+	register_ext_cleanup_func(NULL);
+
+	set_flag(1);
+}
+
+static void test_calls_in_wait(void)
+{
+	int i;
+	struct psw psw;
+
+	report_prefix_push("psw wait");
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
+		psw.addr = (unsigned long)call_in_wait_setup;
+		smp_cpu_start(1, psw);
+		wait_for_flag();
+		set_flag(0);
+
+		/*
+		 * To avoid races, we need to know that the secondary CPU has entered wait,
+		 * but the architecture provides no way to check whether the secondary CPU
+		 * is in wait.
+		 *
+		 * But since a waiting CPU is considered operating, simply stop the CPU, set
+		 * up the restart new PSW mask in wait, send the restart interrupt and then
+		 * wait until the CPU becomes operating (done by smp_cpu_start).
+		 */
+		smp_cpu_stop(1);
+		expect_ext_int();
+		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
+		psw.addr = (unsigned long)call_in_wait_received;
+		smp_cpu_start(1, psw);
+
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+
+		wait_for_flag();
+		smp_cpu_stop(1);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
 static void test_sense_running(void)
 {
 	report_prefix_push("sense_running");
@@ -465,6 +539,7 @@ int main(void)
 	test_store_status();
 	test_set_prefix();
 	test_calls();
+	test_calls_in_wait();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.36.1

