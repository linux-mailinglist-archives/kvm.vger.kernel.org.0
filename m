Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EEC3C3DDB
	for <lists+kvm@lfdr.de>; Sun, 11 Jul 2021 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhGKQLd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jul 2021 12:11:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhGKQLd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Jul 2021 12:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626019726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=plvdWyXd4qV9pRAdncULs2MVIZL8MtO+i2JcuYf646o=;
        b=Ucn408Q1FoS3dzmyRF51WXK7I1TJSpir/307vw/dKN8h59NSXfS+q9I33wnEGz2fqyqtuX
        7vOtqD83eNU9CKr59feVOhqGf0/rSrImlAIoqKwAjNDo0rsIgT9zspqywMbajfu0iFnCYy
        scMKtuPTdTYyTVSRHCTPoNSzbu0dOsY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-9iqZCveIPOKCy6t87jHzFA-1; Sun, 11 Jul 2021 12:08:44 -0400
X-MC-Unique: 9iqZCveIPOKCy6t87jHzFA-1
Received: by mail-ej1-f71.google.com with SMTP id hg14-20020a1709072cceb02904dcfba77bceso4015510ejc.19
        for <kvm@vger.kernel.org>; Sun, 11 Jul 2021 09:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=plvdWyXd4qV9pRAdncULs2MVIZL8MtO+i2JcuYf646o=;
        b=pDqllx6/18jkgsKrazctLS3g/HtP3UPw5/lJ7iYkX0FM7OQPuBHt3HlpSTnLC2ZwSr
         9T+mkczlHYBA7J9N+kkwL9EDbqRVwa7PG6I26aCwL+vA+J+yhLix1g7fug0GPvLhVNQd
         Qf4p4nQ+wE7AqUdLwzdT6V5MSJeyDGmW7GvzGkAhxAjKdbO0uDvAN2h+PYRdJAXXjFNg
         6jsPxBRWQmc9U3dwNjM5TzkHW4ayWrblpMj+59UNUcUCwG2TsbFZTyqeTKC5DqUd1GQ1
         mJ2X6CxeV1YoBqJJ9MNp4Pn79vXDKgpQ5E14p926HzLQ2LaDfXP+vwOMWD+2nYD3K+/f
         twcw==
X-Gm-Message-State: AOAM531SgWM8l9CditjC3Un+K2jr9QSUf9q9ywV01Fu1MlwPiz8wXeRp
        yCoXVJwZ1bGQQ3KiV2HlaNlGVqV8Ht52/5agWlxxban8gJJNDTyTwl+4F3P30RPQWceojMHiNNW
        NyMvKnVN+Gz9q
X-Received: by 2002:a05:6402:334:: with SMTP id q20mr7782574edw.384.1626019723356;
        Sun, 11 Jul 2021 09:08:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5DbXTPixgKQ7SAA5myg1QUAzpzti+8oHSmlPRSSCZOaBtsoWfnjplFHvrs4qVGWvzNiKsUw==
X-Received: by 2002:a05:6402:334:: with SMTP id q20mr7782566edw.384.1626019723238;
        Sun, 11 Jul 2021 09:08:43 -0700 (PDT)
Received: from redhat.com ([2.55.136.76])
        by smtp.gmail.com with ESMTPSA id f12sm5266367ejz.99.2021.07.11.09.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 09:08:42 -0700 (PDT)
Date:   Sun, 11 Jul 2021 12:08:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org,
        ak@linux.intel.com, luto@kernel.org
Subject: Re: [PATCH 0/7] Do not read from descriptor ring
Message-ID: <20210711120824-mutt-send-email-mst@kernel.org>
References: <20210604055350.58753-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604055350.58753-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 01:53:43PM +0800, Jason Wang wrote:
> Hi:
> 
> The virtio driver should not trust the device. This beame more urgent
> for the case of encrtpyed VM or VDUSE[1]. In both cases, technology
> like swiotlb/IOMMU is used to prevent the poking/mangling of memory
> from the device. But this is not sufficient since current virtio
> driver may trust what is stored in the descriptor table (coherent
> mapping) for performing the DMA operations like unmap and bounce so
> the device may choose to utilize the behaviour of swiotlb to perform
> attacks[2].
> 
> To protect from a malicous device, this series store and use the
> descriptor metadata in an auxiliay structure which can not be accessed
> via swiotlb/device instead of the ones in the descriptor table. This
> means the descriptor table is write-only from the view of the driver.
> 
> Actually, we've almost achieved that through packed virtqueue and we
> just need to fix a corner case of handling mapping errors. For split
> virtqueue we just follow what's done in the packed.
> 
> Note that we don't duplicate descriptor medata for indirect
> descriptors since it uses stream mapping which is read only so it's
> safe if the metadata of non-indirect descriptors are correct.
> 
> For split virtqueue, the change increase the footprint due the the
> auxiliary metadata but it's almost neglectlable in simple test like
> pktgen and netperf TCP stream (slightly noticed in a 40GBE environment
> with more CPU usage).
> 
> Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
> the guest.
> 
> Note that this series tries to fix the attack via descriptor
> ring. The other cases (used ring and config space) will be fixed by
> other series or patches.
> 
> Please review.

This needs a rebase - can you do it pls?

> Changes from RFC V2:
> - no code change
> - twaeak the commit log a little bit
> 
> Changes from RFC V1:
> - Always use auxiliary metadata for split virtqueue
> - Don't read from descripto when detaching indirect descriptor
> 
> Jason Wang (7):
>   virtio-ring: maintain next in extra state for packed virtqueue
>   virtio_ring: rename vring_desc_extra_packed
>   virtio-ring: factor out desc_extra allocation
>   virtio_ring: secure handling of mapping errors
>   virtio_ring: introduce virtqueue_desc_add_split()
>   virtio: use err label in __vring_new_virtqueue()
>   virtio-ring: store DMA metadata in desc_extra for split virtqueue
> 
>  drivers/virtio/virtio_ring.c | 201 +++++++++++++++++++++++++----------
>  1 file changed, 144 insertions(+), 57 deletions(-)
> 
> -- 
> 2.25.1

