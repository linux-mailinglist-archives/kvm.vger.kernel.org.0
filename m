Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4792BDF85
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406878AbfIYN4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:56:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406357AbfIYN4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Sep 2019 09:56:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8PDq2HA096474
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:56:34 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v88prtevk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:56:34 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 25 Sep 2019 14:56:32 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Sep 2019 14:56:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8PDuT1j31850608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 13:56:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84454A405B;
        Wed, 25 Sep 2019 13:56:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBC47A4062;
        Wed, 25 Sep 2019 13:56:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Sep 2019 13:56:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] s390x: Add missing include in smp.h
Date:   Wed, 25 Sep 2019 09:56:22 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925135623.9740-1-frankja@linux.ibm.com>
References: <20190925135623.9740-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092513-0016-0000-0000-000002B07C20
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092513-0017-0000-0000-000033114487
Message-Id: <20190925135623.9740-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=962 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909250140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

smp.h uses struct lowcore and struct psw, which are defined in
asm/arch_def.h

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/smp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index 4476c31..ce63a89 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -12,6 +12,8 @@
 #ifndef SMP_H
 #define SMP_H
 
+#include <asm/arch_def.h>
+
 struct cpu {
 	struct lowcore *lowcore;
 	uint64_t *stack;
-- 
2.20.1

