Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D86F455CF8
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhKRNvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:51:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbhKRNvU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:51:20 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AID624U027383
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 13:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a31ceeiWhouj/3vahgynoBmVkF1DBTC0EZrEyxCPZVk=;
 b=pFSJvH+LI5YrdvxjBWrDJQnzbMZGJoJe0BsHMWpmBIi2MfbnfUx+fzLPgJACSm/osuDU
 SxfzA1Cqg45S6a9+cJsMwYiQovG4hbhpd6rRw82Dz6QxR3jwfMFezsQXsE5fBKxzxVQg
 a77bZ7KqSBLi1TezKqb0EtSPn2ho2dgzUpPboDPrpHNynb6l4eDWZDdrd5C8AAH1TEmb
 ubIABKZcqXRsri0OuDMI8c2uYHSpmlOgOMOAqos/o4qdT8vN0IvCQ/+Z3oliFHSXyfGj
 wcB3oH77CfoqknsKJ2OcgHcrovyuUUK7QhJCXYZJB8hUH1SK2ZsvJ5MIarwhZmoDN7Xp Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdq29sk5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 13:48:20 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIDYcnu017391
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 13:48:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdq29sk4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 13:48:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIDlU7C026476;
        Thu, 18 Nov 2021 13:48:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50apbe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 13:48:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIDmE7H25231804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 13:48:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47F6B4C04E;
        Thu, 18 Nov 2021 13:48:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E19AB4C050;
        Thu, 18 Nov 2021 13:48:13 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.84.168])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 13:48:13 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2] io: declare __cpu_is_be in generic code
Date:   Thu, 18 Nov 2021 14:48:48 +0100
Message-Id: <20211118134848.336943-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jngwCtKNvSFx4SeLZIxSTJG-UltYmQFX
X-Proofpoint-GUID: 2AitpO4Z9nKGulqntPKhR2n9fUzNSP3i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_05,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=827
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To use the swap byte transformations in big endian architectures,
we need to declare __cpu_is_be in the generic code.
Let's move it from the ppc code to the generic code.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Suggested-by: Thomas Huth <thuth@redhat.com>
---
 lib/asm-generic/io.h | 8 ++++++++
 lib/ppc64/asm/io.h   | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
index 88972f3b..9fa76ddb 100644
--- a/lib/asm-generic/io.h
+++ b/lib/asm-generic/io.h
@@ -13,6 +13,14 @@
 #include "asm/page.h"
 #include "asm/barrier.h"
 
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define __cpu_is_be() (0)
+#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define __cpu_is_be() (1)
+#else
+#error Undefined byte order
+#endif
+
 #ifndef __raw_readb
 static inline u8 __raw_readb(const volatile void *addr)
 {
diff --git a/lib/ppc64/asm/io.h b/lib/ppc64/asm/io.h
index 2b4dd2be..08d7297c 100644
--- a/lib/ppc64/asm/io.h
+++ b/lib/ppc64/asm/io.h
@@ -1,14 +1,6 @@
 #ifndef _ASMPPC64_IO_H_
 #define _ASMPPC64_IO_H_
 
-#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-#define __cpu_is_be() (0)
-#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-#define __cpu_is_be() (1)
-#else
-#error Undefined byte order
-#endif
-
 #define __iomem
 
 #include <asm-generic/io.h>
-- 
2.25.1

