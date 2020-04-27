Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7DF1BA9E8
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 18:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgD0QQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 12:16:33 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:6249
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728156AbgD0QQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 12:16:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmor5XyvV1BNTTnDMLdtUdRhwAp8raDcIqvy2uXVlvUzVd9DCnJtg62Lx6qbotIU8pXXIPTOvHntWDfHT8gxSfZvGjtNYjB6XVBUTP+Z5kYEtdcj5eknUDbvCiM2cOgH0yOo/aPpopuGsUuFi60oDvIvUO++VkVrMGO/G2r+ulO/Mn59et+/9Jp/8nPeQ1zmXhvsYTtP73V5xQDc4qbY387J1Z2cbc7R82qg5nTeSo/LYBlWNvQsmsAja6mRy/AvtU8+pXJmhmKz3uXeV2Ngd+5zOOHxyP5gwldzI1me0qCHUESKVfawGRkJNbJ+ANT2CWiCgG3+rMXBXSQQOTy2MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPTuHTP2cFZHj/SNKkk7C4sV1EuhSp/KyyjXa7AC8nY=;
 b=ibZKba9BpnoMM5jYzvcyqICN6xkj33QVJTAoRQMd8yaS9xXu9HtrVWaHXjgh6hsBF305Pglso07WJ4u+CE0qCVDIdhSPV8umQ/B0OK4EHtcoe8677trQCriQzbWBBkkLP+3B4HwsO/bHjAsMLTOnzFPmsYw4GwjGSGzWeAvUPcw4deNJ/Lw9yxcVdhJcOKAduDMLkJinJy3OegwY3U5uCk5gARA1uJefPyiizqqprZOSYv5zms5vihLc//GxjskagYGB0LmkTm3Pn/EYnoMiAR9qTtF1GnBCrpLQIdrits5ons/60lLM3kQn+CgqvyAe71UMpL9M3D0MeMBsFSsuJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPTuHTP2cFZHj/SNKkk7C4sV1EuhSp/KyyjXa7AC8nY=;
 b=HjD8yBvBo+38M899vPqrL8ko6JLTV1WkQP2WhHIGyQoL5MAJaSOx7pvu2S/ttbW0zs4ENyXvkARCksCRTPW/JX53AMWPII9IA3BghpMG8jmakkCVaBd7YGENl2cVCKv5gVqv/EnnHtjCsPR3u8r150OFx9ffZC0mzEKVw2KkrmY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4416.eurprd05.prod.outlook.com (2603:10a6:803:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 16:16:29 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 16:16:29 +0000
Date:   Mon, 27 Apr 2020 13:16:25 -0300
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
Message-ID: <20200427161625.GI13640@mellanox.com>
References: <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <20200427081841.18c4a994@x1.home>
 <20200427142553.GH13640@mellanox.com>
 <20200427094137.4801bfb6@w520.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427094137.4801bfb6@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:208:238::16) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR22CA0011.namprd22.prod.outlook.com (2603:10b6:208:238::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 16:16:28 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jT6Qj-000299-9p; Mon, 27 Apr 2020 13:16:25 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e75cbe4b-103e-4ca5-10a8-08d7eac65765
X-MS-TrafficTypeDiagnostic: VI1PR05MB4416:|VI1PR05MB4416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4416A6821392EC4B4E969446CFAF0@VI1PR05MB4416.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(36756003)(9746002)(7416002)(66476007)(9786002)(8936002)(1076003)(8676002)(81156014)(66556008)(66946007)(2906002)(2616005)(86362001)(186003)(52116002)(4326008)(6916009)(26005)(316002)(54906003)(478600001)(33656002)(5660300002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RyT5eR3Eg74TqpMtItKMOfrRA8WA/t7rpxqgMAAnw4040qJQQpoLpOMZjhTyRh1gOe5A+gLyqxMTIzPJEs3LlFGlItZBYIFbZkxRioLqKW7ImQ5J707bjXcPLRetnMnQ1V0fTaXyn9+AMkLwjv11A6XHvvIk9/ndLZZWluKvYzgK0IO2QiNHyWG13BrY52QnDupW0XEcVjGmQ11Ij6vovPTuReNTaGeyiJnZX3cCo+UyqJ6iq0QO91CnrM5NjQeYLfYAayEEMyTaU2nI5VVtNHgrLz8UQ4rPoY/tGwMBrF51G19OlaFhCitdDxclZgnXQIeeyN+TYBX7KkiKxbK8YcjUk0ny2wCXoLdagTajae5tVsArbuDeRubHdnd0hntWS0hRRDSLVRZQx9QWmQ4DeahiRTdYVRc2+T3seS28ldzo6U41c9SzdgUH9pw7glwdK8DOXZki5pwUd+9xlhKiwvvGFAaSgoEaOzLPW7rO2nGnlc9mmJfnZPw+28s9Rdu
X-MS-Exchange-AntiSpam-MessageData: iKAp5Yo3sll1ZmOLEe8NCwaLbwLlR9ndiA0wRjwGMlkxdkkY2YmmFhjHtaOeZmq5UxBDmQmY+eyQr9/XR/AXFmrjgmuF3bJ9Xw268zNDGnoh4HFL7HsDSxcosRDgaRMkDEoeGXvG335oQM65stDGI0cXwiZ0lReZoTgW8tuW0uj9dydHDYv29XrD0HKtDfdfXR+thdzORDHfhkl+Qjk39s7VMultW0NcoeW41w40YzMsQeKcVg8T0LOKwmxWCUAiJZzZZEeMQXkRa9rdxW5XzCQjp9RYWjlE56Og/WC0DnH5pJqWz0qrDChBnQzKvPAEiA3h1s72dhSeTzUwdoMQRaFzSahKq7GP2v4olV0xUyG9XkFIE/ZUY/aPqdIsU64LQ8JVjZ6/rT8RX1un3mEvTNk3rTjq6RRqBhXjRnO6aVj1pf50y2yFgyM0BTF3lN3SnaDFjEqTUv3RhUs/yAErlCk8T6DDmf9ywnJbGdhcqbB5Jci99uG+o4mw2p3ByW0pVRuT433c6n3QcukeWnrIJG9u7UbPNhhMth0uYSChKcIdBp3bw49nzLAHb4TSACQzYBNYIAUij9MItQ/RyzLhAA14A3W0ObdEK41ul7W8GxB29iItg4NMicYTJf8mkHoPEKuSo+R8o+Y+JtB+CbYK2RWA+/h9o14g494D0IOo5/fIJZ8odt7CuePxJBvF3FugP3jYs1sGMHMeQPqyoUxqqDRDYko8li6uWnTq+T9DG7oa2/kwYxFFShqgby0P+0Bjvzt6Si94A4fa79RaGDzhEK5h29oRECMTPPo7CeOD5CI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e75cbe4b-103e-4ca5-10a8-08d7eac65765
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 16:16:28.9448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0ppz3mVEedUo8lUZy8jLrlx8OXTvjnenLD5m2Ys065IFGcK4zkoP3kdkX1MUJ4xPSFbmKqm/LoOdAFIaJNQHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4416
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 09:41:37AM -0600, Alex Williamson wrote:
> On Mon, 27 Apr 2020 11:25:53 -0300
> Jason Gunthorpe <jgg@mellanox.com> wrote:
> 
> > On Mon, Apr 27, 2020 at 08:18:41AM -0600, Alex Williamson wrote:
> > > On Mon, 27 Apr 2020 10:22:18 -0300
> > > Jason Gunthorpe <jgg@mellanox.com> wrote:
> > >   
> > > > On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
> > > >   
> > > > > > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > > > > > emulation.    
> > > > > 
> > > > > Not sure what you're referring to, I see about 30 lines of code in
> > > > > vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> > > > > config space and maybe a couple hundred lines of code in total handling
> > > > > config space emulation.  Thanks,    
> > > > 
> > > > Look around vidxd_do_command()
> > > > 
> > > > If I understand this flow properly..  
> > > 
> > > I've only glanced at it, but that's called in response to a write to
> > > MMIO space on the device, so it's implementing a device specific
> > > register.  
> > 
> > It is doing emulation of the secure BAR. The entire 1000 lines of
> > vidxd_* functions appear to be focused on this task.
> 
> Ok, we/I need a terminology clarification, a BAR is a register in
> config space for determining the size, type, and setting the location
> of a I/O or memory region of a device.  I've been asserting that the
> emulation of the BAR itself is trivial, but are you actually focused on
> emulation of the region described by the BAR?

Yes, BAR here means the actually MMIO memory window - not the config
space part. Config space emulation is largely trivial.

> > > Are you asking that PCI config space be done in userspace
> > > or any sort of device emulation?    
> > 
> > I'm concerned about doing full emulation of registers on a MMIO BAR
> > that trigger complex actions in response to MMIO read/write.
> 
> Maybe what you're recalling me say about mdev is that its Achilles
> heel is that we rely on mediation provider (ie. vendor driver) for
> security, we don't necessarily have an piece of known, common hardware
> like an IOMMU to protect us when things go wrong.  That's true, but
> don't we also trust drivers in the host kernel to correctly manage and
> validate their own interactions with hardware, including the APIs
> provided through other user interfaces.  Is the assertion then that
> device specific, register level API is too difficult to emulate?

No, it is a reflection on the standard Linux philosophy that if it can
be done in user space it should be done in userspace. Ie keep minimal
work in the monolithic kernel.

Also to avoid duplication, ie idxd proposes to have a char dev with a
normal kernel driver interface and then an in-kernel emulated MMIO BAR
version of that same capability for VFIO consumption.

Jason
