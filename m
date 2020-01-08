Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9213475C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 17:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgAHQN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 11:13:26 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729193AbgAHQN0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 11:13:26 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008GCwsU010584
        for <kvm@vger.kernel.org>; Wed, 8 Jan 2020 11:13:25 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xdhch268f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:13:25 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 8 Jan 2020 16:13:23 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Jan 2020 16:13:20 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 008GDIhO44499236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 16:13:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E7EAE045;
        Wed,  8 Jan 2020 16:13:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C60BAE053;
        Wed,  8 Jan 2020 16:13:18 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 16:13:18 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 1/4] s390x: export sclp_setup_int
Date:   Wed,  8 Jan 2020 17:13:14 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108161317.268928-1-imbrenda@linux.ibm.com>
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20010816-0028-0000-0000-000003CF6031
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010816-0029-0000-0000-00002493735D
Message-Id: <20200108161317.268928-2-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_04:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001080133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Export sclp_setup_int() so that it can be used in tests.

Needed for an upcoming unit test.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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
2.24.1

