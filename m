Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD33239C3D2
	for <lists+kvm@lfdr.de>; Sat,  5 Jun 2021 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFDXWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 19:22:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:57428 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhFDXWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 19:22:46 -0400
IronPort-SDR: yce0nPZsNITtuwoxvjkPGUPYq8lX4gEDq/rgMk2/B1DFhdJD/PLcU7FKN3P4cDr3lpsE8tq6/T
 ju/EnKcmIuTA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="201366989"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="201366989"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 16:20:59 -0700
IronPort-SDR: uCv16skNuKCvjIdV83BftJ4S6Oh1AxbTvv4wnS0F0ZEotd0Lsh0gT/uRbzvmlijDZC6mbesRkg
 ZBfQDPt5988g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="480811135"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2021 16:20:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 16:20:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 16:20:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 16:20:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 16:20:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVIo88tLd3FM+iWvCSeviSEDbfcyAihh6gFP0qLofByU4TOC46sqA1Xb8y8ET9+tOii+fdRlHFBVgkRQPDggsvvGzoMN3fzNhYp7RbpkvBoqpfXf77UxtzsaFJe4JlMHkCnNwh/wMkzTSvDNsrkZ3lsDP8/XHDnv6qgRNFkPoRIJ4jUtG0FPcFSuI3MRzEMfoUZJstBEsCrXpGry9R75L/GRFwejgjkaI1sCziEgOzK7tK4slFfmTd4hLNW0TCWRSu2AZpL9zgGr5JnWp7e5mg/lNaHWWTGG+622p9RHKkrdnYT5I03+v2Y/zOJ4cOaasrhd5UOD7wwzS4qN8ZnmXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+7s77UCsoFuK6BKo4irwWUflkrN8p4xiiPMcO52ZPQ=;
 b=QXbv4A6CTqZDWlL3nMIV+kd7BMaB1J0Er4INzs8nFXguYT6Nq1J4HXDPTuY25RIpJdVFh2ruDybcghEyeAamp0pLj23lN1bU+sxtR0Np5Czm1m/0GGqUkVuE42zY5nmyZawj9qaLZeS2MIk6jc5EgihRq3OFuC29C/X1DXQTsayF6MAX2/7lXu9FCA6BY2+nY+uEUEV1JTwmcXzRoPKQBg9kQSw9oZCS9lGywj/YzmdhieQiC/xL4PzL0ftLQUTgMIE/NVmD5gubfhIbliJzMrK06zKiUE0s8ETOctJKRqmMq5mkmVVfMAmKJf10AEm/k1HxpUvQv0TvM1uj+eKd4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+7s77UCsoFuK6BKo4irwWUflkrN8p4xiiPMcO52ZPQ=;
 b=QKeQXDGW1cKHVF5lA3SJVQx1iIY/AaKIFNg60hic5z7rcDp0nmJT4mYDTItWvuTrzKVFev4NoJnxop+FVfBkSyvD6IrEfDuDMb2QCLySX0YaMIiFs+CkKXBHXom41m15iQLQDdRZFfN9rE91owa4yfstg0biM/smXfz0qnVQZHs=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4963.namprd11.prod.outlook.com (2603:10b6:303:91::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 23:20:52 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 23:20:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBLsqGAAN/dRYAAFU5FAAAaxTKAAA16g4AAJNcEoAAOP0kAABZg9PA=
Date:   Fri, 4 Jun 2021 23:20:52 +0000
Message-ID: <MWHPR11MB18861497FDDCCDD48563517B8C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com> <YLcpw5Kx61L7TVmR@yekko>
 <20210602165838.GA1002214@nvidia.com> <YLhsZRc72aIMZajz@yekko>
 <20210603121105.GR1002214@nvidia.com>
 <MWHPR11MB18860FD2BA740E11B3A6B2B58C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604123352.GM1002214@nvidia.com>
In-Reply-To: <20210604123352.GM1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 585e4d6b-818d-4172-779a-08d927af65a2
x-ms-traffictypediagnostic: CO1PR11MB4963:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4963D1E7502D78F639839DEB8C3B9@CO1PR11MB4963.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GFg9nPdV+pb6XqD2fLa2MRlXJp/3snmw++K87gavL+9aT6FPdLc9nOL4dmN/mjrSl6Ad8lRh0sbz07Ik4M78riL6oNzwRrqjNx/wLtD/3vE1NWEuDLGjJsAB2Ys36WJUmrIk6t+CP1dpwr8xsPjQDO/KLGkeRTJCSQcvv048LiDpz4BHdKHbIhHgcaAt/Iv2Wk/ljLSYSHZnq1Vj/xLw5ONVClZoW5nP/IJljAq2QGoGNoBXaMYg9wAqMBz1kCzUpHrUhG5eq44jJ/P30fQqWsYoTQRMU45jwvrkDKYtRZ72VaVdIUEMgqn867cHhxvjjmnkDZ30SsOoQTqmUx/q58rgs+iSbgRNAGIIiqh9yB5ZfUNHo9GKXU2SNgCB2D5q499Nrfi7ApvpWxDl+7e8/vZwW5DnI4NDEjN1V4mBgNaOBfBMjHJsYgURpmsIedjTNyayLir/CiI/7+GNOuwemP1afgKon3N3eojhJyqhip3P/PnrZcnSEao26VioaW3C3aiTfgMI+AVDEAjx3TQD3fW5HkE0GMdAiOMLTpJwkWaQrEaQvO2CKRUe3jMrQdPD8p7kqdUXlnL1vu2XwZhVqW0MojOshbdBx0FZpL4PCkM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(55016002)(54906003)(316002)(7696005)(86362001)(9686003)(38100700002)(71200400001)(122000001)(6916009)(478600001)(186003)(26005)(6506007)(76116006)(66946007)(2906002)(66556008)(64756008)(66446008)(5660300002)(33656002)(66476007)(8676002)(7416002)(83380400001)(8936002)(52536014)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8cFtl1uGnZZdgt+RaqrnX8dhGYr31KvlMzkwg6F2yCK9kYUFwH+iZhkd07zv?=
 =?us-ascii?Q?/rDjKTSY7JG2Ho6MPRS9zzb8IPyCbrXny87l6QCygJLJbIEq0Y3h9yUzX3+n?=
 =?us-ascii?Q?T+p7Gs2+LGWuzrGTsF1tZxvORwCaL9q/c1w9Pd9om19IlsumGm5aHZ9xz0O0?=
 =?us-ascii?Q?0PVQ26tbvOGs5b30ymku/8yn5RthMvvu2GeNYpVNHyJkAvwOqC16ltShvZX2?=
 =?us-ascii?Q?ETWzsfrrOMB9hJGvE4tOL1waEhxS3U1mj5MHPaTkRxpxQcoxHqhnAGUNUoSf?=
 =?us-ascii?Q?aVk4PZAHX5EseZqCzlg0XnnlNDcmqCtDPZO9tFawWvB7mOCPg/YPQpy9CbzR?=
 =?us-ascii?Q?uxEuN+Sp9qOKEE4KwskO9iUrW5ajJAsYOt4IEPcI+SNxu+Ydi9e58Gic1pWT?=
 =?us-ascii?Q?0n8xt+eqIkIpYenp2GVB4TWEXKWKaZaTTtdaSjvoLaJfQGpZN046IAephdD6?=
 =?us-ascii?Q?aIyweW+halBbjet2XH10oJ/UL8r/RM3aFKMHLPjOAzd4UL93em8rAwOGj0f/?=
 =?us-ascii?Q?OIsJr+a58vDTOZXnj7MIjXp6zeeqJyvWgwvQAcuhg0NFf289dBeOXJUBT6e8?=
 =?us-ascii?Q?hW+1GMM1iXeFslPeH9y8yx/lrub6k4b6Ip+kB3c77TGGtq/fCo5868QBDV3d?=
 =?us-ascii?Q?8/ZYFBYf8poQ6IHtWxsCeTXTe3d4vmrUZIILMcDgI9DjUUCHweVN+KjZOKIJ?=
 =?us-ascii?Q?pGC5v8evlUCM/2jDfYaZFoX5DJCytC5HzoTdw/KmFBywxq6+P23E+N/OAASx?=
 =?us-ascii?Q?vBPWSLh8OmSlU8ueprQY9L4xtkMsbXCd77S8AfW065pdEdhqyK7FxOseGpnm?=
 =?us-ascii?Q?pHPnoKFcElnUFjYLYoYYYj1GFwVL4tZoZIvcMr8NQWcl7w0mrcmr/sXLdT0F?=
 =?us-ascii?Q?EjsK7/umpNuKsx9AVsvSgeL4blQQ4Talcg7bGPqsY1CNEYp/ALQMOuvMJ/Io?=
 =?us-ascii?Q?hMXkyAlH+d704f/O0cOr9bAryWSu7nOdNBLWyjx9dvdPhB+Ms/T3QjQbhNuv?=
 =?us-ascii?Q?lflZZpUw0MnGCf0DrUdwr7f9mWKvDgm+ZJmWVws5uxaGX6pt2cIXxZamuOpn?=
 =?us-ascii?Q?HvLR9LMzRDF18kjt2mbf/9rUgX7pLrNcZW8TOsTuZ9/qgrBj+NEefC1TMG2Y?=
 =?us-ascii?Q?Y8MeRopk80avIM//7CPW13qxkpd9ZeJXUY2J/cT3IhYZ3VtsgY36TapgGufj?=
 =?us-ascii?Q?9IpfKp23jZinTawXegctL1+kqd8Q9cl+Af/5JUcfz7/Mveob2SgOPSbSAsqC?=
 =?us-ascii?Q?4UlS/O7w+QQucGChxkRqXo5PBe4sWiHkqI+/UNcmOwOPLv5UHjIUuHEfTjHb?=
 =?us-ascii?Q?G5vZnm1lW9+LCw3a/3lYuT1l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585e4d6b-818d-4172-779a-08d927af65a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 23:20:52.6012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DCiY6+61kSyIVPruGOV666H+e8BkTtxbPdCmXONdKgtjV+fyMtsh6HXdDDJJZguZnu65XW13MEmEgjIrETHu0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4963
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, June 4, 2021 8:34 PM
>=20
> On Fri, Jun 04, 2021 at 06:08:28AM +0000, Tian, Kevin wrote:
>=20
> > In Qemu case the problem is that it doesn't know the list of devices
> > that will be attached to an IOASID when it's created. This is a guest-
> > side knowledge which is conveyed one device at a time to Qemu
> > though vIOMMU.
>=20
> At least for the guest side it is alot simpler because the vIOMMU
> being emulated will define nearly everything.
>=20
> qemu will just have to ask the kernel for whatever it is the guest is
> doing. If the kernel can't do it then qemu has to SW emulate.
>=20
> The no-snoop block may be the only thing that is under qemu's control
> because it is transparent to the guest.
>=20
> This will probably become clearer as people start to define what the
> get_info should return.
>=20

Sure. Just to clarify my comment that it is for " Perhaps creating an=20
IOASID should pass in a list of the device labels that the IOASID will=20
be used with". My point is that Qemu doesn't know this fact before
the guest completes binding page table to all relevant devices, while
IOASID must be created when the table is bound to first device. So
Qemu just needs to create IOASID with format that is required for the
current device. Incompatibility will be detected when attaching other
devices later.

Thanks
Kevin
