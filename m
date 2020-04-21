Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC81B1B1AEB
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 02:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDUAth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 20:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726587AbgDUAth (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 20:49:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F10C061A0E;
        Mon, 20 Apr 2020 17:49:37 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id s10so8953649edy.9;
        Mon, 20 Apr 2020 17:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJHlw0Va8nRu1bocL0iGdefgbBDvsiBEjRNcEzF2emU=;
        b=meeAYjLZhNhYpKBnFQIRY8QNiqkTLOGzc2f5eEof1vaJQqZnU3xO9BHaM0ZTWqz18H
         7JdM/LuAS1FxwOG+U10a3oGmldXeSsYkdnMVfzGPyQiNrW5OHAnV4Q5byiDuVeQsbNl1
         E333eMFKt3b2MoMegW3BJnD5V/q7diY8XYF6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJHlw0Va8nRu1bocL0iGdefgbBDvsiBEjRNcEzF2emU=;
        b=a/wFIf5hD+/oJA5RSbMbbz1417fcXd889TM/dWOyGPwLU2YG+PFn6jLSkdlxXujwEW
         18CTMXcohge7LNpTHmi4hWtbDZRnJMNLXkLBei4h3MCCWqIJTUMLdTLGMYQ4J1RVg9Dz
         COCD5sbAfQk+ukX4YVvQ9ntUsFyRKrLW3utL0LPERlAbqBlyIrlY01XjUQQJQ+XKScZG
         N9FR80YTN/HvCd5xu8DmM/wxbZQMui69EhGB1JNKa7pbVi6dnM+Zeub4V2FObvezLLfa
         DbHpTnBBYYJ5vVAja978ugiwP/lH8lnUWwZwK+O2s+sOb4nYn1TcClujZuJnG2Tzz6uC
         qoAQ==
X-Gm-Message-State: AGi0PuZK7Z8jiqf5gHNt7re+5wEGy2Ci1tPLA2JTFM7D0IH2034oWIoV
        6nXQq7yalFTE2WbRRY9WgNXEiS3ZhvK1fvMZOtk=
X-Google-Smtp-Source: APiQypI1EAeVQeoUmWxrcddmzILwfd83lCEKJEUjqchmR0ZO8JH1LNOiAonElPJJKLVzNuxsgOg9s5aCArGIIeHtz4k=
X-Received: by 2002:a50:cd17:: with SMTP id z23mr16344581edi.191.1587430175724;
 Mon, 20 Apr 2020 17:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
In-Reply-To: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 21 Apr 2020 00:49:23 +0000
Message-ID: <CACPK8XdzLiUkzp-B3DuwxVHgn-hZqKypoyU_PLtE5d0K=B1mXQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers/powerpc: Replace _ALIGN_UP() by ALIGN()
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        alsa-devel@alsa-project.org, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Apr 2020 at 18:37, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>
> _ALIGN_UP() is specific to powerpc
> ALIGN() is generic and does the same
>
> Replace _ALIGN_UP() by ALIGN()
>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

I was curious, so I expanded out the kernel one. Here's the diff:

- (((addr)+((size)-1))&(~((typeof(addr))(size)-1)))
+ (((addr)+((typeof(addr))(size) - 1))&~((typeof(addr))(size)-1))

So it adds a cast, but aside from that it's the same.

Reviewed-by: Joel Stanley <joel@jms.id.au>

> ---
>  drivers/ps3/ps3-lpm.c               | 6 +++---
>  drivers/vfio/pci/vfio_pci_nvlink2.c | 2 +-
>  drivers/video/fbdev/ps3fb.c         | 4 ++--
>  sound/ppc/snd_ps3.c                 | 2 +-
>  4 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
> index 83c45659bc9d..064b5884ba13 100644
> --- a/drivers/ps3/ps3-lpm.c
> +++ b/drivers/ps3/ps3-lpm.c
> @@ -1096,8 +1096,8 @@ int ps3_lpm_open(enum ps3_lpm_tb_type tb_type, void *tb_cache,
>                 lpm_priv->tb_cache_internal = NULL;
>                 lpm_priv->tb_cache = NULL;
>         } else if (tb_cache) {
> -               if (tb_cache != (void *)_ALIGN_UP((unsigned long)tb_cache, 128)
> -                       || tb_cache_size != _ALIGN_UP(tb_cache_size, 128)) {
> +               if (tb_cache != (void *)ALIGN((unsigned long)tb_cache, 128)
> +                       || tb_cache_size != ALIGN(tb_cache_size, 128)) {
>                         dev_err(sbd_core(), "%s:%u: unaligned tb_cache\n",
>                                 __func__, __LINE__);
>                         result = -EINVAL;
> @@ -1116,7 +1116,7 @@ int ps3_lpm_open(enum ps3_lpm_tb_type tb_type, void *tb_cache,
>                         result = -ENOMEM;
>                         goto fail_malloc;
>                 }
> -               lpm_priv->tb_cache = (void *)_ALIGN_UP(
> +               lpm_priv->tb_cache = (void *)ALIGN(
>                         (unsigned long)lpm_priv->tb_cache_internal, 128);
>         }
>
> diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
> index ed20d73cc27c..65c61710c0e9 100644
> --- a/drivers/vfio/pci/vfio_pci_nvlink2.c
> +++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
> @@ -67,7 +67,7 @@ static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *vdev,
>          *
>          * This is not fast path anyway.
>          */
> -       sizealigned = _ALIGN_UP(posoff + count, PAGE_SIZE);
> +       sizealigned = ALIGN(posoff + count, PAGE_SIZE);
>         ptr = ioremap_cache(data->gpu_hpa + posaligned, sizealigned);
>         if (!ptr)
>                 return -EFAULT;
> diff --git a/drivers/video/fbdev/ps3fb.c b/drivers/video/fbdev/ps3fb.c
> index 834f63edf700..9df78fb77267 100644
> --- a/drivers/video/fbdev/ps3fb.c
> +++ b/drivers/video/fbdev/ps3fb.c
> @@ -44,7 +44,7 @@
>  #define GPU_CMD_BUF_SIZE                       (2 * 1024 * 1024)
>  #define GPU_FB_START                           (64 * 1024)
>  #define GPU_IOIF                               (0x0d000000UL)
> -#define GPU_ALIGN_UP(x)                                _ALIGN_UP((x), 64)
> +#define GPU_ALIGN_UP(x)                                ALIGN((x), 64)
>  #define GPU_MAX_LINE_LENGTH                    (65536 - 64)
>
>  #define GPU_INTR_STATUS_VSYNC_0                        0       /* vsync on head A */
> @@ -1015,7 +1015,7 @@ static int ps3fb_probe(struct ps3_system_bus_device *dev)
>         }
>  #endif
>
> -       max_ps3fb_size = _ALIGN_UP(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
> +       max_ps3fb_size = ALIGN(GPU_IOIF, 256*1024*1024) - GPU_IOIF;
>         if (ps3fb_videomemory.size > max_ps3fb_size) {
>                 dev_info(&dev->core, "Limiting ps3fb mem size to %lu bytes\n",
>                          max_ps3fb_size);
> diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
> index 6d2a33b8faa0..b8161a08f2ca 100644
> --- a/sound/ppc/snd_ps3.c
> +++ b/sound/ppc/snd_ps3.c
> @@ -926,7 +926,7 @@ static int snd_ps3_driver_probe(struct ps3_system_bus_device *dev)
>                             PAGE_SHIFT, /* use system page size */
>                             0, /* dma type; not used */
>                             NULL,
> -                           _ALIGN_UP(SND_PS3_DMA_REGION_SIZE, PAGE_SIZE));
> +                           ALIGN(SND_PS3_DMA_REGION_SIZE, PAGE_SIZE));
>         dev->d_region->ioid = PS3_AUDIO_IOID;
>
>         ret = ps3_dma_region_create(dev->d_region);
> --
> 2.25.0
>
