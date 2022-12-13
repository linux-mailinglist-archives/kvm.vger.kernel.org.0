Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A9D64B014
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiLMG6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiLMG6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:58:01 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF6F14D17
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670914679; x=1702450679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HBfcINep82HVPFPIwMFOcydpeusXlzwEf1BgRX/cP9Y=;
  b=VfF+MIWa7JQxAxSxLoIryLBMEG2vvrrNR9g+5Ee1kM8cakk+1hMb6Np5
   Wx6Xz9iOrQWSaMZUPwi7Ftg5gnFmLhZCaJuVayhzq/4YSrrGaG+TIARnn
   BQ3pOodk+4NnOsDYpnLa1RV45D0PH3NTJkTxnT3LlIIOnkcI6+8te/nr+
   dXlCYcS1C2GiNaKTOtX2Se8tawXA7IRowoq+W1a6poAaujf1RvO3ojvCQ
   Lf2txy1EVcpGZPgGHsr04P6DcXZcwo7kvR6ejrgi+ll6Zj1uPDDcs97Rs
   BlDDmDN5iRiHWNyx/GTRD2AzbTc4g95AFRS+Uox0q/xigauaVJvme2Jnz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305701044"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="305701044"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 22:57:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="598726978"
X-IronPort-AV: E=Sophos;i="5.96,240,1665471600"; 
   d="scan'208";a="598726978"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.9]) ([10.249.171.9])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 22:57:21 -0800
Message-ID: <845d9829-a766-3a07-83bb-1d764ace604d@intel.com>
Date:   Tue, 13 Dec 2022 14:57:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH V2 00/12] ifcvf/vDPA implement features provisioning
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, hang.yuan@intel.com, piotr.uminski@intel.com
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
 <CACGkMEvEwutEZT4UyosOZmTcKjvhhS6covy6FgyMWm4nmtKn8w@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEvEwutEZT4UyosOZmTcKjvhhS6covy6FgyMWm4nmtKn8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/6/2022 4:25 PM, Jason Wang wrote:
> On Fri, Nov 25, 2022 at 11:06 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This series implements features provisioning for ifcvf.
>> By applying this series, we allow userspace to create
>> a vDPA device with selected (management device supported)
>> feature bits and mask out others.
>>
>> Examples:
>> a)The management device supported features:
>> $ vdpa mgmtdev show pci/0000:01:00.5
>> pci/0000:01:00.5:
>>    supported_classes net
>>    max_supported_vqs 9
>>    dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>>
>> b)Provision a vDPA device with all supported features:
>> $ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5
>> $ vdpa/vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>>    negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>>
>> c)Provision a vDPA device with a subset of the supported features:
>> $ vdpa dev add name vdpa0 mgmtdev pci/0000:01:00.5 device_features 0x300020020
>> $ vdpa dev config show vdpa0
>> mac 00:e8:ca:11:be:05 link up link_announce false
>>    negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>>
>> Please help review
>>
>> Thanks
>>
>> Changes from V1:
>> split original patch 1 ~ patch 3 to small patches that are less
>> than 100 lines,
> True but.
>
>> so they can be applied to stalbe kernel(Jason)
>>
> It requires each patch fixes a real issue so I think those can not go
> to -stable.
>
> Btw, looking at git history what you want to decouple is basically
> functional equivalent to a partial revert of this commit:
>
> commit 378b2e956820ff5c082d05f42828badcfbabb614
> Author: Zhu Lingshan <lingshan.zhu@intel.com>
> Date:   Fri Jul 22 19:53:05 2022 +0800
>
>      vDPA/ifcvf: support userspace to query features and MQ of a
> management device
>
>      Adapting to current netlink interfaces, this commit allows userspace
>      to query feature bits and MQ capability of a management device.
>
>      Currently both the vDPA device and the management device are the VF itself,
>      thus this ifcvf should initialize the virtio capabilities in probe() before
>      setting up the struct vdpa_mgmt_dev.
>
>      Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>      Message-Id: <20220722115309.82746-3-lingshan.zhu@intel.com>
>      Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> Before this commit. adapter was allocated/freed in device_add/del
> which should be fine.
>
> Can we go back to doing things that way?
Hi Jason

Thanks for your advice, my concern is, even revert this commit 378b2e95,
we still need to re-implement the feature "support userspace to query 
features and MQ of a management device"
in stable kernel(still not a patch fix something but implement 
something), or we remove a feature in the stable kernel.
And there may still need to split patches to meet the <100 lines requirement

The reason why I place the adapter allocation in probe is that currently 
the management device is the VF itself,
move it from dev_add to probe can lighten the organization of data 
structures, it is not a good design anyway,
so this series tries to fix them as well.

Maybe not to to sable

Thanks
>
> Thanks
>
>> Zhu Lingshan (12):
>>    vDPA/ifcvf: decouple hw features manipulators from the adapter
>>    vDPA/ifcvf: decouple config space ops from the adapter
>>    vDPA/ifcvf: alloc the mgmt_dev before the adapter
>>    vDPA/ifcvf: decouple vq IRQ releasers from the adapter
>>    vDPA/ifcvf: decouple config IRQ releaser from the adapter
>>    vDPA/ifcvf: decouple vq irq requester from the adapter
>>    vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator
>>      from the adapter
>>    vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
>>    vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
>>    vDPA/ifcvf: allocate the adapter in dev_add()
>>    vDPA/ifcvf: retire ifcvf_private_to_vf
>>    vDPA/ifcvf: implement features provisioning
>>
>>   drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 162 +++++++++++++++-----------------
>>   3 files changed, 91 insertions(+), 113 deletions(-)
>>
>> --
>> 2.31.1
>>

