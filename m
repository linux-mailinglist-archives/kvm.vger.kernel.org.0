Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8A39B20E
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 07:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFDFkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 01:40:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229810AbhFDFj7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 01:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622785094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goPsG0ZvybVWv4Ouo01fpZW4lJeP0aNbCe0a5SKG3dU=;
        b=g77uIBFUP6vo00lwVpdzH8uG0a2L4x30xPlBhpxiaOP9wQBVIhhNrhe7EBVd+wID4GbHTo
        /FV82w2q16ZpxQXzoq8DxNEIlcGjfZpSgbe8VX79P/JIVVWhzKSbQzQnY8iSTQgtx3xxhc
        DviudW1MIltMNN74efARyQo5/q0hXXk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-EbQSonZuMzy177X8ItSvXg-1; Fri, 04 Jun 2021 01:38:12 -0400
X-MC-Unique: EbQSonZuMzy177X8ItSvXg-1
Received: by mail-pg1-f197.google.com with SMTP id m7-20020a6545c70000b029020f6af21c77so5381054pgr.6
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 22:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=goPsG0ZvybVWv4Ouo01fpZW4lJeP0aNbCe0a5SKG3dU=;
        b=CVMOkkpWMeOQJz4Fk6I/VFQoEBwg5OBDH8Mu1Fq4dCDZHZTAJ44wYLFa7UzQVQ2Xwx
         w0zht5RV1LLsgjI+sfNobUeLyO4JXbFC+KQz8RSXRh5a74WYPQobkHOgA8ooQ++LEdCJ
         JPmEXjh92UD3QroSjNFOIkoxRq2VnJz5ihhw2YVwrmdu8EFPJqh/3ancwP0wMxoAodmh
         wwilstVAVqY123Ggl2sGfVj/+VzzGNocYMynfl40dIo0OcASm8Smfvomc+D8HEe5WBWK
         /n2Kgir6FujLVWQQGsxhd63CrWaTsSrrTbtwp61mx12bHvQ7UljC87wli52cMsRO2kSq
         tPkQ==
X-Gm-Message-State: AOAM533NU7jMCJLRoL+CfZwp0sl2YQPmgOo50aM+sHqBTeG06ygxBJ/A
        AXt2rptuDDVMlCQKjmsABLiMOovjXt5XjOb7M10D7iHHVAF5iOglGkmXXNjbseIGEepnYHGzOM7
        Si8gykrvq8jT6L0Ou+pH/hbueeLtEQdfMCkq3vFpUbg/G0vmpun3G9elYQ5f9mjzQ
X-Received: by 2002:a65:6209:: with SMTP id d9mr3255101pgv.39.1622785091421;
        Thu, 03 Jun 2021 22:38:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy70jTBX6p7+GIl0R40NevNwtAbPV10fcC1uZ6NrvXldomxW3Rg6jMyVb0NoR4dWeio4VttIg==
X-Received: by 2002:a65:6209:: with SMTP id d9mr3255058pgv.39.1622785090898;
        Thu, 03 Jun 2021 22:38:10 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e17sm694312pfi.131.2021.06.03.22.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 22:38:10 -0700 (PDT)
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
 <20210506041057-mutt-send-email-mst@kernel.org>
 <20210506123829.GA403858@infradead.org>
 <20210514063516-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8bf22db2-97d4-9f88-8b6b-d685fd63ac8b@redhat.com>
Date:   Fri, 4 Jun 2021 13:38:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210514063516-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/14 ÏÂÎç7:13, Michael S. Tsirkin Ð´µÀ:
> On Thu, May 06, 2021 at 01:38:29PM +0100, Christoph Hellwig wrote:
>> On Thu, May 06, 2021 at 04:12:17AM -0400, Michael S. Tsirkin wrote:
>>> Let's try for just a bit, won't make this window anyway:
>>>
>>> I have an old idea. Add a way to find out that unmap is a nop
>>> (or more exactly does not use the address/length).
>>> Then in that case even with DMA API we do not need
>>> the extra data. Hmm?
>> So we actually do have a check for that from the early days of the DMA
>> API, but it only works at compile time: CONFIG_NEED_DMA_MAP_STATE.
>>
>> But given how rare configs without an iommu or swiotlb are these days
>> it has stopped to be very useful.  Unfortunately a runtime-version is
>> not entirely trivial, but maybe if we allow for false positives we
>> could do something like this
>>
>> bool dma_direct_need_state(struct device *dev)
>> {
>> 	/* some areas could not be covered by any map at all */
>> 	if (dev->dma_range_map)
>> 		return false;
>> 	if (force_dma_unencrypted(dev))
>> 		return false;
>> 	if (dma_direct_need_sync(dev))
>> 		return false;
>> 	return *dev->dma_mask == DMA_BIT_MASK(64);
>> }
>>
>> bool dma_need_state(struct device *dev)
>> {
>> 	const struct dma_map_ops *ops = get_dma_ops(dev);
>>
>> 	if (dma_map_direct(dev, ops))
>> 		return dma_direct_need_state(dev);
>> 	return ops->unmap_page ||
>> 		ops->sync_single_for_cpu || ops->sync_single_for_device;
>> }
> Yea that sounds like a good idea. We will need to document that.
>
>
> Something like:
>
> /*
>   * dma_need_state - report whether unmap calls use the address and length
>   * @dev: device to guery
>   *
>   * This is a runtime version of CONFIG_NEED_DMA_MAP_STATE.
>   *
>   * Return the value indicating whether dma_unmap_* and dma_sync_* calls for the device
>   * use the DMA state parameters passed to them.
>   * The DMA state parameters are: scatter/gather list/table, address and
>   * length.
>   *
>   * If dma_need_state returns false then DMA state parameters are
>   * ignored by all dma_unmap_* and dma_sync_* calls, so it is safe to pass 0 for
>   * address and length, and DMA_UNMAP_SG_TABLE_INVALID and
>   * DMA_UNMAP_SG_LIST_INVALID for s/g table and length respectively.
>   * If dma_need_state returns true then DMA state might
>   * be used and so the actual values are required.
>   */
>
> And we will need DMA_UNMAP_SG_TABLE_INVALID and
> DMA_UNMAP_SG_LIST_INVALID as pointers to an empty global table and list
> for calls such as dma_unmap_sgtable that dereference pointers before checking
> they are used.
>
>
> Does this look good?
>
> The table/length variants are for consistency, virtio specifically does
> not use s/g at the moment, but it seems nicer than leaving
> users wonder what to do about these.
>
> Thoughts? Jason want to try implementing?


I can add it in my todo list other if other people are interested in 
this, please let us know.

But this is just about saving the efforts of unmap and it doesn't 
eliminate the necessary of using private memory (addr, length) for the 
metadata for validating the device inputs.

And just to clarify, the slight regression we see is testing without 
VIRTIO_F_ACCESS_PLATFORM which means DMA API is not used.

So I will go to post a formal version of this series and we can start 
from there.

Thanks


>

