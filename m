Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266046BDE80
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 03:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCQCOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 22:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCQCOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 22:14:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524DC618A9;
        Thu, 16 Mar 2023 19:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679019247; x=1710555247;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vFtXG+Q3L4VmeEqpEjA5nJEZicd0bSiBT3OAhd7WWMQ=;
  b=WGRcr9zM3jrMqmbKKp3h+2rPiaIG7KOe/SjNrV3DvWXWG4f1p4b1wi+v
   DphurZ9LQ+bHnHmzzZp+Shn9WFYS7oZwnlxfEOFqGGTWszlvFiYpPtTY3
   CkGSP6C1yLMz3RMYdw/fPLJmGMKCwlRnKYobkQaizezktob6Vgt7o8W92
   tUTE67ZHb30SNYpTMh99IEDDU5XrW0YRJgmT8OL1ZMfGK5J5IhTrtys2D
   DhKu4Fek0qi4SyT5dJUNE9Kxj+FzK9nof8SBlhCkrQX0XPWSs1ki+8sah
   gQZa7YRSmP7TrcjKvjfiTYQZpxrbxxACHNShHy6qJdUiVuL78n6HpS0wW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="336854853"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="336854853"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 19:14:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="744395567"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="744395567"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2023 19:14:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:14:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 19:14:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 19:14:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQKkK3IP57STEu5bZqB4GXl4U4EsWf6yxqilYDr5sovmr6MEu4z3n/aBH/higUtrw5Y7ujXmvfOYb2qDRe3kb++giwByzwimF0GzIQ71kuKvSqLkEdAbfWWAvcadwPn4oKQVuxuzvS1KyXwkKzaFYihA0NDsnw0V1AURDHWdXmn5aunYruS+Fky8EZbHIRuH9YZphNwM+3J4f0e6+X3Of3YVXn5biYpKBWtQMDT/HKVM/0f9gLOavGRaW1/ccOm8cYsp/7xKpCV8FCX+mpOZefYRz6RGsW0ITv8S1wRKO9ZL4/mwCUNz2k2FJg/B54SgDZDfDxIK/0XYTbNjOuALzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MVbwY7yPr1HqLnb3dOVu3JCe7MYcJBipTPXCjbHNyQ=;
 b=KB6rB14c+fWaGfJfPm9MfchpJ3yveO9eajIyzr1vHF6CQuYIx40BRFKBEfCOwsjqcm6XYZT6ZOkaNSYKyZQdkXg6nf5PCarhTO3/OZW0FI77mJ3DI5sMOD9Ud2aNvc9u+Ig8r21Ebb1BsdKv3CqSq3i32TLS+jedG3wTfgQXVhM2nhJJczi6pRmAUtnCYVsIqrLtWOYtcq1GGZzQZ2PYv/rbxNhwB+VFnUnNItUW2/Z1sxS/cjfta2Shod+QLIZ7W0F28q5DP+3IRLMPt+BIX6aE8P9utC700d+8IMH2t0vawRzNtwM5bsrOwqYjmYISJ58G4zZUpst4OoTbCHdCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4822.namprd11.prod.outlook.com (2603:10b6:510:39::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 02:13:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 02:13:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZWAax3HHdmgaIcka42QBoWIvZ1K7+O3vw
Date:   Fri, 17 Mar 2023 02:13:57 +0000
Message-ID: <BN9PR11MB5276399B61F4E2E260BFFEBA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-16-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-16-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4822:EE_
x-ms-office365-filtering-correlation-id: dcdfee54-6164-45f0-18c2-08db268d4406
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: noXpngP7km2jBb/p3leCDTpebdJF7Gg6/YqPULkmq8ldBIHNoyuUcBvSbIg6gcPzk2RSy6Zaxg1jsNMssXlcaP2ohj2/ua6el4kK2m/X7dHls9JwWpoqNht7gt52IWHEeWaDz2KnY2tnWaCCU1PZnH6YzGfGacSb6fjPuMmxf+4yMWoKbClEa9SjcPCC8rXPr5oom4HLR2b8EWl3z5s2Xh+cBXZ3tDojJpX6H1nn7iieq2tSDTddClwapOqT9NRvZLGLTjeIvWYoQFPz0dBVqJZedl1Mm/bp9PI61iyvXnRCDXXT5ErheswSRYJ2eCG6j8ORTInYvhxBg/D/8GztKS/WGTJrkzRhLTMnhMDoYRCZ9erc6eg46xnqyFqT51C51Myj19J20qwyPAZcePr5ORakZ0aYgiD+LcanQ1H9/czC5oDQxh8W9IZ6qkzlyxZ+yeS6/6WDLsBM1/D7LfhmRxe/wA2dbtt+TpS2YHUWbT0MTqWQ3IsArCOQWss8+wnkPE5uecCKbtKnoaYsQeu/LGaHMMBuj8rTrSfHt9KS2bFTk4ggc91VF3xTZ697+1cG7FJc1GFmuwJnpRLvn37GVM7aRGfCjy2Eq9I9UEI8mh2AvyIUYXUjkx4pm0NI+dDxm6J+asAeb2Dn4yCmxTb+09PqCYA3+kU86ujRCPgPScoLABUdXMPbIM9WVobMRNdR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199018)(316002)(110136005)(54906003)(83380400001)(82960400001)(55016003)(33656002)(86362001)(38070700005)(38100700002)(122000001)(478600001)(7696005)(71200400001)(186003)(6506007)(9686003)(26005)(8936002)(5660300002)(52536014)(7416002)(41300700001)(2906002)(4744005)(4326008)(8676002)(64756008)(66946007)(76116006)(66446008)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GAyrAwp019SzjWATKqXErHuTBYXwn3AZHALGG1fJu+ucrQ49HNpQp1MbwJaz?=
 =?us-ascii?Q?pdS0Up8JGDRZC6foCDrNVV4NiSrWognqbUkfDcbXEDGfCT6Mo2+IG6N3CUPr?=
 =?us-ascii?Q?LoSvaXOTDfZfPkxscaR5SycKEZVTEdZfVIIEi06CSnmrsut8PFCTkyElJacQ?=
 =?us-ascii?Q?/fqlAnrE+zqWQPrcOztledGLPhzjiYUp6MSwPClMCIynyc99isN8uLzBj3Vv?=
 =?us-ascii?Q?ClRiD17G3PGWvmzycYQk10JneTc3i2cDypX/i6QJh9eZEp7sVnKa350T5fFp?=
 =?us-ascii?Q?7V3RU5y/yAezcK9UJyIuHsaLFGadSSBZPLqpFszLKnWtf/gig0jI93C7OpX2?=
 =?us-ascii?Q?3qyDl+FQkMip7zWIyLPIyvhY2dFKz+LDq9Tya77Wsn/ofe5suGTCVkwx+BUL?=
 =?us-ascii?Q?rD4VbAA0uYZFvRB+w1l7P69YTr7r7XELG0nlJXCzPLzhHUqlR60FxOfWc+Uv?=
 =?us-ascii?Q?3cHAa2s/hAk+dgoEjy5m/IcIT6nKrFu1mbUbyMAuvrCrw6h/mKDKKrnza39k?=
 =?us-ascii?Q?DLWoOtK9dD1W139ANkdPH85YtYW9MCj7pGh3DEUCBu+oiWG4NOuUFUR1FoBJ?=
 =?us-ascii?Q?fKH08zLqLO2wbrid9uKFnejkuXso3tqBEWUTRUf0oMeGfi/LMvhn4TF05rbF?=
 =?us-ascii?Q?+i4Fmuv2Ly8SUTFmHuOHL+uSxccfm1SinFkUfGGaxHNg1DrsMw0xx9NdXto2?=
 =?us-ascii?Q?l3dp8GAbzSqMK/F1KkyeyVaP9lkLlzLfFYKnXfUzdksJ8vbc+tmYKDJQu98H?=
 =?us-ascii?Q?3z5han5M+7qCKYtNn8hW7edLMQ1DUWFKeUGdrYJ9RDV8zCwH2o2CuHK5WMVl?=
 =?us-ascii?Q?xGavcwSeFTZLnMjRkW3V7CmceKN/pjQlMM8am9UOIeeNdEbXLZ+cFu16rdV8?=
 =?us-ascii?Q?wVtlcu7PWpc93mE6mKkc8NJX+uPhG723qK7q56uhMxYG/DFwl23CSIGg62c/?=
 =?us-ascii?Q?NuRYfWenNFazIc0R/HjXDyo1BpuYZ9Igl3vczzcN+8bZQlx+gVPWw6qtjT99?=
 =?us-ascii?Q?CdgbFZziiWsrjUSu25IKGekVy6iY4Kow/BfbTXVt1YMWIzGirDuqlMjAyMoW?=
 =?us-ascii?Q?OKjzn+DDlinDcokNifYjNjV4PHTAge8Wr3VCy1a0IAgu/sQ4iYzjVQJPbxW+?=
 =?us-ascii?Q?oZx1tSrk8auJMcBJF5F2BJTBKQG8JV6H6rF3bprnS6h7l2thgLymsvV5Lo7Z?=
 =?us-ascii?Q?x/CTgPcEqXrt0sGewpnnuu1I+/0Nm0AWKkqBt0zdl0wEFXlob0Egc+gdDBbE?=
 =?us-ascii?Q?LkREjRVWdrjjvIa620bgaPMp+v8HK7v2vbd2IUe+rLP8UoHVh7HO7Ko0oene?=
 =?us-ascii?Q?IYgwzHQQZ8EsJ+Wb9kh0xDiE7W9KiLe+30N1igCB5B+6E6TPw9QjKfBHZSCd?=
 =?us-ascii?Q?aADojKgm/M53C3zXgl8Y+FkboWYFwev5/NN1V1uE3KPztPNVxlMzQ7hHLQgX?=
 =?us-ascii?Q?VQaGDEoHNqaw/3v90LxyFi53AKLZmhQ3ht71Mxda3/I10XgsLlTgkNdzrh/A?=
 =?us-ascii?Q?6aVsP6lyBepHmN/0/08sRit6EE3t66WnvF8Bn4pVX+MEVHO+4AOGjR5Si6cY?=
 =?us-ascii?Q?PGlTe4NBu+9KEF8TXc+WSQ5O5JiGgkcmAIMVF0Te?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdfee54-6164-45f0-18c2-08db268d4406
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 02:13:57.5927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kDKwoSZuUgHJBrM1Xz90bsMC8WoS/+bz7B3kr0v72bHpsAiMsm7bQNwh5Xi0SNUSLgQhCO9PUcm2SRQQ5xJhSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>=20
> +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device) || !vdev->iommufd_attached)
> +		return;
> +

the 2nd check shouldn't be a WARN_ON. It's user-triggerable.
