Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8C21A4334
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 09:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDJHxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 03:53:32 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36382 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJHxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 03:53:32 -0400
Received: by mail-oi1-f195.google.com with SMTP id k18so819960oib.3
        for <kvm@vger.kernel.org>; Fri, 10 Apr 2020 00:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=43YaSfqpJyOfIAuLu675v/pUr1xudLlbaRp3cnQ1E1M=;
        b=cCc881lc1Ihp03fcr4/K5Ry1lRAhHBAe2oBey2RPlj6VUOOaiSCsk9LDfAojhE39fw
         Wd78m1HwB08hZSOk+l5i1veJaOACszje90MAbh3T8IJ8eesg3ShhmBmE3Cw09aMYfHuc
         p/RaKN4C2F9qsyj3Lv0U0yZpxm3q7w+/602P+8Tfquy0LnZaoYt5333EAtOVcqvd4+XE
         f1EBh3RVA2qVwTS5e1nfuIiZP2EunyY7xl493XMdcycxLq1TCOzEz7JyDrEQyt87ZMej
         FhhwdiMNGGJlOU0WZpCotXSHR+++Asyv02/w5y3rNkcMEHmNt4Yb8K7NYdBk+YodH8qr
         m11A==
X-Gm-Message-State: AGi0PuYXVUHNKWya9zJG9mMikMUdBw/eQR4xANbDc77bGgJCG8CT3Qmm
        1fHyjkFAj8eitW1g5ich3eHx3v5Pr/QS4VxFC+A=
X-Google-Smtp-Source: APiQypI2iSZw3iV38K/psYnZhCLD4hmjmk2Nofeoj39fmkSe6PSIuMUG2TZNfre2x8Vj/xAGpFQnwPhLWPk1wzfDD8k=
X-Received: by 2002:aca:cdd1:: with SMTP id d200mr2373320oig.153.1586505211719;
 Fri, 10 Apr 2020 00:53:31 -0700 (PDT)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-20c384f1ea1a0bc7320bc445c72dd02d2970d594@kernel.org>
In-Reply-To: <git-mailbomb-linux-master-20c384f1ea1a0bc7320bc445c72dd02d2970d594@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 10 Apr 2020 09:53:20 +0200
Message-ID: <CAMuHMdUkff8XUrbHa90nGxa8Kj3HO9b2CRO57s3YZrSFPM51pg@mail.gmail.com>
Subject: Re: vhost: refine vhost and vringh kconfig
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Thu, Apr 9, 2020 at 6:04 AM Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Commit:     20c384f1ea1a0bc7320bc445c72dd02d2970d594
> Parent:     5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031
> Refname:    refs/heads/master
> Web:        https://git.kernel.org/torvalds/c/20c384f1ea1a0bc7320bc445c72dd02d2970d594
> Author:     Jason Wang <jasowang@redhat.com>
> AuthorDate: Thu Mar 26 22:01:17 2020 +0800
> Committer:  Michael S. Tsirkin <mst@redhat.com>
> CommitDate: Wed Apr 1 12:06:26 2020 -0400
>
>     vhost: refine vhost and vringh kconfig
>
>     Currently, CONFIG_VHOST depends on CONFIG_VIRTUALIZATION. But vhost is
>     not necessarily for VM since it's a generic userspace and kernel
>     communication protocol. Such dependency may prevent archs without
>     virtualization support from using vhost.
>
>     To solve this, a dedicated vhost menu is created under drivers so
>     CONIFG_VHOST can be decoupled out of CONFIG_VIRTUALIZATION.
>
>     While at it, also squash Kconfig.vringh into vhost Kconfig file. This
>     avoids the trick of conditional inclusion from VOP or CAIF. Then it
>     will be easier to introduce new vringh users and common dependency for
>     both vringh and vhost.
>
>     Signed-off-by: Jason Wang <jasowang@redhat.com>
>     Link: https://lore.kernel.org/r/20200326140125.19794-2-jasowang@redhat.com
>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/arm/kvm/Kconfig         |  2 --
>  arch/arm64/kvm/Kconfig       |  2 --
>  arch/mips/kvm/Kconfig        |  2 --
>  arch/powerpc/kvm/Kconfig     |  2 --
>  arch/s390/kvm/Kconfig        |  4 ----
>  arch/x86/kvm/Kconfig         |  4 ----
>  drivers/Kconfig              |  2 ++
>  drivers/misc/mic/Kconfig     |  4 ----
>  drivers/net/caif/Kconfig     |  4 ----
>  drivers/vhost/Kconfig        | 28 +++++++++++++++++++++-------
>  drivers/vhost/Kconfig.vringh |  6 ------
>  11 files changed, 23 insertions(+), 37 deletions(-)

> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -1,4 +1,23 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +config VHOST_RING
> +       tristate
> +       help
> +         This option is selected by any driver which needs to access
> +         the host side of a virtio ring.
> +
> +config VHOST
> +       tristate
> +       select VHOST_IOTLB
> +       help
> +         This option is selected by any driver which needs to access
> +         the core of vhost.
> +
> +menuconfig VHOST_MENU
> +       bool "VHOST drivers"
> +       default y

Please do not use default y. Your subsystem is not special.

> +

I think this deserves a help text, so users know if they want to enable this
option or not.

Thanks!

> +if VHOST_MENU
> +
>  config VHOST_NET
>         tristate "Host kernel accelerator for virtio net"
>         depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
