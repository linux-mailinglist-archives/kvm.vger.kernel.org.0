Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDD6D0561
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjC3Mxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjC3Mxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:53:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC821701;
        Thu, 30 Mar 2023 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680180827; x=1711716827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CBH49rGJ+3Sedr0H/Hae98dY4p4zknobMm/oIipIBaw=;
  b=Pd1VJJHLs/lQPj4kBQIVFUL/hH2t1HPKrZqy15pcIaeNkDxvjZ4o1TXo
   mNMCJevRrd7RLzIjPLE0WwLlK0cQWXT4OcU92Wz3tLeoL6v2X+ZCvuhz7
   b6nzFuVg/b/YFPaIu1W8q2EV4++f6ww3KPZnBvWz4M6qGNO6L6HYn647V
   j9zRZd1Fj3mcQ0ZSHYbUxcnfxrU+IjISPkRMU2/BgoxqGEJo3snXxMN+F
   6cwfPerBJUGuRyXwW1fxb/CUhoJVS3WwLG9y2LiCh0QedWpdvldB5Lhxq
   uOd1YQuPw0N32nRyMoSKcjqvedkhJ2jo15yPIru1jhOabsmMnsdlbn6nX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="403810928"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="403810928"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 05:52:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="714962244"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="714962244"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2023 05:52:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 05:52:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 05:52:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 05:52:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGj3MYCyrZqc4DjQSR603R8PBnriX+5jBq6enVKkO9aBWrKsgAXXklHbHNe6BOKYz/xLUMSvo8etbo8gfem+2dP7OWdCdUGeNYx/iiAnF0I2rZ3V5E4K+P1u6Dmkhef2mXrDQCNdl6JzWYXTQlNEhAJRNIfBzbk90IKn/Fe+UV0uW94t6ZKT078SadQVIpDfLdN70SJ2lrkeXC3lD+/yYXSaNolPqHiSDT1GE2YCLOjRUEWhDvwfF76NsD8GZZMTkZxVSBnPaFzYOBs7wOKkVIAF9re9e/6k+vqaaIcQMl+uWxPQwU+cscGIVPLoId0jaB9uWuo69F7uUUtbXL5wzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdkFyGvtYbRQmK0SdrJXgcD09zC7gDTOm7fdHqQLDYc=;
 b=XAEvs02fmZWoaRd39hT6L13LznlTFTcjD4a5kjkJNXWeGCAwDOy5YKZP5aSl5fw6j1FYazKVLrwret7eeWC9Q/yWl8Y9LqKECDs6zsujtjIov2MRyAnnoRn0CaesrYq9hm/lgSFtx7uCeMbH/J2jeoDfYmHQN+XlqGJ1vtfvdo43kDPO1hGlrKTkqnczSRycZMGvbhkh/dXZV4uW30Gl18SL6IiBrK5KUVjgIEyQJklAolEWgmCLSPG43y9fW6fUwNAhSZLhJPPfUWN216oXutgIPX3YyHG4H8Ow/Hc2fH+haQ3EiQcOcOSg8a8HIPZDdQtfJEbfMamYFhQZDsSGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 12:52:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%4]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 12:52:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZYJBFW/d43vElu0ifua7qv0EiF68SQfqAgAAne4CAAOE7gA==
Date:   Thu, 30 Mar 2023 12:52:39 +0000
Message-ID: <DS0PR11MB7529B03CED8FE7BCA284F789C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-22-yi.l.liu@intel.com>
 <20230329150055.3dee2476.alex.williamson@redhat.com>
 <ZCTIJScfgbWWguD5@nvidia.com>
In-Reply-To: <ZCTIJScfgbWWguD5@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6803:EE_
x-ms-office365-filtering-correlation-id: e09cccbd-e1ba-497f-b8e1-08db311da4fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jgwj+7QXoylWyYff55ec08DPXqWyboDHHZi6+CRciCFi83rdL76E4d+H7LQKgIZxGsOwAihigD1Dy+XivpfPeGaaY5Eq27VghZ9b1e1saKfS/7ayhAy+DdeE7+7LtKni2EPP9/J54fPgkfpVRamHcoY7rO2zVsjZk24jhsymcdDhM403r2sENH5Or680MswMPp/d6e8V2gGcUbrNnL3V0cJMT78PkZLSKiaGUsupNKpdjYgMCutJA4qog6eI1lIUUE0WezYQpcnVw57vyOw7k7AnxDCG2qZKtUWiwDy0UONjuBJ01mrSTVcoBiW0BstZqp2cybJ8SEhP1gomd3YDrZUS7xkTl68yFHSQxLHtEUWefYoHt/Y6ZIfdXp6phSfj5plxDYkbjYkZAuKaGhWbmVhWoHquoWhepb0Tr7nmF7wiU11ePTquLZuVkQTNYRIHnEu1bCA1+lfLVtKZOXy2K/T8+alN2OpOXPcFIXGVDv/3QDBVK9P4f3w76PMu8Pf1TH2JzGR5ESudiDTjENVcZ6D1EpLpgGNtKXIOQlm0oMFGYXxXU4BVcvaDItgea/oF1K65V0vYi9R/uaatGeoO91fpSea65yUUjVWco9BJyzAlaBgnM6pfFvlo3owXpssw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(55016003)(7416002)(2906002)(478600001)(38070700005)(71200400001)(33656002)(86362001)(7696005)(41300700001)(66556008)(316002)(64756008)(82960400001)(66476007)(4326008)(66946007)(66446008)(110136005)(38100700002)(8676002)(52536014)(5660300002)(8936002)(122000001)(76116006)(54906003)(6506007)(26005)(186003)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zBaw2a5L07p6I+xlS6X9QYMwQS/L0yZdhB6FzS4KigiETEfKhDWA52/oldDi?=
 =?us-ascii?Q?T5nWtnC13gmESG6S204Le/Vq4peqcOgmNKwD4P2sDTKLsEMOsO/YCMw506bu?=
 =?us-ascii?Q?3SbWYx4t/Qpq2dGvz+1UhgVYNVVB/XbUNSoKeVdxG6llYCvqvcnnpq0zC41I?=
 =?us-ascii?Q?sAQdLgba71cgnWzGfun7OyeXYaPegvpPPs6GCPWDwqPx5+URnqgZiX4hSMlJ?=
 =?us-ascii?Q?hxeiFkaJbWgkd7EFQlOudOKih5iW4VK0dlqVqpEj+02yXG4Y+se0PPyli3ko?=
 =?us-ascii?Q?E5NmRRW3YwcSXN9MQjE6ifQZ0V5LjCroVvFmVNID+UvZ61HGBZltNf+Sp1MM?=
 =?us-ascii?Q?8htcCU5vZ170mdLVYoONHjUi7N3eM5buPjo7KYV4NfbpLDpSS+xGKEgeBqvh?=
 =?us-ascii?Q?savqFdYjiT+xiNfNGXooCVyrlrUHFe3OH6fOImhD85kehdKk9fwj62msWMt+?=
 =?us-ascii?Q?H9pcYCXf0QDPZUIhb/AXap836YNEoF+dmVg0BKloXS8K0C4MCJgdIw3Od0Bn?=
 =?us-ascii?Q?kkd+ORQ7RIjn+TjFn+zE10OczoCj0oNHuUf8qlHbipoP+q/pKdvvcOzlydQt?=
 =?us-ascii?Q?+79lbPXiCF/6nvbWko6p3lYhviqXWjom2tFCfYHyc0fWF3TyzbWUhjymA8/w?=
 =?us-ascii?Q?cF5AzmGFYXZc69QAhqQbC7ols1BAWziBP+KIse9F2kMr2Cm0Cz4NaL+caMM3?=
 =?us-ascii?Q?75jboc8kJtpg1a9iKrRcrHwPjjtznno/l3VA0uyRei59EHs+8Au9iAcZqhA5?=
 =?us-ascii?Q?KjE+2pqABCFSSvnzepIZ5dkQpbNNO2GXwWBXmSSH60glECqIj21ukufKvgYF?=
 =?us-ascii?Q?bhWQe2hMJQsz/kPAam5zBYxswhJl6iDn7UnDhfh14jb4jkp+cAxKo98lq3aF?=
 =?us-ascii?Q?6JdjThN2umMtDouybHxh27MCu2RCIFRq+DatRHAozJolRfLheiJGOPFr5Pnq?=
 =?us-ascii?Q?VRYyKiVpGTf2dy3NFlcUk7t+/LdlIL10ossLn+sYZoLYzt7kSPq97+tqOD71?=
 =?us-ascii?Q?2kaBVCydbp4r4qNBtBQQH11imolk+ZISSaXXKh3c+/bcCucOzgSu2nRa6LCu?=
 =?us-ascii?Q?M2HOKNF0QVjwLrAVavJ6qiCm21B7MX4RgL8KSiWBEQGl/wQ+Le05aWw7Rxz8?=
 =?us-ascii?Q?/zdgPSmb8SUpb8UCdXROjjhCVdmhIHVslgYMAI8aJCb2HUDdFk1qmLmVZPkK?=
 =?us-ascii?Q?eQkO1q7v3kbDOFCfw/DJ9EZoUe75K28GTNDb9fx/ktCqTX37CYqWNR8yzqwk?=
 =?us-ascii?Q?f5e/6Vv1ImAbL0UMYfQgOeQ6LWIzul37Y5THNshBc8NnNergSxWsbar0Y7VN?=
 =?us-ascii?Q?D0fkjVxv2xN0sgVrLUU8ndXQRoOaArw0wCtZEis154kKuFck1tHSD+O5lQId?=
 =?us-ascii?Q?XzZO4GxiLzicPy4HBxdX5TpFDJnZ472zn37eABge2BAqCXLloOhUOCu7CT4R?=
 =?us-ascii?Q?3ewPwId+kiQP9XpCGQoUr+RK6nvRT9rp1kuPMfVa8nXrwGS1Jy/Kcg8ksZ4N?=
 =?us-ascii?Q?i+i2MlkGxSXfshdS0VrX4MB1+3yfTg8HJyaSSrXBST8R2dUDQIrkcORVC9gJ?=
 =?us-ascii?Q?nXBU9gW4K53Jci2D3DPfZFaKk5KfYyYkIpDPd0OF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09cccbd-e1ba-497f-b8e1-08db311da4fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 12:52:39.4772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3OMnr881AbsL+JQC+9trBCDnMp/Wt5/wD9mls4qjqTbkDcuWvu/JtTYoiFVBNAyxBvrFCY+PuNoVCpJbuwtJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 30, 2023 7:22 AM
>=20
> On Wed, Mar 29, 2023 at 03:00:55PM -0600, Alex Williamson wrote:
>=20
> > > + * The user should provide a device cookie when calling this ioctl. =
The
> > > + * cookie is carried only in event e.g. I/O fault reported to usersp=
ace
> > > + * via iommufd. The user should use devid returned by this ioctl to =
mark
> > > + * the target device in other ioctls (e.g. iommu hardware infomratio=
n query
> > > + * via iommufd, and etc.).
> >
> > AFAICT, the whole concept of this dev_cookie is a fantasy.  It only
> > exists in this series in these comments and the structure below.  It's
> > not even defined whether it needs to be unique within an iommufd
> > context, and clearly nothing here validates that.  There's not enough
> > implementation for it to exist in this series.  Maybe dev_cookie is
> > appended to the end of the structure and indicated with a flag when it
> > has some meaning.
>=20
> Yes, I've asked for this to be punted to the PRI series enough times
> already, why does it keep coming back ??

yes, I promise to remove it in next version.

> > > + * @argsz:	 user filled size of this data.
> > > + * @flags:	 reserved for future extension.
> > > + * @dev_cookie:	 a per device cookie provided by userspace.
> > > + * @iommufd:	 iommufd to bind. a negative value means noiommu.
> >
> > "Use a negative value for no-iommu, where supported", or better, should
> > we define this explicitly as -1, or why not use a flag bit to specify
> > no-iommu?  Maybe minsz is only through flags for the noiommu use case.
>=20
> I was happy enough for this to be defined as -1. We could give it a
> formal sounding constant too

are you suggesting having something like "#define VFIO_NOIOMMU_FD	-1"?

Regards,
Yi Liu
