Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FD26A9152
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 07:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCCG5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 01:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCCG5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 01:57:37 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847BB29175;
        Thu,  2 Mar 2023 22:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677826655; x=1709362655;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4JEV3DZ/iFkHX8lRsdgNZTT/HxaTvr6HRzoz04st7Yo=;
  b=ALlByhmMF+Sk+I2OJ38cYAzp2iHWnVtA/CxMkuesrEppF9d0fyn8Nw7o
   eHXJCf64wLDIzOD0Cf6EF/qEK+9ip+aYCPjDKiRJBOS769joPgOJtUVXD
   jZ1F3giiRdwHsJvZ8kS6Y36yJ5YUGULdU7v6m4ea8r86qbAuq6KleV3y1
   S0RvZpRwPZeB6NQ3FMeODw6l2kOFY+VbxLnHo4LbWI0lk34/HHbVQfSHl
   jqGopSW/6OO/qIIjJk5hvby0WRHY0aKhfggHy1vCxjjSeaeDtX2NarywJ
   bS48FsepFXeiAdfHlmLMm6jOlAk5Ry1xCz4wkBx8l6JgZGi9gQe1JIFrj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="333695600"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="333695600"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 22:57:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="921003226"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="921003226"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 02 Mar 2023 22:57:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 22:57:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 22:57:33 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 2 Mar 2023 22:57:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CofG402bUV83/9jMo/UKmPpzhNB2t/zHHo6mtUJK8gLJ74zM3o846P2E9y9gyHZSWzo/yTdqkRQOXJ5LjQBDG1a6nZ1Jg9N13Vgi+lG/CpL4FFVR/TUuClfIU0fsIAiUHggGO9hzwCJUltXN0LFG6m5T68zmfiwwK9XbrnPI2eqcVEO4JaeY6t+daq5dXHDZjzXtgObQ3JsiU8PdwI7HW+6q6gZpvz22PKMSxAcQWWoIMbpp6P1FdirUVGM4peuTaHVm5XK/mwwUrcw3LBBx7IBRb1y4H3DgNdoP5vtB/lQ6rggt0KFePNtG25z2cw4uZqyLJolgdcQu9Vnc7F6sgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMcQaSkkzVVUHC5gJuFPZWZdPclEHoV3XAg2FRksno4=;
 b=S2ewYqsUnvbxNB5gtj2ryKaYgmMLDbIpeGVt8dswWcRymcEHI6xdAXrHD0NC2akOCydKh4kZJrYGB5LVlPrUF2vFckW9zRPmZP/tpw4B3BXxEjvpO1AW6mF4Z8TRmjwS7FPc1G0/TxNAKDPHzH8mKP8Tet9F82H7mW+sOEQfzQvOUEubWbe9uoAZcB8mRPz+2zLEPIW6GVbKkVCdnJR3H4oakTPM0nUX9Xbmoah248A7dHb53ZEAHXuWkhaa3Mu26fyu2nvcq8PFMrnnREGCa9kKFstAIDlCDYKUy6xKYjtkcBRaz4E10J+AN6T+TyOV/xI64k4IEMJSaC0vizNlnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB8108.namprd11.prod.outlook.com (2603:10b6:510:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 06:57:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Fri, 3 Mar 2023
 06:57:30 +0000
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
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxP1elsXPP8bE2Y+PYEE7Tlg67ln1gwgACXEYCAAlTioA==
Date:   Fri, 3 Mar 2023 06:57:30 +0000
Message-ID: <DS0PR11MB7529E16DC2B558E8476D835FC3B39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+Pkbtr8KQmUjVp@nvidia.com>
In-Reply-To: <Y/+Pkbtr8KQmUjVp@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB8108:EE_
x-ms-office365-filtering-correlation-id: fc9d7ee2-3a9b-4c1c-2675-08db1bb48e73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H2pJ+1FG1WyAfJrGy//gKCEgsYZGmTcRIa5HwfcGszMcNJOfBNSiYwUhs+WJjuMKGFmkQSnsgwVbNPvDNRhCq3a1pm3EBgb2CAeEcV9RxICdoZqSVOqSXnfzEvm8OZ/DM45dRhMPvS0/1Ui4qW0OAtpXvRsaKIYtKn3tlCXeFgRIy4pibtggvX7eSYL8ZC4CJP42eQ3fLInW8fg2VsJ4wunWfYFmhZJ5ODPcw134IflqtAzZOfojemOm0IoBvb/VuIU8LSIk2mCB6CODpwmk1qEAhJ3Hq6osZw8TjTlmcg5GLNDkmFjOggNjJlDqlcKFzBXK3iXLKEp2Iip/ZQQnbqsccmaLn5x6ewqxbkP1Inw/ID2K1p0h4h07i69EGgfpanDJFWn1PEnF8zhTTqn+7n3ELnpaALF9zCNb12WHyXeFomZINpbz4nO4mPUihLXr9gBzy/oNQANRfZmKolCVgsRB7m0x8BDoOvM0o94ngsYNZmc4dO6Ud7H3Hy91te8JIbS7sZQrp+jbi5MgvDNjZWj2g/giL3fmqAmETGTSdYUDRP71sUvhTZ2ie2STEk+kOIaYL1WzXdEBORtskiPndwcbLunVWwYIdvErFFFfD1NkJCafF1JMq4u08aoe+KwJNXhQdwO5bwMr2dvjz7B4xbiOLm+HzspwMgkP6xcPnrQWlaeRZDUdo1aHV2WIf27YRTvgJ/nuEzOBi/iIrVXgMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199018)(33656002)(83380400001)(316002)(478600001)(54906003)(7416002)(66476007)(7696005)(52536014)(186003)(71200400001)(9686003)(66946007)(86362001)(38070700005)(26005)(8936002)(2906002)(66556008)(5660300002)(41300700001)(6506007)(64756008)(8676002)(76116006)(38100700002)(82960400001)(4326008)(122000001)(55016003)(66446008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9HVDr0MW81/ZTmfPQpr961lFUVxAq/Qhjt7R0xLxre0oPXb234x/DfQkucyy?=
 =?us-ascii?Q?kYcgXBpQa1z3LuV8dK8upADDJsjyd+z/2srBufxZGUD4g+tChIWoWQ5bsR3C?=
 =?us-ascii?Q?N2tUCNjmqERvJubFpLaJb/zuVZr0l5c7lVBI2Nb/bUERihviDb2PJR4QDV2J?=
 =?us-ascii?Q?V2qdkT8fTMB9NOIfEjZep8zDb7Ck244h5u8AZq6x6ZT8GFGVmtmEXMUbis5g?=
 =?us-ascii?Q?evbGu0ndVnyCCCbXRtqg97XqK+UJ1LB6kX6cTZLK4E/lUusEGxkf4YLU5aQF?=
 =?us-ascii?Q?y39Mux3XggGCJotF13mHcF6xNTUhpG9pdjN+sxlf+E07a+ahcSjKVaK2BAlT?=
 =?us-ascii?Q?OLoyNHzKbvnk7FiZ4koe7BJ+v1assLLVrGgh5zdfL9oyVIDQ9n8kBe2XY2xY?=
 =?us-ascii?Q?0R6x6SI4eR72Ypo+LQnU8L+ZCvlb0fopL63Wq75OcgfNID4HUoGr8v4858f5?=
 =?us-ascii?Q?kT6fZwLStzPXCmDKLsbH/YQfWIRODW6cwVinCVU8XRKbDFU163ZUiBk3EuGr?=
 =?us-ascii?Q?VPQtUc1pRRZdDtf0CgbqR+tn/u9IsGscchfE94bI1fNMrolg9QfLw8OEkB7F?=
 =?us-ascii?Q?8svq6FeuXEDz8uZ6/zLjxrTI4WbPD6hpX1HTrodXYTXoEtCV5ufaPNq6aNTX?=
 =?us-ascii?Q?UEQ2ZV9JlDvvl2jRyijHl5y6I9l5VCd09PwDsu6BIrQ3G4RLIxRHaCUGmGyT?=
 =?us-ascii?Q?ZDbVNDlIs25eLMRu40/TB6Ng/1eYmGjtuES0Id8vDW0uVZ0Cizj4qf08h1zl?=
 =?us-ascii?Q?4qKicY2VTmk6KXJsxcuvrpKdRcHQbpEwOQFC6Inpx7XIUAKgpWnsJMC7EbCS?=
 =?us-ascii?Q?Y7Y6XRc6/KO0xfJKupyYBHo9uUIfY2+t/0/oHZYmV69za34gorK4YmxrHIoE?=
 =?us-ascii?Q?4/W6S4Z6i4+3phdF2Wuy7hCI2ekFK1zUdblwAMsuriTnXWFbV+VrQCTQgOp1?=
 =?us-ascii?Q?71Z3SiWOUMA8rsCW45Yhfa6Kw0sc/rkqVm1iDEfVLaR3Y5uuTB6bXHSDhrgl?=
 =?us-ascii?Q?nZQvHMuQ+rjMB1DBNaw1Efb5OHaH1B/mynMl3kfDXwg7zsWXpIxYlxW6N75K?=
 =?us-ascii?Q?qu63HkOO7SonTA8AR6YqELBD90qZtG9dHoMVInPRIpXrS9rJDflsv8/cgUzW?=
 =?us-ascii?Q?HccYXqoppLJg65MDPO7pQxQSeo4NkZ3UvRUr9YPScyqVbxB0iwYbHFCUqhao?=
 =?us-ascii?Q?WzIb4NE1JyPfMeGXg4AtHEOTgsKK36tKBpfxpj3SzX8iHAEfyXJvVh7DRCg8?=
 =?us-ascii?Q?l2Oq/6GfawRgdWYcWFfiskCQdVudBxrkfMm077TGlFYy0GE8t13UAxNZtJ2w?=
 =?us-ascii?Q?RFTpcmzWNN3rMHCe9T0Wfa9UxU+69TWTHf0IxQvO6idJdyCkTDdfKswsI3NX?=
 =?us-ascii?Q?RFU2tDnmz9FFlXUBPp2+oWxCMDP5D5Auw8ESaFNwvttWLituyxoGretsx4LW?=
 =?us-ascii?Q?0PNyzsh+95cgVvAiTKcAvaO+l1jfcHjU+Zd7d5OOLCVFHs1tSzM3hMVOccy7?=
 =?us-ascii?Q?AEStMmEIGo35b4teTUEmxjdroMHXhU/x95iuan9/otJy+17Z3FViw0k8ZZ1K?=
 =?us-ascii?Q?BhvJ/5BVbHHwN/yRM0WbI7EB3tsMzVrjeGHyLkKW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9d7ee2-3a9b-4c1c-2675-08db1bb48e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 06:57:30.0406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lf06bOsmkoEptgiwNeV8KjTkBDGOT6Sfp8GYhdN5o2uG3P/A4dqksJYPiNeWwggan/ob+6t4vIh6iMF4ID42TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 2, 2023 1:47 AM
>=20
> On Wed, Mar 01, 2023 at 09:19:07AM +0000, Liu, Yi L wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, February 27, 2023 7:12 PM
> > [...]
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    unsigned long arg)
> > > +{
> > > +	struct vfio_device *device =3D df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	struct iommufd_ctx *iommufd =3D NULL;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > > +
> > > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (bind.argsz < minsz || bind.flags)
> > > +		return -EINVAL;
> > > +
> > > +	if (!device->ops->bind_iommufd)
> > > +		return -ENODEV;
> >
> > Hi Jason,
> >
> > Per the comment in vfio_iommufd_bind(), such device driver
> > won't provide .bind_iommufd(). So shall we allow this ioctl
> > to go longer to call .open_device() instead of failing it here?
> > I think we need to allow it to go further. E.g. leave the check
> > to be in vfio_iommufd_bind(). Otherwise, user may not able
> > to use such devices. Is it?
>=20
> You are thinking about the crazy mdev samples?
>=20
> We should probably just change them to provide a 'no dma' set of ops.
>=20
> > > +struct vfio_device_bind_iommufd {
> > > +	__u32		argsz;
> > > +	__u32		flags;
> > > +	__aligned_u64	dev_cookie;
> > > +	__s32		iommufd;
> > > +	__u32		out_devid;
> >
> > As above, for the devices that do not do DMA, there is no .bind_iommufd
> > op, hence no iommufd_device generated. This means no good value
> > can be filled in this out_devid field. So this field is optional. Only
> > for the devices which do DMA, should this out_devid field return a
> > valid ID otherwise an invalid ID would be filled (e.g. value #0 is an
> > invalid value in the iommufd object id pool). Userspace needs to
> > check if the out_devid is valid or not before use. This ID can be furth=
er
> > used in iommufd uAPIs like IOMMU_HWPT_ALLOC,
> IOMMU_DEVICE_GET_INFO
> > and etc.
>=20
> I would say create an access and harmonize the no-DMA devices with the
> emulated devices.

How about below change?

diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 4f82a6fa7c6c..e536515086d7 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -18,12 +18,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct i=
ommufd_ctx *ictx)
=20
 	lockdep_assert_held(&vdev->dev_set->lock);
=20
-	/*
-	 * If the driver doesn't provide this op then it means the device does
-	 * not do DMA at all. So nothing to do.
-	 */
-	if (!vdev->ops->bind_iommufd)
-		return 0;
+	if (WARN_ON(!vdev->ops->bind_iommufd))
+		return -ENODEV;
=20
 	ret =3D vdev->ops->bind_iommufd(vdev, ictx, &device_id);
 	if (ret)
@@ -102,7 +98,9 @@ EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
 /*
  * The emulated standard ops mean that vfio_device is going to use the
  * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using=
 this
- * ops set should call vfio_register_emulated_iommu_dev().
+ * ops set should call vfio_register_emulated_iommu_dev(). Drivers that do
+ * not call  vfio_pin_pages()/vfio_dma_rw() has no need to provide dma_unm=
ap
+ * callback.
  */
=20
 static void vfio_emulated_unmap(void *data, unsigned long iova,
@@ -110,7 +107,8 @@ static void vfio_emulated_unmap(void *data, unsigned lo=
ng iova,
 {
 	struct vfio_device *vdev =3D data;
=20
-	vdev->ops->dma_unmap(vdev, iova, length);
+	if (vdev->ops->dma_unmap)
+		vdev->ops->dma_unmap(vdev, iova, length);
 }
=20
 static const struct iommufd_access_ops vfio_user_ops =3D {
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index e54eb752e1ba..19391dda5fba 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1374,6 +1374,9 @@ static const struct vfio_device_ops mbochs_dev_ops =
=3D {
 	.write =3D mbochs_write,
 	.ioctl =3D mbochs_ioctl,
 	.mmap =3D mbochs_mmap,
+	.bind_iommufd	=3D vfio_iommufd_emulated_bind,
+	.unbind_iommufd	=3D vfio_iommufd_emulated_unbind,
+	.attach_ioas	=3D vfio_iommufd_emulated_attach_ioas,
 };
=20
 static struct mdev_driver mbochs_driver =3D {
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index e8400fdab71d..5f48aef36995 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -663,6 +663,9 @@ static const struct vfio_device_ops mdpy_dev_ops =3D {
 	.write =3D mdpy_write,
 	.ioctl =3D mdpy_ioctl,
 	.mmap =3D mdpy_mmap,
+	.bind_iommufd	=3D vfio_iommufd_emulated_bind,
+	.unbind_iommufd	=3D vfio_iommufd_emulated_unbind,
+	.attach_ioas	=3D vfio_iommufd_emulated_attach_ioas,
 };
=20
 static struct mdev_driver mdpy_driver =3D {
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index e887de672c52..35460901b9f7 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1269,6 +1269,9 @@ static const struct vfio_device_ops mtty_dev_ops =3D =
{
 	.read =3D mtty_read,
 	.write =3D mtty_write,
 	.ioctl =3D mtty_ioctl,
+	.bind_iommufd	=3D vfio_iommufd_emulated_bind,
+	.unbind_iommufd	=3D vfio_iommufd_emulated_unbind,
+	.attach_ioas	=3D vfio_iommufd_emulated_attach_ioas,
 };
=20
 static struct mdev_driver mtty_driver =3D {

> What should we return here anyhow if an access was created?

iommufd_access->obj.id. should be fine. Is it?

Regards,
Yi Liu
