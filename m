Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98217414B69
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbhIVOLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:11:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:16321 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232243AbhIVOLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:11:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="221713114"
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="221713114"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 07:09:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,314,1624345200"; 
   d="scan'208";a="550262464"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Sep 2021 07:09:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 07:09:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 07:09:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 07:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHBEmsJJEVXsmfjt6rJ/0nRv5YOlBh8ZjzgtNWycEZeTA62SUeia5SYW5j0E7h+Q0toYxbLyBldb8+UVBMmGnAYOGRg+QKMx4QIH1Vqt/EfiN8+mYA5SKt+ikePL+WiKBJWj0cR6/LEC0bJTkUUtCfsCdsY4gNhbYTecIMMTQbr3EM+RjyOS0eOf85FuidNRqJ//AVGxfIxaWjLLES1FOrdd8w1/3qnvol/qrEgSa92BRGKUWLkRPUkoupWrqdheOIPSzJY8nB4WbW3WMTJxE5t3fzLHVPUHaIYB2lHUIjEOQXHQIQRiveO5+Tb329WOjaBRNkzXa2rYyM+ozl2Keg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BTKxq6WIBzin634TGUkvtwgXa5ChPJhlvcgIPZgYaVk=;
 b=JwfJvNXdlgGG2XBapMn5ZloaKrtRjyg/4K1MR5qabqZPFHuTKqN8XtkRziLEr2RMQ4skOlB5f5E4cZz+llK9MNkclWNktkzd1op5omP5FhB3pv9mElZXBnu+LcCb0WZObxS7IeNMXyf/AFLmQvKb82CjD4SH6d5eYxpTg2IGKgtYpn/BYLa/VLMTaVZcUF/SiEAI9tObUFKdnCLF6r+Jf2dB6AwyWXEz4zNzBr/0O0++yzPgw+47gsZkHuFff4BR5dNi2NWeM8WS6pN6J+CSJCZ45mL0vE7ejLgj6+tw00p4RgLBLeq0Tf78y27U3fzSzoe4hecn42SUisWELdNkTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTKxq6WIBzin634TGUkvtwgXa5ChPJhlvcgIPZgYaVk=;
 b=H2LRvUh5r96WW+Ar8C7qXv5gsW7exjRMyUfYAWC9yuM7dUQMu9zR0+stmNToAh5MpGRTHNUNdPuw/JXKyROYTMUI4uMaYl2GcT6aNu4b5RprdPGMeXSzK1DQtRjb27+dJbjPz1gTv48F2fn1PVqIGonviUkP05lm0Ra1ur/N158=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1330.namprd11.prod.outlook.com (2603:10b6:404:4a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 14:09:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 14:09:42 +0000
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
Subject: RE: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Topic: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Index: AQHXrSFvz6zvm2xHBUaW/Kl+BWVvQauuqGKAgACCWyCAABPxgIAAAavwgAAWHBCAALA3gIAAE9Hg
Date:   Wed, 22 Sep 2021 14:09:42 +0000
Message-ID: <BN9PR11MB5433235312E0D0ADC97BD1448CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
 <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005501.GD327412@nvidia.com>
 <BN9PR11MB5433023B883A6EBDE8D80AC68CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922125049.GL327412@nvidia.com>
In-Reply-To: <20210922125049.GL327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78aedd9e-9cf7-488d-aec5-08d97dd29fe9
x-ms-traffictypediagnostic: BN6PR11MB1330:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1330E7D083F334A86C107D288CA29@BN6PR11MB1330.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: by7LziVgFxGL5Ha+9PGcOIG6XxJbvl4iBHcsfdxoWQz72I3dU/W98bAvWtJxYRA1balSNsweEF0tXOxbeN+Rou3XmHekhaZ+sDpkswJIbNILoIFyIzYyI+7+LpRrkbIaY9Pxzffv7FROT/i40ZQPod6zaMlIA7KdcKtXCYszFmPQIC9fH2sDJYEDeOeHqjvmo4u3ibDuLlYHbKd8myTrIfzzUSwE3tST1N4y2H+5+lGll6f7tMV5lxuLqm6c93MlpLdLwBRA+VqF4jZ8eJkDLqKdRaLMjgklOOF/dQj8csS6bffki3q4ezGMZ10YY6AgiYI77x9vOiuDvZXSn1XXpd+VVvV4shxzvrCdqkvAmuGq1hJyghJD7YHlfS8CBS2lQ05BhuVoNgkBV9bM4hdlh4SNqqcdeKEdzzD4fuSj2ZIWUn+ENju5CGStEdi+3GpL5+2t/0msKytvS0MaXUgOHkCR6yC7zkO4itDgE9dYmqoCSvpIX+unFjn0b95A/Z3F0v7etN1CMhvg0NZABHfYJkqjKM5F0KJBl2X1y8QYtjZLUAK9nInYG0dHfPa0o8PlCvFScP1D49/qRerS1jw+bGPg9AGOgJ0CRfgiP1fyu5nC4HR4gVJgs5Z6h2PH2iKUGag/GXyfwjjNl4fQgS9e/8/TstFZbnqxxWJmEwl3RU/pL7F48vhoBe1UIJovcx7FBqa1Wyn9Rx8qD4oEPqTrAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(26005)(9686003)(7696005)(2906002)(6506007)(55016002)(4326008)(38070700005)(33656002)(122000001)(7416002)(8936002)(71200400001)(6916009)(38100700002)(186003)(52536014)(66556008)(66476007)(76116006)(316002)(66946007)(8676002)(64756008)(66446008)(5660300002)(508600001)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zUpL7fGBelZna1QEqeX7wj5lXuP1tCb8hyeVF9gIEIZeYZOFgMJtLgoqCJEe?=
 =?us-ascii?Q?DUh/6MeKrlD85bxNMPUoDa73oPFKbpE6Z+pkh6ko2gCwIX3v9Vzbja2UjaQM?=
 =?us-ascii?Q?WNtHPw4b574vOAmPWkHCeNCyrnrMskmtbiCOUQj0fOwbN1z9GtkJn3lVaXlE?=
 =?us-ascii?Q?zOk4utjAW/WMSdbYpppx6NGA6O5D0TKP5vu2KuttKHR0lp1/6oFjM4VuhgCb?=
 =?us-ascii?Q?1QACJVzxbimIsP7mU5tQXhxuaEujh/ynL/s6I3OijHlDCMPPlzpXJJJE2o9J?=
 =?us-ascii?Q?7PMf+Hc/I42I41VDHyCRGeLzQA+JJdaPzF5Kvk5Q2zHAkStthMmSU1vW7xsU?=
 =?us-ascii?Q?7n7CdtwafOWpC2W8H5lMmd5qrVE/I4mAXO7EIXIkHNTWV42nAnj1BOh+YHE+?=
 =?us-ascii?Q?JRkQN/5uo/DDxfutkO2yMxSKskC2A5yUNwXM2brKJHS5gvHvja38Koo9vGs2?=
 =?us-ascii?Q?Ux27sPc8vAp64leG4NtPSiCJTZOL1Zo4D3+eheKKp0BbZjP+ee3+tGjKtyDe?=
 =?us-ascii?Q?KUxe1qv1FrIbuN9C/YzEhClj8fY6f5fCDKEbHvS412hAsQQOTsZxmfdZihTi?=
 =?us-ascii?Q?rH/yBR3IA9J4gJKbX/pWxj8t/alrMX/3hDeKPkszlhEIoeLTRrTn+zpA0ShC?=
 =?us-ascii?Q?1OAYQvwNX/oQjzjU9Fq5oVD6beKdAg+c6b7zKBx0UocB5pW+thaa/bqB+owJ?=
 =?us-ascii?Q?hwIyGpuKOLSERQZ2VdNTu+uumF/xaqGFE1UmVvoRaUmpv5PR9GEFz9NacQZ3?=
 =?us-ascii?Q?tEZq+aw8zVOpv85F2BoKEdQfp0Nd0T/Lu+e5EZfUMWV8kI98mCLdjAyy3nLm?=
 =?us-ascii?Q?KHmKCXgsUxvwDi8pjnIV5jHg2eOKFJZGgjv9qjdyP4KV3rBFjbhX1VhNxR0n?=
 =?us-ascii?Q?/PYOeMSa3XlaGeD7MGDYKTNATwXYjePYN51R02rJU9Lknr3ZXZWsag4yoFki?=
 =?us-ascii?Q?tiH4nzr7nMuQw8KbY+jHeXUTUCFDUAgfF3ihdJk3Z3Db3CvYn4nSBjDJOJCp?=
 =?us-ascii?Q?R3L3DGmlT87WUpZ1MW0tuTgEVmLO5dsBfcsiikB8HWGGDP0t3TIp9K3SNMX9?=
 =?us-ascii?Q?atsUrlQnTPIbnIuycUyfxn0krGIz6Wcdj1L4kCMAIR/a4wJQ/ikgsh1twH7p?=
 =?us-ascii?Q?NlI1V5uOp/UWIvc9NKOnJOWpdTuW3g5tdJsIV7u+7JgC/g2fuESGeCE9UW/y?=
 =?us-ascii?Q?vbZnQSxCwLNQ187Xp9wpdu4AnBJbrX7Ul8dRvhovlhlO+JpdJa7/Vg4VywPo?=
 =?us-ascii?Q?lChfCANreU08TrZPmytUPZRv8KFtAV5XQCLeYKCfuurOQi3uHWBzs4zUOmLI?=
 =?us-ascii?Q?4fQ5W1qynM8060UdkVFLfsu1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78aedd9e-9cf7-488d-aec5-08d97dd29fe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 14:09:42.7180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vjlz9X2bcG0dD96AE6/YvPIWRttiMOGTeHdw7+DM44Z9nFD4TiX24pL+85Z8tdfUzgFV9uNPd2AqXL7GHx2EXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1330
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:51 PM
>=20
> On Wed, Sep 22, 2021 at 03:22:42AM +0000, Tian, Kevin wrote:
> > > From: Tian, Kevin
> > > Sent: Wednesday, September 22, 2021 9:07 AM
> > >
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, September 22, 2021 8:55 AM
> > > >
> > > > On Tue, Sep 21, 2021 at 11:56:06PM +0000, Tian, Kevin wrote:
> > > > > > The opened atomic is aweful. A newly created fd should start in=
 a
> > > > > > state where it has a disabled fops
> > > > > >
> > > > > > The only thing the disabled fops can do is register the device =
to the
> > > > > > iommu fd. When successfully registered the device gets the norm=
al
> fops.
> > > > > >
> > > > > > The registration steps should be done under a normal lock insid=
e
> the
> > > > > > vfio_device. If a vfio_device is already registered then furthe=
r
> > > > > > registration should fail.
> > > > > >
> > > > > > Getting the device fd via the group fd triggers the same sequen=
ce as
> > > > > > above.
> > > > > >
> > > > >
> > > > > Above works if the group interface is also connected to iommufd, =
i.e.
> > > > > making vfio type1 as a shim. In this case we can use the registra=
tion
> > > > > status as the exclusive switch. But if we keep vfio type1 separat=
e as
> > > > > today, then a new atomic is still necessary. This all depends on =
how
> > > > > we want to deal with vfio type1 and iommufd, and possibly what's
> > > > > discussed here just adds another pound to the shim option...
> > > >
> > > > No, it works the same either way, the group FD path is identical to
> > > > the normal FD path, it just triggers some of the state transitions
> > > > automatically internally instead of requiring external ioctls.
> > > >
> > > > The device FDs starts disabled, an internal API binds it to the iom=
mu
> > > > via open coding with the group API, and then the rest of the APIs c=
an
> > > > be enabled. Same as today.
> > > >
> >
> > After reading your comments on patch08, I may have a clearer picture
> > on your suggestion. The key is to handle exclusive access at the bindin=
g
> > time (based on vdev->iommu_dev). Please see whether below makes
> > sense:
> >
> > Shared sequence:
> >
> > 1)  initialize the device with a parked fops;
> > 2)  need binding (explicit or implicit) to move away from parked fops;
> > 3)  switch to normal fops after successful binding;
> >
> > 1) happens at device probe.
>=20
> 1 happens when the cdev is setup with the parked fops, yes. I'd say it
> happens at fd open time.
>=20
> > for nongroup 2) and 3) are done together in VFIO_DEVICE_GET_IOMMUFD:
> >
> >   - 2) is done by calling .bind_iommufd() callback;
> >   - 3) could be done within .bind_iommufd(), or via a new callback e.g.
> >     .finalize_device(). The latter may be preferred for the group inter=
face;
> >   - Two threads may open the same device simultaneously, with exclusive
> >     access guaranteed by iommufd_bind_device();
> >   - Open() after successful binding is rejected, since normal fops has =
been
> >     activated. This is checked upon vdev->iommu_dev;
>=20
> Almost, open is always successful, what fails is
> VFIO_DEVICE_GET_IOMMUFD (or the group equivilant). The user ends up
> with a FD that is useless, cannot reach the ops and thus cannot impact
> the device it doesn't own in any way.

make sense. I had an wrong impression that once a normal fops is
activated it is also visible to other threads. But in concept this fops
replacement should be local to each thread thus another thread
opening the device always gets a parked fops.

>=20
> It is similar to opening a group FD
>=20
> > for group 2/3) are done together in VFIO_GROUP_GET_DEVICE_FD:
> >
> >   - 2) is done by open coding bind_iommufd + attach_ioas. Create an
> >     iommufd_device object and record it to vdev->iommu_dev
> >   - 3) is done by calling .finalize_device();
> >   - open() after a valid vdev->iommu_dev is rejected. this also ensures
> >     exclusive ownership with the nongroup path.
>=20
> Same comment as above, groups should go through the same sequence of
> steps, create a FD, attempt to bind, if successuful make the FD
> operational.
>=20
> The only difference is that failure in these steps does not call
> fd_install(). For this reason alone the FD could start out with
> operational fops, but it feels like a needless optimization.
>=20
> > If Alex also agrees with it, this might be another mini-series to be me=
rged
> > (just for group path) before this one. Doing so sort of nullifies the e=
xisting
> > group/container attaching process, where attach_ioas will be skipped an=
d
> > now the security context is established when the device is opened.
>=20
> I think it is really important to unify DMA exclusion model and lower
> to the core iommu code. If there is a reason the exclusion must be
> triggered on group fd open then the iommu core code should provide an
> API to do that which interworks with the device API iommufd will work.
>=20
> But I would start here because it is much simpler to understand..
>=20

Let's work on this task first and figure out what's the cleaner way to unif=
y
it. My current impression is that having an iommu api for group fd open
might be simpler. Currently vfio iommu drivers are coupled with container
with group-granular operations. Adapting them to device fd open will=20
require more changes to handle device<->group. anyway we'll see...
