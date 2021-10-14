Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A87042D02D
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 04:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhJNCK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 22:10:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:10395 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJNCK0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 22:10:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="226352101"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="226352101"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 19:08:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="481053274"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 13 Oct 2021 19:08:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 19:08:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 19:08:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 19:08:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 19:08:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FachPsEWgdOq2mhE5WRNp3qx+SYs0uWG1VwXmg0cMtPUmHUxBM5Al+uTNiXRU4aXUaNPVA1uPPqiUjUPAEbj1yXT4WtUIlJcUG/wYjHKI1Q4IHEYr9kl17nb7PYmTUki5WBhWOegY3RKmMZvkzfICie6mBhR6xqgkfMANmeEbzeSBS1MVJCIYmPuBSlVl/n6t5ekwNtf1jkbEeGYD50+AdunRyHXBRI/P7OJpntsdzFZK6lmu7GtUxVf1p3g9vKrB2fGdxSRClRcLvrNfHP/rvdp38Yz0DEwhFoRhL2mNM2fV5qLvKGP41C24FzN4LBwkiP4Zz5uDvCN8/tDqL4Tag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBF8Wvi8owEFovpOmn1Uc8jkZOKKcDs0hhnxAdqVXxQ=;
 b=l+0WHkNiTMbMHpt7+UfA4+km2io1W97DYnobRAI7aW0SZJ0t0VeoGw/J9WNVZp6SGKb3zDHbTLxN6MAZvv4aTy9K/IbDJaOwJEUS8hZ8O23uriDIcM+HJLYrdQZuG0XpO1z9K2N4WHGiiNuTuxSFlb35lnKIMEdshbbgvWM5Iuo/MlnUfynTExDVYf+qrVzvcaqs3rWYojaxV3UVB2kBnGTqkebthxcIl0BTIqU/tAloDvRpHvuSs8KsnLTY0bNEveisHcbEINSn5yoecTSmMGu57QmICvWjl9MqvD2jFmwPKbqU/TrNRvFNq9ZskVTdd1LB99/6F75vao5MsA3fgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBF8Wvi8owEFovpOmn1Uc8jkZOKKcDs0hhnxAdqVXxQ=;
 b=YubbDhfKkDVQx2FfXF4Gowu3NKtmhNBnU03eR5akLYUnNj25miRKSgglbTZa0fO9KGVnDwWQd5Z+54PisL6NKUN9zK0qO1uoxplKLy4qcGjPkhxPb+m/gzYldarkpTnqaSPuyoQVGD5N/jOETzeGX3N5IjaX8SL1FMdDZLqYVPo=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5710.namprd11.prod.outlook.com (2603:10b6:408:14a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Thu, 14 Oct
 2021 02:08:15 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 02:08:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 3/5] vfio: Don't leak a group reference if the group
 already exists
Thread-Topic: [PATCH v2 3/5] vfio: Don't leak a group reference if the group
 already exists
Thread-Index: AQHXwD6VUyXvHo4s60Sb2+a6F3nMP6vRGNIAgAACowCAAKSecA==
Date:   Thu, 14 Oct 2021 02:08:14 +0000
Message-ID: <BN9PR11MB5433F16E093F9ECB5003B8918CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <3-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
 <20211013160910.GC1327@lst.de> <20211013161836.GH2744544@nvidia.com>
In-Reply-To: <20211013161836.GH2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb128a96-f012-4126-1a64-08d98eb77b7c
x-ms-traffictypediagnostic: BN0PR11MB5710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB5710006EF223E530A10234B78CB89@BN0PR11MB5710.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dfknn7elml1NsYedD8fb2c4hYZPsyjzw15Gk8GYW2LW6sxwtJpmiPEIMuNMuNuNBgTtFUUh/NM5I99heTDO/thyo+g/JtRhaUF6MmtESFmjl3J4AdBYFFdXZLGNrK42FUk52jij/1yQ0scGczRjjU2xLS+O8XV7JxXQIv7P7U1BDKBRq5CvLgR8oD7QbpELig2kM9uY01bSzcNQD3rBVEc29nWIjm5WiRyK6ozhOihMYxubKZgiW6EjQMRn+t2tzHI4Ok3K2ykY8Cj+L3Z3soK7wwPlVK+P0V63xBkPjCfGPpKax8EMaPtLQc0LcARC4m5QmRwrWn/3diUHG+hHIy1wtmwIVBrFLkL8s92LWbrgMQwkAi62hY6jR7eD0FyirySpe2xMRxDwrZ8Yy9D6YrdKLEuqWnNrBENZP6nf3iU4T61O/rEcYhYIuyA+U7Ky0GXmlNVUmVVPQR6COI3PDvLZ6sKkiGDgqpLf+FNByABY2zhYaCbrxYR8jYMZo/uXqIOmXzIfOApU73voiUj76HP9GX4fBa2zjrJZarpXTzzlo4PWQoXK9yynU7gDl4XxHT0U8fKvVT+K+BCG+wumm0nzNGKhE2bARP7heZdBvdTe1VABdOBQ/hBlhvFzsVnwyqegOfWfNcmLxgyDZker5nh1Vxb97DuEg+A0+wnq2hej/tNf3+BTpxoI2zt0QMDEdEpaEdbHApT9lPdAm0Apzcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(4326008)(86362001)(76116006)(52536014)(55016002)(33656002)(8676002)(5660300002)(66946007)(26005)(8936002)(6506007)(66446008)(9686003)(508600001)(54906003)(38100700002)(186003)(38070700005)(316002)(110136005)(7696005)(122000001)(82960400001)(66476007)(64756008)(71200400001)(107886003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bJXWaZaaQpHZ/IJ9eg6FQO5RtxmP/4xSY5LIk7WmVAT4KxLl4wbQC0drYioq?=
 =?us-ascii?Q?u1/remDZue8hcmVhVCszWZhRgn/jxceHg93ZMXERFHIoYShVsygxrXA17Dan?=
 =?us-ascii?Q?CCAKMcvLfg32KuWGaqrzOcEtzGiLNisSn++wsZJw7MAMeaarWorDn1D5OJOV?=
 =?us-ascii?Q?ZOa6wfCaEYT83FaICoWKUKQ0luIjKh5/KTepWNM1FDUO5XZMdRpDAQEhrkMz?=
 =?us-ascii?Q?eu5M5TPGzwSbI4Zls98sK/InlTEwIOjJXiWhw3SHnof5lCPCtYllXUXGTymI?=
 =?us-ascii?Q?kZZs+5e4zmZlmEUZctMIBLsa3KB/B3zATiQJEANEyT62yH1mpzC/CoJd9afQ?=
 =?us-ascii?Q?vwLAJ5CDOxsdyPyTtVIgSkBpWZavic4q/PxB7fXJoYfURX+dkXbTSl/KIeXM?=
 =?us-ascii?Q?gmMQtcnNQEP2jloBbyoqibJVZF9Yu4wNkBzF6VtPNANcW0vo8gJHa6+oMhmG?=
 =?us-ascii?Q?pSNO5RGifWt9+h+PN44cD17GI1icYAE2fQPJb1WVgeLr8CMcKlYw9ISYpzhz?=
 =?us-ascii?Q?e2OfKgT+X99k4cr8PX6Zj8rQfYecFKjlf3P0zjwsCfVimANxStUNsdOVo1H2?=
 =?us-ascii?Q?hQW1bUkBU4xNYgXOx8yyLXRJYsOyx8aZuJcQ4xlEPd3kDdiWdApO1qKl/D54?=
 =?us-ascii?Q?4gCrQ46eHb1r4wWAMkfB331V/Ct+KxzajVpTD9zzjKBsJljbwWhqOEU+c01z?=
 =?us-ascii?Q?OZBkU5+OLbLwdiPc2ZsOcFZAEyJj2/eEEv5owCnGUpOXexXNEVKvLBb2hSP5?=
 =?us-ascii?Q?NuYRSNL38M5wiqYVdzzFe1BbrYWCZSgVp3iAQTOUY5YvDRvnzU4duwju8nE6?=
 =?us-ascii?Q?JcOYNwtFla6rmuDufH9Sw0CudG/7wZLPXogc4LjDF7X+tCKSqgardTtuMhn7?=
 =?us-ascii?Q?XdlJRK8pxl1EqL6JL41TqDnBjEGrH4jhMWTjdrpOcLw8kvrbsVItP4U9YWzg?=
 =?us-ascii?Q?M05mcvp5gP77lXySIINok6+57eZ8Dlq6CaNphzEunGY9BEHGrniSfr6kjmxz?=
 =?us-ascii?Q?YTvTyZcDIT2/FFOc6Qooqis1JQVpCLjci3oO0O5V+edla7KsbnrU4JdpirX0?=
 =?us-ascii?Q?gi78QP4pz8jACHcsq4sLm4Bfqd4c3kqIf38V81ZhTHl+hON7QxP2FJZGPM4i?=
 =?us-ascii?Q?0sO0JEJs8aiNiQP2gTgPga18Nn2z0KtsNZOPfI+5osQNG/1i8BenKqKqEo4H?=
 =?us-ascii?Q?GTZTBRvEYseda+MsQ70wZ1ZobByM7y9Yf4AS/m1UFGfz4f5fAQtP1b4pJbu5?=
 =?us-ascii?Q?udUWd6165eD1dLoGldn2pYEzg/AhWq3Isz6jm6rwTdbN8cqJnSWEvQxVEAAm?=
 =?us-ascii?Q?tLawCISn4TMh7uHJZSLtqVlC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb128a96-f012-4126-1a64-08d98eb77b7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 02:08:15.0072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0wSN8dWS8otwuNe+00PCw26ziK28LZ13R5R1aGhXIb2uZNxl+jHSqk/1NTkdD5bTiArOuZPVv/sJhrz/PCR7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5710
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 14, 2021 12:19 AM
>=20
> On Wed, Oct 13, 2021 at 06:09:10PM +0200, Christoph Hellwig wrote:
> > > @@ -775,12 +776,7 @@ static struct vfio_group
> *vfio_group_find_or_alloc(struct device *dev)
> > >  	if (group)
> > >  		goto out_put;
> > >
> > > -	/* a newly created vfio_group keeps the reference. */
> > >  	group =3D vfio_create_group(iommu_group, VFIO_IOMMU);
> > > -	if (IS_ERR(group))
> > > -		goto out_put;
> > > -	return group;
> > > -
> > >  out_put:
> > >  	iommu_group_put(iommu_group);
> > >  	return group;
> >
> > I'd simplify this down to:
> >
> > 	group =3D vfio_group_get_from_iommu(iommu_group);
> > 	if (!group)
> > 		group =3D vfio_create_group(iommu_group, VFIO_IOMMU);
>=20
> Yes, OK,  I changed it into this:
>=20
> 	group =3D vfio_group_get_from_iommu(iommu_group);
> 	if (!group)
> 		group =3D vfio_create_group(iommu_group, VFIO_IOMMU);
>=20
> 	/* The vfio_group holds a reference to the iommu_group */
> 	iommu_group_put(iommu_group);
> 	return group;
> }
>=20
> Which I think is clearer on the comment too
>=20

with above:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
