Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC60F76E2D9
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbjHCIWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbjHCIV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:21:59 -0400
Received: from mgamail.intel.com (unknown [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3BB4481;
        Thu,  3 Aug 2023 01:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691050611; x=1722586611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9C2Of5uVYx6fWBI9F5s7FFMlPRuZBZ0AmgiNrNKdmMk=;
  b=FlTtnKdHXXy02ZNc2bEstRIkEh5WhInSzZQSpYR2A17MvsEgqHqAOtY1
   7IM/JDxGhupPSONMqGfqxSqumapKGrt3X2xMmzjRg9yP+eID2lqffobUU
   MHgJwuaIpTGJzxPDNZeUp1qpWMn0Ak4IfgICv7A3OIMnaiQzQtu+3WEm2
   +kY3IP72Yx/UjSv1HSMNFFa/0fssVGbQ7kZ+KKQ5NCOfdNVptZ0uzb14Z
   OwqMDXbTZHnhRILY1fmrx2uhZc8JkM+E7zABFR6N2H375Rha52OiwKOWC
   ifyfjueNGDwBTKGBLMHfrj0c5sWZgV3yrxORLzNm8+FykHwQuQjrikNC9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="456182410"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="456182410"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 01:16:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="723136841"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="723136841"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 03 Aug 2023 01:16:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 01:16:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 01:16:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 01:16:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGhd3Uh8gOdmND6viRO1KiCzRoOeDJ6ODolExwvK6+1bbdu9/qwtChpgGJY6GAroIg0m0QVjlExqPPAypYiw4nVgO7ftwnaS2E7fqffZkuhwUvM9KQJEQps857vtvZoqzVOgT7RQTq7/rDPEvkhiUlgtnv0uxU/mX4x6OLIjy2fZJs2KQT6EJGCYqs9/npihklu58hFPSujLlG5l4IyiR1flUFYGCGX/Aih0wQm4bVhJQqBEoe1E5t2JjegU89UFRlkxK4598WmH++8K2eQmea56xHaYahicoBIdkpe1hpqa4V/iulz5qgEGhyCxJ2AkJhCLqrZuu8jB3O/nlkDywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6Pixn2qDkMNTxC4j8d2/biSu88y/dxFrtSBYmML6JI=;
 b=TL+OMyKCO3vqHgHRcc7Xah5MSNyxwIlyDWqvMA011oRHzuFhMaX3Tero6EqHtZGOhqUexMra2vMhpRPeH/Xy87yxuaY+O9BDgfEuuZre4/l6x4ZfiLhbBJgS5jz1+70oRWcJ2eGddIShT0OX2Z3jjXnfbBvUoRzIUIK5a/6PJUksNJ6mru1rRXxZ+7ZqSg0hHEfAsen6VdDDdO6zgonBnRgPW4zMotT0r4x1oqgHhGha0jaZKv5pMS5jnF1enAu/dBgTVFcNyG4U2ZO5Oiz/VyemoqWzyytXDzVzOFaL8PhDUSaAeSCq3OjTCP/zTmh8BwuljUcvYuOHNv5XmWOsQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5226.namprd11.prod.outlook.com (2603:10b6:408:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 08:16:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 08:16:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Topic: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Index: AQHZwE5hR532wMNk30qvLyiBGXN6vq/YQ9iw
Date:   Thu, 3 Aug 2023 08:16:47 +0000
Message-ID: <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-9-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5226:EE_
x-ms-office365-filtering-correlation-id: d0ae5351-1836-4f87-099c-08db93f9fb8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: my2Ut2Qh2eoRVWX2iQIXBoxcURKVJIB3GK/2HXe7uAdoEuNtRXGAn2rtB46UDN032pQCwBxZhA+JqLd54lI346ButdofQ/AEQfHGUy+4jbZ/I0xAgrp+NKk7sn9Y/qyuu7TrpHSYInLwCRjCzYx9Y6WxszsLTUMRKahVjWL4BR3pWNu11kGglo6Rh5wMu3CApfUCz0Hrryace4PM6AWFLEaQMJUBK6VVyUzf42inWotsrOWNzYukRRrfiX0VO2u6wBmcrbER9IhzKWrFOSZKRwpEgnNx4uno3hDEoBy06Xlrp8hDUak9OddqRkswHoO2xoVRtZ0qKgFAOyfAVYHHOqD3GR7hWpQYoFtrYqe9YA3xYoFx+N9mRZ5OKBYYFi6VAIWombnQBbdKTyOUXogGOH0nMaFmR+EqVUqaWbwUmrxwvpOPHz4Jc538FX9+uLyt7LA4M9vHa1ABaEcuUxhcELz7d/ZYwG6sSs05pu3d69YJhSrQQoMrZK5eGd0O+wqBjXzGjavm+uPeLRpA04lF3nGoWmoPL2btjISYrW3X/Nrm/DbVkOA2678bPBrbgwQKxOVyO1xdU5Lrqnb0+GkDd4xeeSineU2RfMmTeC0zqv7ql79euQB6POLArHJnZpJd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(83380400001)(6506007)(26005)(186003)(41300700001)(52536014)(2906002)(66946007)(76116006)(4326008)(64756008)(66446008)(66476007)(66556008)(5660300002)(316002)(7416002)(8676002)(8936002)(7696005)(71200400001)(9686003)(478600001)(54906003)(110136005)(55016003)(38100700002)(122000001)(82960400001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kjRnKbuhn+7uDr+4jl6w/FbTyYS/vm3bm1FTEvXc5RTWhg4KKeNeCtIhDUW3?=
 =?us-ascii?Q?HfVbTDMi+DLL5fuEMigXj0kKVZwsLr3v5twq1y4MJ1r8wpAtQKPMOszK9JIh?=
 =?us-ascii?Q?Wf690l9iusB7CL7l3ZtwotzaXXmZ8LxaUWTzTpp7aA7jwM1xkPztu0MvwED4?=
 =?us-ascii?Q?fcDgWvEVjtlXL9xSAV+fF/uxxGwDQCJ6W8orJRaqJj9fKTiF3+wYyfJR9E76?=
 =?us-ascii?Q?QJosCY0hlCQnXOMludn8Uej1KjBxRfvmw2t10WT/4VSU2QQgIhIlW/mtpPi3?=
 =?us-ascii?Q?F14HbMp7UfF3xBz/po387mtYJ1N5OPoOAhQK9h8+4aB2mMtOeM1+6Tx/m+SD?=
 =?us-ascii?Q?jglAsMLLIHp/ivpUdBZ/F6sfQqcNj5DxH2Wq5JL5IQBkyPSXVqobjBdT9pBM?=
 =?us-ascii?Q?ewHr6OgcCfxaA2L4wMfBacAgA8VMBhAA0nirkoEzRDDq5TAe3LIBbz2Y+vlI?=
 =?us-ascii?Q?rA81cx2TrYl/0JLB6cQY5bU/9aW5Wyqkx71+bLpDDphDcGWgw0wwmKaC9CZQ?=
 =?us-ascii?Q?6zCGwi3cLuBnIQ/7C5u9ZtVIf0X2h24orhHTdl+G36WwWarlbLPeiMQA1Li2?=
 =?us-ascii?Q?3F176JsMD2FcP9aoIiz8kvFiYUsXRXra1GxZA6WwwIcUK2kBgvKFJ9yczcXQ?=
 =?us-ascii?Q?2EVfqHRrP87+ZqBoEBCNDWROUPUfkNkDYXT0KzFpZEqRdwDVBwDZ7W7oxyPy?=
 =?us-ascii?Q?fJb/FCk624vu8O/+0Q7Ty/bL04pVlo/LVfh0IOAvx8atZrTpewW583TxqYsc?=
 =?us-ascii?Q?h9yLG5026RF4Lbd8VgURAZVCv1vA2stWqFrYzVgAPhfURf3fobdl0u0LtiZw?=
 =?us-ascii?Q?UP7iWysQwwYe5gTv0dzYIhL1X9+yrNXvWcogjjgNkqOiVEO8ZT8JROYy4lkP?=
 =?us-ascii?Q?GVmj7XD6UDNA82HohvHqK0ar8ZTbZ9e92df058nTIeuJjlTO9LwhelGgHejY?=
 =?us-ascii?Q?18TtDGYJ1dGe7X5iglowiqP5hV8u68AodWUXzK4qB+lFnKJMqFkyU5N9bpML?=
 =?us-ascii?Q?b8RN0QP4YCti9QsxQLHDAf9Jxh5rRq4pLh2eYfzsw0V0FL1wQUCK+ScFQVnI?=
 =?us-ascii?Q?O70a5drg95E/njaxSf3ftWNFs94uEBi7Uym5VQGYnqw/IyUKX2jZj/iOzARB?=
 =?us-ascii?Q?guh3GjilYbAYC5e6WhAItdIbMkLEnqtfeic2Sq//mnjDzww2xSw6SkMP4QLg?=
 =?us-ascii?Q?Rg4d++4BPF43bl/IL6Aq8mriC4ckpquURRZBjoBCFDdpt9wcBn9C/heI3hmr?=
 =?us-ascii?Q?RyXPFBdXCG3O0L9ZhF2l/IoEp/3BkF/8d3/jpEEzosNhQ8yWxQ/87QnuyS4p?=
 =?us-ascii?Q?q7ZPcCL/nLuO0GHptjtmvd29lwPhLsolI6tOmTK5nsrBwsybX5lEGaR3Z/kg?=
 =?us-ascii?Q?WjPnKPCpuf5F/Ue7PxtIEkTrcEvLvbWCLojsVPjf0nQkppyRgmzUlAtEPujs?=
 =?us-ascii?Q?vVesyfqIrhAB78FlyAIwS5+eT2T1AjpidloJkX1J01SvKh6eGQZ69Cy+J8Xl?=
 =?us-ascii?Q?bYNYohwla82Nxa3GSE86lrP4LZ0PMHhax5n1VqGof5zZGMuXv0LEsTDW3NOa?=
 =?us-ascii?Q?pQxnXZT+NWqIwBqo5OMkFkqz+wdHhaEYKjFganaG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ae5351-1836-4f87-099c-08db93f9fb8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 08:16:47.9117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjI8D475fXP07p4CSLOaHxqWpH4RZc6eWTbEr6kSxaiGr6jEuBqOm389u4ie8VeE4cK0uiloinzfg4iFKceySg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5226
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:49 PM
>
> @@ -82,7 +82,7 @@ static void iopf_handler(struct work_struct *work)
>  	if (!domain || !domain->iopf_handler)
>  		status =3D IOMMU_PAGE_RESP_INVALID;
>=20
> -	list_for_each_entry_safe(iopf, next, &group->faults, list) {
> +	list_for_each_entry(iopf, &group->faults, list) {
>  		/*
>  		 * For the moment, errors are sticky: don't handle
> subsequent
>  		 * faults in the group if there is an error.
> @@ -90,14 +90,20 @@ static void iopf_handler(struct work_struct *work)
>  		if (status =3D=3D IOMMU_PAGE_RESP_SUCCESS)
>  			status =3D domain->iopf_handler(&iopf->fault,
>  						      domain->fault_data);
> -
> -		if (!(iopf->fault.prm.flags &
> -		      IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
> -			kfree(iopf);
>  	}
>=20
>  	iopf_complete_group(group->dev, &group->last_fault, status);
> -	kfree(group);
> +	iopf_free_group(group);
> +}

this is perf-critical path. It's not good to traverse the list twice.

> +
> +static int iopf_queue_work(struct iopf_group *group, work_func_t func)
> +{
> +	struct iopf_device_param *iopf_param =3D group->dev->iommu-
> >iopf_param;
> +
> +	INIT_WORK(&group->work, func);
> +	queue_work(iopf_param->queue->wq, &group->work);
> +
> +	return 0;
>  }

Is there plan to introduce further error in the future? otherwise this shou=
ld
be void.

btw the work queue is only for sva. If there is no other caller this can be
just kept in iommu-sva.c. No need to create a helper.

> @@ -199,8 +204,11 @@ int iommu_queue_iopf(struct iommu_fault *fault,
> struct device *dev)
>  			list_move(&iopf->list, &group->faults);
>  	}
>=20
> -	queue_work(iopf_param->queue->wq, &group->work);
> -	return 0;
> +	ret =3D iopf_queue_work(group, iopf_handler);
> +	if (ret)
> +		iopf_free_group(group);
> +
> +	return ret;
>=20

Here we can document that the iopf handler (in patch10) should free the
group, allowing the optimization inside the handler.
