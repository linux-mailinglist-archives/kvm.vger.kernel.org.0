Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657B023EC32
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 13:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgHGLQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 07:16:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61440 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbgHGLQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 07:16:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077B1hmD192084;
        Fri, 7 Aug 2020 07:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Fr1iz+RFNb1Dq8EX4XEUqnmzyRFZChcgQDIyojQrvnk=;
 b=GqnxW3eyGkm2HmjrPIguvhgLdjPsZiuj0yzaElk4BfxOVFgso2lLH/PseJnz71GNejp/
 OSYb+ewoyPhIRWyGSnZLofEVFEj2CrmPC2pZQnm5d2oN3v9gZm0YGUj5N8Ad3e0QnsU8
 qco5cd65JAGQQmxwNUUh7d1ZEQ93I5YGGhgN5/Df1Cjr/7qFn9ANRWsgOIbmKfjRFicT
 +Z/PaxH69FIDTjff8cTC8p7+VL+LzEPuFznDtbTh7SzNX9aXG/Liu4me0A/en7D0UM60
 +RnN90SNBnpNuyaCFOHx6UcKS2XUzzExRcoPqxJUoB8QF/NpCT/xnmHK/REO8T4fupyv DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32s0tes245-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 07:16:05 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 077B1oiZ192543;
        Fri, 7 Aug 2020 07:16:05 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32s0tes23b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 07:16:05 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 077AtHL7002795;
        Fri, 7 Aug 2020 11:16:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 32n0186k0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:16:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 077BG0h824248668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Aug 2020 11:16:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 362BAAE05F;
        Fri,  7 Aug 2020 11:16:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72D77AE055;
        Fri,  7 Aug 2020 11:15:59 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Aug 2020 11:15:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new skey test and add test to unittests.cfg
Date:   Fri,  7 Aug 2020 07:15:54 -0400
Message-Id: <20200807111555.11169-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200807111555.11169-1-frankja@linux.ibm.com>
References: <20200807111555.11169-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=1
 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When an exception new psw with a storage key in its mask is loaded
from lowcore, a specification exception is raised. This differs from
the behavior when trying to execute skey related instructions, which
will result in special operation exceptions.

Also let's add the test to unittests.cfg so it is run more often.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skrf.c        | 79 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  4 +++
 2 files changed, 83 insertions(+)

diff --git a/s390x/skrf.c b/s390x/skrf.c
index 9cae589..b19d0f4 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -11,12 +11,16 @@
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
+#include <asm-generic/barrier.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
+#include <asm/sigp.h>
+#include <smp.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
+static int testflag = 0;
 
 static void test_facilities(void)
 {
@@ -106,6 +110,80 @@ static void test_tprot(void)
 	report_prefix_pop();
 }
 
+static void wait_for_flag(void)
+{
+	while (!testflag)
+		mb();
+}
+
+static void set_flag(int val)
+{
+	mb();
+	testflag = val;
+	mb();
+}
+
+static void ecall_cleanup(void)
+{
+	struct lowcore *lc = (void *)0x0;
+
+	lc->ext_new_psw.mask = 0x0000000180000000UL;
+	lc->sw_int_crs[0] = 0x0000000000040000;
+
+	/*
+	 * PGM old contains the ext new PSW, we need to clean it up,
+	 * so we don't get a special operation exception on the lpswe
+	 * of pgm old.
+	 */
+	lc->pgm_old_psw.mask = 0x0000000180000000UL;
+
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	set_flag(1);
+}
+
+/* Set a key into the external new psw mask and open external call masks */
+static void ecall_setup(void)
+{
+	struct lowcore *lc = (void *)0x0;
+	uint64_t mask;
+
+	register_pgm_cleanup_func(ecall_cleanup);
+	expect_pgm_int();
+	/* Put a skey into the ext new psw */
+	lc->ext_new_psw.mask = 0x00F0000180000000UL;
+	/* Open up ext masks */
+	ctl_set_bit(0, 13);
+	mask = extract_psw_mask();
+	mask |= PSW_MASK_EXT;
+	load_psw_mask(mask);
+	/* Tell cpu 0 that we're ready */
+	set_flag(1);
+}
+
+static void test_exception_ext_new(void)
+{
+	struct psw psw = {
+		.mask = extract_psw_mask(),
+		.addr = (unsigned long)ecall_setup
+	};
+
+	report_prefix_push("exception external new");
+	if (smp_query_num_cpus() < 2) {
+		report_skip("Need second cpu for exception external new test.");
+		report_prefix_pop();
+		return;
+	}
+
+	smp_cpu_setup(1, psw);
+	wait_for_flag();
+	set_flag(0);
+
+	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
+	wait_for_flag();
+	smp_cpu_stop(1);
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skrf");
@@ -121,6 +199,7 @@ int main(void)
 	test_mvcos();
 	test_spka();
 	test_tprot();
+	test_exception_ext_new();
 
 done:
 	report_prefix_pop();
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 0f156af..b35269b 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -88,3 +88,7 @@ extra_params = -m 3G
 [css]
 file = css.elf
 extra_params = -device virtio-net-ccw
+
+[skrf]
+file = skrf.elf
+smp = 2
-- 
2.25.1

