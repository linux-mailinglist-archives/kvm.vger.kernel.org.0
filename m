Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665A36C3479
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCUOjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjCUOjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:39:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FB215566;
        Tue, 21 Mar 2023 07:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679409575; x=1710945575;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FyHWlNSKtyXFkwJFYDVErztOxjBXb1KZ8XoHjwRxteI=;
  b=WI52VY+SR2K/5p/HIrETYqQ5mUIDlWYN9DgwAPJURlk00Hdil+WmuZ+B
   jQIiMCySW2tcom57hyNZmZx22VlenB2b1CgqGj61Hn2rHW8Gi4ottVs53
   UTzZSGdPJWXvjgRR+/Unvwj+wnLUYuTyAYmgbEi7eFJixOWnd4sRjgMJm
   ScfMuiO2Ed3hANJcEP5jNojPJoewglUMPayBvvQjevsR6GD4ZpeQL5ByV
   AobKa7WkU0/0nQrocSLXyCzBp5OZYfOqKZaMXeEDXgTdrAXhea7qT5unC
   QJvug6SQR48gfilJdhzet8fhhVOdHXxSAdR1vSDh5Xc9/EaQRvmmArNwG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403833603"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403833603"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 07:38:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="805388087"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="805388087"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 21 Mar 2023 07:38:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 07:38:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 07:38:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 07:38:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD9TvHObQWqDERMN1+E83FNz3KaTEoT8TarI4Y+MlvYHDbNWExBhDEByhPRkmGJ7AIerv6HOQEYpsFMSN9/D1ytB8PGUfer0wiUQjt9NkOwl3inTauMO/uA0YMheQ6lz1ODpZNrLr+HHvvtSqA5esZ08WA9d9gdrPb0RyEbsCSop2EVbafjC7pZP9w72GGnzyUHU9yrYTaNJ/cBrUsjEQPALV/6fkaJILY5IAjl6t625C3c9lQsE6hCuLyA/eROgZABPx3WKQXjlEUGcKEeInFCC/NPZBUChJHi27B/QMFXpXOCctwsTmGbN+dpNBQ//YO+p/Jh6VBLjZhaVqq29yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WIqYn9Hq16bqRUZ9i3PUvx3dRQ5FnqJtpjuofB52oU=;
 b=R36BGp7jaLsbAjc2depgx1yd/sN7adOEZ/3j952oUqRg8yvM336O30LiPV3YQu6KepK9mMNacPpKzSL5y46foZ3uDk2iIZcKv/h+LVw3hXYjrrJiPtBAKqCBSlEsWiU0K40bMVie1Ge5AhZtPaia9u9skRKGOANoHXxyXRXTBVgF/cT6UpbssqUmL0qI2TxxLRwQUrO7YVyO9mS+pwYXrO4oinKHbI8ssDypeIe7BrnAkhr6hSslNkwUjYM15hj6IqFWBJqcCsZ6mCAPm4mzWE4cVx+2DXTC6qxUR1vtQ+dIfjvGEiRxf1UrIOhyj289nLOV8LW3OY02ukioIE9g8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 14:37:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 14:37:58 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZUcIP+SZa7TzGK02S6HlHFxIIra7zumiAgAAAm6CAABGNAIAHfd5ggAh9XYCAAAYegIAALgEAgACKCACAALARAIAAKW1A
Date:   Tue, 21 Mar 2023 14:37:58 +0000
Message-ID: <DS0PR11MB7529569D40415AA283E1EA55C3819@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
 <ZBiU8KoSmiM+JkAw@nvidia.com>
 <BN9PR11MB527605E6609222431DFB8AA58C819@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBmcbMuE4lyDIpT6@nvidia.com>
In-Reply-To: <ZBmcbMuE4lyDIpT6@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7641:EE_
x-ms-office365-filtering-correlation-id: d7b59ee3-4369-47d9-71d4-08db2a19dd91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ofNQ0yJBfISzh21FXhzXzNylwEUjTfC0QBCElub7mzngINE5Df9n2hkl1ORDjgMmhG0IAhUkT5drUvHjnFNUoyWTbEw4j/AmwkG07AtKmmaAgvRxDtsoQa6SYLehw2eGlMwuY4qtCKxHazguhMl5TG0GNkTwVFDlT/yh4ljV/sSNnCyiS+sQ5BG3NtTRZzTs09JattHg3cbrushFb1dacHIims0F93bVsYzi8nuP/OtbSZBLsPNXVtqViivISzrb61YVQrrLTSnL+BS/J30thasR2aRVnNUnOd0BiteR+1SI5oCu4M9mvl9xWg/8BYS62I8jzmHaDYc2tX5h2iiyXMufjvBFtkGoIAmPPmMURz0247WpPE+xUzYbrihDw3L6p6yIRkc5aH5TJkt53O1BL8ry3fA9RVSwTHxXyre8LB2bFVlY77iUBqt19NSTE2Z6rJT4oSNq2hyRJifr+KqvjygrGNp+YHzFLYMgV21BUi6oRMiryUwWgZykMv/dxsXBsYnFEte6rKyBLxwdSOuJ1bomF8+11EOjVMQT5CkNh5BVQCcUdiOIiD4KtYfXSniftrjsfiDDsX1yMceqAemWb4NEk4hBU09J8A9t4HdHCu0K0kwPur0gtALV2ftZDtpcWJ9fUMn/SxkZp9deUWQmB09tu/DFx+aI6Oks51tSKl8vN29onEad0Ap/Wjxguz5gIh42fk3OrqTJBky8hSw+8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199018)(5660300002)(52536014)(7416002)(41300700001)(8936002)(2906002)(38100700002)(33656002)(86362001)(38070700005)(82960400001)(122000001)(7696005)(76116006)(478600001)(71200400001)(8676002)(66556008)(66446008)(4326008)(66476007)(55016003)(64756008)(186003)(316002)(66946007)(9686003)(110136005)(26005)(6636002)(54906003)(6506007)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LQg5Ah3N68C2R2xpXBiVpy5n67vy5N2+Jv5RnePkVSFyRYOm/XDQdiBuEkgo?=
 =?us-ascii?Q?B1gjwz4ymNetkF3VBUlPvDpSv2DvBiqf4Ek8qTqD+zS0qbmmF2vzOvU2Asdk?=
 =?us-ascii?Q?CCgeeq/Itm9XLQHngHwNsRJ0hSXBXQs2HDpEFnsbjQDVNQWqwynUMrS+I5Vb?=
 =?us-ascii?Q?bTKiOl7E/x9F9TjShF7SL7gLOvTksNw/YaIF9lMaI2mH+OaLCrc9k5qLT1LH?=
 =?us-ascii?Q?sxYeNInfQfrh11Yv05ECaPlwe/9IH5K4tSIleDdvc3/ruSHQIXklU30Ndrat?=
 =?us-ascii?Q?LRUClNsFNQXcXIEraLiSJw2hjSBjBQedRoMTdmgPnqFiOHC4r6BaiMMPt/rW?=
 =?us-ascii?Q?p5A3KmzY5ezQ08a8D+Z9bc68bMT1HmQ4cvWEU8duGicVSGhtpPvpkdYqCDvZ?=
 =?us-ascii?Q?0jUHnarSh2HhBm1qzAaSvwWrXvP8wP7ntwWQuDll9on+D8DnqEshFJRyOuVK?=
 =?us-ascii?Q?zF3RUQTCfLi7wVUj/r+y0CjAGSVYFeJeQRNJ1+gwKW00GiUr6+tFJ4gcpLcy?=
 =?us-ascii?Q?Omxj2ftpHkXlNFp/Y1XAXUafGDCQcX7+n5lRQOhD9MGvU/StJgingFvmCRku?=
 =?us-ascii?Q?GmzLs+VrJN2ljacoh+0ec5VO5rO2bu+rIr1x2XZsW3Ff/PBfeLCt1KUxRj7t?=
 =?us-ascii?Q?NPd6mSNgIOC2JboR2Wwbgtz0G7pHIYM07C1KyOwnQc961YROV600kuvYHr6F?=
 =?us-ascii?Q?yzTHVlcp2TqdUX1ucCJ7YuZv+EcDDWfv8Gj8ngMkxl1HkqCsjeeuxI0c1VOB?=
 =?us-ascii?Q?dNg/DGP3b5SCFXavbbTTpz8r9dl7DjFpUgabPJ7i1t2kfJWOBqD7Nzd9wuuf?=
 =?us-ascii?Q?TfEQY6XvHrZJHRWJCNX8W1hHsv2qIf3d3zJsdCdmyxujWv73f8w/M2Xbk+72?=
 =?us-ascii?Q?XJTk36jePDScSrkRkpCiR1eLKTZZ0Mjcl9dlAfUqyyNrHQpHUzjdFLNUDpR1?=
 =?us-ascii?Q?O8sUfCfXXfEy+Br11gu0ozprgJtcmCpWlK51ECzeENatGEF2AenCZJd9ex1t?=
 =?us-ascii?Q?LR8xBzUHMZ8oTPlRcoGJOZOBRIKfkER9CknobagBvZeEuqFwnorBeCo02q/c?=
 =?us-ascii?Q?xJWt8lcQKZbdahRBvTtcIQGGQvrxbqjZ2lTpg6JLP355T2hYVN3KniLwoiRd?=
 =?us-ascii?Q?EXVIQY2jXmbQRBrICqXSrpUMANI6v9bJErpjuFFidU3EHglD2aavagDxCdwS?=
 =?us-ascii?Q?Af2B7ENB68WAhhakFqiVjcQUPQNor+iL3HD3M8YLIcS5d19MZFCGcHxnuqoo?=
 =?us-ascii?Q?6lfhy+ygHnAxPRQb0m/alY9GqIk5UXvzSOns614kKsBnFco3qEZrCpsPQTrJ?=
 =?us-ascii?Q?w/oAUUz9oYALOhxubU765oM0xs0glaopm6KjY7+mE1QGG9RLGZoCzdJTIFLg?=
 =?us-ascii?Q?KGkfYRWay2aquJuiy87iFqiLy141YJR3g8OyhOXH/ZhKLF8ND9hAeeR3WG/p?=
 =?us-ascii?Q?MADs7cjRslsQEU/iVOuLmuqIfinOe3efNP913NV3pjRRqUdp2EITWBPKjZt0?=
 =?us-ascii?Q?ahts1s1EsPUCss01/rDNoiO1UYjS2b1LHVZu9rVdQHRnztSahP1OA+0n5QlN?=
 =?us-ascii?Q?vsHuny1aqW7lNIPQBsoXQmwhFGBIKgbajwGTEK9D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b59ee3-4369-47d9-71d4-08db2a19dd91
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 14:37:58.2434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6jHK8TWf57Kw/JF/KymK7rFCTtch3ASB4uJN4feUaQpgr9/VilQidJ4W5ggiFOa5tl5Q37c8j88Qrt9Rrm6xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 21, 2023 8:01 PM
>=20
> On Tue, Mar 21, 2023 at 01:30:34AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, March 21, 2023 1:17 AM
> > >
> > > On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> > > > On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > > > > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > > > >
> > > > > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > > > > static inline bool vfio_device_is_noiommu(struct vfio_device
> *vdev)
> > > > > > {
> > > > > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > > > > >                 vdev->group->type =3D=3D VFIO_NO_IOMMU;
> > > > > > }
> > > > > > #else
> > > > > > static inline bool vfio_device_is_noiommu(struct vfio_device
> *vdev)
> > > > > > {
> > > > > >          struct iommu_group *iommu_group;
> > > > > >
> > > > > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU)
> || !vfio_noiommu)
> > > > > >                  return -EINVAL;
> > > > > >
> > > > > >          iommu_group =3D iommu_group_get(vdev->dev);
> > > > > >          if (iommu_group)
> > > > > >                  iommu_group_put(iommu_group);
> > > > > >
> > > > > >          return !iommu_group;
> > > > >
> > > > > If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> > > > > iommu_ctx pointer in the vdev, don't mess with groups
> > > >
> > > > yes, NULL iommufd_ctx pointer would be set in vdev and passed to
> the
> > > > vfio_device_open(). But here, we want to use this helper to check i=
f
> > > > user can use noiommu mode. This is before calling vfio_device_open(=
).
> > > > e.g. if the device is protected by iommu, then user cannot use
> noiommu
> > > > mode on it.
> > >
> > > Why not allow it?
> > >
> > > If the admin has enabled this mode we may as well let it be used.
> > >
> > > You explicitly ask for no-iommu mode by passing -1 for the iommufd
> > > parameter. If the module parameter says it is allowed then that is al=
l
> > > you need.
> > >
> >
> > IMHO we should disallow noiommu on a device which already has
> > a iommu group. This is how noiommu works with vfio group. I don't
> > think it's a good idea to further relax it in cdev.
>=20
> This isn't the same thing, this will trigger for mdevs and stuff that
> should not be noiommu as well.

But the group path does disallow noiommu usage if the device has
a real iommu_group (the one created by VFIO code is not real). Would
it be better to keep it consistent from this angle?

> If you want to copy what the group code does then noiommu needs to be
> statically determined at physical vfio device allocation time.

There is another reason which may not that strong. For devices protected
by iommu, user needs to program IOVA mappings in order to do DMA. Such
device has a real iommu_group. So if we allow using noiommu mode for such
devices, DMA would be blocked by iommu. Perhaps users that use noiommu
mode should not do DMA at the first place.

Regards,
Yi Liu
