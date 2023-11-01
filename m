Return-Path: <kvm+bounces-282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF477DDC56
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 06:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 608951C20D96
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 05:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF784A2A;
	Wed,  1 Nov 2023 05:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFoieUlh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313A77F
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 05:33:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292E2B4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698816798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rDjrgwKhV0X8uxDqmbjmkhKFvllwLl3UFb2d3q6wJf0=;
	b=AFoieUlhJRiWnlWfcrq88PHXwct6Lnv8TONw/bFEFAhlAsbtJ6nW2fd8Cmj1SB3/hXfph6
	JOoIKdByCPIPK1hVhLadwzQqTkeEpXW3p9vvM6+16sCet0mIYBVjvZks2lwxgQ5NLzOQ2E
	alQlS/lgDjW4yEjFGit0a9x3vO4RUyw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-WAzU2opQPG2hDyUWP7GGfQ-1; Wed, 01 Nov 2023 01:33:16 -0400
X-MC-Unique: WAzU2opQPG2hDyUWP7GGfQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2c50234741eso55971621fa.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698816795; x=1699421595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDjrgwKhV0X8uxDqmbjmkhKFvllwLl3UFb2d3q6wJf0=;
        b=mP9PJzOQJASFN3+zrJFXNBjVMuLzwHqxj0euOfOLNrlZnf6T9k8Fu3X9DJQQA63Yqi
         kwxCWuGA0WITZmRKYbo3tz6dfWeuMG5O2aepLfkAMrzfjzaPQkSCjHIIF29D4Sof4ujk
         x9qOewRm+ERJoISvLMBKLHXGpBveJv2GjBSuN0diXc4CHj2ZgvII6Na6awQZTwmjToz+
         migXXTUe/byXZoAFvpC7N7hlgjdsUUEpndhk2mjgLMMuJMFBJA8ghmfmodqRxQupWUND
         F0VHjI/33eSwxo/5OXnp4EWokQFlWdboUTMog2oDgR02WZKYc8SXokIqkTD9wSKSZepb
         7uOw==
X-Gm-Message-State: AOJu0YxXnWG516Wt8bDGR21ghch/CEe4W5wPOSC9n3v5Mv1XEliujlUQ
	sxRkYdxJcKQ8355Uk9wlLwpcfmuItLNcHTZmAzRdLMBZ3BPoOEyNAcXIGrdrA75iid/rY2La5L2
	0dE1zN4XpXI/v
X-Received: by 2002:a2e:9812:0:b0:2c5:2661:ca06 with SMTP id a18-20020a2e9812000000b002c52661ca06mr11925682ljj.46.1698816795389;
        Tue, 31 Oct 2023 22:33:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdJKneWa6ZspieVJDbbOlVQ+x9L/r+0QQ7YYcFs15rRPnwA70wPVRW0dWuTfkT8+oyMFvGtg==
X-Received: by 2002:a2e:9812:0:b0:2c5:2661:ca06 with SMTP id a18-20020a2e9812000000b002c52661ca06mr11925671ljj.46.1698816795061;
        Tue, 31 Oct 2023 22:33:15 -0700 (PDT)
Received: from redhat.com ([2a02:14f:173:14b6:b6f1:4797:8f5d:fa41])
        by smtp.gmail.com with ESMTPSA id fk15-20020a05600c0ccf00b0040849ce7116sm204668wmb.43.2023.10.31.22.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 22:33:14 -0700 (PDT)
Date: Wed, 1 Nov 2023 01:33:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Bo Liu <liubo03@inspur.com>, Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-XXX] vhost-vdpa: fix use after free in
 vhost_vdpa_probe()
Message-ID: <20231101013303-mutt-send-email-mst@kernel.org>
References: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>

On Fri, Oct 27, 2023 at 03:12:54PM +0300, Dan Carpenter wrote:
> The put_device() calls vhost_vdpa_release_dev() which calls
> ida_simple_remove() and frees "v".  So this call to
> ida_simple_remove() is a use after free and a double free.
> 
> Fixes: ebe6a354fa7e ("vhost-vdpa: Call ida_simple_remove() when failed")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

queued, thanks!

> ---
>  drivers/vhost/vdpa.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 9a2343c45df0..1aa67729e188 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1511,7 +1511,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>  
>  err:
>  	put_device(&v->dev);
> -	ida_simple_remove(&vhost_vdpa_ida, v->minor);
>  	return r;
>  }
>  
> -- 
> 2.42.0


