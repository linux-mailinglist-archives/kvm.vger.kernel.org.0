Return-Path: <kvm+bounces-38007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3102FA338CE
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B46188BDBE
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 07:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C84420A5D3;
	Thu, 13 Feb 2025 07:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8nef65V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E26208995;
	Thu, 13 Feb 2025 07:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739431635; cv=fail; b=ZegrO7i9S3UErcJXR0/tUKuoe13/NAGC89UNab1kk5SLzE3Bq47qq7D57fqlnlF5wFpwvNf00ZfMTk+chGyox1EaPyaDaF52GaIxPBN5vkc/h/P8XaxaLZObq0ZdJ5ZXV/mCEEyqnt2QnkHCjd12SeWWrJxNjyK4AegPztOlfx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739431635; c=relaxed/simple;
	bh=4JpXCrNYaj+wvpHSnGe9AWeeJVEGazGvfZAS8JlT0i0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MPpuEW3aSqQNKvE3IJ//Zw4pIorLTjc3bkDDZTVSGSrijox+McoOfNXrhtToBdjCJAsn3t/XSagb5q//PmKnkVkyt7P/AW6i3OIAMToZkik7//mIBGgv7j74SNlM0fd+5fyDp/yqnpLXz4t2g5oCbCiteGcqFLhc35eGUX7zvPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8nef65V; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739431634; x=1770967634;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4JpXCrNYaj+wvpHSnGe9AWeeJVEGazGvfZAS8JlT0i0=;
  b=S8nef65VnecdrDDTSq08phZGI+Dg2vC3V0DwMVYYtzVynzKze3CC8Y0Z
   9JUYEYMX+IOy3V4bCga2KxtYj0OHOGYsc1UvRWfiJLiaQxlAyDQ9BYS92
   i0MntCk9aBIJCign6ArV8oRJ4fTr9PxEHS8qZoRiKMI1Ey5V8R5SnjBAr
   Vomz8NYNzNClNlYb1HFJG90fCHt1vPs1rhgnyGD2VOn9PRX7s1CRyWwW6
   9vUHfxgexYkJPlZJcByOWOWBiZxXs1f+vcWpW6lqYlB83TWkv71SW4H+N
   C3OrcT34HrqWbKxWJIoh2x7ZM9vjlpJlDYJhbhIaWwIS33A8paAPAowLo
   A==;
X-CSE-ConnectionGUID: cZc34wEEQqe1+25sntg6hQ==
X-CSE-MsgGUID: 3X/X7DLZQt6m1+LxslJHSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="40270867"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="40270867"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:27:13 -0800
X-CSE-ConnectionGUID: eHJJpy8TQF21DGs4DbGE4w==
X-CSE-MsgGUID: gBCYWj6qRi6gSlDohhkBQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113544905"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 23:27:13 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 12 Feb 2025 23:27:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 12 Feb 2025 23:27:12 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 23:27:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oeQf5Gj2ulWXznqwN+BLNUC+aso8K7L03YiZn30yU0VWFp9PcRvQU1ItPXHMf9L0qcXzA/b0e5lZ5bn+2RLlFWttIogXTRf/LB0OXDwsKYAWBEETJvOy8M3GXnSbv0SLY6LjW7XLVlQSvmJ/Pka/oUmAkCNh7WeYK+TJ/dCC0VxKPqqtdZbmMqRbkzy60Ok9XCva4wz9O/VLd//Y2riXjh2GiR6qW0T0xICK4PvrlvM9evk97YqCFoJFBcAwJbxRqkNYSxM3BOxTgO3ZsKTU+IDoyZ5DyJl0QFGKjWvo+4LSYjcGbLiWPMW7M3AAmyDT69Mts6+xWtUvlWpr88wlSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNBSYbbjlNQJPc/TdclqhopZUJ/sjkNld3iL+iJlAA8=;
 b=Sy9QzYQSx5V9R88bAFaL7Aqf6DxwQ38o2v9dhg+/BSG8Qh0BBrz77ltJv7BGF9FsqbDOGXl0Mvy31Peo+rtJ4aJ8K35u8v+vLoJ0rHPHLOIPuoA8W3BNaVvVq8v6+Ev8HCXAnndFD9P9mGqjSKQg5D+aEgLMLksHTXg+FE/6/boFoHHY0alVxwHHf6wkhFpFj8wKUnQCh5hO/PdRqyNtsf9ZT+lZUBCCMM55zHUlvJR+e8S7hplfLOuyzYlgn+I82XITDP/24S8rDq3tpFMtm/6hqlpNhDbmRqSlOB5n8ZsaRdUtUCM0sQ1/xT0eDMa2v48JyTADCJyZzdjJBmE+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8373.namprd11.prod.outlook.com (2603:10b6:806:38d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Thu, 13 Feb
 2025 07:26:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 07:26:56 +0000
Date: Thu, 13 Feb 2025 15:26:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/17] KVM: x86: Assume timer IRQ was injected if APIC
 state is protected
Message-ID: <Z62ettusFdcR+b87@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-6-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025828.3072076-6-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: feb63b67-051d-47bb-1036-08dd4bffcb83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SI+XYAco2R+mtjrdur2CHqLmKSJTm5APlnOru4NXh4AZSYLrPHovVfHOfn1n?=
 =?us-ascii?Q?QOHaMHL9RaTT4xNmfiNKt1CvpeFKa0VAT+TON/fCEdH5bpKvOJbIiG85K215?=
 =?us-ascii?Q?9A2P2/hd1k49cUuJeGm0pL/CxJpvgebXDXTTspcbBU7V6LvM76O3NYJmENQH?=
 =?us-ascii?Q?8ziR+RHdsZ2DPp2ROAna5m+uQ3RaVPtGdktHpuHikcqq4crAb4rLbDd1P+Vr?=
 =?us-ascii?Q?oH0gSuDXAfc05Asy83+zV4azOUqq34rmDWKeUA9lmsb90F/m2T8NUtgJ06gT?=
 =?us-ascii?Q?WFU4ApeKAe/v+emgv7/mxtYRQTRm3G+AFHxPDcp1vyortez+Hu7tSdTVolbt?=
 =?us-ascii?Q?p9vX2PH4lkyQL9aJWvdmnYbP7UWbuzUim3FAFY+FPUJvqL4jRtenghgcv+WG?=
 =?us-ascii?Q?wavJKWzvzPdHX+QklHcR98kEzSI7Dv0lKDLqWU9tZiRI4GCuGL7OuUSxBMRn?=
 =?us-ascii?Q?SubT6c8A2SVpxsSXIXAfQhF5R/FuK9tS81q6I22GBcN9L9rrf+63V5BoWSBt?=
 =?us-ascii?Q?xmpiezq1/9okzd/VCrhm2BvRra/QkytQ6yH++N1zpqcZBHd5gHTgW+0Kxzen?=
 =?us-ascii?Q?ypGSXPY9vt3jLz6UCpLgZty6Cz29ihLLGp6BdN0pbXQ7hBILoa4EBoYcxNSs?=
 =?us-ascii?Q?5kGza7FFTkCkuHaIzfkIldTtHG/+AsGrnshx4G8yBB5ZqeR1Hp/8Mh34ayfp?=
 =?us-ascii?Q?5UXEwwJNSH97CH32nBs/PraEyOO/m55QAi0ZM6NvnUtT4GGm/XHOhHNNAGON?=
 =?us-ascii?Q?NE4NuTp5JyBMfZVZfkX/PvWZSheEI4vhF4B9A/00CcXzrT9pi2z4+RGuCvhO?=
 =?us-ascii?Q?1EiexQ38arHIU3aZFJcKgql8kundzGkXVsKBU9PZuDrufIYY5sb3E0/emDzL?=
 =?us-ascii?Q?nrpZgseC+7O7LT31FAKCo7asVND5/g6/shtB8scjbcZ2jlefRLFHscNHzzgU?=
 =?us-ascii?Q?DcmrGMmzh2UoZDy3JRSQSZN3tjTV0Z1bvQx0hoxAAD0sA6BfKudlr47GVprK?=
 =?us-ascii?Q?gBn7UyqR0IDNv5PDbliVvsCUVV/5ame5Ap97FjISfX9SmFBuIdl9AiKAAAhI?=
 =?us-ascii?Q?vtj6wYEw6Z6dPlgXw/Lsb/fxO1UJIGIaamB/wPf1HwdmFkhgfPOvFbU3hC22?=
 =?us-ascii?Q?pEV85FPiso1MI0CgOn2cZODpuB/tg8aPV56kQJN6uZaQTjXnwJROPwrxV7fu?=
 =?us-ascii?Q?82nyZcWGhvanG/McrOtvyw5a1y8NKmQ8WR7Q+EBpvn412QODT1NePxEnFlJp?=
 =?us-ascii?Q?8EHujuLSBaipYHRgA3IhlHWt5z1yGHT6MyUTDoKdr6DPfxuircUCaKKns/Zq?=
 =?us-ascii?Q?FadlaDyyHemPYdPWJ10+Alm8Hs7QRKELpT9SbuAklnl30B6o7vt8JrD1fXWc?=
 =?us-ascii?Q?K1RakN1xlAUqc441mKDYw+4HbUcy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKONp8PfNmzTEsxpMrrv8vFow5HyzHXX574XdybIN075V6KoNL0q70i808pl?=
 =?us-ascii?Q?c4zTf/4bHvm2eefn1CttWo/xMw2EukrwF7RMfnE0vQoHHMaVEAKZlVllLxbq?=
 =?us-ascii?Q?F3qXrWbKM1Z+2GVdwlNdBa+M+qL6/EdAZv/C7S6TQa5WognIeGhmQQQ9pQQG?=
 =?us-ascii?Q?wGEP2J83mvJIeqoE88+St8hbp8GWQLrm5G0ypmt6jBWL5/d2gsRPvcMcyiyR?=
 =?us-ascii?Q?VkYoqznd50eWKQUwE12qBxcMSM8hUmag/0EbclvEuO5UUOghILKoI3iZ42b0?=
 =?us-ascii?Q?sNQbb0IGZ6iFnoPOrrU1VHe54QF3l21RZChOSj5549YCFLM9jLRdBEDRNASv?=
 =?us-ascii?Q?69UUwOQGXkZ7UVsFjXqv50bmRH+Xi19uae5g7SsLJlZNi029i4SoSpi6zx+p?=
 =?us-ascii?Q?aJBt5VTAsgxQCbPFOeXQLtkVe0p5U3UBXLGCjY8PsE0R5kE9Kw2Ra8FlnjDD?=
 =?us-ascii?Q?ONfuSr+impYuFrEj2NMtcMFyO/TJ1eAm/n444gA8n7yTZymjjXJGKKRpHVI8?=
 =?us-ascii?Q?OEQrwbZRVIIHNltfBsv84ASAeJpGfv/WCTgDgMYgRaT0AOTy5PhhK4qTlOwP?=
 =?us-ascii?Q?Zhg8G5Bgsu+Qss2VhiUBhPVCyfDbnagjKjMryELGD+vx8vc7LvmW2xUgM8Oa?=
 =?us-ascii?Q?5u3BhKUUlirNYtygLc33IB+J8aGHkxruHq8y/i85kmKFrzxZ17cSD+pA24Lt?=
 =?us-ascii?Q?LHT3rd1uW7Vkg0iIBUoO0RpSZvGww6dNtNwHBhSFAX9TN80fYzHvznyiAX2v?=
 =?us-ascii?Q?ubjpR96vNHO9iwN2mvUvfs8DJ+dX9u0AzRzsYB7FbStK7UDxgmVu/gEJjjZE?=
 =?us-ascii?Q?jCsi4ZAByscfHCIIZtSVd6pdtBtS9RWn4PqavFW7s55DXO/BsBZfr8Nk7DkS?=
 =?us-ascii?Q?qrm5rTajCspZyu0tiM1kcNAMr4GW3H0iwuVWX3MsB+ROvqmj6/4mf24MXDmG?=
 =?us-ascii?Q?d68TnQGRYYNX/PN6KMag/j4af35+sVzAmNT8K3/B++NzEfyrMlRInrDtUwHZ?=
 =?us-ascii?Q?CvUISa4vkZcoMqM2hSegr4AjxL9LOaFVssKCP1ooxan/DQPK68AjmbN2+RAv?=
 =?us-ascii?Q?yC9A9LVqshMckrRlot7xeYTDwG/5UOvGa2F+GCwz4H8zrXpBeqka8oJOCcbQ?=
 =?us-ascii?Q?hGciYNzQjmXsMKau4YVGmTy7jIxkV2SZxBUwqCQa1zQjip2dnyKwVSIr8u5C?=
 =?us-ascii?Q?9o4gowJSt3U81Piz2oyA0bu7a89W7X9vBslcgU7/MpuxNLq2NVEoF3/6yxyo?=
 =?us-ascii?Q?k0H83lp8rALdn3gsVpxoTcTnk3ReodYb2YRzjY1YT5W9x6eaMZFRiuCONn1N?=
 =?us-ascii?Q?XCKCiHeGYozUNUP6kxWxNR227PD/9OtMYkL2fpZOsqz9UOn5zNljPRGF21TK?=
 =?us-ascii?Q?2f9+0wj6fQk1GolEHlgTUUpMXrhsyFbP2HSAdOZ42RxPIkId6GVoFyBrKXNT?=
 =?us-ascii?Q?uggXENLeq0Y4GVFtHgm46vVBiy/2XBgboqQFhQylCfbBzJ38nDCD3MdmGrF0?=
 =?us-ascii?Q?bnZ8AU4F2SgCFFEZq8NZ9RZK8T3zpBaXr9Yn9jivDNfuquosYxRf1v5E3HpE?=
 =?us-ascii?Q?vu7qTNtTOjBYRiTnmkCwuOsrPEQFkuJU2FGfcDcz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: feb63b67-051d-47bb-1036-08dd4bffcb83
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 07:26:56.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MN+EsPIWKKPh807OMjHyd5J6AFYpGdmy1JLvdz9MizIKQMulcF3981mqupSeze2/rLqS/1cB7FB3dD0cXKCZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8373
X-OriginatorOrg: intel.com

On Tue, Feb 11, 2025 at 10:58:16AM +0800, Binbin Wu wrote:
>From: Sean Christopherson <seanjc@google.com>
>
>If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
>IRQ was injected when deciding whether or not to busy wait in the "timer
>advanced" path.  The "real" vIRR is not readable/writable, so trying to
>query for a pending timer IRQ will return garbage.
>
>Note, TDX can scour the PIR if it wants to be more precise and skip the
>"wait" call entirely.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>---
>TDX interrupts v2:
>- No change.
>
>TDX interrupts v1:
>- Renamed from "KVM: x86: Assume timer IRQ was injected if APIC state is proteced"
>  to "KVM: x86: Assume timer IRQ was injected if APIC state is protected", i.e.,
>  fix the typo 'proteced'.
>---
> arch/x86/kvm/lapic.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>index bbdede07d063..bab5c42f63b7 100644
>--- a/arch/x86/kvm/lapic.c
>+++ b/arch/x86/kvm/lapic.c
>@@ -1797,8 +1797,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
> static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_lapic *apic = vcpu->arch.apic;
>-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
>+	u32 reg;
> 
>+	/*
>+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
>+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
>+	 * precisely check whether or not a timer IRQ is pending.
>+	 */
>+	if (apic->guest_apic_protected)
>+		return true;
>+
>+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);

nit:	   ^^ remove one space here

> 	if (kvm_apic_hw_enabled(apic)) {
> 		int vec = reg & APIC_VECTOR_MASK;
> 		void *bitmap = apic->regs + APIC_ISR;
>-- 
>2.46.0
>

