Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B317359FC4
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIN1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 09:27:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhDIN1S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Apr 2021 09:27:18 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 139D2qk0146781;
        Fri, 9 Apr 2021 09:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XzuS5as5IWaueUcn3ofnkt2I+738FWP6ZUWEz2NtDkQ=;
 b=tmJdmyHrn/LMuNYmiyOZaEQVe+rik34dC1Dda1/atF/GEcgfiXzc/V61NBF661hecK20
 hVG3jq2zc2oZejmfYU/+HCuLTHUM9hN2pPvU0h1MkEVSFTsYkg/4jX8XlCBCnrHgbQuu
 aRnce4N9SFxdgRw/EVsLc9lTJKxgUV8WxmZCQV5rD9p0tXNzr43qUft01sLndj/LsLbB
 mTWDSrCV1XocX5vqtOhfm870WWcbHaWhS9FDkPcTpSeEH/uqMi+6ElSJF7qwpW9JXywV
 v1cZEcUenDEH8BeECHDKr2lWMCFLrITVd2MgvryNb4E+gJmf5qFh+Crap2fPdPjHFU89 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37tpvwhu4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 09:27:04 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 139D3KJN001972;
        Fri, 9 Apr 2021 09:27:04 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37tpvwhu47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 09:27:03 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 139DLnJR030812;
        Fri, 9 Apr 2021 13:27:03 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 37rvc4hq0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Apr 2021 13:27:03 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 139DQxhK29032940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Apr 2021 13:26:59 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76E6BC6061;
        Fri,  9 Apr 2021 13:26:59 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54801C6057;
        Fri,  9 Apr 2021 13:26:57 +0000 (GMT)
Received: from cpe-172-100-162-199.stny.res.rr.com (unknown [9.85.201.195])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  9 Apr 2021 13:26:57 +0000 (GMT)
Subject: Re: [PATCH v15 00/13] s390/vfio-ap: dynamic configuration support
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        "Jason J . Herne" <jjherne@linux.ibm.com>
References: <20210406153122.22874-1-akrowiak@linux.ibm.com>
 <20210408223804.0ca5ba36.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4c083431-bdba-15f8-bcbc-f80192cb02c8@linux.ibm.com>
Date:   Fri, 9 Apr 2021 09:26:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210408223804.0ca5ba36.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aL5dvifMWPhZQPeYaM8gu8t1dYwPY1as
X-Proofpoint-ORIG-GUID: WGZW_BFRV22fYKWcat4rtAc1OpeCB_CP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-09_05:2021-04-09,2021-04-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/8/21 4:38 PM, Halil Pasic wrote:
> On Tue,  6 Apr 2021 11:31:09 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Tony Krowiak (13):
>>    s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks
> The subsequent patches, re introduce this circular locking dependency
> problem. See my kernel messages for the details. The link we severe
> in the above patch is re-introduced at several places. One of them is
> assign_adapter_store().

Like in the patch referenced above, the lockdep splat occurs when
the APCB masks are set which requires acquisition of the kvm lock.
Patch 08/13, allow hot plug/unplug of AP resources using mdev,
introduces code that updates the APCB masks whenever an
adapter, domain or control domain is assigned or unassigned
as well as when a queue device is probed or removed.
I think the solution from the patch above can be implemented
here to resolve this problem.

>
> Regards,
> Halil
>
> [  +0.000236] vfio_ap matrix: MDEV: Registered
> [  +0.037919] vfio_mdev 4f77ad87-1e62-4959-8b7a-c677c98d2194: Adding to iommu group 1
> [  +0.000092] vfio_mdev 4f77ad87-1e62-4959-8b7a-c677c98d2194: MDEV: group_id = 1
>
> [Apr 8 22:31] ======================================================
> [  +0.000002] WARNING: possible circular locking dependency detected
> [  +0.000002] 5.12.0-rc6-00016-g5bea90816c56 #57 Not tainted
> [  +0.000002] ------------------------------------------------------
> [  +0.000002] CPU 1/KVM/6651 is trying to acquire lock:
> [  +0.000002] 00000000cef9d508 (&matrix_dev->lock){+.+.}-{3:3}, at: handle_pqap+0x56/0x1c8 [vfio_ap]
> [  +0.000011]
>                but task is already holding lock:
> [  +0.000001] 00000000d41f4308 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x90/0x898 [kvm]
> [  +0.000038]
>                which lock already depends on the new lock.
>
> [  +0.000002]
>                the existing dependency chain (in reverse order) is:
> [  +0.000001]
>                -> #2 (&vcpu->mutex){+.+.}-{3:3}:
> [  +0.000004]        validate_chain+0x796/0xa20
> [  +0.000006]        __lock_acquire+0x420/0x7c8
> [  +0.000003]        lock_acquire.part.0+0xec/0x1e8
> [  +0.000002]        lock_acquire+0xb8/0x208
> [  +0.000002]        __mutex_lock+0xa2/0x928
> [  +0.000005]        mutex_lock_nested+0x32/0x40
> [  +0.000002]        kvm_s390_cpus_to_pv+0x4e/0xf8 [kvm]
> [  +0.000019]        kvm_s390_handle_pv+0x1ce/0x6b0 [kvm]
> [  +0.000018]        kvm_arch_vm_ioctl+0x3ec/0x550 [kvm]
> [  +0.000019]        kvm_vm_ioctl+0x40e/0x4a8 [kvm]
> [  +0.000018]        __s390x_sys_ioctl+0xc0/0x100
> [  +0.000004]        do_syscall+0x7e/0xd0
> [  +0.000043]        __do_syscall+0xc0/0xd8
> [  +0.000004]        system_call+0x72/0x98
> [  +0.000004]
>                -> #1 (&kvm->lock){+.+.}-{3:3}:
> [  +0.000004]        validate_chain+0x796/0xa20
> [  +0.000002]        __lock_acquire+0x420/0x7c8
> [  +0.000002]        lock_acquire.part.0+0xec/0x1e8
> [  +0.000002]        lock_acquire+0xb8/0x208
> [  +0.000003]        __mutex_lock+0xa2/0x928
> [  +0.000002]        mutex_lock_nested+0x32/0x40
> [  +0.000002]        kvm_arch_crypto_set_masks+0x4a/0x2b8 [kvm]
> [  +0.000018]        vfio_ap_mdev_refresh_apcb+0xd0/0xe0 [vfio_ap]
> [  +0.000003]        assign_adapter_store+0x1f2/0x240 [vfio_ap]
> [  +0.000003]        kernfs_fop_write_iter+0x13e/0x1e0
> [  +0.000003]        new_sync_write+0x10a/0x198
> [  +0.000003]        vfs_write.part.0+0x196/0x290
> [  +0.000002]        ksys_write+0x6c/0xf8
> [  +0.000003]        do_syscall+0x7e/0xd0
> [  +0.000002]        __do_syscall+0xc0/0xd8
> [  +0.000003]        system_call+0x72/0x98
> [  +0.000002]
>                -> #0 (&matrix_dev->lock){+.+.}-{3:3}:
> [  +0.000004]        check_noncircular+0x16e/0x190
> [  +0.000002]        check_prev_add+0xec/0xf38
> [  +0.000002]        validate_chain+0x796/0xa20
> [  +0.000002]        __lock_acquire+0x420/0x7c8
> [  +0.000002]        lock_acquire.part.0+0xec/0x1e8
> [  +0.000002]        lock_acquire+0xb8/0x208
> [  +0.000002]        __mutex_lock+0xa2/0x928
> [  +0.000002]        mutex_lock_nested+0x32/0x40
> [  +0.000003]        handle_pqap+0x56/0x1c8 [vfio_ap]
> [  +0.000002]        handle_pqap+0xe2/0x1d8 [kvm]
> [  +0.000019]        kvm_handle_sie_intercept+0x134/0x248 [kvm]
> [  +0.000019]        vcpu_post_run+0x2b6/0x580 [kvm]
> [  +0.000018]        __vcpu_run+0x27e/0x388 [kvm]
> [  +0.000019]        kvm_arch_vcpu_ioctl_run+0x10a/0x278 [kvm]
> [  +0.000018]        kvm_vcpu_ioctl+0x2cc/0x898 [kvm]
> [  +0.000018]        __s390x_sys_ioctl+0xc0/0x100
> [  +0.000003]        do_syscall+0x7e/0xd0
> [  +0.000002]        __do_syscall+0xc0/0xd8
> [  +0.000002]        system_call+0x72/0x98
> [  +0.000003]
>                other info that might help us debug this:
>
> [  +0.000001] Chain exists of:
>                  &matrix_dev->lock --> &kvm->lock --> &vcpu->mutex
>
> [  +0.000005]  Possible unsafe locking scenario:
>
> [  +0.000001]        CPU0                    CPU1
> [  +0.000001]        ----                    ----
> [  +0.000002]   lock(&vcpu->mutex);
> [  +0.000002]                                lock(&kvm->lock);
> [  +0.000002]                                lock(&vcpu->mutex);
> [  +0.000002]   lock(&matrix_dev->lock);
> [  +0.000002]
>                 *** DEADLOCK ***
>
> [  +0.000002] 2 locks held by CPU 1/KVM/6651:
> [  +0.000002]  #0: 00000000d41f4308 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x90/0x898 [kvm]
> [  +0.000023]  #1: 00000000da2fc508 (&kvm->srcu){....}-{0:0}, at: __vcpu_run+0x1ec/0x388 [kvm]
> [  +0.000021]
>                stack backtrace:
> [  +0.000002] CPU: 6 PID: 6651 Comm: CPU 1/KVM Not tainted 5.12.0-rc6-00016-g5bea90816c56 #57
> [  +0.000004] Hardware name: IBM 8561 T01 701 (LPAR)
> [  +0.000001] Call Trace:
> [  +0.000002]  [<00000002010e7ef0>] show_stack+0x90/0xf8
> [  +0.000007]  [<00000002010fb5b2>] dump_stack+0xba/0x108
> [  +0.000002]  [<000000020053feb6>] check_noncircular+0x16e/0x190
> [  +0.000003]  [<0000000200541424>] check_prev_add+0xec/0xf38
> [  +0.000002]  [<0000000200542a06>] validate_chain+0x796/0xa20
> [  +0.000003]  [<0000000200545430>] __lock_acquire+0x420/0x7c8
> [  +0.000002]  [<00000002005441a4>] lock_acquire.part.0+0xec/0x1e8
> [  +0.000002]  [<0000000200544358>] lock_acquire+0xb8/0x208
> [  +0.000003]  [<000000020110aeea>] __mutex_lock+0xa2/0x928
> [  +0.000002]  [<000000020110b7a2>] mutex_lock_nested+0x32/0x40
> [  +0.000003]  [<000003ff8060fb5e>] handle_pqap+0x56/0x1c8 [vfio_ap]
> [  +0.000003]  [<000003ff80597412>] handle_pqap+0xe2/0x1d8 [kvm]
> [  +0.000018]  [<000003ff8058c924>] kvm_handle_sie_intercept+0x134/0x248 [kvm]
> [  +0.000020]  [<000003ff80588e96>] vcpu_post_run+0x2b6/0x580 [kvm]
> [  +0.000019]  [<000003ff805893de>] __vcpu_run+0x27e/0x388 [kvm]
> [  +0.000018]  [<000003ff80589d0a>] kvm_arch_vcpu_ioctl_run+0x10a/0x278 [kvm]
> [  +0.000019]  [<000003ff805704d4>] kvm_vcpu_ioctl+0x2cc/0x898 [kvm]
> [  +0.000019]  [<0000000200801ee8>] __s390x_sys_ioctl+0xc0/0x100
> [  +0.000003]  [<000000020046e7ae>] do_syscall+0x7e/0xd0
> [  +0.000003]  [<00000002010ffc20>] __do_syscall+0xc0/0xd8
> [  +0.000002]  [<0000000201110c42>] system_call+0x72/0x98
> [  +0.000003] INFO: lockdep is turned off.
> [  +6.846296] vfio_mdev 4f77ad87-1e62-4959-8b7a-c677c98d2194: Removing from iommu group 1
> [  +0.000028] vfio_mdev 4f77ad87-1e62-4959-8b7a-c677c98d2194: MDEV: detaching iommu
> [  +0.007677] vfio_ap matrix: MDEV: Unregistering
>
>
>>    s390/vfio-ap: use new AP bus interface to search for queue devices
>>    s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c
>>    s390/vfio-ap: manage link between queue struct and matrix mdev
>>    s390/vfio-ap: introduce shadow APCB
>>    s390/vfio-ap: refresh guest's APCB by filtering APQNs assigned to mdev
>>    s390/vfio-ap: allow assignment of unavailable AP queues to mdev device
>>    s390/vfio-ap: allow hot plug/unplug of AP resources using mdev device
>>    s390/zcrypt: driver callback to indicate resource in use
>>    s390/vfio-ap: implement in-use callback for vfio_ap driver
>>    s390/vfio-ap: sysfs attribute to display the guest's matrix
>>    s390/zcrypt: notify drivers on config changed and scan complete
>>      callbacks
>>    s390/vfio-ap: update docs to include dynamic config support

