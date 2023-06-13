Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9E772D982
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 07:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbjFMFtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 01:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbjFMFsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 01:48:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1710410B;
        Mon, 12 Jun 2023 22:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686635331; x=1718171331;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qO+Vg1JtRDys9XtYGmP5Yotn8CVOwEytIeiQIXZMrA8=;
  b=AwPVN/TwJjzlf7WN4ZiU9jorbm4PYkVpgKRwzOG17AQjfD+gy1xMuAhQ
   eASIOh9hKqsdD9lYuC+SYql/CmV1RiVQUBbpdqIIEpNrXPzVZHQGMm38G
   6OcPLVotVWLWXrvDV0YhPdDXv3db470BycqVZNRgh4Mc1TK+Wz4x2qhbn
   sg13fL7wRriH4SEbcd2sSXtlxnZqwXYF1+wHVRfZplBZTIbj3b+PxB2PC
   9qAiTSgRTbqlolxJAny60SnR/h8r8KWYLmlkHOPsioHMZENEEowAtDFDu
   ERpg4Ddq1qnJKbCXqKGdTW+COEx5hGVMR8tOpJGRGAmQAnVcRncfcg3EO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="358232957"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="358232957"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 22:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885723410"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="885723410"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2023 22:48:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:48:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 22:48:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 22:48:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKw2NjWfMSzcsYL976x99l7Ck6Uos1Jo1vlFk2wQydawub+keScY78Z/0Wm7FKCm9pddIFuqUmk95ZdFQY6bR/g9UaGKwl+tmWnrOGz5Sp8YFYYvXNKlx9Y5gAi56cuifd4pOYBze+y7MUTxTSjfklLYFb30oBh9z3R13Et8oE/KXLvdSzbQoIe1lQ8Il4I8hj0ZbTrVNbn/Vy0ucAzneiztsyRBrQSHXN+Pmkv1XQScsFLSIlW5HeFxZlr1+6fpwNvn/y4Ahjfic4fYh9D3+iVrI/C1SWbl9JYB8d+KhFFpgTAEIFicsF2qqsRELdrqZ9a/8HpKQx/akyhXeI53Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaffC5Buw4bP6rdFOzM+t7CGgZjHnzep7euInOlCQHA=;
 b=jwxwoxNFqj/fWTfDootd5Eho8Fedk8p67x6yfuTSHsL5PjFr/Z8jgZR2uIaML3f3PreD/dBEhIayrsVKShL+sueF9kr7UQRWfKeasHHrkFBSAWgssFmjTeuhVVJmY7zVTjF61WWkJFgFtIImMCmggUhUs8KPaWaRJ+C34jryzhkuxshgTP8qBYi7e1eXFOAOYMMyiTN7g8IBbDjphOZLnnZw4K7Q/5WfFIqjlMl8cN+4wG8CVrNlwoQ0CYm7wWD/SSuMKGkAnwjWTVrmqm1So5Z1QGMzAXM8WnhM2IOHiilZU4REhDvPwe1KelAmCPSsByE7sN088gS111J4h8wzaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8093.namprd11.prod.outlook.com (2603:10b6:610:139::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 05:48:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 05:48:46 +0000
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
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+Hz4gAgAB6suA=
Date:   Tue, 13 Jun 2023 05:48:46 +0000
Message-ID: <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
 <20230612162726.16f58ea4.alex.williamson@redhat.com>
In-Reply-To: <20230612162726.16f58ea4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB8093:EE_
x-ms-office365-filtering-correlation-id: 99c298a8-5c86-4d8a-1f00-08db6bd1da86
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZDjyrgIYov2loE+QnZv5Fu9KevkA6CHcv9ebCClwIMQ45RCK0Ed+ea7IMcvBTx0+Y7RQ8pXJ9DaCbmNmwtoV5W4CrvdpvKhCw0soH47LxzPlBQHO3slmauKc1UpHIIFEnLDmG3xy/aV7BG/v/r0ka2RxcdoGUJJc99olQrPFbRQA7j6ExZXQipA6UTesRXGSFZBWTh+hH1js69aRM88lxGrj3N6YDsTn8WYuWllVJ197DD6y6mQPE3o8qbBsgH4DiEb51BYQeiZFjJapEXJfGCpeYZQprniquutaaNO8RiOAJhnZ+1Q7ZYlLle6ND+gu8SpEA/KegyV/kf8U5BmpKA74r0VRPjrSd0Hp+V3Mgxrx6serQaAa9dk8NYazRiYZut4Va2gDymAhXteOL972bBmFKu84N5vdKzjIGdFuR9vQY4aIRwojfkI1xUSI3zN6X/brsuit11IKa9Jfh6FmshpPPVzeRW0XEtz8JCKgFZQpCI1LqUqqSvZZpMYMoZCan1Lz2Xno/Q/J7I7tA6H86PTeo16VM0EMGWVg5QCTb4c+QPVjC9StLt5DYTvxB5Tw5xV299jLjWIrNhnJJuaxLeu1uynzDus9i663E/cjVaJKgM1RE8ch0WdDxW9t09HD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199021)(6916009)(66476007)(4326008)(66946007)(478600001)(76116006)(2906002)(64756008)(8936002)(316002)(41300700001)(8676002)(5660300002)(66446008)(54906003)(66556008)(52536014)(7416002)(71200400001)(7696005)(9686003)(86362001)(26005)(6506007)(55016003)(122000001)(186003)(83380400001)(38100700002)(82960400001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pvVzHnx3WePpyLSBJBNiRxXreq/d868YuSBrnf1PmmGI6dZHdrHkOnolL5kh?=
 =?us-ascii?Q?0uD7nmdYb2VJJ6rgnP5UHVb70egZ2kCPxlEc5zhlrpQ98ZBi1qmU/UwYcfku?=
 =?us-ascii?Q?ziJ2I3dPj5QhAU0X7U0bxuZj43KofwJ3HOdwqWbwna9z7be4nfurpg0yng3F?=
 =?us-ascii?Q?7olUxRpJH6JNIGeZQQEeafQ/wJ9+SagvQ0Lx6EnwosKTGkFFs7w5s87V9ksT?=
 =?us-ascii?Q?Exvd5xlo+3XQjtwrJVu+tWPlSvwrIfxALScKrmgNndCBCIcD86NcEJN9qhA6?=
 =?us-ascii?Q?JgKAHnpm10PtUAmdldi6BOTBTemxI03oJEHvpVNhVTtgdMnUnsdpqT9Jthcs?=
 =?us-ascii?Q?ea10tOFOjt7P2Bxqh+ZuZDMPUitTvRn5QoA3W3D+0JFP2EqbrZ6yraSR81nA?=
 =?us-ascii?Q?3EFMK+LmTkVWS0XZPt2jwDp3VfLMkLTvElI8gmK8j8UUN4NCWhgR2KVfLeji?=
 =?us-ascii?Q?EqQxsFLvLIamzif0I6Nvoqfxk0rOwrF21vOoACqnqWgl9VT05cutr5zMTKjn?=
 =?us-ascii?Q?3j4/fS34P0rk8D/vR4sIKEUERTW2Pxwboi2/KaFZx60YHDtBzDH0+7RRU8Uo?=
 =?us-ascii?Q?XZSZkZ0jVTjEnn3rY4UxJAuUy/XRkXQw3l2Zw3xheVX4rcjPeetsQpmFlIkh?=
 =?us-ascii?Q?ve4589HX7QEXDqtPbsGDoTKn+Dbwo5+tc+KfGLCuw/TsdnGX3xaKFwMIPPVM?=
 =?us-ascii?Q?pd0zP/tSlySgP9fD1OLex40VU9WdcDOmcl2PeAFwRdixZxN4/IOtMhETFnoR?=
 =?us-ascii?Q?ZRoTvEe0Sx+Y3LJ06L9Y9FhY35y0w91tvpxByMcGr0lY9IXv5BgOvLB7akjC?=
 =?us-ascii?Q?UjdCXlGNgGsvRfD6u6NcgwsBU0jRiEkSBl2e8z+UpYietxA2cdojfC1oXSi2?=
 =?us-ascii?Q?KgnpcgQkvCNVeFPjrNj0Y8hanUy948oAyjWbR+jXtQrL8ebBeycfiOwMqjiq?=
 =?us-ascii?Q?yn6ExcUMG62rIfu/jn1AeWvIpBCG8R1sTBPers8WBrPg22b7/gZItiFc06yI?=
 =?us-ascii?Q?xARrBdkC+K45l1AyfKHWIUjcYrhyWx52VuTLzSkE653KIXLzWy1CAjAw5brv?=
 =?us-ascii?Q?lqwr+viHO4Gl5Bsz42M1+bc2WMnlL3Q1kluNdyJqKfMR9xJPYExEngfa+VxT?=
 =?us-ascii?Q?7Heu8UaClRJAaMMfKwXV2lACWwgjcRjxO7D1XtIa4TPxEYAhuJNqDzZEqIhE?=
 =?us-ascii?Q?vB/ryd07O1sMB63ysA9St6ZWccl26mS5sB1nr099QzPUz4mot9x2HvrClO+x?=
 =?us-ascii?Q?KFOFYastHLgLmGfR00SjH6i1STniTRYZAPvMiJs2X+9wECcJk7LaG0xDMXib?=
 =?us-ascii?Q?TVORt8aBDHqspjb/k9TXHYPE5UQAsgx/q1XQAeQG8CJibVA+3QBCnxj3NkIc?=
 =?us-ascii?Q?RNXSSwd0tXDiUt5p+HDuIi+XF60Hh8BJCKoO65gYJ+bzgAdKRzR6oyCLma1T?=
 =?us-ascii?Q?JmcH6jjgASV3iGapoe/wH0t/unCBU/bR6HcdcKueGyFdHyjn+F4+z/TL+3C7?=
 =?us-ascii?Q?khW1DP7QeN/oG9IMtlpSDkILJTid5MFjKOMkpGHfwytWR3DC8AXBf6Cd3WsA?=
 =?us-ascii?Q?20kVBGray55dV7b2iSvCLQT2fZtc+Xg2NgiBax7l?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c298a8-5c86-4d8a-1f00-08db6bd1da86
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 05:48:46.1471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AeSRwn5dI1m7YRk+9a0HHMKgpxx01wVwYxwVizo7rCQzqCHkKKqQ7PHq0BVueG9VXGxyq/hf0HKxqehGJAqVnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8093
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 6:27 AM
>=20
> On Fri,  2 Jun 2023 05:16:47 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This adds ioctl for userspace to bind device cdev fd to iommufd.
> >
> >     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> > 			      control provided by the iommufd. open_device
> > 			      op is called after bind_iommufd op.
> >
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c | 123 +++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio.h        |  13 ++++
> >  drivers/vfio/vfio_main.c   |   5 ++
> >  include/linux/vfio.h       |   3 +-
> >  include/uapi/linux/vfio.h  |  27 ++++++++
> >  5 files changed, 170 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 1c640016a824..a4498ddbe774 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (c) 2023 Intel Corporation.
> >   */
> >  #include <linux/vfio.h>
> > +#include <linux/iommufd.h>
> >
> >  #include "vfio.h"
> >
> > @@ -44,6 +45,128 @@ int vfio_device_fops_cdev_open(struct inode *inode,=
 struct
> file *filep)
> >  	return ret;
> >  }
> >
> > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > +{
> > +	spin_lock(&df->kvm_ref_lock);
> > +	if (df->kvm)
> > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > +	spin_unlock(&df->kvm_ref_lock);
> > +}
> > +
> > +void vfio_df_cdev_close(struct vfio_device_file *df)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +
> > +	/*
> > +	 * In the time of close, there is no contention with another one
> > +	 * changing this flag.  So read df->access_granted without lock
> > +	 * and no smp_load_acquire() is ok.
> > +	 */
> > +	if (!df->access_granted)
> > +		return;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	vfio_df_close(df);
> > +	vfio_device_put_kvm(device);
> > +	iommufd_ctx_put(df->iommufd);
> > +	device->cdev_opened =3D false;
> > +	mutex_unlock(&device->dev_set->lock);
> > +	vfio_device_unblock_group(device);
> > +}
> > +
> > +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> > +{
> > +	struct iommufd_ctx *iommufd;
> > +	struct fd f;
> > +
> > +	f =3D fdget(fd);
> > +	if (!f.file)
> > +		return ERR_PTR(-EBADF);
> > +
> > +	iommufd =3D iommufd_ctx_from_file(f.file);
> > +
> > +	fdput(f);
> > +	return iommufd;
> > +}
> > +
> > +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				struct vfio_device_bind_iommufd __user *arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_bind_iommufd bind;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	static_assert(__same_type(arg->out_devid, df->devid));
> > +
> > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > +
> > +	if (copy_from_user(&bind, arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> > +		return -EINVAL;
> > +
> > +	/* BIND_IOMMUFD only allowed for cdev fds */
> > +	if (df->group)
> > +		return -EINVAL;
> > +
> > +	ret =3D vfio_device_block_group(device);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	/* one device cannot be bound twice */
> > +	if (df->access_granted) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	df->iommufd =3D vfio_get_iommufd_from_fd(bind.iommufd);
> > +	if (IS_ERR(df->iommufd)) {
> > +		ret =3D PTR_ERR(df->iommufd);
> > +		df->iommufd =3D NULL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/*
> > +	 * Before the device open, get the KVM pointer currently
> > +	 * associated with the device file (if there is) and obtain
> > +	 * a reference.  This reference is held until device closed.
> > +	 * Save the pointer in the device for use by drivers.
> > +	 */
> > +	vfio_device_get_kvm_safe(df);
> > +
> > +	ret =3D vfio_df_open(df);
> > +	if (ret)
> > +		goto out_put_kvm;
> > +
> > +	ret =3D copy_to_user(&arg->out_devid, &df->devid,
> > +			   sizeof(df->devid)) ? -EFAULT : 0;
> > +	if (ret)
> > +		goto out_close_device;
> > +
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> > +	device->cdev_opened =3D true;
> > +	mutex_unlock(&device->dev_set->lock);
> > +	return 0;
> > +
> > +out_close_device:
> > +	vfio_df_close(df);
> > +out_put_kvm:
> > +	vfio_device_put_kvm(device);
> > +	iommufd_ctx_put(df->iommufd);
> > +	df->iommufd =3D NULL;
> > +out_unlock:
> > +	mutex_unlock(&device->dev_set->lock);
> > +	vfio_device_unblock_group(device);
> > +	return ret;
> > +}
> > +
> >  static char *vfio_device_devnode(const struct device *dev, umode_t *mo=
de)
> >  {
> >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index d12b5b524bfc..42de40d2cd4d 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -287,6 +287,9 @@ static inline void vfio_device_del(struct vfio_devi=
ce *device)
> >  }
> >
> >  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep=
);
> > +void vfio_df_cdev_close(struct vfio_device_file *df);
> > +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > +				struct vfio_device_bind_iommufd __user *arg);
> >  int vfio_cdev_init(struct class *device_class);
> >  void vfio_cdev_cleanup(void);
> >  #else
> > @@ -310,6 +313,16 @@ static inline int vfio_device_fops_cdev_open(struc=
t inode
> *inode,
> >  	return 0;
> >  }
> >
> > +static inline void vfio_df_cdev_close(struct vfio_device_file *df)
> > +{
> > +}
> > +
> > +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file =
*df,
> > +					      struct vfio_device_bind_iommufd __user
> *arg)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  static inline int vfio_cdev_init(struct class *device_class)
> >  {
> >  	return 0;
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index ef55af75f459..9ba4d420eda2 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -572,6 +572,8 @@ static int vfio_device_fops_release(struct inode *i=
node, struct
> file *filep)
> >
> >  	if (df->group)
> >  		vfio_df_group_close(df);
> > +	else
> > +		vfio_df_cdev_close(df);
> >
> >  	vfio_device_put_registration(device);
> >
> > @@ -1145,6 +1147,9 @@ static long vfio_device_fops_unl_ioctl(struct fil=
e *filep,
> >  	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> > +	if (cmd =3D=3D VFIO_DEVICE_BIND_IOMMUFD)
> > +		return vfio_df_ioctl_bind_iommufd(df, (void __user *)arg);
> > +
> >  	/* Paired with smp_store_release() following vfio_df_open() */
> >  	if (!smp_load_acquire(&df->access_granted))
> >  		return -EINVAL;
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 83cc5dc28b7a..e80a8ac86e46 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -66,6 +66,7 @@ struct vfio_device {
> >  	struct iommufd_device *iommufd_device;
> >  	bool iommufd_attached;
> >  #endif
> > +	bool cdev_opened:1;
>=20
> Perhaps a more strongly defined data type here as well and roll
> iommufd_attached into the same bit field scheme.

Ok, then needs to make iommufd_attached always defined.

>=20
> >  };
> >
> >  /**
> > @@ -170,7 +171,7 @@ vfio_iommufd_device_hot_reset_devid(struct vfio_dev=
ice
> *vdev,
> >
> >  static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> >  {
> > -	return false;
> > +	return device->cdev_opened;
> >  }
> >
> >  /**
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index f753124e1c82..7296012b7f36 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -194,6 +194,33 @@ struct vfio_group_status {
> >
> >  /* --------------- IOCTLs for DEVICE file descriptors --------------- =
*/
> >
> > +/*
> > + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
> > + *				   struct vfio_device_bind_iommufd)
> > + * @argsz:	 User filled size of this data.
> > + * @flags:	 Must be 0.
> > + * @iommufd:	 iommufd to bind.
> > + * @out_devid:	 The device id generated by this bind. devid is a handl=
e for
> > + *		 this device/iommufd bond and can be used in IOMMUFD commands.
> > + *
> > + * Bind a vfio_device to the specified iommufd.
> > + *
> > + * User is restricted from accessing the device before the binding ope=
ration
> > + * is completed.
> > + *
> > + * Unbind is automatically conducted when device fd is closed.
> > + *
> > + * Return: 0 on success, -errno on failure.
> > + */
> > +struct vfio_device_bind_iommufd {
> > +	__u32		argsz;
> > +	__u32		flags;
> > +	__s32		iommufd;
> > +	__u32		out_devid;
> > +};
> > +
> > +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
> > +
>=20
> Why are we still defining device ioctls 18-20 before existing device
> ioctls?  18 should be defined after 17...  Thanks,

Yes. I put it here as it is supposed to be the first doable ioctl for cdev =
fds.
But you are right, it should be ordered by offset.

Regards,
Yi Liu

> Alex
>=20
> >  /**
> >   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
> >   *						struct vfio_device_info)

