Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98714661E7F
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 06:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAIFqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 00:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjAIFqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 00:46:10 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AF3DD3
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 21:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673243168; x=1704779168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Caqn1SXkJ6D0VbMBXPjnMp5pXD/WEodnRuXGTywysOo=;
  b=Wh17HjuuEmcnfLoPWOaUSeqi4KETEfpgvSUiXqx/LrE9sULNbgC7jxsZ
   EJnegfgCIoLCZdN6GW69ALOZ3SU6eQHXsDyO/52U4E5bDbh2FYMhj70JE
   llD8HWNBrr1At6jPji3cizoSw3b66gSFmcopsNC0sh5aHEG7Rc/Fx9WPo
   c9HN+0TqFjBKvi3IkT7SzEYp4/LlpQqitz+Ue/RdX50eqkEJd8+GsypMB
   qVAl18GwSmT5BgjzgurxreE6tty8cL0Qsdwx3yHzND2tsWsVHLDIIcR1P
   GCaKymChYGx6K1evNpoRWSyX/mPiSRwjSzGA08Pv2l0AJw240m0iN2K8j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="324045621"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324045621"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 21:46:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="634093382"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="634093382"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 08 Jan 2023 21:46:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 21:46:06 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 21:46:06 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 21:46:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEPhSVDaH84gcPGWuOfvC9EPq9zGwuKxCjgtmdZGD2Cd6QD3g9Q28GXKg+8aK5dnkoOZF6iWpqWO+Fp8le2il4VgXBKz9CEkzQS3p7lhwv/ZaaSaB7ThhzzssQM8p3obFbcGSqNd4SYXklBMSMFE4xjUuGC4xmF/RSM5HzAy090LPVZ0h+kdSrYwvNs/GUVn+K2qJELO9yQRxD83r4awRkjgHimxU8NVqRAOCchdddHkGzUXzuBwK8jXxqz2NLBqiJL4j6dvgmMB8BtqVkue6KHHJnw2g2kyUdcllNIprNgp3yOElXoP1kPwAchqR/XaiB8vIrzUBDEfi6xAaM79dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDEP9/6pCS1TPlaJ0W2tzFSpEG9wX2PFyFQNdkfSrVs=;
 b=Xfs7kCIP9bZJLXRfCMYbx1yR4zlp842pJhbO0moIney+6h7mGfd86I35SvzF+4KvSXWOA341pYjCASyMNhynueOvH9+7oR2s4ypp0qQeEl0l1tmnJZyHtucj8h5PrfA8slXPApDmXbhHuW6WhRqJhxlXlUMhs8r4IhXHQasXqORVM1muu7P25YQM3NhGRuRja5VP5uugjcQZ1AUN38XLqV4LCc0ncREgztuc5J6qPMmYrnCoRhzFtG3ujOy0dSWeEuutEK6xekpm4nCyT+Fc+iiDZAhBMOTKgMtNei7uOwMUtalotWyd+ei3GpR8wcoBwA5m2ucFbUp1am0dz2fa+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6992.namprd11.prod.outlook.com (2603:10b6:806:2b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 9 Jan
 2023 05:46:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 05:46:04 +0000
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
Subject: RE: [RFC 08/12] vfio: Add infrastructure for bind_iommufd and attach
Thread-Topic: [RFC 08/12] vfio: Add infrastructure for bind_iommufd and attach
Thread-Index: AQHZE4aWtV3++O7lVUOmGXijTuyi6q53wxBA
Date:   Mon, 9 Jan 2023 05:46:04 +0000
Message-ID: <BN9PR11MB52768928D8FF45129AF8D7CC8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-9-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-9-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6992:EE_
x-ms-office365-filtering-correlation-id: 28576556-9313-43cc-c41f-08daf204cc01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ib0nwYfTNMG63ru1hdiV8jFG7h1Hy0wy86bQsdrxQo8MdSU6GR97l/EQO4JWvQh996oYnz5vVlXktdg4UBg9CoWANHbsf0kZKJBsuBIrTIy50H2PROCcZygCv01ooFlLM7iYqry7g/yPzcGjR5gNjAcHPpKIhjkBxNyDzPZdfzXeLqpWliHodkymp45rJ3fXryfy9DT3foVb/2sKYb5rskD15i7MdQID2VYwzACTD7JVCWMn4MA4xD5AwSRnm5YV8C5sNhgXPD/Zu+ttpnViUgoRMeaoUgJ2XILwUDZvfFIjwwYZecLroY8aKl5BAPSdqINzdUen6BUVmCIJCBoNMlh9SPyBuf0TLyIvUO8Kt/4Jd1UO8CDN2g6aiobuqSL04W71GzDw+kEsVGOsEBpxKPRoDpuXmR63j7FjwHLpT1gTT4QpuUaYDwLAgHpsGlTK0h3MPMNpWyQzZm/HVrJ4rjDqNKPSGSsngmv/3uDlPOErdnjnfmECTUiA6DpYAmDkUWfqcITiUfAXnf/w48nF+EOuDIEeg4IKEPUc+23sS0rLOlQZy2kkFm0PgiIEH6MPltGWlkypjOjSJpMQgdMMLWtMZj6vtWN1DtnMCMtCmAmIht1xjYKl1FU585L6Nu9VbSPZ/3u+b0UDZW9E/wmMJCIfdKg43GsvE0/yX4gt1A5jPRfsSM66I4PrOW94GBH+2JqLSbXL93qChBmfeZsBCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(41300700001)(7416002)(54906003)(5660300002)(52536014)(38070700005)(4326008)(2906002)(8676002)(8936002)(66476007)(76116006)(316002)(66556008)(66446008)(110136005)(66946007)(64756008)(82960400001)(38100700002)(86362001)(4744005)(122000001)(33656002)(71200400001)(186003)(7696005)(26005)(478600001)(6506007)(9686003)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NYjP7b5fz1sh9mJXYBM5oMbqGgb5KH3hlFQkfbDrFuQcpFH0qpqOL8JZ79+B?=
 =?us-ascii?Q?3/FCZKK9LIogPn4CGAXWVJ+BqnUz4n5xOwTd73FExrnKvAPvJkmAj563SyCb?=
 =?us-ascii?Q?hD0ACkmnCGOzzLeRHdg7rRvB8pfs2eYecIfQj+XWfazN+1KsnTQ9g8p/Qt1D?=
 =?us-ascii?Q?d48s3f/dZc8lH5wMDfZPUABV599b9g+GM1piPOi+4yKDjzCTMyurvGmm0qlH?=
 =?us-ascii?Q?jfVaZsXE+o4kic3oZCqJmHUbBVH5HuEluhKcwPbPMSICzBzUTlb1vKsi7t0d?=
 =?us-ascii?Q?p13hQ5sQmSSSejH0LCVh9Y1RtMKh1Knir04496hSNoEvBgb2yED50F2UQbFj?=
 =?us-ascii?Q?YKHE4cpPNtGdy17XVEu9ERUZkWr2p8TbUvSoAZaM6RuT4XW9TN6udV8w2QnN?=
 =?us-ascii?Q?SXO07tbBcidLSuueaGuZua+cUnLlIDClPALVwv6gSvvwdw/F4+S/pwa3nutx?=
 =?us-ascii?Q?Q6xshcBAwvAmZLiTpBDnn8zGubnDpP2vi1aKbCkaLodFk3R6lX3o/nxIrgdH?=
 =?us-ascii?Q?7EOkbUso/7v/KkjH5BIzGNKR2aaVfn/dRL8IB4sCSf7Rq8CzRCyKKSfe2+RV?=
 =?us-ascii?Q?9mIByJGvpF/p78+cJ/oTLidA481yzf80PYPNDNTp7ycmu9eiGysPKPGRJRS5?=
 =?us-ascii?Q?Whps1g5fP8nsgran3JyDBVbVWvJpqnU3p0GIf/K7LtzhBUjPnv6rdWIzwsw3?=
 =?us-ascii?Q?YijgJZuxjNBJ2LIAABv9EOsz6+xwjImTeWotfphcebAiTqFruAxoDDxFmuNv?=
 =?us-ascii?Q?oi6IPCzAoUINO/Od1o09hn6DkGf2DEEk+aUK9IOQH8ZSoDeFJLEbo84v7dKk?=
 =?us-ascii?Q?NWR573Y+1vgAjKUuFFoOQiuaqqFYB0t9N+BnPRgGaXTc2OCQ7HXT3EGABqXe?=
 =?us-ascii?Q?eWe1aBoz9nABoofL6A52ROo6XTtyGskBYVZMbMYaeR8W5TyRigTXhES3aFXZ?=
 =?us-ascii?Q?O6T3/JjyLgUDLWL1txfMzek4I/qlTeNMaBYDkeYqLf+ob824dD+W9kZnDJYl?=
 =?us-ascii?Q?pu8TdMLViYWi/L2IqscWrCopdjdEnNmzONssBhVtUdX2Tm+j4Krh+IuujFxX?=
 =?us-ascii?Q?1lL42LrD2ULJ+bEak3kt2zNuRpMB6C/hel/bL/HQhVZD8uuhjnCsyMPz7lLc?=
 =?us-ascii?Q?gqJyk/9XAN+jNaUWN1OIL8ylrxayFLNeSj3G/mMIxxJ7tzq4xa18ZNJck/j7?=
 =?us-ascii?Q?9vRpDglZEP26FpLxqzljIqwd3b4xksX8Wvkf+DKU4t35VVkpHjuIAF+mazw+?=
 =?us-ascii?Q?stnNnz7dYAWH/Px/RInJQHlVx2wlN2OpOs4QvLt06r8L3AEzj195xXkYoo82?=
 =?us-ascii?Q?28gMx2JSNPIGFuGtIizz6CmyUilyaCmOxQL3h3ptktcD92ZuUORE4LUkx7eR?=
 =?us-ascii?Q?Yw/8LOFFQiItIouPb4DyFYpxl6GKYZd8/mvhUrb2NAS/bL/dnWkE09vibNqo?=
 =?us-ascii?Q?JjRh298ZG2GOQOAuAFcDYfW0eWZdN6oJgoHsFzE38/t9jkWLZpxSbKdPHyc/?=
 =?us-ascii?Q?sPnZwHdskmis7AFRWKLFIH5WvgtQYOVUND5HehL4TJUDVlgDDlOtzBoUzBgq?=
 =?us-ascii?Q?bsDkFExkKAA0gkszJNUQPQTdsUvAxa1l1rvrHsoP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28576556-9313-43cc-c41f-08daf204cc01
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 05:46:04.2336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8pTqIj+uSm3DHzyAOFUvzxJBPZWhpYSMJj4xlMk0MBPCRcCeUPB7Y27Bwt21+RZk44Rbur0AEBWdotHBtDpXFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> This prepares to add ioctls for device cdev fd. This infrastructure inclu=
des:
>     - vfio_iommufd_bind() to accept pt_id, and also return back dev_id to
> caller.
>     - vfio_iommufd_attach() to support iommufd pgtable attach after
> bind_iommufd.

Please mention that pt_id=3D=3D-1 implies detach.

>=20
> -int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx=
)
> +/* @pt_id =3D=3D NULL impplies detach */

s/impplies/implies/

