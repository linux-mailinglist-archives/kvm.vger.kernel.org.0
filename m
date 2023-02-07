Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCF68D1E1
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 09:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjBGI4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 03:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGI4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 03:56:53 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA849C151;
        Tue,  7 Feb 2023 00:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675760212; x=1707296212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9OrAQCg52rEcLnwx+Gl0Svgacyhw2lu/H1SJXePYFSg=;
  b=NURBETQ9ESqgnt7tD3gVl36l8Wf/tk6WHDduU+RA4cyYxfrJBfOSdt9J
   1mjOiffBqorXYP0vmC0RkHiNx8gBTZKIuiDh5Rt1FrrMTvnma/zV+njDL
   r14BuhFwZu6Sy4c+8NfeEBUJbtEbytgtSRL1WAqfs2y3jS9TdpSqvCI9M
   EQ3/tTVhiMvcwR94XcNARRqv663QQd0k7WE9hlXqvr0qMXdBHRIyilY4S
   GqeP8f288fBmsGFY1+Y9nxwze3UV6KBAXY2izsuDFljJ1Yhs8Bf3xTh0k
   aCDj3o5beQXiedIdqopLEbiiSPA99p+HH9jg3oo+jvxnLOBGLau6yQ4rJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="356823059"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="356823059"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:56:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="697206791"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="697206791"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2023 00:56:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 00:56:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 00:56:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 00:56:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VlWlapBu8k8avKK0Jbqsq8mwzanvC8AJK+zXNaY8QoazS6n2Bx2UnGtkWjCyw2vrmJBKU2r1jsZr8ZcrZGTXdOzd3hVWjimNJlSV4OieZRhfF9JYumLm4oUTtURv8x4LGbG+/sWIcTeCajxhkPLnm4y1Xs3DItXjHXyjnkGzbsnbW5TSUX1/7u3HB+sqFAaJcOc2NOAmb0iDtCkUIuceU7rl25fuLAwupHvUrf5l2ofU1xzdqyK2wi1aMxIa6ttHZBh6/DtnZNyB6taekchJDovqZnU+HYGqdQ+JWnYk3Nj1ajrPf59MvQn4IrDFBc99O/5ISvMhIbjs0cdJ+/bF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47vfxbw40q/YOGcOe/Rv4pABPI+5xMRo6+Rgk/94pD8=;
 b=nAuovHSFT8bYNoWwT2y8vV3hTVvNe56rTj2833DuBUK550exrVQvqCyUt6B3eCSiHQaIDkzE26LwPD+jlcBhyohGi2ai9/k/eKYbtzbPJcfNN3FeUrD+xdXLxYuBfjMgRp1sMetld3i9NAgMOE4Iz1++j9MCnIqLCeHyh9e/t00bsvl2vOp1YUuO0vg3KpmXjOZhgpo5015TMU6ZYjBStx5OryyZl4bzHXDg6mDuQ9oKyKr0Y7q7BOfRLvaoBfzvytP0dttVtIaVSW6MAbMQP4aF3XU1E+X8SyqC9LYXzc2M4HbAEUzmLb5jEAXVCntoynFSkREWPaJGlwPmEkX+6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6868.namprd11.prod.outlook.com (2603:10b6:930:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 08:56:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 08:56:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 09/14] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v2 09/14] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZOgo/pRhdQAVXPEC6P100tLKEcK7DAK2AgAAvH+A=
Date:   Tue, 7 Feb 2023 08:56:48 +0000
Message-ID: <DS0PR11MB75299F77D98FAF3FF197A304C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-10-yi.l.liu@intel.com>
 <BN9PR11MB5276E166F8BB56049A5CFEC48CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276E166F8BB56049A5CFEC48CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB6868:EE_
x-ms-office365-filtering-correlation-id: f2c59d04-811f-4380-0e42-08db08e93f98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9RQfep3P1hHnfRjh9b3OjzaQoEkF3dCHVNOquIyPWBhsnTzTuFOZxLOjOgy7f8AxbheHPwv/gig8zLnHxX9+yuVk8Ypr/SNwIowgeT1DGsT/SfEt0xULS9DLnviltfiovGGP70GKEvdYKSA5WIqH8rTY12S0L9j9suPQtyW1cUqXCqL6daIKVCb84VHhz76nPO6dlzvE4M9UzxwubF1AUL3v/PJnPSP7XBXHlxjhlMsh0Hg/Uq0h1iVwiQXuTeV8zl/qGHQnh4WKOEkbPu0yCSw1iFjRtACDtcWYDj0AWkZi6BO+iH+IR1OYuTsN97GH6j3Dh8JLE5t50JDhu/bbk0JU609AOwMSRXLPnIE2eC7gJW8dd5Nwekdda1M3ky6NL2p1QzBm09oA93WrO7McNLpIAbt2UMA5qlh3Z6oJoALek6hQLO1VRNOy7EMEnEx3V2uhbEPJ5qCETaEZ4DFIsWemskDqBn6DUm2ZPm2nkiPEYePeFeqf92S6pBx2pmPHn6JslTOqGdkA13aH/T3LRDkftsbkMfgBvNR/6sGD0SVFk7v8XDQLPeVlBULQOKcPIsIP4g6/fdbVrewupkvuyq1cV/ZCchEOSzXj+11NPi0ARLYgR3jZo5LCqk9BPT+NfxJ6/xDCXP1VnLpOk6CY+PbeOCd3PqTSfE0YFtMaKlHjs3yvPzbJTrswcHbGMv04jjnDNX65nIoMBNltg+PfpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199018)(86362001)(54906003)(110136005)(186003)(33656002)(7696005)(71200400001)(55016003)(4326008)(2906002)(66946007)(76116006)(7416002)(5660300002)(64756008)(8676002)(8936002)(66556008)(66446008)(66476007)(41300700001)(26005)(478600001)(9686003)(6506007)(38100700002)(82960400001)(52536014)(316002)(83380400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+NuYKXkHoc9ixkf0Wut546i1QRDG9YLUV36bUJ73wHYysBstjuTG97FDiGhZ?=
 =?us-ascii?Q?A0FhWSyRuUW9vFsI7/5hlvKEWWx5cpPa4F6UBPElKqvaR9wxM53W1EmdJlYx?=
 =?us-ascii?Q?0RMlfSz2N3xk1bcMp1FkSyTmTLe6EsZXDWHQqUljh+sFI0bXiC9fF1E5k3fB?=
 =?us-ascii?Q?ypv1UAJkwmiCdV7A/v5kI2kjtwMx+6UK/7OtiDmUA5tI4MoAeRXBqq5hC1Js?=
 =?us-ascii?Q?7n/FKHI7l4Y+JEp+DiUOVckrmAX5DxEOSFzP12DRxKPmvwV/dkBLCmSrxJyD?=
 =?us-ascii?Q?YBj18z66W47qvszQnGiDxc1YX0R+zRzLd6/YV5/KIpnqC/lUf8B7idBL/G3S?=
 =?us-ascii?Q?WSkI84rvlwkJAxuYbV/YnrzDY/vDEwoUbFnMj1uo5Ww8/7Me7MtgqFxtCkEG?=
 =?us-ascii?Q?1dmWGHqcy3MzLhadrDIsHoUMGlGOVckQ/Wmb+fHyirZIOIa2n166sdNnZDZw?=
 =?us-ascii?Q?kUVYWAZaLJfKlulkpPgQhDkIa7fu72OcP4KKt53sO8xdnhavoGomjzK03KJN?=
 =?us-ascii?Q?DwuTD3d3O4DHAjkQmU3J4WlC2Rlg1zqR9AuMOe7F2Ya9hxujdliVfsMZovaI?=
 =?us-ascii?Q?AED5xHBgf/GLoQnaxTsuJ/VEi1MLt3E5aNI94He0OkHRrGLDHwW4zQCLs1pD?=
 =?us-ascii?Q?BWFJUO6Lb2+WwOhbCBOj0z3DBAYY+9j1mRrhcmnF3tXihZEIzgyzU0H1+SJq?=
 =?us-ascii?Q?VEOZ3B/TBhPFQ7CtF3kJEjaVqBmg9MoBl5NROWsstxfLQA6wTPwVdpc5Qr0U?=
 =?us-ascii?Q?dY4z/qATUN7qlMMyhpzRUSwDKpTeZzSd6Gl+lA/8Lys6A0VUltbNAFd1GKW6?=
 =?us-ascii?Q?p+NtVPHRaQ9QUOMFRPJM7ysLk6e3KhD8dQpB+NxkLROi+7wTw2IX5AnSLTAW?=
 =?us-ascii?Q?6Mtq1aj4XEzKlBXGVxOy5tBvJO+Y3qjlWHp/+r6j3H5rfUNrhvmLypq81MHD?=
 =?us-ascii?Q?zVBeMDJ082CDeQc4VKw7NaS21JJMqpYgZBGq8H7rdKmnhFodv0v2wFShZmdg?=
 =?us-ascii?Q?EhGFDhP7uQbIhoXAv8n146noj/UiSvkv98hMK+NP4pXydUWtjii9OkGC/1Iv?=
 =?us-ascii?Q?thWYxc9dWqBSHUz5L3uVCFvQ16aUrbana4DPUlxBzr0fNNm5KADkNPGWwdjt?=
 =?us-ascii?Q?XJvrfmRmpr3/OPaHuHlE7Z806x49yLCY0N/HYtG3UBNoUsUBwx46MPKoX/bo?=
 =?us-ascii?Q?egvN6aKKK0zK2nyB0hq9SZTjyaLYgthnIjmzy0tT1hPj7RTZE49Aki/dU7wj?=
 =?us-ascii?Q?uCdUhGpXx7RqglfJxW141VlTkDNV2GrXIPkPiWMInAYj7Ya5vsLtxmZ4V1ko?=
 =?us-ascii?Q?z6DD6tyDYuCDfbV8U4XhdRGWWU5WFDl5iDYEOKebpVzPvq/H8DVY0XycFLVA?=
 =?us-ascii?Q?VEg+MdJ6iQdyaSje8wncyJfpjib3099xo+CgRqsksvU2z99nV3i21YCUWYbu?=
 =?us-ascii?Q?2RO2DCdCr+JB8oPpZlaji6gwZaZUaLqun1rbRDXAFlOVl9JJxpT1UsvbmN68?=
 =?us-ascii?Q?s5+P0LFtRoQY8ux+aWO4useHkkxiwVXrzQg39lf701Uvm0wytB/PnNngOHnh?=
 =?us-ascii?Q?JoQdJ9u17ytgcf21Vdvuc31dwl9Xi2Ji2LYtuv19?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c59d04-811f-4380-0e42-08db08e93f98
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 08:56:49.0077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UA+d/JF9V/jM+PvL0CswLtYI5n26+IhyOwiPpL3IjrVQhfCm3vs47kmgT3Y/+cGJhWngldGstYH2QjaPAs/SRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6868
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Tuesday, February 7, 2023 2:07 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 6, 2023 5:05 PM
> >
> > +static void __vfio_iommufd_detach(struct vfio_device *vdev)
> > +{
> > +	iommufd_device_detach(vdev->iommufd_device);
> > +	vdev->iommufd_attached =3D false;
> > +}
> > +
> >  void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
> >  {
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> >
> > -	if (vdev->iommufd_attached) {
> > -		iommufd_device_detach(vdev->iommufd_device);
> > -		vdev->iommufd_attached =3D false;
> > -	}
> > +	if (vdev->iommufd_attached)
> > +		__vfio_iommufd_detach(vdev);
>=20
> I'm not sure whether this abstraction really improves things.
>=20
> Just two callers. and the old code reads clearer to me which
> checks a flag, does something and then clear the flag.

Ok. Will revert it.

>=20
> > @@ -74,6 +74,7 @@ struct vfio_device {
> >   * @unbind_iommufd: Opposite of bind_iommufd
> >   * @attach_ioas: Called when attaching device to an IOAS/HWPT
> managed
> > by the
> >   *		 bound iommufd. Undo in unbind_iommufd.
>=20
> "Undo in unbind_iommufd if @detach_ioas is not called".
>
> > + * @detach_ioas: Opposite of attach_ioas, this is for runtime undo.
>=20
> remove "this is for runtime undo" which is confusing.

Ok, clear with your above suggestion.

Regards,
Yi Liu
