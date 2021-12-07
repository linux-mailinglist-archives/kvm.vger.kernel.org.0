Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1913D46C802
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 00:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhLGXNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 18:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbhLGXNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 18:13:10 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF78C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 15:09:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n8so298966plf.4
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 15:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qKDd1VX3hBC89im9d4I56OuLVc25eiwTlx+sbQdp+Sw=;
        b=vnRocbhNrruqT81hYa0+LL1YmTd03xre0R39dPhTL0Iz+ndRyi8Kk2j4vncEtIedml
         5RWbyz49x2iypSewBHEWmhUYR0VuL5cEhUkN98ZUxvT6HS/VyG0I0qMdRscK/WNR2DzI
         dB92AVMKkDTkNdE63WRtE0QzmrymcC1lL2mSUXhMPJ7x/2TV60k32n1ycoojIp/UExzR
         fc6k80Qup2+U+AI6C7WOejJzHM7rcFKuzGjy1pgiKFxywby8bw80rj64B0R02Fi6e6vv
         fL+92ombKOd2u0jrHgMNUN/EW+PdkCFpJ2gNZo1sByZ9x4wqg7GRifEO4/ue6Cqc/Sfp
         0iYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qKDd1VX3hBC89im9d4I56OuLVc25eiwTlx+sbQdp+Sw=;
        b=zwWOVZe2kWXRpYsDO0lFmTi9bUMuUkC5rIFYGLZpRhHa5Gqj+OqgImn9cIagXLDLQa
         J9gNpkudwAfHnrOcjcbB83OfjdH5UpB3OF20gn+dDVOTllN2G3RH1tZ6tPATWVhuxGfc
         31v8mJS3FEsayu3wENFF7mrp2usj81aJ/dlw+Da6Rprv8BLYy4DeuNlrkJ2pDrjjYwfa
         kyU/wf4meljWyWbBlfsW2TxPpNU8RCnMrI6C4KdgH25fTu+vpAIIdA/5FOAw+fS6jzTM
         vtzVJkx3o6bvZh+ODm9DXEAVTrn8D6Ryq3EsXoyWMLXBDzuzBtgMp+cSYWysYvwkqTvP
         mkQw==
X-Gm-Message-State: AOAM530Ha/+pzFqHY57wyMvpDncNPnAFE99sEF3/WgQS0LRdmsHj37B0
        iEhNujl+jltZ3iOnz9crbbP9Nu9FiDT6bwOkcqTm3A==
X-Google-Smtp-Source: ABdhPJzZdj71AnZbqQAjVBfM6MMhRIMl5UOIfQgG74lXBky1qWNCtCR6rgJiwzjurPqRAgI5uDkweOykjFQBpapU+Vk=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
 t13-20020a1709027fcd00b001428ab3ec0emr54368732plb.4.1638918579107; Tue, 07
 Dec 2021 15:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-4-baolu.lu@linux.intel.com> <Ya3BYxrgkNK3kbGI@kroah.com>
 <Ya4abbx5M31LYd3N@infradead.org> <20211206144535.GB4670@nvidia.com>
 <Ya4ikRpenoQPXfML@infradead.org> <20211206150415.GD4670@nvidia.com>
In-Reply-To: <20211206150415.GD4670@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 7 Dec 2021 15:09:28 -0800
Message-ID: <CAPcyv4gS8fxx_QP43ShhLysRgy0XH-4KS_e3WO56k6gNMQqaJA@mail.gmail.com>
Subject: Re: [PATCH v3 03/18] driver core: platform: Rename platform_dma_configure()
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        "open list:DMA MAPPING HELPERS" <iommu@lists.linux-foundation.org>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 6, 2021 at 7:04 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Dec 06, 2021 at 06:47:45AM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 06, 2021 at 10:45:35AM -0400, Jason Gunthorpe via iommu wrote:
> > > IIRC the only thing this function does is touch ACPI and OF stuff?
> > > Isn't that firmware?
> > >
> > > AFAICT amba uses this because AMBA devices might be linked to DT
> > > descriptions?
> >
> > But DT descriptions aren't firmware.  They are usually either passed onb
> > the bootloader or in some deeply embedded setups embedded into the
> > kernel image.
>
> Pedenatically yes, but do you know of a common word to refer to both
> OF and ACPI that is better than firmware? :)
>
> AFAICT we already use firwmare for this in a few places, eg
> fwnode_handle and so on.

I've always thought 'platform' was the generic name for otherwise
non-enumerable platform-firmware/data things enumerated by ACPI / OF.
