Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00743F9800
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbhH0KSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:18:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4318 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244868AbhH0KSQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:18:16 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17RA6f8n156991
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=Of1s21VPx5bUInGOwTmc/qxPsmg++P23vyzSX3d0FXg=;
 b=tQA2zSzcx3nnYXnDusJAoqXXOjj8761GMNqFZwPYGIvKSdSDMgev4eXOEQiMUobtwEwW
 OH44+1u2e0SWVoOsB7asM4TnjPG1B6bJWOWsagyOaeDVyb0BvEf9Hm/iq49AKP63RGwL
 oca19YctEklTM9YI0HefUMNr+73dbt9eE2qJdvm39O6wxXEze/cDIr8LHUoX3XWlgsyt
 rVQh4KEvMvPbii3LZJkK8Nbf0s1yBUvXJxFf3O1G0BcUqmH6TFBJ3wHrHgeMQ0HCmfE6
 dBEpm0PHlfYTrXSHUoqlA6uvHuSMwNU9iiVkH6YWFQfDeYE8R/W/+3dK1YtkxlZ1fPiA qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwfm137c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17RA6vug158460
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 06:17:27 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3apwfm136w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 06:17:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17RAD3QY013171;
        Fri, 27 Aug 2021 10:17:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3ajrrhkbbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 10:17:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17RAHL1153608822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 10:17:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47C484C046;
        Fri, 27 Aug 2021 10:17:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F01244C044;
        Fri, 27 Aug 2021 10:17:20 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 10:17:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH 0/7] Extending VIRTIO with a data transfer test
Date:   Fri, 27 Aug 2021 12:17:13 +0200
Message-Id: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m1dBdlvFf8b2fcBrTFRlXwlNxJLwfxJw
X-Proofpoint-ORIG-GUID: I6UL5-zjDQZ8XF3Fg5juACzpyORInZjs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108270063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello All,

This series implement VIRTIO-CCW transport and a VIRTIO-CCW data
transfer test.

The first patch is for allowing different architectures to use the
existing VIRTIO framework used by ARM.

We then need a callback in the CSS enumeration to select a device,
and bind it with the VIRTIO transport, patches 2 and 3.

We need to be able to disable IRQ on the processor to protect
part of the code until we are ready to receive an IRQ, and we need
to have the registration and handling of IRQ at the VIRTIO level,
this is patch 4.

To be able to receive data we extend the comon VIRTIO code with an
input routine, patch 5.

Patch 6 and 7 are the two tests patches to implement simple VIRTIO
initialization, very few tests of integrity now which can be expend
later, and a data transfer test to check various alignement and sizes
of buffers and to check the data integrity with a simple checksum.

To test the last part you will need the associated QEMU device published
in another series on the QEMU mailing list.

Regards,
Pierre

Pierre Morel (7):
  arm: virtio: move VIRTIO transport initialization inside virtio-mmio
  s390x: css: add callback for emnumeration
  s390x: virtio: CCW transport implementation
  s390x: css: registering IRQ
  virtio: implement the virtio_add_inbuf routine
  s390x: virtio tests setup
  s390x: virtio data transfer

 lib/s390x/css.h        |  24 ++-
 lib/s390x/css_lib.c    |  31 +++-
 lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
 lib/s390x/virtio-ccw.h | 111 ++++++++++++
 lib/virtio-config.h    |  30 ++++
 lib/virtio-mmio.c      |   2 +-
 lib/virtio-mmio.h      |   2 -
 lib/virtio.c           |  37 +++-
 lib/virtio.h           |   2 +
 s390x/Makefile         |   3 +
 s390x/css.c            |   2 +-
 s390x/unittests.cfg    |   4 +
 s390x/virtio_pong.c    | 315 ++++++++++++++++++++++++++++++++++
 13 files changed, 924 insertions(+), 13 deletions(-)
 create mode 100644 lib/s390x/virtio-ccw.c
 create mode 100644 lib/s390x/virtio-ccw.h
 create mode 100644 lib/virtio-config.h
 create mode 100644 s390x/virtio_pong.c

-- 
2.25.1

