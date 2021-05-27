Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31602392E39
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbhE0Mri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:47:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29498 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234283AbhE0Mrd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 08:47:33 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14RCehMt114047
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 08:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=67UCVwT7Ji9YBH3wFlHVfyzvb/0HuhawHktJArY1OxU=;
 b=c3II0efcriRxTxiPmxNwsvuc4nXimilFS2lWrgkwtKccjnyvO2kB+UfukmnZ91NarzDL
 aJd011NIoDa0C9s2ng4oaQWSGew5o44M4es90RRWhq6whPF+Q/v8bDka70sDLl6UJj2p
 n+7Y/8fwot0wLazmtajHdgSKYF3TnG4HKvBmLs7zXAj+YZ0cdgvt72bqV5GTmgM04x/t
 frk+n2ESQZtRNrXMy8q9DO431q/5zHNg1px5kMCWUMQlyIa9oSukk0hu112uQWYyQ2pH
 fnTAs4ajHAVWypbNXsqRhOvTt0XE4mVSzbmIl45xRg9APFOYmdi037HOmj8edlKYSmsZ jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t9px4m8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 08:45:57 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14RChDR1118670
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 08:45:57 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38t9px4m7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 08:45:57 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14RCbdIA021200;
        Thu, 27 May 2021 12:45:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 38s2dt0n2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 12:45:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14RCjNoC33685836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 12:45:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A4EAE04D;
        Thu, 27 May 2021 12:45:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E185BAE045;
        Thu, 27 May 2021 12:45:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 12:45:51 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, pbonzini@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH] lib/alloc: remove double include
Date:   Thu, 27 May 2021 12:45:51 +0000
Message-Id: <20210527124551.38299-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 20vWOtqGHc0PJ_FIvibKtMrBGWICB7c_
X-Proofpoint-ORIG-GUID: AHKhTg-BYMopcy0gjWyJwM4RKyNJny8G
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_06:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 mlxlogscore=869
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One bitops.h include should be enough.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 lib/alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/alloc.c b/lib/alloc.c
index a46f464..f4266f5 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,5 +1,4 @@
 #include "alloc.h"
-#include "bitops.h"
 #include "asm/page.h"
 #include "bitops.h"
 
-- 
2.27.0

