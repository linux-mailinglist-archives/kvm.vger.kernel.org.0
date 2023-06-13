Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58B72E357
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 14:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbjFMMuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 08:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbjFMMut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 08:50:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F17610FA;
        Tue, 13 Jun 2023 05:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686660649; x=1718196649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rXqXvxTBBCW5a9QHBwQNtqEc3Yye3iHgGBTPmpfgTe8=;
  b=VaiFDiWURZ2e90hBbrNThlJtaMESZPcl5pWLaY5D1n/aP/4Fe2uA5Zvm
   9UXjGz3/8erwt0EseGPajbyUPqamQpq3UOLS4PIaOANdkZaSBxgknH7Bu
   cpbVZ1AVQlUPKw6swB2ByfPGP9hetZwu1GLC7P4l9d3+icF0vT77D5v93
   /2azI03oNmm6TbKybAg11Qul13aGwb5TiwdLio92EwSeuypYM7I/mOOhC
   jHpyddhcrn4SRaukunu5atxgdF5zk3NjBPh+9OUZIs8ksXRdws9ayygMd
   JIlcf9Xa6Y1lSXTLmHeoqjVtRRZLQdNiWKsQmG4Pzv28LIqEZeAARKiVz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="421913697"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="421913697"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 05:50:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="1041758057"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="1041758057"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Jun 2023 05:50:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 05:50:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 05:50:46 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 05:50:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5kDKuHVLasrLwqTpWzdQl5kbSvwzyq8eL06f2MQbmpncQK1aj7ubiaR277siqpDLgJKUIsa8GIfywxo1FdiO5qqwhX7kawSsxVrPhAzHaFw4B9nAi9BS26uf1waps075vE8VS0hPl9gubxafgYuSgiTB07YB0khDxJoN3hC1A4hqpbtFvepXyVSoIaG6XOIkz18BFPou5srLjC5FRX3lzURpl24HhkCPpL1PBWD8Ze6cSQ33QmqUVoVS3sk3ZCJv8QozrJlzZtAeHTkXm00aZ15sDSpoHxg8Z9X8NT+8EQuFw4L3XpP1KyrQ/DiMEXG/EYvwMRPuxxKYY067EeJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJlf4IYghfxxR/bbzJ59cZiSCURezIpUMaC1n2653G4=;
 b=aI48mlrlGj79nMxKKg6WMZrF03QVpcCJuTQ+ZbaoefjYes61Vu0eT1n1PLfnfOcXmtEhIngePFeT+8z4BqXPAkAepbtEZbwEV3DYUiIgSbuE9wzp2ed/FnhGie4nyJtk7VQ5su8Ec6zfInv2Fa7cqzFzBCtMaolLoaOboR0eyytpzdpbBWtvn9Ju0VJ8v653HGL904Odipbp/b/zxk8TkhbvC4k8cNyXLuNm4WmPlEWLXD4qh+4pv2E5VPFp7a3J9iJKNsIkOjUOD2P8L8PsvuFekm9O8z1Zrvuho3d1RalbuGuVgC11P+3+F43eKfhKE7ECC/ky5zZeRdso/84Q3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6419.namprd11.prod.outlook.com (2603:10b6:208:3a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 12:50:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 12:50:43 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZlUvxjWjQHBtl702niB2RsWbvNK+IruwAgAARHmA=
Date:   Tue, 13 Jun 2023 12:50:43 +0000
Message-ID: <DS0PR11MB7529CFADCF0D6D6451E4F92AC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com> <ZIhXMmYjCyUdlGxe@nvidia.com>
In-Reply-To: <ZIhXMmYjCyUdlGxe@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6419:EE_
x-ms-office365-filtering-correlation-id: 8c89c224-cb40-43c3-3dcd-08db6c0cccfb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2EWtzIkEdrzlsc/loNV+FR4W1SZfJszW3suA+JsdzhFoJGVtVk+GggxENzA4wUUYzJH5N3CUYvRhpmv6WC76p4H8CL7hOOC/QjbLZEjKfNo2KGXgG+erkCrVDgJ6XfbMbwvLzZkfrlbzE2jyzCghgdTBWUBWISf0u++Aia7DyHg5wtCqrBSM8J1/t5ekGxHgz+MPW+lMslZa+HJugFMpantPSRBHbQWbuSxJKdUTZh1nxrHJY+uNBj303/JhDNGN/lfRm/t+4WIIeMT4EwZM/hTDOQCjNp7IIY6FAm87vykEVFaAQEJiWRu1fRrRIILFFNuwyorTn83MMXU+X5+ZmJLlt0/i5bpRT+W+ymydiyK0Ref2ba/1lTX88KrTy72GSQZaBaAP9vi4iOK8r/zIb2eAJwxNPiK1iC88fZkHMv5N63exAunYreSydfESTkJJW90HmHNT9BV7X/OmWXHc9fZdVyhPtGn9nI8DW8vVv2k+UtLgl+vbUI5cGLIJu55GWKJL+0D9/oF7UHongHuZgeU9l5Xw04wo7iG6PAz//BD1CPb/4bnvL+Mo7HoX1R42ZhFNn9jxNDvc4hqaOhgzqbyNzBjn6imuIiRuST6aCMlL0nPrJB985NpFgJcfxHg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(38070700005)(83380400001)(122000001)(55016003)(33656002)(38100700002)(86362001)(82960400001)(478600001)(54906003)(71200400001)(5660300002)(7696005)(64756008)(8676002)(52536014)(2906002)(66446008)(4326008)(66556008)(6916009)(41300700001)(8936002)(7416002)(76116006)(66946007)(316002)(66476007)(6506007)(26005)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xKglft5pVPMPSZj1GPZ9sOZy4Mm/4mMHH7jIlUEA9kufh84Yb+gSJj3HSaUL?=
 =?us-ascii?Q?w6OcKCcMIErDZDVpYVyaZqG1GGl1UiVLYSoBX5gZOsSBTQKGhTLocghv2rcm?=
 =?us-ascii?Q?TdNMG9OylgQpQYLZfgXModADcigw4mvBw5BR61r3V1RM0CEQHw9+T6aHuJX3?=
 =?us-ascii?Q?WTqqF5j1FY8FBDQGt4ZYPNowoT29e0WV/wKNxNtqhBnfZ4PawL4Q3x6iIK92?=
 =?us-ascii?Q?oIrXWEPVDQw5ZvSzHs4lBq7R73jn+CvTSpJzfFbh23Rqs3+14SlqYooOPDge?=
 =?us-ascii?Q?Hgfbm8oUXwlEvjHKQXe280BQCzwJ0n7Y1rYpRB/+CwKRhTSoO0lOYjW8sWN6?=
 =?us-ascii?Q?QfbU4avwrM7rqcO+d/mN6yzWe1z2JVPvR+Dh/P1YVPNBnjdVI15bzgUccc3k?=
 =?us-ascii?Q?7P8VzC5XMGzmtrQro9rU8CaAtBzTt02PtKPjK7xVorBu3KDNQfptLaNCzmKb?=
 =?us-ascii?Q?qvLs88BD+xm0MNlzsuJuEjLA+Ue7Bo6vRovzb4sfOs/AHciFpKmyQbJbES3z?=
 =?us-ascii?Q?gC32Ywi2fB7EnSmAVDiRcz7BKNzORc2XtKH7Hz0g+P29Kuo87urhkyxnpyXS?=
 =?us-ascii?Q?17T/+Qlq9vljHXeTiik6akH9jY9u/vocI5JWRVcSZhzlM+PtmRBHF+UF8t5m?=
 =?us-ascii?Q?P4TciPg0vpZTX4zVSCfmEDPtS8uaVmpaLnib6QJPdjrluWqXYp+7FHZwFsLB?=
 =?us-ascii?Q?5Gdnmjlp3SMMkHS6hqBgFwSLtGd0FuhHTBKMDJ3/NaMevew6YwXRO2ZFRQxx?=
 =?us-ascii?Q?Zde6SOtLO6HiFIxIulH9RsAAmWGA2mq1aWZ1SUkpAtwWwjygP4lawEKYvITt?=
 =?us-ascii?Q?Vb93o1R3f3M78bvz0zDSxb/0+zDyAY/8/Lvu+XYuAjYEwR3I2DEVLe3EiL37?=
 =?us-ascii?Q?IVWwsJCSytISCPSDJx/mOfCF2N+7eYnXfGBAsQ9TOgrm8Eac4rS+UhuSPO2U?=
 =?us-ascii?Q?qstPhye1+KmdmH5oeprIeyUzT4c2Ak1tBgCtCFPhMrbRXI7Df3XhM0Y9abM1?=
 =?us-ascii?Q?+AJWb+oqbJXND1JXQyZXOM6CkxW6QxqduH8AIzhvV3Xpi1aVK+izlSG7WMse?=
 =?us-ascii?Q?039mJJA4cBJe9iQ3Row6BjaBmZ3V7Jk768m+anJGzJKMM/CbImGoAumbq2/X?=
 =?us-ascii?Q?o+I49SBQ5amBT9uha9GXwcv3ewhwSRgkLNZ0WpJvBo/HmN+Zz/UdoPGgkZ3x?=
 =?us-ascii?Q?LqBAitqC+V0slesevuQenahLZd0iEAA7qS5JCNaLWEC3DgflmtSeCNGiY+IQ?=
 =?us-ascii?Q?FJrkSYu8Tq6vJ0Jj3oArb+tKTZYk0oORFLD3UEutInS7H6Vcxbkc4WWAKQZs?=
 =?us-ascii?Q?RXY4uiglU8IahJNvJgBfF4D7lTzgSQnGERbqr7c7KRiRb7h5agpa7S7V9RnX?=
 =?us-ascii?Q?Jt7OVFlUz89+/jaxDYMpF+oiNcuGA85SDfJvtN69vtRSSxbdLT1V6sKkxVwu?=
 =?us-ascii?Q?Cm23AcJxDtE1xjKw9spuVjqU+sDmLVxcmRkDad+8kkNV2TMTUTfJWl/E7uKW?=
 =?us-ascii?Q?RbsDmW9TYrXiBzSKQh4x9lgRhjiS2LEiErmZJN8nfL4ndjW+I8b8njeCEIza?=
 =?us-ascii?Q?iF/YKV15J7meOnCsc/DSE+SNosXmQWSPZAQL0jDV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c89c224-cb40-43c3-3dcd-08db6c0cccfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 12:50:43.6885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kPc0GDVvc0MuT8F9cM2VygccoaTNw51/eGlQeqSX7H++u3Qo0Yoi81/FQ+VAA3iYMdfdKtnHal0RDB9vvHc9DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, June 13, 2023 7:47 PM
>=20
> On Fri, Jun 02, 2023 at 05:15:14AM -0700, Yi Liu wrote:
> > +/*
> > + * Return devid for a device which is affected by hot-reset.
> > + * - valid devid > 0 for the device that is bound to the input
> > + *   iommufd_ctx.
> > + * - devid =3D=3D VFIO_PCI_DEVID_OWNED for the device that has not
> > + *   been bound to any iommufd_ctx but other device within its
> > + *   group has been bound to the input iommufd_ctx.
> > + * - devid =3D=3D VFIO_PCI_DEVID_NOT_OWNED for others. e.g. device
> > + *   is bound to other iommufd_ctx etc.
> > + */
> > +int vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> > +					struct iommufd_ctx *ictx)
> > +{
> > +	struct iommu_group *group;
> > +	int devid;
> > +
> > +	if (vfio_iommufd_device_ictx(vdev) =3D=3D ictx)
> > +		return vfio_iommufd_device_id(vdev);
> > +
> > +	group =3D iommu_group_get(vdev->dev);
> > +	if (!group)
> > +		return VFIO_PCI_DEVID_NOT_OWNED;
> > +
> > +	if (iommufd_ctx_has_group(ictx, group))
> > +		devid =3D VFIO_PCI_DEVID_OWNED;
> > +	else
> > +		devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> > +
> > +	iommu_group_put(group);
> > +
> > +	return devid;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_iommufd_device_hot_reset_devid);
>=20
> This function really should not be in the core iommufd.c file - it is
> a purely vfio-pci function - why did you have to place it here?

Put it here can avoid calling iommufd_ctx_has_group() in vfio-pci,
which requires to import IOMMUFD_NS. If this reason is not so
strong I can move it back to vfio-pci code.

Regards,
Yi Liu

