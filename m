Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2267023D3D8
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgHEWP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 18:15:59 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:40000
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbgHEWP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 18:15:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaPY/PnQzOoRzVuTS2rqOGX4/6ebk3KXupHL76c2xZUpLR2qpyX2Tz4FLoDAzLGDZ2cpT2OB7844Hont6MxL7MOU1KY40jmjzS8yH2Tpt8OTJYUcf3feCs5aPr2jBDyKGxiwxjyQCDtax81LI2pScm/cUUsnGHM6qaJ+uWWXQK5e5qvl5tIlMnl04j7OqnnBgPGnXXF5qQyr9dfWanomNtfZSz0s+hL5FmDRpsMehk97c5nwW7CxlNWRKktav5tfkXg3R4G4XnpngkWP+Scm+haP3taRNX4uIVyJdmflafhkbfbahwo5ht4qiQZ3dxVnnALU04YiRBrIaWbeMjlc7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0zQAsHh4P9uE39bNW7Gp0/pVtPaO6imJF9b6LyPVGE=;
 b=oBgJFogJax9lzlqI4w4BBrfyJHdDousUwk1a1moPTzLtdpVat8PU/y5ZNdq+l9WWwRW12SDCMzQgGfxWXldmzGd57PHJni7yeNcHsiC0sB62TU6RUMhQOzhw/lvYe9MPFPeX0nJ0gcZ/f/mmEZkyg7pa48v9za/TKTkzHRlOiV4c0Iq5b+wI17kVTIpSIUltDKGGyp//1qI39i8px2j6q3WNW2dTw9pfkYafrz2DDRYHUPpwb2woE0YHc7jN1EGmQNoMimn+lmceNVB8O7J6vsES6LZdVBx8OGpV0feZV8+9vL2ciU8bKo8VRdDX5iv6wMujubsf0jaWPoKn1pzRHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0zQAsHh4P9uE39bNW7Gp0/pVtPaO6imJF9b6LyPVGE=;
 b=DM9AtO05X2bgnIocIXt9DOljakGQgFmqIMrxHJvuldGCUXN3amisTmpSXItJVOOc1KDZY0Om7HK+ay0LiAT/ulph5Ai0m2P5WFbtjbFQQ3caRYSuwguv56RjiHPC3QNXrok9m2TJ+ktk0UjTrUUTGfZjCGG6hcinPamKVauPTD0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0501MB2752.eurprd05.prod.outlook.com (2603:10a6:800:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Wed, 5 Aug
 2020 22:15:53 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a%4]) with mapi id 15.20.3261.016; Wed, 5 Aug 2020
 22:15:53 +0000
Date:   Wed, 5 Aug 2020 19:15:48 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200805221548.GK19097@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
 <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a1eb5ccc724790b5404a642583919d@intel.com>
X-ClientProxiedBy: MN2PR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:208:19b::26) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR19CA0049.namprd19.prod.outlook.com (2603:10b6:208:19b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18 via Frontend Transport; Wed, 5 Aug 2020 22:15:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1k3RhM-003y3S-5X; Wed, 05 Aug 2020 19:15:48 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92c67b6d-392b-4dbc-cb85-08d8398d1da5
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2752:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2752FEF03BF2ABEAD3727939CF4B0@VI1PR0501MB2752.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4QPhSxaPlC7QLX+WRi959s8pnbgAjANXpABwgAH64KQ2dRaJu+Oft3tbsa8pxu0f8hbmRKt6YH576TlGvxYEOuVlQuzYfZYjbFvd2NFQMHbyoQSR07FyCgoKI522GlV5vQk8pFld+C1nNem+QJkt3GzUYmFFdYkN7IB8t8vO6cLgxytLcmNe8uton3vaLNJX86yN94RT2ERQiQybnood/OdcVYT/tVfB5+Szi9M4ocL+cpk1SNIFit1hxMJR06Y3whjzNh7Ktu0qSpXFL/Y85lcAVFsVy9yU05vRKqOsboqVKW2pyu4X2ICVXWvOERRPyAWZ+QdBudvo8sE5GI5Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(26005)(2616005)(66476007)(4744005)(186003)(66946007)(426003)(4326008)(66556008)(5660300002)(36756003)(6916009)(478600001)(8936002)(7406005)(86362001)(9786002)(1076003)(54906003)(9746002)(7416002)(83380400001)(8676002)(316002)(2906002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IUUGv9G2VLsYUWdAKbt0940wg6pPGgY+qqQQegOeJn2y3zaGpWS+kNM+twd/KVAWOvRjRu6xbFE4Uua6H81eFAPuQJ44wqguwbu3foW9gpmhdYvYgE1vee4R6zznQv3brsLIX1SauLdl0JsTkMagLuPiIL3xdbLhYzGHKVXj5RBDGfhZaNXdGNX49aIjmhczSqyJggVv5Um5z5e7OuKXkkE5i9wTcEXyk7tsc7piFEY2HMoEBPGOKp7jQrVjg4FkG+k0PoFAAxv2dV81WEEpG90LYJkTSz0Xhj6u5CWUhwUvBBdGWDqW1WI1NCvuwfKrDb1dvJoiLe1x6k80KNhqWebt6033LuaOxYze/1R72JassDTk7kdig3CWbm1GFx1DowM8jiaPlmE46GN2PO9gkoaf2J/A2Xmz/oCDQ9JLiBPt6/AfgdQbI92/xUSrSbtZoP9HNUXrEfvpu65tlajNtQC//iYt/VMuSHUUUBblDPeB+nYBQM3UbGqCF7PRct8WjGi1M6BiuKn2+CQtkfvUZirPR+8/i/qBzwB1oitUsn5ZXpevpo+iMOI/owhL9h8R53syYAQ+tdGX/FFR/UZ69yfhrbUBwkdh0Mzhz/YTc9FFvpgt+E/hzwoBHG7+vNKYATlAgj8kXaSR5brbLDk2Og==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c67b6d-392b-4dbc-cb85-08d8398d1da5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2020 22:15:53.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJ82ogLvm5j5p/dHxWWNfjjFmXpUuQLpl5AMrlFgt2BN9+3UmAeA1/sPVmVoqldPQHNZA2cu0GRvQK7TlVHeng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2752
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 07:18:39PM +0000, Dey, Megha wrote:

> Hence we will only have one create_dev_msi_domain which can be
> called by any device driver that wants to use the dev-msi IRQ domain
> to alloc/free IRQs. It would be the responsibility of the device
> driver to provide the correct device and update the dev->msi_domain.

I'm not sure that sounds like a good idea, why should a device driver
touch dev->msi_domain?

There was a certain appeal to the api I suggested by having everything
related to setting up the new IRQs being in the core code.

Jason
