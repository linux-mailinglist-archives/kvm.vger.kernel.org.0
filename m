Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA63443674
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 20:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhKBT0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 15:26:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5758 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230295AbhKBT0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 15:26:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2IGV5D008338;
        Tue, 2 Nov 2021 19:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4ULBXy0MYgwePsBhrr8+fGS9LLAvNqXZv0w+cxlrp5o=;
 b=XzXQBErFvimqaqNiFMWP1B1aV9axJXo5gYcm1PF7Talvd9B+xje75IWdrC9O/FcGauOo
 TCyum3jQlCteLMxxhe9Ty4FTPi4qS6gJxevT7pEHBnfT+FNAw6DUhvKgtgG/CurzbN8c
 3w/rRqA1i9Z47fc7cIQSrxyGHvfwuMib5bX+2ptmH20BHnW5N5tIsTWuqmAhobSMmA4K
 UZEZTn2FqkO6oHJMHZJepy0ECBy2txfhK60aoks1cZ8PRFAS7TR3q4O7VzOl5w3kYXud
 IZgjNOXeMJRTpMa7+IC7WCJPNJN2NQOoIUbcgs6FgAaWKQ5yqVGZSYNqqIkBPmzP+rNq fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c3aff16yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:23:28 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A2IqDwK000922;
        Tue, 2 Nov 2021 19:23:28 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c3aff16yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:23:28 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A2J8sgf003228;
        Tue, 2 Nov 2021 19:23:27 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3c22tsakwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 19:23:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A2JNQJR40501734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 19:23:26 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7284112069;
        Tue,  2 Nov 2021 19:23:26 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B420112063;
        Tue,  2 Nov 2021 19:23:21 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.160.119.222])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 19:23:21 +0000 (GMT)
Subject: Re: [PATCH v17 00/15] s390/vfio-ap: dynamic configuration support
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <6c510a1a-8229-4511-47d7-71f66c18b814@linux.ibm.com>
Message-ID: <359758fd-019f-4cf6-e3eb-dc9b2caae5b5@linux.ibm.com>
Date:   Tue, 2 Nov 2021 15:23:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6c510a1a-8229-4511-47d7-71f66c18b814@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qr96v_PMazb84ehu9AgJWli-wMf_mqyE
X-Proofpoint-ORIG-GUID: ZhjUSjcMba2eSloGK1p7yC9rJ5Sj5bvr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0 impostorscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anybody interested in doing a review of this series?

On 10/27/21 10:24 AM, Tony Krowiak wrote:
> PING!!
>
> On 10/21/21 11:23 AM, Tony Krowiak wrote:
>> The current design for AP pass-through does not support making dynamic
>> changes to the AP matrix of a running guest resulting in a few
>> deficiencies this patch series is intended to mitigate:
>>
>> 1. Adapters, domains and control domains can not be added to or removed
>>      from a running guest. In order to modify a guest's AP 
>> configuration,
>>      the guest must be terminated; only then can AP resources be 
>> assigned
>>      to or unassigned from the guest's matrix mdev. The new AP
>>      configuration becomes available to the guest when it is 
>> subsequently
>>      restarted.
>>
>> 2. The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask interfaces can
>>      be modified by a root user without any restrictions. A change to
>>      either mask can result in AP queue devices being unbound from the
>>      vfio_ap device driver and bound to a zcrypt device driver even if a
>>      guest is using the queues, thus giving the host access to the 
>> guest's
>>      private crypto data and vice versa.
>>
>> 3. The APQNs derived from the Cartesian product of the APIDs of the
>>      adapters and APQIs of the domains assigned to a matrix mdev must
>>      reference an AP queue device bound to the vfio_ap device driver. 
>> The
>>      AP architecture allows assignment of AP resources that are not
>>      available to the system, so this artificial restriction is not
>>      compliant with the architecture.
>>
>> 4. The AP configuration profile can be dynamically changed for the linux
>>      host after a KVM guest is started. For example, a new domain can be
>>      dynamically added to the configuration profile via the SE or an HMC
>>      connected to a DPM enabled lpar. Likewise, AP adapters can be
>>      dynamically configured (online state) and deconfigured (standby 
>> state)
>>      using the SE, an SCLP command or an HMC connected to a DPM enabled
>>      lpar. This can result in inadvertent sharing of AP queues 
>> between the
>>      guest and host.
>>
>> 5. A root user can manually unbind an AP queue device representing a
>>      queue in use by a KVM guest via the vfio_ap device driver's sysfs
>>      unbind attribute. In this case, the guest will be using a queue 
>> that
>>      is not bound to the driver which violates the device model.
>>
>> This patch series introduces the following changes to the current design
>> to alleviate the shortcomings described above as well as to implement
>> more of the AP architecture:
>>
>> 1. A root user will be prevented from making edits to the AP bus's
>>      /sys/bus/ap/apmask or /sys/bus/ap/aqmask if the change would 
>> transfer
>>      ownership of an APQN from the vfio_ap device driver to a zcrypt 
>> driver
>>      while the APQN is assigned to a matrix mdev.
>>
>> 2. Allow a root user to hot plug/unplug AP adapters, domains and control
>>      domains for a KVM guest using the matrix mdev via its sysfs
>>      assign/unassign attributes.
>>
>> 4. Allow assignment of an AP adapter or domain to a matrix mdev even if
>>      it results in assignment of an APQN that does not reference an AP
>>      queue device bound to the vfio_ap device driver, as long as the 
>> APQN
>>      is not reserved for use by the default zcrypt drivers (also 
>> known as
>>      over-provisioning of AP resources). Allowing over-provisioning 
>> of AP
>>      resources better models the architecture which does not preclude
>>      assigning AP resources that are not yet available in the system. 
>> Such
>>      APQNs, however, will not be assigned to the guest using the matrix
>>      mdev; only APQNs referencing AP queue devices bound to the vfio_ap
>>      device driver will actually get assigned to the guest.
>>
>> 5. Handle dynamic changes to the AP device model.
>>
>> 1. Rationale for changes to AP bus's apmask/aqmask interfaces:
>> ----------------------------------------------------------
>> Due to the extremely sensitive nature of cryptographic data, it is
>> imperative that great care be taken to ensure that such data is secured.
>> Allowing a root user, either inadvertently or maliciously, to configure
>> these masks such that a queue is shared between the host and a guest is
>> not only avoidable, it is advisable. It was suggested that this scenario
>> is better handled in user space with management software, but that does
>> not preclude a malicious administrator from using the sysfs interfaces
>> to gain access to a guest's crypto data. It was also suggested that this
>> scenario could be avoided by taking access to the adapter away from the
>> guest and zeroing out the queues prior to the vfio_ap driver 
>> releasing the
>> device; however, stealing an adapter in use from a guest as a by-product
>> of an operation is bad and will likely cause problems for the guest
>> unnecessarily. It was decided that the most effective solution with the
>> least number of negative side effects is to prevent the situation at the
>> source.
>>
>> 2. Rationale for hot plug/unplug using matrix mdev sysfs interfaces:
>> ----------------------------------------------------------------
>> Allowing a user to hot plug/unplug AP resources using the matrix mdev
>> sysfs interfaces circumvents the need to terminate the guest in order to
>> modify its AP configuration. Allowing dynamic configuration makes
>> reconfiguring a guest's AP matrix much less disruptive.
>>
>> 3. Rationale for allowing over-provisioning of AP resources:
>> -----------------------------------------------------------
>> Allowing assignment of AP resources to a matrix mdev and ultimately to a
>> guest better models the AP architecture. The architecture does not
>> preclude assignment of unavailable AP resources. If a queue subsequently
>> becomes available while a guest using the matrix mdev to which its APQN
>> is assigned, the guest will be given access to it. If an APQN
>> is dynamically unassigned from the underlying host system, it will
>> automatically become unavailable to the guest.
>>
>> Change log v16-v17:
>> ------------------
>> * Introduced a new patch (patch 1) to remove the setting of the pqap 
>> hook
>>    in the group notifier callback. It is now set when the vfio_ap device
>>    driver is loaded.
>>
>> * Patch 6:
>>      - Split the filtering of the APQNs and the control domains into
>>        two functions and consolidated the vfio_ap_mdev_refresh_apcb and
>>        vfio_ap_mdev_filter_apcb into one function named
>>        vfio_ap_mdev_filter_matrix because the matrix is actually what is
>>        being filtered.
>>
>>      - Removed ACK by Halil Pasic because of changes above; needs 
>> re-review.
>>
>> * Introduced a new patch (patch 8) to keep track of active guests.
>>
>> * Patch 9 (patch 8 in v16):
>>      - Refactored locking to ensure KVM lock is taken before
>>        matrix_dev->lock when hot plugging adapters, domains and
>>        control domains.
>>
>>      - Removed ACK by Halil because of changes above; needs re-review.
>>
>> * Patch 14 (patch 13 in v16):
>>      - This patch has been redesigned to ensure proper locking order 
>> (i.e.,
>>        taking kvm->lock before matrix_dev->lock).
>>
>>      - Removed Halil's Removed-by because of changes above; needs 
>> re-review.
>>
>> Tony Krowiak (15):
>>    s390/vfio-ap: Set pqap hook when vfio_ap module is loaded
>>    s390/vfio-ap: use new AP bus interface to search for queue devices
>>    s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
>>    s390/vfio-ap: manage link between queue struct and matrix mdev
>>    s390/vfio-ap: introduce shadow APCB
>>    s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to 
>> mdev
>>    s390/vfio-ap: allow assignment of unavailable AP queues to mdev 
>> device
>>    s390/vfio-ap: keep track of active guests
>>    s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
>>    s390/vfio-ap: reset queues after adapter/domain unassignment
>>    s390/ap: driver callback to indicate resource in use
>>    s390/vfio-ap: implement in-use callback for vfio_ap driver
>>    s390/vfio-ap: sysfs attribute to display the guest's matrix
>>    s390/ap: notify drivers on config changed and scan complete callbacks
>>    s390/vfio-ap: update docs to include dynamic config support
>>
>>   Documentation/s390/vfio-ap.rst        |  492 ++++++---
>>   arch/s390/include/asm/kvm_host.h      |   10 +-
>>   arch/s390/kvm/kvm-s390.c              |    1 -
>>   arch/s390/kvm/priv.c                  |   45 +-
>>   drivers/s390/crypto/ap_bus.c          |  241 ++++-
>>   drivers/s390/crypto/ap_bus.h          |   16 +
>>   drivers/s390/crypto/vfio_ap_drv.c     |   52 +-
>>   drivers/s390/crypto/vfio_ap_ops.c     | 1379 ++++++++++++++++++-------
>>   drivers/s390/crypto/vfio_ap_private.h |   66 +-
>>   9 files changed, 1714 insertions(+), 588 deletions(-)
>>
>

