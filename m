Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE73F3FD446
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 09:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbhIAHN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 03:13:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:5561 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242416AbhIAHNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 03:13:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="205883106"
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="205883106"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 00:12:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="460594601"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 01 Sep 2021 00:12:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 1 Sep 2021 00:12:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 1 Sep 2021 00:12:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 1 Sep 2021 00:12:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 1 Sep 2021 00:12:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaGVt8NDQ1oepWOqMng+E9rp9nFRzHtmgKuDdWg0SxTU7AlN9rIsra3okto1cHDRYVX/az/TvtAHrfnAlF1pg3YiP8hKuoSMz4PFFw7/hKPj/3p0mhYi0KfzDjoKLmgNEDg6cXgsd0dezIN6VREbo7Tui5Sss/lIT24i4BQTffYHubWkcFBGhKroTgSxelRSEl7shaixdBTvacY6eFZ34Tv7e/SDeI8odqjZYKRPqddMzgkuToIGfNWxxSyoztdnty+1VdwW7pJ4U2XBAAiGY9VsnQ9L5KXCH0aJ11cO1t/06g5OxXI7+u2vBZ1f0S81D82spmGbsJqNPcVh/VdK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5ymi2hYP+gQ3CUGVfT0uT+hWJtZkzQFcrDY/cqYuuRU=;
 b=VEAqnOpmrvYMSDbleW1KwH9pEA8SNpMRQLRB7JD+nhpHmVHIk6A0l62H/Wwf1KixYdgNrp1pqOIFUsROQjC1YI+vwALO0OaeVjq1xmQ3YpnqUA58eRosHyznjK7DQFeRpDx3ZBiI0Ql4SWzTx2zw1tkOJYUXj2dV7+pXOByBbMshopPzo9AMXEZvI+ghAQx8ZmKOMpwHRFVoTW16Vr20wesQudXJZ/FeafAK31j7zmrvjXICEqAXEZqjaKCxcIOqkmLAxSLG1Vp5fktGq5EMVe45e1cVShgjsTYWyisPUEyhQWPMbWx9Dt4bORVKnTVOfS73uj8meBgQDs/WobC6bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ymi2hYP+gQ3CUGVfT0uT+hWJtZkzQFcrDY/cqYuuRU=;
 b=JsOeqDMSGLe8bEQepLTHoa7u56Pqg/5lz+2Z/TdndJPC+/0eRSzLK+jSdwTomy1z1ev5ENxu+x6n3CdQzFYPycs6fuBVk9ETICMA5v4GWqi8IAuqOuL6IBOfHMtS3zd+vdbXi9W6yuHqq1Dt0iXFJU4WRMz8iLCRg88SwlcWfiA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2146.namprd11.prod.outlook.com (2603:10b6:405:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 1 Sep
 2021 07:12:23 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%7]) with mapi id 15.20.4457.025; Wed, 1 Sep 2021
 07:12:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Lutomirski, Andy" <luto@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        David Hildenbrand <david@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        "Dario Faggioli" <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: RE: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
Thread-Topic: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Thread-Index: AQHXmIJyggQQp5tSKEWVAVM9VOlCiKuFlagAgAEQtACACAM5gIAAI4JQ
Date:   Wed, 1 Sep 2021 07:12:22 +0000
Message-ID: <BN9PR11MB5433876DE6B6B92F9B50E3A58CCD9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
In-Reply-To: <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c47e7d03-c9a8-4c7e-fbc6-08d96d17d84c
x-ms-traffictypediagnostic: BN6PR1101MB2146:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB214608076D8ABD39DB9E05B18CCD9@BN6PR1101MB2146.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b9OrkwlfHX/afUilYDdhvh/fcXk/HYKd6xvI+mRsO6YwIdtER43xxNcmyqA1J/lEYRayB8tUvY4anRRLG4LgVmrudVzRrSxQVD5JyvzDd6AzDRYIjgkts+f4ExQJ0QR6pp73S2oP7pXk6nFlfH3tASlC0IQji7p/9JcGPD8L32FjW+3ZQ17/6U3+Ip+ntwJymD/hb0PlCcNhnUSx/8aUBWMFUT5YsFBowKBPF5a88bADp99/yK5XCDxJJVMzSCB3z97WO+ewbmOsJ4fnsCIGAOrbZjej4vAEYdXsYih29SMX4LRRl/MVqfZHLs9atzrB93MJzLj28OYrLZP52g4SDxSyFTbAxfekqBlHGQTafPRjtAKXcQMWeGRSYlyuWp84boZq4ZQt1VyEqqVyWppcvz+LcL1k93W5aJTJh5x+ZxZCwEFQycfbxzwLpsvQ1tiVidmWC3+mT1GQEncuWknevPyiymW+3eI6MxupW/ixvcC9JBABMUW9KKb9V8kth9kvu9zXpUXJmughnARqmE0gt5oS9OATxpJZOFI+/b+wp/sL5LE1jUOVeXZXCyivSyPq/vKFICOHuZhpcx7P3pZ0xk/Usvqp4JgrgnsVDgGs9p9qMCtpPBE1uUtvDI74nus/gXYymKdYjQM0OePLVZC+8BdVZLA/BzwBSoVFRj0m/jCaV4hfTF8+R3uxm4N4moq5d8vO/NeO70dQliWyKoKMriGlH2YgIrOBJFCBdRzfd3pNegnm4pDjaNkdQKvB8/nxZl3ZKb7sS1qiPEmDbcPKEUXYutAUwHqnHVRPyVFRxpQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(7416002)(8676002)(316002)(7696005)(86362001)(5660300002)(83380400001)(9686003)(52536014)(110136005)(54906003)(2906002)(71200400001)(4326008)(8936002)(33656002)(186003)(64756008)(66446008)(122000001)(38070700005)(66946007)(66556008)(66476007)(6506007)(26005)(76116006)(55016002)(45080400002)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9HJ8zlZvIT+pD8Kd7x41TU+Ur+R2lIwltLvxIZKIcc/PgVMRMBTTKFcypyM6?=
 =?us-ascii?Q?qYJ6mts2CzXv8ThT/TqfTE5e6aAg1lfwOKFWg4DU385nsNj3VqYzzpoBEyKF?=
 =?us-ascii?Q?Qwg7JzQFFccU9Y3GR2+B1LCEr6FdWxJhVqeySixh2SWUzx1AxHQzkkjQpCZW?=
 =?us-ascii?Q?VZ1mZMYRfYsrso2fdKGb2irimTzKgLtuWSx1ouRl//00wabcfs4v9BQx+lDK?=
 =?us-ascii?Q?6cPu9LJ9NLKLXe9ncWm47UR3le72NdSNIUkVpYLRaA4aIeIsGymUtNGwkkhO?=
 =?us-ascii?Q?ncW9GGOErSj+ofAvVKsjjMugRCZXzQyMhsjb69iv2qHpPP7/6UKNP/9IGKlm?=
 =?us-ascii?Q?VQDCzWy9X0e4uTJLzi9FNzUcAQHbOtH2LIGg+K2UD8PoE9PZ4otRrEvRsL9m?=
 =?us-ascii?Q?d1TX5CCQJ/iJWitehG3o8OvhQJCXiRVnjFGkSw2Zhex9qHeNgW33Rwsi9gjP?=
 =?us-ascii?Q?YEnFYbdYJQVR12JBkb+zGzzA4YrZKpdTRzJ+TGUGumaoq7oPVWp4jiFv2Hfa?=
 =?us-ascii?Q?DatoBGDaYiNUMRJw6J85WLQFrVRVv1wr1o74XANHmI/c6xyC894hMeB+ZcSH?=
 =?us-ascii?Q?W7AYU0CoaMhkgnbDmGwDnoiIAVuER6pz/t1O0cEb0Nx/tQD/BkrCq3Db9Tm7?=
 =?us-ascii?Q?O0RLOT4e3wPn5c1QAchFq/XmIQxNEV/xy/bm8+yrBTdxJYCTXIxG/cXmoZME?=
 =?us-ascii?Q?hg7DC0Lgd+R/fZAeCbowC4gxUPETmkbRkobfUI0afUhatiXs6IiM2lHXLn5O?=
 =?us-ascii?Q?sb+KdN/jhuyC20otZPPHsRLv8Sd8Kj0ONk8S3spIbDBhNMjZR7sUd0b111Tm?=
 =?us-ascii?Q?WOSkorNQYuYaqj9vYJZHhS5oUM8VAEYEIO+5z/H74cTImzGZsoMQHDDL3eOc?=
 =?us-ascii?Q?AlWNjBLCDxPTRo7s/h9zo8LwZgnDk+q42KktxZuZOUIoZ0+mmaOUuG6aXI0F?=
 =?us-ascii?Q?I+fXAi11objmEtvmHOhf3HKx62hTLCz9DvF2DemMEu9VG/anc8hI1owmKMKE?=
 =?us-ascii?Q?7lOKzf43dmkYv+xSShiDrZZ86AcxgwcHqJ1ZlC54vMeSZ/mzwGFCREGgrqwt?=
 =?us-ascii?Q?gyxoiGWaC+A0cYzs9WbbZnRg04x8Lkg/dtDXleCtsOg+OefHn+oBJwrPhjFu?=
 =?us-ascii?Q?SZc5TXkTC3sf1Mh0ZPvsXYID8J1NMlFLhZBVAGzI23a4xyVtXCbWW8TEUCtk?=
 =?us-ascii?Q?+WP3zOb4D4VrjvuxdcEu60Tv4HSiUvshBprcAhVOHKfaQf9kvqYcRiIksHxJ?=
 =?us-ascii?Q?8/qrpbf7eRRs1PO07QdGb0Yddf/A5enHw8n+q8LeiTeH26VQbkkAGp9KGY73?=
 =?us-ascii?Q?ITpBgrekNT+HE3JZSdts4jwf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47e7d03-c9a8-4c7e-fbc6-08d96d17d84c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2021 07:12:22.8482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SuGnQJqlFBY9HOZEp2euyzlKQ/SXRwcTZpRYFwG8KmMlRV3wkVB/yrX3SJOYUkCeejnXsESKW7RmsqQaep+dgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2146
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Andy Lutomirski <luto@kernel.org>
> Sent: Wednesday, September 1, 2021 12:53 PM
>=20
> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
> > On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
>=20
> > Thanks a lot for this summary. A question about the requirement: do we =
or
> > do we not have plan to support assigned device to the protected VM?
> >
> > If yes. The fd based solution may need change the VFIO interface as wel=
l(
> > though the fake swap entry solution need mess with VFIO too). Because:
> >
> > 1> KVM uses VFIO when assigning devices into a VM.
> >
> > 2> Not knowing which GPA ranges may be used by the VM as DMA buffer,
> all
> > guest pages will have to be mapped in host IOMMU page table to host
> pages,
> > which are pinned during the whole life cycle fo the VM.
> >
> > 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU
> driver,
> > in vfio_dma_do_map().
> >
> > 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get
> the HPA
> > and pin the page.
> >
> > But if we are using fd based solution, not every GPA can have a HVA, th=
us
> > the current VFIO interface to map and pin the GPA(IOVA) wont work. And =
I
> > doubt if VFIO can be modified to support this easily.
> >
> >
>=20
> Do you mean assigning a normal device to a protected VM or a hypothetical
> protected-MMIO device?
>=20
> If the former, it should work more or less like with a non-protected VM.
> mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether
> anyone will actually do this, but it should be possible, at least in prin=
ciple.
> Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device
> with the understanding that the guest can't trust it wouldn't be entirely=
 crazy
> ether.
>=20
> If the latter, AFAIK there is no spec for how it would work even in princ=
iple.
> Presumably it wouldn't work quite like VFIO -- instead, the kernel could =
have
> a protection-virtual-io-fd mechanism, and that fd could be bound to a
> memslot in whatever way we settle on for binding secure memory to a
> memslot.

FYI the iommu logic in VFIO is being refactored out into an unified /dev/io=
mmu
framework [1]. Currently it plans to support the same DMA mapping semantics
as what VFIO provides today (HVA-based). in the future it could be extended
to support another mapping protocol which accepts fd+offset instead of HVA=
=20
and then calls the helper function from whatever backing store which can he=
lp=20
translate fd+offset to HPA instead of using GUP.

Thanks
Kevin

[1]https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR=
11MB5433.namprd11.prod.outlook.com/
