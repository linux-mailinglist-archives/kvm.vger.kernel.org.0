Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB5B217F97
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 08:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgGHGbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 02:31:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:23381 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgGHGbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 02:31:09 -0400
IronPort-SDR: 0Powxr5Y5Q8nwYkNUQDGUuiEG2MM7R5rb5VwkLbFbbyFa3Q0inSCC53m7PIMqXMY7RQ1tHy2CB
 QamzXiOSBsKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="209279743"
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="209279743"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 23:31:05 -0700
IronPort-SDR: 6JNjKqX5sIWJP8KKvWg0TQgi3IMlldtnSQhIuvVwQZVZ5/ksdfSlbLGUjMGPdD04DeYLtBt0Qw
 eiVVQmb6Pi3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,326,1589266800"; 
   d="scan'208";a="279853873"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga003.jf.intel.com with ESMTP; 07 Jul 2020 23:31:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 23:31:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 7 Jul 2020 23:31:04 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Jul 2020 23:31:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 7 Jul 2020 23:31:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyL3WVTEm5njJIWILF4+Wwv1R3NPP7nihWg0K2jxwX7PEbDDY95WxVrGpmg3x/JKy56+d4WynyQYjmYJYSqbDU1vPMZ787cUK5PtXo0ZPhqO2YuuU64+y3tCm8wv94AAPOTvoklXjtXBCys5JkwfAp8HUpx8wXshFKa6B1QyzmudwWKCVoY0/xQgUBWfQPL5OZmT/H/zviR+LZ4hVhIKnw1m/BfRP1oIByDdhKG9BFxILeDOPRxkQ8N3RhmpZGHKVara35w7h6lt8OiWKFL0Ht0pl+Lb1beMDJr6yPH3RE5Uaghb1RyhtRzWuGod8tPkhoWlT8whAJBptAoBVsvRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOomJuvEcucDLfqntb1sVhxsO7o8IUaBjFMhzbqw5iA=;
 b=R998Xr6TIIy4K16V0MtsiCQ1dLRHbR2dEwwkb8rGGYFjb78e7an4yFy1iChW9Gew93off3PqU1xCzl6Edbbcm2Nn7huR4wrW+bzJD+Kj73sXPSkvOoPzLaOhOgazpxwc29ql7Tjfi876rjnfAl5QxT2/4rl02VfccsU21SnxeDq8Oihs/qQWcSpqxT3OjzV81jELQzAuZcAnNJcmMwiYeVB2b7/Tnxx7Qjr07Dl5cV1rMqIN6BkPFJKcWPX56ymmp8z8Et1m2475YJOZgGlnv7xanqFOWU4QuYOwNJVh7wCIDFA4iaukngLa+7qKXdS9+Cgo2I9aeAfWHkcZ80QZ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOomJuvEcucDLfqntb1sVhxsO7o8IUaBjFMhzbqw5iA=;
 b=RRF2hSqUA9u68Feqwc2nAP6Y4jsFIOhSXaBtJK5JQZEY1YL0oi2oHFZAjpE7fTBC0H7j4AK8edTwmPQnxHwTnYh5oBpe3T/+4v/nFQdgVAWgxnZKqff6qUk8FqEKH8UwI8ksp7ROh37bfzyKGWOYFKv4MXgfeDKu385rFx8byjc=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Wed, 8 Jul
 2020 06:31:00 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 06:31:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Index: AQHWDWq7bB5+TEBrpEWwuv/xNBM+XKj9T7IAgAAdgwCAAEhYIA==
Date:   Wed, 8 Jul 2020 06:31:00 +0000
Message-ID: <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
        <20200408055824.2378-1-zhenyuw@linux.intel.com>
        <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20200707190634.4d9055fe@x1.home>
In-Reply-To: <20200707190634.4d9055fe@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a3fbebf-df79-45af-2eda-08d823087b01
x-ms-traffictypediagnostic: MWHPR1101MB2207:
x-microsoft-antispam-prvs: <MWHPR1101MB22076F18C0E52DFC804A3F288C670@MWHPR1101MB2207.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qSlkAZ02+xCvnfQ+wabgz/MK2OIQ+5KYGdyU54lqkFdRAQjJjy1ot3KnLQyUPLYNQ6KXdEwZo+et70HL4oO8afljCaIuWk4wcqnwImK9R91ReJHdc0efe6CMdExeH+O3LIgh/Q/XWKx4e/2X1uHWsFyDMxGki2c539jVVlrRVUiS9sed2Rd137lC6zKHnp2g6YlzX+WrFiZ8Bh0dFHskeknOzkheM2PIxepzGCp6Y8x658hY3GMxiRrqfs6ZCcydYqiYk3cHKnP2toRmJ9g7emngeNtGYQLI18upQm9cqqqHQA8UAgY37Bvf6Y9+/Tu6NpigptBuC/jS9lVxzHFF1GZeFyXUnCR3F6dNtxB72Pe7/fb4oWfuICclZ88szzQU4DZP5Tv0fEuXvT4SUm0SIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(186003)(55016002)(9686003)(478600001)(83380400001)(26005)(6506007)(8676002)(4326008)(86362001)(8936002)(7696005)(6916009)(5660300002)(2906002)(316002)(33656002)(66476007)(76116006)(66446008)(66556008)(66946007)(54906003)(52536014)(64756008)(966005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dTbHlDGlTMxCbbt2gB3wodgntul3OdZeuL1tVnnIT5beaOY5zb7jNCIqq7SkbKFNC2Hu2DbzotdVleiWcQ1bBYt/jKeZUxx3GybM+gtWTMsjxYF8n/6TwfQayyTlZoLaN2RNHrt70N1Q2yhvfnX44I6sdzGkhM2BYYEQiIfZiAyvbB6HonM5OVC8oTOLPjsj3xLilSwR72922sSwPEm/AfJkpnNAQ7blXfOMAna1biAZEMq7zAQV6k2wLvNibADPzHhjnPTvqFsvYW3A90vGXsZmJPbBroJ3m/fEMJXoyVJ8aeAgubNNAQGxYs6jt6fY1lBhfkYthIcuZlLil8D+Q/1tJkzuVeIAq5b2WCGlpXOSM8vLRJwsL0ZxSEELR3orn0kSFg16E/tiID9ixCEFqR6UmDoeIJZXI0me8dq1r/LHpQwLEquPGeBknlu40aLnNTz5cXsDjFw6l/0iLedpjSUUbW5poKxmNL09EP2xr3NydYJRFHdadElE+EkhNlar
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3fbebf-df79-45af-2eda-08d823087b01
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 06:31:00.2341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cscc4Voy4LlsFFEZJsn5M+9G1aNrO6Gd4J6RqEVF027ml7hd/uJXOLPmRoIPaIjFRrGn0FwEiYI5BxJ5LYrN3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2207
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, July 8, 2020 9:07 AM
>=20
> On Tue, 7 Jul 2020 23:28:39 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > Hi, Alex,
> >
> > Gentle ping... Please let us know whether this version looks good.
>=20
> I figured this is entangled with the versioning scheme.  There are
> unanswered questions about how something that assumes a device of a
> given type is software compatible to another device of the same type
> handles aggregation and how the type class would indicate compatibility
> with an aggregated instance.  Thanks,
>=20

Yes, this open is an interesting topic. I didn't closely follow the version=
ing
scheme discussion. Below is some preliminary thought in my mind:

--
First, let's consider migrating an aggregated instance:

A conservative policy is to check whether the compatible type is supported=
=20
on target device and whether available instances under that type can afford=
=20
the ask of the aggregated instance. Compatibility check in this scheme is=20
separated from aggregation check, then no change is required to the current=
=20
versioning interface.

Then there comes a case where the target device doesn't handle aggregation
but support a different type which however provides compatible capabilities=
=20
and same resource size as the aggregated instance expects. I guess this is
one puzzle how to check compatibility between such types. One possible
extension is to introduce a non_aggregated_list  to indicate compatible=20
non-aggregated types for each aggregated instance. Then mgmt.. stack=20
just loop the compatible list if the conservative policy fails.  I didn't t=
hink=20
carefully about what format is reasonable here. But if we agree that an
separate interface is required to support such usage, then this may come
later after the basic migration_version interface is completed.
--

Another scenario is about migrating a non-aggregated instance to a device
handling aggregation. Then there is an open whether an aggregated type=20
can be used to back the non-aggregated instance in case of no available=20
instance under the original type claimed by non-aggregated instance.=20
This won't happen in KVMGT, because all vGPU types share the same=20
resource pool. Allocating instance under one type also decrement available=
=20
instances under other types. So if we fail to find available instance under=
=20
type-A (with 4x resource of type-B), then we will also fail to create an
 aggregated instance (aggregate=3D4) under type-B. therefore, we just=20
need stick to basic type compatibility check for non-aggregated instance.=20
And I feel this assumption can be applied to other devices handling=20
aggregation. It doesn't make sense for two types to claim compatibility=20
(only with resource size difference) when their resources are allocated
from different pools (which usually implies different capability or QOS/
SLA difference). With this assumption, we don't need provide another
interface to indicate compatible aggregated types for non-aggregated
interface.
--

I may definitely overlook something here, but if above analysis sounds
reasonable, then this series could be decoupled from the versioning=20
scheme discussion based on conservative policy for now. :)

Thanks
Kevin

>=20
>=20
> > > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Sent: Wednesday, April 8, 2020 1:58 PM
> > >
> > > Hi,
> > >
> > > This is a refresh on previous series:
> > > https://patchwork.kernel.org/cover/11208279/
> > > and https://patchwork.freedesktop.org/series/70425/
> > >
> > > Current mdev device create interface depends on fixed mdev type, whic=
h
> > > get uuid from user to create instance of mdev device. If user wants t=
o
> > > use customized number of resource for mdev device, then only can
> > > create new mdev type for that which may not be flexible. This
> > > requirement comes not only from to be able to allocate flexible
> > > resources for KVMGT, but also from Intel scalable IO virtualization
> > > which would use vfio/mdev to be able to allocate arbitrary resources
> > > on mdev instance. More info on [1] [2] [3].
> > >
> > > As we agreed that for current opaque mdev device type, we'd still
> > > explore management interface based on mdev sysfs definition. And this
> > > one tries to follow Alex's previous suggestion to create generic
> > > parameters under 'mdev' directory for each device, so vendor driver
> > > could provide support like as other defined mdev sysfs entries.
> > >
> > > For mdev type with aggregation support, files as "aggregated_instance=
s"
> > > and "max_aggregation" should be created under 'mdev' directory. E.g
> > >
> > > /sys/devices/pci0000:00/0000:00:02.0/<UUID>/mdev/
> > >    |-- aggregated_instances
> > >    |-- max_aggregation
> > >
> > > "aggregated_instances" is used to set or return current number of
> > > instances for aggregation, which can not be larger than
> "max_aggregation".
> > >
> > > The first patch is to update the document for new mdev parameter
> directory.
> > > The second one is to add aggregation support in GVT driver.
> > >
> > > References:
> > > [1] https://software.intel.com/en-us/download/intel-virtualization-
> > > technology-for-directed-io-architecture-specification
> > > [2] https://software.intel.com/en-us/download/intel-scalable-io-
> > > virtualization-technical-specification
> > > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > >
> > > Changelog:
> > > v3:
> > > - add more description for sysfs entries
> > > - rebase GVT support
> > > - rename accounting function
> > >
> > > Zhenyu Wang (2):
> > >   Documentation/driver-api/vfio-mediated-device.rst: update for
> > >     aggregation support
> > >   drm/i915/gvt: mdev aggregation type
> > >
> > >  .../driver-api/vfio-mediated-device.rst       |  22 +++
> > >  drivers/gpu/drm/i915/gvt/aperture_gm.c        |  44 +++--
> > >  drivers/gpu/drm/i915/gvt/gtt.c                |   9 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.c                |   7 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.h                |  42 +++--
> > >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 115 +++++++++++-
> > >  drivers/gpu/drm/i915/gvt/vgpu.c               | 172 ++++++++++++----=
--
> > >  7 files changed, 317 insertions(+), 94 deletions(-)
> > >
> > > --
> > > 2.25.1
> >

