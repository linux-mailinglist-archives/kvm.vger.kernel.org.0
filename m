Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009693325D2
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCIMvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231304AbhCIMv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:26 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129CXYA9052878
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=4xXjZh5Y+TbFcBX53gdf+y4NWeqa08C3loloU/0ug1E=;
 b=dElmG0BuqGtuOGjYkICzNgUnE59P6Q6uWIe6J8tOf0819R5gqEQsr8ZDPybvkjxdQQAn
 itMVs44pVEEoMW75ENdwMRb2LfVeJU5nly1VRj5LKzYHOF7eDvBKAb2sosPY30fsL3va
 kSZ6Qttdppp2Hq+6Hz8x1wxCsDIZngtYYz03777CiXfhi+8w1QNB2xz3TKBFN1DnZP7y
 u/Z/eAbVrGU71VsN2a2eyngjw6lIaOBTLcMQGi51QLBH+Rvtuv/KVNaEagCXeAcyvj5E
 j9SsOMWHXKLoNOZSSnRtQf9Wad7ua0AfUdN3wwAVWiN7ANPCuyRApOcicmcTPamGmn0R qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3762wr3fgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:25 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CY1r9053956
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:25 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3762wr3ffk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:25 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CTMbH014293;
        Tue, 9 Mar 2021 12:51:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3768va00h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpKu429950406
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3203B52052;
        Tue,  9 Mar 2021 12:51:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E11A55204E;
        Tue,  9 Mar 2021 12:51:19 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 4/6] s390x: css: implementing Set CHannel Monitor
Date:   Tue,  9 Mar 2021 13:51:15 +0100
Message-Id: <1615294277-7332-5-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement the call of the Set CHannel Monitor instruction,
starting the monitoring of the all Channel Sub System, and
initializing channel subsystem monitoring.

Initial tests report the presence of the extended measurement block
feature, and verify the error reporting of the hypervisor for SCHM.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h     | 16 ++++++++++++++--
 lib/s390x/css_lib.c |  4 ++--
 s390x/css.c         | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 3c50fa8..7158423 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -309,6 +309,7 @@ struct chsc_scsc {
 	uint8_t reserved[9];
 	struct chsc_header res;
 	uint32_t res_fmt;
+#define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
 	uint64_t general_char[255];
 	uint64_t chsc_char[254];
 };
@@ -356,8 +357,19 @@ static inline int _chsc(void *p)
 bool chsc(void *p, uint16_t code, uint16_t len);
 
 #include <bitops.h>
-#define css_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
-#define css_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
+#define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
+#define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
+
+#define SCHM_DCTM	1 /* activate Device Connection TiMe */
+#define SCHM_MBU	2 /* activate Measurement Block Update */
+
+static inline void schm(void *mbo, unsigned int flags)
+{
+	register void *__gpr2 asm("2") = mbo;
+	register long __gpr1 asm("1") = flags;
+
+	asm("schm" : : "d" (__gpr2), "d" (__gpr1));
+}
 
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
 bool css_disable_mb(int schid);
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 77b39c7..95d9a78 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -94,7 +94,7 @@ bool get_chsc_scsc(void)
 		return false;
 
 	for (i = 0, p = buffer; i < CSS_GENERAL_FEAT_BITLEN; i++) {
-		if (css_general_feature(i)) {
+		if (css_test_general_feature(i)) {
 			n = snprintf(p, sizeof(buffer), "%d,", i);
 			p += n;
 		}
@@ -102,7 +102,7 @@ bool get_chsc_scsc(void)
 	report_info("General features: %s", buffer);
 
 	for (i = 0, p = buffer; i < CSS_CHSC_FEAT_BITLEN; i++) {
-		if (css_chsc_feature(i)) {
+		if (css_test_chsc_feature(i)) {
 			n = snprintf(p, sizeof(buffer), "%d,", i);
 			p += n;
 		}
diff --git a/s390x/css.c b/s390x/css.c
index 069c2be..a763814 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -149,6 +149,40 @@ static void css_init(void)
 	report(get_chsc_scsc(), "Store Channel Characteristics");
 }
 
+static void test_schm(void)
+{
+	if (css_test_general_feature(CSSC_EXTENDED_MEASUREMENT_BLOCK))
+		report_info("Extended measurement block available");
+
+	/* bits 59-63 of MB address must be 0  if MBU is defined */
+	report_prefix_push("Unaligned operand");
+	expect_pgm_int();
+	schm((void *)0x01, SCHM_MBU);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	/* bits 36-61 of register 1 (flags) must be 0 */
+	report_prefix_push("Bad flags");
+	expect_pgm_int();
+	schm(NULL, 0xfffffffc);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+	report_prefix_pop();
+
+	/* SCHM is a privilege operation */
+	report_prefix_push("Privilege");
+	enter_pstate();
+	expect_pgm_int();
+	schm(NULL, SCHM_MBU);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
+	report_prefix_pop();
+
+	/* Normal operation */
+	report_prefix_push("Normal operation");
+	schm(NULL, SCHM_MBU);
+	report(1, "SCHM call without address");
+	report_prefix_pop();
+}
+
 static struct {
 	const char *name;
 	void (*func)(void);
@@ -158,6 +192,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

