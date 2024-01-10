Return-Path: <kvm+bounces-6028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC48D82A4F4
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 00:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1CE21C2290E
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 23:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2DB5024C;
	Wed, 10 Jan 2024 23:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KieXm0gf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1740350243
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704929247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrNHEIe3ea+e/UXJPqy7LTP7mhEx2H+CbelvED2S6dg=;
	b=KieXm0gfm0/wp2menxd5jj+HCH/18hUFPYBQ2nksaUwRLGDwYY5YPdRFnFcSdjPOLSl1nT
	FXbNCmZDGqufnU2N/fRJ6k4WZ7sLku5+J8weasCaRiErd4HCUYs61CirWvvburQJ8J/nlp
	JEamf7h929gRcu5kqapitRXx557CeGU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-B5fF-uw-Opmv-vVmMimZcQ-1; Wed, 10 Jan 2024 18:27:20 -0500
X-MC-Unique: B5fF-uw-Opmv-vVmMimZcQ-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6de353881d7so930382a34.0
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 15:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704929239; x=1705534039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrNHEIe3ea+e/UXJPqy7LTP7mhEx2H+CbelvED2S6dg=;
        b=qyxb4JlTbAKRRF7RJdMnKdcZ6Fi7pe8JwKRV6UqoGt84WiZd1m09WcX7iacgcoEq9I
         ErGBeqoD61R783FPlDa0akbrUY7aV/8Mf3XsY6lHyVpYpO75L6uddGpaKU3cC9SByZ0v
         o8n+4TTCQ6myrGwrCk2wNGkc/MkY0KeQidIrb1OldzxqSzVZ4G6yHCvngGlqyOMDIuhr
         hQiQXTHZx+cb54j1ovZigPgTL/lSPCAdMuwze7i4ijcgMyCcniHSuYyMywSrTW9UIX4b
         wlXAbHM0dInsQ6w+maYgf6jINMy8+pSSxOzH/jkeB9BasqYYLihdVHcih9HIYCE2jOOv
         mHxg==
X-Gm-Message-State: AOJu0Yzh++Egn0v6z69QkS02Fm0salfLideydJrZ1P8niMzRqlHwRWzU
	kwt1e4JsPfNBHYzvz4gv7BkGIst82Hjoy92u1JZSnOEv2uGO3fkiVNLgzZ1u/UpV+qjEdMXo2gF
	66tLCqdzTk5lFJHw7cRnL
X-Received: by 2002:a05:6830:1114:b0:6da:531d:9af2 with SMTP id w20-20020a056830111400b006da531d9af2mr406990otq.10.1704929239298;
        Wed, 10 Jan 2024 15:27:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2C6jpBhPHNx973PLEU/pQRswb7lqo3Py9HGD/W0KEfAfyz3J8fHg+rAd2j5LDlltJSi4l0g==
X-Received: by 2002:a05:6830:1114:b0:6da:531d:9af2 with SMTP id w20-20020a056830111400b006da531d9af2mr406985otq.10.1704929239066;
        Wed, 10 Jan 2024 15:27:19 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id w10-20020a9d70ca000000b006dec024acffsm115655otj.57.2024.01.10.15.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 15:27:18 -0800 (PST)
Date: Wed, 10 Jan 2024 16:27:16 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: fix virtio-pci dependency
Message-ID: <20240110162716.64d37d66.alex.williamson@redhat.com>
In-Reply-To: <20240109075731.2726731-1-arnd@kernel.org>
References: <20240109075731.2726731-1-arnd@kernel.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 Jan 2024 08:57:19 +0100
Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new vfio-virtio driver already has a dependency on VIRTIO_PCI_ADMIN_LEGACY,
> but that is a bool symbol and allows vfio-virtio to be built-in even if
> virtio-pci itself is a loadable module. This leads to a link failure:
> 
> aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_probe':
> main.c:(.text+0xec): undefined reference to `virtio_pci_admin_has_legacy_io'
> aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_init_device':
> main.c:(.text+0x260): undefined reference to `virtio_pci_admin_legacy_io_notify_info'
> aarch64-linux-ld: drivers/vfio/pci/virtio/main.o: in function `virtiovf_pci_bar0_rw':
> main.c:(.text+0x6ec): undefined reference to `virtio_pci_admin_legacy_common_io_read'
> aarch64-linux-ld: main.c:(.text+0x6f4): undefined reference to `virtio_pci_admin_legacy_device_io_read'
> aarch64-linux-ld: main.c:(.text+0x7f0): undefined reference to `virtio_pci_admin_legacy_common_io_write'
> aarch64-linux-ld: main.c:(.text+0x7f8): undefined reference to `virtio_pci_admin_legacy_device_io_write'
> 
> Add another explicit dependency on the tristate symbol.
> 
> Fixes: eb61eca0e8c3 ("vfio/virtio: Introduce a vfio driver over virtio devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/vfio/pci/virtio/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> index fc3a0be9d8d4..bd80eca4a196 100644
> --- a/drivers/vfio/pci/virtio/Kconfig
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VIRTIO_VFIO_PCI
>          tristate "VFIO support for VIRTIO NET PCI devices"
> -        depends on VIRTIO_PCI_ADMIN_LEGACY
> +        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
>          select VFIO_PCI_CORE
>          help
>            This provides support for exposing VIRTIO NET VF devices which support

Applied to vfio next branch for v6.8.  Thanks!

Alex


