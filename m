Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE9D786846
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjHXH16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjHXH1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:27:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADD10C8;
        Thu, 24 Aug 2023 00:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692862067; x=1724398067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xWDz6jMD5opAPBCUKkPrFbPKYrjLO94egwCOusL+aOU=;
  b=fY6jfdpENQYYa38ZNee1SHZUcB5IOXISre/1iXJsrcrZ9nE2dFMCDnBJ
   KHAJlho3RCA456Rxe5aOSOtgvZ/5R/iZae7CzhiZfqiAekBHZw8fnyPpy
   YijWj1vluwS+TJ9Te9m1iNQhYvY0VKpVVJafS9GY83xg1m0QiC98xhNsq
   9gQZfs2+a58UK09gztGF9gvyRR8Iy7RXsVaFetgimlMBhk8nkrkDhOjya
   wnnxIRzdQcNi5WJ+7l3G0aZOJUz/+Sr1ZbLPr0VcSsQSEa9/BF/vZdIm+
   pHNVK7jIHusnWDMEfONa8T6eLnrTbRsfkUbUstQs65zvdYnbT2ObQV7i0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="377095678"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="377095678"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="880698377"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 24 Aug 2023 00:27:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:27:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:27:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:27:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:27:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coTaMW15cEtiL4ilusFyXZA0VgrFpO0ViaAbtTWgMmkXaJSWSYxPF7r7h3x9rhgLhHq9I8vJYaBxKAGopya+3zOuf5DczbrbD12VGvaA8aeRvjJ4mhTK/BmFr6S4g3iizU5LcyqTSvWXAnGvgHS5UxA4Eq89Cp31E12+qK0Bhzq8VMRyHpQpSw1D9ylyZft3ilf1LnPEmv1ZcKLMqQz4jMizmoVOeiK+gFhv0BybhN91EqT8JhDDw+MaG8nub4CbHv2SLlQooV9Bnb9cju+NFiNh4pYwoscOEWxHWuOt82ToL8JN/DhAbSyReb0aD43O36Am+IPPD2TAGHGpqXeP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jqvuguffrn2vY3W6dVAZAvd6WBcGgFUQv7bIJS86o0=;
 b=C9/EWsv0hNc4zI5noNNl0MGPv3ovQvLaES7fPrQgh9cefPdT1LphXmqv96MJJaHWEs7qD5+d8wsYQ5oTBkofZuWBiUV+X/2uXB1ZicfZQ+EslWjVTj4m4mwsHOIaeGvSUJbxx/hNN0PbRuNDPywvtqx50tp5UQj8vgyZAOWVTItzObTqdM1a0m+mU3MoBS/+0z73X4y6Ruf5CJrALl1/UROeBXtJ1IShck7mulb0V+TibiNctTobPar+YZgCCL6RTpSGixFBBVjJpiWrQUCRw72w/ydp2qJTYpbrvcqNLTSsoWhGC5GOQnT5AXoowL69RN7yuqnUuvssXkm3xyDO3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:27:38 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 07:27:38 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [RFC 2/5] crypto: qat - add interface for live migration
Thread-Topic: [RFC 2/5] crypto: qat - add interface for live migration
Thread-Index: AQHZq1VZq7RAeX9Tu02TaNt5lN+jaa/Z+q4AgB77VkA=
Date:   Thu, 24 Aug 2023 07:27:38 +0000
Message-ID: <DM4PR11MB55020CCFF28CBECB07ED2F24881DA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-3-xin.zeng@intel.com>
 <BN9PR11MB527644B92CE171ABA202E6AE8C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527644B92CE171ABA202E6AE8C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|IA1PR11MB6490:EE_
x-ms-office365-filtering-correlation-id: 9cd1a30b-e32d-4c2a-fdcc-08dba47397fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 45tRY1WB2BmYykzOSl9NfAH/CO3q0fwx/iMb62J2MSt4AQX03IuhyXAcvtZdmy6k4SX44KrICAucLmeGHZloI5XOJJMy7fgwK3Klab12tBIuv4fAD/nqUNhg2DC0g85OhX1TZi4dl7UBhtdQiyR9OiSbp9QaJa1VlZSCs/CzKiLrQlf2ZLeHZhKsrZHuYjYPZ2vtuvaByvfPySGLDolDvh1pAphOlLb7tQZezrswmVXQPooNT+Z8tdQWgLQV21PXu+G/Nx5jCPpGv85a1QwWZtlbWaiimAROBTcIt2jSLwZSzz3UUqBWzq4p2Jp1Eh0zi1T0sKfWOIIrSAaJ6+xY1dh32KG/XP+MfX/+Ej+mg0EoVBh/FkZkjpTwvJkAJk6Yv2qoce3qWLADkO7UzgZ7bHW9mui+lLPn21YcaQwMG1QOoAKsoP/qAnjJf723CB5ppNT0SKPMsbnnDpb7HMPbAsWq2HZgVpSX/2hu+LbE/ZlVooHVzBqxemzn/MMhfIia5mtkE5nrwTOPQfCStP37Bare602EBFrI9YrI31joNHW5qhaII9tHOrA35orckXfm1D0z9Ma+MszSugsgDiZhrgi/BunNhWtE+H6WJUvaRSM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199024)(186009)(1800799009)(54906003)(66446008)(64756008)(66556008)(66946007)(66476007)(76116006)(316002)(82960400001)(122000001)(478600001)(110136005)(55016003)(26005)(38100700002)(38070700005)(71200400001)(41300700001)(53546011)(7696005)(86362001)(6506007)(2906002)(9686003)(4326008)(8676002)(8936002)(52536014)(5660300002)(83380400001)(33656002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qHR+QAEWv931eOPF3mdfRRXrZL1Ws8UFaq6hs3J8mfwaCro9XBZEHwTsYKuD?=
 =?us-ascii?Q?EV0B4y4E22iVdW0nkgnq6NQkh7kgEj4vdxCE7TV2IPRfEgH7naWtWAglxAoZ?=
 =?us-ascii?Q?ZFZ5177V2NqvvwWi2Ws23p6OcJMq/yumcNVoerU5G0+B1D/jx5EW1D+aB0FT?=
 =?us-ascii?Q?pUqfk3cF3CMZgxGIKaPfyQjLes4D3OwRifJHD+vCleXGAgzj0KJ1AjgbpcOG?=
 =?us-ascii?Q?CanuM7ZRoMmBs3lD0VlQOJBhuZkQduKiNpvnAskjAin38UfylhV04piJl5md?=
 =?us-ascii?Q?50Z1AtLCg5RPh83pZca4MT7M/wC4v2rRwkYxyWylUkTjdQLptzrERHSWKFi5?=
 =?us-ascii?Q?XLcvhauTEkbuXaHKtOfudhUEMhcQdV9yB7mdwbVqIBMCpKgeML+1gku5qWRc?=
 =?us-ascii?Q?V8aPoJhNoz7ICo45qtjUfVO4ktXBiI/fdfrvfhaihJ1UCfAaejr7rtgk8Ffo?=
 =?us-ascii?Q?8BhkVG8PTdzuOFdZ3CcWb+lC2X+qjvYW7GRsukc5GnO11Gu/V8IoJOef7lCr?=
 =?us-ascii?Q?z2wxxcSQ2Tg1YOsSB7yfNpKPSi/siNr+JS+rrYPYTZDUvGnYC25SMUegiNT7?=
 =?us-ascii?Q?UW2vBS/iko2610sGlgrmV83A7najicNFq9lZ5C1Y7cfoAnhnL7+iBwlXTJOk?=
 =?us-ascii?Q?UXHrNd1/HqHzdrC4xKLeq8Ygl6pS5FfxqzU996FQrvJ7NGyUUr21ZUw6DWml?=
 =?us-ascii?Q?z4KPczaLiIqjnfGLwA8pP7RiGMpjVOaMoayXz2LZUdBWKG/dhnrj494yuZcg?=
 =?us-ascii?Q?0zzF0ZTSy9ez7gNAmx0vV9mHDbrXDQwRrHprAN7mai+nx5fuaOXQucx+SENN?=
 =?us-ascii?Q?UjgdEEV8ivAbaeYeUlHxjaK/U6vKu/RD+c/LjaL34x4CHcybF+6ddqEtCaEo?=
 =?us-ascii?Q?aSmb4/K6EMqtRS1YcXUfKEvWSkI+Vu/JgUybVu8Lp2OXefLS8X4btS6gq6Yd?=
 =?us-ascii?Q?9/eXfl0AoczOTFYwov2dB8Zg1zSYqQpu0pZkOILjZ0hd0oVcEcyc8Q8PBrug?=
 =?us-ascii?Q?1is1IKU2QJbbAfprCGukTQ4azsKQF9FjueXATD4KgL/jfbEZwxneQyypEJPF?=
 =?us-ascii?Q?U3ymxFTopCscBsnoFK9Ks2mDTPlynYi/fab22o1NVZYkEh9TuMgj4yweJVIo?=
 =?us-ascii?Q?QtSHA6OULFWwoJ1n2HkWZlOJDiP0GTlhvEtIq3XTVA82uu+P3CpjUQjgVZi4?=
 =?us-ascii?Q?I07iXv85YQbIGmEKMKIgvc3Z2x0q04FVp3FiJsdFiJZg56JwuoIFO2/LMOhP?=
 =?us-ascii?Q?toGwUoj0VOyHiZLcUeBks6rP0EQUdR6pH4AVIkfNnAHlPWtUwVP76XkzasKz?=
 =?us-ascii?Q?MDnap4Bsyixz95r4wPLXs/JP/MEdCMa4tzjMPub4qsrdI1yQwVnOwpMf3Es3?=
 =?us-ascii?Q?mxFTx6d5Sa6ULjDcLmPWmiYU8gbL2bAV4iIy5DvNjzylw5sUCFuLdVRgdrLH?=
 =?us-ascii?Q?47lL4KGXpOYAW/yzLo/dC+j911N9gJ9Pz1n6GDRm97OWum1CgP4/Bk5zIhB+?=
 =?us-ascii?Q?I6H1VnmFJSPEhNlqt3+1lgaX2MS72FMAbDwgIw0iW1UDc6EpI4wumha+SPme?=
 =?us-ascii?Q?kNEpYD7IOMh8UWNtZgsB2I7MlcubqIy/vssw7z5B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd1a30b-e32d-4c2a-fdcc-08dba47397fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 07:27:38.1156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g0NIWGrXa5CHIifM68vD2tuOI2tfVr6MZgfTSUYkrwIi/178LtcXDCVeAtLSGiJiPiHLo7Tz6FYn4UyiLmqKVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
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

Thanks for the comments, Kevin.

> -----Original Message-----
> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, August 4, 2023 3:53 PM
> To: Zeng, Xin <xin.zeng@intel.com>; linux-crypto@vger.kernel.org;
> kvm@vger.kernel.org
> Cc: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>;
> andriy.shevchenko@linux.intel.com; Zeng, Xin <xin.zeng@intel.com>; Cao,
> Yahui <yahui.cao@intel.com>
> Subject: RE: [RFC 2/5] crypto: qat - add interface for live migration
>=20
> > From: Xin Zeng <xin.zeng@intel.com>
> > Sent: Friday, June 30, 2023 9:13 PM
> > +
> > +int qat_vfmig_suspend_device(struct pci_dev *pdev, u32 vf_nr)
> > +{
> > +	struct adf_accel_dev *accel_dev =3D
> > adf_devmgr_pci_to_accel_dev(pdev);
> > +
> > +	if (!accel_dev) {
> > +		dev_err(&pdev->dev, "Failed to find accel_dev\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (WARN_ON(!GET_VFMIG_OPS(accel_dev)->suspend_device))
> > +		return -EINVAL;
>=20
> this and other warns should be done one-off at device registration point
> instead of letting it triggerable by every user ioctl.

Ok, will address this.=20
