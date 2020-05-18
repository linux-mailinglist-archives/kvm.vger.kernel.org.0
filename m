Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F491D7DDF
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgERQHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:07:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727035AbgERQHn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 12:07:43 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IG2NQX113867;
        Mon, 18 May 2020 12:07:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312btuauef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:41 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IG2Nq1113874;
        Mon, 18 May 2020 12:07:39 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312btuaucx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 12:07:39 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IG5dBf016148;
        Mon, 18 May 2020 16:07:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3127t5mf92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 16:07:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IG6MAt62980446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:06:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 354EE11C05C;
        Mon, 18 May 2020 16:07:34 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D77E111C052;
        Mon, 18 May 2020 16:07:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 18 May 2020 16:07:33 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v7 03/12] s390x: Move control register bit definitions and add AFP to them
Date:   Mon, 18 May 2020 18:07:22 +0200
Message-Id: <1589818051-20549-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 clxscore=1015 cotscore=-2147483648
 lowpriorityscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While adding the definition for the AFP-Register control bit, move all
existing definitions for CR0 out of the C zone to the assmbler zone to
keep the definitions concerning CR0 together.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/asm/arch_def.h | 11 ++++++-----
 s390x/cstart64.S         |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 820af93..54ffd0b 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -19,17 +19,18 @@
 
 #define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
 
+#define CR0_EXTM_SCLP			0X0000000000000200UL
+#define CR0_EXTM_EXTC			0X0000000000002000UL
+#define CR0_EXTM_EMGC			0X0000000000004000UL
+#define CR0_EXTM_MASK			0X0000000000006200UL
+#define CR0_AFP_REG_CRTL		0x0000000000040000UL
+
 #ifndef __ASSEMBLER__
 struct psw {
 	uint64_t	mask;
 	uint64_t	addr;
 };
 
-#define CR0_EXTM_SCLP			0X0000000000000200UL
-#define CR0_EXTM_EXTC			0X0000000000002000UL
-#define CR0_EXTM_EMGC			0X0000000000004000UL
-#define CR0_EXTM_MASK			0X0000000000006200UL
-
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index e890568..0679fce 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -248,4 +248,4 @@ svc_int_psw:
 	.quad	PSW_EXCEPTION_MASK, svc_int
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
-	.quad	0x0000000000040000
+	.quad	CR0_AFP_REG_CRTL
-- 
2.25.1

