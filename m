Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00613B733D
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhF2NgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhF2NgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:03 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDS4Ko108982;
        Tue, 29 Jun 2021 09:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=osdcO9R9sFWWWjLhLC3oyvg7ioGxzyZiJlb90U59a+c=;
 b=mJ3Qw2HMNjccL/S7SdtgV93DHju0nkjluDPMMTUhU3qJ8Vh34E6xYRxbqbcZHLv2ycUb
 LWvlEWWmVevcFwRfEnXOl8aazeQJJahMDt6V6Jcca1Wk947hBllr4AO/Cl6mDammJaJv
 cd5qBw6jLoodsazXf0v7ndhaRfrzpqrIrdfuGIlDZ9OQM554Zf+MIwjnbVfN7X/Ue+qR
 g1Xra6npCm5cj0S+OCSMjQVPuF5yYM11oOgvdrFmlxUkNFG1ADvG/y6Y/DORjsnzCdF5
 RnLAxmyI3eXH0188eELBoQwDEo28eULRL+x9KOb6Ko75HFrvQsEVQplPnAS6dMAdWDSD zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e7r688-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TDSDFM109342;
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e7r675-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDTbpJ027726;
        Tue, 29 Jun 2021 13:33:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 39duv89acr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDVsMC20709648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:31:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A353A40F4;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6643A40FD;
        Tue, 29 Jun 2021 13:33:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/5] s390x: sie: Add missing includes
Date:   Tue, 29 Jun 2021 13:33:18 +0000
Message-Id: <20210629133322.19193-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629133322.19193-1-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OSbmaSh5nrrgcwuP65PQoEM23BI-4DKQ
X-Proofpoint-ORIG-GUID: qQB3zmNrMJx1s-jOid3LiN2nqbepAvZF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=981 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arch_def.h is needed for struct psw.
stdint.h is needed for the uint*_t types.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index db30d61..b4bb78c 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -2,6 +2,9 @@
 #ifndef _S390X_SIE_H_
 #define _S390X_SIE_H_
 
+#include <stdint.h>
+#include <asm/arch_def.h>
+
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
-- 
2.30.2

