Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E78C3E860C
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhHJW1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231387AbhHJW1x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 18:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628634450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rKtkcMoRO4/SmKHkWSTGcVIokr6+s/Nfptu/B3gHJZ4=;
        b=VRq5dXPptuCXrk1Y4GUcDpjLK1Lp7wMbznfKIXTrMZdhSwWaGT29pw3c0qIRJ4kHC1b0wm
        oK/zPFOAiZgBEpgjYGPqagEJ2Wuor1oG3cn5AH4lSngONLwSB/vx8LS5FtfwD/ipnJK8Hv
        onn+QhFLvKgV5B5dNSNaB3TOv2Z5CTw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-2w8VQ2jwP_CsM8C68JVrgA-1; Tue, 10 Aug 2021 18:27:28 -0400
X-MC-Unique: 2w8VQ2jwP_CsM8C68JVrgA-1
Received: by mail-qv1-f72.google.com with SMTP id u8-20020a0cec880000b029035825559ec4so84033qvo.22
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rKtkcMoRO4/SmKHkWSTGcVIokr6+s/Nfptu/B3gHJZ4=;
        b=ce/uPCTJBqDsCNYprUp6VNg6Y6GVG5MDtxl7+jZNs1ZN7lPcxIn+yV8l5EaosL37UL
         sB833Td+m0qWnzobuOpjY9c9rSdaOdmx8JunzO5CtxouMdMwCXlG6GuvRjXLbrEZHs2j
         5jUOjIg98s9j5kCSsKXG3AlcsrGt1lP0qKz90HXgs+OpAEqKI3MF+9FMUg4kQDVyMw2l
         cbFxZrM17t/Bj00a7AcNs1NQ1M0cNfsxWPm8noli7pcQm9bjafmqwvvZBi5pl0gkUR32
         w45QvHizBdwuh4y1O1Q48lNm6gO20yOFsTxTb8uBjn50uwRUIOygfsMrQ+hyu529leTK
         gIXg==
X-Gm-Message-State: AOAM5325QuAImCrvp77H6cj+aeHotNwkPmmoyGf3WoTV6PqwMXVQj/oP
        o4bLqoBNMnWRHV8gSGOuJHxgK52Iy2nqWrmQj1NIZZI8yc4yJ+i7rigzVNFMsUwu11p6dm8TFlT
        EJP93VVnkAlX7
X-Received: by 2002:a05:620a:13c8:: with SMTP id g8mr14086267qkl.258.1628634448377;
        Tue, 10 Aug 2021 15:27:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6ol+Dk+1WWikh+M4yXdniloOOnQpQMxQ/tgcF5y35oJ1E0R3kXcExU8u5AzE9C/Qmja70zA==
X-Received: by 2002:a05:620a:13c8:: with SMTP id g8mr14086248qkl.258.1628634448157;
        Tue, 10 Aug 2021 15:27:28 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id o26sm4628328qkm.29.2021.08.10.15.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 15:27:27 -0700 (PDT)
Date:   Tue, 10 Aug 2021 18:27:26 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] vfio/pci: Remove map-on-fault behavior
Message-ID: <YRL9TmcGcLMRHlgO@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818330190.1511194.10498114924408843888.stgit@omen>
 <YRLne7/S1euppJQr@t490s>
 <20210810154512.5aa8eeb3.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810154512.5aa8eeb3.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 03:45:12PM -0600, Alex Williamson wrote:
> On Tue, 10 Aug 2021 16:54:19 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Thu, Aug 05, 2021 at 11:08:21AM -0600, Alex Williamson wrote:
> > > diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> > > index 0aa542fa1e26..9aedb78a4ae3 100644
> > > --- a/drivers/vfio/pci/vfio_pci_private.h
> > > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > > @@ -128,6 +128,7 @@ struct vfio_pci_device {
> > >  	bool			needs_reset;
> > >  	bool			nointx;
> > >  	bool			needs_pm_restore;
> > > +	bool			zapped_bars;  
> > 
> > Would it be nicer to invert the meaning of "zapped_bars" and rename it to
> > "memory_enabled"?  Thanks,
> 
> I think this has it's own down sides, for example is this really less
> confusing?:
> 
>   if (!vdev->memory_enabled && __vfio_pci_memory_enabled(vdev))

Maybe "memory_enabled_last"?  No strong opinion, especially for namings. :)
zapped_bars still looks okay to me.  Thanks,

-- 
Peter Xu

