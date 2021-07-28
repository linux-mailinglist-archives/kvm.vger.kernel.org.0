Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C4C3D8E9E
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 15:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhG1NI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 09:08:56 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:59181 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbhG1NIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 09:08:30 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N1xZX-1nAMXg0eU5-012GVn; Wed, 28 Jul 2021 15:08:25 +0200
Received: by mail-wr1-f49.google.com with SMTP id r2so2494812wrl.1;
        Wed, 28 Jul 2021 06:08:24 -0700 (PDT)
X-Gm-Message-State: AOAM530LP6x5d7utXqUEbeeqt/XXl8lsKRXLE4rbHhR0V70QVPVUOnrU
        IjrbdySFFgl9x1oZv/q4PIuea6rYr5kd+1eFohQ=
X-Google-Smtp-Source: ABdhPJxxfv5Wc+SHhdsDE/NGqS8JZjtCDRKxpejCmw8fSUu1pUblkMW8vqXlfFC6WPm8N6ImE4zLbL7TYQIjJuw7+SI=
X-Received: by 2002:a5d:44c7:: with SMTP id z7mr21469709wrr.286.1627477704695;
 Wed, 28 Jul 2021 06:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de> <20210728120326.GQ1721383@nvidia.com>
 <20210728122956.GA27111@lst.de> <20210728124755.GR1721383@nvidia.com>
In-Reply-To: <20210728124755.GR1721383@nvidia.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 28 Jul 2021 15:08:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a21ah=+x29jycWZBoTGA1RzfYz4qar9usvCa_hU85k=7g@mail.gmail.com>
Message-ID: <CAK8P3a21ah=+x29jycWZBoTGA1RzfYz4qar9usvCa_hU85k=7g@mail.gmail.com>
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, diana.craciun@oss.nxp.com,
        kwankhede@nvidia.com, Eric Auger <eric.auger@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-pci <linux-pci@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:VfrdqH+8hRfWWBCUeeCLzTKee5aiFfVqonRsF0cPxyHpJ27hjjW
 napliTyiM232iU/b2h7piQKIzmMmiu7xfzuBeJZZmgCIv2l0dQdGsOGfnIQAKUWxDOfk6vG
 fQRBZ/tLptHxvILO0wzGVrQ9kHzLmnxLZXR7+mMM3anAyTNikyoKsAmPBKcXeGjwZbRfSsG
 f4G7ykKBzoesUsQVIeJ6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eWfNL6UrdeU=:ampkA+bFoDa2sBzpiNamAZ
 zoWNZc90Y/wXqG+ZIuxUIDsFuNUlXxTk40/6eLdYbQ8W5xKOiWLFWtsfzXj0FvDgwhTCxEhVV
 Qf6ozj4bizaXHvOese38gPx6lwZO2aU5zr+OGUZWJL6sSTPVoSpDX2SK4qeFYkHY+VXL4Mcdj
 MUZaRhC32cvyr4/KdLgoILrgdZMgip4hcvO6y0k2ZqhptmfB7ZH3woAIG9zWg98piJHpcD+hA
 cIGqG2SA/4XpReAEg1fyG+9rTFlPfepHd7eVJXLCuhIC/Cfyj6pw+ez1QyvCbBIgofOpuLndp
 fZ49fGUeApxixHsC1i/gtt5FWxQJtIepsoyYDzsxGPJZJxgRWI4rhJbysCzMn1yU+65rx9k+p
 m9f908CAg/7jRGFDrBeid01FC4PKWtjI5vxuNRKv8l/Ylc4lCc2sZLXFLpwoDcjDEMXL4eQ0r
 K6nsL1iXJSCnb2ECESD8kHPZPtAowh55pUp7Qu7O4qLTiu74LXXZT8AyIfNbdcvd6PSLfPAwk
 jMQoJdJ6O72eQAsRuJ+Wr6hmh81DXi/bsUdHvuTplgmOwN0Jb1CAXGXiiOKJ1/N1QhOVIXV5u
 w8H9byVP/hvEbsGN0B+d3jp3p5Y+BmhMXIPukbnO/W3vqXr3iBz6YxNO2LvJ4fVh4Pqls1UJH
 Qkj+1B3BtCZbGaChjPGEdjI0wz8PtSFJSJkpU8O9fz/HSnpDNI8xDGcyZt3ABzeCRUvzIxFZf
 f3oUVXzgydQzG67vHycIWIBcM90VHvR5G2Pn4Z50u0/G3HNBCeu7OF4epJhF7+fniM6L277Wa
 rxgXCXWE5BrrzS9wE0Zn6Om4YhOoV6pfRBfOLBWA03xwDqh2s4oBmz4cC+ujWRAVKWyLr5U4x
 k7KRksKC7h03RoKVTW8pC6yeVJJbHGTrEA1bf0jccH+6oX6m6xMKo04lnodUcoe9L6srv6Xjy
 S/uFWCmR8XK4IOBPeSYprX+lgh+TSRfBv5QBeSi7eUAxav5rwg7eo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 2:47 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Jul 28, 2021 at 02:29:56PM +0200, Christoph Hellwig wrote:
>
> > So not really an issue here.  VFIO_PCI_CORE really is underlying
> > infrastructure a user should not care about.
>
> So then we can write it like below? Unfortunately it deletes the nice
> menu structure that groups all the PCI drivers together like platform
> (and mdev in future). Not sure this loss is worth the backwards compat

I think you can get back some structure by adding a 'menu "VFIO PCI drivers"'
and 'endmenu' around it.

> @@ -17,6 +15,7 @@ config VFIO_PCI_INTX
>
>  config VFIO_PCI
>         tristate "Generic VFIO support for any PCI device"
> +       select VFIO_PCI_CORE
>         help
>           Support for the generic PCI VFIO bus driver which can connect any
>           PCI device to the VFIO framework.
> @@ -50,6 +49,7 @@ endif
>  config MLX5_VFIO_PCI
>         tristate "VFIO support for MLX5 PCI devices"
>         depends on MLX5_CORE
> +       select VFIO_PCI_CORE
>         help

These two now have to get a 'depends on MMU' if they don't already inherit
that from elsewhere.

       Arnd
