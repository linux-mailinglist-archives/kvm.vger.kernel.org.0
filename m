Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B7232A6D4
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575867AbhCBPxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:32 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6323 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbhCBAvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:51:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603d8bee0000>; Mon, 01 Mar 2021 16:50:54 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 00:50:49 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 2 Mar 2021 00:50:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiyBOLOBfKc1tHcI8cZixv/dTIRDlOdwjbwnRls/pXd1lxK3cjBxv2Yl6sPz6fsX0+RHT9FaNs1bSlSNW4q+m0S2dgo5jTLY24C1KOln9QWVIk2A4U8/4LpCcG7zgYsdrV7ciJ4d/X44TO4m+DyCeCBxJwlj/5+yvYlL8XMmw+zJxWCdnWvLrwglEzWtojZYdMGu+U8sOI6eEfzYlhfyDdkfVo6WMzxe4zLo5hBKgHYs7puke9zimi1GoDdfk4nY3yomTRhX5D+RY5qS8TBr3el+0fCUrTGVEGTbHx48qdeTULWqd1fS9kdUoSci2I0FHmHwBpilgW5WGBFXq3ZQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sucyUN9nqzV4VNQbY8vYSj8n0i41rfSbF+hOFTFMJAo=;
 b=D5vF2m0ASv/evq38IBr8fD4PhLmjwG1sPHDTCQjIsqwRc/KPMpFiBEstmKcE2/ZaRwwP7cthsLvV+SJidzb0bcZGQS2W7D0I2SDizOm1RCCjmpKXi1sPYL+b+zhPECRVgHJtLIISiwE8TO+mxH2nOstqQXMfK8mUHxWxrepZRxjW6XeNBC18zqEs885JsEhf56wfBvj41ueqc6iql0EWNtsKE7ww7j7uzRjrMfwSwnuzfyuAwpqqhwvQQYc/vhMfDZFOx9gKRL32bFPq0gZlOld73CYSKz/czKY9BRvocXo7U2vh+VrhhJWtknS22KyrpZptO8JOpQMBjp+1ghg+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB3528.namprd12.prod.outlook.com (2603:10b6:a03:138::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 00:50:48 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 00:50:48 +0000
Date:   Mon, 1 Mar 2021 20:50:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration
 and helper functions
Message-ID: <20210302005046.GD4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <b41828e1-ab67-856b-f2c0-6215106ba813@intel.com>
 <20210302002922.GC4247@nvidia.com>
 <3dd57aa0-3f64-d8cd-8f61-d91d7b1a1bdd@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3dd57aa0-3f64-d8cd-8f61-d91d7b1a1bdd@intel.com>
X-ClientProxiedBy: MN2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::16) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0003.namprd15.prod.outlook.com (2603:10b6:208:1b4::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23 via Frontend Transport; Tue, 2 Mar 2021 00:50:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lGtFO-003O7A-6d; Mon, 01 Mar 2021 20:50:46 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614646254; bh=sucyUN9nqzV4VNQbY8vYSj8n0i41rfSbF+hOFTFMJAo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=pQSrD7KlQU5IsU1bQ8Pa/7ANhiRiZttrdYqXCxFCHDM/ncFjXq182fFGjHrLn9OIZ
         wMijha1qzqZtf0GJS+WIZoEKWLQ2QuAVjLKlDljRiWkiTOnD8puzWwRN9lwLIaOm8i
         JT0IzVhbUMP4D0L+BiDnCyKNNk7otgdA8DkTbfen4Rmqhm6Lz1nhRBAsQ/eJf6mSlB
         ALjStNjtniuN9fKAC41np23YVykg4PvXXW37ew28s7zEDiXAwc0x8bglaMkmZYsXLW
         S3U+7ed1FWDlBHCgobWu+UDCTKNcUN8H7Ku/f9NYPl3UozSCTAlDjzT6IFbYmu4N3L
         Gs/nQnHun35KQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 05:48:00PM -0700, Dave Jiang wrote:
> 
> On 3/1/2021 5:29 PM, Jason Gunthorpe wrote:
> > On Mon, Mar 01, 2021 at 05:23:47PM -0700, Dave Jiang wrote:
> > > So after looking at the code in vfio_pci_intrs.c, I agree that the set_irqs
> > > code between VFIO_PCI and this driver can be made in common. Given that Alex
> > > doesn't want a vfio_pci device embedded in the driver,
> > idxd isn't a vfio_pci so it would be improper to do something like
> > that here anyhow.
> > 
> > > I think we'll need some sort of generic VFIO device that can be used
> > > from the vfio_pci side and vfio_mdev side to pass down in order to
> > > have common support library functions.
> > Why do you need more layers?
> > 
> > Just make some helper functions to manage this and build them into
> > their own struct and function family. All this needs is some callback
> > to for the end driver to hook in the raw device programming and some
> > entry points to direct the emulation access to the module.
> > 
> > It should be fully self contained and completely unrelated to vfio_pci
> > 
> Maybe I'm looking at this wrong. I see a some code in vfio_pci_intrs.c that
> we can reuse with some changes here and there. But, I think see where you
> are getting at with just common functions for mdev side. Let me create it
> just for IMS emulation and then we can go from there trying to figure if
> that's the right path to go down or if we need to share code with vfio_pci.

If it really is very common it could all be consolidated in a
vfio_utils.c kind of thing that all the places can use.

There is nothing wrong with splitting pieces of vfio_pci out.

Jason
