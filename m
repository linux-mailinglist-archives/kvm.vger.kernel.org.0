Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE559CDEC
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 03:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiHWBbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 21:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiHWBbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 21:31:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AE35A80A
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 18:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661218275; x=1692754275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AOvKU+X30KIAr/UAdKTtRY3lDyC04ouOwhHhM6T2E2E=;
  b=AMs8ZEwhwFLm+j3V+Uog2aiCgMVH0ZiZUBGszbYBIFjPi4NSv1VLLmb7
   9oC64VpWeEA/apZ81l7VptJ+Vg/AS6NFlXYSGN2Sfx5bSAFjuL1dlJEFe
   IoOPo9OyvCYYh7ceDVSWPuXVpnPfsH0LmPw2QeQBIZut1OCbkBmwSwyXS
   0tFiuKAxkhemyBBrT55lG0UzZfYsnLEfpF9RIJC71zSg30aMW1zAQFmjX
   a20O/21FiisOZ9zTK8mN3lEGFBqvBsiajqye16eVlmEbq8NLsCy9B/Mnn
   dzN12k01EDy2ImchaQTgSs/dExw5aa9LYf4jysuWhgJzsiTsKceaHR7mT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294352948"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294352948"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 18:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="585767989"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2022 18:31:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 18:31:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 18:31:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 18:31:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ijc2iDd4r1n8JCAAGriDnkieEWBf2L+IMNtuqu4ZPchalBd+mTa5g33azM/vkvhdQTibAsipthleyc+1HfZkzRWw9C8uDKZardnXwbYLmOjyd2i3Uhybo33zeBUZZ0VRPoobM4xLGcMj4MpfnhgpodBXRK85Xuyou4fQWvwmAtuRau/Tc2Kj7DQMDqtD6mIOXf/aF8L2VPNM6fJwb7iUA+DkTOCKU2gPD/VNEm4W8A2Zy61FXr2p8FMzK/Lo7sI02twW3jIgTU4wrvzvLuAT7bfZGemq7YzDnyq67D0CwbMaumtZfeFT2ES2vR0UufuK7xrVlBTdBcG3yCz1Av1+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8P1LapdnB1yvzEqPWfzYyl+nc8IzJUFv0Qk0fYjCF+w=;
 b=dp71xtB088BEVakicVTp4tIlTNPlqD/F1gULzj9XEuGEo9v5XVbfPJekqznwVjhl5AiMF9r1XFwmZPEO+yqnW6Le0ydYxnLvnMtdzowvABmerSOwVDharcFSRJPjIYDqX5InUeVnOanhl1wztyZBj/zi3+de2YWXNsZEIcoFOCNGwptx7NT/R+sEmYTthL4upo49J4NQoj/S/8Q25BkgDDuR/m7R9/TAyJZ54Lrdd9O/j6XQ+AT5WvVBBVkyH4ZU/J3HPjYYJTFsYA75un7pbrYjnskMvSR2yN2IHIvV8OKJ0YvT2/30C9T2hiEoecxkcdfAAZlJ3NZsPxYIL/1a+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2696.namprd11.prod.outlook.com (2603:10b6:a02:c5::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 01:31:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 01:31:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Topic: [PATCH v2] vfio: Remove vfio_group dev_counter
Thread-Index: AQHYsaRGGwFgE99eLU+zfxszxAHdM626W62AgADs9gCAAG4C4A==
Date:   Tue, 23 Aug 2022 01:31:11 +0000
Message-ID: <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
        <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
In-Reply-To: <20220822123532.49dd0e0e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 691b3a6b-5b09-4d42-3b73-08da84a729b7
x-ms-traffictypediagnostic: BYAPR11MB2696:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: skFTD9gRcH+ZREJDNG/yaUk87GkWi6+Ao504V8zu9lxYBce6SDD/pj6Vz15M9FE8mjf37ljK0pOjJRvhTiHRUjkdYJ23ZEdZ8Ag6hMHUsfbVVl2G3L867/NrVyyLn/+ljFAo1QG6vk7oLR3rlCO/r0OXj9sIbIFjr2xx1dIx1l1LYF0GM7CJ8AXuU/nyPV0GaV0V42EEqcrTLNl1UE87Tm94jkViVW3W9U/XgBNgJB0NF4FF+u2cwU7PUIMa4LNY+CVvB55RKv4A8a73bhZxp6TTH4Y+WhxNJdzndHXH6CkhnSIt77Z95Td7gp4ioTgsY6aH+sprym1IoHU+sU5HfCsSMG+EioxPbv2CNS3YRjwNzOLxJunkJRmWy/GNM3c76jpO4oW7VQDQnAzI4TCBxLB2zonjjArK1ZBAkXL8kD1smM77f3XPzPc0TQ/OB4tZWiqdPF+r1TMf50DqoKHsUrCj5evehBBMYqDn5p4boxYOHYi6c3sT7Dm6BW0yDMKzCP2F1nC2v5wDX+VPhw3du8YYikc93U+nczMa/+SBzAta97VPaSAVBVkZDwNZMb8S/KFgrHvMHnp+6OUGQtengMBLsI+AwTpe6vzjHcIIoaCu8QdyHD2CtsG6RtZXcDiyYP925NLFbHrFyJxIPgzrkCXRWhchMxyb+fpbztNr9W7AFlcmJEWUTFJpxRqZB4Nben20PGNWKBXDarsy/H0NokPbsHrWtAFvP9KxXMObGitP/NeDCFkQ8L69kgHgnIHlf2HxrV+ZNR9igEtSYGPxpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(376002)(396003)(38070700005)(38100700002)(186003)(55016003)(122000001)(4326008)(8676002)(66476007)(8936002)(66446008)(66556008)(52536014)(71200400001)(316002)(6916009)(54906003)(64756008)(66946007)(5660300002)(76116006)(26005)(7696005)(2906002)(478600001)(86362001)(82960400001)(83380400001)(33656002)(9686003)(41300700001)(107886003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iWZ4RgM4MC+p5486LEBxeLQV9OMYhIQH/dD/Dz6GDEOZAiCAT0w6SjAAsj/k?=
 =?us-ascii?Q?sjGYcidlHg6UbNm4GmWcZs2vAeiPWFTfWw91Z4yIc081bC976W5DqfLlKyJT?=
 =?us-ascii?Q?OXI7j4qMjDPBF+OIyr3CkyRJVxkceyxxE/KewK7fjzCMQeMNc27ntf5nCTyx?=
 =?us-ascii?Q?Ncynioazh0fdg9ELN21QVN3lOwH3zDhzCj8zmgr2VdezLPMLyFXDHfY31sFE?=
 =?us-ascii?Q?hRbjGFMEp6G0nwgaQf7t9JTkldn1UXgZEjm8WVI9jORGEuRDM1wWzrTe3rjl?=
 =?us-ascii?Q?SIHKINhs7XHyOowoYJztJH/xzVoKJ9vORVUSzDAPqWEmz+0Cg6ezK4w+ASm2?=
 =?us-ascii?Q?M8XC/B0Iy27vKBk9Fb3mbutZ+HHMT0EDjRR+9WIBht4WdyDZ6TeXbe1ZsKUf?=
 =?us-ascii?Q?Qb8PfClPvZGz7TURz4+qD6LtpXZqKivXa2Fg5qwR2DRqPOMrpVpZZ9a4l9Lp?=
 =?us-ascii?Q?d99UoY6jxDPiQQtcvEbH07DQg2TSnjDjuiUsF/J/75lbNVpr0AeA5sB14cCj?=
 =?us-ascii?Q?v5bh2tA8Su7dkautd9vC1NXuKJOad0xxTkMXuw14ugKJopGEuIiF+UVi0QIc?=
 =?us-ascii?Q?bvLYyeCZW2I3mq/WsGMYV8qNt9snE4bjg7ct32uI3WIfLGAUzSE9W35wSYqz?=
 =?us-ascii?Q?in4zPXHsDQn2NVSoEWxkqGIjsHkuRYacwnrEnG/iqXnUVq8HUMvq9rzKCqdr?=
 =?us-ascii?Q?YLOkb0SCCP0IJVxXFiRHGFVEIfgm78/vG6Akw2S4/c9ahwYea2pwEtqY/sP2?=
 =?us-ascii?Q?4ObXupTyOSRYhUczH16/bofNkMDnh8JO2kD16hyJH1ES7zZHEtMUFEOTI/gU?=
 =?us-ascii?Q?d9ZnrzEQK0SrTOLNS1YwAjrr18c/lAbo6ckwogi7HEUKLQmoueJAJTx4BkyI?=
 =?us-ascii?Q?4gJaDR9jwippMYI30eywhBAbQqIVxTz/+cCpldpb/2V003PE8TzTCT7xx0NF?=
 =?us-ascii?Q?y8IvtcPzIF79jCN7lcJfPmuh5GNZbE64/RsnfzaJzj46snsrEg8MPEqGT0ib?=
 =?us-ascii?Q?/f40+JRFzDVSCOs4i6hn9yhrajRFXYRYEFoQ9lv3G4S94etx/zU2y+NlxGc3?=
 =?us-ascii?Q?klfAa7J10+ZMh+eI68QphIkZdN0hwR7RtIRNfyy23jRFmY481ocF2tzwYYI+?=
 =?us-ascii?Q?C8723FoRtvcQZP/kKiVfit5obejCEXDCO1U0IOuWhKmQdUTPenJUz4Ym6PYM?=
 =?us-ascii?Q?Ye+iZnVfb+4MVRNSTGHzGbWOnADm1DHKCvqgA7k8kGRcfn/MrimXnv44dDOh?=
 =?us-ascii?Q?z+/0/GiWz9zwAmmZEUgCiU/9Q08t3B7w3vQZ+6u+hOOgH/C0jBZELEEIQVkY?=
 =?us-ascii?Q?5GdQxQPtNdDjlZ597w6oxHbnHYK07JGYQSPHa2R2VVNWJ4ZlIldbqoHXIKAV?=
 =?us-ascii?Q?mbbRNf7k3Lad+7UWs6/V7VOuUrFynkYGhK8FqgZA+kcd6xm2bECxh6CLlxUB?=
 =?us-ascii?Q?jZ65WNgqbYi7FG5/Ya2BexryeQbE72++ei67zAcjduIxiuETznsjNVeE67Ak?=
 =?us-ascii?Q?zp4W7+n8QYbHle0yjPg2dTifwrwqx6WP52qdJPn9KQt5uSMsxhOtRO8NVTTg?=
 =?us-ascii?Q?P1k9bKuEZrmcEoip0o36mfbqIzXt0r9A1+Ofm3+h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691b3a6b-5b09-4d42-3b73-08da84a729b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 01:31:12.0469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5EkudWjzkRzLUzZOxOQdTOsw+u1LlF60wH0+sZemEB3GlX2Mdxvh5GmxPci9Tm9PZ6B5dUEcE9SY0lMjWTQBgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2696
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

Thanks for the explanation!

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, August 23, 2022 2:36 AM
>=20
> On Mon, 22 Aug 2022 04:39:45 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, August 17, 2022 3:13 AM
> > >
> > > + *
> > > + * A driver may only call this function if the vfio_device was creat=
ed
> > > + * by vfio_register_emulated_iommu_dev().
> > >   */
> > >  int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
> > >  		   int npage, int prot, struct page **pages)
> >
> > Though I agree with the code change, I'm still unclear about this
> > comment.
> >
> > First this comment is not equivalent to the old code which only
> > checks dev_counter (implying a physical device in a singleton
> > group can use this API too). though I didn't get why the singleton
> > restriction was imposed in the first place...
>=20
> It's related to the dirty page scope.  Use of the pinned page interface
> is essentially a contract with the IOMMU back-end that only pinned pages
> will be considered for the dirty page scope.  However, type1 operates
> on groups, therefore we needed to create a restriction that only
> singleton groups could make use of page pinning such that the dirty
> page scope could be attached to the group.

I get the former part but not the latter. Can you elaborate why
multi-device group can not be attached by the dirty page scope?
It's kind of sharing the scope by all devices in the group.

>=20
> > Second I also didn't get why such a pinning API is tied to emulated
> > iommu now. Though not required for any physical device today, what
> > would be the actual problem of allowing a variant driver to make
> > such call?
>=20
> In fact I do recall such discussions.  An IOMMU backed mdev (defunct)
> or vfio-pci variant driver could gratuitously pin pages in order to
> limit the dirty page scope.  We don't have anything in-tree that relies
> on this.  It also seems we're heading more in the direction of device
> level DMA dirty tracking as Yishai proposes in the series for mlx5.
> These interfaces are far more efficient for this use case, but perhaps
> you have another use case in mind where we couldn't use the dma_rw
> interface?

One potential scenario is when I/O page fault is supported VFIO can
enable on-demand paging in stage-2 mappings. In case a device cannot
tolerate faults in all paths then a variant driver could use this interface
to pin down structures which don't expect faults.

>=20
> I think the assumption is that devices that can perform DMA through an
> IOMMU generally wouldn't need to twiddle guest DMA targets on a regular
> basis otherwise, therefore limiting this to emulated IOMMU devices is
> reasonable.  Thanks,
>=20

IMHO if functionally this function only works for emulated case then we
should add code to detect and fail if it's called otherwise.

Otherwise it doesn't make much sense to add a comment to explicitly
limit it to an existing use case.

Thanks
Kevin
