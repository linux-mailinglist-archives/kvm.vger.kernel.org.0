Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3882B68F0
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgKQPnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:43:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58989 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbgKQPnE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:43:04 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFYEQq182098;
        Tue, 17 Nov 2020 10:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bw9aTWt7WWNGFlV07UZdE/bPdQWZfmRGF3bQB9XqK7U=;
 b=iP54e2jqfWH9m83edkrYSKSa77Stoml0LERhUFv92me8Ne8EwQeQKTVomtqzQLcOU/1L
 B/Mmmmd8hPaqICZ1CY4szGGJS0drr4EFGZcr6TfeO9gCll9Iy74jH/mQYUBXLKGud69H
 Y0eYaIU0VpCSvMgYCVf5B6Jq+i2Npp8HSvYcOkaQvg8QTmWn+kqyECfQR/Kh58zLgDQt
 eZ/CHK9YBW+DENppFcQDPjJdbWVHGddS7xTXHTOJVCcoqHQBKgPZb4tszGy77MVub60u
 749SXR8VfDt3/0Nf8adWb4pT7ruf/xc86VeA2k8DePcjR1KpLmly02cBzZkv0vRErBRF wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vdn5pkga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:02 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHFZLxN187128;
        Tue, 17 Nov 2020 10:43:02 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vdn5pkfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:02 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFgdRd005692;
        Tue, 17 Nov 2020 15:42:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8b2h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:42:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFguvD8323806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:42:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D67E24C04A;
        Tue, 17 Nov 2020 15:42:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F91F4C040;
        Tue, 17 Nov 2020 15:42:56 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:42:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/5] s390x: sie: Add first SIE test
Date:   Tue, 17 Nov 2020 10:42:15 -0500
Message-Id: <20201117154215.45855-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117154215.45855-1-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=974 mlxscore=0
 suspectscore=1 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get the correct interception data on a few
diags. This commit is more of an addition of boilerplate code than a
real test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile |   1 +
 s390x/sie.c    | 125 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)
 create mode 100644 s390x/sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index b079a26..7a95092 100644
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
index 0000000..41b429a
--- /dev/null
+++ b/s390x/sie.c
@@ -0,0 +1,125 @@
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
+		if (vm->sblk->icptcode == 32)
+		    handle_validity(vm);
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
+static void intercept_diag_10(void)
+{
+	u32 instr = 0x83020010;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x100000,
+	       "Diag 10 intercept");
+	sblk_cleanup(&vm);
+}
+
+static void intercept_diag_44(void)
+{
+	u32 instr = 0x83020044;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x440000,
+	       "Diag 44 intercept");
+	sblk_cleanup(&vm);
+}
+
+static void intercept_diag_9c(void)
+{
+	u32 instr = 0x8302009c;
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+
+	memset(guest_instr, 0, PAGE_SIZE);
+	memcpy(guest_instr, &instr, 4);
+	sie(&vm);
+	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x9c0000,
+	       "Diag 9c intercept");
+	sblk_cleanup(&vm);
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
+	intercept_diag_10();
+	intercept_diag_44();
+	intercept_diag_9c();
+done:
+	report_prefix_pop();
+	return report_summary();
+}
-- 
2.25.1

