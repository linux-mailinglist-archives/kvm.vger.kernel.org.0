Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9F6F0135
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbjD0HFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbjD0HFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:05:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1B3420A;
        Thu, 27 Apr 2023 00:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682579142; x=1714115142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lOkCzGNvmBXgvGB9MhwvUZQHBzeEOkhr32bkINX1NZU=;
  b=kBvO7wstMsWIcA5TGDw1ft+mjzxsx5V8/Zo/vCFS+FAM03YnQ6sU6Sj7
   l01ac8i8EUqnpRGwsSOozhhUvq6uM7eoBBnG8NojxyoybLafFJled02sl
   0nKApCDLx6avOhnS811EvvDQIykbeysD8rLsA3wk41tTN8UiETxZuPdbm
   Js6lqbCP8pPCps0E4/1Jr3k8vpJ0YHLvti0V0kTnpm7yDrsY2k/STz8/5
   zNpo9dXeSLJMRxNvEVTqPGSHLtP7zsVFJKy6NOxtbiPiR85Ztuue1fX9o
   i0GkWZvUfgRakgJZJ7Dsz1p3j8hBNM9Z2nrOGlo8axRborKJLuYIjrNfJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="347361343"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="347361343"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 00:05:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="758966277"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="758966277"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 27 Apr 2023 00:05:40 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 00:05:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 00:05:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 00:05:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W33BxyZPdkosaggdIvaskR/z4ipYWMPQgfyuAcNrynHqVoUtqp63y4mr44EK2c+LT7MUAfp83VEZdQJBGGmMi9RhSK6qnGWgli2orjI9PIB8c34rkEyPCcY9vQcOgNNV2BFkJ5jBG3JqoToLfvCUciN2rS40Terjsva9CtwLRdUrfgEoDeqnixModX0LhhdljjcIHAJHRbezM6DTa7FmGWDB7/jAslhh2K4LmDiTBipMmpBtyltfK/PZAlS3rTe7x70Wdq5uImybsoeGQruiOeiGHOkfICidF4xIEn3UJs+jMkm9F7H5y7jRdcmT1pP4pJhsDuaHKD+nX9E4/4q8IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7E++khss0CqMXqPaYoygOKPE4WNoelDb0KYXLAXdJs=;
 b=EPS6Y0j+g0N3gATyExqmyGQqEqBKee+JNB01DYoX0YTmXym5Z3hUcZRUemHzqv1jp9j6ZVTMusMvUfzaYdz7T2yTpT07Qvr6rSWUUSEJzap79j5UKDyfdl9sxiCg5M5RX90UEoY24W7BP3pgT2dSGCdvlWwQQpSvGhdTwvpeseHAAq3qPgH+J+IDp8ugn5wJQQFM/5oCx1mqYa4K2oS/NVEgRSSv3T2zOcd26UmObVsT1XIDygm6neB6bmmFp1DwmxI1efzbZX4yRrw4KtXdhBW39jLRj5/RjRKdx+RcaPeuKV98bmK+1CMGWeFuqgzpBWIWSBW0iz1sPvFTmjs5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM8PR11MB5573.namprd11.prod.outlook.com (2603:10b6:8:3b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Thu, 27 Apr 2023 07:05:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 07:05:37 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 1/9] vfio: Determine noiommu in vfio_device
 registration
Thread-Topic: [PATCH v4 1/9] vfio: Determine noiommu in vfio_device
 registration
Thread-Index: AQHZeE8BXiKD5gxucki8dL1sv/iXWa8+tHKAgAAH1tA=
Date:   Thu, 27 Apr 2023 07:05:37 +0000
Message-ID: <DS0PR11MB75294AF4D8B4A886F7646F44C36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-2-yi.l.liu@intel.com>
 <BN9PR11MB527688F8FBB299306400A1308C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527688F8FBB299306400A1308C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM8PR11MB5573:EE_
x-ms-office365-filtering-correlation-id: 2acb49ae-1be2-42c1-fb9d-08db46edcdbe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Gk34WKslf5BlIo1lxrvIEVxt19qE5xWlkWbJcZka8VZjFVQ5RMk2muKoNtQLNZbMZkpPQkXlLQQxXSHBmFnH6kRqPEibp+9GRkdZ88n9b81wAJJQDIMkmzKyIxkzWM3/jM3XqAeGQeRF6FbVpIspLolasfC18XNPvs7iBM1mFRp4RnDfEpzljRSOaz8n+S2hu/5IbxNHwJjHGApFQXWo4bHIhcmaD8RTVFh8motYkOiv6UbP6xR6k9TF2vAwOMbRWTEysYa2ECbwnTof+qw9lMg1UQBtUUm6cToVYw6vfkroN3H1HtpvaAu9al8/qL+84p7WG+LAyfWUs5am8TTxltrC66+7+zlX+s03xCWdxcKD02b9NHCYiBb0qp8IdiytuasRkFGoqWuX/nA/Cxts1TE49bUWxiZNikE4RhORSIrmWLhWhTylRLVlsPHgXgj+IT/gNLBzBgXfxo/SpTuXBHyOG+GnNHzhpKN1XBeOjBOLd+khuQEDVyI5UwA0JoVMp+qcns6KbJxTvWwjyj9zF3Ow9SO+nCUSyZe/vEE4+CMoFgxOkbg+1BRSo8xjCinaXqAR3kaOQLddL3urLUIEVveVMNtDaMQgJz2CjXAbVY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(54906003)(478600001)(7696005)(71200400001)(55016003)(26005)(6506007)(9686003)(966005)(66476007)(66446008)(66556008)(64756008)(41300700001)(4326008)(110136005)(316002)(82960400001)(186003)(66946007)(76116006)(5660300002)(7416002)(52536014)(8936002)(2906002)(4744005)(38100700002)(38070700005)(122000001)(86362001)(33656002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yKxrEjvCud7TRaDUpA2Cjd7ZtUzDE7/GfOm4igUZ3IjnBjwn3cjQ4LBnwKwT?=
 =?us-ascii?Q?47phy/VQXzI3GvSG79K7gfISQXrLr6+LkZwsKggbcKvWWNzlNrwSIVkp7Dh0?=
 =?us-ascii?Q?yABqajAY++TvAOIb/VB6I3qbFxA7wiZkqYMA2X1y+byCtVrgiiPTw0TMHKZk?=
 =?us-ascii?Q?BXz9nxnIl1lk1Sn4ClA5YZxgU05NWbnX70GtPRpBPAzl2QbmO69VcngCrl0C?=
 =?us-ascii?Q?ZZ330qANkLUOZ3gXQuUamWACTAoiPg5pqL+XE1wNf9T/zF9b5TwDzRhVm2if?=
 =?us-ascii?Q?QYT5b24hstG4hBug1yL1lKYOQFLWcGIWoYKGS1ExMe0v3u9P12bOxljAIrLD?=
 =?us-ascii?Q?ZuAwEUoB6XBoZXfb83K+k9w4elYECPcxy1paCzMpxHddc3npzGiPRmVQI38X?=
 =?us-ascii?Q?7+V9FjGlmlBOLucit7jRz9vTCMse5Fl/BYO6B5TaLuUyak3kB+LCeZmv+2Ka?=
 =?us-ascii?Q?vQpmQzBLLXfsIc6EkqNaX7448UDkdXc1tcHMGSwFdlfSaQsLLVhbJGex3pj2?=
 =?us-ascii?Q?LWWg+RRXPKVBRZByj3kWOTH3dumDFpjCYtXdzUssBXzB/nWcpplN+BsVTbRj?=
 =?us-ascii?Q?wpnjoaSNPxNmfZA7w2ID3Mn15L84V/In7D2NqzKhNYCoZdyHUBs8881VhWvk?=
 =?us-ascii?Q?k5sC8iNhOUXz1kQeXRb9c4JSs+62YYE9CalrN+sv5OUGYc7rk/0txOWsu7PB?=
 =?us-ascii?Q?ov6JdxpFtYu9KyMocx2d4wt1lbPX8v/bzAar0GTDTggqGJWxNsyJxeI9QVMU?=
 =?us-ascii?Q?eYJrRz+ZPSNdRgxYbdTo4nrqVVR2KQnEhfIA3AVLLh7SFWtXME4j9fzWvecn?=
 =?us-ascii?Q?SG1xo/FWZtaThoqG7lpJ83ac5x6gzkoTpY8L64/UDPqxp46mS/Xx2w5cU8re?=
 =?us-ascii?Q?bizL2/miC3KABdn2eK5t85fhmCWRMc75OSVVgg3pMHwE/NgpC/9Bh/je8eeF?=
 =?us-ascii?Q?jBs5Xl1ZbgHrw8ulzwUErdgtxpoyCFganM4a6Ym0BLPtVWfLY2FN3sjChAN6?=
 =?us-ascii?Q?nfi/Q/HL4KuUq+EIm7XgKHcFPbDu0+cs99xJFRek7NwRpsZT+QdFamEGSltf?=
 =?us-ascii?Q?FmM0kOtQ9MLZJMt4GTmVRo8pL5hlJDaXqNIe9sPZzky5QwjGfKctwLA8PZFm?=
 =?us-ascii?Q?5FlNOd+fbzVaxxfsoZHOPgzadD//xDGdXpuMXPLD5GqRJnq4+8iRkjBORodO?=
 =?us-ascii?Q?vkNsEx+AIc5oXr2N7uK6P49UyRrhzmR8WTUwGlB2AWhJBqru3WrWPwp8qdGV?=
 =?us-ascii?Q?8qfsQqW5V+1rCanPQqK/jDG1Ek9/roLS8f5SWycSHAB+ayFrwYUIQmXUjDHe?=
 =?us-ascii?Q?sRWNhZLNFIwD7SAf6kj/J5N/8b2AkW5f/dYrb6I546+EyDZQ5GIuqnwq2xeH?=
 =?us-ascii?Q?LpUpVPNozBUzyXdpN9RGvct5xLcVgj7vldpTMhM4jlsDiiGxqDQb/0nLIJA8?=
 =?us-ascii?Q?JEalTQfOee1EtsfJXOY3UQewRpZyfCCDLY6uL8CJuNGlxUUtm5RfmwPT9gbU?=
 =?us-ascii?Q?2Lyc00WCLMSfx1ehlJ1R6tAzZ2mr4tDCo+rJi1DQhDdyj5zVzvMFanVTPYRl?=
 =?us-ascii?Q?SdCqxvS+Aj3tZPFnk/GY2q12n0/QiDip3pmJqs9W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acb49ae-1be2-42c1-fb9d-08db46edcdbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:05:37.5512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S9wou9Eyv4pjN2x7bI2BnMB/G+ZCfRm++l4jVus18Pipp8a0YaDj5lumOWVoaur2EUw69VC3KvaKmitAgcyrrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, April 27, 2023 2:36 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, April 26, 2023 10:54 PM
> >
> > -static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > +static inline int vfio_device_set_noiommu(struct vfio_device *device)
> >  {
> > -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > -	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > +	device->noiommu =3D IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > +			  device->group->type =3D=3D VFIO_NO_IOMMU;
> > +	return 0;
>=20
> Just void. this can't fail.

Hmmm. Yes, before below commit, it cannot fail. Maybe this can be
converted to int later.

https://lore.kernel.org/kvm/20230426150321.454465-22-yi.l.liu@intel.com/T/#=
u

Regards,
Yi Liu
