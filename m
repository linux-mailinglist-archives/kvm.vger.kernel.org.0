Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AE36A036A
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 08:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjBWHzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 02:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjBWHzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 02:55:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705B2104;
        Wed, 22 Feb 2023 23:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677138945; x=1708674945;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kgQS2xezZ+yAWX4fdEPIH1p0aRU5gHaS1+DJ4Bl0ohg=;
  b=kgbm7tDazJtVqNK7ydGW6+pOWYTv8kNV0QS6zik8DhAScLGrX9LIbyc7
   ++3v/QTgkRzvRtygHV3lVIt7zEVDVtkTueYOs+QsL0CiLtyXP6bdQx8ZI
   GFmQpU+Sv475pQ7sH4XoxyqqKi1s0Kc052hajIVnpRh8+zR/oCUsZP+W2
   jZPM/EPO62aLyZ/5izOPrFyXdhwwgpweXJ9Gtf8hsgw9GcNlIN7jAC2vk
   1FsDVS8Xua2MnPGbY88zB9OU4j3o/+1Mw7QkXrpkHb/V4jpc15RYwpmJX
   3eu+A75nueVHzPluZAT8+FnPhrjCyl0nBJtk8zOO9NqVV8U/kU1hDtJDg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="316872501"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="316872501"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 23:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="781779478"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="781779478"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 22 Feb 2023 23:55:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 23:55:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 23:55:28 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 23:55:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFSTqQ0sT/1tMTuaZlKuyj9bcNq4fd8H2z1OtfVna51WjZWVzVSlpwXgIQqUBx2j/p3gvcnP0y/848FDMyG+Nr0Tdw+oaflJzLFBeDS7LpbEkA9LEMZ5IYvXXWnUZe+BU9t+dK7UlKIo87T7D0xC+uzzzHxGQfOihTgeLp7zpdGIVbXE3+Wa8ptBaxu4zFmKw3tNhGxKQFDV4RTIPxVWzJI+O50vI8SNFxgUzA8ah8Qh4hlDJymgOnL8nLGQ3Feh/XMDTtn2SCPCHPMpBrjirQUSFqtSKom6aL50QkSxipYMPamiCyqJ5eLqe8dU+3XPRHZpjzc35q7AlV6T+b0OtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rGOIFahWLV5oWW4xWtB/qxGKLEt7r0hFIChuXom1Ks=;
 b=NGDuCFssIm/Qj14+GAIZswxIXRBV7z8nbw1PCW9RDIkcUD+Curw89FEylK1vtP80Xf4q1wnC5gfDezYX4O0oaU77mezwf2RNS6dEXQ1mFHbGVTmUEWqSV/OcJ6oNOwF1B8nEr7eQ6uckV49kDFFcXzPgszg5ZSSKHLjkveaeF43mq+EWSRsc9DqD1mizxZEiwXd9WoXofkuIY0UmlwA9EXxmcPD2PdF/OcHl7nOnifbAFV422zM9mwx2z4nYwqA16cqIibCRJaMep8p51+MWZvEM54IgKAGpTNg77WaQy0iIr1roFkQNDdIlJ6w5S82sFshKOZGRV9EOApzqLzryfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB5551.namprd11.prod.outlook.com (2603:10b6:5:392::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 07:55:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%7]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 07:55:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRade4YzkLtsVl0WRYDgmHuz0/q7akQpAgABomgCAAD40AIAA70yw
Date:   Thu, 23 Feb 2023 07:55:21 +0000
Message-ID: <BN9PR11MB52767915B9A5E509BC90E0888CAB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/ZOOClu8nXy2toX@nvidia.com>
In-Reply-To: <Y/ZOOClu8nXy2toX@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB5551:EE_
x-ms-office365-filtering-correlation-id: eec7a0ca-320d-4fff-57d1-08db15735008
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZPhKDq12yBVV8ZGwk94ZzdSDxZlKxZaVy0dGggBNCa0mTcsqFrXNQQeJSJA1A0cg5yRWQkS0zOagH6hm9TYbve0OD9UitRJw5QGpnwGx3r/fkvjf+2HLY/n+gDWc9goA+tjO9T62MGHrJAqjHfng3VFScqD7m4YRTDQuhF6zncV1eNwyhWWcQU7hs+P4XtwcB1+iGkQhe3tOl47+HecyZi7NP8kwmF8wfGRf3em+NO2o5sOEnY5oFkERyfXRBAEx7zEejjTLGkM9yGn451rEl6fzz2K7sM/22hwosUpki9VcPIO5sQV84DaghSQprrLUp0tU6Y9lEfP6f0PilDF5fP9fvktJ+u9YT0f8Zyl3pzU/mFOPzIU0SnKIFjygHsC4fcPiKEe158OecOYlXuPAdG6zMLrGeUjwDokmV40fVc54+ZobaEaE77PtzaRKVBHlyni1vPNrzt6N2KvxuYEZtpf1epGrFGp3HmDdP1AIUfqRpWWASjK3PvaIFO/s1NlBtpz4vK2bQtp0/m3qsDaUO/4+FkFYFkryDersbvlitGlngCH2/ffXGpr6+JJFW6i3AUt4W7aLRAjQ3+VEm/u1XFZdH9CFhioVy4gjeoWIMkPdC21V4OVef/2jnuxbom5irD1xJQ7FEI0YzhwDZAYNGX1i8uE/YvPUFJSv7c3mDfLJjJR5UUgwvgOO9yPChb0W4drsHsdfTFOjrwYDD3y03g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199018)(7416002)(86362001)(82960400001)(2906002)(38100700002)(122000001)(478600001)(71200400001)(7696005)(9686003)(26005)(186003)(33656002)(55016003)(38070700005)(66946007)(76116006)(66556008)(66476007)(66446008)(83380400001)(6636002)(54906003)(110136005)(64756008)(41300700001)(4326008)(6506007)(52536014)(8936002)(316002)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oOofj5IUK4MvT+vwt6SDahQxzqal5KctkGSGBdayclivWknmAFXbwRYlvi72?=
 =?us-ascii?Q?ypnA51BpZGZPCm7dObEbpMrX9ID287XQWb4X4aS2P4j1i2RlE60L5U4msak6?=
 =?us-ascii?Q?1kW4ikcLT8TnCrTMytnt5fI9LBuxPs9df0oElIVNjlmcAT7jSEhx1r8jNnGn?=
 =?us-ascii?Q?r8vudOwKY55zfLIfaXwSZGXolMc9vp1mXLeBBjdmA8mO5zt8UJny6SstokYn?=
 =?us-ascii?Q?CJmZH/EnkinA1yJDQZSqFUmBBOdMvuqH0oLnqvu4oOX3L/z5eCRg8lAyaebI?=
 =?us-ascii?Q?EhkuRsR+FUaCnT3mdUwUjWOb13d36lTap2DyMjrGviyJiNBqE4uFp9LNu6Ob?=
 =?us-ascii?Q?LcGpzmAJm6aH6v9R4+38o7l2GrvFRBtvONijI6ZTXyUG1Ai2nlRGPIaws1sv?=
 =?us-ascii?Q?pvk7ol3dRkwC8uH9tF1EIC0zFumjw0p5ZBpsZpnrecOc8IYxIWWpGG7F4Bj3?=
 =?us-ascii?Q?jo0ilLeU5AAlJvoPd6I4Oybipe+CzpJx6pHT573/EofKn+WuRJlxgs2cb6zq?=
 =?us-ascii?Q?R/vW65LcHcvYXYxEMtzd0/zCprn6PQHGpyC4roGdX66gPgz5lL8PO+djHD9q?=
 =?us-ascii?Q?Y2DAaz8FC+HnhdU+L445ktlxm5Y9LVq3sVK2ZQpyGXusoQWtTsESfSYCmX81?=
 =?us-ascii?Q?QHM4CztN4pZRvXQ7frUyRCoF0YU5T6/qgHL3sbuJyCCOYUTSupyt+SO8QBuK?=
 =?us-ascii?Q?HWFCiDovbRyYAwpPpNInYT+0EXYrXPCNqHkKZ7qRC9wmBRcMWDOW6AZaM8PG?=
 =?us-ascii?Q?a5IXg0l0NMH6ASFdWDNTdVcltrz1ESSQsLRZuEfKezmfoBBMnzJAyIHD0nIu?=
 =?us-ascii?Q?Jo8tpGoNmjXRUNNehKUwRXTQDZa9Ip79fCWiNwkYuxRmDZR/WzQOZQrpFKY+?=
 =?us-ascii?Q?knveYCoJUlqF9mAjWow56Tbhb3vcBX7YpENZX4Z5eyE43+z1l20j5ks56BOg?=
 =?us-ascii?Q?q8e7UhpyChtHVFs3YThGeYXqhvB0/vvKqy2Llz95R4D8rzJC6xm6W2wMBAfR?=
 =?us-ascii?Q?kVokzSV2RaYmfKe9VN3TluNmJ8bibagplgHr7QJheRYEnRAYMRzXlBdxckto?=
 =?us-ascii?Q?4VrG/oLMS9XdNs8qKKh9onYYfZ504JSyKLrhbPz85TAdtyYlFmrogR7r1fmX?=
 =?us-ascii?Q?ZRwmWpxuldedx977FgZK0cCH+ay2z8UoLjn5xsA68K8v74z5Y+VW/nnPywtr?=
 =?us-ascii?Q?+gFr004aUvPd5MO2+KrSTZ9ASPel/si9dzrrnK03wbCR6EjZJVdkLTiEPD9A?=
 =?us-ascii?Q?KABszDmL40ZNt8vY6Z6H101GVLoWc7dDCdAcghtJumN3MdyG/xw95N+EHmXO?=
 =?us-ascii?Q?fc4LgparGBvibm0hdVtqkUy/KFab+t5WxcI/vERqUCO41BEBVUZJl/LyOuSf?=
 =?us-ascii?Q?cG7R+XL5WHN6ZW9N5B9ywp3QZHr/mBgsquBYo/Sijw/15r0BjwEyKoK+Bk10?=
 =?us-ascii?Q?9c2cF8f3zGf2wdrQ50gc33CAk8Bictk/6F0/kBxb9pGKOK8u7xnN24CpAI+u?=
 =?us-ascii?Q?I7oQt8gc3lDq/wToMLZmW0Y+wvNa3ByH6MZc/k7XxjjjSrAg3/mvlXbdO6fc?=
 =?us-ascii?Q?E01uL2mSDFR0ZzAiL/yPthOpWY56G3OqZ1CRciwh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec7a0ca-320d-4fff-57d1-08db15735008
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 07:55:21.0579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +bOsMSJeZ75skEEjadFys67K1mQ6JJk80NMcn8X8Y1+q0SUcNoX+MBm2BZ3VFI3vAf7oOkj22N3RjjIYL53D1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5551
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Thursday, February 23, 2023 1:18 AM
>=20
> > > static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> > >                                struct vfio_pci_group_info *groups)
> > > {
> > >  	unsigned int i;
> > >
> > > 	for (i =3D 0; i < groups->count; i++)
> > > 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > > 			return true;
> > > 	return false;
> > > }
> > >
> > > Presumably when cdev fd is provided above should compare iommu
> > > group of the fd and that of the vdev. Otherwise it expects the user
> > > to have full access to every device in the set which is impractical.
>=20
> No, it should check the dev's directly, userspace has to provide every
> dev in the dev set to do a reset. We should not allow userspace to
> take a shortcut based on hidden group stuff.
>=20
> The dev set is already unrelated to the groups, and userspace cannot
> discover the devset, so nothing has changed.

Agree. But I envision there might be a user-visible impact.

Say a scenario where group happens to overlap with devset. Let's say
two devices in the group/devset.

An existing deployment assigns only dev1 to Qemu. In this case dev1
is resettable via group fd given dev2 cannot be opened by another
user.

Now the admin upgrades Qemu to a newer version incorporating
cdev and your change. Then immediately dev1 cannot be reset
since dev2 is not opened by this Qemu.

Do we consider it as a regression? Or is the answer to ask the user
to upgrade the mgmt stack?

>=20
> This is looking worse to me. I think we should not require userspace
> to pass in lists of devices here. The simpler solution is to just take
> in a single iommufd and use that as the ownership proof. Something
> like the below.
>=20

As you said the dev set info is not exposed to the admin today. It's
only available via VFIO_DEVICE_GET_PCI_HOT_RESET_INFO after a
device is opened.

My question is more on whether in real deployments the mgmt
stack always tries to identify the reset dependency indirectly (is there
a reliable way?) and assign all relevant devices to one VM. If it's not
the case, then this change (requiring user to open all devices in the
dev set) can certainly cause regression in those deployments because
old group-level check covers more devices hence has higher possibility
of being resettable than what your change implies.

Alex probably has more insight into this usage open.

Thanks
Kevin
