Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50AE373681
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhEEIoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57944 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232140AbhEEIod (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458Xhg0038143;
        Wed, 5 May 2021 04:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=pOs1vB8u+sF/OIKZ1zak5HrbiA7czhkU7kRAYd0vPzE=;
 b=n5E3qqlaJcGq7puQ7IRnWyPzNSvjYz9tfWiJWxkV6G1GE+W6RMOYjfAaB6M7MVunyPPG
 f17tnmeD38Blhr/ErN8dS2qaZRewTutAaWoMUbasfiKTUE7UvO00oRBuwuAENHrwSPdA
 C2EUn+AH1yeUZ4UYnkjX6cJrn4HvaY+hPGj06/9ufZmXcE74NViq5G0AYB0AtNWEiL6Q
 0KHl91Z7uMogdO0NJp13ZQStdw1SurA+Ocmv2E6EpYAye/F3JklWEWhEbHH9Vg17qnjP
 ty1S+jswzJEV2+F0+7II1S0L68tBXpDT/sYptsYTOmdw3WJYHbHJLRhvU34ibhr86JcC CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bqgvrxs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458XsRc039064;
        Wed, 5 May 2021 04:43:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bqgvrxr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458gHlE021422;
        Wed, 5 May 2021 08:43:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38bedxr6b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hUe729753670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C480DA4054;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A60CA4066;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 5/9] s390x: css: implementing Set CHannel Monitor
Date:   Wed,  5 May 2021 10:42:57 +0200
Message-Id: <20210505084301.17395-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tGLCdwTv9IBeBhwp931-7zO76YCG-syc
X-Proofpoint-GUID: dYzKinawcms96skIybBTF73J42Oz3DQc
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_03:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 phishscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We implement the call of the Set CHannel Monitor instruction,
starting the monitoring of the all Channel Sub System, and
initializing channel subsystem monitoring.

Initial tests report the presence of the extended measurement block
feature, and verify the error reporting of the hypervisor for SCHM.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/kvm/1615545714-13747-5-git-send-email-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h | 12 ++++++++++++
 s390x/css.c     | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 7dddb422..7158423c 100644
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
@@ -359,6 +360,17 @@ bool chsc(void *p, uint16_t code, uint16_t len);
 #define css_test_general_feature(bit) test_bit_inv(bit, chsc_scsc->general_char)
 #define css_test_chsc_feature(bit) test_bit_inv(bit, chsc_scsc->chsc_char)
 
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
+
 bool css_enable_mb(int sid, uint64_t mb, uint16_t mbi, uint16_t flg, bool fmt1);
 bool css_disable_mb(int schid);
 
diff --git a/s390x/css.c b/s390x/css.c
index a4778338..af68266d 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -141,6 +141,40 @@ static void css_init(void)
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
@@ -150,6 +184,7 @@ static struct {
 	{ "enumerate (stsch)", test_enumerate },
 	{ "enable (msch)", test_enable },
 	{ "sense (ssch/tsch)", test_sense },
+	{ "measurement block (schm)", test_schm },
 	{ NULL, NULL }
 };
 
-- 
2.30.2

