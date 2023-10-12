Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358257C6B1F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 12:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377746AbjJLK35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347165AbjJLK3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 06:29:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0025D8
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 03:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697106592; x=1728642592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5SKj5y0nzEh+mHktVwMtOXvHLzceY+BjcxTXjOUlQBE=;
  b=HbWtUULKS/1kksXXdd1psqOa755motkEsMXIeu1v/FeI7nJKUJHsNzSK
   y8/4qBPpQ5slgBaQ9C7QfM2wUz9lBZAk9xI4dGA3MeY5M2GWquGisOLCL
   HMY+nVGANiuMVibDq9c/Vnq364ml7dIGrZ1ewmV5+hRBDsRPWfs1APTrU
   H2AuIh1gJJkDvd9VPHHqCmmP+4OSX881hmu1mc3Bb4/wSJxLUTWLcuXk+
   XptbS49Y5d2P7x1cXsfiUCxfX7LGJ3gzDXkqVrptvR1c77bZZqpyE1ffn
   y3AlQQTQJbB8hk+BBT96ntRH8k4w87nH0XtbB/BiA8KBATy1/RnsUZEPL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="449074002"
X-IronPort-AV: E=Sophos;i="6.03,218,1694761200"; 
   d="scan'208";a="449074002"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 03:29:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="820085560"
X-IronPort-AV: E=Sophos;i="6.03,218,1694761200"; 
   d="scan'208";a="820085560"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.29.0]) ([10.93.29.0])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 03:29:49 -0700
Message-ID: <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
Date:   Thu, 12 Oct 2023 18:29:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com> <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/11/2023 4:00 PM, Parav Pandit via Virtualization wrote:
> Hi Christoph,
>
>> From: Christoph Hellwig <hch@infradead.org>
>> Sent: Wednesday, October 11, 2023 12:29 PM
>>
>> On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
>>>> Btw, what is that intel thing everyone is talking about?  And why
>>>> would the virtio core support vendor specific behavior like that?
>>> It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
>>> that implemented vdpa support and so Zhu Lingshan from intel is
>>> working on vdpa and has also proposed virtio spec extensions for migration.
>>> intel's driver is called ifcvf.  vdpa composes all this stuff that is
>>> added to vfio in userspace, so it's a different approach.
>> Well, so let's call it virtio live migration instead of intel.
>>
>> And please work all together in the virtio committee that you have one way of
>> communication between controlling and controlled functions.
>> If one extension does it one way and the other a different way that's just
>> creating a giant mess.
> We in virtio committee are working on VF device migration where:
> VF = controlled function
> PF = controlling function
>
> The second proposal is what Michael mentioned from Intel that somehow combine controlled and controlling function as single entity on VF.
>
> The main reasons I find it weird are:
> 1. it must always need to do mediation to do fake the device reset, and flr flows
> 2. dma cannot work as you explained for complex device state
> 3. it needs constant knowledge of each tiny things for each virtio device type
>
> Such single entity appears a bit very weird to me but maybe it is just me.
sorry for the late reply, we have discussed this for weeks in virtio 
mailing list.
I have proposed a live migration solution which is a config space solution.

We(me, Jason and Eugenio) have been working on this solution for more 
than two years
and we are implementing virtio live migration basic facilities.

The implementation is transport specific, e.g., for PCI we implement new 
or extend registers which
work as other config space registers do.

The reason we are arguing is:
I am not sure admin vq based live migration solution is a good choice, 
because:
1) it does not work for nested
2) it does not work for bare metal
3) QOS problem
4) security leaks.

Sorry to span the discussions here.

Thanks,
Zhu Lingshan
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

