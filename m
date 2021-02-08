Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9B4313CFC
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhBHSQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:16:20 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17086 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhBHSOB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:14:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60217f3d0000>; Mon, 08 Feb 2021 10:13:17 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 18:13:16 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 8 Feb 2021 18:13:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMfMoYHcg08geZsQq02lK3cz2dRWpui0cNltFhJb8rCyST3L/dVJfP5ZHhYRt9/rtH+YgohaPKMeX9xNqueJkiRWUpmiO3TcjihuoA3hxrCDJnmAsXr3J5QA414ld14Ed/jl3UmLvK0acJaHhtsAu55/d0kKhKYRbBumB/Aat47JAx7vcSfJlenjNmXcBVaeced50koReK3bn94nC5/mF6DVlthZc4ZNnjm98IfvlZHeARJHVCNG+Wse2qBHjs4YuNivHfdnOqfF6mpe+V8/qHW+1JU0Mma/d1fTtroEYyAlBjZi9AAaigp6S9f8hSTVmalRqXP9YEjw+aQ8wDXaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9cPp2oIQq6GcYFP14tN532iDEEYJNPobmrQZRL71m4=;
 b=CexI+7wQBkPFPVAzx7aIFilwZrtRHGwwPAGhXoJEHLTcU541SDVhByGgOfaExJHvLL3wYCsj8uk/gkpjK9UQwZboQEfrofnPQMETd8H0acFSEuJFilTTZLIZzfNa+Fdm1anPcYcEYz6KAOiaXUXGUN2sRzTqos2i4+hjGmlvqp4fh3Vqj7vM4N84GBDALUfH6+HPWqbGr6GqXYsTOrxKA3Z8yVQy7gSJI1gb2sI9kqtHAYGJ5jk7EU9zDCVk8iChyrKFtleLx30VE3W2cIyQsG2gHPowW++Qu6hgXcrZ8t4smFBKVt6bmzZSRYOCWUFn0IgPqvxoMGAE3Ue79dQTAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2938.namprd12.prod.outlook.com (2603:10b6:5:18a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 18:13:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 18:13:15 +0000
Date:   Mon, 8 Feb 2021 14:13:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210208181313.GH4247@nvidia.com>
References: <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <34be24e6-7f62-9908-c56d-9e469c3b6965@nvidia.com>
 <83ef0164-6291-c3d1-0ce5-2c9d6c97469e@ozlabs.ru>
 <20210204125123.GI4247@nvidia.com>
 <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d69a7f3c-f552-cd25-4e15-3e894f4eb15a@ozlabs.ru>
X-ClientProxiedBy: BL1PR13CA0322.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0322.namprd13.prod.outlook.com (2603:10b6:208:2c1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Mon, 8 Feb 2021 18:13:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9B29-0051kF-OY; Mon, 08 Feb 2021 14:13:13 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612807997; bh=u9cPp2oIQq6GcYFP14tN532iDEEYJNPobmrQZRL71m4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=jHz/6g+LC2Yp1n27lfPuzPNZRWv7851RFe/uwp3ccBGl4UgWZg++1l7nHYygvT/kG
         ont1xu/9Nl7N5ps5rZSXxNdZbEZAvO97ljozJjVUDv/psKhrCc2eiSqHpBmbqceLNR
         xE7ylSS3Czh8v7DDGfgwnSPX+Q2hnHMZZG5ubIeWy7pjktid3J2KuKv49Nh3JeQjZh
         zfk8I5/F1Mp3aRFmSGj5eUqz1Z19fvObdSW+8HafffIKY4Z0o49T22CJZn0aZ6dkug
         U2gsa2DvL0sonddJo+bNhvKqjGL1ZgNtjyj/zdXuKK3Glkqat+C/3geMfZoAyOf49O
         nq3F86dDEO8Cw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 11:42:11AM +1100, Alexey Kardashevskiy wrote:
> > A real nvswitch function?
> 
> What do you mean by this exactly? The cpu side of nvlink is "emulated pci
> devices", the gpu side is not in pci space at all, the nvidia driver manages
> it via the gpu's mmio or/and cfg space.

Some versions of the nvswitch chip have a PCI-E link too, that is what
I though this was all about when I first saw it.

So, it is really a special set of functions for NVIDIA GPU device
assignment only applicable to P9 systems, much like IGD is for Intel
on x86.

Jason
