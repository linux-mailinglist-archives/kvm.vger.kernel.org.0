Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB525B0C76
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 20:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiIGSZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 14:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIGSZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 14:25:28 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237EB2777
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 11:25:27 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f131so7264043ybf.7
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 11:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=t1RT2GVL7So8FRxhttvNmfTvwaG7wye3XjohR9wIDto=;
        b=d+pqtCM7emIqHqqcL0FHUBGevoq1D8aCT3LyylUG8lQcnvelI9T0US5vu7KwGPVIz5
         mzmXu8yMHa9xjZQzxqTF0/OFT6/PbcNpNEbMVWHQnSUEWUa9uberuGAQO/UfPpx5mNoE
         8IDPGgqmMCtXrV1CSCjdVYO83arausSfcFTWgtHvxSZSQ7yJF0wgjKzWER5gVVJH6zl1
         v9bx+QXgNeTUfPfAxLV0r78mUzP8aWPtsX7iEPZCtL7BOr3YEcBUoMhKNX/kqUr7B+XQ
         BOZgcuBdvMpanoRIG32KLgFjh9qtARUy+mu3yK6NIznET5lMXvuweEY0jSuS6p13b8bp
         gk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=t1RT2GVL7So8FRxhttvNmfTvwaG7wye3XjohR9wIDto=;
        b=azMwXGRkbBt7nD6xgPWS7XekzyNFS79QOd91FG8LGcw4D5p+eijLJHVSo0je+Y0qj7
         pahNHGZtMRPKLFaRyyZ8qmPYfWob1U6e27qCdzp7/AVgivzwxyv3D2xGXvYgirzpC7Xr
         G/iv7dPZKaSxK+8LFT6t9BwCf2wNK1kIz4f6ZcLXbYohoVRlt6oZMk3EbrfbTs7vs/hD
         5TsbNLKl3AB2THIM+AuhrYpQrKSoMzKV/rsBdDTScOUzKyX2acLXjHz0VejEmPWKkFQ9
         ir07G/0u65nJuoQ2YY6U6vyGPlniETWnA2cwtzwFzazL6W3Shq8fiSUYqMzvRghv+JkN
         KNSQ==
X-Gm-Message-State: ACgBeo1d3tmde7ZBYKgQN6exNH0ELGUxqFcR7nGY8xhfGsWvvLRZ1ARt
        uwjQRRXVPWJHDtPzdA/iUGVsuYGmd4apouN1mYpgUw==
X-Google-Smtp-Source: AA6agR5g3t8dPU742opp3p0IGn/aiTc1yTYGIe5tHSK58+GIreEcSzS0Uo9FzFd2YosZaWBi6GX37ZkiUG1Bh97oglc=
X-Received: by 2002:a25:3cc4:0:b0:696:5790:438d with SMTP id
 j187-20020a253cc4000000b006965790438dmr3664251yba.563.1662575126653; Wed, 07
 Sep 2022 11:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-4-nipun.gupta@amd.com> <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
 <DM6PR12MB30829DDDC62B36B17F87B204E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
 <f5cf7bd7-4cd9-ef9c-7f25-f814b2f1e41f@arm.com>
In-Reply-To: <f5cf7bd7-4cd9-ef9c-7f25-f814b2f1e41f@arm.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 7 Sep 2022 11:24:50 -0700
Message-ID: <CAGETcx9LE=E2focmbEsdQV3s2NR4-9H35ODkgSxZY5_7SEJ1Qw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 7, 2022 at 1:27 AM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2022-09-07 04:17, Gupta, Nipun wrote:
> > [AMD Official Use Only - General]
> >
> >
> >
> >> -----Original Message-----
> >> From: Saravana Kannan <saravanak@google.com>
> >> Sent: Wednesday, September 7, 2022 5:41 AM
> >> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> >> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> >> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> >> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> >> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> >> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> >> jeffrey.l.hugo@gmail.com; Michael.Srba@seznam.cz; mani@kernel.org;
> >> yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com;
> >> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> >> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> >> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> >> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> >> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> >> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx)
> >> <git@amd.com>
> >> Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
> >> for CDX bus
> >>
> >> [CAUTION: External Email]
> >>
> >> On Tue, Sep 6, 2022 at 6:48 AM Nipun Gupta <nipun.gupta@amd.com> wrote:
> >>>
> >>> With new CDX bus supported for AMD FPGA devices on ARM
> >>> platform, the bus requires registration for the SMMU v3
> >>> driver.
> >>>
> >>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> >>> ---
> >>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
> >>>   1 file changed, 14 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> index d32b02336411..8ec9f2baf12d 100644
> >>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>> @@ -29,6 +29,7 @@
> >>>   #include <linux/platform_device.h>
> >>>
> >>>   #include <linux/amba/bus.h>
> >>> +#include <linux/cdx/cdx_bus.h>
> >>>
> >>>   #include "arm-smmu-v3.h"
> >>>   #include "../../iommu-sva-lib.h"
> >>> @@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct
> >> iommu_ops *ops)
> >>>                  if (err)
> >>>                          goto err_reset_pci_ops;
> >>>          }
> >>> +#endif
> >>> +#ifdef CONFIG_CDX_BUS
> >>> +       if (cdx_bus_type.iommu_ops != ops) {
> >>> +               err = bus_set_iommu(&cdx_bus_type, ops);
> >>> +               if (err)
> >>> +                       goto err_reset_amba_ops;
> >>> +       }
> >>
> >> I'm not an expert on IOMMUs, so apologies if the question is stupid.
> >>
> >> Why does the CDX bus need special treatment here (like PCI) when there
> >> are so many other busses (eg: I2C, SPI, etc) that don't need any
> >> changes here?
> >
> > AFAIU, the devices on I2C/SPI does not use SMMU. Apart from PCI/AMBA,
> > FSL-MC is another similar bus (on SMMUv2) which uses SMMU ops.
> >
> > The devices here are behind SMMU. Robin can kindly correct or add
> > more here from SMMU perspective.
>
> Indeed, there is no need to describe and handle how DMA may or may not
> be translated for I2C/SPI/USB/etc. because they are not DMA-capable
> buses (in those cases the relevant bus *controller* often does DMA, but
> it does that for itself as the platform/PCI/etc. device it is).

Ok this is what I was guessing was the reason, but didn't want to make
that assumption.

So if there are other cases like AMBA, FSL-MC where the devices can do
direct DMA, why do those buses not need a #ifdef section in this
function like CDX? Or put another way, why does CDX need special treatment?

> Note that I have a series pending[1] that will make this patch a whole
> lot simpler.

Thanks for the pointer. I'll make some comments in that series about
bus notifiers.


-Saravana

>
> Thanks,
> Robin.
>
> [1]
> https://lore.kernel.org/linux-iommu/cover.1660572783.git.robin.murphy@arm.com/T/#t
>
> >
> > Thanks,
> > Nipun
> >
> >>
> >> -Saravana
> >>
> >>>   #endif
> >>>          if (platform_bus_type.iommu_ops != ops) {
> >>>                  err = bus_set_iommu(&platform_bus_type, ops);
> >>>                  if (err)
> >>> -                       goto err_reset_amba_ops;
> >>> +                       goto err_reset_cdx_ops;
> >>>          }
> >>>
> >>>          return 0;
> >>>
> >>> -err_reset_amba_ops:
> >>> +err_reset_cdx_ops:
> >>> +#ifdef CONFIG_CDX_BUS
> >>> +       bus_set_iommu(&cdx_bus_type, NULL);
> >>> +#endif
> >>> +err_reset_amba_ops: __maybe_unused;
> >>>   #ifdef CONFIG_ARM_AMBA
> >>>          bus_set_iommu(&amba_bustype, NULL);
> >>>   #endif
> >>> --
> >>> 2.25.1
> >>>
