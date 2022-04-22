Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D1A50ACAE
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 02:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442771AbiDVAPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 20:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiDVAPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 20:15:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7850ADF14
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 17:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650586381; x=1682122381;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QOTSvnqRbflPzcHAl2zGyHx0kdouzmXF8K2vU+cHR9Q=;
  b=Y0y4IaHBkljBYPdLmkd1R4ix237OQmXt4PB7hW9mJrctS9bMPoHMi41o
   2w0eAO1XfdXXodvJ0gJkvhpW/y49TYeyhM8VITkRetgHSygNzsix5QE5j
   ufgaYDq0yvGXUfL20YVMToeAwcDEgwanY8mu3jVGqB0LefGZLJENSeu57
   yOBsf2Ncljc4kn1PCDIvhrfy4/wcXf5Qmz5EjPH9Akwvla6k20zN/LimV
   duQ6Lk+CM1fV8VDmpJDwqEmKo1zmzTUCJHJelXvyct20QGP3W9k11sSHT
   C7n920ahbE053og59bUBCm+hZBvEPYrZe9sCXp35hrDx2EvvKV0dTUU0H
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="327431745"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="327431745"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 17:13:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="728252393"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2022 17:12:58 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Apr 2022 17:12:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 21 Apr 2022 17:12:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 21 Apr 2022 17:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8S/r7TVq74XjzeApItuwXySF8gJ7HV8s7mMg3bsuFV81K9Pvy/sCSplR6+X/nVZPsWpfeXliLaEy1ifTd9hWBiIh9Dw+pY9ovifriFYdhyfENL3M1/DeJ/uQo9njhhIpGCWEmTmr5hi9qHWTuQKKS8B6HO9SH9LX89bjUs/6EmefTaineK8rmxWP22+fsSnZx/7ix0v+R4Q6jVar/K7jL6xNxHFJBsX24Apgus2Zehr6Rl353cTmSedHKM4JnP7ibaGuqS6WgHVqOxyPqXVRm+8E0nvctG16NV61ffH+DCeovVHgiSTc2OFGFU5Y+u+ajAxf3h0ZBF75brH17KbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOTSvnqRbflPzcHAl2zGyHx0kdouzmXF8K2vU+cHR9Q=;
 b=O96Awy6qIlGK5mT5IbYee/+K9RzxhfwVOm1wnZ6mF83cIBKFOy3BApTUpZbmmoeQS6M258VDlKYaU6fwXLiD1SC3AOBFY/0jrANJpGjrNx8WD8j1QUpbwxJG7+5pfp96pgx5KTwByY0sN9dzONzDaVsbgMAPbqMR0glwK1WAF067X9YPUWvEQCuQ1zt8JIVycai5w0koCZ/q2vlVzHsXQmc81yNwEC93lOcKTEFIBdqtKG3p2GFxe2aRIu+De+YPftCtubM2n4bjaRvYRHHPu+4QL3nQGOnJjA5QpGLzB3gAhBnNiJUmekLZb4gXITHc/89fIrPGQYRo5cZjCtH5cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4869.namprd11.prod.outlook.com (2603:10b6:510:41::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 00:12:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:12:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Topic: [PATCH v2 5/8] vfio: Change vfio_external_check_extension() to
 vfio_file_enforced_coherent()
Thread-Index: AQHYVOwc8QHMMV75gUKPqgPshj3xIaz52v0AgAEzw8A=
Date:   Fri, 22 Apr 2022 00:12:56 +0000
Message-ID: <BN9PR11MB5276370B0B585DEE51B083AF8CF79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <20220421054116.GC20660@lst.de>
In-Reply-To: <20220421054116.GC20660@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5952edae-5f0a-4345-23a7-08da23f4da5c
x-ms-traffictypediagnostic: PH0PR11MB4869:EE_
x-microsoft-antispam-prvs: <PH0PR11MB4869E8B5453210267AAB54C58CF79@PH0PR11MB4869.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TyKgJqmc6wXW6Qr9UbZnFB81HyRR3Bk3PC0eqyAHAqPXozJiUJ4mzMj649nbFROSKazMEfSWOcEhXgiP6c6CXCnRa+enHx6hEgEmsQZClQ6XO9uHa1J8jSBa9A1Un1JWW/4ksIZoA53K9h2FgYzgSPW9d/E4eXCmD7c2bHwcro1csH5iCm8VZPOfO1Qyw2lUHq27fL11rxDXaF+UrE1YcdeV2PSNRxqJnZauHa8HJb0JqP/vHFLcvZfV5/iPFNdj5TIypTN4lOjCtPe7uoB+URMarn7BJ2BnjKFe4TDFGugIFaw5FUOEfBg87XSpQk8VNw9j002Fs93unAmTaMDigThDltU1wpG7GAsaYQn6i9E2W/beaquYAITQNAgt7Gh2BI4L80rcqbReTnfVOzWi0M+Uv9ym9OD1Iq6Pm7INhC7e0Y9ei8OjUXh62r/bWPtHp4CHwhWs/2K/Ucd6/x8u8atpefhXqRZBKqODJEwbn76/BmZDXdF28T7ASu5DFCTKg2OlFoUsprQaZ0FAxW64K9dSEKVoFuBcHq3gQSLzH2aVgos+UYy1oUvil3+k2SL/r/KCkY7j93gaGzf8vKDewNC9IOeBCdWThSjBxlqR/sVzax9J/4G4HbeY7iGrVH8OyZMeUyC1NSDaJLnbLZTT84UrvN/HT/avV7r+/84GHlJ0xKyR1+70FPQJAXi5N59DpN8iG3HlpfVDDzA+GtPnIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(55016003)(107886003)(9686003)(122000001)(66446008)(54906003)(110136005)(66556008)(82960400001)(66476007)(8676002)(186003)(316002)(4326008)(76116006)(64756008)(86362001)(26005)(7696005)(6506007)(52536014)(71200400001)(38100700002)(8936002)(4744005)(508600001)(5660300002)(2906002)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8etQ6NuDejTTHz07UhKqaxwfBRFO91kPrIzP3ccgYbjweaw93PN9cd0cfyNp?=
 =?us-ascii?Q?Njnp/84q5uOTsBRnu8y4dgPQVKiW0r/zDefYfaycL8sSNmHCLMD+ED3LxlmW?=
 =?us-ascii?Q?+qF9HMAfOd0yABnMWf08lnG3bsW838zJx4SWZ5Qogu9LSe6YdtIQwyVc+rfl?=
 =?us-ascii?Q?/VEaeX7M/ym9b2hs395m0xh5qheturfuldlpR7PZr0bCuM5h7bMwSNVZ2CwA?=
 =?us-ascii?Q?4byopSZdJI7P7hiyJqGO/XK/aVOPc72t4AoWKWOh6T7Y8TsnJnpnF7gljmt0?=
 =?us-ascii?Q?lqve+3Yl4SO2fs0E2aRufoAELyt2xNQJutWrOGk/3rrutvqEsiOyB3dOeJ/m?=
 =?us-ascii?Q?MItUgCCZaqktHhnMpb8MdegT3M4vC3Jn8xi4hIFaa5WTv+0h7ffrcep7Cmru?=
 =?us-ascii?Q?nqkUJ3gFhER6SrewcunYRqcidoeh2UXo1pMgx1H416PxeyQjbMGYYuzMHoD5?=
 =?us-ascii?Q?xupVpg1pbNYjuZlHA4LZgzS8L04d6gf9QCro3QTjhEB+zoMTcTE0RoHSMg+C?=
 =?us-ascii?Q?yie09ZtlOuxDepjUQbLGcRtpkgvfKymuPrqofgw2FDM3Ib3cu/MksejSOgJX?=
 =?us-ascii?Q?TYVcGbSAXw1w07oDCSHk2gxnIVi9sfvqxy3Ja34dLAAadYMIuZ4Ur21DgMSG?=
 =?us-ascii?Q?8pbXAHJszwp3E++ldcEnA0wNvcQnrDSHQlkSqFv1s+dHpSBEYQtBugbuUMTf?=
 =?us-ascii?Q?DAK1aFcErHuJZMVW8x0bnK/n9AJzRHA6aURwYXSLtI0s1o4hH0T3D18dn6aT?=
 =?us-ascii?Q?ebjuQ9SY0pANE46TZujotXJkTDtAAhQFeVSr6abiwbORy8jzsFbV1jL/4Xem?=
 =?us-ascii?Q?qkQYGgENYXeEzZVyaPQ6Q1sI8lOJb+3ABaj+CD/nk+r/URe8lkraY+tISDXl?=
 =?us-ascii?Q?L3u0B7UcljHx/Rn84uDSMRNVy1GZ/C7diZtzWL7rlNqSNAguZzUEZ8wBAjOO?=
 =?us-ascii?Q?2MCGxsoLnLzBrDjS1oSCF/Ho7D4mSPX1VXTidIzIdLMPaQakVaaJokwH4qyb?=
 =?us-ascii?Q?9yyQu6IicD2IxNyRNztq86qpfOhB6yeLZAqzwlbkn2tpdP7EtWO3kx1kC+Se?=
 =?us-ascii?Q?qWANROpZ37ClNZbfq5vO8OW3Etd3jqfRXr9KFJX0fHSmfDg2Z75KwQh7Vuag?=
 =?us-ascii?Q?H6ZsB3NnHmR1kMFv+fyInclSvwzhJr4XjhvV/Eppv3SFNTreMO9KYJTZfv6w?=
 =?us-ascii?Q?wyZzXm4dhrJ07x/Pwg1yi2TOJ+4IDupp+urUfk0rl3BcyVBmiNnLYCO5ghwT?=
 =?us-ascii?Q?Z4CuDjQbAsx0JAKQ3vnozzIlWY4u7zd2DfFkfgtvyH1X9myy2cxGVmW0EZuu?=
 =?us-ascii?Q?5kP3pg/WMIncf3yUnkgYzTjnmBCgaBXly1Ba+7QoSoaSXGEJ3rul7qEXZduH?=
 =?us-ascii?Q?XUIrE4CsmNqNwFcC31PXcNsScSxBqBiIOvoOoxr1yMRpo7lE61gepxyWo+42?=
 =?us-ascii?Q?J7fWpShmGrklbsvN+9YOPcN7AQph7wCNOoiWa7nMPddWQjmg4v3WVXbXqgU2?=
 =?us-ascii?Q?Zn7gFL3jA5klnWaIOMvJApmjpV5gMRn64Pghb42teGiKFu1HKYwc7NqhBN4M?=
 =?us-ascii?Q?Ljhb2g7lUZVkzWEL0GetYOtLZNsNNhZTMDSDhzRMmLaS1+c3OFScnm1ewwtu?=
 =?us-ascii?Q?NKZMq3+nPKL0xJJjF6wPG5RyD4g7NbtFOWvFDE0BmcvbAhhQxlmFJ75gkLRd?=
 =?us-ascii?Q?WHayPWUO1rDotllOX9HZxcDDwM6M2c0UAxAJuc6NSVt+mId5dyNPch+y+FUS?=
 =?us-ascii?Q?YJ87yS1vNg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5952edae-5f0a-4345-23a7-08da23f4da5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2022 00:12:56.8341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mb4dsZhlipYBR9MeOEHM+Pk6IqnkrQReWSTwrFciLKCCRtu0aLIUbwBWEAvs1IDD8gvkfxmNTRXossH6b1Bu7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, April 21, 2022 1:41 PM
>=20
> I can see why a specific error might be nice for some cases and am
> open to that, but as a simple transformation this already looks good:
>=20

There is a slight semantics change together with patch7.

Before patch7 the container must be attached before calling
KVM_DEV_VFIO_GROUP_ADD, otherwise vfio_group_get_external_user()
will fail. In this case the result of cache coherency for a group is
deterministic, either true or false.

After patch7 vfio_group_get_external_user() is not called. It's possible
that KVM_DEV_VFIO_GROUP_ADD is called before a container is attached
by the group. In this case cache coherency of the group cannot be
determined at that point. I prefer to returning an error in this callback
so KVM can still fail adding the group, instead of letting the inaccurate
coherency info to bit the user in a much latter point...

Thanks
Kevin
