Return-Path: <kvm+bounces-281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 500EF7DDBE9
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 05:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADD79B2118D
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375A81845;
	Wed,  1 Nov 2023 04:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHVfMrSB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB47F
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 04:36:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9D6FC
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 21:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698813393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bm6nv3OrJNAdAjBRVuIThTw9zVigtFmJLGDyu68dZkw=;
	b=HHVfMrSBP1WiarZ76VH1Heo8TMzC2tUMnnVp/ZznP9gINGpEqGzoS7VQrfC5/xEOILWYRm
	UAM1o4tyzYfq3YtajI6CHPtylCJA3PecbfXuj1Jo5wYNzf2CTH3xwqs9BrnS51YH4KpM8/
	628tXQY1kCeZn9Z6blAQeSgBPsBam/Q=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-v5p1a_SoOoCSz3TRX40t9w-1; Wed, 01 Nov 2023 00:36:32 -0400
X-MC-Unique: v5p1a_SoOoCSz3TRX40t9w-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c563a2a4f0so69502341fa.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 21:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698813391; x=1699418191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bm6nv3OrJNAdAjBRVuIThTw9zVigtFmJLGDyu68dZkw=;
        b=FEGd72KSP4+uM+kwMTfppxUNMJupwihSW0FgFpaIlGMDap32u1oLL5zZgnnVXDBThk
         IPIpljXhyX00z0YSVf0L32z4fwBg4/5NfvE7gI0JvdQomcsRwla+Ajas3drdP9O4JeJN
         l9zqZNNGt2c0GOFNt6bcJfrblp3MiyjIhmcYpsPIThFVSwdWVqFokDoKj3KVFuEC1gr4
         WYR/7At5c5HxOP6uEp2T27+cdH9YkQqY9NMB3+O60kuK6yvcIDrcqkHgG1eP0oRCEZ+L
         ggOiYMB3V1DhDH621Di1A4/MKTKouXVBaadGF5fXY+orwFuAzWQApI+MZvghdBGmi77P
         EyFw==
X-Gm-Message-State: AOJu0YwkdeOj/fBXZ3ky5X72fN6eQtyOIQ7XHLTXWCZBalanBac+RsWJ
	JkkNpdmOcx69ikjzb/vx/z0D5vukUncEgFieNIZAjw8hnd6RD3BfaMt89P/eLcJrBqO7CHajZkE
	TXsKsZh43Bz++LgQ8w8YKk31pcNC+
X-Received: by 2002:a19:ae16:0:b0:503:afa:e79 with SMTP id f22-20020a19ae16000000b005030afa0e79mr10181914lfc.5.1698813390935;
        Tue, 31 Oct 2023 21:36:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFiWTEEXffIJuc8scoNdDy3OwhB3Mf/+OrEdEdZTWinIPqM4Ur7SHi0nvzq6dnmpW4or5dSxVvXJ3rxzRcbLU=
X-Received: by 2002:a19:ae16:0:b0:503:afa:e79 with SMTP id f22-20020a19ae16000000b005030afa0e79mr10181908lfc.5.1698813390652;
 Tue, 31 Oct 2023 21:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
In-Reply-To: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 1 Nov 2023 12:36:19 +0800
Message-ID: <CACGkMEvytH47Wb2LjP2667-D8OWbDruwV8aRvqcUzksWB-ruvg@mail.gmail.com>
Subject: Re: [PATCH net-XXX] vhost-vdpa: fix use after free in vhost_vdpa_probe()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bo Liu <liubo03@inspur.com>, "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 8:13=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> The put_device() calls vhost_vdpa_release_dev() which calls
> ida_simple_remove() and frees "v".  So this call to
> ida_simple_remove() is a use after free and a double free.
>
> Fixes: ebe6a354fa7e ("vhost-vdpa: Call ida_simple_remove() when failed")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/vdpa.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 9a2343c45df0..1aa67729e188 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1511,7 +1511,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdp=
a)
>
>  err:
>         put_device(&v->dev);
> -       ida_simple_remove(&vhost_vdpa_ida, v->minor);
>         return r;
>  }
>
> --
> 2.42.0
>


