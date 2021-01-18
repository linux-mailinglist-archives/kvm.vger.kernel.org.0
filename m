Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E222FA888
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405931AbhARSRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:17:32 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:29877 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436743AbhARSRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 13:17:18 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6005d07f0000>; Tue, 19 Jan 2021 02:16:31 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 18:16:31 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 18:16:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYkNdlkqylcuDAYklTDm7aBpJEaEvq6XDVC42ZbSBz0WyJkkLMR4nos3kW4xXHDvt59Wd8QPrb98gJcB+xMMboyUT447vI+KH7xbzZP07k/x2ydNQm4IGlN/kI/ZSS5vC1tlLhSXBgzjL3ivJEiA5NdKCuuyDOoteuTI2xwPpnHeWjT7D4fNB6CKtjTJsP8XXXXxCRai05aRylcV07Ga5BFKdB6XCSq4nG3Cn6own9dTynklptAMldRWezausBbTgqPEE0uTgMjkP/ME+1Ix9uTdFlOUGlmfuqE+o2aQQwPCWYpwrThJIDTdTnXdgKd3erDw6ztvj/04NpvgsFplJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwRTfgXlifdCtlutUS4baPAqei432iOgP77dJnQrfX4=;
 b=FIml8hduyM1JCspw59UKtDNiw36A/XLEzh3n/a0bYbtDW6VTPiUikMr8CjMtExEalzVpWmF6ZRZbnoKzPO6KlTQg2RDUFi5hGqjDR4P2olrbj+OWqKtlPskI6Tt9OqvdWDtqAv8eNvPFPR9Oer1p/hAQglKn73mb8X85ZWnkwZGE5VQZoKi5D4ZncAa3a+oNRnncqG9DtO8bRD3EzZD0DMtRYrPQZXnaFyzTbgZf4Y/MtR5VjpUaNmPe2Q4zX4LZAzzjwWdB6OHdGiBVR0Krk/w2oYkCvkylSkohDrKEkdGJhMugU33muXwNFY7NzxPZX5NP2Co97M/Q3mwQHml3Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 18:16:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 18:16:28 +0000
Date:   Mon, 18 Jan 2021 14:16:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>, <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210118181626.GL4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
 <20210118143806.036c8dbc.cohuck@redhat.com>
 <20210118151020.GJ4147@nvidia.com>
 <20210118170009.058c8c52.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210118170009.058c8c52.cohuck@redhat.com>
X-ClientProxiedBy: MN2PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:208:160::47) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR13CA0034.namprd13.prod.outlook.com (2603:10b6:208:160::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Mon, 18 Jan 2021 18:16:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l1Z4k-0031Ls-TV; Mon, 18 Jan 2021 14:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610993791; bh=IwRTfgXlifdCtlutUS4baPAqei432iOgP77dJnQrfX4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=JaBL6lOwtUgJS8vV5R9nFhYvDT1OCbuesnTH/6+Z5uhgfNHFvKplTCDaaAg8gEAxu
         6m4TwL0EtlaCTPf32doaZoyABN9WdfJhhRKWufY2t2RkYQI5lAvMDB5xYQskeUsiFQ
         FUGdsU/r78Hp1s4JloyADB6wkvqsZw416PKTdhCGQZT+fUKKPGP9qTWGkC0BIWNhqy
         49quHmnOs/VNJGMmM6G+MbPT+Dpm1+8TIIA+lFsFvsfvim3sQSEOPCNHQU4/IcGo7E
         0VDTOMrUMA4T0FBiQA4ehyf4T7uHSJeaEc/lIqIuiYNetW4n7TNzM1nDor52AK12Q+
         TVGBfCsVLnPUQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 05:00:09PM +0100, Cornelia Huck wrote:

> > You can say that all the HW specific things are in the mlx5_vfio_pci
> > driver. It is an unusual driver because it must bind to both the PCI
> > VF with a pci_driver and to the mlx5_core PF using an
> > auxiliary_driver. This is needed for the object lifetimes to be
> > correct.
> 
> Hm... I might be confused about the usage of the term 'driver' here.
> IIUC, there are two drivers, one on the pci bus and one on the
> auxiliary bus. Is the 'driver' you're talking about here more the
> module you load (and not a driver in the driver core sense?)

Here "driver" would be the common term meaning the code that realizes
a subsytem for HW - so mlx5_vfio_pci is a VFIO driver because it
ultimately creates a /dev/vfio* through the vfio subsystem.

The same way we usually call something like mlx5_en an "ethernet
driver" not just a "pci driver"

> Yes, sure. But it also shows that mlx5_vfio_pci aka the device-specific
> code is rather small in comparison to the common vfio-pci code.
> Therefore my question whether it will gain more specific changes (that
> cannot be covered via the auxiliary driver.)

I'm not sure what you mean "via the auxiliary driver" - there is only
one mlx5_vfio_pci, and the non-RFC version with all the migration code
is fairly big.

The pci_driver contributes a 'struct pci_device *' and the
auxiliary_driver contributes a 'struct mlx5_core_dev *'. mlx5_vfio_pci
fuses them together into a VFIO device. Depending on the VFIO
callback, it may use an API from the pci_device or from the
mlx5_core_dev device, or both.

Jason
