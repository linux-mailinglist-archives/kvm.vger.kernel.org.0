Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FF71032B
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 05:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbjEYDED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 23:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjEYDEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 23:04:01 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11D5B2;
        Wed, 24 May 2023 20:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684983839; x=1716519839;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LIFXKZn2FbVW+8CecIsBjNvXE0Q4G/MsntHY67Frs6Q=;
  b=Ut4y2rc1/lkjIj4zTHfRBInRFPlzLZnzBjCAvKb0cAwWPZSlRp3AQNYC
   cJhqv78xA8yA9q8+DZcG3fjLoKnTFpe4VQ4PMYaO+ZaX/sEanQQshvHhb
   0KYtUulXpnIqP0WTMl6URIsJo/RT+b6vmRgh8fiKw01usgrHFJhV919Pa
   AykrDEeFZvZzTmQcyeVSBy+HK5F1HYpsjDnoV6vyKuQ1eoDUTW63bZ7Zf
   QQRXghqJ83sjNa5053EdPeJnlHIYgXDRUx4ce/upvSn5qZuJQdw2D1B/0
   yQEb9gibV8T4p06muMtqx5X71BcOCHhO0FSHBJcclbXZgqEDfo3Hh7o0T
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="351273421"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="351273421"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 20:03:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="707816241"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="707816241"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 24 May 2023 20:03:58 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 20:03:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 20:03:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 20:03:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Csw72rPrYfz0qbrQx2TY9lAf9mbok/bNBnXGCOjh/vrA5NMsL+m5qrCXYLj2doX69Gw9N+zrvJlzWJcMXS8KEaULYSbXh4O7D8BuNUk7+/ZaCnjlFv3fjzx4zfzeVgsKNdl7hFJoBNnTNihdmzoHPCm3uEv5dwrDyZJAh7dHIsNdDT6EXsgTdgfXU+wreWMnhmevxJoGvzZ7Ur5hVL/dgH/niy6Rdhxn4XNoJXP54e+qe+zt/WORAt8CGOoIh7UdagMHad9wCPEW2pNZ6gZtSPkkG1WA0rpSpNU30bcpaVlh6c2d3dBxKa78ceatU2kiiZcb9+hmGiHkCGWXsWunoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ivy9vix8Ez83JSxZQNfJJpb1qXOakgWMnTt/S8YxBwk=;
 b=iOQp7LFH3fwCNkrtb3i2xksHbgxufW6RNDZdQSO5rZs9r3jq54rjO2VFFzYPBffwif5NLPbU58Fqi6ZOIA1anyjE9U/aZ8qHyVAlGR8gxclpu+l2uBjD6z85NSRQ/WpQSYtm+x8ml/YFb+EwbWgRvgcmslZeyOVOpwiz66rLu248wF2/DOotmaMFwiGAy9UFsTCPFXug24LoThgk9fwQuRcI+WYcZe+CqHUJTfU/rqPh1azF214SBzAL+7WcA6YZTJruBauVsXMnBlCi5Ilj/1muW8SjkVEQtjZ8URdu49VAzT3TxPg68Z7v6yzZJmj3/lc5DYo4me0UFHjPjj7cwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB8456.namprd11.prod.outlook.com (2603:10b6:510:2fe::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 03:03:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6411.028; Thu, 25 May 2023
 03:03:55 +0000
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
Subject: RE: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Thread-Index: AQHZhZ7iKUbaAh4TKEGwflpEYDXvra9m6p0AgAAxWMCAAPVhgIAAqe5QgADjLACAAASTYA==
Date:   Thu, 25 May 2023 03:03:54 +0000
Message-ID: <DS0PR11MB7529407F01EE55AE4A0A9F1FC3469@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
        <20230522161534.32f3bf8e.alex.williamson@redhat.com>
        <DS0PR11MB7529096D1BE1D337BA50884BC3409@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230523095025.1898297c.alex.williamson@redhat.com>
        <DS0PR11MB75292161F081F27C0650EFB3C3419@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230524093142.3cac798e.alex.williamson@redhat.com>
In-Reply-To: <20230524093142.3cac798e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB8456:EE_
x-ms-office365-filtering-correlation-id: bc35c024-8185-4d34-8d46-08db5cccad19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdhfwol3joclhwyFbuNGbGG0hlv9m9A+Wh4lLqRm+p9JqSGs5IvplrjURSowpMDF+XLdzkZLFKjD4MTX1m++oKytSD18h3q1TW3qg04iBWmIa5y8SKxhQA9WYdbk/4wyWlYfjjMno64OZiT2r5ru3unwN/N3HBKByj+bfD1xOBjJliGvAM6R1LgsTyV/68uY9ssk9HkiSkFkq8bffmR6XkumxdnvMxWKRmV7F05zfroNkoaBh/X0PYgbXt+nmgyg9HjFoZfyeYLvbBWKPo8F/q9TIpOz0UOdNZydLKORv+zvlLfBhQ8W/GW/wVlEmm4wpKfDfY6ZbPv/m8kl00iSPOzitXTJNexUBhS8SG45o4Z1w8tbUFRv2M9bw/QmZqshxtuU86rGuxhwA0j4MeOn7SgP5QjttdIuwM2EeZycPtRTPF1lC/BcBPYuK5EQovJpQUWbhBqYqgOWwLOqCqkR6rSZ3g+r8wnqhwbNG1YRLvKzpcYm97FHe7fhOFFJp7Kn/D3JkH/vxi9TPCLq+7DZbG4zEyhxe/sxkJ/kNYkF77jEpufpCQbTHV4yV3R+gHwlyf3zxqPqlHZojK/3FPQzXWvGjY2BuvK4ujnNN3Os42a5TCQ+XIu/523G2u2hdeYv4p4H8Pr0v6TtmJiSs7dTx1DSiPuLiq7Zk8fHefTmDTY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(83380400001)(54906003)(38070700005)(86362001)(478600001)(38100700002)(33656002)(66899021)(186003)(66476007)(76116006)(64756008)(66556008)(4326008)(6916009)(66946007)(2906002)(26005)(71200400001)(82960400001)(316002)(9686003)(6506007)(66446008)(41300700001)(7696005)(52536014)(55016003)(7416002)(5660300002)(8936002)(8676002)(122000001)(13296009)(83133001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k2eAOSy242nhMgHNSlFja+fDS/spmMR7Sn88vncTWJ8iW0u7bac328s7bMGg?=
 =?us-ascii?Q?Zy3IzFhmmi91WcLKEOhfuccZrNchBkRiMp2lcm2cvK2WVxErRc0LWfSDkj1H?=
 =?us-ascii?Q?Bdnwm8FnXHfYbcq0+rFCqOyWd0RP0zeNcotXti8yCV1h+m7iZ6oRNICrQEmO?=
 =?us-ascii?Q?3kSsvTM3uh0lbqAuWM8khcaby8f8PtTZtYjy/8QjD1YxTlpkXxIkIrFxcWTg?=
 =?us-ascii?Q?sZkc4GEZ4VeNie1UqmIJ4c0bwTmCuSmGVu+WJhE4SrggYS5NqRI4uF16MNY5?=
 =?us-ascii?Q?v0ryP+UlYvRipCqgg+2FQRD6NiFgKeS8ujwUJRRBBOpu9h6opo5/hDXYw2cm?=
 =?us-ascii?Q?tk0Gfs6Qei5KwPk7XyuVngkIfZc+1y6yPwzz88VU68Buen70McfyG+ohcGTg?=
 =?us-ascii?Q?0PzpDDvTOb81wDGWUTeFmZRLt9bav8DcIW6x55qKiuGX3dDHEmIakGUpdn/+?=
 =?us-ascii?Q?i+Ridhik0xbf8nAhxoud02KCSXhqMkerIUVWb7W0hfzKYpI3wMXRQtHTadUa?=
 =?us-ascii?Q?smy9sv1+NSUpT1bByj6jg8TXcseEEkIHFE4wvn3/khXBatXgF1cFDB+7QzDF?=
 =?us-ascii?Q?LrW7QlIxff5Kal/W20g6x50kHl9/oEkWzfDdrUa/gyDzbS7LcScNySO10Kzr?=
 =?us-ascii?Q?j34LfceVCzX1afPshlcQPnVR7hojGI15q6oMWBqOoiXhkG+SsSmndSRVSJXt?=
 =?us-ascii?Q?/2iGvDZnmlO5Ly1y0TEdTnC0U+1aDSTZDVKzKppjFoFsNp6lQlQzGHwC4LdG?=
 =?us-ascii?Q?rcg9o6z59m/51Rtvgw+ezLjtlQ7mERVceoWXTlFxAkxs4wwGTMQZA1E5cQhp?=
 =?us-ascii?Q?uLqsTfvrgX5ADcWH8I/qmKoXJUzyxeSRXGPMIEwMxl22yiheED3oI5TvaDQ3?=
 =?us-ascii?Q?X7ZhpQZzZ+vcI8lh2GMagBBy9MWTH1Syje2rXlsyhx8rfeM7c+QyTZO2qqdS?=
 =?us-ascii?Q?v7anjWChsqF0wBAUBc/QEbrCaoSJ69jKFDm7wuGIE1rVA6YOKsJoxpm33/Lq?=
 =?us-ascii?Q?GMC573fOdH1BvaRSCLpblyDFz5CrToe6QfMiR+ZiHo7yT8qBlZRvYkdLI9pQ?=
 =?us-ascii?Q?IcIZIPdKdASdrCxqVjaG+7YxBHbUYwG8FCsg0hMiyct+rfrSKeiT/WZG0eeE?=
 =?us-ascii?Q?Ab9FbRxpqe3hit1R6qVvpi8VL8UsksVm+yuQFzOWmQdM6qtjPGuRnv0wxhT5?=
 =?us-ascii?Q?5ebijl9+djvVSVKIHzMZKd8NGADGmCGDFHKKMP5DcBH4ltuZ/RM9nNjuRWFa?=
 =?us-ascii?Q?xvqzFPd4Z5amunRarL320eudujYZ8ND9p+zcnWgupRwI5tyvUxELX213hyLn?=
 =?us-ascii?Q?kTYC1NynWmPqAWBLNIIeFL5V9ZZO1p6VCDlJPLSpVNyYs/HN+XGqXUChP2nO?=
 =?us-ascii?Q?rKsNEnf9gNN5HZ5wGtXDwxY/dxRItB5KSsj2x7lthiTT6Dwo8DNnDu8R0Y02?=
 =?us-ascii?Q?3Ju1vQvOcrGT3q3SpOo4bmhYSUqS3qvzlceAOtXKuI8l+Si9Uhp6bk05YZPO?=
 =?us-ascii?Q?RO9iOJVq1EQbdNnIJ+J4LdsOAgki3e8RYyXQvBirsXMhozqOaa+FBrFvYwwK?=
 =?us-ascii?Q?GplOh1m7zyUcg07mq+8yD89Ztquqbg7r8Yf43kQz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc35c024-8185-4d34-8d46-08db5cccad19
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 03:03:54.9717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qkaSy+g0wMpgl+FpGLyD77ObG+Ux3Cjxl86bhojowYEpgByX6Ca3yI/7MkAraO5iD16UVBDarjvFVtqxIoGRDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8456
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, May 24, 2023 11:32 PM
>=20
> On Wed, 24 May 2023 02:12:14 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, May 23, 2023 11:50 PM
> > >
> > > On Tue, 23 May 2023 01:20:17 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Tuesday, May 23, 2023 6:16 AM
> > > > >
> > > > > On Sat, 13 May 2023 06:28:24 -0700
> > > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev)=
);
> > > > > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > > > > index 83575b65ea01..799ea322a7d4 100644
> > > > > > --- a/drivers/vfio/iommufd.c
> > > > > > +++ b/drivers/vfio/iommufd.c
> > > > > > @@ -112,6 +112,24 @@ void vfio_iommufd_unbind(struct vfio_devic=
e_file *df)
> > > > > >  		vdev->ops->unbind_iommufd(vdev);
> > > > > >  }
> > > > > >
> > > > > > +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> > > > > > +{
> > > > > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > > > > > +
> > > > > > +	if (vfio_device_is_noiommu(vdev))
> > > > > > +		return 0;
> > > > >
> > > > > Isn't this an invalid operation for a noiommu cdev, ie. -EINVAL? =
 We
> > > > > return success and copy back the provided pt_id, why would a user=
 not
> > > > > consider it a bug that they can't use whatever value was there wi=
th
> > > > > iommufd?
> > > >
> > > > Yes, this is the question I asked in [1]. At that time, it appears =
to me
> > > > that better to allow it [2]. Maybe it's more suitable to ask it her=
e.
> > >
> > > From an API perspective it seems wrong.  We return success without
> > > doing anything.  A user would be right to consider it a bug that the
> > > attach operation works but there's not actually any association to th=
e
> > > IOAS.  Thanks,
> >
> > The current version is kind of tradeoff based on prior remarks when
> > I asked the question. As prior comment[2], it appears to me the attach
> > shall success for noiommu devices as well, but per your remark it seems
> > not in plan. So anyway, we may just fail the attach/detach for noiommu
> > devices. Is it?
>=20
> If a user creates an ioas within an iommufd, attaches a device to that
> ioas and populates it with mappings, wouldn't the user expect the
> device to have access to and honor those mappings?  I think that's the
> path we're headed down if we report a successful attach of a noiommu
> device to an ioas.

makes sense. Let's just fail attach/detach for noiommu devices.

>=20
> We need to keep in mind that noiommu was meant to be a minimally
> intrusive mechanism to provide a dummy vfio IOMMU backend and satisfy
> the group requirements, solely for the purpose of making use of the
> vfio device interface and without providing any DMA mapping services or
> expectations.  IMO, an argument that we need the attach op to succeed in
> order to avoid too much disruption in userspace code is nonsense.  On
> the contrary, userspace needs to be very aware of this difference and
> we shouldn't invest effort trying to make noiommu more convenient to
> use.  It's inherently unsafe.
>=20
> I'm not fond of what a mess noiommu has become with cdev, we're well
> beyond the minimal code trickery of the legacy implementation.  I hate
> to ask, but could we reiterate our requirements for noiommu as a part of
> the native iommufd interface for vfio?  The nested userspace requirement
> is gone now that hypervisors have vIOMMU support, so my assumption is
> that this is only for bare metal systems without an IOMMU, which
> ideally are less and less prevalent.  Are there any noiommu userspaces
> that are actually going to adopt the noiommu cdev interface?  What
> terrible things happen if noiommu only exists in the vfio group compat
> interface to iommufd and at some distant point in the future dies when
> that gets disabled?

vIOMMU may introduce some performance deduction if there
are frequent map/unmap. As far as I know, some cloud service
providers are more willing to use noiommu mode within VM.
Besides the performance consideration, using a booting a VM
without vIOMMU is supposed to be more robust. But I'm not
sure if the noiommu userspace will adapt to cdev noiommu.
Perhaps yes if group may be deprecated in future.

> > btw. Should we document it somewhere as well? E.g. noiommu userspace
> > does not support attach/detach? Userspace should know it is opening
> > noiommu devices.
>=20
> Documentation never hurts.  This is such a specialized use case I'm not
> sure we've bothered to do much documentation for noiommu previously.

Seems no, I didn't find special documentation for noiommu. Perhaps
a comment in the source code is enough. Depends on your taste.

Regards,
Yi Liu
