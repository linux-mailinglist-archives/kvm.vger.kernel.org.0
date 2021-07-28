Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561A13D8881
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhG1HEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:04:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57487 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhG1HEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 03:04:54 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N5FQJ-1n9Ipi13Bt-0117pO; Wed, 28 Jul 2021 09:04:51 +0200
Received: by mail-wm1-f45.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so922907wms.0;
        Wed, 28 Jul 2021 00:04:51 -0700 (PDT)
X-Gm-Message-State: AOAM5313lpJUfcDv78Dh6GGcjF/dUcJA84kHhrvqm6hxFWXBR6L9/9hM
        vfekag4LmZwhS5UReejIy6UqimkJtFu+6mF3Fu4=
X-Google-Smtp-Source: ABdhPJynD/9Il+Kw/wzVv2FoAI9EzaLkE/ynrgFuvxOuhTIZl8g9i0YgqUQZRMdYvUppf3KbqSXlK642XfMKR85CXEE=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr7815803wmb.142.1627455890836;
 Wed, 28 Jul 2021 00:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210721161609.68223-1-yishaih@nvidia.com> <20210721161609.68223-13-yishaih@nvidia.com>
 <20210727155440.680ee22e.alex.williamson@redhat.com> <20210727230941.GL1721383@nvidia.com>
 <20210728054306.GA3421@lst.de>
In-Reply-To: <20210728054306.GA3421@lst.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 28 Jul 2021 09:04:34 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3eSVoCYToP=7cNv97DO-fjV1G6a=-OnrNhXhsbBVU7Qg@mail.gmail.com>
Message-ID: <CAK8P3a3eSVoCYToP=7cNv97DO-fjV1G6a=-OnrNhXhsbBVU7Qg@mail.gmail.com>
Subject: Re: [PATCH 12/12] vfio/pci: Introduce vfio_pci_core.ko
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
X-Provags-ID: V03:K1:+f2qo4ua7/cksPQTjl1NeHfnGfT7wAnsfKlTOy/V9f/cIKCDU4Q
 2VTOnRHjOy+tvKnk1lEYzXGzMRqet4fiN7t1/mxOV2TDeDa0xGWLTPimgsCXdaKpX2zCv7R
 n1WvBx4Fu4KHWc0uahadfNxt8V43q/H2FWirIDCprGgYrpWEy0dSRSSmShW2B6EZO86qkrB
 hKYG7CQr0tzNmM1ipIWQw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wm1Mt9kc0/k=:QUXNKlQGOBuDsiUq7keSe8
 W0k4cMAQct3MqJNU0wxAL4V3brl58luotfZ5+yfJioS3VaIuJLhFLSw7Gu0MIzh28ClyxUCcf
 HQoXWmK5DrP0KpPpnhTpTak5JLL+OU7yepJY8uI4I3SEtMa+AM8ujELMN4KgPU7HQuhNr8bNm
 K4JADdEj181L/8r8/1xara1aShvnM/wIskSKvg0aY4JOSaYOEHmQALbHWxd65Q8ShbkCztSv9
 Qeq7NyoSV00UB9V6LpYZmv2n1Nm5HrDLM2DvMyvXdNQs383OmONzrnHEuBQc97xDHfhskmDbw
 nQgCNzXu0d5s4rE/nNUCaAPWenC9Ru58n45GzmpKuAKfQtxTB+yMDZhqR/ABGfMFCeoC27m37
 RmJ+gFMgBimjmGraLc8d307bKXvTyta5UiLbnlnLxdaea2AztaEW9neAXpZLpX+XjT1zXPZeV
 gXniN9bgh/6FI7ffcLWzKdtxgnr/epbx+yjqxeNPFE7fWG9FFHrbK+/2/tM7lr+Gk770c3MMZ
 Tf698OLnPpLC0qtMNFz982BgryuR9qu0SSTII17xd/y+T860acPI8nAtpMSIVauRUK4IqS+Hn
 k/toid48qel0gu5IhWqbXA3rkE0NU4qNxrHYkNaiakE7ycYRW0H+STXLqNFzgxZaLHa8BEIpb
 JAGgW0FgSXXi7z94cvvwS2NWPW+FxOHY8AdRECyWYc/m50ro7wno++1tBH51xILlc/11niCx4
 Rb43vSKQgYaIPYpG8x3ma1Ik9hPfxpjE5PV3y1Wc2U/ZEsfiyk/OvZd35MGMMqmxcR0Bjm+8V
 u32m2E+iBBTed84zKqHVjYh7erU93iAPM7LWCllfs5Z94mYYaH/7W+6B+eFb7a547+GEScA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 7:43 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Jul 27, 2021 at 08:09:41PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 27, 2021 at 03:54:40PM -0600, Alex Williamson wrote:
> >
> > > I'm still not happy with how this is likely to break users and even
> > > downstreams when upgrading to a Kconfig with this change.
> >
> > I've never heard of Kconfig as stable ABI. Christoph/Arnd, have you
> > heard of any cases where we want to keep it stable?
>
> It isn't an ABI, but we really do try to avoid breaking if we can and
> I rember Linus shouting at people if they did that for common options.

This is handled in very different ways depending on the maintainers,
some people go to great lengths to avoid breaking 'make oldconfig'
or 'make defconfig', others don't seem to mind at all.

CONFIG_USB_EHCI_TEGRA is an example of an option that was
left in place to help users of old config files, another one is
CONFIG_EXT3_FS. In both cases the idea is that the original
code was changed, but the old option left in place to point to
the replacement.

I think doing this is generally a good idea, but I would not consider
this a stable ABI in the sense that we can never break it. Most users
should have migrated to the new option after a few kernel releases,
and then I would remove the old one.

If a user upgrades across multiple kernel releases at once, usually
all hope of reusing an old .config is lost anyway.

> However lately for example the completely silly s/THUNDERBOLT/USB4/
> change did slip through and did break my test setup with a vfio passed
> through external nvme drive :(

Another recent example is CONFIG_FB no longer being selected by
the DRM subsystem, which broke a lot of defconfigs.

        Arnd
