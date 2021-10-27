Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04C943CC17
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbhJ0O1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 10:27:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238437AbhJ0O1b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 10:27:31 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19REMPWQ026724;
        Wed, 27 Oct 2021 14:25:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WJuazXrqQ31UiuLErxP8RMoE6Pat5wKBFWTh8hyYEEg=;
 b=tscz0b/60gavkC6cS2UqkYsIt13j4lLuZGxbt1TxGzLOajHB6sjw4/8nG+pOPBYS3si7
 BkJ/IZa9ps7hJ9XsuoI9Cqj408SX5g8GnR2DZ28MMlCIdVrK2vQb8yG1wmUJEXkAQnDd
 S1mUyYjExrLCcZM2pj4IN4FIUBSmPY+mUZzMJgVoUvyZwSnDWUbYgA3KeVVKNW6tkwCV
 TSXC8yI8rNSpvsJfk4vWgN+S+mXuGC+XJs2gbeHPxDvgxYghvzY+cJ1CzLeCsYGxDQE6
 VoL6/pCikmrqMDItAKgDyK6JVQb8s5PAl+QzGP9FJG56YyyoJyuXfckaV6hR+QIwTooO jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by8fqg26g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:25:04 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19REO02f000891;
        Wed, 27 Oct 2021 14:25:04 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3by8fqg25h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:25:03 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19REHsqm002192;
        Wed, 27 Oct 2021 14:25:02 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3bx4eg3r91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 14:25:02 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19REP0xE44958206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 14:25:00 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2B92B2077;
        Wed, 27 Oct 2021 14:24:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A653B2064;
        Wed, 27 Oct 2021 14:24:57 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.65.227.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 14:24:57 +0000 (GMT)
Subject: Re: [PATCH v17 00/15] s390/vfio-ap: dynamic configuration support
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6c510a1a-8229-4511-47d7-71f66c18b814@linux.ibm.com>
Date:   Wed, 27 Oct 2021 10:24:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211021152332.70455-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fuAhpcae6qyshMi9wKtHrVQibmipfdDF
X-Proofpoint-GUID: hzLcgHsLu_oWqgXVoPcI9rthIzJ5UDyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_04,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PING!!

On 10/21/21 11:23 AM, Tony Krowiak wrote:
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
> Change log v16-v17:
> ------------------
> * Introduced a new patch (patch 1) to remove the setting of the pqap hook
>    in the group notifier callback. It is now set when the vfio_ap device
>    driver is loaded.
>
> * Patch 6:
>      - Split the filtering of the APQNs and the control domains into
>        two functions and consolidated the vfio_ap_mdev_refresh_apcb and
>        vfio_ap_mdev_filter_apcb into one function named
>        vfio_ap_mdev_filter_matrix because the matrix is actually what is
>        being filtered.
>
>      - Removed ACK by Halil Pasic because of changes above; needs re-review.
>
> * Introduced a new patch (patch 8) to keep track of active guests.
>
> * Patch 9 (patch 8 in v16):
>      - Refactored locking to ensure KVM lock is taken before
>        matrix_dev->lock when hot plugging adapters, domains and
>        control domains.
>
>      - Removed ACK by Halil because of changes above; needs re-review.
>
> * Patch 14 (patch 13 in v16):
>      - This patch has been redesigned to ensure proper locking order (i.e.,
>        taking kvm->lock before matrix_dev->lock).
>
>      - Removed Halil's Removed-by because of changes above; needs re-review.
>
> Tony Krowiak (15):
>    s390/vfio-ap: Set pqap hook when vfio_ap module is loaded
>    s390/vfio-ap: use new AP bus interface to search for queue devices
>    s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
>    s390/vfio-ap: manage link between queue struct and matrix mdev
>    s390/vfio-ap: introduce shadow APCB
>    s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
>    s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
>    s390/vfio-ap: keep track of active guests
>    s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
>    s390/vfio-ap: reset queues after adapter/domain unassignment
>    s390/ap: driver callback to indicate resource in use
>    s390/vfio-ap: implement in-use callback for vfio_ap driver
>    s390/vfio-ap: sysfs attribute to display the guest's matrix
>    s390/ap: notify drivers on config changed and scan complete callbacks
>    s390/vfio-ap: update docs to include dynamic config support
>
>   Documentation/s390/vfio-ap.rst        |  492 ++++++---
>   arch/s390/include/asm/kvm_host.h      |   10 +-
>   arch/s390/kvm/kvm-s390.c              |    1 -
>   arch/s390/kvm/priv.c                  |   45 +-
>   drivers/s390/crypto/ap_bus.c          |  241 ++++-
>   drivers/s390/crypto/ap_bus.h          |   16 +
>   drivers/s390/crypto/vfio_ap_drv.c     |   52 +-
>   drivers/s390/crypto/vfio_ap_ops.c     | 1379 ++++++++++++++++++-------
>   drivers/s390/crypto/vfio_ap_private.h |   66 +-
>   9 files changed, 1714 insertions(+), 588 deletions(-)
>

