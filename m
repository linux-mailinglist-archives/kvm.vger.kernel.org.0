Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879A742ED7A
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhJOJXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:23:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:2093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234769AbhJOJXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:23:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="291365636"
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="291365636"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 02:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,375,1624345200"; 
   d="scan'208";a="488059586"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 15 Oct 2021 02:21:37 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:21:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 15 Oct 2021 02:21:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 15 Oct 2021 02:21:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 15 Oct 2021 02:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM19bQlNL4e/jz2pMPzKFV8zNTSeLnjUxaZ6oqo6BXz66zCTjp3JqhwVpqpZ5WRLQiYyuXBh2dAJHdIILTIXsX01Vf837YJHODJJMM0qciym49TqrkPBfMYrom9ABgtx3T84BzUYL/gGIeRr9+tKPZ3ojM/I2pvlWEQsMDHdm1fSjov1p40a0T5x3DE789yb6PC6g1yDJqy+1+MOqlhhPtxNNMMP+TJ0lGWZp4aJbjAPIZNyQU62sBT7TewDSwG2pfCjMkID4El7eo4Fqc5WvP0VQcCIRcbJy92LMuOPCQ71ayP+rFixGNDhCTfu+uwKCP7AL03Cbf6NVpwD/d2FWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3/CRa8PVHPKs3aYYq4nl+9WJBdKMR+25TpVwzXnCqU=;
 b=IycWUIqfCN3J3WrBHe9Uec0wszHFoFgLjWyWcv3oBYpF8pw0bMPW4AO2rYfuNGOOjQA0Sj3oWRQmdBb3cq+3beq4dGsKsaq3RwqZZxOedTP1erZOvWoBZ2yZzagwJjRSjoeF+yK1rHb3d6Z1qTYcr/WwBBjHh3TpZ8C8d+kI7ysngmMksxiaB5kICR1qRCYsyagttfsPv3/9F1jnBWbIiL7Nm81vE4XrtSebN2gOYYB6wP1Rb1DscT9hqRC++MyGw5OtJGpqjtfX8V+XjiHFti7Gold4DulUq4WIAriI8SXzf5J6mj6wdF7kWRM/DPrb7LnwJ7CIFBGBSJozw7RHNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3/CRa8PVHPKs3aYYq4nl+9WJBdKMR+25TpVwzXnCqU=;
 b=weCI5/xg1y9gx0y418qJfuqiXJ7iWiM34gNpKdL0CvDd+bBSL4JGDFzKmqYzrHDuIxhYg3p0te+wQaOQ5qd0P8yxXnXmWLczkQ+2s9B/jpjfxL+coTvOEXsMaiQ9FTaFsAbGiyycDrEv3YgcrA9xArubY+8rqEOqOEjuH091BrI=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 09:21:30 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Fri, 15 Oct 2021
 09:21:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Thread-Topic: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Thread-Index: AQHXrSGDMw0OcdJe2UaVTake4lDKuquuvgWAgCUzJFA=
Date:   Fri, 15 Oct 2021 09:21:29 +0000
Message-ID: <PH0PR11MB565826922F160F541249FB0AC3B99@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <20210921171431.GT327412@nvidia.com>
In-Reply-To: <20210921171431.GT327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b030dbc7-656c-470c-2f9d-08d98fbd2c1f
x-ms-traffictypediagnostic: PH0PR11MB5580:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5580E61E303CD0508BBCC04CC3B99@PH0PR11MB5580.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UN+ZUCIMLCXTVMGaWgWSYmWDaYWebJmS5D8L11HcOpNbE6ZJSULoPnWUMpFOOvwv4DsRYm5Y9T7Nnno8owagVGqL7CICWwCZ1iMp/8GvEX9L9ifL81rVfXu1gYFIcMgiFPtqSEgSHZyzjduDglefLTZ5SRlHxdjZuD+BTa9sTyFU8YquVQOSMpJDNf6XEhr792zaF9IpvpsEkSdlwo2/o6NTvUfJD2XUI0Q/z4ttVaN5R7HixqZs2ggiegERJmXFdIdRAahVFD+juM9m4m07aGX3spRvItaErbrEDtGYzyuq+sztOs33y4nvdU00dueA73qFjAr6NZYGgm71lV8KhQCUbkXeFVlhYsGNyU0uqqXc7zyXYhr7biTOkfBvw3YQZgKle08eLeJirR2VkYJZ56ZAKQ8FW/y2OFewo/qlNKBVZHnMDhm1SvLW3fLIMQfGQ2trUMhMq6nJLglB3rEl8kEINlPqcll1C/r+b0MsC/94pMsDoHfbzu3jBPgYReldABfASpYgvzrXK1ckb3s3L57M53KDeN+xcqZzvCKXZA81+mlgWdHHWaNIsuyn+01MJInKWUZu4t+3shje296+AjiPhxNbzm8i/2+8r0l1sIDBvZWijzpL4E7j6bx9eduOehoaDhjwQmthceV1i8WNNzHUANy+5Wk61ORAZPZhMItWSE5kBwBZMqoXxTjuYgp87W9Nz5HCjcgGbs2/wSZiOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(508600001)(7416002)(4326008)(82960400001)(33656002)(54906003)(6916009)(86362001)(76116006)(26005)(71200400001)(5660300002)(8936002)(9686003)(66946007)(66446008)(64756008)(66556008)(66476007)(38100700002)(55016002)(316002)(38070700005)(8676002)(6506007)(52536014)(7696005)(186003)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KdQOhKLRkH8YH3dn7SoPua15luSJMDUNBHWiWhHz9rlRGyZvlX3Dz2Bu/Hjq?=
 =?us-ascii?Q?ddO/HayYCln4P6ataybz9rmQ5nLOOJJ5+xfZX4D4bIvj0mMBk0TzlkDI5XsV?=
 =?us-ascii?Q?6hSyuN+5rggeL/G42+bH/nsRBUDIJoTetHOEB6L9hRw/gBxVmkawOHeILxvD?=
 =?us-ascii?Q?pLEO7ZLoz452u9/92pe4DIaere5iTOboPAq4g1p2EcT3ajmOydpA5O5O3rXt?=
 =?us-ascii?Q?yTw72Yfx8hgcQlaFsS5uj+pu4Speg2qNVK744z6mirQDIyqcQKmfrO5VKwqP?=
 =?us-ascii?Q?kwLxenL98HsOOe32gGi3+FrUkDHJ4TWf5ZPwdXbOl+9lGAmiklm90JZGP4rq?=
 =?us-ascii?Q?Af9i64Lgg6+YnfMRXSUaE1w65X3q9SyRARodS3AWepe4gVDJXO88+rlFYmGS?=
 =?us-ascii?Q?UH+lBM+ioQ2u77vJwXFrZiwNCzUJZR5aiCUg21hFqgTpiAn++Qxjv+r1qjqW?=
 =?us-ascii?Q?TbNGw/gJk3wdrtg7pvNY00c258hHcPMxEeyNgPdFA6cJQnV3V1z3gJrX+rar?=
 =?us-ascii?Q?YZdgu/H/r1lEDeOeXV/K3+4dg8Kb5/aGcMANAkEhwLQ1mfUyACUbHDHrS3es?=
 =?us-ascii?Q?hJbH94RZaSNW+GLYhXRnOlacUchSKQq//0NKKPnyPmcgtw9Igcwx9bSEftB/?=
 =?us-ascii?Q?ojb+zf99+t7wosjjqgQBbZKdrnc7/SAfTXF/M0rWZFOFX765NrXZeh5MBUU/?=
 =?us-ascii?Q?ysRZZmvOyab7nFvLpFqqln9fRWnz4mKZX467SPkxxg8gpsc6LMLlqPuRGrXA?=
 =?us-ascii?Q?Z0Nch54/PCAtdX/iMxJREjowKIBlSSFzdmXuP5V3KQ9gJvAntbM2rpA+W3ZI?=
 =?us-ascii?Q?2NJ9CdgaRGPjsGMHG4MT+qglCXuaEoQcxxQXFED1K1gjoft472J0S7u8CMyW?=
 =?us-ascii?Q?CJIvGSVQQ9VDBG4wTpTpt6hyU3M95TyeFiNXBANBtTNJZ74aigTY5c8ETsYA?=
 =?us-ascii?Q?fEbJOEOx1DnXGcB7kEVc5fbrm1m53nu955PqFyCpfnfEThr57z+bg0/QvN05?=
 =?us-ascii?Q?XciXc2FSEcARaxBptMKt42HztAvbsz7KW5xnvY6amvKalY5MRBnxM0n3NHKz?=
 =?us-ascii?Q?dA8oYf/d8AxTnPnbDSCpeBSY9Z/LPYxY53dmICnAQkZLXresVoJ81GKH+zTZ?=
 =?us-ascii?Q?84fslJ93VkaKLiv/WmPhCZTvUAWvWABGYJjSMmtKqkVTMvCl0/vqO5a2WJGI?=
 =?us-ascii?Q?yqQxgZTVmGJ0StjsRa4ABXg3ixZi8PRNsJ0QQxZNCSFQ9TaxLKA9XRKEQMXl?=
 =?us-ascii?Q?GtxLw97t9AH+hiX4dp0Ww6Y4l5cQM5cHDDhShO/8idOuQLDC1xC3m0Injs/C?=
 =?us-ascii?Q?v1+2lAiTVzg8DQaeqI4RGMI1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b030dbc7-656c-470c-2f9d-08d98fbd2c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 09:21:29.9556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvuHAeJJVCgVdBi+rtQ5CfFcHE1CXjCzeqP+LHDvN8sUAo3aNQri6/XkXDiaiqjH5nYbH9it+TpRBn22cbSAVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 1:15 AM
>=20
> On Sun, Sep 19, 2021 at 02:38:35PM +0800, Liu Yi L wrote:
>=20
> > +/*
> > + * A iommufd_device object represents the binding relationship
> > + * between iommufd and device. It is created per a successful
> > + * binding request from device driver. The bound device must be
> > + * a physical device so far. Subdevice will be supported later
> > + * (with additional PASID information). An user-assigned cookie
> > + * is also recorded to mark the device in the /dev/iommu uAPI.
> > + */
> > +struct iommufd_device {
> > +	unsigned int id;
> > +	struct iommufd_ctx *ictx;
> > +	struct device *dev; /* always be the physical device */
> > +	u64 dev_cookie;
> >  };
> >
> >  static int iommufd_fops_open(struct inode *inode, struct file *filep)
> > @@ -32,15 +52,58 @@ static int iommufd_fops_open(struct inode *inode,
> struct file *filep)
> >  		return -ENOMEM;
> >
> >  	refcount_set(&ictx->refs, 1);
> > +	mutex_init(&ictx->lock);
> > +	xa_init_flags(&ictx->device_xa, XA_FLAGS_ALLOC);
> >  	filep->private_data =3D ictx;
> >
> >  	return ret;
> >  }
> >
> > +static void iommufd_ctx_get(struct iommufd_ctx *ictx)
> > +{
> > +	refcount_inc(&ictx->refs);
> > +}
>=20
> See my earlier remarks about how to structure the lifetime logic, this
> ref isn't necessary.
>=20
> > +static const struct file_operations iommufd_fops;
> > +
> > +/**
> > + * iommufd_ctx_fdget - Acquires a reference to the internal iommufd
> context.
> > + * @fd: [in] iommufd file descriptor.
> > + *
> > + * Returns a pointer to the iommufd context, otherwise NULL;
> > + *
> > + */
> > +static struct iommufd_ctx *iommufd_ctx_fdget(int fd)
> > +{
> > +	struct fd f =3D fdget(fd);
> > +	struct file *file =3D f.file;
> > +	struct iommufd_ctx *ictx;
> > +
> > +	if (!file)
> > +		return NULL;
> > +
> > +	if (file->f_op !=3D &iommufd_fops)
> > +		return NULL;
>=20
> Leaks the fdget
>=20
> > +
> > +	ictx =3D file->private_data;
> > +	if (ictx)
> > +		iommufd_ctx_get(ictx);
>=20
> Use success oriented flow
>=20
> > +	fdput(f);
> > +	return ictx;
> > +}
>=20
> > + */
> > +struct iommufd_device *iommufd_bind_device(int fd, struct device *dev,
> > +					   u64 dev_cookie)
> > +{
> > +	struct iommufd_ctx *ictx;
> > +	struct iommufd_device *idev;
> > +	unsigned long index;
> > +	unsigned int id;
> > +	int ret;
> > +
> > +	ictx =3D iommufd_ctx_fdget(fd);
> > +	if (!ictx)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	mutex_lock(&ictx->lock);
> > +
> > +	/* check duplicate registration */
> > +	xa_for_each(&ictx->device_xa, index, idev) {
> > +		if (idev->dev =3D=3D dev || idev->dev_cookie =3D=3D dev_cookie) {
> > +			idev =3D ERR_PTR(-EBUSY);
> > +			goto out_unlock;
> > +		}
>=20
> I can't think of a reason why this expensive check is needed.
>=20
> > +	}
> > +
> > +	idev =3D kzalloc(sizeof(*idev), GFP_KERNEL);
> > +	if (!idev) {
> > +		ret =3D -ENOMEM;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* Establish the security context */
> > +	ret =3D iommu_device_init_user_dma(dev, (unsigned long)ictx);
> > +	if (ret)
> > +		goto out_free;
> > +
> > +	ret =3D xa_alloc(&ictx->device_xa, &id, idev,
> > +		       XA_LIMIT(IOMMUFD_DEVID_MIN,
> IOMMUFD_DEVID_MAX),
> > +		       GFP_KERNEL);
>=20
> idev should be fully initialized before being placed in the xarray, so
> this should be the last thing done.

all good suggestions above. thanks for catching them.

> Why not just use the standard xa_limit_32b instead of special single
> use constants?

yeah. should use xa_limit_32b.

Regards,
Yi Liu

> Jason
