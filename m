Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648E420A18F
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405705AbgFYPHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 11:07:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47738 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405309AbgFYPHk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 11:07:40 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PF3nkv129970;
        Thu, 25 Jun 2020 11:07:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ux00ckp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05PF5LNn137978;
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ux00cknm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05PF6DJk020083;
        Thu, 25 Jun 2020 15:07:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 31uurycwkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 15:07:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05PF7aPh49676772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 15:07:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3CA2AC05B;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E5B3AC066;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.202.75])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 2/2] docs: kvm: fix rst formatting
Date:   Thu, 25 Jun 2020 11:07:24 -0400
Message-Id: <20200625150724.10021-3-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625150724.10021-1-walling@linux.ibm.com>
References: <20200625150724.10021-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_10:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=8
 clxscore=1015 bulkscore=0 cotscore=-2147483648 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a little rst touch-up for docs introduced in:
 - commit 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API") and
 - commit 04ed89dc4aeb ("KVM: s390: protvirt: Add KVM api documentation")

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 Documentation/virt/kvm/api.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e0b4f2088c46..19681e96eb33 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6134,16 +6134,17 @@ in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
 
 8.22 KVM_CAP_S390_VCPU_RESETS
+-----------------------------
 
-Architectures: s390
+:Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
 
 8.23 KVM_CAP_S390_PROTECTED
+---------------------------
 
-Architecture: s390
-
+:Architecture: s390
 
 This capability indicates that the Ultravisor has been initialized and
 KVM can therefore start protected VMs.
-- 
2.26.2

