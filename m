Return-Path: <kvm+bounces-15609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA958ADE18
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 09:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3183CB2215A
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 07:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C602145BFD;
	Tue, 23 Apr 2024 07:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QEa8HiVq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F3B45948
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 07:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713856592; cv=fail; b=Y0mH367vkKvXKGdUhPK3rX9dMidBAKMJyruqELHFit6CXy0ZjpwS67809ZpeIO0/59E7KiM/2Bs3K0rz3kMbmojkOdNVcAzH4NcOWTTyYQK/NzmFpBk9hJSkEZ7sZshSxZWjojsSr1BvTTOyRKHPtvOWo06lqsCz+cDMumspRns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713856592; c=relaxed/simple;
	bh=1xn6Z+A5mSp7IOZXlq3fZr05S1YYG9aUMB53snzR9zs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aU+ygrhzCZpdmSxgFT0rh9b6ErmzN4S7CyhUGDupcBt1bVdAckrlvYyTPu/JXu4cZ7Q+qy+3o6H7gTj2ZmfGtaOXMGS8ii1xfosv5CUBN5osLDbOy7nvpYSLFmkVWwbIP72QsI4tOVdL+hpXhNACAFjfGOzZfyvf31mK/F/RY/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QEa8HiVq; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713856591; x=1745392591;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1xn6Z+A5mSp7IOZXlq3fZr05S1YYG9aUMB53snzR9zs=;
  b=QEa8HiVqOaNNdyvINLiBO/HtVSuUkZY6xHaYBylH3OXVGXIcCXy+QKc2
   3DAsR7lXM4VorCyBXShfao5hoUbtVi2cdzJXRjGFqd2cAGi5qJtY2Vndr
   /arP09DUZcV5gaYkf5QOEXCGFIR/5DJoT4qPnjwfuJ/aEuMKqnejbul7P
   EvlhUSz7bquCTwYDeOy+xlZS1dC005L90rrjXOwFYeOd4qggNzlFmiHib
   n0dxIwE/TA6sKAi8MNe78xZkuyF9I4lFXLGM/KO19g7/IqYnJ6zQZoIAK
   6GH2x3SWDKyuFUXOjhMzQZy83RwvM0jvZZee6OqZ8KI+OBWLgAWS2w0B1
   g==;
X-CSE-ConnectionGUID: bzEznb10SHi8x35Eh/lvyA==
X-CSE-MsgGUID: 2DRpz/pCS2aP1L7UYHBYVw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9300613"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9300613"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 00:16:30 -0700
X-CSE-ConnectionGUID: G7YAWmf4T/2ZkyMEhOUZHA==
X-CSE-MsgGUID: 6YcbGWUDR5mpG8M6D3GqSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="24323428"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Apr 2024 00:16:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 00:16:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Apr 2024 00:16:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Apr 2024 00:16:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Apr 2024 00:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgJitRvNQD6oWpfr7x1sQvpy/fKyWkouPKgYLkbyawXcM5ycQdC51gLNS2Rjn8q7oUbrEncakJr5KOtQYuWTsAzMAkgo0d57Ourc1in5hi/tQ45vKHzeawLm1bRQ43rI9aSIJjPZ8iaeG/KpiNN5GgnbyKQGeOmpxFcQ4UlvvX2ewiHeudu5akmXWOJPGEzdPzbC9+RAzvQGL7CeTmnxfcAK8S46OyDYHM4IaHNQnE/bY+hqIo1nXVqaGrn3TNOp8f/5vZclBX4pvn+9PnHsa1ekvfm9cHiTd5ZutImb0HarPRRd4J4H7NTMxnXOfZZF7PHbU/7PNmrnri1OXBT1Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thFb/10qmrByGm3nxRvo4V7CB86B+1er3nYkCK5s5Q0=;
 b=TM+mfLKfFD95fGhYWE/YAPv4x/beeGD23rWdpKEUE0Ys9Na53K3vTdzTsbdVIJrbFe/m312M/48gLeegKlV2HwRrncW6d39AgndW2aEYoH7Ki0cUj7ykH+VhcfPtkgE1CSBP0NfUh1hQh25IGXfNLYR7nWDlxGGV+/EHl+AKdWfENWe44Kyz0q2PDGhufdY0Vha6ZvtJ9RjwrztBl65cTs6caoteHzL05hvfTFCN97mB9JGeAHMUPjmMNB+wD/LycbAufmaIu25rYmnAkg84ONxvDu9bxrsaitqbwrL5JWGDf4nxbNGgPASyJaMVzo7BQQzhE+iNSvSzbHh9poLpvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6824.namprd11.prod.outlook.com (2603:10b6:806:29e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Tue, 23 Apr
 2024 07:16:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 07:16:25 +0000
Message-ID: <4bac4087-77d8-45c1-852a-1c6a37044431@intel.com>
Date: Tue, 23 Apr 2024 15:19:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] ida: Add ida_get_lowest()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<baolu.lu@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<jacob.jun.pan@intel.com>, Matthew Wilcox <willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-2-yi.l.liu@intel.com>
 <20240416100329.35cede17.alex.williamson@redhat.com>
 <e3531550-8644-4a7e-94bd-75bdb52182be@intel.com>
 <20240418102314.6a3d344a.alex.williamson@redhat.com>
 <20240418171208.GC3050601@nvidia.com>
 <d4674745-1978-43b2-9206-3bf05c6cd75a@intel.com>
 <20240419075504.47dc3d75.alex.williamson@redhat.com>
 <20240419140047.GF3050601@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240419140047.GF3050601@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 7221a35c-d598-417f-1b16-08dc636548ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q3FncEhKSWtTTStWbU94TlB2WDNCSkdYZHRJVjZZSExZdEdPZVpVNjlYOUVD?=
 =?utf-8?B?Y2JaR0lSK2F0VUR2ZWN5WTRJc2tuZDFmSllyVU5TbUR2a202TjBEbUJ6czFt?=
 =?utf-8?B?UTc3SEppTWtKaGZSdE00RUNUbjNyUzFNdkRxRGhDbDhGVW94WDFBS083aEFi?=
 =?utf-8?B?ZFZlaTFmclYreFhaWTBZYlIxTnczVUJkZWpvL2JxOTZ5VWxuYkVnMWp1cTRR?=
 =?utf-8?B?UTdabC8vaXFYVHZoNk43bk9zU1VqdHpSVWw0RGRXQldoVjZhQmptUWIvYXVF?=
 =?utf-8?B?cldhOEUzWWRlSUJRSW1GOGtpYjRxcmI3NEdyR0pSWWJYM0tEMHdaVndaczBx?=
 =?utf-8?B?R0VyaFhTVnRJOTRHY1JvR3ltMjhEaGxvUlZLOGRjTkpQSE9uMk5aN0J2TGNM?=
 =?utf-8?B?RWw5Mms5dExFKzI5WVlTdDQ5YWM5dWFYNXRpTGJzOG9DS2haZkRhcGFWcFFu?=
 =?utf-8?B?ZkVKdXpFdnNrd09BbEhNRGNlekNReGI3bkg4QXpReFFpS0o1U3hsVTFiZmVa?=
 =?utf-8?B?ajZvN0lnRDNQam1MMlZMdG41a3dGN1oyV1hvNWhKd3dPV1pHRE1RMnNlR05T?=
 =?utf-8?B?RFJReFY0clBLajJPeWZZd01Sc2JuUWFQaGo2b1lQKzFoR1Zib1pwT0gwLzNt?=
 =?utf-8?B?c285S1d4czdJT3BxKzFJVzBURlJ4V08wVElGTkxqK3dJWlo4NkN5bUJqeDVW?=
 =?utf-8?B?ZDJJQkxnY2YrRXVGMHlrNzNsQytpNmx0WUtoWGxEbkNZYlBCcnRTY2ljMlhz?=
 =?utf-8?B?ODlPN3NZMWxGdnQ3RzRYWXNVdGR2VDZjVUxlS2lvblRVam9SbGdjd3pJZ2pi?=
 =?utf-8?B?SllHcXd0Q3dUY09qUksyU0IwMW1sMk9rYkpudnNtU3RGcXAxNGh0UU90Rmpu?=
 =?utf-8?B?bzRXRFQrN2VlVmdBanEvNFZLTkI2d3pYK211Um1SOU5GdzdieG16Q01xbEJN?=
 =?utf-8?B?YnZybWxaTmlKRm9oNHE1L3kxRnZ5SVFoRkZzQ0pvT2tnMXFkYWtBZDdqMXpY?=
 =?utf-8?B?NEI0Y3BjYUlwRUtiRkhNc1BZZStvazJTQmI4MjllMkx0UkhES05MalNzVlRw?=
 =?utf-8?B?V0dWVVFJbTJTcWltMVhvZ3o5K3A5UXR2SkhybjJHdjZ6QTVPNWYzSTFMTHFu?=
 =?utf-8?B?RDVmc0NhaEtNK1lWc1RUZWdBT3ZHMThkalJrdTBVdkFkanpJVm91S29ZRk1y?=
 =?utf-8?B?OVFmaUF6bkE5alJjaDBLb3hpK0dySWxaTmVueUtRY2VMYUhDRGo1WisrMzNK?=
 =?utf-8?B?dnpKTzMzVjJQaDlQc28yVjVkbXB6YzhERENQVlczZS96c3U0QjZNakMrTGlG?=
 =?utf-8?B?bTJjaGV4RXMya1FKRGdTVHRsUlZWNnArQjBsM1g0c0VHSlhjYkhvdEdhN0Ft?=
 =?utf-8?B?bFJWTHFmQ2ZPRlpVMTB2Y1ZVeThiZTNsei94dkdqTTdvcEZSc3ZjUWpJZ1U1?=
 =?utf-8?B?UEY4Vnp5NEhLem5YVnFSamRZWU9QdG51b1JTWm5qSjB3WUVEZ29jQktpeWo5?=
 =?utf-8?B?WjdsMktkdVNpSnhiMHR3aWw2UVJsa2lXR1ZwRDdmaWk4UU1DVGZKTE5XODFQ?=
 =?utf-8?B?R3FRLytVYjhSb1VnalJDSDc3MXZ3NG5Yc3dIUGE4ZWtyQTdMWEZCc2NJWlhx?=
 =?utf-8?B?clhUTENyeWZNd0hic3VLekdxNDJvM1Z1azZocVRjcjN0ZEh0enlpT3Q4WFQ3?=
 =?utf-8?B?bHA5ZG5QYzl4ZW1KQlBEdFJrRnZLNEVVbWFnVTVmVTdLZjdTcy84TURBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3QzSndzVlNJWkRoNzVoL3dkWUFRNTJiRkYwMnUxdm9BZVZiY3owZW9Zc0VD?=
 =?utf-8?B?UnBDcGxsTHBxSVdpZnQrdmZjRTNrdnVyaGxRSkhSZ1ZhZlZmckM0SXhzZ2lM?=
 =?utf-8?B?WFBXMHJtajFzSkRlZWQxTGJaT01NY2FCb25udS9pZi9Sb1ZSb3RoQTBqM3Iv?=
 =?utf-8?B?Zm1WWFlBTkFSSnkvTUZXNmo3U0ovZVd2NFdLNit2WnFuaVdLL3FKdEp6ZjVM?=
 =?utf-8?B?eVRTYTZESWt6ajhoOUg5bllzamVZVGJaL2kwRjRScjZtdHQyRzZzY28wTWFO?=
 =?utf-8?B?Y2NXei96ZllVOXdGNGticlJnTzJ6Nld0a1RHQ1RWZEUySGkxMDU2eXMvUGpR?=
 =?utf-8?B?UzFJUzU2VExYNXordXF0eE1UUVgrRDYreWIxOGw1dEM1L3l1aWphelhPYkVY?=
 =?utf-8?B?akFDaWRyUG5zWDBWYlZKdTAzR3VHMjZOTHJ3bXJDdGtjOS9Oa3RrMWhRQXRW?=
 =?utf-8?B?emRkRE9lTlB3Sk9HM1d3LytKbmtmb1Yxd3hiSm1xRG5oSURZUGp6ckkvZW5P?=
 =?utf-8?B?N2RvbVpwd053NDhIRjJhUTZIcU9lZDNLM3Nrd0hQZHlXejV4M0swMSthTFZx?=
 =?utf-8?B?ampKdE9IM2Q2Zmptc052OGtNVUtkNDA3OFpwNTI0WDd2QWRSOGZjMnczTVNR?=
 =?utf-8?B?ZFdzc2RFRTQyVDY0Uk5EZ1p4MUJ4b1lrMk1vSGl6U2NURWNka3FMbGRPUUtS?=
 =?utf-8?B?YmFLWlo2eFFrSUtReVBuV2pON3pJRk91TUtwd2dwMTFkQ2FaZkQyK0dTUTVE?=
 =?utf-8?B?VWpid3FuWjAwODZkMmptM1NrOEtpdmdJNnY2M0Y3bmoweUNZMHV1SGM2R0My?=
 =?utf-8?B?U0QvdlJWc3ZEZlJHYkZsRnJyUFZJSUNHL1lBUUczVVd1V3oxOFVick0wbE9l?=
 =?utf-8?B?YW9Gc1hSOGdKTkg3WGZOd3c3K3NDZWxoTkduQXhNY3Z5MUJmUjl3Vm1TZ3Jk?=
 =?utf-8?B?ZTE1V2ZuRWpNM0dDazU3c1p3YzN3QS80UHV3aS9Va0Rsa1RvMVU1MjkwQWYw?=
 =?utf-8?B?aTdnSzhvdUROc2EwMkNRS05LaGU4Nk5PdnhYeUxJbGNDUm9xUWtlaEtoYm85?=
 =?utf-8?B?U29PaUN5QmluWFgxMEN2OVRUbWllYWRidmpJbTFGZ0htcUVIakZER0JpRTE2?=
 =?utf-8?B?RGtIRmZLbmYydGpwRGJGYjlXSmhoWFN0Mlh4dHZuWWxxdm5mbVM3YnlZS1BK?=
 =?utf-8?B?eXd0UTN2QjViZFM0ckRrWi95cEdhV3dGRHplVDlxa1VZUDNKK2dYdjFKMzRL?=
 =?utf-8?B?V3pxbDJDOGo3UGt1YzhOcXM4dE5RMGhMZTN6b0E4UHI2SUJ5UEdNd1VCMXRL?=
 =?utf-8?B?SXNKQ2xxSENyREhXc3hlNFdGenpFMHdmSkVJWVJuZGd1TEZkZzVoM2VPYzhl?=
 =?utf-8?B?bVFWbzRENG1CbnR0amxaejZkc0IvK2gxeXFDUGlIL01xNDZuUlRsU04rNGdw?=
 =?utf-8?B?Q294RXZEWWdYM2ZzNkpVVkYyZzA5aVRZcEg0clRYNVRmV3FBV3BacUMxWDdT?=
 =?utf-8?B?MS82VkRhY09zR3h2a1JCcFptSmYxRjk3N0xVaWg2NUlmejYxOXdMblAyNkVD?=
 =?utf-8?B?VnJ6MEdMM3ZHbmZqZ21rRHB6elQwdk14UWdhWk1GVnZDMmJjR1FOMVA1V3oz?=
 =?utf-8?B?TWNrMmJOZnlDdWROK0tKREpXN1BGRmduTHBmUUtKZWZsRkJvZDZlUk8yRHRz?=
 =?utf-8?B?T1N6cVcxS2F0cllZVWJyRzIxYmhrOVFSbTZ3bU9OT1BOelVmQ05BS2JNQVlK?=
 =?utf-8?B?R3A3akdXUlZPME85SURsakx4S3lFVGQ5VzZzaUQzYWhTNitPMkdFV2wvSmNH?=
 =?utf-8?B?WGI2a3VEd0ZSazZYNmQ2OTNtZEJDVlRsNGlRRkRJak5KcFluVER6VWJZaWJP?=
 =?utf-8?B?ZUUrQkdaeERtbkNFRHVwd2EzSFdTQlJXR2lrcmFPMzVxczU5RXEybFB5elN1?=
 =?utf-8?B?cG81ek4yQ0l6bkNLOFhQYmw4SElSOUhvNFA3ZFRpSi9UbUZ1SFI0a0tXbmFW?=
 =?utf-8?B?ODNLYkpPYzZ1NkNtNFpYMEJJb1NCZHZza25BV2czNVpFbzdzZEFMaWtPdHkr?=
 =?utf-8?B?Q1l1NGxqOW8xeHBnamN0djdiZEljbEQ5UW01ZU1OOVg2ZHdMWWpjMGZBeVBt?=
 =?utf-8?Q?gBAnlziotdS38xJ/L2/U6r/pz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7221a35c-d598-417f-1b16-08dc636548ec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 07:16:24.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhKMUEjIF6foWLzjaTi0jMot4BnSIHnHXaa+ho+JRsiKGuJLUuUmv6cA8R9D6aUbAe2/SLSt8ONfSRr7t+foqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6824
X-OriginatorOrg: intel.com

On 2024/4/19 22:00, Jason Gunthorpe wrote:
> On Fri, Apr 19, 2024 at 07:55:04AM -0600, Alex Williamson wrote:
>> On Fri, 19 Apr 2024 21:43:17 +0800
>> Yi Liu <yi.l.liu@intel.com> wrote:
>>
>>> On 2024/4/19 01:12, Jason Gunthorpe wrote:
>>>> On Thu, Apr 18, 2024 at 10:23:14AM -0600, Alex Williamson wrote:
>>>>>> yep. maybe we can start with the below code, no need for ida_for_each()
>>>>>> today.
>>>>>>
>>>>>>
>>>>>>     	int id = 0;
>>>>>>
>>>>>>     	while (!ida_is_empty(&pasid_ida)) {
>>>>>>     		id = ida_find_first_range(pasid_ida, id, INT_MAX);
>>>>>
>>>>> You've actually already justified the _min function here:
>>>>>
>>>>> static inline int ida_find_first_min(struct ida *ida, unsigned int min)
>>>>> {
>>>>> 	return ida_find_first_range(ida, min, ~0);
>>>>> }
>>>>
>>>> It should also always start from 0..
>>>
>>> any special reason to always start from 0? Here we want to loop all the
>>> IDs, and remove them. In this usage, it should be more efficient if we
>>> start from the last found ID.
>>
>> In the above version, there's a possibility of an infinite loop, in the
>> below there's not.  I don't think the infinite loop is actually
>> reachable, but given the xarray backend to ida I'm not sure you're
>> gaining much to restart after the previously found id either.  Thanks,
> 
> Right, there is no performance win on xarray and it only risks an
> infinite loop compared to:
> 
>>>> while ((id = ida_find_first(pasid_ida)) != EMPTY_IDA) {
>>>>     ida_remove(id);
>>>> }
> 
> Which does not by construction

thanks, got you two. :) Let's go with below. < 0 should mean
no ID found.

while ((id = ida_find_first(pasid_ida)) < 0) {
     ida_free(id);
}

-- 
Regards,
Yi Liu

