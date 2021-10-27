Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174E043BFDE
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 04:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbhJ0Cf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 22:35:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:13813 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhJ0Cf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 22:35:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="210840991"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="210840991"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 19:33:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="465556624"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 26 Oct 2021 19:32:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 19:32:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 26 Oct 2021 19:32:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 26 Oct 2021 19:32:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 26 Oct 2021 19:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jjt5lQClSg0oRr5MWN+Hvrdw0A8MUxyIOHsz+qnbHkYkRUgn/2A0RSsDqxjI4gzLLkc9FiTGzz6ayED0j7YzQGt0pTXajxVkqruwl+p1Krc10OsMIcPXaI7Uu32vIaKDCQ2FBUGUxtkSYVgZmKjxxV23TL5lBmHeMhy8D1QoUKp85nmFGVHHLubSLgkzQG40ZyZByyhA0REIh7sOZaqysZtosg0yyEvOiMOHFvq/JvZRTBy3lBGV1nlN6c/MjxT/wpRFg6QOsTyzVe7Vfrwrtz9BJfe/9Q/K3RgZ/r0F/ik7aAibJqiFVE33bDbznfvJc46XcJwOJ3vyZLxetpzjbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4IUoRq/0aYRJnYozVD1ywts8t8n/DCswoLw32yWlgo=;
 b=OJFsTH/2xTwZyYufQoErcONPIn2LB7WAI6np4wZhUO4GfsASAItw2KKGlza/phv5ypWCauXSDenfbtXgqfBoGXQQuOYLDZRontRv4J/26YhcJ6WoHhAhmrBcxPvgXirRu4ioE/oJVPVxGh1CM3FBxnZS7pr3+Ze2zANcTv4eAVfabNZHeBE9/GN7huMmWi7YDo8s7Goj1/ab2dehvD2F4IC+flb/6D9HV+7/KdVGQjlKYBk3hI09l5nzcXqGIAe5K5ZM4uC/FMWgRGmsvRDmkshdtkWLoNI6aa5Fr90VLtddCtewMwrFMbQYqF4fg8f6h52NRVykXCX9rUP23hhDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4IUoRq/0aYRJnYozVD1ywts8t8n/DCswoLw32yWlgo=;
 b=FkzjQY1uiSDbu8o62UzU3eRXBpCk59LruL2mvZMzT9o0YG6OrpheU5fu2mjmrQdhOrDV2F6Y7BYhDONNDnmN3oRQ9Rw8AIpognzoV4nDS7LilV/TR32ctDgP4u4SrLk5tWh6NuVeCQBYm6Mncz6FePeKQmtOLp0lBFXOHaudZqw=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1268.namprd11.prod.outlook.com (2603:10b6:404:47::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 02:32:57 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%7]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 02:32:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66u9vAMAgBLi5DCAAXeHgIAAGqnwgBEwZ4CAAuw5IA==
Date:   Wed, 27 Oct 2021 02:32:57 +0000
Message-ID: <BN9PR11MB54330217565C687A7275AE458C859@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com> <YVamgnMzuv3TCQiX@yekko>
 <BN9PR11MB5433E3BE7550BBF176636F8A8CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWe5U0fL3t+ldXC2@yekko>
 <BN9PR11MB54331C7936675EEE27C209948CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YXY7A+UQWC4gbIJc@yekko>
In-Reply-To: <YXY7A+UQWC4gbIJc@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7afd310-80df-4fd5-d87a-08d998f21647
x-ms-traffictypediagnostic: BN6PR11MB1268:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB126886E39772563A89C77C128C859@BN6PR11MB1268.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRk5ufwh0cPYz5oKqDrgUYvMdM1HDo64YXrXPYEt0nWSS6IhJv7enjSxrukGM6m/evtmhFxbXo17R4JFcg3QNigIAjZ9ShvChGP1A8kTmS0UIkSwHVF3CpO+Li8lM/SfFjoFfRt3cHxYFC2mQXP0NfMSgVxDsjeF7EIjUWhcb3809JgmVA05VzobO9eP+ZJK3qR+0YjbEyzCIq7QX5VJDIBwkZFQXFbK5iihqd1uK8qyFI6uW++tdQ3XLWXo8KykKGtMBQV8EPWKyO5KyOUSuQCMDStoXviU6bAWoKQRehMj2ldXUrku0fFRbsR7TKOGsxjHe7YzCZhISuXi3J1JxsSmyhf/ygG+3LHfJcipgIQzWhSkcy2d2DFq2QR9LXpdVf7hdDpS3TKwXkSvjMD2+EKlodLYWaBZhGqXuhZyQrwdIFQJ1e6OP7FNoLu9Zb3peKVqpAAC4Oqcm94duOaAAiEt1f0+qyqnB5NP0qOElh34jd0S+YCB1aRH4JcKJGbBahYWwd16qKrCDxTV4lJXAhws10k7bjxQzGHphUsplsxjRO6wgMmmgsxfQoKe48nHhVhsaLfG65CTvA6L/juuqQjq5g0cOgODJmfW8wAy2FtNuF2VfXntSkUzqIrgx21M2qj7/feUSTG6Y2u+Q8xmvOGNR/2yQ/+/OJbRvf8812B32buvCTsaYV4Hy6RJ2RsBQxSwxsl3e1t7WN4ml2pfFKH43fSvrgcjEDVlvltizko=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(38100700002)(86362001)(66446008)(122000001)(4326008)(38070700005)(2906002)(5660300002)(52536014)(66556008)(64756008)(66476007)(66946007)(76116006)(7696005)(82960400001)(55016002)(6506007)(26005)(33656002)(186003)(316002)(9686003)(8676002)(71200400001)(7416002)(6916009)(8936002)(54906003)(83380400001)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U2QPF8Nq0hkSU+FDavWDcv4RWtYskh07DjO5YsKfNAr09k9htknGh6lBveCw?=
 =?us-ascii?Q?FKf+f0EryLLhS61BPACob43j35NHtd8ah5AiRMsJTopa+lLVwwhpJnSYYvF3?=
 =?us-ascii?Q?s8EHJDi6LRWiL2q48hocRC+8SyH74ctadNp11jXgG+n3DCkbeg1lgzV83+bw?=
 =?us-ascii?Q?lqyV3KMKrFSC+tJSz4s/VWtqMi4oz9iUKCWeYVbu8z9esBp2dNLUt4jGa+m1?=
 =?us-ascii?Q?0UwGer1Yw8FbH+4Ecz2iRIO30+L5xV/+Louq/2kjrkm/f2bcUL0eGDO9b4kg?=
 =?us-ascii?Q?Rd7cJkautQXwfa9YAOGPRS8WpZlcmYNK5qicPBDotiU01lHMkTXUjUpGcgPD?=
 =?us-ascii?Q?sQQ9yI/hAoX8ACrrj/ie4xK67EBsU1Ze0RoIUVrYtsEQKQsmb51uraW2khCW?=
 =?us-ascii?Q?L0W5QTgr1n2MjFiBU2yNF8cdUazhgR4W4jtUlsGez0TilifqkVMpEPK1p+Fw?=
 =?us-ascii?Q?VMQ6eifybU+IyzBteyiStT7NIYCMLONbxCTkdFaxIeM6+rnjSX/sduadmPq6?=
 =?us-ascii?Q?tBXVc8wgmyX/5k4unMoFWnwj5MQJQCftCCBtHb3EREhroJEGc/8/I4RlECEq?=
 =?us-ascii?Q?o5gt8UzVk+y6fIzpvP5eSJhQenv2nUUFIOnH0EL8PVkaWJ0k9/QpeW7Zpx+B?=
 =?us-ascii?Q?qGY68NTILhjaSCdtwqheISJVGIcGw2TCa1bPPHKEzhiHzgDiOJzpBAsN0ekR?=
 =?us-ascii?Q?emrDIacfCq/vrPJ4gsRDmrp/bQ3kugkSZdd0Mu/A+3nBSuAd2LHR0ygwgfoK?=
 =?us-ascii?Q?AFjcGlryWeaf5RUZZwdDQrwWa3vbKSMi0Bg6CxLOsLnQvDBlcXCevZMJ5fuI?=
 =?us-ascii?Q?vWsTystsaeiwhk59F5QGTcyqMrv4kmDlkA6+LToEBEd/HRmbdCc6+RuShGYO?=
 =?us-ascii?Q?KE5s/J6aexfJdhpHdh9gjrK5Lv+wHqtHgomgJSnOKrC6+XCkjV6TIgiLTtPf?=
 =?us-ascii?Q?Cm1QgjJO1e4QG05eNq9auOAVHmMpBaHvhyRiuDjCCI4QrpdVsSWVJyb6MBPb?=
 =?us-ascii?Q?AGL8JLlv3kuO81MmH4LfUpTqB6+8zMKK9ljAi6hi3NH6Obmoh3gFMrvftSXz?=
 =?us-ascii?Q?C8h5dDl4aJfReuZ6CGTYnCT8edd6CMd7ppZGjEsCiWplMY4aUar8X7zBThdZ?=
 =?us-ascii?Q?tpvhgMpaTYliq/6Lr8ExvHMDKFetaPY6qVCINEwqSziVNQg1ggE30l447orf?=
 =?us-ascii?Q?2hIkCy0i08WK/OVfiuv1kDCnETprjacSH0ocCoQN45tnB9ErR1l6qREekJQE?=
 =?us-ascii?Q?tI5NV9yPi9gLg5VFLYj2pOxe9WvtrzzpRLPNtY+cZR7wWoTOxqGHhESFFshX?=
 =?us-ascii?Q?bONVv2k2J6vxHb1wcnNQOQbTsNe4/zj2JXfWMFz7kqE4TY779Lbo3QA7ygSX?=
 =?us-ascii?Q?6kxnTS+6SqiZsYT8HO1usfsv3n7LmqgnEPwqrX1lSOxbniOZ82U2gymzdx2P?=
 =?us-ascii?Q?VedUdf4flCKUsl48VwSLKeKY2U83WDUIogKzy67LEYvLXs3I3iie/8el3eiJ?=
 =?us-ascii?Q?LmmDQKFneJvQPGsi9Xyb9aZ3FPQ/WJnweKGGgdCasacqfG+RxkhdjdwU1SjQ?=
 =?us-ascii?Q?0ODB0jmSbaRYVjvvqDicNsj9EZhgC5iaLQRmSmRzt6km0oZhKME8sClWMgbK?=
 =?us-ascii?Q?ZQnAjaWhjdxTnc5rkOZmKJM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7afd310-80df-4fd5-d87a-08d998f21647
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 02:32:57.1287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doqkeg13V4D7agqnFiIxNrAMDrol8c4RvlJh1FK/oLL9sdW0jPShhgwtRk3xCCSYOfaLPyLwQnrGbKMWTTuSxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1268
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson <david@gibson.dropbear.id.au>
> Sent: Monday, October 25, 2021 1:05 PM
>=20
> > > > For above cases a [base, max] hint can be provided by the user per
> > > > Jason's recommendation.
> > >
> > > Provided at which stage?
> >
> > IOMMU_IOASID_ALLOC
>=20
> Ok.  I have mixed thoughts on this.  Doing this at ALLOC time was my
> first instict as well.  However with Jason's suggestion that any of a
> number of things could disambiguate multiple IOAS attached to a
> device, I wonder if it makes more sense for consistency to put base
> address at attach time, as with PASID.

In that case the base address provided at attach time is used as an=20
address space ID similar to PASID, which imho is orthogonal to the=20
generic [base, size] info for IOAS itself. The 2nd base sort of becomes=20
an offset on top of the first base in ppc case.

> >
> > regarding live migration with vfio devices, it's still in early stage. =
there
> > are tons of compatibility check opens to be addressed before it can
> > be widely deployed. this might just add another annoying open to that
> > long list...
>=20
> So, yes, live migration with VFIO is limited, unfortunately this
> still affects us even if we don't (currently) have VFIO devices.  The
> problem arises from the combination of two limitations:
>=20
> 1) Live migration means that we can't dynamically select guest visible
> IOVA parameters at qemu start up time.  We need to get consistent
> guest visible behaviour for a given set of qemu options, so that we
> can migrate between them.
>=20
> 2) Device hotplug means that we don't know if a PCI domain will have
> VFIO devices on it when we start qemu.  So, we don't know if host
> limitations on IOVA ranges will affect the guest or not.
>=20
> Together these mean that the best we can do is to define a *fixed*
> (per machine type) configuration based on qemu options only.  That is,
> defined by the guest platform we're trying to present, only, never
> host capabilities.  We can then see if that configuration is possible
> on the host and pass or fail.  It's never safe to go the other
> direction and take host capabilities and present those to the guest.
>=20

That is just one userspace policy. We don't want to design a uAPI
just for a specific userspace implementation. In concept the=20
userspace could:

1)  use DMA-API like map/unmap i.e. letting IOVA address space
    managed by the kernel;

    * suitable for simple applications e.g. dpdk.

2)  manage IOVA address space with *fixed* layout:

    * fail device passthrough at MAP_DMA if conflict is detected
      between mapped range and device specific IOVA holes

    * suitable for VM when live migration is highly concerned

    * potential problem with vIOMMU since the guest is unaware
      of host constraints thus undefined behavior may occur if
      guest IOVA addresses happens to overlap with host IOVA holes.

        * ppc is special as you need to claim guest IOVA ranges in
          the host. But it's not the case for other emulated IOMMUs.

3)  manage IOVA address space with host constraints:

    * create IOVA layout by combining qemu options and IOVA holes=20
      of all boot-time passthrough devices

    * reject hotplugged device if it has conflicting IOVA holes with
      the initial IOVA layout

    * suitable for vIOMMU since host constraints can be further=20
      reported to the guest

    * suitable for VM w/o live migration requirement, e.g. in many
      client virtualization scenarios

    * suboptimal with VM live migration with compatibility limitation

Overall the proposed uAPI will provide:

1)  a simple DMA-API-like mapping protocol for kernel managed IOVA
    address space:

2)  a vfio-like mapping protocol for user managed IOVA address space:

    a) check IOVA conflict in MAP_DMA ioctl;
    b) allows the user to query available IOVA ranges;

Then it's totally user policy on how it wants to utilize those ioctls.

Thanks
Kevin
