Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C7975714F
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 03:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjGRBSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 21:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGRBSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 21:18:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E072ED;
        Mon, 17 Jul 2023 18:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689643111; x=1721179111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bkTw7HC12ZXcNYuYXYNnSy/FFxkSUWhvv4YG9hFgvnU=;
  b=nrinuEfzUNkOI4v9YQHwK36qpmvvmzxcank1c8bJH4864q9wHLq47z1X
   Q2ZBQjU4iow/zwsWeIT17Ble4OgHa8+NOeDvtPVAyZINaQ234qLB4D5+g
   +K8lrL1iECMT9HuewLgcSqVsNoersNRALpYD+/tF0tEamV3kT4bSbXHc/
   fAIoX7D0He4tfR7cMrG6sPT26N4GZrYXqxXydnErEYv/habm5UyxjSDLT
   eutyMADhmn8lZGNDg/BAFuZDDYTTrVs0LszxRpUb1KVeoPP8VmK/9w4OI
   zohu8LtAhyeY5iirF+T14obwyJjok3k0hwP9GtbC02+5mqCjHngpdhu9k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="396917579"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="396917579"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 18:18:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10774"; a="673721283"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="673721283"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 17 Jul 2023 18:18:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 18:18:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 17 Jul 2023 18:18:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 17 Jul 2023 18:18:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASN/8MKQqkYLMMR+OqFT1Kb3eADVEJSTB4Hhw+Q9Traye1N3rpaSVBRyCbSyxo+hxFccKhgkYF7Boa+VGTrit8rPha54YNWS0uKQ4rcJ92Zsc/pjUKxOW1t4hthq391dER/FJlND2l7kAB8SmQI0rVjNYjB7Dy98hFNav30f0UEqyeOv899qLXWXENcp12ryfal64gRoL/x14ZifagyXX6Wm624weNg79ldnj9Hi9mLTVU+Qp+c3GIgDRHxqmCOq4jtUdlyojPl+3EBLzuq7h3vKINHhPywrtbnQ5NwY8bEftg65MWrOvXiOtEi0GHeisURHnjpOERQYArwYkZ5mtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lI6LJI8rjiCvCU9lRhqwrjAfpsHLv0D0hsJ/ojD5fRI=;
 b=SCc0hUbe81J1ZxcUvp8Oh2BcoqTesEYZSVE/0KX33gMBdMmlJuHxFRfEaQEGjlero+CKO21wNErqqcOGxTQD8DxTSNw7ORk92PWSnAkiIISAtafiXSLWG91WQJao7YT8FLMGcUwma1APiHTVDNJf56MunrXJQDkRU6LOd6ZZI/yx3JdeM2oA9cHmryRzFCBeUeg0vGtn2gSJzGNclLorv/xUZOH6JXYsJLVeRZ1hZiD5IE5ZUOnK0dF4+RSu3IDwhgRpD9XyC9ZzyN/5NQrs0lpXLisT7NvT/vWC7RfBsK5yvGkPZXCD/TSbtbpw4ebkXlz2Jz/k3dQ6Oa1ZImJxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6829.namprd11.prod.outlook.com (2603:10b6:510:22f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Tue, 18 Jul
 2023 01:18:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 01:18:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Topic: [PATCH v13 21/22] vfio: Compile vfio_group infrastructure
 optionally
Thread-Index: AQHZoDagsdh+fCMUvkyHLuzt/JVGpq+9qlBwgAAgfRCAALKIgIAAbOlQ
Date:   Tue, 18 Jul 2023 01:18:07 +0000
Message-ID: <DS0PR11MB75295D5E5D220CBDED941E0DC338A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
        <20230616093946.68711-22-yi.l.liu@intel.com>
        <DS0PR11MB7529C571419F1DB629AB7E92C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
        <DS0PR11MB7529F01B82FB659B96D15E38C33BA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230717124539.743de027.alex.williamson@redhat.com>
In-Reply-To: <20230717124539.743de027.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6829:EE_
x-ms-office365-filtering-correlation-id: 0a73c568-bae0-4ca9-df61-08db872cd817
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVgHa9gMiOQjlsTB8sfKLgR4sHQeHDg6lRkOms9z4kl1gxk+LH/GeADqp9DRtd6r9RPNKAhE+r7qsw87s8NMyssjKhMeYGgVP9p3Gg183Eu7dUHgwSR/s6P3HAePaaNlfD+qbSpiUa0mCWwFc85q/53V4CP+idBvWdrsJJlgkCh6Su3WknZB7l3yhsqSrGWgywKEbxpkWTr0S7RANO+sW3381E2ELzGDaLbJoLS2q+65z8FxQZsCaNeU7wpsdI7zBpf558m8jisfqR05YylRtt4aCQzw/byLq2BsVumJStCdIDrzpXnhBL5Ad9Y8N/5br5essHyFNetsGwVUUJYozTH3rcEppB7kCx7CDUGF6Qv+zpenNNK6+x2QADs+su1M3rOzAk9+ijyvIq/pnrNaeXQYJdsYXAqRrikv+3j02kYG794pnYalEnlo9l6fNLg1nOCkcFkynoEdGYEaJye1wHyD4FAaUBxw1QDDF78gvCHyp3C+h/MCNusb+vMoEQBIDGGX5W7aYmlCyk4N+qf1OwKbR5CsL2L0m7IXRnAVqXKBACTx6sGOgjf4WC2nHrgqHaVo65vPnCsCJDWpi6MqD/ynk/xJovSPYsuz+m74dpF00vtjm2c4gYlfll0zJ65d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199021)(8676002)(41300700001)(7696005)(7416002)(66476007)(66946007)(6916009)(2906002)(66446008)(66556008)(8936002)(54906003)(122000001)(76116006)(86362001)(4326008)(316002)(52536014)(5660300002)(30864003)(9686003)(64756008)(38100700002)(83380400001)(186003)(26005)(82960400001)(71200400001)(33656002)(6506007)(38070700005)(55016003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lG4NbB/2qzwvMZqXrsUtkH7YMwcPeDfyUGLI7lqU2IQntQK50zP6MfPkpp8d?=
 =?us-ascii?Q?vqXCfTBOE+Ik964sjrDeyB+ZBUP/s7cuElUJn4lsCifX3P/PbGU1X9awBvc7?=
 =?us-ascii?Q?l2xaUFG7JBdDg+xW8kkIv9VwHsSQtZNwJ0D9BXVJ4wEkINxOOCfDRXV7mEUT?=
 =?us-ascii?Q?4QLUhXCEYOd2rnjIdCkmDtcXd1P981aN0bL2yRM38b7RTUNS+L0Ou6JcsQ0S?=
 =?us-ascii?Q?I2i9LXo6/UunaScgLUP8DCNikWB7Qlxaq/Wbfwxh2h+lCtUxCbDsTO+ttk+H?=
 =?us-ascii?Q?ALHch1Suex0MYxTdSljY7SFIGs/hg49yFx0rm1/guU46Kl88kT4hDwtXqnLQ?=
 =?us-ascii?Q?t95b8SjfUuQQ0zCo5EGcq/ECZMmX/xoEm2eJqSDODI1ccr66eIdbvfaILpXs?=
 =?us-ascii?Q?H3MDg/qse1poWGXQOPCv0IFrYRx1cGOtcT/lvzaMgix6U19JXBw5sPmPr0Kw?=
 =?us-ascii?Q?+ktuPFlrwkiUXmm50WoomKHY/SJS0wNkap4PSPm5zL8iKuIuSgCdxM2xcv1k?=
 =?us-ascii?Q?QnFKfWcwqu71yvd+Qulm7GSVzh5cQZdtGLFR6RVdx4Gp6zQWeEXgTHQrn0N5?=
 =?us-ascii?Q?1EiMuy2CTnals7Bp3+UwFAacEJz9xwIiyuxoxmhQ0yv+ozuPQRTqObXywP5n?=
 =?us-ascii?Q?RTlkqgMW3CR809mUfwMbiOlHp7MOkxLC94pontUNiL8z/AP2YCO5ry3qk8up?=
 =?us-ascii?Q?QRC91f/BuiMOduF0CvWEh+DQd6X5GAY19DF8qxTH/hhD8mAIiOGuOqySrJgJ?=
 =?us-ascii?Q?YrWxoDC/68wni/HiFnBX6/nQhet8+YSgsRW2K+Tjf09mVlQC51LnWKx1Evsv?=
 =?us-ascii?Q?5ZiZgvMxcjYFuM+PFA+5dQ5yxHK5RAbQTHSvXRHz8QqLjKn84B5m8n/FgqvZ?=
 =?us-ascii?Q?L8+5hwLdW1aNAhxnUXMdYnriE6jdql7Oe9SDuM4jtQoF3DEwILRULNw9Ya/i?=
 =?us-ascii?Q?6djmyvt0jQgQ0DqxLOmsWTG7rsfoiz8x1qs7803WGE0gh8blvb+wD/GVLZpu?=
 =?us-ascii?Q?weW2fmSM2Xxo0rI7JfrMrTg45/GHlnLnvSo+HxC5TWSPBEuiSxadRSUIkj2k?=
 =?us-ascii?Q?PPfzLg6/f4nY3kcFTVK5VTh2BlZ2yuzecXC2kQ9K0iN/ca4DZOxZ1bq0BeM4?=
 =?us-ascii?Q?SGY2yNx+wKa0B6CrRDHqICZGxOgXdXSXnEQc8AioqC0rSdji6jjtkXOdbEro?=
 =?us-ascii?Q?Cr7hi8CYd5qx5ecgFc7jwHdfzQczPtiNWKwM7pJq6TRc24EU15n6J8m3JFK+?=
 =?us-ascii?Q?tYmJb4xGdRyZhHVoNqu3Z4zY3DCZ8JZLysJiP1PpWhS6ql7KYrBA79aAJupO?=
 =?us-ascii?Q?CtDlNnzLKf81c/rBB4yG8LUBEKBOftYITe1suZMtrc7HIcLEgkdW9B/kcyaQ?=
 =?us-ascii?Q?rGz9d4k5cFh4Bn5U2EyDG47ELZi8Cc/cXgfIX6TQkxRDL4h9ehVNn3q0h1Cw?=
 =?us-ascii?Q?L0rtrFBGayf05Lxs3NBETSZKvpgCxjoc7RsrSYPmN7JTRFe7+xHoh5kMPDTx?=
 =?us-ascii?Q?D4tl7uCDQCwr9bXZpaEVi6rBCkDnv38JZedECXDYzqcIGUgR5cy21p2HoLZT?=
 =?us-ascii?Q?1RBfStUt43cqUjQsrLN/Od+Sj0Xl6Xjl1wnK5bs5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a73c568-bae0-4ca9-df61-08db872cd817
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 01:18:07.6359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3mFUOrfvtMPFpU3QzKyPzWzEJ/P5qYkWfUGnLv0tRCWvL53U6YfHPgrvRCt5DxZMOv3fd4WmiaN3X3P1eLFCpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6829
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, July 18, 2023 2:46 AM
>=20
> On Mon, 17 Jul 2023 08:08:59 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, July 17, 2023 2:36 PM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Friday, June 16, 2023 5:40 PM
> > > >
> > > > vfio_group is not needed for vfio device cdev, so with vfio device =
cdev
> > > > introduced, the vfio_group infrastructures can be compiled out if o=
nly
> > > > cdev is needed.
> > > >
> > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/iommu/iommufd/Kconfig |  4 +-
> > > >  drivers/vfio/Kconfig          | 15 ++++++
> > > >  drivers/vfio/Makefile         |  2 +-
> > > >  drivers/vfio/vfio.h           | 89 +++++++++++++++++++++++++++++++=
+---
> > > >  include/linux/vfio.h          | 25 ++++++++--
> > > >  5 files changed, 123 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/=
Kconfig
> > > > index ada693ea51a7..99d4b075df49 100644
> > > > --- a/drivers/iommu/iommufd/Kconfig
> > > > +++ b/drivers/iommu/iommufd/Kconfig
> > > > @@ -14,8 +14,8 @@ config IOMMUFD
> > > >  if IOMMUFD
> > > >  config IOMMUFD_VFIO_CONTAINER
> > > >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > > > -	depends on VFIO && !VFIO_CONTAINER
> > > > -	default VFIO && !VFIO_CONTAINER
> > > > +	depends on VFIO_GROUP && !VFIO_CONTAINER
> > > > +	default VFIO_GROUP && !VFIO_CONTAINER
> > >
> > > Hi Alex, Jason,
> > >
> > > I found a minor nit on the kconfig. The below configuration is valid.
> > > But user cannot use vfio directly as there is no /dev/vfio/vfio. Alth=
ough
> > > user can open /dev/iommu instead. This is not good.
> > >
> > > CONFIG_IOMMUFD=3Dy
> > > CONFIG_VFIO_DEVICE_CDEv=3Dn
> > > CONFIG_VFIO_GROUP=3Dy
> > > CONFIG_VFIO_CONTAINER=3Dn
> > > CONFIG_IOMMUFD_VFIO_CONTAINER=3Dn
> > >
> > > So need to have the below change. I'll incorporate this change in
> > > this series after your ack.
> > >
> > > diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kc=
onfig
> > > index 99d4b075df49..d675c96c2bbb 100644
> > > --- a/drivers/iommu/iommufd/Kconfig
> > > +++ b/drivers/iommu/iommufd/Kconfig
> > > @@ -14,8 +14,8 @@ config IOMMUFD
> > >  if IOMMUFD
> > >  config IOMMUFD_VFIO_CONTAINER
> > >  	bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
> > > -	depends on VFIO_GROUP && !VFIO_CONTAINER
> > > -	default VFIO_GROUP && !VFIO_CONTAINER
> > > +	depends on VFIO_GROUP
> > > +	default n
> > >  	help
> > >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relies =
on
> > >  	  IOMMUFD providing compatibility emulation to give the same ioctls=
.
> > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > index 6bda6dbb4878..ee3bbad6beb8 100644
> > > --- a/drivers/vfio/Kconfig
> > > +++ b/drivers/vfio/Kconfig
> > > @@ -6,7 +6,7 @@ menuconfig VFIO
> > >  	select INTERVAL_TREE
> > >  	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
> > >  	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> > > -	select VFIO_CONTAINER if IOMMUFD=3Dn
> > > +	select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn
> > >  	help
> > >  	  VFIO provides a framework for secure userspace device drivers.
> > >  	  See Documentation/driver-api/vfio.rst for more details.
> > >
> >
> > Just realized that it is possible to config both VFIO_CONTAINER and
> > IOMMUFD_VFIO_CONTAINER to "y". Then there will be a conflict when
> > registering /dev/vfio/vfio. Any suggestion?
>=20
> This is only an issue with the proposed change, right?

Yes.

>  I agree with
> Jason, removing /dev/vfio/vfio entirely should be possible.  That's
> actually our ultimate goal, but obviously it breaks current userspace
> depending on vfio container compatibility.  It's a configuration error,
> not a Kconfig error if someone finds themselves without /dev/vfio/vfio
> currently.  Thanks,

Sure. Let me post a new version then. I've addressed other comments
from Jason.

Regards,
Yi Liu

>=20
> Alex
>=20
> > > >  	help
> > > >  	  IOMMUFD will provide /dev/vfio/vfio instead of VFIO. This relie=
s on
> > > >  	  IOMMUFD providing compatibility emulation to give the same ioct=
ls.
> > > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > > index 1cab8e4729de..35ab8ab87688 100644
> > > > --- a/drivers/vfio/Kconfig
> > > > +++ b/drivers/vfio/Kconfig
> > > > @@ -4,6 +4,8 @@ menuconfig VFIO
> > > >  	select IOMMU_API
> > > >  	depends on IOMMUFD || !IOMMUFD
> > > >  	select INTERVAL_TREE
> > > > +	select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=3Dn
> > > > +	select VFIO_DEVICE_CDEV if !VFIO_GROUP
> > > >  	select VFIO_CONTAINER if IOMMUFD=3Dn
> > >
> > > This should be " select VFIO_CONTAINER if IOMMUFD_VFIO_CONTAINER=3Dn"
> > >
> > > Regards,
> > > Yi Liu
> > >
> > > >  	help
> > > >  	  VFIO provides a framework for secure userspace device drivers.
> > > > @@ -15,6 +17,7 @@ if VFIO
> > > >  config VFIO_DEVICE_CDEV
> > > >  	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> > > >  	depends on IOMMUFD
> > > > +	default !VFIO_GROUP
> > > >  	help
> > > >  	  The VFIO device cdev is another way for userspace to get device
> > > >  	  access. Userspace gets device fd by opening device cdev under
> > > > @@ -24,9 +27,20 @@ config VFIO_DEVICE_CDEV
> > > >
> > > >  	  If you don't know what to do here, say N.
> > > >
> > > > +config VFIO_GROUP
> > > > +	bool "Support for the VFIO group /dev/vfio/$group_id"
> > > > +	default y
> > > > +	help
> > > > +	   VFIO group support provides the traditional model for accessin=
g
> > > > +	   devices through VFIO and is used by the majority of userspace
> > > > +	   applications and drivers making use of VFIO.
> > > > +
> > > > +	   If you don't know what to do here, say Y.
> > > > +
> > > >  config VFIO_CONTAINER
> > > >  	bool "Support for the VFIO container /dev/vfio/vfio"
> > > >  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > > > +	depends on VFIO_GROUP
> > > >  	default y
> > > >  	help
> > > >  	  The VFIO container is the classic interface to VFIO for establi=
shing
> > > > @@ -48,6 +62,7 @@ endif
> > > >
> > > >  config VFIO_NOIOMMU
> > > >  	bool "VFIO No-IOMMU support"
> > > > +	depends on VFIO_GROUP
> > > >  	help
> > > >  	  VFIO is built on the ability to isolate devices using the IOMMU=
.
> > > >  	  Only with an IOMMU can userspace access to DMA capable devices =
be
> > > > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > > > index 245394aeb94b..57c3515af606 100644
> > > > --- a/drivers/vfio/Makefile
> > > > +++ b/drivers/vfio/Makefile
> > > > @@ -2,9 +2,9 @@
> > > >  obj-$(CONFIG_VFIO) +=3D vfio.o
> > > >
> > > >  vfio-y +=3D vfio_main.o \
> > > > -	  group.o \
> > > >  	  iova_bitmap.o
> > > >  vfio-$(CONFIG_VFIO_DEVICE_CDEV) +=3D device_cdev.o
> > > > +vfio-$(CONFIG_VFIO_GROUP) +=3D group.o
> > > >  vfio-$(CONFIG_IOMMUFD) +=3D iommufd.o
> > > >  vfio-$(CONFIG_VFIO_CONTAINER) +=3D container.o
> > > >  vfio-$(CONFIG_VFIO_VIRQFD) +=3D virqfd.o
> > > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > > index e7a3fe093362..b27a3915e6c9 100644
> > > > --- a/drivers/vfio/vfio.h
> > > > +++ b/drivers/vfio/vfio.h
> > > > @@ -36,6 +36,12 @@ vfio_allocate_device_file(struct vfio_device *de=
vice);
> > > >
> > > >  extern const struct file_operations vfio_device_fops;
> > > >
> > > > +#ifdef CONFIG_VFIO_NOIOMMU
> > > > +extern bool vfio_noiommu __read_mostly;
> > > > +#else
> > > > +enum { vfio_noiommu =3D false };
> > > > +#endif
> > > > +
> > > >  enum vfio_group_type {
> > > >  	/*
> > > >  	 * Physical device with IOMMU backing.
> > > > @@ -60,6 +66,7 @@ enum vfio_group_type {
> > > >  	VFIO_NO_IOMMU,
> > > >  };
> > > >
> > > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > >  struct vfio_group {
> > > >  	struct device 			dev;
> > > >  	struct cdev			cdev;
> > > > @@ -111,6 +118,82 @@ static inline bool vfio_device_is_noiommu(stru=
ct
> vfio_device
> > > > *vdev)
> > > >  	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > >  	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > > >  }
> > > > +#else
> > > > +struct vfio_group;
> > > > +
> > > > +static inline int vfio_device_block_group(struct vfio_device *devi=
ce)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static inline void vfio_device_unblock_group(struct vfio_device *d=
evice)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline int vfio_device_set_group(struct vfio_device *device=
,
> > > > +					enum vfio_group_type type)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static inline void vfio_device_remove_group(struct vfio_device *de=
vice)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline void vfio_device_group_register(struct vfio_device *=
device)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline void vfio_device_group_unregister(struct vfio_device=
 *device)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline int vfio_device_group_use_iommu(struct vfio_device *=
device)
> > > > +{
> > > > +	return -EOPNOTSUPP;
> > > > +}
> > > > +
> > > > +static inline void vfio_device_group_unuse_iommu(struct vfio_devic=
e *device)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline void vfio_df_group_close(struct vfio_device_file *df=
)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline struct vfio_group *vfio_group_from_file(struct file =
*file)
> > > > +{
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +static inline bool vfio_group_enforced_coherent(struct vfio_group =
*group)
> > > > +{
> > > > +	return true;
> > > > +}
> > > > +
> > > > +static inline void vfio_group_set_kvm(struct vfio_group *group, st=
ruct kvm *kvm)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline bool vfio_device_has_container(struct vfio_device *d=
evice)
> > > > +{
> > > > +	return false;
> > > > +}
> > > > +
> > > > +static inline int __init vfio_group_init(void)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static inline void vfio_group_cleanup(void)
> > > > +{
> > > > +}
> > > > +
> > > > +static inline bool vfio_device_is_noiommu(struct vfio_device *vdev=
)
> > > > +{
> > > > +	return false;
> > > > +}
> > > > +#endif /* CONFIG_VFIO_GROUP */
> > > >
> > > >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> > > >  /**
> > > > @@ -362,12 +445,6 @@ static inline void vfio_virqfd_exit(void)
> > > >  }
> > > >  #endif
> > > >
> > > > -#ifdef CONFIG_VFIO_NOIOMMU
> > > > -extern bool vfio_noiommu __read_mostly;
> > > > -#else
> > > > -enum { vfio_noiommu =3D false };
> > > > -#endif
> > > > -
> > > >  #ifdef CONFIG_HAVE_KVM
> > > >  void _vfio_device_get_kvm_safe(struct vfio_device *device, struct =
kvm *kvm);
> > > >  void vfio_device_put_kvm(struct vfio_device *device);
> > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > index d6228c839c44..5a1dee983f17 100644
> > > > --- a/include/linux/vfio.h
> > > > +++ b/include/linux/vfio.h
> > > > @@ -43,7 +43,11 @@ struct vfio_device {
> > > >  	 */
> > > >  	const struct vfio_migration_ops *mig_ops;
> > > >  	const struct vfio_log_ops *log_ops;
> > > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > >  	struct vfio_group *group;
> > > > +	struct list_head group_next;
> > > > +	struct list_head iommu_entry;
> > > > +#endif
> > > >  	struct vfio_device_set *dev_set;
> > > >  	struct list_head dev_set_list;
> > > >  	unsigned int migration_flags;
> > > > @@ -58,8 +62,6 @@ struct vfio_device {
> > > >  	refcount_t refcount;	/* user count on registered device*/
> > > >  	unsigned int open_count;
> > > >  	struct completion comp;
> > > > -	struct list_head group_next;
> > > > -	struct list_head iommu_entry;
> > > >  	struct iommufd_access *iommufd_access;
> > > >  	void (*put_kvm)(struct kvm *kvm);
> > > >  #if IS_ENABLED(CONFIG_IOMMUFD)
> > > > @@ -284,12 +286,29 @@ int vfio_mig_get_next_state(struct vfio_devic=
e *device,
> > > >  /*
> > > >   * External user API
> > > >   */
> > > > +#if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > >  struct iommu_group *vfio_file_iommu_group(struct file *file);
> > > >  bool vfio_file_is_group(struct file *file);
> > > > +bool vfio_file_has_dev(struct file *file, struct vfio_device *devi=
ce);
> > > > +#else
> > > > +static inline struct iommu_group *vfio_file_iommu_group(struct fil=
e *file)
> > > > +{
> > > > +	return NULL;
> > > > +}
> > > > +
> > > > +static inline bool vfio_file_is_group(struct file *file)
> > > > +{
> > > > +	return false;
> > > > +}
> > > > +
> > > > +static inline bool vfio_file_has_dev(struct file *file, struct vfi=
o_device *device)
> > > > +{
> > > > +	return false;
> > > > +}
> > > > +#endif
> > > >  bool vfio_file_is_valid(struct file *file);
> > > >  bool vfio_file_enforced_coherent(struct file *file);
> > > >  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> > > > -bool vfio_file_has_dev(struct file *file, struct vfio_device *devi=
ce);
> > > >
> > > >  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long=
))
> > > >
> > > > --
> > > > 2.34.1
> >

