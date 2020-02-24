Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD04816A574
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgBXLqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:46:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727494AbgBXLqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:46:24 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBfXoh069392;
        Mon, 24 Feb 2020 06:46:23 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ybu12sud9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:46:21 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBfZgj069486;
        Mon, 24 Feb 2020 06:46:18 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ybu12subf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:46:17 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZ9Im006950;
        Mon, 24 Feb 2020 11:41:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 2yaux6fvj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:15 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfDBd45613494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 313F128058;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 202FE2805E;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:13 +0000 (GMT)
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
Subject: [PATCH v4 33/36] DOCUMENTATION: Protected virtual machine introduction and IPL
Date:   Mon, 24 Feb 2020 06:41:04 -0500
Message-Id: <20200224114107.4646-34-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Add documentation about protected KVM guests and description of changes
that are necessary to move a KVM VM into Protected Virtualization mode.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[borntraeger@de.ibm.com: fixing and conversion to rst]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/index.rst        |   2 +
 Documentation/virt/kvm/s390-pv-boot.rst |  83 +++++++++++++++++
 Documentation/virt/kvm/s390-pv.rst      | 116 ++++++++++++++++++++++++
 MAINTAINERS                             |   1 +
 4 files changed, 202 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index 774deaebf7fa..dcc252634cf9 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -18,6 +18,8 @@ KVM
    nested-vmx
    ppc-pv
    s390-diag
+   s390-pv
+   s390-pv-boot
    timekeeping
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
new file mode 100644
index 000000000000..b762df206ab7
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv-boot.rst
@@ -0,0 +1,83 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+s390 (IBM Z) Boot/IPL of Protected VMs
+======================================
+
+Summary
+-------
+The memory of Protected Virtual Machines (PVMs) is not accessible to
+I/O or the hypervisor. In those cases where the hypervisor needs to
+access the memory of a PVM, that memory must be made accessible.
+Memory made accessible to the hypervisor will be encrypted. See
+:doc:`s390-pv` for details."
+
+On IPL (boot) a small plaintext bootloader is started, which provides
+information about the encrypted components and necessary metadata to
+KVM to decrypt the protected virtual machine.
+
+Based on this data, KVM will make the protected virtual machine known
+to the Ultravisor(UV) and instruct it to secure the memory of the PVM,
+decrypt the components and verify the data and address list hashes, to
+ensure integrity. Afterwards KVM can run the PVM via the SIE
+instruction which the UV will intercept and execute on KVM's behalf.
+
+As the guest image is just like an opaque kernel image that does the
+switch into PV mode itself, the user can load encrypted guest
+executables and data via every available method (network, dasd, scsi,
+direct kernel, ...) without the need to change the boot process.
+
+
+Diag308
+-------
+This diagnose instruction is the basic mechanism to handle IPL and
+related operations for virtual machines. The VM can set and retrieve
+IPL information blocks, that specify the IPL method/devices and
+request VM memory and subsystem resets, as well as IPLs.
+
+For PVMs this concept has been extended with new subcodes:
+
+Subcode 8: Set an IPL Information Block of type 5 (information block
+for PVMs)
+Subcode 9: Store the saved block in guest memory
+Subcode 10: Move into Protected Virtualization mode
+
+The new PV load-device-specific-parameters field specifies all data
+that is necessary to move into PV mode.
+
+* PV Header origin
+* PV Header length
+* List of Components composed of
+   * AES-XTS Tweak prefix
+   * Origin
+   * Size
+
+The PV header contains the keys and hashes, which the UV will use to
+decrypt and verify the PV, as well as control flags and a start PSW.
+
+The components are for instance an encrypted kernel, kernel parameters
+and initrd. The components are decrypted by the UV.
+
+After the initial import of the encrypted data, all defined pages will
+contain the guest content. All non-specified pages will start out as
+zero pages on first access.
+
+
+When running in protected virtualization mode, some subcodes will result in
+exceptions or return error codes.
+
+Subcodes 4 and 7, which specify operations that do not clear the guest
+memory, will result in specification exceptions. This is because the
+UV will clear all memory when a secure VM is removed, and therefore
+non-clearing IPL subcodes are not allowed."
+
+Subcodes 8, 9, 10 will result in specification exceptions.
+Re-IPL into a protected mode is only possible via a detour into non
+protected mode.
+
+Keys
+----
+Every CEC will have a unique public key to enable tooling to build
+encrypted images.
+See  `s390-tools <https://github.com/ibm-s390-tools/s390-tools/>`_
+for the tooling.
diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
new file mode 100644
index 000000000000..27fe03eaeaad
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv.rst
@@ -0,0 +1,116 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================================
+s390 (IBM Z) Ultravisor and Protected VMs
+=========================================
+
+Summary
+-------
+Protected virtual machines (PVM) are KVM VMs that do not allow KVM to
+access VM state like guest memory or guest registers. Instead, the
+PVMs are mostly managed by a new entity called Ultravisor (UV). The UV
+provides an API that can be used by PVMs and KVM to request management
+actions.
+
+Each guest starts in the non-protected mode and then may make a
+request to transition into protected mode. On transition, KVM
+registers the guest and its VCPUs with the Ultravisor and prepares
+everything for running it.
+
+The Ultravisor will secure and decrypt the guest's boot memory
+(i.e. kernel/initrd). It will safeguard state changes like VCPU
+starts/stops and injected interrupts while the guest is running.
+
+As access to the guest's state, such as the SIE state description, is
+normally needed to be able to run a VM, some changes have been made in
+the behavior of the SIE instruction. A new format 4 state description
+has been introduced, where some fields have different meanings for a
+PVM. SIE exits are minimized as much as possible to improve speed and
+reduce exposed guest state.
+
+
+Interrupt injection
+-------------------
+Interrupt injection is safeguarded by the Ultravisor. As KVM doesn't
+have access to the VCPUs' lowcores, injection is handled via the
+format 4 state description.
+
+Machine check, external, IO and restart interruptions each can be
+injected on SIE entry via a bit in the interrupt injection control
+field (offset 0x54). If the guest cpu is not enabled for the interrupt
+at the time of injection, a validity interception is recognized. The
+format 4 state description contains fields in the interception data
+block where data associated with the interrupt can be transported.
+
+Program and Service Call exceptions have another layer of
+safeguarding; they can only be injected for instructions that have
+been intercepted into KVM. The exceptions need to be a valid outcome
+of an instruction emulation by KVM, e.g. we can never inject a
+addressing exception as they are reported by SIE since KVM has no
+access to the guest memory.
+
+
+Mask notification interceptions
+-------------------------------
+In order to be notified when a PVM enables a certain class of
+interrupt, KVM cannot intercept lctl(g) and lpsw(e) anymore. As a
+replacement, two new interception codes have been introduced: One
+indicating that the contents of CRs 0, 6, or 14 have been changed,
+indicating different interruption subclasses; and one indicating that
+PSW bit 13 has been changed, indicating that a machine check
+intervention was requested and those are now enabled.
+
+Instruction emulation
+---------------------
+With the format 4 state description for PVMs, the SIE instruction already
+interprets more instructions than it does with format 2. It is not able
+to interpret every instruction, but needs to hand some tasks to KVM;
+therefore, the SIE and the ultravisor safeguard emulation inputs and outputs.
+
+The control structures associated with SIE provide the Secure
+Instruction Data Area (SIDA), the Interception Parameters (IP) and the
+Secure Interception General Register Save Area.  Guest GRs and most of
+the instruction data, such as I/O data structures, are filtered.
+Instruction data is copied to and from the Secure Instruction Data
+Area (SIDA) when needed.  Guest GRs are put into / retrieved from the
+Secure Interception General Register Save Area.
+
+Only GR values needed to emulate an instruction will be copied into this
+save area and the real register numbers will be hidden.
+
+The Interception Parameters state description field still contains the
+the bytes of the instruction text, but with pre-set register values
+instead of the actual ones. I.e. each instruction always uses the same
+instruction text, in order not to leak guest instruction text.
+This also implies that the register content that a guest had in r<n>
+may be in r<m> from the hypervisor's point of view.
+
+The Secure Instruction Data Area contains instruction storage
+data. Instruction data, i.e. data being referenced by an instruction
+like the SCCB for sclp, is moved via the SIDA. When an instruction is
+intercepted, the SIE will only allow data and program interrupts for
+this instruction to be moved to the guest via the two data areas
+discussed before. Other data is either ignored or results in validity
+interceptions.
+
+
+Instruction emulation interceptions
+-----------------------------------
+There are two types of SIE secure instruction intercepts: the normal
+and the notification type. Normal secure instruction intercepts will
+make the guest pending for instruction completion of the intercepted
+instruction type, i.e. on SIE entry it is attempted to complete
+emulation of the instruction with the data provided by KVM. That might
+be a program exception or instruction completion.
+
+The notification type intercepts inform KVM about guest environment
+changes due to guest instruction interpretation. Such an interception
+is recognized, for example, for the store prefix instruction to provide
+the new lowcore location. On SIE reentry, any KVM data in the data areas
+is ignored and execution continues as if the guest instruction had
+completed. For that reason KVM is not allowed to inject a program
+interrupt.
+
+Links
+-----
+`KVM Forum 2019 presentation <https://static.sched.com/hosted_files/kvmforum2019/3b/ibm_protected_vms_s390x.pdf>`_
diff --git a/MAINTAINERS b/MAINTAINERS
index a0d86490c2c6..97a70647c93a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9209,6 +9209,7 @@ L:	kvm@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
 S:	Supported
+F:	Documentation/virt/kvm/s390*
 F:	arch/s390/include/uapi/asm/kvm*
 F:	arch/s390/include/asm/gmap.h
 F:	arch/s390/include/asm/kvm*
-- 
2.25.0

