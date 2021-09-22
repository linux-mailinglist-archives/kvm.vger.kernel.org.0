Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054E1414AF7
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhIVNq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:46:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:19237 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231758AbhIVNq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:46:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223626494"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="223626494"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 06:45:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="435438093"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2021 06:45:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 06:45:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 06:45:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 06:45:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBCETkU7hoHxdC1kCq+9IK024sYAazalC0+AzHQTMGRT9yT4CPS4A0i9qpT5WAYBmSr+huzgY6lSEvEbir7OFatCAE8D2KobRwrkNRZVzyKpLYl9pAHmdC1pW5S1/zRrYcitcLiKDkDR5zriMSEeJCv/K1vKCdHt13DscasU3XONEAVpyAnuxtPt8psKGZ35vUul7tfJ4XNDdHQJmLjwLqWu5NkLrJm1DUc4nWvbIrjJNdgWBNBqpXzBUar+MUeeCGMurz/hdCQcmgTqWvF8Y8tmTw7w4PGSp6VV4O50wqEn6U1KEX6ejR33/2J/QW/b4C9Es6U+Q6MhPnY4g+7ONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CFWENkVdWUP6oyCpxmVbNE8wqsKnrA5UdC2QxJwC+EA=;
 b=jSGA6Vyrvtq/d1lZi/6CUIOwat1g4QYjHgbxDx3/eGtmWmt4jNgSdAzLLwefYAZkJdOVPPW3MYnppydiBmmK/WMZg1smUeqIsYahPz+5wHk7A4IkZqqb1GrbV0FE+yGXvSz6UmRUHsZi5XJHEIDAZtFyzUFGpPPlESek6VUF1EnaRmjXtxbO3ZoRBZMR0LLQzBSpvBLrb5ljV5DNrJCp/9NJ0a0MAxFO4dzjjGMvdpMmOI0i+NLJuoKVtsHJHASzDCvqXwoLWBpBBnpzC7yIhDeXImO22akVTgXYDr3DES520gBgKptohx9GMI7KeepmDzkZ+QOm5fl0jJ7peKIKIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFWENkVdWUP6oyCpxmVbNE8wqsKnrA5UdC2QxJwC+EA=;
 b=QznSQM5DBRWyOvam11fmu6Ky26Bja6SFM123vVewh5SKRUWs9Y0+PUODw54Xcx7HuAmlLXShmKRwloAMiR3r/SGvSfTLndaqNontGWz4y/XuudjiTGdL9sxIbfnsZiD7r/BtXOvOdF9YNgdptgVHvqY9JwM1oMmGtzWwPS7ZuJU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5500.namprd11.prod.outlook.com (2603:10b6:408:105::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 13:44:56 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 13:44:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFCAAB2WgIAAjDNwgAA0YACAABbJgA==
Date:   Wed, 22 Sep 2021 13:44:55 +0000
Message-ID: <BN9PR11MB54338CA90323E2A15A8536CF8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005337.GC327412@nvidia.com>
 <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922122252.GG327412@nvidia.com>
In-Reply-To: <20210922122252.GG327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ef3f1a0-f0e1-4c9d-2242-08d97dcf29c3
x-ms-traffictypediagnostic: BN9PR11MB5500:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB5500716A8082DA2CA4CBD6328CA29@BN9PR11MB5500.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s52EI1VDLiHrjgdi6sKJVvtutISg0YZWrL5r/MuoCP9hxLolZLe7rZnrs7tZvW8ARmGGbfwajLSqGHKTcpGgyg2rY01lMgpojAQnIdP6XnxpNufDqyTObFVPf8Q9xSsfqFLkLDca5CIg5JHUjADwduaa5u3lAWfkHlME29Kgeux1KxfM4zW0c963uabWvxIj4I1TsohQhQX03nQqTVMepRWCT6IgagICaH+t7JjXG0Fga3uki6e2DzVRNMsPrvsyED8IJWQUj/5BMIX/syhm5P0xZs4aVpqBk8te1PD6onWUKJssClEJedhFUI8JDhBJf2c97doWmcWCYR5IGKC7vQyWEYBxY+0tRJCp2aDSEmZnfm6dH5K0PdG6ESM5odrWhrflzkpjXSf5ArVcsLkFuqxi3M8LXBTBnK+Hd8pW2aAMyS5WKv5TImj+SlAZnqx6RMfdGkiQhIAVU8jcm9kFo9bUyam1wrO5In2YAtYaIShDdpWPcjfe43FhVs5W2294LPZ/+PlKBaaNywLHhJZ08FdnNktfOOYiB52+k4rej4kCL7D5nAsqWIz+WU6PHwjAY+zJV6TxLZF0fZg6bpydYE1i/0ucrhe9PNZiVGmlPlEXnD/foTOyy2YWSrw8IQOX0DB2G0SHNyvVUncDm+5UdvzNPz6t8ekTHPkdWT29kPyB0nSabhnS185QNup3Uo24ZAayeMZmF9WGNvMm72u7jA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(71200400001)(66476007)(55016002)(6506007)(9686003)(86362001)(8936002)(2906002)(122000001)(66946007)(38070700005)(7416002)(8676002)(7696005)(316002)(6916009)(54906003)(33656002)(4744005)(508600001)(26005)(52536014)(66556008)(4326008)(5660300002)(66446008)(76116006)(64756008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V7ohxXENqE5LdfO6IRfELZBVO2f2mi+IlCBoBrfMoVGiEvEuatcCH8is8BxT?=
 =?us-ascii?Q?DjZMvpvWHkw+Hmkj3AJ4dDLAuJ0p/Q0TsNb96koapWbx5wFaB2MTnsDULE+O?=
 =?us-ascii?Q?/KSu/iz4C1a9WoweJK2lnP5NvI8rIUeSrChHV5YTg36tc7Kb8DNQ9M1mU03u?=
 =?us-ascii?Q?X8mTJ5bcSvxFG9oWs6NpSm/IipOMhZxs+4TpLQ3QMPslowUecmmHNl0t8teM?=
 =?us-ascii?Q?0WZwYgS9AqrYUESCnfsCMFOetoAr7St+xOAPLxlr/Oox7khlO892xmgATIHB?=
 =?us-ascii?Q?V++SCG6XX1Xo0/tH9q+5QBTjC+8SyrYNhR1HdzZHlDb/KQYT3LhgY4AfmOT2?=
 =?us-ascii?Q?5LMUp8f5T3wpRtCs6iy2M7avDPJQ0RWn/bwuoBIirTVk4xtiSOm+4o0nysKF?=
 =?us-ascii?Q?YsUqlxRMwjPZBQxquTnM+Hj/whhgcPQcg5Tn7puygb2D6OGV36tWh8Cv+kcL?=
 =?us-ascii?Q?N0d36WTCoICjBoAU80MCn+MrcisLTvO6099U0z7lVzvHSzLhrccoty+keX1u?=
 =?us-ascii?Q?Vb5z2+cSlKayKPj7MUNlCmUNlrl+Y+m4SXm5dnbantjhdeY9hJ2aHWKu6U1o?=
 =?us-ascii?Q?XEbjtn6roUNTNe1Uy3/sT85eAlZ1GrRL6sKDPw8RPWe6NHo2u6YUnHA3qzwp?=
 =?us-ascii?Q?FDm2KaIS3+v0WzyBaczfs6ZUa9co71whs+ptTc5jY/7wMuM30Kc7ERyqsfPl?=
 =?us-ascii?Q?50wfE140rWPUp0u8fGIWxxjEsSFdDGrIF9L5Io3gjClrqJaBZv5qwqczYp+7?=
 =?us-ascii?Q?Ow/bwnIjnI/t8atXGzR0OXGEYY3gToSj7waJJv/oZ5BOI+h7zmat28x+h3Kp?=
 =?us-ascii?Q?K95ng42MCzY987k8U+sfP4RbaBcsPL3RoRyeakM5jWurHvht0ix+7h7mTAJ+?=
 =?us-ascii?Q?RfTroGthWtma8roNxfK7E/Zw81mS0w1LR2Obi5KAN55DObAhlY8R9vZSGEtS?=
 =?us-ascii?Q?oYxtEjDHVimzM8cZBOAgxcodPAA5n3pKyBl3ypVSI65E+Vb9tiLh1YesvXco?=
 =?us-ascii?Q?TFUB9+m9u1N4e/ffY29KSTQVJ/c+oPHeEfhtIVm19hsTlkzeUfq7yUA1M8eO?=
 =?us-ascii?Q?+7mPAsZqiieKzgU835UyJ9zDwBfqHND1gc56zVMa5L5RbKZ7n7/raVxIL64r?=
 =?us-ascii?Q?xUPqGLtfqXhfojzA5y7FYeaiATUoNReqPLtNtxo2C9c7r+G1ZWw6x9H9Y47+?=
 =?us-ascii?Q?Zrk4KH1Eom1x+diY2WGXMil9UaZdKyWmtvDcj6VVzl3esqtbj4HLag7v9GRU?=
 =?us-ascii?Q?HEmL1rJY1z1U6xXyLkAL0f+UWBWUKaLcbnv/GQhYSVMq/Rct9NL9NvTCsA62?=
 =?us-ascii?Q?V5NPL+qZcoNG11vPDs/iyCkZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef3f1a0-f0e1-4c9d-2242-08d97dcf29c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 13:44:55.9901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 12tGWQHWnggEeE5vFNDLkxqxgFTdKnu5zEOtWeENFmUDs0TrnQlvpJmikK1FuPF3IztOlKsfGTx0DMiwsFzeOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5500
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:23 PM
>=20
> On Wed, Sep 22, 2021 at 09:23:34AM +0000, Tian, Kevin wrote:
>=20
> > > Providing an ioctl to bind to a normal VFIO container or group might
> > > allow a reasonable fallback in userspace..
> >
> > I didn't get this point though. An error in binding already allows the
> > user to fall back to the group path. Why do we need introduce another
> > ioctl to explicitly bind to container via the nongroup interface?
>=20
> New userspace still needs a fallback path if it hits the 'try and
> fail'. Keeping the device FD open and just using a different ioctl to
> bind to a container/group FD, which new userspace can then obtain as a
> fallback, might be OK.
>=20
> Hard to see without going through the qemu parts, so maybe just keep
> it in mind
>=20

sure. will figure it out when working on the qemu part.
