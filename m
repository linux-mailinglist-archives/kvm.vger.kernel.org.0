Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7321B522A3A
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 05:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiEKDPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 23:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiEKDP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 23:15:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DD0483AB
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 20:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652238926; x=1683774926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+UFioMfrrIhZ0QmaDtQpSzOSCCEDdkzEL12W13EX99s=;
  b=UfKwo2GjrAnjfWzXfosA506AvlfRqz2FyDnfCUW1J1aNAea5730x1uBz
   IZpEohTIV80FcKjD+MkMnfbAbk0+28K3gnHo+nkzj4XuIA2h6Mj2kSnpN
   8GQ4TqtcsJMYNH6HT3x/F5wCADcX/AB91MfKxxXtrOZdbiId74VVJ6nOZ
   kP8LCMvHeoxeBxd29DRICZXYRfyOL/s7HcrX8v0Z9g+vJtXaCaVawjJKs
   SMEE2z7lTSwRLEkgIAHkQYBtCVZVb/GiJ5qwN9xDsScb45rcQq4h2Bc4p
   NTWTiFK7nNsk3VhhNQJ6F5VOiru6jwLDYJ2991ruekcI+RsWN0rl9sJB3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="269504930"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="269504930"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 20:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="542105448"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2022 20:15:25 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 20:15:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 20:15:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 20:15:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 20:15:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkTSncSwydckmabu9zUsDqbU9iz6dCwbDsqu5FgWsUhFvED6dM2UL8/pP0hdAscmdD/9mvgCFQxtGQ+KcWCzFiABtEM/yfrhvIRcLMxZXbsnlkDKQBc5DgICS/CB4/capn2qThlc2UFjK5rTQ4VrNA4VkJ9TORL9+fMVxauwp106dOpD9MINkndReg/CRbYinii/CewvO5UmHawfzhApyyR4EInpx5nZkIlBHuCbSZNap6hvbctUpBSrZrJPvNhQj2b4LICDrXiUWhJRMPGTyNMScv/TWCom9YiIPMk84gH1/djjjJkY9jZXqWlIC48xIvuysj9FMIAXQ858KXfhLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBPCF1gjLROsmu2v1l1kLHH5bvDk3sRtXXGNo5SbEU8=;
 b=itFaVKb2T9WnzkVjXbEhRa298HcOM2/GeP482b17a8Sr9QWwZLtyfbetuh04LexnyFfpIw1QRi82lQ6zdqzjr3bFSVHj49uxSx2dZPK3SEnN/WvR2Ay0sFG3vkk4Jfklg6bR6fgl8/87/pw7NIwAfCaPyicgDjDXqALgKsZ3l5EYA2hchYyhXQv84pvB9toKx3kJSz2rARLxZXlRnjrdvdfQ7CigMlcQVxT3jXaM/V3E71mF0Iri1gA8D0AyTgjr00GmfdHLhSuIhJDDcDaoMyt/w2g0SkiJj8ILus0zeCRq+K1vGzQYO831zNd2uo/whLRAwZvfFrOlxKWra4Gugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0008.namprd11.prod.outlook.com (2603:10b6:910:76::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 03:15:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 03:15:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Jason Wang" <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Topic: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Thread-Index: AQHYOu2EhhTTZTsn5EqajxaIjlC6M6zNmzGAgAAclACAAWiFgIA2iT0AgAAE2ICAAP5AAIAAbGoAgARd/oCABXnXAIAArI2AgAB77oCABEVaAIAAhciAgAEgKgCAAMXWgIAAgm9w
Date:   Wed, 11 May 2022 03:15:22 +0000
Message-ID: <BN9PR11MB52765D95C6172ABE43E236A38CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428151037.GK8364@nvidia.com> <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com> <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com> <YnSxL5KxwJvQzd2Q@yekko>
 <20220506124837.GB49344@nvidia.com> <YniuUMCBjy0BaJC6@yekko>
 <20220509140041.GK49344@nvidia.com> <YnoQREfceIoLATDA@yekko>
 <20220510190009.GO49344@nvidia.com>
In-Reply-To: <20220510190009.GO49344@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a067690b-1ad0-4b4a-7940-08da32fc7c76
x-ms-traffictypediagnostic: CY4PR11MB0008:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR11MB000874976D4CC169CB8DB0578CC89@CY4PR11MB0008.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOlwWAK74cgV/mJuaLKFrbSCqgBdVa2Lesn9MaUn6DMmLQlSxpevprMDr6NCG6cqxEJC3pjXWnPRlCXbOD6bYaIpzUcx8t/oHoHYBErGeMYrHI3t/tP9Ge4vu6OeuzjGbvDe64t0DSUUp1BMqXkVXThLVXcJ7gMt6a7udbbD8vfpI7OxDsA/DJwC/7nMe+2xcL/jGbXGDPgrXW5JSU2GDzhh1ex8ClC6kqIi0rfAec3gBLkx4yAnDkv8FIetBxVmdeQvLnOwesG6ZrRwnyeNKPAroREe8fcxzA+iImMwiPt9/xdqXbr+OxFF55+jrCuQqHzcBN5k3+SkCfQxm18t9mOcUKuGkqZDahbcV1sZI3Gue/Pw6ZsDUmPY6G/r7fyDk577OBOIj4nwxRWD/1GqTtnA4dhnSiYCMRY9H/ylXeb/KNmSM4mKJtVYvH9fZI9itgvJ3phskH4LkXrk9uMLZcs0bu5Nfhw+JhXEyaqTAihkeBYQVnUVNyQGGYO3HlJUxvtGPOF6ZwfyUbNOdEbVu14IcV6xCJdS4OBx51XU93SuPN02sbHcMpgijlSURnvv1Qkbkc0coJV4/Bu9842HUFDF7bawMUjbO+O6RWsumdUx8yfQ4bLre7CTLRyIfUEPxFfi9fywhTqGZsiriA46xwZ8XuUvQJ82M0cRYiappuSRUtkFsa4PuJFq88X8s0WwyUNwWBK/uCZE47EnrCD1QQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(508600001)(26005)(71200400001)(9686003)(6506007)(186003)(7696005)(86362001)(2906002)(5660300002)(7416002)(82960400001)(55016003)(122000001)(83380400001)(66476007)(66556008)(8676002)(64756008)(54906003)(76116006)(66946007)(66446008)(4326008)(38100700002)(38070700005)(8936002)(52536014)(110136005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eD9NFFUt8JbqzR2ft93ICK5FglR+uw+nFgLHlyA3jDDADNQ3o9FGt7jSISFq?=
 =?us-ascii?Q?x35tJV5YzrcuItjEewHzhv18LvMtb/EVTkMyFn5g5qHURvjc+6e4v8UwJdXR?=
 =?us-ascii?Q?wVd19jNqYguI8j/yXgjQjcrNMj9vRJSlhCvFYyXss3mMCavN4Ico5yymi0zT?=
 =?us-ascii?Q?gqeo+35Cg/YcuFHYOKqa9CM43TEPH40mnKcV5YOwv942Iih5cNPCD7DZtceo?=
 =?us-ascii?Q?0E6ZKIFxt2n+SoKgjCZ22rJtP1KkXe8Sb1mf7zPcolIPg7CAGRprimo8yIL+?=
 =?us-ascii?Q?HA40d6EV+x7JJ5zgPP5uFWNWOLHeCUxE73twFTBIOKdiL9PWJiL1y2nld+5h?=
 =?us-ascii?Q?17AiP693TucdndgVbovZvgcnPZiZtOw5hlK20oHL1FsqvTlcM9CDjgQ/Gh8u?=
 =?us-ascii?Q?PXK4YsimgdNNL5fmtoRf1aNXve8SYDeUnkuS45ASSwV7AXDVfcl0G+3tDVOa?=
 =?us-ascii?Q?836Mcr9S/hb9s9IM5DJjQSAOvwZ9y92hbTkZLoq6TCV0YqNQGk7zrHqHNU90?=
 =?us-ascii?Q?u1JqgNSTxllyY9E0j9eV3vhlF2/dWTBjX7Dt4G3i+x75FuLa0Ho0TdGo7Oxq?=
 =?us-ascii?Q?8Cyz5mvH3M7govohxpMutmSRQ51i4R9uOwXRnlPrQEixL9+qKT0h82aTh5hW?=
 =?us-ascii?Q?m/7z3BUaU9iGXESKNriva02nffOndOFDyvBZ+LgG/0MtHNyH9D5CkwWI4H13?=
 =?us-ascii?Q?DoZLKxLRLLNu+Q+i5O2TKlixxnAL/1DPfxybnmXC0CSrpJIVlP6ficgUF1FG?=
 =?us-ascii?Q?/QT2pfLICftxWTiK45H1zEp45UafArj7VfNKSZ9/a6Zd4f/8qZDD2Vvc5r7G?=
 =?us-ascii?Q?TfMjpEISjy5nV4mM/576PyAG3+LhYJfZujAEKjuTkoUQXCbmCPv7T2QTEDJm?=
 =?us-ascii?Q?YkNQYCDcN5SspaskL1aP0Fd5sh3mbUbuYonFe0qtvUCkYxWmG4SwHsNJUg4z?=
 =?us-ascii?Q?1ML744Ek5aDiWW+4olrKMgMNbqJbzicWLcfqlIL0qxBIop22YahRG8E9tcpp?=
 =?us-ascii?Q?uqhsEvPVciW1UEuDkNkW+2poJdpmxAvEFrPRvOwuoJfA27JmUYhp9r09P38z?=
 =?us-ascii?Q?/VYyOU0T3TpZW/9xs9Up81QbEOW8HtjsU5VfRo0elsAA5C1UIgMMJ+py5emT?=
 =?us-ascii?Q?rWBE1hT1YCTHNiB1NDdwqIkd4C0GRRQqPHaY8kXz6rNP47doSsQDKZGMXgzz?=
 =?us-ascii?Q?4FTCpc4aq3XWj1XM+r6T4AfwfzHf/uoVT5FiZ87cLkoOpZyHxEYUGcgavnSy?=
 =?us-ascii?Q?gCko+gNx9fzzph57HsqL8Qo2MTH/iQ+uxVvBxdhGhNMSuUh/jXTv/r/2Llon?=
 =?us-ascii?Q?ZVSJwGt1pVqtbyOrYXs5Y3ZqgSPXTfJO0CEv/wRdYeM8IIRcTozQUXqo2KJN?=
 =?us-ascii?Q?z28SKSPgSbXUuQLsgXPbO5zL/FO86xhJLHEOE35Y4s7fc5+vZng6darBicSN?=
 =?us-ascii?Q?uHJJyOQwKhHF2VFSPfQjH3sw3UCbuKsVAE31HBtRtucFq3uwMOWMuHL+nhXH?=
 =?us-ascii?Q?QEiYtzfXAqgYiH2q8IVV9dudeMftcbM0TOWHCdKOeWQtIJwEKt0mKGwKVv/f?=
 =?us-ascii?Q?OEfw9//tYIC9WL/TStqxwVbqhcRM4aQbcc563/amPVrcqgslM3sdkLZ6mVaY?=
 =?us-ascii?Q?/2AR5zQuZWnyli4MexHvg7eriXsBdB2ko+yC4yK5AB11nvL9MtfJJ04nzLgV?=
 =?us-ascii?Q?tE8w3kO6SJpXM+QavqSkB8dGLABJ82T9BiCi5pWpkKe85BMsQmx5wvmd8zYz?=
 =?us-ascii?Q?fM4e9SktsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a067690b-1ad0-4b4a-7940-08da32fc7c76
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 03:15:22.7008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MZeVUhezMilMNVlnXElP2a0gzXbnJKfMinDXTl6OL1bH2VLgMPvPxLLB1ScpyRdOtkCGo++7CxLeKulShEx1ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0008
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, May 11, 2022 3:00 AM
>=20
> On Tue, May 10, 2022 at 05:12:04PM +1000, David Gibson wrote:
> > Ok... here's a revised version of my proposal which I think addresses
> > your concerns and simplfies things.
> >
> > - No new operations, but IOAS_MAP gets some new flags (and IOAS_COPY
> >   will probably need matching changes)
> >
> > - By default the IOVA given to IOAS_MAP is a hint only, and the IOVA
> >   is chosen by the kernel within the aperture(s).  This is closer to
> >   how mmap() operates, and DPDK and similar shouldn't care about
> >   having specific IOVAs, even at the individual mapping level.
> >
> > - IOAS_MAP gets an IOMAP_FIXED flag, analagous to mmap()'s MAP_FIXED,
> >   for when you really do want to control the IOVA (qemu, maybe some
> >   special userspace driver cases)
>=20
> We already did both of these, the flag is called
> IOMMU_IOAS_MAP_FIXED_IOVA - if it is not specified then kernel will
> select the IOVA internally.
>=20
> > - ATTACH will fail if the new device would shrink the aperture to
> >   exclude any already established mappings (I assume this is already
> >   the case)
>=20
> Yes
>=20
> > - IOAS_MAP gets an IOMAP_RESERVE flag, which operates a bit like a
> >   PROT_NONE mmap().  It reserves that IOVA space, so other (non-FIXED)
> >   MAPs won't use it, but doesn't actually put anything into the IO
> >   pagetables.
> >     - Like a regular mapping, ATTACHes that are incompatible with an
> >       IOMAP_RESERVEed region will fail
> >     - An IOMAP_RESERVEed area can be overmapped with an IOMAP_FIXED
> >       mapping
>=20
> Yeah, this seems OK, I'm thinking a new API might make sense because
> you don't really want mmap replacement semantics but a permanent
> record of what IOVA must always be valid.
>=20
> IOMMU_IOA_REQUIRE_IOVA perhaps, similar signature to
> IOMMUFD_CMD_IOAS_IOVA_RANGES:
>=20
> struct iommu_ioas_require_iova {
>         __u32 size;
>         __u32 ioas_id;
>         __u32 num_iovas;
>         __u32 __reserved;
>         struct iommu_required_iovas {
>                 __aligned_u64 start;
>                 __aligned_u64 last;
>         } required_iovas[];
> };

As a permanent record do we want to enforce that once the required
range list is set all FIXED and non-FIXED allocations must be within the
list of ranges?

If yes we can take the end of the last range as the max size of the iova
address space to optimize the page table layout.

otherwise we may need another dedicated hint for that optimization.

>=20
> > So, for DPDK the sequence would be:
> >
> > 1. Create IOAS
> > 2. ATTACH devices
> > 3. IOAS_MAP some stuff
> > 4. Do DMA with the IOVAs that IOAS_MAP returned
> >
> > (Note, not even any need for QUERY in simple cases)
>=20
> Yes, this is done already
>=20
> > For (unoptimized) qemu it would be:
> >
> > 1. Create IOAS
> > 2. IOAS_MAP(IOMAP_FIXED|IOMAP_RESERVE) the valid IOVA regions of
> the
> >    guest platform
> > 3. ATTACH devices (this will fail if they're not compatible with the
> >    reserved IOVA regions)
> > 4. Boot the guest

I suppose above is only the sample flow for PPC vIOMMU. For non-PPC
vIOMMUs regular mappings are required before booting the guest and
reservation might be done but not mandatory (at least not what current
Qemu vfio can afford as it simply replays valid ranges in the CPU address
space).

> >
> >   (on guest map/invalidate) -> IOAS_MAP(IOMAP_FIXED) to overmap part
> of
> >                                the reserved regions
> >   (on dev hotplug) -> ATTACH (which might fail, if it conflicts with th=
e
> >                       reserved regions)
> >   (on vIOMMU reconfiguration) -> UNMAP/MAP reserved regions as
> >                                  necessary (which might fail)
>=20
> OK, I will take care of it
>=20
> Thanks,
> Jason
