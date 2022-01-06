Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B36148644D
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 13:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiAFMXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 07:23:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238475AbiAFMXc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 07:23:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641471812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DIfBxULOavolfufOQdNG/vzCAo1esWK0a3vka0Ajyjs=;
        b=H6z8alnBOHpoSHFfpjx1TC22Hk0ABy2O491yPXJvmSTLHM7tRCwx0u4dVsi34KnjVmhs56
        RxM5DSffdej3+CCMcVNJbq5G+XggkxN5X6HzFyyoI10FjFyPi5autprQ3jSujJEDiPeQXt
        XG0s98pfWErjdHEbGq4JV2SH4pPAqxQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-Im1mPoBFPySi6wz1PvX2Qg-1; Thu, 06 Jan 2022 07:23:31 -0500
X-MC-Unique: Im1mPoBFPySi6wz1PvX2Qg-1
Received: by mail-wr1-f69.google.com with SMTP id a11-20020adffb8b000000b001a0b0f4afe9so1185654wrr.13
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 04:23:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DIfBxULOavolfufOQdNG/vzCAo1esWK0a3vka0Ajyjs=;
        b=46nYsdUKY5kSovpvOP1uXRUrJw+vPgUkABxuDEXpC9PZqb8RPxyNsXl9hU3Eu5byf1
         1Im0QaEda8vx1TIIAlYziE4bITfJYFd+h3gk9e61EoqhFNVT8JCcaHWrnXMCXVMWure2
         SUewcOXFS1tmixUzUuX2eQTdbfJ1GcZ4DzCdHnwcDNrIwE5k5ezF/T4VvTVDS6yqheQS
         q2g2mnr7ielIP0NVseyZ8sac4ap7z7vMTBD1kMl34DKtjrVQ9jr8BUu18j9pWU3Z0sdX
         03Mjgbom6wQfkiyhbXvoyANRmT+yTYGLPhU7kZXGX52s+WgPA/63QceVWl5RyfdHzfX9
         DGww==
X-Gm-Message-State: AOAM533X3IeTveQ4t7QcAPCIEHabRB4Nmo3zBdY8BjXrkA5pzrxv2r9Y
        EWgIZ/qPH9RWiobgVmh+0jHazm4D/vW9jwDnFZX8NKwiU692AqNrJJVDkB7hcVN5hafclVfIRIi
        JqpJuKaHpUyti
X-Received: by 2002:a05:6000:3c8:: with SMTP id b8mr5369681wrg.152.1641471809678;
        Thu, 06 Jan 2022 04:23:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCKaZ3Vwd4RKCtyVMKKYHTk+aalh3XwUj1HV3KC0ncZK7QR6PvJ9NCHxybq+bIctJq+mNlbw==
X-Received: by 2002:a05:6000:3c8:: with SMTP id b8mr5369670wrg.152.1641471809449;
        Thu, 06 Jan 2022 04:23:29 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:207e:991b:6857:5652:b903:a63b])
        by smtp.gmail.com with ESMTPSA id u15sm752186wmm.37.2022.01.06.04.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 04:23:28 -0800 (PST)
Date:   Thu, 6 Jan 2022 07:23:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost: add vhost_test to Kconfig & Makefile
Message-ID: <20220106072056-mutt-send-email-mst@kernel.org>
References: <20210616120734.1050-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616120734.1050-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 08:07:34PM +0800, Cai Huoqing wrote:
> When running vhost test, make it easier to config
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

I'd stick this under "Kernel Testing and Coverage"
or something like this. The point is we don't want this module
is release kernels.



> ---
>  drivers/vhost/Kconfig  | 12 ++++++++++++
>  drivers/vhost/Makefile |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 587fbae06182..c93c12843a6f 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -61,6 +61,18 @@ config VHOST_VSOCK
>         To compile this driver as a module, choose M here: the module will be called
>         vhost_vsock.
>  
> +config VHOST_TEST
> +       tristate "vhost virtio-test driver"
> +       depends on EVENTFD
> +       select VHOST
> +       default n
> +       help
> +       This kernel module can be loaded in the host kernel to test vhost function
> +       with tools/virtio-test.
> +
> +       To compile this driver as a module, choose M here: the module will be called
> +       vhost_test.
> +
>  config VHOST_VDPA
>         tristate "Vhost driver for vDPA-based backend"
>         depends on EVENTFD
> diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> index f3e1897cce85..cf31c1f2652d 100644
> --- a/drivers/vhost/Makefile
> +++ b/drivers/vhost/Makefile
> @@ -8,6 +8,9 @@ vhost_scsi-y := scsi.o
>  obj-$(CONFIG_VHOST_VSOCK) += vhost_vsock.o
>  vhost_vsock-y := vsock.o
>  
> +obj-$(CONFIG_VHOST_TEST) += vhost_test.o
> +vhost_test-y := test.o
> +
>  obj-$(CONFIG_VHOST_RING) += vringh.o
>  
>  obj-$(CONFIG_VHOST_VDPA) += vhost_vdpa.o
> -- 
> 2.22.0

