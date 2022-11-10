Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09AA623BB0
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKJGUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKJGUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:20:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B76E2A40D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 22:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668061216; x=1699597216;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hGWyxUkydtXJwvX4mK86sh+r5ydD25pAvx1mMuicHDs=;
  b=UuZImFDI44ZoKE/2cUGMkBrddZZ+6Kjc46kLD+bOytcacMPgasdd2J4M
   k9obyyp/8HbRuhwHpX+SntawQMwIvQcX3TwvkT0HWXMpMf/SOIyTxCbgD
   2MBcgbWmQ5g/NKOeb5RgWHJnkpvipFq6ueagd/43Br1+MWPi1z5Eo0njL
   pWGsuB6Wc6JItZzgcUP30WJsSGNbxW5o6M9LdK2YarU9ep/AedfWk80+p
   6kJXR4ihKXoUD3W1jPsEit8VcHfPdwF+T+ti1NLZjTmcj/Yk/ERtAOCTj
   +pSVEKi0PXHjFNpwnFSsbUcgiqTDmo5DlLIMZRREUWJCCjPW0gzCvFKF4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="290944328"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="290944328"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:20:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="779647842"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="779647842"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.70]) ([10.249.171.70])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:20:14 -0800
Message-ID: <03657084-98ab-93bc-614a-e6cc7297d93e@intel.com>
Date:   Thu, 10 Nov 2022 14:20:12 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEu-5TbA3Ky2qgn-ivfhgfJ2b12mDJgq8iNgHce8qu3ApA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2022 11:49 AM, Jason Wang wrote:
> On Wed, Nov 9, 2022 at 5:06 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 11/9/2022 4:59 PM, Jason Wang wrote:
>>> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>>>
>>>> On 11/9/2022 2:51 PM, Jason Wang wrote:
>>>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>>>> This series implements features provisioning for ifcvf.
>>>>>> By applying this series, we allow userspace to create
>>>>>> a vDPA device with selected (management device supported)
>>>>>> feature bits and mask out others.
>>>>> I don't see a direct relationship between the first 3 and the last.
>>>>> Maybe you can state the reason why the restructure is a must for the
>>>>> feature provisioning. Otherwise, we'd better split the series.
>>>> When introducing features provisioning ability to ifcvf, there is a need
>>>> to re-create vDPA devices
>>>> on a VF with different feature bits.
>>> This seems a requirement even without feature provisioning? Device
>>> could be deleted from the management device anyhow.
>> Yes, we need this to delete and re-create a vDPA device.
> I wonder if we need something that works for -stable.
I can add a fix tag, so these three patches could apply to stable
>
> AFAIK, we can move the vdpa_alloc_device() from probe() to dev_add()
> and it seems to work?
Yes and this is done in this series and that's why we need these
refactoring code.

By the way, do you have any comments to the patches?

Thanks,
Zhu Lingshan
>
> Thanks
>
>> We create vDPA device from a VF, so without features provisioning
>> requirements,
>> we don't need to re-create the vDPA device. But with features provisioning,
>> it is a must now.
>>
>> Thanks
>>
>>
>>> Thakns
>>>
>>>> When remove a vDPA device, the container of struct vdpa_device (here is
>>>> ifcvf_adapter) is free-ed in
>>>> dev_del() interface, so we need to allocate ifcvf_adapter in dev_add()
>>>> than in probe(). That's
>>>> why I have re-factored the adapter/mgmt_dev code.
>>>>
>>>> For re-factoring the irq related code and ifcvf_base, let them work on
>>>> struct ifcvf_hw, the
>>>> reason is that the adapter is allocated in dev_add(), if we want theses
>>>> functions to work
>>>> before dev_add(), like in probe, we need them work on ifcvf_hw than the
>>>> adapter.
>>>>
>>>> Thanks
>>>> Zhu Lingshan
>>>>> Thanks
>>>>>
>>>>>> Please help review
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Zhu Lingshan (4):
>>>>>>      vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
>>>>>>      vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>>>>>>      vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>>>>>>      vDPA/ifcvf: implement features provisioning
>>>>>>
>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>>>>>     drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>>>>>     drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
>>>>>>     3 files changed, 89 insertions(+), 109 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.31.1
>>>>>>

