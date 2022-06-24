Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C335559334
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 08:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiFXGQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 02:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXGQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 02:16:19 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24FF4D631;
        Thu, 23 Jun 2022 23:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656051378; x=1687587378;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4uq2/4ZBLj2o++nE9q0tN6AQfiBZTqTk0dA5724flZg=;
  b=nJPgiUUsahWlYwXop6khjm+zyWeyio9XnUUHYamIKJLRAgZscVKP2CG+
   0aoJkuSYOIkmFVSx8m2TZv7XJQmOQKR4fd58egj2GpiO4ZTVkFhlyYAa0
   7cZCEOdehexv3ESI3sTjGtuK54Uwn2JMYWp85HxPPshKsVX5wDjYvOs/y
   shkw/lxskP8IUZZ1JxQNFOm5cbXjRi6n7cXYAvcWOJ6/rHk7AkkItjGg1
   osztrjpHv7UEggpFWasMXrWHfWhz6ILdVKk37KvZDcHctroCmxu/7lYiX
   zzvYFMGSJRdJlXVBuGddGf2EUNTY/cnfDfVab4zj2Ppp3RyxLWJSQiAqG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="279699208"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="279699208"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 23:16:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="586466299"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2022 23:16:16 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 23:16:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 23:16:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 23:16:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDU0oJBrPTeM9GZbfYVHCJPneRWHX+oZPFxzDnhVQTTE38L84NBTbcsrebHvm4ihu6fub0zhZeDXNw0lYl2+29f0sa/l/rZB+CULpKyScUpXw/5R8j4UsZJub6kL9xzR6oo3nVDa2Vc9zyBCPsjptdQ0yMuP18S91QlDpWdBnj0EaLkJPg5xVX4LwMKnoUSoO8FoWxgkFBT94rV+0YIMMWL0WCmjK2DUub+68zQE3q0vXZApZUxan9qjkdEHSjtCEykZWyaEHRAwh5c4jtCyESFu+ciFyWt4HeltmDVX96NrX+jr/q62fLHLT/OqIjY2lH9wiJBGG9zQHLgxwqe6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sM24M8EWTU37ZtL5sdXGAwPx+ETCvLCKdnK4jo1Fu9E=;
 b=j143aAgCDUMo26YXxm6pnhc5ccWDH4juCVsDJLkXb1qq9CaP3prm9wzMB8R2gIWlA/dXDI9gj/f0zaNkIqode/x0PfZNkdmHqINIiuEmJPFWJBXwbhdXkNU2s6esp+fanfW35vuljGmS2EcY26xPypLR4Vxwa7eaChTfiNJZllJfI4YnInt+fDW/Vd2Ec/sMg/906GaihNx9ulTVMFCYNW6ppAEgF77HN6v87diRXF/kIna87uTHKsAB9EpzHiIUMMT7QL7gV2jRqLVDTrnNk3xU8aCWPfnM4YBmgGhLdadyN1geThIaYgjWho7BTl8B1odVy4AIO6BkabUwQaUNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR1101MB2246.namprd11.prod.outlook.com (2603:10b6:910:21::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Fri, 24 Jun
 2022 06:16:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 06:16:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yong Wu <yong.wu@mediatek.com>, Nicolin Chen <nicolinc@nvidia.com>,
        "Baolu Lu" <baolu.lu@linux.intel.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYhzwc+z9iMdoELUOwrg1xSZWs8q1dxv6AgAATDQCAADDjAIAACdeA
Date:   Fri, 24 Jun 2022 06:16:10 +0000
Message-ID: <BN9PR11MB527629DEF740C909A7B7BEB38CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
 <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
 <YrUk8IINqDEZLfIa@Asurada-Nvidia>
 <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
In-Reply-To: <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74ba5b81-fd53-4198-60ad-08da55a90880
x-ms-traffictypediagnostic: CY4PR1101MB2246:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZwwV/VJOS7HVWaYwyA4dsFtTMjtULz3XX/AS/JkToSWsvK4V0U5KE9es8tlXbebICfD+eTD9D2fSDS+quUaKnqgj6fUTcukVFN92O2MQIqGJf2Qw4Q5n2Q5IuD3RdH1ojsM0eImVQkDyP4GJHswgmr3LiR21Qf0YnXgtYsVHVaujc9hnPT2HFx97mNsu6385vraq1EDUM8sX9WPH3icR7GKLWHYe1nbLdL+ee/5w7P18wP9S79YjCrWZebX0aK1RufCu4q3AnRCvF2cElHdU446o2LZoJP+3nmP2qIndul4zqPjKbBMceXtzJyhCBmj1aGgNKth7W5UhItMpGJm4EFHf5VpaW2t3mPS6ZHWhfwsBuUeBmjGGoYgWRI7QUh+cfFguq0vBBZ2D+v5TJ5+1FpL7AHdCvP7q8SCQlGSk745ltdh7WzP81C4oAq3YGl+j8UQ2CWZkDeN2kwICe3w4pyWBfpSqm0ifKLU1Oz508Rh1XQEWSS5wCARaDRcFVPlvfDa0zKK1aKhuivKNdN9JrCUZV+mNDx1/feBKB6mglZK3s4VsD4+larvrNTXNxOiOCPygYXhJMMOlw+1MOx/21VCvsOPeFX4DS7j8KDhcFyiH+BE3C++kPuJ+OE+JCrZE3y7Xm8Vzb9CA+Qv4vQR7qLMBYIAWIGld+8XunhQ2IiCHvZD4SP9Dv6zK8V2D9/la1p1vqke6T9WcxOPWMAXf6W1GjBiJC4riXm9HjVgqLAGOIFSX/lNg9GHCb5deXFNc1uOYeQkPRP5CPLlFoVD9DX65FYddDaChC1iRfpPbf8XfjG0G2+nlJMHR81drkH3Wuks+ABLXChTHTecv2XQpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(136003)(396003)(346002)(41300700001)(6506007)(4326008)(186003)(83380400001)(66946007)(7416002)(66556008)(7406005)(64756008)(38100700002)(8676002)(76116006)(110136005)(71200400001)(66476007)(478600001)(52536014)(66446008)(9686003)(26005)(7696005)(53546011)(54906003)(82960400001)(38070700005)(8936002)(33656002)(316002)(122000001)(86362001)(2906002)(55016003)(966005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7y+lG9YFZmxl+4w62lEhiXwxXi/7200BWprCmy7rvq6MHt69+ERqxkNEHhF3?=
 =?us-ascii?Q?47k59wFaAqNNcHN+4UzhdtUIvcJmhsV/kSqd5mI3WBE4bHThhw10g5GzMLj1?=
 =?us-ascii?Q?HuQv7Kn0OZ2fNdJg7v6REkg3X2/mgs8XQjsmdNy3u1tE3MuK7ZSzOvvZ/6dF?=
 =?us-ascii?Q?7Bl3FucNWcNLbDldu+DxP4nwOiIfzJVc9upubXYTju0E5oLDPfafbdrxvdQl?=
 =?us-ascii?Q?b+FL+jrwbOSm14+iU7AJW6q7g71rSEQQtNLwx8bVZa5jJrgZ/tBgqD4OSRVM?=
 =?us-ascii?Q?RTa+LkIPabBcu2mP0ZXs5VFQExdR4PYz16m5ghY7QgPGykg0d+qU5sywoQl0?=
 =?us-ascii?Q?fgQLkIwKh9+5sH7GI8tZ7dnwgWBWXKjuF2wutLcSs7cwtH20VMUXbbTT3nm1?=
 =?us-ascii?Q?H7tC7GWdf3pj/6lylQzT2mdcftraBxp2uHBoKbxi2+pr0h/q3oLruCgms/Re?=
 =?us-ascii?Q?Fd5GU2+ny1JhJsLf32tYC0nrg+qHJZK3Pq8NcRmajzpIR2YreVyPmaYl/s+X?=
 =?us-ascii?Q?7Gz4a2stYcpb9lNRuTn9K2UXGpv1/hehcoc+O0L8myo+w6QpXeyTJI+Wbn3+?=
 =?us-ascii?Q?YhhGjrt9gEZA19xn9So5omtBvyxh75WLZ4LKKK1EfIbAZEC4PmU4t4n0XhwP?=
 =?us-ascii?Q?gNvaXm2q5FqiSblalxziXu9/kzFbMO2Y9ElAoS+cIvNeL6+CcGajR5MvsrL6?=
 =?us-ascii?Q?pwJ6VxD5SZruf8f6Qe7Wp3ag9mt6/zQG+TA5qIC9ebKWSeuk+4voLCWZlS5c?=
 =?us-ascii?Q?jkqKpZrCt3F+K/fkN2yu6R4ujbl+02uqxugNSnYWVza4tGnecmadGKWN6YSR?=
 =?us-ascii?Q?YmFP1pdOVY4hU+OJjOF6fH5jAwe4ooAN0kUb2fvGHS+r3DCJNvIHMC49d6A2?=
 =?us-ascii?Q?/t8JkE581+QSKWu6cjgGILl4/C6LWE/9H8iiz3GP3/nDyIXXi1Wm18iDbQT6?=
 =?us-ascii?Q?3/Rg/+TXh3wxdTYEtrr6Maq0wWKkGdmzkmyN8Ov3LqMClherG81TJOTr0drc?=
 =?us-ascii?Q?JQJqu0Yce1BaTgAtHR05WvRAcLMuXGwd0yv/2lkbAK1FX7zyC2ACwZQnSKhd?=
 =?us-ascii?Q?lGs6qPvlyqRZYcL6DBSI0RCyaOEofFKZU2i9CN8KDsfq3zQyy5VgRe3AxARy?=
 =?us-ascii?Q?UXUqo418NCgv5NcRm0abY1xPnZ0zFVsE21PTS8QNWUzVWhfrSy6SOfffFauo?=
 =?us-ascii?Q?fZyII9lLkvO3yc/56GEJNxlIu9aW7KJBIGmQmqLtd1jvWtzk54QcbLZDIybB?=
 =?us-ascii?Q?gbOpLQtmn0abJ8ebrR0nbfkdv2AwK5T1wrPmsKrbNO5+PRybFO3Og+EQ2vni?=
 =?us-ascii?Q?wy1R4Fu2UcZOsdfrst1cUYwupjJgNFKLJvxGj95xSN1mfcrSp4fcDxpGuOvr?=
 =?us-ascii?Q?UuSkBvb64bmIYOWmqP5O4hawGldYp4x9t0MaBGhlv8jRYcbB+q0pq7BDUWZd?=
 =?us-ascii?Q?6sKjUyrFOuZgAx6qclmB86PXnb1rYquL1ZqPGSZaknNGp0n+Hn/NJgqfBAWc?=
 =?us-ascii?Q?63cDlReM/oXY6Dh77WuAL7V+HWbCckQ5VabXO5OSSSfotQQYGEPJ3yS+m+WV?=
 =?us-ascii?Q?jFWId0lRp1U3PL0PQ2gbDbL3xemYsZuDlzj5SQoe?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ba5b81-fd53-4198-60ad-08da55a90880
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 06:16:10.6342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wFKlbjuB+3MkwmfpNTRXBaYe7fMsPiKonVsy0CxXAN7aQ3LsXIzNAUd4fe79s7s8rCfTUVxyUrbJIGq1O0N1mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2246
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yong Wu
> Sent: Friday, June 24, 2022 1:39 PM
>=20
> On Thu, 2022-06-23 at 19:44 -0700, Nicolin Chen wrote:
> > On Fri, Jun 24, 2022 at 09:35:49AM +0800, Baolu Lu wrote:
> > > External email: Use caution opening links or attachments
> > >
> > >
> > > On 2022/6/24 04:00, Nicolin Chen wrote:
> > > > diff --git a/drivers/iommu/mtk_iommu_v1.c
> > > > b/drivers/iommu/mtk_iommu_v1.c
> > > > index e1cb51b9866c..5386d889429d 100644
> > > > --- a/drivers/iommu/mtk_iommu_v1.c
> > > > +++ b/drivers/iommu/mtk_iommu_v1.c
> > > > @@ -304,7 +304,7 @@ static int mtk_iommu_v1_attach_device(struct
> > > > iommu_domain *domain, struct device
> > > >       /* Only allow the domain created internally. */
> > > >       mtk_mapping =3D data->mapping;
> > > >       if (mtk_mapping->domain !=3D domain)
> > > > -             return 0;
> > > > +             return -EMEDIUMTYPE;
> > > >
> > > >       if (!data->m4u_dom) {
> > > >               data->m4u_dom =3D dom;
> > >
> > > This change looks odd. It turns the return value from success to
> > > failure. Is it a bug? If so, it should go through a separated fix
> > > patch.
>=20
> Thanks for the review:)
>=20
> >
> > Makes sense.
> >
> > I read the commit log of the original change:
> >
> https://lore.kernel.org/r/1589530123-30240-1-git-send-email-
> yong.wu@mediatek.com
> >
> > It doesn't seem to allow devices to get attached to different
> > domains other than the shared mapping->domain, created in the
> > in the mtk_iommu_probe_device(). So it looks like returning 0
> > is intentional. Though I am still very confused by this return
> > value here, I doubt it has ever been used in a VFIO context.
>=20
> It's not used in VFIO context. "return 0" just satisfy the iommu
> framework to go ahead. and yes, here we only allow the shared "mapping-
> >domain" (All the devices share a domain created internally).
>=20
> thus I think we should still keep "return 0" here.
>=20

What prevent this driver from being used in VFIO context?

and why would we want to go ahead when an obvious error occurs
i.e. when a device is attached to an unexpected domain?
