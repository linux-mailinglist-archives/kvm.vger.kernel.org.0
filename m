Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FEE23ED3C
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgHGMUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:20:05 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13193 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgHGMUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:20:03 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f2d46e50003>; Fri, 07 Aug 2020 05:19:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 07 Aug 2020 05:20:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 07 Aug 2020 05:20:02 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 7 Aug
 2020 12:19:58 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 7 Aug 2020 12:19:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPrkW53YUMLKOOWBR8QFZxmCT3PyvMzHZdQjXAxCuT+OxUyalQGY/5Il9Gm4ULZCj8IJ67IpRn9SagyGaS3qVSA3aXVUTVGN1AuyM+ZYeZi8HVxJuJeghK9dgrezQ9oYWK/DegEwVa671Azrpv/8QwNbb9kAH+9U1THTWuFBqs2l3hJPNycZvHRjZYrP2Aho9NK8+rRfvezHrfttqHG/vwyvWzi79Bl5NNp9lcRAtG3XpMfnC4PuICqRYCjpo1eXVyD6cJYvgK2gEHMD2bQ3NaMidHeAHA6CzfZIu/2WJ8LOKLMilCeNM1ws+RQk7Q0esLrP2JPg3WQu8Od7LXb22A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nPGeq/CB4zb5MsgRTO9HHv5loEEdmISFZjlsqVKXIU=;
 b=UC/P8ldrsHCyZbtRy2UB/UxiG6rscyDGHhDiKWBAToXdiHuc+oNIah/G+4saFAgvrWUAdWyM70uqvHIrS+7mbiIkGrGPwn1qkC2phwHsNOx6lLRW7R1QsrdWCXVc3f1NxFnoPIZBRkSI6VY6HL9ZiO7rxSpSJwEPlhgO8xQHBQ0gqrdOYCdCh9+YLklT8ME/Rk12PFLRgqFvXWYRZAvcT+DsTOnZrVz07sBD1gOSqMqzepc5IfUilijzMCP80zGVq/B1/cuWE1QCSwhkZiCHj1tcSPJtHVUTYn79PnREboqxUHrCQNFdfpc7aWk9T5Ts6MrMaoIRq8otm9pfBjcSfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 7 Aug
 2020 12:19:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 12:19:57 +0000
Date:   Fri, 7 Aug 2020 09:19:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200807121955.GS16789@nvidia.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200805192258.5ee7a05b@x1.home>
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0042.namprd20.prod.outlook.com (2603:10b6:208:235::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 12:19:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k41Ln-004gmL-8u; Fri, 07 Aug 2020 09:19:55 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af605af6-1cf6-4273-3ed5-08d83acc32ad
X-MS-TrafficTypeDiagnostic: DM6PR12MB4057:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4057027899426B9FA34A2354C2490@DM6PR12MB4057.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sT45pI/EJqwMs9Mo6bZvV6h+QRUVvyxudav8zLhJWxHdXgD5Puz5hxXTnCvr5NoYsCBTA3gWZcNcwdjg/lYmo2kSvCzZoW2I/zMOEy9DEcGmGh0cTlRvhFBqtRAcUo6jVkoT9xUx/FdmwZArNsPfGfDvU6Hlb5U/Fag/ELh2A5uZnwfSNCwQ76/HlnZg4KZrbxZaoZykuoHXWyDax78sVd7qtv4JvkzxixV+ZXILaxb0OMdCksUc6MmOO5pV8EFyob3IFlhA474LYoxDlv0N6XLvrKd2d0axKfih4gZi93Kd3TNEVia3Rqt+dACR7FOYdk6CfL35aHOAsAK+2gyMHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(5660300002)(83380400001)(8676002)(4326008)(7406005)(9746002)(9786002)(7416002)(8936002)(426003)(26005)(478600001)(1076003)(186003)(316002)(2906002)(54906003)(6916009)(33656002)(66476007)(86362001)(2616005)(66556008)(36756003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HSkanueyqJR0VTKI4xknqDy8RBXTzzr2HM9WS12KUYpB7YZPbtp89UlRFxEBHOdRxrsZXe/cp+G7gRH5gS3U5Y4U1Oc6ZM/rl0+n/VC+e7HC8irsOsKOmJWgyhjKNz1rgJ5D24e8Vb99XjdRIyy9kFuKhGWZHaX5UXL7yKfFfalzidUMfqXRrACYOds2XJTEs7a+My8xLdTqLbZz6DS9cL3hhFo7ljmr/j4AOInr9NBOF/GINkS6STYgkzfKPSSpRx8a7ifRN0PbQ0FS0ID10RsvmeBw2D1fPWHuQfUQFMDCx6A0QT3zbm3Ailb6rvt/8wTezQqoUDdrSIbEsliVjGmi4+pZc1qN+eDXi3KVOzva2osuZLY5K7iG1nMhr2UJqtxnM2Kz2CmqA3KIu8rDJ4mVWp+yyyBgynY73w4XdojFrw0CBqHwyD8NvK0AO2G980DuctUu1jg1TtaJ3ow4ME3O7KoXkpmSJXTfzazqG5jIHjEnCRJdihxsh5SxsdwnGcmCzTOir+rintg974r7/xgHyiG7XvfzXGM4lb+2kKHRdzOiGfBHPz8yIUB3Y/AVPopY8RtT7ErMDXMdHsbAmO6WbA0XiPcmghmd5fYLr/X+bO1lL05GFXqrM1NGhLyhv6QtJ/lfHVwak37P/RRjTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: af605af6-1cf6-4273-3ed5-08d83acc32ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 12:19:57.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdDxPLIVMvJekn9xpXy9KxRXok4TRFeo45ViOc0ojwy2Vn7LXR0vlzz38BgiY3qb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1596802789; bh=9nPGeq/CB4zb5MsgRTO9HHv5loEEdmISFZjlsqVKXIU=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-LD-Processed:
         X-MS-Exchange-Transport-Forked:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Al/+sp1GjB/okQPNn3uj47BXS5mklUjTT9NxEzq5NjhoOP3iY0Cuptglk0X3w711E
         xdOtG62TOELtj1wpI81WqPKXbw5nOaKJnXrkCWF9pjRgarC8R1ixNyd5klsxp0RJYT
         NU6DwbLyJHJKJK1mV+CXaUb+3zqTW0GMdDf1MTGlWmSbt/D1i/GAClsQ7mCH/S6x5I
         oI3Tvmke5LX+/FXMEloGQeBvMHkAX1N48CT/qZf0C1ibYlzxygY5i+9ILz7J3Ny32O
         gYoGqrJPXDSd9TwVJIJkWajV6FPpNXBi1ajgUPc9Tw9Ti/6uX4Nx1oWPfjFW77KRmx
         XHY8poriRFaeg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 07:22:58PM -0600, Alex Williamson wrote:

> If you see this as an abuse of the framework, then let's identify those
> specific issues and come up with a better approach.  As we've discussed
> before, things like basic PCI config space emulation are acceptable
> overhead and low risk (imo) and some degree of register emulation is
> well within the territory of an mdev driver.  

What troubles me is that idxd already has a direct userspace interface
to its HW, and does userspace DMA. The purpose of this mdev is to
provide a second direct userspace interface that is a little different
and trivially plugs into the virtualization stack.

I don't think VFIO should be the only entry point to
virtualization. If we say the universe of devices doing user space DMA
must also implement a VFIO mdev to plug into virtualization then it
will be alot of mdevs.

I would prefer to see that the existing userspace interface have the
extra needed bits for virtualization (eg by having appropriate
internal kernel APIs to make this easy) and all the emulation to build
the synthetic PCI device be done in userspace.

Not only is it better for security, it keeps things to one device
driver per device..

Jason
