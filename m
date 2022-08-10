Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0ED858E807
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiHJHqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiHJHqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:46:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DB967C98
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:46:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A5caoR031120
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=inFqxBSu9cFJ9q3u/x8sLK3QHoPPZCuBdq/jtlu2Ts4=;
 b=kJ0FOkdSkbAglT0bPONxgtCTWdIYY7WpvMr7+3Krbr2je+y2gbdfZ/jua2ppBD9MHtDM
 AP8M9AEJImtdH6LZBi0Vuj9Fd6uD/OBCskkMa+WzxZYS94jQAM4oimb+nrSiYL62hB8+
 mVZyW11CPsNstsS63Nt1FU6+o9tx6eVD0qUZZLtPUR0MCPUGOzK9W0W2B+1n5hrgg/WX
 iaTgU3WVWa02ffjSdJvFoH2FM9eitGuLuTz3hebZHKWxZ7SnlVdjQBZkcXxC5dNTeWWJ
 /Toy6swiNPIsF1Rp4pNAg3YSno/Xtx1RqIXyQGp9vkBfnjttmWb6rgN/es4p8jHIUDwe DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv1fvahqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:24 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A7UlZg028591
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:24 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv1fvahp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:23 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27A7ZDpl028227;
        Wed, 10 Aug 2022 07:46:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3huwvjgdgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27A7kI0f29294926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 07:46:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14AE44C046;
        Wed, 10 Aug 2022 07:46:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E38294C050;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 3/3] s390x: smp: add tests for calls in wait state
Date:   Wed, 10 Aug 2022 09:46:16 +0200
Message-Id: <20220810074616.1223561-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220810074616.1223561-1-nrb@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kFIgykuJXNPaYPPfjdefhcQk03-4TUNW
X-Proofpoint-GUID: rqnA3w_t8SeZ7TdxYv9zatjD7lfzDb1a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_03,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=910
 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100021
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the SIGP interpretation facility is in use a SIGP external call to
a waiting CPU will result in an exit of the calling cpu. For non-pv
guests it's a code 56 (partial execution) exit otherwise its a code 108
(secure instruction notification) exit. Those exits are handled
differently from a normal SIGP instruction intercept that happens
without interpretation and hence need to be tested.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 5a269087581f..91f3e3bcc12a 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -356,6 +356,102 @@ static void test_calls(void)
 	}
 }
 
+static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
+{
+	/* Clear wait bit so we don't immediately wait again after the fixup */
+	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
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
+
+	set_flag(1);
+}
+
+static void call_in_wait_cleanup(void)
+{
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
+		/* Let the secondary CPU setup the external mask and the external interrupt cleanup function */
+		set_flag(0);
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_in_wait_setup;
+		smp_cpu_start(1, psw);
+
+		/* Wait until the receiver has finished setup */
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
+		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
+		psw.addr = (unsigned long)call_in_wait_received;
+		smp_cpu_start(1, psw);
+
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+
+		/* Wait until the receiver has handled the call */
+		wait_for_flag();
+		smp_cpu_stop(1);
+		set_flag(0);
+
+		/*
+		 * Now clean up the mess we have left behind. If the cleanup
+		 * were part of call_in_wait_received we would not get a chance
+		 * to catch an interrupt that is presented twice since we would
+		 * disable the external call on the first interrupt.
+		 */
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_in_wait_cleanup;
+		smp_cpu_start(1, psw);
+
+		/* Wait until the cleanup has been completed */
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
@@ -474,6 +570,7 @@ int main(void)
 	test_store_status();
 	test_set_prefix();
 	test_calls();
+	test_calls_in_wait();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.36.1

