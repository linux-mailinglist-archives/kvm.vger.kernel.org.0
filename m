Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2751076DFAF
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 07:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjHCFUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 01:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjHCFT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 01:19:59 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D53335BB;
        Wed,  2 Aug 2023 22:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691039968; x=1722575968;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RKSGV+Br0zCP62CmJBAr5MwAYJbq1mkwrjpITQBGoIg=;
  b=E1vFcuw/KCR+QpW+3B6qyZhjuADTLl9ZFYCQrRdTP7dOlGU7KPwtJn2Q
   tu7xzzwg+5EJBS/KRX6TlJPdFsecUT6V4/2CZgbTMZRfYIXWvtR2Eay+h
   uKS79o0bbWdRcerMl2kcUsHrENTaRVK4jG4zFYBKFC9Vb1hlPv9rPYA88
   pAxVZ6A5c2M8aurws/aRgtNfjT4BAZEC49eAkyQn40qoHJDp9+JHUVBG4
   Dm925UcynlOy030A5dI3iVCrK3HRkGL4mxQUc4kBtvphJrEGcnK7VL0pm
   FhhMhmnfzdwe3owF+rFvbywBzXSYhJZSbexLkJWVCoyoxME9vzZJQCJJu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="436085668"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="436085668"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 22:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="706407307"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="706407307"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 02 Aug 2023 22:19:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 22:19:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 2 Aug 2023 22:19:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 2 Aug 2023 22:19:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8AJPGyaPHy0ZTnnswndQgSaFJ7mXBlI90P1aosflt4X8fheLIlOem0gSv/+eH13SyuLYxiSkefj7cHWGC4cmAsmbm8BXvhiCQ94BJJ1XUYWi/6mUmqsmjOCT4FCenDnuVogTlbpwM+9kN9PyFasiBNhh6uDQsRYLHJKWyhSAsGDJgr8VzHgaKBpHsHkesqFBCqodgSApfkhQFMpEgfyc+nL+xS6HFkj/+IHlB+c+yNSeDULMOEQ3u8xem4kQsp0WRWLErNOjVYdKipVOYlfpZ0Syhv6DrXHamLwuYyZqYSkWmzULi2X1wZl5denKofdddI9noZbgY95sqiy+zOWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yqp2TzKI5br+/LXyoPnTEHtOxHfIHDXSBZVG8QqD3vI=;
 b=G5jTLRV9x46agENOLEJs9F3cbheMuM9Rhz1+MaeCuBPKY6ZhfqT2Ceww9rk/39H81P0zxIIjzp30f8zkOeaL2a5HlAWz6spSrALGVM1gH90Ybw31xsvxZCsb7byLVYcomlQ0AeTaTMtoQLHycuoBgBWKQLOILkNYF1gW3N1wK1jkuf4Pb/MX6Ay9JBOvWRcpj45BkbUR1AZOiCMsOcyqYAMAUj4MF5dPIXeOAnBmOk6agw05Q4y7/VOTa69IDy9uAmsTj1QXZbr9xji43ELGaeFB08QFIuAEoB6+1DxenzGMjun9fXTuth97hI4JFKhAu7Ac7CzIGHFgpzLTWdQT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8198.namprd11.prod.outlook.com (2603:10b6:208:453::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 05:19:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 05:19:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio/type1: fix cap_migration information leak
Thread-Topic: [PATCH] vfio/type1: fix cap_migration information leak
Thread-Index: AQHZxJCN0AlhA9yfwU2jGe88ugDMa6/YCjWg
Date:   Thu, 3 Aug 2023 05:19:04 +0000
Message-ID: <BN9PR11MB5276CEA18E764411F6E755D98C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230801155352.1391945-1-stefanha@redhat.com>
In-Reply-To: <20230801155352.1391945-1-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8198:EE_
x-ms-office365-filtering-correlation-id: c3563da8-c010-4f11-4c65-08db93e127cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vrC97Ya3m2YfnmUcR4F3UJP4uLwMNdOMXjqQgyaePaWRyfPpOZHyeqWzX1WKFm9zipfWCeouVmDBJIUX6yCiSXGS7WCbrZ1KhjhoDkR3/YNqy9P1HYv1J+2clfo83Ne+yPwNzauI/wA5kK2dSMZC9+arrxNInWsc4vDCqPrphR65KVNXGnIC956Rsg0x2FTxYGSKKlkmq9y5oWpHyNTaGbw5PvMAJj/Uc3qsCGgcz+AqT4pleOEEslbqG7uQ51JD96hu3jAncl90401uXEYA/qUYYzo+8IdKIIp4Z6Uux3JT6RGg7Sg6bOljCV1hZe1sQCzZvk7CMETBa6cD5oCODCS2aCeKuyKT1xSN/U6yotxeVgg7N5ha0xQ8f9USd2W+VehjKudHdTkzf8PXvWmv7mzSJHe0hZSrC7wVpntUBUbuWCJpESOr+6Gtc8CZGcLSw6drsm862P8RnYzspiLX9XXVD6rhEtzROp7HKNSCg0psjOyooty9O0aI1HVY1hAn18QPq326ppPs+K/L4D2J6yHTje1vDtl4QQr11zoIkiNvZ06bKFZBh1QaTAg+u9F2uSE3krCkfzbZP+irA9XTFhvf5GcFls3payAHjdlsy7IwpgzMMbc+JIC+/EBQnY7NzFrXqe6KHuxwtrG93LSFbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(6506007)(26005)(186003)(316002)(76116006)(2906002)(66946007)(4326008)(64756008)(66446008)(66476007)(66556008)(5660300002)(52536014)(41300700001)(8676002)(8936002)(7696005)(71200400001)(9686003)(478600001)(110136005)(54906003)(55016003)(38100700002)(82960400001)(122000001)(33656002)(86362001)(38070700005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1fXp3OIIBAlMzigIjTjO9mdOmDUzt+bcj+DAPNc9BBW8+FhOEtpubR3B08TI?=
 =?us-ascii?Q?hIhvqLL2chNNpUZ8AUpNnwNjZ3tW07B78XRvQoBLnxo1wn3WiawG4iwA31ZY?=
 =?us-ascii?Q?1vNHXJAxYUwZf1Ewl3WdKYYz+hjJcyx0dfztYC7iLXzpLiowTTWtAT3g11TP?=
 =?us-ascii?Q?fjL3Hz60RstU8VHE5aVarJSgk/QHJtPDCeA4U9hkIAf2m6l8CpXKyx5o7PAn?=
 =?us-ascii?Q?wYCmX5UuuDsq4Yv1jdQvJoBJbf1i4nxj+bbCwWK9kCIW8luHvL8xX/txjYYM?=
 =?us-ascii?Q?M76E8r3CL3CSfTCLgS5sw0nE7sw7EodMJKMBzZgdmsQcEgYNHePw99zk8B4i?=
 =?us-ascii?Q?QGOuP+7ZxJCJlllsILWeZkHXXSenhE7XwpRuXXiWe1m7nie7JfJqtYVGYEfd?=
 =?us-ascii?Q?hLxOj6MCq6QY8gmDNvQR5+IyRwSDmwPOy3D5DfMD96ZnU8P1Y6jzePlNzDwA?=
 =?us-ascii?Q?a7ZYtXUOg+012t/PlqiQVEuBQWoSNBxNuFav5vL/x4FzcTU9G/b9gXQV57fR?=
 =?us-ascii?Q?XIff+5ZSuYhL1nzbUxWOjgymNTCBetecIx6g5SF4ZYyK9ksMK7IPL1aGFBqu?=
 =?us-ascii?Q?dVcJnholUWHiFgWck8ryj069EaKA0IjBw4+DiRfVxANL6YBLiNP15fIkgwZJ?=
 =?us-ascii?Q?0UAXoDmNkRFKgea8RE1Gy18w6kXsm9sT3luWLCdA0o/jpeFCQEk6Ts0ePZjq?=
 =?us-ascii?Q?82oGzBJWxLmgot1i494vq1H6k27WNNgnoZDsds4edUAGGSvPSstZkbpyjcpJ?=
 =?us-ascii?Q?NU7LAexSjwioEeMNAtDyU4KTUPau7/GCRfEIDdXF+RfRawcRf1V2ax50haQY?=
 =?us-ascii?Q?lVFCaXGoeXGZcjVmG8Q15AURmg9KIlv9AjvgwRi/18DY1tdK37SWmwV/5/rX?=
 =?us-ascii?Q?2FrQrA/FOxhbfBMkzoSCkjgoZmBxfVQWJMMt53CjXae2h4+yy/W/jGtJuyGs?=
 =?us-ascii?Q?FGn43P2/vU8zj8GH3AUVk7kB0CuYE9ReeoIgVG+fL/JxKjReHmp8Gg4+0e08?=
 =?us-ascii?Q?RPLTWZNmFxQuBLq3owdkqz3gn99duSOUBc9+rUhxYnC2WARXMxR0V3Ru55FI?=
 =?us-ascii?Q?g1sgCkRIeFVmjU0PMyvMdyUU3sw0YowQbG/4DwLyp9RKVkz2Z/lJK9XScMTJ?=
 =?us-ascii?Q?XOoEWjzPnI5cE3SA1lKzIbJSQeb9Vc04AhJifkXW43EqOp06PSxDGKM4fbAi?=
 =?us-ascii?Q?AmM0uzlD0Vyg3fdgNXwfNRB9p43L4wkVZVKs9XSrIfhOXu8cbigqtyvjgEJl?=
 =?us-ascii?Q?upgVOJb0DKOrAarNWGfzKKTTUkLKj/cHKlxcHnrn116fUbyz8YmAZJITWpLp?=
 =?us-ascii?Q?SfJrOCB900IvWTAyMr+PH46rUtxAwHLtzZzGquVEPt7rprYT4+kfjZ3Y62Cc?=
 =?us-ascii?Q?WIQHjUi0TNsCWW9zaQ+czuTrToZnyYjdry38B4a+A+1SMUjZ7tYeebKi/Xh3?=
 =?us-ascii?Q?+GZUH2LugMNrS3umAF930hQVIgWebPRcqTBSe6Ikk2Q3xsBFaTaes4u+/5OP?=
 =?us-ascii?Q?ysGqodlZ1wsjA4wRU5SVNjUqoAMzRmjfET8c9nT7xRJ49DeF6Kf/Py50Xp00?=
 =?us-ascii?Q?PQxVrc6N1+G3gFMcq3LWBsJD1RUE71y7qjP0F9PG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3563da8-c010-4f11-4c65-08db93e127cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 05:19:04.7442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MCEyunSEc10jfzTW3zWvVDGOYdqhW1Q48YQ1Q5fsZ39J8FixYDd5GKeYRMAaE5AWQdBJ37Cg0wh+Pa1NtRw6Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8198
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Tuesday, August 1, 2023 11:54 PM
>=20
> Fix an information leak where an uninitialized hole in struct
> vfio_iommu_type1_info_cap_migration on the stack is exposed to userspace.
>=20
> The definition of struct vfio_iommu_type1_info_cap_migration contains a
> hole as
> shown in this pahole(1) output:
>=20
>   struct vfio_iommu_type1_info_cap_migration {
>           struct vfio_info_cap_header header;              /*     0     8=
 */
>           __u32                      flags;                /*     8     4=
 */
>=20
>           /* XXX 4 bytes hole, try to pack */
>=20
>           __u64                      pgsize_bitmap;        /*    16     8=
 */
>           __u64                      max_dirty_bitmap_size; /*    24     =
8 */
>=20
>           /* size: 32, cachelines: 1, members: 4 */
>           /* sum members: 28, holes: 1, sum holes: 4 */
>           /* last cacheline: 32 bytes */
>   };
>=20
> The cap_mig variable is filled in without initializing the hole:
>=20
>   static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
>                          struct vfio_info_cap *caps)
>   {
>       struct vfio_iommu_type1_info_cap_migration cap_mig;
>=20
>       cap_mig.header.id =3D VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
>       cap_mig.header.version =3D 1;
>=20
>       cap_mig.flags =3D 0;
>       /* support minimum pgsize */
>       cap_mig.pgsize_bitmap =3D (size_t)1 << __ffs(iommu->pgsize_bitmap);
>       cap_mig.max_dirty_bitmap_size =3D DIRTY_BITMAP_SIZE_MAX;
>=20
>       return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_m=
ig));
>   }
>=20
> The structure is then copied to a temporary location on the heap. At this
> point
> it's already too late and ioctl(VFIO_IOMMU_GET_INFO) copies it to userspa=
ce
> later:
>=20
>   int vfio_info_add_capability(struct vfio_info_cap *caps,
>                    struct vfio_info_cap_header *cap, size_t size)
>   {
>       struct vfio_info_cap_header *header;
>=20
>       header =3D vfio_info_cap_add(caps, size, cap->id, cap->version);
>       if (IS_ERR(header))
>           return PTR_ERR(header);
>=20
>       memcpy(header + 1, cap + 1, size - sizeof(*header));
>=20
>       return 0;
>   }
>=20
> This issue was found by code inspection.
>=20
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

nit. better also add a 'reserved' field in cap_migration to
mark the hole.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
