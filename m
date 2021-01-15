Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647BA2F79FD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732919AbhAOMn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:43:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388381AbhAOMnZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:43:25 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCYQ1g011718;
        Fri, 15 Jan 2021 07:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XMrSdkBO6H0bhPZj+2/Gi75A7sr3FfvZntzURITiK5I=;
 b=bRkXjY/OyDMhDquKHRG5/K4GMDINWNXzcia1Atqt+lipPGztoGoaFn95UrxTwsX4VeMa
 QEZY2lVJ0X7o7FFCC+jEjiQRRfULDqPG8jk+HFSImMWgyasH2T5hu9EPbr6UeqFWFqva
 aXSCr4yYd1mGuS67qYR4ZcIbfMmWEPtll9dYjQJ//BfmyRLpUuqVYH3BD2Oj15od0TCZ
 JfZDl2gmKa/lxoUmvoEL8y8doXhZSx1+PwjLozEfkZVmEHSMKLmqcuHNtgcmD8ykQeRM
 lNV+T1j9Fa0UZIL+Kc8VY9rpiPgH33SMcR0LE3qXak521OKBFroh1713lT1vyzJ3mrI9 Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363aux0m31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:37 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCavhb028309;
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363aux0m2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FC8Cmq014079;
        Fri, 15 Jan 2021 12:37:34 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdf9nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:34 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbWW846137764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29CABAE051;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2AC3AE055;
        Fri, 15 Jan 2021 12:37:31 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 01/11] lib/x86: fix page.h to include the generic header
Date:   Fri, 15 Jan 2021 13:37:20 +0100
Message-Id: <20210115123730.381612-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bring x86 in line with the other architectures and include the generic header
at asm-generic/page.h .
This provides the macros PAGE_SHIFT, PAGE_SIZE, PAGE_MASK, virt_to_pfn, and
pfn_to_virt.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/asm/page.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index 1359eb7..2cf8881 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -13,9 +13,7 @@
 typedef unsigned long pteval_t;
 typedef unsigned long pgd_t;
 
-#define PAGE_SHIFT	12
-#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
+#include <asm-generic/page.h>
 
 #ifndef __ASSEMBLY__
 
-- 
2.26.2

