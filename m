Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46B3C5CDE
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 15:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbhGLNBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 09:01:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234410AbhGLNBQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 09:01:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626094707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Wzq1eRU3t7sOn0FtJiiIKj07Ib+WKzw1VGxsqeZYHE=;
        b=No77YeaPiOTB+8toWmcUFZow4qvYKZproHOQue2xzjXzOoY+P4wzm3ELYFpCbNuGb//OsS
        YniBV0dWFn+osoGsTvpP6xqc9KerKc0Fc6Jb37ykH/HDzIUAp/GQlxmAav1p6CFyiU/W7z
        WE6o9gpYpP7P+t7+bn/FABKaRjojxKQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-ZMNaiiF1NV-qD9dHTpvqWA-1; Mon, 12 Jul 2021 08:58:26 -0400
X-MC-Unique: ZMNaiiF1NV-qD9dHTpvqWA-1
Received: by mail-ej1-f72.google.com with SMTP id sd15-20020a170906ce2fb0290512261c5475so1014979ejb.13
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 05:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1Wzq1eRU3t7sOn0FtJiiIKj07Ib+WKzw1VGxsqeZYHE=;
        b=lUlJoLw6oNITvoKAp9KdgEudfb7GKMbcebOXcTr3ygSsbOQM5q7dCDo2EGrNBjwL6+
         mPuOqHP41uEZnVSCdF+c7Cct7vGlSiTYrBUUpPeRG8RMfrys4MAykaKzxbM8rgkSqPQP
         HMcfNWiSZbZLbPIf0WCUx+iViErQTPRZoNmPqfNN6U8hBVOiWG20DJ4TXf0gFCAA35Rb
         yqow2SifK3pr3TpRGKZFNPwPHyDsjgpr2w24+XmBwPO97awz1U2cVkDP5EnGHIQlZLzX
         QzxHRmFogdkVr3dIxYHXsANvucfVdLD0S1As33jz208TtMUrgCOaolUPiPJ2oX0e7+qG
         94zg==
X-Gm-Message-State: AOAM531pttcHoxqotfsnhSZwoqGXE1UmN9eZTJ/mLMPmdT5Wni46NpLn
        qkUmpK5IeHx7ZeEA5LI5aZ2U9eQVsIMo8BAYajxqjV4fPp6S73f3Y2MbY2WMOxCVydAaRmyqcPO
        n9DzcTfFN5bwu
X-Received: by 2002:a50:9f8e:: with SMTP id c14mr28543871edf.283.1626094705166;
        Mon, 12 Jul 2021 05:58:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqbwu+mcRnHI1uQvTVajxs03j+bkhUKjClyryAOcRQ1J3v5nPBRJxWtSdmvlffTNXy/QcPlw==
X-Received: by 2002:a50:9f8e:: with SMTP id c14mr28543858edf.283.1626094704948;
        Mon, 12 Jul 2021 05:58:24 -0700 (PDT)
Received: from redhat.com ([2.55.156.48])
        by smtp.gmail.com with ESMTPSA id bm1sm6438284ejb.38.2021.07.12.05.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:58:24 -0700 (PDT)
Date:   Mon, 12 Jul 2021 08:58:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <20210712085734-mutt-send-email-mst@kernel.org>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
 <20210506041057-mutt-send-email-mst@kernel.org>
 <20210506123829.GA403858@infradead.org>
 <20210514063516-mutt-send-email-mst@kernel.org>
 <8bf22db2-97d4-9f88-8b6b-d685fd63ac8b@redhat.com>
 <20210711120627-mutt-send-email-mst@kernel.org>
 <e2b4c614-746f-e81b-bb0b-d84f0efd381f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2b4c614-746f-e81b-bb0b-d84f0efd381f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 11:07:44AM +0800, Jason Wang wrote:
> 
> 在 2021/7/12 上午12:08, Michael S. Tsirkin 写道:
> > On Fri, Jun 04, 2021 at 01:38:01PM +0800, Jason Wang wrote:
> > > 在 2021/5/14 下午7:13, Michael S. Tsirkin 写道:
> > > > On Thu, May 06, 2021 at 01:38:29PM +0100, Christoph Hellwig wrote:
> > > > > On Thu, May 06, 2021 at 04:12:17AM -0400, Michael S. Tsirkin wrote:
> > > > > > Let's try for just a bit, won't make this window anyway:
> > > > > > 
> > > > > > I have an old idea. Add a way to find out that unmap is a nop
> > > > > > (or more exactly does not use the address/length).
> > > > > > Then in that case even with DMA API we do not need
> > > > > > the extra data. Hmm?
> > > > > So we actually do have a check for that from the early days of the DMA
> > > > > API, but it only works at compile time: CONFIG_NEED_DMA_MAP_STATE.
> > > > > 
> > > > > But given how rare configs without an iommu or swiotlb are these days
> > > > > it has stopped to be very useful.  Unfortunately a runtime-version is
> > > > > not entirely trivial, but maybe if we allow for false positives we
> > > > > could do something like this
> > > > > 
> > > > > bool dma_direct_need_state(struct device *dev)
> > > > > {
> > > > > 	/* some areas could not be covered by any map at all */
> > > > > 	if (dev->dma_range_map)
> > > > > 		return false;
> > > > > 	if (force_dma_unencrypted(dev))
> > > > > 		return false;
> > > > > 	if (dma_direct_need_sync(dev))
> > > > > 		return false;
> > > > > 	return *dev->dma_mask == DMA_BIT_MASK(64);
> > > > > }
> > > > > 
> > > > > bool dma_need_state(struct device *dev)
> > > > > {
> > > > > 	const struct dma_map_ops *ops = get_dma_ops(dev);
> > > > > 
> > > > > 	if (dma_map_direct(dev, ops))
> > > > > 		return dma_direct_need_state(dev);
> > > > > 	return ops->unmap_page ||
> > > > > 		ops->sync_single_for_cpu || ops->sync_single_for_device;
> > > > > }
> > > > Yea that sounds like a good idea. We will need to document that.
> > > > 
> > > > 
> > > > Something like:
> > > > 
> > > > /*
> > > >    * dma_need_state - report whether unmap calls use the address and length
> > > >    * @dev: device to guery
> > > >    *
> > > >    * This is a runtime version of CONFIG_NEED_DMA_MAP_STATE.
> > > >    *
> > > >    * Return the value indicating whether dma_unmap_* and dma_sync_* calls for the device
> > > >    * use the DMA state parameters passed to them.
> > > >    * The DMA state parameters are: scatter/gather list/table, address and
> > > >    * length.
> > > >    *
> > > >    * If dma_need_state returns false then DMA state parameters are
> > > >    * ignored by all dma_unmap_* and dma_sync_* calls, so it is safe to pass 0 for
> > > >    * address and length, and DMA_UNMAP_SG_TABLE_INVALID and
> > > >    * DMA_UNMAP_SG_LIST_INVALID for s/g table and length respectively.
> > > >    * If dma_need_state returns true then DMA state might
> > > >    * be used and so the actual values are required.
> > > >    */
> > > > 
> > > > And we will need DMA_UNMAP_SG_TABLE_INVALID and
> > > > DMA_UNMAP_SG_LIST_INVALID as pointers to an empty global table and list
> > > > for calls such as dma_unmap_sgtable that dereference pointers before checking
> > > > they are used.
> > > > 
> > > > 
> > > > Does this look good?
> > > > 
> > > > The table/length variants are for consistency, virtio specifically does
> > > > not use s/g at the moment, but it seems nicer than leaving
> > > > users wonder what to do about these.
> > > > 
> > > > Thoughts? Jason want to try implementing?
> > > 
> > > I can add it in my todo list other if other people are interested in this,
> > > please let us know.
> > > 
> > > But this is just about saving the efforts of unmap and it doesn't eliminate
> > > the necessary of using private memory (addr, length) for the metadata for
> > > validating the device inputs.
> > 
> > Besides unmap, why do we need to validate address?
> 
> 
> Sorry, it's not validating actually, the driver doesn't do any validation.
> As the subject, the driver will just use the metadata stored in the
> desc_state instead of the one stored in the descriptor ring.
> 
> 
> >   length can be
> > typically validated by specific drivers - not all of them even use it ..
> > 
> > > And just to clarify, the slight regression we see is testing without
> > > VIRTIO_F_ACCESS_PLATFORM which means DMA API is not used.
> > I guess this is due to extra cache pressure?
> 
> 
> Yes.
> 
> 
> > Maybe create yet another
> > array just for DMA state ...
> 
> 
> I'm not sure I get this, we use this basically:
> 
> struct vring_desc_extra {
>         dma_addr_t addr;                /* Buffer DMA addr. */
>         u32 len;                        /* Buffer length. */
>         u16 flags;                      /* Descriptor flags. */
>         u16 next;                       /* The next desc state in a list. */
> };
> 
> Except for the "next" the rest are all DMA state.
> 
> Thanks


I am talking about the dma need state idea where we interrogate the DMA
API to figure out whether unmap is actually a nop.

> 
> > 
> > > So I will go to post a formal version of this series and we can start from
> > > there.
> > > 
> > > Thanks
> > > 
> > > 

