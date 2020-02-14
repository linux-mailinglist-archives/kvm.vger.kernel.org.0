Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449B115F9C0
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgBNW2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:28:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727864AbgBNW1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:17 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMNvdU134699;
        Fri, 14 Feb 2020 17:27:16 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5jxu9k67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:16 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMOlmP136129;
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y5jxu9k5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:15 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP6HG015199;
        Fri, 14 Feb 2020 22:27:15 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 2y5bc01xfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:15 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMRB2C65798652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:11 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87530136094;
        Fri, 14 Feb 2020 22:27:11 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE872136093;
        Fri, 14 Feb 2020 22:27:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:10 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v2 10/42] KVM: s390: protvirt: Add KVM api documentation
Date:   Fri, 14 Feb 2020 17:26:26 -0500
Message-Id: <20200214222658.12946-11-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Add documentation for KVM_CAP_S390_PROTECTED capability and the
KVM_S390_PV_COMMAND and KVM_S390_PV_COMMAND_VCPU ioctls.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.rst | 69 ++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 97a72a53fa4b..cb58714fe60d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4646,6 +4646,68 @@ the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
 
+4.125 KVM_S390_PV_COMMAND
+-------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED
+:Architectures: s390
+:Type: vm ioctl
+:Parameters: struct kvm_pv_cmd
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+  };
+
+cmd values:
+
+KVM_PV_VM_CREATE
+  Allocate memory and register the VM with the Ultravisor, thereby
+  donating memory to the Ultravisor making it inaccessible to KVM.
+
+KVM_PV_VM_DESTROY
+  Deregisters the VM from the Ultravisor and frees memory that was
+  donated, so the kernel can use it again. All registered VCPUs have to
+  be unregistered beforehand and all memory has to be exported or
+  shared.
+
+KVM_PV_VM_SET_SEC_PARMS
+  Pass the image header from VM memory to the Ultravisor in
+  preparation of image unpacking and verification.
+
+KVM_PV_VM_UNPACK
+  Unpack (protect and decrypt) a page of the encrypted boot image.
+
+KVM_PV_VM_VERIFY
+  Verify the integrity of the unpacked image. Only if this succeeds,
+  KVM is allowed to start protected VCPUs.
+
+4.126 KVM_S390_PV_COMMAND_VCPU
+------------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: struct kvm_pv_cmd
+:Returns: 0 on success, < 0 on error
+
+cmd values:
+
+KVM_PV_VCPU_CREATE
+  Allocate memory and register a VCPU with the Ultravisor, thereby
+  donating memory to the Ultravisor making it inaccessible to KVM.
+
+KVM_PV_VCPU_DESTROY
+  Unregisters the VCPU from the Ultravisor and frees memory that was
+  donated, so the kernel can use it again.
+
 5. The kvm_run structure
 ========================
 
@@ -6024,3 +6086,10 @@ Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
+
+8.23 KVM_CAP_S390_PROTECTED
+
+Architecture: s390
+
+This capability indicates that KVM can start protected VMs and the
+Ultravisor has therefore been initialized.
-- 
2.25.0

