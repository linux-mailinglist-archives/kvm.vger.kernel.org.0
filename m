Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 344EFFB986
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 21:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfKMURR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 15:17:17 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4797 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfKMURR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 15:17:17 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc64cf0000>; Wed, 13 Nov 2019 12:17:19 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 12:17:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 12:17:16 -0800
Received: from [10.25.73.195] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 20:17:08 +0000
Subject: Re: [PATCH v9 Kernel 1/5] vfio: KABI for migration interface for
 device state
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
 <20191112153005.53bf324c@x1.home> <20191113112417.6e40ce96.cohuck@redhat.com>
 <20191113112733.49542ebc@x1.home>
 <94592507-fadb-0f10-ee17-f8d5678c70e5@nvidia.com>
 <20191113124818.2b5be89d@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <f0673bfe-7db9-d54d-ce2a-c4b834543478@nvidia.com>
Date:   Thu, 14 Nov 2019 01:47:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191113124818.2b5be89d@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573676240; bh=DHOHiB4ImG16t5YYfA/EGzbykv4Qjn/Uga8j+2nz0nA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=czzAc6sv4BtazbPm4Rftnd4+v+o1JhYBUqno9ar4+HFqjDT8DoJZpVFfpZ/ikyShL
         OTnwQAzEMqhktT8JN5VKPREOWSGznLhpY0WdtLZAM2JcT0mY7GbGkzgpsWGklxoZSy
         4gna/JsaSKNh1mdFgdqpKSEOwSVN8eHlSoDzUOTejawtHJ+O6WLb5AzHJ3gpiH+/eQ
         1b4IZ2CjKkcMomm08vgn7kxnnCjrH9q/bY9s3DNOmJXl+Yh9s8Wgy6gFrslsukzCSE
         k/HDBKP7jodiFeVazS93lPBL2MN/BOby9yIuy9nT61c9qI4K8MFwnln3VyPWgfRJpC
         f7bWW7+x15twA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/14/2019 1:18 AM, Alex Williamson wrote:
> On Thu, 14 Nov 2019 00:59:52 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 11/13/2019 11:57 PM, Alex Williamson wrote:
>>> On Wed, 13 Nov 2019 11:24:17 +0100
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>    
>>>> On Tue, 12 Nov 2019 15:30:05 -0700
>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>   
>>>>> On Tue, 12 Nov 2019 22:33:36 +0530
>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>       
>>>>>> - Defined MIGRATION region type and sub-type.
>>>>>> - Used 3 bits to define VFIO device states.
>>>>>>       Bit 0 => _RUNNING
>>>>>>       Bit 1 => _SAVING
>>>>>>       Bit 2 => _RESUMING
>>>>>>       Combination of these bits defines VFIO device's state during migration
>>>>>>       _RUNNING => Normal VFIO device running state. When its reset, it
>>>>>> 		indicates _STOPPED state. when device is changed to
>>>>>> 		_STOPPED, driver should stop device before write()
>>>>>> 		returns.
>>>>>>       _SAVING | _RUNNING => vCPUs are running, VFIO device is running but
>>>>>>                             start saving state of device i.e. pre-copy state
>>>>>>       _SAVING  => vCPUs are stopped, VFIO device should be stopped, and
>>>>>
>>>>> s/should/must/
>>>>>       
>>>>>>                   save device state,i.e. stop-n-copy state
>>>>>>       _RESUMING => VFIO device resuming state.
>>>>>>       _SAVING | _RESUMING and _RUNNING | _RESUMING => Invalid states
>>>>>
>>>>> A table might be useful here and in the uapi header to indicate valid
>>>>> states:
>>>>
>>>> I like that.
>>>>   
>>>>>
>>>>> | _RESUMING | _SAVING | _RUNNING | Description
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     0     |    0    |     0    | Stopped, not saving or resuming (a)
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     0     |    0    |     1    | Running, default state
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     0     |    1    |     0    | Stopped, migration interface in save mode
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     0     |    1    |     1    | Running, save mode interface, iterative
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     1     |    0    |     0    | Stopped, migration resume interface active
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     1     |    0    |     1    | Invalid (b)
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     1     |    1    |     0    | Invalid (c)
>>>>> +-----------+---------+----------+------------------------------------------
>>>>> |     1     |    1    |     1    | Invalid (d)
>>>>>
>>>>> I think we need to consider whether we define (a) as generally
>>>>> available, for instance we might want to use it for diagnostics or a
>>>>> fatal error condition outside of migration.
>>>>>
>>>>> Are there hidden assumptions between state transitions here or are
>>>>> there specific next possible state diagrams that we need to include as
>>>>> well?
>>>>
>>>> Some kind of state-change diagram might be useful in addition to the
>>>> textual description anyway. Let me try, just to make sure I understand
>>>> this correctly:
>>>>   
>>
>> During User application initialization, there is one more state change:
>>
>> 0) 0/0/0 ---- stop to running -----> 0/0/1
> 
> 0/0/0 cannot be the initial state of the device, that would imply that
> a device supporting this migration interface breaks backwards
> compatibility with all existing vfio userspace code and that code needs
> to learn to set the device running as part of its initialization.
> That's absolutely unacceptable.  The initial device state must be 0/0/1.
> 

There isn't any device state for all existing vfio userspace code right 
now. So default its assumed to be always running.

With migration support, device states are explicitly getting added. For 
example, in case of QEMU, while device is getting initialized, i.e. from 
vfio_realize(), device_state is set to 0/0/0, but not required to convey 
it to vendor driver. Then with vfio_vmstate_change() notifier, device 
state is changed to 0/0/1 when VM/vCPU are transitioned to running, at 
this moment device state is conveyed to vendor driver. So vendor driver 
doesn't see 0/0/0 state.

While resuming, for userspace, for example QEMU, device state change is 
from 0/0/0 to 1/0/0, vendor driver see 1/0/0 after device basic 
initialization is done.


>>>> 1) 0/0/1 ---(trigger driver to start gathering state info)---> 0/1/1
>>
>> not just gathering state info, but also copy device state to be
>> transferred during pre-copy phase.
>>
>> Below 2 state are not just to tell driver to stop, those 2 differ.
>> 2) is device state changed from running to stop, this is when VM
>> shutdowns cleanly, no need to save device state
> 
> Userspace is under no obligation to perform this state change though,
> backwards compatibility dictates this.
>   
>>>> 2) 0/0/1 ---(tell driver to stop)---> 0/0/0
>>
>>>> 3) 0/1/1 ---(tell driver to stop)---> 0/1/0
>>
>> above is transition from pre-copy phase to stop-and-copy phase, where
>> device data should be made available to user to transfer to destination
>> or to save it to file in case of save VM or suspend.
>>
>>
>>>> 4) 0/0/1 ---(tell driver to resume with provided info)---> 1/0/0
>>>
>>> I think this is to switch into resuming mode, the data will follow >
>>>> 5) 1/0/0 ---(driver is ready)---> 0/0/1
>>>> 6) 0/1/1 ---(tell driver to stop saving)---> 0/0/1
>>>   
>>
>> above can occur on migration cancelled or failed.
>>
>>
>>> I think also:
>>>
>>> 0/0/1 --> 0/1/0 If user chooses to go directly to stop and copy
>>
>> that's right, this happens in case of save VM or suspend VM.
>>
>>>
>>> 0/0/0 and 0/0/1 should be reachable from any state, though I could see
>>> that a vendor driver could fail transition from 1/0/0 -> 0/0/1 if the
>>> received state is incomplete.  Somehow though a user always needs to
>>> return the device to the initial state, so how does device_state
>>> interact with the reset ioctl?  Would this automatically manipulate
>>> device_state back to 0/0/1?
>>
>> why would reset occur on 1/0/0 -> 0/0/1 failure?
> 
> The question is whether the reset ioctl automatically puts the device
> back into the initial state, 0/0/1.  A reset from 1/0/0 -> 0/0/1
> presumably discards much of the device state we just restored, so
> clearly that would be undesirable.
>   
>> 1/0/0 -> 0/0/1 fails, then user should convey that to source that
>> migration has failed, then resume at source.
> 
> In the scheme of the migration yet, but as far as the vfio interface is
> concerned the user should have a path to make use of a device after
> this point without closing it and starting over.  Thus, if a 1/0/0 ->
> 0/0/1 transition fails, would we define the device reset ioctl as a
> mechanism to flush the bogus state and place the device into the 0/0/1
> initial state?
>

Ok, userspace applications can be designed to do that. As of now with 
QEMU, I don't see a way to reset device on 1/0/0-> 0/0/1 failure.


>>>      
>>>> Not sure about the usefulness of 2).
>>
>> I explained this above.
>>
>>>> Also, is 4) the only way to
>>>> trigger resuming?
>> Yes.
>>
>>>> And is the change in 5) performed by the driver, or
>>>> by userspace?
>>>>   
>> By userspace.
>>
>>>> Are any other state transitions valid?
>>>>
>>>> (...)
>>>>   
>>>>>> + * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
>>>>>> + * and for _SAVING device state or stop-and-copy phase:
>>>>>> + * a. read pending_bytes. If pending_bytes > 0, go through below steps.
>>>>>> + * b. read data_offset, indicates kernel driver to write data to staging buffer.
>>>>>> + *    Kernel driver should return this read operation only after writing data to
>>>>>> + *    staging buffer is done.
>>>>>
>>>>> "staging buffer" implies a vendor driver implementation, perhaps we
>>>>> could just state that data is available from (region + data_offset) to
>>>>> (region + data_offset + data_size) upon return of this read operation.
>>>>>       
>>>>>> + * c. read data_size, amount of data in bytes written by vendor driver in
>>>>>> + *    migration region.
>>>>>> + * d. read data_size bytes of data from data_offset in the migration region.
>>>>>> + * e. process data.
>>>>>> + * f. Loop through a to e. Next read on pending_bytes indicates that read data
>>>>>> + *    operation from migration region for previous iteration is done.
>>>>>
>>>>> I think this indicate that step (f) should be to read pending_bytes, the
>>>>> read sequence is not complete until this step.  Optionally the user can
>>>>> then proceed to step (b).  There are no read side-effects of (a) afaict.
>>>>>
>>>>> Is the use required to reach pending_bytes == 0 before changing
>>>>> device_state, particularly transitioning to !_RUNNING?  Presumably the
>>>>> user can exit this sequence at any time by clearing _SAVING.
>>>>
>>>> That would be transition 6) above (abort saving and continue). I think
>>>> it makes sense not to forbid this.
>>>>   
>>>>>       
>>>>>> + *
>>>>>> + * Sequence to be followed while _RESUMING device state:
>>>>>> + * While data for this device is available, repeat below steps:
>>>>>> + * a. read data_offset from where user application should write data.
>>>>>> + * b. write data of data_size to migration region from data_offset.
>>>>>> + * c. write data_size which indicates vendor driver that data is written in
>>>>>> + *    staging buffer. Vendor driver should read this data from migration
>>>>>> + *    region and resume device's state.
>>>>>
>>>>> The device defaults to _RUNNING state, so a prerequisite is to set
>>>>> _RESUMING and clear _RUNNING, right?
>>>>   
>>
>> Sorry, I replied yes in my previous reply, but no. Default device state
>> is _STOPPED. During resume _STOPPED -> _RESUMING
> 
> Nope, it can't be, it must be _RUNNING.
> 
>>>> Transition 4) above. Do we need
>>
>> I think, its not required.
> 
> But above we say it's the only way to trigger resuming (4 was 0/0/1 ->
> 1/0/0).
> 
>>>> 7) 0/0/0 ---(tell driver to resume with provided info)---> 1/0/0
>>>> as well? (Probably depends on how sensible the 0/0/0 state is.)
>>>
>>> I think we must unless we require the user to transition from 0/0/1 to
>>> 1/0/0 in a single operation, but I'd prefer to make 0/0/0 generally
>>> available.  Thanks,
>>>    
>>
>> its 0/0/0 -> 1/0/0 while resuming.
> 
> I think we're starting with different initial states, IMO there is
> absolutely no way around 0/0/1 being the initial device state.
> Anything otherwise means that we cannot add migration support to an
> existing device and maintain compatibility with existing userspace.
> Thanks,
> 
Hope above explanation helps to resolve this concern.

Thanks,
Kirti
