Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625CD674D92
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 08:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjATHC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 02:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjATHCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 02:02:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E8811659
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 23:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674198145; x=1705734145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j9Fgib+wkhIQgNCU/Ohw+/xlK7ENMbRrB5tQbHIV9Hk=;
  b=GxrWSBOBlbXn052XmfeKqpQZzMsN2a6NXD4nnd+AzRmiNZ+xI+LcsVkj
   irSe222lv2DWY8vz9MDub9YwfvYVaONaToC3CiLFV93vYfrAzE0E420q5
   A/+YT2oNRtDFsaZB/PWIMcu9KOlUrWZZO6fI+Ms2Y7voDfwk1Kju4LXC9
   OOLB2gpY2hkX7EnT3xT/2qPUWWAmzyuaspFY/5C9GziOr3g7ggTBFC/xB
   CShEBOW8nuIQW5fS+GeWMG8Pbj/LTGIU9GksqIgERhgnV19Ko8rZsnWAU
   whq3jRvIlFOBpZiedUOsRxucjw7EgjJfUDQjFJLXnDEcgH0gAH1HEmMVk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="411750993"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="411750993"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 23:02:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="784419426"
X-IronPort-AV: E=Sophos;i="5.97,231,1669104000"; 
   d="scan'208";a="784419426"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 19 Jan 2023 23:02:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 23:02:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 23:02:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 23:02:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIu51p6Z3R/UktJbuIPZArl9zvv7LX/XTsogdbL3u4n2gbSkdEa2AGCNMACtnZMaK7nYh6DzT6pMC7omix7QvCMJTO5VG9ijghihP0Qk1LGW42mOmf1B4kBbFQr50x4MzeEYdfQcdSRZ5N+fsHkfrGM4hErNk4krK1rdxtV6Vy4QY6GOBsQTrfRw0oxzs54FoDM5JqBI1nBArJf7++7O1hb4hQYjl0LZkXQOliZ+WX4hBu06uz4ZRzhoPBN1t14EgqQ5ySeF9BzJ7Ujk/QyPVtiY18rVHNfNLtFukpeudlwVuLvmTOuFmKG4tOu77NIfevfplSxqT1rlMck/OjMeTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5N5K71dw2wTL/p5LkpD90/ftfbP+N0S2e8qh7y5cy/8=;
 b=RtUMkLWtAt73Mv767gXwIm3RtObn2223J75K/hcG5fDmPLhpiJUsXHcxm3o4RiouioLk47ztCg2kItrrn0Bp87lELnu7nwU84DN6A+1PW675JFgnhyENB365o2Aoh8RSik3fLS5AhKv7NhKt8p7pM5R1jRgbq423h4o98WvDdBBLYbJxn+d8iTI/OjO0HQn5S2iTf38H2bdOniHqT2xBMvJP1dLYDioVIwWYHszA8RbjL9rUVGvr48VrdxQmI7LOxy/VYirFFSqJpK3AeMgxhILu2L7rgIC7i/A+sOH0T+EbmqrpD9MqPc4DwpdhYkG0qRfGQnHHyu8zqExsCDTbGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4879.namprd11.prod.outlook.com (2603:10b6:a03:2da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 07:02:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 07:02:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH] iommufd: Add two missing structures in ucmd_buffer
Thread-Topic: [PATCH] iommufd: Add two missing structures in ucmd_buffer
Thread-Index: AQHZLJQpB9gO5o1irUarESJEX6UXga6m4IDw
Date:   Fri, 20 Jan 2023 07:02:12 +0000
Message-ID: <BN9PR11MB52764C457BF19D3184A406F78CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230120055757.67879-1-yi.l.liu@intel.com>
In-Reply-To: <20230120055757.67879-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4879:EE_
x-ms-office365-filtering-correlation-id: 154456d8-bcc0-44d4-9cac-08dafab441b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NcBsKIBLouyQI2Jh4m7xW8gilVn/Pu9vR8ys+a0e9Z/ZwHA3lAvivfna8/9NS1QCzpNdm6Ezma+ehwmfFdZRmnmFmPdtfVoz5TDbjYzWvk+/44F4/5Fqo88VdCg3C2gjmM/npGrgRJkX6Jt/QxE1k30MG/jKn0aWQm1L21lCooee/xuQEqOSyMLaG/mVluel89fUS2eqC0UR4pIHR9WxthzT2Q1jVRDjlUu8Zrec8BOvM5Gfkft8YyW/EK5Sw7l11Dq3kvpgbYkgm7LLM7lU+xNrgjaKJkVIrrk0ABaobMjT8iivBt6zkJDNcSYzBE8c2nvYfHklj0kKyYawLAlYPqkFVbpOsecR7mnmHEf1rO/CgLXP8taaNN1L8QvaKLbn7xnxW7OO1UY0xIfhBC+z8AHdQcvkgzDp4iRedsJPhITk7tF2KVPuIobc5WYSL3uwSvZV18yBCVYH78VHIt0LB0/ZrbP7Lwu8y0FTMrRT+B0vfovTC96jW3u50HXmcq/AOjWBS6Rpw3tOcZO8Fvew+gZu0ig+iQyzEkZ/rDmC/Iv6vOLUGSosS7cCvJscq41G5/6y3fGxl3TBf0VlSGT4W7DdFH3iaSfEZh/g12DFGpzky4BmKR41U/+r2zbsi/aEgVBLjO/IGFh5XRiMPD7QQ4NcGpHVuECMpFn5noRg3x0jF2TSi98E2o2DKiL46hM9vl1UAWZb+UG7jAHgQmpQew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199015)(6506007)(33656002)(55016003)(478600001)(54906003)(7696005)(71200400001)(110136005)(4326008)(66946007)(66556008)(66476007)(76116006)(8676002)(316002)(186003)(26005)(9686003)(5660300002)(8936002)(52536014)(41300700001)(2906002)(86362001)(64756008)(66446008)(38100700002)(82960400001)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZSAKVDTnzdJX4qK6KBirMRb8ECysvCUHHg6hjDMVy0a1j8alSiSCdCDVldWP?=
 =?us-ascii?Q?tY0SzQ4MpgaMS+DblBLnV3avijoPqfRBUCKxVLbYWeN8yPXIOYiCrSfNQexz?=
 =?us-ascii?Q?hc7hjZ+YaS+RgkXNCEK1E1RkDp+KzU8qhYBL8oOA/7DJcII4t6VUK0hlXdjq?=
 =?us-ascii?Q?I4H8N7o/zrVvf05QjQIeymEINbim5lfjPhZQDTDhoZ+Z5YE9885wMkcsuxnt?=
 =?us-ascii?Q?C/4rE56AmH2P11NFR3mTMl89oxthNhcJF6Vmqxvj2nlN7G4E69720Ar8Ezyw?=
 =?us-ascii?Q?tbQY8ELDC/LHA34BUzHIdflzDLx3jTEMtO2S7BLf9l8YS6DZIdUfK82hKkew?=
 =?us-ascii?Q?cmUITQJMcSLh2zATzYqYylo7ZzwV8EBdmJ6Sj6x9fLf9gDWZDc/BBJ7HAYm1?=
 =?us-ascii?Q?Gh5uBKw5Li2ODOgcTMtUFrWyHZ9B3nzRcWMII+IslzV0Yv5svhQLkdZSoT69?=
 =?us-ascii?Q?94A8y7/0NFBVtxodtZUoigi+paBsNEDxy7eOwWCFJL5QePJ8wWpX/q6VAlfm?=
 =?us-ascii?Q?k8tdHFB1MbJAuKxoIfXZL7wsTnKazuE5E3Nzu/7/YNAvPY9DMyTv5HRab2SU?=
 =?us-ascii?Q?kbHHsC5BrW3l9DYxBlAGFvYkj7QnV3aopnZDwoVgr0bOE+Bco8nsiAtSP1j/?=
 =?us-ascii?Q?rPOeXJJEQ5JPNbL4FqkGEiZiTpz1gQOX4kUzMXl8w+fxuVFt86hyDtpmMR21?=
 =?us-ascii?Q?PgeKK6TpAUXUiPFAGwIPBJrIV2zou+ZwR5L6wJCUqeC1Szj3Wy/9QamPTTX4?=
 =?us-ascii?Q?MKcs5YpjS5YQTEXSjnty8Vj6hXytsUuHpkcKFSrJv3iXA4QJsvyz9LRPrinY?=
 =?us-ascii?Q?72nDraEzwnA6+flUIuddf80DYIuifDnLY39yfht1eXfkNaK1rspPuK7jlREl?=
 =?us-ascii?Q?PNtA0CTPXW1YPDESLjMPKquaw1kLj/uCOZDD9NBRvhsIdgnSYCbDZQug68HI?=
 =?us-ascii?Q?XIf3q6rgEZbu00wlJq5M0VUJKkgWSLyrHO8rnhzOHvleJ215QTgpvcKJT/oe?=
 =?us-ascii?Q?DGUaZTzlbOGx+KQzMVHPC9jx81ma0+KAACiLoxV0uI5Ebz2U3F36sZeBLZYb?=
 =?us-ascii?Q?7xUBsi8QnRPC8sSBM7HxcMJbWdNTO0ruJFhkO51D8e+fg5IDhod5h3sTtt7F?=
 =?us-ascii?Q?9L5Vr+3KAlIsXoHYClc6YkB1sSRzKijRLh4piImxzndQeW2KkMxg+s4yh3Y+?=
 =?us-ascii?Q?0gaBKBUwRLv38PqtCtXzD2QeK+9VtQaS68gwr9SDK2BRAa+XH3Kny6FbPCta?=
 =?us-ascii?Q?1q0CforxX70NktXWfTSyDz0LQCBcl/V/I4Sr5w6RQAdZ+TUMnLGFgfHNEYsp?=
 =?us-ascii?Q?hhUF2FFtG+tJMr5szrymK+dWVAAowGJf7lyXYh9ClRCraqNJ5FVLBEFTLmeW?=
 =?us-ascii?Q?1eTE4neVgQZz2XOCYKhcuzz7juKHJgbS6KbO7INRqvjiVv8kqHeDJLonQxOq?=
 =?us-ascii?Q?IR7znDkRWxHazHFP64xhAOIFCY2kzhiIjgV+ouR3L33KDIX1pffoaWCpcp37?=
 =?us-ascii?Q?lhdtPHVZPzi8tK/AMfUNUAThRLzSWRao9t2bPNg8u2vBaVY/kVosi4YcuqHj?=
 =?us-ascii?Q?BMoWBSrsmvKsF22oCNflqKokr8UiNNsrSL8uOKZ3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154456d8-bcc0-44d4-9cac-08dafab441b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 07:02:12.9396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: poPivFn50AKVz0U5uTqYpROgJluRVS04wHAmp/JP+z/S2FODsdOBaWG/2BcDTpmXUlTumgbGGvXvOmr/cZ3JRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4879
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
> Sent: Friday, January 20, 2023 1:58 PM
>=20
> struct iommu_option and struct iommu_vfio_ioas are missed in ucmd_buffer.
> Although they are smaller than the size of ucmd_buffer, it is safer to
> list them in ucmd_buffer explicitly.
>=20
> Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
> Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/iommu/iommufd/main.c
> b/drivers/iommu/iommufd/main.c
> index 083e6fcbe10a..1fbfda4b53bf 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -255,6 +255,8 @@ union ucmd_buffer {
>  	struct iommu_ioas_iova_ranges iova_ranges;
>  	struct iommu_ioas_map map;
>  	struct iommu_ioas_unmap unmap;
> +	struct iommu_option option;
> +	struct iommu_vfio_ioas vfio_ioas;
>  #ifdef CONFIG_IOMMUFD_TEST
>  	struct iommu_test_cmd test;
>  #endif

while at it can you also add iommu_ioas_copy?
