Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542DE4C01D3
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 20:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235109AbiBVTJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 14:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiBVTJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 14:09:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6254A15B9B0;
        Tue, 22 Feb 2022 11:09:13 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MHw4kD025841;
        Tue, 22 Feb 2022 19:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ttu9Wx/2DxK6yAj48IT3E0f7qy18HQrbKmgAWGtNA6M=;
 b=dd4iU7oPBlsMBA/k0UYNHFGm4efJLfIdzZpk3yqGVqtd0UcxF9oBJQP5TX20QvrnlJaT
 qPSkHMCU7atP7yr7zfkPsfR84W00Ay38xQs5gNGmYjoNOkRJmgjvusxb8pE9LR+0Qruj
 NaRwFEMGEwoHGpXH0d40yVf0WQVAGmue9LEQNHq6OquLAGOrp6ZYH3Ivj4GO+u2OlwIl
 oFeDW8iR93zP80bNiTApLrkjaZDree3QiHIcPnEhod4/wh2Ok96Twy86AfcatMSVthJU
 uvpHREq2lfUMB+umC9AJ45syCompHNe3g8UfKUaEoBEc5c/EhvzgKV4m0nudIXldKss5 RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed2prwepr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 19:09:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21MImXmb007733;
        Tue, 22 Feb 2022 19:09:10 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ed2prwep7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 19:09:10 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21MJ3Nrl023798;
        Tue, 22 Feb 2022 19:09:09 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3ear6attqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 19:09:09 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21MJ98vu16253460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 19:09:08 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 052EB136051;
        Tue, 22 Feb 2022 19:09:08 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E435A136055;
        Tue, 22 Feb 2022 19:09:06 +0000 (GMT)
Received: from [9.160.49.132] (unknown [9.160.49.132])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Feb 2022 19:09:06 +0000 (GMT)
Message-ID: <f01f9416-480f-67b2-18b4-c9fbb1cad45b@linux.ibm.com>
Date:   Tue, 22 Feb 2022 14:09:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 00/17] s390/vfio-ap: dynamic configuration support
Content-Language: en-US
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220215005040.52697-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7DzzYh47L80rbWR4iEqmkdH0xr8GDicS
X-Proofpoint-ORIG-GUID: Q2m-OZkWolaGUJCUVihTMzUfF6-68BeJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_06,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202220117
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PING!!

On 2/14/22 19:50, Tony Krowiak wrote:
> The current design for AP pass-through does not support making dynamic
> changes to the AP matrix of a running guest resulting in a few
> deficiencies this patch series is intended to mitigate:
>
> 1. Adapters, domains and control domains can not be added to or removed
>      from a running guest. In order to modify a guest's AP configuration,
>      the guest must be terminated; only then can AP resources be assigned
>      to or unassigned from the guest's matrix mdev. The new AP
>      configuration becomes available to the guest when it is subsequently
>      restarted.
>
> 2. The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask interfaces can
>      be modified by a root user without any restrictions. A change to
>      either mask can result in AP queue devices being unbound from the
>      vfio_ap device driver and bound to a zcrypt device driver even if a
>      guest is using the queues, thus giving the host access to the guest's
>      private crypto data and vice versa.
>
> 3. The APQNs derived from the Cartesian product of the APIDs of the
>      adapters and APQIs of the domains assigned to a matrix mdev must
>      reference an AP queue device bound to the vfio_ap device driver. The
>      AP architecture allows assignment of AP resources that are not
>      available to the system, so this artificial restriction is not
>      compliant with the architecture.
>
> 4. The AP configuration profile can be dynamically changed for the linux
>      host after a KVM guest is started. For example, a new domain can be
>      dynamically added to the configuration profile via the SE or an HMC
>      connected to a DPM enabled lpar. Likewise, AP adapters can be
>      dynamically configured (online state) and deconfigured (standby state)
>      using the SE, an SCLP command or an HMC connected to a DPM enabled
>      lpar. This can result in inadvertent sharing of AP queues between the
>      guest and host.
>
> 5. A root user can manually unbind an AP queue device representing a
>      queue in use by a KVM guest via the vfio_ap device driver's sysfs
>      unbind attribute. In this case, the guest will be using a queue that
>      is not bound to the driver which violates the device model.
>
> This patch series introduces the following changes to the current design
> to alleviate the shortcomings described above as well as to implement
> more of the AP architecture:
>
> 1. A root user will be prevented from making edits to the AP bus's
>      /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the change would transfer
>      ownership of an APQN from the vfio_ap device driver to a zcrypt driver
>      while the APQN is assigned to a matrix mdev.
>
> 2. Allow a root user to hot plug/unplug AP adapters, domains and control
>      domains for a KVM guest using the matrix mdev via its sysfs
>      assign/unassign attributes.
>
> 4. Allow assignment of an AP adapter or domain to a matrix mdev even if
>      it results in assignment of an APQN that does not reference an AP
>      queue device bound to the vfio_ap device driver, as long as the APQN
>      is not reserved for use by the default zcrypt drivers (also known as
>      over-provisioning of AP resources). Allowing over-provisioning of AP
>      resources better models the architecture which does not preclude
>      assigning AP resources that are not yet available in the system. Such
>      APQNs, however, will not be assigned to the guest using the matrix
>      mdev; only APQNs referencing AP queue devices bound to the vfio_ap
>      device driver will actually get assigned to the guest.
>
> 5. Handle dynamic changes to the AP device model.
>
> 1. Rationale for changes to AP bus's apmask/aqmask interfaces:
> ----------------------------------------------------------
> Due to the extremely sensitive nature of cryptographic data, it is
> imperative that great care be taken to ensure that such data is secured.
> Allowing a root user, either inadvertently or maliciously, to configure
> these masks such that a queue is shared between the host and a guest is
> not only avoidable, it is advisable. It was suggested that this scenario
> is better handled in user space with management software, but that does
> not preclude a malicious administrator from using the sysfs interfaces
> to gain access to a guest's crypto data. It was also suggested that this
> scenario could be avoided by taking access to the adapter away from the
> guest and zeroing out the queues prior to the vfio_ap driver releasing the
> device; however, stealing an adapter in use from a guest as a by-product
> of an operation is bad and will likely cause problems for the guest
> unnecessarily. It was decided that the most effective solution with the
> least number of negative side effects is to prevent the situation at the
> source.
>
> 2. Rationale for hot plug/unplug using matrix mdev sysfs interfaces:
> ----------------------------------------------------------------
> Allowing a user to hot plug/unplug AP resources using the matrix mdev
> sysfs interfaces circumvents the need to terminate the guest in order to
> modify its AP configuration. Allowing dynamic configuration makes
> reconfiguring a guest's AP matrix much less disruptive.
>
> 3. Rationale for allowing over-provisioning of AP resources:
> -----------------------------------------------------------
> Allowing assignment of AP resources to a matrix mdev and ultimately to a
> guest better models the AP architecture. The architecture does not
> preclude assignment of unavailable AP resources. If a queue subsequently
> becomes available while a guest using the matrix mdev to which its APQN
> is assigned, the guest will be given access to it. If an APQN
> is dynamically unassigned from the underlying host system, it will
> automatically become unavailable to the guest.
>
> Change log v17-v18:
> ------------------
> * Added a new document, Documentation/s390/vfio-ap-locking.rst to describe
>    the locking design for this series. This included a patch for adding the
>    new doc to the MAITAINERS file for the VFIO AP maintainers.
>    
>
> * Added Reviewed-by for Halil in patch 6
>
> * Restore filtering in the queue remove callback. (Halil)
>
> * Added patch s390/vfio-ap: hot unplug of AP devices when mdev removed to
>    unplug all AP devices from the guest when the mdev is removed.
>
> * Split patch 9 (s390/vfio-ap: allow hot plug/unplug of AP resources using
>    mdev device) into xx patches:
>    - allow hot plug/unplug of AP devices when assigned/unassigned
>
> * Replaced v17 patch 08/15, s390/vfio-ap: keep track of active guests with
>    s390/vfio-ap: introduce new mutex to control access to the KVM pointer.
>    No longer tracking guests with a list of struct ap_guest objects. Added a
>    global mutex called kvm_lock which must be held whenever the kvm->lock is
>    taken. (Halil)
>
> * Changed signature of the filtering function to limit the APQNs
>    examined. This change resulted in a cascade of changes to patches 5, 8
>    and 12. (Halil)
>
> * Removed v17 patch 01/15 (s390/vfio-ap: Set pqap hook when vfio_ap module
>    is loaded). (Halil, Jason).
>
> * Split patch 14 (notify drivers on config changed and scan complete
>    callbacks) into two patches: One to make the AP bus changes and the other
>    to implement the callbacks in the vfio_ap device driver. This was done
>    to facilitate merging the AP bus changes separately from the vfio_ap
>    driver changes. (Harald)
>
> * Removed check of driver flags in the __verify_card_reservations and
>    __verify_queue_reservations functions in ap_bus.c to balance the
>    weighting between the default and vfio_ap drivers. (Harald)
>
>
> Tony Krowiak (17):
>    s390/ap: driver callback to indicate resource in use
>    s390/ap: notify drivers on config changed and scan complete callbacks
>    s390/vfio-ap: use new AP bus interface to search for queue devices
>    s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
>    s390/vfio-ap: manage link between queue struct and matrix mdev
>    s390/vfio-ap: introduce shadow APCB
>    s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
>    s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
>    s390/vfio-ap: introduce new mutex to control access to the KVM pointer
>    s390/vfio-ap: allow hot plug/unplug of AP devices when
>      assigned/unassigned
>    s390/vfio-ap: hot plug/unplug of AP devices when probed/removed
>    s390/vfio-ap: reset queues after adapter/domain unassignment
>    s390/vfio-ap: implement in-use callback for vfio_ap driver
>    s390/vfio-ap: sysfs attribute to display the guest's matrix
>    s390/vfio-ap: handle config changed and scan complete notification
>    s390/vfio-ap: update docs to include dynamic config support
>    s390/Docs: new doc describing lock usage by the vfio_ap device driver
>    MAINTAINERS: pick up all vfio_ap docs for VFIO AP maintainers
>
>   Documentation/s390/vfio-ap-locking.rst |  389 +++++++
>   Documentation/s390/vfio-ap.rst         |  492 ++++++---
>   MAINTAINERS                            |    2 +-
>   drivers/s390/crypto/ap_bus.c           |  226 +++-
>   drivers/s390/crypto/ap_bus.h           |   16 +
>   drivers/s390/crypto/vfio_ap_drv.c      |   71 +-
>   drivers/s390/crypto/vfio_ap_ops.c      | 1347 ++++++++++++++++++------
>   drivers/s390/crypto/vfio_ap_private.h  |   57 +-
>   8 files changed, 2058 insertions(+), 542 deletions(-)
>   create mode 100644 Documentation/s390/vfio-ap-locking.rst
>

