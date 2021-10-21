Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB3F4365FD
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhJUP0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:26:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231239AbhJUP0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:26:06 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEfcme001118;
        Thu, 21 Oct 2021 11:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UDbE79JaITCm5tr6sH9UXAbC21o1b3RXWKp7lvhSo2A=;
 b=pisH+Y7pt9QkuUOQ/9XbdHXrmmfe0ve4ZdkJajOOwbdchryoGAwjc+4lpuOt5c13Kb1X
 pYDKMw6GTnEau7APIfJIwlpvw23uVfSP6di61fcog5TjXciHDVfyVk4hnBhQ4r1LevJ9
 r60fxLCnEvCln/A00gV83v0+G3fWvNaJP9/mMQwhkXrsIvJk2i/+QCbiXY4rlX7gTt9K
 ySfEtnfP4Cl7Jf/iPjEanas1h1jQHd2DcIAL44juLTHRSbVMLIEj+mN6uK5OxM577a0i
 E84Z3MhCSKhgmpKs38p9B08n0pHoiGjuZ4HRshCQLv9DVHnJ0ls88Vu8YoOavRLBrVeV Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu7nedc45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:47 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LENSrE001380;
        Thu, 21 Oct 2021 11:23:47 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bu7nedc3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:23:46 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF4APZ028090;
        Thu, 21 Oct 2021 15:23:45 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 3bqpccyq5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:23:45 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LFNiX234603334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 15:23:44 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FDCCBE061;
        Thu, 21 Oct 2021 15:23:44 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A89BBE05D;
        Thu, 21 Oct 2021 15:23:42 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com.com (unknown [9.160.98.118])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:23:42 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v17 00/15] s390/vfio-ap: dynamic configuration support
Date:   Thu, 21 Oct 2021 11:23:17 -0400
Message-Id: <20211021152332.70455-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uuMO5yubFNvptv1sMbAbQHMKUr5bIH0r
X-Proofpoint-GUID: sZBQoONvjwkEOxWq9gNhafbSYSBi0WmA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 malwarescore=0
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current design for AP pass-through does not support making dynamic
changes to the AP matrix of a running guest resulting in a few
deficiencies this patch series is intended to mitigate:

1. Adapters, domains and control domains can not be added to or removed
    from a running guest. In order to modify a guest's AP configuration,
    the guest must be terminated; only then can AP resources be assigned
    to or unassigned from the guest's matrix mdev. The new AP
    configuration becomes available to the guest when it is subsequently
    restarted.

2. The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask interfaces can
    be modified by a root user without any restrictions. A change to
    either mask can result in AP queue devices being unbound from the
    vfio_ap device driver and bound to a zcrypt device driver even if a
    guest is using the queues, thus giving the host access to the guest's
    private crypto data and vice versa.

3. The APQNs derived from the Cartesian product of the APIDs of the
    adapters and APQIs of the domains assigned to a matrix mdev must
    reference an AP queue device bound to the vfio_ap device driver. The
    AP architecture allows assignment of AP resources that are not
    available to the system, so this artificial restriction is not
    compliant with the architecture.

4. The AP configuration profile can be dynamically changed for the linux
    host after a KVM guest is started. For example, a new domain can be
    dynamically added to the configuration profile via the SE or an HMC
    connected to a DPM enabled lpar. Likewise, AP adapters can be
    dynamically configured (online state) and deconfigured (standby state)
    using the SE, an SCLP command or an HMC connected to a DPM enabled
    lpar. This can result in inadvertent sharing of AP queues between the
    guest and host.

5. A root user can manually unbind an AP queue device representing a
    queue in use by a KVM guest via the vfio_ap device driver's sysfs
    unbind attribute. In this case, the guest will be using a queue that
    is not bound to the driver which violates the device model.

This patch series introduces the following changes to the current design
to alleviate the shortcomings described above as well as to implement
more of the AP architecture:

1. A root user will be prevented from making edits to the AP bus's
    /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the change would transfer
    ownership of an APQN from the vfio_ap device driver to a zcrypt driver
    while the APQN is assigned to a matrix mdev.

2. Allow a root user to hot plug/unplug AP adapters, domains and control
    domains for a KVM guest using the matrix mdev via its sysfs
    assign/unassign attributes.

4. Allow assignment of an AP adapter or domain to a matrix mdev even if
    it results in assignment of an APQN that does not reference an AP
    queue device bound to the vfio_ap device driver, as long as the APQN
    is not reserved for use by the default zcrypt drivers (also known as
    over-provisioning of AP resources). Allowing over-provisioning of AP
    resources better models the architecture which does not preclude
    assigning AP resources that are not yet available in the system. Such
    APQNs, however, will not be assigned to the guest using the matrix
    mdev; only APQNs referencing AP queue devices bound to the vfio_ap
    device driver will actually get assigned to the guest.

5. Handle dynamic changes to the AP device model.

1. Rationale for changes to AP bus's apmask/aqmask interfaces:
----------------------------------------------------------
Due to the extremely sensitive nature of cryptographic data, it is
imperative that great care be taken to ensure that such data is secured.
Allowing a root user, either inadvertently or maliciously, to configure
these masks such that a queue is shared between the host and a guest is
not only avoidable, it is advisable. It was suggested that this scenario
is better handled in user space with management software, but that does
not preclude a malicious administrator from using the sysfs interfaces
to gain access to a guest's crypto data. It was also suggested that this
scenario could be avoided by taking access to the adapter away from the
guest and zeroing out the queues prior to the vfio_ap driver releasing the
device; however, stealing an adapter in use from a guest as a by-product
of an operation is bad and will likely cause problems for the guest
unnecessarily. It was decided that the most effective solution with the
least number of negative side effects is to prevent the situation at the
source.

2. Rationale for hot plug/unplug using matrix mdev sysfs interfaces:
----------------------------------------------------------------
Allowing a user to hot plug/unplug AP resources using the matrix mdev
sysfs interfaces circumvents the need to terminate the guest in order to
modify its AP configuration. Allowing dynamic configuration makes
reconfiguring a guest's AP matrix much less disruptive.

3. Rationale for allowing over-provisioning of AP resources:
-----------------------------------------------------------
Allowing assignment of AP resources to a matrix mdev and ultimately to a
guest better models the AP architecture. The architecture does not
preclude assignment of unavailable AP resources. If a queue subsequently
becomes available while a guest using the matrix mdev to which its APQN
is assigned, the guest will be given access to it. If an APQN
is dynamically unassigned from the underlying host system, it will
automatically become unavailable to the guest.

Change log v16-v17:
------------------
* Introduced a new patch (patch 1) to remove the setting of the pqap hook
  in the group notifier callback. It is now set when the vfio_ap device
  driver is loaded.

* Patch 6:
    - Split the filtering of the APQNs and the control domains into
      two functions and consolidated the vfio_ap_mdev_refresh_apcb and
      vfio_ap_mdev_filter_apcb into one function named
      vfio_ap_mdev_filter_matrix because the matrix is actually what is
      being filtered.

    - Removed ACK by Halil Pasic because of changes above; needs re-review.

* Introduced a new patch (patch 8) to keep track of active guests.

* Patch 9 (patch 8 in v16):
    - Refactored locking to ensure KVM lock is taken before
      matrix_dev->lock when hot plugging adapters, domains and
      control domains.

    - Removed ACK by Halil because of changes above; needs re-review.

* Patch 14 (patch 13 in v16):
    - This patch has been redesigned to ensure proper locking order (i.e.,
      taking kvm->lock before matrix_dev->lock).

    - Removed Halil's Removed-by because of changes above; needs re-review.

Tony Krowiak (15):
  s390/vfio-ap: Set pqap hook when vfio_ap module is loaded
  s390/vfio-ap: use new AP bus interface to search for queue devices
  s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
  s390/vfio-ap: manage link between queue struct and matrix mdev
  s390/vfio-ap: introduce shadow APCB
  s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
  s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
  s390/vfio-ap: keep track of active guests
  s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
  s390/vfio-ap: reset queues after adapter/domain unassignment
  s390/ap: driver callback to indicate resource in use
  s390/vfio-ap: implement in-use callback for vfio_ap driver
  s390/vfio-ap: sysfs attribute to display the guest's matrix
  s390/ap: notify drivers on config changed and scan complete callbacks
  s390/vfio-ap: update docs to include dynamic config support

 Documentation/s390/vfio-ap.rst        |  492 ++++++---
 arch/s390/include/asm/kvm_host.h      |   10 +-
 arch/s390/kvm/kvm-s390.c              |    1 -
 arch/s390/kvm/priv.c                  |   45 +-
 drivers/s390/crypto/ap_bus.c          |  241 ++++-
 drivers/s390/crypto/ap_bus.h          |   16 +
 drivers/s390/crypto/vfio_ap_drv.c     |   52 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 1379 ++++++++++++++++++-------
 drivers/s390/crypto/vfio_ap_private.h |   66 +-
 9 files changed, 1714 insertions(+), 588 deletions(-)

-- 
2.31.1

