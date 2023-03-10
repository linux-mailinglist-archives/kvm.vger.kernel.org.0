Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1AE6B39ED
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCJJPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjCJJOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:14:51 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC87D3B65D;
        Fri, 10 Mar 2023 01:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678439457; x=1709975457;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4UiEW8G5iMHvSva3a8tQglVdLaPIdmWRiBO0Yi2JckE=;
  b=V2TDsLJoWqXFeU1BROOm4I5RRN3RqZOsbNUw0WqUugg7A71eB8LKgsSH
   oca2xAj/3rQpBNIab42sccM+DC+9oJkaEOqJM3LwHFlNvwYMjbgEhUriD
   adaerpY8lLT7mAouf2xyaww7NIJrncoR0hIeMTP0KdcuIjukzYyM+3VE8
   EoDLBtv7zAPpS2J32djlN/yxX6F6DFcz4NCQcIlKQCYKz0OBQvmTQoJk5
   MMiBe3muMXAuugikJ0CcEr9Pdn19wdEmVEJfjHGWpsj5urP6GjwL1lotW
   NtdVifc7JV0rkH9S7krZWb3+5xSw3Gdokin2mC2BrPzAILDV1X1WtzqQa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338239473"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="338239473"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 01:10:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="677735569"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="677735569"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 10 Mar 2023 01:10:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:10:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 01:10:55 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 01:10:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMf8zmE8qz6XAPODr/F2MI05qpOMLnBkRj3V1XL7TKWyAvdZqo45qSO9vOY/Jv0/OWb88ylXxqUkXZV+SacKmtkIrawBoXpVTiTttrq9DjgPDASlVVtB1ziv+1wLglV1gT7aXjsTTLuo4GsGGF2Ds0W+VZdXqRmzdWOy/9FatXI+q3iWh5/CDOFafEWCJv6jXZ+EiLiyttaArMGQP99D8B7u7lB3hjjlMU4do1wkS4ZNxXpMq2LgsTdEImJYQ+cvaQW+PdO0+S+kpPZEubqgfU2TSJ30vaKqL5g3cfnA1VyEAoXkAEHVOPBNTP4yYipVi7SoMuGhhpx6UgUtnA5S/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1n1VJX4nPs1P/ylylhq62TlJzSBPrbXfNc8cv0Yb4ho=;
 b=m4dqU1YFjqT18dYTZlBPJGzn8T41pWBFPIU/TsnC7zFIYhx1u0V9bD1KaHnVs7UY+BlNmOGOLR5c50ZKfTaTlkjnDKODAJht4khxeuqksNXiTwYmxtqrRsVkwgTPW8HE0hAhfeaC2M0tvcsCynQokzkeX5syvx7f5q+00/jLpPYZa08u+/o/dBk5F+pvDcTOS9FQh+t749ksHagve8pSLDB8wDh+4htaMR64YX9reyMzbYa5zHfY/Mpbu47pQKFYqjF++kCiQwNJoaNAFPV1ftVLC3s/E9GfiK0j+eD8AEHb0HQkqA+kYWOtzAMsFvIXGUT9KDucwLV7kHFkdipapA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7422.namprd11.prod.outlook.com (2603:10b6:510:285::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 09:10:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 09:10:53 +0000
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
Subject: RE: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Topic: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Index: AQHZUcIKnlfid+m1xk2WV9/gWjjIRK7zp/CggAAHawCAAAzbUA==
Date:   Fri, 10 Mar 2023 09:10:53 +0000
Message-ID: <BN9PR11MB527619B449D84154FDEB4C6D8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-14-yi.l.liu@intel.com>
 <BN9PR11MB5276CF102D9EBB7B447C58FD8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529BF46B3A81438DE7A11D2C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529BF46B3A81438DE7A11D2C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7422:EE_
x-ms-office365-filtering-correlation-id: d17846b1-849f-4bf4-f1f2-08db214759d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JRwNCPa/g8ZaP27H1NmEy4VkkRJCrXpT56eXG/4OWTZvYt2s96sfhSDEB5qUfrxX/n/nget/aSCDhkbNzwvPUaDihboIBGoUsuT/RCrs6QgxOdd0OwadPkFgr63/LRZW7soWNPxrjPMGswLL/PagCybcWaAwjwV7YlPz2Vw3uEGvtjEAilE40SIEykMmfUIRJ7rmvx9Q4OYVYdl3jWyq9wWa0xELiSr34TVmQDH5SK0qIoByRraHUCibHzIjdf4Xr/pk0u817h9ah7LB8+Bkpc5NOTdWze5nO0Tjbq3xlxWuGr5CjqFFuF4gNV6Dxf+V32ANBp16MhmU019XxyZvDfu8Q1NOYe0Fk5oZzK3qrqIMaPTv0JIXzhfeHgifjMQzzHUlfibiRkplwymm5RcqJCLpYoOatlXZYXrp7b/7VRRPZVNsk31IXOYWiH5fiJ62AFjLnM/w6qvTQ6bfVFZUxajEWjcl8nfbZB2K7uEICRxaXRNJYqCcC7UGea4lk77RLyFI0aWz/65etCzk5RzcY88/96F+aHSAR3PlPpQ6/C7kwWFAlesAJ7p3qj33tmQbqSl2dGGje8rCdTg+eRgVNZ8ZuPcvSNNN6vgWq9ijeFB39QVtJzB20Od+b/nXnAHBkkL0VN8vstddQq/cgBJS6VkqJyfZ8bkvSL9/8/u1eui5QIoBk37Vd8306VdY3aB/yWtPJBpRLowBg009AD/4aQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(6506007)(26005)(9686003)(110136005)(71200400001)(7696005)(66476007)(54906003)(186003)(316002)(66946007)(64756008)(66446008)(8676002)(66556008)(76116006)(8936002)(52536014)(122000001)(82960400001)(41300700001)(5660300002)(4326008)(7416002)(2906002)(83380400001)(38100700002)(38070700005)(86362001)(478600001)(55016003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jynQeFc4J8sqzJT5yyJ3Baop3aDJTVOy1pzO+kO57mDGUvphCTEMXRFKuTII?=
 =?us-ascii?Q?JW3yh2jhNpQFuslzV8y5qcRgpdfYe1Y0JjLpp/XSvYgggex/9YFumNQRrQ5q?=
 =?us-ascii?Q?WO1BvsE1MckWhh4+zTZsabCzKPamXfz62vSxM7BjciD5sqsCT+kSB4yZC9l5?=
 =?us-ascii?Q?cfndHKqxRnca4QbMWc+p0YVdn6KdAi7sTERiKUj2rl2Phx/GCrjkLbVoNiPG?=
 =?us-ascii?Q?pjm6jpF7s0d7Fup8kvtlXbimmry3CybSCtP8AE8B/UfbpWsaYveSzyIUfpx0?=
 =?us-ascii?Q?vsqqRvGDWQ+QKXq3nDR0xlJpzVcZMQSYsvj8CtjgeQ6hcMGdikbHIoNtCrAy?=
 =?us-ascii?Q?Oganphbg7+cDbUz/tldfnX3rV4laqflgbzIlWdIHK0T8559OkvrIGzrnjkut?=
 =?us-ascii?Q?UlfErryjfUqjtErigMRhr9EocYsoIJhfxbk3CUX5loVB9koF8l1obrRceowX?=
 =?us-ascii?Q?0k2/K6GecN5ftos4Gn9pwVNRypwviTAQIMsD3LzIQ61zT3E12yvvlyOdsgX5?=
 =?us-ascii?Q?CVaFgRCvWEFhysp3FkUvJj1CSIu/U6lbejpbLzurMK2DxjO1JnHOLex12GgW?=
 =?us-ascii?Q?jhfwDwEkZvS755qQ5GOGNsWE4W1flaiq2NFdnw3WRtEPMnSFP7ux/Q11JQz1?=
 =?us-ascii?Q?VlhAo+Yutn75/tmNuAmf77A2UVgIQk1Nyui4mhtpb6a3mAHpMtw7/RZyJRji?=
 =?us-ascii?Q?6cC350/7JAcVXRAqfZecau6VmopA0mNs1NG0RIzPTrJIAdyJtddCkpc+DR52?=
 =?us-ascii?Q?TqCiUysbhrDN7XNDWZCMpKTE9bP0QH14ccORP+pnXuS2ruSYS+WYXzULTAG7?=
 =?us-ascii?Q?9gIor1ESH3a430736nJYlgSGSFOAOYkIY64QBLvXPlvQJ8+1ZkQEnZt7Hngf?=
 =?us-ascii?Q?Jtp5lF+StT5DGN5Tqg93fI7KQuGqATYZ6ITwi43HTPMSCk3b75iSq4GpqPtW?=
 =?us-ascii?Q?7WPeSuuR0vueRCjqOnatNmmrCchc/0rn8D3XwU448qTaSk8e5XrDQ1BhAQ9V?=
 =?us-ascii?Q?LB0tquv2ov6CbGzWpHNAR65M+XOS8A8PCxfS09YIfu4789IAg5J6o5hiRxD7?=
 =?us-ascii?Q?t+pKPwo0Ldhj5W7KcecM1NiaB4MfNIJ+7PvxyPWVMbUybYX+9RPjNqcgPwS+?=
 =?us-ascii?Q?KOk/oC70edMRefN21syJWIkI94EvnVBDJSlmm4LNO2HSB6XsbNA+g4ZwtxWe?=
 =?us-ascii?Q?Hv4rEG8ug507nHEOwej2zXKIVhbZd/TmtLBe8391WXPOXReGuUyq3tPNb9I4?=
 =?us-ascii?Q?rvG6KnE861W1VZvGnOqC/2mFGj6RJi55Wxk+ih1FDCqYYJ25iePSpd7S9Jh8?=
 =?us-ascii?Q?+sORIakdMEK+jTVpLBv6xexyLltZi2gKTVXkufc9pG+1Itp5d5uOk3iOFr+g?=
 =?us-ascii?Q?uAx4dLybnd25xqjq5sRp4dSfUAPvPd8lg/MSssoP6lzK1Vt7DT8aEG9QviSi?=
 =?us-ascii?Q?jqL3LHcCIZD4fLBbwjx5I6Etp43k7ofRPW7Ylxdqx29sfgN6CcoAcW7ir/xN?=
 =?us-ascii?Q?j5NK/ISiyvr+16zdw1iixlhXMR52SKCxMN2OVE1/zQyOCx3dGkQL/JVtra9N?=
 =?us-ascii?Q?R3u5YYg66gvESAHUvF21O0Oe3LYvg09DTE5lpZmD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17846b1-849f-4bf4-f1f2-08db214759d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 09:10:53.6357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yyji1kplu0wlN4LdWkvBWEJ0LTJOOByE9n6McOQJJDcLAZ2FWZqVR7h//nRMmTMrmqTjHJncdbglP+nlzzGhhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7422
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, March 10, 2023 4:22 PM
>=20
> >
> > > +int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
> > > +				    struct iommufd_ctx *ictx)
> > > +{
> > > +	u32 ioas_id;
> > > +	int ret;
> > > +
> > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > >
> > >  	/*
> > > -	 * The legacy path has no way to return the device id or the select=
ed
> > > -	 * pt_id
> > > +	 * If the driver doesn't provide this op then it means the device d=
oes
> > > +	 * not do DMA at all. So nothing to do.
> > >  	 */
> > > -	return 0;
> > > +	if (WARN_ON(!vdev->ops->bind_iommufd))
> > > +		return -ENODEV;
> > >
> > > -err_unbind:
> > > -	if (vdev->ops->unbind_iommufd)
> > > -		vdev->ops->unbind_iommufd(vdev);
> > > -	return ret;
> > > +	if (vfio_device_is_noiommu(vdev)) {
> > > +		if
> > > (WARN_ON(vfio_iommufd_device_probe_comapt_noiommu(vdev, ictx)))
> > > +			return -EINVAL;
> > > +		return 0;
> > > +	}
> >
> > no need. let's directly call following from vfio_device_group_open().
> > In that case no need to do noiommu check twice in one function.
>=20
> Ok. maybe still have vfio_iommufd_attach_compat_ioas() but
> only call it if it's not noiommu mode. vfio_device_group_open()
> can call probe_noiommu() first and has a bool to mark noiommu.
> Jason had a remark that it's better to keep the
> iommufd_vfio_compat_ioas_get_id() in iommufd.c
>=20

Probably that remark doesn't hold now if we agree to remove
vfio_iommufd_bind() and let vfio_device_group_open() directly
call .bind_iommufd().

also group.c already calls other compat API:

                if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
                    group->type =3D=3D VFIO_NO_IOMMU)
                        ret =3D iommufd_vfio_compat_set_no_iommu(iommufd);
                else
                        ret =3D iommufd_vfio_compat_ioas_create(iommufd);
