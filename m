Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B4749E2AA
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 13:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbiA0MmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 07:42:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241313AbiA0Mlv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 07:41:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643287311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uNXpPtb2OXqXG9hmJBWkzD608J4s2s8/JsJidLVyecU=;
        b=CW05eK1vUvlsPfFp6m9vJhou6V3Y9/AL8THswO2fdF4SXMpo4F731s7uMnTUxGznDD6E4e
        uwDR5Q9PoLR++ma/yl1nUewvXFniju1YSdIYVcQmM0NsnNWcw8la6w2Lt7a00oIjsY+bF8
        zEJkhCs0DRofSijDmdYq8esi6pqS8bU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-DNEJ1_r1Ptu4U-wnxuNvDw-1; Thu, 27 Jan 2022 07:41:49 -0500
X-MC-Unique: DNEJ1_r1Ptu4U-wnxuNvDw-1
Received: by mail-ed1-f72.google.com with SMTP id i22-20020a0564020f1600b00407b56326a2so1351851eda.18
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 04:41:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uNXpPtb2OXqXG9hmJBWkzD608J4s2s8/JsJidLVyecU=;
        b=KPVacrjDjqip3xfudjCdGRRPs3dUjDMe8y/yWesVZNhV3f44RG1zNP8SjOY2nDfG7F
         wF9WWR2sQOTgCUqedi9+DsqElQyWe9IBpUzw4oJfolFY3OKfnA/97FqAAOxPqgk20RJ6
         YxKAFPNJLGVup6SKE3f17V5KRUXRsfqfPaSGgzailx6xFuImgL8rMfgsNk+c5PcCveEL
         MQWfiKxrFl8e+5/gYCu3LOZqCMGzWxRUK3vA1lqo7ILqJmVetzcD3lJexIMDnPQPBY3C
         oZ6Jx7uG2/oiVOlsjVY7W4asGc9qrc44f4y8pcNr5PmuNVlKIXiL/V6ln2Lm3RW9/2tB
         RmtA==
X-Gm-Message-State: AOAM530W8GxKOrsRbUe9neCbg3wEmcbN7QsfZSCiiVpdNdXkMxMwHWel
        gWkDFmxAuA3BjWuxPFnsYKnft9f++gsSOuSBz/ytPfeaGtU/nkhSGj308RRODtpKjSjrccHeUJV
        DnEZUqUsBF9Up
X-Received: by 2002:a17:907:7d89:: with SMTP id oz9mr2684960ejc.400.1643287308392;
        Thu, 27 Jan 2022 04:41:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyotloQ/8jLEyYVrL4x9QKTye3cSBEx1XpJh+giSQrDeyBAnixpRAjtIqNHOtrp8KFRexubOA==
X-Received: by 2002:a17:907:7d89:: with SMTP id oz9mr2684950ejc.400.1643287308220;
        Thu, 27 Jan 2022 04:41:48 -0800 (PST)
Received: from redhat.com ([2.55.140.126])
        by smtp.gmail.com with ESMTPSA id g9sm8674052ejf.98.2022.01.27.04.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 04:41:47 -0800 (PST)
Date:   Thu, 27 Jan 2022 07:41:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yin Xiujiang <yinxiujiang@kylinos.cn>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Make use of the helper macro kthread_run()
Message-ID: <20220127074050-mutt-send-email-mst@kernel.org>
References: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127020807.844630-1-yinxiujiang@kylinos.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022 at 10:08:07AM +0800, Yin Xiujiang wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
> 
> Signed-off-by: Yin Xiujiang <yinxiujiang@kylinos.cn>
> ---
>  drivers/vhost/vhost.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..19e9eda9fc71 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -595,7 +595,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  
>  	dev->kcov_handle = kcov_common_handle();
>  	if (dev->use_worker) {
> -		worker = kthread_create(vhost_worker, dev,
> +		worker = kthread_run(vhost_worker, dev,
>  					"vhost-%d", current->pid);
>  		if (IS_ERR(worker)) {
>  			err = PTR_ERR(worker);
> @@ -603,7 +603,6 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
>  		}
>  
>  		dev->worker = worker;
> -		wake_up_process(worker); /* avoid contributing to loadavg */
>  
>  		err = vhost_attach_cgroups(dev);
>  		if (err)

I think if you do this, you need to set dev->worker earlier.

> -- 
> 2.30.0

