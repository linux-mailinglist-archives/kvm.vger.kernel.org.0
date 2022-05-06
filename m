Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66D151CF55
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388486AbiEFDVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiEFDVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:21:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A124976
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 20:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651807078; x=1683343078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Av269r7PNmvU6wR4IIwAPyIV4oIC5viYD+SUqCDhxMo=;
  b=CJ2uS/V+0OFFIi7eD2UErOFy9RALsw/iA4bEbcqPy9cEEahWeuvtJ0Kp
   Dh+xhUGOpt2D/TswhR37UIt0WZyHoAWzWDdsWJusPt4+BzYkShKNeV04x
   SCjDuOvv4M9/Xg1nObeN55qjhPRoiyOYokHRhzCfoyPzqb+PgljEPj2EB
   +gkCcCrlNabBsFNdUNVifzS78Gzw2/EHmGKW41pskNVPjZrSZbiMZ1fRK
   RE0HVM0beoHHsZJKVxqjSu7+u9j2LVRF0s630XgNG+qcCjYr+1ccQzzm0
   cv5cam+gRSF8EflidY8kg7KUM1YvBgDquTtHgTCG11OjNWekfxGAoqBA2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268477369"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="268477369"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:17:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="600355881"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 May 2022 20:17:57 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 20:17:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 5 May 2022 20:17:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 5 May 2022 20:17:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGpwICqFqOD2dgUpc5z8igGakDFmoFVE/z5HspMfPfF8jMJbKO+palhSoJSe/MPpsEW4G9B9GiWJcRYO+qnVdzutjAhP68fdMZlUiNCPBfZQb+/eFAjUt5EreMO3JJuRLksMVv3QbzcjQduFQO4ncDuAiVT3GRoXG4YE4/5Yk5gz8/PhSdroZRWykXfqRuPjOTr2UScnAsdXaIfNZF1Od/xCboNgn1H7yzbBQ6sd+deFHNBAHXXQJo6cOGH5P8GEw60wZn9ICm4qbHLEyoQjFdvKOQWRTY/LKhEbfjIWvvrO1WnKf5rrjrZjcS37twrW0Vp3ui5d2CjWFAL5D87e9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Av269r7PNmvU6wR4IIwAPyIV4oIC5viYD+SUqCDhxMo=;
 b=ixK+0nqdVslj+Lm+bhXuuqYS7uQQDPF3CL+HTJvHH4GjZy5FGA7+MVxiLzYxX/qL7qWss/1V4Gnvm1re/h3ZnSk/MQvUrBbCSl8OWew8E204VLFXT9fGpJ0Nuo87ZHzwtIXLmmolsQS9Nlrvr2FQWE0m5V1H6TgfJTse6PyGH3vILPl+JIw0eivaa5YvpiF/4cD/zQ1avpKlkPMaPYTWJuJzidT44KEHbQ3yYss+l7uUxw6l2L7JhklYw772nrKoWgPX1IVph53vv3qZOHv4x3ALSr2R5bkAWy3cB8Cv5ihdr1vG0klFVJSrpINWQRPxS6HSW3zHzKs5nbuYzP+1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4722.namprd11.prod.outlook.com (2603:10b6:5:2a7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 6 May
 2022 03:17:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 03:17:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAWwCICAAAubgIAD+0BQgAAo1oCAAA4PYIAAMbiAgADfTfA=
Date:   Fri, 6 May 2022 03:17:55 +0000
Message-ID: <BN9PR11MB5276153736E7D2000DD4C6CB8CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
 <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
 <BN9PR11MB527662B72E8BD1EDE204C5538CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505135507.GP49344@nvidia.com>
In-Reply-To: <20220505135507.GP49344@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7f98b15-625a-4032-0960-08da2f0f0390
x-ms-traffictypediagnostic: DM6PR11MB4722:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB4722E77D527625012BACD8188CC59@DM6PR11MB4722.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HQQIXhWfbBxVQBdRHzNHjtKoNPaBo2J4IyFT0a2YGfuc6U10kTnO6kAykq579ESqUc8J6su5cN76MmCvreeXkM1+MmalPm/dPabgcH8q7DB3QBpZ7e1CBt+lKPJiYjjFWgnNj4lonJKQHMeGv61U0AI894fbIQZGl0ipjQe4UEjAYNR/QRm+BboZF5xt/GMKIpQRe6ymvgDqMWtVTKss5hYpyRMdruVTL9lVnT10ApzC0vnTlOsOqr83oFrOgSNYfHbeOnhWXLlQmRbpt3JF+NJlA1/xallWT8KTxY/gxMz2IPgyvHmTGBjcbWRRD+uB7VecvqspyP8qQo+qmvwZSJLS06nzYASqYg8lKpsMvPtusA8TH3rUmz/GXuNFDs/LhgPEKAHlg0hp7H9nlpXdqSzPuiT/ccKZNU0SRSkvHvHbYpcoBRgSY10VkToikgM1MrphOaPHy5/jwYW+ObYP4BTCpBj28xxJBjsXv84M5olPPVDPemoCYNL/58mJBe2EgpsWHvRY+4lFUVgAMWLIebmBjwqojUmmR2IfJaHO7yMmCHKtYOVU19mZ0HlThABJ1Rcz+mHwPEhpImEkMg7AIKzS1AuimdnMmnoNjOuiV4NSsC0dURSPH61erSDw6kt8Btdk+mFkdSZkiWSIaKuUk9uz+QxpVO9+POuj0OzuBnZ5Gv012zqXzozZrGxlKDBcehEFKi7b9Wa9nqsTsp6UcH2vx5O4OKRB30RC/nvLSbw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(55016003)(508600001)(52536014)(66446008)(64756008)(2906002)(66556008)(66476007)(8676002)(76116006)(66946007)(7416002)(4326008)(54906003)(6916009)(8936002)(4744005)(5660300002)(9686003)(186003)(26005)(7696005)(6506007)(33656002)(38100700002)(86362001)(38070700005)(82960400001)(122000001)(71200400001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vsn4s9n4E/JErbJ2fLJYexVjnRSse+/bUZ7X7wW5yfUXuNJgLk5is+FJ7rtD?=
 =?us-ascii?Q?d12zcmdXSTpYaQ+bK5I0ZEOwaCW+hue12whNGabTUiEWXhsAprXG7KetHgbo?=
 =?us-ascii?Q?DQE69JTQAgvPh3EuXj5j/eq58JvtQBmVYIrquMYV4GE4B6//TAxZEA+bMZPi?=
 =?us-ascii?Q?6VwqMj6R23XVhRcuSdNzOiQ6P3Bp4eK9YKR1RFOocZPqg7Rp4vw0GBs2krF3?=
 =?us-ascii?Q?NDwot3ak901rhkyoc6dF2l68oldQBQmyhxjbMvzTQPnqaBaNsQUe3cL+1t9R?=
 =?us-ascii?Q?sKR/ZpiPWEAlQQXV+ZZAnnpmfYiiMbWasFLfiZHKnelAuCkXo/Oj5wBSVQ+G?=
 =?us-ascii?Q?rhXeiPOcHanybjFmwYPHqIKD1Bdabd/exA2lELElLz6xOpWewsY7jEC+4mnz?=
 =?us-ascii?Q?HsyghtvEJhxPDpa4svRjhhDn32fmLxiH/BugvoIssaeazgd0nqZUovfhRVLw?=
 =?us-ascii?Q?0UpIyXAg2hDEtn4aqFrGGZJv7vxje08evx8ToX3OLaFFuOMugNSqd2/+m1/j?=
 =?us-ascii?Q?wlZNbYGvbETS0CuT+3X6V98rOWSoGexV3KzquQEYlYchP4y5l0w+4GU+c0S3?=
 =?us-ascii?Q?WKppLM2675U3nIppuAZaQtsl7clvx0n8lVez/c3u4mS1mqVS7M5RnOJsPMlh?=
 =?us-ascii?Q?haAW27Jj9+2QwvqCmSMJyCrPCMeXptWi/ohC1p5ITqnPvtxgB7tMcKVncuy6?=
 =?us-ascii?Q?AD7tI/sPhZ64SE9KZqGeKJ+Zi4IkTim0xim0VelxGO0GCkU4kUpEXnnUw55h?=
 =?us-ascii?Q?1o2NJeeHpWiHrFj/JmMyEgUDjaYESLxXZpx2z1oVspT9T/1l/PVB2IbCCbQE?=
 =?us-ascii?Q?imsvCAkxvoIm6i8jhQDgjVqO7nQULyGB59yYVSlNVEATiaos0lVQbI6WRnFJ?=
 =?us-ascii?Q?vHL2CeKZK/DM3t/l/K0Yh8iQM/jBxLvRzn93o28Nlgak2EG/zWhkB+a3VhVP?=
 =?us-ascii?Q?qVQFOEBzH7i4rqeWtAj7RQpUuTiPQfHo+1xsYYQx2flmcUZkQumpZbXkzqN2?=
 =?us-ascii?Q?1xb51HEWw8fPWDYbipoJIXCbyfalFOUDwIuGcWkH4fqqhtJsGYQsR4TWpjRo?=
 =?us-ascii?Q?xZ5O6fRER/FhxMvmuSNzXXsNhUFqbkfysDa3amTJ1POcK1TmgsMiJVmw+Dv0?=
 =?us-ascii?Q?ZXBPiQf4TLCXuvQB7Kjlxl8tf5EkN7HY9RJoGfrbAYZyQRYmLu4aBwpN+wLZ?=
 =?us-ascii?Q?c2nWF2YPtSjK+RD7qD9GDo0ue3TC7Q1zUwiLPkzQyaBXgayQ5633DVhbs8mf?=
 =?us-ascii?Q?jgsnVX4i/rYZ6SK0QizEO+t8oYOVQGX3aZtwTbojm3znxgHMUGICx8eVPwb+?=
 =?us-ascii?Q?zb49femVvrCbrHyuZSs/itJUk7AqKs2Pzdz/cF8Jth1EoncHNQaJHRhmxd9G?=
 =?us-ascii?Q?33LOIKXOBJNyKUdoOCT00tMbiYgArDs/WgSstHj0NdhkwkGiOCHu7uJAUYIf?=
 =?us-ascii?Q?ZLOGOC+IoWGpuPZ0aaf/cJ8bMi0q3k7HQrt5E+Iop7C6bkNrszCNYiwPFzeh?=
 =?us-ascii?Q?ndLeuJUx3/w0WX8d4TLP4GWPZAx+3X/yq9NMSzN1tGfrOOm/op7W2DBsudWO?=
 =?us-ascii?Q?yk09zmRBvfpz/yRpOgX4LDBmh5LA7u98wo8D0eoiGvfca9lN0lqS29e/4zqE?=
 =?us-ascii?Q?llC4OeCm1r27htaDhSAq2yQbLdwS8TEc/oJcb+zGSDg7e6xSGQEOgT493P3K?=
 =?us-ascii?Q?WKIQ9svM6laXdSZRHXC/UiuYoqvM4Pj+95tMC53xT9U/zGbU2EhGXriqD5zA?=
 =?us-ascii?Q?SnVTs1yY4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f98b15-625a-4032-0960-08da2f0f0390
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 03:17:55.6507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B1O49baFR3k3Ypa9M7iUJSE0Tt6A0kbWIuxELk/1okX3Jqg4i0J/ksfC3QCVA0AWHJ+2CGb7Pi+b+pS0Iqj+sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4722
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, May 5, 2022 9:55 PM
>=20
> On Thu, May 05, 2022 at 11:03:18AM +0000, Tian, Kevin wrote:
>=20
> > iiuc the purpose of 'write-protection' here is to capture in-fly dirty =
pages
> > in the said race window until unmap and iotlb is invalidated is complet=
ed.
>=20
> No, the purpose is to perform "unmap" without destroying the dirty bit
> in the process.
>=20
> If an IOMMU architecture has a way to render the page unmaped and
> flush back the dirty bit/not destroy then it doesn't require a write
> protect pass.
>=20

Yes, I see the point now. As you said let's consider it only when
there is a real use case requiring such atomicity.
