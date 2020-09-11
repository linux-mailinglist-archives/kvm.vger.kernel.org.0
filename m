Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3A265DA3
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 12:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgIKKSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 06:18:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:50539 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgIKKSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 06:18:14 -0400
IronPort-SDR: S9hF1rLyJcyJPvB8Iq4JmTklaqfqS8fKCPF7SYzr1gH2lxmLaB8qykeNzAb0LNNTdJHhX+CWO3
 09dHv3iWJsgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="146420974"
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="146420974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 03:18:09 -0700
IronPort-SDR: SL+FQj1eUuYaneCHhJeXAZZ3Xhe6bddELOPKQJqQsXdTtmU4HahDulATh8TqqFTBTjm8c0cuUC
 4PvUlP70j1+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="329719963"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 11 Sep 2020 03:18:09 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 03:18:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 03:18:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Sep 2020 03:18:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 11 Sep 2020 03:18:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWLw1aEZyMywsSh/Hyp02eWQGOnlEVPoqReKjvIz84mSsJ5pfIGl2BB8fSROqJ+49kKBqHeOXyoStNbsWU0/VZGi1ohw3GOzKAl/T+cH5oCdyHByQ2VVFd3hdsEJUkLr3S9/iWXHrjAkfv+ARGolpbyEsIlvX+anYjvbSyziC33zUxLjnd6WRw3QZoNIhG92+VbiWXjn1u7+9HMzTagf9gcUs3wnUlQcJrMT/X9f8u1qM20kf822EWGeP42D85mCm0TstyYv6yzZ4nVZ2otYhqTQBLCcLryfThRhC6moQklULXTvUPjT6DdBGoHeJvvVOAz8Pt6T7SoHqPn4ql3dkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8UpJZYd/92B9Erz9/K/AjD1nRQ5k/wUezoqowyMMgo=;
 b=hB6F4teZF2FRO5LxmNebPUIhunwtz9x81Fp+3wFhUuafU3HUdep/v1mY5xRxbZj/H5WwyNRz4Ejyv0X785z+BHmRlPhnnGM3FD9GDkLTKttGsbxsliz7Fkpsl58RoFUJLprKxsVK172YLKjC25uKmXR6P8BJgITSkXX9N/BQ2r/DjjNGRdkPaiKfy69BHcn7AB62O+4MF8nlKTxp3u6D2ic6++RDD0z0k1QZhXey3xFTksNZCHIouvuQbpnx06oOGtyKTowE7Mb4dhA8IzaqsVoebfa09A2Qh5ktWMehTgIjGD/wOiFJ8llmgyjy4ZQVjIxWgNol+ejEpBrWa6SEdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8UpJZYd/92B9Erz9/K/AjD1nRQ5k/wUezoqowyMMgo=;
 b=kEEcT3OdwJ7dKgRco4AF5K5a6d8ySo1bKVSZP/o8xL+J4X9cW858LgPadvAtmpw0HI5iebQ8+835Wx+4wpRZzlfEVxgzErDnmn8UhheKtFVYfVeut6CatFCf+/+J3UDK6xkhbVLh9o1PHtCvOx70GEGqQfUWLXfreZAxSidvJos=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2158.namprd11.prod.outlook.com (2603:10b6:301:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 10:18:01 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::6dfe:feb8:25f1:ac9c%7]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 10:18:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Sean Mooney <smooney@redhat.com>,
        =?iso-8859-1?Q?Daniel_P=2EBerrang=E9?= <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Wang, Xin-ran" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "Feng, Shaohe" <shaohe.feng@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Xu, Hejie" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: RE: device compatibility interface for live migration with assigned
 devices
Thread-Topic: device compatibility interface for live migration with assigned
 devices
Thread-Index: AQHWWW8QECb/pyJxCUW88yuEbnXnGKkJnOAAgABHiwCAAhL8AIAFR8uAgAnb6gCAAPsXgIACNNuAgAn8e4CAAKQQgP///oIAgAAG/ACAAFf6gIAAAa4AgAAZYQCAABZEgIAHp3eAgAR+pQCAAaChgIAGKisAgABceICAAAHKgIAABBUAgAAFswCAAo59AIAALZkA///+Q4CACJqBgIABDL6AgAObzICAAASeAIAEGmYAgA05qwCAAME+gIACQQQAgAADTYCAAFdUAIAAc3cAgACaQQCAAAD+0A==
Date:   Fri, 11 Sep 2020 10:18:01 +0000
Message-ID: <MWHPR11MB164559CBC9819565289BAAE98C240@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200825163925.1c19b0f0.cohuck@redhat.com>
        <20200826064117.GA22243@joy-OptiPlex-7040>
        <20200828154741.30cfc1a3.cohuck@redhat.com>
        <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
        <20200831044344.GB13784@joy-OptiPlex-7040>
        <20200908164130.2fe0d106.cohuck@redhat.com>
        <20200909021308.GA1277@joy-OptiPlex-7040>
        <20200910143822.2071eca4.cohuck@redhat.com>
        <7cebcb6c8d1a1452b43e8358ee6ee18a150a0238.camel@redhat.com>
        <20200910120244.71e7b630@w520.home>     <20200911005559.GA3932@joy-OptiPlex-7040>
 <20200911120806.5cfe203c.cohuck@redhat.com>
In-Reply-To: <20200911120806.5cfe203c.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e1828f4-6a97-4d06-af6a-08d8563bf6d6
x-ms-traffictypediagnostic: MWHPR1101MB2158:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2158D7C186CC99652C0920598C240@MWHPR1101MB2158.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CH3TJtjBPHa0br7UjH0G2a49pVHouWvtCaOhl3ASUn4QQ8ljeY/Cdk0KvrBjVlQGU+YPCUppYpiT52ZzF/8mieKCKIbNEwvwcCb+bjkcMCgpGPqry5eOdDgPQal6flnhZ0SMVSEwgsSLBkah5bulUdHN6xfV2qNyGuMC8txXi+3olzDfP/fLfvyxsgKyVPFzeFpYezBB7m+xNdYd75d6ChOjxg2gRj6VI9kb/QnUjBFSkE3oBwCuHlU1+pVIzx3R3rObDucc68og6cSRqspO/KLW4EddGQzFCj2d9ihT0UIxQ3jaN8ve+fhnDZuR6H3oOqt2SwhLu2uq23KjZ1ZxlOu5x9yjriBeRvp0+FTDEtKiArAki0GdPvdZdK/sT1Mp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(26005)(64756008)(66446008)(66556008)(71200400001)(52536014)(66946007)(478600001)(76116006)(7696005)(66476007)(5660300002)(8676002)(33656002)(186003)(4326008)(7416002)(86362001)(6636002)(9686003)(54906003)(6506007)(8936002)(2906002)(110136005)(55016002)(316002)(83380400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: f0XF7GwfXwjn+XHxrXA7gayCa20CPuo5uC6u/+3fTM2DojJE7NRT22U0NcwXPPfOWOPSAeptJa1Nmnph7wnd4x+H34QnB0Go1YUBK+gUlgjd9CqW4hxJgCU+oHAOrgpKrBdXTNTDp/ZpPRVorsC8oY1Eu075kKblvzdd74CerxaE8ZdhrzoDVCF1YpgDgt4lEjTe+fVMLgTydo0V9ILaKYNdbqDpvmE8AbTSSmLniYvgIWAWm5Cv8bIkwdkhnrTYhP936uMvxUZzObvKbW1sadIzj3z9ddKCJpyRC2mDJNrF52Q0J+w2XmE9QVQ30DcyA/UuMKl4LYv9CkR0weKQhLLKExQ8vESQSzSRP1akTlt17WbbYkrYER7j9td+Il84BoJOzpBLHesg1YKMN2NGaRGm0ZhiyeCxGkWuF4rbRpMGjv9kltZOVFF9finMoUf0zxM4CLOC4MBFoAa+8EGybYjtwm3dHupXu/s5/Y9ptVxjUqBKQJS48GaR6lDKg6TfIkLc3vw1lG3HI9YLfVW2nrFBGLleVxVztEnODhrGLYxnNAz8HD9DL31bewhNllPXb3OgOi3YKKUCwV75zkFadgD22yG2OQtkVqFd/dQ6PDP+yfGGmAS//QrPAtpjhjmo+xEfMq9RvUP949z+avn3oQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1828f4-6a97-4d06-af6a-08d8563bf6d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2020 10:18:01.6209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q3d8/PbPaPW56Mf3399GEverXCvU669KPL8slRIbXruATNYcsIdemA84RP/PHXqY3Oz2OUyGiPFYrsxYp65KCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2158
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, September 11, 2020 6:08 PM
>=20
> On Fri, 11 Sep 2020 08:56:00 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>=20
> > On Thu, Sep 10, 2020 at 12:02:44PM -0600, Alex Williamson wrote:
> > > On Thu, 10 Sep 2020 13:50:11 +0100
> > > Sean Mooney <smooney@redhat.com> wrote:
> > >
> > > > On Thu, 2020-09-10 at 14:38 +0200, Cornelia Huck wrote:
> > > > > On Wed, 9 Sep 2020 10:13:09 +0800
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > > > > still, I'd like to put it more explicitly to make ensure it=
's not
> missed:
> > > > > > > > the reason we want to specify compatible_type as a trait an=
d
> check
> > > > > > > > whether target compatible_type is the superset of source
> > > > > > > > compatible_type is for the consideration of backward
> compatibility.
> > > > > > > > e.g.
> > > > > > > > an old generation device may have a mdev type xxx-v4-yyy,
> while a newer
> > > > > > > > generation  device may be of mdev type xxx-v5-yyy.
> > > > > > > > with the compatible_type traits, the old generation device =
is still
> > > > > > > > able to be regarded as compatible to newer generation devic=
e
> even their
> > > > > > > > mdev types are not equal.
> > > > > > >
> > > > > > > If you want to support migration from v4 to v5, can't the
> (presumably
> > > > > > > newer) driver that supports v5 simply register the v4 type as=
 well,
> so
> > > > > > > that the mdev can be created as v4? (Just like QEMU versioned
> machine
> > > > > > > types work.)
> > > > > >
> > > > > > yes, it should work in some conditions.
> > > > > > but it may not be that good in some cases when v5 and v4 in the
> name string
> > > > > > of mdev type identify hardware generation (e.g. v4 for gen8, an=
d v5
> for
> > > > > > gen9)
> > > > > >
> > > > > > e.g.
> > > > > > (1). when src mdev type is v4 and target mdev type is v5 as
> > > > > > software does not support it initially, and v4 and v5 identify
> hardware
> > > > > > differences.
> > > > >
> > > > > My first hunch here is: Don't introduce types that may be compati=
ble
> > > > > later. Either make them compatible, or make them distinct by desi=
gn,
> > > > > and possibly add a different, compatible type later.
> > > > >
> > > > > > then after software upgrade, v5 is now compatible to v4, should=
 the
> > > > > > software now downgrade mdev type from v5 to v4?
> > > > > > not sure if moving hardware generation info into a separate
> attribute
> > > > > > from mdev type name is better. e.g. remove v4, v5 in mdev type,
> while use
> > > > > > compatible_pci_ids to identify compatibility.
> > > > >
> > > > > If the generations are compatible, don't mention it in the mdev t=
ype.
> > > > > If they aren't, use distinct types, so that management software
> doesn't
> > > > > have to guess. At least that would be my naive approach here.
>=20
> [*]
>=20
> > > > yep that is what i would prefer to see too.
> > > > >
> > > > > >
> > > > > > (2) name string of mdev type is composed by "driver_name +
> type_name".
> > > > > > in some devices, e.g. qat, different generations of devices are
> binding to
> > > > > > drivers of different names, e.g. "qat-v4", "qat-v5".
> > > > > > then though type_name is equal, mdev type is not equal. e.g.
> > > > > > "qat-v4-type1", "qat-v5-type1".
> > > > >
> > > > > I guess that shows a shortcoming of that "driver_name + type_name=
"
> > > > > approach? Or maybe I'm just confused.
> > > > yes i really dont like haveing the version in the mdev-type name
> > > > i would stongly perfger just qat-type-1 wehere qat is just there as=
 a way
> of namespacing.
> > > > although symmetric-cryto, asymmetric-cryto and compression woudl be
> a better name then type-1, type-2, type-3 if
> > > > that is what they would end up mapping too. e.g. qat-compression or
> qat-aes is a much better name then type-1
> > > > higher layers of software are unlikely to parse the mdev names but =
as a
> human looking at them its much eaiser to
> > > > understand if the names are meaningful. the qat prefix i think is
> important however to make sure that your mdev-types
> > > > dont colide with other vendeors mdev types. so i woudl encurage all
> vendors to prefix there mdev types with etiher the
> > > > device name or the vendor.
> > >
> > > +1 to all this, the mdev type is meant to indicate a software
> > > compatible interface, if different hardware versions can be software
> > > compatible, then don't make the job of finding a compatible device
> > > harder.  The full type is a combination of the vendor driver name plu=
s
> > > the vendor provided type name specifically in order to provide a type
> > > namespace per vendor driver.  That's done at the mdev core level.
> > > Thanks,
> >
> > hi Alex,
> > got it. so do you suggest that vendors use consistent driver name over
> > generations of devices?
> > for qat, they create different modules for each generation. This
> > practice is not good if they want to support migration between devices
> > of different generations, right?
>=20
> Even if they create different modules, I'd assume that they have some
> kind of core with common functionality. I'd assume that as long they do
> any type registrations satisfying [*] in the core, they should be good.
>=20
> > and can I understand that we don't want support of migration between
> > different mdev types even in future ?
>=20
> From my point of view, I don't see anything that migration between
> different mdev types would buy that is worth the complexity in finding
> out which mdev types are actually compatible.

Agree. Different type means different device API. as long as the device
API doesn't change, different modules should expose it as the same type.
If qat really wants to attach module name to the type, it essentially impli=
es
that qat has no generational compatibility.

Thanks
Kevin
