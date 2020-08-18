Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0B247B95
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 02:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgHRAnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 20:43:52 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1955 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgHRAnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 20:43:51 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3b240d0001>; Mon, 17 Aug 2020 17:42:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 17 Aug 2020 17:43:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 17 Aug 2020 17:43:51 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 00:43:48 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Aug 2020 00:43:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTqYmEqTx17zJi0aGI73t/G/JDA3vHbQ+55/bA7S3u70p1KsQnFnu3zrHcUqMbRHa+b7kn5sznA4hmAgbAEAaWMYzSSiNvKItftlKM5a4YqX7Sf+NbISBVsj6osZVmL8omL34Xb6ZYpWRtDvlP8s+FoP7Ix4rEJchNUMLWdwC7okcbBKje2C58Tu59+CzHBEq6pXDYIZjmiJlJpHWetWEvBqZkjGLOiqGx4ovlxVe7efFK8qSbmYhJLCqgYuxeAGqw1Ayl5tUgdVRHrpm75R5TxkMJ4uY0Ng2Yy9khtcTOJ11F1G7ZVeDG7gEijhCpoJR73uFYEC+AIDXdMefc08QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7B1t+o9+ek/E4LL/gsOotaR+V8iGwZZJy907euSh5Nw=;
 b=Ox9Tqe3rgdTfcLC3RwA+shT4UHT9uILlg/jYXHsnDJ3wU1RIkVL3WxDVlMVvyxd5p/yR7VFaClCDG9TpZJjdfYPw98ttOgij6sAYN072VJPAZ7dXxYw/RAQkgV6HzU8uwEDBxGbwRKVQC1F9oIhCsNiK+/VkO6G/SLFyyJ1G4VvCw5HSsanCXXs9nG279aIvLhqLS5C63LNN7Icv8FWAoEK8JjrkJV5khFwifhHQHwqZWgd93JW2hvLMm6OySxxsuP9oZPAC9DzPomJDEUIZYY7TUtT+aWsl/HRCR06rpTYkCOIaS3tyZmGllt17q1HBHSSz4BqAzoebyAsFvXjTmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4546.namprd12.prod.outlook.com (2603:10b6:5:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Tue, 18 Aug
 2020 00:43:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::2d79:7f96:6406:6c76%3]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 00:43:45 +0000
Date:   Mon, 17 Aug 2020 21:43:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <20200818004343.GG1152540@nvidia.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com> <20200805192258.5ee7a05b@x1.home>
 <20200807121955.GS16789@nvidia.com>
 <MWHPR11MB16452EBE866E330A7E000AFC8C440@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200814133522.GE1152540@nvidia.com>
 <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16456D49F2F2E9646F0841488C5F0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0063.namprd20.prod.outlook.com
 (2603:10b6:208:235::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0063.namprd20.prod.outlook.com (2603:10b6:208:235::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 00:43:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1k7pj5-007yz8-JL; Mon, 17 Aug 2020 21:43:43 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faaed4de-b62f-41e8-b65d-08d8430fc309
X-MS-TrafficTypeDiagnostic: DM6PR12MB4546:
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4546A95282253EAC3CAF10B0C25C0@DM6PR12MB4546.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gB5TbYR9VElz0P6P/lpA+IvJvOCrMG4yDztWJrqxjwQ5LZe0iVfAkQiWLM60a2x0WJvAke/qplnU8lZdlA6G2gJiGU+qj3EjjBn63EXjR+OPrhvpQVh4NaWtnh3IDRtu5nTYkduu28SgnS6HEJMyzHmIPKTI8DLeZf7RPs0OtMH4laVKuEPIB5h1YlfOjQ0sr/8hnZNgyFZRGXOO283dXZBClqqDjQSUcz9bZUw3UTg6QyR1VFd9GCWgV9KqxImFWB0VY3UvUnPVItFFa78/ijzFEoO15xtHQkCSghdsLP5hU+zb7pUj0wAMMUbtfcVhPaMiER8dFABmveXyGiDGAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(4326008)(2616005)(9746002)(9786002)(8936002)(2906002)(26005)(36756003)(1076003)(66556008)(478600001)(54906003)(426003)(66476007)(66946007)(7406005)(86362001)(8676002)(316002)(6916009)(7416002)(33656002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6yj+rs3VJ3dkUK4gZpKpeFoD5XyXrjMDoyqDpb7MYm09SpeedhNdz72m9bjMSR6w2xhMRaS4lSJaNF3wS0P9OCBwWINnrgO/d1X4gJX2wFC1AgWQQdl6rTfi/TMTdg45EDcRj5jkCrsiykAlNDzcjhXpiS+8PxeEJ2DNdJczwV8FagMLuuCjsIYAZpHHkLHPUyMsdLpcZRjwGxEDG8eFrPSbESDwJMaV3FJq/l2Oso9e3rFaNzX2LZpUL2xUaqEDqggOK3VCiRprC+t1TmQhu9PdfN9FUd/2FhBRGwoZreVVfrB0g0XdXSL9jDboWijYdapeS7btPcdYphtZkP/MePGHT4etfqeWzIG/cyDY6yZ68+0EPZTqZ0y+SoQUHfP47EZUsFlHtIHUtXfwwUTb92MJiDVH+5QJV2KKnr6bTuEqdwYzBjpONMLa+yy4iR8N2Viv7776C5nN6kxzMQ9027qZizzIOYvK+JQCUcsefCvR1n6t2I/xPHot8iFzUj2AuHyqtBabLC7TgjQPl/6zdc2+UDkwlCVfmaNoflVnkR9HQZ+4PWpOQlfhxO2TdtrQIgMGm1b7BSEiPkoaqIlgNtIGH1R36Xd77oaUlMahs17h8dkMrxH5a7UHH7Hi8mIKRe0MKTU4KrGqjHXBiidEnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: faaed4de-b62f-41e8-b65d-08d8430fc309
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 00:43:45.7624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9jt5uqBmSwLc5lOT1j75PaaZpjIkHa/3GdYdDKJf+wwG9J3Aec6ohoYrHzmORri
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4546
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597711373; bh=7B1t+o9+ek/E4LL/gsOotaR+V8iGwZZJy907euSh5Nw=;
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
        b=ZsqDgLGNe5aIFmS0BYT3jU7DjBh0QSWVLdGGibZnhkwriW22Zom1dqSsgCgkhyree
         Y9OPqWboCxijZgl9RhXkPyksdfCODwOgbkMgf1Bjkc+rlNLEGj3mZANbJDExOfumOx
         WNRC+LrtC5nhNZwy4NRC1ltGcox7i2qofwxB63idodgk3WcyqsG/MdcgYsHmrLxywH
         sJPR+u1RQm8muwFgT300n0s6CmtqKizPAN8uyhRuoRT6zIHUfvr/HBFlRImbdUGZBE
         zXmh96/G8NyJRCt8EtyD9ONK12zFRyjAyHa48sG2iVF3q9WsoHwnd+QkknsOxcSrMZ
         3EnhR4q4rEijQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 02:12:44AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Friday, August 14, 2020 9:35 PM
> > 
> > On Mon, Aug 10, 2020 at 07:32:24AM +0000, Tian, Kevin wrote:
> > 
> > > > I would prefer to see that the existing userspace interface have the
> > > > extra needed bits for virtualization (eg by having appropriate
> > > > internal kernel APIs to make this easy) and all the emulation to build
> > > > the synthetic PCI device be done in userspace.
> > >
> > > In the end what decides the direction is the amount of changes that
> > > we have to put in kernel, not whether we call it 'emulation'.
> > 
> > No, this is not right. The decision should be based on what will end
> > up more maintable in the long run.
> > 
> > Yes it would be more code to dis-aggregate some of the things
> > currently only bundled as uAPI inside VFIO (eg your vSVA argument
> > above) but once it is disaggregated the maintability of the whole
> > solution will be better overall, and more drivers will be able to use
> > this functionality.
> > 
> 
> Disaggregation is an orthogonal topic to the main divergence in 
> this thread, which is passthrough vs. userspace DMA. I gave detail
> explanation about the difference between the two in last reply.

You said the first issue was related to SVA, which is understandable
because we have no SVA uAPIs outside VFIO.

Imagine if we had some /dev/sva that provided this API and user space
DMA drivers could simply accept an FD and work properly. It is not
such a big leap anymore, nor is it customized code in idxd.

The other pass through issue was IRQ, which last time I looked, was
fairly trivial to connect via interrupt remapping in the kernel, or
could be made extremely trivial.

The last, seemed to be a concern that the current uapi for idxd was
lacking seems idxd specific features, which seems like an quite weak
reason to use VFIO.

Jason
