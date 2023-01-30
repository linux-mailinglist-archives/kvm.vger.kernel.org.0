Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F28680D55
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbjA3MPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbjA3MO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:14:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517AB1739
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 04:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675080896; x=1706616896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zbsoer2m2lkIGgFc78ybdVpK30J9CIvTYya+CH7HV5Y=;
  b=ea0tmIxSc2m8i+9C33McqUYV7mb3d9qxl4ZgNXL4HfhDI+rEmQE/fqTR
   jwBkfv0rv8WSXmsszxBITlASCDCRrU3nngKncdfXlPLwtxPI3dGUf9iQR
   MXZ+a/VIOHHr8DryJCWL13jUbmoWYMnn3IFimZmsp6A8bRKWlqO7TKQw6
   hqTmhCVmnIuYKCoEAvw8uMzx6Tbh3aR0EpsUjDuzcJ0lorisiByr/6UHu
   PMO4emDGcFL6CSN+7c18e4X6kzj5DZe8xupctSt1hlCFc5ZUrfsobSHhg
   Y9aawC/HLOGrVCu7uVUfwnqhhlwNSWIaUMedwmGZjVCOp8csnbJeiZ2JZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="328817662"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="328817662"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:14:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="992880379"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="992880379"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 30 Jan 2023 04:14:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:14:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:14:40 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:14:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlTsIA08geOlYs4ohE8OA2yJSjzM89ZvF7ZKlPfUdsnjl9m0jwut5o5/Xykh8BHNcVXvy4R70enHWUkpF9KTdVfd9hZpijONIH5BA/Zdn+mArUfxzq8hV0N57EW6QerJXedaH5+im7gTnqTVFMS0AH7tr5hPIB3LB9CkcNUcTjdkq4q0CmhhhG1yGes/ScU8sLWr6/DkK0B0bMk9hSDrJHJK04b5si3aPDIN/ppQ66Sn5HcBL1JY9N56fCsPp0RucGm+TO4esM6vUHMv7QwKCINgp0u9nyYniqWaSsPLjZYH1yL9KaxaBlIwIfQmtkCuqQwiEhw0mJVlhSAhYVZfrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CT+yy1hCKWZiEVQIHUujc7c549EsxHi+f3GrFH05P1k=;
 b=U8Co54EgRmylkwzXYQNPZMpj1OnxnH6FN//A2OjSbFpDC6SioXiuiMFkjd7BfO4r0WeagoAHGkyZ5dkQX9n4qUQQ2v7ik/sLP2zx9SVZ6ZvbqcNRa77f0a3iaBvPTCJZA/gcMMxnTgAGlBdtwjFjumFB4rT5cDfrM2hoQyQ3r+mYv5x81Rvme/a5v+6B6bo6f1qkh9NbhBNjR0yu3iI8HN+46u0se7Gx13sbsXEunzMYVgtDiLFZxN4MTFL1Rgi7ix5BPdJnGWhEoZ/Jm/bbIQHQCv/410hXC+7dUQo2CY+KHFFq6nfov/kMEmQqukxJMwfe73zalz3wze1ai7xxzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB5912.namprd11.prod.outlook.com (2603:10b6:303:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 12:14:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:14:36 +0000
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
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhA=
Date:   Mon, 30 Jan 2023 12:14:36 +0000
Message-ID: <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
In-Reply-To: <20230119165157.5de95216.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB5912:EE_
x-ms-office365-filtering-correlation-id: f9d35a6f-92dc-450c-2ebd-08db02bb8dc8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xlbKLGNKgLsMpYU0t8gctWZlzB9eOGoG/VBnHm8t2Og7+lWS0D4QIHP9kepp/eWLnbkiNflBhgXy+HZh3zk+97O21Qya6P45bptXNmip3OI9L4i6hr59nZGNRVQiu6iR4yrdYkGypHcHptz2g2I5fDArZoViZ/IoaufweLN9giSsIeNaWZPRToh20laFLpuzaAyTetewXPb+BNMtX/JQeNIndTEY4BWIAh0N5j8tlfo1Njp4k9Sg2tz6AOUV57TJykVHDDqj20rDHucKRohrRp71TB0DfcklrA0h9itnOB61NZ7sIdO/tjJ25Kr3hQvn4A8LiqMm+YKuqxUdxszF+3HxDVTNsOjvE43y5w4UvA0RO9lohaDX2JXejhskB5iCIZLiBRhi4ZksUpNWlVo4KIWPllziZXT6/9uPUtEU0yvL80VV0+aNjVA+jEBWHEM9BCY33r03OPikL15zVDCTNBqErhJ4SZlFQR6BijGKzWEr2v/HAj858iok8cUelV+4+7Ga8XlJQL48optP+d2OYSukyREaKUcy2ZRLWsN76RTzIeKQbRFUr/sJGCO+dHz11ZF3tRrloR5FGh1jR+pnyy5X5ErgMoDi9sw+/XvYKl3lqFPFGSEbuptwlr8MUMFVmbq9J+fHif3wn3sHIkBin1/VyXTLUy3yheifNBO2/qBS5KJPwQ/Y6w98Zc2u6gZnT1bR9pl59ZwJ9vouT4oaqT0Lzflu/r+lTiSldSQETf/AswSAnq2hYJTBqRx77zVU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199018)(45080400002)(52536014)(2906002)(82960400001)(316002)(122000001)(186003)(5660300002)(38070700005)(26005)(9686003)(6506007)(54906003)(7416002)(966005)(38100700002)(55016003)(33656002)(71200400001)(7696005)(83380400001)(86362001)(478600001)(4326008)(6916009)(66476007)(66556008)(66446008)(64756008)(8676002)(76116006)(66946007)(8936002)(41300700001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+wdBGUyc4g95jFtDWcdmu437cBpXak0yeESSjLgP4ecJE0Hu7ObMicm+PSQ6?=
 =?us-ascii?Q?wigh77CWFOB2dqPdPT+py6dPSgJOBOrz6XYSx++K/HXhrjmF1yK+EHjwOiHP?=
 =?us-ascii?Q?/jX5XAMzKTwfoAMoNK2I89byGbvCLSYjlQ9A36epA51vAQZHodkRivGHET6T?=
 =?us-ascii?Q?VJORV6alWk0gYa+EkOc4oR8oERRjEwhsdjitEwZFHFZxsFcQzjtMitHfsocD?=
 =?us-ascii?Q?qa/S5THWLbAU3ZeU3I2rDAorm7ojaR4A7Jkb7TcbzuqaAHFAmVu0gu6dUNc4?=
 =?us-ascii?Q?gGqRlVJcy/ZSi3v9kZPnyt6ABWvgRqYIe8fKMpX8eTCyKz5U7Nqd7CFz7JAS?=
 =?us-ascii?Q?gY2WEcKcHWesxx6gm6j7/mF1AsptTBRHSCCNGKKcxynFH9KGq8OXT48cip6d?=
 =?us-ascii?Q?h7F7GeaeEu0Puv0h1bLZ6DE2/UNhKqf+UBMoHAdZcwh5PDPm6QP/XSpv5Lzm?=
 =?us-ascii?Q?slSWEXlKzqq9NcNOfxteKh/y45B7q8YUxONGS4ohtYxY+17CWLQVt+SHt9K3?=
 =?us-ascii?Q?Bh0AtZfyKk1xRiaAZANwyIpf9Kx39PExTF/2pF8L5QmD6Vsjhox+1GHNoq9R?=
 =?us-ascii?Q?8wgpqLTkBat51ESAnAtuOdrKqEDSl98iTdhTtIGvH/Ilsrg7M/nVNXooLbPH?=
 =?us-ascii?Q?RTH/83htoblr+BBXHAvPpwkhJJ74db2QHewh20rdAxLpwdj1Kj6ULRpjW4m0?=
 =?us-ascii?Q?USeVAv1QxziExsp7qpYURdZlUioFHWGybTS1AnNMp6XJsCBY/wohCO7J3IsT?=
 =?us-ascii?Q?MBsoSICGrZ0NWaiMHGqXWDyUeHttCT1sc3VNwjo+omFqWxQj4qvSI3tHJ2br?=
 =?us-ascii?Q?yhpKiCnZ2DxkXXCaVD96XM8d98cwsaXIYpydmfdCqvW+uD6zRF4Fbieh0O0s?=
 =?us-ascii?Q?S2PJyHV0eBD8y6R2WRHbMkBbo2LuNTzat25mtPBM8UF9v9BlmAA1c2IQk0R0?=
 =?us-ascii?Q?4r26a58iJaYbgHv1GDqLieNy5ruFHpTXLXN4TtCMBNJh61XXwfCfjTxYzQ3t?=
 =?us-ascii?Q?ptzVUG9xuEAq8+WmLPjfl/XzYyEtBt0YecszHdTwzx9EWVpDGlxg7ac+EKbw?=
 =?us-ascii?Q?Qy40AyfLDNAsFVAzxKC8kvLblO26QjjRZ8tgOSpVKpA7Emp/cbwuSOIYYMkf?=
 =?us-ascii?Q?s95GO4JWiMgm05M2U0XivsdEwiJDj2cjRZrYKSNlFmvGzjDL20aZgMhnp+4u?=
 =?us-ascii?Q?DYMvQV+i1dTSbhaNKwF5L7Qrdn1Qcht/VEdPzw2LezU3d2fKGZWaVwgmeuAj?=
 =?us-ascii?Q?+2O7blMm9/Rrwz+1l57SKeWUmKWc3q4rlaw1fzYndBRonKlMaOKAqlQxqGMb?=
 =?us-ascii?Q?cvMfk2TFi4rpl86JSwEx9uoVB5SsXWOXJdR1lhragUyhchFlD81xSd/1WKqh?=
 =?us-ascii?Q?dmw9op1WjLzvtTMlEZlIHrjm1klEAzp9R3ozFs7CzUiJ5uz5Q2YcFyo6X9V+?=
 =?us-ascii?Q?z/+cUyfo7qPDFuPsyxXAwK+JYckYMf8HjjGKKow5ICT6xUoAGM4otEDw5ISP?=
 =?us-ascii?Q?hmvqUN3mOGy0ooAWf+LKeea4clNHSFMhPkn+/N0KzYKEJh6bwcpHbK+WTfEw?=
 =?us-ascii?Q?NAOJK96N2YsBqAgTvULk6kbQymD+Mat6X6cf9THT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d35a6f-92dc-450c-2ebd-08db02bb8dc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 12:14:36.3279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+fLreCFDJgcywtIM1WKCQf8ApMRGLFIGBOvOy3gC+JHY3YJHSaBkY1rmhwSDQWx61VbySG0vlMe81p/z0ODMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5912
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, January 20, 2023 7:52 AM
>=20
> On Tue, 17 Jan 2023 05:49:39 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > VFIO group has historically allowed multi-open of the device FD. This
> > was made secure because the "open" was executed via an ioctl to the
> > group FD which is itself only single open.
> >
> > No know use of multiple device FDs is known. It is kind of a strange
>   ^^ ^^^^                               ^^^^^

How about "No known use of multiple device FDs today"

> > thing to do because new device FDs can naturally be created via dup().
> >
> > When we implement the new device uAPI there is no natural way to allow
> > the device itself from being multi-opened in a secure manner. Without
> > the group FD we cannot prove the security context of the opener.
> >
> > Thus, when moving to the new uAPI we block the ability to multi-open
> > the device. This also makes the cdev path exclusive with group path.
> >
> > The main logic is in the vfio_device_open(). It needs to sustain both
> > the legacy behavior i.e. multi-open in the group path and the new
> > behavior i.e. single-open in the cdev path. This mixture leads to the
> > introduction of a new single_open flag stored both in struct vfio_devic=
e
> > and vfio_device_file. vfio_device_file::single_open is set per the
> > vfio_device_file allocation. Its value is propagated to struct vfio_dev=
ice
> > after device is opened successfully.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c     |  2 +-
> >  drivers/vfio/vfio.h      |  6 +++++-
> >  drivers/vfio/vfio_main.c | 25 ++++++++++++++++++++++---
> >  include/linux/vfio.h     |  1 +
> >  4 files changed, 29 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 9484bb1c54a9..57ebe5e1a7e6 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -216,7 +216,7 @@ static struct file *vfio_device_open_file(struct
> vfio_device *device)
> >  	struct file *filep;
> >  	int ret;
> >
> > -	df =3D vfio_allocate_device_file(device);
> > +	df =3D vfio_allocate_device_file(device, false);
> >  	if (IS_ERR(df)) {
> >  		ret =3D PTR_ERR(df);
> >  		goto err_out;
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index fe0fcfa78710..bdcf9762521d 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -17,7 +17,11 @@ struct vfio_device;
> >  struct vfio_container;
> >
> >  struct vfio_device_file {
> > +	/* static fields, init per allocation */
> >  	struct vfio_device *device;
> > +	bool single_open;
> > +
> > +	/* fields set after allocation */
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd;
> >  	bool access_granted;
> > @@ -30,7 +34,7 @@ int vfio_device_open(struct vfio_device_file *df,
> >  void vfio_device_close(struct vfio_device_file *device);
> >
> >  struct vfio_device_file *
> > -vfio_allocate_device_file(struct vfio_device *device);
> > +vfio_allocate_device_file(struct vfio_device *device, bool single_open=
);
> >
> >  extern const struct file_operations vfio_device_fops;
> >
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index 90174a9015c4..78725c28b933 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -345,7 +345,7 @@ static bool vfio_assert_device_open(struct
> vfio_device *device)
> >  }
> >
> >  struct vfio_device_file *
> > -vfio_allocate_device_file(struct vfio_device *device)
> > +vfio_allocate_device_file(struct vfio_device *device, bool single_open=
)
> >  {
> >  	struct vfio_device_file *df;
> >
> > @@ -354,6 +354,7 @@ vfio_allocate_device_file(struct vfio_device
> *device)
> >  		return ERR_PTR(-ENOMEM);
> >
> >  	df->device =3D device;
> > +	df->single_open =3D single_open;
>=20
> It doesn't make sense to me to convolute the definition of this
> function with an unmemorable bool arg when the one caller that sets the
> value true could simply open code it.

Yeah, how about renaming it just like Kevin's suggestion?

https://lore.kernel.org/kvm/BN9PR11MB52769CBCA68CD25DAC96B33B8CC49@BN9PR11M=
B5276.namprd11.prod.outlook.com/
=20
>=20
> >
> >  	return df;
> >  }
> > @@ -421,6 +422,16 @@ int vfio_device_open(struct vfio_device_file *df,
> >
> >  	lockdep_assert_held(&device->dev_set->lock);
> >
> > +	/*
> > +	 * Device cdev path cannot support multiple device open since
> > +	 * it doesn't have a secure way for it. So a second device
> > +	 * open attempt should be failed if the caller is from a cdev
> > +	 * path or the device has already been opened by a cdev path.
> > +	 */
> > +	if (device->open_count !=3D 0 &&
> > +	    (df->single_open || device->single_open))
> > +		return -EINVAL;
>=20
> IIUC, the reason this exists is that we let the user open the device
> cdev arbitrarily, but only one instance can call
> ioctl(VFIO_DEVICE_BIND_IOMMUFD).  Why do we bother to let the user
> create those other file instances?  What expectations are we setting
> for the user by allowing them to open the device but not use it?

It won't be able to access device as such device fd is not bound to
an iommufd.

> Clearly we're thinking about a case here where the device has been
> opened via the group path and the user is now attempting to bind the
> same device via the cdev path.

This shall fail as the group path would inc the device->open_count. Then
the cdev path will be failed as the path would have df->single_open=3D=3Dtr=
ue.

> That seems wrong to even allow and I'm
> surprised it gets this far.  In fact, where do we block a user from
> opening one device in a group via cdev and another via the group?

such scenario would be failed by the DMA owner.

The two paths would be excluded when claiming DMA ownership in
such scenario. The group path uses the vfio_group pointer as DMA
owner marker. While the cdev path uses the iommufd_ctx pointer.
But one group only allows one DMA owner.=20

>=20
> > +
> >  	device->open_count++;
> >  	if (device->open_count =3D=3D 1) {
> >  		int ret;
> > @@ -430,6 +441,7 @@ int vfio_device_open(struct vfio_device_file *df,
> >  			device->open_count--;
> >  			return ret;
> >  		}
> > +		device->single_open =3D df->single_open;
> >  	}
> >
> >  	/*
> > @@ -446,8 +458,10 @@ void vfio_device_close(struct vfio_device_file *df=
)
> >
> >  	mutex_lock(&device->dev_set->lock);
> >  	vfio_assert_device_open(device);
> > -	if (device->open_count =3D=3D 1)
> > +	if (device->open_count =3D=3D 1) {
> >  		vfio_device_last_close(df);
> > +		device->single_open =3D false;
> > +	}
> >  	device->open_count--;
> >  	mutex_unlock(&device->dev_set->lock);
> >  }
> > @@ -493,7 +507,12 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> >
> > -	vfio_device_group_close(df);
> > +	/*
> > +	 * group path supports multiple device open, while cdev doesn't.
> > +	 * So use vfio_device_group_close() for !singel_open case.
> > +	 */
> > +	if (!df->single_open)
> > +		vfio_device_group_close(df);
>=20
> If we're going to use this to differentiate group vs cdev use cases,
> then let's name it something to reflect that rather than pretending it
> only limits the number of opens, ex. is_cdev_device.  Thanks,

Yes. I'd follow it. Kevin has a similar comment on it.

Regards,
Yi Liu
