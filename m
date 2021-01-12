Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804272F2D65
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 12:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbhALLGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 06:06:42 -0500
Received: from foss.arm.com ([217.140.110.172]:44106 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbhALLGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 06:06:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3B8C13D5
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 03:05:56 -0800 (PST)
Received: from mail-pl1-f182.google.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 911C63F73C
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 03:05:56 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id x12so1205014plr.10
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 03:05:56 -0800 (PST)
X-Gm-Message-State: AOAM530d8ftSVaSEG9YQ5hdjBglN80F9rfXROKprAdMUliSpZnjJU4eD
        DbfzsQ0LDTahyLBxjIvawlrw2afi7tfDNc8h3Dg=
X-Google-Smtp-Source: ABdhPJzsg6zT++OpgkFhHve/i+0GEamVqvPpEfMSkAHJGOtMcZmOT2hTATjzTkckorSJ3yItCQexaSYbcqy/caLFHkw=
X-Received: by 2002:a17:90a:f28f:: with SMTP id fs15mr4087906pjb.121.1610449555888;
 Tue, 12 Jan 2021 03:05:55 -0800 (PST)
MIME-Version: 1.0
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com> <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Vivek Gautam <vivek.gautam@arm.com>
Date:   Tue, 12 Jan 2021 16:35:45 +0530
X-Gmail-Original-Message-ID: <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
Message-ID: <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Sun, Yi Y" <yi.y.sun@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        Will Deacon <will@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>, Robin Murphy <robin.murphy@arm.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,


On Tue, Jan 12, 2021 at 2:51 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>
> Hi Vivek,
>
> > From: Vivek Gautam <vivek.gautam@arm.com>
> > Sent: Tuesday, January 12, 2021 2:50 PM
> >
> > Hi Yi,
> >
> >
> > On Thu, Sep 10, 2020 at 4:13 PM Liu Yi L <yi.l.liu@intel.com> wrote:
> > >
> > > This patch is added as instead of returning a boolean for
> > DOMAIN_ATTR_NESTING,
> > > iommu_domain_get_attr() should return an iommu_nesting_info handle.
> > For
> > > now, return an empty nesting info struct for now as true nesting is not
> > > yet supported by the SMMUs.
> > >
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Robin Murphy <robin.murphy@arm.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > > ---
> > > v5 -> v6:
> > > *) add review-by from Eric Auger.
> > >
> > > v4 -> v5:
> > > *) address comments from Eric Auger.
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29
> > +++++++++++++++++++++++++++--
> > >  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 29
> > +++++++++++++++++++++++++++--
> > >  2 files changed, 54 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index 7196207..016e2e5 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -3019,6 +3019,32 @@ static struct iommu_group
> > *arm_smmu_device_group(struct device *dev)
> > >         return group;
> > >  }
> > >
> > > +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain
> > *smmu_domain,
> > > +                                       void *data)
> > > +{
> > > +       struct iommu_nesting_info *info = (struct iommu_nesting_info
> > *)data;
> > > +       unsigned int size;
> > > +
> > > +       if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> > > +               return -ENODEV;
> > > +
> > > +       size = sizeof(struct iommu_nesting_info);
> > > +
> > > +       /*
> > > +        * if provided buffer size is smaller than expected, should
> > > +        * return 0 and also the expected buffer size to caller.
> > > +        */
> > > +       if (info->argsz < size) {
> > > +               info->argsz = size;
> > > +               return 0;
> > > +       }
> > > +
> > > +       /* report an empty iommu_nesting_info for now */
> > > +       memset(info, 0x0, size);
> > > +       info->argsz = size;
> > > +       return 0;
> > > +}
> > > +
> > >  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> > >                                     enum iommu_attr attr, void *data)
> > >  {
> > > @@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct
> > iommu_domain *domain,
> > >         case IOMMU_DOMAIN_UNMANAGED:
> > >                 switch (attr) {
> > >                 case DOMAIN_ATTR_NESTING:
> > > -                       *(int *)data = (smmu_domain->stage ==
> > ARM_SMMU_DOMAIN_NESTED);
> > > -                       return 0;
> > > +                       return arm_smmu_domain_nesting_info(smmu_domain,
> > data);
> >
> > Thanks for the patch.
> > This would unnecessarily overflow 'data' for any caller that's expecting only
> > an int data. Dump from one such issue that I was seeing when testing
> > this change along with local kvmtool changes is pasted below [1].
> >
> > I could get around with the issue by adding another (iommu_attr) -
> > DOMAIN_ATTR_NESTING_INFO that returns (iommu_nesting_info).
>
> nice to hear from you. At first, we planned to have a separate iommu_attr
> for getting nesting_info. However, we considered there is no existing user
> which gets DOMAIN_ATTR_NESTING, so we decided to reuse it for iommu nesting
> info. Could you share me the code base you are using? If the error you
> encountered is due to this change, so there should be a place which gets
> DOMAIN_ATTR_NESTING.

I am currently working on top of Eric's tree for nested stage support [1].
My best guess was that the vfio_pci_dma_fault_init() method [2] that is
requesting DOMAIN_ATTR_NESTING causes stack overflow, and corruption.
That's when I added a new attribute.

I will soon publish my patches to the list for review. Let me know
your thoughts.

[1] https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
[2] https://github.com/eauger/linux/blob/5.10-rc4-2stage-v13/drivers/vfio/pci/vfio_pci.c#L494

Thanks
Vivek

>
> Regards,
> Yi Liu

[snip]
