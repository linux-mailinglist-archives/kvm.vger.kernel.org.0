Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE512262E8
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgGTPEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 11:04:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728469AbgGTPEL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 11:04:11 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KF3qdp100582;
        Mon, 20 Jul 2020 11:04:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d9wnqxe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:05 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KF435g101419;
        Mon, 20 Jul 2020 11:04:03 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d9wnqxbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:04:02 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KEkHHX030503;
        Mon, 20 Jul 2020 15:03:55 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 32brq8xg9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 15:03:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KF3pXH48628126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 15:03:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91B1A6E04C;
        Mon, 20 Jul 2020 15:03:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6925B6E04E;
        Mon, 20 Jul 2020 15:03:50 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.188.6])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 15:03:50 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v9 00/15]  s390/vfio-ap: dynamic configuration support
Date:   Mon, 20 Jul 2020 11:03:29 -0400
Message-Id: <20200720150344.24488-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 suspectscore=3 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200104
Sender: kvm-owner@vger.kernel.org
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

1. A root user will be prevented from making changes to the AP bus's
   /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the ownership of an APQN
   changes from the vfio_ap device driver to a zcrypt driver when the
   APQN is assigned to a matrix mdev.

2. Allow a root user to hot plug/unplug AP adapters, domains and control
   domains using the matrix mdev's assign/unassign attributes.

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

Change log v8-v9:
----------------
* Fixed errors flagged by the kernel test robot

* Fixed issue with guest losing queues when a new queue is probed due to
  manual bind operation.

Change log v7-v8:
----------------
* Now logging a message when an attempt to reserve APQNs for the zcrypt
  drivers will result in taking a queue away from a KVM guest to provide
  the sysadmin a way to ascertain why the sysfs operation failed.

* Created locked and unlocked versions of the ap_parse_mask_str() function.

* Now using new interface provided by an AP bus patch -
  s390/ap: introduce new ap function ap_get_qdev() - to retrieve
  struct ap_queue representing an AP queue device. This patch is not a
  part of this series but is a prerequisite for this series. 

Change log v6-v7:
----------------
* Added callbacks to AP bus:
  - on_config_changed: Notifies implementing drivers that
    the AP configuration has changed since last AP device scan.
  - on_scan_complete: Notifies implementing drivers that the device scan
    has completed.
  - implemented on_config_changed and on_scan_complete callbacks for
    vfio_ap device driver.
  - updated vfio_ap device driver's probe and remove callbacks to handle
    dynamic changes to the AP device model. 
* Added code to filter APQNs when assigning AP resources to a KVM guest's
  CRYCB

Change log v5-v6:
----------------
* Fixed a bug in ap_bus.c introduced with patch 2/7 of the v5 
  series. Harald Freudenberer pointed out that the mutex lock
  for ap_perms_mutex in the apmask_store and aqmask_store functions
  was not being freed. 

* Removed patch 6/7 which added logging to the vfio_ap driver
  to expedite acceptance of this series. The logging will be introduced
  with a separate patch series to allow more time to explore options
  such as DBF logging vs. tracepoints.

* Added 3 patches related to ensuring that APQNs that do not reference
  AP queue devices bound to the vfio_ap device driver are not assigned
  to the guest CRYCB:

  Patch 4: Filter CRYCB bits for unavailable queue devices
  Patch 5: sysfs attribute to display the guest CRYCB
  Patch 6: update guest CRYCB in vfio_ap probe and remove callbacks

* Added a patch (Patch 9) to version the vfio_ap module.

* Reshuffled patches to allow the in_use callback implementation to
  invoke the vfio_ap_mdev_verify_no_sharing() function introduced in
  patch 2. 

Change log v4-v5:
----------------
* Added a patch to provide kernel s390dbf debug logs for VFIO AP

Change log v3->v4:
-----------------
* Restored patches preventing root user from changing ownership of
  APQNs from zcrypt drivers to the vfio_ap driver if the APQN is
  assigned to an mdev.

* No longer enforcing requirement restricting guest access to
  queues represented by a queue device bound to the vfio_ap
  device driver.

* Removed shadow CRYCB and now directly updating the guest CRYCB
  from the matrix mdev's matrix.

* Rebased the patch series on top of 'vfio: ap: AP Queue Interrupt
  Control' patches.

* Disabled bind/unbind sysfs interfaces for vfio_ap driver

Change log v2->v3:
-----------------
* Allow guest access to an AP queue only if the queue is bound to
  the vfio_ap device driver.

* Removed the patch to test CRYCB masks before taking the vCPUs
  out of SIE. Now checking the shadow CRYCB in the vfio_ap driver.

Change log v1->v2:
-----------------
* Removed patches preventing root user from unbinding AP queues from 
  the vfio_ap device driver
* Introduced a shadow CRYCB in the vfio_ap driver to manage dynamic 
  changes to the AP guest configuration due to root user interventions
  or hardware anomalies.

Harald Freudenberger (1):
  s390/zcrypt: Notify driver on config changed and scan complete
    callbacks

Tony Krowiak (14):
  s390/vfio-ap: add version vfio_ap module
  s390/vfio-ap: use new AP bus interface to search for queue devices
  s390/vfio-ap: manage link between queue struct and matrix mdev
  s390/zcrypt: driver callback to indicate resource in use
  s390/vfio-ap: implement in-use callback for vfio_ap driver
  s390/vfio-ap: introduce shadow APCB
  s390/vfio-ap: sysfs attribute to display the guest's matrix
  s390/vfio-ap: filter matrix for unavailable queue devices
  s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
  s390/vfio-ap: allow configuration of matrix mdev in use by a KVM guest
  s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
  s390/vfio-ap: handle host AP config change notification
  s390/vfio-ap: handle AP bus scan completed notification
  s390/vfio-ap: handle probe/remove not due to host AP config changes

 drivers/s390/crypto/ap_bus.c          |  323 +++++--
 drivers/s390/crypto/ap_bus.h          |   16 +
 drivers/s390/crypto/vfio_ap_drv.c     |   36 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 1216 ++++++++++++++++++++-----
 drivers/s390/crypto/vfio_ap_private.h |   23 +-
 5 files changed, 1294 insertions(+), 320 deletions(-)

-- 
2.21.1

