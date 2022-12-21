Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605F4652C09
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 05:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiLUEH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 23:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLUEHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 23:07:53 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE771BB
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 20:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671595673; x=1703131673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iO15JEh7dYggV5vPKjYVfwVbJfdRrZ1BPmy5MUcTOOI=;
  b=OHxa3O9Xj1xyeVDzFYg56huLjCIZOCnI2UbR19miqKkzE9Slz0A5jX2g
   5f/HdvTohO5qC329SfDgWXA+/O90k520us8/1PEJuBuRM+M2Gceqo6sTV
   r+DoxQ7J+g0GFy+xu3IXdNazwL1IK5rdb7nJK3pwGdzRduN6v5qmtquQi
   bosANG7QLqy9peQKNyLn+v6dsH6TeHCcqmF08rV0GsIf0ZLpUbRutPd4J
   4v00E4RgjtYDqaABCn1HogJHyyxg18Zy710YLkvK9MjLLylPKFgtDpx2v
   dU3ejeJTFNW32hvSPD9nBd1ecG66z8tl3tNtWv3Cb/zSMwmh9d/Isv1p8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299455609"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="299455609"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 20:07:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="740024494"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="740024494"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2022 20:07:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:07:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 20:07:50 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 20:07:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mv/gPy5SxYKQq2dINWPxKiv9LvrUaJYGHQMLjtxH+D5wUwMI29pR/pTGKWEkeZHexfIKlnJ/xJb53+mLYc+iVyNSg3RXqtQkmxdP6swDbAznStL/87+SdrCiwRyC/QQg/HbeBC6V4r+8C4eT4KZiFTe/zKhUcoQoG1+h2W7xOelhVyBidDF4NNQYMLBSJKlASF2feK7itz1I6dWKqvrztSaTZfkZAdIHeuz93pChOQAroz+ghwBsDpYHec48mDoqzxYphxvr0RVxZY2AXKYwpt0n+WgBevAC9f8XNEKyIayCg/J+K9sy+DF2bbENfOVr5bGIVBY465ty9rgbKbr5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buBbtbD0spNDtDTxQOjTw+ZLwLgd4dnvAAY/7rw3GV8=;
 b=C5Fjwr6ddhnLkMMw1F6F/vWRj7oizATkbOf7HbIJG9S9BrteeAy4/tWDdQYgu7pY1Mu8wzJQs28gyn0siUVcWCoN+K+f01xoE7T+LxoLQX8iDU7ZGcaNkluX9UoS8jiOu6IDP2PQAm5naA8NBuPZFHOVIr4am58B+yjC4xeVJ8a0Cz5FLHV98s/fZFmuCGggth2CRcCLKO10BL+qWKZzTEyYmeUcTkkdAF5YXNGCDce6FBjX4i2W2sP9Pg+cShvrlcemIo1nNE3+QtnR1auAODfubGnqV2003xvJkNEv+YTwzYdgT7S6cbgTWCjmTQ5I4EmkJM71Ya4BrhYg1f7LsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7642.namprd11.prod.outlook.com (2603:10b6:510:27d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 04:07:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 04:07:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Topic: [RFC 03/12] vfio: Accept vfio device file in the driver facing
 kAPI
Thread-Index: AQHZE4aUoco4n7f4C0+MZKWU7rSYp653rrfA
Date:   Wed, 21 Dec 2022 04:07:42 +0000
Message-ID: <BN9PR11MB527678C180EE0BBD1F40E3698CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-4-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-4-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7642:EE_
x-ms-office365-filtering-correlation-id: 572b7de9-d309-43d3-5c17-08dae308e8a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qbSNcnBtnmxg0E89AaFYkgaP2bWYvABUd2WEZQv+c8sMQosl5zK/4jsqWVHYyIvXveg/qMijp0YjOpsFPYpkMeZQ1B6m2YdxPjAmO7TGwYQsFucuZbTdKm7vY0wp3LJsaDNPStursUgNb1upttWWEVyv4Yirr7jPdZDQpV2vv6+5QkRzYdAxiblzZicKrwold3MmmPuZX4ne6CovLwSlXk3l5m++PYUnvV5eo1eb6AJdF8j/Ne+3DxbabYznCgIECZqiuu3w9qbhFthSD3ejpZf11ynTI+J3PoVpwfSuchw7svUpWI2cpZbxf1vSWqxA47GRCBGBolxZpmw6uAMrXFz53yW6Mq0G55FAFEcgYMw1GtKIPG4D6jrwVlCcP0M2swZndWN+eFBrAwKXq/V6MoH4BvMmOHXgrueHeuCvY1WhAsnkq6fIe2vSf8RFm5REpUYMWzI4DNOCULjvlzAS/DIV8RFepRtL5zwtJlzZPmsRRLUemB+4iiYFTApE+epAxgOceX8HqH84TU1++DIvnHn6BSz7QpdldyTyLWH1wlUDjXrRogFUSu5F3lVD9dYZlBS3QKZboBtYh0XQSa3u/zjGio1HCPCmebhY0N0AUS8GKSUG4MfcnYiXUqwa6EzX0vfOEEzmgkvu1UIkEGoGL8xtCySTK+FDsa0/ksljOpb+g73+9mwAvkIBeSwGfzYzDDrQnfwpDbvXfo49EJteDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199015)(38100700002)(55016003)(33656002)(122000001)(38070700005)(82960400001)(86362001)(8936002)(478600001)(54906003)(110136005)(7696005)(26005)(186003)(6506007)(5660300002)(7416002)(316002)(71200400001)(9686003)(52536014)(2906002)(64756008)(66946007)(66476007)(4326008)(41300700001)(8676002)(66556008)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cpc3CuhnF0fxMeyUTz6gPiviqpzbxo/vTfdNfhO8vMWiDH9/uKKJKyO/ktvT?=
 =?us-ascii?Q?VIYi6qNidUYA5gN7IHlGkiqy92UM+KXoFPArpq/eMN47pA5V9t4GSs0RdC9P?=
 =?us-ascii?Q?a4AD6Tt+U54Ohxygxuh8S1KPF7GBU9mHnvlprSolB214jYYrUj2OYKs/T6Cq?=
 =?us-ascii?Q?tWaBMSJy5g8RG7xDThjaJTaDenbrH0p7jQG/a+ugttAtbE9BZbkd/gceCuXT?=
 =?us-ascii?Q?Ew79eWH+MWqoHdeLLpU9a5vnCkpByGdCiXjGT6vPr/P6kr5xGyodDcnWCbkm?=
 =?us-ascii?Q?vZaQzNQUCubMOOoRp8vWzLegnjPJ2aY7vy906zj5pYC8gtRJkMK0tnElzZH8?=
 =?us-ascii?Q?rFs6TIhInYSpw9qkyJuNwlUuk/4km68SqvZfpa/WY1fAooIQ0q8fhJ7cCkWD?=
 =?us-ascii?Q?u63qQlf42TJNmC4LCJvPaG9AdciElGEIA2qYLPFN/bGz0kvMNKL30hvuWAJL?=
 =?us-ascii?Q?6fykJ93i2o9bK1byjUawd4mgqnvADUFsv4NLQb/3uvO14/kva3A+7gOR80N1?=
 =?us-ascii?Q?5xwoiEDunNs3ub/RZ6YHZyy7kdQa6rRubqrB8lRHmpsGncuq3icj7Fz1OIft?=
 =?us-ascii?Q?EGwm4jdV2nsX+5xBgS825MjgVXiQ8sCPhvoDS3XyD0ek6L+J0xRM/hnQnGfq?=
 =?us-ascii?Q?B8Y+ml8+50JqvuAlyFG50l4zsxx52FPcmCDu5+19gaZ6hbiyzyj3VkxZJsf/?=
 =?us-ascii?Q?7yzqxUE2kdjmJHtY2tIgsI+wKHTcCR/P04CKFI9z89Btaz1hBx6vDMHyJUTM?=
 =?us-ascii?Q?eBds7JRDW6xPsS6u6Whwxji0YZuuVud3vV6D0rnai5Ds+Gs75kE8/wb3cuKd?=
 =?us-ascii?Q?j3mCBPNiPO9KHQGarpwDp5YpXb/NiQsWa/16V1B2EE4N3ADb6Ih4QwfUX/kq?=
 =?us-ascii?Q?yKK+W4c4gRf4Go3yPmj0pxSEEkezOyNKPC/LHd2R3VmZKyIIt1CmF3H7PtqA?=
 =?us-ascii?Q?5vcnxO8R3LG8AtDbV7OhNHyTKxN4Ql8Fa+PsaNVsWFo1lkUfg20GDd8Z8am/?=
 =?us-ascii?Q?5fJYNM7AcJBvjOT1qCr+i42vI2IDcg7zqwogDIJRvqLho26KjnVkcKutTRlV?=
 =?us-ascii?Q?fUncysUaR6u/IrpErlni3f6nso6A7nnxcuaW8tM4VJr9L+gCTZmaf17y3aQV?=
 =?us-ascii?Q?aZN9NJMULqt502q+NDW969Hc3bBKhawgnvNqChKYnGMNuyVKg7GaBA84IMGn?=
 =?us-ascii?Q?Ht6vcQtzBZWMDxBDpwFbrElIUw/E/cN+ZxpnRzssOHwdRIX2HSkS4Ncl3ZMc?=
 =?us-ascii?Q?XsKi2GjeYpxH2oY1Oxa9LGkz74ptwxe+cxCtMEofe/cqYDu9nQdGJzjC4Tvr?=
 =?us-ascii?Q?TUdJb3OwQIx7rZIVym5rK/nM7MGj6nHYW5QIiLL+f2DokeHau3qXkwfKmYqa?=
 =?us-ascii?Q?IjwA06hKx0iIK5EqYlXKMNDJSOvqIsM7I1Ugnr2jJT1gRG9/9lV1P0G0mnbT?=
 =?us-ascii?Q?B650dvsPWfOT6rA9VU0/ys0px40RzePevjeIRFShV0YNte42Za9hqbgbRZ0R?=
 =?us-ascii?Q?5FbI6pkdqMC84PPFJLuruay+VQgXm6Ht6VOlFzFG8AP0bJ/yi1lm0mXzBARC?=
 =?us-ascii?Q?s1gCwwzqzVv4ey2bGNIrk6jn1MtXWK/18mXNfXUr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572b7de9-d309-43d3-5c17-08dae308e8a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 04:07:42.8312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fC1+ZbIHBMvAnilchnHXCUO/4lPJYJN4S8wky8noUcZpt2i0qs8NFcqzD7EQGMj0AfdbraYGFeya5QrwyP4x0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7642
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> +static bool vfio_device_enforced_coherent(struct vfio_device *device)
> +{
> +	bool ret;
> +
> +	if (!vfio_device_try_get_registration(device))
> +		return true;
> +
> +	ret =3D device_iommu_capable(device->dev,
> +
> IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
> +
> +	vfio_device_put_registration(device);
> +	return ret;
> +}

This probably needs an explanation that recounting is required because
this might be called before vfio_device_open() is called to hold the count.

> +static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
> +{
> +	struct vfio_device_file *df =3D file->private_data;
> +	struct vfio_device *device =3D df->device;
> +
> +	/*
> +	 * The kvm is first recorded in the df, and will be propagated
> +	 * to vfio_device::kvm when the file binds iommufd successfully in
> +	 * the vfio device cdev path.
> +	 */

/*
 * The kvm is first recorded in vfio_device_file and later propagated
 * to vfio_device::kvm when the file is successfully bound to iommufd
 * in the cdev path
 */
