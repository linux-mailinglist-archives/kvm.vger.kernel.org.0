Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E839A597F73
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 09:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbiHRHqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 03:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243902AbiHRHqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 03:46:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E214DB35
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 00:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660808769; x=1692344769;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=yLGLEmTauGY0ETnGPzfT6ayy7unIq7F1NgHqpbjW1VE=;
  b=n/fn7RO9L9xY5fLY8kWt2sC2Kpdgtf7deTB1CH9IO60CdNIKVs6OgcyN
   WzWX0Iv8vyesLmjLN/WdnItMNvEb6HZfbn+98x648rWgLMvaVebL/XSjS
   phIkImzx8buYu+uif+WIW6SH1k3kABZgBH0rppJ+5PILh2M8q6eVn921e
   7KEg5TqJd31DsJhpIk+kghN5znXaaULVwh/bp/fl8Miir1dZGMhv6HCUn
   f3yGrkXtdTuee33thbjFb1ZfXspRCaH0HSQm1JraxeaAKb6EWTGBGwy1Y
   B7VlKPPQ5xd1A3c8gdh+OPtOa29gsZTmZHFniIdUbfb4J+is3St347Pa7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="279657474"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="279657474"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 00:46:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="584102708"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 18 Aug 2022 00:46:09 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 00:46:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 00:46:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 00:46:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 00:46:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGbeYkpvDYEr4kSln8MkbLU/hH5P8gLdz6iYRMr+Fx8yMG7AN4DgbAxBAqaczH0RdsvuZn2tGdioWg8m9pKcFT5uEYHo23ZzWUnTULXHc61etTBH8wXM6zs5mBss5Zf23r2KYQ/XoV5OXe6kSARst+n9SnuG4hKrPMiJI3TFn3ySGHGos8YSdI6tjtcJugi/PMzRToNNE7b0TApnTLPSGETW2WHi6fqRC2S/AIOAzOaQ8xuJ4YKolfLT/9JQs34WUKznUCzV8oj2mt+Jxvz9Aylamp7oyNauJkLWsWpzy1SRjriaurLgY2k+Z2y1fPyh2JqwvukUcVTi7IJ/RPEpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOH1T7aZOonYRUxQDCP1chifaR1H2FOi6fyEm8iFfEU=;
 b=nnZjF+0Fo3zcPcYcBC2GR2sEEsSZ4OJAzL6aVKKcLuMePzN7Yim4zGhdRomPfyRnnUEQFnOOUxFOaj476/LMGGNG0xxwzSWPTLam3jwUICWu7Yy2hNFfRjlH4kAw3low3fgWz6q17EqZzFd1DGMM1aIMi5HbAW6yJBgKMGTz3l+KKt2m5tz9RkHXDqK1qiIsHUQcck+NjY38c0Ieme8Wz/6DQ/WKnVfWqy+Hq0MRA9T/hf6VinzkslVSv15zUHdlTvU7gcrU9iYXGWcMcAbIufjwDwATKjkMXlmmXzFILh9KNfVXYjs1TZMIytPaB1XALQOuM4jZDX0yoyAG3GK3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2211.namprd11.prod.outlook.com (2603:10b6:405:51::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 18 Aug
 2022 07:46:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 07:46:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsMefUhZ1IgENlUynDdc+cU4pTK20SJAg
Date:   Thu, 18 Aug 2022 07:46:01 +0000
Message-ID: <BN9PR11MB5276F9EB0295CBD485A58D308C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
In-Reply-To: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 9d378331-4e7b-48b5-e86a-08da80edb259
x-ms-traffictypediagnostic: BN6PR1101MB2211:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Npk2r6+6TcyRt7oZ5xVM61+oH5saksCDQNnPpp8Cv2SRsFu5A6S3wMn/Uae8KhKEMwJEqEj9gOslRoMj/BAe/U9ul9c74aEbFJIdXFY6BXGLY267kg32uuQRhetZvST7eI/rrAzfJjdf9D9f4Ld9K2whgg50RyMeBuUFPgvPDHt0Ijz0JDpnJWzS5txr3Q/L6y9OLqDhziWsO3h6CxzK/0ntpDdvPYPZCQubiKdIlX6WTegCtKfRbeGqsHlgLdLwBcS4wLGVTLxvOgmdyssSppVGB5BKtpypA2PwvDqgJBFyn4ecCrgx8JaCWXvXEv2FdgVPtTv9GshavfOgyyxEvuZMenHWQrkq/2gfEWXqHPS0J0U3gNQQPKLECnZetjtGMZpy93GpK8gqajrbC5Xg+0xNhUmNgqH9efcsKWSLx+ae9Cu1mv0EiBrziJRI0eegzDq5cnOtFa3pPjiO3ZAtusChCkJwnTwYm7jBsMz9oOGkSxI/wlVXXI1ZPhvYrpQIeH1rHAJMHE2t5iPVbWOujBOz/OB/Spv/hzpz/2x7xRBLNG69cTCBIV5yG4bpfXcFZZhThVm8GZsN20GkktpieyWqkTpbM/Kxg3/KF1LAY4gi3jeuCRlwnOZwuz1zeLmXLas1pXqmaktL0L8Kuiu+d6aMZ+xTZmXwFtiZkJDGHnP6dS0DONPr4a5DisEK2oOUeGdhhyFZA6YHI9TMZbek7ixOrGj7txqt8qIP7A3ejIKmTN5+fbVHdkkw0KD5n7fd8R1lY83qwH/0jP7/7iRofQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(396003)(39860400002)(366004)(66946007)(66556008)(55016003)(8676002)(5660300002)(33656002)(76116006)(64756008)(66476007)(110136005)(316002)(86362001)(83380400001)(41300700001)(122000001)(26005)(9686003)(7696005)(66446008)(71200400001)(38100700002)(478600001)(38070700005)(8936002)(6506007)(82960400001)(2906002)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?obDaatdIlofHyJ6+mG5mktSp7fdTZ6NyTuyu+eUDAdTiGmQTTPbLbt1G9IOg?=
 =?us-ascii?Q?MwDIPAetM+87d8SZLv2aAxkgL0UqRTC9TxRw+sW/B5jJylpIGI8GBUlphEwX?=
 =?us-ascii?Q?OYUDiSB/rARzYBjcLuu93PRywx4jok2logCPkAu2cEe8AoXXSZDvo7+hrhnB?=
 =?us-ascii?Q?1oQuhZynXAqLmYWaVMA0ixJMz3H8r3sM3cvMll7ILHYkL5u4Mr4QPhefjiVc?=
 =?us-ascii?Q?CQg6pJwRvRsaXtU3dCzjCqr9fFM+3LAm3mzF6X7COxcUAYh9G+B/FLAUWijq?=
 =?us-ascii?Q?LOgzjveS+pq/i61W2ikk9P1t4faJnrDveYHluvZcWjODKAWgCsAtS2pTn7zk?=
 =?us-ascii?Q?WVjtCp/aZnLREtfjvj3v42ml5MrFm++8x+KrvXsSt0hj9czIrN6AiROLDHRs?=
 =?us-ascii?Q?7e1KEcSbgstFkbZunsottk/vVOrKN9z6Y4zpyoTLj+El/1Ux68eNO6KW7izC?=
 =?us-ascii?Q?i/L4VOy8iJ7ycZcZrc06wfNnk7Va3R9frKaPUtLqdW8a6JmRkS5VlpymUo+g?=
 =?us-ascii?Q?b1IC6rv7J5IMfYsqkKZh3UTPMcXsOmUxv8SPyAxPtiqccc8IdI+zMbE/BnwC?=
 =?us-ascii?Q?DDgwzNa418IEXGKDT4isLXjDEt1hjip8L3iSdERA3u8hwF9XhROYie/39rAo?=
 =?us-ascii?Q?1rPBjBzwpL1T8rQ034WqgylRtMKmW3mts9sKF40LSNSfHcKhgw0shqe2p3Qj?=
 =?us-ascii?Q?by2mcUCI9Ybjy4q0E6kMARg4wP+n33ps14/OukwnzCsnAItLtXHMXL9K276H?=
 =?us-ascii?Q?sdNRICigE5fQiK/gvhABVzgugues73J4jYvqRwsogeYs2S4UMIqvj6W+75e1?=
 =?us-ascii?Q?vz8SdZes4J0IG+zFl+jyvg0E6IpSBbZy03zMf5PgLxcSFnrH/FWvJLeHmYAe?=
 =?us-ascii?Q?HQcDNYeEbpzee5cWtHYTRaOMfzkQH0nflyO+grnRX5z090IH4pybTPYW5kIK?=
 =?us-ascii?Q?LgXZEBvbR3N8SQ9f/CVhdqtMf8fabopqCn48LllsFPP7aHShKzlyxIotrD1s?=
 =?us-ascii?Q?70RIdeNsk2MiW/aAjRwuwxYEcvTnBfEtbNu5IkqaCQBAaenRSS66H4e470fo?=
 =?us-ascii?Q?Kvy37RrhsOJ6bvYmzn5P0IPS1Y2+jmdWomxztZG97H5/jCu2tuhKwVaHOgAu?=
 =?us-ascii?Q?y9Gv+VaEH+jHbDRb77QfYlztx1pu6W+HOKCOiAkjgweJgyPGIXBNJVz96Zxw?=
 =?us-ascii?Q?xyeHQCavPbuldLyw0vIQivvSFlQec/xEUwUfiSj40/t3J/eRUhliAt7N4WIg?=
 =?us-ascii?Q?TtpuXytHVpS/kNf6/sp899ymyCxVL9HapOAtNYDByZO++tkAyjZXYMjblNsg?=
 =?us-ascii?Q?z/hrOBvgqjx/17UgdlnLWYDHjK6pPrekZ75R52M6hPTXOPU8/vTzeCiswDQJ?=
 =?us-ascii?Q?xR2sqV4eWVqPfWIfz6Xh4cSUugijWm5ffGG3/GbNBpvSeTn+KPEYqx2fqDRl?=
 =?us-ascii?Q?RtWlCZO93sCJd5pSrMEr8E7NXdh1O3N57wIj7VlZJZRnkbtmEr6a48ZSgA+t?=
 =?us-ascii?Q?OhTTysJjB9l5iu5Y+mGHnFHx3+4jXPl88nrTierIw0SQh6K0/srCFu3zDtP9?=
 =?us-ascii?Q?7a2YWqY2RfqSwIi/BGd0mwvCo2Y87J22llkX7lk0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d378331-4e7b-48b5-e86a-08da80edb259
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 07:46:01.4031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qXZWleWMraEf6qeyeYF/jYONAf0zrRErLyw2WswFM7j66kdXWPs3Aiwh1iLd75a1ZwrsMBeAdv4WF3TePdcHkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, August 16, 2022 12:50 AM
>=20
> This counts the number of devices attached to a vfio_group, ie the number
> of items in the group->device_list.
>=20
> It is only read in vfio_pin_pages(), however that function already does
> vfio_assert_device_open(). Given an opened device has to already be
> properly setup with a group, this test and variable are redundant. Remove
> it.

I didn't get the rationale behind. The original check was for whether
the group is singleton. Why is it equivalent to the condition of an
opened device?

Though I do think this check is unnecessary. All the devices in the group
share the container and iommu domain which is what the pinning
operation applies to. I'm not sure why the singleton restriction was
added in the first place.

>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 7cb56c382c97a2..76a73890d853e6 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -74,7 +74,6 @@ struct vfio_group {
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
>  	enum vfio_group_type		type;
> -	unsigned int			dev_counter;
>  	struct rw_semaphore		group_rwsem;
>  	struct kvm			*kvm;
>  	struct file			*opened_file;
> @@ -608,7 +607,6 @@ static int __vfio_register_dev(struct vfio_device
> *device,
>=20
>  	mutex_lock(&group->device_lock);
>  	list_add(&device->group_next, &group->device_list);
> -	group->dev_counter++;
>  	mutex_unlock(&group->device_lock);
>=20
>  	return 0;
> @@ -696,7 +694,6 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>=20
>  	mutex_lock(&group->device_lock);
>  	list_del(&device->group_next);
> -	group->dev_counter--;
>  	mutex_unlock(&group->device_lock);
>=20
>  	if (group->type =3D=3D VFIO_NO_IOMMU || group->type =3D=3D
> VFIO_EMULATED_IOMMU)
> @@ -1961,9 +1958,6 @@ int vfio_pin_pages(struct vfio_device *device,
> dma_addr_t iova,
>  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>  		return -E2BIG;
>=20
> -	if (group->dev_counter > 1)
> -		return -EINVAL;
> -
>  	/* group->container cannot change while a vfio device is open */
>  	container =3D group->container;
>  	driver =3D container->iommu_driver;
>=20
> base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> --
> 2.37.2

