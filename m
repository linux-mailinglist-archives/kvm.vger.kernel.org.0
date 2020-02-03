Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C84A1506D6
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgBCNUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbgBCNUE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:04 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DEPSK066164
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:01 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxgjwgps2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:01 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DEVNk066809
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:01 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxgjwgprk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:01 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DJ95a008188;
        Mon, 3 Feb 2020 13:20:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 2xw0y6n91d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:00 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DJwem32113020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:19:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54DBB2805E;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 512022806D;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 01/37] DOCUMENTATION: protvirt: Protected virtual machine introduction
Date:   Mon,  3 Feb 2020 08:19:21 -0500
Message-Id: <20200203131957.383915-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
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

Add documentation about protected KVM guests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/s390-pv.rst | 103 +++++++++++++++++++++++++++++
 MAINTAINERS                        |   1 +
 2 files changed, 104 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv.rst

diff --git a/Documentation/virt/kvm/s390-pv.rst b/Documentation/virt/kvm/s390-pv.rst
new file mode 100644
index 000000000000..5ef7e6cc2180
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv.rst
@@ -0,0 +1,103 @@
+.. SPDX-License-Identifier: GPL-2.0
+============================
+Ultravisor and Protected VMs
+============================
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
+As a replacement for the lctl(g) and lpsw(e) instruction
+interceptions, two new interception codes have been introduced. One
+indicating that the contents of CRs 0, 6 or 14 have been changed. And
+one indicating PSW bit 13 changes.
+
+Instruction emulation
+---------------------
+With the format 4 state description for PVMs, the SIE instruction already
+interprets more instructions than it does with format 2. As it is not
+able to interpret every instruction, the SIE and the UV safeguard KVM's
+emulation inputs and outputs.
+
+Guest GRs and most of the instruction data, such as I/O data structures,
+are filtered. Instruction data is copied to and from the Secure
+Instruction Data Area. Guest GRs are put into / retrieved from the
+Interception-Data block.
+
+The Interception-Data block from the state description's offset 0x380
+contains GRs 0 - 16. Only GR values needed to emulate an instruction
+will be copied into this area.
+
+The Interception Parameters state description field still contains the
+the bytes of the instruction text, but with pre-set register values
+instead of the actual ones. I.e. each instruction always uses the same
+instruction text, in order not to leak guest instruction text.
+
+The Secure Instruction Data Area contains instruction storage
+data. Instruction data, i.e. data being referenced by an instruction
+like the SCCB for sclp, is moved over the SIDA When an instruction is
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
+is recognized for example for the store prefix instruction to provide
+the new lowcore location. On SIE reentry, any KVM data in the data
+areas is ignored, program exceptions are not injected and execution
+continues, as if no intercept had happened.
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

