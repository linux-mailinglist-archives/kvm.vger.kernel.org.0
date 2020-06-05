Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60FB1EEEBE
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 02:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgFEA1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 20:27:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:31472 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgFEA1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 20:27:44 -0400
IronPort-SDR: TcvsNA11R5nqdaXrLpyAQxSiEnOsICkhVupdomEG+S4QiwbnkCb2TjJQPTTvN+12csO/0Tkhpc
 uZBqSOmWcQPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 17:26:20 -0700
IronPort-SDR: A0jOHIQzFh3YLN6Kefj3GEQhlZEX0co/Rp36wr897tmUcAlAux6tDv8OSCoHIqc+Bu35Td6MtH
 B2w2BJmttPqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="258527670"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga007.jf.intel.com with ESMTP; 04 Jun 2020 17:26:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 17:26:19 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 4 Jun 2020 17:26:19 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 4 Jun 2020 17:26:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 4 Jun 2020 17:26:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyXFcwN08qPchzRqSZt83t1KI0wWb2HyaUzaTYGZZMJMAO2MG/b6m8KVaSOV93xfSkEbHezsMYlEOgSFCU3/sJRg4Vq3oK5ej/MGyhYeuEvWY56xAHKnPMhjrhP1Wsju4f3KJT4Pw6BAK1BBcqZXX6mPCTq82sW/cILFpV4UGsnXW1P18xLThe5/1yMHITNU7mr9mCkWGgyEv9ceCDFJ2t48LgdlVtovdbb9gncgmQEJdNHpNsEk+6XV7ajRBDWRKxHh1kDIxfG4XAOaMVeAhPR2RzQWDFs44ARahPhy8ooYiAsR1+SRlSJgI1iTotjG995crzF+NjLKZNCSoJlVpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwHxYx1CXToamFdmyK5Hq1QTps779dRvRNWoEExNhxo=;
 b=Uc+yuzu0KSpGENgE7cRpjKuskBeWLb/iIGXS4NOznzE9PYOJMz7unDj+/BIbQl2lrCIAFYpcKhsXvXOlGUPtikDMD/MfFgtwY31LzJak9Bh11HWunU1moDZtvGifr451+MwamdsfJLEpVnLFezVA+eQ02G0k6yOniKcYcobIn+QW8SEZJUU+KdJ9KzxszEPCTfi+nI7c+aWo0xXhgTAJ1QakWnuWkF204W1MoyXfWIp6aGxv43J06GP1U0fDL+EqKhZnGQ0MaL+FTgIhYZccxx0VkM0+wEAWJHPWfzwkACmzESWD6lNnGmz3wjmeAj04eRB+WNpuhGras81SXUWWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwHxYx1CXToamFdmyK5Hq1QTps779dRvRNWoEExNhxo=;
 b=WxARPlKEQMc7lKem88oszcdmQd267ez0LANuWLL1AlciDsAZgIn9o/un7x6LodYEZid7nrK7IXBtDIIpL6dif6IdfxP6YruaS4MdTvpDNsaF1PiPJzc32Dgs7clkCfIkxf6BL7isykTL+hr34c/hQD1YKNYlH3IytKoP49HEc0g=
Received: from MW3PR11MB4667.namprd11.prod.outlook.com (2603:10b6:303:53::10)
 by MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Fri, 5 Jun
 2020 00:26:10 +0000
Received: from MW3PR11MB4667.namprd11.prod.outlook.com
 ([fe80::75d8:d24f:501d:a0f1]) by MW3PR11MB4667.namprd11.prod.outlook.com
 ([fe80::75d8:d24f:501d:a0f1%3]) with mapi id 15.20.3066.019; Fri, 5 Jun 2020
 00:26:10 +0000
From:   "He, Shaopeng" <shaopeng.he@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Thread-Topic: [RFC PATCH v4 07/10] vfio/pci: introduce a new irq type
 VFIO_IRQ_TYPE_REMAP_BAR_REGION
Thread-Index: AQHWLMDfxMYbZXR6aES43GWa4YQ+iqi/q4SAgAO+ywCAAKOjgIABCEQAgAC5+YCAAGZeAIABZrcAgAA8zACAABi6AIABRl/g
Date:   Fri, 5 Jun 2020 00:26:10 +0000
Message-ID: <MW3PR11MB46671722B459551BB9CEBF4AE5860@MW3PR11MB4667.namprd11.prod.outlook.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
        <20200518025245.14425-1-yan.y.zhao@intel.com>
        <20200529154547.19a6685f@x1.home>       <20200601065726.GA5906@joy-OptiPlex-7040>
        <20200601104307.259b0fe1@x1.home>       <20200602082858.GA8915@joy-OptiPlex-7040>
        <20200602133435.1ab650c5@x1.home>       <20200603014058.GA12300@joy-OptiPlex-7040>
        <20200603170452.7f172baf@x1.home>       <20200604024228.GD12300@joy-OptiPlex-7040>
 <20200603221058.1927a0fc@x1.home>
In-Reply-To: <20200603221058.1927a0fc@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb46fbc2-b44e-4821-9063-08d808e70c13
x-ms-traffictypediagnostic: MW3PR11MB4635:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB46355503253C3ECD76671A8CE5860@MW3PR11MB4635.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0425A67DEF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oh1Nwnc8LDZAEhGDHMe34Xtvp6U1WgbPqrJaS+6E9FpzU+UIztKg86EZomPX5jfSxMyNLIx7afWvW/8on0uz33tghNX62UiOmF18Dm3T8C08zhmK8ROFkSogUrqebQwNC286AhkYu0FqTzRjaBprwy4qMdSBp1hHp7vQnY+sE/+mR5EvBKl7FEnkhPqAYgma1wEpTfb3w4iEpE1FXagul2sHMlKYkc/O06FoeWBxhx7BMBx7jter6E7m9+LAjaCc65846k9EH5XalO5JrGvqIlBy+09qwwwwMagunFph7GzdVNlc+Rb7sGjKVfDIhnElwftZxHECI493vwdfZNLjEn2umGhY4a9Q9Axs3leDibB+3xm7hrY4VHMW03/E5fTu6Y0i1FsBQjZdzxEzKM0A/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4667.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(71200400001)(76116006)(2906002)(66476007)(4326008)(9686003)(110136005)(66556008)(55016002)(83380400001)(66446008)(8676002)(6636002)(316002)(54906003)(66946007)(64756008)(8936002)(478600001)(966005)(52536014)(33656002)(6506007)(7696005)(86362001)(186003)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UJo1KEFvFa3aLQfQEix75RETz/2BDCSv2bgRB7Ps7fs3kdhZfGn6B1eqf9vRXH5Qhhtp6u7//0LG+VpSwXeiYsQiqCx9R0QAr+e72So0ZSBZMLZ6Pr7xqB1ibX2CkRgNRLeYupMuan+VpMBu4IHrkNk+IMywKVH0P4oSDDMtLjoeywxMrpoa2spEO7Zrwq6FbPvyOlUE2/BCt8xFVJW/mHq0EOybd/3M2XY0BX5ymBA1nasR8OOHMlp3BepiTH4ReT54sUQhudVAa0lxDmmJ5wndFkzuEUAq1mD9are9iHPqATjS40QTmhXTsOP0RYydmJybrmOyKyfyrLTdJewIn2goqh1yg5BBz1SI8Zg6EMquNRZyPLd6M1tw6opMdf7BTXV8IbbuYNipg+M/DgSe+Me6lMKtEmGa/RzM26HM+Sx4/uQIwONq6g1RfTnuT1w2Vvk9bj7YyQL/KonZBN5AyAXFiapNM6CgkLuMYxEl/oU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb46fbc2-b44e-4821-9063-08d808e70c13
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2020 00:26:10.4906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JeOER/IPZ27dlUi+dWYC2UfHzSzHYAl4+O8JQ6M3kJ05wjjTAHDNJlSJKm954aCZXPhADuAEHFywXQFGMdPmXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 4, 2020 12:11 PM
>=20
> On Wed, 3 Jun 2020 22:42:28 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>=20
> > On Wed, Jun 03, 2020 at 05:04:52PM -0600, Alex Williamson wrote:
> > > On Tue, 2 Jun 2020 21:40:58 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >
> > > > On Tue, Jun 02, 2020 at 01:34:35PM -0600, Alex Williamson wrote:
> > > > > I'm not at all happy with this.  Why do we need to hide the
> > > > > migration sparse mmap from the user until migration time?  What
> > > > > if instead we introduced a new
> > > > > VFIO_REGION_INFO_CAP_SPARSE_MMAP_SAVING capability where
> the
> > > > > existing capability is the normal runtime sparse setup and the
> > > > > user is required to use this new one prior to enabled
> > > > > device_state with _SAVING.  The vendor driver could then simply
> > > > > track mmap vmas to the region and refuse to change device_state
> > > > > if there are outstanding mmaps conflicting with the _SAVING
> > > > > sparse mmap layout.  No new IRQs required, no new irqfds, an
> > > > > incremental change to the protocol, backwards compatible to the
> extent that a vendor driver requiring this will automatically fail migrat=
ion.
> > > > >
> > > > right. looks we need to use this approach to solve the problem.
> > > > thanks for your guide.
> > > > so I'll abandon the current remap irq way for dirty tracking
> > > > during live migration.
> > > > but anyway, it demos how to customize irq_types in vendor drivers.
> > > > then, what do you think about patches 1-5?
> > >
> > > In broad strokes, I don't think we've found the right solution yet.
> > > I really question whether it's supportable to parcel out vfio-pci
> > > like this and I don't know how I'd support unraveling whether we
> > > have a bug in vfio-pci, the vendor driver, or how the vendor driver
> > > is making use of vfio-pci.
> > >
> > > Let me also ask, why does any of this need to be in the kernel?  We
> > > spend 5 patches slicing up vfio-pci so that we can register a vendor
> > > driver and have that vendor driver call into vfio-pci as it sees fit.
> > > We have two patches creating device specific interrupts and a BAR
> > > remapping scheme that we've decided we don't need.  That brings us
> > > to the actual i40e vendor driver, where the first patch is simply
> > > making the vendor driver work like vfio-pci already does, the second
> > > patch is handling the migration region, and the third patch is
> > > implementing the BAR remapping IRQ that we decided we don't need.
> > > It's difficult to actually find the small bit of code that's
> > > required to support migration outside of just dealing with the
> > > protocol we've defined to expose this from the kernel.  So why are
> > > we trying to do this in the kernel?  We have quirk support in QEMU,
> > > we can easily flip MemoryRegions on and off, etc.  What access to
> > > the device outside of what vfio-pci provides to the user, and
> > > therefore QEMU, is necessary to implement this migration support for
> > > i40e VFs?  Is this just an exercise in making use of the migration
> > > interface?  Thanks,
> > >
> > hi Alex
> >
> > There was a description of intention of this series in RFC v1
> > (https://www.spinics.net/lists/kernel/msg3337337.html).
> > sorry, I didn't include it in starting from RFC v2.
> >
> > "
> > The reason why we don't choose the way of writing mdev parent driver
> > is that
>=20
> I didn't mention an mdev approach, I'm asking what are we accomplishing b=
y
> doing this in the kernel at all versus exposing the device as normal thro=
ugh
> vfio-pci and providing the migration support in QEMU.  Are you actually
> leveraging having some sort of access to the PF in supporting migration o=
f the
> VF?  Is vfio-pci masking the device in a way that prevents migrating the =
state
> from QEMU?
>=20
> > (1) VFs are almost all the time directly passthroughed. Directly
> > binding to vfio-pci can make most of the code shared/reused. If we
> > write a vendor specific mdev parent driver, most of the code (like
> > passthrough style of rw/mmap) still needs to be copied from vfio-pci
> > driver, which is actually a duplicated and tedious work.
> > (2) For features like dynamically trap/untrap pci bars, if they are in
> > vfio-pci, they can be available to most people without repeated code
> > copying and re-testing.
> > (3) with a 1:1 mdev driver which passes through VFs most of the time,
> > people have to decide whether to bind VFs to vfio-pci or mdev parent
> > driver before it runs into a real migration need. However, if vfio-pci
> > is bound initially, they have no chance to do live migration when
> > there's a need later.
> > "
> > particularly, there're some devices (like NVMe) they purely reply on
> > vfio-pci to do device pass-through and they have no standalone parent
> > driver to do mdev way.
> >
> > I think live migration is a general requirement for most devices and
> > to interact with the migration interface requires vendor drivers to do
> > device specific tasks like geting/seting device state,
> > starting/stopping devices, tracking dirty data, report migration
> > capabilities... all those works need be in kernel.
>=20
> I think Alex Graf proved they don't necessarily need to be done in kernel=
 back
> in 2015: https://www.youtube.com/watch?v=3D4RFsSgzuFso
> He was able to achieve i40e VF live migration by only hacking QEMU.  In t=
his
> series you're allowing a vendor driver to interpose itself between the us=
er
> (QEMU) and vfio-pci such that we switch to the vendor code during migrati=
on.
> Why can't that interpose layer be in QEMU rather than the kernel?  It see=
ms
> that it only must be in the kernel if we need to provide migration state =
via
> backdoor, perhaps like going through the PF.  So what access to the i40e =
VF
> device is not provided to the user through vfio-pci that is necessary to
> implement migration of this device?  The tasks listed above are mostly
> standard device driver activities and clearly vfio-pci allows userspace d=
evice
> drivers.
>=20
> > do you think it's better to create numerous vendor quirks in vfio-pci?
>=20
> In QEMU, perhaps.  Alternatively, let's look at exactly what access is no=
t
> provided through vfio-pci that's necessary for this and decide if we want=
 to
> enable that access or if cracking vfio-pci wide open for vendor drivers t=
o pick
> and choose when and how to use it is really the right answer.
>=20
> > as to this series, though patch 9/10 currently only demos reporting a
> > migration region, it actually shows the capability iof vendor driver
> > to customize device regions. e.g. in patch 10/10, it customizes the
> > BAR0 to be read/write. and though we abandoned the REMAP BAR irq_type
> > in patch
> > 10/10 for migration purpose, I have to say this irq_type has its usage
> > in other use cases, where synchronization is not a hard requirement
> > and all it needs is a notification channel from kernel to use. this
> > series just provides a possibility for vendors to customize device
> > regions and irqs.
>=20
> I don't disagree that a device specific interrupt might be useful, but I =
would
> object to implementing this one only as an artificial use case.
> We can wait for a legitimate use case to implement that.
>=20
> > for interfaces exported in patch 3/10-5/10, they anyway need to be
> > exported for writing mdev parent drivers that pass through devices at
> > normal time to avoid duplication. and yes, your worry about
>=20
> Where are those parent drivers?  What are their actual requirements?
>=20
> > identification of bug sources is reasonable. but if a device is
> > binding to vfio-pci with a vendor module loaded, and there's a bug,
> > they can do at least two ways to identify if it's a bug in vfio-pci its=
elf.
> > (1) prevent vendor modules from loading and see if the problem exists
> > with pure vfio-pci.
> > (2) do what's demoed in patch 8/10, i.e. do nothing but simply pass
> > all operations to vfio-pci.
>=20
> The code split is still extremely ad-hoc, there's no API.  An mdev driver=
 isn't
> even a sub-driver of vfio-pci like you're trying to accomplish here, ther=
e
> would need to be a much more defined API when the base device isn't even =
a
> vfio_pci_device.  I don't see how this series would directly enable an md=
ev
> use case.
>=20
> > so, do you think this series has its merit and we can continue
> > improving it?
>=20
> I think this series is trying to push an artificial use case that is perh=
aps better
> done in userspace.  What is the actual interaction with the VF device tha=
t can
> only be done in the host kernel for this example?  Thanks,

Hi Alex,

As shared in KVM Forum last November(https://www.youtube.com/watch?v=3DaiCC=
UFXxVEA),
we already have one PoC working internally. This series is part of that, if=
 going well,
we plan to support it in our future network, storage, security etc. device =
drivers.

This series has two enhancements to support passthrough device live migrati=
on:
general support for SR-IOV live migration and Software assisted dirty page =
tracking.
We tried PoC for other solutions too, but this series seems to work the bes=
t
balancing on feasibility, code duplication, performance etc.

We are more focusing on enabling our latest E810 NIC product now, but we
will check again how we could make it public earlier, as low quality i40e P=
oC
or formal E810 driver, so you may see "the actual interaction" more clearly=
.

Thanks,
--Shaopeng
>=20
> Alex

