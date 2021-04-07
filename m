Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347AB356C63
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbhDGMm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:42:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234296AbhDGMm0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 08:42:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137CXVCI005138;
        Wed, 7 Apr 2021 08:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G1PDUqDMpsNe0ntgFx4AwBRrGhhIiVEZj41qImbLcWc=;
 b=RUcJi8gOQeGZectgBsWH5SeOiSTHxJEoPZIiD7awR56WwaSHvCmaZDhXqSJujNQawD15
 taXE5Qi44/y2iYMxzf+SaQ6HJSljNZbShDMnWdCXD006l8JL7Dcfb0XLIcfaHWNMa31l
 1hncjc396YABxnRQ9qbE8+Fo1CeYV4ZNrM4PHA8DeLp0yQYZasI+Dn95OAChknsy9V1Q
 kqrP/eM+IwZNXyBoBIq5h7qJq6naDWJ+JIiMVDYbQopS3OmOUf128En76mLomldW3Z9T
 ydfGX7xcO9r9S5kFHXZrY+ITVI3wc7Ipqgil/bO99JBuYzywl+qLSk46bRzq/S92KiCN Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqgr7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:16 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137CXeQb005870;
        Wed, 7 Apr 2021 08:42:16 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqgr78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 08:42:16 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137CWZCC025881;
        Wed, 7 Apr 2021 12:42:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 37rvc5gchk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 12:42:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137CgBcs43909418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 12:42:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 640B852051;
        Wed,  7 Apr 2021 12:42:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 052CF52050;
        Wed,  7 Apr 2021 12:42:10 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 2/7] libcflat: add SZ_1M and SZ_2G
Date:   Wed,  7 Apr 2021 14:42:04 +0200
Message-Id: <20210407124209.828540-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407124209.828540-1-imbrenda@linux.ibm.com>
References: <20210407124209.828540-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ywqTJ349Bs7DDgwVu7vULxlFiqlv1yjR
X-Proofpoint-ORIG-GUID: bWLlKDIVzOVFaC1OL1bck9oJmWIoxBVB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_08:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SZ_1M and SZ_2G to libcflat.h

s390x needs those for large/huge pages

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/libcflat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 460a1234..8dac0621 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -157,7 +157,9 @@ extern void setup_vm(void);
 #define SZ_8K			(1 << 13)
 #define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
+#define SZ_1M			(1 << 20)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
+#define SZ_2G			(1ul << 31)
 
 #endif
-- 
2.26.2

