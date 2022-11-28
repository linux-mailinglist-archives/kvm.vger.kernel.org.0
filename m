Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1647763A275
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiK1IGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiK1IGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:06:01 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FCD62E0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669622760; x=1701158760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0bIw83u3cMOMtmerYGTO0wutsxmbcAHQaPFpPcHZyYY=;
  b=GI8+qQwCP/yL4gRYAtKQrpC8kr492koLEnF7iJy0RSbFq/kyMDKe+5Si
   KjczstL8reggAv1OIx15sxXTG7ybV4mhqVV2TET7ivezBtLHuDIcm7z06
   QVk09N7V0OQsXQBrLjg9pBvHRkUUk9VzPFuU4nt1q7o8daNK/qCsQq4eW
   67NORd368vPoV7ZFrvADUjZMBO6wNh3WrIIugD66bwHdb6rs/kYTw08qQ
   URzZ7n/xvVgYx8Fd0YmbpcEkLyyiD64xdRcMj/OUmLnZOpltwk3LkpQ9w
   VfD0di/Ye3P0amK6OtBznhn3LQuESyXPQ+ixRpUPBTO6KHa8Uq/og/9Ju
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="295157286"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="295157286"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:06:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="972164094"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="972164094"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 00:05:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:05:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:05:59 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:05:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+/j9Rm2wZUPNwGKbHYu3mEMm0s2WOMeBxYxuhRNIZ9WhlYUMfSbtJTZMXTCa4D60tKInj/WAk+pZo4PkRJ1bQY+W9BVrqCAfuCYa6InxdD/cg9JV9u9GIJBex55Lm2mfct1BjtdA550Tln0gmo3un0fD+kVGF2hxxIGCpwLZf4foqXZlxTKQ22BWCqi94C3jsspQdCnwulgZ0rPt2zTGGERSQ4ofuc5lvBv9WGxh3SHX2NWzEko9Bk/Jy9uJDJHo8d9WswA8K7/4k4soib7XkgJwBaz9iIvWvsQV+g/cRcmqS5emHWmll8FwViCtyM8ypxXiMBCn86RE/WlZBLiYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0bIw83u3cMOMtmerYGTO0wutsxmbcAHQaPFpPcHZyYY=;
 b=TVfNuEqQtbbEuAR3F8zF0RpVZaGHe8FlmAGI45TDEhgJIvHbmJOR6S9XbcjaoHxvQZp9rvzOSTBFu6BhS4Ip/Z+wECz5McPTtd6gKdPaCWmrk4BKpK4PER7aOgjF5VjMawx5B8FzGfFGN9fxxy1vPZpwe1K73ZFutWYh50hSNo7Nx58FUjBGLvrk8NfE6Wl9Itiwjyh3Us/dwMrtzKzwpzE5c2uAGgv6Xjveovk3Wf/8O5Kz/kPLRXHzJmUlrObLznEAfnyWugDEylMkAmyyGSTpsG5huaqFjw357qoU0Im2ZwAcj/JMFLH+iVWBUm8aEQkBAbaojWwaVuwKT7V3tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6499.namprd11.prod.outlook.com (2603:10b6:510:1f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 08:05:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:05:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 02/11] vfio: Move the sanity check of the group to
 vfio_create_group()
Thread-Topic: [RFC v2 02/11] vfio: Move the sanity check of the group to
 vfio_create_group()
Thread-Index: AQHZAAAY8VH6vjrsiUK70maTnNVJra5UAGfw
Date:   Mon, 28 Nov 2022 08:05:57 +0000
Message-ID: <BN9PR11MB52769BFF7A45B1A516EDEC748C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-3-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6499:EE_
x-ms-office365-filtering-correlation-id: 6b4b161d-69e9-4f56-f7c5-08dad1176134
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 75FGIAeepEAp+Y0OJe2NJAx5SbdmiQhh2Y9uAR51BIFjNNwWtPjyBP/md5IwL3IO6z8cqfMjtY5bi6KbBxR2EdurqOzuGxvkvZtbqDXiUVU1qqd0gmHt1tnfbBpeZUaGNnD1fS51ORxUKquaP18PO8rYojmNFr5qm1GB4QgxK6EBM0/1DBhXYP3JAb6dgoOuAGdK0KtpaieSKtwUd6coiPo1XuTBOYmf5kInLh6bpxLV14zp+ypgZtxr4SQjvvQqd8WWz2cx0BJXwbsvc7ZEc9RzO3qzdWoQMomn4EwV6sI/3REsikxz5wTQ/WT797PIYQC+9NXVQ9F9hnYOrkgaB73BDsaPMs2hRH6awPYto6zwCREHHw66azwnppyChWrU9FEfmiqqLf8C8lAnuIhcr41Cm/MBSZnePfgWD2AHS6WxW+l2egJw3b6/bArf8NYVclwjApWbwc0aEyWEuCuN9b2QGeEaXl/zS/O06lfZ4madIagPRVutdtqfiaJeLF/6wK9iHm4BHyS79oGirEvfHf0CJT/Lf0ZMMaIlzG/NNB0l3t6JXwEnEClmIYTk3ey+yeQ0L3FlBJ0O66/erCeJDBORj+zkflYZXZ1HuAXNUZUbtJZDIIDEVHEKPII6qZblV8ZZdNYUvmy97Xbj8OZfPzMMPZk8Op998y8v1XfI0V0nBEO+QgA+PRSp+QHR/4rQyhJAH7WL4UyOgWf7MSA5DSttcNgfg1awG1GQh/Y9TrA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199015)(82960400001)(71200400001)(122000001)(26005)(478600001)(9686003)(38100700002)(7696005)(966005)(6506007)(41300700001)(76116006)(66476007)(66946007)(66446008)(64756008)(8676002)(66556008)(33656002)(86362001)(4326008)(38070700005)(4744005)(110136005)(316002)(55016003)(54906003)(52536014)(5660300002)(8936002)(186003)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8CUrF+ggJReKKtvyyOFmTT10etiPKjPNGqYPWs8aKOtNnSB0nVL+29pqLtI6?=
 =?us-ascii?Q?sUXZkbUc42KRfwWTYhoyZe4WpcuJgsDTnnQMx28vMzMvSNhcZs6D9mphc2R3?=
 =?us-ascii?Q?nhTdzOSZfJ06u+yRPQwGdt0mQUvcapBGzGmxyV+XcNkUxCqgI7u56Ma0rLKz?=
 =?us-ascii?Q?/8EZa8jFBNLXgAlwhi21F3xbhsd1XmU3vAJh4p8G3q0Two+nsiGwL+SN+aHp?=
 =?us-ascii?Q?bblxRgn9lyaug6ycUdJ89DyRN/cPzuH8JXo5w6Hu6wsa6jpFTpc8omulKj7z?=
 =?us-ascii?Q?cqIxoAH5DqKKmCTYEeEqjU9B6hfiPZP4u87/U5a/VwVIMYTtxT3hWfEsd86K?=
 =?us-ascii?Q?9BWTRjX7CLxLsiu1fnFbHGgyrHMPIRuqpibffEOzEnaWRU91fVqxypDYr3QE?=
 =?us-ascii?Q?BEQU1ua9mNnYlb6s/SyZroFCYI6o/t3RPWTNuNQZaC+qPLt51bcw/tIdTrFh?=
 =?us-ascii?Q?gmTvjtKrkJBe6uIWHq3CyXW6tmN6S4pefe6+iyIhEAvIjXYnk4Vuvi2oOYJ+?=
 =?us-ascii?Q?N/jeCfY3P0nY8tH7X+8Z6qMkXDwWBsEHZTG4zBEszMeuPjD2NxIaT0ZPx047?=
 =?us-ascii?Q?RcV+7MSn0Uab9CAHgIsd8Zb5UwIx7f8PqB7RxUGfF0eMkCbb+sZrL6RWguR/?=
 =?us-ascii?Q?V5KUzINmazGNgfKZ5bD5kKh5xF+zbsF1ieSbedt+Gg4i4bcQRchhWPe4AySi?=
 =?us-ascii?Q?9m48ctEjQ24LscyVat6Ni2EplXVkCyvHkteIkHUokBoM6MO7QvzjzWhfBz4V?=
 =?us-ascii?Q?7bExUUaqWzEb+imtuPaCTmx6DsrKW4y9Q2pWyQRymAuu8kjPBLu6Sw7Evs03?=
 =?us-ascii?Q?xSHFt8c7zl+DMdn4ZyqVlqIJ0r5iIEI3attspZ1m9AYRIY2fiYJB6AN44MC2?=
 =?us-ascii?Q?OeP5iUa6GU7Q3tkMo1lNZ6rPUKGhQkjJ8Tqc34lb0UAZuwgkT86ulnGbiAOJ?=
 =?us-ascii?Q?TdbF7PrEEjap8qM99hw/rJKlDZVp/8ydjS8vYzNC/DkeJ33I+va6FLC5l0Lr?=
 =?us-ascii?Q?P+Obb6cgvZewThMTr8bKpSfom8Gk8dM5nkpVO+bWjFgJ49EB45N9SuRl/gBs?=
 =?us-ascii?Q?muORn2Ug0JbIqLD8UNL0oCYBux4usOneZgMUCmQP5Ha87BUY6tcbSzZOCCMS?=
 =?us-ascii?Q?BQhHjqfeHqY0zKiwcvL+gUkvYybPiQM3lhC8VTs6I+req8T6Vv2XOFlIZLSU?=
 =?us-ascii?Q?i90h8eyKDWGnTKFf7zGqvTYvuIJ5SelHt9P0RBf/q8mj2ot+DzhWiYu06QLm?=
 =?us-ascii?Q?YvaeIFJ/mW6NodwgGpzvFohdGgJrHYANK5+ZR2eSLUSJTQfTjJoApZL/e2IY?=
 =?us-ascii?Q?5zItF+NR2qlj1CQJ1S06tuMNQIEoGWYs30ePzY9rpNEgNTeXwQe7I+FxMyYu?=
 =?us-ascii?Q?+wCTYh6H7nM3HSunXdorPj1UYajDuKqsrZLhTSpK2BrUauWztWqGGuZmU3wM?=
 =?us-ascii?Q?yyK0ycl31V0irpBcwlxHym0kwPj4k0H8jSE1Ulkl+24jhNPIvNa90SJwc10P?=
 =?us-ascii?Q?MSro86Zxj+DtKvd/9oTlYDLg8/POoNQ//CLNRXw9lgkRMPtJKkRnHee+pa69?=
 =?us-ascii?Q?C0eRhJyit4SfxzQYXTbqvNxwLsFLkw+Unu4zogGQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4b161d-69e9-4f56-f7c5-08dad1176134
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:05:57.1348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PFt/yv5OGIaDUHJtjAeSGhfHkZrdgRpbBeVw4tGshSZpfP2PrFQGW41IoH2H5GIdxAN0TbxFABCUBTUvYsgxzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6499
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> This avoids opening group specific code in __vfio_register_dev() for the
> sanity check if an (existing) group is not corrupted by having two copies
> of the same struct device in it. It also simplifies the error unwind for
> this sanity check since the failure can be detected in the group allocati=
on.
>=20
> This also prepares for moving the group specific code into separate group=
.c.
>=20
> Grabbed from:
> https://lore.kernel.org/kvm/20220922152338.2a2238fe.alex.williamson@red
> hat.com/
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
