Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995637AD0C5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjIYGzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjIYGzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:55:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70625FF;
        Sun, 24 Sep 2023 23:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695624907; x=1727160907;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aJscAPDjXDRDcMJbY6/nXJz+5NPypiUmryy3mDk8h/k=;
  b=LvXnVHZ/HZ+Uusu7NbruDTH1s83gAYfS1k6cFJnIp4KyOYCkSs1bAnL6
   r1s6f1814APFk7fn3x/27XbbPf+SRaKD+DMW9Z2XbD2ewjalFbPMlJuDN
   I1FcEqY4bzqF3FiFuR3/FElrXceI6f/1LSKMvzq96swQG2VJ0QedD58hS
   m8cjQriL0SAVfVQGA19p7UcNNhs6Pfte1HC7YkDV30W8fGKb7xeK//gwL
   FRfuJc+SS3HT2Fiil13Zn1uz9fYnUQzWOIs94A/FTkg5xQgMNvCZTCOMP
   OkugbIQrmMsktNIx8bqdYjEgvfXjNttzqK3WZkYxXu5rzF8QHFReNwNJ8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="366239990"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="366239990"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 23:54:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="838483985"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="838483985"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 23:54:57 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 23:54:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 23:54:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 23:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoWq/HVE52X4wRxGEL3ixAwBu3+gCKP4q0FBUj1f51sOE9GKVp5vYDcMDtcZbBtiRDsZjHKPC0QcBtuyHlUGdj1Q5VqvgxSa6sO8CFcF1Fc8vI6eI7zuUe6EUV/1r/jfgfd+hUZx1aTMAU13C76VqOj6FDEyDj18DTLVyz6ODm8M0cd8RxVQUVpW9ZHRKlbPWQGI8SneccvFR0KGKQugX3VSCNzhvikRttK3e+f/OPoh98VYbQoBhcKBAiuy/eBCW70XVmqv1GGRrs/zMkzMXlZqeSvDhbIGaDQwk/fHckZ/AZk/IA0XO4nM9qiM2vUkFs+GgYYxDvyyGezSgGfyEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQjYe2OImGHSw/mfMgPPsFudmFNOfMMquv28heiqJJI=;
 b=Y1/As6H3xe2jft3SOkQr4Ns2p6uNvfFc+hM++0aQmjyplMdME0Val5vCySs3378Gy9PeDvTCdVOafjO3oaOC2SpDPKLbKHtZkYEeMhghYLc8zPwLddn+Goigk9Ba/5MKY7w93dT6N4dIsPFvDg+1c1/SDKey79tDIX7tpMZD1/RZcGlN4dbLaCy1DQ3WhhgjQXf9BQ4Rernzon2DCymyjh6EEyTCOhCaVBHEt2Zopw/iMtpiiT+Z5KJVFL9sxuaurEGUV1J4znhn45S4zdYkxVup0rRc8z2QBo3VNSiFwfXAqAQ1Z3l8N7gSoSqr5iaKvtwOo2ft+Sm302WvMxVG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5556.namprd11.prod.outlook.com (2603:10b6:208:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 25 Sep
 2023 06:54:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 06:54:54 +0000
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
Subject: RE: [PATCH v5 11/12] iommu: Consolidate per-device fault data
 management
Thread-Topic: [PATCH v5 11/12] iommu: Consolidate per-device fault data
 management
Thread-Index: AQHZ5un2ZJ/WReNtbkSLfM+RiDflerArKzKw
Date:   Mon, 25 Sep 2023 06:54:54 +0000
Message-ID: <BN9PR11MB52766E5569D115A4762AE9B68CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-12-baolu.lu@linux.intel.com>
In-Reply-To: <20230914085638.17307-12-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5556:EE_
x-ms-office365-filtering-correlation-id: ed3001ec-1534-4839-86cc-08dbbd9452bb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3uJWidtfpEKHJd/V8FTQfMowYwL18UY6EqLMUvrsW+x9OdcykCFQ9jOH7xGYawlH4fkq5KTZrB3wH1QFeuOQn6W2Kf8zwvsZEJq57747RIiLruQWk9qZZfebzVojQuXzjNlMTHtHkl2ycNHLXiBsSVpjJmQ8ZYPmo91og6rcJnP/BVrz1BDxsSjD9CO/aO1fNvjhqZXha/Kvr6N8O7/FQKostRvrXRkfVHI2+3189BKlCnkUEVADUz/8SqYS16OJHXJAT6jyzSk44bb1RJLGFJnq+ZvPoizZgt25Eov58CwMiqZ2AY5JWDla74xTcV78+yyA4KUGlkJm0NwnYQEiFW3OSK5/PXdObwJDX5771L9WvDH6oRCFaRC1j55kA3th5xANpn9Kqtfo6cHikemWmVd3+4OfVqMtGdrssvky5H6ONraY4qMahLQrUcxg2D2E82RQegOOJ7cU7ZQeTe0McO4xh9g8rTT0WJZIAMU2bvniqtAtJ8n92R02cm1UH6iJhgTsnGv4VOCJjgTwYHpH6eCeI9+QKt/4HlS1m9VGlYCvJadd4kA8NJYUjWZfc+8mddhqgntjtxi+Vc7NRYpxtgtwY6ATcq3btabtntGNfghrPWF+A5cMR8WUv0z/KBW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(9686003)(7696005)(6506007)(71200400001)(83380400001)(82960400001)(122000001)(33656002)(86362001)(38100700002)(38070700005)(26005)(55016003)(4744005)(52536014)(2906002)(110136005)(8936002)(8676002)(4326008)(41300700001)(7416002)(66556008)(66446008)(64756008)(54906003)(66946007)(76116006)(316002)(66476007)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3jGjY/MpWv39iA0jz5D2c7Xsh1/ATOUKwsswSVlvZHBpx3KYd2SklJzlJ1ow?=
 =?us-ascii?Q?OhFq8tMtMp4RAn06bg5pWMLlQ4ZFh+BZGFqXdSW03YkxGMDeVt8hy9LWU6A/?=
 =?us-ascii?Q?zc/3cpS5SCL+61UzdRwx+hpHYirevXrs+VgzQUjX45n0w4/iFg+9RnDf5B+C?=
 =?us-ascii?Q?1J4k5s3D0X9caMqjjtrzdz6HwphdO4izRlwKHUI3V+kNez3asZnS0uW70iV3?=
 =?us-ascii?Q?UBgdRRj7j0Hp1OGZVzJUv96ajlijJn2kWxROdmTGFG3IBEHu1QXnJgZDzjtH?=
 =?us-ascii?Q?0ScFMumf5mFGA/NIEiTGn2sl+QfqESvjtgTKNRI0Pkb87hytUsP4De0c36un?=
 =?us-ascii?Q?hSgggz3niuk2XymrBMOT6+VhlUYxQ3qVl3T7YQ1Y1lEx/CtzgR+IwLaW34l1?=
 =?us-ascii?Q?57p9n3Cv68RQQMVvpwSX1FtMrkG25ynWF7mtIGOT6xrPhqOFp4XRHft+u2ND?=
 =?us-ascii?Q?ycL5Lxx7Fm4awyoG4KsbnyOEnSeFD0PRo4OerMPklmswG210lZiIF31W+lR/?=
 =?us-ascii?Q?Yco4MVM0rSBpsNlnpJeeUbC5jcvoGHCgfizHqy08jZEshWVLXqGCGSE2uGc5?=
 =?us-ascii?Q?oK8k3TzRlImo9NKV0v1tnBgjvBL+3pnfS9iuX6VQd5iwuF8AK/KJKGcLi8vG?=
 =?us-ascii?Q?+fWUkYWSWNjIIWRUKAl/659HJTKoRhgcTSrCtPiiS3Uxb+edLa3W6ddf4H9b?=
 =?us-ascii?Q?GYK3rvzssIucjBNTWp48GiLOLDWV0SqwteZTlT0vtU9jm8tr0IvfQWYU3jWJ?=
 =?us-ascii?Q?xmRox6jm85+PAAHa5uXb2DLTvPNgjA+k4C0DYX6bX+sNoNIX7ubyXXxcGs3p?=
 =?us-ascii?Q?+fE69kYg/5ISEkSMjS/ZFzW/kr2O0H7LQhrU5/s+ifnVrqbDp5v92I8NCfeQ?=
 =?us-ascii?Q?Hy/2rJQEkrDshZQwXNPccSTUAg5rhL7dohyVGDaTpQRvX644dMq6dvXAJqVW?=
 =?us-ascii?Q?nUzx3dplRswTe47bpqe9kAXW4hQQTcs16d28J6h7X33vgaXL/HMDKQLFkd9G?=
 =?us-ascii?Q?QRMlcCk/Hq21/Zqu0EuLh/14XxIToEOey7pU0elyKJq56e408H5eBKqL+ztk?=
 =?us-ascii?Q?h+XWJ0mY1UZUGvd9MneWF9VOnXLYnPwD+XL/60aLm3lim8Q1E5MrXp4fs5Ax?=
 =?us-ascii?Q?bPRKFx73W6rLHtsadwxxZfXd8y/M5sd82m7qLqdjkKZOOQaOLOw0on4PBBoR?=
 =?us-ascii?Q?FM2hinVhQLcGOusSv/GqcDHy9mbrvQEWP1s8ZiwRBNyzvDvolbyMV+foNhbK?=
 =?us-ascii?Q?YKab7K9fykCzFp7HXQMkiKEl7AVNAsIihL5Vvh/rS5SIvixQfc9hE6rtU3bo?=
 =?us-ascii?Q?XsAK//0OLpUVlZCLkVqBiqbHPpREAla3GXaeIgGL92hdlWhH/+BQ+Cmqul/F?=
 =?us-ascii?Q?Tc0KBwlagZKxRxjC1bpoWoaht0onUJVhdw76ojumr9NZ85p8VfNwiCmbkXGC?=
 =?us-ascii?Q?bTqcJSWNj1jlk4TPn4/O5hnqEn3NW5oPxHfs67ArrsMYQcPUBhWle31TP16S?=
 =?us-ascii?Q?0xPXIuQjwv6e23WVqRUdbESN6eBP5s03dxOVj0UbaF9ctaxDmv/hhvUcDHWm?=
 =?us-ascii?Q?zAHxH93Hnsyz91LLXcKBU8+JTUtKG11jN5MMfbS+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3001ec-1534-4839-86cc-08dbbd9452bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 06:54:54.3879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z+B3R5r1ts0MCil1sc68YEKE2XO/K2a5b5lkvTWcq/2ON9Pf/0ABu8cGaCLdGDS7QkE84+6RBGfxAf6vWFOgyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 14, 2023 4:57 PM
>=20
> +
> +/* Caller must hold a reference of the fault parameter. */
> +static void iopf_put_dev_fault_param(struct iommu_fault_param
> *fault_param)
> +{
> +	struct device *dev =3D fault_param->dev;
> +	struct dev_iommu *param =3D dev->iommu;
> +
> +	mutex_lock(&param->lock);
> +	if (WARN_ON(fault_param->users <=3D 0 ||
> +		    fault_param !=3D param->fault_param)) {
> +		mutex_unlock(&param->lock);
> +		return;
> +	}
> +
> +	if (--fault_param->users =3D=3D 0) {
> +		param->fault_param =3D NULL;
> +		kfree(fault_param);
> +		put_device(dev);
> +	}

this could be a helper to be shared with iopf_queue_remove_device().

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
