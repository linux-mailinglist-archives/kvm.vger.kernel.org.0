Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25E5509D3A
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388204AbiDUKQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356293AbiDUKQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34B3B874;
        Thu, 21 Apr 2022 03:13:39 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9Urjq030106;
        Thu, 21 Apr 2022 10:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yoE9kcQPGUlgdmj2KwuWhbykIPpOygwu/bc5gzbl5eQ=;
 b=ce41oDW1PooD39GWDWwxsxTf+T4U6zOG6IIneSB3377zsbaSTvMWqZ7BwbcWD8kyfxRf
 CNbb4nUZWBPnpptHag5BA2+3yZlSJFUt7RuP8luGiFG9oQgR8Nf7+5Yv4FSuaE9jKCSl
 12cPXIZCSfbC1ohj+BSLKVlbBQNwHvPXA6rmxoUQuGnA8yir2wKqGb89z+r5f6k1Up+Z
 zhNgXxGgjEwwea/TVFh69cNfbs+bkZOZ980chokCy38zdQQ6ez6jNXcBIqnDVXmXz2ih
 QlcCXL6aqMOwbQZftPngZAFCrrbqTYblUAQgrRx20IT3EqEVftLLrpR3T7uB+s0VtlPB Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cwuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:39 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23LA9wIR020012;
        Thu, 21 Apr 2022 10:13:39 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cwu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:38 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LA3Yg1025697;
        Thu, 21 Apr 2022 10:13:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u4hb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LADWPE52232542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:13:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7853AE056;
        Thu, 21 Apr 2022 10:13:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAF53AE04D;
        Thu, 21 Apr 2022 10:13:31 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 07/11] s390x: css: Cleanup includes
Date:   Thu, 21 Apr 2022 10:11:26 +0000
Message-Id: <20220421101130.23107-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SHm2xAmxNAuVp-Aeo3KzuxW2RyNiVZZj
X-Proofpoint-GUID: QxufR6lJIEiRyZQue42sMNHF9l8zj_-u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=863 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

