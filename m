Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BB2DC795
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgLPUOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:14:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14022 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728746AbgLPUOV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:14:21 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2vxe181265
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g+6NcmY2CMN3pnInIKAxRv/N64gV3ATfEKs3aWONZF0=;
 b=Lq/TgipjRP2cImS1xRkgE5VBhO7SrXOquZJXIZhJ+KHnIC9y9eJcQPLpzLet3gf9Mpa1
 wxNk+/3qSufJQMzt6PkDxFglt110fAodQqIVBh5cJhVFZSUatjU8b3mCbimAopk7cJ2x
 Gm+bWb8lC53iCFlCBYSBwUlojdAEq5GmllYN5dgH3nO1L64pysZjNdqioKMUDHaa7J08
 NdjSU3vvH4fU6Z2eAYm7RUAPxMYArIpZCCMNIPsUjtC2ZTocgxgHfKTJrCWI8cwWP3sT
 bu0Sms6OGja+T4fa/BqhLWOveg1x2HBU9vfgd1Wv33HcEzpc0IfJTu+LGpiXD/bmyxRB Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frs78gek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:39 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK36tG181632
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:39 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35frs78ge2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:13:39 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK7ZA1021512;
        Wed, 16 Dec 2020 20:13:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8evkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:13:37 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCK5933489186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DFB442042;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 008BB4204B;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 01/12] lib/x86: fix page.h to include the generic header
Date:   Wed, 16 Dec 2020 21:11:49 +0100
Message-Id: <20201216201200.255172-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=934 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bring x86 in line with the other architectures and include the generic header
at asm-generic/page.h .
This provides the macros PAGE_SHIFT, PAGE_SIZE, PAGE_MASK, virt_to_pfn, and
pfn_to_virt.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

