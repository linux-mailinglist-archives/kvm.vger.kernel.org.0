Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF7132073
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 08:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgAGH2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 02:28:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1075 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgAGH2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 02:28:37 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1432f40000>; Mon, 06 Jan 2020 23:27:48 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 06 Jan 2020 23:28:36 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 06 Jan 2020 23:28:36 -0800
Received: from [10.40.100.83] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 07:28:26 +0000
Subject: Re: [PATCH v10 Kernel 1/5] vfio: KABI for migration interface for
 device state
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <jonathan.davies@nutanix.com>, <eauger@redhat.com>,
        <aik@ozlabs.ru>, <pasic@linux.ibm.com>, <felipe@nutanix.com>,
        <Zhengxiao.zx@alibaba-inc.com>, <shuangtai.tst@alibaba-inc.com>,
        <Ken.Xue@amd.com>, <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-2-git-send-email-kwankhede@nvidia.com>
 <20191216154406.023f912b@x1.home>
 <f773a92a-acbd-874d-34ba-36c1e9ffe442@nvidia.com>
 <20191217114357.6496f748@x1.home>
 <3527321f-e310-8324-632c-339b22f15de5@nvidia.com>
 <20191219102706.0a316707@x1.home>
 <928e41b5-c3fd-ed75-abd6-ada05cda91c9@nvidia.com>
 <20191219140929.09fa24da@x1.home> <20200102182537.GK2927@work-vm>
 <20200106161851.07871e28@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <ce132929-64a7-9a5b-81ff-38616202b757@nvidia.com>
Date:   Tue, 7 Jan 2020 12:58:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106161851.07871e28@w520.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578382068; bh=dzCb4GaxrhXuuZAVIohUXfWRe9Imjaf4D1VnoLy2doc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HLu+tskabfkeEqDBKF1tgEOLuVAcSMhXO68HZGX6tmPV8zmxHxnWEigSXnj9DHZKd
         doqjIkPok9rXn6YuzZsyiWaN1GCMzi3AGtXRm/HaH7K1SvDO1EJHX7FnZPG9w3uLgN
         6V4NT7L3r3HOsLZDja4WQuRnnNkq5Cfauis5WSuHM2+AuzajGV43+JBFd0Hj02Ph7a
         5Qi/eGzW2mZbnW6WaQOtBJi2GowszuDTcfMSiuCiQheR6pKTpHw2cNKwl0Z8vSEdNF
         QJio2umKX/oe1uT0z31dZLka0FJUqnas8vnC142h3f1ZcY3RO+rLnrRHNXDUm7K1dG
         BvbKX9+Sj75bQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/7/2020 4:48 AM, Alex Williamson wrote:
> On Thu, 2 Jan 2020 18:25:37 +0000
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
>> * Alex Williamson (alex.williamson@redhat.com) wrote:
>>> On Fri, 20 Dec 2019 01:40:35 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    
>>>> On 12/19/2019 10:57 PM, Alex Williamson wrote:
>>>>
>>>> <Snip>
>>>>    
>>
>> <snip>
>>
>>>>
>>>> If device state it at pre-copy state (011b).
>>>> Transition, i.e., write to device state as stop-and-copy state (010b)
>>>> failed, then by previous state I meant device should return pre-copy
>>>> state(011b), i.e. previous state which was successfully set, or as you
>>>> said current state which was successfully set.
>>>
>>> Yes, the point I'm trying to make is that this version of the spec
>>> tries to tell the user what they should do upon error according to our
>>> current interpretation of the QEMU migration protocol.  We're not
>>> defining the QEMU migration protocol, we're defining something that can
>>> be used in a way to support that protocol.  So I think we should be
>>> concerned with defining our spec, for example my proposal would be: "If
>>> a state transition fails the user can read device_state to determine the
>>> current state of the device.  This should be the previous state of the
>>> device unless the vendor driver has encountered an internal error, in
>>> which case the device may report the invalid device_state 110b.  The
>>> user must use the device reset ioctl in order to recover the device
>>> from this state.  If the device is indicated in a valid device state
>>> via reading device_state, the user may attempt to transition the device
>>> to any valid state reachable from the current state."
>>
>> We might want to be able to distinguish between:
>>    a) The device has failed and needs a reset
>>    b) The migration has failed
> 
> I think the above provides this.  For Kirti's example above of
> transitioning from pre-copy to stop-and-copy, the device could refuse
> to transition to stop-and-copy, generating an error on the write() of
> device_state.  The user re-reading device_state would allow them to
> determine the current device state, still in pre-copy or failed.  Only
> the latter would require a device reset.
> 
>> If some part of the devices mechanics for migration fail, but the device
>> is otherwise operational then we should be able to decide to fail the
>> migration without taking the device down, which might be very bad for
>> the VM.
>> Losing a VM during migration due to a problem with migration really
>> annoys users; it's one thing the migration failing, but taking the VM
>> out as well really gets to them.
>>
>> Having the device automatically transition back to the 'running' state
>> seems a bad idea to me; much better to tell the hypervisor and provide
>> it with a way to clean up; for example, imagine a system with multiple
>> devices that are being migrated, most of them have happily transitioned
>> to stop-and-copy, but then the last device decides to fail - so now
>> someone is going to have to take all of them back to running.
> 
> Right, unless I'm missing one, it seems invalid->running is the only
> self transition the device should make, though still by way of user
> interaction via the reset ioctl.  Thanks,
> 

Instead of using invalid state by vendor driver on device failure, I 
think better to reserve one bit in device state which vendor driver can 
set on device failure. When error bit is set, other bits in device state 
should be ignored.

Thanks,
Kirti
