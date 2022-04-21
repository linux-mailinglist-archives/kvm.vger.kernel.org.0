Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64862509D44
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388188AbiDUKQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388204AbiDUKQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B0CB7D5;
        Thu, 21 Apr 2022 03:13:38 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9j1nR012166;
        Thu, 21 Apr 2022 10:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kycaE6IqT8OH0UM6uHvkjrBf5dDdAuTHuMCvsG6vyTg=;
 b=NtNIpXPH6P9OcH1eAY4SCKEpcd69i9wNa0R69De2Cqg27gpVQuZ1h9hOvoZL9lfd137x
 OL/QWSuniKnzrRPU5aLbEBzuYBJINymxY0o6XveK5rMO7dKZ1FqXThppNnppA/tmNPPN
 ygH4EjGx+c3jlA1JD56iJNeOTPvia+16HfJ+DVQ23lDKF0qVGTGrdkvyKeiaJe2cTrvu
 yv/AGGHhjvdQJcF5dYEc33mbyL6r8lkFa04GSV2JGbQapF9W/rGWTEoM9AflaWJl3CLY
 ithX58ULiW5REwWp2ZCUxWS/zUr9DCmcqkblxVsJ6B4+2zFgCi7gBl/rSlj8zAeoywzq ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjn0xj67w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:37 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9jFLK015264;
        Thu, 21 Apr 2022 10:13:37 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjn0xj675-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:37 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LA3Fl7003025;
        Thu, 21 Apr 2022 10:13:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne97nsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LADVgj48824614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:13:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4759AE055;
        Thu, 21 Apr 2022 10:13:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04773AE04D;
        Thu, 21 Apr 2022 10:13:31 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 06/11] s390x: pv-diags: Cleanup includes
Date:   Thu, 21 Apr 2022 10:11:25 +0000
Message-Id: <20220421101130.23107-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i-4nuVdPWKqNpUkWgvebteX2I0Mm2svN
X-Proofpoint-ORIG-GUID: NvHGzrqPgMnw2QzLOPuu9StsUTEa983o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=901 bulkscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This file has way too much includes. Time to remove some.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/pv-diags.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 6899b859..9ced68c7 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -8,23 +8,10 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
-#include <asm/asm-offsets.h>
-#include <asm-generic/barrier.h>
-#include <asm/interrupt.h>
-#include <asm/pgtable.h>
-#include <mmu.h>
-#include <asm/page.h>
-#include <asm/facility.h>
-#include <asm/mem.h>
-#include <asm/sigp.h>
-#include <smp.h>
-#include <alloc_page.h>
-#include <vmalloc.h>
-#include <sclp.h>
 #include <snippet.h>
 #include <sie.h>
-#include <uv.h>
-#include <asm/uv.h>
+#include <sclp.h>
+#include <asm/facility.h>
 
 static struct vm vm;
 
-- 
2.32.0

