Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B81556D2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBGLkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727317AbgBGLkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017Bb6eK143534;
        Fri, 7 Feb 2020 06:40:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0ktsc5yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:08 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Bbglo145725;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y0ktsc5x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:06 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017Bckx6013696;
        Fri, 7 Feb 2020 11:40:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2xykca210b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:05 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be3FD35652058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:03 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4B9EAC05E;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93863AC059;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:03 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 35/35] DOCUMENTATION: Protected virtual machine introduction and IPL
Date:   Fri,  7 Feb 2020 06:39:58 -0500
Message-Id: <20200207113958.7320-36-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002070089
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
 Documentation/virt/kvm/s390-pv-boot.rst |  79 ++++++++++++++++
 Documentation/virt/kvm/s390-pv.rst      | 116 ++++++++++++++++++++++++
 MAINTAINERS                             |   1 +
 4 files changed, 198 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv-boot.rst
 create mode 100644 Documentation/virt/kvm/s390-pv.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index ada224a511fe..9a3b3fff18aa 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -10,3 +10,5 @@ KVM
    amd-memory-encryption
    cpuid
    vcpu-requests
+   s390-pv
+   s390-pv-boot
diff --git a/Documentation/virt/kvm/s390-pv-boot.rst b/Documentation/virt/kvm/s390-pv-boot.rst
new file mode 100644
index 000000000000..47814e53369a
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv-boot.rst
@@ -0,0 +1,79 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+s390 (IBM Z) Boot/IPL of Protected VMs
+======================================
+
+Summary
+-------
+Protected Virtual Machines (PVM) are not accessible by I/O or the
+hypervisor.  When the hypervisor wants to access the memory of PVMs
+the memory needs to be made accessible. When doing so, the memory will
+be encrypted.  See :doc:`s390-pv` for details.
+
+On IPL a small plaintext bootloader is started which provides
+information about the encrypted components and necessary metadata to
+KVM to decrypt the protected virtual machine.
+
+Based on this data, KVM will make the protected virtual machine known
+to the Ultravisor(UV) and instruct it to secure the memory of the PVM,
+decrypt the components and verify the data and address list hashes, to
+ensure integrity. Afterwards KVM can run the PVM via the SIE
+instruction which the UV will intercept and execute on KVM's behalf.
+
+The switch into PV mode lets us load encrypted guest executables and
+data via every available method (network, dasd, scsi, direct kernel,
+...) without the need to change the boot process.
+
+
+Diag308
+-------
+This diagnose instruction is the basis for VM IPL. The VM can set and
+retrieve IPL information blocks, that specify the IPL method/devices
+and request VM memory and subsystem resets, as well as IPLs.
+
+For PVs this concept has been extended with new subcodes:
+
+Subcode 8: Set an IPL Information Block of type 5 (information block
+for PVMs)
+Subcode 9: Store the saved block in guest memory
+Subcode 10: Move into Protected Virtualization mode
+
+The new PV load-device-specific-parameters field specifies all data,
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
+The components are for instance an encrypted kernel, kernel cmd and
+initrd. The components are decrypted by the UV.
+
+All non-decrypted data of the guest before it switches to protected
+virtualization mode are zero on first access of the PV.
+
+
+When running in protected mode some subcodes will result in exceptions
+or return error codes.
+
+Subcodes 4 and 7 will result in specification exceptions as they would
+not clear out the guest memory.
+When removing a secure VM, the UV will clear all memory, so we can't
+have non-clearing IPL subcodes.
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
index 000000000000..dbe9110dfd1e
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
+Protected virtual machines (PVM) are KVM VMs, where KVM can't access
+the VM's state like guest memory and guest registers anymore. Instead,
+the PVMs are mostly managed by a new entity called Ultravisor
+(UV). The UV provides an API that can be used by PVMs and KVM to
+request management actions.
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
+SIE behavior. A new format 4 state description has been introduced,
+where some fields have different meanings for a PVM. SIE exits are
+minimized as much as possible to improve speed and reduce exposed
+guest state.
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
+may be in r<m> from the hypervisors point of view.
+
+The Secure Instruction Data Area contains instruction storage
+data. Instruction data, i.e. data being referenced by an instruction
+like the SCCB for sclp, is moved over the SIDA. When an instruction is
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
index 56765f542244..90da412bebd9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9106,6 +9106,7 @@ L:	kvm@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
 S:	Supported
+F:	Documentation/virt/kvm/s390*
 F:	arch/s390/include/uapi/asm/kvm*
 F:	arch/s390/include/asm/gmap.h
 F:	arch/s390/include/asm/kvm*
-- 
2.24.0

