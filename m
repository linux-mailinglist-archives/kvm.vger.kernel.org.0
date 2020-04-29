Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD601BE141
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgD2Ofk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:35:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgD2Ofj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 10:35:39 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TEXp73089428;
        Wed, 29 Apr 2020 10:35:38 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30q9bc503v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03TEYm0U100791;
        Wed, 29 Apr 2020 10:35:37 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30q9bc502u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:37 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TEUVE6018511;
        Wed, 29 Apr 2020 14:35:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 30mcu51v44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 14:35:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TEYPKY63045902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:34:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDBFF4C052;
        Wed, 29 Apr 2020 14:35:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 211F84C04A;
        Wed, 29 Apr 2020 14:35:33 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 14:35:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v3 10/10] s390x: Fix library constant definitions
Date:   Wed, 29 Apr 2020 10:35:18 -0400
Message-Id: <20200429143518.1360468-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200429143518.1360468-1-frankja@linux.ibm.com>
References: <20200429143518.1360468-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=900 suspectscore=1 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I uppercased the whole region instead of only the ULs when
I added those definitions. Let's make the x lowercase again.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/arch_def.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 15a4d49..1b3bb0c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -19,10 +19,10 @@ struct psw {
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 
-#define CR0_EXTM_SCLP			0X0000000000000200UL
-#define CR0_EXTM_EXTC			0X0000000000002000UL
-#define CR0_EXTM_EMGC			0X0000000000004000UL
-#define CR0_EXTM_MASK			0X0000000000006200UL
+#define CR0_EXTM_SCLP			0x0000000000000200UL
+#define CR0_EXTM_EXTC			0x0000000000002000UL
+#define CR0_EXTM_EMGC			0x0000000000004000UL
+#define CR0_EXTM_MASK			0x0000000000006200UL
 
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
-- 
2.25.1

