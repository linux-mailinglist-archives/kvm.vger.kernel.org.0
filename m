Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F36C1712E9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 09:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgB0IrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 03:47:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728640AbgB0IrX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Feb 2020 03:47:23 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R8id0b079392;
        Thu, 27 Feb 2020 03:47:22 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ye711ew86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 03:47:22 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01R8l2Ee118006;
        Thu, 27 Feb 2020 03:47:21 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ye711ew7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 03:47:21 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01R8is4U027674;
        Thu, 27 Feb 2020 08:47:21 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 2ydcmkkvfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Feb 2020 08:47:21 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01R8lJ0L49742178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 08:47:19 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B31112062;
        Thu, 27 Feb 2020 08:47:19 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ACE1112061;
        Thu, 27 Feb 2020 08:47:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 27 Feb 2020 08:47:19 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     borntraeger@de.ibm.com, cohuck@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v4.1 36/36] KVM: s390: protvirt: Add KVM api documentation
Date:   Thu, 27 Feb 2020 03:47:17 -0500
Message-Id: <20200227084717.13449-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <a392d135-c0aa-3513-b633-70aa6c7e88bd@de.ibm.com>
References: <a392d135-c0aa-3513-b633-70aa6c7e88bd@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_02:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Add documentation for KVM_CAP_S390_PROTECTED capability and the
KVM_S390_PV_COMMAND ioctl.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.rst | 59 ++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7505d7a6c0d8..bae90f3cd11d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4648,6 +4648,54 @@ the clear cpu reset definition in the POP. However, the cpu is not put
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
+KVM_PV_ENABLE
+  Allocate memory and register the VM with the Ultravisor, thereby
+  donating memory to the Ultravisor that will become inaccessible to
+  KVM. All existing CPUs are converted to protected ones. After this
+  command has succeeded, any CPU added via hotplug will become
+  protected during its creation as well.
+
+KVM_PV_DISABLE
+
+  Deregister the VM from the Ultravisor and reclaim the memory that
+  had been donated to the Ultravisor, making it usable by the kernel
+  again.  All registered VCPUs are converted back to non-protected
+  ones.
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
+
 5. The kvm_run structure
 ========================
 
@@ -6026,3 +6074,14 @@ Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
+
+8.23 KVM_CAP_S390_PROTECTED
+
+Architecture: s390
+
+
+This capability indicates that the Ultravisor has been initialized and
+KVM can therefore start protected VMs.
+This capability governs the KVM_S390_PV_COMMAND ioctl and the
+KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
+guests when the state change is invalid.
-- 
2.25.0

