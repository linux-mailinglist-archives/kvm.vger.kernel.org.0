Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70B1263945
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 00:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgIIWmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 18:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIWmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 18:42:17 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B06AC061756
        for <kvm@vger.kernel.org>; Wed,  9 Sep 2020 15:42:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so2064761pjr.3
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 15:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+3Smoa+f+3uCqZK7RJ/D0oJ3+DMFy9C08WYAgHXWYaI=;
        b=HwIgtgQRJVYk3UsZVB8+LAlLldw0BKolYTPBL2Gyf0b0YpeakszW1bnCww6LMdxQ/8
         4UJFrBM//5btWbmHhxneRFOTwkI8khmwzmmcHbQYf0brTRE0EEL3yVL4Sfriwrs47TSm
         gSA6IUxE9u+rmUKcgwk5xg3m22l5YGSVeWovRXJYR9ai3O0nUyS66EeaqnIeA13hUkie
         EA3QrmS1owLGXIGColDstK6lb5+JzsZeIxY+DDdNaS0Yxrvkk0bSuy5XlG32Td1+X4gN
         Hsunao4vb+d1eKz215rP7/jxHzj3FLxgx7DHqVAK+FTsOuzBiZuxz9LJphsf1+ofjUaP
         jn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+3Smoa+f+3uCqZK7RJ/D0oJ3+DMFy9C08WYAgHXWYaI=;
        b=W+y0py9BwtqPlJ7Vvnb8eXbcT+mB6Y79N11e4UHeFmrXOAtg7MCtZLTOoT8cx1Ts7i
         OLxaoX770dKPJIbRgPOFmIuQieovLUdnkjmcbrAnmjkYKd42P1iRsJCMcUmq1gpl8Tty
         f1k2Hafkg5BeoxekBvHqx4zzSA6DcfcoCkeI1dopFIEExY5zsElilCDyqONxgspTYpbJ
         rgr6ftMdArJf33ZtI2jVIIzzCaPeZlIHOCJVHHIOiVwIMLYzgNhzAXgMhfnOAUt7LK+h
         t3p87sIAl063jA0vbzMLWU+XE+UN1PODsd2ddyuSMo5sXVpTxSO0SszeVv06opsP5Bxf
         Rl2g==
X-Gm-Message-State: AOAM5333nEfQU4EwXsolr/672qYn+oq3hRQzCQ/wawm+SQgwdi02fabK
        KEgppLd8gb5Vln97JxGJb6dLvA==
X-Google-Smtp-Source: ABdhPJz/2Qf6QNZwgwk/961aGz0uD5WP/jMVye/WwOGhRg0CjMOHv8HXh4RhClPh40DjwMrbC6a7yQ==
X-Received: by 2002:a17:90b:797:: with SMTP id l23mr2578793pjz.176.1599691336688;
        Wed, 09 Sep 2020 15:42:16 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id j6sm3520746pfi.129.2020.09.09.15.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 15:42:16 -0700 (PDT)
Date:   Wed, 9 Sep 2020 16:42:14 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
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
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v5 1/4] vhost: convert VHOST_VSOCK_SET_RUNNING to a
 generic ioctl
Message-ID: <20200909224214.GB562265@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-2-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826174636.23873-2-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 07:46:33PM +0200, Guennadi Liakhovetski wrote:
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
> index 75232185324a..11a4948b6216 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -97,6 +97,8 @@
>  #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
>  #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
>  
> +#define VHOST_SET_RUNNING _IOW(VHOST_VIRTIO, 0x61, int)
> +

I don't see it used in the next patches and as such should be part of another
series.

>  /* VHOST_NET specific defines */
>  
>  /* Attach virtio net ring to a raw socket, or tap device.
> @@ -118,7 +120,7 @@
>  /* VHOST_VSOCK specific defines */
>  
>  #define VHOST_VSOCK_SET_GUEST_CID	_IOW(VHOST_VIRTIO, 0x60, __u64)
> -#define VHOST_VSOCK_SET_RUNNING		_IOW(VHOST_VIRTIO, 0x61, int)
> +#define VHOST_VSOCK_SET_RUNNING		VHOST_SET_RUNNING
>  
>  /* VHOST_VDPA specific defines */
>  
> -- 
> 2.28.0
> 
