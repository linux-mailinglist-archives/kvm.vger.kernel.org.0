Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A57633E300
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 01:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhCQAry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 20:47:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:4072 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhCQArV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 20:47:21 -0400
IronPort-SDR: Cl/ImUSXVUv4oitL7BXVj5Fm3XQzMzp7gsRAUszsVhxJPGYW/tEpeA9MPM/vbsUdfSoeUmI4Am
 reHS+TKsg/zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="253375333"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="253375333"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 17:47:21 -0700
IronPort-SDR: FjR5RccgYns6fjupra4+m5e8/d+dwrbBmSfQctINlRkJdqzhWrYIXdFYv7ZI4DtvxtviMEFbiy
 M5GWGsdIG9uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="379068957"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 16 Mar 2021 17:47:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 17:47:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 17:47:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 17:47:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVDH9QHdXoHHciJyYHsuBkg9pDxhIIyLfeX9Lh9aM/lx6j2W9MM9L+a+wQf6wGV24sgxac4MkxgZSvqtu4YZGjYhhpyhtp07rfQxqKZRIZioTVqqt7EQzeIr1+kw+6RDsc6ziOE37bZpKrBOfh2LfmlRm0kpP5TcPp6NQGCubkr4tkS5ObA96vzuyOVQDXvvOF5tABkMgIfs+6V+0pXnr1D4IC1l/6V/uOKIK2NyghUfShtELF+kRVUm7cSrfAuqP2d5UiJtVlQw8oiPDvZBAOBxz9wY9NVzeFnYVWWLhPNtRBk5UtsZXTIfOk8wnqhgQPpTMYtLnszpAHo+f6e66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQ6d1Pv5vwV5y78Obymjmd7F+P8uI1PwKYoQG0HsjMg=;
 b=Rdr0d4dgRx7sTrbvRvwsb7qLMCx72FkPufrtJHTG9ETXjo2uwijt3IU51XnYXwPS9y+UCXK6/m2Txol4U48iXzcjfY45cZ3tRQNH+Xs5P8iNiwknzkTs/SzD2spoQVtjr4NfjEAVMcEXygFZasBvqjuwmFkNLTGxDErRNjyizlBXckMvx3BwVysks2Y8p/IZ8Nenm3EZGzq12cYdZw9s1aAW7ld/VYU03bg9N6NePA8P+FKinKes6pZjT0mpeylIMmFG0/POAzoLzsDy/JvnJTpqVNCtXAiZEvCT1fP887l3dzBSoh/Qtvlqbw4h/8gSNnbgnnGVbHL5TUPPrFt4xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQ6d1Pv5vwV5y78Obymjmd7F+P8uI1PwKYoQG0HsjMg=;
 b=O5IRI8yldvfmag/WbPqm1XjHL42Rmq3KrASGdX/7Oi35cURZ+MvvqElSqe+wD+fRmnmMTBwmdl3VexHDOPXob6S1jmWx5dj9Tf24ARsyGxTG4tUKJk51+xuSucUvynUXZd5wWxZB0IZM4I0H7rX2yIA0kOsimGtthAui/rI9f78=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR1101MB2174.namprd11.prod.outlook.com (2603:10b6:301:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 00:47:16 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.033; Wed, 17 Mar 2021
 00:47:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Tarun Gupta" <targupta@nvidia.com>
Subject: RE: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Thread-Topic: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
Thread-Index: AQHXF6P+5ZL3gouDMEucT8NEjICOD6qGOYzAgAEJgwCAABqS8A==
Date:   Wed, 17 Mar 2021 00:47:16 +0000
Message-ID: <MWHPR11MB1886F45D619CE701979D2A638C6A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB1886F207C3A002CA2FBBB21E8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210316230744.GB3799225@nvidia.com>
In-Reply-To: <20210316230744.GB3799225@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b648b2a1-1a54-4249-2ba4-08d8e8de3656
x-ms-traffictypediagnostic: MWHPR1101MB2174:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB21744DC92F4C3CADE9FFAFEE8C6A9@MWHPR1101MB2174.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgUeOPD6Q7y8dVWNm44I3YxkoBIYyJWEfTSdo9cEQIZdnJfLeWHOZyYxBFKAkrSEwFh11oVbJy+fX0a4ZrJrwr5xxzMcP/gmIDWx8d0gtuUD8JyfNR59da/7IehvUGgU3lGrk6Va8kJdBIg6nccMuTTmPkLWkYNOxkvzAFlUPtXutVTB6Xnekb5KY0CzmtXkfpt0EB6vStL+vz47Wfb0a85r3jXaZfJq/1fAnSUp6JrRkMPSEn6hSP9xMRwcd6y7Qakl/AXnDSikmIeYE7vyYF7IZ740uM2b8pNSJblHghZMVNUMaCTHW0IjgCWvhrf6a3qZThTEgC2SZ6UxMMuLXEcuOLrS9xwoWTe5A9nnLZoOxz7ew1e+qwRV4/GWc+z0YU+SMlc7QNL7dmlrw5vucc6yMm/foWjP0qYtJPZI4x93fdjjJ3Lkgy0NLwWDM0kKZfv7CyAxiv0/BOgDWxAYZzU4iialtHHrO+kxVEZFCtG6L25+HHcZwJHcR+dYjL6TuVw7IP3wvx587ozIV4UA1FToYRSnm4otIBHIWjnrJF3vMssaqQfn+Xn81TQLGng9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(366004)(136003)(8936002)(54906003)(26005)(6916009)(33656002)(7696005)(52536014)(5660300002)(2906002)(186003)(76116006)(6506007)(7416002)(66946007)(8676002)(83380400001)(316002)(478600001)(4326008)(9686003)(86362001)(66476007)(66556008)(71200400001)(55016002)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?w8Vqiolcgwp2DhrxY8P3FdITDZztmFz33pj7eFTIMvcHN8EsjwuLsCxXKywx?=
 =?us-ascii?Q?m0uwfH8sxHSa2rBYigImf7nNQtDnvRpona+RyH9ykaOayejcHml8lv1MNgTY?=
 =?us-ascii?Q?8G7yT3/zjCk3ocflPiwro0R23/tagG4caxMiHANc1uqXPgzYpXp0Z5v8caen?=
 =?us-ascii?Q?XnuwURdrkoqG3X9IDo7s0ECgYjCaEKpg4wqlXv0IUN2rEL9D5WXOkUhIN9US?=
 =?us-ascii?Q?RqHfulZzCEM7y8drwCf89FT/q9aWd5/GyCbmTHU6NdgyRoixnJFzAfYwL5xZ?=
 =?us-ascii?Q?iNU1esPkA9DzkMNhVXxGjpwVsW49zD0q0YkHpVo5P+LOQyARxerStPaGQt5b?=
 =?us-ascii?Q?CqP8JLuHBzeNiPwKBSW1Hyu8S//G+w9p+SopZmqDULhZ8EexbyoBkGxobMtq?=
 =?us-ascii?Q?EuwspVLjqTMIZBMe6+3W4nZL0M0sNYk1LDpibbuEl8LEjF2i15unRwNkPT08?=
 =?us-ascii?Q?VWvZSkYRTvcEs5xREm3uJsgA1K4tEFj5YPOMgdXflLLraPqHYoTPfRWl+oT/?=
 =?us-ascii?Q?ItxAtrgM2fI2PNQ/sIXbdnWvmBl2dDc4Yb2FbEIXJ5NNfsYbirw+ppm3qzy8?=
 =?us-ascii?Q?LN4S7KXvTm6yvyx9eYi1sRIKxTeyCbgysNwtKIslN0TteiPYtRffWuvBl7Xb?=
 =?us-ascii?Q?S0mXWxIdkYLkzhsISFYRjIooUx3WM2H+73uq5qnBLFv2BQdWB7olYa6RTghW?=
 =?us-ascii?Q?jAbtvOzQtekRxHCdj/Do4tp/PmN2HcXiYGrx8fwVozNAsSXYCU9hid4uRcxD?=
 =?us-ascii?Q?I+GcRo8sYe+Yq4Uv+Q36bGntK1Ou3hWKc8rX/QBpiAPvlQfRjS6sFb4KXTx+?=
 =?us-ascii?Q?OQ0iO+CiWXl0vx5VLLSF6nuaIQH319MzAM7qj3PyDLSVw7KCqix1U3JEJJ+n?=
 =?us-ascii?Q?Has/3XvKDFQ9JV2OijAB1ydSc8Xi/TipfB/mIw68NN3V0Xz6kAoeAbb0E5DJ?=
 =?us-ascii?Q?f8jx/GZNNHEJ1mwHHqXMeqpRznNiCiffna5yMqK8/b0TFiad3TIs1B2Yhkbl?=
 =?us-ascii?Q?2duEXBHStWI1/BMCVLhs6Nedg1eUIuf0cCpg6UetNDKxTmVxxmOuAn8T8vyT?=
 =?us-ascii?Q?NtR2fugRJybE+XRl3b/P+RsMh/v1O5NWoohrbITopBGiA4cUZ5c7dqbqrA2P?=
 =?us-ascii?Q?O4Nb1/ZMZH9kmklDAa1jS8vIMzy/oKsoRkflF9oextjCgJ4NAD1bVsbhDN2o?=
 =?us-ascii?Q?dY3c5IgOctcTKCYFgeNXV1P0ci9KBTs+Ah+dqbGADDcQyMDWIqFOnxfBW7Mp?=
 =?us-ascii?Q?TEhVt47X5UGlRgJDt7whIbkxte1ah0q6y74hJW7U5Y6HfhPh2p9RSVSro3Bw?=
 =?us-ascii?Q?u6dYtLFb1BsMhXrI2c1/cmYj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b648b2a1-1a54-4249-2ba4-08d8e8de3656
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 00:47:16.3706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEXNVXhz6XV9bRjWLgqtdQEe4kMp19zxqyPGJhMH/ceC32NphF29tk1DQ6uUw8l53Eewk3jVqlwBBGJs0kw6yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 17, 2021 7:08 AM
>=20
> On Tue, Mar 16, 2021 at 07:33:55AM +0000, Tian, Kevin wrote:
>=20
> > > It is tricky to see, but the get at the start of vfio_del_group_dev()=
 is
> > > actually pairing with the put hidden inside vfio_device_put() a few l=
ines
> > > below.
> >
> > I feel that the put inside vfio_device_put was meant to pair with the g=
et in
> > vfio_group_create_device before this patch is applied. Because
> vfio_device_
> > put may drop the last reference to the group, vfio_del_group_dev then
> > issues its own get to hold the reference until the put at the end of th=
e func.
>=20
> Here I am talking about how this patch removes 3 gets and 2 puts -
> which should be a red flag. The reason it is OK is because the 3rd
> extra removed get is paring with the put hidden inside another put.

Fine. We are just looking at it from different angles.

>=20
> > > @@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
> > >  	if (list_empty(&group->device_list))
> > >  		wait_event(group->container_q, !group->container);
> > >
> > > +	/* Matches the get in vfio_group_create_device() */
> >
> > There is no get there now.
>=20
> It is refering to this comment:
>=20
> /* Our reference on group is moved to the device */
>=20
> The get is a move in this case
>=20
> Later delete the function and this becomes perfectly clear
>=20

Looks above comment is not updated after vfio_group_create_device=20
is removed in patch03.

Thanks
Kevin
