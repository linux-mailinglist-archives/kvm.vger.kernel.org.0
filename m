Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065D1319A27
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 08:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBLHPD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 12 Feb 2021 02:15:03 -0500
Received: from foss.arm.com ([217.140.110.172]:33184 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBLHPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 02:15:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 188E3142F
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 23:14:16 -0800 (PST)
Received: from mail-pf1-f178.google.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 033893FA45
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 23:14:16 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id k13so5263237pfh.13
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 23:14:15 -0800 (PST)
X-Gm-Message-State: AOAM532yf9ceAD/gfD1XYYO9yyV4JCYo99HTpfaOCtBdvpEbS60Grm7W
        QlfZDQZoBgaPU7yyhU8UJNABYgna4ynBiOlNahM=
X-Google-Smtp-Source: ABdhPJwh4OqzK51l5+oCcpoe1lJtHP5iZhZK3MLekzZNtkSeLcPp/+/1EG+P0Mm/KZz1hThhfwoCC9mQkeT8tsLUBKQ=
X-Received: by 2002:a63:1865:: with SMTP id 37mr1914822pgy.206.1613114055288;
 Thu, 11 Feb 2021 23:14:15 -0800 (PST)
MIME-Version: 1.0
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com> <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
 <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6bcd5229-9cd3-a78c-ccb2-be92f2add373@redhat.com> <DM5PR11MB143531EA8BD997A18F0A7671C3BF9@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB143531EA8BD997A18F0A7671C3BF9@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Vivek Gautam <vivek.gautam@arm.com>
Date:   Fri, 12 Feb 2021 12:44:03 +0530
X-Gmail-Original-Message-ID: <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
Message-ID: <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, "Wu, Hao" <hao.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,


On Sat, Jan 23, 2021 at 2:29 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>
> Hi Eric,
>
> > From: Auger Eric <eric.auger@redhat.com>
> > Sent: Tuesday, January 19, 2021 6:03 PM
> >
> > Hi Yi, Vivek,
> >
> [...]
> > > I see. I think there needs a change in the code there. Should also expect
> > > a nesting_info returned instead of an int anymore. @Eric, how about your
> > > opinion?
> > >
> > >     domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
> > >     ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING,
> > &info);
> > >     if (ret || !(info.features & IOMMU_NESTING_FEAT_PAGE_RESP)) {
> > >             /*
> > >              * No need go futher as no page request service support.
> > >              */
> > >             return 0;
> > >     }
> > Sure I think it is "just" a matter of synchro between the 2 series. Yi,
>
> exactly.
>
> > do you have plans to respin part of
> > [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing to VMs
> > or would you allow me to embed this patch in my series.
>
> My v7 hasn’t touch the prq change yet. So I think it's better for you to
> embed it to  your series. ^_^
>

Can you please let me know if you have an updated series of these
patches? It will help me to work with virtio-iommu/arm side changes.

Thanks & regards
Vivek
