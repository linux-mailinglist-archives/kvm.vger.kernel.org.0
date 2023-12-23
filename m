Return-Path: <kvm+bounces-5197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BB181D748
	for <lists+kvm@lfdr.de>; Sun, 24 Dec 2023 00:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87E36282FC8
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 23:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57C01D68A;
	Sat, 23 Dec 2023 23:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8y803xR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A9E1D527
	for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703374687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vo+lDb0wJXd4hdBEVp0Ww22V2dy/PRP+8Xd5xVkEKjY=;
	b=h8y803xRHO8ty+acB+WNKEVS/ZICyuD8G7fp/3peN7KEteR6TfzLFBtc57k5lObosRJPUY
	SOt+Q2IA3wGsOksEFmOwEamgIrOSbFZ67NNlGMG990ybm9RsYCuRucOJtqiGstYTrKZV21
	cRpNFpH28HvaOY+j74B0d+d96vw0H2U=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-RONouddqMduAErNIenq2Vw-1; Sat, 23 Dec 2023 18:38:05 -0500
X-MC-Unique: RONouddqMduAErNIenq2Vw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bac08a97c1so37170939f.0
        for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 15:38:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703374684; x=1703979484;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vo+lDb0wJXd4hdBEVp0Ww22V2dy/PRP+8Xd5xVkEKjY=;
        b=Jr79p2XkKrO6tBo+BfLggBl5kynZ99+GNCUiSMPzEKheiMKgEgor/gFlGTJ4OhHQW3
         gM0AAK2Lk7D7qnUSuzvzNBWs7UayPniSKVjEuyY31g+t/QXlYcj7Avxfz29BUQPaUp68
         m0NWo1/4iPMqfGM/wqvhgw4kvKdZ2qX+EacbH5zgkLZLf3ihGvHEUa0dgvuYyNTdUlR7
         er3luiVDtildUpemxE1rtjtq7XA0p8h3ewZNGtaYcavuVfgbsWph32WiJgjF34nsdME2
         cYQFYfvV139z2PQSM5FQ78GapmfRF/oNuL7N34qVLjJn+RpFuHCK4XZExzYd9UmBhd6A
         C+zg==
X-Gm-Message-State: AOJu0YxuBXDf/5V51T3JcltkNVvWYs8+5FsBnbxr+ZOiyCHVzEYFHj8n
	lZlOIKSfkE53VQpvrU6uFHNTG+GAGc4nccVnMbE7fjKGO+wv0jXs0q8pp3L+SEyFIo23ts4R8jw
	FeurbtC6UtkXhOgSXl0b/
X-Received: by 2002:a05:6602:17c4:b0:7b7:96aa:70b4 with SMTP id z4-20020a05660217c400b007b796aa70b4mr4132540iox.9.1703374684663;
        Sat, 23 Dec 2023 15:38:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFMSybNvHaiQEg+aF+8VIpYW/wXwNjQO0sFwQ5UQ2G8NoALM/J9aFYiapO5kWbXkjT12zkj/Q==
X-Received: by 2002:a05:6602:17c4:b0:7b7:96aa:70b4 with SMTP id z4-20020a05660217c400b007b796aa70b4mr4132532iox.9.1703374684424;
        Sat, 23 Dec 2023 15:38:04 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id s1-20020a5ec641000000b007b7d65b30bbsm1703145ioo.3.2023.12.23.15.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 15:38:03 -0800 (PST)
Date: Sat, 23 Dec 2023 16:38:02 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Matthew W Carlis <mattc@purestorage.com>
Cc: kvm@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH 1/1] vfio/pci: Log/indicate devices being bound &
 unbound.
Message-ID: <20231223163802.4098b07a.alex.williamson@redhat.com>
In-Reply-To: <20231223221612.35998-2-mattc@purestorage.com>
References: <20231223221612.35998-1-mattc@purestorage.com>
	<20231223221612.35998-2-mattc@purestorage.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 23 Dec 2023 15:16:12 -0700
Matthew W Carlis <mattc@purestorage.com> wrote:

> We often would like to know when a device is unbound or bound
> to vfio. Since I have a belief that such events should be
> infrequent & in low volume; after this change the driver
> will log when it decides to bind and unbind a device.
> 
> vfio-pci doesn't log when it binds to a device or is unbound
> from a device. There may be logging from vfio when a device
> is opened or closed by some user process which is good, but
> even when the device is never opened vfio may have taken some
> action as a result of binding. One such example might be
> putting it into D3 low power state.
> 
> Additionally, the lifecycle of some applications that use
> vfio-pci may be infrequent or defered for a significant time.
> We have found that some third party tools or perhaps ignorant
> super-users may choose to bind or unbind devices with a fairly
> inexplicit policy leaving applictions that might have wanted
> to use a device confused about its absence from vfio.
> 
> Signed-Off-by: Matthew W Carlis <mattc@purestorage.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1929103ee59a..3e463a7d25f9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2265,6 +2265,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto out_power;
> +
> +	pci_info(pdev, "binding to vfio control\n");
>  	return 0;
>  
>  out_power:
> @@ -2291,6 +2293,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  		pm_runtime_get_noresume(&vdev->pdev->dev);
>  
>  	pm_runtime_forbid(&vdev->pdev->dev);
> +
> +	pci_info(vdev->pdev, "unbinding from vfio control\n");
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);

Parsing dmesg is a poor means to track driver bindings.  There are
already udev events, why aren't those sufficient?  They're certainly
more generic.  Thanks,

Alex


