Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9F695A83
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 08:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjBNHUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 02:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjBNHUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 02:20:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC1AE395;
        Mon, 13 Feb 2023 23:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676359201; x=1707895201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Dnt/xYBsfw4QDCsdLv4ddhcn5eI5TKZKXmhAkGGyd0=;
  b=OBOyerWDWVLCnI6pxCLwAwH/Uxf77fn6yEztIR8rLDMCBwDLg2jrvYB7
   HP/oiTQAbj69j39ntgR57sQMYezIB9GMUDTAZaOPKI16WFIfjE7MQxDMm
   +7s+a6XpVVyWH0bGXBAQ1PeMCE8/ozosIUB+d4wCxn7cuPjqO0oK+4sjR
   D4sXCESc0ETRBayZQ4SIx0nQocjoxUsG+9i2oyGCuc6dLITqbTlyXV5Pn
   GTKxafXomSw+vVihWtrjNDkYhVIbIXVlkuQNEqJJYqiGRC5MNos5FkxbU
   7nPhK5NNJ4hO6r75FxgVNpdUkPRiKBVAkOvSo3ezR9GLIlfj0h6cuAVbY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="395714659"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="395714659"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 23:19:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="737803650"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="737803650"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Feb 2023 23:19:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 23:19:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 23:19:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 23:19:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9j0l5k7lMvA1aNOKmbeSA8zekg6Jo3xGhRD3rjUgsq0ivf/vVCxAoQ3vrrCLmphJfUPphCNvhNM1qZIzWmwORj0+5Cg25jFttParsONzUCaLi7BDDAvnJcCQ7PTB/A7UFgKSevjOD4c/Ha03uPCcANZy0lioSsRpr29XIm8PdUZgVj6V6e2Dx7AyNAaQSnWWMDPi214wqbeEPz+L//R3dTqfuAi0pFgF98uDJUtY7p2dhz6qxMDz/Sb7/enL2T0LZHM20z8woVMDpT0OglTgvMCWpFj2C3bR18hLnvo+LAxgkZZQfTxA+5SOCQLnlccGz+HK/8XP/9IE7TqwaXiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7/UeIoHDPS1WfeUFfZFqwzeGDJgMnO3sVcNHNLe0nA=;
 b=fvRHzZoaWQYXdBCn90uGTt4ZdlkDvF3Dl0zQy1KHtxSt9GzFCPsH66gLCtQpaaIqqNgJ4p+PlCL21lsHkv5Z+yFWHfdlBvXB7M+h3Uv2vGDYG9WkLubYH2tFpIOURIpvONcsN3xirFox+//pwi4etkXQyg8fvBXgjN9UXVB6Ok7ADLwx+0GpQn8Q/g4j06ViyaCg07IQqiGsF8DXOkeWcLB+jdnpdqnTxCDJSWTZhO/wF9wDcZaLYIOtpU6xpkrS49YtRi+woA/F1hRQlxHD8tMMkcaQsHMDosQe/B2gsHuoIksDu5F1XIqL8DZ30oUrEsgHGjZmi+diDu+Cmj342A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5515.namprd11.prod.outlook.com (2603:10b6:408:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 07:19:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 07:19:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NioEAgAAlR2CAAFaKgA==
Date:   Tue, 14 Feb 2023 07:19:12 +0000
Message-ID: <DS0PR11MB7529028251B2DFF28A3CCD00C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com> <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5515:EE_
x-ms-office365-filtering-correlation-id: bfb7118b-3fbf-4834-0536-08db0e5bc57a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4YMzLf+gGoth2xy6YyqT7YlACeRg6pxEUopV+YadN84ctWzYe2Fs8dbs3HzsMturcOUWyZi4/tji97E/XiPJHUKepFMvSd9ZcHB0bKjCfbfzdQXmEplSkaJRjkkFW83TwQrcuRDxylMy8ZERbNEWmgprhg4fGi4rFM+fTWUvYERqGUF8Kr5m2EHCx5w4rpfnyQDttZurGOaiYrLZkrvWiYgyDEhqyMkor8KyLbhVUEpkyunU3WsS2TvjRqHPxy8E82ddE2Sgw4X29CSvPybsn3gUsNJNq4B5VvYDlpZhr1xPJkC9WIRyfaWKpYbSWHdaM6ga0kKCmnaRVP3vAIK3ROafirk+BNujACImvIO5aBILKXLYDxF7tZFsFMItb94OB8X3z/ILWgZ9eQGiMw8O1hSF6J8x44uBg040HEjU7tek5Qg/Bgi5xI7MthV+48r1PqEQuuuEFQSoWCSh7Snh71VRauAmJFCe8+l6RyHCB86KbWh6gcmNuVW8dLqYMwKyggl/xZR7AT81RsGTH6eOR4PqnzBI+NBW2+9pTcUt7jIksmeNqFRzTWqDG7b/Hw03cakxrmtkiSySJiKoaVJIC/MIA9cuktm2KgtIhpkOMuYTkqxspJB3y4If0nc2SSyRbTbdBUqJSiUc0iLWY0ELb4huZkpQZogiZtFk81lwx5iZnlm11Hev0PDY2ssH3pT6FICKSN/1E9UWjrJTy0nGiQ+hoizK64pvNaxyzpOD6eU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199018)(7696005)(478600001)(5660300002)(52536014)(71200400001)(66476007)(66946007)(76116006)(4326008)(41300700001)(6916009)(64756008)(7416002)(38070700005)(66556008)(66446008)(8676002)(2906002)(8936002)(54906003)(86362001)(122000001)(55016003)(38100700002)(316002)(9686003)(82960400001)(186003)(26005)(6506007)(83380400001)(2940100002)(33656002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oxJgMm77XNw7UkvsD8Uq/v03RcJkOMLiy4NqlFcF8ORAN2ODNr/Xx/7W6v5/?=
 =?us-ascii?Q?nHhCOE2mqfzpMDY0zHJ4UZETmHIxg1a9ETzG5PE8t7JJip3FvGyY3Dyunym7?=
 =?us-ascii?Q?KHzCMbE0/7i3K/fhAXlxYhnU3LqbWLfF3nUUnll9FOCMI5xYSexgYPHjP6I4?=
 =?us-ascii?Q?+JaoEs3wSYXLqDbsbApuEJzcUzmYgVkBHbZ1v4O3ucjRJPicPaJahUYNzKIf?=
 =?us-ascii?Q?XLyG6m8if5p1wB50rV2sb1+XJdw3OAD2AVht29QO0K5ETIyKjDHW91EGM4Tu?=
 =?us-ascii?Q?jSICUYeMWWzR+ZCfERRIg1V5ZA3ZVnKZO4Lkt+ONCF7F9O7w+6kkhCBLP9Ph?=
 =?us-ascii?Q?8V1CmdNZTBivRs3WuxIzZuPo/kkpswDFZpNVqIDlCrsajPK7lolnsxTGld1H?=
 =?us-ascii?Q?2vqmo/caW0g+sU+D0e5Ii9ynXF5VkBNf7Opp0alkygn+Z0N8F5sVwxnYi0kT?=
 =?us-ascii?Q?+NUqx0bH7cV5ruRsU/UZUxjHHOBICoXqU3f6wrxKsxc6ogT3gb18ic/bxsD/?=
 =?us-ascii?Q?SDy23RHkL4dzSXoNKUtBthx4sVijs8iv7tarIXzbf66nf19JZ8lWN5k8IzEN?=
 =?us-ascii?Q?6NllHaI05BETSdtbyWpOLS2MLtHakWfOclXCyjKOLWk86dAQi9z6zS7I1XJk?=
 =?us-ascii?Q?YomM1tpmtWKBN/lr3lZ9h9+1xt/IKUyurcYdGqQ2iZjsoRj5yYqljxSI6wAR?=
 =?us-ascii?Q?4nOYeE4QF+YAkcLInkt6MgJ1bBX1lXhfyF/+g6xMd9OHAoCTFRS3o6NRrPxz?=
 =?us-ascii?Q?WwM0679F50f71IoGAWpFTABncVoH8sWJ6x1bzZVw+T1i3PSFR5nwdzKN1euz?=
 =?us-ascii?Q?WyWegHWi42Nzw9z/W8bpS8WGct7x1qfJbdDkC7Rdo40B2dTAiffEcxE0k3xK?=
 =?us-ascii?Q?qj3wBGe9J3VNwIzuRFeB1lZbJTIkm7BpwTouZHilS7OTzvroB49mLIa3ioQa?=
 =?us-ascii?Q?92NY8I18fjPZThQYSZwX+AfsfwV2YtvyxVQxbGgWF3QqAaDR5iqh500VZlWQ?=
 =?us-ascii?Q?9d4R/b0w7A/XVHQIpe9hJ3S2vO3zmYyaOavbyNQs0afcl2ijTz73//7xLjo5?=
 =?us-ascii?Q?1C426ES2eR7PmDaAbFVJA/LYxXgMOhZcM/lr2wHkVA8eHbbVVA6CWqkTs0v7?=
 =?us-ascii?Q?ivoJBoFgzWWZOjqcDcr7a306N611sU9QJ69ohNcyMIC2UK6O/2q8F5d6agv5?=
 =?us-ascii?Q?854Ql7LtvQ0nEzBLJrKmHzNOnVUsrKfdmWNVeKf/YlSwaJ/aj0Erj7X1IzI1?=
 =?us-ascii?Q?LxR4pz2YP1Q7gBTUQ5yXBraPAY2pVL5kEfCwYRkhUKwOCmKB8MlrhKUxzKFb?=
 =?us-ascii?Q?t8gRAjzaSYeQblfzNTpp1ctlhI1bAJ7EaAC+ukxtUmAgI+PXPG5qacagtzIT?=
 =?us-ascii?Q?TrKvBV33DGQs2b/F7FMkUlYCvPTDQHuyaA/HkEbYD1WvxmupIcDxddjQtDQ9?=
 =?us-ascii?Q?EZn0w4hF64r4uzw9nB0W+P1/c747QSsqe1IJH1ozXqEYH0wYHk8rly5AfpaE?=
 =?us-ascii?Q?f2R4yLMsakKFfkhZWg5C5w6B2rqft4uRrSEV8rKps6Q4i9avP9I4KNEqTAj5?=
 =?us-ascii?Q?dlZbORVpvuaqRCZ3bLlWvZqtW+QS+HxkBOVgLS1g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb7118b-3fbf-4834-0536-08db0e5bc57a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 07:19:12.0353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IHWQX5CS6lheYdaRUzvjSW8wLwhOyXraVm66yT4cLW49sBVNzYcwrCk77dMEdk7fdqGo7TFEA/nxG6oa9PKOvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 14, 2023 10:03 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 14, 2023 7:44 AM
> >
> > On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > > +static struct vfio_device *vfio_device_from_file(struct file *file)
> > > +{
> > > +	struct vfio_device_file *df =3D file->private_data;
> > > +
> > > +	if (file->f_op !=3D &vfio_device_fops)
> > > +		return NULL;
> > > +	return df->device;
> > > +}
> > > +
> > >  /**
> > >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> > >   * @file: VFIO group file or VFIO device file
> > >   */
> > >  bool vfio_file_is_valid(struct file *file)
> > >  {
> > > -	return vfio_group_from_file(file);
> > > +	return vfio_group_from_file(file) ||
> > > +	       vfio_device_from_file(file);
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> >
> > This can only succeed on a device cdev that has been fully opened.
>=20
> Actually, we cannot. This is used in the kvm-vfio code to see if the
> user-provided fd is vfio fds in the SET_KVM path. And we don't
> have the device cdev fully opened until BIND_IOMMUFD. But we do
> need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
> open needs kvm pointer. So if we cannot apply fully opened limit to this
> interface. Maybe an updated function comment is needed.
>=20
> " vfio_file_is_valid - True if the file is vfio files (group or device)"

I guess your point is this is also called in the pci hot reset path. And
in the reset path, the device referred by the device fd should be fully
opened. vfio_file_is_valid() only checks f_ops, which is not enough to
show the device is fully-opened for cdev fd. However, view the high-level
flow, for cdev fd, the device access (neither VFIO_DEVICE_PCI_HOT_RESET
nor VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) is not allowed until the
device is fully-opened (done in the bind_iommufd). So if the
VFIO_DEVICE_PCI_HOT_RESET path goes such far to call vfio_file_is_valid(),
the device should have been fully-opened.

Regards,
Yi Liu

