Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDF07D07C6
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 07:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjJTFry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 01:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJTFrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 01:47:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C4E1A4
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 22:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697780871; x=1729316871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BkLxoihBlCRPNpV5bvN7AA534jkYfgVI/Ttp7cZK1wk=;
  b=N9NRfbfyS7h/zcAXuP6VgE4frAK8l2QJTSY7YBRDO6GPur3W5dbPmHBs
   Mjx2ZXqxrds3k0yy19FJPIuk0HRllsFYmwmhvIrLr5MmMYad5hA+v2IlO
   uVU2DnSUiqx6s9nbvZVZFReIascaB2XATQNueIT3NDPL1RwexMFVKJISl
   8bR6+5wKkSwDMGNA4FXkNh/reiePtK4H+hj0pMdEsF6dxzgf90NwQWI3E
   aEUi74Ug0GW4WzERvZFrcSb/D9XsiIWiz+lsUFcXd7u2VMT6Ndvt2+pYc
   6Tf5Hp5wGGyd5ZK7+YJTLh/vffSM4aGa6oJTCIEFxa4yGqFHCy1N6Oa/H
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="366667231"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="366667231"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 22:47:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880967249"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="880967249"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 22:47:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 22:47:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 22:47:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 22:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDu5s4iG8wwlPT+Ie3jumFxA8kzI0KfzkZQ0atq3uK+fRYLtqX49aBG0dhizfn703GlQKC1EuM3AOc04T6yLgfJkDQF7FM6jAEwxEVaZ5EoPijS5EDUtgNHfC7lc5oQC6TsZvJLxKb0y/xorL0vfEfZHlhBj99JTXCHDOSpCHySkmeu2nX9nt7gQjG2nT4/pAX6b1MpImvG7/f58xj70HsglxAZzqEkN0sVqewGjNJ2eizSwqrjGz65s2fESibjSMf9VtQtOPRFDgQkVUahJCTgrx7BUBmq0WJPHP+ANKos+lchs/TN6gdC1uKE5ScfSD2LUA7Rl8mBWXT0POGLRzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkLxoihBlCRPNpV5bvN7AA534jkYfgVI/Ttp7cZK1wk=;
 b=a/YR8lZdM8ueYG2TmbBqARCAGX113rfh1CwTyxMhaU3pK30aUB0onIhffItXFsBngAYaTO46ulaSBtk9u0u0hckW1+UBOvPXGkjzkRq3LUCGS7nRh+NplJQMS68g2IfXNqikE+68cLyTdLAmxroYVVw6iTsliFWL4cejwB3xq+zqKmN1+ggmXAKYJdCZkNueSgt9y5VQHwJRWn7bNVYZ5ErXd4eBmSYD1BMgGUQ2nEoK61btpSy6wUw6u2m3vhbdJV4ONpx30Vu1LVCmzKQJt3HQlXQfpEbWWshDn+hsQcuy4MvC8pmVuCYt5o4KiQiYRI+yBM1njBggM/yD8kmfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7405.namprd11.prod.outlook.com (2603:10b6:8:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 05:47:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 05:47:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        Brett Creeley <brett.creeley@amd.com>,
        "Yishai Hadas" <yishaih@nvidia.com>
Subject: RE: [PATCH v4 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD
 namespace
Thread-Topic: [PATCH v4 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD
 namespace
Thread-Index: AQHaAgGfx1QXG6fXLky80vl0Bs6AUrBSLcDA
Date:   Fri, 20 Oct 2023 05:47:43 +0000
Message-ID: <BN9PR11MB52762C3B76D4DBB18C41D07B8CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-4-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-4-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7405:EE_
x-ms-office365-filtering-correlation-id: 1b0fb59d-76f8-4937-c272-08dbd1301479
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cj2duIf+Ldh4EZ1AC6QrioALeVv4s1wx6oaCQTowlSIXZCe1mvOjDpO97UBbBeyl0jXB9gnD+t0UpWqgeH3Cd9Kc1Q+jPZwbQ+ITvZaX0n2WHCcrjGvI4XBj/gaDz2MQwmRXVsPsnJ+TjUJwWbJC6r4vPZVHRsEeZgAZVbzIeqc4rlZKa9QcKC17OtOaoVvfEpCKsQ7SyeoowVMqECzWIKNbjyYkiGMdPRlv49kit/0484yMJnjUoyzZ6DDdWeDScWrGVWMaBWe/uhhDvdGhLhfpML2TJR1fBXgNDOAXwcWDosiwENs0ud9i3P0ccW6K25mPbXT+WeZHaUkh61t8+geBMPA1+Z6vnHj0NKezTW8W6FOZDL07rT8sBjqlieL/pGxlXIk2oKpQsb6cui/Pjeda5Ojd7bNfncnfoaVE4AAnwp7n9jsP7XH2qFiQal/0ZusVNwlfLQ02QnVkfj8+m4DoesQ/Zq9JRjiwroGdDZpb4imsDOeyHJJ3HlxUaWyStPm1cLmwXklNDNokqtrnUmPco5q2YZcO+9hFdggX1n2JO/GWc92yP4OXsWnY+An4ZaLXVojkExJ22bfQg5zkWnPFCDuE+M030wKSGtNcQL81l+Fwsdb9eNDZaYcbp075
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(55016003)(110136005)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(316002)(122000001)(82960400001)(478600001)(86362001)(33656002)(5660300002)(52536014)(8676002)(8936002)(7416002)(4744005)(4326008)(41300700001)(38100700002)(9686003)(7696005)(6506007)(2906002)(71200400001)(26005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4oMpaO79KQVlA0ScxWKt6m8ee6NhxQTSDawxb4P1G2H9C/XdYPfbsJhotqnB?=
 =?us-ascii?Q?rnrL1hQN2d//1l0pZKfze8OCImjE24IBuhHtAwb/uukHWUzr6/pB/Cpoe5Ry?=
 =?us-ascii?Q?J/Z/jm2gIPodhmmYAmzxi9mw5THAGiHMqt5GcV+TNiwq8mFXvFnJ/RTXgnGy?=
 =?us-ascii?Q?Gq4MtLoqsohkVAaJfuGdIWD16tF3XjwD489JiKSq4+sJUeAG4mYLZYxDfIGI?=
 =?us-ascii?Q?LBF2sBvC+2HSAuMTeV3ip8AHnvZ5KYdtaZNC5hNl3y8IVi/j+ILgjRGGmI9C?=
 =?us-ascii?Q?qlMHTQAWEaeIDgAuZcpw8+klZPgm+WUPKH5c7ptXH0Tbz9U8uW/P6Wl+39Fo?=
 =?us-ascii?Q?YMWqtecS2ACPd7iSwsdSfcw5JPrdFF3As2t1wayLbxRTrz45CYcGtWqJEb6Y?=
 =?us-ascii?Q?ixmtFx6WnJyRmBow8OlE5X2Tt8Hbie6c3OLg1eEvl84qu1oz3kA99F31GaLL?=
 =?us-ascii?Q?GmjiKGoY+MQNfy+VD0Df/cgoDheZGTa1eYbSunzazD0SUpaNxKiDJ7XyMcmU?=
 =?us-ascii?Q?YTn60uKTbiwebVzslaOaEE9z4r0lTP9VG1tvtXyCvK2WnG5IwV+nhp9r+dYQ?=
 =?us-ascii?Q?uQyguXfaeXJzxTkxUh43XsAsyDbw/iGx9pbWz9MELNZ5YPuLHcKjxwvSjvfS?=
 =?us-ascii?Q?P4TkhPG4Fc1y6QsLNy1kOuBNzzcZpWLkRMTJ7G0o5zwqKokjMcJaRWPcJzF/?=
 =?us-ascii?Q?fVDhlf4r+F3O7bmmzJEq11Hl17UyTjujErZoE+Oi3996Xlyge8pyGWtOWvbu?=
 =?us-ascii?Q?sctmyiX0QKaUANqNq305iD6paa35XLQaXvxgbhjdpjCEtfb3YZtf5tc7foTO?=
 =?us-ascii?Q?ZqUl0DSHKGX3t+C9FbaLsLPDCTa10BS9szPxBvOiWa+X5hgZcRgP22h6IZq2?=
 =?us-ascii?Q?YfnjDmPcfb0L1AtJizC08leJxPMzxtwjBdSSxJhh6oRAVN0TXY2TNl0WKtdJ?=
 =?us-ascii?Q?cL//CpQMRbH14NMM2vaVmrFjxZKmNE0qpK9kE+/Ewehm+dUzABnjd4AWsXqI?=
 =?us-ascii?Q?xiDLliGDbR6D/JnuE71uaWHamR8Wa8mGg4CZCiJk+zm2fal3b7p39WFZAuyo?=
 =?us-ascii?Q?4707EUj3vejDLEhNWI4q6LFV04qlK7NgQGUgcYyi9XPDQCbk4Nyo7vqCj5+P?=
 =?us-ascii?Q?+bxBKsqklUhLH/N/ojwUOZXfGnG2+MXbqU8a/IWmZYcSpQRd2VBQDoK/RnFi?=
 =?us-ascii?Q?BuEKsVooaNUlUKBJM35cJFLwmzroy460cOQOW+WYRpbzS9RlsEaMFmuztuOW?=
 =?us-ascii?Q?oVevct9GrcwXg6uzIi5F/bMBmDFwYJqIrWhm03+EHHHxDpiCoiTSnc+IjGeK?=
 =?us-ascii?Q?hBtAq3vQtz9Gwp/f7mr2qfBJ7sRVNO/j17cyaC+7osfQP4Q7ZO7scCryr0WI?=
 =?us-ascii?Q?NSJrwZqvhRF50dLVBubA6PiFsoT/thQOXJqbaQ9zB+aMiiz2IPI2pmgkwcVM?=
 =?us-ascii?Q?YB+8C02qkCIBLSXkL/ONIpF1yWrI7dNSbBeNrzcSjtW+8vuVfcr5qUPVufim?=
 =?us-ascii?Q?04NYP7IBkfXx/bSfXDSUnAyH5iGuSs7uCDfoPDyvmK0GkaB3Ut0WJlU8Tg0r?=
 =?us-ascii?Q?l7ZM+au3dZ0x7BTikTM3fuMg/YVEcdSQhprqQf84?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0fb59d-76f8-4937-c272-08dbd1301479
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 05:47:43.5026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A72zKz0Fr0MX0FW6kljOq3J/euR583UCNOVvU2AnoYkyKH4Wb44ByFsrATXYafys0aofx6RcTKo0/tMRVnYt0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7405
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> Have the IOVA bitmap exported symbols adhere to the IOMMUFD symbol
> export convention i.e. using the IOMMUFD namespace. In doing so,
> import the namespace in the current users. This means VFIO and the
> vfio-pci drivers that use iova_bitmap_set().
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
