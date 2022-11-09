Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B362263A
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiKIJGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiKIJGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:06:11 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0463621808
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 01:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667984766; x=1699520766;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+JNLCXbPm/UrqSsWNqXLmoAAPfj8mhI4bJ9CrK93e6o=;
  b=CRpp/o0BpznfQePP8nDbHySHKt14OXOj/IhYMtW1ilmOmXIW4J/56iMj
   LpAnvIwxXq6Bo7CpybQJrup9zTyJL6Q0OqsJZlOpRK3K8B591OQtMPu4V
   YtBcb1dpTRhxG+c1+Xf6c4KMVGIrBCCuOZlBZVW7M8fVozSKsKIEttrZj
   +yyIjLIq3Pd9bFUTXSPrD1DwXutoYl+6H4gTfLZUATSgWqXdxRAvMJfyq
   HBaDRnj2uVEPUzAXhJKkvLnFrB135JOjVKQ/P1mL4fUa+b8k9PMYCbWBP
   JBvQ6d5lPAVw5KLerf3jc7Ji4Z56HjLMHuqRecyO+PH94PqVaU6H6tVMs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="298450478"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="298450478"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 01:06:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="811564536"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="811564536"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.29.36]) ([10.255.29.36])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 01:06:03 -0800
Message-ID: <80cdd80a-16fa-ac75-0a89-5729b846efed@intel.com>
Date:   Wed, 9 Nov 2022 17:06:01 +0800
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEujqOFHv7QATWgYo=SdAKef5jQXi2-YksjgT-hxEgKNDQ@mail.gmail.com>
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



On 11/9/2022 4:59 PM, Jason Wang wrote:
> On Wed, Nov 9, 2022 at 4:14 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>>
>>
>> On 11/9/2022 2:51 PM, Jason Wang wrote:
>>> On Mon, Nov 7, 2022 at 5:42 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>>> This series implements features provisioning for ifcvf.
>>>> By applying this series, we allow userspace to create
>>>> a vDPA device with selected (management device supported)
>>>> feature bits and mask out others.
>>> I don't see a direct relationship between the first 3 and the last.
>>> Maybe you can state the reason why the restructure is a must for the
>>> feature provisioning. Otherwise, we'd better split the series.
>> When introducing features provisioning ability to ifcvf, there is a need
>> to re-create vDPA devices
>> on a VF with different feature bits.
> This seems a requirement even without feature provisioning? Device
> could be deleted from the management device anyhow.
Yes, we need this to delete and re-create a vDPA device.

We create vDPA device from a VF, so without features provisioning 
requirements,
we don't need to re-create the vDPA device. But with features provisioning,
it is a must now.

Thanks


>
> Thakns
>
>> When remove a vDPA device, the container of struct vdpa_device (here is
>> ifcvf_adapter) is free-ed in
>> dev_del() interface, so we need to allocate ifcvf_adapter in dev_add()
>> than in probe(). That's
>> why I have re-factored the adapter/mgmt_dev code.
>>
>> For re-factoring the irq related code and ifcvf_base, let them work on
>> struct ifcvf_hw, the
>> reason is that the adapter is allocated in dev_add(), if we want theses
>> functions to work
>> before dev_add(), like in probe, we need them work on ifcvf_hw than the
>> adapter.
>>
>> Thanks
>> Zhu Lingshan
>>> Thanks
>>>
>>>> Please help review
>>>>
>>>> Thanks
>>>>
>>>> Zhu Lingshan (4):
>>>>     vDPA/ifcvf: ifcvf base layer interfaces work on struct ifcvf_hw
>>>>     vDPA/ifcvf: IRQ interfaces work on ifcvf_hw
>>>>     vDPA/ifcvf: allocate ifcvf_adapter in dev_add()
>>>>     vDPA/ifcvf: implement features provisioning
>>>>
>>>>    drivers/vdpa/ifcvf/ifcvf_base.c |  32 ++-----
>>>>    drivers/vdpa/ifcvf/ifcvf_base.h |  10 +-
>>>>    drivers/vdpa/ifcvf/ifcvf_main.c | 156 +++++++++++++++-----------------
>>>>    3 files changed, 89 insertions(+), 109 deletions(-)
>>>>
>>>> --
>>>> 2.31.1
>>>>

