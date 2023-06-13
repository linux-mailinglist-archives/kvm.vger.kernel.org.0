Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF35872DD8E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 11:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241745AbjFMJVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 05:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbjFMJVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 05:21:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FC5EE;
        Tue, 13 Jun 2023 02:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686648069; x=1718184069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=euh+nXjO50eFLGc/Rxjh0dveImxI6REVz7azB6k5tlA=;
  b=EYx+S/ptzhLORC030z3+8XABfvDOpgZ0SeQfevzvXhTGzofGDM/BItXz
   mnlLIlN0e4Wl3S0S2XZmsy/hBcataBI9285K51s7jId3+5T1ANZ+M9Xlt
   buxxq7sZAk3ehyrzXd4IY3saFWVnOW/M72Gs2VUT7ZBNwS3AuwOPNwTZc
   kHD9tZ7GtJohXg2v3KOrfQsGQj4Sc/5LHcb7oSnvsfn7XcGOxdbZnOcj4
   MaaMQyFGkXJfqmF8jHZKu3ZYjd4YFbxa9v3IXwYQ91+C6p39PEdSuRZ6h
   1gi7MQjgtGwb2M15C1krkO6EqT95h8FcqnuaXLgSyyaHu/JhoEaT/6Bxn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="360760552"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="360760552"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 02:21:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="661940860"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="661940860"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 02:21:08 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 02:21:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 02:21:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 02:21:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdEMg0wBhG4C8T+h1FhONLZ6aafcaL2zEIooXMc96xsNIoNdfLyNrgQaxV+VCkKmUTPz/TxtT2Low8Qk06qqb6DdQc7dSYJdva22xc/yVZEA0nCWFVUeKlZinpoHuQPIuAeRbXqZSgmLpCLU44HaPcs3v9s84+vfZNQvWkBJMRS4/yLocd3glpCSF00cI3ZCG8Jeiv6T16wi5gy6EKNrBKM52bxifWRWRG1CjkYNpgOpAuR/fjwBrcUzWP0bJrd/nRJVlSYvIqL0RJLM63ih+mQxezTHYmov4aO3Lcm+xsEK81AFdGZeyvBdLUaXn6YgJCwav+8tnpm1Zue3I1+H4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDKeXL9I96OmTnaqRf8SKeSKp46worcedaT7jWRtEL4=;
 b=n54C+qZg4aK5ABbLDScFhw9pcXhVgtZTA0JEC0PhnSojjNdIbFGlQnGbnuIebytv38UR6NY5p2JAzxWXwlHywXOkvECrCz9euzSYdUX8+0tzFeUFA2FXAx6/k35p9aAI0DrSmlbq8uFifWttn3s3xgyJXSDqEI8J4yFmBe5nHp6tD03Z8/Cz6JUyX6jkr/FPGb2+3y0R2cAKQBdh7T+G8OxOTM5N7xVTsu5sL4F4CbuH3F7xnCqOSfHwEMLGlRhAMAGSTTYkSbkXr9Fz4gvlG+yQPItNz6sJWrZJZTB79Ia+l2/8as/GH1iydcERWXKC8FpNcpTbmmkNH0qBiAa5iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB7770.namprd11.prod.outlook.com (2603:10b6:610:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Tue, 13 Jun
 2023 09:21:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 09:21:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v12 20/24] vfio: Only check group->type for noiommu test
Thread-Topic: [PATCH v12 20/24] vfio: Only check group->type for noiommu test
Thread-Index: AQHZlUw5NwlCFZhQEkO14QEkwADgxK+H0mcAgACzC8A=
Date:   Tue, 13 Jun 2023 09:20:59 +0000
Message-ID: <DS0PR11MB75299E29CBB54F7533DE20CDC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-21-yi.l.liu@intel.com>
 <20230612163742.215eabde.alex.williamson@redhat.com>
In-Reply-To: <20230612163742.215eabde.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH3PR11MB7770:EE_
x-ms-office365-filtering-correlation-id: af3affdb-919b-495d-a4ab-08db6bef805d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WKhpAnikl1UvUpiMQAI7JC0H4so5SJtmDzGuUhyqr8HlLGa37qCwz8KB4yWDp31cmzHIVQ1rXK4TF5bYtpyuEqDtJVvwZ4tZj4Ke736Bxs9LNIB9OoqmuazWcUUcO6rnPxDlYuOFdI3NRO1O0My8zywN9XvJNju9v5m6L6UixtEf663MbQU5qwy8CredHy6GhswD4Nyj28373UgwDxdkWPPkukHoWTWAow2r8w9WdB6NPe2RiD+S2fwr+AomIu/2s/7Vtus1/LlGm4jG8wST9RITdoNy8Qa2AWAXwtjNiK8HY4HsQzujcMW21uTHLNi3+DF+pUyNl+JbfJpLq28TnkNYvJ6sxFnRDaZVYzMbEUxT3rm+d+bVXZ0hI8DI+q5Q8IhzOdbVXtL7MQg/4XdWe1EvPbztMgg1s068Vxpfxg23hkCHpuLgApFE6gmVShS/TpCEQ7KeNO4gZ2v2X8KV5pyWw44LCM8k8dHxrS74uNW5zDBty0sr3e3HKw0oXG2YRvn89q10Kjm0tb2XF87qYHiVHpeHkhMG0Vy5xCcRaWi9ZEI4/m/QnTiaVkkiw7MtJmXQ7GtBAETXPpAzi5aaWM4DEdRSQ22u/W5hv3tAturZ+xqp1RtQOHNC39gYBD0r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(38070700005)(33656002)(86362001)(66446008)(66556008)(54906003)(478600001)(6916009)(4326008)(316002)(66946007)(66476007)(71200400001)(76116006)(64756008)(7696005)(8676002)(52536014)(41300700001)(5660300002)(2906002)(8936002)(7416002)(55016003)(82960400001)(38100700002)(122000001)(6506007)(26005)(9686003)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jZScS8wFw3OkhNC7PO7WGezxsLpGbbKrkpVMRJlNK4RSOLkFWT0GJzQxGgSe?=
 =?us-ascii?Q?1kl+0w56YKaXMUAXg+liJ3wnwCMQExH+RShImiUDqozJMiAPVmoWjWbNL/r9?=
 =?us-ascii?Q?KXOqwlt5GlkBBqHcSKb6WS2rktRBzIhx5Pji+JNjdDzNUc4kOCODKqrPV9zA?=
 =?us-ascii?Q?00BA5Rjqyq6ccmLo9ePyWOxORISm4lkXyJt99wSLkhJlIZw4rkGQZV3t4HbK?=
 =?us-ascii?Q?7RRZcO7R7exSfYhO2/QzpUj2Uln3mdY5tK/PgSHo2loz6NhF2HvLZU3sym6n?=
 =?us-ascii?Q?uXROolW9Sa7eGBKHLoE/3PZQ4dVfSzEsyctPLcTjHd9xs5DRM0aGFh0dzvKq?=
 =?us-ascii?Q?F0y2mKotnuQAesSbmzUhtr7GK1LrUkchSHCJ1K0U7M4tZd0OKHbJRzWQG3zi?=
 =?us-ascii?Q?AFogOvxgXj7CDBkBjLz9r3lON/Aahci973MspPCSoWFk9vgr3Fqx2R8wX54p?=
 =?us-ascii?Q?lcuy75OqOdUafEhFOlhXng+LgSAMgW37N4HpDqN2L75hba6UwJFojcFu1Cvz?=
 =?us-ascii?Q?zrevgHjkt7MrmBL83Om8YbdkY8ujbSUfeYniypXPjI8d/JxRObRLfQkF2eRg?=
 =?us-ascii?Q?SkH0j5uzvMv/NI8Na/DRWzAFyjGcufrMtU/orIfDMhnMchP6NNOyS0xnm42d?=
 =?us-ascii?Q?IW18nHU7m+iQFIwFUsay/UF8Klhs66mnVJE5oS/jiUAsfOhWXZKEWT7llEjI?=
 =?us-ascii?Q?xRMp33hn4awD/jg2yMFZdmhXfCB7VFf8Gywn1veyI8/fBsKCzxopjhS58qoz?=
 =?us-ascii?Q?TGDTpNXaro4+hDx6Arc2dtEavAA3nAWYuwIA9l0tYV8YONQa8aDIHQfuETII?=
 =?us-ascii?Q?GgcXWoYfEu8uI7K8xSDy9kijiVHxSS9DvURQYXOu6vJmwxv2IQX1GgiWtiUJ?=
 =?us-ascii?Q?XCnX3KgD6rAQkQFekQ6eyiPtQXnPFOU6JjKsRh8bL0PDc5mZqo2J9RQCsoLE?=
 =?us-ascii?Q?jrhS7bcU4LAAGSIAz40SA3a7LxqS2yAwwzq5W3ZzhJbbWe2MVn2S/MpvcjDN?=
 =?us-ascii?Q?57Ds3fkHMS65I+6u5AFfZQczpsPo09XjKCw/vEeO33xJWHXq+JI3YEp7qswQ?=
 =?us-ascii?Q?HlObWtbZxCJLoAXLtPTZN+Nib/psyJbNxmWAXd2ad8zdYoE5OBjmH/5zjL3K?=
 =?us-ascii?Q?7AMljf5kOjJ19iZfc5Y1f7r/iXKIvl33WVf2g/THR3G1+EG7yHIUhRd7R9Qr?=
 =?us-ascii?Q?4gXtVk2sUdGVckykGTCY79CDddGxcCU1YKSQ60N6nrjNi92X88RdqHgews9X?=
 =?us-ascii?Q?f7uHaxkYe+qckqXcURKgKOu4r8g1fuucMKCB2T0aiQlWedhShQEXvglBlbEs?=
 =?us-ascii?Q?4Ce7+lR4e79I/JJFbCyKabusJ07ZJ+DEnRfm84Re4KrEuKnVoMGN9Uk6N6vG?=
 =?us-ascii?Q?TANlX0mrakjindNNEVOaD7tbJcAvfRTugtGljQFcWrsE0ZVq4PEAPb2bmMy4?=
 =?us-ascii?Q?d4KQ0fmE7xDC17+Qz4FzX5irERpB3ydR94tWoT0wheCAUeTDYabiPq0JkF6x?=
 =?us-ascii?Q?ue+Q39qN2gCdbLAGst4EgRewP8mhsX+9NmQTzMOSFHXfiDX3bXjCfH1Cz5op?=
 =?us-ascii?Q?PNkLYB5WdDm617bJP4wmHwasbDv7n0ORa5D+3n+t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3affdb-919b-495d-a4ab-08db6bef805d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 09:20:59.7759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KpxNaNZdtTCEOskO0bVWxaqO+iKu/dwSWfnVbZacuCC3ODUk8Y3Olo4ES1Uv0mSWDq2jb2xpAlKUrkOEDyOIOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7770
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 6:38 AM
> On Fri,  2 Jun 2023 05:16:49 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > group->type can be VFIO_NO_IOMMU only when vfio_noiommu option is true.
> > And vfio_noiommu option can only be true if CONFIG_VFIO_NOIOMMU is enab=
led.
> > So checking group->type is enough when testing noiommu.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/group.c | 3 +--
> >  drivers/vfio/vfio.h  | 3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index 41a09a2df690..653b62f93474 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -133,8 +133,7 @@ static int vfio_group_ioctl_set_container(struct vf=
io_group
> *group,
> >
> >  	iommufd =3D iommufd_ctx_from_file(f.file);
> >  	if (!IS_ERR(iommufd)) {
> > -		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > -		    group->type =3D=3D VFIO_NO_IOMMU)
> > +		if (group->type =3D=3D VFIO_NO_IOMMU)
> >  			ret =3D iommufd_vfio_compat_set_no_iommu(iommufd);
> >  		else
> >  			ret =3D iommufd_vfio_compat_ioas_create(iommufd);
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 5835c74e97ce..1b89e8bc8571 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -108,8 +108,7 @@ void vfio_group_cleanup(void);
> >
> >  static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> >  {
> > -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > -	       vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > +	return vdev->group->type =3D=3D VFIO_NO_IOMMU;
> >  }
> >
> >  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
>=20
> This patch should be dropped.  It's logically correct, but ignores that
> the config option can be determined at compile time and therefore the
> code can be better optimized based on that test.  I think there was a
> specific case where I questioned it, but this drops an otherwise valid
> compiler optimization.  Thanks,

Yes. in v11, you mentioned the compiler optimization and the fact that
vfio_noiommu can only be valid when VFIO_NOIOMMU is enabled. I'm
ok to drop this patch to keep the compiler optimization.

Regards,
Yi Liu
