Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F002612EA
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgIHOpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 10:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729649AbgIHO0K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 10:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599575163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uTbg/F8EMJz/zWHZGHElfxdFbIFaiE/jJsKyDwICFFY=;
        b=hkHT2HmkuGHo40OTKmRMTEF9oaIFN5uODhUQHWSOcP0h5AFbbAuojQZvOMpil8dw3zltXv
        fAZg7GUx5Gxe7M3xXWHQuVJGuD0Zy308GqRoGionQcem6nxAzA9QTDhsl+gMs1Bz8P3ec/
        1dVkwDe8iXC6/gYjie/y0ugHrpg0hEY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-a9RqD-8OOX2IFa2Aegtwzg-1; Tue, 08 Sep 2020 08:05:50 -0400
X-MC-Unique: a9RqD-8OOX2IFa2Aegtwzg-1
Received: by mail-wr1-f72.google.com with SMTP id l17so6838470wrw.11
        for <kvm@vger.kernel.org>; Tue, 08 Sep 2020 05:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uTbg/F8EMJz/zWHZGHElfxdFbIFaiE/jJsKyDwICFFY=;
        b=e3pPUuNHrrYV1aOt3QdVGqTeh2IeWrvvJ11qlv+fWP70yIyuDoVUMlXHDfXLx7Ved2
         LCJFdM1sIWpvqRMVswjUWicHQsjvsa4sxz/EJtOeHdpTzUXXH+xAtpFbPyDeio8JyEMq
         e0eUWhNj5jNZssHvWpOe5ZWI9Y1ZRo6zX+qeeqqK1rszbQF1FKbjie+Hkpl3X01zgmH9
         OuWICJXDQNmvrkav8rZU7ZibYfGXWKqpAuQGbpgbm9njxzGbhcyUt9P35SjgPTSFHfRM
         VPA9wgmP0XmeqFsP2FYEqE3S9DeWACTLV1ep4lZ3cVV0U0zvL3/MHnvKAJsyLZ9rFZk7
         2+jg==
X-Gm-Message-State: AOAM532H4rYOhWiAOKy/hPrQlP7gZIZpxEn5Pbed/3L2HJBfKiY7UgL4
        MEdtdT4NorViGzqORMQM8omF54YIA+HPKWU9f9kjAThRYfsuVA8elMbEXEVAvaZpJi6O5TxvSHC
        enUjxrvK4tmkt
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr4062493wmd.161.1599566749491;
        Tue, 08 Sep 2020 05:05:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1voR2aDQ/omOiAhnyNbh20XUmSq/vHolLDEZXQW14ePuREj8QwPqWOFx4FPXk1oqmTfQ+LA==
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr4062476wmd.161.1599566749321;
        Tue, 08 Sep 2020 05:05:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-218-236.inter.net.il. [80.230.218.236])
        by smtp.gmail.com with ESMTPSA id l8sm34308524wrx.22.2020.09.08.05.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:05:48 -0700 (PDT)
Date:   Tue, 8 Sep 2020 08:05:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost: remove mutex ops in vhost_set_backend_features
Message-ID: <20200908080513-mutt-send-email-mst@kernel.org>
References: <20200907105220.27776-1-lingshan.zhu@intel.com>
 <20200907105220.27776-2-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907105220.27776-2-lingshan.zhu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 06:52:19PM +0800, Zhu Lingshan wrote:
> In vhost_vdpa ioctl SET_BACKEND_FEATURES path, currect code
> would try to acquire vhost dev mutex twice
> (first shown in vhost_vdpa_unlocked_ioctl), which can lead
> to a dead lock issue.
> This commit removed mutex operations in vhost_set_backend_features.
> As a compensation for vhost_net, a followinig commit will add
> needed mutex lock/unlock operations in a new function
> vhost_net_set_backend_features() which is a wrap of
> vhost_set_backend_features().
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

I think you need to squash these two or reorder, we can't first
make code racy then fix it up.

> ---
>  drivers/vhost/vhost.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..e03c9e6f058f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2591,14 +2591,12 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
>  	struct vhost_virtqueue *vq;
>  	int i;
>  
> -	mutex_lock(&dev->mutex);
>  	for (i = 0; i < dev->nvqs; ++i) {
>  		vq = dev->vqs[i];
>  		mutex_lock(&vq->mutex);
>  		vq->acked_backend_features = features;
>  		mutex_unlock(&vq->mutex);
>  	}
> -	mutex_unlock(&dev->mutex);
>  }
>  EXPORT_SYMBOL_GPL(vhost_set_backend_features);
>  
> -- 
> 2.18.4

