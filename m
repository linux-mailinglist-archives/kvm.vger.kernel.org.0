Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7D42EFE2
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhJOLpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:45:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:26677 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235360AbhJOLph (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:45:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="208012988"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="208012988"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 04:43:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="488086872"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 15 Oct 2021 04:43:27 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 04:43:27 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 04:43:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 04:43:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 04:43:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Usqz3ay08kDfyQod0SndbEJDN3CzR1AIv77npJVKtQNA0Pab7zAHKcTbl1FA/MNgieHiBhoL/CcC+sR0p9o4FCFDAEusZYotu9vHNjepUk5n6M/8SdxTdd1GatUh56WUNTFc30Rzdz2eTBvqcfiIuxqvlJpCUgj1+Q3H86DCY5jfwRvCcY6xIIW2q6q7+H9HTyimZ+G32cmKfOOHwRWq+mGmviiKRvPf49dJF8CD8c6Tk7/k13EB85Ixlp5Y9GoGHIO8JLrQN1akHw6gR9ijxWpQ5hXZfgcdcWczRSkPGQG1xSff7+Vz3SUFiEqbaPuWcmb9ElTqfBh/3/1Z1eLt2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlhAZwYM2Qsc8A4+cNumW+8e6BpV1wPVTO9ziLu6Whk=;
 b=Pb10PHpfnq7n/aMV1zHPBhEdt00rpn1wYYzn+cF7U1AAzIzGujBl18NLUPDe+ay6Zzise2FxwWohG4p3CV8EYeQDMFybWsTdE0md969pZkJj6jn8AxtbXS+TdANNFLRALWMOXAG2+pECm3f3FN/fpYx9OPiRV4+XWw9dIFkZV+oyQbBVGFcuEiddfiF2pfwGQ8WCNijNIjCuLE1x6yfE4rjVrJnc2JDbGcy/naLDfX7Swl31GLNNWhuGqHRZW4ixaf27TK+AVR45ccDhnAMe1jLKc78mva9LBRvnwxe2HRih1xSMcFcc/PPTvx2+Ts3OuiYEL/qlWBqRRpQONhrtZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlhAZwYM2Qsc8A4+cNumW+8e6BpV1wPVTO9ziLu6Whk=;
 b=eBnH/Aom9ncdkx3Vhkzy1Zan8ER+znw+ZfK8JwilcODVgHaRCKdGv4EWGZV9p7Y6PHR5xLUEJfpdVSJYCzhcE7tWuygUTBDzhPq4C7rQ5NSR9vFjfCzjxW/EGxB512FapjheaRmomgQrf/CScKt+lM4JjbV6XPG5EZWR52wxo8Y=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5593.namprd11.prod.outlook.com (2603:10b6:510:e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 11:43:25 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Fri, 15 Oct 2021
 11:43:25 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH v2 0/5] Update vfio_group to use the modern cdev lifecycle
Thread-Topic: [PATCH v2 0/5] Update vfio_group to use the modern cdev
 lifecycle
Thread-Index: AQHXwD6SiGHsWaIRwEeUL+A5q+eCDqvTkyWwgABffICAAAB6cA==
Date:   Fri, 15 Oct 2021 11:43:25 +0000
Message-ID: <PH0PR11MB5658E3537109FA2DEB3C2499C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <PH0PR11MB5658A21677BA355E1A44A6C9C3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211015114115.GE2744544@nvidia.com>
In-Reply-To: <20211015114115.GE2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce52e6ff-df5f-44db-2bbb-08d98fd0ff6d
x-ms-traffictypediagnostic: PH0PR11MB5593:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5593B3E3B23C4DC9735A4D5EC3B99@PH0PR11MB5593.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MQ9Prw4oZZYHKKOnDCkkOFYtgIZWOA4iqBM1MmkkffCQ8TZKN7FRl76wyOmI28qnrvmx3UNWEXTaR4dNWhXl8Ptwcf4k7c3HR7qPzu0ceZNiriSr3V3nfkKzUvOUWhpgHdoQ/xExDkQYM1gxc9EKHyLiC9C8lnCUhv4DoajkNUZJmaufACDreDkhE00zjyPjUW6LFwzikI4ZVHNhAwyT229S8/RVtRC4jeT13FHnEMqpsXj4z4G5E26vP0JvvnjYFgbsqjpjO2ctXjG7e54MU4WrP8CddT2Bnl6k8vsYm/pmreMOXgqxsfpYaVOIm29vdXBUeY7GAQDOReuQS4IFpEBNnO9WlOpFyknwpidg5zd5D2yWhI7ZcR8RxgPxS0yaqcne1TOCouNWsw9Yc9QGyys3pSVJ0cfva5FohJCgQGghCEC3arYX0qo2YZjeO2zXJK3ZKDolPV26BwfRZFVs4nOCLSTmGFbBgpVKTVFHAPlRLD6RWlsScLbOIWLUs98nDTOP+Cr8ob3Wa2YyReQjwy7ZM+92b9cNbvY8tFnU7ujK3jpaPi2z4hwWcbzgbX98IjMciJujbKcQGi6DKSz5ezhiqvDgsCpFNLJDNgUie60VxUgn9isWOIDRClPpul9LuMFKqoD9TyLqGjlePxoD8zdZJFqKSR/K2WeTwp0IsotlVwU6gkgpClwhTmSswa3ivEl0B8dMCSGq2XfZlV8zpQOV0DDS5sBDLwN+8Nu1Rx7u67K53pRbu8is/mt8SuiPMUi1hMCrJdZ46Q2HvBt1sVCoT+t/7/huT8z63qX5hAHeCiIbIus+bxpSHPCqH45eCzIyxlDckEuurAhvA8OXbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(66556008)(66476007)(64756008)(2906002)(76116006)(66946007)(8676002)(26005)(8936002)(6506007)(186003)(33656002)(5660300002)(7696005)(52536014)(122000001)(38070700005)(38100700002)(107886003)(9686003)(316002)(83380400001)(55016002)(86362001)(71200400001)(508600001)(966005)(54906003)(82960400001)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2jXv+4Edzk1JmDXLiHnBNx5lpWp5N1VT0CP4jk4CstCPQZ05dlU66PdLVtSb?=
 =?us-ascii?Q?xZRUWz8LgN5T5gOZTRqvjQyB6xLWQdCnlIfKR6pk7bziJxRg5OzH21c0CTpv?=
 =?us-ascii?Q?nTQBIDgaCh9IfxKGCRlm7psNal1VwCX8897mKwr5lLxdK6Yfhdq+qXy8qQe1?=
 =?us-ascii?Q?hehXhA6VukQqtB3ux8fqpO4M7+DLf3CGVTe2AufgM/MSxZDAp89QoD/WyLpW?=
 =?us-ascii?Q?x1hjqO/lKhqYSNZ4d/wSyd8hJZKKRP0xIh4F7BzsUi9lIlPqJfe7eA/xlBoH?=
 =?us-ascii?Q?nIppX2hoY2739HY0F88brm+dHJDp7REj33xiojZOCuBHoY4+P0Il0LZQPn+a?=
 =?us-ascii?Q?KDlSIQk2W/5YOdmDqNWE0fgotGsOWFNbF45UzZoTZjcvzMFvBQJhAsLkA2VC?=
 =?us-ascii?Q?Nw9VMTHp1nJmGP9uQhDcS58u4u2YqwGf2eJAAPe8RyQLEKSW5kM6rx4aDywK?=
 =?us-ascii?Q?++gogATt62qIC1jkHhZKl+JW9xPaMud/CycW7zr1lfI6LYpVkEPQvrf0mkLq?=
 =?us-ascii?Q?AcYeMXQD3L77+8QuMe5Z4XscxcXS9z/YNRTzFmBXc+JsmtRU5NOoI+sw5Qa5?=
 =?us-ascii?Q?fENiT7onC4Y2y+24ZhgKsP+DWIokHJIPMFdWQs38JbEdNOcw2TKILn4B39aK?=
 =?us-ascii?Q?9TbL/VNufcsSmdGTdo03PWVs9bPdh7xtyuVSiAA3RY3/ljqfli8P3h3B6W7P?=
 =?us-ascii?Q?TVnbNqHJ3sxSPtJK7llkoQsErIyJoBVmxpTgX1dz9MJrgaUkkWPf4rKf3R2S?=
 =?us-ascii?Q?AcfDJ0eCxjpTmXRt2L2hq7iegnJTO/b458PLdQfu491olEgKILvtxQYS004v?=
 =?us-ascii?Q?EFySulFTQcsE9u17BpoXQhjruTrm1gDycAiDz/BW3Tvom7ku7SvVWcKxd+hJ?=
 =?us-ascii?Q?SnIWQywSyApGEHQkXEX5sHby93c7dvoY3TdCqM5kVN0EQV7BPUsbgryluNXX?=
 =?us-ascii?Q?dp4a93snW53gYm1b2BIackiFXjg1nhJ3Lsnnpm01nDwgVcSIrC47wWpTWlVk?=
 =?us-ascii?Q?rJCh9vUHr/7mENaNnoa7Av5yKYMfdXl6lJrtJ3dp5g/b6IlvVRPv/scGCShT?=
 =?us-ascii?Q?UlQiMijC/3yx1+YcuXjPPyaZr4mFpRlmOzuq8X7Y3LE672W4o8lRvG2g9qnI?=
 =?us-ascii?Q?fiJr/Biz0Dmqhiey5x2TBTHUN9mkrTaOP/+CHiaS22TP4XmwKoTKUdfyAa5t?=
 =?us-ascii?Q?gFFaHKLQkFFwWkWhUOWK4eOJmPnVFnmTbyemJyBVKx38NcovLnF7RSWt+yLT?=
 =?us-ascii?Q?trEbIB4Dvgfdk5EWaOtxCNO8qNwAYebj785uA5YBGT0pVdh/H7vo5jV8F2W4?=
 =?us-ascii?Q?8xv1ZL/h8n44wZ2LrgnMhplS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce52e6ff-df5f-44db-2bbb-08d98fd0ff6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 11:43:25.0153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PLGbA4C87T/IwQQuSOpI8ARZJ7qwb43QzFQkKYh5xqNyR2hYnFwu9YxbOyPVzGh36BQANxZHHsWWHb4s6WD4Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5593
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 15, 2021 7:41 PM
>=20
> On Fri, Oct 15, 2021 at 06:03:18AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, October 13, 2021 10:28 PM
> > >
> > > These days drivers with state should use cdev_device_add() and
> > > cdev_device_del() to manage the cdev and sysfs lifetime. This simple
> > > pattern ties all the state (vfio, dev, and cdev) together in one memo=
ry
> > > structure and uses container_of() to navigate between the layers.
> > >
> > > This is a followup to the discussion here:
> > >
> > > https://lore.kernel.org/kvm/20210921155705.GN327412@nvidia.com/
> > >
> > > This builds on Christoph's work to revise how the vfio_group works an=
d is
> > > against the latest VFIO tree.
> >
> > Jason, do you have a github branch includes these changes and also
> > Christoph's revise work. I would like to rebase the iommufd things on
> > top of it. Also, want to have a try to see if any regression.
>=20
>  https://github.com/jgunthorpe/linux/commits/vfio_group_cdev

thanks.

Regards,
Yi Liu
