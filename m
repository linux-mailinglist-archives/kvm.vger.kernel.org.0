Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C082415382
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 00:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhIVWgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 18:36:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:15792 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhIVWgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 18:36:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="210796382"
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="210796382"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 15:34:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="474861602"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 15:34:44 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 15:34:44 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 15:34:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 15:34:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 15:34:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkvLIfHPrQmkBU+NibtZDINwqllSn3/ktets2ysS7JNTxPoDORm1aRwAk4/WhcKzdJPFDKnM98dBPZN7M4vxijZa015ZQjEcyA1fz7ntSX6rrMsOChbEAlzFiIWrt2tcL9koBVfYg7Snh2bqZB9MIXjaH3A9pbjCcBq5/MAF/ghTvOOCGLV2Dkczh14iSbgndwYzXsqBF8sF1G9rKn/BjN2UFbEcFn8Zxr6C2Fje0vEKMu8I7lEnAw8WD3urJnurGoq1Kk1aFIsoVrVLKOAImspO+XxR5JJWTH5VcuIAyYMGDO9NN+ejUgqQ9QxU9RIC6hAVjqVeXOcOKlybSifIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w/75khrrynZ5IBbgDAOesqE9d1ME4zTDkoRBF8ZUuLs=;
 b=U/0ZcQVlqNajt04of2ftOBq+LunjM+P9rbMHzciQClNdDlWc4swN3LQOMGnGdPuG5S9Y25wahLFAvsKkY9OnMowFZCCqkfNCf/b8Van83A3iz9Eqr3sTjgFe6JPlphGk8eI5IsxP7uc6BiYib8sJbiHNk9pN8x/bAOqfTRy3+lRsiTwaoZWkjSFieQJivm5IG8N+EASxMHWP+fPd5SbkY3hW0CDFDcJjlw9uTWepdgkj8R2d0TEU+qZG8KthlH4GfFzjCJoP+fxSVtSy91yvpvR/ib1do3oeVCdEm8vra598Q/cypXO3ZUGsdVvxxmiM8k25dbTKBaI37ISyhKuDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/75khrrynZ5IBbgDAOesqE9d1ME4zTDkoRBF8ZUuLs=;
 b=VbBZZJEIIXXFvHTO7aiJ/mEGelQd/eBwnrVbMX+E9BhnwnOYbSJWfA1t5x2D9l3p/VZEXGpRk9szZ0SIMY3xDvrMwwFECS6Edc1n8/OhempYmsnogiiM6Y3Se3684g4GebGpsT8ScdOjLjhsvV43cLUmGvWN9wEKaCN9CcXP82o=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1537.namprd11.prod.outlook.com (2603:10b6:405:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 22:34:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 22:34:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFCAAB2WgIAAjDNwgAA0YACAAIKvAIAAJpDg
Date:   Wed, 22 Sep 2021 22:34:42 +0000
Message-ID: <BN9PR11MB543366158EA87572902EFF5E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-4-yi.l.liu@intel.com>
        <20210921160108.GO327412@nvidia.com>
        <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922005337.GC327412@nvidia.com>
        <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922122252.GG327412@nvidia.com>
 <20210922141036.5cd46b2b.alex.williamson@redhat.com>
In-Reply-To: <20210922141036.5cd46b2b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec6faf97-c456-40c7-0cdc-08d97e192bf0
x-ms-traffictypediagnostic: BN6PR11MB1537:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB15372D87C97DE809014BB6118CA29@BN6PR11MB1537.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vPsUzWgKvA0O1fOZrz5J6/xaPPY6pi3aTJuq/3W3eM4xch4RbFV11uX+mcQ7uJIUTd8ubb05r5KbRk1ZYCWKdGCtciCQUMj9RWIimItP31zKI8+pvQ3ZG1yIrhCUm74tvSRDcnymkm5bdUj3IyzaHWKV+OT84PNvY8wneBVV+nGnqZbu/SSUcjXL3j0x9raKrXyzFclN5BKcCiLpmOj0hvryQY/IPYRlXxOkPBk2pK62L1oeQWLwMzdSTWwN0UNa6T7KziantRYkPZcQtJBiU1pK4kSb+TOtQC4hN2vBYeM/9wYILLSmwydyFEk1t0rHqjjwUeF3HK5NyxAtF8LBaSlBJ8XwykZA9tBKnB1lQET2bM/vwn2428w4g2zY+d5rkNtYbxtHyaPP7OgJfASlcxYVJQ4AK9idE5J5H2ZdU2l7k+dHl0IXnw7xWIqnu71mGwXSO2X4BHqVX7bjXb5UfJHcW2cBxxFFNMP5AdF3Kqs8Nj67tB4WJh+dZKc9oWkTE2X05mWUwckuwRURMGY3zGVM5enXA0yP//tw86ENcScwaM8ETy4B7ghFSBoQDWmRv55mHWd5rnD8IB1KgO45+Vvdcyuu+C2sRV9yjtj9IaGtm/5iXZsvo/bs2k6lv0L/BX1hUZHh82nqGTLkO8ZpNr+ucCpvqKsR+S7AGuU/6uTKOW8+slXrvRj822u5wHO4qWKJmY6OFsJq2rkrDLBYqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(7416002)(76116006)(26005)(8936002)(122000001)(186003)(7696005)(33656002)(4326008)(508600001)(38070700005)(9686003)(316002)(6506007)(66446008)(66476007)(64756008)(86362001)(66556008)(38100700002)(55016002)(8676002)(110136005)(52536014)(5660300002)(66946007)(71200400001)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RsaHJw3uLolBUtUj4Fd9MAnpcxnOkK9qREJL/E/F/3JeJ9OGNZQeshldR/Mx?=
 =?us-ascii?Q?QZ332jvnDq8elS7YusR6c8iHvjbYQYSdl448F4JSXZz0tdAdF5IhY2PkIKuY?=
 =?us-ascii?Q?blYyjWpD0rrtLpQWseym8D5Mu79WMc0t7KGf7u+0BbwAk66XEVeNwHBGsTyP?=
 =?us-ascii?Q?UjlTdpDZRUCAJNhJ+/cMcKn9NeSgbSeQf6dGC9WIILHadXdxemUjlZ6QscYT?=
 =?us-ascii?Q?yN8g5IT3iH0/EmIXonpaXZvd1RrBXS71ho3hLezxfMrOxf8v07NY4WndSRMK?=
 =?us-ascii?Q?++QCQxC8EA8T1BaSNUUv4v+i4NV3MNcSegCrqH0YzbM9Q4/KsYyETEfc3ts+?=
 =?us-ascii?Q?H2j1ovub0HMR4bYJkE9uElqOLv7T9kgJBZLETkqkCtf6ukhFSIwefW7dTuYN?=
 =?us-ascii?Q?eJi01PM2EqJun8NS/NHj4Q7txcKgaSxMwCIyLcRmUVCAhK2qAsZDBy2YVZQ/?=
 =?us-ascii?Q?mLwqowvQvrgQT8iOiBfX/xoOd0zYBCkuAxBmygrQdEi9KBHjTPm5UfzAMpVG?=
 =?us-ascii?Q?efgJ4FpL3c3hEtCHoeYWV5/FHrEiFo+aHTt0QsZ4kqyzr7pBJ3fPML4tfe/h?=
 =?us-ascii?Q?Bz09RIar2XMd040k5TEsuXdBQfsZW+k6JMjX0ydocxVITZ+OskvI5XE9o2aX?=
 =?us-ascii?Q?Zjfedak2mn01GPItjfRR3btCf0aB0EthowRIsjHFA00GB7yDROsTzwSq4vEC?=
 =?us-ascii?Q?n9MzTFaqHq9LaCPBIn+i3soGmUA6ayFw3r4OzqGCPjsgeamLqeFZCs0oc0zM?=
 =?us-ascii?Q?t6VlUJZTP8V2R3x1kmnRMwrGfxNqjJWSI03Pcnen/280QDeZTpcbnOyPQ9Bo?=
 =?us-ascii?Q?y1hbbXVP/NmnoY4/jlBhTgLVQrWQho3T2bKGTMgnqDMr0+cyoF5PlpR5H5gO?=
 =?us-ascii?Q?QL9MmmYIAM23OrCpf/tV7rDqIxeReC6gtW9pPhAka6W3zfybJhB4nJj/5vud?=
 =?us-ascii?Q?TQODLSnw37nFBrUOy9VOTLOP/QSEIg9ZkdlmTMZwkzN5XFf4y9O4sCtGv57h?=
 =?us-ascii?Q?XV38tAoGmbKzJUuTn2LSBm7ANxEUaCjnw+uRJElKx7xQk1R+va6UgbPESPq/?=
 =?us-ascii?Q?cEpFUL5coBSxCiDyeOG58PQ153dgY04IADu0600Y4QJDulQi0jMQ4Pt/DoIW?=
 =?us-ascii?Q?1e0R+I1du9QWBHguDoPrHoRpIQxuWLqiT1mHTgDEzqSNBz2EH2faEPe50qmH?=
 =?us-ascii?Q?aGVe91oPrOehtheo5RUK3L9yfPehBTI4gd4bdOD+UUuDGRhVenJ+i066uw4a?=
 =?us-ascii?Q?J5CRavRI69k7bnDXdJlpmisdnc/fq0BKQK7URraWblRpRqYCCrk06pvKQs3w?=
 =?us-ascii?Q?7aUkiakAWhoWjaXu0ZoRTzUq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6faf97-c456-40c7-0cdc-08d97e192bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 22:34:42.4238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dOSzTg2AJQ1SV3lMf0Ib/3pJVcwipJyuPExwrqs55h//77gun8ZfP+r3w2UwedTpWtOjwczQd9jO+hF8oMHRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1537
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, September 23, 2021 4:11 AM
>=20
> On Wed, 22 Sep 2021 09:22:52 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Sep 22, 2021 at 09:23:34AM +0000, Tian, Kevin wrote:
> >
> > > > Providing an ioctl to bind to a normal VFIO container or group migh=
t
> > > > allow a reasonable fallback in userspace..
> > >
> > > I didn't get this point though. An error in binding already allows th=
e
> > > user to fall back to the group path. Why do we need introduce another
> > > ioctl to explicitly bind to container via the nongroup interface?
> >
> > New userspace still needs a fallback path if it hits the 'try and
> > fail'. Keeping the device FD open and just using a different ioctl to
> > bind to a container/group FD, which new userspace can then obtain as a
> > fallback, might be OK.
> >
> > Hard to see without going through the qemu parts, so maybe just keep
> > it in mind
>=20
> If we assume that the container/group/device interface is essentially
> deprecated once we have iommufd, it doesn't make a lot of sense to me
> to tack on a container/device interface just so userspace can avoid
> reverting to the fully legacy interface.
>=20
> But why would we create vfio device interface files at all if they
> can't work?  I'm not really on board with creating a try-and-fail
> interface for a mechanism that cannot work for a given device.  The
> existence of the device interface should indicate that it's supported.
> Thanks,
>=20

Now it's a try-and-fail model even for devices which support iommufd.
Per Jason's suggestion, a device is always opened with a parked fops
which supports only bind. Binding serves as the contract for handling
exclusive ownership on a device and switching to normal fops if
succeed. So the user has to try-and-fail in case multiple threads attempt=20
to open a same device. Device which doesn't support iommufd is not
different, except binding request 100% fails (due to missing .bind_iommufd
in kernel driver).

Thanks
Kevin
