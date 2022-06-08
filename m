Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C08D543AC0
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiFHRpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiFHRpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:45:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA9F182BB9;
        Wed,  8 Jun 2022 10:45:45 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258GE0WF010747;
        Wed, 8 Jun 2022 17:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V6J7nn3GJ3JQvZ6U+5OZsRGF/t1SytmjeEHYCxmk7g0=;
 b=UM+8ifmT0hB+drquBUjlb/Nl8qk5cRqlijCZuTCTGgYOcOs21qjMLIoti1LSPkcC0xT1
 4DKFYs2Usxw1V8oHhtAjFOMQJAzsFqi4GF9v2kiVWF8bhm7iCgBou/HXjZvifkbNclhb
 wZI5E9EC0WlUk3ZtwiouBr1cwvQ8yetAwlh+vAN6sGmYJB4P2QJ0f9smgIDLSmqXeCFa
 cOl51Gl21XFaF2tlG98DJwdmps0IbWve8H/eLDJH+FcxZr61xOGgoGY3cUZsbrVKdycA
 2ZYroaa4oQUI/gZT/vUPOVrT4vy4bWxx0Af7Xp9mqhhGis5+kSvLoBYwJQDyWCGKp/Iu 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjy3t1v2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258GviYd016492;
        Wed, 8 Jun 2022 17:45:43 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjy3t1v2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:43 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258HL6RM021599;
        Wed, 8 Jun 2022 17:45:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3gfxnj4k3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258HjcrU44630398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 17:45:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC42711C052;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F0DA11C04C;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 2/3] s390x: Test effect of storage keys on some more instructions
Date:   Wed,  8 Jun 2022 19:45:35 +0200
Message-Id: <20220608174536.1700357-3-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608174536.1700357-1-scgl@linux.ibm.com>
References: <20220608174536.1700357-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UFMIVomsQJlufhFUntadcLLR0_e4gtwB
X-Proofpoint-GUID: 9_Slf2CFUZ3hIZK036S-XlQtVcjNIOsa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206080070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test correctness of some instructions handled by user space instead of
KVM with regards to storage keys.
Test success and error conditions, including coverage of storage and
fetch protection override.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/skey.c        | 275 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   1 +
 2 files changed, 276 insertions(+)

diff --git a/s390x/skey.c b/s390x/skey.c
index d05ebc09..36b81cec 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -12,6 +12,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <vmalloc.h>
+#include <css.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
@@ -304,6 +305,115 @@ static void test_store_cpu_address(void)
 	report_prefix_pop();
 }
 
+/*
+ * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
+ * with access key 1.
+ */
+static unsigned int chsc_key_1(void *comm_block)
+{
+	uint32_t program_mask;
+
+	asm volatile (
+		"spka	0x10\n\t"
+		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
+		"spka	0\n\t"
+		"ipm	%[program_mask]\n"
+		: [program_mask] "=d" (program_mask)
+		: [comm_block] "d" (comm_block)
+		: "memory"
+	);
+	return program_mask >> 28;
+}
+
+static const char chsc_msg[] = "Performed store-channel-subsystem-characteristics";
+static void init_comm_block(uint16_t *comm_block)
+{
+	memset(comm_block, 0, PAGE_SIZE);
+	/* store-channel-subsystem-characteristics command */
+	comm_block[0] = 0x10;
+	comm_block[1] = 0x10;
+	comm_block[9] = 0;
+}
+
+static void test_channel_subsystem_call(void)
+{
+	uint16_t *comm_block = (uint16_t *)&pagebuf;
+	unsigned int cc;
+
+	report_prefix_push("CHANNEL SUBSYSTEM CALL");
+
+	report_prefix_push("zero key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x10, 0);
+	asm volatile (
+		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
+		"ipm	%[cc]\n"
+		: [cc] "=d" (cc)
+		: [comm_block] "d" (comm_block)
+		: "memory"
+	);
+	cc = cc >> 28;
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x10, 0);
+	cc = chsc_key_1(comm_block);
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+
+	report_prefix_push("no fetch protection");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x20, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_push("fetch protection");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x28, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_FETCH_STORE);
+	report_prefix_pop();
+
+	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override, invalid key");
+	set_storage_key(comm_block, 0x20, 0);
+	init_comm_block(comm_block);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_push("storage-protection override, override key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x90, 0);
+	cc = chsc_key_1(comm_block);
+	report(cc == 0 && comm_block[9], chsc_msg);
+	report_prefix_pop();
+
+	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
+
+	report_prefix_push("storage-protection override disabled, override key");
+	init_comm_block(comm_block);
+	set_storage_key(comm_block, 0x90, 0);
+	expect_pgm_int();
+	chsc_key_1(comm_block);
+	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
+	report_prefix_pop();
+
+	report_prefix_pop();
+
+	set_storage_key(comm_block, 0x00, 0);
+	report_prefix_pop();
+}
+
 /*
  * Perform SET PREFIX (SPX) instruction while temporarily executing
  * with access key 1.
@@ -430,6 +540,169 @@ static void test_set_prefix(void)
 	report_prefix_pop();
 }
 
+/*
+ * Perform MODIFY SUBCHANNEL (MSCH) instruction while temporarily executing
+ * with access key 1.
+ */
+static uint32_t modify_subchannel_key_1(uint32_t sid, struct schib *schib)
+{
+	uint32_t program_mask;
+
+	asm volatile (
+		"lr %%r1,%[sid]\n\t"
+		"spka	0x10\n\t"
+		"msch	%[schib]\n\t"
+		"spka	0\n\t"
+		"ipm	%[program_mask]\n"
+		: [program_mask] "=d" (program_mask)
+		: [sid] "d" (sid),
+		  [schib] "Q" (*schib)
+		: "%r1"
+	);
+	return program_mask >> 28;
+}
+
+static void test_msch(void)
+{
+	struct schib *schib = (struct schib *)pagebuf;
+	struct schib *no_override_schib;
+	int test_device_sid;
+	pgd_t *root;
+	int cc;
+
+	report_prefix_push("MSCH");
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+	test_device_sid = css_enumerate();
+
+	if (!(test_device_sid & SCHID_ONE)) {
+		report_fail("no I/O device found");
+		return;
+	}
+
+	cc = stsch(test_device_sid, schib);
+	if (cc) {
+		report_fail("could not store SCHIB");
+		return;
+	}
+
+	report_prefix_push("zero key");
+	schib->pmcw.intparm = 100;
+	set_storage_key(schib, 0x28, 0);
+	cc = msch(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 100, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	report_prefix_push("matching key");
+	schib->pmcw.intparm = 200;
+	set_storage_key(schib, 0x18, 0);
+	cc = modify_subchannel_key_1(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 200, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	report_prefix_push("mismatching key");
+
+	report_prefix_push("no fetch protection");
+	schib->pmcw.intparm = 300;
+	set_storage_key(schib, 0x20, 0);
+	cc = modify_subchannel_key_1(test_device_sid, schib);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 300, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("fetch protection");
+		schib->pmcw.intparm = 400;
+		set_storage_key(schib, 0x28, 0);
+		expect_pgm_int();
+		modify_subchannel_key_1(test_device_sid, schib);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	register_pgm_cleanup_func(dat_fixup_pgm_int);
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("remapped page, fetch protection");
+		schib->pmcw.intparm = 500;
+		set_storage_key(pagebuf, 0x28, 0);
+		expect_pgm_int();
+		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+		modify_subchannel_key_1(test_device_sid, (struct schib *)0);
+		install_page(root, 0, 0);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+
+	report_prefix_push("fetch-protection override applies");
+	schib->pmcw.intparm = 600;
+	set_storage_key(pagebuf, 0x28, 0);
+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+	cc = modify_subchannel_key_1(test_device_sid, (struct schib *)0);
+	install_page(root, 0, 0);
+	if (!cc) {
+		WRITE_ONCE(schib->pmcw.intparm, 0);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 600, "fetched from SCHIB");
+	} else {
+		report_fail("MSCH cc != 0");
+	}
+	report_prefix_pop();
+
+	schib->pmcw.intparm = 0;
+	if (!msch(test_device_sid, schib)) {
+		report_prefix_push("fetch-protection override does not apply");
+		schib->pmcw.intparm = 700;
+		no_override_schib = (struct schib *)(pagebuf + 2048);
+		memcpy(no_override_schib, schib, sizeof(struct schib));
+		set_storage_key(pagebuf, 0x28, 0);
+		expect_pgm_int();
+		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
+		modify_subchannel_key_1(test_device_sid, OPAQUE_PTR(2048));
+		install_page(root, 0, 0);
+		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
+		cc = stsch(test_device_sid, schib);
+		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
+		report_prefix_pop();
+	} else {
+		report_fail("could not reset SCHIB");
+	}
+
+	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
+	register_pgm_cleanup_func(NULL);
+	report_prefix_pop();
+	set_storage_key(schib, 0x00, 0);
+	report_prefix_pop();
+}
+
 int main(void)
 {
 	report_prefix_push("skey");
@@ -444,9 +717,11 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_channel_subsystem_call();
 
 	setup_vm();
 	test_set_prefix();
+	test_msch();
 done:
 	report_prefix_pop();
 	return report_summary();
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index b456b288..1280ff0f 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -41,6 +41,7 @@ file = sthyi.elf
 
 [skey]
 file = skey.elf
+extra_params = -device virtio-net-ccw
 
 [diag10]
 file = diag10.elf
-- 
2.33.1

