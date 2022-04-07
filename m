Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A116E4F7A1C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbiDGIq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 04:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243263AbiDGIqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 04:46:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4365184B49;
        Thu,  7 Apr 2022 01:44:44 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377MDNm007819;
        Thu, 7 Apr 2022 08:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NDeB37/1KcYxqA3vWagZwD/m0C4f6IfTjz9xT9i4vXY=;
 b=cOiIyqsWw0WpvRXsmGadJ+PtaekPQidakYPs7daR8zhangMV2pyBO3zbLzSE/qfpvx17
 89cBQH2icsbfYxV6j+eJZYVEvXcAyMcIo+K5eqmFIViWdgT0H9c4nG/VPZOHq4gqoncI
 6i1ih+sSTJaWVbcUi4dBrooF1VQv10OYmqw63kG9cEZMimRUHeo0LzT5pey9gpDj15ji
 V9j85GfY9FLQpm2WEEre5Cx5ut9IjFMeolfdJa8xkKoysWxCNdxnHACn/6ARKXX5QgQS
 YTmG0AWehHTEqBrkyv2oOAXIpB/B1QKXGTt9hBsKQxvq51F7y1TIDp42/8gbsmtW4FV7 jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugf9hje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:44 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378LVHp039655;
        Thu, 7 Apr 2022 08:44:44 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugf9hh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:44 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378XNac030630;
        Thu, 7 Apr 2022 08:44:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48yrtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:44:40 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378ibgM32899400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:44:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A02F1AE051;
        Thu,  7 Apr 2022 08:44:37 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D51CAAE045;
        Thu,  7 Apr 2022 08:44:36 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:44:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 9/9] s390x: mvpg: Cleanup includes
Date:   Thu,  7 Apr 2022 08:44:21 +0000
Message-Id: <20220407084421.2811-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407084421.2811-1-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fTx6AGKupHMfbOO6ZYlUIi3d7v-_38fi
X-Proofpoint-ORIG-GUID: 7lW34PRxLqHHyJ2k8hnV0Co85P41kw01
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=735
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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

Time to remove unneeded includes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/mvpg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 62f0fc5a..04e5218f 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -9,15 +9,12 @@
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
-#include <asm-generic/barrier.h>
 #include <asm/interrupt.h>
 #include <asm/pgtable.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/facility.h>
 #include <asm/mem.h>
-#include <asm/sigp.h>
-#include <smp.h>
 #include <alloc_page.h>
 #include <bitops.h>
 #include <hardware.h>
-- 
2.32.0

