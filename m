Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9D4FEA51
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiDLXU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiDLXUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:20:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC9AB18AA
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 16:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649804649; x=1681340649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BJz7qYzNhG5g5G+vHVPNLAo/cXd95MNRr0YmreN7aNg=;
  b=A6uzOj3PRJCNPkIB1jXfEvots5tz4WTxDL1Rd5fLxooPuxTCfUQUe7nb
   ZmY5m/4XM97d4fw6VY/kfnmEfrK4DOHTgvuy95nanmymqmds57m48t9MU
   OgF8cuJPMzpFoUos4/TbHJWnELVXU4M5+S0CD8V9d14M/kBF10stB7zoU
   lIvIp9j1yukFM316yq3v0RXVsDs1DBXeznRDFIFLBarvMN0NaDSATfyOp
   mtC4fv6aYPtSzyj3J7MvOWQTuc40j7ZDFGqqERyUyX2lrIbTK+o4O8vH9
   0yPmRVMq4ALM+iflDxDffNd7nxV1z37OCuHhPSPRjGAMBOz14aS+peJu4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="325433106"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="325433106"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 16:04:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="854560248"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2022 16:04:07 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Apr 2022 16:04:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Apr 2022 16:04:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Apr 2022 16:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXKDWBajYg3M8Hc61mcNC4IzxSRh/70BDl2uqcHEBiG90uiLzjcKncQWm6UJ7rpuGjZeIPPTeOqjlsh/z7PpVA7WeFPqP6ZWluQ9Qeijp6RGYsB4CnF3ovEP4y7HhmR+uMrN36SmalsuO8//157mLgHAXgetqwpTQ6WLeQYRHUNEsNs1ncFIowhYa7lVuKQ68Zprc6OWZja1nEXBVuXftDA5e1u2+4LMpqwWbZ507W37lsgvd2ICRurqWcHExjsX34EZsex2QAzwl3mrOqSBbZeXGeSrc3w7HjO3CNPz8s3QVgK0PQg77C78ihKaMKzJGSY8gfmzQlIZe/vB+NqZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJz7qYzNhG5g5G+vHVPNLAo/cXd95MNRr0YmreN7aNg=;
 b=eCk+5R577+k1EQ6iT+SahjWFRCh6cgn1Tr/Mg7ebjD8MzLMIFgqDq0ZRBLTm5++HCviP0jnX4TWAG9OpHZp2ph9AkWaWXvUG474GTjJHZYafW3lwJ6ynMxSEP+NA/IU6ko1tZmM6B/yPL5SMYLwnjNPtpEnSHXcNJIAGMxw0HHwRFYg6KMZis5wOmXYI9Oaqf1kUGtpRq0drV76xO907fdirInZic9E4r1KenPoOK6vlVTmJSYboMR4e0UypaQLKSQANR1VKFxVCrBLhWC2orIiyNasSGgt/pq0SzIwKjAqFRqE1uJ2mYPf1J8hSLbuXPvpbRmi8EsoPZ7X0pTjEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4256.namprd11.prod.outlook.com (2603:10b6:208:17b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 23:04:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 23:04:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Topic: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Thread-Index: AQHYSpODjq97KCkZqE+HgacEjq1/gKzlqx6ggAHgngCABGEPsIAAXD+AgAACG4CAAKE0QA==
Date:   Tue, 12 Apr 2022 23:04:05 +0000
Message-ID: <BN9PR11MB527667C637E3CFDDB611697E8CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276796235136C1E6C50A5AF8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8df77a0f-55ee-bbc3-8ada-ab109d9323eb@linux.intel.com>
 <BN9PR11MB5276FD53286C0181B4987C958CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a3b9d7f0-b7b9-ffdf-90c3-b216e1e19b35@linux.intel.com>
 <20220412132059.GG2120790@nvidia.com>
In-Reply-To: <20220412132059.GG2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82364406-6649-4822-3a99-08da1cd8be08
x-ms-traffictypediagnostic: MN2PR11MB4256:EE_
x-microsoft-antispam-prvs: <MN2PR11MB42564E122FF36A4C12C71C228CED9@MN2PR11MB4256.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T4D4vffWoFOMrj/VC8TrUuCfEYC9/mzs+/S7NwwmvX1ZJ3BmrC6651jriNeRAnojx4+aOWUxE0G2Go0F8nFYHw8R8QepL6NAcjF7BdzNDtv+QBvyA0YlNRSozMknNP3MXeS/6diSdAmyw3Ze+nICRH51dLsCJT9sWdjXwCnNagSgvGQP+adjmD8IhdjjFW1dn31DMM6mU/uCrlqq6PEhZ9flxp9fKhoVqNgrWFJizKoMZMR4a7MVxF8wBxUmjxUWbsQlZkTZIpiiQK9SgYBZ1oacIO8ab7gPilgvxu2hWJgqUmIgdGPTjGm/QB0PsBenIUdFsyVtPKrym26iGDQzvXxk5XLDjqivEP8bi/AHwLWu8tlPrfgiNRJKrEeXw4NS5mO3OqNgZPFi8xDRLImg6l4Z5Suxh1I9fosKWpMS/9WIMWlvsNVMEqGLSQbp6wKzlB470TAyg6Jr9onf+eHAzX7lMB0PEIUYc7v8fV6x492pxStXFtiCQYqtXBsLgXNgiLIQNqrCno8J8h/J5CALbpIYeQWN+WOeieJS+FDWi2HnAKP6psKWxPGyxV7XvygbxkjdvM7Mc2AKone3ZTf8Yq9rsb3XXcFC6/EvCKB6m/yvtaFh5ubJqTnF6YaBAJWsK6r+kYXGOzrVUaSdu03L1WTfBceI2D53+B9sgIcmQ7n0a6NTOiRW7wfiJ3s8uFRlHbBpo8aTsDsX7jjHo/u3/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(6506007)(52536014)(110136005)(5660300002)(316002)(38100700002)(186003)(38070700005)(86362001)(82960400001)(7696005)(2906002)(26005)(9686003)(71200400001)(508600001)(76116006)(66946007)(66446008)(66556008)(66476007)(64756008)(7416002)(8936002)(33656002)(54906003)(8676002)(4326008)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z7tJgmpKCwQv3gOz2ThVRgs9r8kuZ20O9RQtqiQL38akO/2Cm8ks8aZJxB5V?=
 =?us-ascii?Q?XB8CD+DvooT2NRhNvqUQMLor6P8Pemt3CItbTzxEhzASlJgGBgwMSvIZ3RBB?=
 =?us-ascii?Q?LpYsCP63EbUbeztrHnOXUxYK0Y94n1mHsCIuOWGMlWwXWNuWAqs3UpNwSOPs?=
 =?us-ascii?Q?AmFMtxsVHXFDZfxOwQax704MABcEMDAHOs/8rXK6aIFb6ypolnB1IT4jBOKK?=
 =?us-ascii?Q?9R5JtfegjNEeez3D/HaD6w2Lmr+KAWtPEZuDk02cnaXGq1tgAQ0GqZuqJeDt?=
 =?us-ascii?Q?gbDBnmKkXC4cgrMkHPYFsJkfWeB5HmTyX15l2FHavJEBdTalZjVhqQufWcEr?=
 =?us-ascii?Q?7vm5p11KPMOtwTIQlFzQLlfskDGzV9B4NN9UOF65RmZ8WcgPjj592kmey+5L?=
 =?us-ascii?Q?cn1kadjLyn4kknFx5LSCweis/Oq+1z726uFhdN8TyV2rqHfnOjLN5JoqHBwO?=
 =?us-ascii?Q?jMefKrCU7L+fi3O7VsCGMlw13h6aCRhd0I3WQ3y8qwl16sfAmxL6/WifGV+2?=
 =?us-ascii?Q?fhXMj7u+2O9iGHmbtf+EQSDBrCCX0q7Af/G4ordufv/I8t/lSickXMuyRL3p?=
 =?us-ascii?Q?FlR2Scll7JsmKOiezJxDGvOANjN4xFOTxMwfX2S33kfHBf1xTYUgL96BN3FQ?=
 =?us-ascii?Q?fiorKztiTyy+9uAS0CX6ZK6CJ2/g8dZUPbuy4tQnrVMXdu2JDFqw688m18c3?=
 =?us-ascii?Q?gQXj2Gm2mwl//9TBanIUvdUSwRPYnHu6tdoBN960vU/I982rfsP9I8PzPANY?=
 =?us-ascii?Q?ahEV1wQtbQ+rSMahNwuUMokCgHF7Gsi0eZO5ASUYdLXulCUOYH09C1iKLoIU?=
 =?us-ascii?Q?zreY+Y5G8TxxnybU6c0CsUcZl9Xkaz62vGVDGzJjSUglnvk36CnHfpRE20a6?=
 =?us-ascii?Q?wTr44ZUMyATPjeq+HblIN4ZXI2EHWcVDNu+e2LKN4ZS4jDOSo/RU10aXY4UJ?=
 =?us-ascii?Q?4yy2bU+Ot3ekTihe9pEhbvDgr2oouebjcYW2RO10B7PHRklsIAa25F8zT5FK?=
 =?us-ascii?Q?0ZtDOVp80IZQjcA2DqztXt0uNmLp7YxYOTo5W/k3weMrZz2YgWbOCqNOSbYX?=
 =?us-ascii?Q?ns/+Pw4vqu0MJiJQ0AdjS3V4e1p+0JE58ddNTOQsZMISx8anIVxz3fvzrF5E?=
 =?us-ascii?Q?1nroWxuE7zBakoQZtIdugdvjucfCtYcrOrNukdL9ipPGkluwuUKTeljNTsOW?=
 =?us-ascii?Q?+/TgoshZgW5Ms4AER06S0r3YyQNEyp+zxA3005ifN+q8JdK0/whKVA49Re/z?=
 =?us-ascii?Q?5V+mXkQuehpw4FY3MSfjh1l+Lmpgxt/hoeD6AtQ9h0GXEVQdVDOqMEdBlAvM?=
 =?us-ascii?Q?0cNmb18iffXagc2pR3zOBeUB0G684E+VkIi+AP6xcdM8/qbG31GMtYsTaXsM?=
 =?us-ascii?Q?oZ1C5XaLXKHC/QFEPj8oknyKGEBOXHdYHtbORhAFKYnJvPuRalHrG5hP+qjw?=
 =?us-ascii?Q?5WYG9DkCQlEgDs99fqA2Gzqn0oc6mGm+Uxp+43PcRi0P8xr4KVdTQ3YGJAbz?=
 =?us-ascii?Q?3hRSgUJXLJ34xymnKSRIxtIabWQkVWlFu3UjVYiAOSIvXRO8ygdJ47I98fjE?=
 =?us-ascii?Q?BaqQM/sgjtKfvH2hZV0QO84njJXzKQLAus+g9kpxOiFtsGtw7lOEwui5Raw/?=
 =?us-ascii?Q?dFX4HPImaL8TXbXcRiaomnrGXkgGC8X0dDQe3jWp1UKTeWRpOxarS4aqLYfF?=
 =?us-ascii?Q?QF/Ze1C23EdmSWYPi74oP0QHwRy2FNlVic2fvU8i7D6I53wnY7pRTX0XQzjC?=
 =?us-ascii?Q?AYnz7KZ92w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82364406-6649-4822-3a99-08da1cd8be08
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 23:04:05.2445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: svAlytahwWuPMWjfcoQP0Je/XCRdpUem2ykMfrJNfD2N39xBZBX6VT/CLOdccTbqUUvjNcUXbo+f0K9hXys4uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 12, 2022 9:21 PM
>=20
> On Tue, Apr 12, 2022 at 09:13:27PM +0800, Lu Baolu wrote:
>=20
> > > > > btw as discussed in last version it is not necessarily to recalcu=
late
> > > > > snoop control globally with this new approach. Will follow up to
> > > > > clean it up after this series is merged.
> > > > Agreed. But it also requires the enforce_cache_coherency() to be ca=
lled
> > > > only after domain being attached to a device just as VFIO is doing.
> > > that actually makes sense, right? w/o device attached it's pointless =
to
> > > call that interface on a domain...
> >
> > Agreed. Return -EOPNOTSUPP or -EINVAL to tell the caller that this
> > operation is invalid before any device attachment.
>=20
> That is backwards. enforce_cache_coherency() succeeds on an empty
> domain and attach of an incompatible device must fail.

seems it's just a matter of the default policy on an empty domain. No
matter we by default allow enforce_cache_coherency succeed or not
the compatibility check against the default policy must be done anyway
when attaching a device.

given most IOMMUs supports force-snooping, allowing it succeed by
default certainly makes more sense.

Thanks
Kevin
