Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C895676E25C
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjHCIDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjHCICh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:02:37 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B784EC4;
        Thu,  3 Aug 2023 00:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691049267; x=1722585267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=33UOkSMkM9BomQxxurJheon2QdPZ9/IK7zqKAbWbDF4=;
  b=Vk4Ko77OAgjNirKX+etXScrOxNkre+tI3797kSrUL+1GsrvYYDkYCSL+
   FTxQh6dc4iE2ouZ//upLcHwOeGzxErEYnWP4ghZW/R4fay6Li3QxD4YrX
   +biocdWmZ+jmzbk4D5PCECm0p+wr/SQ6v+/rVeDb7+YtJIVWUVtsMqNd/
   ft2a0gorfw7wMPIlzB5gqc+EGmWxzRyFBYKZoBgZJku+NhhRAx6ZTt6SO
   hjIwVgGQ0bcWvm04gVUlPRX0uc/qDV2YDB/rZ+ApcHLrIw8i22X6Ik6Tx
   gWM3dmXNL+CG/8eBTlHHU8VONV2rzMTDTgD5Iv+bA7kEWwJic5T9buQ6R
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="367256916"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="367256916"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:54:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="843491920"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="843491920"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2023 00:53:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:53:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 00:53:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 00:53:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhtYSTU3Vf1I+c0s/BTFyT6r8ZJwroKa1JfxTfE02DerqhNduqU6WtOoJk9HesWfUZYM6UinkkiinyuDgxkJBW6YDnXULCPnvkKI7webLUyNm0VGkgyIewwlWU3KzB5tafidg9O2FX/RtrG6AVX3dNIXIwKVSBXHKIvCkfd+jyWJ1V+HhltmfyTIIkCxNkG9Gngi0uUs1lXc2cqx249qcd5olIkXetMXOxcW/Y33535kn5NafdTSdCAtlfQ8RUCfO1s1PLKdp8UEaZRv2oADbwxNCLse9oeEg7IyTexxQJrqY7NAKiRQksrv8PPOfAZmWLIon1PlJTcvpYxQpYCnDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKZjrfVh5co5lerj4AzLabSHy6gR0Diex/5DewhwKRE=;
 b=Ltkm09UpzHNIBvHDjAEVfia48VnNA7bDcwDT9Ck9/A1gGRrUOUT2Hi0osLKTg3wugc1pD8+N2Fme5edpRSO+fEEnsO0QmJOx0aipaNfYA3Sgcw2mg7jh2o+/XVNE1PU3DecJ2Iebpdv37h/4xAg4kINwB/uniUDQJ/yjgJCJjd3w+0eCvw1ACQ7RoptHx8+zUwsqBiJaKjg4LxmlKb6loyQxI5ib5EA6c7x0mE7P+2rdNfHEx/qDfCJQaYwtguL2uENrStXRPmXO+KEer/uwmtBwCoaPhlRabBC3KZ1/jGVOc8Tk1YpcOz2wbYxMT8/2Kr5I/zToM3piex05z0ktDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 07:53:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 07:53:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 01/12] iommu: Move iommu fault data to linux/iommu.h
Thread-Topic: [PATCH v2 01/12] iommu: Move iommu fault data to linux/iommu.h
Thread-Index: AQHZwE5Q7SSqgtjPpE6tMKfSHqVBPa/YPliQ
Date:   Thu, 3 Aug 2023 07:53:53 +0000
Message-ID: <BN9PR11MB5276D70741353AEE610D53668C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: c1d1dbec-227a-4993-76ce-08db93f6c837
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tobp3h8qZ7Nm2xnF5wbXMgmgBAhiZXXUIDHmlKCsbsWufZmfr06g0EboOk8LBpyJsvykcgWGdR557FH2fhdeKptq2MyKmLUXXUmI5L3vvtc8V74cFi9W8ikvoRrifnKHUw6YlCaLn9PqKnOfz6N6SY4jhUbga0gYTWfb6YZKxSkGynBYEow2oR1vz+7O8wYKyXhToRmy+KwFU44FspSgkTblV24w5SN8JQGx22YgKUPaaMX5//6SzHxtE8R6loEm/rpnOMr+9aNA2UORRWOlRsjHEahbme7UQ5XHuMMsdxT12KaqEKkF/8AQXjd0m5Z9vCjLKftVOLXNNYqhwzDE2O1sAGTwffenyGbY9geTzQmjP+jucIgrw6cT5+vf+ByUgkcBRhlKdk2gi07LOkH7nQq2PD49YosAIKSK/FXYUf8CGsqW5+QRbCVCenMsNtZoFHCgx9ApM6HEMUQG83TViuJVhiJETsbN4NSzL/fufexNSLts+A5ysZGqWKMzfKfHPYCaGtLpy4LdB/NX+QFWhhnO4tRp3GsMpJi2vOuUfdqVjatYvvgpHr5qAEs3W43YLPNy5gPE4nD4uwetoPDIEq48PuPRc2fCHA9iiQSBuLKQ/g+66ei65qN4o2Q8n9Q/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(38070700005)(86362001)(33656002)(54906003)(478600001)(110136005)(55016003)(38100700002)(82960400001)(122000001)(6506007)(186003)(26005)(83380400001)(8676002)(8936002)(41300700001)(52536014)(9686003)(71200400001)(7696005)(316002)(4744005)(66446008)(66476007)(66556008)(5660300002)(4326008)(7416002)(64756008)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0mGIw3YpStssedKd4xTHdLvg94YswqxByhdMcSP4dtxWeOoweXa0AxMfb0p2?=
 =?us-ascii?Q?Oyj+yqrRnChfyICB76oKBrUu7vrbs93gJSKCL+LVGsqq19i4xzsEaLcbPjgq?=
 =?us-ascii?Q?2NYU9nDI07roVNP0fpQJ/deeegimgR3saTaqD1d/yW634mM/hqEx7/5PqSv6?=
 =?us-ascii?Q?nFxe2vbbAMSefZbQpHAFU7ulAEUjwcr4wMK+zgvDpuEjVR6wgrSy7j1RsLJW?=
 =?us-ascii?Q?hL9tdygLPeVCmetF68eH8YduYJkpQmE2+umNKC3eoZvzMMz28td4I+2Xr5OS?=
 =?us-ascii?Q?PNaI85hYZ2M9r0dmQV59S04uMQELI7dfktVUOs2FJUgsoLvB/xRLgLSSFXWV?=
 =?us-ascii?Q?BqB5PwKivEgg3jIY0SwvI1qYRWGblHKYTrS5E/o9XJUG9iAqX1uWFRX10iIf?=
 =?us-ascii?Q?VXUMSLtUzJF6vvkpYr4wsIWXtYPzR1MJsXd92+JkACbC3ktllkmHo6sWozOP?=
 =?us-ascii?Q?KbM6gs3VJvMzDOBFKdvO/ySBwXpEo2t/83EiavrETb/1qhtlvn6nUVIvaOdI?=
 =?us-ascii?Q?1a6ht9pUt8IK2F0JOTyFzf1s3FvNoShBjOIzdOLQvbWQIfTLTR6ofSElFOtm?=
 =?us-ascii?Q?sQylWsN7U39+V/2Qf9Id6U/8fdK3urwAJWf+oMuQLwvjqOQUGSamtZMe6nrk?=
 =?us-ascii?Q?dEmT7AcRkwgz7B8qgLrH7IQJfIT59Isx+r0Dg7NeInpPSSlzLeL43ZD0jThR?=
 =?us-ascii?Q?zHfadj5KF1R+7hv/YeRUfYDaFJ4N4pTbtrH8KfCpQgeCjTs+rrh6VQbdYlzt?=
 =?us-ascii?Q?vmzmuzWqAwSsVs/WG9LR8VSOj0m04Xo/i4yCAkA6pLXbq0UM/wqdkjIdvuCh?=
 =?us-ascii?Q?8o7pDOvbStT0nFi2HLmT0DIRb3GALGP8+QVxlqAZDUdi5vr8zoNBUlGVNYaM?=
 =?us-ascii?Q?s+rolh7Gh2SYgV2PPwJUlqrzZOIdhiYBeUJF0vm/gz2LjYtX4sFuaP4mixMF?=
 =?us-ascii?Q?K1liz8EvJW7yVXIAaZhFTgmc1J1Pr8cPRiweFlZTZmdNFojAYp3mKoR1mmBx?=
 =?us-ascii?Q?YblJlxlEFc2aSg6H0LsQxgahQD/r8AnFvfIwXa+530GUY3AroaIb4S3f1PPf?=
 =?us-ascii?Q?egO76BvGB/wNHF8ZTq24m2i8hx+Skr1Shut2jFXoo1DpQRyS71Zza1Drtlzt?=
 =?us-ascii?Q?sEq4NSE8zLMOfap9DpkQLNc8F4B0fA/hV1ZgelaND8MLKS+5zciZBqsVTQVO?=
 =?us-ascii?Q?0wSWxtvrEBU3Op/50s/N8ooN7vKXXCAzxaN41AvKXl24T/ifdPqI/avsmGGb?=
 =?us-ascii?Q?Xl0BvEKN5cjNOsErH1j0iK1awqAKE4QQSCe0lEbqRM0f/6upL9hlLzcycSTo?=
 =?us-ascii?Q?ca7JPrfGk60c6iI9I2Dit5diDNGo2d5NQSjT+AI1jYDoX2kcAOdwEQnt62Rl?=
 =?us-ascii?Q?Kbg/TCkO/VfNNjDlA7294bqvPOVxsR9DrqVBlLT/90seYNrzknY01LVhk4+4?=
 =?us-ascii?Q?AtUFzTHSSlfJlAYcVBkjj92QzOirgraCxggJoPcnfC/UwKcZV5QJtzJyq3Yt?=
 =?us-ascii?Q?o4YKCJzEvrHcRif6M6KJV6e/fZGB3uLwmZWgwck1zjyGvjq96vOkTHzWlJ0O?=
 =?us-ascii?Q?2aRYuFILIMIgipeelL3JH6t5rLuXWWHpBJnrWYge?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d1dbec-227a-4993-76ce-08db93f6c837
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 07:53:53.2817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AYYYTKRFjJdF1oba6Tw/sExVUVEgVwE8CJiKDhkqf7GSiG0kjkQkOIP7L7/fUHb1rTn03Tfk0U1DP3qkAk1PUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:48 PM
>=20
> The iommu fault data is currently defined in uapi/linux/iommu.h, but is
> only used inside the iommu subsystem. Move it to linux/iommu.h, where it
> will be more accessible to kernel drivers.
>=20
> With this done, uapi/linux/iommu.h becomes empty and can be removed
> from
> the tree.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
>  include/uapi/linux/iommu.h | 161 -------------------------------------
>  MAINTAINERS                |   1 -
>  3 files changed, 151 insertions(+), 163 deletions(-)
>  delete mode 100644 include/uapi/linux/iommu.h
>=20

put this behind patch2/3 then there are less lines to be moved.
