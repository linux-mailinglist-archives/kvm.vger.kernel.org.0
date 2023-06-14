Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE0172F453
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 07:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbjFNF4S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 01:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjFNF4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 01:56:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E91BC9;
        Tue, 13 Jun 2023 22:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686722173; x=1718258173;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zv8hEcyN/CPXBAbwmXAAu9nRmKZA+jWHmtr/7MVk6MA=;
  b=LaRYlMPkVLhHcCKxEMIFzAvWjT6qNspX3Jpsnugqmlgk/pZT/DYi1lDv
   ylbNfSkAXcOK28Xi1Lrv3fBMrho9mkoOutiJ9PCve5KmvLckDac34TK2I
   FaYu0fVn80uyQcudP43U3y/wnPd5f1gNCnOfVTCUr3stjLolzcHp5dD9Z
   C4YBOuzRXxJ7pqPfnWzvc0KZXjwb4aNmWa6coydPpxSZtIh8eMPTEt8QR
   WLKdNhYFHeXJPtiBl0uUDD4DMYRTw7SG6z1jMUBMjgEMpA8/jo800G3gE
   cApXZuw9U9UapImEu1XY/CLLkNo4TzfYudjhY4AObQJXTyiU8oD982+No
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361901450"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="361901450"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 22:56:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706080273"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="706080273"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 22:56:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 22:56:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 22:56:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 22:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xrz+l4XGUeMb5Aq0QrvS0ihru32pPJjxxQLLTmLeKxPRGDDno3J1DHwwxlDCZjr7d2z/n90Ha0eHlkxTrXB9hUNXC2SR2f738WnfWcFGTHu8GejCKIykv4ZI0RMuvXdx7Z+MKtf0385fg48QaVBadc5n77IT0ktqofYyjOOTaPk1WReoEjLEohFHQHVsWWFYsaca6pclov7qJjrXjv81qqNskQq2d6KCAaUCOQ75yULmIv8yNgQTYcfPox73OICkQaBFyTaksC+hSin3rz78IPLeiALQkJvUpY2bXfApDge2eqI9bdaCvRfCX0BWoszy13CvsNtFpUzlTk31FIzltw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ROBtjTKjZz97ctPCQ0v0sEY2ulrMO/yAfSaq3by7fJw=;
 b=WzK5/UrsJ1RFSQZleZMwMZSJG0pOHqtvPJpaM83MUREotWRJ0rCpVT2MaEPr9GlyE6iECZAZqmn86AqFYbw6A88Vlr0PRISd6ynkpJTOqPrMdGi7oBrSJTr2ajPZAFjH2HQeGqTtlW4FTzAtiQhBC2rH2tPI+WpNRdvWhjQcK3BCKPaY9ChL7mIcvu9G8M0zoOF5JyJkCDDJ9r+GZrf9fWcbQ6GVJONe1snUZCwWUc2OEsuROIMjB1dicrffmmnEmQY3wEChcnK7sqTBI+p8d3V74Ma5bE7Za9FzCtib4MuzwhV9k95ZdWeeKliCnu9CBW1BhNNH2c0z6WuAX2PMsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CYYPR11MB8360.namprd11.prod.outlook.com (2603:10b6:930:c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 05:56:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 05:56:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v7 6/9] vfio: Mark cdev usage in vfio_device
Thread-Topic: [PATCH v7 6/9] vfio: Mark cdev usage in vfio_device
Thread-Index: AQHZlUvxfL+AQpan4Ee1/gkIuCXp9q+JFhmAgADDK9A=
Date:   Wed, 14 Jun 2023 05:56:08 +0000
Message-ID: <DS0PR11MB752998A3AE0185BBF179F3BBC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-7-yi.l.liu@intel.com> <ZIitv1rz3wg48dOW@nvidia.com>
In-Reply-To: <ZIitv1rz3wg48dOW@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CYYPR11MB8360:EE_
x-ms-office365-filtering-correlation-id: 03aa13bb-1c05-4d43-c4ae-08db6c9c0c8d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SzEgKU6QIaFc3NUw+jvm/TiVsB6Xe3oD1kHlBd90fn/71beY60rEtKgjCxGAhL4JGrm1EP6d0Bjj7Aug8cI0evwx4TlAa7nSoIpeFi26dijSf1dgtMjV557ixlJbYAbOVBAJKi1bQTiIm/UV7Ff040CmYtCsuK/qyHZK+RJW/MZmZmPS4tCqhZWnKRvHiy2KczWxWCGbLrA7R7fog2NTFveob903lFYHLCaN52LqgmBQi28dIW5ytAtZmd2bBse6z4CfelyfVepwAyBJgSw/aS8TexRcMu4fz9ykME1m4MA/zX1QYJhQBvXfM764Vr3Uu8QAwIRCQ8p8wihBkf0UeYRClXH1W+VYtCtHhXWoJidIACGzgCZwD/kw2cMszDmS99/mIifDQr9Jw6ntuxFAxem4SJ4PNHD5NkTLcj7KOT5L2f7GXNVanUSHuteAUletM31iBiVA1654NX/wC9/3zCELYXaFdDt7NyoT0NicPbQh7x+fTJ/Edwzc6ST3nEAYm24qTwQ2r2ciixPL7ytY/jiPbW2dFS5tSGko0sMhp0u54qVCtxd8ueWOpQc2ss76tWcExSoK7yBenohb/TPcyP6Xb5rIaWu9l+9TgMyex3A5T25AYfhsu8gAXQaZm+EU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(7696005)(8936002)(9686003)(26005)(8676002)(41300700001)(82960400001)(478600001)(38100700002)(71200400001)(66946007)(6916009)(66476007)(86362001)(4326008)(76116006)(66556008)(64756008)(66446008)(316002)(122000001)(38070700005)(33656002)(54906003)(6506007)(55016003)(5660300002)(52536014)(186003)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qe0jsWs1foxMMymDs86A3uRMjL8fq8u+azb0g3CLtOUlr+UJoS1CQIozSh+C?=
 =?us-ascii?Q?dpVA7sbOvtidUVVCpHvXmo1KwMAP0zoE4lusJyQnQzmk8sQ9UbKEFyWyUAcs?=
 =?us-ascii?Q?6WgDA9Xs+YCCxnM8Ff1jK6syhaS1658MwyXWGccoIgA4i0SOGBdQRTgLoFIS?=
 =?us-ascii?Q?ocC4PYUq5Azd6f/Pc5dkif5jURv5O6QFwhsMi2qafRtR/QdosGVXH+LZ08/n?=
 =?us-ascii?Q?SToJtUx8DOadMBBoWRk231p2zX0WRTfb0CopNgxu2do5h4QpjgVD8apLjMTQ?=
 =?us-ascii?Q?4bq8UmMJb+BMoPnNnLl2sbkswBuNS9+yOkbkUvYDt+jDpSV9DGo1H5Yl0jzM?=
 =?us-ascii?Q?ijoNKnqaYW7keIBfpa7LJwJt8ZDKK4WN1ydoCIx2vb5KjxICtMp5j301557B?=
 =?us-ascii?Q?KRG6AG++dneOJ+sxNbHoAHZTQDQGtznwGeA0fns3yFdqGnKWX88yg3LQJAQL?=
 =?us-ascii?Q?hS5GIT2b7oMWSMEUXMj9lyeITT5shxt6iGm8mr6HPlhgoQfstp9xdHq1UhcY?=
 =?us-ascii?Q?qbwoGsCWN+l8KPEKnM/bgz5br1Xqz83iBWd/Bk4QHsIU2xwoFLiO0JhBuWMY?=
 =?us-ascii?Q?AdZt7qZB/JFldyR1N4IOp6TGBvDgMpxXtXjFioMX9JdN87hl+/UjpLv3um60?=
 =?us-ascii?Q?uw35cUvT1+0W6fvI4zN4hKxk5gv8qC5HLLZuxaX6lwhbpMujVUQgQbxjxP0u?=
 =?us-ascii?Q?Q74LO+psR2FyAmSXcTsdkHjNoMqewtIyXzddq8mqApnwcxZBM8SCObr/Qolf?=
 =?us-ascii?Q?1Kuq6VigEOrn4bZyQkZujH5gWkH3DOW23N/5jx/YzzTljuSDTfo86KEG3/tx?=
 =?us-ascii?Q?05+blAleQVr0oDfPwHFphOEOoXn6YWx+WosdQ08OX2j7K8od4/m8/ronlZm6?=
 =?us-ascii?Q?H3bf0Dm4lMRxO3wFZ1Y3YHvljg/rMnspYyvGBUJTHjlU1X28xmeDpf28icZf?=
 =?us-ascii?Q?5X8SvYfXz0tBlTqCnhArax9JxeTOUy54aK2xmwZtZBUMkX2vuaIEFDyDecrL?=
 =?us-ascii?Q?CTKkTn5SudUEHa6nyjzqoxTycb0h861KlskN0B3G3nJHC+GCjpcthSfCIbI9?=
 =?us-ascii?Q?OGCNwnJp8gItNU0bC1G2OcxZrtuoLAAJIFM8Pjc88aIVCZMPbGWchbkBym6F?=
 =?us-ascii?Q?6AywxgwUcWA3e3UUhRvNzGB1AJEy8j8XvxuZ7dY2byHuOwTQj/RLq9iMTAlZ?=
 =?us-ascii?Q?1zgPUr1HxrRbywnqP3pxj3n34Gf0VEG+bnw/99dYWOZz4d56t0dJx+A/dIKk?=
 =?us-ascii?Q?2wJpDPwZOKpCpfTT5UaFhuz9xO4t7ODDyUpeTClTM57MkVOtqrBnTMMFfkZS?=
 =?us-ascii?Q?yX59f3/jAdP1tM4zeGo7ybN+nKTcHQgajp38Aulk1SogBZkdIDKYBActajAz?=
 =?us-ascii?Q?UxL8BSyEvOYZmWNAEN2Vy/s/rsZh2mqbVR+mfkbHYco6Astd25EspiJv5suT?=
 =?us-ascii?Q?J+G2/UyTYFcm2Dk6GgmMnzR46+gHv3x85riBpB7E1aiD2URt+65Z51xrH8eD?=
 =?us-ascii?Q?M9sRVIxMvTwAazjcsUy+N7n3D4GEDy6qt+NqSPbd4X9pxgyPffG6RXo4psrB?=
 =?us-ascii?Q?BTIyHNA+zrfMQPNKL+stAyqPlBYSfQ9nfWDLXFL8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03aa13bb-1c05-4d43-c4ae-08db6c9c0c8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 05:56:08.4324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WkYcJXL8lUdGeG+8njmJVEkIUOzoM0rII2wV/wdAFULS1sODLG/Ly0IUdtiXyJwxqKnANCY3NdvIUfe5ywYIFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8360
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 14, 2023 1:56 AM
>=20
> On Fri, Jun 02, 2023 at 05:15:12AM -0700, Yi Liu wrote:
> > This can be used to differentiate whether to report group_id or devid i=
n
> > the revised VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. At this moment, n=
o
> > cdev path yet, so the vfio_device_cdev_opened() helper always returns f=
alse.
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  include/linux/vfio.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 2c137ea94a3e..2a45853773a6 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -139,6 +139,11 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_=
device
> *vdev, u32 *pt_id);
> >  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
> >  #endif
> >
> > +static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> > +{
> > +	return false;
> > +}
>=20
> This and the two hunks in the other two patches that use this function
> should be folded into the cdev series, probably just flattened to one
> patch

Hmmm. I have a doubt about the rule. I think the reason to have this
sub-series is to avoid bumping the cdev series. So perhaps we can still
put this and the patch 9 in this series? Otherwise, most of the series
needs to be in the cdev series.

Regards,
Yi Liu
