Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A436421965A
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 04:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgGICxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 22:53:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:4811 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgGICxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 22:53:11 -0400
IronPort-SDR: 42ujUCZGzT/g6WvCP0n9ghTdzlz+si6GaBOYwOOmBVXPWIySY3LzaZlPZxo2+7yEHFtWDJSMfX
 sE5X6NqqD7YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="146022053"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="146022053"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 19:53:07 -0700
IronPort-SDR: gzZb+MULQfP+oC0oX9xK2pU2/2NpBH5mU2jpK8m4U4G+uZYliRR41PSDl5qbmsQr5IBbR8eiv4
 UCGbcIt4mDmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="358292758"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 19:53:07 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 19:53:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 19:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWLMz1d21Vq+QaqRA8qtmjzDp77Wg2xGDzqx+ijgH8dBJYQJ0pxy5QEY7MKa+cfPJhFUThzmIP1eTAAkCgd3crBLXeutEqR+zC5sPuQjursaT6RguTTCsZUec7W+E2/RdXS7/+zzlHy03DvRNjLkl8e77MS2IjH1B7Vz9S2J9KaNxdVe+N9PgDV46vt6t5ROCI83fBkiopkc1HXK51GzVyAgM0xR+f0XlDlAjfMkEpR5zkLJ+b8RqDMuSlNKtkpVRAcG+FxshFGQUNf7CcHWLs7IMvMvKHi9mbSb4/Ls6hgFRfyX3mfcceJFczhl9K3WM325J2jAbaK2oE53JZKriA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vovaR95VfklXkBAQrt0sd5pFvJt2GpTSdXRvIrgyKos=;
 b=TLkiJODM32xb8ojozaES4+YwJqYEsGJLrd/XGu6GW9r1faEpfdN5JYClrLHL5cyQJz0uU4EX0wN89qC+DKVv6e4lV7gZEHbExn3E7U2il3yDiRxFgZwNKOgDEWlUH1EmFPwVD+AK7aCgi/Oo3ExH3VviWhVjzAf2XmaoVWzVac42YdQhGdMFVUNgMUYnNbBHh4puPNG5wGNyHyazE7mPrgVx3J7cz2FFfYhlgWJI/3Z3KKlZYItp+TclcqNDUr/PaBmyKyOkJ7xFXvIqFKvLXWvHlPnx3edAIZUA2i0YJvN2mCAj8B0/rr8xHrXG0Y6XkQGo3/1NqxBw7tu+BxKoGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vovaR95VfklXkBAQrt0sd5pFvJt2GpTSdXRvIrgyKos=;
 b=wkryGZ4FQd0dbG+pn+eCvO0lnpBdg0O2TkSp80mjKEnUvlOChILwMS1PL13pOvPXuOHHd3qwMOaZgpCs1HUPwMN/kw5uFRbzdVNwt1JurXB7gl+/9RVkjk9tse8ciTAWpB1lFblk/TP4+BRucfO8VvrfI1KK1M3KYegXNNGm0pc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 9 Jul
 2020 02:53:05 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 02:53:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Index: AQHWDWq7bB5+TEBrpEWwuv/xNBM+XKj9T7IAgAAdgwCAAEhYIIAA4D8AgAB97VA=
Date:   Thu, 9 Jul 2020 02:53:05 +0000
Message-ID: <MWHPR11MB1645C5033CB813EBD72CE4FD8C640@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
        <20200408055824.2378-1-zhenyuw@linux.intel.com>
        <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200707190634.4d9055fe@x1.home>
        <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200708124806.058e33d9@x1.home>
In-Reply-To: <20200708124806.058e33d9@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ca3cd5b-83ca-46a0-f923-08d823b33454
x-ms-traffictypediagnostic: MW3PR11MB4523:
x-microsoft-antispam-prvs: <MW3PR11MB45237EE58F6BF7B4486F94838C640@MW3PR11MB4523.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QoWQupW0c5KuqIPSvR1JFnXV5ASv+EjwHqg7dv45kMupZtCTVZBI7a4vszw2rpoV7rnSzB683F5tYsRTbs4FD3sB4+H76Soprj7gBq/CurcxXFogltn7g166Xd/oEGqCxMK5OUBBuQeRFm+y0gW1A6l4R2hZVg7ZfoYMqExn+Umv4HR6Fc8yCZPn1m5IAYMA+C+pR4zN5bRmWLLlNY5zgQXjRkTvZrvPjGoYQc2VDUVAj97qG+PXeY5lpyOcFSI/UaUwaRF28rGidX7RxXI7gvR5brdnqS/xiauxuAU/9rPXyTZjY9KQ5C2VA/ij1g+EbLH33jU3qz7u1GXxogQm4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(66476007)(6506007)(8676002)(52536014)(76116006)(7696005)(55016002)(9686003)(2906002)(6916009)(64756008)(71200400001)(66446008)(186003)(66556008)(66946007)(26005)(86362001)(83380400001)(478600001)(4326008)(8936002)(316002)(54906003)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: II91g3UkVaoTr/rUNcBimXhYwv3zziFR3IZFFjZmrEJ5tu0Gws/kHg92bVFdYRTCuTMy5aRHuWh3yKD0HvJw0U5Nm4YqfpMBacJ1AeJcLUKE5bAxZfZkl89d2hsIqMvkkkjAxxjwfy6wff1jvbg/WipvhL4UTN7cSO3282wQ08hMOoOithr4NBE4Kqg/cGgEfoj6u2bBXY82+mZF1V+wqZZxqp7qtIqz2Xy+GpiA+I5kW4bgl0x8TYsZsAhi9ZO/EFMP+abycJts92p/a8y6mSuM2eim1jz78wmrbit+cIhW+AKZZmVvCwX1MFmyxtTQTItnvwuiCXNi+zj3r1vzjwWX2eS3MqQDSf2qDvJ0mLDTT3U4YTpj+eSeM/SGoSyCfzbvsOQYB72iKZJFDMidGAlV+csiEHGnYaO/FbF2eU/QFVU8JPyOnW8d2qS466SmAvVRC3UgLXkQ0nfOLq7uHQHETZXqnPigEq5QdGzOkagXStYbfjXyblNeizRLlQFT
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca3cd5b-83ca-46a0-f923-08d823b33454
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 02:53:05.5078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 29COO4KPWZiWXmINSy8eaJSB4EQ15cxkow2mjuAla52jZJGv2VxMj5Zv23o3mzOizNy1IcbGJYR1dFm0n3MODg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, July 9, 2020 2:48 AM
>=20
> On Wed, 8 Jul 2020 06:31:00 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, July 8, 2020 9:07 AM
> > >
> > > On Tue, 7 Jul 2020 23:28:39 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >
> > > > Hi, Alex,
> > > >
> > > > Gentle ping... Please let us know whether this version looks good.
> > >
> > > I figured this is entangled with the versioning scheme.  There are
> > > unanswered questions about how something that assumes a device of a
> > > given type is software compatible to another device of the same type
> > > handles aggregation and how the type class would indicate compatibili=
ty
> > > with an aggregated instance.  Thanks,
> > >
> >
> > Yes, this open is an interesting topic. I didn't closely follow the ver=
sioning
> > scheme discussion. Below is some preliminary thought in my mind:
> >
> > --
> > First, let's consider migrating an aggregated instance:
> >
> > A conservative policy is to check whether the compatible type is suppor=
ted
> > on target device and whether available instances under that type can
> afford
> > the ask of the aggregated instance. Compatibility check in this scheme =
is
> > separated from aggregation check, then no change is required to the
> current
> > versioning interface.
>=20
> How many features, across how many attributes is an administrative tool
> supposed to check for compatibility?  ie. if we add an 'aggregation'
> feature now and 'translucency' feature next year, with new sysfs
> attributes and creation options, won't that break this scheme?  I'm not
> willing to assume aggregation is the sole new feature we will ever add,
> therefore we don't get to make it a special case without a plan for how
> the next special case will be integrated.

Got you. I thought aggregation is special since it is purely about linear
resource adjustment w/o changing the feature set of the instance, thus
reasonable to get special handling in management stack which needs
to understand this attribute anyway. But I agree that it's difficult to=20
predict the future and other special cases...

>=20
> We also can't even seem to agree that type is a necessary requirement
> for compatibility.  Your discussion below of a type-A, which is
> equivalent to a type-B w/ aggregation set to some value is an example
> of this.  We might also have physical devices with extensions to
> support migration.  These could possibly be compatible with full mdev
> devices.  We have no idea how an administrative tool would discover
> this other than an exhaustive search across every possible target.
> That's ugly but feasible when considering a single target host, but
> completely untenable when considering a datacenter.

If exhaustive search can be done just one-off to build the compatibility
database for all assignable devices on each node, then it might be
still tenable in datacenter?

>=20
>=20
> > Then there comes a case where the target device doesn't handle
> aggregation
> > but support a different type which however provides compatible
> capabilities
> > and same resource size as the aggregated instance expects. I guess this=
 is
> > one puzzle how to check compatibility between such types. One possible
> > extension is to introduce a non_aggregated_list  to indicate compatible
> > non-aggregated types for each aggregated instance. Then mgmt.. stack
> > just loop the compatible list if the conservative policy fails.  I didn=
't think
> > carefully about what format is reasonable here. But if we agree that an
> > separate interface is required to support such usage, then this may com=
e
> > later after the basic migration_version interface is completed.
>=20
> ...and then a non_translucency_list and then a non_brilliance_list and
> then a non_whatever_list... no.  Additionally it's been shown difficult
> to predict the future, if a new device is developed to be compatible
> with an existing device it would require updates to the existing device
> to learn about that compatibility.

I suppose a compatibility list like this doesn't require the existing devic=
e
to update. It should be new device's compatibility to claim compatibility
to the types carried in existing list.=20

>=20
> > --
> >
> > Another scenario is about migrating a non-aggregated instance to a devi=
ce
> > handling aggregation. Then there is an open whether an aggregated type
> > can be used to back the non-aggregated instance in case of no available
> > instance under the original type claimed by non-aggregated instance.
> > This won't happen in KVMGT, because all vGPU types share the same
> > resource pool. Allocating instance under one type also decrement availa=
ble
> > instances under other types. So if we fail to find available instance u=
nder
> > type-A (with 4x resource of type-B), then we will also fail to create a=
n
> >  aggregated instance (aggregate=3D4) under type-B. therefore, we just
> > need stick to basic type compatibility check for non-aggregated instanc=
e.
> > And I feel this assumption can be applied to other devices handling
> > aggregation. It doesn't make sense for two types to claim compatibility
> > (only with resource size difference) when their resources are allocated
> > from different pools (which usually implies different capability or QOS=
/
> > SLA difference). With this assumption, we don't need provide another
> > interface to indicate compatible aggregated types for non-aggregated
> > interface.
> > --
> >
> > I may definitely overlook something here, but if above analysis sounds
> > reasonable, then this series could be decoupled from the versioning
> > scheme discussion based on conservative policy for now. :)
>=20
> The only potential I see for decoupling the discussions would be to do
> aggregation via a vendor attribute.  Those already provide a mechanism
> to manipulate a device after creation and something that we'll already
> need to solve in determining migration compatibility.  So in that
> sense, it seems like it at least doesn't make the problem worse.
> Thanks,
>=20

This makes some sense, since anyway 'aggregation' still changes how the
instance looks like. But let me understand clearly. Are you proposing=20
actually moving 'aggregation' to be a vendor attribute (i.e. removing
the 'mdev' sub-directy in this patch), or more about a policy of treating
it as a vendor attribute? If the former, is there any problem of having
Libvirt manage this attribute given that it becomes vendor specific now?

Thanks
Kevin
