Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214DE258B49
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 11:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIAJSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 05:18:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgIAJSp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 05:18:45 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08190cxj146453;
        Tue, 1 Sep 2020 05:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CACXlH9PbEottqGjtJoeuI5teZxhJyksGGYPfoIvGEg=;
 b=V3YOOPhUhWFbPKwA6PE6u8GxfoLZX3fYuVNnV28u3LGccKlHuXFGCThKKsAfIkONpFam
 3aVnm7Etsxwi4O6PvgMZCovQ7+yXRT4TZE2nKw7r288KF07SAj7glbEr5NsMvsMMTZRP
 UZ/lHJjhAoB2ZWj+P6eQ6vKb2b2RBYx1bT06DD2TU7rwrKn17ApWcsy2ZR/0pPQfYI/g
 /c2h4s9jJQDDXM765HInbzJdtJERdQ5KfqwmGPOg++FHsjdLVEKFUawD2FqBqqYw/BnG
 FoDW0o5Tro3MVM54JMHdFMlngccH6GxMX7iF8JTZJQ6U80+MKz7k/7XDbRNAJAmod/II nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339jmgswet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:43 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08192LID160919;
        Tue, 1 Sep 2020 05:18:43 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 339jmgswdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0819DaoX015828;
        Tue, 1 Sep 2020 09:18:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 337e9gu86v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 09:18:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0819IcQQ57278836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 09:18:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D8344C046;
        Tue,  1 Sep 2020 09:18:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C0AF4C04A;
        Tue,  1 Sep 2020 09:18:38 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.37.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Sep 2020 09:18:38 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 2/3] s390x: skrf: Add exception new skey test and add test to unittests.cfg
Date:   Tue,  1 Sep 2020 11:18:22 +0200
Message-Id: <20200901091823.14477-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200901091823.14477-1-frankja@linux.ibm.com>
References: <20200901091823.14477-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_04:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 clxscore=1011 impostorscore=0 bulkscore=0 malwarescore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010075
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20200807111555.11169-3-frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.25.4

