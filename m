Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3442FC088
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729900AbhASTqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:46:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5196 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729866AbhASTnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 14:43:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600736260001>; Tue, 19 Jan 2021 11:42:30 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 19:42:30 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 19 Jan 2021 19:42:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvPfuWyRGsF0MRWBBh+T3mnhANf1V34A3Wb3eHXsb4CfqIrOCwZRAXU+uzAZmUr1O3sMRJVVAe7np89zC7aXQv0fYdQHHr/x6dZBUUVGLSfhCL9UrZNO/y0tAkFpLoe7AReZCg44xZyL6RBKFPiM6f8iD5a0OFGLzmuKnY8uzEjNF6d92If1Yz0KsToMxpCmGflc//P7JGckKLVGFJ8Xzj/26t5Qn2wRLQHT63z3BkCv0EpiaFtfzijiQfRLEP4tDuzm9P49U7iFWIcHpTTZWwFJ6TVRggF/CLZaYyjIpU888vSwFRp1DVK7juty/W9lx+YEM3Zy0ZHqOVQp7rH6ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcTSxcno5mAak3oEmM+85w6fqaZeDZ8lFv/+zeP8EzU=;
 b=ZQmRjNPcBGSecLPKvEkBMsTDet8W6Np3BxdirgY0iMPt0bzPYRAc0XRp8RLUEUKITSY9VKhEg7/hPwL1OR5c7I7d1W7wjssj9nFmCmFoZhiGmF0PNTZe4xgL3wBXDXB3xt0Glk9jtKwMj74EZqECPZunKwpt/BJG65pxrbjQ746B6iTW/KKdk6VcEuv5ikszbu/1KAf+WijhZuLaEDTkDgIP/pKG3s8K/8I0D056Z1dft7yFz7Q1E8vlXgECusyf6+Uhyt0LWpyTa4YUngdzPE1h30RwWukMVIK2+b34ebzZ3mFLXGm/lZKu2H5z8I9RsPguA/ye4WcNAvDytEuzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1516.namprd12.prod.outlook.com (2603:10b6:4:5::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.10; Tue, 19 Jan 2021 19:42:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.011; Tue, 19 Jan 2021
 19:42:28 +0000
Date:   Tue, 19 Jan 2021 15:42:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210119194226.GA916035@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210118143806.036c8dbc.cohuck@redhat.com>
 <20210118151020.GJ4147@nvidia.com>
 <20210118170009.058c8c52.cohuck@redhat.com>
 <20210118181626.GL4147@nvidia.com>
 <20210119195610.18da1e78.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210119195610.18da1e78.cohuck@redhat.com>
X-ClientProxiedBy: MN2PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:208:fc::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0028.namprd02.prod.outlook.com (2603:10b6:208:fc::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 19:42:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l1wtW-003r76-Tx; Tue, 19 Jan 2021 15:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611085350; bh=RcTSxcno5mAak3oEmM+85w6fqaZeDZ8lFv/+zeP8EzU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=B8CNbrTkmNralGJ1WS5zL8q1qT6+CGzd9M0NOd288SLQxGxd48aciPnTkQ6jaE8V8
         G7ELx9e7Ah83xMVvrSr6BAp3nfkuGw4kHsx1de2w97JnL9w/SnJEaBVPuAt02YM32a
         rCqYvxc0LWuI2IQEkYScVH0EsOLtp4KhvSmZ9WYAKJwUkTQDmPov2TAHt2MBK78ybc
         Ji91NyonsOVbItbeDO+LpUz6QHMq3oa4uGwCvjPx6KOE+GboEjhGlSpUXJ70qsMmnj
         LhiVzW87UpDEnKDvKgXmnXB0IUFzkh7I+nmo369yc0ScZXB1H6fIbnodP9HjLHaUVl
         D5fuAHbBiWeIA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 07:56:10PM +0100, Cornelia Huck wrote:
> On Mon, 18 Jan 2021 14:16:26 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jan 18, 2021 at 05:00:09PM +0100, Cornelia Huck wrote:
> > 
> > > > You can say that all the HW specific things are in the mlx5_vfio_pci
> > > > driver. It is an unusual driver because it must bind to both the PCI
> > > > VF with a pci_driver and to the mlx5_core PF using an
> > > > auxiliary_driver. This is needed for the object lifetimes to be
> > > > correct.  
> > > 
> > > Hm... I might be confused about the usage of the term 'driver' here.
> > > IIUC, there are two drivers, one on the pci bus and one on the
> > > auxiliary bus. Is the 'driver' you're talking about here more the
> > > module you load (and not a driver in the driver core sense?)  
> > 
> > Here "driver" would be the common term meaning the code that realizes
> > a subsytem for HW - so mlx5_vfio_pci is a VFIO driver because it
> > ultimately creates a /dev/vfio* through the vfio subsystem.
> > 
> > The same way we usually call something like mlx5_en an "ethernet
> > driver" not just a "pci driver"
> > 
> > > Yes, sure. But it also shows that mlx5_vfio_pci aka the device-specific
> > > code is rather small in comparison to the common vfio-pci code.
> > > Therefore my question whether it will gain more specific changes (that
> > > cannot be covered via the auxiliary driver.)  
> > 
> > I'm not sure what you mean "via the auxiliary driver" - there is only
> > one mlx5_vfio_pci, and the non-RFC version with all the migration code
> > is fairly big.
> > 
> > The pci_driver contributes a 'struct pci_device *' and the
> > auxiliary_driver contributes a 'struct mlx5_core_dev *'. mlx5_vfio_pci
> > fuses them together into a VFIO device. Depending on the VFIO
> > callback, it may use an API from the pci_device or from the
> > mlx5_core_dev device, or both.
> 
> Let's rephrase my question a bit:
> 
> This proposal splits the existing vfio-pci driver into a "core"
> component and code actually implementing the "driver" part. For mlx5,
> an alternative "driver" is introduced that reuses the "core" component
> and also hooks into mlx5-specific code parts via the auxiliary device
> framework.

Yes, I think you understand it well

> (IIUC, the plan is to make existing special cases for devices follow
> mlx5's lead later.)

Well, it is a direction to go. I think adding 'if pci matches XX then
squeeze in driver Y' to vfio-pci was a hacky thing to do, this is a
way out.

We could just add 'if pci matches mlx5 then squeeze in driver mlx5'
too - but that is really too horific to seriously consider.

> I've been thinking of an alternative split: Keep vfio-pci as it is now,
> but add an auxiliary device. 

vfio-pci cannot use auxiliary device. It is only for connecting parts
of the same driver together. vfio-pci has no other parts to connect.

Further, that is not how the driver core in Linux is designed to
work. We don't have subsytems provide a pci_driver and then go look
around for a 2nd driver to somehow mix in. How would it know what
driver to pick? How would drivers be autoloaded? How can the user know
things worked out right? What if they didn't want that? So many
questions.

The standard driver core flow is always 
   pci_driver -> subsystem -> userspace

I don't think VFIO's needs are special, so why deviate?

> I guess my question is: into which callbacks will the additional
> functionality hook? If there's no good way to do what they need to do
> without manipulating the vfio-pci calls, my proposal will not work, and
> this proposal looks like the better way. But it's hard to tell without
> seeing the code, which is why I'm asking :)

Well, could we have done the existing special devices we have today
with that approach? What about the Intel thing I saw RFC'd a while
ago? Or the next set of mlx5 devices beyond storage? Or an future SIOV
device?

If you have doubts the idea is flexible enough, then I think you
already answered the question :)

LWN had a good article on these design patterns. This RFC is following
what LWN called the "tool box" pattern. We keep the driver and
subsystem close together and provide useful tools to share common
code. vfio_pci_core's stuff is a tool. It is a proven and flexable
pattern.

I think you are suggesting what LWN called a "midlayer mistake"
pattern. While that can be workable, it doesn't seem right
here. vfio-pci is not really a logical midlayer, and something acting
as a midlayer should never have a device_driver..

To quote lwn:
   The core thesis of the "midlayer mistake" is that midlayers are bad
   and should not exist. That common functionality which it is so
   tempting to put in a midlayer should instead be provided as library
   routines which can used, augmented, or ignored by each bottom level
   driver independently. Thus every subsystem that supports multiple
   implementations (or drivers) should provide a very thin top layer
   which calls directly into the bottom layer drivers, and a rich library
   of support code that eases the implementation of those drivers. This
   library is available to, but not forced upon, those drivers.

Given the exciting future of VFIO I belive strongly the above is the
right general design direction.

Jason
