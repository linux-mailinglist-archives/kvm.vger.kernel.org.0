Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4E64F26C0
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiDEIFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 04:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiDEH7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E8D41330;
        Tue,  5 Apr 2022 00:55:50 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2357dsNX009240;
        Tue, 5 Apr 2022 07:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PaVzySJRymfnVJlh7kyGZru3sznvPR1NyTVSB1TAAkI=;
 b=RzzTuSml6CnvZhluVeuQDNO+2oDPmnh8KmgrpoxqfZFid7BIll+keZLlQ4WeTnE0UyZj
 NWWjrZdue0VPKl99ShNg4zBxTX/no47ZqOiqXLYDxO1/nzliFRdFPdgWNefxFjyvLbPc
 HGbjmam5yFl+6M7FXLic7qOpf8kt7e/kdDpM7VXwGiv34Pa5BMhzt4I9ufOSeV8Xn8ho
 MIgg/ENC4Prs/iqwqs/WcUOmYEdgpEf5CfYNn4RnVgP6yUNNhJc+86UAcGGXoBShFcou
 +wRGCijxCD/YLIEBhfm1sRRsbbObR4J+axGI3KsyLnR/lCnjBTkl35soxUI9kg4SH2Wt Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705hjrus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:49 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2357gMLc019679;
        Tue, 5 Apr 2022 07:55:49 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705hjruh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:48 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2357hERl015345;
        Tue, 5 Apr 2022 07:55:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3f6e48ma9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 07:55:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2357thxa33685908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 07:55:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB9684203F;
        Tue,  5 Apr 2022 07:55:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C37842041;
        Tue,  5 Apr 2022 07:55:43 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 07:55:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 7/8] s390x: iep: Cleanup includes
Date:   Tue,  5 Apr 2022 07:52:24 +0000
Message-Id: <20220405075225.15903-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220405075225.15903-1-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nV1X5GNg9G5J7fwMneq5Ldhbm_4WNTa7
X-Proofpoint-ORIG-GUID: m7b7mYbuXs_kS7pzkiTqCklxEPiGRraT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_09,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=741
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't use barriers so let's remove the include.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/iep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/s390x/iep.c b/s390x/iep.c
index 8d5e044b..4b3e09a7 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -9,11 +9,10 @@
  */
 #include <libcflat.h>
 #include <vmalloc.h>
+#include <mmu.h>
 #include <asm/facility.h>
 #include <asm/interrupt.h>
-#include <mmu.h>
 #include <asm/pgtable.h>
-#include <asm-generic/barrier.h>
 
 static void test_iep(void)
 {
-- 
2.32.0

