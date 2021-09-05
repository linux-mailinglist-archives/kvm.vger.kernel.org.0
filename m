Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240C9401076
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhIEPK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 11:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIEPK1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 11:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630854563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bkfQCXJDEUYk3g8BBS8rlUuMyFV0Zq2nUPXbhNlOHg0=;
        b=Q85YS7u1I/oftYsxt+nm6nVOms4LmElCmBxTCLyJbIFU+F83YwTzJCSYx20Fbf5ZAvvABr
        VP3DFd5q1v0oB4bNNm4Kn8wE4SgnjOKbRbH/FWJDv/i6jsX/mHpD7fs8t9bVuGBP/ihzN/
        JUGD3HzsPKeXgYjdBu0jDDEhydcZK0U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-NmNvKZ-GOAmez7cIFlEOPg-1; Sun, 05 Sep 2021 11:09:22 -0400
X-MC-Unique: NmNvKZ-GOAmez7cIFlEOPg-1
Received: by mail-wr1-f70.google.com with SMTP id t15-20020a5d42cf000000b001565f9c9ee8so619182wrr.2
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 08:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bkfQCXJDEUYk3g8BBS8rlUuMyFV0Zq2nUPXbhNlOHg0=;
        b=EG4ySvCxSecFARA6zRxjrLhgF4IqUHh9TonEbBam5PZFyy71B9f3BCnYkrURWG5F4g
         KEzb59UVAIhyMZra1a+SPN9ZmpNZO30eBiiXrxYW2fI/cUA1ObPiFrh9l6RAaALimyf7
         HIbmtx/aPgT34yQ1p+hd09DKGT+Rg5bs1MfenAzScbfoP1qt85py3gRygYRJipUHtF1M
         o7BBd4+2h/xRZZCQcGXeOo3waak3QLFf6sA3EqgVR/ZShXwUhA5I0Ojxb40oFKrJl0Cj
         10ioDBrcLA08VjC4tcCsINEWdwJJNACwOANPZZP0+uBwiBu64gt8q/aJ9kcF0nKpeXdC
         Wc/g==
X-Gm-Message-State: AOAM532AdZJJhJsuEomIzRWEni7mfWiYkAqhvWKMyb0x5QViuEy/U6ir
        p/Y+IlgYJE5JpmgvPcxtfMc3XOY32eGCDvIB918lwsDkYITIi8AGzsdeTzaL9svXsFsvDCi3mw2
        DvAfFlIC07HM2
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr7294614wmd.160.1630854560957;
        Sun, 05 Sep 2021 08:09:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWg8Rhwq8pH6/4X7ngXckGFB5ySGYXCykfVnvivAfOnMQtde2OZp9BretAuFmPJFBmLiNypg==
X-Received: by 2002:a1c:1d84:: with SMTP id d126mr7294604wmd.160.1630854560782;
        Sun, 05 Sep 2021 08:09:20 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id h11sm6126459wrx.9.2021.09.05.08.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:09:20 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:09:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, oren@nvidia.com, nitzanc@nvidia.com
Subject: Re: [PATCH 1/1] virtio: add VIRTIO_F_IN_ORDER to header file
Message-ID: <20210905110804-mutt-send-email-mst@kernel.org>
References: <20210905120911.8239-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210905120911.8239-1-mgurtovoy@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 03:09:11PM +0300, Max Gurtovoy wrote:
> For now only add this definition from the spec. In the future, The
> drivers should negotiate this feature to optimize the performance.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>

So I think IN_ORDER was a mistake since it breaks ability
to do pagefaults efficiently without stopping the ring.
I think that VIRTIO_F_PARTIAL_ORDER is a better option -
am working on finalizing that proposal, will post RSN now.


> ---
>  include/uapi/linux/virtio_config.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> index b5eda06f0d57..3fcdc4ab6f19 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -82,6 +82,12 @@
>  /* This feature indicates support for the packed virtqueue layout. */
>  #define VIRTIO_F_RING_PACKED		34
>  
> +/*
> + * This feature indicates that all buffers are used by the device in the same
> + * order in which they have been made available.
> + */
> +#define VIRTIO_F_IN_ORDER              35
> +
>  /*
>   * This feature indicates that memory accesses by the driver and the
>   * device are ordered in a way described by the platform.
> -- 
> 2.18.1

