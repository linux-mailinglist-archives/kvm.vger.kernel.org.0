Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F721506DA
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgBCNUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728296AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DEQSS066251
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxgjwgpx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:08 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DF45f069591
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxgjwgpwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:07 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DHHpo030453;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2xw0y6da4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK4lA39977366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:04 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25FA428078;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2215728073;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 09/37] KVM: s390: protvirt: Add KVM api documentation
Date:   Mon,  3 Feb 2020 08:19:29 -0500
Message-Id: <20200203131957.383915-10-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Add documentation for KVM_CAP_S390_PROTECTED capability and the
KVM_S390_PV_COMMAND and KVM_S390_PV_COMMAND_VCPU ioctls.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.txt | 62 ++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 73448764f544..a73fdae40e26 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4204,6 +4204,61 @@ the clear cpu reset definition in the POP. However, the cpu is not put
 into ESA mode. This reset is a superset of the initial reset.
 
 
+4.125 KVM_S390_PV_COMMAND
+
+Capability: KVM_CAP_S390_PROTECTED
+Architectures: s390
+Type: vm ioctl
+Parameters: struct kvm_pv_cmd
+Returns: 0 on success, < 0 on error
+
+struct kvm_pv_cmd {
+	__u32	cmd;	/* Command to be executed */
+	__u16	rc;	/* Ultravisor return code */
+	__u16	rrc;	/* Ultravisor return reason code */
+	__u64	data;	/* Data or address */
+};
+
+cmd values:
+KVM_PV_VM_CREATE
+Allocate memory and register the VM with the Ultravisor, thereby
+donating memory to the Ultravisor making it inaccessible to KVM.
+
+KVM_PV_VM_DESTROY
+Unregisters the VM from the Ultravisor and frees memory that was
+donated, so the kernel can use it again. All registered VCPUs have to
+be unregistered beforehand and all memory has to be exported or
+shared.
+
+KVM_PV_VM_SET_SEC_PARMS
+Pass the image header from VM memory to the Ultravisor in preparation
+of image unpacking and verification.
+
+KVM_PV_VM_UNPACK
+Unpack (protect and decrypt) a page of the encrypted boot image.
+
+KVM_PV_VM_VERIFY
+Verify the integrity of the unpacked image. Only if this succeeds, KVM
+
+is allowed to start protected VCPUs.
+
+4.126 KVM_S390_PV_COMMAND_VCPU
+
+Capability: KVM_CAP_S390_PROTECTED
+Architectures: s390
+Type: vcpu ioctl
+Parameters: struct kvm_pv_cmd
+Returns: 0 on success, < 0 on error
+
+cmd values:
+KVM_PV_VCPU_CREATE
+Allocate memory and register a VCPU with the Ultravisor, thereby
+donating memory to the Ultravisor making it inaccessible to KVM.
+
+KVM_PV_VCPU_DESTROY
+Unregisters the VCPU from the Ultravisor and frees memory that was
+donated, so the kernel can use it again.
+
 5. The kvm_run structure
 ------------------------
 
@@ -5439,3 +5494,10 @@ Architectures: s390
 
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
2.24.0

