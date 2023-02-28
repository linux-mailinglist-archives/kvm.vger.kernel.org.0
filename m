Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B76A5A7D
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjB1OBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 09:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1OBu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 09:01:50 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0B92B62F;
        Tue, 28 Feb 2023 06:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677592909; x=1709128909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XdOq00opwOlPE4D9mlKlAhQURJl9wZr26pau9fb+PvM=;
  b=KBaongkWCJ0N+mZTYpqlx1pc8dIMMSewk0yYYT9jVHwljiuh7hy/USCH
   7EKEmfBa8KYP48XGnt7O1Ugv7GgR9wjQqcmGg7F0lv8uT/QKp3RFm+XkM
   2j1AogF74pd49XNMTTuLIoTj2LaZdo4Nh2MuO7hDi7GeeQsYjPYL5XiiV
   AdByXFqdFQLA3/OJsP1Ez9O/PgOXnwaDCkTGdRjbu7vZNsewGaDHtAT3Y
   gbBjgw/sVpB2Uguzp1NXkyxJhLxndVkTNR8GYt0sHdaYijSmn5DNADQIJ
   h5Jod6pau4PqtaP54kL+Fk6+UXMU9CIbyr3kQchjoKUxmshCuhDFUBvue
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="361703221"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="361703221"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 06:01:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="667468192"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="667468192"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 06:01:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 06:01:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 06:01:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 06:01:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dge1qN/cvGTcXkQeUNpHO95hN1JAwczSyNV7Xfkk4Ae5hq7C7FQdQmmTrZ/ha7lgVcYUgKt/jXdCYMCVix9rG96Yo5boIS8AVCbR/on/TYTzPJp63hKkvbgWtVDzFsNJAU49fO6h4SgrBQGA1Gr/fja3LrlYmf/aqZvSTCtHn32GbtkN4dlK7h/xTmeJHRcAANvaHw5sXRzVXoXDpyjDgZK546X1kjIDRIVuJ4pxVo7ls295orZXNmLkYjwRUD7PvevpEDXh78r9lFU4FUV1EaGAyRe2xjO9KXhOjgyfPvQXsuWzOc1T0VMPAD8+YY7Vh52nM2JJfoK7JZu90FUz3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUxRiCaxN2YFVLrF4UTpKGTGKJ5q+J7UrwWfJ1lV/4U=;
 b=mUI3ZCRVshDKYgM7MkcfVIrNh48Y5XzDfDDkT8QwILOjDa1qstWfPEy22tKWOU38seA/6MzcJg4ixeO9+vQcyBnCVeyRr/S7BsMhfQtsPcJZ5uzBJkEtCxvsSukpbnDDvugEErjWj0d16wFwDOEoAAFAIOfKvwDOeFvNcqzGlJfqU7M8jkzdWmdouSw/hZkkwFGzaKO5wN1fU8Y2IfLx70aI1m5+VTIMWwW2QUfLM3Qaazp6qLrG7PrjYjdUS3zyh1bTvdCBarJqQDppTwg5GBuhliWqZk/2BqlvojM645pMx2f1JVmIuYYfLg6Wvf0A2lM7uvVZIcvvg5zPDXm/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB8105.namprd11.prod.outlook.com (2603:10b6:510:254::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 14:01:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 14:01:37 +0000
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
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZAgAAE3oCAAAG0UIAABx8AgAAA9gCAAAQbAIAAAylw
Date:   Tue, 28 Feb 2023 14:01:36 +0000
Message-ID: <DS0PR11MB75293E34AB7C53F7ABFC0E36C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com> <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
 <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4FDP8H1qRdgVrL@nvidia.com>
In-Reply-To: <Y/4FDP8H1qRdgVrL@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB8105:EE_
x-ms-office365-filtering-correlation-id: 4f0ca6e2-3d55-4199-16af-08db19944e83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nj9I0QCpWSSUZQn+vmFjEl1fJRHdNt/qfQpDKdFSc20PdHhSwqvy6Ke7B9jTmaUv413UUwxorIfXpO4gnkZHivucpvl6xmYPmbuE6vXFW0vWCVMDv7AZuaa+NeD6WmW9Ej+PjE19z9F5zkPnN1iyl9zjuTmlLK1Sp3dkNjcU3Lvyzmzk1gmjaivAw2LYG6spEhqIC7wDsiRNqvPU7fy8Lb97aV+0pY+uO8U/p7zfg14to1RcTQfh4qSSqdUBzk0oqqLBFck/mgk6mPZW4iSuwGV6dLqMF6cpLEwaldSFKS6nuuDQPorlYZDkudVg0fLTPsFwNvLh5mR/fjGHnOaveHlUdmpLnyY6nQOuYpPkqkMPkmyear6O3MjUs1LuJJ+06yc8dtCpMnUbtywsaeNBW97BzvhODaPbllgscyR1GDy5pNabPGkPsjcPfuARjgLleyvEeWevY1ErwF4ws3B94A2PugiuVg2Aohs9gXdLx7GG3Wb8icBQvFmkCwuIkF3b5yVqrFrCfsF8CZFWx6wjE4VBBli4Rw6+LrEHdsgIAO+u9td+VQGvkil+ZR33Ut2Y8AfDBaVcnE2ARgpqwnsLBrJQ+7TgvWl3Os4ivUJXI6PfMskHOx0IkB496lLSm9ul/ZVmcO/3SRyNv16nMcM43YbTN7nCL8TYdfItNFnnxPmbC71VKtgG9CrlDXxhh/g6G2A7djetlrkYP4g/dP/B6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(33656002)(83380400001)(6506007)(26005)(7696005)(41300700001)(9686003)(71200400001)(186003)(7416002)(52536014)(66946007)(86362001)(2906002)(4326008)(8676002)(66476007)(66556008)(64756008)(76116006)(6916009)(66446008)(8936002)(55016003)(5660300002)(38100700002)(82960400001)(478600001)(122000001)(38070700005)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/lpIphTuf2rHJhn24J5zAicN3mMBxhToiOERpVA4iamM2eyPhuTRXLRB7Tb+?=
 =?us-ascii?Q?utW1h3kX+VU+29Sahx1ZRttSRcMDRvuFx2hC6NOCqmAKkIu5sntXUZ2oJETO?=
 =?us-ascii?Q?k1F0p+w7Nnt+84SGeKJyr9jpAw0RPCNDkECPbzxXW6zoW7tEncKdbgU0+Opc?=
 =?us-ascii?Q?LFroyMXTKLTFfphIkx3ZVi+C/Dal/Q517+Po/Sji1duwGzIAgWlmc/CmvEHX?=
 =?us-ascii?Q?tWdV+U3PiH6+WGd1Gu+cH0nIp4UbuctENp4YAtZObbkLg4oRRnoIjxnSRj8G?=
 =?us-ascii?Q?t+LFeLXg/mRbZcneDRrS26UtalbUmnUcTsZOgm0UQxhXOMQCTtDlnpA/6Eid?=
 =?us-ascii?Q?O1hjkWSQIDAQJOURRQhiPExraUoqW9GnVWwLIV33U5Idnmp4mzdoHTNmRQ5E?=
 =?us-ascii?Q?4eVjd7AY3xsSW4PB1vBf3nBBsx2Z1VwLNc4JI1TzPof/cxL299IMDIU7QTgw?=
 =?us-ascii?Q?X4t9o1Y+cx57vrk1pzEtzKWclFe7TzpfZpx8f6WDMrKEJZzT8gcT3cVQPkcx?=
 =?us-ascii?Q?+hmRMysl5xHYs3nbfj2aXSAGlHyuF0jD/oBgnczGmnp07UrzynByeNB+SnQ/?=
 =?us-ascii?Q?9/nMzlL3zDlAGUM3CgTs8pza4Ln0xysT8KUQJbqpuL9E9JNag7tnLlNDh4j6?=
 =?us-ascii?Q?nz7Xywk1Uk2+xrLG9VvY4BQ9P8YovPpCUEGMgJzO65SiNhDpDC6XM66ehHkh?=
 =?us-ascii?Q?zz9Bu/5I65zbChW+lpfZwG4ndEy7YgW/3c7UuVoA+StrBgcNr/ulRigezkah?=
 =?us-ascii?Q?HVdmtdLBYRxmSwAE9DbfayG/CMcdJHu2dC0HR76R4WV1wRcdqPzhjp5YN1gL?=
 =?us-ascii?Q?iRx17MRWoUhEVZV86tKAUFcvZ3eSDoIOFwiSgR2iyyYDFkDaw8lje6fgQrIF?=
 =?us-ascii?Q?2/bWobsIDE9mIDtmTt1fYDlzZW2dfGU1dIhGau/Ugsnvl+I0OQV6ibFnIy0Q?=
 =?us-ascii?Q?r9hek0bCRJD5xfCvCPbSzs+kTbcc8/gaijHyLhOKtQ8d48OMbAPvAVZ5trEC?=
 =?us-ascii?Q?FlC59mUat0HMv6FnPxfCWQksqHN6J+RaxoX/QxK7f5u9AXm8ORgqjIJreQCt?=
 =?us-ascii?Q?GM2azvVzy8g9piqTsGeiIwyJk4b2Situ3QL+lYniAe92UnHPqOWgY5OBkpIN?=
 =?us-ascii?Q?EQHsZWobdgB9s0a5oAmI6EexDsf7hr6IlurraCb2LKMpiGdwkvJdHj03wib9?=
 =?us-ascii?Q?18gLLrOTbvg2iU2Dmo37lKYLDOUgq49xX91GozROWjotQRpVozAuKIdJK1FK?=
 =?us-ascii?Q?siJ0h3UQz/1nXv0XGwMYC+C5QgZCcGeCSbWdSQE4QQcOXI8r8RUShDtPGAlK?=
 =?us-ascii?Q?BNl0C5/BWmC/iopgNe2Ca5DlQ01SzNYZ1AJIq97OMDq4D3dE42TSIyhFyf7d?=
 =?us-ascii?Q?Gg9AN4Z1d8f6SnyOS3layyCQqCtXD2gTTmP7shoxq5t5mprphByQw5x9wYgB?=
 =?us-ascii?Q?WWE+Sr3po/aLmaAvZfnjCyxGo3W2orrdFo2Y1R1o1DVL2cUFHU04/uxtl4WN?=
 =?us-ascii?Q?sEQHvZVQ0RZkKYBBSXjydvBGWBGlYoK11NRoQYNQYFWSc8fX8ZyFMjn32PRQ?=
 =?us-ascii?Q?qXv/CmPu+HOzS8Zh7R+F3+0D57Uj61KVnBddImAB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0ca6e2-3d55-4199-16af-08db19944e83
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 14:01:36.5969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LxoOdi+vfAnHKYTnGZhhRB5dwyyxdGkFqRtK9jXrAymxXvzK3vEKO8d5TLf3L3YpkYAv9Uk+AaSBlG6fhruL/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8105
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 9:44 PM
>=20
> On Tue, Feb 28, 2023 at 01:36:24PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 9:26 PM
> > >
> > > On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:
> > >
> > > > > A null iommufd pointer and a bound df flag is sufficient to see t=
hat
> > > > > it is compat mode.
> > > >
> > > > Hope df->is_cdev_device suits your expectation.:-) The code will lo=
ok
> > > > like below:
> > >
> > > Yes, this is better.. However I'd suggest 'uses_container' as it is
> > > clearer what the special case is
> >
> > Surely doable. Need to add a helper like below:
> >
> > bool vfio_device_group_uses_container()
> > {
> > 	lockdep_assert_held(&device->group->group_lock);
> > 	return device->group->container;
> > }
>=20
> It should come from the df.
>=20
> If you have a df then by definition:
>   smp_load_acquire(..) =3D=3D false     - Not bound
>   df->device->iommufd_ctx !=3D NULL   - Using iommufd
>   df->group->containter !=3D NULL     - Using legacy container
>   all other cases                   - NO_IOMMU
>=20
> No locking required since all these cases after the smp_load_acquire
> must be fixed for the lifetime of the df.

Do you mean the df->access_granted (introduced in patch 07) or a new flag?
Following your suggestion, it seems a mandatory requirement to do the
smp_load_acquire(..) =3D=3D false check first, and then call into the vfio_=
device_open()
which further calls vfio_device_first_open() to check the iommufd/
legacy container/noiommu stuffs. Is it?

df->group->containter this may need a helper to avoid decoding group
field. May be just store container in df?

Regards,
Yi Liu
