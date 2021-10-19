Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5F433B2E
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhJSPxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233329AbhJSPxL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 11:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634658658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GbRnMysgz6O7UnaXr5MK4VpcJplugKks3BSf1ebt1U=;
        b=Jx4E0zUqaJ0oon9pP9k9ysGbp8EnqagtL9cq4RTIV2dff1xgwWt6gNlJLtd9aqHV6bAhAn
        r26ad+0q9VyR5jafmk2N6oN26ZpaZvrzivxKAZdxzeCKNwixy4To2p9lV+w/Jau9ArT53s
        EOsiZESwBYPxPcdW5v/8WJif4/MiMgc=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-SjK3pBLrNMWmFSJ2GcvY8g-1; Tue, 19 Oct 2021 11:50:57 -0400
X-MC-Unique: SjK3pBLrNMWmFSJ2GcvY8g-1
Received: by mail-ot1-f70.google.com with SMTP id r3-20020a056830236300b0054d43b72ba5so1997702oth.17
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GbRnMysgz6O7UnaXr5MK4VpcJplugKks3BSf1ebt1U=;
        b=N3lgClfKKqZhI+Emv++sUV9Dx5EHRXfQOiS/MrGSV06EF+cmmuji3qxXJXtt/yn1q9
         1jah6uxSoIGkjNIRmgpQhhk2I/n/BdHnVrsCEJRUS8owIUpHMzqNaAWytXCviRcomsvV
         xTIEIc4z7BioJYo/xhoNGIXYWsX0mCjJbzZgR+e9J4xG05Eqwzw4s2jDMlGf+CDNRq0t
         EMpaOR6S8eEIQyJQTbZGHHTInqCBgB1jVrGSDcBbMULaFT80B8p+ov2DYqBsXiColL5c
         ial0e5lcg7GZTKHO5tcXsguDIIdSaL4NIXAx7JCY9J/FEbFlrBqfw8KXSQrGf2lAGeNp
         xpQw==
X-Gm-Message-State: AOAM530WWoI9UiKs6cV9tHf8REMNWLk8hbTiGfIhlk+uZmxYTLukDK2Y
        L9MTWWXHlLnfToLAoh7PbRz2nusCutt1d4G4F6CR/9Nz/0BTM7zDPaQX2+NvkH0/4dr2syh2bz/
        5PqW+rkS3PFa1
X-Received: by 2002:aca:3741:: with SMTP id e62mr4868391oia.107.1634658656393;
        Tue, 19 Oct 2021 08:50:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuZk7ybu4ZG0GrP92X3+qNn8wg+fCyQDne+8sf1A9W2vT/rGeO2zS+cII8ncS8Dh0Ll18EuQ==
X-Received: by 2002:aca:3741:: with SMTP id e62mr4868375oia.107.1634658656212;
        Tue, 19 Oct 2021 08:50:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r23sm3738636otg.71.2021.10.19.08.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:50:56 -0700 (PDT)
Date:   Tue, 19 Oct 2021 09:50:54 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V2 mlx5-next 08/14] vfio: Add a macro for
 VFIO_DEVICE_STATE_ERROR
Message-ID: <20211019095054.396b4f57.alex.williamson@redhat.com>
In-Reply-To: <20211019094820.2e9bfc01.alex.williamson@redhat.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-9-yishaih@nvidia.com>
        <20211019094820.2e9bfc01.alex.williamson@redhat.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Oct 2021 09:48:20 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 19 Oct 2021 13:58:32 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
> > state.
> > 
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > ---
> >  include/uapi/linux/vfio.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 114ffcefe437..6d41a0f011db 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -631,6 +631,8 @@ struct vfio_device_migration_info {
> >  	__u64 data_size;
> >  };
> >  
> > +#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
> > +				 VFIO_DEVICE_STATE_RESUMING)  
> 
> This should be with the other VFIO_DEVICE_STATE_foo #defines.  I'd
> probably put it between _RESUMING and _MASK.  Thanks,

This should also update the existing macros that include _SAVING |
_RESUMING.  Thanks,

Alex

