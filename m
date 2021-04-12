Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5FE35CABC
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbhDLQGO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241405AbhDLQGM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG48Rj078561;
        Mon, 12 Apr 2021 12:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xHJny+Jx7mTvgYtd9S473cDQZW0nMP7VIW4DoPZhF3Q=;
 b=hY+1s6x7XAh4cVjjxhaeXFJkClV027d4iqoFTgKsJy89U4jRu6dmsV1grGwycoBQ73Qh
 cA4Bm/TfDRdu1udNSFslUx64r4Hz1Avb3eqioTdm79JIK9ckhq2KsjPyxQq5IGGzgg/F
 m+W/aQa6ajr7dKFvJsVDvSDisuMJK3FjSuJmcOH+PZbxyHdbjlFyxj9T84wCycT+uLda
 dc0BgyA0VB2ZgnceEYn884T0/VBrV5zSjE7ayDMsPKsUBp/1rpJFoBnn5/4+Qywwc0K4
 7KTdKfv/dw+mEUZmNqy4Gm7JX0IeJbcsU3gXaMEO8SJAB6i06hHxqK0CCNWgTcFnb697 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushw2h96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG4FDs079232;
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushw2h77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFq9sw000898;
        Mon, 12 Apr 2021 16:05:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 37u3n8919c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5Q1g30802342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B601A4040;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31D81A404D;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:48 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E1CDDE0393; Mon, 12 Apr 2021 18:05:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 6/7] KVM: s390: split kvm_s390_real_to_abs
Date:   Mon, 12 Apr 2021 18:05:44 +0200
Message-Id: <20210412160545.231194-7-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: plUg-BG49-op1BXsHJHdY22intqwM624
X-Proofpoint-ORIG-GUID: m4siZJdG-ExosK02X7ktsVmgjcRQTS2s
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

A new function _kvm_s390_real_to_abs will apply prefixing to a real address
with a given prefix value.

The old kvm_s390_real_to_abs becomes now a wrapper around the new function.

This is needed to avoid code duplication in vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210322140559.500716-2-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.h | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index daba10f76936..7c72a5e3449f 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -16,6 +16,23 @@
 #include <linux/ptrace.h>
 #include "kvm-s390.h"
 
+/**
+ * kvm_s390_real_to_abs - convert guest real address to guest absolute address
+ * @prefix - guest prefix
+ * @gra - guest real address
+ *
+ * Returns the guest absolute address that corresponds to the passed guest real
+ * address @gra of by applying the given prefix.
+ */
+static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
+{
+	if (gra < 2 * PAGE_SIZE)
+		gra += prefix;
+	else if (gra >= prefix && gra < prefix + 2 * PAGE_SIZE)
+		gra -= prefix;
+	return gra;
+}
+
 /**
  * kvm_s390_real_to_abs - convert guest real address to guest absolute address
  * @vcpu - guest virtual cpu
@@ -27,13 +44,7 @@
 static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 						 unsigned long gra)
 {
-	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
-
-	if (gra < 2 * PAGE_SIZE)
-		gra += prefix;
-	else if (gra >= prefix && gra < prefix + 2 * PAGE_SIZE)
-		gra -= prefix;
-	return gra;
+	return _kvm_s390_real_to_abs(kvm_s390_get_prefix(vcpu), gra);
 }
 
 /**
-- 
2.30.2

