Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E12922BAE9
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 02:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgGXATk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 20:19:40 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:35832
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728187AbgGXATk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 20:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIxAfDKrmELHkQ37Yx/pxYpFMm7XdktPaJDURJNRIWS588Q0mnNd8qocOGAqpvBarU+LU3Vyb5J065i7rTHhzKXgh7gcS86DZ8kSZYj7qy9l/IO5GWpE7z8/tduG5048973ksFx0Nr6Jt0HcQ8Bc3e8svaArYhI4QNSuY6cueXUFF/PLPv5i1eErvI+BePmFJ8JDzIInTJTdpG1ueN8KlpDnS3zRPiKjlbgZqYtl1Pyz850ezRpUVFluj5NRgD3dwSJlFMuzD/PAA5jmE4N2RZR+Js0j91GR8jK7a4DJuqsZONFG4jtUXVAdT7nOUi3JZ1mfeZKu55wzzfZXFl1ptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKgXeUQzsksGmCUNsr44CK5LbZB3qab0NdBc27SSk2A=;
 b=kdpHJo0LC9bhjuY6pQGYgy4hf3N/+HdkpkZi6TO+4SFE/8Zh0ocnEJ2X8NBQLLViKRUhEmHra9Fwg+Sb0WzwXSOkAp3hyjLYRlDriOYVAouoJyLM2tb+ixxQhceMvaCr5u3FG253XQM/fGn1cY1ZNexRZfO3+stbzzfOTtxdcq8EHoNxINFJKufmNo8744k/mD/3asdWJrk3bVrmIDcODilQ2D6COtPp5VD+bJ4P55Ir9saCdCe68B4fRMyTUy6VlET10N5D85HuZWIIcT3VwhYsq+ycCp9OOsIciJGZ1GmR3VR2TOG083iUsjpoCtLAfavpgfB+tTphSCfmgxsYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKgXeUQzsksGmCUNsr44CK5LbZB3qab0NdBc27SSk2A=;
 b=XYAEOz8BxMr0eFMYwD5pMjTikc6lzoyRtPTkwXT9lRWX+osryR7ENpaGNIb6brFao1PIb2ZO+kq0CFcTk/nKgbkSY2yOgQd/x63MEc8dX0eO6VWMXszm33AY0c0uH52auTx6eZbslmLVsQkT6RMNuvVv38Rw/zoXSnvLEsCeU2E=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0502MB3951.eurprd05.prod.outlook.com (2603:10a6:803:17::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 24 Jul
 2020 00:19:35 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.028; Fri, 24 Jul 2020
 00:19:35 +0000
Date:   Thu, 23 Jul 2020 21:19:30 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Message-ID: <20200724001930.GS2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0065.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::34) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by YT1PR01CA0065.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Fri, 24 Jul 2020 00:19:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jylQw-00Eb6F-EQ; Thu, 23 Jul 2020 21:19:30 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 806467bc-1a4b-4a0a-a658-08d82f673e69
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB39518E7774967D684330AC82CF770@VI1PR0502MB3951.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kn+1XU7PKTZVibxyduX59TPZGAoBiXIRju/TovbE96He8qJHDj80MZt1uRIs4e6U595f4h79TZn0qgk4RC3zAeLkpz5hF8SNqQ8iksfagpukJCZXs+P3lwHJVuQUy37PvOQ2uDet8IOuu2jnlqCH2+AetwERtBVaZjuFXL8iRF0ibbCYecgWu5DA8TA2ENMK9dKF0Z1O5sC+22CI/Mk5XvfHNvb9KgnPY1g/dOdDiXd7mpsPPmqXxoWfzd8xhqvVReUUPNI6Y7fPWyfOKsbNpuq0yhmWbFYIoEotvKUBuAQ7tPsvK/Gh0FhEkcAL6j0B9MLFgAB4pyHKVf3H96R3OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(33656002)(26005)(6916009)(5660300002)(4326008)(36756003)(9746002)(9786002)(1076003)(7406005)(66476007)(186003)(7416002)(478600001)(2906002)(2616005)(426003)(86362001)(8676002)(66946007)(54906003)(66556008)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pqhcNQMSuLcBz0D1S/zT5wggPgEbWSbmN4ICtH/pXZ3e6nw6HDQGe3XNxLiALdRG/d3qQMfzsjGoa/SkjwjHhPjbhlCsQi/qmyWfOg4MRXataK9h76zcdAHdsUTcB3Q2DLQ3BIjoFnGq4Co2P0A4b3CKPga9dig3+ECLE+8f7VMCE+8fgFhK5DnrZKIC9Uq24OCV21P6cFAyEYuhl+SxDlvOQEhFxj6pyNyVi11eLbnqk9gpqHGEnxcSFj3aPPPrpWp+4lN4iUR3w8JizdwDPAMyCxTYQFw7Gm2ZJiZbHJdRg6rTiwmsL/kiZJ9551Cd5rv9ri/k78GvVvUp22Mmk/E2DDAopL6ngESoqHohcklnZ9t+n+ONFFnJgdkY+4EdScCI4pWo3UDB645PnUKrFbOVnOfA41SNs9tkgLeVy/kl6KbjDCjQx2WvusIJSDmavYsRJ9L7uCgWpWkJ+FT22aAwdS87Yp6sj2j0UyEvYX8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806467bc-1a4b-4a0a-a658-08d82f673e69
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 00:19:35.1871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9UHQLJZXe5XZN5s7IhMkNzkltN0nXje4Fgdkes6OT0LvBJQPNOvVoYs7zRc/YhIWh8NZks6c4LU2+eFPmdRvoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3951
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 11:54:49PM +0000, Tian, Kevin wrote:
> In a nutshell, applications don't require raw WQ controllability as guest
> kernel drivers may expect. Extending DSA user space interface to be another
> passthrough interface just for virtualization needs is less compelling than
> leveraging established VFIO/mdev framework (with the major merit that
> existing user space VMMs just work w/o any change as long as they already
> support VFIO uAPI).

Sure, but the above is how the cover letter should have summarized
that discussion, not as "it is not much code difference"

> In last review you said that you didn't hard nak this approach and would
> like to hear opinion from virtualization guys. In this version we CCed KVM
> mailing list, Paolo (VFIO/Qemu), Alex (VFIO), Samuel (Rust-VMM/Cloud
> hypervisor), etc. Let's see how they feel about this approach.

Yes, the VFIO community should decide.

If we are doing emulation tasks in the kernel now, then I can think of
several nice semi-emulated mdevs to propose.

This will not be some one off, but the start of a widely copied
pattern.

Jason
