Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE31CC13F
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgEIMV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 08:21:29 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:40515
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728326AbgEIMV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 May 2020 08:21:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkwfrgIO/jpuG7qTOq0T1o+6J0tjIzX9vKKPl7xWFefr4NMhyxhpLhD21RMVwW2oMzZktwNYuLqGK6Jcccfil1AoM4jGotE+r4tILXAoLhW3FReYKO2vvl031fj8iPUb1xFleazj3S07/rh193ndeIzOR7zaZ6H88xcx/zbafhhJMD+5F1hYF7AVQFHS0KgUVnew79lctwX4ciipSx6ayaQOSQQ5ngh2JoqVsHXRyJR1vM68UMKAutmoIJufw6LrK5z7cCxnBwlsUg8tgfA0WxaMRMOkU4mMe2f8nKwnWW7LT1JijJaeWAXjJWQCKfCO3TEcWxFZttv2W27g63gWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h7nCXjrl0Gr2jKC1KzAk5gAE4foOIZC/ZPgPjwkQsI=;
 b=jG55hj6rXuPoeV857R61aWxdaSrI5MwR0ffQFxiB3GLu2YW0d0reKe9/v4ZJx+mV3YcbnK/2WiCfyNmcpB970su+PXde4KTRYLOlVakmuGTvww2zQI6kQZtO5xyEmpQMdB7zZpTsEcyYmQMvRU6KXotfafy14j0GQyw7sV/q8bjx+B5Ka940UaK2+Emjf2VCOPuyOd5xZpBJB//ABu6JIsFXLYluoa+Nepa0iDhmuJ7qHJY1sSMWb09NKF9xJRv9mk2QgbCMpnKvRVLVrUwyBDCaPV+Phrh2xAPaxfh98fCKpAfgMAIDl9FG2wqfUieMdDavOpiMLQwBOwM7Odav5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h7nCXjrl0Gr2jKC1KzAk5gAE4foOIZC/ZPgPjwkQsI=;
 b=tRwcqL0m6od7l6Uge93pKuhRjwiyI0/B7w/eNP0Cjlf389QvVV65TG+1sQGW6qxddOSlVxuKg/9Jx6Fjpa+zSktccp63t4ZVvhvq1/wemEnpFPEM4RPWAxsz9d2FBJRPW/qWX8e5TfD/1gh2UOtFn2ioVo6GDEnfz7UlS8gFUCE=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5071.eurprd05.prod.outlook.com (2603:10a6:803:52::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Sat, 9 May
 2020 12:21:21 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 12:21:20 +0000
Date:   Sat, 9 May 2020 09:21:13 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200509122113.GP19158@mellanox.com>
References: <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03>
 <20200508231610.GO19158@mellanox.com>
 <20200509000909.GA79981@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509000909.GA79981@otc-nc-03>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:208:d4::42) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR04CA0029.namprd04.prod.outlook.com (2603:10b6:208:d4::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sat, 9 May 2020 12:21:19 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jXOTh-0007eZ-Ad; Sat, 09 May 2020 09:21:13 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab269f3c-0c00-4c18-94e7-08d7f4137abd
X-MS-TrafficTypeDiagnostic: VI1PR05MB5071:|VI1PR05MB5071:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50719C4BEA78B5EE3FD28421CFA30@VI1PR05MB5071.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /54wTlohEPoVrZWRnQFdIseAls0AlpkCcFTfT7w316/Qo5wDPMVS5Y43mNxDPpzWklWdv9fIm9pNYSaOkj5qYAuunzSwOtkmBbNYmyfT9PNiZHxYA4uEOOU6SygeaGiINE6VN8yTm24FrWra4dTk6WyuxVCON+fslQo0vsVRl7vdu7TM+jV5OD05frY66kP0UI6LxId7VuKj3Hin9Wz+ozkOh+sPD3vXW+V0RKITKt/3h/EqGub9nKgggeLDkwtQgf4pjpLncHzOGno8itzQlHX8YicJj6PS09zsRvTu5EpvHE8WdQrce8l3SM3gFafceG9bwU98TQAeORwAUatg4PP871S0SCaekbmc6KjRS5T/njf7waEZtqp2c2qzQpX9WIO1DsgZEHn8myyoLLoXvU8M0h21wRgnUpwG51KV/uinJTzSCPa+mVPNpRLMvxoedhdXM+KCvhi6L4F3ttzbXCDh9tjL72p1ifuuDmy/C6q59sSGwqhxvycYK+o3Q7v+2B5z7jgaMM8xOfFHiEzSS/GeOTnlKY5cLaOHdwcy/kRoYf8JVreFA6xHXt8M1MAk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(33430700001)(478600001)(316002)(186003)(6916009)(26005)(9786002)(5660300002)(9746002)(86362001)(52116002)(4326008)(2616005)(7416002)(2906002)(54906003)(8676002)(33656002)(36756003)(8936002)(66556008)(33440700001)(66476007)(66946007)(1076003)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HiqlSbBEHyerhLiI9HQ/nJ74piXXoOtAA7UyKaRYKbxFMHF5M1GBoRmc+iriiONqWFykuKZmXRJBbBzQG0o2K6CkusZ025YtUEBUU2yeHsQ0aL9/6iEM1tN+KRFkMchXrBaFI79jHJkZZAG+fLYoRcJXaes4i4xj7/fyZ5qYt8sYejE47P43cgkCvYVoqrMShPxFBsnwEZx0Djj58Z8FujUGtYxQa4q4N+OSxJT0BO+jmG6VGjLj5NeDnq6+T2Z6YqtGq0SQ2YhC/3sqt9qFP54hVnce/uYH8EaT0CE021jscN7SMUx3iiu3MpgCizHqvHBcd+pXex2+Lr9MUt3H6usMnMSOqvBI86Qkn7XWwu4fv0lAqm+x1ACLAfIPtIap5PZYJCo6w7V93HZClE8Bim/430VHk9cFrwlXg0B9gj4540VlXyF9NTzL8lhjleQ/FGxX+uqKDfYBi49ZYx8vNvhm7HJ09ORZUnAkMH4KBabdAA2hxDDlPZFrx1IpgazA
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab269f3c-0c00-4c18-94e7-08d7f4137abd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 12:21:20.2292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8b2sLAm7Rh4LonBwMhwRS6Kqc0HQv6NYfg3r/2N22ywtEYa15NjpgakM5yV9jj17eSayuLen1Ej7UvQLRAN4JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 05:09:09PM -0700, Raj, Ashok wrote:
> Hi Jason
> 
> On Fri, May 08, 2020 at 08:16:10PM -0300, Jason Gunthorpe wrote:
> > On Fri, May 08, 2020 at 01:47:10PM -0700, Raj, Ashok wrote:
> > 
> > > Even when uaccel was under development, one of the options
> > > was to use VFIO as the transport, goal was the same i.e to keep
> > > the user space have one interface. 
> > 
> > I feel a bit out of the loop here, uaccel isn't in today's kernel is
> > it? I've heard about it for a while, it sounds very similar to RDMA,
> > so I hope they took some of my advice...
> 
> I think since 5.7 maybe? drivers/misc/uacce. I don't think this is like
> RDMA, its just a plain accelerator. There is no connection management,
> memory registration or other things.. IB was my first job at Intel,
> but saying that i would be giving my age away :)

rdma was the first thing to do kernel bypass, all this stuff is like
rdma at some level.. I see this looks like the 'warp driver' stuff
redone

Wow, lots wrong here. Oh well.

> > putting emulation code back into them, except in a more dangerous
> > kernel location. This does not seem like a net win to me.
> 
> Its not a whole lot of emulation right? mdev are soft partitioned. There is
> just a single PF, but we can create a separate partition for the guest using
> PASID along with the normal BDF (RID). And exposing a consistent PCI like
> interface to user space you get everything else for free.
> 
> Yes, its not SRIOV, but giving that interface to user space via VFIO, we get 
> all of that functionality without having to reinvent a different way to do it.
> 
> vDPA went the other way, IRC, they went and put a HW implementation of what
> virtio is in hardware. So they sort of fit the model. Here the instance
> looks and feels like real hardware for the setup and control aspect.

VDPA and this are very similar, of course it depends on the exact HW
implementation.

Jason
