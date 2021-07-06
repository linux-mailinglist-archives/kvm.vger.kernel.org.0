Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7717A3BD69D
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhGFMlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241533AbhGFMUr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:47 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166C4SO3146116;
        Tue, 6 Jul 2021 08:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RA+MFc/JOa2CVJ/aISAh/wGL83BbBPxSgGM8ovO+pl0=;
 b=DA//RIw3knp1T7B1yiIyRoeGPmwl8gIeKfya8oYGKreVVksnPy6Z51v3J/2TF8xOdqzT
 WpDOEAH5yGoOoDSB9CCjtWYQ3kR0gw4V1pJvUo0RvAup0I8FpvmEd4lUA7DBRnpno240
 Q3UzAyJwr5fq39LnCVdIwgZvCsRp8hQHoZdT5P7EeUgjHva+BLXJyyabFeZXZw4kiGEB
 mLPOswbCbU6eLlKnUdx56ei/DDPXB/IX8jkFJN5Y6LJlea6QswmeSr6YAlbdS7xrFQGV
 NPuOghZLx5dqw7XqsSfAoqurVqjKWHouhp6+yvFbc2yfwUF1XtvdRTWCGQ7zMYXSDwGW PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpup39y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:08 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166C4gxY147725;
        Tue, 6 Jul 2021 08:18:07 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39mkpup38c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:07 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2jqq026164;
        Tue, 6 Jul 2021 12:18:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 39jfh8s879-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CI3IR31523294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:18:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9BFB42045;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75CCA4204B;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/5] s390x: sie: Add missing includes
Date:   Tue,  6 Jul 2021 12:17:53 +0000
Message-Id: <20210706121757.24070-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706121757.24070-1-frankja@linux.ibm.com>
References: <20210706121757.24070-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HcCdTS_svT9txVEyfQWh_V-Luhm4vovV
X-Proofpoint-GUID: x_eftPTavpQZxCFqMimikHUAhPB0i7aE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

arch_def.h is needed for struct psw.
stdint.h is needed for the uint*_t types.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
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

