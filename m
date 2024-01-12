Return-Path: <kvm+bounces-6146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D1B82C2D7
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D37D51C21243
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 15:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3846F6EB5B;
	Fri, 12 Jan 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sb3VOPiZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45E7319E
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705073696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rG2cAHGtPmYkdk3n7aV573S9W6xf9H2t9/+D5tjR41Y=;
	b=Sb3VOPiZzl3PBe1u2nS+V310XhFqpU7yuUqjevznlWsKEpg3EBmKNaQpqXebhukVSUK0l4
	sv3msnAkp4qIF2CtHyE/Ay+DAxQCOH7vvgPEU5Zo24YI6hWiV+nDR7kl+Kd9CD3A7ZyzSs
	Qy8697hgbo8A8hdYcHjhaQ4vxi0Gpv0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-X6AXFC9mMdypkIt2FItVKg-1; Fri, 12 Jan 2024 10:34:50 -0500
X-MC-Unique: X6AXFC9mMdypkIt2FItVKg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bbb3de4dcbso890405239f.1
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 07:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705073689; x=1705678489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG2cAHGtPmYkdk3n7aV573S9W6xf9H2t9/+D5tjR41Y=;
        b=TR2zhQ9iXh2oGikIJ07YBAftVHMirUeAOJGl6Oencv/gfXDtaiJL8Ok06dCC6AYofK
         9eyK19X8ehEK77jbTOl3s/EAaEw4X5xWLn0R8imxdcwQGIG7H5+GP/pbStrvQ9TOhA/4
         aNN77amouS2lfZ9YJdTUQqOSYjgExT/ka00PWfEiEq2e3zztnL6NdJSiifirfxu2LPhW
         ferjQvq4z3L7Y8/D3USwf8pV2YeQBEk9V9GCoRb5usPz66P51fz4FvrsYGG5IJZmfmO2
         7m995ik/zteGjEgYcC8BYj8H8pHLGFn14BdhsXXc7N9o0zKXfXhYYrgVHlXUuohl4jvR
         UQmQ==
X-Gm-Message-State: AOJu0Yw7CrA8ADv+WO3btJKZ1d2Qkl4Ch1SWxsgsHkGsQqWNWnwHfLfc
	/Uu0tob0Cdoree2u3v4t4O2Bo0irIGX3sKIm+Af6w0vWzm65LKv8hQcukWiPpIoXXA3t6xO18QF
	Y9JTmECI3Gq7k4QcfwUKq
X-Received: by 2002:a05:6602:234a:b0:7bf:bb:ab73 with SMTP id r10-20020a056602234a00b007bf00bbab73mr1616851iot.18.1705073689306;
        Fri, 12 Jan 2024 07:34:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2w/p+DDnIx4QjeudfMRA2nrpJ8epdw1qDUQBCBhnVfD9HwWZBu0dRc/CNRCpcwf14BesJvQ==
X-Received: by 2002:a05:6602:234a:b0:7bf:bb:ab73 with SMTP id r10-20020a056602234a00b007bf00bbab73mr1616839iot.18.1705073689087;
        Fri, 12 Jan 2024 07:34:49 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id a23-20020a6b6c17000000b007bee386f29csm812469ioh.20.2024.01.12.07.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 07:34:48 -0800 (PST)
Date: Fri, 12 Jan 2024 08:34:47 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Kunwu Chan <chentao@kylinos.cn>
Cc: eric.auger@redhat.com, a.motakis@virtualopensystems.com,
 b.reynal@virtualopensystems.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/platform: Remove unnecessary free in
 vfio_set_trigger
Message-ID: <20240112083447.750ad1c6.alex.williamson@redhat.com>
In-Reply-To: <20240112064107.137384-1-chentao@kylinos.cn>
References: <20240112064107.137384-1-chentao@kylinos.cn>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 14:41:07 +0800
Kunwu Chan <chentao@kylinos.cn> wrote:

> commit 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
> add 'name' as member for vfio_platform_irq,it's initialed by kasprintf,
> so there is no need to free it before initializing.

What?!  Just look at the call path where vfio_set_trigger() is called
with a valid fd and existing trigger.  This change would leak irq->name
as it's reallocated via kasprintf().  Thanks,

Alex
 
> Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 61a1bfb68ac7..5e3fd1926366 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -179,7 +179,6 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
>  	if (irq->trigger) {
>  		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
>  		free_irq(irq->hwirq, irq);
> -		kfree(irq->name);
>  		eventfd_ctx_put(irq->trigger);
>  		irq->trigger = NULL;
>  	}


