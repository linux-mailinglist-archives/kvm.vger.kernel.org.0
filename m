Return-Path: <kvm+bounces-6145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5217682C2B6
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFE50286589
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 15:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AD86EB5C;
	Fri, 12 Jan 2024 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bl/0TZGd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27B11EB50
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705073431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKcet7EPhwZvK+ahttSgaOqRHQ80c589qC78IA79o1A=;
	b=Bl/0TZGdK9gFZSdaFzNowHUZxmekatOgNVg4aOQ22sLqjFgpVwVotVeqgtafqylrYqWDQQ
	IzprZMR3warSVUa2rweVyt4A7HDR3a7u3HjAmL46sUDJOVQP2rIXRdMF1M1cnCmF/5r82I
	0BstQrSwjN77mcv1I89A4bB6qads9DM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-luKUf50ONymcJ8_EqXHPwg-1; Fri, 12 Jan 2024 10:30:30 -0500
X-MC-Unique: luKUf50ONymcJ8_EqXHPwg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7bef780be70so231947239f.0
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 07:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705073429; x=1705678229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKcet7EPhwZvK+ahttSgaOqRHQ80c589qC78IA79o1A=;
        b=CG/syfhqOpvf+CHJWE98xVy1rXzDTY+uuswXLR0/pia7selO1Wpa3svdUgfsfGdMmZ
         dCNcqXltxW1KZBeBTv/exSSSXPz2UvGnSP8qXvG+qgaKmNbJn4f2DCZUZeiMmjzYUv0a
         erAuQI3GmZaVaAia/UDLelQdXyWoJDzBjC+XyXoRp07oRAgZGYch/xgOknMOJgOsuzUL
         lLSN6T1Bt5tqzBk3X6U48CzHR/3OjkdnL1F/Wpwy5SFl8gjyeQesq0Y5ekKsYBmEk8TG
         JS32SWqJ/IQa6q9S9cB+FMyHgC/80uOk7HbeVeWJLM+2iylvovM/ob39/t0FsA/h7fxZ
         8aOg==
X-Gm-Message-State: AOJu0YzGNrciP1XC6xKF+WTSeCMdVAJHxNaEG6A0UlPemDZ93HTkqaOz
	wHjEkZUjW6+Zv3jJfQLbguuu+yFvQja5y6UZ0sxrE6F2JzTloP6ywmmbEdapQz3MjxB4cSSQN+w
	3GybyjO+rNAduWWbX41oe
X-Received: by 2002:a5e:9419:0:b0:7be:f199:31dc with SMTP id q25-20020a5e9419000000b007bef19931dcmr1615149ioj.23.1705073429237;
        Fri, 12 Jan 2024 07:30:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzsq9yRVXAib6DIQwfVf/KnFC6+h43i4PQcVSeTG/NcCD3gdNth3t5SI9RoZ3Srcn+8tHD5A==
X-Received: by 2002:a5e:9419:0:b0:7be:f199:31dc with SMTP id q25-20020a5e9419000000b007bef19931dcmr1615147ioj.23.1705073428999;
        Fri, 12 Jan 2024 07:30:28 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id bi3-20020a05663819c300b0046e5995f930sm715355jab.10.2024.01.12.07.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 07:30:28 -0800 (PST)
Date: Fri, 12 Jan 2024 08:30:26 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Kunwu Chan <chentao@kylinos.cn>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Fix NULL pointer dereference in
 vfio_pci_bus_notifier
Message-ID: <20240112083026.7fd01b41.alex.williamson@redhat.com>
In-Reply-To: <20240112062221.135681-1-chentao@kylinos.cn>
References: <20240112062221.135681-1-chentao@kylinos.cn>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 14:22:21 +0800
Kunwu Chan <chentao@kylinos.cn> wrote:

> kasprintf() returns a pointer to dynamically allocated memory
> which can be NULL upon failure. Ensure the allocation was successful
> by checking the pointer validity.
> 
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..74e5b89a3a0c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2047,6 +2047,8 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
>  			 pci_name(pdev));
>  		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
>  						  vdev->vdev.ops->name);
> +		if (!pdev->driver_override)
> +			return -ENOMEM;
>  	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
>  		   pdev->is_virtfn && physfn == vdev->pdev) {
>  		struct pci_driver *drv = pci_dev_driver(pdev);

This is a blocking notifier callback, so errno isn't a proper return
value, nor does it accomplish anything.  We're into the realm of
worrying about small allocation failures here, which I understand
essentially cannot happen, but about the best we could do at this
point would be to WARN_ON if we weren't able to allocate an override.
Thanks,

Alex


