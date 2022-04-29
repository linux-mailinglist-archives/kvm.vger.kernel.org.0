Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8662F5143B0
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 10:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355414AbiD2IPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 04:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbiD2IPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 04:15:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38F927B10
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 01:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651219940; x=1682755940;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z7m4wZW1VNXYmblYiaj9KStCg8+y0E0n3gp9iC2a1js=;
  b=P9YrZuh9g+Yeh9p4AHerW2Yy/0O2qlZQ+ZdTBNzaKDzn7BM+Lq7UguOQ
   nYxX7nud1ygJHRCOKSF5nCKz1LxgDUS2ZtdC7QGCJbMP3aLTuj0Xb8mmn
   mfZo0C3v5jFZCLk3K8xllCmoWA/ed6z/ZCC38nnPEM/W8iyUg2RTwAJ88
   ulnGQ6qGSTp0QrGDbQUBnZogm2+bidzesq091qEu1yx6pfE+Hqa9V0Azq
   RRRZSLL3zc4SRVxtfrb9u7PmUbtQozgE5GRXe0D13Pem6jm8oZRVEgqzl
   MlAEenycy2Map2G+GEzJlI6DqJXzQ+PXEuWcSardKcbX0EScd7cLG5zEQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="353002817"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="353002817"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 01:12:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="731950928"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2022 01:12:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 01:12:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 01:12:19 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 01:12:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGsOncVldw8jYUgrzqZ5g5u9RvxU1L000wSfDL3v19PILCgi8eJMYEwNxQz6fvW+bpZKePYzPLop1aSDtP15rXPb96ZVBQ0kvDnkoeFD65QRcDcJK5yc2ez7t1rd032CafsdJmsM5cVp/1+sF/9mnOyUVvjHRvyYXUYqA30iY2LFw2h4x/em6CnX7ZGaRMb3mNwG0WG2DcyFOJcU5HpJ0lkMhIIilhX0adsqXhnyx2J4BTlLNovX82ytnh/Nwx78yQIIM97Kn5N876EyT+R6n3IKWe/m+siSuW5cvqcqJ3Q0yIKpWayP34vyGWLsy2+65O9rSVRyYS/9Y0nVhOADsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuXTH5nxjHKmTLB4dZZv5GiM307YbtxtTSsVWpR8d1k=;
 b=g23BJSVRasYoHjM2p5kiG2Xu4CCMKnBOglc8UTUl+wJNvcep+zBS/IbdCIc+E3VzUpqfcOXagzwxU7X4Nyb1Sd7sMJVRBpC/gepouXLnFLnzae6y6+9xq15CoHprq7ytTXjo8HB3Oc6NHqRcycf5IPhajjR5sROLNPe7Wd8uMAQsvuHTM5Phgu0vhxnW6qaQbVNBdINNpWpf24GlhwLtpN9eEulS1TNhJvPM9VgcIA0Pm2z03/6VgKpvTJXk1rNm+etEIhTLdzMNhc5mn/lZS6JKfESkmV07t0IiOF99W/nfziwZgBRd1o1ydt1oVMgoQYs4heZDq8gPMEZcfD+QlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2998.namprd11.prod.outlook.com (2603:10b6:a03:84::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 08:12:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 08:12:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Thread-Topic: [PATCH RFC 03/19] iommufd: Dirty tracking data support
Thread-Index: AQHYW0SEhZD8p3HCAEqpE1YCrbpuv60GikUw
Date:   Fri, 29 Apr 2022 08:12:08 +0000
Message-ID: <BN9PR11MB5276C829C3F744BD4F4932B78CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-4-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-4-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 452c34bd-2e89-4383-90d3-08da29b7f493
x-ms-traffictypediagnostic: BYAPR11MB2998:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB2998B1AC31F373149A39E6548CFC9@BYAPR11MB2998.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HhAC0H9ksGGLYLvWNiBO0weErJ92dFFr040DK/VARZfebHPEKL7j3BQJZ/C+eh748fRuv5Yiyc3X0zeO1yOjyiTaCGgAEkPW61eoWhK9RvVkKjOubTGtPB88Mkz6S5hKbnWkQVZG3bdq/e2HmqPwnD8wamvKlXDAvZ1dQ1kyQFfHxqeifgjsi9Jikd5trFE+Zi5nfaXTHQViyQFwYQ+6yyaF5LWjHUx4I4Zd+ndOm6VhSpSZoFHePlUkGz7hUKx9Zo0LidMA8c9TlPYXcvAwqD6MWmpdvsnLWJjW5Bti+qkJSmISu9FYF8JVSbLk1ocym0eB5hYRi6z2Fct5Qb+xkoXmo9B/BIcGqYE1vxhzrkjMQ5VV/Q3TNO3gtPkqTAQ/jNwRzPSh5Ld/CDAdgjOY9UviJAvFI7HdYequlePubSKOg1Mx1h8uc2etO3tjKbsDidjJk0VbDooU5uQCRYm80FVKwoaMkXoFt0r/yQHE2nmpRA8o/aZZ8/V/EnFRE0uDUQ/6vJzFMqXDlo5sRiFLRfDfBI4a84rpNMuF2BglsPQJht2o7Uvs0q1I1V8Q9ezCD4Q+s1C9FKJH/Y6DG1aL6I1VRBKFrpay97ap0qqyQq28p4Cr/TvHyHeW9dzFmwtkM1+ukhE6ntLFGYwPQnIur/JFyWwBJO4nWDtOE/s2SktuwWf3UyfX093j3f0Aa4zbz9Y8jXRvSAi8rKTdD2iwAblC+JHJ4T2d9Srv77uq+MIJIM2ZqbwruzSYaefI46IS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(86362001)(26005)(66446008)(76116006)(66946007)(8676002)(508600001)(66556008)(6506007)(66476007)(64756008)(4326008)(71200400001)(55016003)(38070700005)(38100700002)(316002)(9686003)(110136005)(122000001)(54906003)(82960400001)(2906002)(7416002)(8936002)(5660300002)(52536014)(33656002)(186003)(21314003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tovp3ivKSgReaxYZK4CkLZ9lYl02LwwJP31dzB/k2FnPMM6MqF26pAu9zP/1?=
 =?us-ascii?Q?G4gio/p3XqXFfD+qFMVDiav8ZOtjRq1mm+rud+TI95nj+UyEsah4EoiY1DNZ?=
 =?us-ascii?Q?00NjjR3Pd/kNA+3HNZ5DEleVWUp0BVIvbBRbxOecRcIfxpU1K5rYFxsXkwxQ?=
 =?us-ascii?Q?D3RuzK6AEre6MbR57jTUVHwkhZ+cK1a/aVcv3IungAeWMH7SZ3/W2uqVrAtl?=
 =?us-ascii?Q?CharsY0fUaMO1whFKRtX55DJ9Gnva1TMwit/YmlA1dwLHweTy1zq6gD8H26f?=
 =?us-ascii?Q?HT8TAywfNEnzcrHaYXrsB1wOValWvAA4YFL4caosJJHjPRte6Y6MKnEs9CLu?=
 =?us-ascii?Q?FGB8xRV7x/u3/uNvSssTv1rqxSLAkdnE18yQT34QdFJJHw1JCovjGRVcU2eb?=
 =?us-ascii?Q?qYiwltdgqN5YlBIXPVy8RZh7ZX/Sod31ltIv2lPkb58b9L2ovsJunbTCfMc7?=
 =?us-ascii?Q?waiRrYHnKh69YRK0c3Wjv+iNHMrpxPtWRHSPTViKDEACRWA9Ny0eKy1U3Ym+?=
 =?us-ascii?Q?Nv7jYSFmo51kKOsPvwAFvGuYtiIypJSD3cxoHTeOchupOBFoLs5c3DUa9bCH?=
 =?us-ascii?Q?+W3ymSUMay5U6qAm+z4qhmMZyC08j4pFAaSji3y5iO0cSPNifzmYSlz6RhVq?=
 =?us-ascii?Q?ifW5cElczN4vU8cLruKpN9UCSXKBpqg6icb5KLXv3sTjpT65TjcMdIJ1CdBc?=
 =?us-ascii?Q?uZFNWE00Uta78iQ6TvwSqHXXWxy+wQgLiMukm75C9JQGH8fGSdA5tNaEkNuw?=
 =?us-ascii?Q?vFCo8pV5q/Q5bwpcHPmpKEOEhFtvX+8D6O3WE+57LdXsiQw1PDlewbzh9fyI?=
 =?us-ascii?Q?ElmROcDOTTmn96NjPndLPGPo6pAtM7lWTAu2u89bMTR40/HDF6A2rnzvDNwR?=
 =?us-ascii?Q?0lXVSb82VJO81TcuqCIfmQ+xAEo1qtr5KipgQf6B01WXP9CxdMVa7rbxVa98?=
 =?us-ascii?Q?qYuzt3K2cnJRXqZ7ZGTiRoLgqdiNzHUFsKBEB+OtRmvCjZSr3Z7sOKufxWM8?=
 =?us-ascii?Q?J2YRPKy6jPmibEHJ9e6BDVgFdDf49ekkJwNgQUmJAoE4bJ2nhGPVZes1Eui7?=
 =?us-ascii?Q?j3lcfyWBy0RPDSOxwgQPENH9aOIxoPN6BzPTg7v2I5AafOTvDYLqhdy0O7k8?=
 =?us-ascii?Q?KhMtveQPxhnoCyjvOJdIe7SKxmCqvsXqPvEPMwAr6FdRa/3mdYjqQUyyYLo9?=
 =?us-ascii?Q?zOWs74KXsyrShUC8lMxHTiRxcti2mF3nnYRLWRb3jLKp7okermDY8VjrZ2d3?=
 =?us-ascii?Q?oZD4I4c0EP07Lj+mkrwmxfSvmkqqJ7PMynpDPa3iSdupOdkqgK+1JTF8JSs4?=
 =?us-ascii?Q?ownsDgZ+3DgSa4/PAsMyVQoDAm3UR+FVUbPtBlctymYMPDRvV5+3FLm4Mvau?=
 =?us-ascii?Q?fDirqUZypFjX+J9UYyBKoLLiSzwvhpTTFu1EnjjdoDdYt7MB7GXAzJl6Mmii?=
 =?us-ascii?Q?Zgkox6F0yn7vWOT7pX3nQn/yIK8MMV00811K4InheNuYNjgKWr4T2LYal8s4?=
 =?us-ascii?Q?7aWfdlLgEWWNt5aN6pPQkvb1JWiUKI2e6fxq4iLg4Vrk3qnDE/l29kn0e6wV?=
 =?us-ascii?Q?zGVl7dWbw+1swF+eLI4UXe01B9jxEgOT1/RR4es9Gz8llrWc/lUOpMQ7uDq7?=
 =?us-ascii?Q?6xsUgygP/zochucyh+NB5MFsnCd/Z/TvGVTGZw5oFrXTvUVf7x68w8yvXhgU?=
 =?us-ascii?Q?4AT1G0s3zTYXIn9e1ts/XfJAEBBaS9Nw1e+bbldcnGL1M5zbW9OMAZ6PhSZk?=
 =?us-ascii?Q?uRMH20IJmw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452c34bd-2e89-4383-90d3-08da29b7f493
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 08:12:08.4930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pve/mSPYsLewtcSgomdQR7VvRJCPKUbVZweavGWKsbIVFCYAMLpdrNr6B5CI+Of4Udtet5B3iM532TuM5+mISg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Friday, April 29, 2022 5:09 AM
[...]
> +
> +static int iommu_read_and_clear_dirty(struct iommu_domain *domain,
> +				      struct iommufd_dirty_data *bitmap)

In a glance this function and all previous helpers doesn't rely on any
iommufd objects except that the new structures are named as
iommufd_xxx.=20

I wonder whether moving all of them to the iommu layer would make
more sense here.

> +{
> +	const struct iommu_domain_ops *ops =3D domain->ops;
> +	struct iommu_iotlb_gather gather;
> +	struct iommufd_dirty_iter iter;
> +	int ret =3D 0;
> +
> +	if (!ops || !ops->read_and_clear_dirty)
> +		return -EOPNOTSUPP;
> +
> +	iommu_dirty_bitmap_init(&iter.dirty, bitmap->iova,
> +				__ffs(bitmap->page_size), &gather);
> +	ret =3D iommufd_dirty_iter_init(&iter, bitmap);
> +	if (ret)
> +		return -ENOMEM;
> +
> +	for (; iommufd_dirty_iter_done(&iter);
> +	     iommufd_dirty_iter_advance(&iter)) {
> +		ret =3D iommufd_dirty_iter_get(&iter);
> +		if (ret)
> +			break;
> +
> +		ret =3D ops->read_and_clear_dirty(domain,
> +			iommufd_dirty_iova(&iter),
> +			iommufd_dirty_iova_length(&iter), &iter.dirty);
> +
> +		iommufd_dirty_iter_put(&iter);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	iommu_iotlb_sync(domain, &gather);
> +	iommufd_dirty_iter_free(&iter);
> +
> +	return ret;
> +}
> +
