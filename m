Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80582C6664
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbgK0NJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:09:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730066AbgK0NJK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:09:10 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCVY6M187796;
        Fri, 27 Nov 2020 08:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7PLA+wHiCZwtzEzklzXSMkA9+LdthVygMLRoFoRGCeM=;
 b=QV8EeyFGapY7OtJk/21AsjJKk5FBhveHtQ9f2KYGBRy4s/2iotjnMnZFSzF7sRHN5862
 FEBFSYZn8jj1P2D+UFwmOj5hgBFFlWFVvVo7S2+XOqlbUCqi8o5O7y8qIpA7WI+gPcdv
 Ix8Ews7RDitrC1gFG0xw8CMPsq5Mhg4bxb1jwrC8u/i8xtoNBelvc3iG/oxNWNjzvQnd
 BnpnV14WP6KYoGGQqFOovL7qv3MEv2QGtO2sSpRfQBvLu4Hw6IRbuG8UiGlvtkF4nRZq
 Ti8ZEaOKFWZpfuY8/9SYN/0lUFKf2r+TQGfJXAKJEOGPTgGCec2CRpNsN+DCZxugpVlZ Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352we6r3fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:09:09 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ARCVnHt189080;
        Fri, 27 Nov 2020 08:09:08 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 352we6r3f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 08:09:08 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ARCSREc024095;
        Fri, 27 Nov 2020 13:09:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 352jgsh05b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Nov 2020 13:09:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ARD6YlR58655066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Nov 2020 13:06:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F3B54C071;
        Fri, 27 Nov 2020 13:06:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B53C4C046;
        Fri, 27 Nov 2020 13:06:33 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Nov 2020 13:06:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 1/7] s390x: Add test_bit to library
Date:   Fri, 27 Nov 2020 08:06:23 -0500
Message-Id: <20201127130629.120469-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127130629.120469-1-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_05:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 clxscore=1015 suspectscore=1 mlxscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Query/feature bits are commonly tested via MSB bit numbers on
s390. Let's add test bit functions, so we don't need to copy code to
test query bits.

The test_bit code has been taken from the kernel since most s390x KVM unit
test developers are used to them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/bitops.h   | 26 ++++++++++++++++++++++++++
 lib/s390x/asm/facility.h |  3 ++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
index e7cdda9..792881e 100644
--- a/lib/s390x/asm/bitops.h
+++ b/lib/s390x/asm/bitops.h
@@ -1,3 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *    Bitops taken from the kernel as most developers are already used
+ *    to them.
+ *
+ *    Copyright IBM Corp. 1999,2013
+ *
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
+ *
+ */
 #ifndef _ASMS390X_BITOPS_H_
 #define _ASMS390X_BITOPS_H_
 
@@ -7,4 +17,20 @@
 
 #define BITS_PER_LONG	64
 
+static inline bool test_bit(unsigned long nr,
+			    const volatile unsigned long *ptr)
+{
+	const volatile unsigned char *addr;
+
+	addr = ((const volatile unsigned char *)ptr);
+	addr += (nr ^ (BITS_PER_LONG - 8)) >> 3;
+	return (*addr >> (nr & 7)) & 1;
+}
+
+static inline bool test_bit_inv(unsigned long nr,
+				const volatile unsigned long *ptr)
+{
+	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
+}
+
 #endif
diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index def2705..5593c2d 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -13,13 +13,14 @@
 #include <libcflat.h>
 #include <asm/facility.h>
 #include <asm/arch_def.h>
+#include <bitops.h>
 
 #define NB_STFL_DOUBLEWORDS 32
 extern uint64_t stfl_doublewords[];
 
 static inline bool test_facility(int nr)
 {
-	return stfl_doublewords[nr / 64] & (0x8000000000000000UL >> (nr % 64));
+	return test_bit_inv(nr, stfl_doublewords);
 }
 
 static inline void stfl(void)
-- 
2.25.1

