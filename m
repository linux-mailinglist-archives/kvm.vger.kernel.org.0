Return-Path: <kvm+bounces-33277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C87B29E8961
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 03:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9874C1883410
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 02:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C9770801;
	Mon,  9 Dec 2024 02:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDFdng0r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A437825777;
	Mon,  9 Dec 2024 02:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733713126; cv=fail; b=YsitHCQNlKHZpxy4Ged1Sew6qTQwmJ3QpucxtAt6Vt4Dw797ha/gn1YrsApcqLTsKxKJdBO5wzLqJrEQj6zfyyY+E6NlY7bntFTFw7xnizev1iraU0ZFDMB9ue5Ia7W/2EvWbK5/tS05N6AGaMjVIlZt/Hxb10nW+fK/B1jxcrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733713126; c=relaxed/simple;
	bh=moYcFR62/CcDAi9Qz0fcAsE9MzY/BdiOw3uH7S/NUdE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B0emA4jOu44qLxd4oPjrRSbm5rpgKsfbqcSPEf2V8qE4B1qjQbtrSN2/DuU+SRQ5eegGQqsogm7nLIPOlUqsZPBYoaDd5d18st56tXEqqiafvWXEvABSogu26vbtLY+aBKTHc/aK4exC/wmwzfguEhg3TR4nftSS/gEEqyNTCGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDFdng0r; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733713124; x=1765249124;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=moYcFR62/CcDAi9Qz0fcAsE9MzY/BdiOw3uH7S/NUdE=;
  b=SDFdng0r+aGqOWNIY0VYf3A8cf9haYZgIh+XRUrNqzFdeF++VjyqV8ES
   FfuHCOuLhN3U3ytPZQlrzhaH5whz+m2k06A2ctY/1gBQYNgOdaXPmVAaJ
   doyubvsQMs7ouvpo4VbE7BUKTWAHEAym60t3AI7DcD7h1jq8ilALNGSgZ
   npm6aMRLmJDvgvquvGGZxdnMGi12965Pr19FSo1YeAD7u4qVkN8jevXAy
   yGUDs6rWhnnXktyiGakqZ215WaIqDs3zyroM/S4qXVI7KLULcj2lqRyRD
   02ELcKRtxnbavEjMeG0IgzcrwRbRTpmDDN53KRSWv3bZirkYtUmt5A/qZ
   Q==;
X-CSE-ConnectionGUID: AV01WHt2Q6eadTgPt0mvMQ==
X-CSE-MsgGUID: O5yaLVldTJGUC3/VgPcdqw==
X-IronPort-AV: E=McAfee;i="6700,10204,11280"; a="45006929"
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="45006929"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2024 18:58:24 -0800
X-CSE-ConnectionGUID: z8HTPh38QuerwIxAZEuCjw==
X-CSE-MsgGUID: TQFgRBlPQVSjYS0wxylJew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,218,1728975600"; 
   d="scan'208";a="94783775"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Dec 2024 18:58:20 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 8 Dec 2024 18:58:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 8 Dec 2024 18:58:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 8 Dec 2024 18:58:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPymuxIwOqn5GYqh+kmo9k4pVJIevHooA/6yZaR2iWIDjFB3lWCJVHylCSfsaZjkpGyF3g/+pRicFcOXnqb5w7tzHaLsvS1oJT8T0a16cFRzJNV2RpA8L3KWN9NEZOYkdtETzZPAmZ2iiTl7sgBlzs9U5XtrGWF5w1FPzalMrMGzOoyaVpTCNPBCnkvhtEJlw8s+odubYg03cjA+lhNesaS/jEVJmKt42oXZ6RElppDMGr4jwuE620b9HGRuc807a7VGSMpXS6bc/kRylqxF/zaWJK+yoxTTRqTUuS0EZOI+05hNA16rgDO0WU+nQ8yIDwm4Eh97lo1/c0NAVoYTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9z2B1qvPCb37t8GYgSUew2K+ZWJmowo8+fP5YRwsnM=;
 b=ly8WA+d6ID8pcgUHJJw2QHl7k7fqC/DpVpmZvhsUUVGWMtdQWm9oh0E9Ydyg62PJX2PhM5pWQFfygARiRWYIf/9qom/QfxwU/eXBdbdpAMEYTWskisaNe6VeE9SzSKWSBLcDU6VE+08uDVG5RkglIuJRfmIC89CaWNMCbkyC/84ko6QNEsmfjed01pxE5yUZui8VINu2KOTqyIg+lTtRihf0kCv6p0tGdTmyO4C3Huk7rJ1q/sLkbq4TRh/sGDNa4b+IqZ3XlZVxR+LORPSlcO/XA1j2AgROIZCRC7mtFb0tYOoQj6V67Bid2VzZvk6Fjxk7eUKzCFAcJe4DcN67CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5318.namprd11.prod.outlook.com (2603:10b6:208:312::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 02:58:17 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8230.016; Mon, 9 Dec 2024
 02:58:16 +0000
Date: Mon, 9 Dec 2024 10:58:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <michael.roth@amd.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
Message-ID: <Z1ZcvCmAPvBOr4Vt@intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241201035358.2193078-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:3:18::27) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: 7beaf9a0-a932-4c2d-88b6-08dd17fd5461
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hWDGYPi62L+eLLIi0esAF0y2Xmy6c1PCBCDaMtqmS9sGgmODu+EygJWMgmos?=
 =?us-ascii?Q?eINBS9YA5qv9ySFHlPyUVs0YEvqevFEHQ9ocAISUZCguOA3US3uy98NRV5vW?=
 =?us-ascii?Q?bElDwGJNdXZd8zZC1K9+yY4d1LwRq+OWA98XuDx5FM+mOjgFwlwJkSTQsG88?=
 =?us-ascii?Q?mwioTE4h1JPF6yCpuzWZOZpacLWmQ/UknvmE8xddaNCS3iyiIHsT8Q1flCef?=
 =?us-ascii?Q?yUGms/zRk92wa7DbhpgSggd/34r4buzeeGJYoIkVjemSiudkm5UxF760jpSv?=
 =?us-ascii?Q?kFTagaz8OowrV7FOqQdn8o0ihGoLSbJhFIh2frswQRBECgBuoDPjqYDBWC22?=
 =?us-ascii?Q?2K4+azahoFVjKgqo9C5uIVmONsaLtJFaMtFJg8HRPxsabs9Nl7zEe13H/NTr?=
 =?us-ascii?Q?QUWjurQE1AmcaOi8V7fgfk98ht2hxKtWJx6xMxX7HLUIkEc5OJo96hygmLob?=
 =?us-ascii?Q?HL3ETTm0/okHiMzzxvDDbUIUcl5QCKxv8ZUaWXhrdpayviG3J0AtToi/+ICR?=
 =?us-ascii?Q?pBND9HrDPiPcdo6/tB5XVi993TfHU07IWhnH7JN9Kn++Ysx99VmilmY2RRDh?=
 =?us-ascii?Q?q/09f4vBSzdmfxzt/nccD5/1oJ52vHhDky+Uv9TEuI0jtVtDcwY9z4TiKSpl?=
 =?us-ascii?Q?un0pVveNiVtUmG77KJE4URvrXhcFBzlcvEFBwLFbXkLN0nYxa8QkZNmem3tc?=
 =?us-ascii?Q?Q2QTVgfD5A+zp0JaRMf2J5bneUtlKYPFtvH0ox093N/0AngnUjG4ZUyR+jt8?=
 =?us-ascii?Q?aF3L6Qoxm90zf6ZFLptjnXIVax0kiBo4smmEH4n8dZaXNMlUlFQ21TmzbLdR?=
 =?us-ascii?Q?TtJANcNNaj3Kvl3QY6Tdmvzn0I3W/7IX4CE0QNyF3/UM26y/5PieueK33H5B?=
 =?us-ascii?Q?Ci9eM+SoKG4Sutqq0xGyss0z5b35gw8nR/CU0ZCgETYojGjf7Fjj5Bkc+TIX?=
 =?us-ascii?Q?+NCfkmW0qyl574OqaNe4XiDVQA1aIC3kV+QflTB4YgeyGOomJr6N/inIwGru?=
 =?us-ascii?Q?MqGHA00R6cyg4WA85KDPzXbHSv8BUtOPk1Etke46nDTHTsjA+CP90cLV2SkG?=
 =?us-ascii?Q?CZ8p/dnB1/cGXW1yKgHgrSXTSNBUv5KrzPtp7Pwv5u6zSOb9B6r5yFIPxGAl?=
 =?us-ascii?Q?bLJdYEfFX8BiS8gneif+j7TPALe+fxOAULpdOsb3gk33kmVeLAkmYgi26KBn?=
 =?us-ascii?Q?ChwAVroRqD2KpmH+5zuHNdsKz2BIm/pcistpby2/sK9DSNlFzBR4fP8oFt2c?=
 =?us-ascii?Q?k7HBwxmTvv30JcLXaVQqg8ymUuJvG2ji59JrZ6ME9FMdap8dRgYJ6eMJwKx+?=
 =?us-ascii?Q?3aadzSDLhvyw3kVsVrAVl3GyZXgvwz+zPctAQ7BLfbM6PBLFJUdGyUh+3eqm?=
 =?us-ascii?Q?/rQ0Mk4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o/zjwaI0XAEOwPVxFnjxTcADgrKnv63smi+PFfa4fkClhgFtj8v59kqkjjh9?=
 =?us-ascii?Q?Je42WkmYP9OzgE5bCYjixE+WAmk3a49MQ+qWhA8530Dyd7DN+tdpkKUdEIVH?=
 =?us-ascii?Q?RX8uOEFm3/PXlCDz/3zLF3HOKKQEI2OXQAMcX7Sko6OdsJU4v1P1uvT/Ab98?=
 =?us-ascii?Q?8GCljEjl54hrKF7/4mbXvWAoz50FPWxpBB57GegqveoOqySrrOIf/gR2Gl5I?=
 =?us-ascii?Q?ZZfk+kvrDl473F7LBSt1qzULUNeRSFSD/N15Ib3mjnWnkJx98f/hVAnLkNhl?=
 =?us-ascii?Q?IzTAV9uhSSKCszTWiaqxy6Sr9erJHMjAi1RbMS+5Jn6LOv0VEBnsfc29q51K?=
 =?us-ascii?Q?NxXf0kqY5/bxjvUVkyOD7X1r1gPkaOg9gK6rdT39ArNw85csvLiz2z2cHmvl?=
 =?us-ascii?Q?Yu4leIsDtNMqIA+LgvagPS2bs5649XG2ToagIRPI4K6X4Z2vly9F7sn1TJCn?=
 =?us-ascii?Q?zV5q14lHbyOH+yLsf1avmsgEtyIa8IbzuZMPaT82sq0iIoKBGyMW98COMhoV?=
 =?us-ascii?Q?VBSBrEw0qCVrDcDauyt7FZGBjKtCnvIL6RR7X0FgSNzuRjLDsKP0Wq7mVdhg?=
 =?us-ascii?Q?siNXo/SC/SmxG8Uyhpi4iT9NlUFH6mZEbV888rfyyqkWMppAHoVmm4RwUsG1?=
 =?us-ascii?Q?rDCj+5PSuNjrkh7nFdFXiMBtSP9/wA5jr5nqI1fakrYHUIcgpnNL2QKmXkXs?=
 =?us-ascii?Q?N0ifk+U585SxlkiXEr5+LQMuK2EgWZunUqCv+CT11PMw5IEaqk6QLuUnnNPV?=
 =?us-ascii?Q?8f4anWR+Mf74kaP9yzHLeTxYSKs8aaubT3GCa07Hdxe9hzw3ex2oR3E4nqj6?=
 =?us-ascii?Q?pBaVv96W59NK/JdqBS1J7PA/4yCo2XbHYkMA2S6RMKBKtOCI6P6A3COyntg/?=
 =?us-ascii?Q?uqHng0t1nrG9JTUmHnNS8lbtVVdPpTSi3hiFmMf3gPHuRd/mK5mTRdUWJ62n?=
 =?us-ascii?Q?2HoaamNSb8m4nOK8R+7An8b3/TzDzBl00AKta7qEBRPPzjrPIU7jOB1u6r4t?=
 =?us-ascii?Q?nEAlOdmZGVvA0zpu5LuH8K3YiAnRILXJG6/eomGU/3FxTBZu1BL0FwcWces/?=
 =?us-ascii?Q?r3VrFURQrRs245QwWrlhcXRLJ6OzPYacJzH8hHvT6qa4yBcYJ1/QO4+tBm5e?=
 =?us-ascii?Q?/5mGY5wA5xoQqWwHDX8GC+DPX6u83Uvkt9jdF+9dwYm9KY1VCY9jWpfdGNvL?=
 =?us-ascii?Q?PlQVPudhPBmkJyIEScokRdkYQLOK4vONc6n4XF6rxKCmsVggG/qSAbxrYhC2?=
 =?us-ascii?Q?rVg7bS6jUpbHQWMNj5ClHD3saZYP5KIOTukmRm8CEhkQgeMuwujqTJ7Z/oAG?=
 =?us-ascii?Q?+VDv+cJNp0WbHaaDT9D55f453RvuI5WXjmBh/OME3ElEa+46dZfZSCmOSBd0?=
 =?us-ascii?Q?66b4pdvU1JGQtA9JzTQj2r+j9L2hqzwcnK1e5hmSTfDWl3YL7CVmYV+fbgCe?=
 =?us-ascii?Q?CQO1oqjrE599y9zgpkrvmt+67UeUFbCxDSy6EeNinm1iPWRkB+qLM0b+hykG?=
 =?us-ascii?Q?YxLR1v/HMiUzkTgd326YgSueDiIPu46qwJ9hI0C4jJ18Ljk4bSGV1MuKWT/g?=
 =?us-ascii?Q?L3ET7RmPplLGIm51EopNKufrU0vGd9R38i9VUCig?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beaf9a0-a932-4c2d-88b6-08dd17fd5461
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 02:58:16.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/KJaHL4ULFWLRyI02hH7m15HCPINEiFr7vMsEMLt/hvWC5RdV9AATN+15XkBe5VQMOChpK+2njc3+myuu3fwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5318
X-OriginatorOrg: intel.com

On Sun, Dec 01, 2024 at 11:53:52AM +0800, Binbin Wu wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Handle KVM hypercall for TDX according to TDX Guest-Host Communication
>Interface (GHCI) specification.
>
>The TDX GHCI specification defines the ABI for the guest TD to issue
>hypercalls.   When R10 is non-zero, it indicates the TDG.VP.VMCALL is
>vendor-specific.  KVM uses R10 as KVM hypercall number and R11-R14
>as 4 arguments, while the error code is returned in R10.  Follow the
>ABI and handle the KVM hypercall for TDX.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>---
>Hypercalls exit to userspace breakout:
>- Renamed from "KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL" to
>  "KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL".
>- Update the change log.
>- Rebased on Sean's "Prep KVM hypercall handling for TDX" patch set.
>  https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
>- Use the right register (i.e. R10) to set the return code after returning
>  back from userspace.
>---
> arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++++++++++++++++
> 1 file changed, 31 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 19fd8a5dabd0..4cc55b120ab0 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -957,8 +957,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
> 	return 0;
> }
> 
>+
>+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>+{
>+	kvm_r10_write(vcpu, vcpu->run->hypercall.ret);

Use tdvmcall_set_return_code() here? it would be more self-explanatory.

>+	return 1;
>+}
>+
>+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>+{
>+	int r;
>+
>+	/*
>+	 * ABI for KVM tdvmcall argument:
>+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
>+	 * Non-zero leaf number (R10 != 0) is defined to indicate
>+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
>+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
>+	 * number.
>+	 *
>+	 * R10: KVM hypercall number
>+	 * arguments: R11, R12, R13, R14.
>+	 */
>+	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,

note r10-14 are not declared in this function.

>+				    complete_hypercall_exit);
>+
>+	return r > 0;
>+}
>+
> static int handle_tdvmcall(struct kvm_vcpu *vcpu)
> {
>+	if (tdvmcall_exit_type(vcpu))
>+		return tdx_emulate_vmcall(vcpu);
>+
> 	switch (tdvmcall_leaf(vcpu)) {
> 	default:
> 		break;
>-- 
>2.46.0
>

