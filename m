Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B494525B4B3
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 21:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIBTrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 15:47:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726594AbgIBTq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 15:46:57 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082JhIX4136003;
        Wed, 2 Sep 2020 15:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=OwSxU4NAP7jStdtuTC+FUhSDcDea3J45JeuxRMcK9oM=;
 b=UGLT4W2aihJmJS5eEAlBU8lJHcgRkZbJ5A5XQwEn+Jg7YHZBlrQuO2Hh6aNcL806eB+b
 2Hc17+uHeSFnOTHZfde9MPcyeeQZ5wEPFXZ63w2//jJM4qWDdA4nFji0LQFgmWpbRIit
 6SziDRAe8KVPqIb4C+Wckx9PLlF+6E5OAkoqC8kloeq7CZzJaqhQONUJX3bVNAi7dhSa
 8hzLEizZBaxZFQkf0uh6J+nnYzBn07cAj4N840K1Eh8bIVD7T1z+riO+qXK9nwA/+X6T
 s8iPzp0/SnQB4lgN8cwP5Qd7bdlJqjYRmOxWuOkgSKu/SVC48sFVHERlOT6iLWnjomri GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ahswg3fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:45 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 082Jhe7L136478;
        Wed, 2 Sep 2020 15:46:44 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ahswg3fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:44 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 082JfMA8012026;
        Wed, 2 Sep 2020 19:46:43 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 337en9aejg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 19:46:43 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 082JkhQn42336556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 19:46:43 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E34F2805C;
        Wed,  2 Sep 2020 19:46:43 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95BCC2805A;
        Wed,  2 Sep 2020 19:46:40 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.10.164])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 19:46:40 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v4 0/3] vfio/pci: Restore MMIO access for s390 detached VFs
Date:   Wed,  2 Sep 2020 15:46:33 -0400
Message-Id: <1599075996-9826-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_14:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=845
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009020178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since commit abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO
access on disabled memory") VFIO now rejects guest MMIO access when the
PCI_COMMAND_MEMORY (MSE) bit is OFF.  This is however not the case for
VFs (fixed in commit ebfa440ce38b ("vfio/pci: Fix SR-IOV VF handling
with MMIO blocking")).  Furthermore, on s390 where we always run with at
least a bare-metal hypervisor (LPAR) PCI_COMMAND_MEMORY, unlike Device/
Vendor IDs and BARs, is not emulated when VFs are passed-through to the
OS independently.

Based upon Bjorn's most recent comment [1], I investigated the notion of
setting is_virtfn=1 for VFs passed-through to Linux and not linked to a
parent PF (referred to as a 'detached VF' in my prior post).  However,
we rapidly run into issues on how to treat an is_virtfn device with no
linked PF. Further complicating the issue is when you consider the guest
kernel has a passed-through VF but has CONFIG_PCI_IOV=n as in many 
locations is_virtfn checking is ifdef'd out altogether and the device is
assumed to be an independent PCI function.

The decision made by VFIO whether to require or emulate a PCI feature 
(in this case PCI_COMMAND_MEMORY) is based upon the knowledge it has 
about the device, including implicit expectations of what/is not
emulated below VFIO. (ex: is it safe to read vendor/id from config
space?) -- Our firmware layer attempts similar behavior by emulating
things such as vendor/id/BAR access - without these an unlinked VF would
not be usable. But what is or is not emulated by the layer below may be
different based upon which entity is providing the emulation (vfio,
LPAR, some other hypervisor)

So, the proposal here aims to fix the immediate issue of s390
pass-through VFs becoming suddenly unusable by vfio by using a dev_flags
bit to identify a VF feature that we know is hardwired to 0 for any
VF (PCI_COMMAND_MEMORY) and de-coupling the need for emulating
PCI_COMMAND_MEMORY from the is_virtfn flag. The exact scope of is_virtfn
and physfn for bare-metal vs guest scenarios and identifying what
features are / are not emulated by the lower-level hypervisors is a much
bigger discussion independent of this limited proposal.

Changes from v3:
- Propose a dev_flags model for the MSE bit
- Set the bit for typical iov linking
- Also set the bit for s390 VFs (linked and unlinked)
- Modify vfio-pci to look at the dev_flags bit instead of is_virtfn

[1]: https://marc.info/?l=linux-pci&m=159856041930022&w=2

Matthew Rosato (3):
  PCI/IOV: Mark VFs as not implementing MSE bit
  s390/pci: Mark all VFs as not implementing MSE bit
  vfio/pci: Decouple MSE bit checks from is_virtfn

 arch/s390/pci/pci_bus.c            |  5 +++--
 drivers/pci/iov.c                  |  1 +
 drivers/vfio/pci/vfio_pci_config.c | 20 +++++++++++++-------
 include/linux/pci.h                |  2 ++
 4 files changed, 19 insertions(+), 9 deletions(-)

-- 
1.8.3.1

