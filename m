Return-Path: <kvm+bounces-70854-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IJtPCayZjGkhrgAAu9opvQ
	(envelope-from <kvm+bounces-70854-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:01:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 159E71255EE
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 737633014F42
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8AE2C026A;
	Wed, 11 Feb 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HXOc6u8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62745280CD5;
	Wed, 11 Feb 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822014; cv=none; b=jLU93bZRmKSaHrRMLLb2R92CEoDPsD63ktMayCBSPFxoG/hhHLMspnX4HQRRddpIUuqkMJZXCeTEtfF/SH/JxXm5u6cue+Dt0MeKEQY+5Z295q0uH+ZQ5UyLsdl/K4F5kLliyETvZh0cz/+iEI0m9zx709zd6qW/o3KdqkT83uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822014; c=relaxed/simple;
	bh=YcvNaSUlHBkGQne0v8ktVxukyOwK0b0ScwezgaS9BZs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=stU/WZPZ5B5TMnSj73W8QBoroAk7zIc9lgjIvaCrZngR8Uqg9vsxJr5anruCBdns7B60QeUsPaxLlZhVPwARofonS9Xf4bIUYrujHSG4GboNrYvZzJ8bOf1E5P/L9NwZA7QZM1FyZSEfi93rfmNm449eYLVpGhw5E5ttcEbbjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HXOc6u8Q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AMF5Ga225970;
	Wed, 11 Feb 2026 15:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AyrE2w
	M7n70s5a2CVjgJeVZS2Y7v1AEYWcdgbBJVC14=; b=HXOc6u8Q62LAOu6hNlubM3
	7isCRUC2rh8/Ct3BhnklyNFCRT6aJeRjEBXbn+nnHm8+C5ZHHlje+GchwqvYnUK5
	SFI5vRYOgqB9nlwHGuP5Gg5z1T3JmJcpKhsbcYzajT58eTGHt3caU/eCDPBfKZDO
	iFob9DhkgTRspFwhVWkjmW8rWCd/USefw/VN2Y7NRoSG1p8C8YBGxgANhJ7uIg7Z
	gnA28nHk5rcB6pdFaZuA4fCNRgI/iYTWxnV/zhSYas+y7LqA7zYOS5SPQHKd/AZa
	E1IQIz32ZUNbbSEf8CsAdmxm8VQ3NWofD6dJjLq/anP1z77BdLHIhEX7PjVGpKPg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhnvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BDdhhl002557;
	Wed, 11 Feb 2026 15:00:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6fqspdp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 15:00:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BF06tY50725272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 15:00:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FC832004B;
	Wed, 11 Feb 2026 15:00:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A913720040;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
Received: from [192.168.88.251] (unknown [9.111.49.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 15:00:05 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Wed, 11 Feb 2026 15:57:07 +0100
Subject: [kvm-unit-tests PATCH 3/3] s390x: Add test for STFLE interpretive
 execution (format-2)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-vsie-stfle-fac-v1-3-46c7aec5912b@linux.ibm.com>
References: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
In-Reply-To: <20260211-vsie-stfle-fac-v1-0-46c7aec5912b@linux.ibm.com>
To: linux-s390@vger.kernel.org
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6004;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=5yUzwT3iFxTedeamVdiFlTNO10wcG28UZ+ikrcuth5Q=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJk9M0uO3r7ypUnsuqJ+VLEKL4/fef/fzTzxd6SFv8sHz
 5bYXcHRUcrCIMbFICumyFItbp1X1de6dM5By2swc1iZQIYwcHEKwES4NBgZZnTy2Ir84upOnx18
 Y9mvcwmts0/rhV/us6+5d1sie81zI4Z/Ovm8V2YYLKo+2lI+9Wp2Y5PIWanYoz/1Ghj3u5xeeMC
 EFQA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698c997b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=g3eoNvHwOKj1BpS12hIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 99XMuVT115RbfZ0ssvdiLu0bEatS6nAj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDExNCBTYWx0ZWRfX8r0N5QJLTImb
 b+rhet/lZe+blEY6t//3g1RK09zdsBK3bCxS9nTnKA1WPdaDOvR4815Ic8kmtt/vrelTPFRn+Y5
 cQ7Rp6TRbZowQESahL5XWvFrfROwLivLGYcioUkJ+QslZbVzT96w1nXc51Sp10QXgYv54iXjHrZ
 TiFUJvzrgFhUOW2Z0eRjC5Ghxd5eRR8dTfgHG81n2Ty2n5zKProynkvNkXg3sIWa/ZMD+Xv6bxm
 v5B2gInsS7xv1qZpM8pNb/We6QDx9+OCYuKFSDa+8Guls00tKeGQdIoR2+xlzoJGcTku1LpOVrA
 dRQ3Nog+9nvZqk6fVMdmuMM6JoMrJpEic92NoutAO0uimcJXSa2QXEpOXy1AJwswxiQpcmkqIcL
 GmaCllCO610sjn0mOkpu6PJpEBKTQ2kzQM0Tt/jAlJJXBozc2b+I51TmDY0It/zPO8LOm/CysIv
 lgFjTiXPPy0RVMkc3jg==
X-Proofpoint-GUID: 99XMuVT115RbfZ0ssvdiLu0bEatS6nAj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110114
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.5.7.0.0.1.0.0.e.5.1.c.3.0.0.6.2.asn6.rspamd.com:query timed out];
	TAGGED_FROM(0.00)[bounces-70854-lists,kvm=lfdr.de];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_NEQ_ENVFROM(0.00)[schlameuss@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Queue-Id: 159E71255EE
X-Rspamd-Action: no action

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

The STFLE instruction indicates installed facilities.
SIE has facilities for the interpretive execution of STFLE.
There are multiple possible formats for the control block.
Use a snippet guest executing STFLE to get the result of
interpretive execution and check the result.
With the addition of the format-2 control block invalid format
specifiers are now possible.
Test for the occurrence of optional validity intercepts.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Co-developed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 lib/s390x/sie.c   | 11 +++++++
 lib/s390x/sie.h   |  1 +
 s390x/stfle-sie.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 0fa915cf028a1b35a76aa316dfd97308094a4682..17f0ef7eff427002dd6d74d98f58ed493457a7ce 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -42,6 +42,17 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
 	report(vir_exp == vir, "VALIDITY: %x", vir);
 }
 
+void sie_check_optional_validity(struct vm *vm, uint16_t vir_exp)
+{
+	uint16_t vir = sie_get_validity(vm);
+
+	if (vir == 0xffff)
+		report_pass("optional VALIDITY: no");
+	else
+		report(vir_exp == vir, "optional VALIDITY: %x", vir);
+	vm->validity_expected = false;
+}
+
 void sie_handle_validity(struct vm *vm)
 {
 	if (vm->sblk->icptcode != ICPT_VALIDITY)
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 3ec49ed0da6459a70689ce5a1a8a027a4113f2a4..8bea0b10b0a6894096ee83933a8bda11711a1949 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -51,6 +51,7 @@ void sie(struct vm *vm);
 void sie_expect_validity(struct vm *vm);
 uint16_t sie_get_validity(struct vm *vm);
 void sie_check_validity(struct vm *vm, uint16_t vir_exp);
+void sie_check_optional_validity(struct vm *vm, uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
 
 static inline bool sie_is_pv(struct vm *vm)
diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
index 21cf8ff8b6f6e9d61ee304c5748c36f718da65ab..5b642d9e8c3d775e078c1f09b87ad6822cd28a32 100644
--- a/s390x/stfle-sie.c
+++ b/s390x/stfle-sie.c
@@ -42,6 +42,7 @@ static struct guest_stfle_res run_guest(void)
 	uint64_t guest_stfle_addr;
 	uint64_t reg;
 
+	reset_guest(&vm);
 	sie(&vm);
 	assert(snippet_is_force_exit_value(&vm));
 	guest_stfle_addr = snippet_get_force_exit_value(&vm);
@@ -55,18 +56,73 @@ static struct guest_stfle_res run_guest(void)
 static void test_stfle_format_0(void)
 {
 	struct guest_stfle_res res;
+	int format_mask;
 
 	report_prefix_push("format-0");
-	for (int j = 0; j < stfle_size(); j++)
-		WRITE_ONCE((*fac)[j], prng64(&prng_s));
-	vm.sblk->fac = (uint32_t)(uint64_t)fac;
-	res = run_guest();
-	report(res.len == stfle_size(), "stfle len correct");
-	report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
-	       "Guest facility list as specified");
+	/*
+	 * There are multiple valid two bit format control values depending on
+	 * the available facilities.
+	 * The facility introduced last defines the validity of control bits.
+	 */
+	format_mask = sclp_facilities.has_astfleie2 ? 3 : sclp_facilities.has_astfleie1;
+	for (int i = 0; i < 4; i++) {
+		if (i & format_mask)
+			continue;
+		report_prefix_pushf("format control %d", i);
+		for (int j = 0; j < stfle_size(); j++)
+			WRITE_ONCE((*fac)[j], prng64(&prng_s));
+		vm.sblk->fac = (uint32_t)(uint64_t)fac | i;
+		res = run_guest();
+		report(res.len == stfle_size(), "stfle len correct");
+		report(!memcmp(*fac, res.mem, res.len * sizeof(uint64_t)),
+		       "Guest facility list as specified");
+		report_prefix_pop();
+	}
 	report_prefix_pop();
 }
 
+static void test_stfle_format_2(void)
+{
+	const int max_stfle_len = 8;
+	int guest_max_stfle_len = 0;
+	struct guest_stfle_res res;
+	bool saturated = false;
+
+	report_prefix_push("format-2");
+	for (int i = 1; i <= max_stfle_len; i++) {
+		report_prefix_pushf("max STFLE len %d", i);
+
+		WRITE_ONCE((*fac)[0], i - 1);
+		for (int j = 0; j < i; j++)
+			WRITE_ONCE((*fac)[j + 1], prng64(&prng_s));
+		vm.sblk->fac = (uint32_t)(uint64_t)fac | 2;
+		res = run_guest();
+		/* len increases up to maximum (machine specific) */
+		if (res.len < i)
+			saturated = true;
+		if (saturated) {
+			report(res.len == guest_max_stfle_len, "stfle len correct");
+		} else {
+			report(res.len == i, "stfle len correct");
+			guest_max_stfle_len = i;
+		}
+		report(!memcmp(&(*fac)[1], res.mem, guest_max_stfle_len * sizeof(uint64_t)),
+		       "Guest facility list as specified");
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
+static void test_no_stfle_format(int format)
+{
+	reset_guest(&vm);
+	vm.sblk->fac = (uint32_t)(uint64_t)fac | format;
+	sie_expect_validity(&vm);
+	sie(&vm);
+	sie_check_optional_validity(&vm, 0x1330);
+}
+
 struct args {
 	uint64_t seed;
 };
@@ -119,20 +175,33 @@ static struct args parse_args(int argc, char **argv)
 int main(int argc, char **argv)
 {
 	struct args args = parse_args(argc, argv);
-	bool run_format_0 = test_facility(7);
 
 	if (!sclp_facilities.has_sief2) {
 		report_skip("SIEF2 facility unavailable");
 		goto out;
 	}
-	if (!run_format_0)
+	if (!test_facility(7)) {
 		report_skip("STFLE facility not available");
+		goto out;
+	}
 
 	report_info("PRNG seed: 0x%lx", args.seed);
 	prng_s = prng_init(args.seed);
 	setup_guest();
-	if (run_format_0)
-		test_stfle_format_0();
+	test_stfle_format_0();
+
+	if (!sclp_facilities.has_astfleie1)
+		test_no_stfle_format(1);
+
+	if (!sclp_facilities.has_astfleie2) {
+		test_no_stfle_format(2);
+		report_skip("alternate STFLE interpretive-execution facility 2 not available");
+	} else {
+		test_stfle_format_2();
+	}
+
+	test_no_stfle_format(3);
+
 out:
 	return report_summary();
 }

-- 
2.53.0


