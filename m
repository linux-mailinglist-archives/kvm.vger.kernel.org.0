Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE1F3D8D85
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbhG1MMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:12:36 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:42833 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhG1MMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 08:12:35 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MeC5x-1mjQkp1ZbD-00bObP; Wed, 28 Jul 2021 14:12:32 +0200
Received: by mail-wm1-f48.google.com with SMTP id u15so1269692wmj.1;
        Wed, 28 Jul 2021 05:12:32 -0700 (PDT)
X-Gm-Message-State: AOAM532MpaqeO71mNQRW3YDRH16ST2k3YgQde3aNwDoikqA6sRXW6aW5
        KdT0rQ7IbGyTIpPwCt+pqqvg0eMUctRq5MPx5GU=
X-Google-Smtp-Source: ABdhPJxtjjFWzeF0bcDUjzb2WEgyyLb/YJ7SL+MS80Z9pRM49SN6JqmTZdBENGSfukT9DUUYsyY+SSfd5EqZgIJrm/o=
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr8756862wmc.75.1627474351802;
 Wed, 28 Jul 2021 05:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de> <20210728120326.GQ1721383@nvidia.com>
In-Reply-To: <20210728120326.GQ1721383@nvidia.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 28 Jul 2021 14:12:15 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1=sGwYqVoZzOdgrs7d6v3dwOFC9Q+pROnPB5F3Qe-5CA@mail.gmail.com>
Message-ID: <CAK8P3a1=sGwYqVoZzOdgrs7d6v3dwOFC9Q+pROnPB5F3Qe-5CA@mail.gmail.com>
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
X-Provags-ID: V03:K1:JWlaZN0i7V0mnUSFlIzSms4JvMbPeIKOGafbFT/ie0e4w8cE4Zc
 aa2qt2LXCopJG8zY8Rd4jSPsyqZ3KdENQOyHaYxjI9hCKc7zeoo5eJhLqn/7prLzRl1K3nf
 7OjkcLLYt+7yw9qgLlzIyEtGWJ+wGxRJ7GbbbixntZRoNxBCrKnovCw702MQ7px1RaGcS9Y
 EyM4lp6Z/1hz9nfOTFcJA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vEgE7TX5Cpo=:WWvybrpF3ZTubhw6xNo79c
 sV7p/i/sS+N98JL0maJm34sm2Mp4ePocIYqbcatJk0vxEJfPkEq/vgzwMGtTpsPh/vACKiIvs
 E0hjXivE4vMmOWnpSF7TFQtwcaFamBmL++v1M49P0zhiH9BJNgPAb/OoJ14vy/RhLJMyZlRCP
 fVlsf6RAaoFJ2edrxCMRxnvko7hy+XNdZchMQxA5uXa3Ronb6FPtfJbee7DWU+PztABoB0nEz
 QDuqmPqck46jkrM/so19xIvdoGEXNiUXy6iHTcvRw2osu/J9lrljEJzKrfIGaBJQDs1IbbChq
 kDjLWEUQMQ+E40iIjIji6QSg/rB3R0rseAN9VKZSyqYIy6Zmgqf5QiAIclEmPrDA+lC2e579q
 NF5lBFR/COCYJkJJXF/xTWzY2U3MyN/ybuTYOlLnKVgJ4/A5ZfF/m5LymgJWP0E7yWk/VyU2I
 SrOp4i5jTfZIwgjPaTS5CBgemjGC7bKelcWghUfsKnJNx/3+/4m8B5tE/vkx9E2sd4Xkx7kZg
 q4lV7yZ13nyLwuW9C2/ptQ1NziR3WUKF4USr3luwrt9/dvvY9MEkVNvuPCBQxqWv5wUMHHYlr
 yzfqTVH3T5FCIMQyw3oaGizKv8G+hELMXm4ExCpBkMzTvona2awfPgVGH/b9jwSmw7BgymFjF
 5WHmW2G945Llb7A+LeR9Xvb1kTW9Mps5sw1i9EiH9EZoVDL73dBr/mKrYK7sMSar7WmHpa6tD
 bbTJAniZ+7bxddAwA9bPEjxHMnRvx45R2u8xgo29I+s5GLCBdoFxeEwsdoA2RNzf09jdyPTLt
 vpbTwBYGyi+kJnc/QaUeec4wbEnSvQHeGQvjziQAw36oDz/dp8OGKHQYS/jK0doMAFrcn8Qki
 He/FBVAYT+WVSXO0mBIDjWb4iIvA/fLcKNT3f3eQf4vsvOuQ61+N0/opBUrFXycipV2oWrxS5
 XJeySE6pMAVXZug8cmgA2PW4LX4mi8c0DCfAETPmOyR3rfF04a1kd
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 2:03 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Wed, Jul 28, 2021 at 07:43:06AM +0200, Christoph Hellwig wrote:
>
> > > Which might reasonably be from an old kernel. 'make oldconfig' prompts:
> > >
> > > VFIO Non-Privileged userspace driver framework (VFIO) [Y/n/m/?] y
> > >   VFIO No-IOMMU support (VFIO_NOIOMMU) [Y/n/?] y
> > >   VFIO support for PCI devices (VFIO_PCI_CORE) [N/m/y/?] (NEW)
> > >
> > > Which is completely fine, IMHO.
> >
> > Why do we need to have VFIO_PCI_CORE as a user visible option?
> > I'd just select it.
>
> I'm not great with kconfig, but AFAIK:
>
> - It controls building a module so it needs to be a tristate
>
> - tristates need to be exposed in the menu structure
>
> - As it builds a module it also has depends on other things
>
> - Select should not be used to target tristates
>
> - Select should not be used to target options in the menu tree
>
> - Select should not be used to target options that have depends
>
> Which leaves us with this arrangement unless we delete the
> vfio_pci_core.ko module - which seems like a bad direction just for
> kconfig backwards compatibility.

I have not looked at the requirements for this particular patch, but
generally speaking there is no problem with using 'select' on
a tristate symbol.

The other points are correct though: you can not 'select' a symbol
that has dependencies, unless the symbol selecting it already
depends on those same options, and you should not 'select' user
visible options or other subsystems.

One common mistake is to have a reverse dependency, where
A uses 'select B' or 'depends on B', but then exports an ELF
symbol that is consumed by B, as opposed to the other way round.
I don't think that is a problem here though.

            Arnd
