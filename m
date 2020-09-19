Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85743270EF2
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgISP2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:28:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbgISP2r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:28:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08JF33g2115289;
        Sat, 19 Sep 2020 11:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=F5IPuoRy4PpWgpmKafbX47Ict4OA/+gedW/oss+a8mw=;
 b=gGlU2o3Z4EBj991M4DTn898NEQ445s1pscwnU45peq9y8oThQsSQvpc3AO3zGrmpVKWq
 G6teYq6PqSrw8eir0nGk23XpRVKxhFBBCd5m+5lbiOtUNpsl2Rjtmu+BkERUvzyePm+A
 q6uR/Z4i0Gi1rArml53V/D3NTVNvYc5McEFpDhm6c+fNp2nLtQxPRicL14Vgr0WTGaQB
 iqqHcZejGBhsmtLkkHA0Yx7Debud0iukm9TwPyRAVF450/RTpN2unYxgHQdFBHfRgsK2
 tsS2xqVJRYArWcAoktRNWyGG2LvzafjmYkcB3Vy8zhOY6mVfPLygoPFqsMyKytRO26BP Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nk87hhby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:46 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08JFSkfM022814;
        Sat, 19 Sep 2020 11:28:46 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nk87hhbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:45 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08JFS6G6019802;
        Sat, 19 Sep 2020 15:28:44 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 33n9m8b6s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 15:28:44 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08JFScfJ60555674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Sep 2020 15:28:38 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6439BE054;
        Sat, 19 Sep 2020 15:28:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87370BE053;
        Sat, 19 Sep 2020 15:28:40 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.74.107])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Sep 2020 15:28:40 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Pass zPCI hardware information via VFIO
Date:   Sat, 19 Sep 2020 11:28:34 -0400
Message-Id: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-19_05:2020-09-16,2020-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=887 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009190131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides a means by which hardware information about the
underlying PCI device can be passed up to userspace (ie, QEMU) so that
this hardware information can be used rather than previously hard-coded
assumptions. A new VFIO region type is defined which holds this
information. 

A form of these patches saw some rounds last year but has been back-
tabled for a while.  The original work for this feature was done by Pierre
Morel. I'd like to refresh the discussion on this and get this finished up
so that we can move forward with better-supporting additional types of
PCI-attached devices.  The proposal here presents a completely different
region mapping vs the prior approach, taking inspiration from vfio info
capability chains to provide device CLP information in a way that allows 
for future expansion (new CLP features).

This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry.

Matthew Rosato (4):
  s390/pci: stash version in the zpci_dev
  s390/pci: track whether util_str is valid in the zpci_dev
  vfio-pci/zdev: define the vfio_zdev header
  vfio-pci/zdev: use a device region to retrieve zPCI information

 arch/s390/include/asm/pci.h         |   4 +-
 arch/s390/pci/pci_clp.c             |   2 +
 drivers/vfio/pci/Kconfig            |  13 ++
 drivers/vfio/pci/Makefile           |   1 +
 drivers/vfio/pci/vfio_pci.c         |   8 ++
 drivers/vfio/pci/vfio_pci_private.h |  10 ++
 drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |   5 +
 include/uapi/linux/vfio_zdev.h      | 116 +++++++++++++++++
 9 files changed, 400 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
 create mode 100644 include/uapi/linux/vfio_zdev.h

-- 
1.8.3.1

