Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C91623E90
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKJJ1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 04:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiKJJ1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 04:27:16 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361836A6B2
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 01:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668072435; x=1699608435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DjFcL5BKDS3lx6Tya3zdhgH6ECLByTkf5CQ6PVKRDKk=;
  b=gfjY3dfxanM8PLF6E+3UplP4fygEB7VGVma1Oo5MNBbI5GPGcQdg03RE
   uAxlykxXe6HM2r6Gs5qA1rMzjKXLLuVA5vzLgzpNO0JCZG7DrBcjhLsLR
   U3p7qtcG1mN8UFwC/pznBy4RmIqHdFcaaCtcYKg2sS+J+jOUWu9XUwSt2
   pGO9G9LOx5FQ8XDtXfdoJlWLQAp2MxUtsV6zlNw0x+Vu0daLtkkoZlv30
   AEG7rEbsh6Wvl0jlPxbKy9YCi6vPpF03jqoUk3AfOsx1LCu1gk1HAGrAY
   +Z0njqyTPOXRNriBWr5AI2BHEYB37kic7EPZYMgm7lH/QYd05mz2fH+rE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="298760016"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="298760016"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 01:27:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="706077499"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="706077499"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.70]) ([10.249.171.70])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 01:27:12 -0800
Message-ID: <604ae2ce-5e00-3d08-fcfb-0d3fd3c505a3@intel.com>
Date:   Thu, 10 Nov 2022 17:27:10 +0800
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
 <3286ad00-e432-da69-a041-6a3032494470@intel.com>
 <CACGkMEuca97Cv+XuKxmHHHgAQYsayZvJRtpONCCqcEE8qMu5Kw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEuca97Cv+XuKxmHHHgAQYsayZvJRtpONCCqcEE8qMu5Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2022 5:13 PM, Jason Wang wrote:
> On Thu, Nov 10, 2022 at 4:59 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 11/10/2022 2:29 PM, Jason Wang wrote:
>>> 在 2022/11/10 14:20, Zhu, Lingshan 写道:
>>>>
>>>> On 11/10/2022 11:49 AM, Jason Wang wrote:
>>>>> On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan
>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>
>>>>>> On 11/9/2022 4:59 PM, Jason Wang wrote:
>>>>>>> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan
>>>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>>> On 11/9/2022 2:51 PM, Jason Wang wrote:
>>>>>>>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan
>>>>>>>>> <lingshan.zhu@intel.com> wrote:
>>>>>>>>>> This series implements features provisioning for ifcvf.
>>>>>>>>>> By applying this series, we allow userspace to create
>>>>>>>>>> a vDPA device with selected (management device supported)
>>>>>>>>>> feature bits and mask out others.
>>>>>>>>> I don't see a direct relationship between the first 3 and the last.
>>>>>>>>> Maybe you can state the reason why the restructure is a must for
>>>>>>>>> the
>>>>>>>>> feature provisioning. Otherwise, we'd better split the series.
>>>>>>>> When introducing features provisioning ability to ifcvf, there is
>>>>>>>> a need
>>>>>>>> to re-create vDPA devices
>>>>>>>> on a VF with different feature bits.
>>>>>>> This seems a requirement even without feature provisioning? Device
>>>>>>> could be deleted from the management device anyhow.
>>>>>> Yes, we need this to delete and re-create a vDPA device.
>>>>> I wonder if we need something that works for -stable.
>>>> I can add a fix tag, so these three patches could apply to stable
>>>
>>> It's too huge for -stable.
>>>
>>>
>>>>> AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
>>>>> and it seems to work?
>>>> Yes and this is done in this series and that's why we need these
>>>> refactoring code.
>>>
>>> I meant there's probably no need to change the association of existing
>>> structure but just do the allocation in dev_add(), then we will have a
>>> patch with much more small changeset that fit for -stable.
>> Patch 1(ifcvf_base only work on ifcvf_hw) and patch 2(irq functions only
>> work on ifcvf_hw) are not needed for stable.
>> I have already done this allocation of ifcvf_adapter which is the
>> container of struct vdpa_device in dev_add() in Patch 3, this should be
>> merged to stable.
>> Patch 3 is huge but necessary, not only allocate ifcvf_adapter in
>> dev_add(), it also refactors the structures of ifcvf_mgmt_dev and
>> ifcvf_adapter,
>> because we need to initialize the VF's hw structure ifcvf_hw(which was a
>> member of ifcvf_adapter but now should be a member of ifcvf_mgmt_dev) in
>> probe.
>>
>> Is it still huge?
> Then please reorder the patches, stable-kernel-rules.rst said:
>
>   - It cannot be bigger than 100 lines, with context.
>
> Let's see.
It is over 180 lines, so maybe re-ordering can not help here, I will try 
to split patch 3.

Thanks,
Zhu Lingshan
>
> Thanks
>
>> Thanks
>>> Thanks
>>>
>>>
>>>> By the way, do you have any comments to the patches?
>>>>
>>>> Thanks,
>>>> Zhu Lingshan
>>>>> Thanks
>>>>>
>>>>>> We create vDPA device from a VF, so without features provisioning
>>>>>> requirements,
>>>>>> we don't need to re-create the vDPA device. But with features
>>>>>> provisioning,
>>>>>> it is a must now.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>> Thakns
>>>>>>>
>>>>>>>> When remove a vDPA device, the container of struct vdpa_device
>>>>>>>> (here is
>>>>>>>> ifcvf_adapter) is free-ed in
>>>>>>>> dev_del() interface, so we need to allocate ifcvf_adapter in
>>>>>>>> dev_add()
>>>>>>>> than in probe(). That's
>>>>>>>> why I have re-factored the adapter/mgmt_dev code.
>>>>>>>>
>>>>>>>> For re-factoring the irq related code and ifcvf_base, let them
>>>>>>>> work on
>>>>>>>> struct ifcvf_hw, the
>>>>>>>> reason is that the adapter is allocated in dev_add(), if we want
>>>>>>>> theses
>>>>>>>> functions to work
>>>>>>>> before dev_add(), like in probe, we need them work on ifcvf_hw
>>>>>>>> than the
>>>>>>>> adapter.
>>>>>>>>
>>>>>>>> Thanks
>>>>>>>> Zhu Lingshan
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>> Please help review
>>>>>>>>>>
>>>>>>>>>> Thanks
>>>>>>>>>>
>>>>>>>>>> Zhu Lingshan (4):
>>>>>>>>>>       vDPA/ifcvf: ifcvf base layer interfaces work on struct
>>>>>>>>>> ifcvf_hw
>>>>>>>>>>       vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>>>>>>>>>>       vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>>>>>>>>>>       vDPA/ifcvf: implement features provisioning
>>>>>>>>>>
>>>>>>>>>>      drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>>>>>>>>>      drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>>>>>>>>>      drivers/vdpa/ifcvf/ifcvf_main.c | 156
>>>>>>>>>> +++++++++++++++-----------------
>>>>>>>>>>      3 files changed, 89 insertions(+), 109 deletions(-)
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> 2.31.1
>>>>>>>>>>

