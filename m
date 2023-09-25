Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B57AD083
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 08:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjIYGua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 02:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjIYGu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 02:50:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD13A2;
        Sun, 24 Sep 2023 23:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695624621; x=1727160621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dGE3joJunOmNIjST+CKvuc+/dCZWI8qaqJo+JzfAO38=;
  b=TWfUgoJ+sKNwmRm6pSzRVOcsHMTHgcjRcbNENs3gdsoPraYF7dsTb9Xa
   qi9JOAKOc+ORgIvghm4rdu39BJR7XTOPgODUiZx4S1jw3Ipyx+RIbX1qA
   ZCoQ4xKzCNjHVbfyD7b6r3W0rrD1NGu7NXjIrDk4YdF6PcFHq8mj/oNr1
   33OiVldDv0XXR4bw5s1IYxNPbNuX9bpDXqRv1wpr8oJGwMSEokDZ4RXuc
   TNsQfSWES+EiY5cTmtpKGuv8Uo2XPZd5BoSMXNjVK3suooZk4F0gFV3fY
   8TnZAEuPd6kKSk0AEPNTy+ng2ZvjrNsQR+l0YyjKNOeLhdknQmrDVt5zq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="383941116"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="383941116"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2023 23:49:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="741810568"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="741810568"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2023 23:49:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 24 Sep 2023 23:49:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 24 Sep 2023 23:49:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 24 Sep 2023 23:49:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A57n5lYSAbCyCr2DPJBqtkjqONrzSuVHJLRLSJ42bT2MmaqxQT5fr7hW47QZIZ3DgMbvsPt3S9Yt1p/xwQtUYk46j4m+LOqBHx+dNIxW6wilRFd/txRZDJw7pYvfjjh3pn8I3AZPiPNPS3Jc0u5VcQwKAeLQTwWx1yQ3O59i8U5N6Kpa2t0vWHUY3wxloy6J/0VXGgvROfkOYw+jB5ahhgeipjGo/CYqmQjZDqC5e0KCPno04iyrcOV693e3FzK+e8gebliSlO8CMXoXpLVZRNOV2wjUdgAt6rh4rgTyAXbhXACsYRezONc9BUOazBO2I0kI1i4Tpqaz8hnOMUAZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGE3joJunOmNIjST+CKvuc+/dCZWI8qaqJo+JzfAO38=;
 b=cV+kw0albpyO0mnFyTa2fSdpIeyF/Pm0S819wzIohGGvwBNpdF8G5KTsfa3ZkPLZ0lXE2YRssHA8VfUuLCcpPb3jflGNbIs58QzGV8lXCVohOelUMIDouY0mvYfoSgKPIL3gSaudVWCWZgJDbqn/zqCJh1NheqfiucUy46wvyuRDID/++I+VOhaw8zpdOVWGzLsP/xLEefPrr7hR/5xMrU2UaqfuO5U66SOswsiAmU6yiYOaZ+CStOYXX5L7HzAd49Kua+6i7wTSo5ESK8dpQz3IIGcS5hvqSeGHuml31UsPVGo+HCGGTa5b/7cWcp6nGvaKYsRpzVueuf9RgUU3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB5556.namprd11.prod.outlook.com (2603:10b6:208:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 25 Sep
 2023 06:49:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 06:49:04 +0000
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
Subject: RE: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Thread-Topic: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Thread-Index: AQHZ5unyZ2I6PTvmrEWL5YfID2rsELArKpdw
Date:   Mon, 25 Sep 2023 06:49:03 +0000
Message-ID: <BN9PR11MB527624D70225AB2B4DA89B3C8CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-10-baolu.lu@linux.intel.com>
In-Reply-To: <20230914085638.17307-10-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB5556:EE_
x-ms-office365-filtering-correlation-id: a269250d-f646-4178-d3e9-08dbbd9381e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bR/wPyR11+7SwgDwgzZtkey47otbxu9BL82EoDWTLXxVjsQC14aYE5eIggBRyEKiHbWso7myvjxJyDfwTjE0IpIJVIPdw5OjQd7ZQh4OrWI9ATPj62bvXxSWBkm4wGmNEfZMo4RTJl7Qqf5eayZcLa2dKGtwlqIAEo6gQFwXLUTlfHI5uOwVMHGGknxZS1dzSwu/MnrHLXKUKgD13ZGx5cj1Dd/shcFgP/1eCmcM5vtSMirzy1MTXR1I30NM26exHpDK/c4xtdBVCApRdGpELDwuj6cmLtiNOmqvD5KwjTp+X2DcyNR6e9WVYutGdGQPkWnwmWqQB+/5vAh1DrpHFWAwuknsozux8vR8CzlUTSJSke/l/E4M6D1I7V1DwdMvPp8wn6G5g5CkQk5LkZ5Oe2y7TlkTmd70e1jj9QfgOUFLH+LPRhvNEfKjU8t5zm4LpSZfTtKFIJdZdjRhqf8wsOkk8qel5PwZgAQ3/PsNem36SMOkKR4FqHOnXsexK7J4MkL5+mRu0/P6azBPeX8G3H+rZ2NtJlU+zFCPf3Fx3yewEbINHw5OphcFevvlUyl4zW67s6ygk+nN6OKFXLEJuGjSHxvD2FGHrZDu12Uu9wUJAY0kVNLVK1pB///ofXDEuCj7txvhsjxwu03AKr5ORw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(9686003)(7696005)(6506007)(71200400001)(82960400001)(122000001)(33656002)(86362001)(38100700002)(38070700005)(26005)(55016003)(4744005)(52536014)(2906002)(110136005)(8936002)(8676002)(4326008)(41300700001)(7416002)(66556008)(66446008)(64756008)(54906003)(66946007)(76116006)(316002)(66476007)(5660300002)(478600001)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UAfgQQKRUf6SwbIUbCM3+sb+dTr73kJR72Yw6kTKbKwvWN4bCDWDzaUq4lV+?=
 =?us-ascii?Q?iQ23L94h0Di587Wxa/CaWzj9erWSUKvXx5S4CtbmeJy/i0ATGWhW6N/RGZuo?=
 =?us-ascii?Q?4PGWaYnFldKpaacURL3wylqdP08/pZ7S/d9WBuefr2I2cvHdgH0nEjbUxOLE?=
 =?us-ascii?Q?zwzYLfzshq1l0/ZoNo3W+CVSGwlV2H60genZSJvAOR0BnLludCnyGXvhwSXL?=
 =?us-ascii?Q?Kzi5/m3te0z8FYOFOBdLZZGIXyGvVgviQCrzNwCAaP8PXsjzAqe/KR9vJp6r?=
 =?us-ascii?Q?cflNceOaS2deWbR5dOef8Biyiu0hrBzRUbG1M1IbYX71c5SZ290O4ufEIQKv?=
 =?us-ascii?Q?O49AiuO7G6hMdM9c6QWrc8/2GowFo7CHNEMlRnfW0KSkgwVgIKRfvd/GT7N5?=
 =?us-ascii?Q?XoBSNW0xgtc0K7ZEekc32cSUPoEdQHTOrhdlMVK8lzcVflKn5HjusqO6GRwd?=
 =?us-ascii?Q?1qFtIYIn5fCtY4zjLQ8i374eWYm+zADR0bWXdXZMJSebKk8xtX60iQN4lJfc?=
 =?us-ascii?Q?TquSovMaWiDpv/Lpq8JAZll4aJOrv0vqNHrz0PR1B1ap2ItFltZE90F69aVW?=
 =?us-ascii?Q?aF/s7ukHv8d6fF4r+ChXibJbz95VjaYWkcHl+TuhoT/0vT3tJB/tnDigfIEl?=
 =?us-ascii?Q?xlLvQpNDV8s/R+8JoVu0sIAoq4D6NxfnaIF4em8mHKDVEfcbcBT50QudbT+Q?=
 =?us-ascii?Q?1D0R+7El/rwotB0TU2nPwM3Pe9O+KxFJA6B0JF22/bBlHrxyeySK70dhCMj4?=
 =?us-ascii?Q?VGiZCVYMum8aB32kgl3KgEI+5PHBGW9QfwHBPi+HXv1o8UTAETtLpilxEv7u?=
 =?us-ascii?Q?yZxXdsqe0l3eHn5K8R48q9VuWkXasV4XgHmhqtgqQ+KZsSgKVNuf8wjQ3jPQ?=
 =?us-ascii?Q?S3Gm0hsaiYQUjct/C7VHDNmKLUMF0siSltf9GsCi/nahMMnx/3PF31H5qNAx?=
 =?us-ascii?Q?Mf93DGMW6sWCpbBnLDFSeJAvthe6LClweFAvrPkjnR4qYfeN3dqkVB+Ypr3R?=
 =?us-ascii?Q?ATpv8v2kwL3WBVOgp/LY1zfGQnMi3ExQLnAPbTAgcc8i/PNQq8rP8KiS0Pqs?=
 =?us-ascii?Q?uFDS1mT/lz5kJDYqWJ7udsbDtqOvMHtvs7YMrNwBOY14kLzm10wYIgE23n7N?=
 =?us-ascii?Q?kfPIKGYT8KqihxyXo2tq6EM5iZIbVX9b9+M5VCM/muMRQ9i1J/NkPayfNOsi?=
 =?us-ascii?Q?BPQPUT7JM6DvaiQx27G4QVrYUH0cc3ig+6GUoa706sEqsAEHlXN02b2av0Gy?=
 =?us-ascii?Q?ZGJch2g71htTUsdG7SP2uPQNTbyKemWNHVfnFVEAC4ng3eUbYw26gqFJTMBf?=
 =?us-ascii?Q?/klwQycnWPYaKtlFhzByDezRw5oMUIGE1Zwcv8Uhsngleg3GuCNVTLwHNb5M?=
 =?us-ascii?Q?DVqg14gs59J6OFqcct+Ppnv3sO+jDaHAC7o26lad/CUA0sD1FunmKZdt41j5?=
 =?us-ascii?Q?62KMx39m6p99cg8DxVqUMf3FQ4DerSdYbOcamlKXEmNbvw+ZA0AojuV/37xD?=
 =?us-ascii?Q?n06EvOiOmt5Nk3Pv6zfkZmRmVBqaPTA8VMw5b1rxvvm/lc9HSTJoV1svPDpa?=
 =?us-ascii?Q?NqNAUOUXDsR62gBTrcHEVBJw0qFcXVDVIi+aPBfk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a269250d-f646-4178-d3e9-08dbbd9381e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 06:49:03.9726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXQcjH6Sn0mByGovXU+rwvusM5Hh4dZXUluccxkNyVfzFOsnYeogXONtaofZqjyuFNb6rndWazS/fWpp3qvCfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5556
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 14, 2023 4:57 PM
>=20
> Make iommu_queue_iopf() more generic by making the iopf_group a
> minimal
> set of iopf's that an iopf handler of domain should handle and respond
> to. Add domain parameter to struct iopf_group so that the handler can
> retrieve and use it directly.
>=20
> Change iommu_queue_iopf() to forward groups of iopf's to the domain's
> iopf handler. This is also a necessary step to decouple the sva iopf
> handling code from this interface.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

With the fix of domain error check:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
