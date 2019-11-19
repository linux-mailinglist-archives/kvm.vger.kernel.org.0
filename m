Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5105710213A
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 10:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKSJxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 04:53:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbfKSJxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 04:53:48 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJ9qgW6111334
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:47 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2way8naw0b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:53:47 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 19 Nov 2019 09:53:45 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 19 Nov 2019 09:53:42 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJ9reTG57934038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 09:53:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EC7552051;
        Tue, 19 Nov 2019 09:53:40 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4513652052;
        Tue, 19 Nov 2019 09:53:40 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/3] s390x: export sclp_setup_int
Date:   Tue, 19 Nov 2019 10:53:37 +0100
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
References: <1574157219-22052-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111909-0016-0000-0000-000002C7E3EB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111909-0017-0000-0000-0000332999CE
Message-Id: <1574157219-22052-2-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_02:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 clxscore=1015 lowpriorityscore=0
 adultscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export sclp_setup_int() so that it can be used from outside.

Needed for an upocoming unit test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.h | 1 +
 lib/s390x/sclp.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 6d40fb7..675f07e 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -265,6 +265,7 @@ typedef struct ReadEventData {
 } __attribute__((packed)) ReadEventData;
 
 extern char _sccb[];
+void sclp_setup_int(void);
 void sclp_handle_ext(void);
 void sclp_wait_busy(void);
 void sclp_mark_busy(void);
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 7798f04..123b639 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -45,7 +45,7 @@ static void mem_init(phys_addr_t mem_end)
 	page_alloc_ops_enable();
 }
 
-static void sclp_setup_int(void)
+void sclp_setup_int(void)
 {
 	uint64_t mask;
 
-- 
2.7.4

