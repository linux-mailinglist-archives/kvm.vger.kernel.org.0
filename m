Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250BD76E265
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbjHCIDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbjHCIDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:03:14 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341415596;
        Thu,  3 Aug 2023 00:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691049292; x=1722585292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aaBDiUG1bwXMn/iXANbHZz8rL7VwIDPGVUMScKIhCwI=;
  b=QDQS+hYeTaRnZLyeQhlHft4XhAyG8EynRonoB4PqsHH0vpTdRXeZuYnn
   S+Q17qRGdqjCeIrAp5Xr6xPRPyJnH2ohur9TQgQQ8bi9TjFC5xpIdWHUD
   vRLocB+d1LZmvK7ZhZroZ5aZwRBgG/R0zAdTDYgQoqXVwaw7kWtOlrVP9
   jlW3sudZiS/UGSofbxc/pfex0/J5ozeAIa192QoVZOzOxTChNTASoPmCr
   1n5DoolUgfu1b6H8XX1At10/zTLKqbrM0/dMvW8DclRhE8VvabR3S06A4
   oyq0t2vKHgId3khJ4Mm5S8ajM6BNcmeOp2aCe1acnCbBbbi5Etcf+mLg3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="367257069"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="367257069"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:54:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="843492642"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="843492642"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2023 00:54:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:54:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 00:54:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 00:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPS2kfHxvThsi/nqifTUrinU3uqbGem8bVLEhScVtsky15uuRC6tKN9MrZW1gXPKkHnPH/A9/MU301aShusJq1371+VLWaqeqHuLsIesB9z9+uc/ZSfNRP3hFeE2Sl2sTb7V38jS2CEkNdrAMbyVbIWH29IZ7+JjHS83BFzYr3qVRQzcpQwmzB0ccbVDrkEhAoA7ffI1z/Gohp8WXb5vFDTqO8A/BlvwegHrZP0j0/2rkN3EfNfDAZQlqrYPJmdoA9plNEDpKcXb2Ilm30sMNizuqR5iKMDhIeJyv+QL8gALVSG5gxWnLrAR0FEXfNClddVEBLzXGHJwxDrpg9j10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHLqPuejsjiCslYLB8zxYfS6L8WEa4Sj5IClvACjtFQ=;
 b=A5xptU2JvggJ/WcOIrq8P0fsCj5LowLiOKPnUeFfKo+sGDMiiPRIjOco6JF/If+C+5vKo9EyvMMu87m4oTBNHY5GzBAZ9jPvlOhCXgu+Wz3U1I8GC+lNtsvyj+3I5JYf5XfrXEsF5iLsLSpw1zY1+kBQ9uZoyP92IAI3tD7xqaAaTZKoCHPzyjc8nJjNsozH/78xm9nOToj14bAiZpeviZTZALIi8BWLRqCIyp2K8RQydRlzbqYfZwlvDX/GLzoov0x1i+NbRuZvFDsSWJZqOjgqqWkt2owUFKByfdKoLEhcnTNeP8Tg6Yd5LIvLt/LxwqxdpLQuLpA6eV8wZ09GXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 07:54:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 07:54:41 +0000
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
Subject: RE: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Topic: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Index: AQHZwE5XwmTCizFL9kGoEloX5eLFx6/YPsPQ
Date:   Thu, 3 Aug 2023 07:54:41 +0000
Message-ID: <BN9PR11MB52767976314CC61A0F8BEFD08C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-4-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: 5e36bfa8-6baa-4b18-d072-08db93f6e4fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /j7bzHUokkrc25dvcGZzeqTl/tHXl5nKaEYA5v6nfZAXXLXU7GF8mftCwvKjU+y5QorX8by9k0QOSr3qHqvahH4kuTX3pruc2Cv9NCgsnMzKQo9pNLcREFyh/DWIBJPHwRT/kLCNhdMPFZRojNNHcIqnh5A7HOyu0dxn7zeBVsZbMSr02z34GYlW69cZ0rjPSLtb/oAXXciUkNtL5sNzxT4BuyZov5yoQywgm6etYpfFxOgl5dUxikslNuwZiKpEWtdwt60EJAliAyCbUtpidpvh+50ibFKxcoaqgq3o0+ur6EuLuAGQMJNjNxSEyedyhRBu71HdjKVAM9SCSmrCAlerPBtgJ7v0xfn+3oCqypU75pc30KVA2buAqQ1iDLL+GSzzNjoekBafUqppTVNsSAQ3YkK3EU7BnSxC5YbiqzPxLA31wQalFUOdrxGVEKFJuSiMeH7NdyFkf5oIbkSR8m43ZCf/e/cmeY8XujeAaTmRwncGMdN3znM/NbEiLmLMpEPPLqMhJ9sqGcaUemscrmeno7hBPWkebblrOt1U6D6sZl9UXjh6VwCn6Ta4dF544hHfVwdTaoNe5PHY2juDgG2Zk7GSwopKKXFF/pNwCKF+f0e43zGkjo+rHEnVRG0K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(38070700005)(86362001)(33656002)(54906003)(478600001)(110136005)(55016003)(38100700002)(82960400001)(122000001)(6506007)(186003)(26005)(83380400001)(8676002)(8936002)(41300700001)(52536014)(9686003)(71200400001)(7696005)(316002)(4744005)(66446008)(66476007)(66556008)(5660300002)(4326008)(7416002)(64756008)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dVr9/6zJT1RCBm8MOS3hCulW1QcG5l7w0oXTHUM0WXDgy9hc3SSMvn6X/Z9K?=
 =?us-ascii?Q?0v2PyFf4clDa5a2EPGjKQFd9AlBkfrP3l3YCWULWXVMuxxXVAnvU/T8JhC7C?=
 =?us-ascii?Q?dfhY+cbGblo7RpkXszTnd2IiWOORavatHpaSld2Z833ltTkF9HzhxPBJFDSH?=
 =?us-ascii?Q?TPfN5Qj/KeSHbG+86Coxv12BSYy1zl5VkqeNBbq18sBEpeFU42qSIMdqYioW?=
 =?us-ascii?Q?DS5FVM4B1jREmf3vj5AcDrdeqsTDma7tO2fiBaRQTK5QEWfdeGlryzMWYcCv?=
 =?us-ascii?Q?xDnW2Lb7P3mXjlpqYS8FLyzGOu1ZXVNtzJa9Z7dDxzc2du++eMRFZgWqfIcW?=
 =?us-ascii?Q?BGDyfxf+LWBnTWb4PNnhXtMvf27SpwVZdcI3yNakj2sFHsD88mR5Qf5IfUFG?=
 =?us-ascii?Q?QWs+OA7bMqP031Fk00V4vCzF8YvMRXUfSAhSr9BMWpjZ+AW0b/Kn+w4+G9WL?=
 =?us-ascii?Q?LbL9K9Bi768aJWxbPfZe9XgsVuxgd2pX8TwstoIdTIhc2SnrALFiqXdFpA+3?=
 =?us-ascii?Q?8vASD+LeSZ0G0sRkM4cWcKfSZB93fGoD2NtdxDmQRJogCSu5f7Of4KEUrjGu?=
 =?us-ascii?Q?5u9wyDc3GLDgEE2l2RPqbB0CV9W3pHGD2ULaEHj0MeuO5BSZX0dPCScBbKHQ?=
 =?us-ascii?Q?xGkMID9i3Kt65GJscpWVUVKk+fBvsiGhytekeyX8PVoUAeDyedMyNVrMnLA1?=
 =?us-ascii?Q?9vz/y94KZhgOGevNIIkG43n7ttMlxO56LDYunQ9hdrYU7jRqmYF/xolP8H+9?=
 =?us-ascii?Q?KCSAepkn+Q8KEogfPD45PqhOyAcGnOPIF0Gq5ykZgjQ0OItlOJMqSVJ9UlW2?=
 =?us-ascii?Q?gYX3OmXEWRDCrM84toQpwR9RUDBCYV2SfuLNhzhoNYI8TFl5cr3MDgIUw7tx?=
 =?us-ascii?Q?n5F3O9qhfCwODYe4dKffhpCWtwGz9aVpmawM06jC+Fa59PNhaFKNYIgbDwNk?=
 =?us-ascii?Q?k9BT6AlCzqC2PGxB0Da1bf5/1Zd/7GwKq47DI5BZEoJjPzF8AGStrLzoDRst?=
 =?us-ascii?Q?/dm3fAHKSM+tUMYTmxN/bEsrUG5UyYJIUaPlMIgfTJUeQDo3IpFcUrzmNAEA?=
 =?us-ascii?Q?xHKJe8CXYMy9Yd1GsxmiouRvb/Ud0e7hC9slfAqiyqKZ2Z9ffVrdRjK53sQf?=
 =?us-ascii?Q?Xc5f/3MR9intjCA5OLotchmUWYYeFy+4X5Td9crdZhYgTQGZivyIta1xnjAw?=
 =?us-ascii?Q?1vnfsLKUVSQNhJQRDCjpfmu4zoOnRkaQtVjMdG3tYu3yvbjsEklTRmn7UxfW?=
 =?us-ascii?Q?tgZG3D/UjvHHOq8NCFkgX1SNPRJ77U3tC6i1c0SDj/v1nchKmSPIPEXPXjg0?=
 =?us-ascii?Q?P95IyRjJjut6ep9BifCo7RTMDDQkErYd7DFLUgoDX5cjCkH3gv9cmM3m2k0x?=
 =?us-ascii?Q?RHGIN90XW5yeBHLcU0MJWWDabh49ldqxhOOT73uWc77mBK3PPK0vojTs+J2g?=
 =?us-ascii?Q?EjDm0+skWSKC2jgH3SWev70EzUkn2RFy2DP7nkeiN45So5bphXdzyCy4+/N2?=
 =?us-ascii?Q?VrAW6ICsP1Iz5pbhi/zt9N01elrMpljNwfK1wYHvuCiNiohuIur6Ao4SG0hX?=
 =?us-ascii?Q?iWjGcIBPTVps81tCv2W3SdnhUNO06Z5AozzRcKUI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e36bfa8-6baa-4b18-d072-08db93f6e4fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 07:54:41.5584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6tK+USOrB9OMJ4lui0N5sQqVYDuPBWdKnvc8ZVLp1u/WgyCLlbxdZabpum5Jr/J2M/YVdgRtD0iXYb+a5TLaNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:48 PM
>
>  struct iommu_fault {
>  	__u32	type;
> -	__u32	padding;

this padding should be kept.

> -	union {
> -		struct iommu_fault_unrecoverable event;
> -		struct iommu_fault_page_request prm;
> -		__u8 padding2[56];
> -	};
> +	struct iommu_fault_page_request prm;
>  };
