Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82C730F377
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 13:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbhBDMwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 07:52:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11114 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbhBDMwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 07:52:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601bedcf0000>; Thu, 04 Feb 2021 04:51:27 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 4 Feb
 2021 12:51:27 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 4 Feb 2021 12:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeeEDNSrI8YV2nB9Y5a1FiFrscM2Hx1iy3CJCZGOAYLLgLNS+9LFSlZ+ouJToigAUMLe6/AwDkVo3eg1N1RlKFroCLbLFB6OOJBiI521GCR4eet1+QbnDO8AvU03RqCauXSi3Hn61YXIltJLf6MhBjn1dnhrulh6px7urBNMriyvH89ptdsVLJf2udNNEGESCxq7Kv3WxqkNKln6Rq+2jX2BuNf0b5176GhLp/y6HVTi+VCiz16q5cpXUkdXR0Dmm0QbaUiimRpcmUfjSX3/TobaBlXOLxmMOtyc4nfRuPUAXlADDSWW8yT0H911Ql/Mpgr/owE6Ym6EsF7L+zufaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IVfWPx+gDezPU8wuhMlGznCTEXl0liDaimEVhEj51g=;
 b=kTIBLih1cHIZ8ZnZm+o8FDGOFFBtud2WNFf0590wxFxVb4YUS3GIUD8C5K+DHG1eJLEG4OZ8I0oWV8i6a2+L0uQ/EujcevLW+8A/QSvojQy0uBGA72cXToHXSKErgUPICILjDfNXhaNSx0vF12Yco92sLJIXUCnADKduq4+c6eAAa4qKFusOK4YdRwdGHaTmTX94p6UZIiMKKlQ41WNp0IAXsTaxPvz71EjmnbaCu4fWQ4nfH478YIceU8WHByH5gUgH13n9IqDoscL+a8qj7olNK579zBIbld564Ct8L960H9AW5fjk9/FwGzSujaZNn8E1F36nCl5FCufUXwHNvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3212.namprd12.prod.outlook.com (2603:10b6:5:186::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 12:51:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.033; Thu, 4 Feb 2021
 12:51:26 +0000
Date:   Thu, 4 Feb 2021 08:51:23 -0400
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
Message-ID: <20210204125123.GI4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <806c138e-685c-0955-7c15-93cb1d4fe0d9@ozlabs.ru>
 <34be24e6-7f62-9908-c56d-9e469c3b6965@nvidia.com>
 <83ef0164-6291-c3d1-0ce5-2c9d6c97469e@ozlabs.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <83ef0164-6291-c3d1-0ce5-2c9d6c97469e@ozlabs.ru>
X-ClientProxiedBy: MN2PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:c0::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0030.namprd05.prod.outlook.com (2603:10b6:208:c0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 12:51:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l7e6V-003Lmu-N3; Thu, 04 Feb 2021 08:51:23 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612443087; bh=+IVfWPx+gDezPU8wuhMlGznCTEXl0liDaimEVhEj51g=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=OUAtAYtL3TUaBLF1hYq+RtjUfzQnB7BIxpOZfCqh6p8d2hTfnDi+McIXo1ksXNc/w
         gqEqMcjumC9YdE1/e/MQl5R3C8bY4aLYr59az8fvpLW8wCMFLsy5vjh4jV82cj1XSC
         OiSw7L0m9H0j0pyD1hT2BTFWJenEZHzCgg8tzqPzUWRyjwkHh8KW5Zx3RUeAjrZD5Q
         h7jJ6hEGmHP1ciD1qRnBa1l+2Af0Ta4DaAcjvxXVxklZsOxrnZUK8YM+Sr4dTacm/N
         oMgb1C/FDq2weKpQo9AD6qANPdzR63s7FJ4I1hH6mvG1BujdqruZ7tf4gQMcGYnPPy
         lNZ4/XAcBVOoQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 12:05:22PM +1100, Alexey Kardashevskiy wrote:

> It is system firmware (==bios) which puts stuff in the device tree. The
> stuff is:
> 1. emulated pci devices (custom pci bridges), one per nvlink, emulated by
> the firmware, the driver is "ibmnpu" and it is a part on the nvidia driver;
> these are basically config space proxies to the cpu's side of nvlink.
> 2. interconnect information - which of 6 gpus nvlinks connected to which
> nvlink on the cpu side, and memory ranges.

So what is this vfio_nvlink driver supposed to be bound to? 

The "emulated pci devices"?

A real GPU function?

A real nvswitch function?

Something else?

Jason
