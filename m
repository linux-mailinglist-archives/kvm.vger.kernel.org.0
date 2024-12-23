Return-Path: <kvm+bounces-34333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 751539FAB8C
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD2E2165DD2
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0941B18D62A;
	Mon, 23 Dec 2024 08:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7uDsH+o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0541487CD;
	Mon, 23 Dec 2024 08:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734942766; cv=fail; b=SxazNCOt5t6vxiCmLOLak0pETz1JWFJAFLtPnI3jECqaSKodDG3jfghqK/KJbZ9naohlbtoenixlap2+97I17RbuVhLJMxLWRH9CfCPb7fmEYRIFW36uUHg2R2YWfMmLDUVL9LZekVTcrh5T33/vnZJXKsPSbrzsYiWg6vFcUoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734942766; c=relaxed/simple;
	bh=LGA2UoGTsjSK/40YQoUbXrdXVYYpZ7ca6P4SWj2rsjU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IDPQTaOdifDMm8A/IwnKQ/LDg5O2daiPpCbVrKuK2S82DE6ENGsallITDWVWJ7aPeCGCIuGovt1+BE9cpAvAqMhVuIdTit4KlV7YT3ph3XL1RvpfW/DWzBhXZFTrxug+HZdlizR7ymS+ykUNfun0u9ZMlo34OC1nSRBntzLklAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7uDsH+o; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734942764; x=1766478764;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=LGA2UoGTsjSK/40YQoUbXrdXVYYpZ7ca6P4SWj2rsjU=;
  b=M7uDsH+opHkCUbTcLEvPtLbA19h+KUw8farteCw7c3GxKjFeJ5q7jibc
   NtOBW9ck03mfDzAes3bUXp7f+T7gKzhfgVC6Pfz0nKCYUt7B2WvlUiH4S
   kzBqaTpm46Og4SUnXHXbLGk5oD9d4R7x4AsdyHNB3L4J2SioueXUemjts
   Gum/1osZyfvZHho1BR3niMWfUE8bPHmoAPKap6wXrbSVDver/YIwHqqat
   vFPcWihct5QK1zxij4Yeji0bU/B3mH1/1zBHdKmy+K2Vc30oBMamZFPlC
   Jqa4fblJsFvAtULaY2MmmKPWYTi/u4HqbL7WUl5gt1dRK1i1YTpItOaz/
   A==;
X-CSE-ConnectionGUID: utrmzZg3SMaYSblVk9o4ow==
X-CSE-MsgGUID: PEsjiIuiQPqRPkhSzelRpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="35622058"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="35622058"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2024 00:32:43 -0800
X-CSE-ConnectionGUID: vOHjEkSFT/+jGA5nCQzyqw==
X-CSE-MsgGUID: nF3LXy9bQ3SZUDoq9h4G2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99996801"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Dec 2024 00:32:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 23 Dec 2024 00:32:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 23 Dec 2024 00:32:43 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 23 Dec 2024 00:32:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+bT/jvEU3gqmybxJUn6bEyz7BP6o3cMtKoTBZqKUSyWHefbBwKmGbujJIGD8donlUHw0McPJ3tsU0SVcG8zQhudm/SLILoo2r/niwN/RkYccLwyL7YrS0zpt30kia2Y2xmpwc+sQBvHRKt4V+NhPqIdNbBoeXJYgp9S183ZIhW2znNnl2PZVZG0oUlJX5gJ0jjNtcLczQMWplgQqPhN5HGNDomKY4BvpgAcKTNpDxb6gjMiofe4rmaIHs33bHamxzCHpBdtEMRtSxBYH+zM8lmv/ui0rj5ZC0Cr+i9l0w6bQmK9x/EdeYS3mgolU0frWPByh+lqLv0oAlkwVBpjcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pUmDs9/WWZjixE8yZOr0gf+0DUFKLbrMKF2ER+3FSc4=;
 b=CAwu2i3tLNdbsaapsQ/lqGAx2czVJ1necu11b5SUO1FetPhKk6xIma6kAS6PxPkVCVXVb6vGCQqdiVLVL4Hq2/rb8IHr6EKVnuM/E9/jecuKpBP9ncHGyriqB6Q0JRR0PyhqJ/aF8K4JHHnaovRMPnn3GYAmigF73uZl+DzvAlOXNBIw1Gv4b9dy3bM8M7OzFTfYJhBIM2isUA0qQZ+WYmUybddujye6HF8OGK1NYD0yuX9HQid+aSqyVWUUd4HWsQ40h0Wbjqpo2kpNY+047ovrw9q2b+eiQPBh3HQMm+tt96wNWIpnRsSR9AMt7YffUEHZk4oiRD0CzkWw2oDTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Mon, 23 Dec
 2024 08:32:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 08:32:37 +0000
Date: Mon, 23 Dec 2024 15:58:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <binbin.wu@linux.intel.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v6 01/18] KVM: x86/mmu: Zap invalid roots with mmu_lock
 held for write at uninit
Message-ID: <Z2kYFs4nYVIbqA4t@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241222193445.349800-1-pbonzini@redhat.com>
 <20241222193445.349800-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241222193445.349800-2-pbonzini@redhat.com>
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7173:EE_
X-MS-Office365-Filtering-Correlation-Id: 06be02fb-bd4e-4d66-448d-08dd232c5ad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P+tATwEUPz1hmoh8VeJQ23vTFrmZ5ceNlLYXhpqRnaWyHpjIPNqi51JiOfyD?=
 =?us-ascii?Q?dJoFxoFTAVv+mc2cVpwucE2IpPfDOOzClRw3DXrXgK7MnRyv73bDr7vdPzjv?=
 =?us-ascii?Q?AZNTdgZ1hJTzCpo9pAZJJSmLxqCx93IUSwoUukT33jSI3ZP4kq1C01l8bTvX?=
 =?us-ascii?Q?mbYrAzFihp0mxMi9txkoCjYqz6atZpHo7fvFQ89MxvhhKjCNie/dT/oxaW66?=
 =?us-ascii?Q?m2IZUOfCETtKxb6zd3CseI3IkmNerUCcMBNaYa+dKHA617fHKf+HrDABjHtd?=
 =?us-ascii?Q?b9s52HWNAEUpfgQWAjhdqErE+6XZwotowr8WAEimTn91UDsJfNXoT7wODAJA?=
 =?us-ascii?Q?3/60GAx6cq3zHGYzW41873gIwBX2SMU/X1D+SGE6Pv/RE4X3jniq+xTa//4d?=
 =?us-ascii?Q?84TAeMmHhSoxl5z5nriZ2b5hD91TXHsOBxfCtUFxxKwGKQiCczR2QtKp9THm?=
 =?us-ascii?Q?eXYHiAKBu909E17Wq1atGdbbXuQCy2kz1tYNMjj26Pje9I8jdsWea6jzWScn?=
 =?us-ascii?Q?capcLXBNiJS1vL0NC7MxnM9QTaS8MC1J5I30Gge/qjJ5nLZIFQ2QpJgyM1bO?=
 =?us-ascii?Q?L72s06HINgsQE2VJlwFTJ19H6sJqSMK6spaq3oOZQrDFIuYihTKzTssL+m8n?=
 =?us-ascii?Q?jIqT3TmrKnXm6h3LQBaf2p1QE8pl2BnPcJsAvIeF58Y1w1Pn+tz3/OM+bqF+?=
 =?us-ascii?Q?ezC6rgO3b7B6uB42Em0MMsSRo0HUNI0of8h2kWisLeDiwxGcM2+E1p2qXPJY?=
 =?us-ascii?Q?+e3grKPhHK7D9NMPmxwstDLjn9SHSOvaP5AEw6LD9FKqol19knFQIO7OgmfU?=
 =?us-ascii?Q?FJDFyD+TcbIRbMmNTJTBdhZjQt3YcUnP5dLMX1WUF+LTZxVb3o3vI74NVtCG?=
 =?us-ascii?Q?Ef9kHaj4b4bu5s4Sst89owJSuYCyQMQFyjaSViV7LMKtIdURUhTuXuh4qbnA?=
 =?us-ascii?Q?ssmPxzsRVCP7Slpa5XZczKkdEjhxbt+kRSeJHKdLJxprlx1wx+XZnFxvnYhZ?=
 =?us-ascii?Q?r66eSh+vIzzwBJfR9MTFqFNjtzHRk3L+ZUIPP48+BdxFjU1kJVms5pPS+0Gs?=
 =?us-ascii?Q?rOccgBiugtJU34Sqip+4RJAn2YOIfQlT8035ytQw2tH2BtRtVvmmfNcbVAz1?=
 =?us-ascii?Q?2Pc2p1Tqi4QxDAwnu7C5VPVKdpCZBc4K7PSFc/7IsycoB5JZuVwp3TaFD/1a?=
 =?us-ascii?Q?D1xnrvesUJ/ROs6/75y2TQ4PUhlxAi52DL14gkuS11SETa3GMvjuxWQdlilg?=
 =?us-ascii?Q?DJE4jnauFKfooYTC5QH9ls3xHimqwTNP3UfD0TE+1P5MgLI4iEpYba2aBDzh?=
 =?us-ascii?Q?EINXVJ1yok4VTwz7aqiEJtDPvry81tOQEoXb7L27oM6kcVJSYILytsa2KMEQ?=
 =?us-ascii?Q?AlygBkIV76DrHNIWx7frKu68qg2L?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5NQBWK0QOVZlHc92+30kg4Ubk55r1v/6i9l3dkNMKf2FxAjvtVcXKJaOlEm?=
 =?us-ascii?Q?/kgaodNpYqjbqJ/hld39MPmyvGJl3zwpLPhG2ayjrny6a2UWZImOLwYhncla?=
 =?us-ascii?Q?Us2nu5t0RwEa0Ddp9b6USDMuXH6t8kx0TWKNlbsYMtipVEFo4FEQEy1UGhOi?=
 =?us-ascii?Q?3389Tx2Wmm0qevwqrhRjEuR03SwPagXRwR9z1/5iyNRI5IrUTwTQ9CnVKZ38?=
 =?us-ascii?Q?x2IUSNQiJDKaKammk3V0WgLMveVDbdymbByDfRx9a/ZnCoTMHFtD+rbpi4oG?=
 =?us-ascii?Q?CFLueVPo4eld/Xd5jq/h/Q9EeF1mopP8YQqrcAPQCjsyOsqWwMGFRjWQoIUC?=
 =?us-ascii?Q?JuBiammmLhBC0ZU8P1xpcpHAfXa+IUcf8geL+KcDDsz3r9KCllAa1yQE289h?=
 =?us-ascii?Q?Ftk6/TSqLAZ4rgnaWlIwpGMCnn3WHl1HeDljZEuGxh/a+AcFxvmHfzJqTeHM?=
 =?us-ascii?Q?pUmMIGmiV3LMvpLhRwS+f5ysXdzTFfHrO1/R8a7Rf4HZc10zUxqZWeKdeTua?=
 =?us-ascii?Q?Qst6/MVzmLjKBI2m0cwWQgNdC3N4WbcGpIjI9om4cGOvNpQ89tRhsd8j/SA/?=
 =?us-ascii?Q?QYJ5j/q5jxJ7H+Vck9TJotcQ9Fe5KBSgZ4HWMueuEm2OQmeI1wHHN4Sj6A5q?=
 =?us-ascii?Q?JpZMezyH+T78cFReby0CpP5iYpKhSh7yaF27Zol4avkCK/h1rX0QZSXmCaq9?=
 =?us-ascii?Q?ATI2963k83PS/mAuRIwOwh6EKS7DYDwa4EH85ERpaAbKWGWwOkkPp+a1/mYz?=
 =?us-ascii?Q?2x3bJErjUlC/KlJyqQ9o2nTyoIagSpXrBKzpbcCYUPa00VUlHCOP4n/VBzla?=
 =?us-ascii?Q?pxFUPXAjoCEcDRrKLC7AYlG2voX9P7JXzvw2RdWB8JHIQrG5jbVRJp5rBOf6?=
 =?us-ascii?Q?x+puYlQknCYtV1luUTfqT1wwLPUmVB/wLoDehDHjWBR4s9H2auBGapx2ffsY?=
 =?us-ascii?Q?6wwMGakSt2YRa+LsPWmS3U2wJkaSgIzb/n1ivo4DOCkJLo8iJ4c0vDl/PQyh?=
 =?us-ascii?Q?k6kcHeOeRdMaKqkCXOU7p+tSV2catUIQ+9056HlgXMLHF9LgfkSC5QUIqWMl?=
 =?us-ascii?Q?XIODgoeFMCo9MRRRWJA6w6TlEQCsfZjXZBlbmPdpGFXqO1dgYgI+nm/sSzZV?=
 =?us-ascii?Q?W5yomxEeAccucXTcja6QFWaeD4vTq43OIR1ucHskrr+IHuspv5UUd65Q051f?=
 =?us-ascii?Q?Noj1+oKCtK1Ei+MgvFTa+AEruJCm0Fw5qR7x/Mwj5c6RvmDeMSxcsa02ftPk?=
 =?us-ascii?Q?VddUtwYV6NKgwf/5MAe5hqFVeGy7/SXjzfhAgwFvDIArqmCqvDl/zlHVARuJ?=
 =?us-ascii?Q?nBt6idlNYHT2jLo0Pc2c9BLa0XFcqusavhceFMLMMGCUem9X35bBdz5GSgEf?=
 =?us-ascii?Q?i8yLXV0ylhJvCqGTL73P/tjxUqwHnW2F1dmZXA4oz89lMD8rqY+ofX3yRiFX?=
 =?us-ascii?Q?gcDHl+zxJZqu+Hay3pkBuW6YLeBcTiRrNc9fgP6eAIucF39WR8XjLKiNxSxX?=
 =?us-ascii?Q?Pj9t0CYKbssyuPkKs78GZmC+5kwhGo0IPaLJ/623c6s/zcUD5Ezduopizwhp?=
 =?us-ascii?Q?wsya4GcjzAjOah73RGbfT6fkb/95/f9PMSbEI/Sw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06be02fb-bd4e-4d66-448d-08dd232c5ad9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 08:32:36.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddZpmUrE4Yjv+056o5AI4KEckV2OxUwpKgI5c4mKs7dfM1jkshQlalbduZH2S89J0JhPVJOBgHd3c4+e5N2MDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

On Sun, Dec 22, 2024 at 02:34:28PM -0500, Paolo Bonzini wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> Prepare for a future TDX patch which asserts that atomic zapping
> (i.e. zapping with mmu_lock taken for read) don't operate on mirror roots.
> When tearing down a VM, all roots have to be zapped (including mirro
s/mirro/mirror
> roots once they're in place) so do that with the mmu_lock taken for werite.
s/werite/write

> kvm_mmu_uninit_tdp_mmu() is invoked either before or after executing any
> atomic operations on SPTEs by vCPU threads. Therefore, it will not impact
> vCPU threads performance if kvm_tdp_mmu_zap_invalidated_roots() acquires
> mmu_lock for write to zap invalid roots.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Message-ID: <20240718211230.1492011-2-rick.p.edgecombe@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++++++-----
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2401606db260..3f749fb5ec6c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6467,7 +6467,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	 * lead to use-after-free.
>  	 */
>  	if (tdp_mmu_enabled)
> -		kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +		kvm_tdp_mmu_zap_invalidated_roots(kvm, true);
>  }
>  
>  void kvm_mmu_init_vm(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 2f15e0e33903..1054ccd9b861 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -38,7 +38,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  	 * ultimately frees all roots.
>  	 */
>  	kvm_tdp_mmu_invalidate_all_roots(kvm);
> -	kvm_tdp_mmu_zap_invalidated_roots(kvm);
> +	kvm_tdp_mmu_zap_invalidated_roots(kvm, false);
>  
>  	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
>  	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
> @@ -883,11 +883,14 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>   * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
>   * zap" completes.
>   */
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared)
>  {
>  	struct kvm_mmu_page *root;
>  
> -	read_lock(&kvm->mmu_lock);
> +	if (shared)
> +		read_lock(&kvm->mmu_lock);
> +	else
> +		write_lock(&kvm->mmu_lock);
>  
>  	for_each_tdp_mmu_root_yield_safe(kvm, root) {
>  		if (!root->tdp_mmu_scheduled_root_to_zap)
> @@ -905,7 +908,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  		 * that may be zapped, as such entries are associated with the
>  		 * ASID on both VMX and SVM.
>  		 */
> -		tdp_mmu_zap_root(kvm, root, true);
> +		tdp_mmu_zap_root(kvm, root, shared);
>  
>  		/*
>  		 * The referenced needs to be put *after* zapping the root, as
> @@ -915,7 +918,10 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
>  		kvm_tdp_mmu_put_root(kvm, root);
>  	}
>  
> -	read_unlock(&kvm->mmu_lock);
> +	if (shared)
> +		read_unlock(&kvm->mmu_lock);
> +	else
> +		write_unlock(&kvm->mmu_lock);
>  }
>  
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index f03ca0dd13d9..6d7cdc462f58 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -23,7 +23,7 @@ bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, gfn_t start, gfn_t end, bool flush);
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> -void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm);
> +void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
>  
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> -- 
> 2.43.5
> 
> 

