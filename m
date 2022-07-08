Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0456B0E6
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 05:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiGHDOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 23:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGHDOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 23:14:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC78674793
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 20:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657250075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6pWJ9vidmXiESXTHRmiFlc+OMg3mXWEt42MkWbaRXFo=;
        b=cvAQUN3upZK01jpzB6/K8AYNl2bU0HlYtQhooXLlFDtq3NHD/sH/7BSBFwsrJnCQZ+oBO5
        IvObkAsnEnlU7thP8NiTCZYyxDue3QS57cgtxXmYScbF1iQixwuNKPQkMJ7zDA9DZ2JHrJ
        hfehCzumJ0jZkDcO9qDbkLh1Se+RD4Q=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-s9wgzxp2MBSlIrU6wO4N5Q-1; Thu, 07 Jul 2022 23:14:26 -0400
X-MC-Unique: s9wgzxp2MBSlIrU6wO4N5Q-1
Received: by mail-lf1-f70.google.com with SMTP id o7-20020a056512230700b004810a865709so7120458lfu.3
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 20:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6pWJ9vidmXiESXTHRmiFlc+OMg3mXWEt42MkWbaRXFo=;
        b=WCqAQNP68CA8Yer1mjA4WKYDk25/dCEdvimpz5bz5Jh7+Nj1edjmndUzrM9lJGqnDZ
         w34SnD8omLYd3Ha4FrikmsP4TgyN2iR/zILHT1zZOm3US+5gf5VQOlD/YX0I6ZtZ6BWZ
         56xAoYvXOZ13t00WoJG8BzYaGhhm1BEgjMvAwO0W+2hNWxN4qWg48u7A4WHwi6tmuyhZ
         jFwJguX7rlofkuhv5uGYOKUOgtWGcjtwLQaI18WvHIBVap9/m7sOtQQ+LDrMHlzbnfzM
         +YENW73qZWfRub/iKpxsJgzjocYu99mXgkNucYoTcSW5/WuY7M+ssG3hRtektEysoHjJ
         s3LQ==
X-Gm-Message-State: AJIora9pSmVzEXNRsWiF3o0ngEM+J1wKaIdDuXIF2QCaJRdNdkLd0uHa
        QRgbb5FMMdmyzlR1NDzPkCi7N+BgYrpJOES8Q/Pjgt3fx0JWPyhOHmattliMri96enn5BV0oTX8
        CB6b87iPnJmI7NE1eDmOmy5kXZjOm
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id w13-20020a0565120b0d00b004815cb4cf1emr864067lfu.442.1657250064637;
        Thu, 07 Jul 2022 20:14:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sL5nNaKVUjLfzqmHqBuyERNjefQaJM/fNkZA4syaavKMsdSCdlbxtRU8opv07Qp1KDTOFhmmsBKmEyTtATiQ0=
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id
 w13-20020a0565120b0d00b004815cb4cf1emr864054lfu.442.1657250064363; Thu, 07
 Jul 2022 20:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
In-Reply-To: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 8 Jul 2022 11:14:13 +0800
Message-ID: <CACGkMEvkHKqOkTCEaTUHK4Ve=naeU5p09BpnvPW-y1cGqOTo_w@mail.gmail.com>
Subject: Re: [PATCH] vdpa: Use device_iommu_capable()
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 8, 2022 at 7:53 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> Use the new interface to check the capability for our device
> specifically.
>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 935a1d0ddb97..4cfebcc24a03 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1074,7 +1074,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>         if (!bus)
>                 return -EFAULT;
>
> -       if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
>                 return -ENOTSUPP;
>
>         v->domain = iommu_domain_alloc(bus);
> --
> 2.36.1.dirty
>

