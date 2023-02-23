Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1176A0242
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 06:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbjBWFHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 00:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBWFHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 00:07:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220513527D;
        Wed, 22 Feb 2023 21:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677128859; x=1708664859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n6ml1LhldVZgTB+XyVBdvDmDcqP56+iBpXUIV6oJ/rA=;
  b=n2uiTzghJYwYVAq0lBR5k6Tfx0VH+dlysA4W3mnDdCsKjtD1NqkI7Cdj
   m5sDsnSIyOg/Lhmrd2WDGSfQ5NqiQ7TPeP71bWHTp1f2TSnMIYsyV6Kkz
   ta0p3D9DdpOZVt8nH7WMhmQPxwPpFmQJxKg/R4IbSF3pxLO4S23tDd24a
   6VMfpnHeNLtxRE7ssEI2InkqnRLQVUrRwqIUzot0NKVxfpkdNjFH3kGiJ
   Z+CDnC52lJ5Yg9fgbPga0AxUe06hNajbFxhIHSZDqUgk8u+Ugb8bdFOBx
   Bi2U+KEWVmIiyo4IDejSHR5Z2QgDyCalRAjvdf1+a0oMghBy+Idpjc3RO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="321262449"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="321262449"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 21:07:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="622190951"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="622190951"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2023 21:07:11 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 21:07:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 21:07:10 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 21:07:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfCL7oC8+yqSWAFiBsm2N9JoBA+t2ZODOvOPHAuGq8oVBxC2bnu6dUxDynJG2RERo/MpnLvxT0XYlyDsJxBIa39QvNPsNo1TyB+bl9ZpZJ468zu4vID3v8CZR4AMfvJ60ZjE4YE9urCsVkAOorlu9JwCO8D7Ih1PK5E58HMA5MDzjbPypqEQUgOcs4OtHAlm585C4RIF1zLRqsU4D34+2GXrlM++yrrLmg68/cikM6qrLGoHn+gk/V8jYVOB62cJ4hOsSXBFDI8VVCAj0nn+8vh0ubIOG0lUvuLAxf6Yv1DyU1XhNKtmuSpvpxqRbwbxmjEoyfWtw1gW02rQUM11vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Npf5NEIZp2XPL1OSVHTe1UkLc9kV7e6q+gzX/9llioQ=;
 b=BoywBs2Apw5YX5R8tsWFVsGXv/i69J6aL7KDkCoSeMmV5gFqNeYae/LlLRyHXLGraM4NzT7pIXYo+MsmBibsI5qJiiW4rc0OTubUaOU+/14GaOcVdHhQjS91QmILdzE2ALF8Gn9IBsOfmwOuBsUmJWuTBGwS/QFEsy4chmEGbEqMkdd5BfQYVOwvlhv0Zx+Eq9J9HQluJUDYKBE/23aZ8SNZh9XCqW4+uuO9eW//vBCM+dp3vN3PjZWCTtcYrb1IwZEUKKZ5IKgK93bGl/j3Y2CNoxFB+6TKxcqUy6wNbOeqMqpr6vPH2y9qbS68qcNGKJgIPqnRSFBXxlwBDoQYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4739.namprd11.prod.outlook.com (2603:10b6:5:2a0::22)
 by DS0PR11MB8206.namprd11.prod.outlook.com (2603:10b6:8:166::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Thu, 23 Feb
 2023 05:07:02 +0000
Received: from DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::c442:e5e2:35c4:7339]) by DM6PR11MB4739.namprd11.prod.outlook.com
 ([fe80::c442:e5e2:35c4:7339%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 05:07:02 +0000
From:   "Miao, Jun" <jun.miao@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Szmigiero, Maciej" <maciej.szmigiero@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: Align the function name of
 kvm_swap_active_memslots()
Thread-Topic: [PATCH] KVM: Align the function name of
 kvm_swap_active_memslots()
Thread-Index: AQHZRQfG/5qoLPdSx0uaQHuTSRKFXa7bT+8AgACuWUA=
Date:   Thu, 23 Feb 2023 05:07:01 +0000
Message-ID: <DM6PR11MB4739574A5EBA94A487D725319AAB9@DM6PR11MB4739.namprd11.prod.outlook.com>
References: <20230220084500.938739-1-jun.miao@intel.com>
 <Y/ZhYiN+oYbx6z5n@google.com>
In-Reply-To: <Y/ZhYiN+oYbx6z5n@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4739:EE_|DS0PR11MB8206:EE_
x-ms-office365-filtering-correlation-id: d75362a0-deaf-4029-4292-08db155bcc68
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uk0FfHgsEBelryApHVhOCQZ/0MhcNgvmZn49kKL1W4u7qwQORFzYdYAVoC3TLp9GhaX0CbLaW2bRfV/Ekp6OQhVSxvVBzb8ZByJiG1BR2EZt3H5VY9j7e2UYhsLWntZ7MdWpjfqFVHoslHO2nAbSDw8Sp1P33WwRqr3Ulf9jIS3DZZkU8xdpjksSjzfeWewPa3d0Mz0YYla+K5AIUE0vknyCcCIb9jCds3Y1mYJ1oZ4ImRSJQYLw0p1EHwclna41nAoeQEp3rEwfNVZhn7pnsvSahT3fLQdfR/9uX+RKUylQPkLbMDo5tOUzQpM1tMdyoNY9d0qNA1nBby8WM1m47f2fyfta4KNlH7XRYmCDppgDlXi2vXr5aBNwYuZ8U1nVl9pR16gcBRHGRYJ+lZWH7aMBZIV81ktxip7rT0FaLizrLT1C8LTRJ96MEFU7B2QfZ/ZxoBITxWQbVH87TaoF78og3C2htiasVkjH+GyIBjGgNylwHbjGm/QtRBUN1/BZut8RTAt3AFPGs6H17/q7VHzQTLiHmLDFxpBpHdiy4RgqGj9twc3gN3JGwuvWBQw3HXKK8yKI7s2qmJXsl9cZJLuPYcvmsHw/D7A8i4KyBh1O8L47FWUCfAv5IP8vyuJoL+425V/C3uZHPn6U2D6qBeIymHRINrZwaFTuExa62UPl5MboqieCxV2a4GqXh0RXPVhB7tOm7gbjeia+OvJUtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4739.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(316002)(478600001)(66446008)(66556008)(66476007)(71200400001)(66946007)(64756008)(8936002)(54906003)(8676002)(52536014)(76116006)(4326008)(7696005)(6916009)(5660300002)(41300700001)(38100700002)(122000001)(2906002)(38070700005)(26005)(186003)(9686003)(83380400001)(33656002)(6506007)(86362001)(55016003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?87Z5B6lDTG6cJ2+6VhNLGAd8q/ZzBVn+1UxJ/TQmMQDzX2HsHFXhWKG3OXB6?=
 =?us-ascii?Q?v9alj0WSi5wn1+KAwC7q77XbWntECsF4l742JTXTZTE6RST3+terXaKLSs+o?=
 =?us-ascii?Q?FtC396fHOdQjAIi66PIp1ZXTl31FxMm62B/FdWYFpv/NXSmGdu2H85+znZvv?=
 =?us-ascii?Q?cmhcpCWnzO72EAlzEFR7Z6wDOVcmoRf3yLvJX8FlGR9hNc4X6XhqJtGyMbzy?=
 =?us-ascii?Q?fxLWBFqYMyI614AChokc8GP15rcHPQOLUUdCfd5wJeFSJGi8Rv1p3CyZOxOP?=
 =?us-ascii?Q?Ii/VkBsh0h19cFjx5mul2y6L9osDsNvnzdUb2i6TaWojNpn0VdFC6U9Kd5Yp?=
 =?us-ascii?Q?CYoJjlaWIIdp4TSp9f5v9AOv42X/gooef9uGzwqZYM5YoUK7GFH02sGTkOzd?=
 =?us-ascii?Q?l9fp+NlFskHSX1zmXqPSpqqFOOBS7Df7V+9CwhKHjmlBqQ8P2Shv/Dk+kTAU?=
 =?us-ascii?Q?0Xwm/xjJWH5mHsWqiy7vp/F+Iuwjo1/AJ/MzzMHEeS7dZfbpG1GkhVNI3HLR?=
 =?us-ascii?Q?YkunsFTBrz1egQWldLwvjDnBzY8Ua97Ml6tMpApIHPLGSTiIf1sao8437tqk?=
 =?us-ascii?Q?ksg2+RTFXac6D7c7HVKlG0ZGy8ylOe91S4kLYUSqxWDLiifNvfTx+qI3lWgB?=
 =?us-ascii?Q?VAj3s5WGcuSJ7PNwQlUoNzfWnGv78jyOfV6lbfjQ3efefAuoEC34ogDtICbM?=
 =?us-ascii?Q?ljWwBmvqjHEQ5ya2EyV/dEZ35FNE4tfab6sFD1v7tFfQ7Q9DJYvrkts9+8da?=
 =?us-ascii?Q?ClhYHyOWEukRNpRZ2FR6le4ExmjEWVJiOWosuCc09fyZsecu1ndmnQ8bX0Nb?=
 =?us-ascii?Q?jWA6yof1BHB3rHOrSWeXK/rQQLVvPccH/26pyukXwbOcSX2tRCfFVV/kYVzZ?=
 =?us-ascii?Q?pvZbC+ipc3n4Ij7/UhzQyawo2eugcpohDiksCdv3P9QClWQUH/ZFy+E9PlP8?=
 =?us-ascii?Q?Z2p3b1pHPzPPSg4/Uj9Hfb2VDoiGq1zZapLQsukEqdOwtmBBzAZurfmgbdkU?=
 =?us-ascii?Q?HKzDW16DQ/6idxB6i7/8zEHVI9lvQxg68GOrAIhOlwJOzWMphXfL+MYn6Sw6?=
 =?us-ascii?Q?EUFvnwH6IpRODzaEA6qcG9LfEeM2h6MeRQJcwBKdBtxpVWVVQ0qlJfJ6ceSr?=
 =?us-ascii?Q?uJ3Pl2Z3pAQF6oZSAVtMPz6F5retpUiNpkoGUbQHSv7752IyS0ParLcgDbTo?=
 =?us-ascii?Q?e54H30bIHQeZchuJV5AnMVsZUfI/IDeV3fdsEWo5SIybRaCsuUTRT6OhZqez?=
 =?us-ascii?Q?yIbo731RJv6zotTZBSYzA5+McsC0XtA23MocSzzZR5XVHwlrl83zbTZE6zr4?=
 =?us-ascii?Q?Bny1es/pnPDyVNUaPnKya9onfFtGehWbDT0Sb0fH9rfh7Hg8tj7duqQYKbjw?=
 =?us-ascii?Q?5xxf23UYESK5/nJrX0Lphwu5o+tY2nYDwmFs31Pj5zFVrLCl1INbwKWSs2Qk?=
 =?us-ascii?Q?VNdVg2urZCpPMd5lVQQe9OFvPDT7iXTCYhXnB5RSYRuwvTJlL86Fuu+aUYkK?=
 =?us-ascii?Q?mxk1YHM6rG7Y9nrGpmMlgRiAe2eNWKzsUqQy5mSK8sZrQYiYNqzbaWsM9pVr?=
 =?us-ascii?Q?B21Uk7PlocvFPqTvJ5HjLVINLIpt/X1Fht2TGNEC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4739.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75362a0-deaf-4029-4292-08db155bcc68
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 05:07:01.8180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F34KKOG5AT7XaeWAWUizsznBRzmH4vGuK6DOppjrrWuXZJDTZ4DOFjVqr/KCDOfwo8e29YusjsIiy7Q5/C/p3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8206
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> Nit, "Align" is a confusing because it's often used to refer to indentati=
on.  Maybe?
>=20
>    KVM: Fix comments that refer to the non-existent install_new_memslots(=
)
>=20
> On Mon, Feb 20, 2023, Jun Miao wrote:
> > The function of install_new_memslots() is replaced by
> kvm_swap_active_memslots().
> > In order to avoid confusion, align the name in the comments which alway=
s be
> ignored.
> >
> > Fixes: a54d806688fe "KVM: Keep memslots in tree-based structures instea=
d of
> array-based ones")
> > Signed-off-by: Jun Miao <jun.miao@intel.com>
> > ---
> >  Documentation/virt/kvm/locking.rst | 2 +-
> >  include/linux/kvm_host.h           | 4 ++--
> >  virt/kvm/kvm_main.c                | 4 ++--
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/locking.rst
> b/Documentation/virt/kvm/locking.rst
> > index 14c4e9fa501d..ac0e549a3ae7 100644
> > --- a/Documentation/virt/kvm/locking.rst
> > +++ b/Documentation/virt/kvm/locking.rst
> > @@ -21,7 +21,7 @@ The acquisition orders for mutexes are as follows:
> >  - kvm->mn_active_invalidate_count ensures that pairs of
> >    invalidate_range_start() and invalidate_range_end() callbacks
> >    use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lo=
ck
> > -  are taken on the waiting side in install_new_memslots, so MMU notifi=
ers
> > +  are taken on the waiting side in kvm_swap_active_memslots, so MMU
> notifiers
>=20
> Can you send a v2 and opportunistically add () to the blurbs that don't h=
ave it?
> I.e. so these are all "kvm_swap_active_memslots()"?
>=20
I will send V2 with the lost "()", thank you for the warm and accurate advi=
ce.

--Jun
> Thanks!
