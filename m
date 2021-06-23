Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440E73B1545
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 10:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFWID0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 04:03:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:24271 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229902AbhFWIDZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 04:03:25 -0400
IronPort-SDR: 6oxvM4+FlbPgMDpuvcb2OCD5VHajd82hNKVb6bGI4IYNu/RzmD6p5+VDoNJEEzmWip4HSqkUrZ
 JZyNcfTKzL0g==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="292843249"
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="292843249"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 01:00:56 -0700
IronPort-SDR: vX5NoCCcFe6G/piKXxfb0VjKG7o/NQbinEUDQlvfZeGQoKOww73c4fmF10koY6zCwMZTFR3FRp
 5SRQ+rkqTNUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="454563172"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2021 01:00:56 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 01:00:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 01:00:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 01:00:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJWNsKf4BU78mkFD9efhBGClPXYm/MzVN1bO6JFsVp58r8+rP2yAs2xzsohPNAbrWu6u+PjfSxP8V+JQQ9fHTNKiEPfiYnVlL0hfRlf1VVsk3JFtRIIGVsWdXWxOlIyFRGp57Soh8/ulxSw9/2AJAmTokKVyGTllh7tGe2x/6MGzuk/V/vl6A/xleQRR3ssDS0/TVi0YNWIK440sTR/bgjFOk3qY/tVnAoYX07l/G+PRRFy1KeObRu8O21wmBFPLAc+ml1TQ454XmOxfVQHHugwyKTE/cgTTJmDW6oXgRky/prqjHrFnVovCTZJ8fmGSHDEeU5FZ1SzeAmoxyasjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39ofjA0oANVXTPxcBxfYjxhfF4ik8C2GsRarUCFSUVo=;
 b=P56FchOroKSDWNj2s+QCuH8b+JTi9BVXPKg2psjJZ50Olqs+gXaSS4Lvd+VmMvTu3gPJyubbdWoD4hcfVBUOgEXFTDes5Sb8+W2ES8wo4TF3u3cjmz1y1Ou71JnlJZDXVUv+e2SPj0CnlKH3C2YBt3WgO1BmTCmBsYlLj+xuyTmLqXveWieZBdCJxjBWrOPshlxPu4suvrHoIBDcu0KE33FIA66WTHlb73KoPHPFuPGLEP4EqrYO8nANihAjP/9a0B0IQifQoXhN/KhGJ7PizVwXRvdVHhm8PuEx/eP1/lOXjmPSwO3/iRg932x9D15HnWvu1odoSvSNSlCAh0FHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39ofjA0oANVXTPxcBxfYjxhfF4ik8C2GsRarUCFSUVo=;
 b=acj6TCBPcHV8wA/m4YUKtCdg+MGJ0JQU6vIW8A858LAM8BUNKRyDuo1FrAb5W0akSneOAsmeyQwAOxu7nC25WtT9rmsB14vNF7q/6YtqlVqGTZVUPORoL9w6s2rGltDm2rVmDw3tDI2DufaeCvRDtOE/Q/kbjolvuV5asJXu0cY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (10.175.54.9) by
 MWHPR11MB1933.namprd11.prod.outlook.com (10.175.54.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Wed, 23 Jun 2021 08:00:49 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Wed, 23 Jun
 2021 08:00:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ97BhCb3gd8AUyldaDZ6yOMNAEqZK+AADR4pXACuXPOAAE11w8g
Date:   Wed, 23 Jun 2021 08:00:49 +0000
Message-ID: <MWHPR11MB188672DF8E0AC2C0D56EF86D8C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLch6zbbYqV4PyVf@yekko>
 <MWHPR11MB188668D220E1BF7360F2A6BE8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMrKksUeNW/PEGPM@yekko>
In-Reply-To: <YMrKksUeNW/PEGPM@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.143.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78aa1a14-4516-4f41-fcb1-08d9361d0392
x-ms-traffictypediagnostic: MWHPR11MB1933:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1933634B679641D975E1FEEB8C089@MWHPR11MB1933.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Cvxe4AYBGUKz98Xo4PcYZs7SSKoMc80YZVNQz65KfdgDSRlBTYTBmgD60joFqApoPTTJx/akyzyYVJqOy5YOiSzB1UAM9hGFOtrjDDsBEjY+5DrUQ7/irffoo2kJNudlK5ypMFHKTPIPnz/N65Nty8qtbsVqWZDFk2P5oef/uQpj7E8xMpUlzPKu1WMVe8KcKLK3hO1qXJnyR2hy6G+186bgw3z5GbQfklnP4u/nXUxWW4mnTvWRu8MFbQjILJ79Jl6OuL+WA34gB4wGxB2RkLoWkyyWGAamC6wDkutimnsAxBE5TdEYtGmFOAciPveg1YIK3EjMfJtw/mD3USW5jhBwKCM3JtYMOgg3oU8f/yEKJ/cUlX9+WOxvFf4J0X85dldehzzpd3Y/QqBff8Fd6tS0jRLpmTpdudnHT8eIwmDas88PSZZ9qni/1TfuQWQnIlgQALWFCpVddSI47Q7CqO+mo0X2A20aOMTm/QyN6SGxglh1y8H8mkufJ3ml5oxU8INZBqkOIj1unsJTcIksalS2R/WQmmjYAhRKWpFVerfCyfSyGn7kw36CI2zn+jjggqpmeFm0Hj7+iWSyIxjgg+8dlQdM2tWyMBOI0xZAIg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(71200400001)(4326008)(86362001)(7416002)(66556008)(2906002)(66446008)(478600001)(6916009)(83380400001)(186003)(122000001)(26005)(52536014)(8676002)(8936002)(76116006)(7696005)(54906003)(55016002)(6506007)(9686003)(316002)(5660300002)(66946007)(38100700002)(66476007)(33656002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8H2llP44LElefVBZX64duZXMHhiNZe07g6HBeooER+YgVScenuUwq2zSmNE6?=
 =?us-ascii?Q?jkj/lkicguce81Zx3H8gq/1mSFgtLXizH4NyyK30RxUUspF9d1NBrhGp4g2f?=
 =?us-ascii?Q?cNl0lSHfk0gDETUucKpQMc8kTVnTQi/WA2e4mnoDQHCJ5/hf8o9m5jfmpTCo?=
 =?us-ascii?Q?baV1Jz1iyaS51JWAJgPLzHhWLzdN0kMWgc/y28CsnY5ueXC/aFJTwbD8re2K?=
 =?us-ascii?Q?EeL0Nl37NxnhradUkORqlm5mO/iLjZdCZKwZS1hwuVqfG4DPcM5rL3nNbx/C?=
 =?us-ascii?Q?sWmeCCQPFdan6RjL/BKu4K38/fccKlBvgAeAzSnUukWiNMk/SoDdos2yTY/e?=
 =?us-ascii?Q?V5MwTJeUaWcLCnblo960QA20gP1Ecfjw5Qam1HNSmAlZjLNpoA0xuboRY+jK?=
 =?us-ascii?Q?vj0iN3eK1sco8LTIZGUlVdzR2ufzf68C1ZjgZxjO3dGfR48Bzj5kAqNg0Nzr?=
 =?us-ascii?Q?aMhigmxw8mlztmAN6bFNA2vgAdjqVTR3Pu7IOhT0ONY3s1eIO91FHjQfuTS4?=
 =?us-ascii?Q?HfC6rrpxWq1tquXaqiUunXgsMWgfXYKyFsCnlmBltJesxshyD/qTWMNH97tq?=
 =?us-ascii?Q?XVysbs0g4m8TuRerALeA0rgdMvK0fN+lBtqRyG47Hu6ruQwjb1pzXjMD9AVn?=
 =?us-ascii?Q?BCS7E2V5EJpKp6izDttkUlGzI6h5+GTOsYOg2jGHbygzuxRgmhEKUkSyprLB?=
 =?us-ascii?Q?O9Re1yUzsFmOnPjLg2LNFnUIRQ8I67mxmC5G8Eu7UBcQ8S7FH7wtV2pThAXs?=
 =?us-ascii?Q?YpMOUfphrkQPnJwPdh9Kyxn7iGhX/10o1YvMuRMOwGLVg87m37icT8fLWKBq?=
 =?us-ascii?Q?MHg2CJp9FLs3ydtp98WVia2rvgQrm6TfNVT6FALonNNeMutjM0Ofpr4CjQPx?=
 =?us-ascii?Q?ZkiH08B2XsFML2DTmp3PHX+GqBDfFiWtb886gCYJcXGJBS6m/VmzO3DPvrUV?=
 =?us-ascii?Q?GMUW2UlEGsJfa1Az1YkqgVPoCoLHlWpeQHLlc9PjR5vKzUNcBi4yUrbBpVV7?=
 =?us-ascii?Q?FxX4L4Z5vxNec2pYZZHkKdZfXI8Dpt/srlZkLBjGAYkUXQ0QpzmWIYtFB45D?=
 =?us-ascii?Q?x5e+F8lCkyVakdBDg55i/E2G83uXFaZVTdxwyW2wF8mszsbWpH38iwr5SH7l?=
 =?us-ascii?Q?2AQFBNPzOiFHoGPoEKggmzkjgxzFXevy4QWoLe66ezU1A8c/uZ5D7AWXOx7c?=
 =?us-ascii?Q?ySVORtEWSjgqvUappdAK5gk6BBaMlyfTAr0RIy56GzesUsVqtsmZW3tD7eJw?=
 =?us-ascii?Q?to6mh/NDqrW0itgTFYOyrvzGv7c6Z2QUoOmUeLkGfO+jAz9L/gopCo8uxYZ2?=
 =?us-ascii?Q?0RgUXHyXeZlkeZG1eVIBLKij?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78aa1a14-4516-4f41-fcb1-08d9361d0392
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2021 08:00:49.0352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KkAXK3VlLxAVMp4JSNV1X39BurHGiJjJbRiCwTfW5vU+AD3lhb4Fs1k0MB1Qjter8herewH5G0pMesWpiWi+0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1933
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Thursday, June 17, 2021 12:08 PM
>=20
> On Thu, Jun 03, 2021 at 08:12:27AM +0000, Tian, Kevin wrote:
> > > From: David Gibson <david@gibson.dropbear.id.au>
> > > Sent: Wednesday, June 2, 2021 2:15 PM
> > >
> > [...]
> >
> > > >
> > > > /*
> > > >   * Get information about an I/O address space
> > > >   *
> > > >   * Supported capabilities:
> > > >   *	- VFIO type1 map/unmap;
> > > >   *	- pgtable/pasid_table binding
> > > >   *	- hardware nesting vs. software nesting;
> > > >   *	- ...
> > > >   *
> > > >   * Related attributes:
> > > >   * 	- supported page sizes, reserved IOVA ranges (DMA
> mapping);
> > >
> > > Can I request we represent this in terms of permitted IOVA ranges,
> > > rather than reserved IOVA ranges.  This works better with the "window=
"
> > > model I have in mind for unifying the restrictions of the POWER IOMMU
> > > with Type1 like mapping.
> >
> > Can you elaborate how permitted range work better here?
>=20
> Pretty much just that MAP operations would fail if they don't entirely
> lie within a permitted range.  So, for example if your IOMMU only
> implements say, 45 bits of IOVA, then you'd have 0..0x1fffffffffff as
> your only permitted range.  If, like the POWER paravirtual IOMMU (in
> defaut configuration) you have a small (1G) 32-bit range and a large
> (45-bit) 64-bit range at a high address, you'd have say:
> 	0x00000000..0x3fffffff (32-bit range)
> and
> 	0x800000000000000 .. 0x8001fffffffffff (64-bit range)
> as your permitted ranges.
>=20
> If your IOMMU supports truly full 64-bit addressing, but has a
> reserved range (for MSIs or whatever) at 0xaaaa000..0xbbbb0000 then
> you'd have permitted ranges of 0..0xaaa9ffff and
> 0xbbbb0000..0xffffffffffffffff.

I see. Has incorporated this comment in v2.

>=20
> [snip]
> > > For debugging and certain hypervisor edge cases it might be useful to
> > > have a call to allow userspace to lookup and specific IOVA in a guest
> > > managed pgtable.
> >
> > Since all the mapping metadata is from userspace, why would one
> > rely on the kernel to provide such service? Or are you simply asking
> > for some debugfs node to dump the I/O page table for a given
> > IOASID?
>=20
> I'm thinking of this as a debugging aid so you can make sure that how
> the kernel is interpreting that metadata in the same way that your
> userspace expects it to interpret that metadata.
>=20

I'll not include it in this RFC. There are already too many stuff. The
debugging aid can be added anyway when it's actually required.=20

Thanks,
Kevin
