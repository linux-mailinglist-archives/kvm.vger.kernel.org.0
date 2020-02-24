Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284AF16A3AE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgBXKQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 05:16:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727183AbgBXKQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 05:16:07 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OAEcss092132
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:16:06 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yb1ar9mh1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:16:06 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 24 Feb 2020 10:16:04 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Feb 2020 10:16:01 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OAG0Po43647394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 10:16:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 344E452052;
        Mon, 24 Feb 2020 10:16:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 218B45204F;
        Mon, 24 Feb 2020 10:16:00 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D96C3E0320; Mon, 24 Feb 2020 11:15:59 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/1] KVM: s390: rstify new ioctls in api.rst
Date:   Mon, 24 Feb 2020 11:15:59 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200224101559.27405-1-borntraeger@de.ibm.com>
References: <20200224101559.27405-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20022410-0008-0000-0000-00000355E089
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022410-0009-0000-0000-00004A76F888
Message-Id: <20200224101559.27405-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=636 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We also need to rstify the new ioctls that we added in parallel to the
rstification of the kvm docs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 Documentation/virt/kvm/api.rst | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 97a72a53fa4b..ebd383fba939 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4611,35 +4611,38 @@ unpins the VPA pages and releases all the device pages that are used to
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
2.21.0

