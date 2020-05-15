Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080A81D5C4A
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 00:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgEOWUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 18:20:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44298 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgEOWUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 18:20:04 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FM2VmD035800;
        Fri, 15 May 2020 18:20:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 311rd7asbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:03 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FM2lat040107;
        Fri, 15 May 2020 18:20:03 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 311rd7asbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:20:03 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FMJ5OE025915;
        Fri, 15 May 2020 22:20:02 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 3100ubte1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 22:20:02 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FMJwRB51184094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 22:19:58 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A783CC605D;
        Fri, 15 May 2020 22:19:58 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F251BC6055;
        Fri, 15 May 2020 22:19:57 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.146.125])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 22:19:57 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v7 2/3] s390: keep diag 318 variables consistent with the rest
Date:   Fri, 15 May 2020 18:19:34 -0400
Message-Id: <20200515221935.18775-3-walling@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200515221935.18775-1-walling@linux.ibm.com>
References: <20200515221935.18775-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 clxscore=1015 phishscore=0 impostorscore=0 mlxlogscore=986 adultscore=0
 cotscore=-2147483648 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename diag318 to diag_318 and byte_134 to fac134 in order to keep
naming schemes consistent with other diags and the read info struct
and make grepping easier.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/include/asm/diag.h   | 2 +-
 arch/s390/include/asm/sclp.h   | 2 +-
 arch/s390/kernel/setup.c       | 6 +++---
 drivers/s390/char/sclp.h       | 2 +-
 drivers/s390/char/sclp_early.c | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
index ca8f85b53a90..19da822e494c 100644
--- a/arch/s390/include/asm/diag.h
+++ b/arch/s390/include/asm/diag.h
@@ -295,7 +295,7 @@ struct diag26c_mac_resp {
 } __aligned(8);
 
 #define CPNC_LINUX		0x4
-union diag318_info {
+union diag_318_info {
 	unsigned long val;
 	struct {
 		unsigned long cpnc : 8;
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index c563f8368b19..a45967cfc1ae 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -78,7 +78,7 @@ struct sclp_info {
 	unsigned char has_skey : 1;
 	unsigned char has_kss : 1;
 	unsigned char has_gisaf : 1;
-	unsigned char has_diag318 : 1;
+	unsigned char has_diag_318 : 1;
 	unsigned char has_sipl : 1;
 	unsigned char has_dirq : 1;
 	unsigned int ibc;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 1aaaf11acc6b..8925a1ac14c9 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1026,16 +1026,16 @@ static void __init setup_task_size(void)
  */
 static void __init setup_control_program_code(void)
 {
-	union diag318_info diag318_info = {
+	union diag_318_info diag_318_info = {
 		.cpnc = CPNC_LINUX,
 		.cpvc = 0,
 	};
 
-	if (!sclp.has_diag318)
+	if (!sclp.has_diag_318)
 		return;
 
 	diag_stat_inc(DIAG_STAT_X318);
-	asm volatile("diag %0,0,0x318\n" : : "d" (diag318_info.val));
+	asm volatile("diag %0,0,0x318\n" : : "d" (diag_318_info.val));
 }
 
 /*
diff --git a/drivers/s390/char/sclp.h b/drivers/s390/char/sclp.h
index 196333013e54..d6a91f3b8e2b 100644
--- a/drivers/s390/char/sclp.h
+++ b/drivers/s390/char/sclp.h
@@ -196,7 +196,7 @@ struct read_info_sccb {
 	u8	_pad_122[124 - 122];	/* 122-123 */
 	u32	hmfai;			/* 124-127 */
 	u8	_pad_128[134 - 128];	/* 128-133 */
-	u8	byte_134;			/* 134 */
+	u8	fac134;			/* 134 */
 	u8	cpudirq;		/* 135 */
 	u16	cbl;			/* 136-137 */
 	u8	_pad_138[4096 - 138];	/* 138-4095 */
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index cc5e84b80c69..388d24c65e74 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -46,7 +46,7 @@ static void __init sclp_early_facilities_detect(struct read_info_sccb *sccb)
 	if (sccb->fac91 & 0x40)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_TLB_GUEST;
 	if (sccb->cpuoff > 134)
-		sclp.has_diag318 = !!(sccb->byte_134 & 0x80);
+		sclp.has_diag_318 = !!(sccb->fac134 & 0x80);
 	sclp.rnmax = sccb->rnmax ? sccb->rnmax : sccb->rnmax2;
 	sclp.rzm = sccb->rnsize ? sccb->rnsize : sccb->rnsize2;
 	sclp.rzm <<= 20;
-- 
2.21.3

