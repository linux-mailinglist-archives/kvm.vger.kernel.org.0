Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B944F7A1A
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbiDGIqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243255AbiDGIql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591DE184276;
        Thu,  7 Apr 2022 01:44:42 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2376UOiL025640;
        Thu, 7 Apr 2022 08:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yoE9kcQPGUlgdmj2KwuWhbykIPpOygwu/bc5gzbl5eQ=;
 b=XuVCliiutmrNH4U82ynIvBrSw4GXmlFDLz+2kI15c855I1K5TFEGp0HD83sZSUuQqwCj
 61lvMUsxU2c0DX5vspEF9b16TAYca8n6fYm/AEjqrDbaLmC76AMPFdP02Gl89ep+SxCV
 js6dMZXATGes7Lr8fnIzisjo94/vTHGS3Rpflq+DrFo6LfyDjT8I4MPyAkSdG2bS/vJm
 8CWpjrlFp6wzpfOVVSxm9SJUivkFU2rmNUFzMlHpkcamMSOy2VhDy5rXWYlarJQmJOg/
 gyEeOYJTD/Y2kjLLnhK1QcvyR9RH2KjKH7lW3LqSbc9x9b0uLNu9cGwbcwuogvGrJEw+ +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9tr62kq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2377h9Ov022994;
        Thu, 7 Apr 2022 08:44:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9tr62knp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378XLYN016681;
        Thu, 7 Apr 2022 08:44:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e491e3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378ih4e43450864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:44:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDA04AE045;
        Thu,  7 Apr 2022 08:44:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2653AE055;
        Thu,  7 Apr 2022 08:44:34 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 7/9] s390x: css: Cleanup includes
Date:   Thu,  7 Apr 2022 08:44:19 +0000
Message-Id: <20220407084421.2811-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vr5CHZjVsbNv1Sv33DpPwiC0irYcr2y0
X-Proofpoint-GUID: A-3EFVHMqGQITTrON0TOW7TOV97fbmbw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=889
 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most includes were related to allocation but that's done in the io
allocation library so having them in the test doesn't make sense.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/css.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/s390x/css.c b/s390x/css.c
index 13a1509f..fabe5237 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -9,17 +9,14 @@
  */
 
 #include <libcflat.h>
-#include <alloc_phys.h>
-#include <asm/page.h>
-#include <string.h>
 #include <interrupt.h>
-#include <asm/arch_def.h>
-#include <alloc_page.h>
 #include <hardware.h>
 
+#include <asm/arch_def.h>
+#include <asm/page.h>
+
 #include <malloc_io.h>
 #include <css.h>
-#include <asm/barrier.h>
 
 #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
 static unsigned long cu_type = DEFAULT_CU_TYPE;
-- 
2.32.0

