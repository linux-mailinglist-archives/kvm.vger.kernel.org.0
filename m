Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969FD391ADD
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhEZO52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235191AbhEZO50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:26 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEXw24007092;
        Wed, 26 May 2021 10:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cl2LHhsjhT4G5eJjip9UyOuXIeOYll7NR4pHngnaNXA=;
 b=C9byNlR+zv/rqMEJup80GP7W6kZvA22/rlhhJgsCUBJpnLoIy8D2LG5rLsYrBXizTKMF
 j4C5mWvunq/NvhKFHtAvI94mk79AU3mZMyg5a11u9yl3GjV18eFodMRaEWKAEsHqgTpf
 TVACVwO6Z3FwbSdAYdbznsATa+fDXofZwwR7tqHfsQ4YywCjVUtwLg5eOY19FNkQN2sk
 PYfaXg2+73bOdxM6vZo+3f3Id8P+1AdmBkin2Vtk/emqHrbWuZ2LE/9bkf7dZblXLTfc
 D1ApUUL6mt0ws1cLlMkXbQWVdNs4gxh2pcdXfQ6m2Ol/lFRnMqn2zignWN+23Q7BluXc RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7mduw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEXvj0006944;
        Wed, 26 May 2021 10:55:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7mdtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:54 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QErthi013968;
        Wed, 26 May 2021 14:55:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r48mp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtndD34275782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0565BA40C0;
        Wed, 26 May 2021 14:55:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 630C3A408B;
        Wed, 26 May 2021 14:55:48 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 1/9] s390x: uv-guest: Add invalid share location test
Date:   Wed, 26 May 2021 16:55:31 +0200
Message-Id: <20210526145539.52008-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
References: <20210526145539.52008-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pkwNxICg_N3Nuezop6cOeCv7w9mAY1Fs
X-Proofpoint-ORIG-GUID: awXBzAnNRHecWZwoZ4BEffkNMplHAjv5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lets also test sharing unavailable memory.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 s390x/uv-guest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index 99544442..a13669ab 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -15,6 +15,7 @@
 #include <asm/interrupt.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
+#include <sclp.h>
 
 static unsigned long page;
 
@@ -99,6 +100,10 @@ static void test_sharing(void)
 	uvcb.header.len = sizeof(uvcb);
 	cc = uv_call(0, (u64)&uvcb);
 	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "share");
+	uvcb.paddr = get_ram_size() + PAGE_SIZE;
+	cc = uv_call(0, (u64)&uvcb);
+	report(cc == 1 && uvcb.header.rc == 0x101, "invalid memory");
+	uvcb.paddr = page;
 	report_prefix_pop();
 
 	report_prefix_push("unshare");
-- 
2.31.1

