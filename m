Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4F9C5D5DC
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 20:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGBSEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 14:04:54 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3584 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBSEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 14:04:54 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1b9cbf0000>; Tue, 02 Jul 2019 11:04:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 02 Jul 2019 11:04:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 02 Jul 2019 11:04:50 -0700
Received: from [10.24.70.16] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Jul
 2019 18:04:44 +0000
Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Parav Pandit <parav@mellanox.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <156199271955.1646.13321360197612813634.stgit@gimli.home>
 <08597ab4-cc37-3973-8927-f1bc430f6185@nvidia.com>
 <20190701112442.176a8407@x1.home>
 <3b338e73-7929-df20-ca2b-3223ba4ead39@nvidia.com>
 <20190701140436.45eabf07@x1.home>
 <14783c81-0236-2f25-6193-c06aa83392c9@nvidia.com>
 <20190701234201.47b6f23a@x1.home>
 <AM0PR05MB48669DA5993C68765397AF1BD1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <b6afb6a7-0bd8-dff3-4a4b-a6bb34ccb61d@nvidia.com>
 <20190702070856.75c23a0c@x1.home>
 <e0ba170b-bd69-d8f7-10f1-c3426355c9c8@nvidia.com>
 <20190702084342.77b27b24@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <141dc7ed-4faf-6c32-4489-c2902495af7e@nvidia.com>
Date:   Tue, 2 Jul 2019 23:34:30 +0530
MIME-Version: 1.0
In-Reply-To: <20190702084342.77b27b24@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562090687; bh=emVzHAbVPHiM/XCX8a6ZFJEhJsDgU9lfSF7iq6ERKNo=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ZdnjY9XxSMeNECyCdZ700aqOOcYLu6NlojG3M2yufhirsjyVE2zkJ06zcQaW1fTwS
         wb4ZfwqZ52q0ZD8UWGHLSc0fYbVgL0g+kHNBs6xGjaXV2KhZNtjieW1PqWZELEgmwG
         voCIrma2aTtr1+EbMXMC2Pah0HYoSOTSdTp6L18Z4dskmvp/YpiU6OoHn135nDypeD
         zNtlLNCMqQ34kNasHsQMPCnY+Ng3/UHTN/2uS8ZB75k4VuQFVsZU7cTqjPp1HIKNda
         fiNrTOZXMlqhfJq+lh+DMBHJMGEaY+Lxl9K9+Bh2Uzoe0LZk3uYtWi3ZeO+M9Vye2b
         B4p3UCYYe+ZSQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2019 8:13 PM, Alex Williamson wrote:
> On Tue, 2 Jul 2019 19:10:17 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 7/2/2019 6:38 PM, Alex Williamson wrote:
>>> On Tue, 2 Jul 2019 18:17:41 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>   
>>>> On 7/2/2019 12:43 PM, Parav Pandit wrote:  
>>>>>
>>>>>     
>>>>>> -----Original Message-----
>>>>>> From: linux-kernel-owner@vger.kernel.org <linux-kernel-    
>>>>>> owner@vger.kernel.org> On Behalf Of Alex Williamson    
>>>>>> Sent: Tuesday, July 2, 2019 11:12 AM
>>>>>> To: Kirti Wankhede <kwankhede@nvidia.com>
>>>>>> Cc: cohuck@redhat.com; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
>>>>>> Subject: Re: [PATCH v2] mdev: Send uevents around parent device registration
>>>>>>
>>>>>> On Tue, 2 Jul 2019 10:25:04 +0530
>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>    
>>>>>>> On 7/2/2019 1:34 AM, Alex Williamson wrote:    
>>>>>>>> On Mon, 1 Jul 2019 23:20:35 +0530
>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>    
>>>>>>>>> On 7/1/2019 10:54 PM, Alex Williamson wrote:    
>>>>>>>>>> On Mon, 1 Jul 2019 22:43:10 +0530
>>>>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>>>>    
>>>>>>>>>>> On 7/1/2019 8:24 PM, Alex Williamson wrote:    
>>>>>>>>>>>> This allows udev to trigger rules when a parent device is
>>>>>>>>>>>> registered or unregistered from mdev.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>>
>>>>>>>>>>>> v2: Don't remove the dev_info(), Kirti requested they stay and
>>>>>>>>>>>>     removing them is only tangential to the goal of this change.
>>>>>>>>>>>>    
>>>>>>>>>>>
>>>>>>>>>>> Thanks.
>>>>>>>>>>>
>>>>>>>>>>>    
>>>>>>>>>>>>  drivers/vfio/mdev/mdev_core.c |    8 ++++++++
>>>>>>>>>>>>  1 file changed, 8 insertions(+)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/vfio/mdev/mdev_core.c
>>>>>>>>>>>> b/drivers/vfio/mdev/mdev_core.c index ae23151442cb..7fb268136c62
>>>>>>>>>>>> 100644
>>>>>>>>>>>> --- a/drivers/vfio/mdev/mdev_core.c
>>>>>>>>>>>> +++ b/drivers/vfio/mdev/mdev_core.c
>>>>>>>>>>>> @@ -146,6 +146,8 @@ int mdev_register_device(struct device *dev,
>>>>>>>>>>>> const struct mdev_parent_ops *ops)  {
>>>>>>>>>>>>  	int ret;
>>>>>>>>>>>>  	struct mdev_parent *parent;
>>>>>>>>>>>> +	char *env_string = "MDEV_STATE=registered";
>>>>>>>>>>>> +	char *envp[] = { env_string, NULL };
>>>>>>>>>>>>
>>>>>>>>>>>>  	/* check for mandatory ops */
>>>>>>>>>>>>  	if (!ops || !ops->create || !ops->remove ||
>>>>>>>>>>>> !ops->supported_type_groups) @@ -197,6 +199,8 @@ int    
>>>>>> mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)    
>>>>>>>>>>>>  	mutex_unlock(&parent_list_lock);
>>>>>>>>>>>>
>>>>>>>>>>>>  	dev_info(dev, "MDEV: Registered\n");
>>>>>>>>>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>>>>>>>>>>>> +
>>>>>>>>>>>>  	return 0;
>>>>>>>>>>>>
>>>>>>>>>>>>  add_dev_err:
>>>>>>>>>>>> @@ -220,6 +224,8 @@ EXPORT_SYMBOL(mdev_register_device);
>>>>>>>>>>>>  void mdev_unregister_device(struct device *dev)  {
>>>>>>>>>>>>  	struct mdev_parent *parent;
>>>>>>>>>>>> +	char *env_string = "MDEV_STATE=unregistered";
>>>>>>>>>>>> +	char *envp[] = { env_string, NULL };
>>>>>>>>>>>>
>>>>>>>>>>>>  	mutex_lock(&parent_list_lock);
>>>>>>>>>>>>  	parent = __find_parent_device(dev); @@ -243,6 +249,8 @@    
>>>>>> void    
>>>>>>>>>>>> mdev_unregister_device(struct device *dev)
>>>>>>>>>>>>  	up_write(&parent->unreg_sem);
>>>>>>>>>>>>
>>>>>>>>>>>>  	mdev_put_parent(parent);
>>>>>>>>>>>> +
>>>>>>>>>>>> +	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);    
>>>>>>>>>>>
>>>>>>>>>>> mdev_put_parent() calls put_device(dev). If this is the last
>>>>>>>>>>> instance holding device, then on put_device(dev) dev would get freed.
>>>>>>>>>>>
>>>>>>>>>>> This event should be before mdev_put_parent()    
>>>>>>>>>>
>>>>>>>>>> So you're suggesting the vendor driver is calling
>>>>>>>>>> mdev_unregister_device() without a reference to the struct device
>>>>>>>>>> that it's passing to unregister?  Sounds bogus to me.  We take a
>>>>>>>>>> reference to the device so that it can't disappear out from under
>>>>>>>>>> us, the caller cannot rely on our reference and the caller
>>>>>>>>>> provided the struct device.  Thanks,
>>>>>>>>>>    
>>>>>>>>>
>>>>>>>>> 1. Register uevent is sent after mdev holding reference to device,
>>>>>>>>> then ideally, unregister path should be mirror of register path,
>>>>>>>>> send uevent and then release the reference to device.    
>>>>>>>>
>>>>>>>> I don't see the relevance here.  We're marking an event, not
>>>>>>>> unwinding state of the device from the registration process.
>>>>>>>> Additionally, the event we're trying to mark is the completion of
>>>>>>>> each process, so the notion that we need to mirror the ordering between    
>>>>>> the two is invalid.    
>>>>>>>>    
>>>>>>>>> 2. I agree that vendor driver shouldn't call
>>>>>>>>> mdev_unregister_device() without holding reference to device. But
>>>>>>>>> to be on safer side, if ever such case occur, to avoid any
>>>>>>>>> segmentation fault in kernel, better to send event before mdev release the    
>>>>>> reference to device.    
>>>>>>>>
>>>>>>>> I know that get_device() and put_device() are GPL symbols and that's
>>>>>>>> a bit of an issue, but I don't think we should be kludging the code
>>>>>>>> for a vendor driver that might have problems with that.  A) we're
>>>>>>>> using the caller provided device  for the uevent, B) we're only
>>>>>>>> releasing our own reference to the device that was acquired during
>>>>>>>> registration, the vendor driver must have other references,    
>>>>>>>
>>>>>>> Are you going to assume that someone/vendor driver is always going to
>>>>>>> do right thing?    
>>>>>>
>>>>>> mdev is a kernel driver, we make reasonable assumptions that other drivers
>>>>>> interact with it correctly.
>>>>>>    
>>>>> That is right.
>>>>> Vendor drivers must invoke mdev_register_device() and mdev_unregister_device() only once.
>>>>> And it must have a valid reference to the device for which it is invoking it.
>>>>> This is basic programming practice that a given driver has to follow.
>>>>> mdev_register_device() has a loop to check. It needs to WARN_ON there if there are duplicate registration.
>>>>> Similarly on mdev_unregister_device() to have WARN_ON if device is not found.    
>>>>
>>>> If assumption is vendor driver is always going to do right way, then why
>>>> need check for duplicate registration? vendor driver is always going to
>>>> do it right way, right?  
>>>
>>> Are we intentionally misinterpreting "reasonable assumptions" here?
>>>   
>>>>> It was in my TODO list to submit those patches.
>>>>> I was still thinking to that mdev_register_device() should return mdev_parent and mdev_unregister_device() should accept mdev_parent pointer, instead of WARN_ON on unregister().
>>>>>
>>>>>     
>>>>>>>> C) the parent device
>>>>>>>> generally lives on a bus, with a vendor driver, there's an entire
>>>>>>>> ecosystem of references to the device below mdev.  Is this a
>>>>>>>> paranoia request or are you really concerned that your PCI device suddenly
>>>>>>>> disappears when mdev's reference to it disappears.    
>>>>>>>
>>>>>>> mdev infrastructure is not always used by PCI devices. It is designed
>>>>>>> to be generic, so that other devices (other than PCI devices) can also
>>>>>>> use this framework.    
>>>>>>
>>>>>> Obviously mdev is not PCI specific, I only mention it because I'm asking if you
>>>>>> have a specific concern in mind.  If you did, I'd assume it's related to a PCI
>>>>>> backed vGPU.    
>>>>
>>>> Its not always good to assume certain things.  
>>>
>>> It was only an attempt to relate to a specific issue that might concern
>>> you.
>>>   
>>>>>> Any physical parent device of an mdev is likely to have some sort
>>>>>> of bus infrastructure behind it holding references to the device (ie. a probe and
>>>>>> release where an implicit reference is held between these points).  A virtual
>>>>>> device would be similar, it's created as part of a module init and destroyed as
>>>>>> part of a module exit, where mdev registration would exist between these
>>>>>> points.
>>>>>>    
>>>>>>> If there is a assumption that user of mdev framework or vendor drivers
>>>>>>> are always going to use mdev in right way, then there is no need for
>>>>>>> mdev core to held reference of the device?
>>>>>>> This is not a "paranoia request". This is more of a ideal scenario,
>>>>>>> mdev should use device by holding its reference rather than assuming
>>>>>>> (or relying on) someone else holding the reference of device.    
>>>>>>
>>>>>> In fact, at one point Parav was proposing removing these references entirely,
>>>>>> but Connie and I both felt uncomfortable about that.  I think it's good practice
>>>>>> that mdev indicates the use of the parent device by incrementing the reference
>>>>>> count, with each child mdev device also taking a reference, but those
>>>>>> references balance out within the mdev core.  Their purpose is not to maintain
>>>>>> the device for outside callers, nor should outside callers assume mdev's use of
>>>>>> references to release their own.  I don't think it's unreasonable to assume that
>>>>>> the caller should have a legitimate reference to the object it's providing to this
>>>>>> function and therefore we should be able to use it after mdev's internal
>>>>>> references are balanced out.  Thanks,
>>>>>>    
>>>>
>>>> I'm not fully convinced with what is the advantage of sending uevent
>>>> after releasing reference to device or disadvantage of sending uevent
>>>> before releasing reference to device.  
>>>
>>> If mdev-core still holds a reference to the device, is it fully
>>> unregistered?  Why not send the uevent at the point where the
>>> notification is actually true?
>>>  
>>
>> By that time, device is removed from parent list, each child is removed
>> and sysfs files related to that parent are removed so that no new child
>> can be created, which means device is unregistered, only mdev_parent
>> structure is not yet freed which gets freed from mdev_put_parent().
> 
> So you're saying it's 95% unregistered, but there's still a tracking
> structure yet to free,

Its almost unregistered, that tracking structure is unusable since all
other interfaces are already removed and it is also removed from parent
list.

> so go ahead an send a uevent just in case the
> caller didn't have a valid reference to the device they passed and it
> might get freed.  Isn't this the original request which we've decided
> is unreasonable paranoia?  Please cite an instance where this makes any
> sense.  Someone called us with a reference to the device to register
> with mdev.  The references we've acquired are entirely balanced within
> the mdev-core and you're suggesting that the unregistration caller has
> released their own reference to the device and now relies on ours,
> which we're under no obligation to hold in the first place.  We're
> using a caller provided object after tearing down our own internal
> tracking, which should have no bearing on external tracking of this
> object.  How can that be an issue?  Thanks,
> 

You gave a reference in previous mail, release is deferred via workqueue

> If CONFIG_DEBUG_KOBJECT_RELEASE is enabled then the deletion of the
> kobject can occur at some random delay after the last reference is
> removed via a workqueue,

similarly if someone defers unregistration, this situation might occur.
Again this is a very acute corner case.
I still think right way is to use device by holding its reference rather
than assuming someone else holding the reference of device.

Thanks,
Kirti
