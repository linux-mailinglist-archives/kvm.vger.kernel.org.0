Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3461C542AE2
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbiFHJKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiFHJJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:09:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34790FCEDB;
        Wed,  8 Jun 2022 01:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654676887; x=1686212887;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=edpY6QrNA7POrXPYM4XjR5yEZ3t9625HngY1VPnspqM=;
  b=KVxj9EnVR50s4GHLqv6vnph4BYWJKxZhISFNVTSbbyoeidc7PhwDZfgL
   2d6LAcbm0z1yeGRNAv7poa374TXMBuxsuDiVPJCVJjgFLplU8mPeqqSJE
   vm2NaDxoYQHEmfhYkOaxFcSIR4cLwJliUCXgD7PD+pp9lkwHI7jkZIKCr
   O1Bc+Dipp7RPwbvvG8X7zuDxmsHlJ3a4Fe0nQKrzoHM6uS8uZpcUZ+Lu0
   7xd3WH/i9kRFz7BPsuhor2qwTtrCwI9oScvXXrcT+ewdrPCrCNkHsL6Fe
   NGf8rvQlflcZNkItmGqmXkSUDVdh6+IBDOGr8/rc/Ub+D2ximkrgRAXPY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302170660"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="302170660"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:28:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="683206681"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2022 01:28:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 01:28:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 01:28:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 01:28:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irVU1uWnTzalY9lbZtcV8TxW/uvX4hlsy9AtL3cdnMmh3eqfo4KWKu6d/mHF1FgznmSIN5UkmHShiYpOKf9pb0JIPq4M4nqzlOvyMnldNKu+nu6+NcwjkrElpJOKpASk+og7XnoMjr6RzF5Y6Ft04/rvPVpQdNOCSUsuZ0qLuvbzze4cnOON0+lu/WNhXQc41mQDhMF+DXoqo/9ByH0gRjf3HhYVA95LCPfl9moCqvbRCYSATgWcKRTKtcxv+Dqan8jDWNrnm288kYhiXH1TTBG4kL0aC1zgpqX4knIZkpHiYEv+NnCBWxRISIFL2GqecKhX2Ra/k6p77R7mPRF2xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9e9vJ7ASc8XDPYe/+0nT68a0lyHt1Ikivd1xar+D6E=;
 b=UeVQCJmF0fjXN2x/NRCv5uucRx+o7rVBjay4Da4uLsuvHwOA4GWBcvBjzoOK/26KB9dk7SWNMle0TYJuC5GCIjnSyTPnEHcICFbID2K6/04vIm5BA+j+LUHOKKVz8/ClBpfEnTwJw3KWAPurZ61Wyqbco3jN3nVxnYbNY8of4NHgA7uTfDLXKK2gfDRB1qKM2bhSFpQxAPJNsZhh4siatSu6BRY79VAqf6vk408xU3Y/Pc8gwRC0m0o3pDa3XqBl+/1s3GAEXvbHw05KfyqFM/BT+5Lqc1Nj5oC+cwrmN6w7m/AebVVxOSfasnWASgJyE8qXD42rfKP/5KZv3e0Ffg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.19; Wed, 8 Jun 2022 08:28:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a1cb:c445:9900:65c8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a1cb:c445:9900:65c8%7]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 08:28:03 +0000
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
Subject: RE: [PATCH 3/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Thread-Topic: [PATCH 3/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Thread-Index: AQHYeW2KrRlTv4MQ5UeMm5INXClL961FJamw
Date:   Wed, 8 Jun 2022 08:28:03 +0000
Message-ID: <BN9PR11MB5276DC98E75B1906A76F7ADC8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-4-nicolinc@nvidia.com>
In-Reply-To: <20220606061927.26049-4-nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 304c158f-3799-4c83-f0ca-08da4928ce7a
x-ms-traffictypediagnostic: DM4PR11MB6214:EE_
x-microsoft-antispam-prvs: <DM4PR11MB621401B86659048BDEAE5F108CA49@DM4PR11MB6214.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4767M/OXtTUkC4mUGwfIsxrJJyj+ZyzDUtCJntI1j0sz0ai8zorC6aLGV1JeiBwTPxGOwIRt10mT4AH5z33ZLzk1xj1ifVwybfZtUI13COamvrQj3W9sz9eEtPKwOJJd0erTZmioYlkFQiEUIUU/feWYYmhpfQnK9LflVLRifF+4Ko/drQxH+JHym3gEhxSEz7uy1iv5960CvtgbOQ0qxCYzVV3IC/8A8aCwmEercctBP0tPcHouLuH4JxR1oDjExg9fdCi5m0GagCVcdYxL4WpOlIbZXB8R2G3YlOGJfqxV9JdD2FWFSYMOR6rSTuW8Zbpd6M+DXwtYkkxNvJuYIJbaaT77VrFuLetWuapef7VYHFCZ0wfLzzki7YrbWSLhYXaiq8F8FzUz0mxtBZFVwSlBMKB6bw317XVmJQH+84XWGQkKbGt1GNkFaOqbZ8jTH1qVTsIqnPkgZYQtN4ILePjn78zQYAVdmlPjoj+AmCtOTh6BEjGU8gA4qZE/GeoBqxvi09Oy8St5OIrhGWpsQXrNu6ERd0Wgdx7S4Nt3xqpuqR8u2wv6kLzqdBJ8zbkTzWK59ppDLdEFEihGWmf1BKHQmMjhM8vkcGoAstw4cfDDblIxlOsmjYLnvrVKffiHoSCxlnippeirRHuPbRpi/jsif9UmmAi0hBfTzfkTeJk3Z8IGt78tLQmxvgJn1UnQG5Y619WUFq/egRi8dXWKjXSRI3Iikh/1bISlrEFr6dLix87mYTCq+p/8cLJkDhcAHOyE5Mlhit3SYdcmkxgJ3dPemfXbXcP3iR7CcDDjrtv9WXKcN/wXj2RTMCjQzSuu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(921005)(8936002)(4326008)(8676002)(316002)(7406005)(5660300002)(122000001)(38070700005)(82960400001)(66476007)(66556008)(76116006)(66946007)(64756008)(66446008)(83380400001)(33656002)(38100700002)(55016003)(86362001)(52536014)(7416002)(508600001)(966005)(110136005)(54906003)(71200400001)(26005)(6506007)(7696005)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BDnqsGTgkeO6s34/C4LziBFtT9HApcI4GvLdNKSmBTWIxnaSYEge+TVnvVQR?=
 =?us-ascii?Q?fRSBHcpUSQizuD9xIWkRkho8EzQd5ceZsqozRHH+2nCiaB7k8my7XBB32YIW?=
 =?us-ascii?Q?SAe9yHxYzmQeEyaXXcPO9g7yIpUITtaF7a5t155GBX9kTRP83599l3YqznIz?=
 =?us-ascii?Q?NIoRKH1r7YCDaCFAbYvvkOcFzzib+bdLExZMhGmAW9W55CzJyZE/GGkqLK46?=
 =?us-ascii?Q?mBLGtEFvkd32Er7zwCAznp/F9BEi+pO2St3w31DJnCJleG5TprSxkkFkn2aa?=
 =?us-ascii?Q?e9IyoAQjrnVqhwXYqoOPvohdiylL3LKZvXXtOcptgbGvYbQlzsSQDNUpdIR1?=
 =?us-ascii?Q?KsYBWB4KMQNN3/eGVki/ei/+eAK4bGvzmnemQD+Mcu9Hgs5muVcRdra9jOmK?=
 =?us-ascii?Q?Liy5N8q6PWIBj/6D+sR0KdHCR/Orpn97OebH3f5oBxLw8gdTezzAzK7Sj1YP?=
 =?us-ascii?Q?I5o8jJGW9aU2DyNeuHhWT8jHpBQ1Cfb/QRjThJzxYtD8M5SD6K/yCMXMC0PW?=
 =?us-ascii?Q?k5UbS3b8+nZnTDYt5RSlH5oMnOIyQCObjFdlaE1adCstgt6vqnv1VbOjFHBQ?=
 =?us-ascii?Q?IrdO05G2gYcN/R1DGEY87fvjo6XZliFACZXhKM7GHWJHX4cnCGlIkxHO3KVc?=
 =?us-ascii?Q?V/gpWMZ3Sdc4Gx0wTezxdeJmUGt/gT3QNam55rvESWMo03V8EJVtewYFZkCJ?=
 =?us-ascii?Q?9n798/kICrSsTxcOI8xsHY1nnic5Li1+wSxmRoHwQX7dGvSit9BGQWvjfz6Z?=
 =?us-ascii?Q?nCZIoGz9Kj/SLSztIrcuMGjUv1CbGPGLpd2KAffnTPp0RhiliS/MYNzX4UYN?=
 =?us-ascii?Q?3znSYYdBxqKUVWh0uks38yBL4upbbwTu8z0iI2jcxLJjsN0ReBBZpxYfne9P?=
 =?us-ascii?Q?T3MiCqYspX1uXYm5+P2E7o4TIObBrU7guNFiGxJJAUXWf1EDChLRrg5yqici?=
 =?us-ascii?Q?R5KhMD0Jz52EXGkRFfHoBDjAmPLUCsp8MsmYXg6RhPFl5tnz7UcTvvCoFc+y?=
 =?us-ascii?Q?qKvRqK93KwVGRbLuOTBzQnNgDfIRXjGiEP2d876UU11LA8TB4eky/wW2igJC?=
 =?us-ascii?Q?7Qv2ChNpDsAqpQv7T0zFj2knI+HFyDID8oB0A9S3kQHsJF4G2rYfd6PyYjyh?=
 =?us-ascii?Q?0tuam6R6VCZWpDmVMbXX2QVt5v1+TawpBZ5uZo//LWKGXypG87hnVkRG3hw4?=
 =?us-ascii?Q?evd4hIVAPDgzI2N70JbpbDfUz8quUPh75Jx0MBRtWz5I0C5zL0EPHl6S5soQ?=
 =?us-ascii?Q?5M3uwu9w45x11b/yfNMT5FReMctCo4pf9ryPp5vTUrTC/XWP/hBoqSTWCQ2l?=
 =?us-ascii?Q?erPNJHdtGfufukvEkIZLygksMh9dA9vvUrZi23NIg5hCayBR7KId291gvjIi?=
 =?us-ascii?Q?uZ3T1J4F8HuQbNA1qeyNBQgHI0KH87O1H0BOsqD0A7h14Uomqx78OFfmaejk?=
 =?us-ascii?Q?I5fceMYEv82HY6CQbT4pT/uXIn5ubPLfX4plCzPfdwETiXLhKT/E2vcHAbyG?=
 =?us-ascii?Q?u46xL5UlPyiHw/2u87mL3FI5cEzdmNu5gWeTDasNTHgLaWP9FjrkQc0X3g80?=
 =?us-ascii?Q?VyE/L7injXeJ6GcPuiGFF5moVrKcoBIEwS8vufam0jX92ep/lr0lqA5B6EaE?=
 =?us-ascii?Q?vuC9dzf+JlB4Ge/724bzprBKWs4gm7jQS2zZEN9GNleoJVnWoLGduucn48Wy?=
 =?us-ascii?Q?718Azio41FPgy+YPyHWPGbcag7zXzybION7eAbds2+x1sJAyVaxoHIBIscxQ?=
 =?us-ascii?Q?ZpqmSve5kw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 304c158f-3799-4c83-f0ca-08da4928ce7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 08:28:03.7717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K+7FcNwRkTytkTriwYGv5gQmcq1faqMeXFpzJZp0AZVr0fSouE6HLHm0Tei9pq68XQgCDsSxUOoZix9Jd69W3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
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

> From: Nicolin Chen
> Sent: Monday, June 6, 2022 2:19 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> The KVM mechanism for controlling wbinvd is only triggered during
> kvm_vfio_group_add(), meaning it is a one-shot test done once the devices
> are setup.

It's not one-shot. kvm_vfio_update_coherency() is called in both
group_add() and group_del(). Then the coherency property is
checked dynamically in wbinvd emulation:

kvm_emulate_wbinvd()
  kvm_emulate_wbinvd_noskip()
    need_emulate_wbinvd()
      kvm_arch_has_noncoherent_dma()

It's also checked when a vcpu is scheduled to a new cpu for
tracking dirty cpus which requires cache flush when emulating
wbinvd on that vcpu. See kvm_arch_vcpu_load().

	/* Address WBINVD may be executed by guest */
	if (need_emulate_wbinvd(vcpu)) {
		if (static_call(kvm_x86_has_wbinvd_exit)())
			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);

In addition, it's also checked when deciding the effective memory
type of EPT entry. See vmx_get_mt_mask().

	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

But I doubt above can work reliably when the property is changed
in the fly given above paths are triggered at different points. The
guest may end up in a mixed state where inconsistent coherency=20
is assumed in different emulation paths.

and In reality I don't think such niche scenario is even tested=20
given the only device imposing such trick is integrated Intel GPU
which iiuc no one would try to hotplug/hot-remove it to/from
a guest.

given that I'm fine with the change in this patch. Even more probably
we really want an explicit one-shot model so KVM can lock down
the property once it starts to consume it then further adding a new
group which would change the coherency is explicitly rejected and
removing an existing group leaves it intact.

>=20
> So, there is no value in trying to push a device that could do enforced
> cache coherency to a dedicated domain vs re-using an existing domain sinc=
e

"an existing domain (even if it doesn't enforce coherency)", otherwise if
it's already compatible there is no question here.

> KVM won't be able to take advantage of it. This just wastes domain memory=
.
>=20
> Simplify this code and eliminate the test. This removes the only logic
> that needed to have a dummy domain attached prior to searching for a
> matching domain and simplifies the next patches.
>=20
> If someday we want to try and optimize this further the better approach i=
s
> to update the Intel driver so that enforce_cache_coherency() can work on =
a
> domain that already has IOPTEs and then call the enforce_cache_coherency(=
)
> after detaching a device from a domain to upgrade the whole domain to
> enforced cache coherency mode.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e357..f4e3b423a453 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2285,9 +2285,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  	 * testing if they're on the same bus_type.
>  	 */
>  	list_for_each_entry(d, &iommu->domain_list, next) {
> -		if (d->domain->ops =3D=3D domain->domain->ops &&
> -		    d->enforce_cache_coherency =3D=3D
> -			    domain->enforce_cache_coherency) {
> +		if (d->domain->ops =3D=3D domain->domain->ops) {
>  			iommu_detach_group(domain->domain, group-
> >iommu_group);
>  			if (!iommu_attach_group(d->domain,
>  						group->iommu_group)) {
> --
> 2.17.1
>=20
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
