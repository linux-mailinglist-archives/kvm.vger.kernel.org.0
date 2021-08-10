Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CCF3E533A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 08:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhHJGE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 02:04:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:50776 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhHJGE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 02:04:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="202012655"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="202012655"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 23:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="468926250"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 09 Aug 2021 23:04:34 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 9 Aug 2021 23:04:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 9 Aug 2021 23:04:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 9 Aug 2021 23:04:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4dUomyI41n4RtWUgSF2B+pnWmvjPI8cMn3qBcY/4MgvkBW7zK6Xvamikc/ARyE8kV0aSRER8H2bHrpbrvC6qTGdDLPWb/XosSDX8M2ErwlGtVrLYz8NL9kZIiEKKdstXItp859VCl+ivb8xIOZFltVz0UkGW3NHU4bP9lqMrfP3U3U0rvHCPYA80PlyUYIObtX3C0exN2nE0PiZRsGp/7Wzm1D4k6Z9PKsfMCjiySKLJZK48tWO0OnqmeW1zyLvb1fc+zNgAmtPjGMDm8+poDNDmbwYPADciYFwjKgLRHtjDNtYi9zj1Tn+S4X5+kgZyfkH4neS0FBd/EoOnRNnOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixgGi681s1mYtspGSdfrPlLmTkUpihBcDA0DmTdgk6U=;
 b=ZcZ7Z3zUILEuedeX5Y6s2i69x+zWEO6q0Y6zXOjLSwmOwjiAR0Z/xVtsfilvEsRwnbSueKkykU83AwBEn+wpKjJ1J8cuxFSDqCAIIY3Tbi+5iPT4TKFBqE2Xq9m/d3KydDeb2nHHPBh5vY3Mb6h3OFiVKJXUfCIU9k1wBrADmL2x7baJ6OSsyXGyeuGMWMvKNHIdF7ki2mTnpACE/+SE1WlFLbVtwZXF7EYIVGyiXDXeSSpVrwbAGJQRl4M6mkBgZYZMMAyjjm4fRqkIHUVGPpaPYeuo9SBI/t/K9fzPI5HMjzrx6jobxLvEizD1MuWDkuzwbw9nJCcU4dhzA4mjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixgGi681s1mYtspGSdfrPlLmTkUpihBcDA0DmTdgk6U=;
 b=euDcbGn6dW5aOsjoXGnE4F2FEaP3Za0p/hk0DhejbLVgvFyTKaVKi1RX3XYhSe5YojgKjHxjtU+fs26CuTiZNcrpDsd8mXJrHt3XPPUjTF+u+9aeNBJs9hE8DlT7rtru617YaUNgyizL6DHKd2soIp/Dby6EF8oyeTY28Xh17dw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1763.namprd11.prod.outlook.com (2603:10b6:404:103::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Tue, 10 Aug
 2021 06:04:21 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 06:04:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNQxoYAAGGEwqABKoT0AAAAch4QAJyI0wAAnMDPwAAsfuqAAAI4CRA=
Date:   Tue, 10 Aug 2021 06:04:21 +0000
Message-ID: <BN9PR11MB54336B63A92F28E4A158DF3C8CF79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <BN9PR11MB54332594B1B4003AE4B9238C8CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQig7EIVMAuzSgH4@yekko>
 <BN9PR11MB54338C2863EA94145710A1BA8CF09@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YQy+ZsCab6Ni/sN7@yekko>
 <BN9PR11MB54338800A20821429D7C34038CF69@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YRIE9eDADmPoWWg9@yekko>
In-Reply-To: <YRIE9eDADmPoWWg9@yekko>
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
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c7017df-5aca-42e1-20d4-08d95bc4b284
x-ms-traffictypediagnostic: BN6PR11MB1763:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1763020627E0769039AB59558CF79@BN6PR11MB1763.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pz6nGC3E1cl771CJzUlwV+ZIW/gK3rjFgFAEJ1bjw3KmqdnIYDBkZrBKKvS6fX3MS4JpX6r+qVBdRcysjnl1WBwj+AdIuYg1REBRVZO2UQXDIO4dhQYWuIaP40LpBGJ+1ajdOK+5Qaw8Sb8fflgRcfHk1w8k8/GRCuWUq/dV6yRPW/V+jjI1RZWSPKXW860UWqL6eQOPOh1I48VPx+HTceOXL3c+MT0Thg030erBbXE/7XCZlwahPJRjg9WMCKY7+oiljreACO/i4sdNjmnl01q2ACggZmGtjJvTjQaTgHu5pMrSVVCDdUXHNa/PJjEmz01ATGfuXpApzCGwTKamKUx9BdoxV0sU4kTxTuIqcOR1C3MxL0AnUuKBDn8Hc1ME6qrz/egnJhUr3b/5Yqd4FFEF79dElYBKDvKhNFU73yHYj7dE2nwP6t3wEsz+uBFAakro73XCEAY2WyKATeAowjzhIZ3+GTNFfd3fz4CoVGCs8QuY+PaEhlQkh2kNOm29FCVhp1aXb84DWMVJrDGIm7fFTwyXyHBDWxSga/42YcENW2InUBSeMqR2ROyNeAUaC+WMsd4TnXvzePNPlnsEcIno40VaGnzyEonJ55iF2QZyA5MfxDgF4ElBfn4JH3WYuzvJ0JvjMnTRkUb2nHmx3zi2XVbl6JNGqAhC6UdHgXoH9TVPeEZ6VnhgXDVWkkIcu92Q/GwlITPv16k3sqqCQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(52536014)(4326008)(64756008)(55016002)(66946007)(5660300002)(186003)(66446008)(66476007)(76116006)(9686003)(6506007)(26005)(33656002)(66556008)(508600001)(38070700005)(8936002)(7696005)(7416002)(2906002)(38100700002)(71200400001)(86362001)(316002)(122000001)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: plHfgmC98rfT1m8gXgyYLZcUjUPYqTpA5WX3048wIcuh/gsAwockOqhOFaN63zYAheJYDNb0jPEhvP5dXPMDko9CT9nwnvrbD2ioK/ml+y4u05bEJp1UJvTky9yYv5SVybozVzJTWYvX2bKByIlURkSIuS0Uls0XU5mY10UKgVCAYzSnTQ3QC0w9bedWZ+gbaCYpcenH5ZtGM+r1s0ebdW6c7k+pmzp67xm1FDrtncP3oxu62f9z+82BrdyeQsmFvX87JKwaDPuWplAGFzWXej+wabWp8+EWgPhPmcvf43M6rSAbOBM73rrHr+vZwDFsvAqrSj4SkOkVQ9gxES6eJjQ5iXOuhCAptJsDWw65dCM8GczMgOaRGzV2yph0c75CgaE/rETwlVIhRk/B+tfJVBoh9A4r9T+MJjSv0GgIup6BKXAMszR+5OMSVKMKU+LzLqn/pvGTmTWeZTH80i4OHJazVdsn9jQsbLX9H8yHBryAhoKhugCWbdUcPIPTv/JrUgCGEPuoxEYt8nk+uf0ABcAtBBpb0HJaN1uLXD7bAX68DcWltpbtPe+kkEdL5eZFjhNY9znY54AhaFCEv0wJCxCOdKvWhCxx67BQDLqAdyW0Qz+lHrU5CKifQ2kpPLhrp9XCeQiO2voHNtaGJpT1MP2xOQkUE5b9pdAI6Gta5dLUjsrBbIocSeAz2id9Xda5uxseeIOgngd9CqtFAz+ayxEipD/bpluz5+D7h7lXZQM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7017df-5aca-42e1-20d4-08d95bc4b284
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 06:04:21.5052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xxYymDVAc90bF8fW7BhiUosPGtmhbx3rlz8Q6oaVBKsCFUZvXtQhO9VrevWu3Xpzo5zsGxR3O2m0Ude5G5MpOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1763
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Tuesday, August 10, 2021 12:48 PM
>=20
> On Mon, Aug 09, 2021 at 08:34:06AM +0000, Tian, Kevin wrote:
> > > From: David Gibson <david@gibson.dropbear.id.au>
> > > Sent: Friday, August 6, 2021 12:45 PM
> > > > > > In concept I feel the purpose of DMA endpoint is equivalent to =
the
> > > routing
> > > > > > info in this proposal.
> > > > >
> > > > > Maybe?  I'm afraid I never quite managed to understand the role o=
f
> the
> > > > > routing info in your proposal.
> > > > >
> > > >
> > > > the IOMMU routes incoming DMA packets to a specific I/O page table,
> > > > according to RID or RID+PASID carried in the packet. RID or RID+PAS=
ID
> > > > is the routing information (represented by device cookie +PASID in
> > > > proposed uAPI) and what the iommu driver really cares when activati=
ng
> > > > the I/O page table in the iommu.
> > >
> > > Ok, so yes, endpoint is roughly equivalent to that.  But my point is
> > > that the IOMMU layer really only cares about that (device+routing)
> > > combination, not other aspects of what the device is.  So that's the
> > > concept we should give a name and put front and center in the API.
> > >
> >
> > This is how this proposal works, centered around the routing info. the
> > uAPI doesn't care what the device is. It just requires the user to spec=
ify
> > the user view of routing info (device fd + optional pasid) to tag an IO=
AS.
>=20
> Which works as long as (just device fd) and (device fd + PASID) covers
> all the options.  If we have new possibilities we need new interfaces.
> And, that can't even handle the case of one endpoint for multiple
> devices (e.g. ACS-incapable bridge).

why not? We have went through a long debate in v1 to reach conclusion
that a device-centric uAPI can cover above group scenario (see section 1.3)

>=20
> > the user view is then converted to the kernel view of routing (rid or
> > rid+pasid) by vfio driver and then passed to iommu fd in the attaching
> > operation. and GET_INFO interface is provided for the user to check
> > whether a device supports multiple IOASes and whether pasid space is
> > delegated to the user. We just need a better name if pasid is considere=
d
> > too pci specific...
> >
> > But creating an endpoint per ioasid and making it centered in uAPI is n=
ot
> > what the IOMMU layer cares about.
>=20
> It's not an endpoint per ioasid.  You can have multiple endpoints per
> ioasid, just not the other way around.  As it is multiple IOASes per

you need create one endpoint per device fd to attach to gpa_ioasid.

then one endpoint per device fd to attach to pasidtbl_ioasid on arm/amd.

then one endpoint per pasid to attach to gva_ioasid on intel.

In the end you just create one endpoint per each attached ioasid given=20
a device.

> device means *some* sort of disambiguation (generally by PASID) which
> is hard to describe generall.  Having endpoints as a first-class
> concept makes that simpler.
>=20

I don't think pasid causes any disambiguation (except the name itself
being pci specific). with multiple IOASes you always need an id to tag it.=
=20
This id is what iommu layer cares about. which endpoint on the device=20
uses the id is not a business to iommu.

Thanks
Kevin

