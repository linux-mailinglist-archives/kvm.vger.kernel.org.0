Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0FE5007E1
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbiDNIGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbiDNIFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:05:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0474D617;
        Thu, 14 Apr 2022 01:03:28 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23E4seL5025433;
        Thu, 14 Apr 2022 08:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L+8PjHPMiq4AQHcRLajykYL0EPB3iNidhaOlepmKopc=;
 b=RhU1Fh0VkILmuNeXW3h70dkQjqCK3KXStRrqR9TjAVAYhqQmUWo+j7ZLIHj0Dpv8LCb1
 GtWA7zHJJKyfowskF0Y4WQp88p2jxrV6jBc1BGXiLy234qupBH3GByT1he0dm8PzFo1A
 zLRciVCQ/p5M+dIEvbBBglslZJJCHzkIEmcvnV1yMqYs0ON7GnZJkB29KcC6GUz3jNFl
 hysdqI+/3E+lK8HryI+waZvGLP+i3zCliAKSl8X7MfKOMcjGJ/soEJgeKj+mUPb9bu7z
 KpYpHXNgik+IMgb1mMxDdl1LAuCMLJHSZKJV5u72apaGUouWfkt30gjJ6BT6vD1q3nPB 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fed0kk9wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:28 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23E7xaBX002307;
        Thu, 14 Apr 2022 08:03:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fed0kk9w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23E7mA0O006046;
        Thu, 14 Apr 2022 08:03:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8yy6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 08:03:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23E83Mqf32637314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 08:03:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 384A8AE056;
        Thu, 14 Apr 2022 08:03:22 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC4F2AE04D;
        Thu, 14 Apr 2022 08:03:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.1.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Apr 2022 08:03:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 08/19] KVM: s390: pv: clear the state without memset
Date:   Thu, 14 Apr 2022 10:02:59 +0200
Message-Id: <20220414080311.1084834-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MJ_dyZ6cd46YTlxMBm3QqBG6lCfxLyyd
X-Proofpoint-GUID: xD1JcWtSKXCAOzItd4-GR5IoJZSDDriG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_01,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 mlxlogscore=872 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140040
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not use memset to clean the whole struct kvm_s390_pv; instead,
explicitly clear the fields that need to be cleared.

Upcoming patches will introduce new fields in the struct kvm_s390_pv
that will not need to be cleared.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 9e900ce7387d..76ef33a277d3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,6 +16,14 @@
 #include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
+static void kvm_s390_clear_pv_state(struct kvm *kvm)
+{
+	kvm->arch.pv.handle = 0;
+	kvm->arch.pv.guest_len = 0;
+	kvm->arch.pv.stor_base = 0;
+	kvm->arch.pv.stor_var = NULL;
+}
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc;
@@ -110,7 +118,7 @@ static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
 	vfree(kvm->arch.pv.stor_var);
 	free_pages(kvm->arch.pv.stor_base,
 		   get_order(uv_info.guest_base_stor_len));
-	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+	kvm_s390_clear_pv_state(kvm);
 }
 
 static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
-- 
2.34.1

