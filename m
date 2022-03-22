Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76E4E399F
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 08:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiCVHcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 03:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbiCVHcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 03:32:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F931AF26;
        Tue, 22 Mar 2022 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647934256; x=1679470256;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3D+MhYnKOglj0wd7LIoLRj0iHfwQUFpoOeGMO1f0Hno=;
  b=N/QlYz3Wlj+UJDiEwzLadpmBuRtit8qFBWpe4es0HAjVy3ck6w4V9Io+
   bOLIFDqy2Ie81eXlg/LzvKqVEIaV90LaVyVHEKvlS+L6dldT7itbmYSvR
   +CYFv12Z9AfHckoA1OlHnxDTPnFPS4aZR96waRste+dspNVPEjUcEZ8/f
   9MlopZhis/FOLOeGubOVbT16T8gmTT4rdkG7fx1YP4ES/O1aR+OJzKTyo
   RNvnMS9yVHi51IqMED0vFWpJhPc4YQIeOwJgp/CUN2cqaV8IxMrTsJuqe
   RrpXwKKMB4XonvikKgBlvgZ//1KUgj9of7yUdrOHGsQDTnCwR4XOaU4Qv
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="282584138"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="282584138"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 00:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="600776232"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2022 00:30:48 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 22 Mar 2022 00:30:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 22 Mar 2022 00:30:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 22 Mar 2022 00:30:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmUJzDE7Nu5vO1H40nqreE9kd3hFmf6eEZczUqH+zRPhwqwD7hAnD3Nj+WfN2OUi2AiS1K5Jkds90816Pdb3PDRHv15a8xZc566Wqb7UNgDy/IVm44WhGBagH04ZLMhw4RGZ9C9ltWQl5+5mwoBeC2LVrYKnTHouQevM81Cu/xUPYEDLR4b+r236g04VLobirMBEuOqOBY+ZKCaAAtJFoQ1w3q/ZI4wh2mH4uM4fCpvI9bDplM/28KnjQX5xD3FmprrgaLhDqLxTBBihDzebNTvBX2vgnPUBfEiFlPaj7mHYaCLn0Q+pWhdXMWrKIx8lkD1J5rAnWvORA0Z1PKDARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3D+MhYnKOglj0wd7LIoLRj0iHfwQUFpoOeGMO1f0Hno=;
 b=oMiF6p4QzbXFCRC1erXD0Yv0UUDG3lHFjvUqlqkEDs+hTfG3Al0L0zbdIdO+A3+7mlDhrd+lkxJPbJ7sjNGD3/NN2o3DN8++IvldNMAzrDEAZ50p7UDFlKXeGXJq8f7KvmyvTGfp++18KTJ0qIJkUTTTGGnQAzVL+xzpMg6KLtxo1ExZqZyajHIYnlx+W1RWnXlxJAOqLp0Q3oM1OZeREyRVMD71WAv1Us9/64/QhdgdSgYNeBgrKpjJ1LYDCtZn/UuE5eC6emXtbIlRlMDT3ocNzFiQ5Bxm0WWsI086DsL6OIAY0TSvqg9J6yKXoJFHxs5Tb9t568bmdO1jzTZivg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB3351.namprd11.prod.outlook.com (2603:10b6:a03:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 07:30:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 07:30:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "david@redhat.com" <david@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the
 KVM type
Thread-Topic: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Thread-Index: AQHYN9xnDDDBVY4pLUqXQfRGdryZ0KzARNcAgALO3mCAAIkrAIAAzPRAgADLE4CAASbdkIADjmGAgAEbrkA=
Date:   Tue, 22 Mar 2022 07:30:42 +0000
Message-ID: <BN9PR11MB5276F75EF4213BE565E7B4868C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
 <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220317135254.GZ11336@nvidia.com>
 <BN9PR11MB52764EF888DDB7822B88CF918C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318141317.GO11336@nvidia.com>
 <BN9PR11MB527649907D241347BCB540528C149@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220321140701.GV11336@nvidia.com>
In-Reply-To: <20220321140701.GV11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d77a9780-92fa-40e1-75f8-08da0bd5df1f
x-ms-traffictypediagnostic: BYAPR11MB3351:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB33513577BC860A0ADDA087D78C179@BYAPR11MB3351.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQ48sxi1XdhOSEHP8G8+KmW245Uj1YvgL011Dpv9VXi+ZUTiPhTEGzcNcyT4b5muu/9qPmKsZXJLOx7enjKL8gq88vYKRj7XDSbzzfXeZbmeSc5J1W3vb2lmlkn8Yw++4fstAZUCDoJjpt67P5RpaYHXrv9+g5Krt/vwgd0qKV5gWz2VYmDR80lcAuexR9ttUAHvdplE6gwaByZoPdvF0hImZ9uV/yE0oTiRaxDgrq3N7EHdfmGYuD/YqvY61WbJ7s5BJNyY8ZFbg8sZMNkrq6BaxoNUxUDfy7GIbxCGiRiInttHTLJaohDxQCtcr/Wb/9x9GNCAo2Hhfc8ti2BATaq1WOs6utDf9EWDfvstZS82cz+CO85OsHi3ObxWMcpcSIliRMYIti0Z+f2STuz55xEwVOk15qJBb1zyb2IqDafnISt6N9N5DePprkC6U52NbY8f65l7v/hwopsEz43Pk4rnUNYuOhJhYFQREctwAwEf5xBDxVH7WkcLUHFc0nHssZxKNBrigWVwgF5q4IRUsbGWO3m+ZyL7jOuO5US3+dmjcPTvKIoed4Ut9jZ0670tvlISfGmUCKNLMedIG3uK3Rj3Jxf7QsLsX8hqLczz0+0m3zGspb2iWngoMnmZmUJU4vITrNQhFGi9OTkRQQva5BBmODUmEGVMDt1tbSy2Dza+QzVZ/yXHMPKDrsc0/cjp8C8CLC15ZUKHto3vZ7Ja2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(83380400001)(6916009)(54906003)(82960400001)(316002)(38100700002)(33656002)(122000001)(9686003)(6506007)(7696005)(2906002)(64756008)(8676002)(66476007)(66946007)(76116006)(66556008)(86362001)(66446008)(4326008)(186003)(26005)(8936002)(7416002)(38070700005)(7406005)(5660300002)(55016003)(52536014)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ogjlatxr4ErAQqvrMDw3ugjqrJsUlZ+Cq7RlhDMjogM4xOp+T5VfLYKKO28Z?=
 =?us-ascii?Q?g53brGq7dirqfqMaMMKj7nAtXhrFwmFL8Axt5YpVYYIIzqK1tDCT4O8hJKPf?=
 =?us-ascii?Q?yfGnrFegIY3pD/A1q7iQs20Pa8iCQInkmR6aAjYxdWXVyYDFmntuOknTr4Zj?=
 =?us-ascii?Q?t+VATteftduam4jCf1x+5yVA4Mss6M0esG7GACB9DfsUfBWVwozYhVEGyFOF?=
 =?us-ascii?Q?+r9fG6j0JzO2nY2/MWjuuaq2o56/0vMFrl8ocEA8jA3eIODn/edt9KFlNO+s?=
 =?us-ascii?Q?hjLBfA1gixyux78K+FXkrHtfbAWeK9O+tqI0BE89+MEY6i6n2NFk6OU36Hir?=
 =?us-ascii?Q?JrxvZjTCgjw+Xi+Mes7CHZw8U9JRsZuZYHabybbcSLcHSevBaBQqCdoJXpoc?=
 =?us-ascii?Q?9HwrZ1+8F4QlEKpU4JpZ1rLLW9b6LRkPaQ2ZSbKnM/OPkgqo9+Rf4+SH/Zb7?=
 =?us-ascii?Q?pBQ4vH3IauX0VeFWMmR++ZyC167TlhvLKn/Kl/wSaknMVElu79i5SP7JqlWK?=
 =?us-ascii?Q?UtrNgW9AfYPaxd3BN9bqhmppGz8XmeMjbiY1I7wKNrZFvbyhdmyhZnktObU2?=
 =?us-ascii?Q?Z8wfn45usArTzYr131NBEBACqrxzzNDxhXhUlb3aT9GpHIHfJv7QadWccbbm?=
 =?us-ascii?Q?vSUefGkUimkL5ikO05/689UPa7FE8vPBqenZWy1UneWyti9hh9CJ47j5O4G4?=
 =?us-ascii?Q?GqO8Oaa2QvlX7hDGVAHhLuZf3TOKYEcCXhU0mZam2ltFeW8MWT+F51lV7xgh?=
 =?us-ascii?Q?WePVf/Irt/3Aox1Mjvm4bGXBaEeGAwAjp6w1RKt+BghI9yaoHlm27d0yeK3B?=
 =?us-ascii?Q?4STnS/col1LQavppD38ktKYjFqrOIqr28ROZCnCSPZvfFPmewYnGdWW5HmYp?=
 =?us-ascii?Q?nHhWwzSKbiY1WLznANIfSH2lx7JJh9xWYf+yRwTjQiP5Qj4/e7ER8xBVz16X?=
 =?us-ascii?Q?IG1Kz2z9Urda5N1l9rQ64kWjwPEHDbwXg6QHQKLOEmLW5/dI+wO8xrVDTmSr?=
 =?us-ascii?Q?PlUYqFCz6b32ARtwZGNYV0gdd2xhVSHqLtSb4ke89GquMGP40sjEhj2EtDpK?=
 =?us-ascii?Q?r94ARjRgJeT17pYm2g4xihTNCIsZiyTB7DseF75kVZpcbTodfLgf5h6G0ZKe?=
 =?us-ascii?Q?+oHpQC8lIxxbYq3M0DJC80xNPhLAzmhQ2i8XdjTuwLUgfn1aRLBcxZsDts9P?=
 =?us-ascii?Q?Ve2Q4te4MWoNuozjhDbTd+ATI7G8onBjKgQCol+fbqMvZqf7iLh98KdbtoJQ?=
 =?us-ascii?Q?3fvMn3iXaog0270b8TUYLSemBn37yF1Qf0QC+q2+m/VGvwNiIXoHDrk+waAp?=
 =?us-ascii?Q?kOXfKJiYsAXtDkSzMKlqqI6KO9Tw18o0W8un4VmGnGxxQMCnG37M1ahs+PbI?=
 =?us-ascii?Q?5KosKts2UwT9LwfF2TtBxfL+lUEdrWE77H78nPksOLyKye+YXSPVxuo0LZlb?=
 =?us-ascii?Q?aKEIg+xa+JbbjVO7gpnXCLXbPzppQtuD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d77a9780-92fa-40e1-75f8-08da0bd5df1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 07:30:42.4885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wwQGvAjBmL3+0QFYe87S2Qi8EcckaSev9gcrVd08bWrByyLQlKfALpWX+ntWta8XS5oM+PfoMRSyKo+g4gwRRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Monday, March 21, 2022 10:07 PM
>=20
> On Sat, Mar 19, 2022 at 07:51:31AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, March 18, 2022 10:13 PM
> > >
> > > On Fri, Mar 18, 2022 at 02:23:57AM +0000, Tian, Kevin wrote:
> > >
> > > > Yes, that is another major part work besides the iommufd work. And
> > > > it is not compatible with KVM features which rely on the dynamic
> > > > manner of EPT. Though It is a bit questionable whether it's worthy =
of
> > > > doing so just for saving memory footprint while losing other capabi=
lities,
> > > > it is a requirement for some future security extension in Intel tru=
sted
> > > > computing architecture. And KVM has been pinning pages for
> SEV/TDX/etc.
> > > > today thus some facilities can be reused. But I agree it is not a s=
imple
> > > > task thus we need start discussion early to explore various gaps in
> > > > iommu and kvm.
> > >
> > > Yikes. IMHO this might work better going the other way, have KVM
> > > import the iommu_domain and use that as the KVM page table than vice
> > > versa.
> > >
> > > The semantics are a heck of a lot clearer, and it is really obvious
> > > that alot of KVM becomes disabled if you do this.
> > >
> >
> > This is an interesting angle to look at it. But given pinning is alread=
y
> > required in KVM to support SEV/TDX even w/o assigned device, those
> > restrictions have to be understood by KVM MMU code which makes
> > a KVM-managed page table under such restrictions closer to be
> > sharable with IOMMU.
>=20
> I thought the SEV/TDX stuff wasn't being done with pinning but via a
> memfd in a special mode that does sort of pin under the covers, but it
> is not necessarily a DMA pin. (it isn't even struct page memory, so
> I'm not even sure what pin means)
>=20
> Certainly, there is no inherent problem with SEV/TDX having movable
> memory and KVM could concievably handle this - but iommu cannot.
>=20
> I would not make an equivilance with SEV/TDX and iommu at least..
>=20

Currently SEV does use DMA pin i.e. pin_user_pages in sev_pin_memory().

I'm not sure whether it's a hardware limitation or just a software tradeoff
for simplicity. But having that code does imply that KVM has absorbed
certain restrictions with that pinning fact.

But I agree they are not equivalent. e.g. suppose pinning is only applied t=
o
private/encrypted memory in SEV/TDX while iommu requires pinning the
entire guest memory (if no IOPF support on device).

btw no matter it's KVM to import iommu domain or it's iommufd to
import KVM page table, in the end KVM mmu needs to explicitly mark
out its page table as shared with IOMMU and enable all kinds of
restrictions to support that sharing fact.

Thanks
Kevin
