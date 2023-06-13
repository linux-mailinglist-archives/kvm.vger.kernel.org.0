Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054DF72D976
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 07:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbjFMFqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 01:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjFMFqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 01:46:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E879102;
        Mon, 12 Jun 2023 22:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686635202; x=1718171202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p2+NQAwl7i7GnmkdJvlISPe+PdZZ0geN8JYQJB7GN4M=;
  b=dWdGKz27tyWpL7fRlBR4mOzwkZAeUz7e/wBhgy57VDTr1Auedvg7LGsi
   ifNhXAOZMHRT+J2hzSRyEwAE/L5Bc6fhh7wFt8q8qmmCkEgc2NqxFmwRp
   TMVzfZgQu4j94vd8PWFzOz1GR1hYcUxd9olOhHwo3htrXZjFuxKYD6bgC
   4dkZxMnpiBFCa0UN/RiUgO9Pm0xIZ2JoM9jAxJitjbcpb6u7cj1BJf04D
   9E+BIfWefxIzF23vXxZkkw/Ko9OCwE5yrK0ru8cZl2NvdcKpmZmYjEIf0
   duaz7fcGPzvZVGmU8E7ksUbXKBmwj1aH3c6eWz02NGXy6YP1aJxvn4nUA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386627907"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="386627907"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 22:46:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="661872511"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="661872511"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 12 Jun 2023 22:46:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 22:46:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 22:46:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 22:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQYyfztnYLo360ehRmzkxRCU8jZehwGUQKRPccTMTkfofg+YCEc6gyUS7KYSLQhezvjymh5zIH9qsw/D8h5zibNr5Jz4RsH9RJih/2ai6C3BoFP5MgjH/NXQ63BTam1aEOX+/tuQlUHSGJlyxnAGN0VXeMN6DC74jtXcIC2pLDqKMd/WYt19HyCWs0jid850yl5DvVC3r+ryUymW25rv+dXRtluHWfiEvowWYMZcK7abItfRD53nizWx42DBBKRW2kSnjcb0s9lrVdaUJXg4J5Ylt22QmbGN9/ZoiI3qIG7NP0SydFLWn9gygsZAWdRlRMqQyKgY9zlWx4FnrOEHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99SgBe4YTEIWBYsKy8o/QvR/1oEHCpBdAzsyITtwEK4=;
 b=nypbIeRQkcKJ/n4jygu/t5ezWajYfHx1HRN4YKBn9OXvFvCyWtKUUVIFWJF86RgiNiDy5QEXJqTTblnpFbG5uE5QCngGZI9dik/H9GJaW9bbhineaUobQ1lCRvdJZwfOf/NG50R1VqrDRbhYLe5EfZpFo0PGqU/UB9xXkKRiIn5emqpNV7ND1OuPuk/NzU5nddmi3bJCoPk03eXGuz78qeDBTKY4gExROxybxGKQG0qP8yqRo3zj7Jku/Rz43DjqYxrmz8DMC0I8Ektilf28J4/TC1ODJjiH6EDka4/oHDnf20Y+gUhcO5lAnr41Nnb2se+kfzxMuVsXdeKUVrQ5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8093.namprd11.prod.outlook.com (2603:10b6:610:139::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 05:46:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 05:46:32 +0000
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
Subject: RE: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZlUwrPp8CB3o9OkmAJqWvehBIwq+Hxa4AgACAbJA=
Date:   Tue, 13 Jun 2023 05:46:32 +0000
Message-ID: <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-8-yi.l.liu@intel.com>
 <20230612155210.5fd3579f.alex.williamson@redhat.com>
In-Reply-To: <20230612155210.5fd3579f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB8093:EE_
x-ms-office365-filtering-correlation-id: b1be209f-3980-4095-1e69-08db6bd18af5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ikkoYNj+LogjGBeLRVseqNkNBt9sV26iTFWwApwEO8EBJRasBDDLBoZ4cWM19yO+Z+CzLGHPckVvjDpTwGIJs9HAq5pD/3S3DM2BRuyiqSoCcNmk6CHf1NJtu+dPlMAlgyhU/okEcK+KIafDFoV/408OaVZMxkLdrff/E+l3ZkajDypzaqyUTBalXqYZjY+E2yXhhJkrsj5S1Oe7BmDQgLcOfk3udNQCA2pe6Wo6OArQN2v68egrwTbAxnWqrDLTXnWfwURG3hG9EaBjUWLYsmxLB9Rk/reDmul0M8xfXu/yabblfSjhMdfGPXPbqdWbK7IpGJoN+NurDP2FWryKLM8p65DRlTwmbpg48itBP90DVo1n5bHc5T8pEeT5zkL64zTjlRvkubdE8PT0i9bhDycz7FjWlpnOn12I+9tjNGjMLwR6CpWkIjTha6ndgiCWNekcBWbiRzC+EwkhWBlUehZDj2cYDrHz80eKXM8Nkh5/AbIxv0jBA3hAAxXqeHbXRqR7Tl5SgU/hSvTV058qcHthGPIzO8/4/mjV87IdN9AM7H55Oa7739gXkjrH19WmERTB3F3V467CfCoGPJTy3SsLLwGbbRLWCI1w6Iyu4g3QnBRXH17kov7aK5lgBkd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199021)(6916009)(66476007)(4326008)(66946007)(478600001)(76116006)(2906002)(64756008)(8936002)(316002)(41300700001)(8676002)(5660300002)(66446008)(54906003)(66556008)(52536014)(7416002)(71200400001)(7696005)(9686003)(86362001)(26005)(6506007)(55016003)(122000001)(186003)(83380400001)(38100700002)(82960400001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AuLCU8HBrS8ZIvjlmpg0g0965e4CboFkif9bLw/5U3p9ZdP3HGpT3oTHmCiW?=
 =?us-ascii?Q?XPueQK1WxW1ww+sJzrZNmIHvkZ9VvK0QxMp1HlqvKw1m19MRTbb5qxVKGjdm?=
 =?us-ascii?Q?e5GZmz2c2UJwze0lMip7wsJxoHOSzVFU8yH8MhlNQeeWknPaDToHOsgfTGLi?=
 =?us-ascii?Q?u4ME9gmE9+g6WghIMWQjiRsn+wYGRI+VO8Kc6dnnCQ8792rhHnFeMdkdW3EJ?=
 =?us-ascii?Q?EZOPVdVD/tPur2/OCw1FrjHk+0NILClP1yFU+E2jwR89ZB+rF3jJ4Iqbpp7D?=
 =?us-ascii?Q?6uIXHsK+M7S83qJbMs0IQ0/iM/FxnJfjRWElQjuEe17nYwuZL92lcyuk6oCa?=
 =?us-ascii?Q?xQaZygoneyLRtXeDNraWFhzmtkumcKW9wmidaHjwrBCUCYu7kuns4LNstBNO?=
 =?us-ascii?Q?uQuFs+DE74cGhRzakkqAxbh30DQZObGgvOkjmlpOe9unWo1KLzDy3xN6EjKq?=
 =?us-ascii?Q?bVXXy2DfuYhD2lWJomt6tjs4Pn6OnD/1XODGcu/9EwymS3sYZ4TNHCSIFqUC?=
 =?us-ascii?Q?38jjRib6KXJccYFoZ8RkRhXSeTUORWDPr/qD0zXhcydexbHs7cM4oT7YRckm?=
 =?us-ascii?Q?CIcxaZZ/enilv1hLaCU3MKUgPqK/5W2bRLIjUubCrZPAfJHdCvmxIxMalvS6?=
 =?us-ascii?Q?PY09i5w73abVz0JtaWZLGaWi8PAVjJlBaeJTRCL5edJNcEIFBrS9+2Qjm3Kz?=
 =?us-ascii?Q?cmekVhSG/Ymyha0NEWVylYDm9NQ7NsKw+7AulazbADk3805arZZzZg9RCHjI?=
 =?us-ascii?Q?jTTfchxyutUD/ULkbLgfOZMjTyc5wrWGdx53xe53LpLzN+opoMcrq95Q4Q97?=
 =?us-ascii?Q?Fg3ZBx5q62r86QeYmUo2jN9+aQ9TZH5nSsj7SaO+wtg7rc9Zd3167NhAbCA1?=
 =?us-ascii?Q?bqmEEL71CKwK3tBD4OkzN8utCOyWfhG/zat6nmeDWM8utNJ6J8esn1weBKO4?=
 =?us-ascii?Q?Qw6RgHLNCi0snn+sSJlaPjIkaqshC875PhSNetsC3lvE/+eI5UrvcQuI7QqA?=
 =?us-ascii?Q?V2xamVXaZ2MpyH1VeRxphJbrsfYhHRpJJERBzSlBVyuxs99m5o3NCh0A2Q4f?=
 =?us-ascii?Q?8UJ2WU7SVqztL2Ws+FLmGGwL7Hj46LY+pLcrGFa6Xr4ZsHOKIpHnygZ9KoBp?=
 =?us-ascii?Q?wcsgf7su7LbYyAo1F+t4nUYnoyrXgB/4f6r2Ev5ISq+m+aF/R+L8GbC+OSPo?=
 =?us-ascii?Q?yifZh5aLQ/0ff7PU18f1wtPqM3FVvxZ0v49pVMwisoLR+Vh04hDD+0rJ6qa3?=
 =?us-ascii?Q?cKpwvcKLvshAuPdO6THZhH1EsZsBpUlnJYCzPbgA9jpn0lBeu1wOKoNWf3iY?=
 =?us-ascii?Q?UYa75e530vIJdTomM+EyIjIHfUhl5s3fXue/qHBC24mSZ3cbxR4BgY9xK7ua?=
 =?us-ascii?Q?TcW4dmHKW5eiNjfU/HGEsfQd3xFLr6Q4KxSVlIk5smZRtrY0t74/PJ36fU49?=
 =?us-ascii?Q?5qV7MiuJVdUB6O9Xtrnus+KkPxCusohGd/7F0jK+Up8ooxsm8GdMYk1j5gMG?=
 =?us-ascii?Q?AS9RwNckCf2+dKghedRsGmxMyOlSX7607dCzQKX/uyvdiLWgjv8u/TnmzzN0?=
 =?us-ascii?Q?qmhED3RovvDOjQkTOYs2hNoNCf/I9sAeewEVWNX+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1be209f-3980-4095-1e69-08db6bd18af5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 05:46:32.6123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uz8xtjau/zSZLVHMV+Aq4+FGfeE+EI4n0XEfUZE6G1+bWabsAtoGzeaXWCx8wcCLbsjY3cpbjD5H891BKqcq7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8093
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
> Sent: Tuesday, June 13, 2023 5:52 AM
>=20
> On Fri,  2 Jun 2023 05:16:36 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e. its .open_devic=
e()
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
> > unbound->bound but it cannot handle bound->unbound. To allow this we'd
> > need to add a lock on all the vfio ioctls which seems costly. So once
> > device FD is bound, it remains bound until the FD is closed.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     | 11 ++++++++++-
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
> >  3 files changed, 27 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index caf53716ddb2..088dd34c8931 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -194,9 +194,18 @@ static int vfio_df_group_open(struct vfio_device_f=
ile *df)
> >  	df->iommufd =3D device->group->iommufd;
> >
> >  	ret =3D vfio_df_open(df);
> > -	if (ret)
> > +	if (ret) {
> >  		df->iommufd =3D NULL;
> > +		goto out_put_kvm;
> > +	}
> > +
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap and vfio_file_has_device_access()
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> >
> > +out_put_kvm:
> >  	if (device->open_count =3D=3D 0)
> >  		vfio_device_put_kvm(device);
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index f9eb52eb9ed7..fdf2fc73f880 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -18,6 +18,7 @@ struct vfio_container;
> >
> >  struct vfio_device_file {
> >  	struct vfio_device *device;
> > +	bool access_granted;
>=20
> Should we make this a more strongly defined data type and later move
> devid (u32) here to partially fill the hole created?

Before your question, let me describe how I place the fields
of this structure to see if it is common practice. The first two
fields are static, so they are in the beginning. The access_granted
is lockless and other fields are protected by locks. So I tried to
put the lock and the fields it protects closely. So this is why I put
devid behind iommufd as both are protected by the same lock.

struct vfio_device_file {
        struct vfio_device *device;
        struct vfio_group *group;

        bool access_granted;
        spinlock_t kvm_ref_lock; /* protect kvm field */
        struct kvm *kvm;
        struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set=
::lock */
        u32 devid; /* only valid when iommufd is valid */
};

>=20
> I think this is being placed towards the front of the data structure
> for cache line locality given this is a hot path for file operations.
> But bool types have an implementation dependent size, making them
> difficult to pack.  Also there will be a tendency to want to make this
> a bit field, which is probably not compatible with the smp lockless
> operations being used here.  We might get in front of these issues if
> we just define it as a u8 now.  Thanks,

Not quite get why bit field is going to be incompatible with smp
lockless operations. Could you elaborate a bit? And should I define
the access_granted as u8 or "u8:1"?

Regards,
Yi Liu

>=20
> >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::=
lock */
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a3c5817fc545..4c8b7713dc3d 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1129,6 +1129,10 @@ static long vfio_device_fops_unl_ioctl(struct fi=
le *filep,
> >  	struct vfio_device *device =3D df->device;
> >  	int ret;
> >
> > +	/* Paired with smp_store_release() following vfio_df_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	ret =3D vfio_device_pm_runtime_get(device);
> >  	if (ret)
> >  		return ret;
> > @@ -1156,6 +1160,10 @@ static ssize_t vfio_device_fops_read(struct file=
 *filep, char
> __user *buf,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_df_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->read))
> >  		return -EINVAL;
> >
> > @@ -1169,6 +1177,10 @@ static ssize_t vfio_device_fops_write(struct fil=
e *filep,
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_df_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->write))
> >  		return -EINVAL;
> >
> > @@ -1180,6 +1192,10 @@ static int vfio_device_fops_mmap(struct file *fi=
lep, struct
> vm_area_struct *vma)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > +	/* Paired with smp_store_release() following vfio_df_open() */
> > +	if (!smp_load_acquire(&df->access_granted))
> > +		return -EINVAL;
> > +
> >  	if (unlikely(!device->ops->mmap))
> >  		return -EINVAL;
> >

