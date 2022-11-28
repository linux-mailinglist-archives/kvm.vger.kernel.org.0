Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00B963A2F2
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiK1I1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiK1I1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:27:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0536152
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669624038; x=1701160038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wqIFqRMg3wMT5E3FlhYbEMoeo0ccwNh+1aYmF1qgvQo=;
  b=ATPILI43VtS3DlKj/4/cwu4Yn62wYDxmlUKa8oqKopDZvu6WDKKzaOmL
   vEeI9CuJ5yXC7yOCe4ImAaQxbAfdo4KdN+RWAsoFkttV+rofgde7huxjk
   mIkyuPSPRjuWmB+zkF5K4jBFKUuOCtRCj7/OefYgyKDRTrTI8jcDyWoFX
   LWm8qvGZ13wDawmDWzsBUL+ap6NFkF5RAacQ0nop5ixuureFN8jruDyLx
   01gbKUW41Ex/4O8k9bLmTjHdzXOtSAi1fWHGgvsJrK32vVTFRkWIjamuk
   uidXMx2KDR9IiJpEQ1VIwZya77uyPNcaZGd6V6Y1K9i8xl+T8PfAP8rP3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="379032642"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="379032642"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:27:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="732045360"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="732045360"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2022 00:27:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:27:17 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:27:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:27:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWwjKnYXwvBeR9Y15AiSK3qh82QIaROsZEfJkR6xLsg9kg5f4oerRNLidUo50ZPqn2K+9+/WObrXhrxlWPqHNeGnxA94O4Q3r62p4iEQbDUeHyH3XvKWzRdqjVhn7bsCdYc3hm/0sIqIqojV9qis3P2eESvAUIto2Yo8++1LlySAKg10qw1lgvxGpsPNtvyzqW2tkZJxYlYsfQLhhW+XWe6U6F/Wc5+ZLjWv3q01XH2E1knafcT7rteCFLjZv9KCFi1wgLqMgRvGDl80S16ScLXJU0osG9lZzAMz+bS/DtLYuage2BFtN+pOnJQK8UcqwvxmTqct+RuaGv/N2IORfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqIFqRMg3wMT5E3FlhYbEMoeo0ccwNh+1aYmF1qgvQo=;
 b=aLxcCPW016Uu0a/BsrvGGMrxpm083zQKlDSxGpsXfMZMRD1nHHKU2JUQ2wLZ70zOPOmLHdB0T8GlY1VB3H+E+EKdeBD4yFLgor3qh3iyHX5bau7I7RzjF9xvdsQDbwUzhI7s5hQuZMHm1TNfFDp3CJUFkxClA23Vq6v5Fjxqc2hbs5Zeqs+JvQHPmhz42jC2wf/Q8h+UuOU8CPZr8dD69mSdgkaVSse7Ze4t1V+bf7vGJGbt421TD4Vkql7pCT/l+1u7bu0iL96w7zgM4iO6Qc7Lp4aX/URrOdoLBRsRlY7AWO0kJIv7IuS2QPJYuI4p1f1AKutjY7OcEAsHruzUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 08:27:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:27:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 07/11] vfio: Swap order of
 vfio_device_container_register() and open_device()
Thread-Topic: [RFC v2 07/11] vfio: Swap order of
 vfio_device_container_register() and open_device()
Thread-Index: AQHZAAAeiD3akhgHUUypYmP1AsGW/65UBg1w
Date:   Mon, 28 Nov 2022 08:27:15 +0000
Message-ID: <BN9PR11MB527610A799BEDD4FAD79571A8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-8-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7175:EE_
x-ms-office365-filtering-correlation-id: 3cb6e7f7-33cc-44da-13b8-08dad11a5b0e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GH5q7vnyussouho2k02VTKGKqkHf2RK7qd4QylXHGg3FZM1dBQMfSuefPumREJr28IOAcvhIZ1PnLaJhWS+UafB3dd/eAGJnYCIHUD1zGbah+RrEQzMXvwiMeOWaN+SBsdT/Zj3n16b1mGsXFKMAgEIyNYhThjhFcM9HZVytbM0yRFjUOrojpp2KkvA1e4My9B1yiiY4tXOe6u2WHGNVAJvdzIQqR92h0QH7egMXUuk+77RSHaJpe42773b/EfsjhU5dPozmHpongpIl0mQfHfrAQiMZz2BeVK+n4GcEXzdjXyfxxbHI7cXTBsMxeVq/JaZPryHSwGBdBurGvFJLf7GYcAHlTX06HRS3g3QFkgj1qsvhpt2mEz27IjX99ssOVSnVhhz9YLPEIuXdx9dez6K5vJ4pQBG9glesEyMdbPWxgxKoxcM/9aizIaCueGuxwhpZxBvw6ETtWHHTMqjXb41xlbwLnDPtr4CXHzeWi99F3iksiuxyL0l8603cz8Lv/zX4hmKMmGRVDlG3VAMiOwrhOLrYn78vSMHPqsb2cTcBHUF0gcMpn3Kj8yoz2CUukJNiL+l9EdJVDvhKPyQbwGRADmXKM3bmj7iS4QVfsv+475N/Jjib4epU5UG9/lXQ5DOihuhgma2J/jQnvFwp3/u/ahPmLE0QcYrpWu4716WDW0GfWhsp4YmmlKdG7ye1vVpJXEMN9QZkCame3bHVzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199015)(478600001)(38100700002)(66556008)(2906002)(82960400001)(122000001)(71200400001)(66476007)(38070700005)(76116006)(64756008)(66446008)(5660300002)(8936002)(66946007)(41300700001)(86362001)(110136005)(52536014)(4326008)(8676002)(33656002)(55016003)(54906003)(316002)(83380400001)(4744005)(186003)(7696005)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LlgumqIbwqYNeXePxeGi/p1bGYx0pmgXXoTiN6lc5mIekOaDq06lZnrKR8qR?=
 =?us-ascii?Q?fuaUAQWngWpMOWcN+u9WrTUfUEM4hwpTpmSXvNbFgazAlASuT381Ojbl0Ba3?=
 =?us-ascii?Q?vYlP4D2eX/Pw9OodDSH4LAt9Zwq3hHK7KAY62ReSk6XaZjbBpqYMq9GSFUKF?=
 =?us-ascii?Q?hGmy4xnZqg/aEAlIlNr7nTbWSjncAkyI4KIgJtu+TUZfelV4xikIAec9B2nf?=
 =?us-ascii?Q?nMdPydKbNkK7FW6Jq/5A7RVmhOkF1ItMli8f+FKEERjIfjNzWabgkMUYypEY?=
 =?us-ascii?Q?JDIg+kl5aAlJWmN5m3JFMnNJ5wPq2LXk2114yVynsC60LDtWYgZkNYZ83D3o?=
 =?us-ascii?Q?uDLk+talpDMEP8Yv8dC/r4AhH2DtLVtbo1zfoPVvpC9nOg7Ya2JfCNVkoNBK?=
 =?us-ascii?Q?GIGanfHtdX2RY8pDSKJZpLtJyIi8ifRZVAAqA82cuvpuCCQNg87YW0PYaank?=
 =?us-ascii?Q?uKh0B8yIbn401VnSbgZjM1wW+CBeRrE1a/ctee0khY0u51JNJU+MM9oauE40?=
 =?us-ascii?Q?lzSXEzPYargmsNmPvtxeMKLcUf4dUHTvTQ2Vr6Gr3MfSHi99anv3Tl438adI?=
 =?us-ascii?Q?hJrgL3CfWJ4dl0zfe+5y+3t4KHQOKmJH4HwqoBxfOpd0aZrLDpIdf4lJeA2Y?=
 =?us-ascii?Q?AJ3ExErB9jHTHUMhoO4QSEEaVKwl9x6DeGh40AFaduGvO722HtygJU0a2OKq?=
 =?us-ascii?Q?CTb0vGPq5zemUrFFgUVrT+EztxRXw/OqFsMc3nZxbm/i10UbzTGiDgVwOGKr?=
 =?us-ascii?Q?ndKyvAPxCv5KA7uFIWhiDZGJsGhASroRUKJ3oR/ywKsq9ZWRqBMjuVM9kYC0?=
 =?us-ascii?Q?Okn6H/nPHzhSETdDBHfk6bj5QPsr+3qs+VZabSa88Y9tIL43XAVIaIe0I+MM?=
 =?us-ascii?Q?JXAwRo+gTzH+ViLZXkuBO3Pl/1pfIiIPl+ZtyyTqbY23TKLln3twqgsj8h4K?=
 =?us-ascii?Q?wzBRgcRN2BwoCLruY3wHKmzHH1JVntm71Tgc+HmhpiF0bkwylC4A3RYIeXl3?=
 =?us-ascii?Q?bbPyh0kdu6NrrQEAmmMopqIKxU59Y7oOoTnNjU+gi9XxOVq1qCy/PjxecQrZ?=
 =?us-ascii?Q?HrrOKCPeCysREXcbQPXk+iAoGgFHHy2258TbM3cjfdwL064lUTD0lGtfOMOx?=
 =?us-ascii?Q?Iq0XwU3i6BzwDr3KATpsdKwOI92ROrt3YBgH4x9Rlejm556GvIJNQ/cgn86J?=
 =?us-ascii?Q?+0emCGoyOG/ekykLML0j88yooWCzI5zX3vKzZeBVSvGITd9GFUXsvaosqdI8?=
 =?us-ascii?Q?j1JXG8OkLAj+KUOctNqRIA2jKEKcJRRyEpEN+7FVzgWtnvBEhcgdP+9RWLKo?=
 =?us-ascii?Q?uGz1LyA5WyP86PJg/aWA/0CTTxscZrbLMZyLT9pTn1DzDNVPXmaocagAmjmJ?=
 =?us-ascii?Q?2wL/JW1ctP+AVbYDh6oelOBooZpSg1Hn9idhFEnPvZJtXkeeBq1G0M2EM1UI?=
 =?us-ascii?Q?ETr1Cc0jOVGh1UaAl7H5gtvXwQjmh97P2eaWXMfuaEoSME8YrZNxCkc1OBt8?=
 =?us-ascii?Q?vs2BbnDei4Bdx3svl+uEQiKbsumDJ0P/LGXXWNDIHuS+mBoK6G3UshFPreqn?=
 =?us-ascii?Q?2G0y/fRrArqnyDnuF4uFzDyvg2Qw4WQKXG85zFgR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb6e7f7-33cc-44da-13b8-08dad11a5b0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:27:15.3038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqNgEKFkW9V3iYKFdj1WFELXcmsVXBrwlBXeSg7c9vEMIQioEuZBaHYTAHcyAqCrMfP2CLKA7ZqRlMPxbLecrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> This makes the DMA unmap callback registration to container be consistent
> across the vfio iommufd compat mode and the legacy container mode.
>=20
> In the vfio iommufd compat mode, this registration is done in the
> vfio_iommufd_bind() when creating access which has an unmap callback.
> This
> is prior to calling the open_device() op provided by mdev driver. While,
> in the vfio legacy mode, the registration is done by
> vfio_device_container_register() and it is after open_device(). By swappi=
ng
> the order of vfio_device_container_register() and open_device(), the two
> modes have the consistent order for the DMA unmap callback registration.

let's mark out that existing drivers have been converted to be OK with
this order swap in Jason's series.

>=20
> This also prepares for further splitting group specific code.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
