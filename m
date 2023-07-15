Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA18754949
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 16:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjGOOUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 10:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjGOOUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 10:20:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5C5E74;
        Sat, 15 Jul 2023 07:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689430795; x=1720966795;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jw8usk4qnbAX2a+MK1cz+JTOrpNvbytL6ZWy2zaIvxw=;
  b=av6leXv4Ni/crlQAuFMc8YHCJjz1d6jEXLYko5k0lILJ21KO1XOBmjd2
   tIJS+mAXEHWBvlOfX0c0j335g7XR8vcc8LkLwH141RFn3kiMNRjzCOlD8
   9oeDvCUM7urUg+VxxvJrQMfq/AOkDKCHDbJIz2o6sUpKPmQ4DXCE1j/DN
   gPSr1WNI545/4h93fYLLD8Zd586na0PZE2Mq8H+YjEMxeIk7GBupR8v2d
   TGfyWwCQjsPb4cuxztsANxeI4hAs4giCsSz4Zqx6lWZQEWWvnVDzmwdo2
   hVwUxsovYI4kwcSoZM93v+DzvlwT00LVUqqZA1R4F3mIyidXPYoqNlpZu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10772"; a="365704377"
X-IronPort-AV: E=Sophos;i="6.01,208,1684825200"; 
   d="scan'208";a="365704377"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2023 07:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10772"; a="716636884"
X-IronPort-AV: E=Sophos;i="6.01,208,1684825200"; 
   d="scan'208";a="716636884"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 15 Jul 2023 07:19:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 15 Jul 2023 07:19:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sat, 15 Jul 2023 07:19:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sat, 15 Jul 2023 07:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duVjNlS+qBHVvBYEdRNwnZF2C35zXgpxQU+rlhhY5AAuIu0c4oD1aNfRSwpNCYoh4EiIhXdHyxgx+iYrPFmnoxR4hzElE9nPcLzOG1xTHgVb+vQ6YbUEY8LyH26O6CoaaYgNzYJ6+HmDLYtdBSXazIJ2RvnR3gOWEegbK476bcMnGaV7iRFo3EKsHIU8FhEIH6WHfVzT93OoHfGshjrg2Jm1G1ElISYhLOSsswK290BQJc09Hpqsg7stpARHZCn4p6dDhrQ8Et3XiLPta3sImbH/l75TcGlIN5c+jz+JMsIqsNNZnNGJTmw0AZbuPSOBSLi92KlwOHDfcRZgZSq58g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2CPQGbuvfIleImJ7xP3E4M+JqoHiV/okhKasPrVvWA=;
 b=dRMRozz8ubXP6XWVlqp/ZhQzQIg4th6mZWL7dJtqpQV9e9Ggmn/Tfxo1FmGpe/MJRlJziCJKk1Q+zDplQIHcIe3zeBb5c4st+a+CV2rYnXtGNzk2X9NBkyM9qWQDa985BYSUGkILft+z7C289yuyHXazCQ2kikfMAQyMUEIWOFvmOvQbDaVMS8m8XeOPFVH5vIYkwdpYtaNR9A7xHCFW/YEJeknemrpFfdlomDTdbSUdvqBi1FhmOt7HiHLBg6I/JeeYvmrwnMP5f4yCtickhWjtJ0c43tK1MSedSE8RTOZ6p/RE7XFerm78YKRM8oBXfn2UO0PNj0fL++3zCAmqqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB7645.namprd11.prod.outlook.com (2603:10b6:a03:4c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Sat, 15 Jul
 2023 14:19:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 14:19:50 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZs6PJ5wkagZbV3kqhRW+Tv/kBJ6+5W3MAgADiPuCAAJTogIAAFL0Q
Date:   Sat, 15 Jul 2023 14:19:50 +0000
Message-ID: <DS0PR11MB7529B5B6D3E2919A89651339C335A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-23-yi.l.liu@intel.com> <ZLFewHxO8DSelEml@nvidia.com>
 <DS0PR11MB75297BF68F3FAD4B9EEA483AC335A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZLKZc/wnMbrp9ZYE@nvidia.com>
In-Reply-To: <ZLKZc/wnMbrp9ZYE@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ2PR11MB7645:EE_
x-ms-office365-filtering-correlation-id: c8736cd6-fa3c-4b3f-5eaa-08db853e8d03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1aqgeYNG/+spHX9BebYcii/Q7YZlP3yxAuDhqvtpiQ/kpE3+gQhAW49TsbS6kp9d6BjQ/4ns5FRxr6ODh4K7HreTsEvvECZ6sRN7BZ4Pv0XX4WRlijPjcbB97WaEHHOAynnNItKwvX9a8LQ9X5BzUyxKm8mQBzKyaoVJ0hvDQRJU3LmUrC0DOU2hMeSs9cTMKiW0Z9mNhgxqqKoi3MmeMHxJGJw+SCKrr50f0Froa1aGEoiDZBOBaNHMLahL0ay6j9e52feJ/yj5wwshnyyE4pyWkVQY2f3wobbrFkKo+ua8NDYBQYS8GUaQ4CRM3sfsWMFhIvYBFNssAqtCmPjJmsaKqkS1QEY37rjWapadJo3uRfbEdfH8m7Cz52KTNeCcrqX6OmDa+y+X+u+L8ylSiMrWWUPWGZxia/g8+w1MlyBGW7SOgHzXkJm1X323EzDotwyawWfbm/hwbGSBIJgTsxzsRuvTi5EUTlHF/BpJYaVL3isw7rbLjHmiCqTMy3K3Y5fysMpfy2FOLqti50h16dp75kS/bS8XDsWqSUQkEjZXAzywsa1RcuS003B7ciB9ZMYH3+dGRu1YZ85mo6HoHHfGaSCU2TYvdlHM4aJetY/RYebuQsDYhhhrdLF4xVVxBGyktl7HUFVg7jHqTURbTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(366004)(39850400004)(396003)(451199021)(38070700005)(76116006)(66476007)(66946007)(66446008)(41300700001)(66556008)(55016003)(4744005)(122000001)(82960400001)(2906002)(38100700002)(478600001)(6916009)(54906003)(4326008)(64756008)(316002)(5660300002)(33656002)(7696005)(86362001)(71200400001)(186003)(52536014)(26005)(9686003)(6506007)(7416002)(8936002)(8676002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VObC7dghuvsbX9eDjlEaNf1+piLlwLVLnnm3XFpQNmcExvZ1BSsQa1rw63OL?=
 =?us-ascii?Q?4Ikhg+kDlx04sA/SDtD3cMb5vG6JzJ+rYKu7UntxsLwdT6Nu+hT3kQjPhZBD?=
 =?us-ascii?Q?wB+y1yyQjrSz42htXhwRoK0SYp+TZC7noyKyHPb1TUoZMWgwoET3MRdjNL6i?=
 =?us-ascii?Q?l+3qI5QEjN/9DEaHTdpWHMHVdy+KmRYBuak5hgLzRGy42LZDWdEcNh5SqU1x?=
 =?us-ascii?Q?nvsCsECOD4xb0hnONhW8AxF+wQaDd3jiR+erY0NQ6byNdkw/GppFpcymcW0L?=
 =?us-ascii?Q?2Xe1JYUyZbPJ/xNxxYshHdb7X7EWgtNiT9shdSPWhqB91GWycBFdjKyvu0Fl?=
 =?us-ascii?Q?IKrnGMFBr2VS63V/2ps//rhaLEK1w+V6j+0jVODuwJaEAcOGhv+g5mckVsCS?=
 =?us-ascii?Q?LEVfokaCjBt5tSWdMzMtXr5w3sxs499cAKjrvK7Nq77Xu0z3rHeANltYHkMU?=
 =?us-ascii?Q?V61DHsC6ovF6wKgeYCpW8e/lw5FwqRVrpRuju6BmhnNVHwjPJS0FrVgTJoSx?=
 =?us-ascii?Q?CPMCP5ErtGdeD6PydrA1DGE9Pz872GJbNNG5ImavVfVv0yjkJ7jvEwA5iLui?=
 =?us-ascii?Q?lc4BTYtxlaETsaPWwRq8CrBsHXQ92cLJgWQgu352QQIXUIQYx7BwxIilNYho?=
 =?us-ascii?Q?NpEL3AK6Vx9Ccc1xeF780dR6COcVSIMjys1PJB9Y3VCaGm6peu0q7v0XI2WL?=
 =?us-ascii?Q?QtZYbzwLpEUPGo86sV1bpbrC8SepA5QGFDFwo0kj9jCLQFfwTQV/eLIyU+3e?=
 =?us-ascii?Q?5fH+cenISoZmQBfOJfYoiSCenMBRtXbAwdEZOyhuorrXWx3TNVWmdjbGYL4O?=
 =?us-ascii?Q?d0QRjD483D6y3PQFPKE2pKVgAxXZpmZnInUv3QCZYodnHbr4pPPPBu6DQxI/?=
 =?us-ascii?Q?TguVCm5z8T0JH06a3I6Vz/XbWEWi0zxV9ChJD/ZN5BNgcV3q2Xm4zfKkNUNa?=
 =?us-ascii?Q?5ShPTCLrkPoSW3MTYoqz85gsbdlHu5K0o2oAzsorK0aKHcxWBlqYmcpZd3LV?=
 =?us-ascii?Q?QCv6GWIp/wHVcav7mp0ymfb4gZAzY//3X+SpliiUvW6JL1RKWvkoIovfbPC6?=
 =?us-ascii?Q?dd0aMEhZiNiNfqUXrgYCr2oI7oogXLdLqKMQuP0JzFktyqVSdoeFnpx7KobM?=
 =?us-ascii?Q?WwwHbiFfNuZkGWMJgEUQ0v9B7hbbQWa7iIBXPPFPELQGZuPG0+Rg1b5jjfYr?=
 =?us-ascii?Q?saotoS4RFuBjulePnfXdNRtEAuQtfjH8Rso7G+ygs9/qehUVgXlZ1BpRRZSu?=
 =?us-ascii?Q?UksdHbpZcrkBSK7DsvwweQ09SqfxFJmpL7ugUsL+gUej6vwMkY8cwfq0Ew+S?=
 =?us-ascii?Q?tcMdYaJmUFLiBStkKV1euGST8wUmuVJUYxi2OpLRfUlcC/gPCd7u0M9hvNKQ?=
 =?us-ascii?Q?7ehb0+wzmf/hGHFbLlZIY6yCVledHKlr7BtXLszhOlwkmPsIhvqrCB5xrjxu?=
 =?us-ascii?Q?QHxVhZ9KIP6k7ooHbxGWkXTJ68Ny1A2aHfgF3COwTja7d7gFMrwoa+Qoh6TB?=
 =?us-ascii?Q?bcMUTJFfP2jjjFObQEEskdn0QYIFR7JTnpm2Dh3OePO79copbmgZfqARXjw+?=
 =?us-ascii?Q?09FomVxUndNLYKOAoKLWrVZTYdXOkxapkRl+WFVz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8736cd6-fa3c-4b3f-5eaa-08db853e8d03
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2023 14:19:50.3019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qzryt2YeOjZstzpkeHII0oaXvB1ARw1Agici35qEOHnDHZ12rTevlMYtbvLIM52sbITpnWtpXWLJ8terzs3tWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7645
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, July 15, 2023 9:05 PM
>=20
> On Sat, Jul 15, 2023 at 04:16:52AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, July 14, 2023 10:42 PM
> > >
> > > On Mon, Jul 10, 2023 at 07:59:24PM -0700, Yi Liu wrote:
> > >
> > > > +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_f=
ile *df,
> > > > +					      struct vfio_device_bind_iommufd __user
> > > *arg)
> > > > +{
> > > > +	return -EOPNOTSUPP;
> > > > +}
> > >
> > > This should be -ENOTTY
> >
> > Okay. Since there are quite a few stub functions in the drivers/vfio/vf=
io.h.
> > Let me check the rule. All the stub functions should return -ENOTTY in
> > the !IS_ENABLED(CONFIG_XXX) case, if the function returns int., is
> > it?
>=20
> No, just ioctl returns ENOTTY, so really just this function.

Ok. I see.

Regards,
Yi Liu
