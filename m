Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00B3338F04
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCLNnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:43:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:39864 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhCLNmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 08:42:45 -0500
IronPort-SDR: O7eOQEw/201T/lYPFgXd9JBuwpPTsFMAMb6M6flXKbOOfAbZmknUP2vn9IJsV34518o+sEsfHI
 nrV43z1LRy0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="176423325"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="176423325"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:42:44 -0800
IronPort-SDR: QkLwrRrfcMNB/3K4ceO0Mg1rxgeZhKj9qtqV1mfoJ+kx8iOWoAz8EGFDcZtY7SMevKrRhfgoyy
 zNSbBt12TuPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="377709911"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 12 Mar 2021 05:42:43 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:42:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 05:42:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 05:42:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YimvXiFYCohy2WaWXs4VdbBY1Yj5GCY6c3/R7sfL0IaVlk/GQLwhLT3oqG84TjCJlbkcbQQF7QWfBJvZCq1BncFC6DgaeHGdM0u2aSGpTzTgrqD4JTbjjm0BmKeEiretk4UlboVMwrylpJSeZ+zu92Jx6Li7q1NL0iL6a1qA8e4wdOZuoUQdpDaMWYHCafP6qeDfSZFXqljGQK769Kv/9Hqvt35rLF/Fo0vozy0Bxd+UCCLsWxRI4TNy/y2U/PsjpOuXf9yhmPWjerTjB1sn8wKsaIVKaWoDXp2hXNIPO+4c2LO5NXh4FK+aqEPRo79mOPvUWKGgmUOsIawKG76vNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8FPItKh06gHW4MD7uia2nFDmhbpU8czpcf3W0/yz+o=;
 b=XcT3u/XuyJCJmluvkAdOPA4GSEHP5+BN0q4xxFT+vXZrMXwhNwb+UGqD0/YobEuAlNknAAEH1PU796SUA4ka/gH8RPkLdaT3lxqOL96w+x1vblmMrFuqTlQyWgCaAlQM1SL953q6ur2xZN2taGoAwZ0hp+Z5bVVegaMuAMoQ2j1auLp4boRb+I1DQOHTxv09xHWzp/4o5t0m6CNUv51EenrUnC+DaIm7NYkyByvq8ep+h9qCP9RczxSVjavNCTDhLaEpuUiYv8rM331r8G1TBP0jC0TZsxKq8/u6haz9DvyQsljqVK4qUnautj/FiqzVzGEv3x/4VsOkrFVb834TTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8FPItKh06gHW4MD7uia2nFDmhbpU8czpcf3W0/yz+o=;
 b=FskiHUrPK0SwRt3bIG9rzhaaqyinlig3ovz+oGNJuBm8tcbMwDeZPYLhuvxTKxDUTd6nkXFSoDsx3YPyu28Y6KCml/qaZxzulOI87lQx6k3WMEHYe3Sy8yZe19QuhVv4K2B/LXKFNbr31p1b0kJZflk+r7B1v7v60tg1+KqNq5o=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN7PR11MB2754.namprd11.prod.outlook.com (2603:10b6:406:b3::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 12 Mar
 2021 13:42:38 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 13:42:38 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
Thread-Topic: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct
 vfio_device *' instead of 'void *'
Thread-Index: AQHXFSzFyLqoSj5Bl0CR1Rt9LX14JaqAX6FA
Date:   Fri, 12 Mar 2021 13:42:38 +0000
Message-ID: <BN6PR11MB406801671BEC89068FA77F44C36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3e46f1e-0a2a-48ca-7d3c-08d8e55cb371
x-ms-traffictypediagnostic: BN7PR11MB2754:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB27540356E0681FF45A952B29C36F9@BN7PR11MB2754.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vkf5Ktw2RFeoXxSqgFcFlX4D0yT6nvKgsdggKIo1EUTUIZjyVoA57MELU4hWVBzdhpcEqQESikLpx8IPGpgrjF5SEG3EYvbc1tXq/clPkl3V4Qa+umEF5yJblzHtCtgUbOGsDzrUxGdHmSOaEULCjMEsMOhohXCPrvOZ+aAJbfXdPzggtgXUO7FV7M6abQmnuhiaiYYq27jfkq2T8zyyutdTqHl8DuE6bnC70sOCwsoTaaplEnoiS0Ybx5RWCcwtA8X/mu+dhdyUNUqple2+VnRqBDePCsI8PFeV6KzM6krhaV1OxlrorZ8Lo84JB7zYGt9HQYZYIzaxcQcWYxP2A3MdrUQYO82xf9EoRhONA5F3gzOZp8qLlbEsD+ZcQmVS9FnsqTud4//NCoZy7ezIccL58ulgRPE/vJfieNLXkod5dq92e3eRKNsk4RKor6891NIpd4ZO7fwDqCZ9bMsF8IVmSXhT+4Pn/q3MV082q4zBcxxnLsnqd9AH3Y2HzGsLPdeGGb0kFUYApB+GPTY8Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(9686003)(4744005)(54906003)(8936002)(7696005)(8676002)(71200400001)(76116006)(478600001)(4326008)(7416002)(110136005)(55016002)(66946007)(64756008)(52536014)(86362001)(66556008)(66446008)(66476007)(6506007)(2906002)(186003)(26005)(316002)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?80R+J1zFOsWpkbsbpLM1SNVpI5aIqB55sxeTfyza4fPWJZiqZ00HUHStJ4Cz?=
 =?us-ascii?Q?2Bskk4P2O8yKjiZFrfwFUmJVjIv0zg7XMf6XYb2hbkmAVSID/qktQCt0nIMh?=
 =?us-ascii?Q?YsR/h1oYlSFE9wSXj6sZBK3u6MjrBQo25IooXJVQ+hdH0ScvJ8WpguCpPGJ+?=
 =?us-ascii?Q?458nIcNykB0CCQKAtS1MhM00OLzAXl2k4NsmKmkcGigB/HDzLgIjxStssJJR?=
 =?us-ascii?Q?LKmhWzKtrfilde+HFbQ6N8OvTtJcF4Km2auB9k0FMgaTEpfjPtzD9F1mvAUC?=
 =?us-ascii?Q?6mvcaqw+6atQx7F2WG2fE/IRSM80XWFATFms78clNwPuZHOikE6LmF37vhoB?=
 =?us-ascii?Q?Mue2+wnbdTRStA1H1mzIDX4B0l2rjiWcknkuwzjn0NM5ilVRI3R/tIqpxKAB?=
 =?us-ascii?Q?NggatbhUK77YLg6PshXoo6Opm++u90ktNsAoFS4b0+7E6CXJwVTxvKIpdIdG?=
 =?us-ascii?Q?6leg3vu/1bMMOGszeTYoJ2wAJ+29MgeXF10DmLUPBiCalxtdTPH9ec+jCqoq?=
 =?us-ascii?Q?xJemwbJKBiL2XX52Z4txOLkzYb27VP8dL8fM8EZOaY/HYm5Er1uxm8PNbVp6?=
 =?us-ascii?Q?1Sfzar6HAp5mnhKRLC6mXasxpAP2fEFJwR4tmI+sOCNWs1PPxPCaSCSUDFRD?=
 =?us-ascii?Q?O09/2QFJrIcg6nOoS6E7xk1R/pbPi9yoS3Snzswm+aZA5JXj7bXm4Jh59KpL?=
 =?us-ascii?Q?/re2j4rD6QILKqod22kYfzqzhxuhOsrQKojmYTqot07neMhjXa29Jcusk39Q?=
 =?us-ascii?Q?OtwOWaKhcgQj+5HFwzEf8pAioOW99pCbri3WN7BURQX4MFXc/e/A1vaiZu2Y?=
 =?us-ascii?Q?9I11tGU8tVlPGi74mqlhJnoW0Sp7o56s7gK1gIWJwzC7gk/b2OWXlzDsC/mm?=
 =?us-ascii?Q?/53eqTg1Dl5TE8OLViMK7zRBk9a/CqIl8gki+86Ed41gvAZa901Vwj29uFUE?=
 =?us-ascii?Q?M+34K6N8UozTDRFYQ2Lx4GKmXkbWFrEAZCQ6ufzRJlYemv6jsYeswQEBARZN?=
 =?us-ascii?Q?ZH6S02KTHIL4mfD22rqhP82S3kbvL6gW0hvgKCp25VHDYcDK3lusL7u/87Ya?=
 =?us-ascii?Q?IZaHckJaRk4rQjBqktqs/P1KNlK2cD0nBqkDyjrVSa09MxOgWmC5/l4Zxsub?=
 =?us-ascii?Q?+qNgKRF0/6fmE+fXszMW6q1Crn0mNpzPnuDnaZG82pbGYY+o3J6lyon3zehN?=
 =?us-ascii?Q?NHVG8H0KnT+E1lz2Vcvvy5unUl018maNpkWjMTT+B/Wmul6/188yr3FMLUjT?=
 =?us-ascii?Q?uDy7sFIbYppdAf6UW/gNm8yVkd7JgmP407EL9ya/0GOVuhWV7WcFZxUqwX7O?=
 =?us-ascii?Q?CEJcwgM2wfk14nI8R5ueeUXi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e46f1e-0a2a-48ca-7d3c-08d8e55cb371
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 13:42:38.1727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B//oIENTssbes/lYlBZgX872hNn2svXOYyzst912NFZkGkdUHzGk3mhwzMEuRT1nFsiZJq+nObCY8c54gsjdwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2754
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 10, 2021 5:39 AM
[...]
>=20
> -Each function is passed the device_data that was originally registered
> +Each function is passed the vdev that was originally registered
>  in the vfio_register_group_dev() call above.  This allows the bus driver
> -an easy place to store its opaque, private data.  The open/release
> +to obtain its private data using container_of().  The open/release

I think the is to let VFIO device drivers (e.g. vfio_pci driver) to obtain
its private data by using container_of instead of let the bus driver.
right?

Regards,
Yi Liu

