Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54765575D3
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiFWIq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 04:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiFWIqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 04:46:55 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DBF49249;
        Thu, 23 Jun 2022 01:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655974015; x=1687510015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0rn4q/mEp8WcWgPDnKZHyLLfCJFWqceNfkAmqoteURE=;
  b=novzaAOG7EuJVbBEh0x4ZqW+6fSnkjfqEea7DuMNl52+XvJHKsRlxYZp
   9t1PYpEz3ElJzIUWRSIS0ODOe3BxLUw6qRQm+xvOASujSY22iNCa9QFVM
   x+JxRqVW2XvxKynJeT3DPMuEFREdPeNFCSCR04TcNG0/C8wbt6TEl0/jS
   ULEKzp0fZqQtT/uRH1BwNMFd+/TgSh9sOqu72mHIAywAUYMz1JGgxM+PB
   s4eGW/BJNsuN9R9fXzDh2FkvEYsNKCAmNNeaEgeYZOLREEWwiPFDUW51f
   sanpi6hEqie6Sh1EqiqCfLsg4Tm/SBQkObqj4id8XS/ubycbfBPChjjTP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="269389008"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="269389008"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 01:46:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="621238914"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 23 Jun 2022 01:46:53 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 01:46:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 01:46:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 01:46:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcnZ7ncJfOAPzJaQ4CdqSHPRcbE+u3Wmxo+JzSiTp31CvCYomw2V8nlKjE063FcjST9X2OL+0tEPMuTfyCCIO7T27VSEC0fLqb3qt3J8JeFSoQH9Bm9faUyVHPcyJ9g4zyKqUlSfA5MWTSPKXrSC0cnfJ2BrBZDssJFIKycR6S8O/7S39zaPO5lZ6cZs7WHj1+nRRLZ7V/s5M8vAwPRwv6kz8KxEXHEPfM9EZ9k/DwobbFDD5la5+UJa5ylqckfRTpmZgdcw2vv8OCpqMjN9CliPw4/luZwf2l2DkDC9yOXWU0IB7W0s6WqRwGR5jz28lIg9+W+CCfXRbZBpXgPbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj9bdkwT2xBOcU4wtenB7/jSX82cixUfBaciWDNZqq4=;
 b=YfB7qglRIVFyBwCzSaZc84ruGP2CDu6RHdM/QWKtRfy4SElJCPwPrzAOWkjBKp2qIYMJlRdCGRu7XRmC7Uwk/iscY1eucSvpb55l398BpXWJwPjOGbEq/6vZFIJVjWD5PLHRlb9xxcKTydzKQfxhb+iDpqnBkI+On21KwdYS2sXoUjy/VrER/3kHY3CPu9k1CrnDykWo42WmnVCnXQpAsme7bY5GbV7HjSjBvCsMvtKHOWKeybcw04SwhTP62UXR0+oyxsqaCSjDQ1QLQxCtbZXcxcCnziPgdI0P4UhKyC/+DDjfS3ddzhx7rv9INyDWOE4iJr3EqzJluHF1GlX2Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0072.namprd11.prod.outlook.com (2603:10b6:910:76::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 08:46:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 08:46:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Thread-Topic: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Thread-Index: AQHYhjBDxcSXv+DsdUqa5sThL76Ctq1b/06AgACtydA=
Date:   Thu, 23 Jun 2022 08:46:45 +0000
Message-ID: <BN9PR11MB5276A79834CCB5954A3025DF8CB59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
 <20220622161721.469fc9eb.alex.williamson@redhat.com>
In-Reply-To: <20220622161721.469fc9eb.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb827052-7779-4653-7fca-08da54f4e767
x-ms-traffictypediagnostic: CY4PR11MB0072:EE_
x-microsoft-antispam-prvs: <CY4PR11MB00722A4BC1939B588AB347F58CB59@CY4PR11MB0072.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B0qfahwwBNGAR3L51LnLiZZQwkV/E4HSgM9abxVXvG9QERww2i7XfDAdrkrqke3tgpzV1ObJ8guxuPznxHAeHZpVYKh7xcRHHW2wqB0rGOnu+NnWS8IAZfikF8WdcdndE/TTtl1V0sAWkEU3VAHr4SKrU1gJ4qE8btnxWyQ5aUfztfwPWmE8vAFfYLiFEQWJUvoF2mT6wFxc4Lkakd/G0r1yjf2RLF7S1JwdFhIQE9KyBi27oy9CRztWqJcBEGHH2iijOyPWkxrkq9gSKkgb9GdGzZXkCe6OZ1jdiYAkTc4ay2p1krp3yz3L5NiJuMkWwFqH9OV9vdvH8ULgNeeECLsQ4huJTXBoUdTtGO2k/AJgXAO3d4UdScp1c1girbXkxTVGNy+zx5tvati+2UGx8jPNy3b4bBREYYy0LtOf/VnwTNaAeHJ0/KASCsXw/C+BaNGi1WZL6J+Fb9Y4QLmN5AzIEDDab2sRuyUy/9wzgaGsJHAOHLLcUBgoQYI20JR0yZt7wwZcNawh40nBZe6F4+GLUCIPzmU94N1EQsDkfGS4+6xV/ZDkWfc79gWf/EnlAFpYMCE+qAMYIIpAwEC8KNJXoXPQ4+fP6uBv15Ni7+z5bekbthcUqb7RSJzcRo7teEeRkxWvqlNKqzlkxkT0RLIKvKA11cKPnbTo77Q3kKFEV2Xe9Hl/85zn+bTfZmGOjjxBoS6quM0o9J5TlCKFOaDxaBWUQdzPMxjcQvvKgSgCAaJ0Z6wTob1XjYoOu8TX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(366004)(136003)(346002)(55016003)(4326008)(9686003)(186003)(66556008)(71200400001)(66446008)(82960400001)(8676002)(66946007)(64756008)(66476007)(26005)(76116006)(6506007)(54906003)(41300700001)(122000001)(33656002)(110136005)(8936002)(5660300002)(7696005)(86362001)(38100700002)(2906002)(316002)(52536014)(38070700005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wltc2TMclfOz0qmitw28G5Rw64/bnoGYpc0XX3YtaUuhEqZhwJhQ0so5+qhK?=
 =?us-ascii?Q?PFF3DhUJnrUx899+Orgg4qb+xCh7AW/gItIAcLd5BiIIwBv6FePvf2xdP6IP?=
 =?us-ascii?Q?76nY7kV77Kv9bhUfHs8gIesQ15x+yk/iMF74WcW73lZy6Osjib7FY1oFK86N?=
 =?us-ascii?Q?iyOObmLvKkHIe3DCRUTX2k5DPYWX4zfT30CaVc/1S/aPu+K2j4uVInH8j+V/?=
 =?us-ascii?Q?7V6l2Hfr8ORXdpUhU0eqSl3Ap7dNvdqVNK8jxGkEP5p5Pp8l76zIJW1h+eP3?=
 =?us-ascii?Q?z73ylgBJELRmvvOw1+PERDqDkeIhqJ2nOOdKh0oJZaJsaPVguHCNcLVsWtwF?=
 =?us-ascii?Q?nsMYOy0U/6tDPMKtbYeYTZOaNLzAkh27umJlt2d3oI01mNy0zbUM9EzzhgI3?=
 =?us-ascii?Q?lwVyENcI/nq11nnWNiu/MCIxRlFH1aEM40f/uxUMEeg/v0Eb1U4pYQWZio1m?=
 =?us-ascii?Q?T70XUWDaDWtcoRlRY8NNWcboWa8X715AiWA6tyVmHUmtmY5K/GOn6h1HvSpw?=
 =?us-ascii?Q?LXgLiRMrtcmiojrPd37NS+mQAPvHjVAjINbj5uJAQvjRlOIsAB0Rc7TlSQDx?=
 =?us-ascii?Q?UDPUnqek9pTWDT3qMUXM6VIkZyAzx3WZA+xgcMflTEc+F+KaySgjy3IsA329?=
 =?us-ascii?Q?juJGrxGjkOv3eXcrv/B8ijU25KEunz0gc/HBSmnW/AHc2WKvrgPUhR0JdvEb?=
 =?us-ascii?Q?5Xp6ZzF3iMWyGXT7rSrlEeNvx1oZMwpVYf8pTB90dTd0GiBRB8yu+BbhYRs1?=
 =?us-ascii?Q?+FYhwP55qusHVA1ybtUGAPhTBD+W74bnvui/IDG5HkJs2WtZkdAyZawrzwyT?=
 =?us-ascii?Q?i619TL6qdRf3tCIkEIPDK3OJ/MHlh1hujmlm0kiQTtvaEbH2yWewT5CYGbOI?=
 =?us-ascii?Q?nqluu5OiXq08aMf7mWKeHvBq+i2yRuj3/wGK7sdjVDv3SkNiPPhLNlGxTsdL?=
 =?us-ascii?Q?YIs7xDD6Ygqi8rRK1lAHHjpZchPDhdlHCFzQ1mAMkw/t60WuSmtZXKBddevI?=
 =?us-ascii?Q?Fcx9v8kSf+lCdulpFoDOzPnHhOl0c30rs+tEzNgdaZ0ifLt14P5ABYS+fO/T?=
 =?us-ascii?Q?GtolNwSqxiBY0B7PnUmSYvhSdFXXm79tj5OXsx0PI39K5nqbr73+bCJafdYt?=
 =?us-ascii?Q?y1Pkp9F6f2JpZfXjlQsOaYOKtHdzVjSU9d19zWB3IyPivtEH8A/343L7XLM9?=
 =?us-ascii?Q?xXXJgPJBvgut2gtgpsT2xUHs8D/f/+ePgKIYQN7tDl8UfzwkMvs/U5LhTC4e?=
 =?us-ascii?Q?gKWBSFwvmnKsoXrdRqw9FH5SqGrvGN87D/SXa8QQron7SQM82p4X7jqxmrGg?=
 =?us-ascii?Q?rROHiZxIR1RnTR7XA63nibmhlSUfdGdudMe2GrIRefMQls56sLoQM9A1V0fo?=
 =?us-ascii?Q?hPeio9Gz4nvCtX1DXb9ED0h3Uem/zTHG0oIDTdKKL7dpjKH5d8pnjD4CT0mO?=
 =?us-ascii?Q?rzqdZqUbdNX9Fp2KKf0OBise6EGu5dl4xqrICZoHEGidFuHimzmc7N87aRdU?=
 =?us-ascii?Q?Nno9BZ8sZh+jrl23bySRLlXs4AMuUzwend+4hG0LlpD1u++XyP9r+mLeeN+s?=
 =?us-ascii?Q?AgGbrhz7S2JYrP4ekal6GXN8LxB2ycYfU/ZDhI0Y18FLkhDmcxclskYYXjEw?=
 =?us-ascii?Q?4cg3B00qBkiqfzSSDGD4utC5GPsARsENDSPF00zE4zrUEm6KoBctzTqmxTh2?=
 =?us-ascii?Q?Z5pkKE+DzBq8TzAIXZOGcGBEUkhX3SBb5OA6CcJJi3h8iQ8dugs4XfypsS93?=
 =?us-ascii?Q?Gy4XgXeLQA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb827052-7779-4653-7fca-08da54f4e767
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 08:46:45.7107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmh3W/pISDTQxzKjPWo/elEaHN4aBdibWZ96DIg3GhENHAoOlgAqpJ8Rdqr81PmjoERRApDyQs1MkJ2QZ5zt7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0072
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 23, 2022 6:17 AM
>=20
> >
> >  	ret =3D -EIO;
> > -	domain->domain =3D iommu_domain_alloc(bus);
> > +	domain->domain =3D iommu_domain_alloc(iommu_api_dev->dev-
> >bus);
>=20
> It makes sense to move away from a bus centric interface to iommu ops
> and I can see that having a device interface when we have device level
> address-ability within a group makes sense, but does it make sense to
> only have that device level interface?  For example, if an iommu_group
> is going to remain an aspect of the iommu subsystem, shouldn't we be
> able to allocate a domain and test capabilities based on the group and
> the iommu driver should have enough embedded information reachable
> from
> the struct iommu_group to do those things?  This "perform group level
> operations based on an arbitrary device in the group" is pretty klunky.
> Thanks,
>=20

This sounds a right thing to do.

btw another alternative which I'm thinking of is whether vfio_group
can record the bus info when the first device is added to it in
__vfio_register_dev(). Then we don't need a group interface from
iommu to test if vfio is the only user having such requirement.
