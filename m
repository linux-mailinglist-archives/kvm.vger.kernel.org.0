Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD562EAE8
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 02:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbiKRBaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 20:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240815AbiKRBaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 20:30:19 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D28765855
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 17:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668735018; x=1700271018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2YlsP9jnpaTkIXoYCijD7a0VtJE4FvpDe57vfIGZG2E=;
  b=WiS2D86qAisH6Gt/D/uQp9GiCSYItE5VYFESNdV7srVfJj+YVFRojamU
   +a4Kc+wWlOz2klb/AZPx4yM+vMbId3wGKieO8BUvYE16eb66qWinovdvF
   1U9PaPVlVrCXy3ZxqCLIi5n04KIFw52T1YvWSS9XK4wEHi8qJKEYBKu7T
   mJxTlxzCioX1D9BfJ9gaWKD8vKt2pCR7gmGQIXNWrMza9oDQodPv80gA0
   3GR1RqlfSq+AV6tGZDjxsY5m+vPoJVDTUJ/7+MPuB8xIskhwaJSaarC7h
   OR0c/JiZa1XuhZL/y0BPSkQnfpaL7+oGqw0XLfqrRPud/aE7Sn11pgQs8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="292726546"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="292726546"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 17:30:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="708853297"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="708853297"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 17 Nov 2022 17:30:17 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 17:30:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 17 Nov 2022 17:30:17 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 17 Nov 2022 17:30:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeELuejdinvHKURBgNJqmq1btCnmqRa2QdBEyTzVCC33D9Hk+gdYTotqUbDOPV9+YFQN4Lg6VQsqNrhWEQV9FZETUwYeS3w5y5QcmsRVmAtv4tmBL3qcmizKoYHTVxS+AIUWWZIRGevplRZZUyJuvPDoq+ngR/hPNQFr5fEeV++gsqnI23II07BjHk6YJrSR5UiLMw5/L0rNweSUWrl9zWnOE+UZIeZA4Vhg9E07WowOq9dmp95ERhizM1LQipQ6lPLB0smALb4/G3GrRpzHAVKr8AHRcIMlMb3l08j0hZ/E7Vj0j0fAsFkMFD68VbhgOIib96XeU7Lvr7cqjayM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YlsP9jnpaTkIXoYCijD7a0VtJE4FvpDe57vfIGZG2E=;
 b=Eu/mqHT8NTXePgelMsjA2boFT2PkzbNc9GhjlV/gXhTx3/gObJdi/Z+aBCRevMqDhT/h/skjqQ9p/T35OT0fAkZnwX78+3jH8bupfYFOZxKPEB8wVv3OmhUBxvllx9+gfzSGnaweBy8wxz34DCtc29uPjWVoYnYbyEq2af4XpCmfHX5u5IXJBvYWo/2EU65Fxdnw2t1s6XV2k562tgkN9rIepG+pRXtIP8sRSPtucH6VUhnCOMwrU9+uj82Y3oVXLAEslVquULqxSYyUyCqQuMWQv79p11hazxlBUDZ/klnD721QaPHmMjKSM9jtZcXWnhuT8cs5AZnwuS1ITd0mkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB5180.namprd11.prod.outlook.com (2603:10b6:806:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Fri, 18 Nov
 2022 01:30:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::9929:858c:3d20:9489%4]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 01:30:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 07/11] vfio-iommufd: Support iommufd for physical VFIO
 devices
Thread-Topic: [PATCH v3 07/11] vfio-iommufd: Support iommufd for physical VFIO
 devices
Thread-Index: AQHY+gAzS3lJUt0WfEWeBo4rylbP0q5D5nnQ
Date:   Fri, 18 Nov 2022 01:30:15 +0000
Message-ID: <BN9PR11MB5276FFE05B51FB2D4085A2328C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <7-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <7-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB5180:EE_
x-ms-office365-filtering-correlation-id: 584f1ca2-72d7-4730-b75c-08dac9047221
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hJMOw2sIsljxED8ExWgY1svUXEJFPr3wg6LpWxi1bbB0oqto+BtPGjUtbyJ33xqRF3TkSfW6wCo/2Y0LdvWEWfrcR8pLEp5nVMInNGKy/G4cS6EL9r+Tik/2vH8U6hNR7PZv8EB3tSaoJl4mIhRXX5WF3RMXWTQo3WaDbPpuMsaz3WeCQaRrm7+TmgxFZuhwmfgjONravvDVaO/mx+sMK/iaW9TWj2suDLQEqEPISknUU73yywytTYKerPv5ygdWjYgH//R6caLoojC0EkxA7ewsm68D6jSs6kNqpXawVD8xaQF1Qi4vpBhPyf3KLIsN0Jd+xTUCBy3gSxvuIV6tVB5pmewU22KHzbsrxtqqV94kG28LWg/EcWMPcz+5kRIp5+cpmYXFNMVtORm7bN+PF5Pvn7XTOZIKiVyVCnEoK3XAh6hNCHNVO2ffFeyhp10JaUcQXL/HCK3UTOrElezn6AzBmNfj9zPhIN9NPNGdxPJ++M3+3Rd4lq6rh03/hU+ogorlvKXwep8wRyvmFWs2Z3zkiWwExds0kPkMozRm8c+Z/FN/1wEgdHYpdbhiy07kj4E4dwKq9QQ8Ih0CHlQ6s3toYmixP2E61vNdoc2D2e2RCxfkTKhezEUkWWKG0zcvjMyg6zgZyThZ2pLxhG3TI42ZER9B1v9IX6m6Vnv6XMT3r6cnuRho2hmC5b56gq25
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(38100700002)(55016003)(6506007)(7696005)(6916009)(122000001)(186003)(9686003)(26005)(8936002)(2906002)(41300700001)(82960400001)(66556008)(478600001)(8676002)(316002)(66446008)(4326008)(71200400001)(52536014)(66946007)(5660300002)(66476007)(54906003)(4744005)(76116006)(64756008)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ehk9e6r2pe5EB4PykV4CfrO0dPbiNxbd8xULVpxrSyuxPosAG0z/dv23e+Yb?=
 =?us-ascii?Q?RxGM6xTyMMtB5biY+NTa7tlqMmQXQtOm7l4wcSMOxQekBqlwuS9WKYwx5Kf5?=
 =?us-ascii?Q?+E88D4r4m0MKqlZunhgkG8/vW34M9UW26eaX9bIn6Sh+7OPju2h8UEifuFGe?=
 =?us-ascii?Q?vsy8ffIZGN94KYqqitRGr8WR4p1Sn8EGYOMqNwmp720DM2jLO70FpydOqkpy?=
 =?us-ascii?Q?C2YP2Q93YRl562cQP3298UV7kkCin+Vj6bkSH4VzgKMVInPnWR9vO6C37kCx?=
 =?us-ascii?Q?jx2MqOpoEJdR2q9LkVp/Xu4WwAH6DeLlFk8CgQlu7VtrKa21aYiXaTSDfob3?=
 =?us-ascii?Q?kLnIoAC7K6acC5iQnX8TUfmEsxS5uHhqlFQIZo78TJt3e8Yp9fi5Rap7T9om?=
 =?us-ascii?Q?wc+yy6bCQ8neJ8eSVkdIk54DgfX2n3+dveHkV4iEbovjJ2AhVjRUBBw89Yu0?=
 =?us-ascii?Q?q/+sD7Ub9/2JH8V9C9ntVjnYKuhID9piZDLKM/vCKyZM54/NGPOaNF/SggBG?=
 =?us-ascii?Q?r1vwuJWWH+uoLeNrLPHSqj/1Cq2ymCI7hVRxJek5Y5pTcmE8k17O6HkxKjIj?=
 =?us-ascii?Q?FxR+lQTqPl53CdBBahzpht49JliD6DTZrXhH/rDxpERKqVSg4WhatCGtRQOQ?=
 =?us-ascii?Q?no4EDZONM5A1b8lK5DZIFrlU2HxgA70bYwE2/TDGWszvo9QC+eI5yStG3Ht2?=
 =?us-ascii?Q?Jdyb2vRMuyToS7UzfNbSME89lbZ1ck/PYrI307HF3YN9R322J8CE70I3dEz1?=
 =?us-ascii?Q?+8on1ZOnjM+cprz3D/iMr95c2DLdX88oIyd7g1n4Sre1EMvqfho0T7h3V6LN?=
 =?us-ascii?Q?x7evftvpNNvuX+RQTLwZyhpPngllpPKGUzVFBOIUN2K50dkjSUGUy296dwc8?=
 =?us-ascii?Q?NPCRo9h+9++BDeBEOcxpw2JFa2vEkF5hMf84m0H+M9v3MWTSAYXZ13CFfRJx?=
 =?us-ascii?Q?53mxVeN5oSxZnpbxvEx43MSdPhcN5h4fIphOJtnnFvcVr/72I6ZM+eRvUEAi?=
 =?us-ascii?Q?zAqOjpK4sGneG0K1u1/HF6YBtaSaN/cP4T3T0V3U8/qgffz8eZRvmIgi+vZ+?=
 =?us-ascii?Q?zOPFPG+4CecGKnK/JncnXj+CybjGw0wdkuMtQytdn3uWvaPaxAmn+7t3nNiU?=
 =?us-ascii?Q?RJXwOiRdUSb5Xdzkgp6b7AV+N0Pz2jt3xcLIz39mtlZv+phb5ZBSAGaq3LYF?=
 =?us-ascii?Q?YeK2ZpsECiL0mUBpHMvSVWkTVu81OohdhtT6hNuXd1/Sj8CSqC3L1k4uHIpB?=
 =?us-ascii?Q?sNL+DXZJEyjarfHplVMCGuFGQSyS+jp60jlCbEDZtsDQ7ih5nyqkf+tELM0m?=
 =?us-ascii?Q?zYJM2f7TX+YXTo57BnL8hjh1sKXCaUmiqzJcEq2VwG/61huQhBWqkk4B5/yt?=
 =?us-ascii?Q?CV19WM8hKNTbaJINkoztyva9TYjuh9zgg8k2k6qUNeGgpiTYRUyOEGSYMHLj?=
 =?us-ascii?Q?egqTv4lhWF0BYJrVwWOExvc/AEuzMVjFWbWY/fXN8I1+FY0KZacROqVvYm71?=
 =?us-ascii?Q?/2AN5GA7KqIbbBP+KPBUVbMJyRhYMY8SMWDLtsSMLjlhqIOnjOgWi11DzZN1?=
 =?us-ascii?Q?vDs69B0jW+ZyQG80POmlSvvVxmuRnzteQG4yvkL8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584f1ca2-72d7-4730-b75c-08dac9047221
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 01:30:15.7742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 23N+xLvhuRfQrrVgNcYjRuA84Wq1ttlQCH8VkJ+l7ErTd07WDSWwG8QJZMxtdkgRBK52qSqCaNexIvV6nronvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5180
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 17, 2022 5:06 AM
>=20
> This creates the iommufd_device for the physical VFIO drivers. These are
> all the drivers that are calling vfio_register_group_dev() and expect the
> type1 code to setup a real iommu_domain against their parent struct
> device.
>=20
> The design gives the driver a choice in how it gets connected to iommufd
> by providing bind_iommufd/unbind_iommufd/attach_ioas callbacks to
> implement as required. The core code provides three default callbacks for
> physical mode using a real iommu_domain. This is suitable for drivers
> using vfio_register_group_dev()
>=20
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
