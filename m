Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46AC455EB8
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhKRO4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:56:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhKRO4j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:56:39 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIDffwX030677
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oMVTQsrdaA+ObV9Y/XrxSWwrx0ubrMtu512+9x9guF0=;
 b=Ss84UF5AvZELyHZfpUSDmL/pWKLxwYScSuyO9kzyVBZ2cQZX+TFd3vemCOZ8pHed99Pz
 WHz2SLhFYM1tOOkw9eNitdnOLIY/a6SUhOHu/CclAo8PzF7oom2rh3oojB0leBFc1a2z
 gbjqm1oe9l2DZXQiEiADprfyZGcEUqAgxvrP1Pvc1eConeEj+Nob8HpDzK54fOAqhjcE
 /PDRupy8dhs780rPbM7cyD9rC6EexLuyEb7/fMDi6U+nBttZVXpArlZTy1iHMyzknv8a
 kExrBQbNzGj/ci6d92jcuhUVlcJsqTd1tgFBWIJD0Q3AeJkPbNlFhognM+QzD7Y9fI4i Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdqxe1tmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:53:38 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AIDi1Wu010876
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 14:53:38 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdqxe1tm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 14:53:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIEpuAp009095;
        Thu, 18 Nov 2021 14:53:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50bq000-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 14:53:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIErXsn6947336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 14:53:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13CC7A4065;
        Thu, 18 Nov 2021 14:53:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD815A405B;
        Thu, 18 Nov 2021 14:53:32 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.84.168])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 14:53:32 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3] io: declare __cpu_is_be in generic code
Date:   Thu, 18 Nov 2021 15:54:06 +0100
Message-Id: <20211118145406.340503-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iLAvbvCC4gtVh6VRU1P5vVwARNEaJ1XT
X-Proofpoint-GUID: pgQvDH2NnkE5hjsFg8HBD8jtS4_5ku6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=840
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111180081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To use the swap byte transformations in big endian architectures,
we need to declare __cpu_is_be in the generic code.
Let's move it from the ppc code to the generic code.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Suggested-by: Thomas Huth <thuth@redhat.com>
---
 lib/asm-generic/io.h | 12 ++++++++----
 lib/ppc64/asm/io.h   |  8 --------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
index 88972f3b..dc0f46f5 100644
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
@@ -100,10 +108,6 @@ static inline u64 __bswap64(u64 x)
 }
 #endif
 
-#ifndef __cpu_is_be
-#define __cpu_is_be() (0)
-#endif
-
 #define le16_to_cpu(x) \
 	({ u16 __r = __cpu_is_be() ? __bswap16(x) : ((u16)x); __r; })
 #define cpu_to_le16 le16_to_cpu
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

