Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00B041BFF3
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 09:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbhI2HdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 03:33:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:4506 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhI2HdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 03:33:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="212134847"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="212134847"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 00:31:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="538713188"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Sep 2021 00:31:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 00:31:19 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 00:31:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 00:31:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 00:31:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/II652fmFcsE4Ub7jQgV0JKgT6i+pi8AB7bD875fFtfdo1+r1KYLw/oSitOUd2O+EyxIMfDP1FmyURDNn5UK5lFPkZV8qdekojazK2FKt5vZuVUCWmTonWbmrjNCG3+J2a28elQ0cGzb1vm96NaeYIyvQ2CG/Wf47D4oTuliRJZIt3KgrisaUwGYznMKcVXiZrxIVAJshg3ogP4JyWIirr8OEEvNd1Xw1uAAa5BQPssp2dBf8s/0Zh4FwbYRiacqr9GNUJgvFkuQ027aVLRyE2AhVclA0QHqOQpEqwlG3zUgYFD4R+GTt0xC2bZzbvBcXlH+EF9mivWb8mapQjfIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UUNRWvOwRddHjE5VFCfuv4MUPh5SRnnBC+Floa3KH+M=;
 b=mICbD/kuX+mb+EbOV6zmCrUnaW7JWhiMDgP5QZc/wU0G40CI9Yi1gKEpqE1WUglZk8YZ+oFJ5vK1BXMpdW0/3mo17eSwq1v5JiLioAw4LZ/69t9fMuq9ZsygLwCLOuHqGGsHAG21rK+1ggIWS8cuZ8z+2X65PnfLtTDfXnD2UJnC4padfeDnRX+TdNW2+h4BHijP0RpbE9yvEhynobnbECMmarH2K4LZKkgo3R/RwB2OFr1mPtUw5dXA94NDbz/l5SFWc023c/vz5+1ZJ9x3kDjIAudJS2RH9tmunSn0qOR0VN8elBK/hEuUeBITx0JeHwS08qa4R2Y5Vab8QbQb+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUNRWvOwRddHjE5VFCfuv4MUPh5SRnnBC+Floa3KH+M=;
 b=ca+3cXA7Ql2ANFR6DjNC8iqwmEbr/MpE7NB//q79MNsieTZ7CZi8kuPW/JN3yAzQARELq1Clkid89QY8YJfT2rHP2c0nz6LeqKM5gjuENGQiDte063MAs+dZGHqAAi5RngeAgbxkcXaYy6qfC8QK5er5mBRxdDufAfPXDwFRY2I=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 29 Sep
 2021 07:31:08 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 07:31:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2Edmau6gj6AgAAJv4CAABIXgIAADaYw
Date:   Wed, 29 Sep 2021 07:31:08 +0000
Message-ID: <BN9PR11MB54335B4BA1134B14E1408D358CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com> <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
In-Reply-To: <YVQJJ/ZlRoJbAt0+@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c08e964-6789-4e12-ef2c-08d9831b1ad9
x-ms-traffictypediagnostic: BN0PR11MB5709:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB57090B5444492A760F1D4B618CA99@BN0PR11MB5709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h5N/cr1nQodQXXL9TmlcY5nv8NzVS3q5Ydi3Oz+Ok0fVRFznE9tb/ILdxG+56UZMLxuV7nvjKMzGiNmRc9niHdjJs7Ppks87c9JKBtdO7Iy2Qvg1paw6O/b9OnKMQnm4dvcOkqqV54Wh7OXA0+ZTXUbul5kYDt35ilgUGPHboxh6vBGjsQVZeRAD/C9YE8nIL44G+q3cu8UZnVEoe+M3xr0CiWRwwtK4/rPclwgNn9pYq14T0eh+3Fx8ehQ9ER+K7wslDzYgM4tPRZaDfR8kUyElxEvEZwOuWvDco1eo1XAK08EII/cG7to6Jz+aamgNTADgAXwYVKufemHdzuJvWVNo+K9RaylqUkPjeBHfNXjLRuvQJL81WDJ+nZqdv4EzkSy4QGK2UkMg7VvqlUVjBvOB6hNG60EdPNhUuCMN49KDdFE+TZCvFstKkT2HBeUw/l5vTSSko8U0Sr65qKRedvJnh6G1h6kNtQRzXstQExXJwsNPdoPb8j03SL5gOl8f/tppmat//UU1Ydhxj6lLlIZlmQ+fLb4sF43KehqY032agxelw/RPoCW359p88+dCE9fch9LJL4G1JXqKieUY86fQ/i10M7FJLKF8EKst7KpM3mD86aYSorOua1tjJ+k0wSVnYJEQEVJOUv7UdTaPpzhBjtSo949X8ppfcBiHXpUmchn6KAp3oWIIRCM0n6+c+XZ+zuG9ZC4o20vPzl6dA9IyQS6M84wuNKHRSvLd4eKKofrlEDB12I//QBUgI8LAwe4ePzxocltVGINVwMMa4AIq0roHLe94DNssUUltq3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(2906002)(33656002)(26005)(9686003)(6506007)(83380400001)(186003)(66446008)(71200400001)(55016002)(8936002)(66946007)(52536014)(66476007)(66556008)(6916009)(64756008)(38100700002)(122000001)(5660300002)(76116006)(38070700005)(966005)(54906003)(7696005)(7416002)(4326008)(316002)(86362001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wwfti/r1ZuBpJ7zh4Nys6bmo9/ZO0U8yqYcj76Onu5ssB7+LMgqdNSsIsZJY?=
 =?us-ascii?Q?u002g8MSz7Hg5puAyfhJHv1+cI8YfUbWnNuqieyAFruJwi1OM0KAyNT5fWYL?=
 =?us-ascii?Q?jCx7Ofylwx8yywAa5eXCS46h4XPsp/vIpCJY0lTIN6z+tubH48ff4fVyz+Ul?=
 =?us-ascii?Q?iVnoNchh2HM9GY7VvPVo0Srkm1DYXZO/U/ehcxajDe4gzX3EY3aGcc8NYizG?=
 =?us-ascii?Q?dNfqZfXClyS7phzipwrMMphOnNSD5rZmh4Ayr0jhznOqHw4vecAlZ9thEO0o?=
 =?us-ascii?Q?GDme5JJ3UjwdL/hGxQ1EAeAsTF9ynVSjbSAvmlCwLv/HUAIRvJjpWMSNzs7Z?=
 =?us-ascii?Q?a2N6enTwqoV4ZXUURZANJ91lxzcF071PgIwix8BNlNNGwNVufZDd/Sv0sRq3?=
 =?us-ascii?Q?0Wh+vPPAG5DuyXylmx3129ohAoiqhZtYVS+JYUzWVQ7U1qQSGnhrzI7641U6?=
 =?us-ascii?Q?thUHA2L+pKMUi4XAP+qvGHyXM48u09vy88fzNUCXWItRErK8zhDjsB5a+Wzr?=
 =?us-ascii?Q?ssvrwQOWWxGmZk9JCx81lyhULyHPRGc+ubQJKbA48umPYTKxeil1ObkyAUEH?=
 =?us-ascii?Q?mLtjkpsi28q/S+bsj8e55SElLZJl5Z4hLt+UiGIrDvd+RmEkrathSDtCIqO1?=
 =?us-ascii?Q?8AiPhg6qauJhLMaWk2YqSkkj2dDl8OKceFDQEaYshOMJaNSotIzgtV9u6HDm?=
 =?us-ascii?Q?/7sKAFJX6EttD1LA6x6Gz0JhqQ9+jGN86WM3RVQSkDM6ACSseUQOaQYWSq7j?=
 =?us-ascii?Q?ZVpqnVfH7XfyBkhqYks24DjqxKa1o+I+kf51D9GZ+eadtmKmwCfup+MlF/fW?=
 =?us-ascii?Q?2KJNDXciErlMwV3OPpu+Vuy3qzjzaJprLiyqjAxanIIXQvVvgup0ZGhWseRc?=
 =?us-ascii?Q?KIiU3vZy2cYIHqU6iyHH0dLUmDPka0vMgsBjDQJexACJRV/mLGr70pKE7VdB?=
 =?us-ascii?Q?KLOEG+FIoQiY/Vh6SiU8GZ37n/dP/XNeRIv8rFbvXTtbSo/WYhVNuNICbdl2?=
 =?us-ascii?Q?PmDSPSKh06y9naiZyUZsKwTWAK7wJ/yLoF+wtuNKqpd/vPo37YEK+YSQJXcm?=
 =?us-ascii?Q?klOB/rM5Vr6yp0+DcR+9tSXoENU6KEMPNb6/WeXGQqTeAO86a30RbLqnR9l3?=
 =?us-ascii?Q?fag+bC9J/QDszm7+BK/JFIQKapGTMzuzCvPWdLbFK8oP4K9grAOBZGgj3OkY?=
 =?us-ascii?Q?+0dY3v8xZ5K+0anfa7nwn4CvkJICjLeqR+VieBlTA1OebXtCGq+GlQXzSPYF?=
 =?us-ascii?Q?IUSzamzt+rotXLIcAMWThjULM4nPtAIyFRX5FLW+sSPfOz6eJ33RhE1pjJVh?=
 =?us-ascii?Q?60+tz3Az6pWM137ZN8udOD7w?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c08e964-6789-4e12-ef2c-08d9831b1ad9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 07:31:08.6695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dxinozHndpLYswpcECCeHEVYLKSOZCHcJvzJG5Kri7fDJOb9BiKu4+jWgxsPMbLP+3sHkeEjOgMy6KWPA+3LDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Wednesday, September 29, 2021 2:35 PM
>=20
> On Wed, Sep 29, 2021 at 05:38:56AM +0000, Tian, Kevin wrote:
> > > From: David Gibson <david@gibson.dropbear.id.au>
> > > Sent: Wednesday, September 29, 2021 12:56 PM
> > >
> > > >
> > > > Unlike vfio, iommufd adopts a device-centric design with all group
> > > > logistics hidden behind the fd. Binding a device to iommufd serves
> > > > as the contract to get security context established (and vice versa
> > > > for unbinding). One additional requirement in iommufd is to manage
> the
> > > > switch between multiple security contexts due to decoupled
> bind/attach:
> > > >
> > > > 1)  Open a device in "/dev/vfio/devices" with user access blocked;
> > >
> > > Probably worth clarifying that (1) must happen for *all* devices in
> > > the group before (2) happens for any device in the group.
> >
> > No. User access is naturally blocked for other devices as long as they
> > are not opened yet.
>=20
> Uh... my point is that everything in the group has to be removed from
> regular kernel drivers before we reach step (2).  Is the plan that you
> must do that before you can even open them?  That's a reasonable
> choice, but then I think you should show that step in this description
> as well.

Agree. I think below proposal can meet above requirement and ensure
it's not broken in the whole process when the group is operated by the
userspace:

https://lore.kernel.org/kvm/20210928140712.GL964074@nvidia.com/

and definitely an updated description will be provided when sending out
the new proposal.

>=20
> > > > 2)  Bind the device to an iommufd with an initial security context
> > > >     (an empty iommu domain which blocks dma) established for its
> > > >     group, with user access unblocked;
> > > >
> > > > 3)  Attach the device to a user-specified ioasid (shared by all dev=
ices
> > > >     attached to this ioasid). Before attaching, the device should b=
e first
> > > >     detached from the initial context;
> > >
> > > So, this step can implicitly but observably change the behaviour for
> > > other devices in the group as well.  I don't love that kind of
> > > difficult to predict side effect, which is why I'm *still* not totall=
y
> > > convinced by the device-centric model.
> >
> > which side-effect is predicted here? The user anyway needs to be
> > aware of such group restriction regardless whether it uses group
> > or nongroup interface.
>=20
> Yes, exactly.  And with a group interface it's obvious it has to
> understand it.  With the non-group interface, you can get to this
> stage in ignorance of groups.  It will even work as long as you are
> lucky enough only to try with singleton-group devices.  Then you try
> it with two devices in the one group and doing (3) on device A will
> implicitly change the DMA environment of device B.

for non-group we can also document it obviously in uAPI that the user
must understand group restriction and violating it will get failure
when attaching to different IOAS's for devices in the same group.

Thanks
Kevin
