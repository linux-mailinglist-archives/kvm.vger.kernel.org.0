Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB34E69F035
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjBVI3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjBVI3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:29:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F83298C5;
        Wed, 22 Feb 2023 00:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677054568; x=1708590568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Arebyd3RYrGcEgVymsZBBVWEE84S/Qio+Ar+cLsaaKg=;
  b=fBU2uJoeYtxBDlDoRg99rO9Ot1rnSaPztgGelOWvUHtgHZYdVBBaG6mn
   pg4PxTJO6J5rLfL732EQQvv5k5Lm9uLNxXL4fT254uBTX5anzrlTzgcPj
   0P+zSfApLM/C55EhpPu6pvPjNXmE3k8n6nDo9J87FCElE/iNt6SqxL7rg
   zx21XMqr03/Gg2QJDUOs9P4bsiBVsl6exd2C7o+Iws8WJ05Qwc1jvTGHv
   9IdS4zjf28XzBd/kykr+ArPdGmz9hE7No5WKq7mSEyt2jKACsUT0tY+Ss
   u1yzoYKEj7cnsL2fKkfPX9Q9teBrg6QDbHQu10H2bhYvoRhKS1V0y/LtW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="330593719"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="330593719"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:29:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="846039253"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="846039253"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 22 Feb 2023 00:29:26 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 00:29:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 00:29:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 00:29:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKxBVi3a1UTUOU9mIfzxJLiWSn/YKaxwbNv9C5CJG0tqcWYDuZigTRdOEIz4Qun0ZRDilZQM3swjHG+DXkFxuWORKCURNbFIs7+I+JSvp4MKyJdf9kKyVvkb+CVmoszXyYjhszxSq0fLww05EU+bA392jykX52BoOp5r5nDdpwCEuPSJkMHl8HP28GKZez+1M3BifrWJCC5s0fqzOKAT539p4yb4VLyu4r38xDUrFQqsCqDwrrV+rmyAsLvH74Tib5K9gUf5NVuOZmiCAXhsKMDunKObFHDNakDOw6tR+keMbU+eh5GqGP51mHUg7L4FKAvbKX8+K/+sR2JIwScz5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sta9crQXS+kGIW9x0zZkQR7SxDdy0B9hazrbQcjQnoY=;
 b=HSRXZsEqWIv+Sspz1QVTsQXT81mxuBYpsfK5e6/rpqHLI5h8YKze1mJTNRrL0bKaeFn6IB1DNwDCMMgonQ1btEU7VP2dll7VKoar/8F4HBs34CPmA7pD+xjlWLYyRERJ1k5b5jHN4vmIdfMjcd+rtMsX4LA5bmHGIEv7IODrdB92ml33yN8NTlskNhfQH/JJ0N/SmN6tzKpkwoWVr4fKVVvJeA4gAjDeKgfFRvl5t0TuSoWKgRnw2yKKwM4d4JG15QJM5R8czdJxy3Cnj1R2K8z6hLzbpkG/hYrX9Dck556gndVKBWP0fYP93YCVHN/aoOK4fOqvEDlOYfuQeEbMyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7583.namprd11.prod.outlook.com (2603:10b6:806:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 08:29:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 08:29:24 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 07/19] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v4 07/19] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZRadcK/x92OoBtUiS0KVBRL97NK7amtSAgAAJNSA=
Date:   Wed, 22 Feb 2023 08:29:24 +0000
Message-ID: <DS0PR11MB7529E3CE1B839C40B4BF0D05C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-8-yi.l.liu@intel.com>
 <Y/XKgUSaa9Ld1e8/@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y/XKgUSaa9Ld1e8/@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7583:EE_
x-ms-office365-filtering-correlation-id: afb7f8cc-7e41-414e-4e8b-08db14aee76c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: muTU7uZaYKZ4DXaY/2nehnPjxxNCHPwQSUFgJcG76cdp77ZDBUJnFInq83KCxRH6Wi8x1r1NfHOekzYpZS+JPjoFDJlnUhD0n001KhuYcCt0fqMWQsfC3BHvlHoupWyoCEhi7Xa/4ys2xqNauii0dw6umMviKXSReAPrhzvHecS5+xHslAQ6SQwhUs5Hufnqa6FP2oKAJ3HAGV7Rlxrju58O0Elvn4BtEG/7DUiH1VlxSVVqJOkB/s9UC/p09LAQBm4Zu2GX5c2uufXhfTBGQGeErnrPK0vhTTnKEx7OIpRixQoBPX8sPwE+aEBkc0SVWAJv0BQQ1foyKeyzfg3nVjNU82rMoamKl7xt713yxtbtMOPIyB16nvPUk6a8vmEKHhD24C4KVBJsqh6BjY5Zoft/gcaw3JX17expUm6Gxl92AeTu733XdsyNsD67yHqNRjXdVdG/imRt6KdeqEo8AVxs7mCdPL1n+vhfwQ+mEVfCfjVbTWYI/3kLJAJJ7iSQVdN7MocnHL5iRdLeyFOlxB2vYsMgNjzW8EQaHGed+8U62tsl0KzJaGb12/jCJ1i6+eZqYMPoeMhkIlJtdp1/uI12ez1di+L6ggtkYnn5q0ii+aSDgEa7HH5ncF1M2x3d+ADY3iP36SE9RT718VIIHjHvzsjYWDRBS4MPZT+dwPRcI1rBWbNJzn/z0AnLyCTVBUP6/uc683Y4W82S7goU8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199018)(9686003)(54906003)(6636002)(6862004)(82960400001)(8936002)(186003)(478600001)(71200400001)(316002)(33656002)(7696005)(66446008)(122000001)(66556008)(86362001)(64756008)(6506007)(4326008)(66476007)(66946007)(8676002)(83380400001)(38100700002)(41300700001)(7416002)(5660300002)(2906002)(52536014)(26005)(38070700005)(76116006)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/E4LCBGelUU7IEVxd5mGQ1jjt+J+wNztb3zLd3IMSMywB/wb2QPgvuI+iAh0?=
 =?us-ascii?Q?MFehararTAW+lHdT0r7O+jJKK5F/ZkmjzpnO03JM/zA9+YTksVGzolS8W0sD?=
 =?us-ascii?Q?L5LQspYIWeZEEuDN050eS24SlDsdIcX1lnTvDWPOomCZnpGoZW8/E9r+FCfi?=
 =?us-ascii?Q?uCxwO58hfGuwf+1cJpFZGp32OkodyeFLkbI6Ddhv3LivbHgxqsGvsn4jDZSA?=
 =?us-ascii?Q?EGAPz1tzQY6v1x5qyqby6IbSlutSmIRBjzF6pubTe6FiHoP2cQnUd2MpNTza?=
 =?us-ascii?Q?D4HUQtP1cgt8H6GAZp5lp4hDoKPuiIqyj9k5G3OB88DASDe4f1C+lRgA/Yw9?=
 =?us-ascii?Q?8ochgir5Koq50Pds1bNy5q7A19CYeeXc0MQCyeAIocP1Yd544Mvb8Av7j7sy?=
 =?us-ascii?Q?bnskpCmT4gKsGCnMf5hPbXuiNzN3dhCMpjEt5yfrr2UjGbj7ACQlvEr6i2gv?=
 =?us-ascii?Q?UDnlJBdbax2/ymxfaxlRY6hfJHhnkAUKZXU33j+SAPtJN+Bnd7PM9Mg9GEuL?=
 =?us-ascii?Q?I7R5McTct029ow1d7FLUzUJho9Hzt3Y399TYY7SedJvYiQJZzCLYNIFIeC8p?=
 =?us-ascii?Q?yEHox/GJURxPY6k9McX5v6OFvni88SsijAWwuljUoCk2sLLxARzXje/M9IhU?=
 =?us-ascii?Q?6Tr07eN+dppVnwKIpATmMWtDPZZztxw8O4F5w3oqa7htt0M6eTu5yDGQvWCy?=
 =?us-ascii?Q?xSUUjX9CxKsett6x4qSD3gq1SwbOsR8mC40WIrW+IHskKnJ7ebZgKPV0eA3p?=
 =?us-ascii?Q?Et8qAtBuwb6N9R+UUhPJ/nfPN4C9BtUaxq+PthtBp6ljP0xcfhmOAyAJn6Ye?=
 =?us-ascii?Q?y0tv24edM9jY31LFZEOHw/qMrsSz8mRNWS4loN5XOamPn8NdVhg7VjV1qeA7?=
 =?us-ascii?Q?h9InJVYjEAL9POllmzRaf8m83AkvUTFrTHk3QgBjFf7uVKbjbCcGVFM5S8tl?=
 =?us-ascii?Q?0MHF2UW0WWCLunFmDKWDurs/EM/VtpLEc9mD7bDxUaddmIBfvgAM1W2aFcOo?=
 =?us-ascii?Q?Ear4HWuIT/31RJ2xHVJyPF/Mik/vziOAd4tTGtVU99+VL633HqkM3YyAlGuJ?=
 =?us-ascii?Q?eSb7G6U7HzjgxvZbYjLcDxjhgLBUgM3wRiygKX19w5vdIt96zBJAQysD9UMB?=
 =?us-ascii?Q?9MjwOSTYcfvceEl10QpKCUlm/zzDKIwQ31fuem0hyq3ypZKlC13UV2UmpyHq?=
 =?us-ascii?Q?6+VxIYAUMkunbKMSme8jRQJRLwRaUkP/Xj86ijI6uG8MoIzZjUbU/NTA4asc?=
 =?us-ascii?Q?v3O8h4R59oK9PUuqvaPfdPeYI9h4EK8veMsfciPoU5APDpTf5pu9RiJ4zElT?=
 =?us-ascii?Q?WtDKnJAp9nBBg/JPBNavU5td4jJmkNw0pF2DeaU3BJxiBTTK18P4x33h1fiT?=
 =?us-ascii?Q?TosEBAz7eiCXrLrAm3RvM3HFxgIlb7tqNoMNh8v9Y+AUvJj2O846PHBVGnw3?=
 =?us-ascii?Q?6DdYm7ikR+jKDURZvkfXs2J9XR0dZumma2pirlq/0Vd1d31OCR5fXpKHp4/X?=
 =?us-ascii?Q?fzBBpSotY0palhQUPI6BmkcCLdPxl8Re4TxUUpRQSU6wknkP2g7AWAy8Fa2G?=
 =?us-ascii?Q?MJmnWgJXZJZcFwJfjrv7ZWc0gm798LsR8iRGUrYB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb7f8cc-7e41-414e-4e8b-08db14aee76c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 08:29:24.2244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4dLIULxB/jr6b+0vRoonrU1dV5tBMvdRpA1n+7skUOHu8zDR6Al49QBn1FsR6ZOvMyWSWaUka2/hd+qfOgme3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7583
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Wednesday, February 22, 2023 3:56 PM
>=20
> On Mon, Feb 20, 2023 at 07:48:00PM -0800, Yi Liu wrote:
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e.
> its .open_device()
> > hasn't been called). This inbetween state is not used when the device
> > FD is spawned from the group FD, however when we create the device FD
> > directly by opening a cdev it will be opened in the blocked state.
> >
> > The reason for the inbetween state is that userspace only gets a FD but
> > doesn't gain access permission until binding the FD to an iommufd. So i=
n
> > the blocked state, only the bind operation is allowed. Completing bind
> > will allow user to further access the device.
> >
> > This is implemented by adding a flag in struct vfio_device_file to mark
> > the blocked state and using a simple smp_load_acquire() to obtain the
> > flag value and serialize all the device setup with the thread accessing
> > this device.
> >
> > Following this lockless scheme, it can safely handle the device FD
> > unbound->bound but it cannot handle bound->unbound. To allow this
> we'd
> > need to add a lock on all the vfio ioctls which seems costly. So once
> > device FD is bound, it remains bound until the FD is closed.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > ---
> >  drivers/vfio/group.c     |  6 ++++++
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
> >  3 files changed, 23 insertions(+)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 2abf55c69281..14e29525e354 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -197,6 +197,12 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_put_kvm(device);
> >
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> > +
> >  	mutex_unlock(&device->dev_set->lock);
> >
> >  out_unlock:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 11e56fe079a1..d56cdb114024 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -18,6 +18,7 @@ struct vfio_container;
> >
> >  struct vfio_device_file {
> >  	struct vfio_device *device;
> > +	bool access_granted;
> >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd; /* protected by struct
> vfio_device_set::lock */
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index ea507a61e3b7..91c8f25393db 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1106,6 +1106,10 @@ static long vfio_device_fops_unl_ioctl(struct
> file *filep,
> >  	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> > +	/* Paired with smp_store_release() in vfio_device_open() */
>=20
> Nit pick: not vfio_device_open() now :)

Yes. need to update it here and below :-

>=20
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	ret =3D vfio_device_pm_runtime_get(device);
> >  	if (ret)
> >  		return ret;
> > @@ -1133,6 +1137,10 @@ static ssize_t vfio_device_fops_read(struct file
> *filep, char __user *buf,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->read))
> >  		return -EINVAL;
> >
> > @@ -1146,6 +1154,10 @@ static ssize_t vfio_device_fops_write(struct fil=
e
> *filep,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->write))
> >  		return -EINVAL;
> >
> > @@ -1157,6 +1169,10 @@ static int vfio_device_fops_mmap(struct file
> *filep, struct vm_area_struct *vma)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->mmap))
> >  		return -EINVAL;
> >
> > --
> > 2.34.1
> >
