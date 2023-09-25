Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355677ACF3C
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 06:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjIYEor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 00:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIYEoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 00:44:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2F4BE
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 21:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695617078; x=1727153078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2Udk7ILXK8hVm0kStsF/kjFOzc0bvoZMNSExj5jdI7M=;
  b=Vagr7hgmT9dXTK059Rf7WjNu1N8op4XYCn2sziK/iU7mAR8A69dixFDP
   3BFejNk6Pih9PrRzNeWTcMjrW9xa1YaqK5B0pf5+MDxNpmhZaVE3eAYym
   KswQush5zddelglS8tMd/rT+jPeAcruVPbH2fC4f8Bp+hBXA25ajKDx3+
   0nTmMJ2+PNusAIBcZSUnXIN6dO93HNhQ0RFrGHGtfa62l/tmt/mhR+7Ld
   LkPKmPN5hnyPd/ifsWQd6uTLcluRPQjhdcMRRJGk/1kISJoUbhRRxqpfr
   k2F7t7EDkH/pOYio4BP9bv1AQ3xJ6D6WaatxkYr9pCscLs17U4Ad/l9wz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="380040937"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="380040937"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 21:44:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="818476376"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="818476376"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.21.134]) ([10.93.21.134])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 21:44:36 -0700
Message-ID: <db8c1f00-39d2-8305-faca-18fe418d249a@intel.com>
Date:   Mon, 25 Sep 2023 12:44:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, maorg@nvidia.com,
        virtualization@lists.linux-foundation.org, jiri@nvidia.com,
        leonro@nvidia.com
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921151325-mutt-send-email-mst@kernel.org>
 <20230921195115.GY13733@nvidia.com>
 <20230921164558-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20230921164558-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/2023 4:55 AM, Michael S. Tsirkin wrote:
> On Thu, Sep 21, 2023 at 04:51:15PM -0300, Jason Gunthorpe wrote:
>> On Thu, Sep 21, 2023 at 03:17:25PM -0400, Michael S. Tsirkin wrote:
>>> On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
>>>>> What is the huge amount of work am I asking to do?
>>>> You are asking us to invest in the complexity of VDPA through out
>>>> (keep it working, keep it secure, invest time in deploying and
>>>> debugging in the field)
>>> I'm asking you to do nothing of the kind - I am saying that this code
>>> will have to be duplicated in vdpa,
>> Why would that be needed?
> For the same reason it was developed in the 1st place - presumably
> because it adds efficient legacy guest support with the right card?
> I get it, you specifically don't need VDPA functionality, but I don't
> see why is this universal, or common.
>
>
>>> and so I am asking what exactly is missing to just keep it all
>>> there.
>> VFIO. Seriously, we don't want unnecessary mediation in this path at
>> all.
> But which mediation is necessary is exactly up to the specific use-case.
> I have no idea why would you want all of VFIO to e.g. pass access to
> random config registers to the guest when it's a virtio device and the
> config registers are all nicely listed in the spec. I know nvidia
> hardware is so great, it has super robust cards with less security holes
> than the vdpa driver, but I very much doubt this is universal for all
> virtio offload cards.
I agree with MST.
>>> note I didn't ask you to add iommufd to vdpa though that would be
>>> nice ;)
>> I did once send someone to look.. It didn't succeed :(
>>
>> Jason
> Pity. Maybe there's some big difficulty blocking this? I'd like to know.
>

