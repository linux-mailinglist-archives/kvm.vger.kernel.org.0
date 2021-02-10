Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CC3316C1D
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhBJRJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:09:40 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12084 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhBJRJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 12:09:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602413290001>; Wed, 10 Feb 2021 09:08:57 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 17:08:52 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 17:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xr8dzprd4CR5Itxj34qeb5N15Qpvxv9L40SJYfE4cLhxoNkeyadhtNpRs+gzGXIFa7U5WQP8XMZnCe5Va3B8mCPFdsgNdfC84m7JslkCHF8fJpOGeB3H58TcuJ52EOkAaLw6WOaKJI2vs9fhWdvufIQOgHBn6s+2zIpMJeMICVtnPGmtXgIB57+tmermmK0EFNhtIgMqUDrZHcVFJh0yQ96c+lo6HjgqgUusV+vB9wPTaqhKBV48kN1gfJND0wEC3wDsB+nIE/YxOOh2MaZIBlKkpgg+p25iDflGDWKmQmnV+1sjceMWQ67hHDGynN3kbqI1osB6aXVHPQEQL2rO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMVrPdzmnWdAICLX1m1OZnLF0fc/smwcqy7dNbQSc4g=;
 b=mH4G573WlaOAgIak9N67OwRA8XyuNZ8vJV10zJQnkVFzwaE9RJzq47b6GW+qCMVbGlKeXCdIIKdqwUBtIDd6XdY9Ij1vPkP3QXcObLqswEIuNYkIwlQbZbFf/4lpveUYqCr396GFbR6ktaazxIzLH+DlDHzTY/MaMqDDNun3nbeZeUMy104iCMpTa+wgJd0QFJiMx6YqCBeVDQRtsLCKchkPUARBDPEP/hwXeKG5GVJYEtZbW1AOonCD8LCrQyFNvIcH2qCDQmUrjgkRAPcrnEoACHuBYte6Z9JqG0hRbRvvoCo7Rlex5+07AiBRggIvi4KWENQhm9j+Ikqy8xHZ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4513.namprd12.prod.outlook.com (2603:10b6:5:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 17:08:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 17:08:50 +0000
Date:   Wed, 10 Feb 2021 13:08:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liranl@nvidia.com" <liranl@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "tzahio@nvidia.com" <tzahio@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "yarong@nvidia.com" <yarong@nvidia.com>,
        "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "gmataev@nvidia.com" <gmataev@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/9] Introduce vfio-pci-core subsystem
Message-ID: <20210210170847.GE4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <MWHPR11MB18867A429497117960344A798C8D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210210133452.GW4247@nvidia.com>
 <20210210093746.7736b25c@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210210093746.7736b25c@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:208:23d::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0003.namprd06.prod.outlook.com (2603:10b6:208:23d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 17:08:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9syt-0067GF-Ld; Wed, 10 Feb 2021 13:08:47 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612976937; bh=CMVrPdzmnWdAICLX1m1OZnLF0fc/smwcqy7dNbQSc4g=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=lDTUcR9VrR6AmFJFV5VFrJanPF0d4rOQ/xQXO/L+5ErPT9GdebGC5nZ1voIx2EaLp
         AeAbOHHqguD8NwEaluEyHpHvOnTe5O6GvyweSLY9aeTQKoO8nXK/jO2I6i1dJjznwj
         PaqBY4xCaq6E9DaIWbbtBrG0Thj1oJ2R2PNDPOsyG/4Zi69pZ8Ar4kl3RElj0Bp13I
         wA9JRfEur7PzP5HSm9HHxaOIdh8fUglPlb1UY2BvvV13zvT4Id7/CMklssbA9etqRi
         lta/TanSlRzQQpWlSw5VI+fg+xf/pso/+qZ0PI+4Q7PdIqF7qI2sp/z1uhDauZhQ4V
         IFAUFmEl5Amtg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 09:37:46AM -0700, Alex Williamson wrote:

> > >  register a migration region and intercept guest writes to specific
> > > registers. [PATCH 4/9] demonstrates the former but not the latter
> > > (which is allowed in v1).  
> > 
> > And this is why, the ROI to wrapper every vfio op in a PCI op just to
> > keep vfio_pci_device completely private is poor :(
> 
> Says someone who doesn't need to maintain the core, fixing bugs and
> adding features, while not breaking vendor driver touching private data
> in unexpected ways ;)

Said as someone that maintains a driver subsystem 25x larger than VFIO
that is really experienced in "crazy things drivers do". :)

Private/public is rarely at the top of my worries, and I'm confident
to say this is the general kernel philosophy. Again, look anywhere, we
rarely have private data split out of major structs like struct
device, struct netdev, struct pci_device, etc. This data has to be
public because we are using C and we expect inline functions,
container_of() and so on to work. It is rarely done with hidden
structs.

If we can get private data in some places it is a nice win, but not
worth making a mess to achieve. eg I would not give up the normal
container_of pattern just to obscure some struct, the overall ROI is
bad.

Drivers always do unexpected and crazy things, I wouldn't get fixated
on touching private data as the worst sin a driver can do :(

So, no, I don't agree that exposing a struct vfio_pci_device is the
end of the world - it is normal in the kernel to do this kind of
thing, and yes drivers can do crazy things with that if crazy slips
past the review process.

Honestly I expect people to test their drivers and fix things if a
core change broke them. It happens, QA finds it, it gets fixed, normal
stuff for Linux, IMHO.

> > > Then what exact extension is talked here by creating another subsystem
> > > module? or are we talking about some general library which can be
> > > shared by underlying mdev device drivers to reduce duplicated
> > > emulation code?  
> > 
> > IMHO it is more a design philosophy that the end driver should
> > implement the vfio_device_ops directly vs having a stack of ops
> > structs.

> Like Kevin though, I don't really understand the hand-wave
> application to mdev.  Sure, vfio-mdev could be collapsed now that
> we've rejected that there could be other drivers binding to mdev
> devices,

Again, I think the point Max was trying to make is only that vfio_mdev
can follow the same design as proposed here and replace the
mdev_parent_ops with the vfio_device_ops.

Jason
