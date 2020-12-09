Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4722D4BD9
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388560AbgLIUaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:30:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40172 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388549AbgLIU34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 15:29:56 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KCvbH144267;
        Wed, 9 Dec 2020 15:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=yupa4joXOPYeGTBuhmT7BcsmAz7RWT5H1phB7fpnD0s=;
 b=Gxq8aEhBg8OgCUUKAeKa4gDEXS+RqHid+Ai+3KHpcLHJOWrnT/QAKygp55kyRfpteCd6
 JqSZc7b1jSW7RFRX1TqAoOPbgwZe4GhC3WOSxqqVhNsM3q4IY+3FhyRB0n3sEzcz14D2
 UY9qLOo8qn4cDTZGm14I5zAMZ7VL7U2QthsfYksYtbxw+8WsrGaSbVpGrXDgTBlHnp2o
 7xQJwal45QZo2IHQscKu7lkDhj29c1wu8sibvKzdt7lq1Ic3T+jU7cukRzyvYuyen6ch
 NgaHUj9Dvp4BMppJSq5sP7aHhepRad0XrunD07YSXOKqkMPEzliL2nud3uYe81EWShmI kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avfffg8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:29:14 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9KQsBT001975;
        Wed, 9 Dec 2020 15:29:14 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avfffg8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:29:14 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KM7iq015859;
        Wed, 9 Dec 2020 20:29:13 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9gdxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:29:13 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9KRunZ22610650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 20:27:56 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1077B2064;
        Wed,  9 Dec 2020 20:27:56 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D626B205F;
        Wed,  9 Dec 2020 20:27:54 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 20:27:53 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
Date:   Wed,  9 Dec 2020 15:27:46 -0500
Message-Id: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=860 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Today, ISM devices are completely disallowed for vfio-pci passthrough as
QEMU will reject the device due to an (inappropriate) MSI-X check.
However, in an effort to enable ISM device passthrough, I realized that the
manner in which ISM performs block write operations is highly incompatible
with the way that QEMU s390 PCI instruction interception and
vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
devices have particular requirements in regards to the alignment, size and
order of writes performed.  Furthermore, they require that legacy/non-MIO
s390 PCI instructions are used, which is also not guaranteed when the I/O
is passed through the typical userspace channels.

As a result, this patchset proposes a new VFIO region to allow a guest to
pass certain PCI instruction intercepts directly to the s390 host kernel
PCI layer for exeuction, pinning the guest buffer in memory briefly in
order to execute the requested PCI instruction.

Matthew Rosato (4):
  s390/pci: track alignment/length strictness for zpci_dev
  vfio-pci/zdev: Pass the relaxed alignment flag
  s390/pci: Get hardware-reported max store block length
  vfio-pci/zdev: Introduce the zPCI I/O vfio region

 arch/s390/include/asm/pci.h         |   4 +-
 arch/s390/include/asm/pci_clp.h     |   7 +-
 arch/s390/pci/pci_clp.c             |   2 +
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |   6 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 160 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |   4 +
 include/uapi/linux/vfio_zdev.h      |  33 ++++++++
 8 files changed, 221 insertions(+), 3 deletions(-)

-- 
1.8.3.1

