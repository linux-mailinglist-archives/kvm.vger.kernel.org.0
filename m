Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448EE20A193
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 17:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405777AbgFYPHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 11:07:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405765AbgFYPHx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 11:07:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PF4pPJ100577;
        Thu, 25 Jun 2020 11:07:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn79rrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:50 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05PF4tID100780;
        Thu, 25 Jun 2020 11:07:50 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn79rku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:50 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05PF5jvJ008830;
        Thu, 25 Jun 2020 15:07:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 31uurtcwg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 15:07:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05PF7aCx48759278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 15:07:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 796DCAC065;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 487CDAC064;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.202.75])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 1/2] docs: kvm: add documentation for KVM_CAP_S390_DIAG318
Date:   Thu, 25 Jun 2020 11:07:23 -0400
Message-Id: <20200625150724.10021-2-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625150724.10021-1-walling@linux.ibm.com>
References: <20200625150724.10021-1-walling@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_11:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 suspectscore=8 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Documentation for the s390 DIAGNOSE 0x318 instruction handling.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 Documentation/virt/kvm/api.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 426f94582b7a..e0b4f2088c46 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6150,3 +6150,23 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+8.24 KVM_CAP_S390_DIAG318
+-------------------------
+
+:Architecture: s390
+
+This capability enables a guest to set information about its control program
+(i.e. guest kernel type and version). The information is helpful during
+system/firmware service events, providing additional data about the guest
+environments running on the machine.
+
+The information is associated with the DIAGNOSE 0x318 instruction, which sets
+an 8-byte value consisting of a one-byte Control Program Name Code (CPNC) and
+a 7-byte Control Program Version Code (CPVC). The CPNC determines what
+environment the control program is running in (e.g. Linux, z/VM...), and the
+CPVC is used for information specific to OS (e.g. Linux version, Linux
+distribution...)
+
+If this capability is available, then the CPNC and CPVC can be synchronized
+between KVM and userspace via the sync regs mechanism (KVM_SYNC_DIAG318).
-- 
2.26.2

