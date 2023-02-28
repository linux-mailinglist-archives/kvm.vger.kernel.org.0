Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E556A5138
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 03:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjB1CcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 21:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjB1CcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 21:32:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69D426CC5;
        Mon, 27 Feb 2023 18:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677551531; x=1709087531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oE4CFSRvIdPlIMh8QrD1NyBjS3S/JhZrIKAVIu4lrTk=;
  b=R9DFHpxVvkTQv2d+RYVRri8kGhlYqHKM4xYxDxUxKy2e+W8e0Z7JbJWb
   RK7hH3zm2sTWeXd42pGLCbY4QuF47DEnkOKvvAcIamoMg9yU8ItUn2WdB
   he5KyFLT8aPrtfmldvDk4ALJXdL04V/s4GjN8HhFVBgEfEJtrPxUDzgVQ
   M4GtZ2K22eByH5gO7RF3VD5ODdAyz9d6Ec0GYVW3lYrnaTOsiW9YdTH9l
   knmaiAzxFGP/GiB16xKKbwxpG8jzcLdNY7kSR1q/dOPvQDAyT6c69jQ4X
   cZSP6J7k1Hx+58XoshZh82CihkzqqkXsTAWwicCfOtMlADMK8urB/908L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="313702841"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="313702841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:32:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="704246952"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="704246952"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2023 18:32:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:32:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 18:32:08 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 18:32:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VczeNPaG4YLKbPQvhiamFNiW7US/YNIwvAroNMWjluBtJlwfAhA8+5KYqU2UBKZY8UpWtT9wXcOTY9kec/y2y9UlxovrLn6apWvOvFIWinnko2HEyYHH/XAA9pkD9zET7LJuPA3H9Bje7hjkezFYWBbzNUEOK2GRNWiVJlw6h7+sJxcL/1PbUKHmiFoJ1Z4vDTypkubTECxeyHQ3tTo5Xgz8pTPqd266tkL/ip/fofBXsM4Ja7ohwybwmE1KTvbjyr6o8DbiquIcUdxp9p2c2lkaAO2G0a1WiZw2UPvQMbAUHfK23DtFbsqTQudlfMY7jXbzhO7HMZGx+MyVcnoVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOCEzpSVZC8vG44iaiQOFxpo1mUiwJ6KwWT88WTTXy8=;
 b=oTXGLQGh3TxRxOJ5WQb3OcpOzmH8Aw+WynxrcVpEszxGBU/0rwHKFteejO84c/CelIQVL3M4ZIMJSjp0wAG3Uu6cJSXTz8m2lXHcBUxLJ0pwM3elQ4vM8xPXCF7Lb0fjEiWPxa30w/udUlZRaix0Td0h9YWl8eT14BHyO2K0LRHsJaLRqvsBGBx0NhSk2gj3exoRFir/Gzz+9l4mQTa55SRcR2nf8DhMa1G2YDr2cDM9yjPPpprHZI0Wy+aECFGp/vyReOKiFUAVY8l3/NDek7l3iaJIKM66uIV0u7fADtyzaCl0OICCMxjQKhuq9jG0jRXfRyGKjVCGzNwHoRcrtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7579.namprd11.prod.outlook.com (2603:10b6:8:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Tue, 28 Feb
 2023 02:32:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 02:32:00 +0000
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7jG8CAgACFuoA=
Date:   Tue, 28 Feb 2023 02:31:59 +0000
Message-ID: <DS0PR11MB75296E071F459CBBFF9641A2C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com> <Y/z09fQAW7Rs0uIc@nvidia.com>
In-Reply-To: <Y/z09fQAW7Rs0uIc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7579:EE_
x-ms-office365-filtering-correlation-id: 28a3c84a-976b-4825-ae9a-08db1933f813
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X4KBmTZi/dolU4ws84XZKmraNHG4j1ffWg2CAN54I+klx6T3VhIKI4gB89/XJvi8rDhHXHTU28g4hY8jkAKgI+ZR9MFbPerNJQ3YpcwPXUt/ztP4iamOjlZ0KYTPd8EQ4tLKKYqcdKY/MTnoe73+9mpI5PE6gnPhaF69c5t6WxWYbvNCqYgyOLJIqYgstH1uD2mJ9DI8wzcl03sMpU04vrztvcCngff5utmHvGIDkvYweQUcj+aI9rieCYpWZr4TnvUq1G2knSH0u5N7w3BncXmi42aAnph18/NsEgsMaY2DTfmsaDAnpZA9qo4w/SSnz9fEJCU7Go7etd0TQub0jPWFPAfp12Yas57Ojr/52ZrDqw+jGggwQ9vnNPl63/usKgCQHzGwfJnz9yVuGg6vB3yiKUbkm7xB1dz4Bb7XZdgA/ChYqS05VecAR8D9In65dMcNulc5MI7oTX6Nind2IBa5cXPYDsoab7iX5+Hk/hPKbQLaUcbsMR8SbUdNfQHp//AQRxDnmLwQMdWAxel2b+Bq6+Ktpccbp7K+YRzLcbcI4p2i6W9R7l0BaAMIdT9EaQKiHMQ1afX0tdj92are9gM61luKlM6Rqb43UD0yEAw//Wmcr6lXcLB41kFwe8x5jAm000pQGcSJrb9mXzi48Ayc00xdYiYVxtyp0t19aZUBgJz9sJRzqXLYXYiPWnwe3g6ylix3zUhG+kbcGJlTGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199018)(9686003)(64756008)(38100700002)(38070700005)(52536014)(82960400001)(122000001)(6916009)(2906002)(66946007)(4326008)(76116006)(7416002)(41300700001)(478600001)(5660300002)(66476007)(8676002)(55016003)(7696005)(186003)(26005)(66556008)(71200400001)(6506007)(66446008)(8936002)(83380400001)(33656002)(54906003)(86362001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s5Iwwle88MHOdE5FJYNnZzyF9beUuBZlQlkVBAO4Lj+lx66SmziCgmeTLMMu?=
 =?us-ascii?Q?G4KayhSwv4qlXlNqVKkFbrKWfK4ZjCj1E64uTMNiLPE9tyJuWKbZnXHT1F93?=
 =?us-ascii?Q?95d9bfevTMIXDnh4mDej2RcBn4d953YzkEdRqOvxOu9QAiBssCfbUf+ha/fg?=
 =?us-ascii?Q?chp81J7sf5Kok/D0rZyoEVY/zrEVdm+N1XLNsOedTw0WLqLlmtd5ydIxRjjP?=
 =?us-ascii?Q?fZo7H6tBV35jMjuTfaOvh76d5/4feSjXtdGeK5PtBLDM1x9QocwKUqANCTtH?=
 =?us-ascii?Q?Eh4dWYoShYgSgHEho2GU7RULnKe7Z6+GqSbwyMRNy1NdbgidvNPF1afVrAv6?=
 =?us-ascii?Q?AmgC9pfQWm7hus59Isk9XvJCY/G9zPIePOELWXmSdvfGngTWSW8WDZYqWxzX?=
 =?us-ascii?Q?PmOSvqq0CF1UcOuPfJ5qb9R6BTDODLrPSlbspuKfUCAvRv9+nzqMjdxG6Iev?=
 =?us-ascii?Q?mOI1Y/mBfSD32y4wOtDQ/ChQvYK7pV2JWgTxn1NE991EWaLaVsvPinYpysq6?=
 =?us-ascii?Q?o0rSKizHVQqlEJkykL0bdwPL8hr65KSze6xuFuRWYqwMYonesaJ1KaLaHKQL?=
 =?us-ascii?Q?DNq3vqMAIjrJL75z3LpBDuOSu0o91rkoopg/oIC4NdiInYNIFl+alMU/76kX?=
 =?us-ascii?Q?AOtus5gASUTF0Qj5bU08JoBUG73wIyfaubDSk06P3Ztnfs0gVFoA+3fF5j9n?=
 =?us-ascii?Q?0raKB/j4rbvF1i1FrDPMnMYoWBv2itnGTwdmrGcLyHS5GhHVjE0eTGivlcF0?=
 =?us-ascii?Q?Tyqq2ftTzrehgkFgCfIRMLPcR7/kRXS78kz3e83WrfPqN9sqkcxFxPJ4/xlE?=
 =?us-ascii?Q?Jxe9kRY/Xf5ncrpUevncYkknG+dB0w4B7G2hcT1N/hWpxRasLFJAp6IOfaxt?=
 =?us-ascii?Q?ymJimu0K8pktSZp3qcE8P1v5T99ZFkKesBSxDSymVyDxyUMhqbHaMblYSHQ2?=
 =?us-ascii?Q?75yt7efUrGonZ/7NxB6vBjZkO+1jWGXr/9dkmA88A+Qf2FmpHh1FXeH1V9f2?=
 =?us-ascii?Q?MI8vBFSS5q9rkM1+hxJULGfcqWdGbSJWd0DUQroxBX6nSL0WOoXyIlks2jsS?=
 =?us-ascii?Q?nnp61+JHoTlJRFUCDY42XpBtQOiUDZ0e/hiY4nzyo2QcKOODgMvueiRqNq18?=
 =?us-ascii?Q?qut6S+cXFWUj4jCayRsFpma9/jminmnc4WWdo2Xss+pAxdWb0NwC5MpukDHR?=
 =?us-ascii?Q?0YIkMBCP0LlSzkT3y9SGwcX/YxlRLZX1panLfBIDcZykiWrUqR7UlAxsbMEh?=
 =?us-ascii?Q?RiO0sAWTTdMwEYnV5DZBnfVDCnNxqUEFa/DKO+s+STl3TJVL7sgKS97XkYox?=
 =?us-ascii?Q?C8D0WE9EyoqiCSKPaQnQzi1eRyFFtP/lBwB4mhwU+ddDeC16Wv4HIsJ/YnMo?=
 =?us-ascii?Q?YD2vx32MVk02/vAu8PAv2KByhK0ETbQRlaNCGwWBacRUpmGmg7swOAiFr8nh?=
 =?us-ascii?Q?SK8KsLd1y+efwH7YMRLEGNGcYXRi7S1eDQTav3HvX7Gzfhcm/Yb9sGtOP5B1?=
 =?us-ascii?Q?XGvkaeZL8XCrZ3pzwookGGVR5DIli4tBZsg2AgIJS4NrPcHUGVWiucg81+Yq?=
 =?us-ascii?Q?g+mc4feVOaHZI8YCftF91T0MEiA6azQFy2UbXMhk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a3c84a-976b-4825-ae9a-08db1933f813
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 02:31:59.8966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 916ygKFWx0ym8AV92K6wPi8LP5KnGE8/5mOJnxb/lzfs2AG2RzNuDy324WLq1kS5lhTsv2c5OsPpFy5GouB4Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7579
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 2:23 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:25AM -0800, Yi Liu wrote:
> > to indicate kernel to use the device's bound iommufd_ctx for the device
> > ownership check. Kernel should loop all the opened devices in the
> dev_set,
> > and check if they are bound to the same iommufd_ctx. For the devices
> that
> > has not been opened yet but affected, they can be reset by the current
> > users as they cannot be opened by any other user. This applies to the
> > existing group/container path as well.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 111 +++++++++++++++++++++++-------
> -
> >  drivers/vfio/vfio.h              |  11 +++
> >  include/uapi/linux/vfio.h        |  16 +++++
> >  3 files changed, 109 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c
> > index 1bf54beeaef2..e0ebe55b4df0 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -27,11 +27,13 @@
> >  #include <linux/vgaarb.h>
> >  #include <linux/nospec.h>
> >  #include <linux/sched/mm.h>
> > +#include <linux/iommufd.h>
>=20
> Is this needed anymore?

No more. Will remove it.

> >  #if IS_ENABLED(CONFIG_EEH)
> >  #include <asm/eeh.h>
> >  #endif
> >
> >  #include "vfio_pci_priv.h"
> > +#include "../vfio.h"
>=20
> Don't do this, put vfio_device_iommufd() in the normal public header

Ok. will put it in include/linux/vfio.h

> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 0552e8dcf0cb..4bf11ee8de53 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -673,6 +673,22 @@ struct vfio_pci_hot_reset_info {
> >   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
> >   *				    struct vfio_pci_hot_reset)
> >   *
> > + * Userspace requests hot reset for the devices it uses.  Due to the
> > + * underlying topology, multiple devices may be affected in the reset.
> > + * The affected devices may have been opened by the user or by other
> > + * users or not opened yet.  Only when all the affected devices are
> > + * either opened by the current user or not opened by any user, should
> > + * the reset request be allowed.  Otherwise, this request is expected
> > + * to return error.
> > + *
> > + * If the user uses group and container interface, it should pass down
> > + * a set of group fds for ownership check.  If the user uses iommufd, =
it
> > + * should pass down a zero-length group_fds array to indicate the kern=
el
> > + * to use the bound iommufd for the ownership check.  User that uses
> the
> > + * vfio iommufd compatible mode can also pass down a zero-length
> group_fds
> > + * array as this mode uses iommufd in kernel, and there is no reason t=
o
> > + * forbide it.
>=20
> 'forbid'

Oh, yes. will correct it.

Regards,
Yi Liu
