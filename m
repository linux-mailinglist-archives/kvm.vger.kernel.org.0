Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B49623E25
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 09:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiKJI7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 03:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKJI67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 03:58:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CB6B4B3
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 00:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668070738; x=1699606738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Taky/eDmY8zE2pNKcx7/mrBZx3iMQ8bamvaFCuUdNdk=;
  b=ZVwSiGEk7u7VozYdqp6tWl5O+dRiO5cLOuy2x9Qu5DF7VGC6evjiwbBp
   lo2Uq+7qw3jk3FZ6IPSUoBgYASEXth6d738NM+jRIwuAmpFIZ/1E1YEtB
   bpdooUod6LLLRA3O3tPtM6/wiHGHqVGu0fTXJkXIPzDKyHfEGOdcwI8P8
   YcQkf64G6qES0P17CNrxqn/rIt4Y8o4lISZc/prQCNxo7OXjT8VkI6SDa
   5UKrtIfWgyj3EO4MDqZvlldW3bbCzm0f22Oolcm+JWEht7YpkjMwR/zH+
   maO+mv2vFIn0MxzXrtgzHp0Q/+b2V2swhuMN5wNv7XUeWZz22xYgntD9T
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375504302"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="375504302"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 00:58:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="811966711"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="811966711"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.70]) ([10.249.171.70])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 00:58:54 -0800
Message-ID: <3286ad00-e432-da69-a041-6a3032494470@intel.com>
Date:   Thu, 10 Nov 2022 16:58:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 0/4] ifcvf/vDPA implement features provisioning
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
References: <20221107093345.121648-1-lingshan.zhu@intel.com>
 <CACGkMEs9af1E1pLd2t8E71YBPF=rHkhfN8qO9_3=x6HVaCMAxg@mail.gmail.com>
 <0b15591f-9e49-6383-65eb-6673423f81ec@intel.com>
 <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
 <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com>
 <CACGkMEu-5TbA3Ky2qgn-ivfhgfJ2b12mDJgq8iNgHce8qu3ApA@mail.gmail.com>
 <03657084-98ab-93bc-614a-e6cc7297d93e@intel.com>
 <d59c311f-ba9f-4c00-28f8-c50e099adb9f@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <d59c311f-ba9f-4c00-28f8-c50e099adb9f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2022 2:29 PM, Jason Wang wrote:
>
> 在 2022/11/10 14:20, Zhu, Lingshan 写道:
>>
>>
>> On 11/10/2022 11:49 AM, Jason Wang wrote:
>>> On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan 
>>> <lingshan.zhu@intel.com> wrote:
>>>>
>>>>
>>>> On 11/9/2022 4:59 PM, Jason Wang wrote:
>>>>> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan 
>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>
>>>>>> On 11/9/2022 2:51 PM, Jason Wang wrote:
>>>>>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan 
>>>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>>> This series implements features provisioning for ifcvf.
>>>>>>>> By applying this series, we allow userspace to create
>>>>>>>> a vDPA device with selected (management device supported)
>>>>>>>> feature bits and mask out others.
>>>>>>> I don't see a direct relationship between the first 3 and the last.
>>>>>>> Maybe you can state the reason why the restructure is a must for 
>>>>>>> the
>>>>>>> feature provisioning. Otherwise, we'd better split the series.
>>>>>> When introducing features provisioning ability to ifcvf, there is 
>>>>>> a need
>>>>>> to re-create vDPA devices
>>>>>> on a VF with different feature bits.
>>>>> This seems a requirement even without feature provisioning? Device
>>>>> could be deleted from the management device anyhow.
>>>> Yes, we need this to delete and re-create a vDPA device.
>>> I wonder if we need something that works for -stable.
>> I can add a fix tag, so these three patches could apply to stable
>
>
> It's too huge for -stable.
>
>
>>>
>>> AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
>>> and it seems to work?
>> Yes and this is done in this series and that's why we need these
>> refactoring code.
>
>
> I meant there's probably no need to change the association of existing 
> structure but just do the allocation in dev_add(), then we will have a 
> patch with much more small changeset that fit for -stable.
Patch 1(ifcvf_base only work on ifcvf_hw) and patch 2(irq functions only 
work on ifcvf_hw) are not needed for stable.
I have already done this allocation of ifcvf_adapter which is the 
container of struct vdpa_device in dev_add() in Patch 3, this should be 
merged to stable.
Patch 3 is huge but necessary, not only allocate ifcvf_adapter in 
dev_add(), it also refactors the structures of ifcvf_mgmt_dev and 
ifcvf_adapter,
because we need to initialize the VF's hw structure ifcvf_hw(which was a 
member of ifcvf_adapter but now should be a member of ifcvf_mgmt_dev) in 
probe.

Is it still huge?

Thanks
>
> Thanks
>
>
>>
>> By the way, do you have any comments to the patches?
>>
>> Thanks,
>> Zhu Lingshan
>>>
>>> Thanks
>>>
>>>> We create vDPA device from a VF, so without features provisioning
>>>> requirements,
>>>> we don't need to re-create the vDPA device. But with features 
>>>> provisioning,
>>>> it is a must now.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>> Thakns
>>>>>
>>>>>> When remove a vDPA device, the container of struct vdpa_device 
>>>>>> (here is
>>>>>> ifcvf_adapter) is free-ed in
>>>>>> dev_del() interface, so we need to allocate ifcvf_adapter in 
>>>>>> dev_add()
>>>>>> than in probe(). That's
>>>>>> why I have re-factored the adapter/mgmt_dev code.
>>>>>>
>>>>>> For re-factoring the irq related code and ifcvf_base, let them 
>>>>>> work on
>>>>>> struct ifcvf_hw, the
>>>>>> reason is that the adapter is allocated in dev_add(), if we want 
>>>>>> theses
>>>>>> functions to work
>>>>>> before dev_add(), like in probe, we need them work on ifcvf_hw 
>>>>>> than the
>>>>>> adapter.
>>>>>>
>>>>>> Thanks
>>>>>> Zhu Lingshan
>>>>>>> Thanks
>>>>>>>
>>>>>>>> Please help review
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>>
>>>>>>>> Zhu Lingshan (4):
>>>>>>>>      vDPA/ifcvf: ifcvf base layer interfaces work on struct 
>>>>>>>> ifcvf_hw
>>>>>>>>      vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>>>>>>>>      vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>>>>>>>>      vDPA/ifcvf: implement features provisioning
>>>>>>>>
>>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>>>>>>>     drivers/vdpa/ifcvf/ifcvf_main.c | 156 
>>>>>>>> +++++++++++++++-----------------
>>>>>>>>     3 files changed, 89 insertions(+), 109 deletions(-)
>>>>>>>>
>>>>>>>> -- 
>>>>>>>> 2.31.1
>>>>>>>>
>>
>

