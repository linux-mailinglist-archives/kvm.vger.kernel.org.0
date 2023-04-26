Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CE66EF05A
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbjDZIjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjDZIji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:39:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56DE3C39
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682498376; x=1714034376;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dES5UTpgc8tZP09naarGoOccMew0/IVgi61z8zQ6OG0=;
  b=CfVkK9+pnGR2H6ScqXE37N/Ya2L+vOMR0XO8UCI67J6yXyHFMBfZY7dm
   AtybKvgIrLlGpv6jU/cSwkTeRPSnLyLWufRRPYn1Qx73m0iRG7xo7XTbg
   SmQkrwqvfci/ILSkWt9CdlqoRc9LDmvFeOaSCbrcR4aHVkfrtiV8pZf48
   NZoR+itIbnzDQgAB7ermsI0Wf8iEe412wUwRzax4de1fgT452+t1IfM12
   ShE3FNrgGo/5Y53+WiAuMdTzPiCEiZZDqmJ6wUSw1JbbMsS37FBiPsM7j
   1wgm330QbbvVCLRKQx9ObXt9KqKkyOMC/Ha/zSkt7zNzM/Cn8d8xDjtw1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="347066604"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="347066604"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 01:39:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="940116633"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="940116633"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 26 Apr 2023 01:39:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 01:39:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 01:39:35 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 01:39:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNOk2Cw6tXrVf3cy+/5ezV2585bUzGKsmN7RLD4E8OSG5khx4IgNU/g15dfgzdf2R5Y6DnNxdiZpiiQxHHqFaATlXvLXgo+iVric9ESgBsCRh2jsouAr7TqPQb5/JvqvdGfht3ovBjdAkzutXuT3AAz5jNb0A0+Q8OcIpMlWyQLVib2+SZjVX9sLex7Sa6cpt+WvUKlXJSte96kXr/eOIsa6WyfeC/wM/Vmc8B5c2ZWX9GkQPcol6ZSgXDlYY8I0NAOHPQ2ahlw8m4i5CTWzAVnS80/xEF04vXqMW7cuYianWC2Hz3HWbtn4ZTW+uH2Chv+uJvsYO0VjCxAeGgzNCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dES5UTpgc8tZP09naarGoOccMew0/IVgi61z8zQ6OG0=;
 b=IVDCCHn3SmapORzf51GcU3WfFi585ZniVRcm8G/OzLDSmyf+jNmAuAV1RFLxXzrIMWPHkoTnfxB3N9j6poIbIMtDINuvqUv1Dt9znwrVw5I2abOgbyeC36EsiRZMDnspERZs9OAUgkKLLhvJFzBb2eI8SchLf8ZSynFgc6TJ+SXw60Z4eCRckDFnmQPwvwXb1+jaXBDRNJpzSp8hRFCtQnaX4+WuiQhXrczGkttVf53j5QpFYzUYZObgFNSXzCrOOoJVOlWRxunA1Xk6bDI6MS1cHcUT2gij3s/J/Wz/40HCa37FH/ERvbzCTVm1qvLg7YdL+MT/DTokf+qCB9Lasw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6761.namprd11.prod.outlook.com (2603:10b6:303:20d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 08:39:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.020; Wed, 26 Apr 2023
 08:39:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Eric Auger <eric.auger@redhat.com>
CC:     Nicolin Chen <nicolinc@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: RMRR device on non-Intel platform
Thread-Topic: RMRR device on non-Intel platform
Thread-Index: AdlzU1l2SINtdgKASzuG/OHqnI4zdAAPzvCAAAAmJYAAAQTsAAAEaOkAAApGNYAAHd47AAAA34UAAACOKAAACawggAABPICAAMKJLIAAAnPvgAAiuPaA
Date:   Wed, 26 Apr 2023 08:39:30 +0000
Message-ID: <BN9PR11MB527641477EC123FB9D5A48F98C659@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com> <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com> <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com> <a2616348-3517-27a7-17a0-6628b56f6fad@arm.com>
 <ZEf4oef6gMevtl7w@nvidia.com>
In-Reply-To: <ZEf4oef6gMevtl7w@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6761:EE_
x-ms-office365-filtering-correlation-id: cc10617c-ba6a-400b-0a17-08db4631c0cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfLaaW+KvLgLd9o5s/n3Gx4TQzy+SWIJ/dl2HdmM10R7umpj29WmQ9hyL7zsi0iCJbAvfnTz25FWwQB9+l8MAzG7P9jAP2iUuZ2a8GNRLfyzks4FlD9jsg+QCcMTdM4pD5TakIhnkJYnDed5uZGfuftwdvamfmPdwGyb3rYv0ieBUArrHmQGXHTp1mnEqCE3mnFHPU5zWKLWwOWgJvuLvlyGYxrScGX6mvPXbRTthVg67erIrl1zC2BY3mF0sKF/hxuWJDSU0BJMC6sNJ/gYPftT1GJK6kiagcEfzuiUIzILC37JlV7GAbCsnL77bv1+56yK570r0tCee2iiQdh9DNg4Oad+JVw7GXYhMokZkp79ZDnjQYK5KCkPLQupbP14KtfZg2Jr/AaPQL+ZcdAefO8XhFLonMFiCVcWaVFUGRE6rMgU3SQlf+HP6QhKYwAlYP9ow1nrrl8QI77ieCrjIdIf51Dkk0k1At7ScM52KxQkT4P9XJgvv88IN1G3nTVKamEUDyaVgOUT63kLshg8UWOfRRk/vVMDsWBlZUQFW89t65WihHr4uLY4AOhB/g1vBnjb+ulSOyr4SUp8OYm4cAft6EJyyaY6+eeWpD7qiCCT1HbafySlv4rHM0SgTnQA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199021)(66899021)(33656002)(122000001)(5660300002)(2906002)(52536014)(38070700005)(8936002)(55016003)(8676002)(316002)(66946007)(82960400001)(66556008)(66446008)(38100700002)(41300700001)(86362001)(66476007)(64756008)(76116006)(4326008)(186003)(6506007)(26005)(53546011)(54906003)(9686003)(478600001)(7696005)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6q0MHTJrWK8pM/M1FNaAMAFDeOyObzrOy2wHtFaOOZpbIHfFddBt75H6ztjO?=
 =?us-ascii?Q?9ZL346pTuHaaZknNi+iVzvRjjruLRAi9CT9hS0G2mYqthrQ/26o0o8NCe+f+?=
 =?us-ascii?Q?9PEFW5MFpsmb8MREg5KfKNTvP7CSbs9QjqytGXpUkvR2nNKslwDHNN+JhAjT?=
 =?us-ascii?Q?a8Ax9Pn4JPRUNbcgtIrVZ0JmPKCCSqhKroBZryUVXlzyIScdKIyBdPTmuzZS?=
 =?us-ascii?Q?zdRp4EhDE93OtKHo55rs+0aY164c94/bTNzNkGVT2w3uVWZFvkEW92E/5v9R?=
 =?us-ascii?Q?jqLKi+3Wa6nYhhWgcxbL6Z9xd01HMNmJ4gogF/zUC4w5MsmBRodTbGohAHyU?=
 =?us-ascii?Q?zkIELFtuOyA22Zq9TWu3iJ/JHbCd/ZCHXxS3Hb/uOf83/2zxu/lN5FLOCqrO?=
 =?us-ascii?Q?nyG4T+axUTB4cf896Qke2psP7KVxRsM0o8WMvwbY8WlwmL7AwC9Fecj7Cv5/?=
 =?us-ascii?Q?F6dfVFxEANbAMUmwQWKYmMb88GThg+Wf7Qnv6K0x4V83JETDls4sEJHZgv9J?=
 =?us-ascii?Q?D487eXyou43jmql+K2JpXa8XPuuks0hjwedR77fGoH0MDX49SuBGru3cM0J/?=
 =?us-ascii?Q?+y6k56tyoc8v+SqN2unT98b/nIF3TU9gbsU71oba3FJ16DBCX1Cb4YEufrl6?=
 =?us-ascii?Q?d4qmFINMkgtcWMCV6MnNT1Mjqzas3k9Alujf1kq9jIZSt5EqLs8ctnEyq4k3?=
 =?us-ascii?Q?dDbYDLpJoS6U1jhKpwJIghzdz8u0UEkjeNutbDwJlhT+OfUsN5yCffkEPn9I?=
 =?us-ascii?Q?F4V2/VZ+mgNtHZfgwFrCpITLRjYKj2ma8MXaStyQ8NgWf2493Xl80TsBROPi?=
 =?us-ascii?Q?TuJlLUCteu3RClQ52rB9RUPwiBpJgPU4rvzU5mr2LGMqSV5IJbWcNLoa93MJ?=
 =?us-ascii?Q?Dmzf2vDokHdVTBErYOVtQxsjCdKOB+BsfAuHPRXFlwdQIICnOs6bagHmloK1?=
 =?us-ascii?Q?XcgvTyvzR9gtTAzRItZE7sSZEcaeyUrK1Xs7w2dejqTs0T9anUhwGPufjCzS?=
 =?us-ascii?Q?PqS2xY03SwNIpOccppkvPzVUdC09LUQ8P05Hy1x3jgXIbMVwFIDBurqqzQFo?=
 =?us-ascii?Q?PRh2Roj1hdtkE6nyvwdc91sZ8Zv+y0aYkP036ea3ZdatyMgl2JhNaavtkQGK?=
 =?us-ascii?Q?5aMSWGa+pmofN1Cnp31iko9gKjeDNlnL+xlh+39B6Fqq/htdnN0q5TbO0Oc2?=
 =?us-ascii?Q?Qac7v+e3xWHUEXtm1yxT+7+nt4YM03GjAbc8mpQbuSx5x7QNZH7fjyJopY6t?=
 =?us-ascii?Q?iv5u1qqUgL2LMitd5i/d458N5+g7JdtgewMWH9GravpduavhWwps1Zp/8TNc?=
 =?us-ascii?Q?CdNykkMY/4yUWVwGmsr5kClR/WMBwhHTy+YdjTr4lcY+kMs1+Oggc7lS17lU?=
 =?us-ascii?Q?TnbNrv8KM3W8Mqecwa2c+7d5JYSInew06n/gCKjsf6EGMcGVHYNfHTzVGIot?=
 =?us-ascii?Q?UK8KisqrZR495s6ig44mRy+IE5mmkkcf2NKTbjFMVOCfQsAthNiVU3VKqQXh?=
 =?us-ascii?Q?Tsp/5HizBXddUrd0Zm4hQ6nwlYEVuc0M4NS/kjZ1mpE2ZLUkbCgbIeI8xmM/?=
 =?us-ascii?Q?CGaf5SPz0C5YolafJkB5vVCerHxUTy1sOSCGJxlh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc10617c-ba6a-400b-0a17-08db4631c0cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 08:39:30.4895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pZYR01RjH61OmMq7gcZfRF9qW7+d9zIBuaD33WlxD662Uz8ohgvYPyTbmfC0r/TmVMH839DIu2qLHj16+FFf/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 25, 2023 11:58 PM
>=20
> On Tue, Apr 25, 2023 at 03:48:11PM +0100, Robin Murphy wrote:
> > On 2023-04-21 18:58, Jason Gunthorpe wrote:
> > > On Fri, Apr 21, 2023 at 06:22:37PM +0100, Robin Murphy wrote:
> > >
> > > > I think a slightly more considered and slightly less wrong version =
of that
> > > > idea is to mark it as IOMMU_RESV_MSI, and special-case direct-
> mapping those
> > > > on Arm (I believe it would technically be benign to do on x86 too, =
but
> might
> > > > annoy people with its pointlessness). However...
> > >
> > > I'd rather have a IOMMU_RESV_MSI_DIRECT and put the ARM special
> case
> > > in ARM code..
> >
> > Maybe, but it's still actually broken either way, because how do you ge=
t
> > that type into the VM? Firmware can't encode that a particular RMR
> > represents the special magic hack for IOMMUFD, so now the SMMU driver
> needs
> > to somehow be aware when it's running in a VM offering nested
> translation
> > and do some more magic to inject the appropriate region, and it's all
> > just... no.
>=20
> Er, I figured ARM had sorted this out somehow :(
>=20
> Eric, do you know anything about this? Where did you setup the 1:1 map
> in the VM in your series?
>=20

Out of curiosity. Does this flag have different meaning on s1 vs. s2?

for s1 it means 1:1 mapping.

for s2 it has same meaning as IOMMU_RESV_SW_MSI stands?
