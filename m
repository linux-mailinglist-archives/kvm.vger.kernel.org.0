Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CA92D7345
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 11:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404931AbgLKKC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 05:02:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2356 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404847AbgLKKCY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Dec 2020 05:02:24 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9kfNZ043665;
        Fri, 11 Dec 2020 05:01:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=s7Imm5sNDcUKQ/AX6S6zRmy5GEphpeWc/sI0CWGC80Y=;
 b=A1hh05DWk3bqaK6yCcUbA7Lsa0+nW04NTqYcVtm/TnYWFmcyoP25f0cIXhBR6NRPCD4u
 rLPjhlp2JBizuFgolfkkvjCwzxFqHYv9ZPNk3idtNa586dF6qf5HZvF3C/zVSsQCqJk8
 xoNAntD+BtasL79zfb/08pLWJ7O8VqUE7dwgosrViWWQuoBBkzTsi3F8EJFWcqoBft64
 hPmRcGgEqgyGSDh3Mp93OHzoUKHcRkcIRY4p0XeT17Xv6hvV/hrk/mmS/ZZdjeXG26ss
 EtkxJ6zmtKwZ4hKTcSSyGAhUyVnWu06AX3CNfmo0TKmYhidFjtNLZJJ2yv1HacGqxqyL zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6efr9qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:42 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BB9m3LE045795;
        Fri, 11 Dec 2020 05:01:40 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35c6efr9np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 05:01:40 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BB9rWJX026138;
        Fri, 11 Dec 2020 10:01:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3581fhkjap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Dec 2020 10:01:37 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BBA1YIM61538682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 10:01:34 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F83FA4051;
        Fri, 11 Dec 2020 10:01:34 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADD35A4053;
        Fri, 11 Dec 2020 10:01:33 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Dec 2020 10:01:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 6/8] s390x: sie: Add first SIE test
Date:   Fri, 11 Dec 2020 05:00:37 -0500
Message-Id: <20201211100039.63597-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211100039.63597-1-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_01:2020-12-09,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=1 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get the correct interception data on a few
diags. This commit is more of an addition of boilerplate code than a
real test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile      |   1 +
 s390x/sie.c         | 113 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 ++
 3 files changed, 117 insertions(+)
 create mode 100644 s390x/sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index fb62e87..8e1b4e9 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -19,6 +19,7 @@ tests += $(TEST_DIR)/smp.elf
 tests += $(TEST_DIR)/sclp.elf
 tests += $(TEST_DIR)/css.elf
 tests += $(TEST_DIR)/uv-guest.elf
+tests += $(TEST_DIR)/sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
diff --git a/s390x/sie.c b/s390x/sie.c
new file mode 100644
index 0000000..cfc746f
--- /dev/null
+++ b/s390x/sie.c
@@ -0,0 +1,113 @@
+#include <libcflat.h>
+#include <asm/asm-offsets.h>
+#include <asm/arch_def.h>
+#include <asm/interrupt.h>
+#include <asm/page.h>
+#include <alloc_page.h>
+#include <vmalloc.h>
+#include <asm/facility.h>
+#include <mmu.h>
+#include <sclp.h>
+#include <sie.h>
+
+static u8 *guest;
+static u8 *guest_instr;
+static struct vm vm;
+
+static void handle_validity(struct vm *vm)
+{
+	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
+}
+
+static void sie(struct vm *vm)
+{
+	while (vm->sblk->icptcode == 0) {
+		sie64a(vm->sblk, &vm->save_area);
+		if (vm->sblk->icptcode == ICPT_VALIDITY)
+			handle_validity(vm);
+	}
+	vm->save_area.guest.grs[14] = vm->sblk->gg14;
+	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+}
+
+static void sblk_cleanup(struct vm *vm)
+{
+	vm->sblk->icptcode = 0;
+}
+
+static void test_diag(u32 instr)
+{
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == ICPT_INST &&
+	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr << 16,
+	       "Intercept data");
+	sblk_cleanup(&vm);
+}
+
+static struct {
+	const char *name;
+	u32 instr;
+} tests[] = {
+	{ "10", 0x83020010 },
+	{ "44", 0x83020044 },
+	{ "9c", 0x8302009c },
+	{ NULL, 0 }
+};
+
+static void test_diags(void)
+{
+	int i;
+
+	for (i = 0; tests[i].name; i++) {
+		report_prefix_push(tests[i].name);
+		test_diag(tests[i].instr);
+		report_prefix_pop();
+	}
+}
+
+static void setup_guest(void)
+{
+	setup_vm();
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	/* The first two pages are the lowcore */
+	guest_instr = guest + PAGE_SIZE * 2;
+
+	vm.sblk = alloc_page();
+
+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm.sblk->prefix = 0;
+	/*
+	 * Pageable guest with the same ASCE as the test programm, but
+	 * the guest memory 0x0 is offset to start at the allocated
+	 * guest pages and end after 1MB.
+	 *
+	 * It's not pretty but faster and easier than managing guest ASCEs.
+	 */
+	vm.sblk->mso = (u64)guest;
+	vm.sblk->msl = (u64)guest;
+	vm.sblk->ihcpu = 0xffff;
+
+	vm.sblk->crycbd = (uint64_t)alloc_page();
+}
+
+int main(void)
+{
+	report_prefix_push("sie");
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto done;
+	}
+
+	setup_guest();
+	test_diags();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 3feb8bc..2298be6 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -96,3 +96,6 @@ smp = 2
 
 [uv-guest]
 file = uv-guest.elf
+
+[sie]
+file = sie.elf
-- 
2.25.1

