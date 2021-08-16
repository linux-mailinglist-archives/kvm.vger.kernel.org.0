Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FAF3ED6F4
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhHPNZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:25:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45498 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236904AbhHPNVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD2Uwj097986;
        Mon, 16 Aug 2021 09:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YyPKbP5U74GZwWD8B76aUxlb3sZEOyDTbn/YmkPZMh8=;
 b=KJpWVjYi6a9lNoO1gaNkga95qXr00ETuaoi4x+b0jc2ykE6ZYLZqoHWJWXK0XA4XUT91
 fzHF9O0pryC+8TZc7yX0UkmEY2EYWgGlLSoPWOJdh8GRUE3gqQ9Ho7JDeIv9CCtS8SA9
 AfpQG0SvV/vhPU7deGvyluqjSBypJgpS4sINKpczOXxZQtePAapYla50dAhyjx0TvBE0
 JCMCMxTCtfJqJ/d7k+k7PziKHW9q9lxYuvhMWR9VK0SANO9IQQbaJO390ocfOhllUD3b
 KlT6+kxwIBx0yRUPGp5O2BP3iHhgsXOySqfu/WWqPWJtPC4xHfe3+yFOypYiTV0TwWYi gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeu4c7txx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD2aGr098428;
        Mon, 16 Aug 2021 09:21:15 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aeu4c7tx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:15 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCrDd022629;
        Mon, 16 Aug 2021 13:21:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ae5f8awp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLAFq54657338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31BD511C069;
        Mon, 16 Aug 2021 13:21:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8D2611C050;
        Mon, 16 Aug 2021 13:21:09 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 02/11] s390x: Add SPDX and header comments for the snippets folder
Date:   Mon, 16 Aug 2021 15:20:45 +0200
Message-Id: <20210816132054.60078-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PcGrD7JOkGxeVC-UOuvRwoF5BZx3WCa6
X-Proofpoint-GUID: 5eZ9sUuTAiLUSNufpk3OsLt20UALi8AJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I missed adding them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/snippets/c/cstart.S       | 9 +++++++++
 s390x/snippets/c/mvpg-snippet.c | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index 242568d6..a1754808 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Start assembly for snippets
+ *
+ * Copyright (c) 2021 IBM Corp.
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <asm/sigp.h>
 
 .section .init
diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
index c1eb5d77..e55caab4 100644
--- a/s390x/snippets/c/mvpg-snippet.c
+++ b/s390x/snippets/c/mvpg-snippet.c
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet used by the mvpg-sie.c test to check SIE PEI intercepts.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <libcflat.h>
 
 static inline void force_exit(void)
-- 
2.31.1

