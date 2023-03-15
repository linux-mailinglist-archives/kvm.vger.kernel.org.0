Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37006BA794
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 07:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCOGPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 02:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCOGPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 02:15:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A6B5BCA1;
        Tue, 14 Mar 2023 23:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678860911; x=1710396911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7kvNEzin0LvenXqA5X4GGr99JgaWSTU1BLPGijRUUco=;
  b=lzmQm+S2KSq2XAIqJc5l3HD5wx0Ob5G5ho6BBpBO6NUzOyEC+JAl6Eko
   Va4VXhC2oLnvWL+Nm02JkpVjLiXvcGnfWeKS81hMuypBW3bKAQVyNbBDM
   l80ou/z8R579PE4rbZ9OZP2JXQeVaA2VrciR8jeibYYVE/cBfqiCctJ29
   4EptyQhMFyNDnJH7OosajLJsn3+sF1wdLJZDzQCZZfyCC3AewFuh7ehY0
   RvFw7GJuK7IhDza+SkHASKWFVUEKRVgixaUJxNdMaPQyIKl51GW/DNmqe
   puA58Xlp2BFvSGsMafnU7jWPZL2niy4AkgSEAVfmyRf3Yc3YHVbn/XQHP
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339163514"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="339163514"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 23:15:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925208159"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925208159"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Mar 2023 23:15:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 23:15:10 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 23:15:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 23:15:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxP9RcE+10uboTl2Yjsdq+io3sCZoGXFHMXeerugztVL8huBcRnzv52342i77ZObOoTd5ab1S+sVWOqSBVSiNR5tYyHloAm5jDVZ3ZPFURuHdbY/AqlZsyT6L+wj40u2DlMezDCabIj/8CZ/VYTnbLTWxAm98gSWca4pwaofp31CjYP1TwzEZNmekmidKHGZzRy1PA7WBHo53nnlrBIJjrao8beieNN2X77H/IqZE4S17aJv+LHSjkNg+lSkzT7pHadm0hN06r34Cm35bNh6LxR1jagIvgVtZt07J2LwNGHrPP7JVIGAiYMUp/I90yMG60mPbnQEbU55tV1/fXTUDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hhvEue8LCM3h7yYSLeU8Eoj27VOZu4wE6uQoqZHkeU=;
 b=MniAfKxCFvzvmcugFeLNuSr6CI0yy0DassrsvbxBLiF1ycxpP0pwd+F9KIBqQE5DuP2CnTkHPLX0BsHqOWiYe744Ff3w/AP96Bd39X4skHGGGW2qseb0uNZsmJo1ydH+0kB419o96apqOvW72YJ/MdnOfWeNxL0VWwxBO1m69tMoa9LgYto8/OaA3tJ9jGqnMOvrA6bBXmG8fVAIPXxH2y9wmhNEY7DT7bAPni21SikFg/EThDVnvvJn78skgFqyVuCcpu7NdiqKKYlORfCKuLPs7EMMWVjYDRsPy4Pom5rCeAeCxlq+K0lheb6Oaqc5Ycmpk8uCeQwpsRrVI2ehDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6173.namprd11.prod.outlook.com (2603:10b6:8:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 06:15:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 06:15:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 19/24] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Thread-Topic: [PATCH v6 19/24] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Thread-Index: AQHZUcIMfpR7Vu8dF0GhTo6mQP/PRK70sIeAgAa2yHA=
Date:   Wed, 15 Mar 2023 06:15:02 +0000
Message-ID: <DS0PR11MB7529D9C29E76E74EF7B8E038C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-20-yi.l.liu@intel.com>
 <ZAvAefwLEj8i13+s@Asurada-Nvidia>
In-Reply-To: <ZAvAefwLEj8i13+s@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB6173:EE_
x-ms-office365-filtering-correlation-id: 6f8145cd-de2c-4486-7c40-08db251c9cd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tgEMEEd5b9ZeuIItj38WOtfQZS/6YtTHoEjpQLn7QxGpxpyMS+ls1UipAYWUNPkxF0kY+jvKCbUYUxJrl5m8vXd/YcdXjd2GRKvFDkDUZDTWPtmhd8+cb1W2+mzXqo4cbFyobsryA1ww78suYm1dEXcyqJrYzxOR8Lgrma6Nzw14c3ju2N5d2M2zkm6I7W2D1n2mchniR+tD2IEWnUq1ELggH3XOO6OREcsT6rE7qRg0+xfiQVun0YZp4rgVB2J8pYGp0ae1CBs7P5i0NnUxixSVTiPS8NJbN/SGNBjU8ZElSGniuEUQ8GaBALpQ6g7DML91j3GpbGr7Yr1L2gjY7KXamsjK+g8FleYtFmrA7y+ewiMktYIgxfX/W7Z5hEOVAWWLU+fyteCIM9eKIGHnU5gesPeXWIpoXaiT9CyHMM5Dt2gQIp3KsPPAp4Ruie9HbhLxZdkEFqShmkONfPDiEoGrBUNtz/Ss4omZfpQf6fn5t5egqw9dljEP1/mzqmPnZJQ/S+hoQwoP6G+5lrnXe/htoz4+uvpRQ5mH0lwXZ2pEpV/z5hecj6WPepkMS496Wb1OcgyiBRCt0oXmOM/Nk92gr5qmq5se9nEaK/YX0BOJvnXdRKneTubuS4wyUlwr4H4gfYMSM6FK8hkoHX8y/Kh1Kpn0Wq0plnens/uYfIvrg7y+YcNlRdDubrKGX85DgZYfAB5im6GvfRvXFCy2mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199018)(82960400001)(38100700002)(122000001)(2906002)(86362001)(7696005)(316002)(71200400001)(478600001)(6506007)(55016003)(33656002)(38070700005)(54906003)(66556008)(66446008)(4326008)(6916009)(8676002)(66946007)(66476007)(64756008)(41300700001)(9686003)(186003)(76116006)(52536014)(8936002)(26005)(83380400001)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?84iwdO06IQox0NgBTj9uafECKw2FSYRNFROaYcTCSTpBTjt3bC/uknEsTFyZ?=
 =?us-ascii?Q?TsqJiS2E37ejt/mSQ0MG6YjJtdw5VRv4TeVEG8dHReb1jcBMcIPTC9ooay83?=
 =?us-ascii?Q?ACNCTWDzgbzn12eCoDTvLqsm4zSDtrSKIh590D/BqDucmbaOVLwVmk/kgLMz?=
 =?us-ascii?Q?jSqQwmn34Hpe7QN4JBTF+QugGXTyLiGmOMYDf0DC6o8eUVLBdNCaseBusqPk?=
 =?us-ascii?Q?LM6SVLXSikwdadFX0Jig9VagE5FCDMKxME/yg6EJSzptbMqTe6EYbTIqCFUM?=
 =?us-ascii?Q?0rp0uWZy+UZ/Uxw8qNv6dxnG90VhB6ZqZxlp+llfY1gtshJs4fQBZXYEk5g6?=
 =?us-ascii?Q?PB51lviz8b06xXCsPObwLdVTL5NaAaMX0WXoMHLgAOKu3VSCRSxKM+8kSii+?=
 =?us-ascii?Q?7FQyDylT6GSz6AC6KVXL1eBr+bXW857qZAbZAO374lG8xkS7UR8JS0yDiZ/M?=
 =?us-ascii?Q?O5u1BxEWYIXfhyhYjhXLotb2vjZf8vgptv5NSGFDURAZpOyxdzo8UpfBworq?=
 =?us-ascii?Q?94za68pfktQ9vGwerZLZX84U/YNOE8ccvkNxqIysiTnMqLzadBVPg4nIDo6P?=
 =?us-ascii?Q?4Jua6a3L5nN9iwipHZ81uAgHc3Kt+z/8+C4wI34ySyJZ0SndmOzxZSRIBO1I?=
 =?us-ascii?Q?/gRHqgwAcX4kFiGPVxaPelXIYLc3tOH9ee65vhTqnbazaUkgoVZg2R5LsT68?=
 =?us-ascii?Q?DesfEuJsyvb/CHe1dEcdHO1WzX/tIkHz+cScivEPOWXHWcCfqnKhC4Lq4xkk?=
 =?us-ascii?Q?+kQDRqBHjXGBkSc+35uQET8bReqvf5JY2l2+ANz2TMMIPR+FRmVkTKPUkQiZ?=
 =?us-ascii?Q?mXhrCn8BFCbkgdX4suCdW3L2MugCUlTpt1R2lP0EA75Fc/CO0Qbs3/MWhywY?=
 =?us-ascii?Q?4G1sHv4uSoHOLxIH934M44gSU3TH7t3O0f64a7JsVGI3QH2NUTfmZxVSRmn0?=
 =?us-ascii?Q?QrwPsg8G4Dq0c2d4khnZJv4XPXMw58OjEGrWJ/aC0vuJUgsb1kcH9wpMCMCP?=
 =?us-ascii?Q?GP/OBz0gy7YgltfiVZvsu8IbeMNXqeI4ZXwpdgCyUYkPOJ58AmXRfcFjbp7O?=
 =?us-ascii?Q?j1td0AQ0L17QGqDhNIcMVvGZ5W9k3eWJcC1VbUZ4ZJ60pD3ZqaD5x+Hc4XAN?=
 =?us-ascii?Q?c7XNm21EJ/RFFqEWzkIeGMqJ361TT1QLKR/Zy5QkLjwc6WiqKEDaF/wVF++X?=
 =?us-ascii?Q?XtuYfvQvEIBTBixr/L0NNbAGqOsJ1aAtGvBAq0qfNNFI5Yk/KWq5QpEebuEX?=
 =?us-ascii?Q?7s7oCGBPokQr8Ux52p6cHYfh7MvGwKfrRsxx1NuF3BoSGAlwD4xpTgSS85Pk?=
 =?us-ascii?Q?YPF//2dB4zMT3P/ZViYSYQZk1Fec0UMbJPkz9q3kI9kzVlDhrtb9N6BiJ8JI?=
 =?us-ascii?Q?o3f0Ljj9stEe6Io4ilobuI5mkzSV2dvaYm1C4RmK07UT3Bhg8Hz9xk4++YKZ?=
 =?us-ascii?Q?YDjgzN9rLMkm3hyYH9BoK1YdzuRldJ7nH4b8kTQw8KGBszScwzw3TmYO2iAN?=
 =?us-ascii?Q?grrCeCJa1rqet7kc0qDEOEiQUSUyPDlhJ8pLliTljYt2OvkP6jVy7jb5XR6g?=
 =?us-ascii?Q?q2RKC1ZDIlrENKzxrOlEcgjeajo7wjawB1fhMku4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8145cd-de2c-4486-7c40-08db251c9cd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 06:15:02.2719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TC4SGgkQPzRaOelymf44OyCSvBg0QyWe92hSNtcxk6LfZlLM+yj+9ysQrl2pbmAhxrToXXIPsAnE4kAtL5w3hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6173
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, March 11, 2023 7:43 AM
> On Wed, Mar 08, 2023 at 05:28:58AM -0800, Yi Liu wrote:
> > External email: Use caution opening links or attachments
> >
> >
> > this prepares for adding DETACH ioctl for emulated VFIO devices.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
> >  drivers/s390/cio/vfio_ccw_ops.c   |  1 +
> >  drivers/s390/crypto/vfio_ap_ops.c |  1 +
> >  drivers/vfio/iommufd.c            | 14 +++++++++++++-
> >  include/linux/vfio.h              |  3 +++
> >  5 files changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index de675d799c7d..9cd9e9da60dd 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1474,6 +1474,7 @@ static const struct vfio_device_ops
> intel_vgpu_dev_ops =3D {
> >         .bind_iommufd   =3D vfio_iommufd_emulated_bind,
> >         .unbind_iommufd =3D vfio_iommufd_emulated_unbind,
> >         .attach_ioas    =3D vfio_iommufd_emulated_attach_ioas,
> > +       .detach_ioas    =3D vfio_iommufd_emulated_detach_ioas,
> >  };
> >
> >  static int intel_vgpu_probe(struct mdev_device *mdev)
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c
> > index 5b53b94f13c7..cba4971618ff 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -632,6 +632,7 @@ static const struct vfio_device_ops
> vfio_ccw_dev_ops =3D {
> >         .bind_iommufd =3D vfio_iommufd_emulated_bind,
> >         .unbind_iommufd =3D vfio_iommufd_emulated_unbind,
> >         .attach_ioas =3D vfio_iommufd_emulated_attach_ioas,
> > +       .detach_ioas =3D vfio_iommufd_emulated_detach_ioas,
> >  };
> >
> >  struct mdev_driver vfio_ccw_mdev_driver =3D {
> > diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> > index 72e10abb103a..9902e62e7a17 100644
> > --- a/drivers/s390/crypto/vfio_ap_ops.c
> > +++ b/drivers/s390/crypto/vfio_ap_ops.c
> > @@ -1844,6 +1844,7 @@ static const struct vfio_device_ops
> vfio_ap_matrix_dev_ops =3D {
> >         .bind_iommufd =3D vfio_iommufd_emulated_bind,
> >         .unbind_iommufd =3D vfio_iommufd_emulated_unbind,
> >         .attach_ioas =3D vfio_iommufd_emulated_attach_ioas,
> > +       .detach_ioas =3D vfio_iommufd_emulated_detach_ioas,
> >  };
> >
> >  static struct mdev_driver vfio_ap_matrix_driver =3D {
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index c06494e322f9..8a9457d0a33c 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -218,8 +218,20 @@ int vfio_iommufd_emulated_attach_ioas(struct
> vfio_device *vdev, u32 *pt_id)
> >  {
> >         lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -       if (!vdev->iommufd_access)
> > +       if (WARN_ON(!vdev->iommufd_access))
> >                 return -ENOENT;
> >         return iommufd_access_set_ioas(vdev->iommufd_access, *pt_id);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
> > +
> > +void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
> > +{
> > +       lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +       if (WARN_ON(!vdev->iommufd_access))
> > +               return;
> > +
> [...]
> > +       iommufd_access_destroy(vdev->iommufd_access);
> > +       vdev->iommufd_access =3D NULL;
>=20
> After moving access allocation/destroy to bind/unbind, here it
> should be:
> 	iommufd_access_set_ioas(vdev->iommufd_access, 0);

You are right.

Regards,
Yi Liu
