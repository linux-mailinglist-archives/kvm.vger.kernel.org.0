Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEAB1165BE1
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgBTKk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:40:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727935AbgBTKkb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:31 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAZcLu052180;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubtb33r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAcIZZ058948;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubtb337-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAcDVm013611;
        Thu, 20 Feb 2020 10:40:28 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2y68976x1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:28 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeP4v29884880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA48111206B;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6E07112071;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:25 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v3 36/37] KVM: s390: rstify new ioctls in api.rst
Date:   Thu, 20 Feb 2020 05:40:19 -0500
Message-Id: <20200220104020.5343-37-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=798 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002200078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We also need to rstify the new ioctls that we added in parallel to the
rstification of the kvm docs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 58be7aba0db2..faca9977cbe7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4613,35 +4613,38 @@ unpins the VPA pages and releases all the device pages that are used to
 track the secure pages by hypervisor.
 
 4.122 KVM_S390_NORMAL_RESET
+---------------------------
 
-Capability: KVM_CAP_S390_VCPU_RESETS
-Architectures: s390
-Type: vcpu ioctl
-Parameters: none
-Returns: 0
+:Capability: KVM_CAP_S390_VCPU_RESETS
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0
 
 This ioctl resets VCPU registers and control structures according to
 the cpu reset definition in the POP (Principles Of Operation).
 
 4.123 KVM_S390_INITIAL_RESET
+----------------------------
 
-Capability: none
-Architectures: s390
-Type: vcpu ioctl
-Parameters: none
-Returns: 0
+:Capability: none
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0
 
 This ioctl resets VCPU registers and control structures according to
 the initial cpu reset definition in the POP. However, the cpu is not
 put into ESA mode. This reset is a superset of the normal reset.
 
 4.124 KVM_S390_CLEAR_RESET
+--------------------------
 
-Capability: KVM_CAP_S390_VCPU_RESETS
-Architectures: s390
-Type: vcpu ioctl
-Parameters: none
-Returns: 0
+:Capability: KVM_CAP_S390_VCPU_RESETS
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0
 
 This ioctl resets VCPU registers and control structures according to
 the clear cpu reset definition in the POP. However, the cpu is not put
-- 
2.25.0

