Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026301CBB26
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgEHXQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:16:22 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:8257
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727110AbgEHXQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLrjdxw7JmiYgcF7QdB7XMT4GN4xtlvIV/h+9e97Wwd6i83nHepm06lImFU3ZPxWqu4vOmXueSNsf1vP2r/dvnKamnbDqU83L2cVd2QTFd8wvjdUkRhDfOBAU/ZelN3b7ws0bY/eWTTvwOvh9LAIcHMWSCMS7sgs7mjYhqFE6npaolonfqIHJ/yx44LowHo5CpTE8J8yfo0FY7zK1+5IuZn9jNXex9v00XP1r2/sfndoGh+tXQAsRN8GfWWga2lO7iRCbYokORfdpl8QW4FsWcUChvRMGImpuEmS5JOqYiU3L40jFllLTftRap1Qd3o947c4Nz+CkVYILS4RF6/HmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fl0zvTYOlzDtJJSS/Z5crPAhewvW7pyxdfloWZFMmBE=;
 b=ZoAAVU0TCsmZdbV7mfbCSL+dMnapYvBaDZIxG/aV9jZfaUVaQGlYRR1GkFNdhIfZLRpgOanipO5Gr/s9yF0LsdmRVdUo/HyzD4RHeFt77ADlgKj2BufbxwypFufn4rgQWQeN1z+2XC4UURiNwHu6wpug2u19SxIgK6GcCDRuIcnNJO5ieW6cAVSO2PS3ROG8KBvQmV6SpL1Od7MyBkWjALW3Vi3o/fhWl3LxSHbZjLHcORvEWclkdSEPg9u+YbdUuFL64JkyBQhTxDhOA9FmIpp6YZpTaZ5Mbla4Q0nTOGyFftk4UTdh8OAxWYZuqXqef3MEwByWCrxx+alc9v3snA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fl0zvTYOlzDtJJSS/Z5crPAhewvW7pyxdfloWZFMmBE=;
 b=S49VdNIoGYs/i6KSKas/UyALJHDlEFQ3Z6uRIYkebEsKfEh/dC9PXQpMwV1mm+5BEQW3Ug5s0QMOqBtcEuzyfsJ9OuA/+RLa2ji5itVkH+EH/SWul/HAbUgYulMnOw1fnBeyyRfHOYjdGAPwDL7IAyte8a/VDC5bMDrCuHXdaqI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB3198.eurprd05.prod.outlook.com (2603:10a6:802:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Fri, 8 May
 2020 23:16:15 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2979.030; Fri, 8 May 2020
 23:16:15 +0000
Date:   Fri, 8 May 2020 20:16:10 -0300
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200508231610.GO19158@mellanox.com>
References: <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
 <20200426191357.GB13640@mellanox.com>
 <20200426214355.29e19d33@x1.home>
 <20200427115818.GE13640@mellanox.com>
 <20200427071939.06aa300e@x1.home>
 <20200427132218.GG13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8E34AA@SHSMSX104.ccr.corp.intel.com>
 <20200508204710.GA78778@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508204710.GA78778@otc-nc-03>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:2d::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:208:2d::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Fri, 8 May 2020 23:16:14 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jXCDy-0005Wg-Og; Fri, 08 May 2020 20:16:10 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a609eb6-784f-4038-5127-08d7f3a5cddb
X-MS-TrafficTypeDiagnostic: VI1PR05MB3198:|VI1PR05MB3198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB31986FC9C828291DD6A2D7E4CFA20@VI1PR05MB3198.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0RG2zlxnQco2QmbnHl+hJUEpM7fuS/CuLcMgDzTzoOZbzxRMF0kECGMu4r8p17Kj7Zc+Mbr4c7px6jfL6a3Teww85Kjh5MEbKSxbL6mFnzlMadYGwwn7Vz81nKDV7DTY1ejhRrOAxp5XUXyUYCbjUzuftLTStTUymH5bYbWByWUWH1KJXLsWWFNNBu/eXyIgdPhnICnAevCfs9jcDjukDl2X4qpwRUoKjYScCm7Nns2iApbPcMHm0tpX5woMKs+WvMPPrshn8K60T+IFyPSCJtGFH5C3iondvHi6byd4GZ05R/rxSx/FbLF6a4i8u9lYKj9PAxFSfVrfzMJ59GYkZF9jS+ubDMAaYlj+s8SfQdvQbbRq6yZz9Ox2ysey6PeNvrUYAy8+YigNEVwVM5gXWZB/lcWdfQ0ddGiHrDmyZucLoJzK1qYExNuota8wkuWGyICjynFKikO5ghXDoyOZrWPU4R4dMo6BnrE0VeBpz7MohV5bhXrQW0E2YpXJB6+mx51PKsLse+yyDV/e6RjkDqrLiEz/+PBwOBX0Tcqc5Qd+YXIh94jDjG6m2KakORY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(33430700001)(2906002)(86362001)(6916009)(9786002)(33656002)(7416002)(26005)(9746002)(478600001)(66476007)(186003)(66946007)(316002)(2616005)(66556008)(1076003)(36756003)(33440700001)(8676002)(4326008)(52116002)(8936002)(54906003)(5660300002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C1q7QXLPnwTdV7XeytOFEValLmyunejnYF9/vCygp/enrJM0XF1O9jqf86xZIonsbELZ3DNcOA1LPVCjpQvemO5pf6nOFLHEBLVdVzV/37El28ix/GzNi1oALktB55CbOkis5QmXDDB1/+GoN2mIoO49I4VzVz3TlfMTaZQgvkzBiob0OTpjRpAB8kVymDSdny84KoTAU3vXZKwCw5DfEeZmKpypdtsc8mLBS3drVuGg1cNPsYCpxXjcsotMN8MbcsXUbI5eDHxjArhBeB4cN6zf9bM1Pm/iSmSBFk8qb06s+NOZSq78joFAmUTvkTreHfNo/tcY0fEr7hcMe7DdHEH4c+j1ZdhYbjhJ9e2uWefZcjtDYw/HUu4teslGalEoky3P3BuOUO2g/IjpWbQTxj6mI+lY+Dp5T80998SPFbQqLPVU/jQDhxwE2HZNMqIwLdiKTV3vYb1xGw0ODowa9idHRfEla/net74X5z7nRCZo9ZDmVm63V4nD7HUryGkl
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a609eb6-784f-4038-5127-08d7f3a5cddb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 23:16:15.6434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jy5TMlb4z4AvopOE62igzwaATtIPX1iUe+XJitc6/iTOWMjDmHkItxO2E+nduXPUPWWTQqHuDen3FR/IeaOtvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3198
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 08, 2020 at 01:47:10PM -0700, Raj, Ashok wrote:

> Even when uaccel was under development, one of the options
> was to use VFIO as the transport, goal was the same i.e to keep
> the user space have one interface. 

I feel a bit out of the loop here, uaccel isn't in today's kernel is
it? I've heard about it for a while, it sounds very similar to RDMA,
so I hope they took some of my advice...

> But the needs of generic user space application is significantly
> different from exporting a more functional device model to guest,
> which isn't full emulated device. which is why VFIO didn't make
> sense for native use.

I'm not sure this is true. We've done these kinds of emulated SIOV
like things already and there is a huge overlap between what a generic
user application needs and what the VMM neds. Actually almost a
perfect subset except for interrupt remapping (which is quite
trivial).

The things vfio focuses on, like groups and managing a real config
space just don't apply here.

> And when we move things from VFIO which is already established
> as a general device model and accepted by multiple VMM's it gives
> instant footing without a whole redesign. 

Yes, I understand, but I think you need to get more people to support
this idea. From my standpoint this is taking secure lean VMMs and
putting emulation code back into them, except in a more dangerous
kernel location. This does not seem like a net win to me.

You'd be much better to have some userspace library scheme instead of
being completely tied to a kernel interface for modularity.

> When we move things from VFIO to uaccel to bolt on the functionality
> like VFIO, I suspect we would be moving code/functionality from VFIO
> to Uaccel. I don't know what the net gain would be.

Most of VFIO functionality is already decomposed inside the kernel,
and you need most of it to do secure user access anyhow.

> For mdev, would you agree we can keep the current architecture,
> and investigate moving some emulation code to user space (say even for
> standard vfio_pci) and then expand scope later.

I won't hard NAK this, but I think you need more people to support
this general idea of more emulation code in the kernel to go ahead -
particularly since this is one of many future drivers along this
design.

It would be good to hear from the VMM teams that this is what they
want (and why), for instance.

Jason
