Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06F7D15A
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 00:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfGaWlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 18:41:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729565AbfGaWlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Jul 2019 18:41:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VMfls4138255;
        Wed, 31 Jul 2019 18:41:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u3h6t6cj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:48 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6VMfl7B138256;
        Wed, 31 Jul 2019 18:41:47 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u3h6t6cdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:47 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6VMeeuA016360;
        Wed, 31 Jul 2019 22:41:30 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2u0e871g1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 22:41:30 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VMfSdM39387632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 22:41:28 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 020CB28060;
        Wed, 31 Jul 2019 22:41:28 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F36C28058;
        Wed, 31 Jul 2019 22:41:27 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.130.145])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 31 Jul 2019 22:41:27 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v5 7/7] s390: vfio-ap: update documentation
Date:   Wed, 31 Jul 2019 18:41:17 -0400
Message-Id: <1564612877-7598-8-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310226
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch updates the vfio-ap documentation to include the information
below.

Changes made to the mdev matrix assignment interfaces:

* Allow assignment of APQNs that are not bound to the vfio-ap device
  driver as long as they are not owned by a zcrypt driver as identified
  in the AP bus sysfs apmask and aqmask interfaces.

* Allow assignment of an AP resource to a mediated device which is in use
  by a guest to hot plug an adapter, domain and control domain into a
  running guest.

* Allow unassignment of an AP resource from a mediated device which is in
  use by a guest to hot unplug an adapter, domain and control domain from
  a running guest.

This patch also:

* Clarifies the section on configuring the AP bus's apmask and aqmask.

* Adds sections on dynamic configuration using the SE or SCLP command.

* Adds a section on VFIO AP subsystem debug facilities

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 Documentation/s390/vfio-ap.rst | 871 ++++++++++++++++++++++++++++++-----------
 1 file changed, 645 insertions(+), 226 deletions(-)

diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/s390/vfio-ap.rst
index b5c51f7c748d..bfe75d2f88db 100644
--- a/Documentation/s390/vfio-ap.rst
+++ b/Documentation/s390/vfio-ap.rst
@@ -85,11 +85,20 @@ definitions:
   instructions include a field containing the APQN to identify the AP queue to
   which the AP command is to be sent for processing.
 
-  The AP bus will create a sysfs device for each APQN that can be derived from
-  the cross product of the AP adapter and usage domain numbers detected when the
-  AP bus module is loaded. For example, if adapters 4 and 10 (0x0a) and usage
-  domains 6 and 71 (0x47) are assigned to the LPAR, the AP bus will create the
-  following sysfs entries::
+  The AP bus creates an AP queue device in sysfs for each APQN that can be
+  derived from the Cartesian product of the adapter and usage domain numbers
+  of the adapters and domains detected when the AP bus is initialized. For
+  example, if adapters 4 and 10 (0x0a), and usage domains 6 and 71 (0x47) are
+  detected, the Cartesian product would be defined by the following table:
+
+		        04           10
+		   +-----------+-----------+
+		06 |  (04,06)  |  (0a,06)  |
+		   +-----------|-----------+
+		71 |  (04,47)  |  (0a,47)  |
+		   +-----------|-----------+
+
+  The AP bus will create the following sysfs entries:
 
     /sys/devices/ap/card04/04.0006
     /sys/devices/ap/card04/04.0047
@@ -151,10 +160,26 @@ If you recall from the description of an AP Queue, AP instructions include
 an APQN to identify the AP queue to which an AP command-request message is to be
 sent (NQAP and PQAP instructions), or from which a command-reply message is to
 be received (DQAP instruction). The validity of an APQN is defined by the matrix
-calculated from the APM and AQM; it is the cross product of all assigned adapter
-numbers (APM) with all assigned queue indexes (AQM). For example, if adapters 1
-and 2 and usage domains 5 and 6 are assigned to a guest, the APQNs (1,5), (1,6),
-(2,5) and (2,6) will be valid for the guest.
+calculated from the APM and AQM; it is the Cartesian product of all assigned
+adapter numbers (APM) with all assigned queue indexes (AQM). For example, if
+adapters 1 and 2 and usage domains 5 and 6 are assigned to a guest:
+
+
+		        05           06
+		   +-----------+-----------+
+		01 |  (01,05)  |  (01,06)  |
+		   +-----------|-----------+
+		02 |  (02,05)  |  (02,06)  |
+		   +-----------|-----------+
+
+		        01           02
+		   +-----------+-----------+
+		05 |  (01,05)  |  (02,05)  |
+		   +-----------|-----------+
+		06 |  (01,06)  |  (02,06)  |
+		   +-----------|-----------+
+
+APQNs (01,05), (01,06), (02,05) and (02,06) will be valid for the guest.
 
 The APQNs can provide secure key functionality - i.e., a private key is stored
 on the adapter card for each of its domains - so each APQN must be assigned to
@@ -248,7 +273,7 @@ reserved::
 	 +-------------------------------------------------------------+
 		     10  assign adapter/domain/control domain
 
-The process for reserving an AP queue for use by a KVM guest is:
+The process for partitioning AP queues for use by a KVM guest is:
 
 1. The administrator loads the vfio_ap device driver
 2. The vfio-ap driver during its initialization will register a single 'matrix'
@@ -454,45 +479,496 @@ the APFT facility is not installed on the guest, then the probe of device
 drivers will fail since only type 10 and newer devices can be configured for
 guest use.
 
-Example
+Creating mediated matrix devices:
+================================
+When the vfio_ap module is initialized, it creates a /sys/devices/vfio_ap/matrix
+device then registers the matrix device with the VFIO mediated device core.
+This results in creation of the following sysfs structures:
+
+   /sys/devices/vfio_ap/matrix/
+   --- [mdev_supported_types]
+   ------ [vfio_ap-passthrough]
+   --------- create
+   --------- [devices]
+
+To create a mediated matrix device that can be used by a guest to gain access
+to AP queues, a UUID must be written into the 'create' attribute interface; for
+example:
+
+   uuidgen > create
+      or
+   echo $uuid > create
+
+This will result in the creation of a subdirectory for the mediated matrix
+device in the [devices] subdirectory:
+
+   /sys/devices/vfio_ap/matrix/
+   --- [mdev_supported_types]
+   ------ [vfio_ap-passthrough]
+   --------- create
+   --------- [devices]
+   ------------ [$uuid]
+   --------------- assign_adapter
+   --------------- assign_control_domain
+   --------------- assign_domain
+   --------------- matrix
+   --------------- unassign_adapter
+   ----------------unassign_control_domain
+   ----------------unassign_domain
+
+The mediated matrix device is used to provision AP queues for a guest. When a
+guest using the mediated device is started, it will be granted access to the AP
+queues provisioned for the mediated device.
+
+Provisioning AP queues for the host and its guests:
+=====================================================
+Sharing of AP queues between the host and a guest is prohibited. To manage the
+partitioning of queues between the host and its guests, the AP bus provides two
+sysfs interfaces that specify the APQNs of the AP queues owned by the host's
+zcrypt drivers. The location of the sysfs files containing the masks are:
+
+   /sys/bus/ap/apmask
+   /sys/bus/ap/aqmask
+
+The 'apmask' is a 256-bit mask that identifies a set of AP adapter IDs (APID).
+Each bit in the mask, from left to right, corresponds to an APID from 0-255.
+
+The 'aqmask' is a 256-bit mask that identifies a set of AP queue indexes (APQI).
+Each bit in the mask, from left to right, corresponds to an APQI from 0-255.
+
+The Cartesian product of the APIDs set in the apmask and the APQIs set in the
+aqmask identify the APQNs of the AP queue devices owned by the zcrypt device
+drivers.
+
+Take, for example, the following masks:
+
+   apmask: 0x7000000000000000000000000000000000000000000000000000000000000000
+
+   aqmask: 0x0180000000000000000000000000000000000000000000000000000000000000
+
+The bits set in apmask are bits 1, 2 and 3. The bits set in aqmask are bits 7
+and 8. The Cartesian product of the bits set in the two masks is:
+
+           01           02          03
+      +-----------+-----------+-----------+
+   07 |  (01,07)  |  (02,07)  |  (03,07)  |
+      +-----------|-----------+-----------+
+   08 |  (01,08)  |  (02,08)  |  (03,08)  |
+      +-----------|-----------+-----------+
+
+The masks indicate that the queues with APQNs (01,07), (01,08), (02,07),
+(02,08), (03,07) and (03,08) are owned by zcrypt. When the AP bus
+detects an AP queue device, its APQN is checked against the set of APQNs
+derived from the apmask and aqmask. If a match is detected, the zcrypt
+device driver registered for the device type of the queue will be probed. If
+a match is not detected and the device type of the queue is CEX4 or newer,
+the vfio_ap device driver will be probed.
+
+By default, the two masks are set to give ownership of all APQNs to zcrypt.
+There are two ways the default masks can be changed:
+
+1. The sysfs mask files can be edited by echoing a string into the
+   respective sysfs mask file in one of two formats:
+
+   * An absolute hex string starting with 0x - like "0x12345678" - sets
+     the mask. If the given string is shorter than the mask, it is padded
+	 with 0s on the right; for example, specifying a mask value of 0x41 is
+	 the same as specifying::
+
+	    0x4100000000000000000000000000000000000000000000000000000000000000
+
+        Keep in mind that the mask reads from left to right, so the mask
+        above identifies device numbers 1 and 7 (01000001).
+
+	    If the string is longer than the mask, the operation is terminated with
+	    an error (EINVAL).
+
+   * Individual bits in the mask can be switched on and off by specifying
+     each bit number to be switched in a comma separated list. Each bit
+     number string must be prefixed with a ('+') or minus ('-') to indicate
+     the corresponding bit is to be switched on ('+') or off ('-'). Some
+     valid values are:
+
+        - "+0"    switches bit 0 on
+	    - "-13"   switches bit 13 off
+	    - "+0x41" switches bit 65 on
+	    - "-0xff" switches bit 255 off
+
+	 The following example:
+
+	    +0,-6,+0x47,-0xf0
+
+	 Switches bits 0 and 71 (0x47) on
+
+	 Switches bits 6 and 240 (0xf0) off
+
+	 Note that the bits not specified in the list remain as they were before
+	 the operation.
+
+2. The masks can also be changed at boot time via parameters on the kernel
+   command line like this:
+
+      ap.apmask=0xffff ap.aqmask=0x40
+
+   This would create the following masks::
+
+	   apmask:
+	   0xffff000000000000000000000000000000000000000000000000000000000000
+
+	   aqmask:
+	   0x4000000000000000000000000000000000000000000000000000000000000000
+
+A couple of nuances of this model to keep in mind are:
+
+   * All APQNs containing the APID corresponding to the unset bits in the apmask
+     will be unavailable to the host, but available to its guests.
+
+   * All APQNs containing the APQI corresponding to the unset bits in the aqmask
+     will be unavailable to the host, but available to its guests.
+
+   * Only APQNs derived from the Cartesian product of the bits set in the
+     apmask and aqmask are available to the host.
+
+Provisioning of AP queues for each guest:
+========================================
+The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask sysfs interfaces only
+specify the APQNs that are owned by the host; all other APQNs are available for
+its guests. Since sharing of AP queues is prohibited, this pool of available
+APQNs may be further provisioned amongst guests. A mediated matrix device
+is created for each guest that will require access to one or more AP queues.
+To provision APQNs for a guest, a mediated matrix device provides two sysfs
+attribute interfaces in the mediated device's subdirectory:
+
+   /sys/devices/vfio_ap/matrix/
+   --- [mdev_supported_types]
+   ------ [vfio_ap-passthrough]
+   --------- create
+   --------- [devices]
+   ------------ [$uuid]
+   --------------- assign_adapter
+   --------------- assign_domain
+   --------------- matrix
+
+   1. assign_adapter
+
+      An adapter is assigned to a mediated matrix device by echoing an adapter
+      number into the the 'assign_adapter' interface; for example, to assign
+      adapter 12:
+
+         echo 12 > assign_adapter
+         or
+         echo 0xc > assign_adapter
+
+      In order to successfully assign an adapter:
+
+      * The adapter number specified must represent a value from 0 up to the
+        maximum adapter number configured for the system. If an adapter number
+        higher than the maximum is specified, the operation will terminate with
+        an error (ENODEV).
+
+      * Each APQN that can be derived from the adapter ID and the IDs of
+        the previously assigned domains must not be reserved for use by the
+        zcrypt device drivers as specified by the /sys/bus/ap/apmask and
+        /sys/bus/ap/aqmask syfs interfaces. If any APQN is reserved, the operation
+        will terminate with an error (EADDRNOTAVAIL).
+
+      * No APQN that can be derived from the adapter ID and the IDs of the
+        previously assigned domains can be assigned to another mediated matrix
+        device. If an APQN is assigned to another mediated matrix device, the
+        operation will terminate with an error (EADDRINUSE).
+
+      Note that adapters that are currently not available to the host may be
+      assigned to the mediated device. If the adapter subsequently becomes
+      available while a guest is using the mediated device, it will automatically
+      become available to the guest.
+
+   2. assign_domain
+
+      A domain is assigned to a mediated matrix device by echoing a domain
+      number into the the 'assign_domain' interface; for example, to assign
+      domain 10:
+
+         echo 10 > assign_domain
+         or
+         echo 0xa > assign_domain
+
+      In order to successfully assign a domain:
+
+      * The domain number specified must represent a value from 0 up to the
+        maximum domain number configured for the system. If a domain number
+        higher than the maximum is specified, the operation will terminate with
+        an error (ENODEV). The maximum domain number can be determined by
+        printing the sysfs /sys/bus/ap/ap_max_domain_id attribute:
+
+           cat /sys/bus/ap/ap_max_domain_id
+
+      * Each APQN that can be derived from the domain ID and the IDs of
+        the previously assigned adapters must not be reserved for use by the
+        zcrypt device drivers as specified by the /sys/bus/ap/apmask and
+        /sys/bus/ap/aqmask syfs interfaces. If any APQN is reserved, the
+        operation will terminate with an error (EADDRNOTAVAIL).
+
+      * No APQN that can be derived from the domain ID and the IDs of the
+        previously assigned adapters can be assigned to another mediated matrix
+        device. If an APQN is assigned to another mediated matrix device, the
+        operation will terminate with an error (EADDRINUSE).
+
+      Note that only domains that are currently not owned by zcrypt may be
+      assigned to the mediated device. If the domain subsequently becomes
+      available while a guest is using the mediated device, it will
+      automatically become available to the guest.
+
+The APQNs of the AP queues provisioned for the guest are derived from the
+Cartesian product of the adapter and domain numbers assigned to the mediated
+matrix device in use by a guest. To view the APQNs provisioned for the guest,
+print the 'matrix' attribute to stdout:
+
+   cat matrix
+
+Note that ownership of an APQN can not be taken from the vfio_ap device driver
+as long as it is assigned to a mediated matrix device.
+
+Changing ownership of APQNs:
+===========================
+A change to the AP bus's /sys/bus/ap/apmask or /sys/bus/ap/aqmask always results
+in a change in ownership of one or more AP queues. Consider the following
+example:
+
+   * AP queues installed in the host:
+
+      /sys/bus/ap/devices
+      --- 01.0004
+      --- 01.0005
+      --- 01.0006
+      --- 01.0007
+
+      --- 02.0004
+      --- 02.0005
+      --- 02.0006
+      --- 02.0007
+
+      --- 03.0004
+      --- 03.0005
+      --- 03.0006
+      --- 03.0007
+
+   * The apmask and aqmask are configured as follows:
+
+      apmask: 0x7000000000000000000000000000000000000000000000000000000000000000
+      aqmask: 0x0c00000000000000000000000000000000000000000000000000000000000000
+
+      The masks specify the following:
+
+      owned by zcrypt:
+         01.0004
+         01.0005
+         02.0004
+         02.0005
+         03.0004
+         03.0005
+
+   * The matrix assigned to mediated matrix device $uuid is:
+
+      01.0006
+      01.0007
+      02.0006
+      02.0007
+      03.0006
+      03.0007
+
+If we execute the following:
+
+   echo +7 > aqmask
+
+This will result in the following new masks:
+
+   apmask: 0x7000000000000000000000000000000000000000000000000000000000000000
+   aqmask: 0x0d00000000000000000000000000000000000000000000000000000000000000
+
+   owned by zcrypt:
+      01.0004
+      01.0005
+      01.0007
+      02.0004
+      02.0005
+      02.0007
+      03.0004
+      03.0005
+      03.0007
+
+From this, we can see that ownership of APQNs 01.0007, 02.0007, and 03.0007
+changed from the vfio_ap device driver to the host zcrypt driver. In order to
+change ownership of one or more APQNs from the vfio_ap device driver to a zcrypt
+driver, none of the APQNs can be assigned to a mediated matrix device. If even
+one of the APQNs is assigned to a mediated matrix device, the operation to
+change the mask will fail with an error (EADDRINUSE). In this example, APQNs
+01.0007, 02.0007 and 03.0007 are assigned to mediated device $uuid, so the
+aqmask operation will fail.
+
+In order to free up APQNs 01.0007, 02.0007 and 03.0007 to make them available to
+zcrypt, the APQNs must first be unassigned from mediated matrix device $uuid.
+Unfortunately, the AP architecture precludes unassignment of individual APQNs,
+so we are left with the choice of either unassigning adapters 1, 2 and 3, or
+unassigning domain 7 from mediated device $uuid. Note that if an adapter is
+unassigned, then all domains within the adapter will become unavailable to the
+guest using the mediated device. In our example, unassigning adapters 1,2 and 3
+would leave a guest using mediated device $uuid without any adapters. If a
+domain is unassigned, then access to that domain within each adapter assigned to
+the mediated matrix device will become unavailable to the guest. For our
+example, if domain 7 is unassigned, that would remove access to AP queues
+01.0007, 02.0007 and 03.0007. It would, however, leave the guest with access to
+queues 01.0006, 02.0006 and 03.0006, so it would probably be better to unassign
+domain 7 lest the guest be left without access to any queues.
+
+To unassign adapters and domains from a mediated matrix device, two sysfs
+attribute interfaces are provided in the mediated device's subdirectory:
+
+   /sys/devices/vfio_ap/matrix/
+   --- [mdev_supported_types]
+   ------ [vfio_ap-passthrough]
+   --------- create
+   --------- [devices]
+   ------------ [$uuid]
+   --------------- unassign_adapter
+   --------------- unassign_domain
+
+   1. unassign_adapter
+
+      An adapter is unassigned from a mediated matrix device by echoing its
+      adapter number into the the 'unassign_adapter' interface; for example, to
+      unassign adapter 12:
+
+         echo 12 > unassign_adapter
+         or
+         echo 0xc > unassign_adapter
+
+      In order to successfully unassign an adapter:
+
+      * The adapter number specified must represent a value from 0 up to the
+        maximum adapter number configured for the system. If an adapter number
+        higher than the maximum is specified, the operation will terminate with
+        an error (ENODEV).
+
+   2. unassign_domain
+
+      A domain is unassigned from a mediated matrix device by echoing a domain
+      number into the the 'unassign_domain' interface; for example, to unassign
+      domain 10:
+
+         echo 10 > unassign_domain
+         or
+         echo 0xa > unassign_domain
+
+      In order to successfully unassign a domain:
+
+      * The domain number specified must represent a value from 0 up to the
+        maximum domain number configured for the system. If a domain number
+        higher than the maximum is specified, the operation will terminate with
+        an error (ENODEV). The maximum domain number can be determined by
+        printing the sysfs /sys/bus/ap/ap_max_domain_id attribute:
+
+           cat /sys/bus/ap/ap_max_domain_id
+
+VFIO AP device driver logs:
+==========================
+The VFIO AP device driver (/sys/bus/ap/drivers/vfio_ap) provides S390 Debug log
+files (see Documentation/s390/s390dbf.rst) for tracing events:
+
+1. The /sys/kernel/debug/s390dbf/vfio_ap/sprintf traces the binding and
+   unbinding of AP queue devices to the VFIO AP device driver. When ownership
+   of an APQN identifying an AP queue device is transferred to the VFIO AP
+   device driver, the queue device will be bound to the driver and the bind
+   event will be recorded in the debug log file if the debug level is 3 or
+   higher. Likewise, when ownership of an APQN identifying AP queue device is
+   transferred from the VFIO AP device driver, the queue device will be unbound
+   from the driver and the unbind event will be recorded in the debug log file
+   if the debug level is 3 or higher.
+
+   Keep in mind, that modifying the AP bus's apmask or aqmask may result in
+   changing ownership of multiple APQNs. If the operation is rejected because
+   one or more of the APQNs are assigned to a matrix mediated device, a debug
+   log entry will be written to identify the mediated device to which the APQN
+   is assigned if the debug level is 3 or higher.
+
+2. A /sys/kernel/debug/s390dbf/$uuid/sprintf debug log file is created for every
+   matrix mediated device that is created. This log is used to trace the
+   following types of events:
+
+   * Successful assignment and unassignment of adapters, domains and control
+     domains if the log level is 5 or greater.
+
+   * Failure to assign or unassign an adapter or domain. Failure can occur for
+     due to the fact that one or more APQNs derived from the adapter or domain
+     number being assigned and the domain or adapter numbers already assigned
+     is owned by zcrypt or assigned to another matrix mediated device. For the
+     latter case, the mediated matrix device to which each APQNs are assigned
+     will be identified in the event log entry.
+
+Each debug log has a debug level ranging from 0 to 6. Only debug entries with a
+level that is lower or equal to the actual level are written to the log. By
+default, the log level will be set to 3. This means entries logging the most
+serious errors will have a low level value whereas informational or debug
+entries will have a higher value. The default value for all VFIO AP device
+driver logs is 3.
+
+The debug level can be set by writing a level of 0 to 6 to the sysfs attribute
+files for the VFIO AP device driver, or any of the matrix mediated device debug
+logs. For example, to set the log level for the VFIO_AP device driver debug
+log:
+
+   echo 6 > /sys/kernel/debug/s390dbf/vfio_ap/level
+
+To set the log level for matrix mediated device
+6ec3e43a-86a4-49dc-9688-8524541b2416:
+
+   cd /sys/kernel/debug/s390dbf/6ec3e43a-86a4-49dc-9688-8524541b2416
+   echo 5 > level
+
+The log level for all VFIO AP subsystem logs can be set with a module parameter
+named 'dbglvl' when the vfio_ap.ko module is loaded, or at boot time. For
+example, to set the log level to 5 using the 'modprobe' command:
+
+   modprobe vfio_ap dbglvl=5
+
+The debug level can also be set at boot time by adding the following parameter
+to the kernel command line:
+
+   vfio_ap.dbglvl=5
+
+Example:
 =======
 Let's now provide an example to illustrate how KVM guests may be given
-access to AP facilities. For this example, we will show how to configure
-three guests such that executing the lszcrypt command on the guests would
-look like this:
+access to AP facilities. For this example, we will assume that adapters 4, 5
+and 6 and domains 4, 71 (0x47), 171 (0xab) and 255 (0xff) are assigned to the
+LPAR and are online. We will show how to configure three guests such that
+executing the lszcrypt command on the guests would look like this:
 
 Guest1
 ------
-=========== ===== ============
 CARD.DOMAIN TYPE  MODE
-=========== ===== ============
+------------------------------
 05          CEX5C CCA-Coproc
 05.0004     CEX5C CCA-Coproc
 05.00ab     CEX5C CCA-Coproc
 06          CEX5A Accelerator
 06.0004     CEX5A Accelerator
 06.00ab     CEX5C CCA-Coproc
-=========== ===== ============
 
 Guest2
 ------
-=========== ===== ============
 CARD.DOMAIN TYPE  MODE
-=========== ===== ============
+------------------------------
 05          CEX5A Accelerator
 05.0047     CEX5A Accelerator
 05.00ff     CEX5A Accelerator
-=========== ===== ============
 
 Guest2
 ------
-=========== ===== ============
 CARD.DOMAIN TYPE  MODE
-=========== ===== ============
+------------------------------
 06          CEX5A Accelerator
 06.0047     CEX5A Accelerator
 06.00ff     CEX5A Accelerator
-=========== ===== ============
 
 These are the steps:
 
@@ -509,7 +985,7 @@ These are the steps:
    To build the vfio_ap module, the kernel build must be configured with the
    following Kconfig elements selected:
    * IOMMU_SUPPORT
-   * S390
+   * S390step 3 in example
    * ZCRYPT
    * S390_AP_IOMMU
    * VFIO
@@ -517,124 +993,28 @@ These are the steps:
    * VFIO_MDEV_DEVICE
    * KVM
 
-   If using make menuconfig select the following to build the vfio_ap module::
-
-     -> Device Drivers
-	-> IOMMU Hardware Support
-	   select S390 AP IOMMU Support
-	-> VFIO Non-Privileged userspace driver framework
-	   -> Mediated device driver frramework
-	      -> VFIO driver for Mediated devices
-     -> I/O subsystem
-	-> VFIO support for AP devices
+   If using make menuconfig select the following to build the vfio_ap module:
+   -> Device Drivers
+      -> IOMMU Hardware Support
+         select S390 AP IOMMU Support
+      -> VFIO Non-Privileged userspace driver framework
+         -> Mediated device driver frramework
+            -> VFIO driver for Mediated devices
+   -> I/O subsystem
+      -> VFIO support for AP devices
 
 2. Secure the AP queues to be used by the three guests so that the host can not
-   access them. To secure them, there are two sysfs files that specify
-   bitmasks marking a subset of the APQN range as 'usable by the default AP
-   queue device drivers' or 'not usable by the default device drivers' and thus
-   available for use by the vfio_ap device driver'. The location of the sysfs
-   files containing the masks are::
-
-     /sys/bus/ap/apmask
-     /sys/bus/ap/aqmask
-
-   The 'apmask' is a 256-bit mask that identifies a set of AP adapter IDs
-   (APID). Each bit in the mask, from left to right (i.e., from most significant
-   to least significant bit in big endian order), corresponds to an APID from
-   0-255. If a bit is set, the APID is marked as usable only by the default AP
-   queue device drivers; otherwise, the APID is usable by the vfio_ap
-   device driver.
-
-   The 'aqmask' is a 256-bit mask that identifies a set of AP queue indexes
-   (APQI). Each bit in the mask, from left to right (i.e., from most significant
-   to least significant bit in big endian order), corresponds to an APQI from
-   0-255. If a bit is set, the APQI is marked as usable only by the default AP
-   queue device drivers; otherwise, the APQI is usable by the vfio_ap device
-   driver.
+   access them.  There is no way to secure the specific AP queues 05.0004,
+   05.0047, 05.00ab, 05.00ff, 06.0004, 06.0047, 06.00ab, and 06.00ff for use by
+   the guests, so we are left with either securing all queues on adapters 05 and
+   06, or queues 0004, 0047, 00ab and 00ff can be secured on all adapters.
 
-   Take, for example, the following mask::
-
-      0x7dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-
-    It indicates:
-
-      1, 2, 3, 4, 5, and 7-255 belong to the default drivers' pool, and 0 and 6
-      belong to the vfio_ap device driver's pool.
-
-   The APQN of each AP queue device assigned to the linux host is checked by the
-   AP bus against the set of APQNs derived from the cross product of APIDs
-   and APQIs marked as usable only by the default AP queue device drivers. If a
-   match is detected,  only the default AP queue device drivers will be probed;
-   otherwise, the vfio_ap device driver will be probed.
-
-   By default, the two masks are set to reserve all APQNs for use by the default
-   AP queue device drivers. There are two ways the default masks can be changed:
-
-   1. The sysfs mask files can be edited by echoing a string into the
-      respective sysfs mask file in one of two formats:
-
-      * An absolute hex string starting with 0x - like "0x12345678" - sets
-	the mask. If the given string is shorter than the mask, it is padded
-	with 0s on the right; for example, specifying a mask value of 0x41 is
-	the same as specifying::
-
-	   0x4100000000000000000000000000000000000000000000000000000000000000
-
-	Keep in mind that the mask reads from left to right (i.e., most
-	significant to least significant bit in big endian order), so the mask
-	above identifies device numbers 1 and 7 (01000001).
-
-	If the string is longer than the mask, the operation is terminated with
-	an error (EINVAL).
-
-      * Individual bits in the mask can be switched on and off by specifying
-	each bit number to be switched in a comma separated list. Each bit
-	number string must be prepended with a ('+') or minus ('-') to indicate
-	the corresponding bit is to be switched on ('+') or off ('-'). Some
-	valid values are:
-
-	   - "+0"    switches bit 0 on
-	   - "-13"   switches bit 13 off
-	   - "+0x41" switches bit 65 on
-	   - "-0xff" switches bit 255 off
-
-	The following example:
-
-	      +0,-6,+0x47,-0xf0
-
-	Switches bits 0 and 71 (0x47) on
-
-	Switches bits 6 and 240 (0xf0) off
-
-	Note that the bits not specified in the list remain as they were before
-	the operation.
-
-   2. The masks can also be changed at boot time via parameters on the kernel
-      command line like this:
-
-	 ap.apmask=0xffff ap.aqmask=0x40
-
-	 This would create the following masks::
-
-	    apmask:
-	    0xffff000000000000000000000000000000000000000000000000000000000000
-
-	    aqmask:
-	    0x4000000000000000000000000000000000000000000000000000000000000000
-
-	 Resulting in these two pools::
-
-	    default drivers pool:    adapter 0-15, domain 1
-	    alternate drivers pool:  adapter 16-255, domains 0, 2-255
-
-Securing the APQNs for our example
-----------------------------------
-   To secure the AP queues 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004, 06.0047,
-   06.00ab, and 06.00ff for use by the vfio_ap device driver, the corresponding
-   APQNs can either be removed from the default masks::
+   To secure all queues on adapters 05 and 05:
 
       echo -5,-6 > /sys/bus/ap/apmask
 
+   To secure queues 0004, 0047, 00ab, and 00ff on all adapters:
+
       echo -4,-0x47,-0xab,-0xff > /sys/bus/ap/aqmask
 
    Or the masks can be set as follows::
@@ -645,22 +1025,28 @@ Securing the APQNs for our example
       echo 0xf7fffffffffffffffeffffffffffffffffffffffffeffffffffffffffffffffe \
       > aqmask
 
-   This will result in AP queues 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004,
-   06.0047, 06.00ab, and 06.00ff getting bound to the vfio_ap device driver. The
-   sysfs directory for the vfio_ap device driver will now contain symbolic links
-   to the AP queue devices bound to it::
-
-     /sys/bus/ap
-     ... [drivers]
-     ...... [vfio_ap]
-     ......... [05.0004]
-     ......... [05.0047]
-     ......... [05.00ab]
-     ......... [05.00ff]
-     ......... [06.0004]
-     ......... [06.0047]
-     ......... [06.00ab]
-     ......... [06.00ff]
+   For this example, we will choose to secure queues 0004, 0047, 00ab, and 00ff
+   on all adapters. This will result in AP queues 04.0004, 04.0047, 04.00ab,
+   04.00ff, 05.0004, 05.0047, 05.00ab, 05.00ff, 06.0004, 06.0047, 06.00ab and
+   06.00ff getting bound to the vfio_ap device driver. The sysfs directory for
+   the vfio_ap device driver will now contain symbolic links to the AP queue
+   devices bound to it:
+
+   /sys/bus/ap
+   ... [drivers]
+   ...... [vfio_ap]
+   ......... [04.0004]
+   ......... [04.0047]
+   ......... [04.00ab]
+   ......... [04.00ff]
+   ......... [05.0004]
+   ......... [05.0047]
+   ......... [05.00ab]
+   ......... [05.00ff]
+   ......... [06.0004]
+   ......... [06.0047]
+   ......... [06.00ab]
+   ......... [06.00ff]
 
    Keep in mind that only type 10 and newer adapters (i.e., CEX4 and later)
    can be bound to the vfio_ap device driver. The reason for this is to
@@ -669,36 +1055,30 @@ Securing the APQNs for our example
    future and for which there are few older systems on which to test.
 
    The administrator, therefore, must take care to secure only AP queues that
-   can be bound to the vfio_ap device driver. The device type for a given AP
-   queue device can be read from the parent card's sysfs directory. For example,
-   to see the hardware type of the queue 05.0004:
+   can be bound to the vfio_ap device driver, or those queues will not get bound
+   to any driver. The device type for a given AP queue device can be read from
+   the parent card's sysfs directory. For example, to see the hardware type of
+   the queue 05.0004:
 
-     cat /sys/bus/ap/devices/card05/hwtype
+      cat /sys/bus/ap/devices/card05/hwtype
 
    The hwtype must be 10 or higher (CEX4 or newer) in order to be bound to the
    vfio_ap device driver.
 
 3. Create the mediated devices needed to configure the AP matrixes for the
-   three guests and to provide an interface to the vfio_ap driver for
-   use by the guests::
+   three guests. To create the mediated devices:
 
-     /sys/devices/vfio_ap/matrix/
-     --- [mdev_supported_types]
-     ------ [vfio_ap-passthrough] (passthrough mediated matrix device type)
-     --------- create
-     --------- [devices]
-
-   To create the mediated devices for the three guests::
+      cd /sys/devices/vfio_ap/matrix/mdev_supported_types/vfio_ap-passthrough
 
-	uuidgen > create
-	uuidgen > create
-	uuidgen > create
+      uuidgen > create
+      uuidgen > create
+      uuidgen > create
 
 	or
 
-	echo $uuid1 > create
-	echo $uuid2 > create
-	echo $uuid3 > create
+      echo $uuid1 > create
+      echo $uuid2 > create
+      echo $uuid3 > create
 
    This will create three mediated devices in the [devices] subdirectory named
    after the UUID written to the create attribute file. We call them $uuid1,
@@ -768,50 +1148,7 @@ Securing the APQNs for our example
       echo 0x47 > assign_domain
       echo 0xff > assign_domain
 
-   In order to successfully assign an adapter:
-
-   * The adapter number specified must represent a value from 0 up to the
-     maximum adapter number configured for the system. If an adapter number
-     higher than the maximum is specified, the operation will terminate with
-     an error (ENODEV).
-
-   * All APQNs that can be derived from the adapter ID and the IDs of
-     the previously assigned domains must be bound to the vfio_ap device
-     driver. If no domains have yet been assigned, then there must be at least
-     one APQN with the specified APID bound to the vfio_ap driver. If no such
-     APQNs are bound to the driver, the operation will terminate with an
-     error (EADDRNOTAVAIL).
-
-     No APQN that can be derived from the adapter ID and the IDs of the
-     previously assigned domains can be assigned to another mediated matrix
-     device. If an APQN is assigned to another mediated matrix device, the
-     operation will terminate with an error (EADDRINUSE).
-
-   In order to successfully assign a domain:
-
-   * The domain number specified must represent a value from 0 up to the
-     maximum domain number configured for the system. If a domain number
-     higher than the maximum is specified, the operation will terminate with
-     an error (ENODEV).
-
-   * All APQNs that can be derived from the domain ID and the IDs of
-     the previously assigned adapters must be bound to the vfio_ap device
-     driver. If no domains have yet been assigned, then there must be at least
-     one APQN with the specified APQI bound to the vfio_ap driver. If no such
-     APQNs are bound to the driver, the operation will terminate with an
-     error (EADDRNOTAVAIL).
-
-     No APQN that can be derived from the domain ID and the IDs of the
-     previously assigned adapters can be assigned to another mediated matrix
-     device. If an APQN is assigned to another mediated matrix device, the
-     operation will terminate with an error (EADDRINUSE).
-
-   In order to successfully assign a control domain, the domain number
-   specified must represent a value from 0 up to the maximum domain number
-   configured for the system. If a control domain number higher than the maximum
-   is specified, the operation will terminate with an error (ENODEV).
-
-5. Start Guest1::
+5. Start Guest1:
 
      /usr/bin/qemu-system-s390x ... -cpu host,ap=on,apqci=on,apft=on \
 	-device vfio-ap,sysfsdev=/sys/devices/vfio_ap/matrix/$uuid1 ...
@@ -851,16 +1188,98 @@ remove it if no guest will use it during the remaining lifetime of the linux
 host. If the mdev matrix device is removed, one may want to also reconfigure
 the pool of adapters and queues reserved for use by the default drivers.
 
-Limitations
-===========
-* The KVM/kernel interfaces do not provide a way to prevent restoring an APQN
-  to the default drivers pool of a queue that is still assigned to a mediated
-  device in use by a guest. It is incumbent upon the administrator to
-  ensure there is no mediated device in use by a guest to which the APQN is
-  assigned lest the host be given access to the private data of the AP queue
-  device such as a private key configured specifically for the guest.
+Hot plug/unplug via mdev matrix device sysfs interfaces:
+=======================================================
+If an mdev matrix device is in use by a running guest, AP resources can be
+plugged into or unplugged from the guest via the mdev device's sysfs
+assignment interfaces. Below are some examples.
+
+   To plug adapter 10 into a running guest:
+
+      echo 0xa > assign_adapter
+
+   To unplug domain 5 from a running guest:
+
+      echo 5 > unassign_domain
+
+To display the matrix of a guest using the mdev matrix device:
+
+   cat guest_matrix
+
+If you attempt to display the guest matrix when a guest is not using the
+mdev matrix device, an error will be displayed (ENODEV). Note that adapters and
+domains that are not yet available or not yet assigned to the LPAR can be
+assigned and will become available to the guest as soon as they become available
+to the host.
+
+Dynamic Changes to AP Configuration using the Support Element (SE):
+==================================================================
+The SE can be used to dynamically make the following changes to the AP
+configuration for an LPAR in which a linux host is running:
+
+   * Configure one or more adapters on
+
+     Configuring an adapter on sets its state to online, thus making it
+     available to the LPAR to which it is assigned. When an adapter is
+     configured on, it immediately becomes available to the LPAR as well as to
+     any guests using a mediated device to which the adapter is assigned.
+
+   * Configure one or more adapters off
+
+     Configuring an adapter off sets its state to standby, thus making it
+     unavailable to the LPAR to which it is assigned. When an adapter is
+     configured off, it immediately becomes unavailable to the LPAR as well as
+     to any guests using a mediated device to which the adapter is assigned.
+
+   * Add adapters or domains to the LPAR configuration
+
+     Adapters and/or domains can be assigned to an LPAR using the Change LPAR
+     Cryptographic Controls task. To make dynamic changes to the AP
+     configuration for an LPAR Running a linux guest, the online adapters
+     assigned to the LPAR must first be configured off. After performing the
+     adapter and/or domain assignments, the AP resources will automatically
+     become available to the linux host running in the LPAR as well as any
+     guests using a mediated device to which the adpaters and/or domains are
+     assigned.
+
+   * Remove adapters or domains from the LPAR configuration
+
+     Adapters and/or domains can be unassigned from an LPAR using the Change
+     LPAR Cryptographic Controls task. To make dynamic changes to the AP
+     configuration for an LPAR Running a linux guest, the online adapters
+     assigned to the LPAR must first be configured off. After performing the
+     adapter and/or domain unassignments, the AP resources will automatically
+     become unavailable to the linux host running in the LPAR as well as any
+     guests using a mediated device to which the adpaters and/or domains are
+     assigned.
+
+Dynamic Changes to the AP Configuration using the SCLP command:
+==============================================================
+The following SCLP commands may be used to dynamically configure AP adapters on
+and off:
+
+* Configure Adjunct Processor
+
+  The 'Configure Adjunct Processor' command sets an AP adapter's state to
+  online, thus making it available to the LPARs to which it is assigned. It will
+  likewise become available to any linux guest using a mediated device to which
+  the adapter is assigned.
+
+* Deconfigure Adjunct Processor
+
+  The 'Deconfigure Adjunct Processor' command sets an AP adapter's state to
+  standby, thus making it unavailable to the LPARs to which it is assigned. It
+  will likewise become unavailable to any linux guest using a mediated device to
+  which the adapter is assigned.
+
+
 
-* Dynamically modifying the AP matrix for a running guest (which would amount to
-  hot(un)plug of AP devices for the guest) is currently not supported
+Live migration:
+==============
+Live guest migration is not supported for guests using AP devices. All AP
+devices in use by the guest must be unplugged prior to initiating live
+migration (see "Hot plug/unplug via mdev matrix device sysfs interfaces" section
+above). If you are using QEMU to run your guest and it supports hot plug/unplug
+of the vfio-ap device, this would be another option (consult the QEMU
+documentation for details).
 
-* Live guest migration is not supported for guests using AP devices.
-- 
2.7.4

