Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7508A687548
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 06:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjBBFi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 00:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjBBFhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 00:37:53 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30DC2E83B
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 21:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675316060; x=1706852060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tntawl+mz4IfcHJDYZ+t3JwQP+vblVLtZqvSQZuDHEY=;
  b=CaARRIAcHYxw7+8UVkHNpcDbFsn4Oi1Glepw3LhLlJ0Iu8E/BIIqWMnp
   pwmXIjVeksMup+GgGOlUCCELT024VjU67KnH0ukDk71OW0vsTaU1tLutl
   poQVD8S8mu4sMl/F5CeXaJK1LXoVbCROvrnCvCrDIcBmZCg4wWk4Y8EKn
   B6B5T3ioPFFBtQA6BgfDPGLtm071xr5HzJ9a5NqPtOq1rMiAU5Px86Ap3
   cSNdYEJ6SOurOH3cbTXgErGzJs38BOQYdkvhCNYGWcp1yhbfAsRSU8McV
   f1GlKjhJWRt8E+0LiTOUaEVLUO8Bg21tPBnLsNSb+TPDjCOHM1bAv+P0P
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="312002292"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="312002292"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 21:34:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="789160732"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="789160732"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 01 Feb 2023 21:34:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 21:34:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 21:34:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 21:34:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 21:34:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9w6gQyXr7WJClVWooPa8pPhboQ+dy+qJ1nt7yNETzxW1p5jznzrgxcbAtrO3wkV6nUO0IN81nCIoOWKvC+bKueJLmWGv5OKDm4Y72Wd6X0dtGzlNLwjN8oFPNxVGHwTn07yEkLfsTn/w4qZeUqCTQqGSLmk+SDX8y0Fal2KFRmQnhrGVxVh8B8zNOfcc2iCeQtZvhUWgKBmNR2FF841b1R7vPDVPfLAs6i4ALh69Xj3VlwWMzf3eXtJk4Eqrag6UT+4U4jY34VrsXLn69VZa+33GzSGp5okF0n5szwqEmXCSdcGwkRj44JSz0bh/45YzP/qNOe4lwF0zyDK+eKH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf05sYsr+GOydWJS87yKxJTYyP44NBKNNdfvSPL+9IA=;
 b=mrLyXLs8a7iOAaRxBBu+KEMDvKuAD1lS0SOZp20SgxLbbjae09r/Ja+Qbo64f0gByZJpo77gxmWYPK08wew2OykYbaVseEwg5RAtIXhB9qMoQ9dzbV61CUWFgfWJbCfctJIMvyhKv5ILIQe0Dt13ncGBnVxTQVWkp6UYZEB8GK5X2WgWf3JREuNMz8/y4CZRXk98MQ1CXNu3P1gBK8GyRVzSgwH43czjAP4CCe2sM4RaXlBLqbMJAOSeofc9BZIF+KTwokDBauEmBAxYoBTN9ksDwc9iw14U7kg36AwubrybupaZGHgefEQ+Ne5lOw6bPHul+XGccOu+6KsUe5vbog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA3PR11MB7414.namprd11.prod.outlook.com (2603:10b6:806:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Thu, 2 Feb
 2023 05:34:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 05:34:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcA==
Date:   Thu, 2 Feb 2023 05:34:15 +0000
Message-ID: <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA3PR11MB7414:EE_
x-ms-office365-filtering-correlation-id: c7dd69e8-9a18-40a1-43ee-08db04df1f74
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Ey/6GEdMJQtu05RDpNryTJT1dESsj2aTlS1HzTwY0XcAIZBhmfIGtgXnuTgy7ir2hbo8bl91U5ETNtQOcZLC3wg8do3+8glYrTANiYcXUp9XEqneT0PaIm1qQivr5E9yqjDiigDqqgCdCBjISGXkfHg2JBedLlt10Z3HWu1S9Z5gjpgLuDLxdDRajoPys3G3r8lhWPwhN3bH74bfnL6IBDbfLEJ/ErPMVsacPhBUNO+qPHkMpxigvJw3WfIqi1m0vPqYySyENXYJV2CdPawdbctsVa/zeYOU4nVaVXQvBakT3Ood7VmLkH1Fk1X/y7P4BliR3FdyQDFqR0b67kysa6fpE+FQbAJA5Nyf6buzYLM0BI/7YTlv/fHgHD1JfTDWX0DlvufooupE3t15g4Ehb6JRNkBgeNAjHKoJ6CkKlMsy+aaVqOKpw8pQXI661KfdHPger8nurCqk0cNjCatsKWzYTCJ3Wo2TknsBbmNIH5sNy7GZI1FyH5KdlMweTAm504Pg4RvWwm6viyzX/8nsLZ8XOnmy1SoXxChv142b1s/zAsW6ppbt0IP2xO0WqsqLST9SxYXK4ZCgypaHA+aHSyHByfjhLMlD+C3+5MmFGvsa6nZ8Pu3NCkBzJVi3ODQSHgl/Xx7u3oazAjcOVP8dUbg8CWDghr60rUULmpzBfKKLcDJtsmWuCDN7iL2w1appqq1D+S+YUvrOmu16JO6SV4PvRneX5hsmfU++P3EXA2g/TvxKJVLuW1Cy3I0xP3pA1oxfWb4IITXVaTQBdZoBAgVg/VMj6aarjVS8jozw68=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199018)(7696005)(66476007)(71200400001)(33656002)(66446008)(66556008)(64756008)(8676002)(6916009)(76116006)(8936002)(66946007)(41300700001)(83380400001)(4326008)(478600001)(86362001)(82960400001)(122000001)(2906002)(45080400002)(316002)(52536014)(38100700002)(55016003)(5660300002)(38070700005)(186003)(9686003)(6506007)(26005)(7416002)(966005)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oBWjQsomKhKzGnVPJxGIhC8ba6wVsENKoaF3l3khNEc//scwDyjr6nq7+Q76?=
 =?us-ascii?Q?G54L3CLRkskUfb5WmA2EdMCy1n51UF7Yns/eT1ldsRLIb97ypS/7wmiqwDie?=
 =?us-ascii?Q?bXVfBjOMT7PLM6RpIu6B1P9I3X+yCQOg0p/Lo+prYa58PUmM5ZwUQ52TKXA5?=
 =?us-ascii?Q?a1zW0wxuD2Ay1hmINUcRDJejdOqZaRgzy9DMcIQ/MZ0+8rekowoKMSDeX0Le?=
 =?us-ascii?Q?YLc+wmlgUyqpuOdQN17slw5HaUrarnba9JqUlQ3BPXy2OLP5aubSWudX9juq?=
 =?us-ascii?Q?qC7CLmOjxLFaVgDBszeIhwc3sLPuLEZX4ZcHCobmwTbuUtroo+Slav9pG2A/?=
 =?us-ascii?Q?MRnYKCw6dDbaBU+nAcyKjJmlymMbG5S9LK8143mQ3WfbEjkJmZvR9rUJ8SlH?=
 =?us-ascii?Q?T7+TkXM2BRR/aiWIJ96fbcgog2dyupkix2Ueqc4LboQRyIvbmF7evtN0qGY5?=
 =?us-ascii?Q?8ViY+Z27NxM1/vQDdI0CQZxlbB3BK/CrvdzXcVfgydBE+xgVQhuJritL7pbL?=
 =?us-ascii?Q?6PW2sYVxUdmAgGDycb4Uknkg3CnQF2i6VPnssqhc6kvKucjA+jCrenae3XR9?=
 =?us-ascii?Q?Hp4AWpHXYl5fY75YTW2B/Aznig2zBME2t2d/MDN5jFW+2Qklpwd9ziNfsD3Z?=
 =?us-ascii?Q?06saQnF2yolrUeMTjf+YAg+2krtq+6O5z9a2kxiRzRGknrrKBVzrIYBA8N03?=
 =?us-ascii?Q?H3W12Ee6wE5MgZBGFkPcAXAWDwNeq0QFadq1BoIe/UuAR8bBw5qqR9g11Tfn?=
 =?us-ascii?Q?MEE8TAYMVaz+tOTnWwQoRo4gA88STFp19zcjBiQYK7exIOls2wlTBZ29cc9Q?=
 =?us-ascii?Q?S1F9B2svR9hJi1/pURaFUny16D1qjOE2uEnBy173MoCg71zz4VJ3pYLdqopL?=
 =?us-ascii?Q?t84vgNABCQIH/OFMY74ZEKbTJmmbjcfz/zbh3WT/LHXtOBewAYFfe71lMP9P?=
 =?us-ascii?Q?AaGufVYV1UDAOZwbKLWE8O02OOCC+iMzwywfigl6zWDvQ3Zjh5hLD71O1qji?=
 =?us-ascii?Q?wespJ4EB5Sp4pdHSWreTocaFcCspNx+t4mQNYLSZXPrziDVaMuDnLysNIFFI?=
 =?us-ascii?Q?xOpCr/uxAhwnzeotEbSqL4v+t8q7PlaJmZDR0wwLsrWd765WlLc49OISP1jP?=
 =?us-ascii?Q?aa6wpwUvab2yy+DbBPwqHpZPehsDo9TPeEPINlR7G5pdLYK69GMtAeZCHCEH?=
 =?us-ascii?Q?VbMe28lejITqAdfcIjw2YnsaPr3BOf9IMQIIFOdOVaIKxj+xYQFS8w0WapY1?=
 =?us-ascii?Q?koCMsTiciJrMncnt7skDL9vxo853dfl9Y+9UOafcTnND/Dx0/LGiNhoMnrwS?=
 =?us-ascii?Q?Bl7GhpASAb7FrEkVeX7nNTBpAaCdZ+wKy6jq5wmcCfQyoR+WtJFvi4DqQDm9?=
 =?us-ascii?Q?NR7KSs9kJ1WJljeSpANCiIHxEWdIJ2lV0UCWr+MCEm559xwZ86Ir2ClwUtUh?=
 =?us-ascii?Q?zLDE4PCH937gSdob714QZd+jgns+Rct5H0v/lo2I5w4lY0ubrxCbOgEkvtJ7?=
 =?us-ascii?Q?TKWIqK4BsxRW1u0b6M728eLTCzAU1LDzHehYx1SQxnDJ83TJOp/SHLO6mfcC?=
 =?us-ascii?Q?gTVH4thSfo0XgL5e3ukAFCJuN1jfeoY2nLMA4/RN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7dd69e8-9a18-40a1-43ee-08db04df1f74
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 05:34:15.4676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vharv5uBoOj0RV78900xk8Yj4wb+laX4fGDTR6QpNjoKMr4UgVvEp2V+44HgH/+cB5W/ilI7/YHhapDygSP9HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7414
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, January 30, 2023 8:15 PM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, January 20, 2023 7:52 AM
> >
> > On Tue, 17 Jan 2023 05:49:39 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > > VFIO group has historically allowed multi-open of the device FD. This
> > > was made secure because the "open" was executed via an ioctl to the
> > > group FD which is itself only single open.
> > >
> > > No know use of multiple device FDs is known. It is kind of a strange
> >   ^^ ^^^^                               ^^^^^
>=20
> How about "No known use of multiple device FDs today"
>=20
> > > thing to do because new device FDs can naturally be created via dup()=
.
> > >
> > > When we implement the new device uAPI there is no natural way to
> allow
> > > the device itself from being multi-opened in a secure manner. Without
> > > the group FD we cannot prove the security context of the opener.
> > >
> > > Thus, when moving to the new uAPI we block the ability to multi-open
> > > the device. This also makes the cdev path exclusive with group path.
> > >
> > > The main logic is in the vfio_device_open(). It needs to sustain both
> > > the legacy behavior i.e. multi-open in the group path and the new
> > > behavior i.e. single-open in the cdev path. This mixture leads to the
> > > introduction of a new single_open flag stored both in struct vfio_dev=
ice
> > > and vfio_device_file. vfio_device_file::single_open is set per the
> > > vfio_device_file allocation. Its value is propagated to struct vfio_d=
evice
> > > after device is opened successfully.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/group.c     |  2 +-
> > >  drivers/vfio/vfio.h      |  6 +++++-
> > >  drivers/vfio/vfio_main.c | 25 ++++++++++++++++++++++---
> > >  include/linux/vfio.h     |  1 +
> > >  4 files changed, 29 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > index 9484bb1c54a9..57ebe5e1a7e6 100644
> > > --- a/drivers/vfio/group.c
> > > +++ b/drivers/vfio/group.c
> > > @@ -216,7 +216,7 @@ static struct file *vfio_device_open_file(struct
> > vfio_device *device)
> > >  	struct file *filep;
> > >  	int ret;
> > >
> > > -	df =3D vfio_allocate_device_file(device);
> > > +	df =3D vfio_allocate_device_file(device, false);
> > >  	if (IS_ERR(df)) {
> > >  		ret =3D PTR_ERR(df);
> > >  		goto err_out;
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index fe0fcfa78710..bdcf9762521d 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -17,7 +17,11 @@ struct vfio_device;
> > >  struct vfio_container;
> > >
> > >  struct vfio_device_file {
> > > +	/* static fields, init per allocation */
> > >  	struct vfio_device *device;
> > > +	bool single_open;
> > > +
> > > +	/* fields set after allocation */
> > >  	struct kvm *kvm;
> > >  	struct iommufd_ctx *iommufd;
> > >  	bool access_granted;
> > > @@ -30,7 +34,7 @@ int vfio_device_open(struct vfio_device_file *df,
> > >  void vfio_device_close(struct vfio_device_file *device);
> > >
> > >  struct vfio_device_file *
> > > -vfio_allocate_device_file(struct vfio_device *device);
> > > +vfio_allocate_device_file(struct vfio_device *device, bool
> single_open);
> > >
> > >  extern const struct file_operations vfio_device_fops;
> > >
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index 90174a9015c4..78725c28b933 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -345,7 +345,7 @@ static bool vfio_assert_device_open(struct
> > vfio_device *device)
> > >  }
> > >
> > >  struct vfio_device_file *
> > > -vfio_allocate_device_file(struct vfio_device *device)
> > > +vfio_allocate_device_file(struct vfio_device *device, bool single_op=
en)
> > >  {
> > >  	struct vfio_device_file *df;
> > >
> > > @@ -354,6 +354,7 @@ vfio_allocate_device_file(struct vfio_device
> > *device)
> > >  		return ERR_PTR(-ENOMEM);
> > >
> > >  	df->device =3D device;
> > > +	df->single_open =3D single_open;
> >
> > It doesn't make sense to me to convolute the definition of this
> > function with an unmemorable bool arg when the one caller that sets the
> > value true could simply open code it.
>=20
> Yeah, how about renaming it just like Kevin's suggestion?
>=20
> https://lore.kernel.org/kvm/BN9PR11MB52769CBCA68CD25DAC96B33B8CC
> 49@BN9PR11MB5276.namprd11.prod.outlook.com/
>=20
> >
> > >
> > >  	return df;
> > >  }
> > > @@ -421,6 +422,16 @@ int vfio_device_open(struct vfio_device_file
> *df,
> > >
> > >  	lockdep_assert_held(&device->dev_set->lock);
> > >
> > > +	/*
> > > +	 * Device cdev path cannot support multiple device open since
> > > +	 * it doesn't have a secure way for it. So a second device
> > > +	 * open attempt should be failed if the caller is from a cdev
> > > +	 * path or the device has already been opened by a cdev path.
> > > +	 */
> > > +	if (device->open_count !=3D 0 &&
> > > +	    (df->single_open || device->single_open))
> > > +		return -EINVAL;
> >
> > IIUC, the reason this exists is that we let the user open the device
> > cdev arbitrarily, but only one instance can call
> > ioctl(VFIO_DEVICE_BIND_IOMMUFD).  Why do we bother to let the user
> > create those other file instances?  What expectations are we setting
> > for the user by allowing them to open the device but not use it?
>=20
> It won't be able to access device as such device fd is not bound to
> an iommufd.
>=20
> > Clearly we're thinking about a case here where the device has been
> > opened via the group path and the user is now attempting to bind the
> > same device via the cdev path.
>=20
> This shall fail as the group path would inc the device->open_count. Then
> the cdev path will be failed as the path would have df->single_open=3D=3D=
true.
>=20
> > That seems wrong to even allow and I'm
> > surprised it gets this far.  In fact, where do we block a user from
> > opening one device in a group via cdev and another via the group?
>=20
> such scenario would be failed by the DMA owner.
>=20
> The two paths would be excluded when claiming DMA ownership in
> such scenario. The group path uses the vfio_group pointer as DMA
> owner marker. While the cdev path uses the iommufd_ctx pointer.
> But one group only allows one DMA owner.

However, there is one possibility that the group path and cdev path
have the same DMA marker. If the group path is the vfio iommufd
compat mode, iommufd is used as container fd, and its DMA marker
is also iommufd_ctx pointer, so it is possible that two devices in the
the same group may be opened by different paths (the vfio compat
mode group path and the cdev path).

This seems to be ok. The group path will attach the group to an auto-alloca=
ted
iommu_domain, while the cdev path actually waits for userspace to
attach it to an IOAS. Userspace should take care of it. It should ensure
the devices in the same group should be attached to the same domain.

This seems to be no much difference with userspace opening two
devices (from the same group) via cdev, userspace needs to attach them to
the same domain as well.

Also, there is a work from Nicolin to support domain replacement. So even
the group path has attached the group to an iommu_domain, userspace can
later replace it with the domain it desired (maybe still an auto-allocated
domain during the IOAS attachment or a userspace allocated domain this is
in my nesting series https://github.com/yiliu1765/iommufd/commits/wip/iommu=
fd-v6.2-rc5-nesting).

So for a VFIO device, we use the single_open flag to exclude opening from
the group path and cdev path. While for different devices in the same group=
,
normally userspace may not open devices in different paths.  Even it does,
seems to be fine as above statement.

Regards,
Yi Liu

