Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7F4EDE4F
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 18:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbiCaQGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 12:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237963AbiCaQGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 12:06:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E46522E7;
        Thu, 31 Mar 2022 09:04:35 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VFC6Cs027164;
        Thu, 31 Mar 2022 16:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c5SFzfQf7kPWAzQreYEcrFgHzA3W7E8LW8DsMlnJOXU=;
 b=pFkh2Xs8HrN6gbfzowWTuiEYAEj0Xm91xzRl/E7pJKfeE/vD9IA0LY827zW5b6idXrB6
 6TxMNGKvYOBqbOqBzN8yuOhrMfQYr93MKRNskX2VgnVdomL15ZDxb3uU2Q2bnpKKHTmQ
 WlqWD7DdCpiJ9ydUs9cVYwCDYbyFIN6IKCSnl/FqS3KtvVkCNwrqlG3adenjN/DUkNhG
 Ev+sc3y4duk5fni2T62ds2IZMQ3zp8cDexEyY3raVnZLR72Ja7GnvKlfAU9eljVTjWBI
 iXNCNolu/la2qZa1LpSJHpoCs4mx7wLfRyRUIrTh7jcQJXbUfcK2VoVBKl4eR2Is5WSR Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54epq312-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:35 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VFmO5q004796;
        Thu, 31 Mar 2022 16:04:34 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54epq304-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:34 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VG1kB3028736;
        Thu, 31 Mar 2022 16:04:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf91ebh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VG4TdQ16318836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 16:04:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFAFF11C04C;
        Thu, 31 Mar 2022 16:04:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3281111C04A;
        Thu, 31 Mar 2022 16:04:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 16:04:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/5] s390x: remove spurious includes
Date:   Thu, 31 Mar 2022 18:04:15 +0200
Message-Id: <20220331160419.333157-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331160419.333157-1-imbrenda@linux.ibm.com>
References: <20220331160419.333157-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6D6LL3HtHYIZsFOQgbxqFwwwGJkKjGkm
X-Proofpoint-ORIG-GUID: ilnfwGiBEtTM2qcPgy4rbE_5FHlRYZT8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=894 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused includes of vm.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg-sie.c    | 1 -
 s390x/pv-diags.c    | 1 -
 s390x/spec_ex-sie.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 8ae9a52a..46a2edb6 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -16,7 +16,6 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sclp.h>
 #include <sie.h>
 #include <snippet.h>
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 110547ad..6899b859 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -19,7 +19,6 @@
 #include <asm/sigp.h>
 #include <smp.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <vmalloc.h>
 #include <sclp.h>
 #include <snippet.h>
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5dea4115..d8e25e75 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -11,7 +11,6 @@
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sie.h>
 #include <snippet.h>
 
-- 
2.34.1

