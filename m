Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFAF6A593A
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjB1Mmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjB1Mmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:42:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E4E2F7B7;
        Tue, 28 Feb 2023 04:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677588155; x=1709124155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JSUmXmZWJB0IpzNo99k3nYXbXpxaDys3UYHpjLLwESI=;
  b=bCLVXEn37mNOE6TXp68ODP5CSDK++cMw2o2D+XDQqqwLa5jd1R1otDuw
   2mGcyCM6fewPL0JygXEvE3uQBGOJEA7t7x/V5whcboDjFxWarjykRbHmu
   lnvFyc1PM0HOgCrqCAyYwKbMIoBXksjdUXoDi+ktFJ+GZLQGjN7VfLBOE
   zIA8qtDGnpsw4kU5UDvRZAI49UPmAV0tLC4UiIYUBNg57g4GXKFXOSL7z
   0g07fiR6QIgcAhn2jcE8VfejK17EjJ/123CFEG1Cj0VKeuQBoZDAGKOFP
   nK0ULg8p/v6velYAl9v/zKQBCD0TTaa0qNNnrjfAsOY6hdqIRMfQvqrNp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="322377459"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="322377459"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 04:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="798058557"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="798058557"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2023 04:42:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:42:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 04:42:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 04:42:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkpWvi9PGBPnL+q0jSHYTOrb//HbgprHZvSTvffzIarvDVFArDXDjQLmaH2re6T8nCVoJCWwbLa8ZkUtcfQ72ggISfwWJRCE+TfZ+6+tNZ1gH5zunekspH7xi2w5Ae3u5OFPigIy9M+G34ekDbZ5VRoroLPN0/KbUISSLmLSMKHlWJQDaOE//pcVyKDauQT5ZITo7z1tVglzcZKy1D1xjmKJAPUisPfn8Vxrppx7ThPIcOj54zBPmujFP0WC2V5eR2kUqK8zbRh6jxTzpmXMZqtmDa46A47lNUMuBUZ19mAxy6zZq1HyIb5t5JvzG1IiV/hwBiYQO3gGK99WNU03yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgvV6kxe46WlMEUusfhG5FmD3a1dXcMM4zPgnc3itsU=;
 b=IK0+uBuniQ32o3WQPfZIHs0KDCygKrBRnOqvtEzfrhivzzLg1r2+vSUigPGxNeq/NjmeVRsT8/lNTt2y0DGemhJdxQsdcxMoyMWb7ODeQlAOQUlHEetJ1GxOJ/h/iXjgtHDwumPtq3Q2bPjWRlihYk9730Nb80Gd2lUd99qPHkt8P9PuiOCnGISVBU+6Ir8IzwWkGG3KAUlaCR+gJD0OoywlBHV0B7DuThg2PWePFcj9D0/2tIbJOed8JfxB1B27UpwS2rZbRGY3+6vySzaZWX7j1nIhNOSa9u6uoAWo9oUVrkKxKhlrC+QcZB/sUJgSw5u68byvp9fgTnujWU7O/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:42:32 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 12:42:31 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZA
Date:   Tue, 28 Feb 2023 12:42:31 +0000
Message-ID: <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com> <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
In-Reply-To: <Y/30TEk3t7q/D0Ho@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6360:EE_
x-ms-office365-filtering-correlation-id: 2f69c38a-8f79-46aa-41a1-08db1989421f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Za95Phkj/bhV1r2Ncc5xq0nIN7nvMRLAXPnNKVFzEkzcEkADUOKiDeeHeJaYy9/s3FD21tiCHBQKpxRi6jXwr9gEx5nHw6SXWMP5qwt55GucOkqlql6sVCGLoyTWsF6Ty1eWyM6YsLegUA0OYfNoRtFWXTDQukD0ESVwKOFbAGhVmt2ms1gSyWewNbVE+pGr+syxisBJ1PmcE81OaEq0MWMOKytksr6KxXoAC/yC/9aixB4aiNc2i44KmaEmUotWpAcx6jebsv5XyvRV7ioCERB9V01MAuqDtVDbeUnnZrAqLGKiDIIEX3NiciciTR9BrxHLSBB+XV59n21qH7+n/c5fEZMMpAQEIx2WhMBymKGl05dkmvZAsjYA7CzvQKLjiHHjc3s0bf8hl+ThxCjKdikf1TcMWQQtyuiPyGE6MHcIFLtjyNnJkGfBPSR1hwM52ZYEheoCAVlWu85BMpvdUh95I0m4Rv60yU5QFre20xc1cYnifRUHt9MZmhs93jG8lY5TOXTlzzVMrc86t6RjqmGtR9GRYSzIds01qDqtgT59EjVsbZyM1f/+6iGPL+TCYBXpaAi4NAcfYZ0pofg3l4/pmWKfKBq7MZJAwf8FZeR6kdAOs5RLHiKFeBY9Pf1KJCDMsNo+k9++Z3OjiiYq/n9EkiCP6wobG9M06YU3/v5+ZD6kv0TcjBDA3ibUPw+CUQKRfsilaKcT8xpgEYBvkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199018)(82960400001)(38070700005)(71200400001)(9686003)(26005)(186003)(55016003)(6506007)(122000001)(38100700002)(86362001)(33656002)(2906002)(8936002)(7416002)(41300700001)(316002)(4326008)(6916009)(7696005)(66446008)(66476007)(64756008)(76116006)(5660300002)(52536014)(8676002)(66946007)(66556008)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fX84hWVi66sLyaWRnUbZkdtIRlaWLasdeTueMq2wxg/rGlzkgD+W/7nqKRFg?=
 =?us-ascii?Q?+/pPlHkLartPCD7URkfGk7ok+w4QgJ5FeDTGC6DHUMnXY18GLsNsy6tZEDQE?=
 =?us-ascii?Q?ipVwR2XtaG6boDpC9Aty6Yl9z0tE6cnwmzUDArt0EzBcbBM4i6umP+mwFKU7?=
 =?us-ascii?Q?FoDRRCkqim6LrgP5gWKne5iS5YzoGtJvYFYKwp7G8MwzyjGwvLTPwNC8izpe?=
 =?us-ascii?Q?zh8QUelsfyka1Z+wfjgdPiWmfDUQ5WsOxxzXZTZAK7acDbO91IGX6BpG3vkP?=
 =?us-ascii?Q?wmFqzDpj0vz3Njou//Rmj8UJ4ZHL/PdEr9VcJus0uXzyqFNLvmowDCNC8K4Q?=
 =?us-ascii?Q?TXvWHIVubGXVFpt0eneTBT1rZfxPrXnvw6cutw5v9H1zBSdQJgisksYlstjp?=
 =?us-ascii?Q?IYhdpZCG8BqfbzI8R7Dzo5n7Akyy+3UW6fKyfSRx+wzrO7u3bl5KZKJUWVdh?=
 =?us-ascii?Q?ycFJfQppYSBuVwbpKw8H1IWbYPu5JFXhkgIVGbVsQDZCSYA9aeBnY2BGESsV?=
 =?us-ascii?Q?zDWDf6o1+7luViz0YGgENsQTzq4iCUjNVlnYOHMuoGszpo4UmcIMuA3TLzc2?=
 =?us-ascii?Q?S5YSFbqdcdQUTLSAh8thqq6bAsuq3PrTPJxby2mP7M8GVbTvSWd99SrQtZQc?=
 =?us-ascii?Q?PN6nhu0KgrbZeY4nogVb5Qo4Bppw0ydMQbjSAx9d+4UHwtB/lI8vTyzGJXjQ?=
 =?us-ascii?Q?HNT6U07q3rMX0/w4Iq8JF2KU5qMDdqic4o1TA5XafIkaPbaX/7Wv4zhfccjf?=
 =?us-ascii?Q?wqualR2FT9CstNGGajXtZS6v+v3yyxKCOagUT1KQq0giBDqk704u8ZSiotPD?=
 =?us-ascii?Q?Fvgs/MA9yJ+MBFx/6CHXwnNJ9QmQJH+35MaBsr16KJSolr/OSZ0bNA9hS8u8?=
 =?us-ascii?Q?itKytPCqEBp13CMILpydaQ8r7YfmwvHfJH7KReaAkPmmwsssLxVFzY3l1TUP?=
 =?us-ascii?Q?RaIYeDJx1dDTtQSeaLNVtErzVBWOzeAgOfpWoL2vQaiJDCEm8C0K4t46lAJY?=
 =?us-ascii?Q?TUDgNhnBfQ7yEnhDrLfcUbZPMqLN8v1k3EfgnYtBPBqUJupcAscKSie6lmgQ?=
 =?us-ascii?Q?jT+tkMckHVeT0e38U1nGQiDFISceHGntWl6BIo7hn0EwTI9gG0vErQAt1OBC?=
 =?us-ascii?Q?Pb9ZRg2/aVWfktQG7Vvt8WL+UODwcbLuS/74HBX29O+HHhE8VxZqKzeeTIKC?=
 =?us-ascii?Q?qhkvS4eiBRAfXpo6dUM5HpvGYc2uiUgAgT32R5IXwsi7xF3D8fuKwN+1HW18?=
 =?us-ascii?Q?rc0Og0nPH+32QPkA1HeViOzOPim0pJtGpiIRNaIcY3dgtGyeiUPRf+u1t4Ww?=
 =?us-ascii?Q?pj6A7gafZhKssn4XPRVZGK1Tw+nbIl0cBEv79eZpIvh2pjdru+0GipHLYgF7?=
 =?us-ascii?Q?HDJ+KDUlqv3wUUsHo4KPMQ5GBf+Uzk9zOmEMCItJgFRZ68Iwa225ir+0/ydZ?=
 =?us-ascii?Q?7xZ1QyHd+Mh11CTAptHIcYN552V9qT3OolhftYxWZgVW9UaRYkzWp4NwLqSv?=
 =?us-ascii?Q?klBklywJvg1JXq31voLApmKfnYtGQcDfVouoyNkhJ+zVLa29Qj0bGzDrTcr+?=
 =?us-ascii?Q?O5/n6AT81T1zx8o/Ua7vIo2WRKKMiH8R/kf0ETNo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f69c38a-8f79-46aa-41a1-08db1989421f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 12:42:31.3458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3im/YMlwbM9y+ADG8Iptcghl+P5OfMu/qjZspXZl99HiHi16dcY/E/EJXjlj/CUUbIlDNSNSw6XlMl16Kxcpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6360
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 8:32 PM
>=20
> On Tue, Feb 28, 2023 at 02:51:28AM +0000, Liu, Yi L wrote:
> > > This seems strange. no iommu mode should have a NULL dev-
> >iommufctx.
> > > Why do we have a df->noiommu at all?
> >
> > This is due to the vfio_device_first_open(). Detail as below comment (p=
art
> of
> > patch 0016).
> >
> > +	/*
> > +	 * For group/container path, iommufd pointer is NULL when comes
> > +	 * into this helper. Its noiommu support is handled by
> > +	 * vfio_device_group_use_iommu()
> > +	 *
> > +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> > +	 * Its noiommu support is in vfio_iommufd_bind().
> > +	 *
> > +	 * For device cdev path, iommufd pointer here is a valid value for
> > +	 * normal cases, but it is NULL if it's noiommu. Check df->noiommu
> > +	 * to differentiate cdev noiommu from the group/container path
> which
> > +	 * also passes NULL iommufd pointer in. If set then do nothing.
> > +	 */
>=20
> If the group is in iommufd mode then it should set this pointer too.

Yes, but the key point is that both the group in legacy mode and the
cdev path sets iommufd=3D=3DNULL. And the handling for the two should
be different. So needs this extra info to differentiate them in
vfio_device_first_open().

Regards,
Yi Liu
