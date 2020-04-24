Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B4D1B726B
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 12:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgDXKqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 06:46:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726842AbgDXKqC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 06:46:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OAXG4q106498
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:46:01 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kx0jh397-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 06:46:00 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 24 Apr 2020 11:45:21 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Apr 2020 11:45:18 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OAjtiv57802946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 10:45:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74F1BA4053;
        Fri, 24 Apr 2020 10:45:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26208A4051;
        Fri, 24 Apr 2020 10:45:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.79.138])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 10:45:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v6 03/10] s390x: Move control register bit definitions and add AFP to them
Date:   Fri, 24 Apr 2020 12:45:45 +0200
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20042410-0008-0000-0000-0000037678AD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042410-0009-0000-0000-00004A984912
Message-Id: <1587725152-25569-4-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_04:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240078
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
index c54409a..a0d2362 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -20,17 +20,18 @@
 #define PSW_EXCEPTION_MASK	(PSW_MASK_EA | PSW_MASK_BA)
 #define PSW_RESET_MASK		(PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PSW)
 
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
index e394b3a..2906e39 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -241,4 +241,4 @@ svc_int_psw:
 	.quad	PSW_EXCEPTION_MASK, svc_int
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
-	.quad	0x0000000000040000
+	.quad	CR0_AFP_REG_CRTL
-- 
2.25.1

