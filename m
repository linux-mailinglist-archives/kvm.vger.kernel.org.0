Return-Path: <kvm+bounces-34721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 403BDA0508A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 973EA3A1F26
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C81118734F;
	Wed,  8 Jan 2025 02:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QdhLO8fR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10F315DBC1;
	Wed,  8 Jan 2025 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736302823; cv=fail; b=Jpws52u2ICts9Y4BBSzGuM+5HRbsvXkqUUcVbeus/SM3QoJZ4ChKnTEFxpICSEfOC6/7mTjoy339D9dYJFWTQ4qNosibOOncY3/bp0joKL1himkmAG7PD7IGbp+SXMT91WVEzq42q+HFX98j+UzWthpzPrFCpGf9e+hlGsldrK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736302823; c=relaxed/simple;
	bh=jqQE3LnGFWTSBLfSFHhRWzRKdF6iWw3ACh4WPJKL42w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L7JEsxusZtl4moVn5GaXoa2JmseTDtRuhuXALx6ngS9L3VKsFfnMu35KIBBzuymi8IYfgIEV5d/Yov2CJSa6qyXh4o4Tv8yt5T0TSAJoiwrumm8DJJT9QjzDIPaO5pTzcZPghMrIwuf2KWptYlNMqOtIX1Ky6rs4ANHYtKXGHi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QdhLO8fR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736302821; x=1767838821;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jqQE3LnGFWTSBLfSFHhRWzRKdF6iWw3ACh4WPJKL42w=;
  b=QdhLO8fRC0O2Lwxa5WdaiWjW3BSenip0pef2MhbMqivNjqiUko0+5I6L
   cW6Z/BEtKeZiDWuPHQ4Q1LXgWoG/s4jjovMxIbHXJjYIhWHHZVVH03M1/
   5Zv4k8CbKcQFRSpIAWoPMjwoahjvYogcfS9HDAspo7q2mVrQ2cCUaeBM2
   wK++z6XkTT8sMubtxQsoDjp8z8ll/Owj7k1my+Vbb4+9D4uMTzfu/gt40
   e9ke4y2xownjtL0IHsOkSTFdQURlzfXrLBLY8eWnj8OvaCkKgsRu1NqjL
   REcgO4tlyFiGgiNmqhP3qh+07HgSTj7FQ5BrVqxB/XuMthzg90eu4OLw4
   w==;
X-CSE-ConnectionGUID: 7JDa91PRStyU0pl5kY1P2A==
X-CSE-MsgGUID: lpn2uf6qRtCQsHO+H4rahw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36395062"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="36395062"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:20:21 -0800
X-CSE-ConnectionGUID: Vc93/AmsS/m4qZysZTsYkw==
X-CSE-MsgGUID: Yz4TdF58QGqbyfoP9T5umA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="133839285"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 18:20:21 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 18:20:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 18:20:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 18:20:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sOAva40ASl3bYHkZKO8FX9TmRRNUH4ngvsGTTtGH3OEZNLVSE8I+RrKPTujqdyhTvDLRjyzW2ERFP+5FSnrls6lOUpVrKvelcbM4QG84rKDwYjDu5lPrfPwuuRNLugVw/nYR3h+IKQcvmgKlLor45JxuU2XxrZCqfPdQUlmKp2x4gR3o/pd1EtZVrn/N/6imMghTUEg5Ve0RmGNXmY8WsmTpPaXyc3zK08AYcYT34r2FgCd5Ea9njhMbYvxLvC63wsZ51cl1pew2qVlfQIuTFOJn75q4Ciqv7SNjXS8hlnfqXmlaKQPhO40sFjM7zzDiikUywqpvvsOtHXnkvpylxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzECiJg5uphs4OXwqrRy+A3YkYNaDva283jHc+dSvwI=;
 b=PJ6X1mnrV4H5ViBr378UoH+t23e2BjyKhQIkt6nimMY7V74bWzuT1oR/8jLNkMd1xPXXKEs//5kfMITuURukTuwrDGH+h7VghDdIkKMaMKYAL3g7WM47n9Jd0Z6Klq9N4J+duYmZKMZ4HkFrBzSejUysbXwuXtH7ZJUNFsA94fFbQ73R3Z4oKV+HdABZ8aQBGxT76x2lBxYuKY6Cdu6Sd/8Yj7wjfuJZaVwyp6S0R1evl6qkinjrwdTBmEXzNiKPpiJ+aUQMGMKPtGEEGj9TnIhjz9Ge7k834NWVLbCMWCV4vtHTwVeocS8zZz8KApHqTSYog7+l6gZ9HJKhzl4Gnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6112.namprd11.prod.outlook.com (2603:10b6:208:3cc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 02:19:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 02:19:49 +0000
Date: Wed, 8 Jan 2025 10:18:52 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <kvm@vger.kernel.org>, <dave.hansen@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <isaku.yamahata@gmail.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v2 22/24] KVM: TDX: Finalize VM initialization
Message-ID: <Z33gjNlhGGSEngYJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241112073848.22298-1-yan.y.zhao@intel.com>
 <fdcab98a-82d3-44fe-8f4b-0b47e2be5b7e@redhat.com>
 <Z3zbRYnyUmVWvxFO@yzhao56-desk.sh.intel.com>
 <CABgObfZMR5y7T_dv-V8ng0dv=L00XgUmaDm-V9Y1aVEuz=0anw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZMR5y7T_dv-V8ng0dv=L00XgUmaDm-V9Y1aVEuz=0anw@mail.gmail.com>
X-ClientProxiedBy: SG3P274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::13)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 501081b7-f271-4b6b-80f9-08dd2f8aed59
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VStvWFVNSVAzUnVSS2hGV1hwc2R5WGJlUjBETEdFUWZsVWllWk1IYklVckEx?=
 =?utf-8?B?OFFHUTJhZFpycWxlNVVSYkE2UmJVZFJ6RzBRVjl0a0lrTkRVcUhvU3RJQzNw?=
 =?utf-8?B?cFp1WElndjRMS3VFYXlHazlVUEVqUEdnZ21EOXlITmU4Q1hoU0dUNUNyait0?=
 =?utf-8?B?ak5xcFBROWxJQkxaaUhPRWtRc0FLVVFmeitVaDVsRTd3UXpnanpjajZTSU9J?=
 =?utf-8?B?TjhaVVVGNkFoWjhMZ2VPNVVjbXJ3a1RBTjhibGFDUVdkeVlRUHU4Y05TT2o1?=
 =?utf-8?B?WTUwb0ZweUpNL3doMFZPRlptY242QUg1SFJkNGtPeTJmRWx2TjNyTUNtYVFj?=
 =?utf-8?B?V0Z2MTM5ZlZFN1EzQy9MTVdzVWUxZUN3U1BOSC9LanBBai91RUdhK3l3MlYv?=
 =?utf-8?B?VGxLNHRGbmFlV24xVXVsOExvTW5kOGIrNElrdnJUUVV6SHdndTFDdzY1bXRl?=
 =?utf-8?B?UkE1YzQ5bUx2RmpDT3g1UXJXYjR0QTU2ZmdrdWdlZTBSYzRkenpOSVR3UXRH?=
 =?utf-8?B?ajIrNUZXZmN4WHQ3RDQxbjhyUU9jNExsM2FUTXp3NTh5UEd4eE1qbWY3L3hK?=
 =?utf-8?B?K1Q1MWRRdzVoYUhvUmRwOWJzQWJtK3ZrSjVGcnE4R2ZCY3U4TVlQZTZQZFdz?=
 =?utf-8?B?VmwxT2NUVmVwRlBBblFMQk5BQlMzVWx2MGdRQ0xWYndldTRjbC9KZ1pOMUcr?=
 =?utf-8?B?UzNPbmFuSC8wRXpRcWozdURNbkdWSTZtV0xVb2ZLS0ZQRTllRnhQSzJ1UVc2?=
 =?utf-8?B?UUxhRVdiZ3BOdVRBSjE1TWFCL29HY0FwdytTWk9KQTRpakxMT1BHcnVNYlUr?=
 =?utf-8?B?MnM0UUo4WkhDNUNCdzF1STl6aGJLeFBCZklsY0QzWUpMYjlWRVJaVm81M3po?=
 =?utf-8?B?bE9JSEJCbjBEbERUcHZZOVpMVVA5Mm5Ka1F2V08xZGNuV1Rhclltb3MrYVcw?=
 =?utf-8?B?aDJ5NU05UW8yd1VBUmNyMkV5YnM4dFZQMUlrdUozeVIrMjh3VEhPWUcxVGNM?=
 =?utf-8?B?dnlMTjdzOHhwVFREZWlscVljRGZnMmNRRHNXV2pCdktBZGJTRnZNd3dIai9V?=
 =?utf-8?B?dnZpajBaMHYzaEp3YzBPUjRNSnJra2syNmswb212YzFWZ1hkMi9pTWI4SVRu?=
 =?utf-8?B?S1Jld2swSkVuVXZqWG80UlF2RHQyZHJacm1pL3c0dkJuMzU3WG1rekFHSUVn?=
 =?utf-8?B?Z1k1dklySUNqZ0Y5RE1zcmE1WGwvMjFQSDZtb1V2dzhjdEZURDRuV1ZDU0Jn?=
 =?utf-8?B?Y1hnVWJ0cDBlSlhNUW9oZzY5RUJDSjBwUGp6TmlIVkVoWTVVbFFWbk43SGtt?=
 =?utf-8?B?RWNwNElPMERidkhlZThQeW9OV214aWtRNGZSeU9YTm9vTkZaVWN6VDBjSXVN?=
 =?utf-8?B?cUFyZEZsUzBWYWNiTnBnSmcyTmxrdUVuL3N3U0RIN0wrTGZTMjd3QU5ENDlE?=
 =?utf-8?B?MytLYTAzSHVkVDdld1dqZHlkdU5DOHgwdk1HT2lTMTRIYXpwZFdYenF3NTVi?=
 =?utf-8?B?MzEwUXZ2SGZnYlRyTG1yWEtyQ1BRbWxKSHZERSs5aUttVyt6aGl1UndrTUR6?=
 =?utf-8?B?RlQ0MXZsSkRmdlJQRWRVd3QrT1BhV0ExYmN4NnlMWDNuSGx0L1Zod0RoSEN0?=
 =?utf-8?B?ZzVLZitGdzdVVmovcTdNYTFZdXFZZnVSTGZCLzlsaUNRTmpsWmZ1OUpKVXZx?=
 =?utf-8?B?ZjgvOEJ2amJoZW5Ed055TjJacFVMdjhVWWo4OURFbnRxdnY2TDEvdkgxYm82?=
 =?utf-8?B?aE5IUTFMQkRlYXMwQUhCeWlicWVYRTU1aVA3SFVSd2NtdUJlSkg0dGtNUXdy?=
 =?utf-8?B?QjdZNWpiQXQ2bkk0M0kxaGFLcVV1Y0lPeEFRNGdKekdjelpZMlFpZ1FPWkpa?=
 =?utf-8?Q?fPf3zy+zRdMHD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUcwUWJueG5aNjluVE9tUUxhVjd3T1pMYWtaNXBCSllWa242aHhFWjE3eFBx?=
 =?utf-8?B?QjFiS1hhUFNYZ2VDTi9UdzVqVFJuOGN2OFVwOEtzcEgxaGJocWgrbjhQZVZS?=
 =?utf-8?B?azNjNXdOcWwyRlAxMkhPbnJGNC9RV2g5OUIxcjlWM2JrMEZiVmVqOGt3WHFl?=
 =?utf-8?B?Tm5keWJnV3RDSkhuRnFSQlNPdmJxUG5lKzJxSEozc2UzeWxSQm1UUW4wZC9Z?=
 =?utf-8?B?RVRUQ1pNY25MUXBiQjcvcHV1aUw2WWI2UzVSWU9rbSt4K2FkbHZXN21iRlRh?=
 =?utf-8?B?V2s5Lzh5azRlcDZNTUhlWjdscUNTTTlrRElIcDJYQVU2TDVMR2dmWG8ycUMx?=
 =?utf-8?B?WFJua2haazFOY3Q5NldWRDI3dXQ5TnkwSEhjUFVXd3YrTzZJcjJNK2NJRng0?=
 =?utf-8?B?dUtJTDF4M2tQYVBWRkVjcTVOd2ZvaVhvdUxmRDV6VWM5VXkvVHQ2YkI3Nng5?=
 =?utf-8?B?NGlkSjdLZy93R1JHRlo2cHdjZEE4TWlhZ3JZR2NSVWM0QmNNMktjZUNwc28r?=
 =?utf-8?B?RnV4S1NPQTB5Z2RTMXAweHhkdEtSZnNTSWN2UXdLaUJINklmVWNkc1hqM0VZ?=
 =?utf-8?B?NTZqV1YvRHRSb1NoaXEyNUQxT0NHei9RSUsyOE9PZnA1SXhnZnJOMy9QS2ZJ?=
 =?utf-8?B?dmVXZ3MwY1E0aXd0RHRTb2tNblJoN0tBQlFrOEphVDdrdEFiYU5qMnc0eit4?=
 =?utf-8?B?b0F5alhJRGlJMDlvaW53MmxZdzV3Q1k0N2YxOVRYZVVXeFplS0JzeXRJV3Vr?=
 =?utf-8?B?WXdrbkFxNGl5WVhaK01rSGhsYzlJR3BPMmNHZ2ZyRHZDZ3d2bEpud2RLN3dh?=
 =?utf-8?B?ZVhSbWpMTUxqcC9hZjd1emlEa1hUSXBOYVc5ZFlNWEQ3VHBGVnhydDZPZjFn?=
 =?utf-8?B?dnJ1ZDNKNFdpYXpxNEFVZDcvZ1pOMWh4OFlJMzBrYU9MUHNYYXZibG9YOWdH?=
 =?utf-8?B?ZUJ3TW5yMWQ3Qld5eEo3cVIraWwyUGhzdUxjTjNpVnJUSUFUQ3MwWVZPTC9s?=
 =?utf-8?B?SWkzQ1kreEJqQU1sd3BHYWJhWXZORGlPeUxSL0VncFVUczR0aTluRXgwNHhT?=
 =?utf-8?B?Y1ZqMU1rS3FMbG80MlljTWFUeDRzcGUrZk83QzFlN3lqblEzN1BYUHE5bmVz?=
 =?utf-8?B?WUY2SzhkOEJ0dG8zNU1HS2VlRzU5a3YxTHliSk5ua1dCL3pyTzdmTTFuWGVR?=
 =?utf-8?B?b3hlVGNnbnZCSFVMTENZcjAydzZkUXc1aFJKNUNBNkZ3WHN2azJLcUlFMU5r?=
 =?utf-8?B?N0d0NVlCKzU1UTNjM25ibzhHdDhHQmcrWENWYWRJNnBmSkpwb2x1aC9OYUNp?=
 =?utf-8?B?MGFrUG5Ub3czT3AyRHRFUzZ2YTM3QmhZQUFPaGJzYUFJWVRpeTA1TUI1ZXYr?=
 =?utf-8?B?alRwWjlkdVVDdU9JeEdDWXNPRmxXVkdaTS94ZG85UVlueUhTdnNQbVA3ek91?=
 =?utf-8?B?S3JmbERNWmJoK3BKeUEyT0tzaEhkbkt2VEVaSFhKbzY5RTRZYkJSZlJvaElL?=
 =?utf-8?B?OWdtSG9BTW1rR3NZWTFRV24xTWFvem1lUzJybzRTZXFrcEJuNVUxSEQ4RExy?=
 =?utf-8?B?MWJnVFpzZWZ2dmtpajdocjh4YkNZcDZIbFh1Qkhtc2ZuOVh4WFNyeFQyTjdP?=
 =?utf-8?B?cXlELzdsckZjSjkrN3duVnVFaEN2QXE5djZNbnRHSm5JaS96TDNkM2hYdDNm?=
 =?utf-8?B?UStHbmtQeXlzVWlUQlpOK3JtSkdSOXc1aW5TTUNzTWVpeVRRelNVSnp4dXdP?=
 =?utf-8?B?VS9VUmVFZWxOZUNTRkorS1BkUnoxUUVDZjRUcElYZ1hrQnFqemp3R2VkbHpu?=
 =?utf-8?B?THRzTm9rUEJ3VmxVY0dKVkdRdXlGSG1JKzVPNTJ6UHEwSUZjR3o0QTlVS2JE?=
 =?utf-8?B?OWdwOVVNeEQ1aG9ieU5FbjFXcHJTd3BaNFhLWVZ4STN6OXl0WkNnWWUwdklI?=
 =?utf-8?B?aDBSRU1yejdZMUd1NlRZeTVsSnJ3QzF1U2grcWpyQkpWbDg2NDJScGlLT3k3?=
 =?utf-8?B?L3BpMm5Qb2luU256RSs3Tm1FQ2hzWFZMM1lTaTkwSXpPZGJSenZHZzBmcjhs?=
 =?utf-8?B?UFJZdWlSaGpLQmZ5WCtDcVQ1UjRNTGpicUNlY0F6ZVZzcEptb1ZtWlRHY01m?=
 =?utf-8?B?dzRnNndEWnBBYThJUEY0VG5BdGFiUUQyUEdXZzBoUGYycnpnNkVXcldqcVJh?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 501081b7-f271-4b6b-80f9-08dd2f8aed59
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 02:19:49.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/dtDsA7yad8vjGfk6xX1sNihNxAaVXlY7/yS6cbwLsW0OQhdOeJdbAkodIpl/Qa7IbzJK09393J5JWN7nUWnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6112
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 03:02:28PM +0100, Paolo Bonzini wrote:
> On Tue, Jan 7, 2025 at 8:45 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > @@ -1715,8 +1715,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > >               goto out;
> > >       }
> > > -     WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
> > > -     atomic64_dec(&kvm_tdx->nr_premapped);
> > > +     if (!WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped)))
> > > +             atomic64_dec(&kvm_tdx->nr_premapped);
> > One concern here.
> > If tdx_gmem_post_populate() is called when kvm_tdx->nr_premapped is 0, it will
> > trigger the WARN_ON here, indicating that something has gone wrong.
> > Should KVM refuse to start the TD in this case?
> >
> > If we don't decrease kvm_tdx->nr_premapped in that case, it will remain 0,
> > allowing it to pass the check in tdx_td_finalize().
> 
> Let's make it a KVM_BUG_ON then.

Ok. Fair enough.

