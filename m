Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A015AA6A3
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 05:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiIBDve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 23:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiIBDvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 23:51:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C8A2EF39
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 20:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662090666; x=1693626666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dBnffBCKwpMzCrBybSVBcm1GYsnSnLN7ZpFMLmo0cWU=;
  b=GptO0papjuXDm58De6uVV7wcdyY1F9jQ8QGPeHsTtS0AhC3rnwyzYWdL
   RX7lVaYNAGNV95yTSj5kv9bTbrabAA2EqgOj9AyBQgH98w9+8Pd+E3raZ
   LA2YnMImePddQ1O/z0blY+7KLaatt2pn+URJLN0yreXmeWpxnREke/KXL
   BIAKZOhyX90pTP5XRN5RIbvMmRDnberyiHMmJ3DJgNeQ6nEpYH+83Zpwq
   7CqtXFFRu1jaYgROoNrDhkkN1oUbYvrvwFG6u4+sbhh/DDtIOwBUSNbUp
   dSmOIEaLZEHlU3pMmhEfn36ZWQzP0gQD5HgVjz4mQ+Vje4B/Zb4YsA4zj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="382186760"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="382186760"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 20:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="716369827"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 01 Sep 2022 20:51:05 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 20:51:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 1 Sep 2022 20:51:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 1 Sep 2022 20:51:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVuTViKKdCqqeNMhgAkTum2rpGspEJev7KRmU5fqmcTVT//xcExpkjTEtStbEU+wBDH2hCwTx1ua/n7Fo9AqL1MJTBZyCRN98Z0QVjzm15RpCRktFq+ZtfUoruSsSk/ELwm9sK3U6gYx7aYEv3p15xviag8Gqdqzr2Pu3ICKUBQc9hk3+nCIqbG4qnmoFaXqGC1fx6jNrs+uk18OCXQ3FZm8yg4YAqfewWxW/u3/xi05JQuN3jl9d8M7bYsKXnDnMb2DbMJ2Vup4Bbg088abIqI6XZ2WEJZSZMt/HJ5p/CZJ7lcBDJnivWLdpEMMfZM2c9gR7LOyD1iKUkaR3vAsZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPtFLqUMbMaISTeWlcveiA11LsOgxb9SX/YHXn0wixY=;
 b=jeT60XL4nAAeB2t2qi2CFIq4P/MYlOQ/9u5LBPMsOJ/ZXctJ0sXOi1/1ujoVRrm0Gssbl9r4mqpW+4wqeIY+ncmfOIazL+mnJo/rScWRGrDvo+y4p5KmAvUvfqHMqAWl0IEVkxdCp7wyWvlswq3KVn2SqHAksdFFZ/DZDusn0987SXtW1kM6w2zEVzeXJm8nbXjdVGWWTTllDYfYt4+Nj0JchFTnexTGMzpOxHWHVZOhFBzQXDAy7aw1n09x+d70WQPaWXfpeLXadKTg62TUrCw6V3dYJRMh1ug4v7xHosEtna+xoylTaLQrjCmUoEkIrjlKbBjWhnoM3ewC0CTSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6036.namprd11.prod.outlook.com (2603:10b6:208:377::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 03:51:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 03:51:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Topic: [PATCH 2/8] vfio: Rename __vfio_group_unset_container()
Thread-Index: AQHYvNVSThnzW9KUGEadAxVOclcPZK3IsYPwgAKavoCAADaQcA==
Date:   Fri, 2 Sep 2022 03:51:01 +0000
Message-ID: <BN9PR11MB5276122C4CBAACB295DD15E78C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <2-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB52767A4CCD5C7B0E70F0BA2C8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxFOPUaab8DZH9v8@nvidia.com>
In-Reply-To: <YxFOPUaab8DZH9v8@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 591663a6-d84d-49e3-a2c4-08da8c965a53
x-ms-traffictypediagnostic: MN0PR11MB6036:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+xb/Mi6CTezJKOyylvS4IqVisHVmuJgjMElSJGPtmKo/h2w3G/FQfaSdnzZQOwioxBWYTIIgMf9ueShI6MfnjTy7T8hW4T7YWVqmlIhuT6MxFRVIahK73JjP3EH7fV3/bZ+36E94Ft6pQfp4qaQbGiUn7On6DMNzuJl7CgTo0F2ah3xhCUyStWVQX5xpkiEdRXJKBRBJIXiv1eQE76ZpbtUk1WCBt7SZd1j2IrZqlkzPaKk/AyGrw0m+k2/h1RpsUbdhBD6vo06npWwOYhHyVw00RT0/JbGowlWVIXk0mo5dp+L0A9hUSAnw8W/lqo6abKeaM7QpCXYBsBTR/6FeNGNR4qQ2fQy9YlVmnHc5lEAQ/XQAVjmQaXYOCThGcRONsrLgVdpsGmP8SDFzKXveuv2Scb2dn9+162X9vqzH3hblJQQPgifyvmeSlEPmw5zVYG8pprNcmpN4ZpsCGK3WTKllUpxz0aKpqt/yNl+t6EWDkULBK96akRDFakAL7BEqocvwGwnszwuRagyNhRs8HjGDyIsGnVU7Mb5YXNInomHQExVnvlrADIyQNBdOvV+paQ9kY5IihwdAyoZ4b4tt3IlJflh2FZlOgL8fZa4TU24Ln6iYKuB657m2iep4mglm9epnu8+JI77ekCr4Qy4iE4tuy00Zanx2r3MGPjmWT7S7gsuZSZdAUoRPKgCPJP3uTbg24VD+ON9fKcphIKuftCAZI4H2hcxkrbBKxROujCHMAlZDxL6ydiVxtlN4IW0tNbB0WXWuLEgfPP1IzKeRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(376002)(396003)(136003)(82960400001)(478600001)(9686003)(316002)(8936002)(5660300002)(66556008)(76116006)(186003)(66446008)(64756008)(66476007)(66946007)(4326008)(6506007)(33656002)(55016003)(41300700001)(7696005)(86362001)(122000001)(2906002)(83380400001)(8676002)(71200400001)(38100700002)(52536014)(6916009)(38070700005)(54906003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?63i+c+MO/UoKMOhTvkVAV11DVSLxPi1aProlCBkevSiv0bNMBlHQ56Ad2F34?=
 =?us-ascii?Q?k8+DTsM4SR7C/L0pAKqrz0wR7JKeGzuVmUvqeiBpQn4Bap01U32a7eUBx+qO?=
 =?us-ascii?Q?qbMnKizwBQtZGfFn/zsPEb8pEfeidELbNx5dzEpBhbakmb7gxLpP/TA+pdil?=
 =?us-ascii?Q?5GH/2V8wg+MGzEFeLpxp5fIJXxTHNXg3h+X+h13oQiXW4tgj7qSO03RAs4vp?=
 =?us-ascii?Q?EqsTcbcp3VR5yWU9uSwMegLPbvmtdVX5p0791n7GBFgcJ+kbPF+3Zjfc9baz?=
 =?us-ascii?Q?jEPILHMbaAWpy4hv2eMBW+UDTb6Bxh/tzhz4sk8eLpgiPpxxI22xHhsWiF73?=
 =?us-ascii?Q?jrSXnbn2Rhf8u+pUnTgNL6dv76/0qzJYuzanH9yDtduCbfqbn0Q7PZFP3RLb?=
 =?us-ascii?Q?EuL2khruiOxwYlydCK6aDtLBu4qo6IFQynR8hVl1L8W9wN00SqA50JndBJPV?=
 =?us-ascii?Q?Zkplpa9gXvS4+HqwUdnn3R+yjkstSYv5My1y+tvU9RL7WpTScEky0Xh35xy5?=
 =?us-ascii?Q?yhY97CORk7AX/7trRt5fWrGCqn/WbB3SmygsKkbjy0SFM8Fq6xmwc+y1BC0K?=
 =?us-ascii?Q?3uImWfqNC55WXtn1xArxgMPPcBcM/EWIPO8h5L7pktgFOfMkM/HdDowtMmF+?=
 =?us-ascii?Q?Zo6IpoYyUTxPF1fVoudGabYYIfez0dli6egkX3jpBMf+ZZVXudfFeAv3/ZsG?=
 =?us-ascii?Q?4rRuyF2ihZR7QYG4YgNV/jFcpu6iRcUFN5cBzpSu2lvlwn4rfDawl1leiGdN?=
 =?us-ascii?Q?0ymyx+61UltXswHDRZvNkXf8y+0ddxZ8pzOQlm4N9p+Ea+jn+HOAf5/najWU?=
 =?us-ascii?Q?NuFMRJhJvHxUXQApZyDcL1rRN6HLYRp3Nz9X4kZIyLj59FNDKJST2a17ocbK?=
 =?us-ascii?Q?Ha5e0mn8benE0+QtgeLwmt9Cs5j11ErKkMmUtSTzWJhAssg18/MnhkzpCc0X?=
 =?us-ascii?Q?03NHJCu8XkZo6O0DfezaolEQ0B+PoCFbOoBJ4yOi9jDEFWCgOBfIsjsdl+7I?=
 =?us-ascii?Q?UmzDulgZ6tf4zXFx+KtfZadBaSI1BYGt5qfF45YgEQ4Iywybkh24GakhnJf5?=
 =?us-ascii?Q?ISBg2JvFsrAh7QG3IkLCSk7XOja8AJsW1IDprI/QnFPUqS1zF2krgOjjy2es?=
 =?us-ascii?Q?R4ZEkZ/qzaVnMKU9l0uv96COsfVWCSVPnyUqf93e3LXyEjLajkaioeS5ZEwx?=
 =?us-ascii?Q?RxSnc4sBawCUauoATo8Gtt+A5pIOkX2rbar4/H+B1CZHFUPbo6dwLz8wod49?=
 =?us-ascii?Q?NBl38cRcT+KCY5AZ4cTyr3PwQjpDp1XSgC5d5YXiEkb51BNpX9r0VpniM/c8?=
 =?us-ascii?Q?O9m3GRSA83/sDJrmHk2xtRxXOxS8cW2AHIoLnT9kQdXrwww/IHgC5Kl2m3kp?=
 =?us-ascii?Q?Vb0suSOnAWBDhPdyZljV5AZvIWwomRKpLbIgHrbf4fwXklYTgVasBXf4aPnY?=
 =?us-ascii?Q?vipQ0aJIO63tFcvW1HOyGZmNwObkdNuLH2/ylKNNeVfcBcrB3sFhfF4spSDq?=
 =?us-ascii?Q?KI6eGwoyCKCAfDVC62gUdR8BgRBdMwxlRGsZtQ/RYVVRJRIWffMbS2TFpWa0?=
 =?us-ascii?Q?IXCeTj6UM3cldf1FoibTjgDI9uPKCKJzsX3AM9wK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591663a6-d84d-49e3-a2c4-08da8c965a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 03:51:01.4448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DxBAd0qjKRWUt4eELu1WWgETb0d6qbvWVtzFqDCFqR3O4WD2+zRCe9R9jvcGzh1aDxsv1EPTiIux1DkBKlis0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6036
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 2, 2022 8:29 AM
>=20
> On Wed, Aug 31, 2022 at 08:46:30AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, August 31, 2022 9:02 AM
> > >
> > > To vfio_container_detatch_group(). This function is really a containe=
r
> > > function.
> > >
> > > Fold the WARN_ON() into it as a precondition assertion.
> > >
> > > A following patch will move the vfio_container functions to their own=
 .c
> > > file.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/vfio/vfio_main.c | 11 +++++------
> > >  1 file changed, 5 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index bfa6119ba47337..e145c87f208f3a 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -928,12 +928,13 @@ static const struct file_operations vfio_fops =
=3D {
> > >  /*
> > >   * VFIO Group fd, /dev/vfio/$GROUP
> > >   */
> > > -static void __vfio_group_unset_container(struct vfio_group *group)
> > > +static void vfio_container_detatch_group(struct vfio_group *group)
> >
> > s/detatch/detach/
>=20
> Oops
>=20
> > Given it's a vfio_container function is it better to have a container p=
ointer
> > as the first parameter, i.e.:
> >
> > static void vfio_container_detatch_group(struct vfio_container *contain=
er,
> > 		struct vfio_group *group)
>=20
> Ah, I'm not so sure, it seems weird to make the caller do
> group->container then pass the group in as well.
>=20
> This call assumes the container is the container of the group, it
> doesn't work in situations where that isn't true.

Yes, this is a valid interpretation on doing this way.

Other places e.g. iommu_detach_group(domain, group) go the other way
even if internally domain is not used at all. I kind of leave that pattern
in mind thus raised this comment. But not a strong opinion.

>=20
> It is kind of weird layering in a way, arguably we should have the
> current group stored in the container if we want things to work that
> way, but that is a big change and not that wortwhile I think.
>=20
> Patch 7 is pretty much the same, it doesn't work right unless the
> container and device are already matched
>=20

If Alex won't have a different preference and with the typo fixed,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
