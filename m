Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418CE6A7F12
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 10:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCBJ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 04:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjCBJz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 04:55:59 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E801ACEF;
        Thu,  2 Mar 2023 01:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677750952; x=1709286952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uFrNiVkBH7SkCDQuwDaecuCq3eP60+zCQEexNlnBV6w=;
  b=dGDw+jsmXuAssoFfFEA5iZdI704xRSCOj4DImRm/U8yA7pK4L3n1NH2D
   IGQspvaYimjjSHLnTnEnOqV3AVjalfwnh7JICUeAF6bA2OAPs05nUo1O7
   IeFUXMtxGLQWLN0dtecDWmbPDq8xv8wUfugudXRIcR1BgrVWaZYLNWr05
   DK4pWoox7iDTob579L/+4xb7pDsJgMGIjOuVnj0sj+Xt0gelryyLw0o7Y
   Wj559pYlIdiKK9o8oLWgagTzBRHSz9n9dM5J80KERRDH6wgh3zr0d4stT
   61MNWH47ZrBLGevxo49fcbJ3mlrXLoIPSWsvnSClzEy/K4Mup+5i9V6Tp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420940779"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="420940779"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 01:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="784748697"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="784748697"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2023 01:55:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 01:55:49 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 01:55:49 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Mar 2023 01:55:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJIo1dYr859eS6buTLdzg8OExEERAIBH9h5+JHimHcz/za95mfMqczJXEZVDyJ1L1BhilL8dwo/F0XGzZds8POFBgeswmwIuC3Z1VPnoRwHM656oOHnPqZMOvO1Z6AC9W/T3iYfRCJ1dfpDznXvUO2LzXlrh7W/6Vhea/lcv7pTk1HMw4qEHlaLTvxgOSVNoQ3p1ZoNqWF3APypxdv5XNRCbx6IGtEgsmHU+rPbzpwDsX35JCajed87QaP4uTRMjNtJX7Xhc7eW9fjB69nore6xYYD3vG8FSBsACUs1P4BzfjhUSQH1k4mYRtXjLhh/XKWRxNhpsMuhUKrYggO/vqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMNkJwSrkP804nNOTMWyFWHBkl+qkcplrYYqiAHzxZ4=;
 b=RzxM/lv2Bmq3C4XeGgzLy4AsBec2Wy3KrlE/qCDpM8j3hT//9wgBkl+WiIe7yKz3WRgR53Nc+ay8LStfYJv+VS1BYD2FDRN5X9NuO16LH858KS5lC5e1ITiXb0mblSsInIewjHClkGfSg/udDspgGhD4KQSBSDdfTfSfSfQ6EwfxahkJWzI0/zpRs+3D6VSI8ejLuJYRVBYVU2Tst7i00yGWnLKBVpAqeKOmpVUQzbG8x8A+3NUpoOnoM6Z4Ro8LlYxJYjKJ+4eerrXI0a8IRtVTZTjFXN141T73qaghyk7AnZPbCeweKUYt9WYdGB32AmV6arXF30b+KVdMRpJ57w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 09:55:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.019; Thu, 2 Mar 2023
 09:55:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbA=
Date:   Thu, 2 Mar 2023 09:55:46 +0000
Message-ID: <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6954:EE_
x-ms-office365-filtering-correlation-id: dbd4513a-4be8-472b-3d32-08db1b044b5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VwHXG/IaiqqxSM47n2TzV26IvZMP135LkmbbqGsXwb9jvJRTjkMs6r9PweQSZxym3weqI/I2l2/kb93L6Ggk4PXRYPCrlhZmrrQWPByHZEJphVm1DknAF7h2eCdpaRpGZ0TNieDVJdugaIN0+94aHulrVqNA/SyaiDBozfysyP7trlKmd+50mj4Jozj2AB09s33ivex0DoXET67JyrXifHF6Ngj1rVYfkFkveNrayEavN3fiOKAHw3wi2wM/HEtvXah5Hyqi0yl2QdH7MpyCwIk0yTTBJmZSO6Svw28675hXfv70nARZR5ASqKtlnqFh+PFHG7GEPKglhuqk7pWmaE72wkef0h5t1kcHLa/dQewEb6prRkxsEi0B0USRZi1im4mPyCQuiZRRL70HP2s2cTCVyqKBFWJOBJgnDzT7BoR32U8AbVAm1DXIJl/siuIiylnnLfgQ/d8E/qD341hg0vfD58nWzTz8gYLdDNYjGEzTO5wLG5uiNIB6xYCAD0anipTaB77fzrWzrDn85V+ambmkhE96X0ScD4vo8QhvBgpyZj/iLB3j3Tlh0nb8IDLj3LZM4ME4SSXh12+aNyzLCN7q6rlzi6ExP+aTecQGxRsAH9Ut7otCiQ1zxuaZTbFJkMxJuhblueRc4+qx2jChGORsoqyOswxBFxE6OJeHNqu5wLAzA2B+lsOR6P8eCCAFNx3E3w2n+I1SY2cAJ1Yq2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199018)(52536014)(7416002)(8936002)(5660300002)(41300700001)(2906002)(478600001)(54906003)(110136005)(7696005)(316002)(71200400001)(186003)(26005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(9686003)(6506007)(83380400001)(76116006)(82960400001)(38100700002)(33656002)(86362001)(55016003)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+K1FkqaXjjDPZhTvn6Qn3sRJWUKKlMxED83UQt+GSM+S+lwe6WvnebkDIBoM?=
 =?us-ascii?Q?4hnz39J4ytxu9xgGadHDqZlw+olUiHpzpmmu/4xJuIJlBK+tHGEAQ1Ijw1U4?=
 =?us-ascii?Q?N/Tcj5GeTaXBmwUiVLFYt0oOF4fykEbBgbeA1BZwmbiGwneKoSrNTkafp5hJ?=
 =?us-ascii?Q?cIqeRyIEXT11Y6tNTLQoR9VXRoQAJObK6X3ZjYZyK87hD4BXCF/yv7XBVF6x?=
 =?us-ascii?Q?HbbpM2nKCVBcJMPEQenLJgc7dldMYC49iJ7TRNgbdzpwzlV4y35jaahh9Y9Z?=
 =?us-ascii?Q?v9gxm3FeJF4MR5KNBYWwGJxlLCoaZwShZJRR8ejkFcR9ruGeu8zhVWVeMVMX?=
 =?us-ascii?Q?WxYv1WR0/mJUsLeLqV+gx3YfU0F/w5rrKq1jdQWoqvlJCUyQPrAkJLgyjiru?=
 =?us-ascii?Q?8GipjKP6vmeXcewrZo6NxG/x4FILNj94v8lO4r8VtmK22V2g3MdBLw1U8whJ?=
 =?us-ascii?Q?DW2Di8SOix4maKFIvPYdtpClpAGvVAs6JPkjeuxer3TORfVGw87QAzoVj0z8?=
 =?us-ascii?Q?NA2oEv4xPdERQhPAPNo/ltWKcKTWR9WguSEefagL26zbda2/3OAs15r5ICO3?=
 =?us-ascii?Q?am5NAIlNrM5EmulJpjjOv4FYj2R1x4/KnR/ZzflXo9OPDxIc66T/G7ioAxnS?=
 =?us-ascii?Q?+yQeay9i+/1sDRE5pj5gkkMBAfDKDXWlsymf6dRQKw7LpJTdDWDV41aMtPj4?=
 =?us-ascii?Q?ryDEsFgnDPLVY8bIxOV/XzHAcDLKfWj8zm4U5DVI02+4QOAiRNMhtEWkU48M?=
 =?us-ascii?Q?XaHcgKIbZmw6DReqRuEIlD2Vjo0J/7tysgobVrGTo8I7G6rwh+y5E9sqr7MP?=
 =?us-ascii?Q?kyUnvjzTLFCJim0Fe5DQ9M4EMLdbfku6mt0o2a+1NTcyp7lajTG4HcOWJN6J?=
 =?us-ascii?Q?fMV8g1KNFIsy+Yaps3Qpv4px2nfJSRkCjqmGFrJWALtMleyDQ2LSD+9I0yxa?=
 =?us-ascii?Q?tI/haBfOp+OuV/jKazp51hrQnmQ3CLn6VWTsQMqqfJCvJNoxmJeA3aPR5H8T?=
 =?us-ascii?Q?pfa58ogoi5eZtxM4SQVwbIycoIHLR5vkrNyQlAwI2AQg8n9V+U4CnU/0n7Ba?=
 =?us-ascii?Q?+JJNJMlpq5Y8b8uUhrYcsnCZrvZ2+V6JliPaF+oeY9uB1euPt4HRtUcMEypS?=
 =?us-ascii?Q?Z7jXjhkhycjjYNDsyk/CEAWwUrJOwhbYN+2oHCFK7gJTmWIz/+2OklwmroKq?=
 =?us-ascii?Q?nnTfsl9T8yt+TDv+2XzjurCBTY6tcRGCGx+zptGF12iO15B1h8j4JMMHeuNF?=
 =?us-ascii?Q?ecMuBJFWWXej09g40oYaPsz6px1ujfN7qfBd5rd1616fuJEsBtnKntvnAjbb?=
 =?us-ascii?Q?mcT3M57n1hoiJLLXkia2chpmOP0dU/lwuQrJ5FRTrm4gAlPzheb6HCUj3kza?=
 =?us-ascii?Q?Dz+DI3TmmUsOhKQApyA1yTrX+0IvWt9jxitbPpdde6dn+Dkv6OsO1+YrnwXq?=
 =?us-ascii?Q?s1BvCVjjgfCm29RDDFMa/yGZjKfP6mh7Q5KYnjxRC92NiS3S96CLs9goRGgl?=
 =?us-ascii?Q?kCVh+KIAdfk+lmsvIOxmvzx5QjS0aFeKMj/JWNqLzzPkVIj3Hz6LfIWIHbLK?=
 =?us-ascii?Q?8naJ4jGff1a0VLIwpiz0KLApFYo0xZFZ9E5MLQ4u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd4513a-4be8-472b-3d32-08db1b044b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 09:55:46.0718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HyPompe3Lpis+hUtyC9lhH0xRXscXV9fjJI+o8GvoNoTEUhg2+vKd1yjRgEKXcWaaSIPvccXWh0d5rzBikrABA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
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
> Sent: Thursday, March 2, 2023 2:07 PM
>=20
> > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > +		if (cur_vma->vdev.open_count &&
> > +		    !vfio_dev_in_groups(cur_vma, groups) &&
> > +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
>=20
> Hi Alex, Jason,
>=20
> There is one concern on this approach which is related to the
> cdev noiommu mode. As patch 16 of this series, cdev path
> supports noiommu mode by passing a negative iommufd to
> kernel. In such case, the vfio_device is not bound to a valid
> iommufd. Then the check in vfio_dev_in_iommufd_ctx() is
> to be broken.
>=20
> An idea is to add a cdev_noiommu flag in vfio_device, when
> checking the iommufd_ictx, also check this flag. If all the opened
> devices in the dev_set have vfio_device->cdev_noiommu=3D=3Dtrue,
> then the reset is considered to be doable. But there is a special
> case. If devices in this dev_set are opened by two applications
> that operates in cdev noiommu mode, then this logic is not able
> to differentiate them. In that case, should we allow the reset?
> It seems to ok to allow reset since noiommu mode itself means
> no security between the applications that use it. thoughts?
>=20

Probably we need still pass in a valid iommufd (instead of using
a negative value) in noiommu case to mark the ownership so the
check in the reset path can correctly catch whether an opened
device belongs to this user.

That implies we may instead use a flag bit to mark NOIOMMU
mode and in the kernel also has a noiommu flag in device
file to differentiate it from normal case.
