Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B268D3BD491
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbhGFMOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240170AbhGFMAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:00:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166BXaqb179617;
        Tue, 6 Jul 2021 07:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6lq4GJNvjxZ8+Jnj0K7paOZ2acPaluSF4QbsiTTGcAQ=;
 b=TsW+/+dOkoLscASzNbg3cfHMwW14lhx5S42ZTdi7VIXdxae/Ze/r65VqNkPqdditIeWd
 YPv7e1XEyozeOiiGnjw3uB0drRFY9089nqBxVbvUSHDIiBXfQdp9Y/nxAO+GP4ZOb5f4
 btlvMfRfKF4sVMI4zgS35unaFygyp3dcDk55zzbiQVnnLu8KWiGRkJpm1qrqx155RxnH
 Cl9yYMkYASJSjykIVSnRARJ53kss2tuMtx3mJ2rOnZ0/HVdf+OeyvyfDmhaPm5dLHCno
 cdjrEwm+dLUmU7dDA/zMP02uuWAZVBA/FzVI+uh0MhF6A62mZH6CeBGU7W3ID5Y153kb cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn89tse5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:57:46 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166BaIUG191130;
        Tue, 6 Jul 2021 07:57:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn89tsda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:57:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166BqFIH026609;
        Tue, 6 Jul 2021 11:57:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8s7v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 11:57:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166BtpFd28115272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 11:55:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F1E44C062;
        Tue,  6 Jul 2021 11:57:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC91B4C066;
        Tue,  6 Jul 2021 11:57:39 +0000 (GMT)
Received: from t46lp72.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 11:57:39 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH] s390x: Add specification exception interception test
Date:   Tue,  6 Jul 2021 13:57:24 +0200
Message-Id: <20210706115724.372901-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xCHUY25Pt0u7OlIy_sRNbG_Jgjaop1iQ
X-Proofpoint-GUID: Yh4zOUVcESk2D69c7wl2QgJSOY9qEcmJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that specification exceptions cause intercepts when
specification exception interpretation is off.
Check that specification exceptions caused by program new PSWs
cause interceptions.
We cannot assert that non program new PSW specification exceptions
are interpreted because whether interpretation occurs or not is
configuration dependent.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
The patch is based on the following patch sets by Janosch:
[kvm-unit-tests PATCH 0/5] s390x: sie and uv cleanups
[kvm-unit-tests PATCH v2 0/3] s390x: Add snippet support

 s390x/Makefile             |  2 +
 lib/s390x/sie.h            |  1 +
 s390x/snippets/c/spec_ex.c | 13 ++++++
 s390x/spec_ex-sie.c        | 91 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg        |  3 ++
 5 files changed, 110 insertions(+)
 create mode 100644 s390x/snippets/c/spec_ex.c
 create mode 100644 s390x/spec_ex-sie.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 07af26d..b1b6536 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
 tests += $(TEST_DIR)/uv-host.elf
 tests += $(TEST_DIR)/edat.elf
 tests += $(TEST_DIR)/mvpg-sie.elf
+tests += $(TEST_DIR)/spec_ex-sie.elf
 
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 ifneq ($(HOST_KEY_DOCUMENT),)
@@ -84,6 +85,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 # perquisites (=guests) for the snippet hosts.
 # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
 $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
+$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
 
 $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
 	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 6ba858a..a3b8623 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
 	uint8_t		fpf;			/* 0x0060 */
 #define ECB_GS		0x40
 #define ECB_TE		0x10
+#define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
 	uint8_t		ecb;			/* 0x0061 */
diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
new file mode 100644
index 0000000..f2daab5
--- /dev/null
+++ b/s390x/snippets/c/spec_ex.c
@@ -0,0 +1,13 @@
+#include <stdint.h>
+#include <asm/arch_def.h>
+
+__attribute__((section(".text"))) int main(void)
+{
+	uint64_t bad_psw = 0;
+	struct psw *pgm_new = (struct psw *)464;
+
+	pgm_new->mask = 1UL << (63 - 12); //invalid program new PSW
+	pgm_new->addr = 0xdeadbeef;
+	asm volatile ("lpsw %0" :: "Q"(bad_psw));
+	return 0;
+}
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
new file mode 100644
index 0000000..7aa2f49
--- /dev/null
+++ b/s390x/spec_ex-sie.c
@@ -0,0 +1,91 @@
+#include <libcflat.h>
+#include <sclp.h>
+#include <asm/page.h>
+#include <asm/arch_def.h>
+#include <alloc_page.h>
+#include <vm.h>
+#include <sie.h>
+
+static struct vm vm;
+extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
+extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
+
+static void setup_guest(void)
+{
+	char *guest;
+	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
+			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
+
+	setup_vm();
+
+	/* Allocate 1MB as guest memory */
+	guest = alloc_pages(8);
+	/* The first two pages are the lowcore */
+
+	vm.sblk = alloc_page();
+
+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
+	vm.sblk->prefix = 0;
+	/*
+	 * Pageable guest with the same ASCE as the test program, but
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
+
+	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
+}
+
+static void reset_guest(void)
+{
+	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
+}
+
+static void test_spec_ex_sie(void)
+{
+	setup_guest();
+
+	report_prefix_push("spec ex interpretation off");
+	reset_guest();
+	sie64a(vm.sblk, &vm.save_area);
+	//interpretation off -> initial exception must cause interception
+	report(vm.sblk->icptcode == ICPT_PROGI
+	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
+	       && vm.sblk->gpsw.addr != 0xdeadbeef,
+	       "Received specification exception intercept for non program new PSW");
+	report_prefix_pop();
+
+	report_prefix_push("spec ex interpretation on");
+	vm.sblk->ecb |= ECB_SPECI;
+	reset_guest();
+	sie64a(vm.sblk, &vm.save_area);
+	// interpretation on -> configuration dependent if initial exception causes
+	// interception, but invalid new program PSW must
+	report(vm.sblk->icptcode == ICPT_PROGI
+	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
+	       "Received specification exception intercept");
+	if (vm.sblk->gpsw.addr == 0xdeadbeef)
+		report_info("Interpreted non program new PSW specification exception");
+	else
+		report_info("Did not interpret non program new PSW specification exception");
+	report_prefix_pop();
+}
+
+int main(int argc, char **argv)
+{
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		goto out;
+	}
+
+	test_spec_ex_sie();
+out:
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 9e1802f..3b454b7 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -109,3 +109,6 @@ file = edat.elf
 
 [mvpg-sie]
 file = mvpg-sie.elf
+
+[spec_ex-sie]
+file = spec_ex-sie.elf

base-commit: bc6f264386b4cb2cadc8b2492315f3e6e8a801a2
prerequisite-patch-id: 17697772b67d510e0e60108671c0dc2815973dca
prerequisite-patch-id: 5501a7902745c87349c05ebd88b709c7ac82557e
prerequisite-patch-id: 8377cf56402b62f5684b8c4113237b31e3373523
prerequisite-patch-id: cb9fd55b0ee96866d685616af914cfa752ea0cd3
prerequisite-patch-id: aed25b2421e37aba8786f65ef0ef10ac192d3098
prerequisite-patch-id: c50347e3942c594532d639fa4071c39b8e5e5415
prerequisite-patch-id: 116a357c74b3973d972ec206f066add611ce55ce
prerequisite-patch-id: c4f9f65f5fd25ca35cc04f16a21ef3653d59fc8f
-- 
2.31.1

