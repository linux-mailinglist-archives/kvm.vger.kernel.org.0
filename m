Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37742D988
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJNMxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:53:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231140AbhJNMxd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:53:33 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ECCMh4025960;
        Thu, 14 Oct 2021 08:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HhDLkXNFzJc7wfnxlM+WvnFa7zQ6l96Ytou35Cyr3YA=;
 b=GyrBH7QMoFyjZyXvs7Kan12syGEiRAFje37XboYulVyizJCPalTDxJxU3EXxvCSLKGjN
 12mWlScb5lhBDO0c4/vv466/zI6b4rYxIu7JVgyRcooOQ37OKrxQs1AyU0j/6LeXhgSD
 hdSQJsWf3pfidVVFUJPqGRh6AU+YxhEPrRNR6Bw77njckXvgcFfNtc9N5/5jZdJb0kyg
 zwzLR+CR2vMyjeDk2JVxxONi91eY6Pr81L1MsnEEnO0//YnCc3ULDaBbpqpfk9/xYKF5
 hXw9tMa5F8EqlfgySPqunumdxjNbhQ5zU0C7KncOuUk9MOuGC6vn7MCVkEaiNJOoFcr8 Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpfr2qkec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:29 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ECo0ng028600;
        Thu, 14 Oct 2021 08:51:28 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bpfr2qkcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:28 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EClqOr029601;
        Thu, 14 Oct 2021 12:51:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2qajcnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:51:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ECjeqm61997492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 12:45:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 094FCA405B;
        Thu, 14 Oct 2021 12:51:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBA69A4051;
        Thu, 14 Oct 2021 12:51:19 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 12:51:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/3] lib: s390x: Fix copyright message
Date:   Thu, 14 Oct 2021 12:51:07 +0000
Message-Id: <20211014125107.2877-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211014125107.2877-1-frankja@linux.ibm.com>
References: <20211014125107.2877-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Cksg9rlvApmmZsIGcEnDFTIhHGarAIm
X-Proofpoint-ORIG-GUID: gu9YOn7Ooq7Xi3kegdcsIg8uGQD2vkc_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=804 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The comma makes no sense, so let's remove it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/css.h  | 2 +-
 lib/s390x/sclp.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d644971f..0db8a281 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -2,7 +2,7 @@
 /*
  * CSS definitions
  *
- * Copyright IBM, Corp. 2020
+ * Copyright IBM Corp. 2020
  * Author: Pierre Morel <pmorel@linux.ibm.com>
  */
 
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 28e526e2..61e9cf51 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -6,7 +6,7 @@
  * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
  *
  * and based on the file include/hw/s390x/sclp.h from QEMU
- * Copyright IBM, Corp. 2012
+ * Copyright IBM Corp. 2012
  * Author: Christian Borntraeger <borntraeger@de.ibm.com>
  */
 
-- 
2.30.2

