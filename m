Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F43622AABD
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgGWIeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 04:34:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46505 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgGWIep (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 04:34:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595493284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGTIbgCx+rDVKvWTlEHAJATfxUUpkuPfnD7JMbYkQY8=;
        b=Q9TvbV+hkGZs0MeWmEiWZfVRPg9TshPH0P6bYkmZqO65IbKU0DAppaVlRQ68GjfZOcP0HJ
        B3DkQzb4kTuQAD8ufADqOolDQUj32HbSaHLrLeyl9+gYkuaN7ve3TQqWM83Tn15QCQ8PRE
        /j6cUe58LoAd9gjVN3ufIngDREaYieo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-HSUEivGwPkafClJwqUmUQg-1; Thu, 23 Jul 2020 04:34:43 -0400
X-MC-Unique: HSUEivGwPkafClJwqUmUQg-1
Received: by mail-wr1-f72.google.com with SMTP id k11so657493wrv.1
        for <kvm@vger.kernel.org>; Thu, 23 Jul 2020 01:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGTIbgCx+rDVKvWTlEHAJATfxUUpkuPfnD7JMbYkQY8=;
        b=r6TdazyvtVc+X964bOarZ6byCZKsdGDAxN0FGCHTIn5UzdUvI/9VvSb9GFzGXZsFrP
         xnWc3e7ndwWYN+ADlHaqj1/MovFY+Kq7+AYnpXeJbIa4Emb3Pqf3yD3ZFj0VaVLRFA5v
         gaN9zSB7BSHblTpfE43lexo+OGWtQCWwCpZnoy+fa34eYBS3oSEtPHTxuKTZ7xfWOXco
         t7ZxEdzPcTAq0nfhTlyFce8ExXz6fcBNPkqn6L9sxBvpISY+GFsTSACvxsSBvKPD7oXh
         QFRvLHxSdGQvUZTRnLA4/AQ9sRX77zk/GGZy1DXYf1pIwTMXhJ4rHpRzAhQbBhbO2b0+
         89zg==
X-Gm-Message-State: AOAM533HJcEqG1xPkJaimsiQdK3oba+psvcapCwR4ZZZZyUPia3EBjc0
        AUPZNrvIc+6GzbTLVa39yJ40tFOypR2GJFdhJcJI2uU5FuzqBFVibd45CvOtH7EAjDmghYQzuCX
        6AjOeNdoYj9PR
X-Received: by 2002:a7b:cb8d:: with SMTP id m13mr2650633wmi.120.1595493281557;
        Thu, 23 Jul 2020 01:34:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXZi0KGyqccwK0YBH6EPSIFaT3xENgDnbzBhFqPmSY7XV5a91YqQHX0IHrfs3AUaL6q2mXag==
X-Received: by 2002:a7b:cb8d:: with SMTP id m13mr2650615wmi.120.1595493281258;
        Thu, 23 Jul 2020 01:34:41 -0700 (PDT)
Received: from steredhat.lan ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id o2sm2897806wrj.21.2020.07.23.01.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 01:34:40 -0700 (PDT)
Date:   Thu, 23 Jul 2020 10:34:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 1/4] vhost: convert VHOST_VSOCK_SET_RUNNING to a
 generic ioctl
Message-ID: <20200723083435.3rjn5qiqhxcvxxwk@steredhat.lan>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200722150927.15587-2-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722150927.15587-2-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 05:09:24PM +0200, Guennadi Liakhovetski wrote:
> VHOST_VSOCK_SET_RUNNING is used by the vhost vsock driver to perform
> crucial VirtQueue initialisation, like assigning .private fields and
> calling vhost_vq_init_access(), and clean up. However, this ioctl is
> actually extremely useful for any vhost driver, that doesn't have a
> side channel to inform it of a status change, e.g. upon a guest
> reboot. This patch makes that ioctl generic, while preserving its
> numeric value and also keeping the original alias.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> ---
>  include/uapi/linux/vhost.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 0c2349612e77..5d9254e2a6b6 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -95,6 +95,8 @@
>  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
>  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
>  
> +#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
> +
>  /* VHOST_NET specific defines */
>  
>  /* Attach virtio net ring to a raw socket, or tap device.
> @@ -116,7 +118,7 @@
>  /* VHOST_VSOCK specific defines */
>  
>  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> -#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> +#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
>  
>  /* VHOST_VDPA specific defines */
>  
> -- 
> 2.27.0
> 

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

