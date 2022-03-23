Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2304F4E5714
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbiCWRFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245621AbiCWRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C71517E3;
        Wed, 23 Mar 2022 10:03:33 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NGjjH7005143;
        Wed, 23 Mar 2022 17:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rSVPzxSAn31oXiC/u5JO1F4QUaTI7Vp2nzEpliVgzP0=;
 b=G0g66N4MX7hfuL6xuVrB2WXK2epxAD5tar2M89nAYXiPY5wOA01n331DAwlXk2UclzMm
 BZuyjAFnPsY/bz3R3dMgBNLdcoi7Or0npA/S+7Y5xK5QAlEVk/N53qXeizuvK0HjrFBH
 rQJy7QHCJIKvk2a5G+paMEaTfSzbiU/uf3SH88nEAbGrsn91gmGOrKtKqjVTcuqmqheF
 UQ3Qb88UhaWqY7MT304TSWfbx6ITsDX8C2ELpEL1JYUS6u2Ki5exfYSbrMjI1REgSoQX
 I/RJImJksU/b5WHchFwT8JuiWOA+6XMFMWq3Qn8u1LsV9UQ2uFIF1BQrjy7qxi12UOax 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f07bwgcpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGk0gZ005756;
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f07bwgcng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxDGi012250;
        Wed, 23 Mar 2022 17:03:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ew6t8qreu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3R2Q23265606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBD34C046;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 079684C050;
        Wed, 23 Mar 2022 17:03:27 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/9] s390x: smp: add test for SIGP_STORE_ADTL_STATUS order
Date:   Wed, 23 Mar 2022 18:03:20 +0100
Message-Id: <20220323170325.220848-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t91tN4k2dOdx1Rh3kFke15ujU58CDZ5l
X-Proofpoint-ORIG-GUID: GDHsBJ_53_6ZooXwuoZTKccU4I44vrgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Add a test for SIGP_STORE_ADDITIONAL_STATUS order.

There are several cases to cover:
- when neither vector nor guarded-storage facility is available, check
  the order is rejected.
- when one of the facilities is there, test the order is rejected and
  adtl_status is not touched when the target CPU is running or when an
  invalid CPU address is specified. Also check the order is rejected
  in case of invalid alignment.
- when the vector facility is there, write some data to the CPU's
  vector registers and check we get the right contents.
- when the guarded-storage facility is there, populate the CPU's
  guarded-storage registers with some data and again check we get the
  right contents.

To make sure we cover all these cases, adjust unittests.cfg to run the
smp tests with both guarded-storage and vector facility off and on.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c         | 341 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  22 ++-
 2 files changed, 362 insertions(+), 1 deletion(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index e5a16eb5a46a..344f508a245d 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -16,6 +16,7 @@
 #include <asm/sigp.h>
 
 #include <smp.h>
+#include <gs.h>
 #include <alloc_page.h>
 
 static int testflag = 0;
@@ -37,6 +38,37 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
 	{ INVALID_ORDER_CODE,         "invalid order code" },
 };
 
+struct mcesa_lc12 {
+	uint8_t vector_reg[0x200];            /* 0x000 */
+	uint8_t reserved200[0x400 - 0x200];   /* 0x200 */
+	struct gs_cb gs_cb;                   /* 0x400 */
+	uint8_t reserved420[0x800 - 0x420];   /* 0x420 */
+	uint8_t reserved800[0x1000 - 0x800];  /* 0x800 */
+};
+
+static struct mcesa_lc12 adtl_status __attribute__((aligned(4096)));
+
+#define NUM_VEC_REGISTERS 32
+#define VEC_REGISTER_SIZE 16
+static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
+
+static struct gs_cb gs_cb;
+static struct gs_epl gs_epl;
+
+static int memisset(void *s, int c, size_t n)
+{
+	uint8_t *p = s;
+	size_t i;
+
+	for (i = 0; i < n; i++) {
+		if (p[i] != c) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -200,6 +232,311 @@ static void test_store_status(void)
 	report_prefix_pop();
 }
 
+static int have_adtl_status(void)
+{
+	return test_facility(133) || test_facility(129);
+}
+
+static void test_store_adtl_status(void)
+{
+	uint32_t status = -1;
+	int cc;
+
+	report_prefix_push("store additional status");
+
+	if (!have_adtl_status()) {
+		report_skip("no guarded-storage or vector facility installed");
+		goto out;
+	}
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	report_prefix_push("running");
+	smp_cpu_restart(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+	report(cc == 3, "CC = 3");
+	report(memisset(&adtl_status, 0xff, sizeof(adtl_status)),
+	       "additional status not touched");
+
+	report_prefix_pop();
+
+	report_prefix_push("unaligned");
+	smp_cpu_stop(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status + 256, &status);
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_PARAMETER, "status = INVALID_PARAMETER");
+
+	report_prefix_pop();
+
+out:
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_unavail(void)
+{
+	uint32_t status = 0;
+	int cc;
+
+	report_prefix_push("store additional status unvailable");
+
+	if (have_adtl_status()) {
+		report_skip("guarded-storage or vector facility installed");
+		goto out;
+	}
+
+	report_prefix_push("not accepted");
+	smp_cpu_stop(1);
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status, &status);
+
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INVALID_ORDER,
+	       "status = INVALID_ORDER");
+
+	report_prefix_pop();
+
+out:
+	report_prefix_pop();
+}
+
+static void restart_write_vector(void)
+{
+	uint8_t *vec_reg;
+	/*
+	 * vlm handles at most 16 registers at a time
+	 */
+	uint8_t *vec_reg_16_31 = &expected_vec_contents[16][0];
+	int i;
+
+	for (i = 0; i < NUM_VEC_REGISTERS; i++) {
+		vec_reg = &expected_vec_contents[i][0];
+		/*
+		 * i+1 to avoid zero content
+		 */
+		memset(vec_reg, i + 1, VEC_REGISTER_SIZE);
+	}
+
+	ctl_set_bit(0, CTL0_VECTOR);
+
+	asm volatile (
+		"	.machine z13\n"
+		"	vlm 0,15, %[vec_reg_0_15]\n"
+		"	vlm 16,31, %[vec_reg_16_31]\n"
+		:
+		: [vec_reg_0_15] "Q"(expected_vec_contents),
+		  [vec_reg_16_31] "Q"(*vec_reg_16_31)
+		: "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9",
+		  "v10", "v11", "v12", "v13", "v14", "v15", "v16", "v17", "v18",
+		  "v19", "v20", "v21", "v22", "v23", "v24", "v25", "v26", "v27",
+		  "v28", "v29", "v30", "v31", "memory"
+	);
+
+	ctl_clear_bit(0, CTL0_VECTOR);
+
+	set_flag(1);
+
+	/*
+	 * function epilogue will restore floating point registers and hence
+	 * destroy vector register contents
+	 */
+	while (1)
+		;
+}
+
+static void cpu_write_magic_to_vector_regs(uint16_t cpu_idx)
+{
+	struct psw new_psw;
+
+	smp_cpu_stop(cpu_idx);
+
+	new_psw.mask = extract_psw_mask();
+	new_psw.addr = (unsigned long)restart_write_vector;
+
+	set_flag(0);
+
+	smp_cpu_start(cpu_idx, new_psw);
+
+	wait_for_flag();
+}
+
+static int adtl_status_check_unmodified_fields_for_lc(unsigned long lc)
+{
+	assert (!lc || (lc >= 10 && lc <= 12));
+
+	if (lc <= 10 && !memisset(&adtl_status.gs_cb, 0xff, sizeof(adtl_status.gs_cb)))
+		return false;
+
+	if (!memisset(adtl_status.reserved200, 0xff, sizeof(adtl_status.reserved200)))
+		return false;
+
+	if (!memisset(adtl_status.reserved420, 0xff, sizeof(adtl_status.reserved420)))
+		return false;
+	
+	if (!memisset(adtl_status.reserved800, 0xff, sizeof(adtl_status.reserved800)))
+		return false;
+
+	return true;
+}
+
+static void __store_adtl_status_vector_lc(unsigned long lc)
+{
+	uint32_t status = -1;
+	struct psw psw;
+	int cc;
+
+	report_prefix_pushf("LC %lu", lc);
+
+	if (!test_facility(133) && lc) {
+		report_skip("not supported, no guarded-storage facility");
+		goto out;
+	}
+
+	cpu_write_magic_to_vector_regs(1);
+	smp_cpu_stop(1);
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status | lc, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(adtl_status.vector_reg,
+		       expected_vec_contents, sizeof(expected_vec_contents)),
+	       "additional status contents match");
+
+	report(adtl_status_check_unmodified_fields_for_lc(lc),
+	       "no write outside expected fields");
+
+	/*
+	 * To avoid the floating point/vector registers being cleaned up, we
+	 * stopped CPU1 right in the middle of a function. Hence the cleanup of
+	 * the function didn't run yet and the stackpointer is messed up.
+	 * Destroy and re-initalize the CPU to fix that.
+	 */
+	smp_cpu_destroy(1);
+	psw.mask = extract_psw_mask();
+	psw.addr = (unsigned long)test_func;
+	smp_cpu_setup(1, psw);
+
+out:
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_vector(void)
+{
+	report_prefix_push("store additional status vector");
+
+	if (!test_facility(129)) {
+		report_skip("vector facility not installed");
+		goto out;
+	}
+
+	__store_adtl_status_vector_lc(0);
+	__store_adtl_status_vector_lc(10);
+	__store_adtl_status_vector_lc(11);
+	__store_adtl_status_vector_lc(12);
+
+out:
+	report_prefix_pop();
+}
+
+static void restart_write_gs_regs(void)
+{
+	const unsigned long gs_area = 0x2000000;
+	const unsigned long gsc = 25; /* align = 32 M, section size = 512K */
+
+	ctl_set_bit(2, CTL2_GUARDED_STORAGE);
+
+	gs_cb.gsd = gs_area | gsc;
+	gs_cb.gssm = 0xfeedc0ffe;
+	gs_cb.gs_epl_a = (uint64_t) &gs_epl;
+
+	load_gs_cb(&gs_cb);
+
+	set_flag(1);
+
+	ctl_clear_bit(2, CTL2_GUARDED_STORAGE);
+
+	/*
+	 * Safe to return here. r14 will point to the endless loop in
+	 * smp_cpu_setup_state.
+	 */
+}
+
+static void cpu_write_to_gs_regs(uint16_t cpu_idx)
+{
+	struct psw new_psw;
+
+	smp_cpu_stop(cpu_idx);
+
+	new_psw.mask = extract_psw_mask();
+	new_psw.addr = (unsigned long)restart_write_gs_regs;
+
+	set_flag(0);
+
+	smp_cpu_start(cpu_idx, new_psw);
+
+	wait_for_flag();
+}
+
+static void __store_adtl_status_gs(unsigned long lc)
+{
+	uint32_t status = 0;
+	int cc;
+
+	report_prefix_pushf("LC %lu", lc);
+
+	cpu_write_to_gs_regs(1);
+	smp_cpu_stop(1);
+
+	memset(&adtl_status, 0xff, sizeof(adtl_status));
+
+	cc = smp_sigp(1, SIGP_STORE_ADDITIONAL_STATUS,
+		  (unsigned long)&adtl_status | lc, &status);
+	report(!cc, "CC = 0");
+
+	report(!memcmp(&adtl_status.gs_cb, &gs_cb, sizeof(gs_cb)),
+	       "additional status contents match");
+
+	report(adtl_status_check_unmodified_fields_for_lc(lc),
+	       "no write outside expected fields");
+
+	report_prefix_pop();
+}
+
+static void test_store_adtl_status_gs(void)
+{
+	report_prefix_push("store additional status guarded-storage");
+
+	if (!test_facility(133)) {
+		report_skip("guarded-storage facility not installed");
+		goto out;
+	}
+
+	__store_adtl_status_gs(11);
+	__store_adtl_status_gs(12);
+
+out:
+	report_prefix_pop();
+}
+
 static void ecall(void)
 {
 	unsigned long mask;
@@ -388,6 +725,10 @@ int main(void)
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
+	test_store_adtl_status_unavail();
+	test_store_adtl_status_vector();
+	test_store_adtl_status_gs();
+	test_store_adtl_status();
 	test_ecall();
 	test_emcall();
 	test_sense_running();
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 1600e714c8b9..843fd323bce9 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -74,9 +74,29 @@ extra_params=-device diag288,id=watchdog0 --watchdog-action inject-nmi
 file = stsi.elf
 extra_params=-name kvm-unit-test --uuid 0fb84a86-727c-11ea-bc55-0242ac130003 -smp 1,maxcpus=8
 
-[smp]
+[smp-kvm]
 file = smp.elf
 smp = 2
+accel = kvm
+extra_params = -cpu host,gs=on,vx=on
+
+[smp-no-vec-no-gs-kvm]
+file = smp.elf
+smp = 2
+accel = kvm
+extra_params = -cpu host,gs=off,vx=off
+
+[smp-tcg]
+file = smp.elf
+smp = 2
+accel = tcg
+extra_params = -cpu qemu,vx=on
+
+[smp-no-vec-no-gs-tcg]
+file = smp.elf
+smp = 2
+accel = tcg
+extra_params = -cpu qemu,gs=off,vx=off
 
 [sclp-1g]
 file = sclp.elf
-- 
2.31.1

