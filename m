Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E2572E268
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbjFMMCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 08:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbjFMMCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 08:02:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AE8C5;
        Tue, 13 Jun 2023 05:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686657761; x=1718193761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4v6ksNHk83WJe4d+umbjjAW37k9KpQvnIdpPrenwoss=;
  b=DY+V+sFn9pZ8Q6XoY70HLztklC8127KajmHJJ42OFehvoknapdVODket
   L22z03I7mnsJ1/zzXUbz+aWGAuGJ+iWO9KIsG4O4y/1Ms1NloaAQ4NnKP
   SFC/3i2y1YxlS0nZG+MiVAxCRUf7/qy8IldcPlwITW6JxslmAjzl5oq7Y
   iwIKmrd57Bs7OhInAIqCVdF8V1e/vSVU/3qu5Pmwg9XKsyYkvEOjsYw48
   Y6axnsSGw4HjWXn2ykl/1LqbwReP+dSEhIurpWIXo9q/g7Sy2S4x2qaUt
   DWmGzGRhoXomYcpS7scmfvhxknSHs7dH5GbMT78qsNRzKBXHPQQkwVKRm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="386704995"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="386704995"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:01:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="711616764"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="711616764"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 13 Jun 2023 05:01:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 05:01:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 05:01:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 05:01:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMrfNXmbHkp5Av4ELq5cmma2n9MQRfoE5lru61NqgNQFA6GvkpBAUH/cTyj0GboDPwzB0xvnpm/S9yQVuSYn9ZAH40Rg6u19V822mxnHat4Sf+TFBnUvWB2ex5RZCc44f5KW4b6zeqRwBm1EREsXr3SNi+pUZqZjvjxJdUxJ7YLNK5xTcydCu6p5TPmk5LmAP3Uq3vdVrjMmszgoc2nHK99/HW83pQ11uICXQL47p5KC+k5pOnxpw0dE907Um9lrtMfL/3NC4EeH5V7rRn8q8OKp3Em5OjQvzFGMOjM5liC4piJzr8Opy4+eqzjGMlBfKDRXaLP8tvYdQ3AQnIYulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7dGs0g8h2zihrGL2I+Zow3QVQtnmzq8yc023sVJPfo=;
 b=bk5nAY6WiZIssvYuaPqlG8aSYlVom2VmrpFXFp2nR2Y7KqZsnqLj7gN/kp5kpbPL5KXH171TTWGfJhnUXsnM1/4fmkQmfW1PTAtovggk/ot9YY7SqAr0HbyJE7DqRsgjAA1Nd8Ri9WUyPMlJ4jx9c1MtrcUlm1Cf0XQxveHXFp48Pnvqxx9/A9S0osYG5CnFFpeADH0VaEbWxTV0DobNUZs+N4Pit75K1TaDYrErmv3+IXZOFSGB3JC7++gpuU1u02YzYVrXGfWmkrKoIxOfs/s2JOTl+89hVu2a5B5XnBSURlldSBZWF7Uh/7/yrPAGHPi/W63RPtqfXBrT/Mw1Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7593.namprd11.prod.outlook.com (2603:10b6:510:27f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 12:01:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 12:01:51 +0000
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
Subject: RE: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZlUw9Uf04nacAO0q7EN/OKT++06+H2nAAgADVnWA=
Date:   Tue, 13 Jun 2023 12:01:51 +0000
Message-ID: <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-25-yi.l.liu@intel.com>
 <20230612170628.661ab2a6.alex.williamson@redhat.com>
In-Reply-To: <20230612170628.661ab2a6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7593:EE_
x-ms-office365-filtering-correlation-id: b2631125-9917-4803-e989-08db6c05f971
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hsU8yyRaWBUJxGd2kUtn5Z1pUXKR+rLkl2C1Fh2vY+RPJYq+iqZUxgfw1sMYVRFLVmDh9cwfaL+4sKDRMAIS8IFsgeb8N/uJgPOzDwGEkMJsVPBfEURNgKsamKPgl5lYGAtTAEWI2GoIHcO10y1bIT0o1zvWNB3pxu7280DGlgbTZh2IS0c5BqYpY448QYmiDH0nvb8kPl1W6InMbS1CMcH1gmBtTHi7Fnr4wG8t+323pYdwlE85YVNL/hccucPYf34cFzp600I99Rt5U3b1pqMKkz9iY4ncqHgwAUuwmo8PJA2FFS2H/aep4+NHEefPnMBXyUibeyJHJEX0Znx76K9CXFjF04AcuoAeZ5yvHr/z3EE0qnGMetBKy41w7PfhalmRZGRPpqeXYql3PXVTHub8OkK9TJxHJBhXjFGWIx07m+gzA7U4+NV7vVyJyNNf22RihrpgkGHnZEVg0CSGKksDSam0t1af/IIFmGE8DZegKFKzf14dnFvNWPFbPRH83dqxajlM34GRWoFALCQVq7+sYGUuM6QYvmbjRIn9T+cIk4l6Kn2ve8D3BDn48ido+0gSKgZQ1AeQCql85+c97Yonq4p7LP3i1A9Yy+N51vbScNeQrSblWpaewO5n+V9R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199021)(71200400001)(478600001)(7696005)(122000001)(33656002)(26005)(6506007)(186003)(83380400001)(82960400001)(38070700005)(38100700002)(86362001)(9686003)(55016003)(4326008)(76116006)(66476007)(64756008)(66946007)(6916009)(66556008)(316002)(66446008)(8936002)(8676002)(7416002)(5660300002)(52536014)(41300700001)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tnWl9YoZ40BhrbyK637uu2qIvevC8NbbxJ195PtXhPKrT47Yay49tiyOug8m?=
 =?us-ascii?Q?k8itTMIWsaa+JaCRROQUXoDYwnF8oOvffoc2bCX7PqIPvziS6+PJjm7XT1rW?=
 =?us-ascii?Q?6iaOuy1OgkhLvY65m83cLzNF7UyKLJKolGP9MhdhMhvR4j2/H02hQYmNLTJY?=
 =?us-ascii?Q?q4U1AYUoMzankCPdJ+ew0ecPUv3Rh6swYz0oDPNw/Rkd+4rZw3DM8dwDoso5?=
 =?us-ascii?Q?AXIHt63fLN5QP55IpROOqQrIF2XquAiLjQy3N7ld3mz2Mccm7+/GXo+ze+xP?=
 =?us-ascii?Q?zy6AnM9a61XkibdrwuKMscKO7DOoEYcS6dxXJ1CmQkzK9XRtu78J19xE4eey?=
 =?us-ascii?Q?sl/xIU2BG2KFZ8fzlGv7UvMXov0WvPH2VIwB5w9yb1R57cETBVGkYLqTKGT4?=
 =?us-ascii?Q?+z19sT4C7/WiUXQbP3rdNc7u+hEXRpibgbtD96fm/HJ9wKnxSZiy2AD29wJO?=
 =?us-ascii?Q?D38W1/ATLse/pTzRIi339cl1tXd+nCinSpcod0hSMaV30q9VecgsK9QfHJj0?=
 =?us-ascii?Q?jhcFuqujTqp5iRhSDzgDFV+csWj/ty5sjLgTYNGWiFRBwXAYbyWbwNC0FA6u?=
 =?us-ascii?Q?nQ/UftBm0kj9ZUwz5HMvZwCFyss+PZStFXO0eHFRMQ2l5m+RVDgoUHCCtsJk?=
 =?us-ascii?Q?lICvdRhtDpVD8VTjvEwnsusw5LlC6s3/g/cE3mCJ0hmH6pf5jkEVdR0wZgUp?=
 =?us-ascii?Q?5zRcE8csMNcREVxOi3vWjnqIzBCVCCirkH1YA5vUUJ/16jQ1hVB5luxe/5BG?=
 =?us-ascii?Q?7VYiRsJ3/Hv5SV8aATgQMuDsIIdLKDKcg6ItCPv9Waef8UklwDO7tCKMLFk8?=
 =?us-ascii?Q?SeBY4wX6q7RMdFY+UwyJxCpqpvZx4ratwcraaLtGVAEOsc28Qx2JZzoDH7fU?=
 =?us-ascii?Q?Kbgag9MaUGWLAbxhtU0lYbTtKfXIeNT9XWGVotW1UCIp7Wl79G1wX6glIUUx?=
 =?us-ascii?Q?/vDcG9v14vV1G8W1WKaMQ6ouCuxnQIu6NQxkVSXG7lbA2pSxDU3uJbiJAuoV?=
 =?us-ascii?Q?PQVYDUjm9FYnOiE/2KViOoNM9lOY+qWU/HJVoEJiee8F9Ds5k0iFdRmEc5t+?=
 =?us-ascii?Q?i+e7OcOSpqooZjZLMLlis+A7o/axdV7tVZ6IciqMxP++t948hJyiM191ClDB?=
 =?us-ascii?Q?79Mp5VclQvQ2m+maJC/pyYt7gYocgxLObJDTRb1PWEDP8SjI6YKgFnIOEHHo?=
 =?us-ascii?Q?pk5BoJirthyfaSQMynwGgeC85WwCAdwyX91Fstcn4b4I43kVzhL51e+u38jX?=
 =?us-ascii?Q?xUnqIECSnSUXNyGlkMIDgSEvBIHENOAPi6ssHg5oUmEcWEiG2YERGUtHscTN?=
 =?us-ascii?Q?p5DURcMYtD5Z6z2TQTx4ELFELzip9xFZ1OLx+a4vHlKe9ETApwfBtk1TvTVQ?=
 =?us-ascii?Q?B97ipFNPMDIMzzZiLJ/HDARFTcQqw92R+xK28fcdhC0HNMiIpk6fa8VbH2rE?=
 =?us-ascii?Q?/XClFNAsv/NejqSkq5MWfAEtRyLn1YScFHSvbYrEV3d7zWju2GAec1v1oLEa?=
 =?us-ascii?Q?3gDBMLv1d4Bmt4f7ZYT4cHa93dz+grQjmbkxzpjkD9aPVs/cvCnjBjBoBSWW?=
 =?us-ascii?Q?Wvf1uwZte/hh1QLrzM4Wv7I73ZirShJm/q3scaR4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2631125-9917-4803-e989-08db6c05f971
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 12:01:51.8084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/XjjBtvRwpBXQLvcJI3HFhJpGFZTUd9G0JFW4un9S6d9tLS03cyY15uA0Xrfacmvdemfc7igR8zAiAcJjdZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7593
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
> Sent: Tuesday, June 13, 2023 7:06 AM
>=20
> On Fri,  2 Jun 2023 05:16:53 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This gives notes for userspace applications on device cdev usage.
> >
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  Documentation/driver-api/vfio.rst | 132 ++++++++++++++++++++++++++++++
> >  1 file changed, 132 insertions(+)
> >
> > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-a=
pi/vfio.rst
> > index 363e12c90b87..f00c9b86bda0 100644
> > --- a/Documentation/driver-api/vfio.rst
> > +++ b/Documentation/driver-api/vfio.rst
> > @@ -239,6 +239,130 @@ group and can access them as follows::
> >  	/* Gratuitous device reset and go... */
> >  	ioctl(device, VFIO_DEVICE_RESET);
> >
> > +IOMMUFD and vfio_iommu_type1
> > +----------------------------
> > +
> > +IOMMUFD is the new user API to manage I/O page tables from userspace.
> > +It intends to be the portal of delivering advanced userspace DMA
> > +features (nested translation [5]_, PASID [6]_, etc.) while also provid=
ing
> > +a backwards compatibility interface for existing VFIO_TYPE1v2_IOMMU us=
e
> > +cases.  Eventually the vfio_iommu_type1 driver, as well as the legacy
> > +vfio container and group model is intended to be deprecated.
> > +
> > +The IOMMUFD backwards compatibility interface can be enabled two ways.
> > +In the first method, the kernel can be configured with
> > +CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
> > +transparently provides the entire infrastructure for the VFIO
> > +container and IOMMU backend interfaces.  The compatibility mode can
> > +also be accessed if the VFIO container interface, ie. /dev/vfio/vfio i=
s
> > +simply symlink'd to /dev/iommu.  Note that at the time of writing, the
> > +compatibility mode is not entirely feature complete relative to
> > +VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
> > +provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Therefor=
e
> > +it is not generally advisable at this time to switch from native VFIO
> > +implementations to the IOMMUFD compatibility interfaces.
> > +
> > +Long term, VFIO users should migrate to device access through the cdev
> > +interface described below, and native access through the IOMMUFD
> > +provided interfaces.
> > +
> > +VFIO Device cdev
> > +----------------
> > +
> > +Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
> > +in a VFIO group.
> > +
> > +With CONFIG_VFIO_DEVICE_CDEV=3Dy the user can now acquire a device fd
> > +by directly opening a character device /dev/vfio/devices/vfioX where
> > +"X" is the number allocated uniquely by VFIO for registered devices.
> > +cdev interface does not support noiommu, so user should use the legacy
> > +group interface if noiommu is needed.
> > +
> > +The cdev only works with IOMMUFD.  Both VFIO drivers and applications
> > +must adapt to the new cdev security model which requires using
> > +VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
> > +actually use the device.  Once BIND succeeds then a VFIO device can
> > +be fully accessed by the user.
> > +
> > +VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
> > +Hence those modules can be fully compiled out in an environment
> > +where no legacy VFIO application exists.
> > +
> > +So far SPAPR does not support IOMMUFD yet.  So it cannot support devic=
e
> > +cdev neither.
>=20
> s/neither/either/

Got it.

>=20
> Unless I missed it, we've not described that vfio device cdev access is
> still bound by IOMMU group semantics, ie. there can be one DMA owner
> for the group.  That's a pretty common failure point for multi-function
> consumer device use cases, so the why, where, and how it fails should
> be well covered.

Yes. this needs to be documented. How about below words:

vfio device cdev access is still bound by IOMMU group semantics, ie. there
can be only one DMA owner for the group.  Devices belonging to the same
group can not be bound to multiple iommufd_ctx.  The users that try to bind
such device to different iommufd shall be failed in VFIO_DEVICE_BIND_IOMMUF=
D
which is the start point to get full access for the device.

>=20
> In general there's been a lot of cross collaboration to get the series
> this far.  I see an abundance of Tested-by, but unfortunately not a lot
> of Reviewed-by beyond about the first 1/3rd of the series.  Thanks,

Yeah. The rest 2/3rd part has back and forth changes since v8.

Regards,
Yi Liu

> Alex
>=20
> > +
> > +Device cdev Example
> > +-------------------
> > +
> > +Assume user wants to access PCI device 0000:6a:01.0::
> > +
> > +	$ ls /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/
> > +	vfio0
> > +
> > +This device is therefore represented as vfio0.  The user can verify
> > +its existence::
> > +
> > +	$ ls -l /dev/vfio/devices/vfio0
> > +	crw------- 1 root root 511, 0 Feb 16 01:22 /dev/vfio/devices/vfio0
> > +	$ cat /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/vfio0/dev
> > +	511:0
> > +	$ ls -l /dev/char/511\:0
> > +	lrwxrwxrwx 1 root root 21 Feb 16 01:22 /dev/char/511:0 -> ../vfio/dev=
ices/vfio0
> > +
> > +Then provide the user with access to the device if unprivileged
> > +operation is desired::
> > +
> > +	$ chown user:user /dev/vfio/devices/vfio0
> > +
> > +Finally the user could get cdev fd by::
> > +
> > +	cdev_fd =3D open("/dev/vfio/devices/vfio0", O_RDWR);
> > +
> > +An opened cdev_fd doesn't give the user any permission of accessing
> > +the device except binding the cdev_fd to an iommufd.  After that point
> > +then the device is fully accessible including attaching it to an
> > +IOMMUFD IOAS/HWPT to enable userspace DMA::
> > +
> > +	struct vfio_device_bind_iommufd bind =3D {
> > +		.argsz =3D sizeof(bind),
> > +		.flags =3D 0,
> > +	};
> > +	struct iommu_ioas_alloc alloc_data  =3D {
> > +		.size =3D sizeof(alloc_data),
> > +		.flags =3D 0,
> > +	};
> > +	struct vfio_device_attach_iommufd_pt attach_data =3D {
> > +		.argsz =3D sizeof(attach_data),
> > +		.flags =3D 0,
> > +	};
> > +	struct iommu_ioas_map map =3D {
> > +		.size =3D sizeof(map),
> > +		.flags =3D IOMMU_IOAS_MAP_READABLE |
> > +			 IOMMU_IOAS_MAP_WRITEABLE |
> > +			 IOMMU_IOAS_MAP_FIXED_IOVA,
> > +		.__reserved =3D 0,
> > +	};
> > +
> > +	iommufd =3D open("/dev/iommu", O_RDWR);
> > +
> > +	bind.iommufd =3D iommufd;
> > +	ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
> > +
> > +	ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc_data);
> > +	attach_data.pt_id =3D alloc_data.out_ioas_id;
> > +	ioctl(cdev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
> > +
> > +	/* Allocate some space and setup a DMA mapping */
> > +	map.user_va =3D (int64_t)mmap(0, 1024 * 1024, PROT_READ | PROT_WRITE,
> > +				    MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
> > +	map.iova =3D 0; /* 1MB starting at 0x0 from device view */
> > +	map.length =3D 1024 * 1024;
> > +	map.ioas_id =3D alloc_data.out_ioas_id;;
> > +
> > +	ioctl(iommufd, IOMMU_IOAS_MAP, &map);
> > +
> > +	/* Other device operations as stated in "VFIO Usage Example" */
> > +
> >  VFIO User API
> >  ----------------------------------------------------------------------=
---------
> >
> > @@ -566,3 +690,11 @@ This implementation has some specifics:
> >  				\-0d.1
> >
> >  	00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> > +
> > +.. [5] Nested translation is an IOMMU feature which supports two stage
> > +   address translations.  This improves the address translation effici=
ency
> > +   in IOMMU virtualization.
> > +
> > +.. [6] PASID stands for Process Address Space ID, introduced by PCI
> > +   Express.  It is a prerequisite for Shared Virtual Addressing (SVA)
> > +   and Scalable I/O Virtualization (Scalable IOV).

