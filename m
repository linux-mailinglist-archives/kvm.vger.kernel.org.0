Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3336E2260
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 13:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjDNLie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 07:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDNLid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 07:38:33 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A421A4;
        Fri, 14 Apr 2023 04:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681472308; x=1713008308;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c1th6E+gEg2UgBlN4z6tBVzYeLREGHtBNQVdbAhmK8c=;
  b=FjktGtioHZqTEDjfR8BNG1Fq+UPaRqnU+CXSTGNi7AISupbunhuj+Gp7
   ha4kq7K3tsntBwN7fvj/Mz4hKLbLmjXPxBgJQOKEo/EoBB9Lt+UXOuTH6
   LqV7yM+1G0wFJM3q11hRksNE6RePPzUcULvdg8lhY64Wi+NmqjKaKGHG9
   0K5VBo9zBHhJ0hsofagov3mL4hWcp8K20zB9fY/II9+/KUe+Ppf38hpLf
   wketpjW+mo3Yr92giwlFX+IDczkuyHajkSSoLG1dCeiVR8fWz1bvQOWq6
   EZraCnSl3JAd5R4Ot76SskGJtQYdk/BtB9CaFn4sa2Cv3RvBcBBh7TC3Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430736511"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="430736511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 04:38:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="689777586"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="689777586"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2023 04:38:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 04:38:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 04:38:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 04:38:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUSRfc1Ez/rOavsv0qwFHSbcmKrh35w8jzjSEJminWvDu3Gp/ZXKFEEZ9SJ8eU7YoIZknvtKtIDUgbxVxXYJH0aiVWHYEZ7yLtPlWhlQwEd1Kfw40GtMrM3fyBeCbuDroe6lnAmFkzPgdaZIo2W6we1Qx45ejXWIH7ifrkC/Lx0t+IT9vY91IA2XDH8tf9Y+qSauUutj4PZ9siftDuATxRC9q+ugFvGaIxfGQt62PP3IGMF6MK9uKfs9PxJP2wqH+mD+d1E3atG2sJc1IKrfsB0xETDb7mjAVJYWhNuo4f3rnpiSKHZ46JSkwZAqg629y4szTO280DN1myfLeuVfjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymOaIz7sG2dNWul9PX9hgkBzJ6gtO2bWApGF8L22E94=;
 b=NvPzaQb9+m7W9CX7qXRd3eCJxsLimbHhZmj3EE9n8r5HZkXcCSjDswzX6T1qHepySF4+Xz22+lsXZ+gTnNo4CqRbuZDJYxWL6GTVTCL4v7+mWyEXV74HoSIG4PK13DTso93fZ/Ruqf8GzFYKnqGorptG/HNk5xM5tq72qF+2/rBLLrOdYXvkwpYHOjPTu2OKDyxGSDwltSPwGVjzGAlNzxbZntpZY347nRuz5actKxm3SdQxfPevJIHCvHMG8MnImqPrIvSGXeoRKJ3INo8s5nJ8s0xgGy8vvCv9zi5GBwp3UDEU7OFqaLxktHv+Pa2Pi+aWYmdBl7lAVCEW70Je0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7073.namprd11.prod.outlook.com (2603:10b6:510:20c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Fri, 14 Apr
 2023 11:38:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 11:38:25 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQ
Date:   Fri, 14 Apr 2023 11:38:24 +0000
Message-ID: <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
        <20230411155827.3489400a.alex.williamson@redhat.com>
        <ZDX0wtcvZuS4uxmG@nvidia.com>
        <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7073:EE_
x-ms-office365-filtering-correlation-id: fc07e8b1-72d0-40be-f468-08db3cdcc1ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2CJB1tFvmD3eTY+0tWkrrE/MOpCbn8721vMRvGApSWBNq4Fbaq9YsFOj8c3YRIGa6Xi4S1aGHiJcT5VSuGlDCwBjHgBkAHIpdJMv3JtMPGkk+uzE0L0GCBF+/Xf0b0ek6UYLw+wGqvqowxo7hFCYZhbYIH7Kuqpd75/X4gglNwg/ze1Hng9kW+lg1Z+nMKWLh2ifIQCqosFMpz0zykAtMhcXvo67ClDacxyJ83IQXhVNX4x4uJdTJ0iTHKjqB+9eT0YMvxBHzvsG1Eku/oyExehVMAbSEygaP5BPqFBolvsmpyDkcEN52BUvjC9AAEQivRk/KBXbEeQ+D9rXfFA4y/di4+h2EekhXkYkGUFsK0y1wehvcB/cDUVdbI5UglE4w8bXjSsXGpx5Lu36WWEiGOLW6lq73UxmrhzoFiDi9FTtP6sPcl5/2SUnsFAAI2NNjLwxoTpQC1Q+sWmepcKxcpMQlGKTOjQasqWQh92LrrL63IcSGNL5gB9hsJz5JfXnF+8HXGMNp6mgaIrCo0cZcYbAwcg39KZvlCA3kXOKNYfF1V3XtoBGpfORWJM0w9cboVkZSK9foefUth/QfqOHN2bCbYWCclm16pdANrpsUJV1cxe+Mpv/2drrgv9E4tsI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(7416002)(71200400001)(7696005)(86362001)(55016003)(52536014)(5660300002)(83380400001)(2906002)(38070700005)(6506007)(54906003)(110136005)(186003)(33656002)(9686003)(26005)(478600001)(4326008)(76116006)(122000001)(38100700002)(66556008)(64756008)(66476007)(66946007)(66446008)(82960400001)(8936002)(41300700001)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eF1guOHOwZ4TdxNobhZSOjYRQELPer4wZlR4D19D/a9dRk6KoZuJTIySBBnu?=
 =?us-ascii?Q?SwQjpDalRMH8VcbB+gKjg4zfoE1WJazmTvN7zt+ga3YxTQ+qQVRak2KaIKIy?=
 =?us-ascii?Q?ww0yV79Rh9wyaqrg1k8bLMCy8sP7gOeLUVokAwDZe4SMdhShF0bl38sbZsFU?=
 =?us-ascii?Q?zLSuDdjLrWil/WwaLy6mkc1NWT9+E4JHIkebONto7AvuHzisNgeH8dUII4cA?=
 =?us-ascii?Q?zWkQ/RTnrxhXqeP0xMU6biJZqnSt7ILBdJoGdyDv75gBl09nj31OWvfgxHEI?=
 =?us-ascii?Q?v3cdve3FbYOX0moZemGfD5BuAftuECuAKXQK8jH5U96k+RylM3wp8rsiu5w3?=
 =?us-ascii?Q?pmyR0hmuP4afVsQ424wTj4IfIUDFtKOE6NhZwfAx7UCnyvy+pqy/Mo3NIAaM?=
 =?us-ascii?Q?OKdWY0P5FJKze2Pne5eCh0maeOziZdCWpIzrRf/gLJlgS8K7OJzkxPzrQ4bx?=
 =?us-ascii?Q?bVsxww/tC7TmAoCmazxK+zyRMZeHrQ3bL0b4OSAeRZkOGuUa66GA82TMSHQV?=
 =?us-ascii?Q?ITZ79bUFn++lx/v0SdiU42JqaOD7pX5sodZhtgVF7dZQ36RVd4IP1g5VSc7m?=
 =?us-ascii?Q?3EwbYe8VXy5TzBkg74WLBKTyDAkchs4RhbHEfJVdhshKE52Q2frcKe+RtqPA?=
 =?us-ascii?Q?TSLsXFvR0JPaqGcdf5AKwUw+KermviINHZ9x/hBQDV01kSJDm7DL/vzghWar?=
 =?us-ascii?Q?KWXMx9oDVLIYi1n4EhJgaEiNMcyp8gQGQ6pxlY0FpcTQI2yvwmpQmYdXDshR?=
 =?us-ascii?Q?dfPF02uLSoBusUdvr6/BA/N9qp9/0QEIKceXqZlOoCqkX6u+mbRbb5/XHCaU?=
 =?us-ascii?Q?kSQAoDbNTapPabEoWjxq9XeXeYwDNu1oSeAONBFWGFrUWMh4TGMSKOyVuP+K?=
 =?us-ascii?Q?HYgSYkTNfAzYbU5Z6riWLgArimRKYAgBvXMHY5eKhDKXHRxVNM98xjvOE2Y1?=
 =?us-ascii?Q?oEZr0qUFWnB6odumiOlmu0feIndSXu6Z0wHS0f1RuyLPVmuD8/N6mBgfM3wJ?=
 =?us-ascii?Q?omafNfWeAVbgVZKNQB28e6Yb0UTEJ5VUYntHq1XWycN2SdmrIFzPPAHWopbX?=
 =?us-ascii?Q?IwpWViarIqWXjqcw/z3PjXV38tt7N9AJYBdGfug6vvjrK30OJNN3cWNFTmMv?=
 =?us-ascii?Q?j72PxmFUdSTQjVCPCofRqnpezaJKzZKk2zdksH3sUBMYIND9NeZkpYldzEN9?=
 =?us-ascii?Q?BzmVPge1/74u/4ZzycvFx1Y66ad6G2kEsTDrt8gIK40sX/+qvCRGl+f6JZ6L?=
 =?us-ascii?Q?/hLugHPz1YXmMvLeNTYJr9TsNcvuDQUzwYZ5i8fai7AN78rQfmY03RoBuvG9?=
 =?us-ascii?Q?Qmf5u593vs/T0l+PKBT1DFvQ/lRmSkRdB3F3GCI0Qp9cU+Hs480SMLjhjncH?=
 =?us-ascii?Q?D5urYgJKbaZd4CSn7RIskCAcN5GfOdWul7SH7X1JAvFU3i4eBXR9D0+pN5EQ?=
 =?us-ascii?Q?0TjJRIzU0a7n4IDwFYEPWbeVLV4Tf1STv+3+gR3n3NVMk3gUiHGrHW6JH+K2?=
 =?us-ascii?Q?gNelz1EQkaA2DzUuKg70Exj14FKu+ka2YFKNHNBwsvGyvjYvS0MkheLf8j0+?=
 =?us-ascii?Q?5KvjuyDttW5e3jlW9ARBfWwyJ9jea2Ra98f9dFg3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc07e8b1-72d0-40be-f468-08db3cdcc1ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 11:38:24.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gwij5//0VMExWvk2e85YwepNX0bugdXVJlUDFuW/6NlbFNygt8gpQLFrOwOzJDS9ZnznhPRmUfI/Wz4SvCcmVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7073
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, April 14, 2023 5:12 PM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 14, 2023 2:07 AM
> >
> > We had already iterated a proposal where the group-id is replaced with
> > a dev-id in the existing ioctl and a flag indicates when the return
> > value is a dev-id vs group-id.  This had a gap that userspace cannot
> > determine if a reset is available given this information since un-owned
> > devices report an invalid dev-id and userspace can't know if it has
> > implicit ownership.
>
> >
> > It seems cleaner to me though that we would could still re-use INFO in
> > a similar way, simply defining a new flag bit which is valid only in
> > the case of returning dev-ids and indicates if the reset is available.
> > Therefore in one ioctl, userspace knows if hot-reset is available
> > (based on a kernel determination) and can pull valid dev-ids from the

Need to confirm the meaning of hot-reset available flag. I think it
should at least meet below two conditions to set this flag. Although
it may not mean hot-reset is for sure to succeed. (but should be
a high chance).

1) dev_set is resettable (all affected device are in dev_set)
2) affected device are owned by the current user

Also, we need to has assumption that below two cases are rare
if user encounters it, it just bad luck for them. I think the existing
_INFO and hot-reset already has such assumption. So cdev mode
can adopt it as well.

a) physical topology change (e.g. new devices plugged to affected slot)
b) an affected device is unbound from vfio

> So the kernel needs to compare the group id between devices with
> valid dev-ids and devices with invalid dev-ids to decide the implicit
> ownership. For noiommu device which has no group_id when
> VFIO_GROUP is off then it's resettable only if having a valid dev_id.

In cdev mode, noiommu device doesn't have dev_id as it is not
bound to valid iommufd. So if VFIO_GROUP is off, we may never
allow hot-reset for noiommu devices. But we don't want to have
regression with noiommu devices. Perhaps we may define the usage
of the resettable flag like this:
1) if it is set, user does not need to own all the affected devices as
    some of them may have been owned implicitly. Kernel should have
    checked it.
2) if the flag is not set, that means user needs to check ownership
    by itself. It needs to own all the affected devices. If not, don't
   do hot-reset.

This way we can still make noiommu devices support hot-reset
just like VFIO_GROUP is on. Because noiommu devices have fake
groups, such groups are all singleton. So checking all affected
devices are opened by user is just same as check all affected
groups.

> The only corner case with this option is when a user mixes group
> and cdev usages. iirc you mentioned it's a valid usage to be supported.
> In that case the kernel doesn't have sufficient knowledge to judge
> 'resettable' as it doesn't know which groups are opened by this user.
>
> Not sure whether we can leave it in a ugly way so INFO may not tell
> 'resettable' accurately in that weird scenario.

This seems not easy to support. If above scenario is allowed there can be
three cases that returns invalid dev_id.
1) devices not opened by user but owned implicitly
2) devices not owned by user
3) devices opened via group but owned by user

User would require more info to tell the above cases from each other.

> > array to associate affected, owned devices, and still has the
> > equivalent information to know that one or more of the devices listed
> > with an invalid dev-id are preventing the hot-reset from being
> > available.
> >
> > Is that an option?  Thanks,
> >
>=20
> This works for me if above corner case can be waived.

One side check, perhaps already confirmed in prior email. @Alex, So
the reason for the prediction of hot-reset is to avoid the possible
vfio_pci_pre_reset() which does heavy operations like stop DMA and
copy config space. Is it? Any other special reason? Anyhow, this reason
is enough for this prediction per my understanding.

Regards,
Yi Liu
