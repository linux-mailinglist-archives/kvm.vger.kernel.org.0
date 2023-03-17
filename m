Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF516BDE5B
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCQB5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQB5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:57:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924C674DEB;
        Thu, 16 Mar 2023 18:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679018250; x=1710554250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CnYn5qV4vGujhpXvsTgQ5s9p0090B6op1kh6ixsQ8GM=;
  b=R4sQngS2+WWTBuAyaL75J1zCKbgiDpxrrfMEP1st0tVztEbFt8AQo0XO
   GnUYPOoucIM3OSwf06RsrYKp0gxfK75PDo9hJyZu7faD2SEA8z9/EtUOq
   SYYaiyJtqUBG33ZsP1O4j6fW6ZA9ijdP2X4d0jE2fgpDWcLVzRj+Zz0J3
   v5cgj5t/hz0ZhUgfj7AYR9gBsfXXnvG9oCo7j8BIZ1aYmas5ViO/INcJ/
   bMYhrAcVCTABz1QVO0dnzKC4YJvHoTcgB3ngnGtTAIOITaGH3otFCxTBH
   U/jbm7Vm+oZnl9SCVc424hS0N+AKmZFauAUkMisnv05BQ+qd9aHKcS9w/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424429265"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="424429265"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:57:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657395776"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657395776"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 18:57:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:57:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:57:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:57:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8VWbZd2t28qhHF1VQocQUvwip6SGTLAxR3Mx3Gb9jdLkxA1kbIizWaszO9DRoDPX4u5XCpfQoumRgiWm6Pq8SYvK9vdD9ki7U9aG0cz5bJXoevSgpNw1M7xsJk8PSI1cWqxKDm1U8BYM8QwCCkcIBDi3wMg+SIFrTC+IfC09fTYwKJdzaHx3Li+EthMTbQFCC5I3NZg9Jt7XUrWbed3GEEa6599oXSgG8dhxmMf8wHvn3mcmrbTRd7laTj03otef/jctdxnkWlyfql9C5rbxIjRDZcusBYvcDagyhHtfxrFZ8o043Zs1gWMfJoi1a+GoCbK38IPdChyKWIJHqpIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnYn5qV4vGujhpXvsTgQ5s9p0090B6op1kh6ixsQ8GM=;
 b=a+oxdHBWvu36GMJdoV8UXP6EdzsqJsAF72j+FSvWZD6suLWGt/pjyE8aK5ZhT/b90nDW3G09z8Hxjmsl2+I2V4ed5dLa4uXcgFTVKNRgjrppvlAenJsXE8lZ3we1BljWgNM3xHmZzRg2QRQsD3Wvn2Sp2ptouGMibnQKJCH4ipphvVT3avDApUtgWhzSL1q1cAfW367EayVpiIk8XXsMvF18OM1VCcNS33gz+v41Hdc8nxxo3cqJWB+biT4JsXG7+Qrd8C8+jz7gh2mGByhNBK0eJHEvPUiQbXX1RHIw+rD6TgW+7tgi5UEpNScnFs+vl+mXsPI/8tCHuOLyDD7ZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8209.namprd11.prod.outlook.com (2603:10b6:610:15d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 01:57:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:57:27 +0000
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
Subject: RE: [PATCH v7 13/22] vfio-iommufd: Split bind/attach into two steps
Thread-Topic: [PATCH v7 13/22] vfio-iommufd: Split bind/attach into two steps
Thread-Index: AQHZWAaqS8YdpLh2dUOR1RnXAcBKg67+N4Fw
Date:   Fri, 17 Mar 2023 01:57:27 +0000
Message-ID: <BN9PR11MB5276FB4F599A8325175F61208CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-14-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-14-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8209:EE_
x-ms-office365-filtering-correlation-id: 21aca7fb-9de5-4b88-edf0-08db268af5e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qi5+qpCYtQIooUZ9SY+5UD/ivQUIsaWO8oOWDBBFRyzCW0Qi/IiACZ4jW15iUMUkYOVTXL83r/wFm5mTLyw4OVFGUPFXqJ/tRx9TTS5CADNjezuGGskKbjKTQ1TxJ/fNdlgHhY63QgsPJ2uwKn3RtFK9uVa+4Z2oblfdAfPowhSGxYlwlGUwADmoxh7JndwkAmKbl6JgOD+TOKttvWqeNooUg77uK4n0n9i7mbB63YzGdDjKSmfdpjtspH0k8Y580HsPWN4k7ess+4mw5g3BEzZUP5DTXsBPsgtMjUwHt23aeBF8GbI3hJ7PjyF8kf8Tf5FI4vlosxCBhkf6cC67Gy1cQVrtvgLdWvfXpmwRQhMh5QQxQA6YYiB+KqgR2sywarJa5e8M61cWpLmKtZ21OMQ6M4Z2RzvZTCoa2EoH8C9QEdrt4fH++Hg99cdnm5hJOB1FXHocQmInleWfvXAAPz8fl5jvmFN0vIu7fdeZKY/puPhL23vs0y1e+G19q/YN2s/K4fx2IaBfdHT/h96Re47gSSgfebWiZKk8KTvU4tTqSuVs5agrbj7E+LP7whactywjPEsX9tkkT75gAJpuVXZaFCC8iEz9wGk/YaSRNtiFi6AyhzHvIn8tHTOtL/48eqel3u8jN8p/uu4tM+g6SSOnNc+DUv2PgY0bAneIUKUreX5ogQFOIo4OtktzvasBqX12ughDUkfiMky35i5JUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199018)(4326008)(2906002)(38100700002)(41300700001)(8676002)(82960400001)(122000001)(38070700005)(71200400001)(26005)(7696005)(55016003)(54906003)(478600001)(110136005)(66446008)(64756008)(66476007)(66556008)(76116006)(66946007)(6506007)(9686003)(186003)(316002)(86362001)(5660300002)(558084003)(52536014)(33656002)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QWcHTk3cTLmkaq2HLJT88uzg6b0ZRRzptyhtTk6IGukfGJYYTB7ElgJyJO0B?=
 =?us-ascii?Q?JiTjdbhVhysM2FTuheJPSuEeV+oNyppD51VI6gXtpAW51bMDYOkuXOCG5RvJ?=
 =?us-ascii?Q?tA4v+JwSRX67v+52tl7rGH71ou3zE8FxB5oLYozkCy57DurmlQN0bw3GzdRd?=
 =?us-ascii?Q?5pECCM7j+96nt10tr/nmR6Gofw6YrF+GACRl2tCff40wwfeq4BmCFLdA5g5Z?=
 =?us-ascii?Q?4qD2zWnJHH7XvLzNT1kr/lYVecolFhAMru8K/TCJlsyXIHIhvPczq7A2uiPz?=
 =?us-ascii?Q?7ihwFy8cO1RimBInjfiDOLsnDjnx3WxKmTgTaZJ8oDERe27w3+FRXbqNrC8h?=
 =?us-ascii?Q?9zcg8Dz6fMMkCf/krJFx2QC7DOSuv85bvNpif42vDdicylwi64He0h9JtM0X?=
 =?us-ascii?Q?yie2u5MfD9e0mjNPVsM9h8nfDydZjRsdwRhHYSbpVJBt7jdxv396MnK5Mywc?=
 =?us-ascii?Q?I88f9fLtN1/5wwKzRHhuxXIqPQ0R17afbLBqJzE/hv6S7v3Ra4EglT8QTbcu?=
 =?us-ascii?Q?rSbCroQt5sPoVJdkf1JZKxwYrA/sInMAbEfcwrYrXLl5r32rqPsPXGIDQ33y?=
 =?us-ascii?Q?lyXIusqm2cyWrICCHUkE0V3elEgbdtRVxV12dAAtFCrVrrGSVjwOT8n819Jh?=
 =?us-ascii?Q?m0JyvqgMeyVbyO/AtT/Dt+m37le4KfgQeuYxQFu+zGpsO6Uys1wdJtCzPjkJ?=
 =?us-ascii?Q?pcpFD9+qa8FLrpZKfdAxT1WGXQqEfWwKt2WA8Tw+h0QV2QO67XGNhSwi0hYq?=
 =?us-ascii?Q?+P8nisa5NyihM+ZnT5W8gNFAwnpruJN8VU8R3TxvQDvNt4k3/REOTqRhSmuC?=
 =?us-ascii?Q?cjSgI1bahrPTmn69ga69XHLwtggTY2TBDWUhvgsbZvdY/ybMZNH1e3ttXNS8?=
 =?us-ascii?Q?4B3xQhF+bUIhv/MUpQeWumQVQIpzmBG9iRGSfj6zkLPwhvo9Z1u21JL0u52J?=
 =?us-ascii?Q?24xrJ7BrFoXeolbfwt3P+Dvn41VxJpJVFHIENE36F5pvkdGDgoQka21Kz1bb?=
 =?us-ascii?Q?4Qw/ksYiFcsJtXmKCGOb2t1sASbEMV/r6nqI/HTO02aphKFrr6jJC7VbeXQT?=
 =?us-ascii?Q?Qc3LQICsThEFtQyU0B3EnCzCTQ3BXAo3pts6f4ZHNsoFvPmtvBPiIRo/4Xod?=
 =?us-ascii?Q?TCDfxu/fHPFUAxHEuh5yMylopcUO+ghHcqXEhP+egR2TIQ8UVq9Ql1UoPBmh?=
 =?us-ascii?Q?ralD/VsS2HySmckIhFXw1o1FigvMCnx3FNdGPwHRlO8La5lBqn1GMxS0hWvl?=
 =?us-ascii?Q?GtNeb56ASUH7B8z9L8VZvGnTVwiuv5ur5vSG4LN4EHCcch6TqDya/aG6VzBF?=
 =?us-ascii?Q?lhySe8js5YLdBdsp9rRzSJO2tG8diGA/fjgFAqcwTU5wPeRYNyinlAsH1oJ4?=
 =?us-ascii?Q?VIkwrCz0drtnHHHoMZn0zhd4vPc1/JIJzebB8wq6gG7FdQ/R3X5mA5V45Uuk?=
 =?us-ascii?Q?mAEG49IH29lBPBuBP5g6X1UUExfPpEt8KpRVNqObK04I2AGsCNHaVR+yzexv?=
 =?us-ascii?Q?88O7qu7E106+Nbh2zwexLEeR4tagJbMofl056SUH8b0A+X1PlrkVbp6UTb1t?=
 =?us-ascii?Q?ta8AF9tizbkFNJAf95Gs1e26y16I6+nkleVQpt3x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21aca7fb-9de5-4b88-edf0-08db268af5e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:57:27.5195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtoTRWPyPXE7LeHq8mj6Z4q5pInS7l7n4EwWjJhO5Kv/zxZ2657byQuX8wVVFo1r4UW74sQfe21K59j9Glkf3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8209
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
> to align with the coming vfio device cdev support.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
