Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B352C490D00
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbiAQRAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241396AbiAQQ75 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:57 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HEEgKf026360
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=08OqX5JAsl6KsSDhDqaMqy3/GIC/UZUUksNTo2A8JzM=;
 b=WByRXgFqrhFubjE6PyfYprfUcpRFNpTWz2AQ2MytmtTDYldc3JjDzYc/xRNA8BiZu4wC
 7gk7jRz5prY+OBI3+o7h881K4GwdRvo4VMQHbQ5jHgO+o+9Msj1tURLfrNSb6ilGv4FD
 SMgzt30iGVZv0j30cSqi739iwH/fQxp+xv5excFbwkVUfRFhPVvysqrAcdIOjpjZbNj8
 HkoA8osEIPc4li7cvJ5c7gLJOiqPxPHGbnEwiYheMNdO6IpWkOpxz1czUgKCuALMu/U/
 7pejtqsvQJz6I7ZzP2FhyCx+Jsg9trIlFTSatOE35m/OnDvh1x0kb//ysOBxldCr5qVZ xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcqdbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:56 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGvPWw009792
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7kcqdb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGlC81023004;
        Mon, 17 Jan 2022 16:59:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhj64wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxpwi26477002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F238FA4054;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E77DA405F;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 01/13] s390x: snippets: mvpg-snippet: Remove unneeded includes
Date:   Mon, 17 Jan 2022 17:59:37 +0100
Message-Id: <20220117165949.75964-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0StFmzTck1Iiu53mcHERPq7aZjdrM10I
X-Proofpoint-GUID: 5pb0y9arZ7exzjes_1u3XKnBPjUHx2BG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=808
 adultscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

None of those headers is used, let's remove them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/snippets/c/mvpg-snippet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
index e55caab4..42e74da5 100644
--- a/s390x/snippets/c/mvpg-snippet.c
+++ b/s390x/snippets/c/mvpg-snippet.c
@@ -7,7 +7,6 @@
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
  */
-#include <libcflat.h>
 
 static inline void force_exit(void)
 {
-- 
2.31.1

