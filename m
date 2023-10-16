Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494CE7CA48D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 11:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjJPJxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjJPJxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 05:53:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC2CC5
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 02:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697450013; x=1728986013;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dAsUnnyluJvXyQp37TtlbSqZLVCD7Sjo47cIWmQv6Pc=;
  b=W2rmuOXktsBe1wH4ZNA3qcjpB6bEtRcDhuGJwY/uZTwcLXAcNaBHOujI
   YxixDIxK2f6fUffl5c0e5MoAgLUpcod16tLdAJW++c6DhdUfoD77FQ55u
   EVmwggiienvMZtb0IV9VB3REYrwr/tUnmZIXgrF/oHgO+qGbJo7ZQHwg0
   2N01NLj/j0SH9TnCRv6D3tyxM5DQDE0GYDLznABwMKTlQ9Txvlcnaih1O
   9uQOczg3Xoga7iBkwv7IjHAsI1PX2g1HJ8x/0Kt2KCsHE7AAkJ2VKZ5N5
   y5H4fgQb/oLrWLRUoVO5wFG4PCbGnaZdsLcSrzLihOLAKcUv7zUh5LSmA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="382712468"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="382712468"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 02:53:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="825941359"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="825941359"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.93.35.20]) ([10.93.35.20])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 02:53:29 -0700
Message-ID: <774272d3-8e73-4323-8772-533896894643@intel.com>
Date:   Mon, 16 Oct 2023 17:53:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over virtio
 device
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
 <20231012132749.GK3952@nvidia.com>
 <840d4c6f-4150-4818-a66c-1dbe1474b4c6@intel.com>
 <20231013094959-mutt-send-email-mst@kernel.org>
 <818c4212-9d9a-4775-80f3-c07e82057be8@intel.com>
 <20231016045050-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20231016045050-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/16/2023 4:52 PM, Michael S. Tsirkin wrote:
> On Mon, Oct 16, 2023 at 04:33:10PM +0800, Zhu, Lingshan wrote:
>>
>> On 10/13/2023 9:50 PM, Michael S. Tsirkin wrote:
>>> On Fri, Oct 13, 2023 at 06:28:34PM +0800, Zhu, Lingshan wrote:
>>>> On 10/12/2023 9:27 PM, Jason Gunthorpe wrote:
>>>>
>>>>       On Thu, Oct 12, 2023 at 06:29:47PM +0800, Zhu, Lingshan wrote:
>>>>
>>>>
>>>>           sorry for the late reply, we have discussed this for weeks in virtio mailing
>>>>           list. I have proposed a live migration solution which is a config space solution.
>>>>
>>>>       I'm sorry that can't be a serious proposal - config space can't do
>>>>       DMA, it is not suitable.
>>>>
>>>> config space only controls the live migration process and config the related
>>>> facilities.
>>>> We don't use config space to transfer data.
>>>>
>>>> The new added registers work like queue_enable or features.
>>>>
>>>> For example, we use DMA to report dirty pages and MMIO to fetch the dirty data.
>>>>
>>>> I remember in another thread you said:"you can't use DMA for any migration
>>>> flows"
>>>>
>>>> And I agree to that statement, so we use config space registers to control the
>>>> flow.
>>>>
>>>> Thanks,
>>>> Zhu Lingshan
>>>>
>>>>
>>>>       Jason
>>>>
>>> If you are using dma then I don't see what's wrong with admin vq.
>>> dma is all it does.
>> dma != admin vq,
> Well they share the same issue that they don't work for nesting
> because DMA can not be intercepted.
(hope this is not a spam to virtualization list and I try to keep this 
short)
only use dma for host memory access, e.g., dirty page bitmap, no need to 
intercepted.
>
>> and I think we have discussed many details in pros and cons
>> in admin vq live migration proposal in virtio-comment.
>> I am not sure we should span the discussions here, repeat them over again.
>>
>> Thanks
> Yea let's not.
>

