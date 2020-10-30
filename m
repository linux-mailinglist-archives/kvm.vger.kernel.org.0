Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AE02A1139
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 23:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJ3Wyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 18:54:55 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10758 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgJ3Wyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 18:54:55 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c99c30000>; Fri, 30 Oct 2020 15:54:59 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 22:54:49 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 22:54:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P07rXYSFLv/YilQQPk/sqJHQd6PLcgn1M71/WNIBdcNbj8mCoN0YCCA/FMTxSMM/d9mSq5l93oONrQ8EXYHoHLYKr3o2ZrcTMSb2fGKLbjEPJ9blcxnzBKWfCPzfnTNoRqDsjdNkaF3x31HSjspFIfjdiaGUgyUPjENCr+OICHtp0delS6EozXwq4aikAipPtWtA42D1PKw1nYUGO4iFNRn7zNQECFib9812TAPkZN0k+c1s1P9xh9GccOzgycfyjV6LzoBzIzWIhXrdzPnBQHNx8B3hpQ0iogxASx7721K4MCmeDwESetGHt0HhFkF+2okv8XDho3hl9GQ9pC1DWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGZEkwaxogpzjW0ojadFTDq0iq4f0cxfyeJXrCJYIKU=;
 b=aTS6Yxk3wzDtA8ru2npT+yR09lVrqv7ok23EMl6giHesiK3uL8Y54haNv4QsdDnPtnWNOvO1IO7pl8JcP2YAsdR/8kUoDrDVN1U7yspSOVb5c14Wv+xfgd4uWgHCw+vKCWujPTT6IGAJBPawMUqr9g/wAwX2FvMVaPUKfdWd+Xg7aKj8udpd8wJugP9sa1DLH8aX4iWrwYn7Zi9UHmAE01z8h+eXBqkNZXYHRl0dSuTbaI0ASYZq6CLNWmtL3IVyqcrbiMOkGfFQPj5gxT3m3b5x+9J7ms+IU/MJS9DHSFj9IKtSNJepUkmSGOCVSAiidpI+NCEBDsFgI/GiXcqEaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2485.namprd12.prod.outlook.com (2603:10b6:4:bb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 30 Oct
 2020 22:54:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 22:54:48 +0000
Date:   Fri, 30 Oct 2020 19:54:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <tglx@linutronix.de>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@intel.com>, <yi.l.liu@intel.com>,
        <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201030225446.GO2620339@nvidia.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03>
 <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201030204307.GA683@otc-nc-03>
X-ClientProxiedBy: MN2PR20CA0052.namprd20.prod.outlook.com
 (2603:10b6:208:235::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0052.namprd20.prod.outlook.com (2603:10b6:208:235::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 22:54:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kYdIE-00E4HD-TA; Fri, 30 Oct 2020 19:54:46 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604098499; bh=qGZEkwaxogpzjW0ojadFTDq0iq4f0cxfyeJXrCJYIKU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=QHZfAZx5fCexDjCAutspu+dlHQgsKPnmGW17P2F+UaUyxDDRRHvgZ3u+Nd6pHcGEc
         ktPmAL0VjFhqdnbfWMun1jy6rJ2NKL9Mqt85BMmSCSuUS1XF3djQnW+JA1l5EIibnJ
         j9jdsYzEbH28O/FmD0p/7zvsA96heNmU+WSS5IQ0u1bi+BtUG8+/A5ompAc/PTCrrW
         wxyk57DNFXDzmkKCjcIUcUbt3unVultNiePZrOAMmrPQrRPuKCd+NDfd71nBG72wnk
         w7E1GSqYpGh7xRe5JuT9u4+YrwuZDo1zjGwJPxqjLya5FvH1moxv0UZctBBiFz5imm
         /82XRbUsrCsmw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 01:43:07PM -0700, Raj, Ashok wrote:
 
> So drawing that parallel, do you expect all drivers that call
> pci_register_driver() to be located in drivers/pci? Aren't they scattered
> all over the place ata,scsi, platform drivers and such?

The subsystem is the thing that calls
device_register. pci_register_driver() doesn't do that.

> As Alex pointed out, i915 and handful of s390 drivers that are mdev users
> are not in drivers/vfio. Are you sayint those drivers don't get reviewed? 

Past mistakes do not justify continuing to do it wrong.

ARM and PPC went through a huge multi year cleanup moving code out of
arch and into the proper drivers/ directories. We know this is the
correct way to work the development process.

> Your argument seems interesting even entertaining :-). But honestly i'm not finding it
> practical :-). So every caller of mmu_register_notifier() needs to be in
> mm? 

mmu notifiers are not a subsytem, they are core libary code.

You seem to completely not understand what a subsystem is. :(

> I know you aren't going to give up, but there is little we can do. I want
> the maintainers to make that call and I'm not add more noise to this.

Well, hopefully Vinod will insist on following kernel norms here.

Jason
