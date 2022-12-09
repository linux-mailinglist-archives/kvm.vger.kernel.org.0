Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93583647D80
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 06:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiLIFzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 00:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIFzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 00:55:02 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4937723F;
        Thu,  8 Dec 2022 21:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670565300; x=1702101300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VtnSBJnSIs2GkLfKLmlP0nPa4NrwjLvF4gtNi7H0MF0=;
  b=g/cXbJHcs0ILsh+OYT3/RohpvZz0oxmP/SzVGrymHjQDdkn1EZzXgvWh
   NiyQ7s2w279PqbB7hGPSQiyj/32PBOOmgz92wbtlqpBVUZgpAIGXix8pD
   dOUcV+f7Wce7SO2StXRqexPLQkuNwUJbBw4Pf5rq5ICSD9R/2eziAVExL
   3pStn8O3lzHwCq1X9fUYiMjtM1CRFEETUNKpu+0A9/RBLxiEbD5J7+wTL
   sw7291HnFPkjd4cXLGk96wAMxMVkL3YTGO+ebLZxQqYG6xOJXfA8lKQPJ
   +6Wz6TpxTUpc4CeGQlsuSpq2LxtV179UvqHyGSPlLEvTd0QfuwUhYXn7c
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="379598451"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="379598451"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 21:55:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="640913780"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="640913780"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 08 Dec 2022 21:55:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 21:54:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 21:54:48 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 21:54:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrSp72ikLeqmHksl4kJKrKcdeQRQBrq6x+YRlvWo6W8A8XDkfqjLI2DNyNA7wU+p8HiT8xuqQNWR+Qm+jnlvpT3DSAFHTi8VzolfavpdLospRbsSnocCSeALfIVIxNYbu2RpOmQVbVh5Boa3cjCC80fuWE41xAXhTxzy9VWc2k7VRJIsEQFiRcRnm0g0fs3bvW1lOKDlZy/MmsJYAucshpge0exKsJP7g8ZF67SW3uXrlZy9tuU6/0rw1Q9NF/CxmnLC5WZbiygn/vTgbdtlRQVjCLrN/kI7ixubhptS3WLhW2IUhrLDWbq9PBucLFq39UueoXQpHxNY/TogW4CvNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sf8OEWx+nA/7Uec/Wl4KmEJM7BknGPv/zCaHjVJ764c=;
 b=GLI/72nRjFY8OnfhVCKiv6IjGKWzDPRNoFL8eOWs7f5z9szV5wuL3NVhFFhCdbbspYTe5nL0GJv9vIZj+zHUDymO7BIVJ0oCUKyHUCZFndS1hNqeoSgYVFBEfRzKk3idzC3j3Qw6v+W0olak6FdlB3NHj7HhGs1TNBOruZZGgIE2qKsfzlLLP7/KSxp/BmEuN9BVie/WUylo1W5ZVD6P20iT24YEGaZ5JJIWQSA6PsGhmWtZYS9Qwdsgk4EIB5W85hvSP5JUjVQXM6N/Fk0Yx5Jr0TT3ZpefmZuue/lL09G4Qq87o31zgsBoGisVTLa+Xi+99pLZKBORypJ3heLsgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7788.namprd11.prod.outlook.com (2603:10b6:8:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 05:54:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 05:54:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
CC:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Thread-Topic: [PATCH iommufd 0/9] Remove IOMMU_CAP_INTR_REMAP
Thread-Index: AQHZC0NsDzfSnppzvkKTrEmIXSp/jq5lDsSg
Date:   Fri, 9 Dec 2022 05:54:46 +0000
Message-ID: <BN9PR11MB5276B4F1DE4D31CAF8ADAC408C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7788:EE_
x-ms-office365-filtering-correlation-id: 2b022e8d-b2d3-470b-fdf2-08dad9a9e053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KNteK3/ggQ8/Bi7Xfbg12jUZV76ARExF0M/YjfE1DX0OsMlzcL/abaerbMkrrb46PibWKuFVsXudhWxNpiYJjnD7wwrgAVaMN5KvJ+CKHgBodqsfhNhwRSMmJQ17kDsXtbWD3FKgqSoWo5WysWW904thNm3p54TF5wfTEy6Yw07r3WcIWe3k/j1IH2/a71NynWS+y/DRSyUWO3+KP6CxNKy4kiVwts2AEWcU2/S597Log0Z7aRrzLFgcHXvAGHRAzJC3zksrh+1JJ19vMU9eQzcmFs31XjYLt4x17xaL4acl8Hx2mf/GPG379jVDpiDhEc88uOh5rEkkhtqnBeeZmqg6gkkjB5f6uY+Y8J2bcYPLKcoDvoe/xC9gODDIuXbZQQk57pJBjoQgMnhZG88zOsAb1dntcnzQipDLbbEgaViTVPS4Gvg8wNS7lQCjeBBPfsTiPro0tKP7hcIUkorZKtXEgR/7S/xcHymJKRON/amoeqm+XLWntq6+NVI/2Q2o6VxtA/4Jr2bYg4UaQ0NFV3ZmOS45PBsxDMD1nToI358VVrf2Sy7ZMA98Hf7zXEufMQZuKzzHCDQh7KF4T8KTmPu8fZV1gKF17OcEj0d1ZUX500uGfDZ5C06sFwXEgpr38nZypZi3nFHeYJ+PEsCIqQ3o3a+BHwoYaEYbZRRDhplD1Qm0iN2SpLoEiBQSDVOBuoOAeqaviilUtjyH70dgQQWY8qAYC5NQK3mMOns+bBM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(110136005)(33656002)(26005)(83380400001)(7696005)(6506007)(9686003)(38100700002)(122000001)(41300700001)(54906003)(82960400001)(4744005)(5660300002)(8936002)(55016003)(38070700005)(921005)(52536014)(2906002)(7416002)(316002)(66446008)(86362001)(64756008)(76116006)(66946007)(66556008)(186003)(66476007)(8676002)(4326008)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mm8EgTSOhWiUHdt+0lfZtKKyKdToPAcy60acSNf8HIvX0HdVYZ51CvbuskEW?=
 =?us-ascii?Q?IprYeWXNlKKh4YiJbEqGTK7Gcq7fWKsev9QiOydu4oi3MMgLA6d8xF3s5q2q?=
 =?us-ascii?Q?jGQJY8ZVQp2vC+n6X05a1K+72DCaN5HHLOVY2kvYvuWr52GK+5d6iueiHVAU?=
 =?us-ascii?Q?5ogqa1ovH8EQZSTaA1MlybDMvaeG0NHszoAfEX5yRQb8FTLrH63wy08j1ryT?=
 =?us-ascii?Q?BSpkZiSMTSSb4jUE0M/zktVCgu6L8le2cwPeJyrO3z2aS7DFa9zhRu+uBzrK?=
 =?us-ascii?Q?NOJRs8ra1Asta2x1yioPcgmChh8bWrLHcPL2YPMoSuPSpotLn4PycPGWbGjZ?=
 =?us-ascii?Q?sDruL83vl1dv6SqmxzLqeFOvyqSjwQvrZw9wSrthqtoTBzFw07O+XgUTmLAB?=
 =?us-ascii?Q?UY4CiBk7FMZchq9sZsmDWD46q2690Jmu6OqoKLqN3sZ+S8XeHR6jzNQe3Hn5?=
 =?us-ascii?Q?6Y+Rl5hSBiPqxiIQ4ZX2B15YhH8s6aC51g5pBRzxPq59fsevgvqzLk2F5rY9?=
 =?us-ascii?Q?dlQdpaIwYS3T9+h+sXMyawmLSs25kufRgppP7mxKUMLkB0yMF3hDOv0n8oL6?=
 =?us-ascii?Q?41mg3R2XqoNreKVKySPHtIa/Km0X5N/+2BmZzee6eNupYarvw3FYV47uHDUr?=
 =?us-ascii?Q?ws+rtamJ9sU+omthu07K3+OLurp/rAsGxYwbMZeRFVywNFx9xK6CqkxnGNOf?=
 =?us-ascii?Q?fb6bXXmglNyA1ggMWbHVN0OvaVmf0N93NrpP9tifsMp51c8Zf1ZSxSWXh2Jw?=
 =?us-ascii?Q?1OJuZ1rz34ktqOMTsEDhOj+AJc58ub0FU84ma2/kmbNUmOunNngXHwB2nobd?=
 =?us-ascii?Q?lIKCrOonpiSAHM+SLlKSDupX9bnqVuADWPocJYhmIiaPH2WjfuKjDn9mj431?=
 =?us-ascii?Q?BCbHLExxdjxiIrIYEqSL+KdKgqMN0PwhzGtdwtIfmWdFf0S/HprwnV62vRdQ?=
 =?us-ascii?Q?3nmqtfIWOhB0Dr/sO1qd+s6vO22XG0X+oQRsYmHHtw1wt2IswV4FkHDPgDKq?=
 =?us-ascii?Q?5F7zqGLe3HpdO+3eOuLDxqGc0FKlpe83qo0Lbf2Pgx1dJAf11l2HbrgfCbSh?=
 =?us-ascii?Q?9cZ6I1gMe++hEVwaB80oB+QLUyJR7NE5B9GAJBnRgV9aQ1cJV+dZlKtwgS9P?=
 =?us-ascii?Q?HsA9jg7XqJHN2v8EqgfjZyObb0N7xHjFXc77v4VqKcZgKUcKEXuXV1Y6oRVc?=
 =?us-ascii?Q?5hIBqN1JnI5WOA/hntnass16X12kiOwG+BD1lCeaH8ikk8BQkNfTqBWBfdCm?=
 =?us-ascii?Q?bB7BK7VSvyN8ZRX7dCyMfi5iARKHg49wBG9eAlkerUqjMqhZP/pabUwS3ZsL?=
 =?us-ascii?Q?9Bh/rWF8V56CcAzWttUlOAvMroNPPbUupYFuUCjNYPy+kddZ2LBGw7o5fglI?=
 =?us-ascii?Q?OmiwZAJIuDmOCQ+bsefzNmsC8rWCRJyKmbItRdeetM/barNwTny5j4YgD5af?=
 =?us-ascii?Q?+539lfOSbh8MoBilnSTzl/U3FDDJzbqR1LLg0QEciHY5UcTWNaWxRJQUCu8Y?=
 =?us-ascii?Q?VW0BgZkr81R23GyhNRLL0wAxDZAKzpQ4yjTjf0w8HKNTngzUR7RqiuCabwJF?=
 =?us-ascii?Q?162sUMMXmNI9lywGPFuoRIXr6oIvR1UGoT8+hd2j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b022e8d-b2d3-470b-fdf2-08dad9a9e053
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 05:54:46.2179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7VcbVL8CYoUGRDSefIB0oN2yQ431VLLgeukbWwjosBlJ1fnjqdgNBi88sN4MwjQ0e4ubWh2tGu0tSmsC3Cr0fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7788
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, December 9, 2022 4:26 AM
>=20
> In real HW "secure MSI" is implemented in a few different ways:
>=20
>  - x86 uses "interrupt remapping" which is a block that sits between
>    the device and APIC, that can "remap" the MSI MemWr using per-RID
>    tables. Part of the remapping is discarding, the per-RID tables
>    will not contain vectors that have not been enabled for the device.
>=20

per-RID tables is true for AMD.

However for Intel VT-d it's per-IOMMU remapping table.
