Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166D943B618
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbhJZPyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 11:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237154AbhJZPxZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 11:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635263460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7tz1ztkDJ8/mfxOMQDKDmzGKJgDrZn1JGVp6nZRCrRs=;
        b=BqMHxZbduQ8KSNVo+eNZb2DIgYv8XZF4lXY/AnCTbV/OIIi0JHxVJ9nvmpK+Cnxk1DxfOq
        u8YBXZle67hM5+O5+U+zDoC7cFtTIghm4KX6HO3o07zVGe/ceDY3mSXGJwOosOjYaHmNMX
        cddDf6yp2mwgltdp5AnGxq9TcJbW4Ew=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-IbAaEziBMUOfgl-hp-swUw-1; Tue, 26 Oct 2021 11:50:59 -0400
X-MC-Unique: IbAaEziBMUOfgl-hp-swUw-1
Received: by mail-ot1-f71.google.com with SMTP id z15-20020a9d71cf000000b0055036817463so9335245otj.0
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 08:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7tz1ztkDJ8/mfxOMQDKDmzGKJgDrZn1JGVp6nZRCrRs=;
        b=SYgs2NbgimT2Gg2WssEl8rdIecYjNwBmLXAQ7+jAguqtEq15E2Kj8OucNZjre3GwQk
         pVquBrMDQXamauLqO/IX0e2YxGKen2yuJuAGocuCGOidbP5I3DQAl+0wyA+uoCQb6guy
         Rn6m/1G2ajBv5ZA8fg+4eWlImvyoe1hRo5uS/MaZItUlURgumGWoDwlmQo7OhxS24QnF
         HyTjXzv52O/+cmQ+NfY6Xh+ti5PwxI1WFGdcRHWjAjF3rknbMKyuk5esdwXiSO65IhpD
         XDzk0JZieBy0X7DFUlzZSSgBlPE6usal95+fHBG7VuoEBisSozX9T9lcp6A5kxUVn7zK
         bhmA==
X-Gm-Message-State: AOAM532cwUKYD3SWf1CyVmf0GQe7zHgUOjx4JML5WXvM4bk2xhpvY16d
        fYA/wXhjIKaF/79dkZGA9zTP5hdnxvZPhrGr3N3SHQyjNVLb6zEme6kLfvOJFRPIB/WAPrzIi5s
        zjhiTJWzHyEMA
X-Received: by 2002:a05:6808:1302:: with SMTP id y2mr28467703oiv.24.1635263458702;
        Tue, 26 Oct 2021 08:50:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwKwVU0S0IFXJyByTOQvRXw6ryzeoMp+YocfGDa8qsGEiNUdjdaki5Abf+Y8mGKt7upXgiSw==
X-Received: by 2002:a05:6808:1302:: with SMTP id y2mr28467689oiv.24.1635263458562;
        Tue, 26 Oct 2021 08:50:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l9sm4675881oie.15.2021.10.26.08.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 08:50:58 -0700 (PDT)
Date:   Tue, 26 Oct 2021 09:50:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        jgg@nvidia.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix
 VFIO_DEVICE_STATE_SET_ERROR macro
Message-ID: <20211026095057.1024c132.alex.williamson@redhat.com>
In-Reply-To: <87pmrrdcos.fsf@redhat.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
        <20211026090605.91646-7-yishaih@nvidia.com>
        <87pmrrdcos.fsf@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 Oct 2021 17:32:19 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
> > instead of STATE).
> >
> > Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>  
> 
> This s-o-b chain looks weird; your s-o-b always needs to be last.
> 
> > ---
> >  include/uapi/linux/vfio.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index ef33ea002b0b..114ffcefe437 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -622,7 +622,7 @@ struct vfio_device_migration_info {
> >  					      VFIO_DEVICE_STATE_RESUMING))
> >  
> >  #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> > -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> > +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
> >  					     VFIO_DEVICE_STATE_RESUMING)
> >  
> >  	__u32 reserved;  
> 
> Change looks fine, although we might consider merging it with the next
> patch? Anyway,

I had requested it separate a couple revisions ago since it's a fix.
Thanks,

Alex

