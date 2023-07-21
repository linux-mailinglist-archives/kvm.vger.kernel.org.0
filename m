Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7475C208
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 10:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjGUIvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjGUIvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 04:51:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FB82D7D;
        Fri, 21 Jul 2023 01:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689929503; x=1721465503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GacvXT0EbyEaxBIjd5mETteHVLlTCCZbISoUmp2ggtk=;
  b=H9Agpc+EajEfVAvwvB+w4M89tuokxEDTEoAXDffjdxx4V1hOWSfLabYx
   ZaJGQF5os/WfeQ6AJHpWknE8p1d2VZFLCsNGLDg1sqMKP+7I4AnWRLLAx
   a/NCJSLsKiK3DoHiEM2DS4nGKqA+OFSW/bhSREAHe3IsrivG2XqMpLIRl
   9uHcMw6d74MeAxXkXVSw6lMRcwwXCugIEkGlH7uGMboign+Yk0M2ne6nq
   5WYuMmX+abPHgfrV/2utp6gsil8CLJn8OmnegXYYgwWZqis/kj9Bw5UEA
   y99/BumvH0O1QRc7E24SxFtt3VdYTkzYl+07UHjieblmdJbmpO1etYvyD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="433203595"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="433203595"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 01:51:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="790132059"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="790132059"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2023 01:51:41 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 01:51:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 21 Jul 2023 01:51:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 21 Jul 2023 01:51:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ysfu+zVIZCVXR3moMdz9DcYnCnfcgUTXL8e7dGJpWjDBd7LdrfoaQyme3Go5MVaPeD5TOauX58tL4e3bwUB170FxkDdPCkIedWNDMYd/NNtDGflsYNoR22TQ0uOvwu1vRGCboOqO9Z4BEXq2/HornMv/lkEPRINJMSGcYUrefAbGBjqeav8SxDMAoBTI4CZTlLTGw/2YsYbp5wgtD3JvWAzdVA1DAR0VCEZeCWoZergyySdHfkEcuEMsPIzeHnkUWFtnjmkAj2Ea7nRYvbtEdP8/tP39K8D8/IhAfkUjHtYHsRp57th6oAyrwKblh8K0sIqaFdve29eC66SlIBDBTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GacvXT0EbyEaxBIjd5mETteHVLlTCCZbISoUmp2ggtk=;
 b=NAgpwzFDfpijSXRm5O6YoOtlUCmXE+AhIQwdzp8WKAoaicichYD9ShbpDRu7hoTjcl0L26gsXiYajbZciGb/m/jt2jr1fx0yK5eCm17RzEQtBofl2KA/JMn97OXvn1iYKsQTEkLGOkuaRGWV5Ev1aF5wnSRj/SouhcFMS4Fedm9gbx5+Zyx6eht238kS0J6PdFfU563pscjjVh7x3MrINwC5YJZfYWa6VweU5qthGmLHkTOnh+7NA/CoZEotPZHgSmnqfoBMeQGruQroCzIDjtcwajRXxK2Vt9vLNXnJEJyQ7T4wVym4vprKrZB0FiqqVoHVmUqux/ksGb93hNbkHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7706.namprd11.prod.outlook.com (2603:10b6:806:32c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 08:51:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 08:51:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v12 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Thread-Topic: [PATCH v12 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Thread-Index: AQHZupFlY4vour+3q0qDNUp/ezTlxK/D64QQ
Date:   Fri, 21 Jul 2023 08:51:30 +0000
Message-ID: <BN9PR11MB527674C8514E38AD1E31B3528C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-2-brett.creeley@amd.com>
In-Reply-To: <20230719223527.12795-2-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7706:EE_
x-ms-office365-filtering-correlation-id: 77f32d4f-ba45-4f5d-d319-08db89c7ad58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sRFSrfhasN5D29axWmMm10OClsPowcS92c546/00tjOnCPriCqOhPfedDcFu8mo25hdOtRmfd7Ioiaoq7wIeobdZ+HwFa5Ps/tTm9VL2FALyMAQHBnDcTnlmRhqV1FgK3IW+4LlUQR/hr9wR44M9RzTMhjUJX2bQ/PyGp9kVnpvMMYFuL/3qTjCVVX1eveH7VPR11js91Apmw097ARFc1yxuT7e4b+IXtjm+E/fKHFZC14C+0oJEM1E9wMmWjFqNjdw5TBP7JaVy5YGUP3ce49wRursdc/oxXhlBneauV4sOVRkKfvE2CrXIR9mDV8GfPy2WYo7LCOwDY3JVIUmq4t+yuSVXM0QjYqUkNxgjYmLtqw59TFYDslEFUoLSE87oujSaQF1rps0rp3aaJAT76kxrOlUa+v6uTCkCsZo7V26f6M+PjCMVMMaixzwRleB5GXss1XrRgoY0AHSaoa+6eiU90+WM6B4gi4pA0KC5n+rzmicSO6zlki0a7+F185zLGfp4Fp4SyaTabrn7kV8UmAJeGILYGAe9wHqY8mkKjxBoKAL4+OcwKZICUt/86QnmMCXqKa8e5OamkmcF5oHO/VrIRk1aUJnyuVqowv5XDbw+BNtpOWQVd3F17hatu44lfFJ1OKIKw56eLWpa1U2+mYqZ5SLafbmz1DzrjBJMaBw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199021)(83380400001)(66476007)(2906002)(4744005)(8936002)(8676002)(478600001)(71200400001)(52536014)(66946007)(76116006)(41300700001)(64756008)(66556008)(316002)(4326008)(110136005)(5660300002)(9686003)(55016003)(186003)(26005)(6506007)(7696005)(66446008)(33656002)(38070700005)(86362001)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Eo2WeWjcIiOEcYiBlB50zPITT2Tf/oxg0zeAvXFdUbCyUxYeDnQRfxUiZL5j?=
 =?us-ascii?Q?PZkAeJvx2jrS9G2KUJ44wqP7IA9aQ9BCB4ehd49tH7ubEC19a9itE0PzfMEc?=
 =?us-ascii?Q?dlNGWvkUfmFMkgC7Q2AlSZaZO6LX7svL8gkCFGRHPtfv1gGTK6azTrkk2Z7I?=
 =?us-ascii?Q?ytRFJcHPPgD7lq2afZ+jE+kxcMut6PrUwF2gvwMy5xNkK8cd64td5yPS89NG?=
 =?us-ascii?Q?voLVzWA6L5a85GNXkk7K81Cd3BIJ6IyDPBQIg1HNNysjpWCYk+BZdC42ShTv?=
 =?us-ascii?Q?raQvJNvOwuR00DDAjTPCrpnXRn/mSgOxg+/udGqV92JDry8SoS/w5KMnQQ/v?=
 =?us-ascii?Q?/lfa865noWxs9GqL26OLFABuB84ADqObrZq7wGN3e4JA9Qu7FI8vgwCivJwl?=
 =?us-ascii?Q?EagMXqthgEVniTOzxfHg2h1BAcTJhaTNeOvauaLumP2rJHU02hhOjFu6xkVM?=
 =?us-ascii?Q?ivsujt5CdXx8+kxBF/UuXOsvJVld4z6x4l4oBT7BCSv+ry1F5rEAuzEiuzxj?=
 =?us-ascii?Q?zdIryVGnPznCenj8Gqc+mOj/p3SKxGkaoAfjZ2Diy068JqNXHx/Ygc0Fe3Fb?=
 =?us-ascii?Q?hs4/5nkPzj59S1v+Vmg7iQKKkyu1PoRjGOwsTpqLVjtbnvVbPk0zIYJ5c/If?=
 =?us-ascii?Q?jkbaKvSqxgqtwg9+6U9lu49IkzQKx3lq2C+P0IlrrRXR5VqmOov3HPhGrAtz?=
 =?us-ascii?Q?fovaLwrDuoGJiyVwu1wdBqgy1j7IpU5M4dlM4Jnvs9dorXaciKQlwn/XdG5f?=
 =?us-ascii?Q?Yx6G24CsIQ68mY7f0IrcN0nU3Ri3npOiyByZUnCgHrAs0l1nhC3ZDC6VX4Wa?=
 =?us-ascii?Q?2GO2rsXHqkOgfqGHhL5IxXRWEmmt3hMVF85WjQnuj81NIMJPTXSVZA2ec188?=
 =?us-ascii?Q?PPjzZ70zJsPTYz+5pji1083jE710zN1bW7WOphDzu7eRsaiaByygfEOBxpLA?=
 =?us-ascii?Q?tFEjmz1pSDBH4oUPSwSVBz/bmwbfG3u5WXKah5FE4VSNqPWK0vr7LY/2OpOC?=
 =?us-ascii?Q?l46GbrHazxDcHhMgpGmSJc9QvK+DFP1r0ju60j6nIKqAaQy5LX/pc+btRv84?=
 =?us-ascii?Q?5hQG7gtagsmLmXZk0SDEwEle1dkKq/XAn7o5SXussT3vip62aFkalgGPTWin?=
 =?us-ascii?Q?hea82DLxF6v+0jmrbdvTBahjZCTkVPE8h82uYFP14Iueh4N7Fmyvj3A5XK+R?=
 =?us-ascii?Q?aYSNgXsWv8b5sZu9mjiBVar45uCNTVghHhnt5Z3J2L8XLx7oTU6CvSR5r/nu?=
 =?us-ascii?Q?BAppRpAXdTRNclIePrtBT2ZACf693l6encSW1VVTIjWZveUC10Lih26lr7KV?=
 =?us-ascii?Q?uGRx4eqXhUIiW/le9dhT485gR+aCG7CyI5DqLWU9PfpzUZp+gXuddN51q/j7?=
 =?us-ascii?Q?9e0/76zdVcps+4FGNcLmEuBeGnRTSlVWGjhILvDgXP0ul59+2ScVYT+YmzWz?=
 =?us-ascii?Q?8QksYCwyN+y9nmkpbegnSvJ0JoV/kd8vGcuaJSY4pcKYxgu5Rac5A2S2zNQX?=
 =?us-ascii?Q?Ls9Fvg+DP6gRphoS4nc65C7emT8ZvCwn+ldtEc7SwAT2bMiRtG9O/tEKcrYV?=
 =?us-ascii?Q?se9Bvcq+q8En8lIKenUnlZ2Z64bkNq+jjasMbi0W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f32d4f-ba45-4f5d-d319-08db89c7ad58
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 08:51:30.2324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5mG19xhIdBsIPhry7o15ZSUHOKp8HO+tM9JiShvGY9ag+HQjfcQKvETJRNelxksTkg7nkcYcjGZk5+jcAiEbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7706
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Thursday, July 20, 2023 6:35 AM
>=20
> Currently only Mellanox uses the combine_ranges function. The
> new pds_vfio driver also needs this function. So, move it to
> a common location for other vendor drivers to use.
>=20
> Also, Simon Harmon noticed that RCT ordering was not followed
> for vfio_combin_iova_ranges(), so fix that.
>=20

It's not common practice to put name in the commit msg. Just
describe what is changed.
