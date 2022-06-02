Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1EE53BC26
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiFBQLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 12:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbiFBQLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 12:11:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2422621AC5F;
        Thu,  2 Jun 2022 09:11:14 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252ELGRH014187;
        Thu, 2 Jun 2022 16:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VUlr7ef9AnaEOK6CZUITyjRU3hrna8B0WKah06lUZB0=;
 b=j1nStG8A4Ey6MBSVpUEyFI42fmVBsUzj42zyqrdYIff6LXpbGvlI+5h5clX08JfrA9zp
 0HUTvTxIkIip4sDd+NHJkdvcIYY0agrPvqtcMHInlt2jU+DqSRpMBNDCv5phidZZC+h4
 odgEBL52m3sD5psAwC+L+KHhEb34+IZSSgR/HaAC05CoT2Qs+JGek/poSDNfg+GryIJT
 6mvYzFVigwttdRq1trHFTIYAsZVo6hEQVBq6VF1R4+Qsq4OjXfGo2nuSWDXYp5SX330y
 bY8kgM941rcd0XX2FR2ByUGtLz6LuXh/RsBdvX5MVIg9NYY8Vy7enyCydqnDaXZ58kL2 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9wjpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:11:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 252GAhOj011010;
        Thu, 2 Jun 2022 16:11:11 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gevb9wjp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:11:11 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 252G5sb1009771;
        Thu, 2 Jun 2022 16:11:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9vuk1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jun 2022 16:11:10 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 252GB9Ah24838484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jun 2022 16:11:09 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 590BF136059;
        Thu,  2 Jun 2022 16:11:09 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4E2213605E;
        Thu,  2 Jun 2022 16:11:07 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jun 2022 16:11:07 +0000 (GMT)
Message-ID: <fcddecd6-10fe-257d-1234-940a84f4264f@linux.ibm.com>
Date:   Thu, 2 Jun 2022 12:11:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 19/20] s390/Docs: new doc describing lock usage by the
 vfio_ap device driver
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-20-akrowiak@linux.ibm.com>
 <d75c61bf-c729-1e8d-b751-6addd7b1870f@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <d75c61bf-c729-1e8d-b751-6addd7b1870f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vpRP_qc3soEk5TgXWWnmlkVbNVV9qOLn
X-Proofpoint-ORIG-GUID: m4nsFm1-X4kvcbfZQvhAXeE5rUeyUlwI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-02_04,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020067
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/31/22 3:23 PM, Jason J. Herne wrote:
> On 4/4/22 18:10, Tony Krowiak wrote:
>> Introduces a new document describing the locks used by the vfio_ap 
>> device
>> driver and how to use them so as to avoid lockdep reports and deadlock
>> situations.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   Documentation/s390/vfio-ap-locking.rst | 389 +++++++++++++++++++++++++
>>   1 file changed, 389 insertions(+)
>>   create mode 100644 Documentation/s390/vfio-ap-locking.rst
>>
>> diff --git a/Documentation/s390/vfio-ap-locking.rst 
>> b/Documentation/s390/vfio-ap-locking.rst
>> new file mode 100644
>> index 000000000000..ba5db6689f14
>> --- /dev/null
>> +++ b/Documentation/s390/vfio-ap-locking.rst
>> @@ -0,0 +1,389 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +======================
>> +VFIO AP Locks Overview
>> +======================
>> +This document describes the locks that are pertinent to the secure 
>> operation
>> +of the vfio_ap device driver. Throughout this document, the 
>> following variables
>> +will be used to denote instances of the structures herein described:
>> +
>> +struct ap_matrix_dev *matrix_dev;
>> +struct ap_matrix_mdev *matrix_mdev;
>> +struct kvm *kvm;
>> +
>> +The Matrix Devices Lock (drivers/s390/crypto/vfio_ap_private.h)
>> +--------------------------------------------------------------
>> +
>> +struct ap_matrix_dev {
>> +    ...
>> +    struct list_head mdev_list;
>> +    struct mutex mdevs_lock;
>> +    ...
>> +}
>> +
>> +The Matrix Devices Lock (matrix_dev->mdevs_lock) is implemented as a 
>> global
>> +mutex contained within the single object of struct ap_matrix_dev. 
>> This lock
>> +controls access to all fields contained within each matrix_mdev
>> +(matrix_dev->mdev_list). This lock must be held while reading from, 
>> writing to
>> +or using the data from a field contained within a matrix_mdev instance
>> +representing one of the vfio_ap device driver's mediated devices.
>> +
>> +The KVM Lock (include/linux/kvm_host.h)
>> +---------------------------------------
>> +
>> +struct kvm {
>> +    ...
>> +    struct mutex lock;
>> +    ...
>> +}
>> +
>> +The KVM Lock (kvm->lock) controls access to the state data for a KVM 
>> guest. This
>> +lock must be held by the vfio_ap device driver while one or more AP 
>> adapters,
>> +domains or control domains are being plugged into or unplugged from 
>> the guest.
>> +
>> +The vfio_ap device driver registers a function to be notified when 
>> the pointer
>> +to the kvm instance has been set. The KVM pointer is passed to the 
>> handler by
>> +the notifier and is stored in the in the matrix_mdev instance
>> +(matrix_mdev->kvm = kvm) containing the state of the mediated device 
>> that has
>> +been passed through to the KVM guest.
>> +
>> +The Guests Lock (drivers/s390/crypto/vfio_ap_private.h)
>> +-----------------------------------------------------------
>> +
>> +struct ap_matrix_dev {
>> +    ...
>> +    struct list_head mdev_list;
>> +    struct mutex guests_lock;
>> +    ...
>> +}
>> +
>> +The Guests Lock (matrix_dev->guests_lock) controls access to the
>> +matrix_mdev instances (matrix_dev->mdev_list) that represent 
>> mediated devices
>> +that hold the state for the mediated devices that have been passed 
>> through to a
>> +KVM guest. This lock must be held:
>> +
>> +1. To control access to the KVM pointer (matrix_mdev->kvm) while the 
>> vfio_ap
>> +   device driver is using it to plug/unplug AP devices passed 
>> through to the KVM
>> +   guest.
>> +
>> +2. To add matrix_mdev instances to or remove them from 
>> matrix_dev->mdev_list.
>> +   This is necessary to ensure the proper locking order when the 
>> list is perused
>> +   to find an ap_matrix_mdev instance for the purpose of 
>> plugging/unplugging
>> +   AP devices passed through to a KVM guest.
>> +
>> +   For example, when a queue device is removed from the vfio_ap 
>> device driver,
>> +   if the adapter is passed through to a KVM guest, it will have to be
>> +   unplugged. In order to figure out whether the adapter is passed 
>> through,
>> +   the matrix_mdev object to which the queue is assigned will have 
>> to be
>> +   found. The KVM pointer (matrix_mdev->kvm) can then be used to 
>> determine if
>> +   the mediated device is passed through (matrix_mdev->kvm != NULL) 
>> and if so,
>> +   to unplug the adapter.
>> +
>> +It is not necessary to take the Guests Lock to access the KVM 
>> pointer if the
>> +pointer is not used to plug/unplug devices passed through to the KVM 
>> guest;
>> +however, in this case, the Matrix Devices Lock 
>> (matrix_dev->mdevs_lock) must be
>> +held in order to access the KVM pointer since it set and cleared 
>> under the
>> +protection of the Matrix Devices Lock. A case in point is the 
>> function that
>> +handles interception of the PQAP(AQIC) instruction sub-function. 
>> This handler
>> +needs to access the KVM pointer only for the purposes of setting or 
>> clearing IRQ
>> +resources, so only the matrix_dev->mdevs_lock needs to be held.
>> +
>> +The PQAP Hook Lock (arch/s390/include/asm/kvm_host.h)
>> +-----------------------------------------------------
>> +
>> +typedef int (*crypto_hook)(struct kvm_vcpu *vcpu);
>> +
>> +struct kvm_s390_crypto {
>> +    ...
>> +    struct rw_semaphore pqap_hook_rwsem;
>> +    crypto_hook *pqap_hook;
>> +    ...
>> +};
>> +
>> +The PQAP Hook Lock is a r/w semaphore that controls access to the 
>> function
>> +pointer of the handler (*kvm->arch.crypto.pqap_hook) to invoke when the
>> +PQAP(AQIC) instruction sub-function is intercepted by the host. The 
>> lock must be
>> +held in write mode when pqap_hook value is set, and in read mode 
>> when the
>> +pqap_hook function is called.
>
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
>
> R-b for everything above here. Everything below, I've reviewed in less 
> detail and I'm not sure it really makes sense. Defining a locking 
> order makes sense and it is adequately described multiple times in 
> vfio_ap_ops.c. The list of operations and the locks they take can be 
> derived just as easily from the code instead of this document. Also, 
> documents like this tend to not stay up to date with respect to the 
> code they describe. My vote would be to drop everything below.

I agree, it is probably overkill anyway; I'll remove it.

>
>
>
>> +Locking Order
>> +-------------
>> +
>> +If the various locks are not taken in the proper order, it could 
>> potentially
>> +result in a deadlock or lockdep splat. In general the Guests Lock
>> +(matrix_dev->guests_lock) must be taken outside of the KVM Lock 
>> (kvm->lock)
>> +which in turn must be taken outside of the Matrix Devices Lock
>> +(matrix_dev->mdevs_lock).
>> +
>> +The following describes the various operations under which the 
>> various locks are
>> +taken, the purpose for taking them and the order in which they must 
>> be taken.
>> +
>> +* Operations: Setting or clearing the KVM pointer (matrix_mdev->kvm):
>> +
>> +  1. PQAP Hook Lock (kvm->arch.crypto.pqap_hook_rwsem):
>> +
>> +    This semaphore must be held in write mode while setting or 
>> clearing the
>> +    reference to the function pointer (kvm->arch.crypt.pqap_hook) to 
>> call
>> +    when the PQAP(AQIC) instruction sub-function is intercepted by 
>> the host.
>> +    The function pointer is set when the KVM pointer is being set and
>> +    cleared when the KVM pointer is being cleared.
>> +
>> +  2.Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held while accessing the KVM pointer
>> +    (matrix_mdev->kvm) to plug/unplug AP devices passed through to the
>> +    KVM guest
>> +
>> +  3. KVM Lock (kvm->lock):
>> +
>> +    This mutex must be held while the AP devices passed through to 
>> the KVM
>> +    guest are plugged/unplugged.
>> +
>> +  4. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held to prevent access to the matrix_mdev state
>> +    while writing/reading state values during the operation.
>> +
>> +* Operations: Assign or unassign an adapter, domain or control 
>> domain of a
>> +          mediated device under the control of the vfio_ap device 
>> driver:
>> +
>> +  1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held while accessing the KVM pointer
>> +    (matrix_dev->kvm) to plug/unplug AP devices passed through to the
>> +    KVM guest as a result of the assignment/unassignment operation.
>> +    Assignment of an AP device may result in additional queue devices
>> +    or control domains being plugged into the guest. Similarly, 
>> unassignment
>> +    may result in unplugging queue devices or control domains from the
>> +    guest
>> +
>> +  3. KVM Lock (matrix_mdev->kvm->lock):
>> +
>> +    This mutex must be held while the AP devices passed through to 
>> the KVM
>> +    guest are plugged in or unplugged.
>> +
>> +  4. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held to prevent access to the matrix_mdev state
>> +    while writing/reading state values during the operation. For 
>> example, to
>> +    determine which AP devices need to be plugged/unplugged, the lock
>> +    must be held to prevent other operations from changing the data 
>> used
>> +    to construct the guest's AP configuration.
>> +
>> +* Operations: Probe or remove an AP queue device:
>> +
>> +  When a queue device is bound to the vfio_ap device driver, the 
>> driver's probe
>> +  callback is invoked. Similarly, when a queue device is unbound 
>> from the
>> +  driver it's remove callback is invoked. The probe and remove 
>> functions will
>> +  take locks in the following order:
>> +
>> +  1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held for the duration of this operation.
>> +
>> +    At the time of the operation, the vfio_ap device driver will 
>> only have
>> +    the APQN of the queue being probed or removed, so the
>> +    matrix_dev->mdevs_list must be perused to locate the matrix_mdev
>> +    instance to which the queue is assigned. The Guests Lock must be 
>> held
>> +    during this time to prevent the list from being changed while 
>> processing
>> +    the probe/remove.
>> +
>> +    Once the matrix_mdev is found, the operation must determine 
>> whether the
>> +    mediated device is passed through to a guest (matrix_mdev->kvm 
>> != NULL),
>> +    then use the KVM pointer to perform the plug/unplug operation. Here
>> +    again, the lock must be held to prevent other operations from 
>> accessing
>> +    the KVM pointer for the same purpose.
>> +
>> +  2. KVM Lock (kvm->lock):
>> +
>> +    This mutex must be held while the AP devices passed through to 
>> the KVM
>> +    guest are plugged in or unplugged to prevent other operations from
>> +    accessing the guest's state while it is in flux.
>> +
>> +  3. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held to prevent access to the matrix_mdev state
>> +    while writing/reading state values during the operation, such as 
>> the
>> +    masks used to construct the KVM guest's AP configuration.
>> +
>> +* Operations: Probe or remove a mediated device:
>> +
>> +  1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held while adding the matrix_mdev to the
>> +    matrix_dev->mdev_list during the probe operation or when 
>> removing it
>> +    from the list during the remove operation. This is to prevent 
>> access by
>> +    other functions that must traverse the list to find a 
>> matrix_mdev for
>> +    the purpose of plugging/unplugging AP devices passed through to 
>> a KVM
>> +    guest (i.e., probe/remove queue callbacks), while the list is being
>> +    modified.
>> +
>> +  2. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held to prevent access to the matrix_mdev state
>> +    while writing/reading state values during the probe or remove 
>> operations
>> +    such as initializing the hashtable of queue devices
>> +    (matrix_mdev->qtable.queues) assigned to the matrix_mdev.
>> +
>> +* Operation: Handle interception of the PQAP(AQIC) instruction 
>> sub-function:
>> +
>> +  1. PQAP Hook Lock (kvm->arch.crypto.pqap_hook_rwsem)
>> +
>> +    This semaphore must be held in read mode while retrieving the 
>> function
>> +    pointer (kvm->arch.crypto.pqap_hook) and executing the function 
>> that
>> +    handles the interception of the PQAP(AQIC) instruction 
>> sub-function by
>> +    the host.
>> +
>> +  2. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held to prevent access to the matrix_mdev state
>> +    while writing/reading state values during the execution of the
>> +    PQAP(AQIC) instruction sub-function interception handler. For 
>> example,
>> +    the handler must iterate over the matrix_mdev->qtable.queues 
>> hashtable
>> +    to find the vfio_ap_queue object representing the queue for which
>> +    interrupts are being enabled or disabled.
>> +
>> +  Note: It is not necessary to take the Guests Lock 
>> (matrix_dev->guests_lock)
>> +    or the KVM Lock (matrix_mdev->kvm->lock) because the KVM pointer
>> +    will not be accessed to plug/unplug AP devices passed through to 
>> the
>> +    guest; it will only be used to allocate or free resources for 
>> processing
>> +    interrupts.
>> +
>> +* Operation: Handle AP configuration changed notification:
>> +
>> +  The vfio_ap device driver registers a callback function to be 
>> notified when
>> +  the AP bus detects that the host's AP configuration has changed. 
>> This can
>> +  occur due to the addition or removal of AP adapters, domains or 
>> control
>> +  domains via an SE or HMC connected to a DPM enabled LPAR. The 
>> objective of the
>> +  handler is to remove the queues no longer accessible via the host 
>> in bulk
>> +  rather than one queue at a time via the driver's queue device 
>> remove callback.
>> +  The locks and the order in which they must be taken by this 
>> operation are:
>> +
>> + 1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held for the duration of the operation to:
>> +
>> +    * Iterate over the matrix_dev->mdev_list to find each 
>> matrix_mdev from
>> +      which a queue device to be removed is assigned and prevent other
>> +      operations from modifying the list while processing the affected
>> +      matrix_mdev instances.
>> +
>> +    * Prevent other operations from acquiring access to the KVM 
>> pointer in
>> +      each affected matrix_mdev instance (matrix_mdev->kvm) for the 
>> purpose
>> +      of plugging/unplugging AP devices passed through to the KVM 
>> guest via
>> +      that instance.
>> +
>> +2. KVM Lock (kvm->lock):
>> +
>> +    This mutex must be held for each affected matrix_mdev instance 
>> while
>> +    the AP devices passed through to the KVM guest are unplugged to 
>> prevent
>> +    other operations from accessing the guest's state while it is in 
>> flux.
>> +
>> +    Note: This lock must be re-acquired for each matrix_mdev instance.
>> +
>> +  3. Matrix Devices Lock (matrix_dev->mdevs_lock)
>> +
>> +    This lock must be held for each affected matrix_mdev to prevent 
>> access
>> +    to the matrix_mdev state while writing/reading state values 
>> during the
>> +    operation, such as the masks used to construct the KVM guest's AP
>> +    configuration.
>> +
>> +    Note: This lock must be re-acquired for each matrix_mdev instance.
>> +
>> +Operation: Handle AP bus scan complete notification:
>> +
>> +  The vfio_ap device driver registers a callback function to be 
>> notified when
>> +  the AP bus scan completes after detecting the addition or removal 
>> of AP
>> +  adapters, domains or control domains. The objective of the handler 
>> is t
>> +  add the new queues accessible via the host in bulk rather than one 
>> queue
>> +  at a time via the driver's queue device probe callback. The locks 
>> and the
>> +  order in which they must be taken by this operation are:
>> +
>> +  1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +    This mutex must be held for the duration of the operation to:
>> +
>> +    * Iterate over the matrix_dev->mdev_list to find each 
>> matrix_mdev to
>> +      which a queue device added is assigned and prevent other 
>> operations
>> +      from modifying the list while processing each affected 
>> matrix_mdev
>> +      object.
>> +
>> +    * Prevent other operations from acquiring access to the KVM 
>> pointer in
>> +      each affected matrix_mdev instance (matrix_mdev->kvm) for the 
>> purpose
>> +      of plugging/unplugging AP devices passed through to the KVM 
>> guest via
>> +      that instance.
>> +
>> +  2. KVM Lock (kvm->lock):
>> +
>> +    This mutex must be held for each affected matrix_mdev instance 
>> while
>> +    the AP devices passed through to the KVM guest are plugged in to 
>> prevent
>> +    other operations from accessing the guest's state while it is in 
>> flux.
>> +
>> +    Note: This lock must be re-acquired for each matrix_mdev instance.
>> +
>> +  3. Matrix Devices Lock (matrix_dev->mdevs_lock):
>> +
>> +    This lock must be held for each affected matrix_mdev to prevent 
>> access
>> +    to the matrix_mdev state while writing/reading state values 
>> during the
>> +    operation, such as the masks used to construct the KVM guest's AP
>> +    configuration.
>> +
>> +    Note: This lock must be re-acquired for each matrix_mdev instance.
>> +
>> +Operation: Handle resource in use query:
>> +
>> +  The vfio_ap device driver registers a callback function with the 
>> AP bus to be
>> +  called when changes to the bus's sysfs /sys/bus/ap/apmask or
>> +  /sys/bus/ap/aqmask attributes would result in one or more AP queue 
>> devices
>> +  getting unbound from the vfio_ap device driver to verify none of 
>> them are in
>> +  use by the driver (i.e., assigned to a matrix_mdev instance). If 
>> this function
>> +  is called while an adapter or domain is also being assigned to a 
>> mediated
>> +  device, this could result in a deadlock; for example:
>> +
>> +  1. A system administrator assigns an adapter to a mediated device 
>> under the
>> +     control of the vfio_ap device driver. The driver will need to 
>> first take
>> +     the matrix_dev->guests_lock to potentially hot plug the adapter 
>> into
>> +     the KVM guest.
>> +  2. At the same time, a system administrator sets a bit in the sysfs
>> +     /sys/bus/ap/ap_mask attribute. To complete the operation, the 
>> AP bus
>> +     must:
>> +     a. Take the ap_perms_mutex lock to update the object storing 
>> the values
>> +        for the /sys/bus/ap/ap_mask attribute.
>> +     b. Call the vfio_ap device driver's in-use callback to verify 
>> that no
>> +        queues now being reserved for the default zcrypt drivers are
>> +        in use by the vfio_ap device driver. To do the verification, 
>> the in-use
>> +        callback function takes the matrix_dev->guests_lock, but has 
>> to wait
>> +        because it is already held by the operation in 1 above.
>> +  3. The vfio_ap device driver calls an AP bus function to verify 
>> that the
>> +     new queues resulting from the assignment of the adapter in step 
>> 1 are
>> +     not reserved for the default zcrypt device driver. This AP bus 
>> function
>> +     tries to take the ap_perms_mutex lock but gets stuck waiting 
>> for the
>> +     it due to step 2a above.
>> +
>> +    Consequently, we have the following deadlock situation:
>> +
>> +    matrix_dev->guests_lock locked (1)
>> +    ap_perms_mutex lock locked (2a)
>> +    Waiting for matrix_dev->lock (2b) which is currently held (1)
>> +    Waiting for ap_perms_mutex lock (3) which is currently held (2a)
>> +
>> +  To prevent the deadlock scenario, the in_use operation will take the
>> +  required locks using the mutex_trylock() function and if the lock 
>> can not be
>> +  acquired will terminate and return -EBUSY to indicate the driver 
>> is busy
>> +  processing another request.
>> +
>> +  The locks required to respond to the handle resource in use query 
>> and the
>> +  order in which they must be taken are:
>> +
>> +  1. Guests Lock (matrix_dev->guests_lock):
>> +
>> +  This mutex must be held for the duration of the operation to 
>> iterate over the
>> +  matrix_dev->mdev_list to determine whether any of the queues to be 
>> unbound
>> +  are assigned to a matrix_mdev instance.
>> +
>> +  2. Matrix Devices Lock (matrix_dev->mdevs_lock):
>> +
>> +  This mutex must be held for the duration of the operation to 
>> ensure that the
>> +  AP configuration of each matrix_mdev instance does not change 
>> while verifying
>> +  that none of the queue devices to be removed from the vfio_ap 
>> driver are
>> +  assigned to it.
>
>

