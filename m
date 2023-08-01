Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5976A9B3
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 09:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjHAHEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 03:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjHAHEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 03:04:22 -0400
Received: from mgamail.intel.com (unknown [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522031B5;
        Tue,  1 Aug 2023 00:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690873447; x=1722409447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EJaWi0Zy1SYfvDmf3F5pdYNPtuk5jjpYU2XnoY7a0Lo=;
  b=WUO3JJWj05gtXRyPx4jrBcUoOrFueYKjitlSa4/cY9ZeyWePuEyE3noP
   siXRHognBgsOqnNb7tliPV+fxGKR0WZFwWeCHsyriTT2J0jP+rh4QhtZZ
   CuY2KQUDwoXjTtDVj2MQn+KgFt9lEZBcZHDWiLMcALqlwKjuxt+MwJMp/
   bOfBxFUDOu0tjuCjhQKMif94ENnz2raqd8uGbVFFVlzqbCN/O8MXaJLMn
   4croFV/lp7zbBl5K/lZU1AvSqgzUreKyythJbqdXvnp8xlKdW1XGfzeHb
   bCFJt6fWfH5xnjGKY07z2+/2FQYxJv7R2SN0ybRHYJjSDRuOjKn3jMb9s
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="359261960"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="359261960"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 00:03:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="975162129"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="975162129"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 01 Aug 2023 00:03:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 00:03:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 00:03:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 00:03:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IR7tVO2nLdwygWZLXQQ1FHZjHOOU/ezBj50HRgqilw9uU5ucMEOKQ2yMbuhJJGkoJ4KpnOgRChG+L4wI/hd34iVdwJq5ENWLreOJzsnqUTEpFtyqqlhMrLcOJQ4vtovSfxqM3UdZ/tIKjGHoFCSS5hJSwuy69/1Xb24UnjOssGs2aiSDOmdTwJFqDOCUbv17Juvkv8lQfVrQ6tsDxmDd8qlU9+HFwcHrMYT4g0duRmsQc6FizK9qouHaSnoj9R9U77AJflnxtdhwd8rxe33bRHQc2f9bZkr1/Hfga0XrpD9ok5Eo3dZmmYF0TvASiWwBAeE1+IiQ5Lij2u48OZ/qwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pz9wbM6x/hYd1HH08MMfVe76kt4QZjYn5wXFvEKFJ9k=;
 b=hvcvsoczLy5gj9O7UhFMwwE5pShVpjtCtDfi0equgWRanBLpp4HU4TzCQzBxLjXg1WTlVemZHRhjrkrXNluFl63sPt7JtwID9KYL+lp4fnQFHe1bzV0/RocZosPNALp0SMwrCWQKsMkKt8/kb9ns5ab/hiD6AvJR/bMLxz47eFxOjl8seMSRmKUhSAfqxNoSuJZ3WbQvI6aTAIrtVol+Kxo/SpsbAhOQH2rnbVaWMH7xWVXwizZV481rNlhZbeBHdvHiNfsN76UouDYOtvfN7A4PBchQ9bkC/1EwmvaC/LHKA3R1Dr5vChWhP9oSVc0YcB+L1kwtkgjoqTc7sMmgRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7863.namprd11.prod.outlook.com (2603:10b6:208:40c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.44; Tue, 1 Aug
 2023 07:03:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 07:03:31 +0000
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
Subject: RE: [PATCH 1/2] iommu: Consolidate pasid dma ownership check
Thread-Topic: [PATCH 1/2] iommu: Consolidate pasid dma ownership check
Thread-Index: AQHZxEIhfIdukOyCd0Ww2obftm7IEq/VAaVQ
Date:   Tue, 1 Aug 2023 07:03:31 +0000
Message-ID: <BN9PR11MB5276D196F9BFB06D0E59AEF28C0AA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <20230801063125.34995-2-baolu.lu@linux.intel.com>
In-Reply-To: <20230801063125.34995-2-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7863:EE_
x-ms-office365-filtering-correlation-id: 8777c6cb-71f7-4b0f-ed11-08db925d6a18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Dyd/MTd+KNTo+Q9NSnFKOYBDkEpge4hDFRG1OydeNyFeO261sAzcFLEF5SHi47l1v6hSBXA/LQwUhiAnJURA8TfWQaxDEBXa9GSS0Z84k8qfC7uhN9gKrZpbcyAQuf1kn72cPzil7PrJWaMAOZ9Xm4fdz0hDArRX0s1hcHyeKUXL+2FAerNLGVknp+u03h+4KssH/lm6lA7amPIUkkUF9AzmKWhZmsrhDQEP7OY9Uff5VQtpN5GsS9nQRK/S4Cj9XCxd8t7rkPPIguBUo+SbLCb8dT/i/qv9a4CJoEzg5y6Zmm1gHtFlYqqvb7E0294bwCxK/yEznGf56pAhVluD7ooQATIbRScta/gvh1waaJtgxEkSQsvpylTGP8hCw1Uw9srTEpSxId2nnsc6wgg/Y9GYJuwZ+33+L/He2frpVJObJ9RP90EOhjdKeXaRyj4bWy5NddV4BXQujjC/DExg90LzT7MuVXF39RncoHy8xQ/tmEsoOwOMyvcRKnVwu7VRmZeeAJ+LC3sovbcPRXhBm8m/Opv1c33ljTeLzcez4ByFnXUXp9FcNW+E4QhRg0/qK55BO1xnnyQsgWbmWXD6nOhHkt6MNX+WfUhWx/KIoMQfwAAE1PogrmUBMWtw4LF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199021)(52536014)(82960400001)(54906003)(110136005)(122000001)(9686003)(26005)(33656002)(6506007)(7696005)(8936002)(8676002)(5660300002)(55016003)(71200400001)(76116006)(66946007)(64756008)(66556008)(66476007)(66446008)(4326008)(2906002)(83380400001)(38070700005)(478600001)(41300700001)(7416002)(38100700002)(186003)(86362001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ascv70B50ItG0oc8nA48bX+nUVEp+vaoggFyYQ4pqwaX2mpSMxGGTnyosW+2?=
 =?us-ascii?Q?/jQIoYlLgQ4H70sqQzLrLYjw74QdVRb32PaIA6fwIz18hBU+2avKLAi+qaS3?=
 =?us-ascii?Q?e1yEUsLwKl1hM2Da4AxH3cTt6plzGvpkuE6ENjFWHSMyHDiQ6ot27p2ipamJ?=
 =?us-ascii?Q?/KEKAWEiax+Bk/n64wOCY8Tlo3Fj5DnFl8cScDVo5cdAhMtFVcN2MsT3QN/v?=
 =?us-ascii?Q?nn/ZyI+qK8llPQPMyYfWVEklczVcRWWU2EW6WVubwWuImDUZWSxiZr31Fo+W?=
 =?us-ascii?Q?NW5TmprornH5k1mXauQaCLV+tQjD/uTkQxX3QJh+ZXaAt2TjHMHg23n7NaBk?=
 =?us-ascii?Q?8fWMiIyZM5BYndrSLliuWWMyf7vRVZZTKETvVxooSE7a+BPEhpgnKoZF2nag?=
 =?us-ascii?Q?jd+2TvfztjKpOsKJ5hX96m8xFut7nZEyM3CPZTsJWP5YamKVRsd0LOCOTBxX?=
 =?us-ascii?Q?PKTeVAGtKjs5aAaa22zHCdlidfpKawq3wJJ2NbxhNA6EmrcUozuJyIQPAtZS?=
 =?us-ascii?Q?jiTD1SzccPfvyAvp0XVkJ9ISpar2K859fReDWUf+KioaLroUI02H98wgoEpL?=
 =?us-ascii?Q?jwYe/3VMmFHXXBkYiowpi6dM7oAJljNPSpLcxH4XnjLV9SLH3jR1o14oZfZa?=
 =?us-ascii?Q?UZ9Gf2dtiICiNXLonb8pqUZ/+twlEXu3379s9cPADbTdhqD/6VUtMM99wrWw?=
 =?us-ascii?Q?cdyjki5L7J0pHryiAv3E5AT6nqQiYinqyuYJPJCPUnu8Gv5SqWmr3fq5jFjf?=
 =?us-ascii?Q?0ZqQNCIFBi157LRqUsyreFe4n3yp9oMDfWSFVGteFfZXYWY5I5ghURQLIVGy?=
 =?us-ascii?Q?HG4L54og3Kd2W1rBFtkXXDvANdqw11Z1tsD6goJPsblpGs1/EOVJFzoX6em6?=
 =?us-ascii?Q?ih7IGlylNmO9HjwVriRJZx1KIopbyemJAxCH9ZwH5DuUK/dBRlLolbgvDLzS?=
 =?us-ascii?Q?R//+ycG9zIIr8/4M/flb8LAViSyfq5wwIweUJJMXcyu7MMGyfKw9G5mnS3W4?=
 =?us-ascii?Q?5iUb8kaJLib5Od9T5AadoErufOvk3KU8kg/iB41++rmNPa0YNcSuEgqCYxYP?=
 =?us-ascii?Q?U0QLP9pR0T4stm7rzmfT4fdHgjuP1xv5/+0ftd7NuYVjRvMjjSKneQkFd7EP?=
 =?us-ascii?Q?31SgNlxNBwgA0H6KL6yB8Iy8f+aDuvcx4riDOIQn0UYeBDnwdkSsdfcbDHzq?=
 =?us-ascii?Q?aAvdURTYpeCzEE5zBiE0TYYU+T8alx5OMX87iEJQ0SW2OKAOIrgQ5G2KvYui?=
 =?us-ascii?Q?GzoQr0QH90bVBQp2oc4YOGIWQtvJI5QNZ2edZ0GZy3x7KqJTW0ywbf+3v2vx?=
 =?us-ascii?Q?HgXd1aK3BN5OUe0ywz30lMCgrtp8+KeTnyFrJPXn1ntTxovCzbguGxtJrJ6R?=
 =?us-ascii?Q?lBdbduc8yevIJzPPFAxWdRCP7RGigBBEwdWVBTxmPXQFj341cKJlQVTFJn2w?=
 =?us-ascii?Q?4omDQjD3uVG4hr2yp01IVg94xk1JkrkA0ZEqLTYFXtJHi4qnLWN0VSSwpbFM?=
 =?us-ascii?Q?SJuAlp6gfOWneWz87pwz32PO08QRdCtvExzT7LVgRz6ZcG54rhoFVmrrAJKd?=
 =?us-ascii?Q?RlqkEm7kfddhiTD7gTHr5nY8pgwFHqPi1MPqSfFX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8777c6cb-71f7-4b0f-ed11-08db925d6a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2023 07:03:31.2421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XYn7ZHfq9XlNqAFtoY9F6JZcYX70G4WXQFhcw8M1ccNGfZnBvRCGuMJ6apYpHZd/zV3Iy4WoQqAj8d/MjEbrrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7863
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, August 1, 2023 2:31 PM
>
> When switching device DMA ownership, it is required that all the device's
> pasid DMA be disabled. This is done by checking if the pasid array of the
> group is empty. Consolidate all the open code into a single helper. No
> intentional functionality change.

...

>  /**
>   * iommu_device_use_default_domain() - Device driver wants to handle
> device
>   *                                     DMA through the kernel DMA API.
> @@ -3052,14 +3063,14 @@ int iommu_device_use_default_domain(struct
> device *dev)
>=20
>  	mutex_lock(&group->mutex);
>  	if (group->owner_cnt) {
> -		if (group->owner || !iommu_is_default_domain(group) ||
> -		    !xa_empty(&group->pasid_array)) {
> +		if (group->owner || !iommu_is_default_domain(group)) {
>  			ret =3D -EBUSY;
>  			goto unlock_out;
>  		}
>  	}
>=20
>  	group->owner_cnt++;
> +	assert_pasid_dma_ownership(group);

Old code returns error if pasid_xrrary is not empty.

New code continues to take ownership with a warning.

this is a functional change. Is it intended or not?

