Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621D2198C3
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfEJHIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 03:08:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbfEJHIS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 May 2019 03:08:18 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4A72dka080739
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 03:08:17 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sd41c96q8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 03:08:17 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 10 May 2019 08:08:14 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 May 2019 08:08:11 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4A789WU55509020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 07:08:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6AE3A4040;
        Fri, 10 May 2019 07:08:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D622BA404D;
        Fri, 10 May 2019 07:08:08 +0000 (GMT)
Received: from [9.145.187.238] (unknown [9.145.187.238])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 May 2019 07:08:08 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
To:     Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20190430224937.57156-1-parav@mellanox.com>
 <20190430224937.57156-9-parav@mellanox.com>
 <20190508190957.673dd948.cohuck@redhat.com>
 <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190509110600.5354463c.cohuck@redhat.com>
 <VI1PR0501MB2271DD5EE143784B9F94D446D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Fri, 10 May 2019 09:08:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <VI1PR0501MB2271DD5EE143784B9F94D446D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051007-0028-0000-0000-0000036C37C5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051007-0029-0000-0000-0000242BBC2C
Message-Id: <f91816f8-2ec9-25a2-c3d4-adc04f5cb6b9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905100049
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/05/2019 21:19, Parav Pandit wrote:
> 
> 
>> -----Original Message-----
>> From: Cornelia Huck <cohuck@redhat.com>
>> Sent: Thursday, May 9, 2019 4:06 AM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com;
>> Tony Krowiak <akrowiak@linux.ibm.com>; Pierre Morel
>> <pmorel@linux.ibm.com>; Halil Pasic <pasic@linux.ibm.com>
>> Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
>> sequence
>>
>> [vfio-ap folks: find a question regarding removal further down]
>>
>> On Wed, 8 May 2019 22:06:48 +0000
>> Parav Pandit <parav@mellanox.com> wrote:
>>
>>>> -----Original Message-----
>>>> From: Cornelia Huck <cohuck@redhat.com>
>>>> Sent: Wednesday, May 8, 2019 12:10 PM
>>>> To: Parav Pandit <parav@mellanox.com>
>>>> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
>>>> Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
>>>> sequence
>>>>
>>>> On Tue, 30 Apr 2019 17:49:35 -0500
>>>> Parav Pandit <parav@mellanox.com> wrote:
>>>>
>>>>> This patch addresses below two issues and prepares the code to
>>>>> address 3rd issue listed below.
>>>>>
>>>>> 1. mdev device is placed on the mdev bus before it is created in
>>>>> the vendor driver. Once a device is placed on the mdev bus without
>>>>> creating its supporting underlying vendor device, mdev driver's
>>>>> probe()
>>>> gets triggered.
>>>>> However there isn't a stable mdev available to work on.
>>>>>
>>>>>     create_store()
>>>>>       mdev_create_device()
>>>>>         device_register()
>>>>>            ...
>>>>>           vfio_mdev_probe()
>>>>>          [...]
>>>>>          parent->ops->create()
>>>>>            vfio_ap_mdev_create()
>>>>>              mdev_set_drvdata(mdev, matrix_mdev);
>>>>>              /* Valid pointer set above */
>>>>>
>>>>> Due to this way of initialization, mdev driver who want to use the
>>
>> s/want/wants/
>>
>>>>> mdev, doesn't have a valid mdev to work on.
>>>>>
>>>>> 2. Current creation sequence is,
>>>>>     parent->ops_create()
>>>>>     groups_register()
>>>>>
>>>>> Remove sequence is,
>>>>>     parent->ops->remove()
>>>>>     groups_unregister()
>>>>>
>>>>> However, remove sequence should be exact mirror of creation
>> sequence.
>>>>> Once this is achieved, all users of the mdev will be terminated
>>>>> first before removing underlying vendor device.
>>>>> (Follow standard linux driver model).
>>>>> At that point vendor's remove() ops shouldn't failed because
>>>>> device is
>>
>> s/failed/fail/
>>
>>>>> taken off the bus that should terminate the users.
>>
>> "because taking the device off the bus should terminate any usage" ?
>>
>>>>>
>>>>> 3. When remove operation fails, mdev sysfs removal attempts to add
>>>>> the file back on already removed device. Following call trace [1] is
>> observed.
>>>>>
>>>>> [1] call trace:
>>>>> kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
>>>>> sysfs_create_file_ns+0x7f/0x90
>>>>> kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
>>>>> 5.1.0-rc6-vdevbus+ #6
>>>>> kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS
>>>>> 2.0b
>>>>> 08/09/2016
>>>>> kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
>>>>> kernel: Call Trace:
>>>>> kernel: remove_store+0xdc/0x100 [mdev]
>>>>> kernel: kernfs_fop_write+0x113/0x1a0
>>>>> kernel: vfs_write+0xad/0x1b0
>>>>> kernel: ksys_write+0x5a/0xe0
>>>>> kernel: do_syscall_64+0x5a/0x210
>>>>> kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>>
>>>>> Therefore, mdev core is improved in following ways.
>>>>>
>>>>> 1. Before placing mdev devices on the bus, perform vendor drivers
>>>>> creation which supports the mdev creation.
>>
>> "invoke the vendor driver ->create callback" ?
>>
>>>>> This ensures that mdev specific all necessary fields are
>>>>> initialized
>>
>> "that all necessary mdev specific fields are initialized" ?
>>
>>>>> before a given mdev can be accessed by bus driver.
>>>>> This follows standard Linux kernel bus and device model similar to
>>>>> other widely used PCI bus.
>>
>> "This follows standard practice on other Linux device model buses." ?
>>
>>>>>
>>>>> 2. During remove flow, first remove the device from the bus. This
>>>>> ensures that any bus specific devices and data is cleared.
>>>>> Once device is taken of the mdev bus, perform remove() of mdev
>>>>> from
>>
>> s/of/off/
>>
>>>>> the vendor driver.
>>>>>
>>>>> 3. Linux core device model provides way to register and auto
>>>>> unregister the device sysfs attribute groups at dev->groups.
>>
>> "The driver core provides a way to automatically register and unregister sysfs
>> attributes via dev->groups." ?
>>
>>>>> Make use of this groups to let core create the groups and simplify
>>>>> code to avoid explicit groups creation and removal.
>>>>>
>>>>> A below stack dump of a mdev device remove process also ensures
>>>>> that vfio driver guards against device removal already in use.
>>>>>
>>>>>   cat /proc/21962/stack
>>>>> [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio] [<0>]
>>>>> mdev_remove+0x21/0x40 [mdev] [<0>]
>>>>> device_release_driver_internal+0xe8/0x1b0
>>>>> [<0>] bus_remove_device+0xf9/0x170 [<0>] device_del+0x168/0x350
>>>>> [<0>] mdev_device_remove_common+0x1d/0x50 [mdev] [<0>]
>>>>> mdev_device_remove+0x8c/0xd0 [mdev] [<0>]
>> remove_store+0x71/0x90
>>>>> [mdev] [<0>] kernfs_fop_write+0x113/0x1a0 [<0>]
>>>>> vfs_write+0xad/0x1b0 [<0>] ksys_write+0x5a/0xe0 [<0>]
>>>>> do_syscall_64+0x5a/0x210 [<0>]
>>>>> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>> [<0>] 0xffffffffffffffff
>>>>>
>>>>> This prepares the code to eliminate calling device_create_file()
>>>>> in subsquent patch.
>>
>> I find this stack dump and explanation more confusing than enlightening.
>> Maybe just drop it?
>>
>>>>
>>>> I'm afraid I have a bit of a problem following this explanation, so
>>>> let me try to summarize what the patch does to make sure that I
>>>> understand it
>>>> correctly:
>>>>
>>>> - Add the sysfs groups to device->groups so that the driver core deals
>>>>    with proper registration/deregistration.
>>>> - Split the device registration/deregistration sequence so that some
>>>>    things can be done between initialization of the device and hooking
>>>>    it up to the infrastructure respectively after deregistering it from
>>>>    the infrastructure but before giving up our final reference. In
>>>>    particular, this means invoking the ->create and ->remove callback in
>>>>    those new windows. This gives the vendor driver an initialized mdev
>>>>    device to work with during creation.
>>>> - Don't allow ->remove to fail, as the device is already removed from
>>>>    the infrastructure at that point in time.
>>>>
>>> You got all the points pretty accurate.
>>
>> Ok, good.
>>
>>>
>>>>>
>>>>> Signed-off-by: Parav Pandit <parav@mellanox.com>
>>>>> ---
>>>>>   drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
>>>>>   drivers/vfio/mdev/mdev_private.h |  2 +-
>>>>>   drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
>>>>>   3 files changed, 27 insertions(+), 71 deletions(-)
>>>>
>>>> (...)
>>
>>>>> @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev,
>>>> bool force_remove)
>>>>>   	mutex_unlock(&mdev_list_lock);
>>>>>
>>>>>   	type = to_mdev_type(mdev->type_kobj);
>>>>> +	mdev_remove_sysfs_files(dev, type);
>>>>> +	device_del(&mdev->dev);
>>>>>   	parent = mdev->parent;
>>>>> +	ret = parent->ops->remove(mdev);
>>>>> +	if (ret)
>>>>> +		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
>>>>
>>>> I think carrying on with removal regardless of the return code of
>>>> the
>>>> ->remove callback makes sense, as it simply matches usual practice.
>>>> However, are we sure that every vendor driver works well with that?
>>>> I think it should, as removal from bus unregistration (vs. from the
>>>> sysfs
>>>> file) was always something it could not veto, but have you looked at
>>>> the individual drivers?
>>>>
>>> I looked at following drivers a little while back.
>>> Looked again now.
>>>
>>> drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in
>> intel_vgpu_release(), which should finish first before remove() is invoked.
>>>
>>> s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c
>> remove() always returns 0.
>>> s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm null,
>> which should finish before remove() is invoked.
>>
>> That one is giving me a bit of a headache (the ->kvm reference is supposed
>> to keep us from detaching while a vm is running), so let's cc:
>> the vfio-ap maintainers to see whether they have any concerns.
>>
> I probably wrote wrongly.
> vfio_ap_mdev_remove() fails if the VM is already running (i.e. vfio_ap_mdev_release() is not yet called).
> 
> And if VM is running it guarded by the vfio_mdev driver which is the one who binds to the device mdev device.
> That is why I shown the above stack trace in the commit log, indicating that vfio driver is guarding it.
> 

I looked again, and see the race you are speaking of, it is not the one 
I thought first, which does not really mater at this stage of the driver 
but indeed between release and remove we do not take the lock in the 
right way.

We will correct this.
Thanks,

Pierre


>>> samples/vfio-mdev/mbochs.c mbochs_remove() always returns 0.
>>>
>>>>>
>>>>> -	ret = mdev_device_remove_ops(mdev, force_remove);
>>>>> -	if (ret) {
>>>>> -		mdev->active = true;
>>>>> -		return ret;
>>>>> -	}
>>>>> -
>>>>> -	mdev_remove_sysfs_files(dev, type);
>>>>> -	device_unregister(dev);
>>>>> +	/* Balances with device_initialize() */
>>>>> +	put_device(&mdev->dev);
>>>>>   	mdev_put_parent(parent);
>>>>>
>>>>>   	return 0;
>>>>
>>>> I think that looks sane in general, but the commit message might
>>>> benefit from tweaking.
>>> Part of your description is more crisp than my commit message, I can
>> probably take snippet from it to improve?
>>> Or any specific entries in commit message that I should address?
>>
>> I have added some comments inline (mostly some wording tweaks).
>>
>> Feel free to take anything from my summary as well.
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

