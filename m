Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031866DEC54
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDLHOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 03:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDLHOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 03:14:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222912708;
        Wed, 12 Apr 2023 00:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681283674; x=1712819674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qqgFhiYuYElDD3tYWyYsPZ6h7dUtQ/7Ew1lTetmxF4Y=;
  b=iC7OU6R7ODWm4xrIUM6xsyn7RLzlSGdlORZd0ZISG5Aggq4qbpEnG8EN
   aT9R4t/8LMpKdP85SF0kiek9v3nijKwwKJ10VfxQWQoZGCF8+1qnc6OZc
   q6RzsG4HvCWuHwu5V0h4Tu17Jhn2rlwD0oqvYnzZ2uaB2upHeLvXkO86s
   prr/x4A5NExsekZUm6dEcEikPcN7QW/d5Hx2B823G4esUuVF/gOKus+E0
   8uMe+ua8qIV5iKGXApyuUfEwUQIe+2hSUVJjqVOtQ2pK2rGclZiHIV3Wr
   mb96XZxtD4PpNWQ66EeaJfozd71LFJfuFa9QIoBLOMysS2RfWm7+p+QM3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343828404"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="343828404"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812879145"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="812879145"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 12 Apr 2023 00:14:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:14:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 00:14:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 00:14:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KygQ0m820md9sxQhgkTGw/oOL1gK1QDuvuGava0UvW8GKkbr4cEsHDBbd041gsq4/zX96yWarri1CmuuiOpiH1guDT4NyYrj0yl2KsBphsfAiY7mZDt3ReZLW9Ygq+Y19JyaMrjxic/6WgmnbOvjnd6J75RRzB1QU7wVelw4cKEFJ+/EXIGcrC4kYgG8RlFzkYixVtHuenZyWV+6vysYoVeBP8RpX6jJzL7LZ5HCLTPvMbzQcgZA6xtsJRect7LlElmQCBcbir8Kcg0MofpNjv/aR9ki7ENyEPC8XY1wWWv1GzEOrmvRMuWkInE5Xvy6lEqqlvJu07S+wkFTifX56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRdm6CWVCZj8An0gwg0ouuYYKCMRYyid8rDkuCl/Yis=;
 b=LwRbeUtlq1EmjK7xj5Lc58QY/ZwEDH03izZwiSKHH0RfKmcOM1xwFfGfhXXxo9SRLIE7p92fYA1U6aIK+KjZ4ZOistCsA0WJx9/JF3V2kocwcCVPlrGivucnDTPvm7i5OG9UPP3PACxH5LkUx20wffI/1jRzbCl0XdF5aswoNfWgvR5MAaSTPURXDxQh+iZIYFJKMIMroV2jU8kAeNwfOjo8IDbWYasVk0HIp3vWBgJakEKmjHOjpC0MphXH0YtY+gtAYh3gjQjRAE48XtEuHR8XbPWMpCZ/ywfBxvdf+/V9dpthxhAr0OoxOQxqk4s2M39zqv2a26uKJXZjljMb6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5038.namprd11.prod.outlook.com (2603:10b6:a03:2d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 07:14:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 07:14:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCXow33Wzeq0K314B/OZqu968cqG8AgAAdbYCAACdegIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACyrQCAAIPEgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAAJdNAA==
Date:   Wed, 12 Apr 2023 07:14:30 +0000
Message-ID: <BN9PR11MB5276871042200F9F32962E128C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
        <20230405134945.29e967be.alex.williamson@redhat.com>
        <ZC4CwH2ouTfZ9DNN@nvidia.com>
        <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
In-Reply-To: <20230411155827.3489400a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5038:EE_
x-ms-office365-filtering-correlation-id: 9de3dd72-ee67-4221-af2f-08db3b258f59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Qr0ByjPnv4P0mlTz701E6Wo8X6bBJV6pgqNzAnn17LkREoogHJjQF9dFTHkqjepIblh5LRj0QiFFj9r/U6qHvD+cnMtTYuC4gCKEXQyfK4a1+HbnB0GzEstJf7fzuUUqEe5YizZV+RkOoAn6Qt/5Id6WYxc6MKHq0821Z7NyDNmF1m0m0fvmicIVfpEnLp32y9ht/vAE8groOGYxIVPbwYIilnA8qYCFgfbZhU0wyO0KkLB8HbALXqMZCnqHF0qd7wDX13Lf49cuDl//TWDW+FseZmNAPS3dfwY8BUVlgKOVjLjawzqfjVF6lAGiNTjokHeOIj2qkV9TysT/lIwh9SXcLFPS+1ULiizDwOo1yyo87Msmze6cvLmdMqXXpZ9tjFRV+WrIdQNveC3YCasYW7vX8AF/a2d875eGXf+Y60f53set/i2rbpINcPyScQwU65TNPUyiYdZvIJ5ikwCNShyDiVxDeTPv7xHaeaD5N88pP65rt+/bXp5WzOFRh63SRX9K0Naw27CpNB6x+PCRMOzTvW2Q58TvRXpWc/1fw31l/3SMWDlGujWuEm7eBWBr7KV04x7Zee0WKDYY6ZGvKHCzHkLfVi+IwKd1T0o4DMCX+3nb82ClRn1Pe0JGQ5P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(66446008)(66476007)(64756008)(478600001)(4326008)(66946007)(76116006)(66556008)(5660300002)(54906003)(38100700002)(110136005)(41300700001)(316002)(7416002)(8676002)(82960400001)(8936002)(55016003)(122000001)(83380400001)(186003)(9686003)(71200400001)(7696005)(26005)(6506007)(86362001)(33656002)(2906002)(52536014)(66899021)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZS9IorAuySuMxuguYPtENghMERnBbFr2KiejuYASkJKeEMWcmdmVd9vkGgIl?=
 =?us-ascii?Q?2HnEw+0iXre6ugSpLIuUpkRINFNf9IZqKWUyPP0X91MTiR9R1Ji4KQtizewf?=
 =?us-ascii?Q?JDKw5QgXEuxDl/vLjeW9Bu1RqA15h33KZK5rnPEckCF+7Bjy0vKaRcpfeoD/?=
 =?us-ascii?Q?VgSa5w49XeMnW3+tJalH+x3Of0yyoHmt4uTr4nQLG7Df8eV4N5Ht0KUzFb0E?=
 =?us-ascii?Q?IxcUY2EkHDkBeLNuo9RgFswC2IPAb+SAVT/Prn37OZtvumLuotXVOa9AHlVk?=
 =?us-ascii?Q?mwoaKnLnh+U9AOxG4lpTj83LC4JdcT7r6cSexz/IdpZfClBa39jJkigPOtx/?=
 =?us-ascii?Q?F3A50G2sT0L+7LSB9+MaZAffrrJwBsAsTv2up7SPrhiX6FsymFUse4Kfcxd9?=
 =?us-ascii?Q?4lV8TtuL5Y3BEq2VOGSu1a/Ibq5ksC4JCBuheeEDPNq23bT9Q7fJnll/8Z4F?=
 =?us-ascii?Q?9F6UlwKUXKBhzY+F9mijhvL8ySqNZ11fO4/4Ho/Sg9ct/bUD1QMk4mGi+nC+?=
 =?us-ascii?Q?XkjlFh/wbKc8aUzNa6VVbBRYXGAsPi2263OHKr641gZ4wcnpMFpH+myoTDQV?=
 =?us-ascii?Q?ztTcXVFTTnx1mWY+3SsGi5VNS8gx1pMWhAYg1//ymlJYE50MIE9nc6InEe4z?=
 =?us-ascii?Q?0Hp77Shz8eaJCJoxQ+MmJRYPdp6oMO77R/VZkGtKGwqv5PkD6to5TbDLCiEO?=
 =?us-ascii?Q?AVFZ9Uzlm+XNH14D+oC3L8cNYFps3uHVJE1m/G7XHZGyWwYdS81FvnYSVsSW?=
 =?us-ascii?Q?xuItY2ggJgPH4Cs5feah56390VVSmUyPAV50AfVkkwQfOou1JWP9ldeKmwNW?=
 =?us-ascii?Q?PR6MMNqB1f8WmhuZoKykNhM+SKQkzJSX44HNj52IeKHtV4NvX+Kgn2Jwdis6?=
 =?us-ascii?Q?GR2MyW8AFr2JrbWme0sveagQLk7SBjpNpxRimEPNdU4E4gh/2tYvlj8n6Nbr?=
 =?us-ascii?Q?NkYX+x1MPIzAxjLVbfYYRH+66ISkG6gyLeBiKdWesF9Rr5o9/WigMzSMCbvm?=
 =?us-ascii?Q?sMVAZU8Suo5KeBw2aS3iOExutjyGP0j+zwklAuw53IBCgEeOLj/f79Pi1HUl?=
 =?us-ascii?Q?B+kb+opobSSfKEPHGfWbH8aZohKHAgv5JnP4bkbf8V9DjknQaaynfaFomd2b?=
 =?us-ascii?Q?1fawmBJr80t2fyXDSJqG1hPjtefu92wNgih2GAdzg0ZCULmrHjUTvZ7q8c9W?=
 =?us-ascii?Q?PBg9aZY1v8f5pVFLZQLQcFi+p0581i99AKVc0Ls7YgqY0l+jckb1PatKrt2y?=
 =?us-ascii?Q?91Oo1rTXdaLRTgaDXLE0WaNQLiiwSJTJ8Y7f+5N5v+jpb7QevYbAk5q9Agjg?=
 =?us-ascii?Q?hcVkXYPq4btTJyhw2jhoPrMnS/+IeVDnxYCBGyap/Zu0I1kFpn/KhE1rcqrx?=
 =?us-ascii?Q?uMd9Jygr4Ma2Cus6j9iklUc9Kn/BPXSzVpcLlUqI57O3OHJ/rSw0WBS26KIJ?=
 =?us-ascii?Q?oKtX/ovLP23QJEirhImTcrxgvVpDMyO1JFXqprZrfXEhBLkqnYbE/xY8Y59i?=
 =?us-ascii?Q?pteoYAJkS1Ez684S8YDqWmOR5lCFQ2nzLk4Hu+VLRFN77tS+w1M9CO/PP/SG?=
 =?us-ascii?Q?6bj6hrN0L3k/gnSZfp8310V6Y9r6QQx0rJNhYaCO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de3dd72-ee67-4221-af2f-08db3b258f59
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 07:14:30.7764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D+YSa9vZUgsThuvlAaTPmAJi+3aEmx11FpuLUAD453Tm/9sd6msHGnGGUT9lUW/CvpllfUR3/M3sqys1xI1I4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, April 12, 2023 5:58 AM
>=20
> On Tue, 11 Apr 2023 15:40:07 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Tue, Apr 11, 2023 at 11:11:17AM -0600, Alex Williamson wrote:
> > > [Appears the list got dropped, replying to my previous message to re-=
add]
> >
> > Wowo this got mesed up alot, mutt drops the cc when replying for some
> > reason. I think it is fixed up now
> >
> > > > Our cdev model says that opening a cdev locks out other cdevs from
> > > > independent use, eg because of the group sharing. Extending this to
> > > > include the reset group as well seems consistent.
> > >
> > > The DMA ownership model based on the IOMMU group is consistent with
> > > legacy vfio, but now you're proposing a new ownership model that
> > > optionally allows a user to extend their ownership, opportunistically
> > > lock out other users, and wreaking havoc for management utilities tha=
t
> > > also have no insight into dev_sets or userspace driver behavior.
> >
> > I suggested below that the owership require enough open devices - so
> > it doesn't "extend ownership opportunistically", and there is no
> > havoc.
> >
> > Management tools already need to understand dev_set if they want to
> > offer reliable reset support to the VMs. Same as today.
>=20
> I don't think that's true.  Our primary hot-reset use case is GPUs and
> subordinate functions, where the isolation and reset scope are often
> sufficiently similar to make hot-reset possible, regardless whether
> all the functions are assigned to a VM.  I don't think you'll find any
> management tools that takes reset scope into account otherwise.

If we only care about the primary case where iommu group and reset
scope matches, then why would the new claim model in Jason's proposal
urge the management tools to understand the reset scope now?

btw in your earlier replies you pointed out the issue of unpredictable
ordering on a multi-function device e.g. upon which one runs first
dpdk or qmeu will block the other. But I wonder what is the actual use
of allowing both running while both can't do reset due to affected reset
scope in current model.

If a vfio user cannot do reset doesn't it imply it hasn't acquired the full
permission on the device then Jason's proposal of explicitly failing it
is actually a cleaner model?

Thanks
Kevin
