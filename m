Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7A5B1966
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 11:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiIHJzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 05:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiIHJyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 05:54:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C331101;
        Thu,  8 Sep 2022 02:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662630862; x=1694166862;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=tpSRmnERUU+bt5kNGshWiOS10AtbXQ84Q0iCOiE30GQ=;
  b=WDQXpZL3UyPIPOB/x4C+QtZvNnX5lyu2dlPjlXyGAUB3YvBi1Gb4ST1C
   0nSXYsTNC9djyhegdpp448cnxTL1RIUCpQSYgA1EAGErVSPQWiuv5J/JS
   AVHg5871C/HPXztnp0dCnXtmyGlU0nxRI7cr1t0/sJpcrAVCKxFzvOtY9
   E7hIngeSDSnNZ3zGpyv47j/5L2lVIkt4oceCFPx84RwE/mrAGoT4cotyq
   j7HiH2LHjapuo7S5fakmLO75r6T4AKSeOnaPmFxLhFkzfISJ2s2M0Mzwt
   5td7vU7qLtsRpSAwPj4V1dlYF3eAd4ID2IxG4ovsZeFXoGH2Zjq0t1N3n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="277514443"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="277514443"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 02:54:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="943278312"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 08 Sep 2022 02:54:21 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 02:54:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 02:54:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 02:54:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 02:54:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtK+Sa1H3L9MzabahBJm8JjkTUVVoVHJCjsTqglLO6vLpRiiEKGTo5CkJSP/tPuDa3ZKw/qno/35GwdO4jcIrooS2KVsVCbuEUj/jskoA9WPIgN0f5y1LUOuFY/cg5dyWV2i+e6DG1swbI5oTVGML433N6WLCQtTReNkPNCMBPWgLO6fKpST7hma9gMN3s7mgi4UQ26My6OJ7RFsWAMOrVYvWwN5F5JwLcwREfRAgSZEqKO6QZd4ohC+0Alqry9LCuMXfIeSz33uTM7H6vlLYrNXzIi4mVvyoyBjmEoJHp7f/lvgOxOjwh0VVXvYHd+f0btmzAO3wB36Jqo9pwCh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjzgJJa1So+uPKxd1+fFSQQrE34WAQsAmphg7EiXR5o=;
 b=K+aQWyVzo4nWo7NA4qjzTwO39nnFYalMp40bykwU8VzKxsJxI9IuHZ3PGoVcWoEbu5zxI7ZZB/atk0ljAxO+M1FLgPKyulUbFcmZpjxjC/wmcYvsLFZDXL2OZ4wDgIS95d0K/cZRMtPm6ECH8KaOqAR+7mxj9Ny1sBVVr3DKbV53RuRRe69D5oy1yxTVjZX6kKQ3TRuehqS5Ndop/AB67ZiPrgdU+1ljL3GfWbrlQo5/oVllpEXQ1oAN4abMTaA0FTraJCbbx6fKG2WxAyqhyYq5l4E3zCAuIgyhMqSMdeRYjKAoGGzFUM6T04RaZQUwFbcFCZ7QuAYQwHKAJ4gW0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5362.namprd11.prod.outlook.com (2603:10b6:610:b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 8 Sep
 2022 09:54:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 09:54:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Nicolin Chen <nicolinc@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYsNLwCXoHuSRk00qOEfaHbTrxlq3UDMUAgAASXoCAAAnsgIAALAkAgAAs1YCAAFRzgIAAh2pAgAARlrA=
Date:   Thu, 8 Sep 2022 09:54:18 +0000
Message-ID: <BN9PR11MB5276F93044F557D1473D7FCF8C409@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com> <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com> <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com> <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH0PR11MB5362:EE_
x-ms-office365-filtering-correlation-id: 3cbd2586-9ffe-410a-7c92-08da918018c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhgN23UQRMMUx7AKosSMMSYxCfWa+sFcRy6izuVFYe0si2Kvk/dgBSggDX3griPmCZ9UP9mln8/5uw08HzxL2jb9dsuWq9eTeyoqHVs2hYXKR5UHAxwhwJhlFYa8+TwpA9ew0GOq8f+y0FbGogXoRc3nOkk8lebGzXpIaN0olR76fgji9NlfNgv3c9BB42inRUUWV9+bTqtnTxcIlN5Guqn6iVAET0Ta2HOuRvQc7GuC0TebDWIc1LShfoMmkJ52VvL7MmAZOkevoLOBPPpy3eXGiEGTqcEr8OkB4Od8aQoaKvadT8SOsp5iy1ZklgHEzn5raXRNFyHIObdRRvVJ4TyRd6yQZfCZgEGPxPIqlXwShkDRaFRgz6stv562KoyfnjDncL9k1wOmlY37i1GI8ICczGFgqBq7nYQx7CkTeEojjA1gA0DbZkl2z9fWW/v+nM5J5GJpebnbB9d3CusC2BkBZQa1PTucqAv3OKgr6gR9DDrgxPNNICTvDaj0818jXScPd1IBElDQjLa9jtDM3ze3PCh2cC309KIFJWwqeFb6XXqM34Y6lPeMnDVP19Ec5rtb5HKyPUBmmfVPC8CDDrt5hQ3S6WDpD6AXgDdaxsE1ILYolHXeLDky/tHCmOvqW1fKIZWWyXxK246WUxn9esliF6MIIXfWb7E8373btiFMYxRX92GMcsxZNLOp21JvtcIJcmwjNwRYUxF5wavT7OQT7GO+adus8hbrD/XG5q5llOemsknmd/zpKY+Q6Jqdq1nYt6gLx5wRvcOWA9FGig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(376002)(136003)(396003)(76116006)(33656002)(66446008)(316002)(5660300002)(66556008)(66946007)(66476007)(7416002)(7406005)(2906002)(64756008)(110136005)(8676002)(4326008)(8936002)(52536014)(54906003)(478600001)(41300700001)(9686003)(71200400001)(26005)(186003)(55016003)(86362001)(6506007)(82960400001)(7696005)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vbUltzptcGoFvYsN2+2p2pRY/wXXOISp/08oj52GHKrVqN4MLUlufrzCaOWk?=
 =?us-ascii?Q?eSIsdBEaH3wBYs5WRb9MtFcMP9iFgvGmHogucJGy42DPwQj2of4WARcKfSAs?=
 =?us-ascii?Q?3N8YawqhYYHZlmiKTAqB/YBexwKJy9PO3Vif6c0tN82I6TsV3kiDIzrapnPe?=
 =?us-ascii?Q?y6R068M8TmegtEefs3/jTQy5QiGD3CHMaD32dPZAl2GKe9C48V30TuDmWr8f?=
 =?us-ascii?Q?ql2mcqqTyV1snmUn3P1xMv+mH1pnS8M0tdapt34iMzvd4jnlhLOjCBD+Bp0w?=
 =?us-ascii?Q?5eLWdXFNdy8ssnYOpBNNojHDRN8LYEDYYraO+aSUq+Tr4GaUi0vxFIGMuRtH?=
 =?us-ascii?Q?JKLmND5s37X+t4Ln/sw5QCx0po/3QA0xzqgqW3+NmOoBKX4cAeGGaTh5zOls?=
 =?us-ascii?Q?kSw3mo7X56FFgbEIWfZAxrjhJEwN2ZdL0gpTDCD+llPwafvmUzuSl/JSgPDL?=
 =?us-ascii?Q?i3tO1oaoU584DxVrhb6WvS8Sorj1zL6sYmuo0pBYt1RvTXcqvZwsc0f8YFgR?=
 =?us-ascii?Q?aApQ8a8W/VO7FNcgjzAwIZsvibSDfktm1tD5yq1oqv0puCGGhpQGlV1jj4xr?=
 =?us-ascii?Q?eImxI/p5v3XZd+lSNlmVnrIOkCTp7oIM+VQiJByIXgAdqmq6oTNAaMZmUz/T?=
 =?us-ascii?Q?H5FGbSUqNV6zyjsWDVfPMUVeMP7N/WhrcuEsvgmnJLfV1mOcAPq7747WuB6T?=
 =?us-ascii?Q?C1R4ZcwFoX9qC13rShZi4hD4S+q2KrlWptWyq4NfkzWrg7lRYhc2DLJcm6ZP?=
 =?us-ascii?Q?/wcW+LvcTx45z5r75R6iScv9V2DPl3gvf9vmvTJx/mnm6SO/Q/RUZikQwjbY?=
 =?us-ascii?Q?ijFdZEAo5DfeQAd3jPDkXiZOwAbQuytZbREf1+PqpwKH/G3Z2jsSabjk8Yu2?=
 =?us-ascii?Q?6vK0/LOZRhWeRW+jrAsMzwGsaa+AkA9kjK+r3BGArWPTXeJ+5i+iazClIK6o?=
 =?us-ascii?Q?yxokZzpMXxfaeQpvtvF1fLJnBwGZCy3NUWtNP7DixeFfi+wCPOZ7As/vmSdd?=
 =?us-ascii?Q?QAASyj8JerZY3FUbEz7R4iIL+yvALtyNRFETwSBR1dRst/5mPiAP1xvFNX9E?=
 =?us-ascii?Q?pPF9tmfU+mzpvDA1vHh4hA+W4bEGw2xmFPm6AHeGnZ4Y/9d6JLfF56jiYrES?=
 =?us-ascii?Q?Sdijucz803vcgvgg/yh3rB2Q7QGLbXFkPGJsvzZZKTclt6NPSgbAYapwCBTl?=
 =?us-ascii?Q?/x8GInI3m7m1tmuEeC/wSasNM/3dYschfNYkH+6bGUR/JlyRE7xCiISXKsZg?=
 =?us-ascii?Q?jxTpF7jA1gtChv3DNrT3olR92BUEFkdsxa6YxvJTQfpGh/L2Z4BbW3uQi5Ny?=
 =?us-ascii?Q?bldA04MXHZ46pPdcuVAZQIE94hQe4d5rZcUks5+iP3dgyZLvG+7PIeLezJBs?=
 =?us-ascii?Q?71HCeCNTLPbmbMopAnC7CedYKK5bEEVQndLWxBzrcydVygGPHZ+C9h1P2W3z?=
 =?us-ascii?Q?olF+kHsoEu98V8O6QLZfGuQuS31rtdYvo+c1lA9Zk1xBzH8xfrzjAJY1y7Yl?=
 =?us-ascii?Q?7C745igeTv7gFm/r5O+4QAj11wuOpljdmh1KCSXDrvkwwOi/12YqrTSmB0Qd?=
 =?us-ascii?Q?h7VhkhzHkTUJEnjJ3OgDCkUQ+A4WfsOtJQlVnaBI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbd2586-9ffe-410a-7c92-08da918018c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 09:54:18.3380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zTQxhXPWlrFP2/iuWcO0QW7T8BO/Xaca67FRuOEf60Awbp3zUCstUAfvreFxjpUxgl5et1YFq8zjrqgWzwqaJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5362
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Thursday, September 8, 2022 5:31 PM
> > This mixture of error codes is the basic reason why a new code was
> > used, because none of the existing codes are used with any
> > consistency.
>=20
> btw I saw the policy for -EBUSY is also not consistent in this series.
>=20
> while it's correct to change -EBUSY to -EMEDIUMTYPE for omap, assuming
> that retrying another fresh domain for the said device should work:
>=20
> 	if (omap_domain->dev) {
> -		dev_err(dev, "iommu domain is already attached\n");
> -		ret =3D -EBUSY;
> +		ret =3D -EMEDIUMTYPE;
>  		goto out;
>  	}
>=20
> the change in tegra-gart doesn't sound correct:
>=20
> 	if (gart->active_domain && gart->active_domain !=3D domain) {
> -		ret =3D -EBUSY;
> +		ret =3D -EMEDIUMTYPE;
>=20
> one device cannot be attached to two domains. This fact doesn't change
> no matter how many domains are tried. In concept this check is
> redundant and should have been done by iommu core, but obviously we
> didn't pay attention to what -EBUSY actually represents in this path.
>=20

oops. Above is actually a right retry condition. gart is iommu instead of
device. So in concept retrying gart->active_domain for the device could
work.

So please ignore this comment.
