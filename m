Return-Path: <kvm+bounces-35490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF535A11683
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6881168FCC
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF60C3C47B;
	Wed, 15 Jan 2025 01:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9EtSIYU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7202435951;
	Wed, 15 Jan 2025 01:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736904400; cv=fail; b=nQy5wU4ixCqLMItt4sWy6UmtQ3dgo39BsfyuhZbhU7fP2H4iD70iNs1Mof2S67yKAnjdRL+18LOsV2XkHVs381FuBn0VKCB1R2CwNcbGNS/bzDR/NT5AGvPeA3A7VWXTRybzl4YLnEWm/ZPCWGKXvEetmmhjWrBkol6avx44iL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736904400; c=relaxed/simple;
	bh=fXJgeYd2UVr7v4RmZF+7BzlsoXvGrNMlcHiAwbjg8/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IZYWqDF4hVeiHhjNzxKlx5RxK3HcWmDNIkBEOdpjHcfJqu1l7UeWhcuLioeOdCqz24ML4DoQc8SNNGj7allOenzSwMRnO9wLI7kNnPDDe70dojqhKztVdCchnzQsW17vA321pY6BkCXTg0avdSJ5uZptyuUmc4fkCbAXyGrRCAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9EtSIYU; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736904398; x=1768440398;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fXJgeYd2UVr7v4RmZF+7BzlsoXvGrNMlcHiAwbjg8/c=;
  b=N9EtSIYUgifE6CeFccggNTUqAoVeRBTEO5prGjYaHu28Tl4A1m5SguMc
   SI/jZqHTruB8AHzEeTW5ySWmFcjsLwZcTycLXIndGEDG5OsMkDL5vy2o0
   MFIEL3D5tMp2dUdC6t2FzFT4DtxnJ33BqLW3sHR9/geclBMrbUJGeya/x
   5Rnv/7nDrNygssYCfhYkbGGESjuDW5XbeUGw18b2RLlzKpCnVeheoqy2d
   O9sul98MfYyFqoV/a4G7cVQUCwOoGqGjjR2ClwVIbZ0c3SXCIo2d6xwQm
   3DYYwCTSpXWGKkTsZrpdOoreIDfR9kr5bf9aycghuKpA8dc3+Mo+SXNz6
   w==;
X-CSE-ConnectionGUID: U99HgizVQKeBdiZVRk2QzA==
X-CSE-MsgGUID: mbbbXMW2QQelpqvwsoTbiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="41162386"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="41162386"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 17:26:36 -0800
X-CSE-ConnectionGUID: xIuK3q0CRyeARDvzTYGO5w==
X-CSE-MsgGUID: MDxu1j9XQ0qi8TaEEDDMTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="109952944"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 17:26:37 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 17:26:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 17:26:36 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 17:26:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A540QX+GbgrkLsls1cdTgzrdrSATllexfszU9mCe25ELP5zIaWFjDGhDgNjsCC0u6C7F1qYU1KlzvDXLjaE13B3sw8kjujxK2EjJFtuCqgquCpZzmPTYlrFdWwCGusB6D2rgva8791KeFhwN/xjUsouEG+31EWC74flmG4FArj7di34hyPrRFtcxMia6ZQGtJKmjU+2leqE2QCaZdVNFCos8mibcypsBWSNqPM6uw8o2Fjz2oqeQC0IdzeL/26LJ9YnyoyvpccwEqhIop4g96a3Xw/CMP3fhyx94WVSoZ+HGibldqt05vEaQfj/xbHsah+As/vVTLAIVnjzBRt3Ihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jt8cPvuSiXPf3vW7aUVG1qwFixLLdWsQpTtPwGCJ+L8=;
 b=RIVEbgzidMwv5EXKoy7Hq7EeVUsAIuXVmQCFKMg8RKka4GboUN6xQZCAr9ScPu3pnSeJR4kjhDB7zNEN86wQVcrVgl9eYDpj/AMW6v3xa2+A9sKH0WGMJLsmiXTY1I8vsQY5s+yMaEE4KX2EMYk0Ll3cb5xa3stNzfmMBdjagoHw+3qa9CX2n5AUKS6hLqhn3pCMjqdrd0jr0ZAPuQb2HWl/UYNQVow/Mbx6ndKug51OVLDX2pyAVD9yRlPFjib07KNYK0vpovGPzzQLWz/JkvcbVQGSAy7dnVjLpNWMySEELF5drAT7qHSW4N3/11JBD9gE6qdoecCSLBvu3pJb7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5277.namprd11.prod.outlook.com (2603:10b6:5:388::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.13; Wed, 15 Jan 2025 01:25:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 01:25:52 +0000
Date: Wed, 15 Jan 2025 09:24:57 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 11/13] x86/virt/tdx: Add SEAMCALL wrappers for TD
 measurement of initial contents
Message-ID: <Z4cOaaPbq2Vr4ICC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-12-pbonzini@redhat.com>
 <a3813ab21be79ceed508293d22dd65fdacf9c096.camel@intel.com>
 <277eeb7b-325e-4901-a466-09708560aee5@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <277eeb7b-325e-4901-a466-09708560aee5@redhat.com>
X-ClientProxiedBy: SG2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:3:18::26) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5277:EE_
X-MS-Office365-Filtering-Correlation-Id: 53f742d1-a504-4b98-9d6f-08dd35038cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7aDVoZ155YVu/Un5iFt6JiAsbuHfhwVKFwsJLb32FLTZ5qJEO1/ceJ+csViH?=
 =?us-ascii?Q?B96xNz9epr23QgYPUk9DRxVLaBV2UHE1qEqA9AGaE7FUnO1nxVmz1MctAZxP?=
 =?us-ascii?Q?R1w6PKSKzPbRMTPVqRpyfaVTsZ5FB3a71i87+YBfvYkRCqQ35GU0+dwvZGoo?=
 =?us-ascii?Q?LJash8H1P2/e83U77VVnIfassGei3am5fB1ZEZxIUSyNgRnKiyGYPXEOCn8X?=
 =?us-ascii?Q?Uk9nxqKnBKXWXw1zyS8gSK3kmsPHXqqZTdGj+/KoCXtjU5dHrk9VyU9aHhzp?=
 =?us-ascii?Q?xnnxi++ED8iwsbvYddfnOuC2ekQoDCbU2Tv2nR2XhVFKbRtLrjSmDV+oyMCK?=
 =?us-ascii?Q?Rf0UeCLjxXuo5cZiiNLZVPrYI/assVu8PwbZClnkrD6GulvsKY6ImoNhg8S5?=
 =?us-ascii?Q?yPjlq0Xxclq0uYM3ZOhFjc7cjEyewWKHxcdbwLylOwGQStnaBSCWVg3+txkv?=
 =?us-ascii?Q?ZdvpvCTgnEfJIQSUbu7JfA7UVhEHvVUeGMDRBAePAyEGPh+KxsfKBPNRkCfG?=
 =?us-ascii?Q?e0ohn5mvODG7xgLaNStfR/FNUfsJpdDDnxzTkaLamDh0osJmQZodvjVFbQFr?=
 =?us-ascii?Q?PAIHtnW5frFEkN+yV0d6BN7J4OSkGmGWMbam75LLhQAGoZfO0aRdEjzlL6wJ?=
 =?us-ascii?Q?A4wcXZenAsFWtDteSYSAPp+3jolx9auSv3K9HMpR+drWnENObgyRqt1+tQh5?=
 =?us-ascii?Q?3/stNL/OROCW28wrpULNUf9NhWkG5yCT6kcp5wAYWdMRB9jNjFD2wRChujEm?=
 =?us-ascii?Q?8D70eyMlV51MNMRr0qc2FGwuuhBhKThHQXeyy0PMHwmaTRFCsUABp9xsfmma?=
 =?us-ascii?Q?E5eOGcYx48M1WaKaR9YCLPkuyUy4HjiZbJ07zznC6VPzv6PC1Fw0XgJ7Ut9h?=
 =?us-ascii?Q?DNpccaJqca9Y9oyMPNV+cxTnVMuG+I9MDVYLAhF3EX0S3+VUH8GMe8sxTGaY?=
 =?us-ascii?Q?RTGx6jcuEI3qPBiFr7ov1lk5THvl2QqLkYZKDRxbbIPpG8aidmfnvUHTQGCM?=
 =?us-ascii?Q?Qmt7r3p5LtPG8TJJO83Z3Jih+/OfDMa+byT/iYtKolZoYj46O/xKl54Qyh2P?=
 =?us-ascii?Q?g9pz5KMJqGyuNBoa0HY6FGgmnwhAn7jpqyzSGJXjFN638sVqM8n2QwNiDCQe?=
 =?us-ascii?Q?wyOl6uGUejO1bhrLMJeKsmU66k+0gZ6/iaFzlQZaocRV0+R8x+/IWm40qfSC?=
 =?us-ascii?Q?STiE5O8NoHqHKeugO+0VW2aouBU4M+CZBVA59JwEZ3UHhPI0e9h4wNZuL71E?=
 =?us-ascii?Q?2o+CB8FWHl5MWJ1bsluA3LpzU2OJ35PxU4pTdSCrYDEo0wRYHRnh5pqRh3y4?=
 =?us-ascii?Q?3/a7Z5SW+lyiJmZOwoiee7P6BjXCR2boOJOunsK2OtLZbK4yJw0z+gz+OSp0?=
 =?us-ascii?Q?ezFQgt9q3EygwK5I4Bc5etcwc0oa?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJ0Ytlg7AQzvZKWf7JG8Wl4jlinT71vkHsI3a9OebIwv3R7/EE2lAa6rbl4r?=
 =?us-ascii?Q?2Cz6YVqQITOJjmFwQPxvaxDtUfruq2CPZLHtZl/JKJiLsprCofpTHT38be2T?=
 =?us-ascii?Q?gHHlTZITdTOemx66gJhm2Bm1zO/+6OMX7XlOviWrt0mUZweDUL01YgDBAsak?=
 =?us-ascii?Q?w7NPqmkfNeADte0fApzP8T5UKYNdYLU1ImLMHwBhRcKO4D6vAs5DN6hejHrw?=
 =?us-ascii?Q?B6p6V2N7EKcfqfMKa4hgrfB7dWXlqlpfn6DcV3FAc6Tlz+lNwRgw1X86azsl?=
 =?us-ascii?Q?odRCM8cEwy5k5Kp3mFc0McJqx4WYp7A2QANJiT/KqY/9k51VM/iXZpASCTvb?=
 =?us-ascii?Q?XNJWpqAH3EG3TfUV/OmfksHipty7feHBCOcwsEHsmzWrlWms6QDrmAVh5KsA?=
 =?us-ascii?Q?nE492QBNaDxZ7DHduW9dkjXbopKEkwWWTSf+p4otEs4Sdi3fKu0glgvb2Hxc?=
 =?us-ascii?Q?d1bBICNwPXst2mkkcsuWVeTZtFcyBMSF+jli1TDsC28yN6mPaF//ePyqHf1O?=
 =?us-ascii?Q?vN+tUgr+pgbZLtpuiga+bvcWhUk2AjMnh8nzfHCL1fzV2jDdZUXvuGFjIfan?=
 =?us-ascii?Q?lI4+UVINT5H3BbYqTYdJ8U1RL9q2Rnh5bCNUN4n80rqH0X3HsfbWagdcRO2N?=
 =?us-ascii?Q?O2eMb+J3ahMF8XrF7v7T6DAYeGugsrrUNEfYpTG6WG0YgOEpt4nWOKeOJXlr?=
 =?us-ascii?Q?BhT93X3uF9NIBD/BEIq9ZzHOp3o8la+NAZMdTHl2q3jQIpV46A9MK0ICNKLe?=
 =?us-ascii?Q?8TBoW+d8jRBYl0KE0WtImC5Nw3F+P5Rf7e1+Hil0IFb0ArNflp9XnEBYZ84G?=
 =?us-ascii?Q?JrnDZuK+zC2Idp4PFYkTcWFeJpvgENc3xdhowS+AohJ4toPQ6BN3LtXH8kT9?=
 =?us-ascii?Q?qloHYFmX2MEv81eSSsTvMLiV0y28sKFyheRcUAsBD/au+CdwkKifmsHvQInr?=
 =?us-ascii?Q?PRDMwrRjhVWwb7FKsH5verXdTIdVOmofIVdtlsOagaFeAHfQWlf6SvVzP75L?=
 =?us-ascii?Q?uQGSeb0N6YDjfF/Cr7heNl1YABhZ3DegEwGS91vuQ/ZAzJAeqBSoxH7dZz51?=
 =?us-ascii?Q?VmewJjhip5Xbz5ldViA/7VAlJGPDU3bPzPZJRI+qaV3+2H5IDvMXtfKBfGNF?=
 =?us-ascii?Q?sfz/LL17M2RbjBcHZ3rcMRCgS4SkRb2Cjc0v1faYX5zSdo6X9UXpU6xRQdIT?=
 =?us-ascii?Q?KCOsnLMAyBR0wghERigzIchkK6XTe/gfEwnHG7G86gdthnXzN5rCXrQ8ZpxV?=
 =?us-ascii?Q?s3v/AvMIacy5SGqXUDjZoYjrSTGncK6buuYwtV8TN8Sy2h6VR9dOg7KbgHqZ?=
 =?us-ascii?Q?kA3aiFSQb0JCxGM5TnQUmGBHrmUHcUaS44KeuijeZCnoQUxRFVR5I1NxXvbl?=
 =?us-ascii?Q?zou+r57UOi1NYRq/Nvy/CEzQJ1/ln96WjPYd8J5mYyP2twANFhBZmgGo14yK?=
 =?us-ascii?Q?/MfennX5Rb1+yNoGD+HYnCM5lzWA2p7F346Yi7LXvz/6zBnUKpXqcn5uQD2k?=
 =?us-ascii?Q?UK+jgH2C8Rpn4LjIL54kcrxtf9fA6AyHjRLFkNR1OreoxZZEpfn1DT6QIU0z?=
 =?us-ascii?Q?rcFltqVuduSOGcTd/HjQJJQoh+sxFjs8+IwPIkxc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f742d1-a504-4b98-9d6f-08dd35038cec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 01:25:52.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wALn09NCCKNNN17I9h5l0SH4KOQCnJab18q8CFAd7DekY7xpwDR2/LstWORQr6vypT2o3MLMJcE/91Kw1IO3gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5277
X-OriginatorOrg: intel.com

On Tue, Jan 14, 2025 at 11:03:06PM +0100, Paolo Bonzini wrote:
> On 1/3/25 19:02, Edgecombe, Rick P wrote:
> > > +u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *rcx, u64 *rdx)
> > 
> > gpa should be type gpa_t to avoid bare u64 types.
> 
> gpa_t is defined in kvm_types.h, I am not sure arch/x86/virt should include
> it.
>
Hmm, it's following
https://lore.kernel.org/kvm/e00c6169-802b-452b-939d-49ce5622c816@intel.com.

But if Dave is fine, it's ok.

