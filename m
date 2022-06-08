Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C349542965
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 10:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiFHIYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 04:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiFHIXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 04:23:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5D2132773;
        Wed,  8 Jun 2022 00:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654674559; x=1686210559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=koWshflr5lxww9CJOuJ5w2Lu0NHsVVQOH1+w+7bQFkQ=;
  b=n7ujska0lF5bWBC3pGBobvZDzboSiO1W8EhCFqKVMLNWeHw9t1+6VYEM
   1LzLdjFX8VB189VPNu4M7/26BExuczAkzz08bQOlCrx1gCHbw7GrpD5ku
   wXQv6jEOIT61iHOS+ehk+//yHNpImNe78GCpu00A+rjAUOf1hm1JC9cgA
   4Naq+uIYgi6K0XWzfsCsg9sD2frFE0MrJo8iZ6txGp6gY1Jvc/G0AXAIO
   iyhJpiFahbzh3ho+CR7bGAyrdKVjR+wY+pIPgWrWiYnTwyveKzwA2ggTr
   6h6gdIHV8hh1C5g8PBLObMexd9lHItFLvCIx1NcH+U+JwyoPOkFaS1iH8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="256634346"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="256634346"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 00:49:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="907527650"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jun 2022 00:49:12 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 00:49:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 00:49:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 00:49:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG1gqnSlg+WfO0kLD9Rp+1xlJ3xgKf8RcGyDz2roHSjRHkWKj65TX838gUPKOkDulNfzV9Mx1HmN/ZbhZSM+M7hQYXniin1ET+XZBMxrB+PnddPy9VioMqg3Lo+dKs6mfmqDp+4xthI1mACNeGuMTviW140Lx2v/qj2DAT3xml54ZyguGe+lc1TKtrMnX8k9+7kSfleyd4AIozh0YsOcBiuRWrGpSlJDsGpHPPvsasCOEmHydCc+bWLRioLWC/rjtSUP3qGLK/KOrhBg17GLNj0CDqJo9f7sasq5XrXSVk+w/USQ5+8QKXbi3IDBSJsZkpEw1JrS5bzkx+ynt8LUkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyqCzGOFHWnNL7fLwa36rZc3XP0meDqwdNyurxXtqAk=;
 b=mn/xz3iXkl/FZW93VEzBeH8OMXtNFjU+vfqx9/Bhi0HCWL2NtryNo3pqaNZiB33FeInYQHDeOKmW3WkPNc7grJ23dM7Ktt7V1LCeIjC2QMMKdkyiR8LZjvIFGu9ydSzg5vhO8mWMgZbvBhoc4+O0HwxaZfvsh+siG1lRPDWsEYEcWdwdAwqSPlQdyWS2aNGBJVHhGyODywkSiuvj6kuE3f0xln3N2orR42Cv5CAVXB1g3bF0l7yKQQ+kNWymZvfp5PNQCGq9+MsbvBvFp6XkwnP/vVKYF+OwQGqy5hLqyjn+Ye8RmBWB6EJasi5axltaVrxzg6lMBFcmfBFhF51EQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 07:49:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a1cb:c445:9900:65c8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a1cb:c445:9900:65c8%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 07:49:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Index: AQHYeW2V1diiKll3nEi4L5rqPYEtqa1FIcBQ
Date:   Wed, 8 Jun 2022 07:49:10 +0000
Message-ID: <BN9PR11MB52763602BBEEEF580C3B360E8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-2-nicolinc@nvidia.com>
In-Reply-To: <20220606061927.26049-2-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa9b941e-0e9c-4785-e3b6-08da49235fb0
x-ms-traffictypediagnostic: MN2PR11MB4711:EE_
x-microsoft-antispam-prvs: <MN2PR11MB47119B12AB42E6B7873112518CA49@MN2PR11MB4711.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MMsJuG5pTnW9zI9LAdhtSgVYXPe7CjZTMCU+cd+HeEi9cau/PJfjVcY0iMIBhJkOhQRm0TuhWhZOmo6YA18mUHIiLGXkm74CildmGrl6gF/PzSE2rV99pY3qLhrvdhbCXmxspPza1Q9WWmXtHxi7+YOj8QuRFuFJmlx14Hsj++h/hqx07POn2UHrrSp3xMeanVaxq8xE7mt3LXr0ke3255LjkQpn/2QjaMNWElnAmZnZcVbXGxJfB+8KPCY+Y6ygjXPkB3qXvCGSXNUAmEmodZ/0Q3NWCIgBWMnkSVJkpAcDqABy6KtRyKbmW8F1lbEFjLLImeVyrXeBQOZ29wLnLblFyC+ZGCqFZ1psqN+lNgDueZnnD5M3ISAgwjpEDOr8JspBldzEhbVEWjMGQOBdcn1qkeuWTWz/SHqBwY4dtIUDj3Ut8vOojW2TvaqfqiC/0+O0T+bW+BQFUjljCmqYhQpcu6j/fnoS+wXdW55ZTrZF46tsmzxXrnyvVS+j5L/99j3l00Qu0ZIpc8x3Fiv3+zPbCEy0XITs9Gs5nTnAMcySlO2jbw3na3W+FD7H+Af6+/6XNZQJrFEcsXVz3aNxoq5/VLyQivMRWSHppdt0YXBKM3EzcK4OvlbfFa4ZUM9gOlUZdi+W2sa29bn4erylwwAIIbPEZqWhHeGrPfMQREQsGifzKZlEhJ/6VDIhP1zXFbkiyt+iNn7G5pjMk27y/AXyU39kPjX8OZwem7fie4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(9686003)(38100700002)(8676002)(4326008)(5660300002)(7416002)(64756008)(66556008)(76116006)(66446008)(66946007)(66476007)(921005)(82960400001)(7696005)(122000001)(6506007)(110136005)(26005)(38070700005)(7406005)(33656002)(316002)(86362001)(8936002)(186003)(83380400001)(508600001)(55016003)(52536014)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g1IxZr2ZdLtrRN9bZdytRbI5z9k/mliciiksXod/uMlCN39+Ln4q5F7grPIy?=
 =?us-ascii?Q?LhzBpliifVjOs2xusqLQK4DsFKL0UF1tKW/E4y4IwAPY1FLNxJ2dThXOjEtV?=
 =?us-ascii?Q?WHJN8iXunTRTHS1LlKYhAV31B7qI+HS6qF8Rjc0DK3UQjniNlCg0lc62PisD?=
 =?us-ascii?Q?mCc+WVIYhnaedFDP+0xiFC/pNjc61aFryXAV8VNWHtcUcKu6ATlql43wr7vb?=
 =?us-ascii?Q?4RVjdROmk1X6ttQfxuUsVdqFjYStxJX0HiNaaVv6rpexBCYxzce7Zry65wqD?=
 =?us-ascii?Q?BS9aiTYh/y5ieRi9SGNkia0utv9HdRNEq8U4v6apCRFzK0+g5SWHjgN9HRgd?=
 =?us-ascii?Q?dlbF1mATlAXCS8WnURTkkExwJE2weMrnFXuTCdTysJ98Onv8hiq4YegxyUwi?=
 =?us-ascii?Q?AXAII829w4bXH5tyUS675I+ZvoGuIAz3R+NDbg8JU9vyiP6/nf2rGIBWRtfv?=
 =?us-ascii?Q?3e7XQv+KHvGthqsPRjAtDFBtr0eAwpnPCuaOzFcr/5xJpPca0dKrYf8wKjcQ?=
 =?us-ascii?Q?8GJSBjImDRUmqu5EawdnZLP+Akr7nr0OMSVgzF7YERd+NseSJnpYRAwlVBnM?=
 =?us-ascii?Q?cZWcYSxVBJvqvQUrO9WLMyKlWyGLQI1r/gRPQzOUc57y+uYIk3i3gxcJON/V?=
 =?us-ascii?Q?cQhq5zeRvNui4zYI0in6Od7DtFjlkTaZbYc9sGURXjISwDsDA9WjxF5ZxQN9?=
 =?us-ascii?Q?IUa3Ap75KlJaBw4LYPFrxIobJoM4qwJ2OLESnwJWACzL96UIuAbXKVIKN4RO?=
 =?us-ascii?Q?u9a1bmLKiWxfwCch7Bz4LXve4h0JMXz6KqE2pn1o8z4xBDJRujNSFkEfOsMA?=
 =?us-ascii?Q?tmlMPSD3VyqUT1utkRdkNM99KS2YPC4F6BFO37ViFiGtNpAQyO/5QqQMVqOU?=
 =?us-ascii?Q?FeC1/nS19NRQZRQJLMNRgM7zxK3Z+w1D211hKWNWD8i24xYs1Fy1z9yxrejY?=
 =?us-ascii?Q?/NOprlLC45XjmHVwq+3KbSijn59j4E56DZ9VVgi3+cfRi7lLc2EJXo5jsZUG?=
 =?us-ascii?Q?h/m+2+NHa1Hw3NG+vr0wyPlHW2lJvQFqVO8vOy84Uz6vD++CyilGudfjklQn?=
 =?us-ascii?Q?Wg6w/welrg0Z2PbPmrPOA/8EG7pH3wq5m+pIr01uxVJ6qylt5YS5miBzzHO8?=
 =?us-ascii?Q?GMcV5Cr+/kB0JAAweSLUz0zzNJqdLg8CT8JG1UBU3fu34Dd+APpbSpszlZ+S?=
 =?us-ascii?Q?hxF4EICR6U3uY2NmyamsfkgD3Y6bDKv5jLXLS10ImHLWl0EdHF9RwDqvqFao?=
 =?us-ascii?Q?JNEuvikwKsF7gz2iFzrrqboxJ0aR572Z8HVyUic37KHYi9y6EpsVpG9NRn6c?=
 =?us-ascii?Q?kgu1ntijM+guxTjSfW6uv6TEekvkNUfavuRWhrrsKVivneW6YMmpV1sHkwp7?=
 =?us-ascii?Q?aDNnQ3+ORgE2rmYr+r/kdnqrTpDp68sCPKxKv+hPONoX/UTyy/PTbvG/VKdj?=
 =?us-ascii?Q?XEfKFYEGhRwaunF22A9qCQz0lC0QSGYPrChojGPvnglgWBUnmOInXdwD184d?=
 =?us-ascii?Q?ypbW7QsesuLv3Ttm7DvF9YkoVNpAPRY4YggRo5W5Rz3Ewng26onQ0hX+27b6?=
 =?us-ascii?Q?q1k+khxsoqsxCd+Wy5V4bFkYP+ZhkkaA0s3RDbLKGqPA5d5i59LeBtaQVDu3?=
 =?us-ascii?Q?7rloOoRxWAfx9fNQdj9E/mFRx8tgjAOiwsux/uXHqnFRvoX4cXZI3IhbPR1h?=
 =?us-ascii?Q?SAN0r0itsNjWqVv7DdF7tXgpb/H0wamq85nBZ/esl7tlwzKo2poV8STwJJmd?=
 =?us-ascii?Q?Txw9nZWjOQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa9b941e-0e9c-4785-e3b6-08da49235fb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 07:49:10.3989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnJ2W/XToWCXCQ1i9iDjws7TbwWs8uuxbYI5Fx74jrmb/2U8Tj0344YltlSLeOKEnXQ4teYRuZowllAVOF/T/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen
> Sent: Monday, June 6, 2022 2:19 PM
>=20
> Cases like VFIO wish to attach a device to an existing domain that was
> not allocated specifically from the device. This raises a condition
> where the IOMMU driver can fail the domain attach because the domain and
> device are incompatible with each other.
>=20
> This is a soft failure that can be resolved by using a different domain.
>=20
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.
>=20
> VFIO can use this to know attach is a soft failure and it should continue
> searching. Otherwise the attach will be a hard failure and VFIO will
> return the code to userspace.
>=20
> Update all drivers to return EMEDIUMTYPE in their failure paths that are
> related to domain incompatability.

Seems not all drivers are converted, e.g.:

mtk_iommu_v1_attach_device():
	/* Only allow the domain created internally. */
	mtk_mapping =3D data->mapping;
	if (mtk_mapping->domain !=3D domain)
		return 0;
** the current code sounds incorrect which should return an error


s390_iommu_attach_device():
	/* Allow only devices with identical DMA range limits */
	} else if (domain->geometry.aperture_start !=3D zdev->start_dma ||
		domain->geometry.aperture_end !=3D zdev->end_dma) {
		rc =3D -EINVAL;


sprd_iommu_attach_device():
	if (dom->sdev) {
		pr_err("There's already a device attached to this domain.\n");
		return -EINVAL;
	}


gart_iommu_attach_dev():
	if (gart->active_domain && gart->active_domain !=3D domain) {
		ret =3D -EBUSY;


arm_smmu_attach_dev():
	if (!fwspec || fwspec->ops !=3D &arm_smmu_ops) {
		dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
		return -ENXIO;
	}
**probably this check can be covered by next patch which moves bus ops
check into iommu core?

Thanks
Kevin
