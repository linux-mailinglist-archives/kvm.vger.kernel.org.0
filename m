Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B235D1BA651
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgD0O0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:26:05 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:29699
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbgD0O0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:26:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jyzGEwIYnkHquW8HRRU74yDUaR+aiKdRCbIK4vpoRBewvdWjPUnBb8YEYq1Sx2JA7hZphyWTB3KmULgIpDfWfd/zxsjwyE7h3pBquZYRid6XF8CsHEGLfXmqOMXS2NZZ8MQx8MS4SGJ5rGSZKie48WI+ODK1/G1yQOrXXD8R52kvx2B4G10k/okUxIM3wJ/78xzHDc7t/GwUnruaixKm31k9TWfbhernQ3DO5It/6lWXzUqB/+Eza7WMVCtk1wv4bHPLOaxwZ3xzSv36p8Wxgdbb5xnYCci5oIVUvuWDHq8qAxP+AmR28gN4WK6lyWqhSyUtm7msYal7GOry3Kh7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73pxRLEAccaMA1EYoTl6Dgo3FZtgkSsRnyNyaKa83pM=;
 b=R9MuJv/hUlTZ37OYh3htsM2DDE6Ll0JOZ81ljbtunfsOVt9j2P2/2akCt9c58671I6KH0A1Cidh2RPWCr3f2/wedpbeJy6iK3HacuTMBUvc3lgsLXpz3cxIQ0ALajAj8OEiuqKHbox1kHypv524PTtLmrw/m1NuMy/CLqt4PH1xbzGxZulWCSWz6wrmy9NeKZ94vD0X+qjVWSoimrOdKD5bARXJceVCNnXx/R2Gf9I36M7Of3UkkJzxOqQlkPBJwMDfD0Kv4kLCFgTaM1taF6pn5mPmg1R1xTfKEvDo6HuSyIBQmMUn0+feLMVYg71ZLLRnlzHIZUdsIefqQ09pSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73pxRLEAccaMA1EYoTl6Dgo3FZtgkSsRnyNyaKa83pM=;
 b=C2I3T7Cjax3NJfJF/B95zrYYv+/XiAlIoU1JrkVYicHKdx26s7CjP8JOzhgJJIQbXWk2Of2ETFGD8LyXVrlcQIPwIfl7zRi8ZReFIQHDiDjdyXhTTdWmC0ar6bY+MnGr7JRHxiq+2ovXWJCACkMWHHlP8C/pCjpcmw4ItpQ9AE0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5183.eurprd05.prod.outlook.com (2603:10a6:803:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 14:25:58 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 14:25:58 +0000
Date:   Mon, 27 Apr 2020 11:25:53 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427142553.GH13640@mellanox.com>
References: <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <20200427081841.18c4a994@x1.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427081841.18c4a994@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:207:3c::20) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR02CA0007.namprd02.prod.outlook.com (2603:10b6:207:3c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 14:25:58 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jT4hl-00083h-TE; Mon, 27 Apr 2020 11:25:53 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bca20ff2-8517-4dc4-56fb-08d7eab6e754
X-MS-TrafficTypeDiagnostic: VI1PR05MB5183:|VI1PR05MB5183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5183A2BD8069F6322A4EC67ECFAF0@VI1PR05MB5183.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(52116002)(26005)(6916009)(186003)(5660300002)(66946007)(2616005)(66556008)(54906003)(316002)(66476007)(4326008)(478600001)(9786002)(9746002)(1076003)(86362001)(33656002)(36756003)(2906002)(8936002)(8676002)(81156014)(7416002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05X4l1p6VZ+cBXhuIafJ0TZRnctsj5iI57eQJuYRJ0vltuBD+ZzYJ50ZZGSNykqyJ5iSwpGaZIHh+8cNJQHUKwmu6Ac6HQfQ147VdrO4GluBgifcmLF2q0t575J4BqmGZ6GeeNSVYfYhtG67py0/CFv3v2HNyCftS1tzCATaVawdXBroaFSS4HOCepZ+aHP2i3+EkOLBS7Oi4KQ1NUPF0KpwczrDkGYJRLq2vPf7/rUC6L0oOBxwWk5+th0Sy6gvw+evreoAVhN5Rwj7Z8MQzUkQkEaYBR+4m/OjWVFFauSKpWWaEFxBplTC5qdHYF+G/XxjdkSSWFQ5i9JfyN7x2IItXK+6YyRemxNpHnqt9/PAs+f5k+zVm1auLuRv0UWR4du36XddODxfxISpqwHxycN5ses36S5BKiRT/O0hhc0gX1wfgWeCrxS/7XqgqkfBiLppAJCR4aANAUFAZLLCyIAqpeTTBUnO0xV6rkN0wy0UFwuclC/1khmcedwfa7ng
X-MS-Exchange-AntiSpam-MessageData: oJghRb+9wZU/4jL4TQYgagw1z6XiBgdb7+t/00wGxOYFgx5pURmaHIGKnh0/uOCmN3Pgq7/DOhe0DLfsT2VF378+4KQoCKhKZPBUeA8LHN8f7qpsb1oDt5P8N5zP/Um4dwhp5GNitrqqYEzLhP+TYE6qbO4rLy3miBsT7qCRzC9hsIfXn2dIxyeV4hHFReAII/Q/m36YR2T5NuKsk/1Zfk5JBNqwJKX5wcVfueYtLZxeDuaeKsvjIVz/BbwqxmcApI0IHKzpbUD1uazTJSammLZLgJUFtPutlVIlDUbru8a2pkIl40El/KNOKB3hE6bZo0UhfSi26Ym/UuuXaBtAVXLObL01iVhQSExzlTmckpDnLeiqylsQiodtY0+KQ8hMWxOo29q6NIcu1TWALN+7rxL/DwCVsSz5EUItTwJYwi4HKvF3EuduZD/K1VNq8afx5q8vGZBdBzsC03lz1BybqfrYUTy+zKAvoxBgiQX1n4tE7wI44X6nwkvoYK9ck9Y4IHZpKi7BqmqOkNnigATactJbsauCApluBSzaG1bsY5yb8dLPzKgJRmmsUV/e9fufRE1JtmNJchqqNzKSO8cGgeV5reHybZCqgwA2nF7ptkO9vWkiQffcoGFZ3rHzIMHas0cONkhgUdkXMThkBXl5qUAcu89fo3U/v6jduU4kHMCzdKfHI9obhkLEjlBLDBKR54tb33Y17txerK9sW6cbYUI7YeeW5gLeITIG2Fo15ff1sNffQsmkneuCB7EKisJ51zNHbrkh5iAYR3/2GrIXVFiKI219TMhb8xhIFmGjaOA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca20ff2-8517-4dc4-56fb-08d7eab6e754
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 14:25:58.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlRu1EcECVW2HvZPh4axAmcAxysrYphwx8KsJsJkjShDbj1BEgrvAITYYAv9+9gkAER0MjVJhkmdTB+LWYdS/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5183
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 08:18:41AM -0600, Alex Williamson wrote:
> On Mon, 27 Apr 2020 10:22:18 -0300
> Jason Gunthorpe <jgg@mellanox.com> wrote:
> 
> > On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
> > 
> > > > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > > > emulation.  
> > > 
> > > Not sure what you're referring to, I see about 30 lines of code in
> > > vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> > > config space and maybe a couple hundred lines of code in total handling
> > > config space emulation.  Thanks,  
> > 
> > Look around vidxd_do_command()
> > 
> > If I understand this flow properly..
> 
> I've only glanced at it, but that's called in response to a write to
> MMIO space on the device, so it's implementing a device specific
> register.

It is doing emulation of the secure BAR. The entire 1000 lines of
vidxd_* functions appear to be focused on this task.

> Are you asking that PCI config space be done in userspace
> or any sort of device emulation?  

I'm concerned about doing full emulation of registers on a MMIO BAR
that trigger complex actions in response to MMIO read/write.

Simple masking and simple config space stuff doesn't seem so
problematic.

> The assumption with mdev is that we need emulation in the host
> kernel because we need a trusted entity to mediate device access and
> interact with privileged portion of the device control.  Thanks,

Sure, but there are all kinds of different levels to this - mdev
should not be some open ended device emulation framework, IMHO.

ie other devices need only a small amount of kernel side help and
don't need complex MMIO BAR emulation.

Would you be happy if someone proposed an e1000 NIC emulator using
mdev? Why not move every part of qemu's PCI device emulation into the
kernel?

Jason
