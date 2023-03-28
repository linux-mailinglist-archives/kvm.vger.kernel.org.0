Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23BB6CC28A
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjC1OqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbjC1OqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:46:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02306DBE6;
        Tue, 28 Mar 2023 07:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680014743; x=1711550743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Om8+E3FsPNzf43Lfwlvm1isKNwKjz/rm0d4fTy0WtSk=;
  b=UXUFy1OxT0tjh6acoYeUCzjlA3VWew1ksPIF3iK2Xz9GZzqz2nT9E60h
   2nt/+GVk12LfNC6ZDQsn8Tfxt0k/Ji1pT/46UM4cs7yIwmAymwRfBf2zy
   yyT1xjSHI2LG/cj8c67aT7IU3pUCpI8usngaKuXJtpMx6dmIJqbxNTM2W
   Grt7N7WQldYKVN/J2Akb95W4s4IFTZV68F59U1a3PlNlRERCcbcm+3mtJ
   8W0gZZrWwNViZ4k7jEGwAifgYeeGRQu9kPOoGmY2PGFXJtGChDx7Qj5PW
   R0CqKsNrMR7qNMe0ZPip7PitPJrd/K2ajl9C9Zd+nd+lTwXqyUw3SvaNf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="403196077"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403196077"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 07:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="827496333"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="827496333"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Mar 2023 07:45:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 07:45:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 07:45:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 07:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9GCRjP4iB1QljwqeLwkCzrQd+/CE4BdyWDYXfbo+N1Yn6MkBw+Iv7HjD1229QhNxDEdDFI1urEaIBpMwecmEyS/EMhbi66WnUD6ZPhavdZhVMSmJBUUHg665sI9T/eKPotorlu0nD//BCdFDKSgaOoBOWVmWKZD38J80VyGDIdAgSVqDUfrORVJ583aT7nScqpbYbc0r5kw9OT1iWGFbqlW4sHDdwsZgD8utObDE/1sWAr5YRt9N8v8AigbCWLOgl80KOpClt7GxDI6t00Y5opaV1fjKUtX5XfOOgo2n4L4o81MU+Y3weekcVJKgQOqAL+77tB/u9AJy0WCm98W6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKcgA8M44yH875ZIJ1Q/yguUPgUBbEr5zMGsBdf8icY=;
 b=YMoHWHfiS8I31JDDsRvb2GfwN2cOJol8ply1Kynt3x9nspuRPbwcVuqsRJ4gE1p/e0xZkkE1Oj+fGjjxZedEAM+OQPp3xs8BUipliZLWXbMUl9ln4u5ply5OMaecOhK0w07F350YepNVplV4eWLIv9WyeWo4lalRSGzmqTpOroDsomfSoaQkSkEZgOqNjEZ/Beck775fjmtdNrDsAAZwzFfsmTwmOuGQb96klqsX2Doat5/1I2lEtyVyGJuhsa9P3dmKNRqZUcnbBPKKKp67vRzy0SCM2BvSTEZG4dIFuB3h1MkofYHJvg9UGE5AoBlYtxplez3v69EeJjaA7/4e5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB7908.namprd11.prod.outlook.com (2603:10b6:8:ea::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Tue, 28 Mar 2023 14:45:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 14:45:29 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8QI7wAgAAiDDA=
Date:   Tue, 28 Mar 2023 14:45:29 +0000
Message-ID: <DS0PR11MB7529AE495EE69B4F7A471E0EC3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-11-yi.l.liu@intel.com> <ZCLgKKeESkh3Cdk2@nvidia.com>
In-Reply-To: <ZCLgKKeESkh3Cdk2@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB7908:EE_
x-ms-office365-filtering-correlation-id: 60829cf5-c550-47bf-bbe4-08db2f9b1373
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C6F4E9xggm6fJyYAGl/JpV3yzoWvVCiWYbHgbPeucV5537aQq6DE0aNu3szJHpPuwKJXl9Xw4B+39qbrEkFy/8t9YrrYFem6O/T3sD3VU2vfqKmDXThn4mTYmdnp+1FKNhlJdDFHTlbQMQF+7St1xAcN1jolQomB6cRv2D47k9HDvBmzvlFr8zTJdlnQl2ywt1yOh0ptVfwdjEyCtTUHRFOimWldsb4P9qAnVZzLHiF1uZXP7Tl/c2lii88HmAeFbtiMlUBsiMtcJGiMipDsSnctiD7hR9MXHLlHfLgy9hZNqv7DErz6/3yXEYv5CvLIZCPECDC8dnuocRsJbUKwH+bGPy1IHbfVsFVUQSDfJc4/gAV2zrLPlhf2C2MKUeikv2lpHlogQgwuubMELvoy2h0j2LmnXMbJFmxNTJAlnEJGGB8wEForvsdh9D2USj2b1lypjFA0/7uxVYAiSIdVvqRoqbV/KVXNaY/rIUMG1ztCIyBxbPjYGd4+wDgBWQOF8GaKRrdisgC9Xo+ZmEz5XPrLtJtCzTd93dVviLl0bypQUpY62Ux2P+VNjgdN6NxDnfpwZ5jH2xT3zs7T4XsPPpJDrmJNr37z8EEngdYBA24IcVcxfgLtQ12BY1tLqIzl3GrORdE0K9h9DRqtCs3CEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(66476007)(66946007)(83380400001)(64756008)(8936002)(41300700001)(86362001)(55016003)(186003)(316002)(38070700005)(122000001)(7696005)(2906002)(8676002)(71200400001)(76116006)(4326008)(52536014)(54906003)(9686003)(82960400001)(38100700002)(6506007)(26005)(5660300002)(66556008)(6916009)(478600001)(33656002)(7416002)(66446008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IJ9Tsj24rSqcrSPRhrHBozhGAN12+uL4PSEzKZaxhGudCL0NQLPzqOBq7Pqn?=
 =?us-ascii?Q?TiZQ51lh8HnlGuN9qYliPeh5NWNzvmw98Qj/cF28rYZc8ZcsQlSrd5UvHl80?=
 =?us-ascii?Q?sXVdPKL8UAegItCetCv1ZGwCh17ocbtTg1SOFoXGYRsVoAGT4LP42Xw1L+k2?=
 =?us-ascii?Q?wv6Sl6zQX8TsbweKRkeiKy5A20D50udDMt8DVhidzvv/V+15DLhuJslqoBq4?=
 =?us-ascii?Q?D7W9fA0mQ3tKIbpid+kcHLcWHrPhLqy9D59C8k3xBeui5uJF2FtJ4ZiSqOFv?=
 =?us-ascii?Q?kGilrhwMTnEcpNotc9S4QuQPk3wb3lU6jQiHL+vi1x9PdXWp1GZYYqfrtSPe?=
 =?us-ascii?Q?VSY9IgBQVylzqz6FD2SIeJx//7pu0AwZcxMCtEJH3KYpQpAZaJI5xxCJM4y6?=
 =?us-ascii?Q?qmsZZYwFImSbVoageVkIjP3lLyfBFpYzHDxdRTwuBrZluDnKzu8DWiBhgWBW?=
 =?us-ascii?Q?gXU5YsyY0vuzMcH2M6wVURUeEGu9wGXzAVF32sy0YSYCsXwZ6gN7Ae66hsDt?=
 =?us-ascii?Q?1BMdV48tWEZgnNsDp3jJa09xmmkRHPMoNF2I4AVwWZ9lo+jpXO1rgYnZU9v+?=
 =?us-ascii?Q?fcM3hOQL1TiGR+mXlhY8XjMNhoPQ62W8mEF7/ojXovG26wRXwzAu7O9j6fR3?=
 =?us-ascii?Q?dNk8m/4NQ4jbQ8/XX+T2eN/l/FR7/JSFTKKLjqUarl57DJL7n18v6YrDg3Yo?=
 =?us-ascii?Q?SB6Gn89lXw124YQASJCYRZbkS7gocZoyIj9RCAPbx8FTnpmRk/gKPjfulmv+?=
 =?us-ascii?Q?7LWF43sGlATTS6oQQB42hN30/mYSePyQsGJr1vc6NtksMIK123ygl/s6wTZg?=
 =?us-ascii?Q?/fR5qvt1pQ3QM4WsPKLE9JzEAyaQM2sOkHPl+9AwDEFIhwYkwhriSFIn9xpN?=
 =?us-ascii?Q?8I+DPDPkhZLpC4+bhrkndRwTzo14aQPeVkG+2s4jdEyu+3KnPeE1Ifq8fAZU?=
 =?us-ascii?Q?rI1ybjdkOKD13wNjCHEoSmlK8Jeuqbj1Wj1vdWSdh25HIt9lhP4mvAaV+7K1?=
 =?us-ascii?Q?/6GAq8iVXp5WSJoGpZooqfBFBsv7Q6rM5hsxnWXjH3qKSr56atXlLozZHMKj?=
 =?us-ascii?Q?zbr5xoSupf4ZPFIKYjSoxy4AFGjcB4/ACRsOBGj1EjRxO6ZndoW6apCTe7HX?=
 =?us-ascii?Q?pg6yidNXydgnDZpPfKidWJWJNU/ZMZzGOg1yRxwgKGTQT3RqIwI21b/JrbTk?=
 =?us-ascii?Q?AY8u2TNc/rUNM0CH4AnMXk1lXIb8O7QJeZPoaB1sPh8DwznswrH9sq5mOJV4?=
 =?us-ascii?Q?NTwOYN+3NWcO6bTM7fwiHIf+HjpG1CI0klNjQvrUrFVroeYiZZW8H136n0h+?=
 =?us-ascii?Q?MVXdJR68bqAbpgVv6/5dbO39uEgTekBVB1p41Di+hwfxlkNFXbACYtBTyrOM?=
 =?us-ascii?Q?Bzk3+cVqMV/Mmafe3vBjt/brAuUAggA5DyOhK3SuhPF6p3FxCHvkreBbjr9Y?=
 =?us-ascii?Q?ZvmsgN6wZtZlADNZ/ggFf3FDk8flOjMIs7YLzAl1DAlQaJF9dQvTIlCObAgu?=
 =?us-ascii?Q?9ooqCWNJjnbd7dz++Hw52dUtV8fqJMwuawKT9GuhnftcVF3IaRJkG44W4f2Z?=
 =?us-ascii?Q?k7ac2mcaOqYYGeQPVW4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60829cf5-c550-47bf-bbe4-08db2f9b1373
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 14:45:29.5220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KtlsuCWYuMQdKr918HSQ4MkFzxvIKLu/duSsft4yS1MXlTzX2IbuuG/hpiPrFIs+D1th7pP2OfA43rZ3Wm0DDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 28, 2023 8:40 PM
>=20
> On Mon, Mar 27, 2023 at 02:34:58AM -0700, Yi Liu wrote:
>=20
> > +	devices =3D kcalloc(count, sizeof(*devices), GFP_KERNEL);
> > +	if (!devices) {
> > +		ret =3D -ENOMEM;
> > +		goto reset_info_exit;
> > +	}
>=20
> This doesn't need to be so complicated
>=20
> > +	list_for_each_entry(cur, &vdev->vdev.dev_set->device_list,
> vdev.dev_set_list) {
> > +		cur_iommufd =3D vfio_iommufd_physical_ictx(&cur->vdev);
> > +		if (cur->vdev.open_count) {
> > +			if (cur_iommufd !=3D iommufd) {
> > +				ret =3D -EPERM;
> > +				break;
> > +			}
> > +			ret =3D vfio_iommufd_physical_devid(&cur->vdev,
> &devices[index]);
>=20
>=20
> u32 device;
>=20
> if (index >=3D hdr.count)
>    return -ENOSPC;
>=20
> ret =3D vfio_iommufd_physical_devid(&cur->vdev, &devices);

Ok, so the whole point is that if  cur->vdev->iommufd_ctx=3D=3Dnull, then t=
he
vfio_iommufd_physical_devid() shall fail as well.

> ...
>=20
> if (put_user(&arg->devices[index], device))

Will modify it. let's close the "separate ioctl" v.s. "reuse ioctl + new fl=
ag" open with
Alex first.

Thanks,
Yi Liu

>    -EFAULT
>=20
> index++;
>=20
> Jason
