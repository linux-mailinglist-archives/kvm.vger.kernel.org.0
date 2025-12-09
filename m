Return-Path: <kvm+bounces-65548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BC2CAF295
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 08:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F4233033DEE
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 07:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2262E281376;
	Tue,  9 Dec 2025 07:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TGEgH87p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4EA23A9AD;
	Tue,  9 Dec 2025 07:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765265862; cv=fail; b=FN1AEbKkcgc28Tdum2PRVCDG85iTolGm20HbYoseWm/Qn0wZUfUgskn6il+NtV6etsUGhXduIslJ99Yna+fcYl20CooztJT+M1Vw8EmRD/pnTEkoZQY+5E+KvR5yYq98U0U9E6l2c08HRDY7IRbosxCr4l+hq55QQrapukaFovo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765265862; c=relaxed/simple;
	bh=YILEUeiMLIVx9pJZEMZQmJojDkvuJEEq0mjKI4xOnuc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PwA0r2FOxpLYYlB/3hepDtpVBpklBDdBixs+sR/PuVdLU5G41lXuEbkZXXjYenRvDo1vamoXpnilvAPaHjQvTCwOSfaLDH5LhkED5HddMFFwGamcfRzAgZC9/CTYot/k+iGllcIq7/yKK7iSuoWPX02tlRJ08Ysopj0OAgb4ClM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TGEgH87p; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765265860; x=1796801860;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YILEUeiMLIVx9pJZEMZQmJojDkvuJEEq0mjKI4xOnuc=;
  b=TGEgH87pg9hx4MeLPIPO5cHBiz3lWqCJqLOSWsDWULAqNhinEe5mlTME
   vc6J4ZQJ3zXYOPxacPWxQGCkFTaXdP3LbLHqpsUfTvygQn2IWiCb/mFrz
   MPzlZcmMK6ZEU+HSNldJUKGs+A7+2uuJA4tp62befnH0Xj22dwrVfj2Hw
   7UIgxaHlkdFbM3CpyDDUA1G9ijZ8Zhl+6tHA4vrEPNJpViYu39qOp5Bnz
   /95DdylV214aHDULUCigymFlFdlP8qBm+nH4F1bJuKcazR26NnQQhJ+3y
   JYI7W2VTQkG0jSqZaCtct+hmAI0WiV7Af5rjKUBH2KN+M8sQG683j7Tlr
   w==;
X-CSE-ConnectionGUID: +58XSR9gSta3687gmT9pzw==
X-CSE-MsgGUID: BMI+X3SoRIWyeidmuopHhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="77833845"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="77833845"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:37:40 -0800
X-CSE-ConnectionGUID: bmv5yUIzQqmGDFFznPEwww==
X-CSE-MsgGUID: QyXEbmxCRLCkBmWtjv9Ydg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="200630596"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:37:40 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:37:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 23:37:39 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:37:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHdggKnk5ZhDD2tJ65aRPLr96SVloAYUZhAZke32tps1YhJKT3dJ14oIndJTqCd0q3k4LJTqYsOvvXOkEXkeKaWfFDW9XgW9ABejJDUiRE73oi7g1Qn4VI1tug4Qd8+K2+f7cw8Kl4XGnurqWAPQEzrBD9BQKCnsAqClrvFyZ9Kvbj7/4XVo86e1CgLIdFe/oDE4Z7P42nt+GLBEZfcHq6c65IO5TkTtF0mMUbCZMvQbqouBoSfnWV2FZMjZiyzwd9WZuG9Cps03CllP8Pb30yYAmcHOUtxo8OSx4MnHpaOJH1vB691bEUL0F2jfXDvc0zaLzXLDd/v95JsfSWGSJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YILEUeiMLIVx9pJZEMZQmJojDkvuJEEq0mjKI4xOnuc=;
 b=e+kg7CNH93psz5VVCWcP3E02M7291zHjh7PXwX4RlsEzhIuIcyz0OgFTfqIdpsatrvovVrCAizPLqubgPGpG/bUPnIoISNG79ULMgC+Cn0Ij7rzl7sC6vJyjJys05W4lt1B6vEJ8JStctbwgpJTKTtc2QQMoNovRAZ0QPXKDOMkp/xPZVk3kZW+ffTqme6CcvQwoYL9k+Nr7Fi/W4No+/8Y9XJc0aZ+hZpIYZu8OiiA3by41BDoy9TIujt3W2OAescXTWgp0F08OtytsThCfLadlMhdAp7ScDMy8CBP1xSzR/ojSq04gRfJGMQZzYeGXq27GIc6mjmevTlq20LbqZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4707.namprd11.prod.outlook.com (2603:10b6:5:2a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 07:37:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 07:37:36 +0000
Date: Tue, 9 Dec 2025 15:37:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 7/7] KVM: Bury kvm_{en,dis}able_virtualization() in
 kvm_main.c once more
Message-ID: <aTfRtRHtXdvqyF9P@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-8-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-8-seanjc@google.com>
X-ClientProxiedBy: KUZPR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:34::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: d11bab7b-5bb5-4117-1c02-08de36f5d291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uSV4a+1k0XXkD8ruOUb135mwOmCtaDMMCh1M8ruDe7h25DBxlAIzJ8cplx0p?=
 =?us-ascii?Q?AsDmNZZP+pVwWTGKcSUfom7S2bBQiilJPannFmkZr/QFEt1EDDFe5kMGLaxW?=
 =?us-ascii?Q?FOcBt5H6nS3Jp/zTrW5yZBfPWOY1yHTOyR80mem/VQPr0VQ5BkKI3zhxyHSO?=
 =?us-ascii?Q?PlT3kSVXvixS4gi9WGkvtF3mJ380chCZ3Zbpig8eWqXkLNfZQj20HWpofmDK?=
 =?us-ascii?Q?W5nukMLfRkGHcc9MsJM1CBsDiJx8Gzwh97pd2JM+B595KsTXa7+Rxjk/3dJE?=
 =?us-ascii?Q?lh0NidFugl3yIPo1+eBDAAqGcAlArqJ8a1PWoxwiaFbBUYIM1d8WBUKVCb8f?=
 =?us-ascii?Q?VIxYPB8JJbPNjFyBqjj/Aix+QJcSoC/ZAMwzg8uyiQa5QJWh5Sa2IrBXenzr?=
 =?us-ascii?Q?5edS23o0gV1DTgYnRGDZWwqcILCp0gUBXkPoDKfMhSXXJmxuA6FKNczdi3/P?=
 =?us-ascii?Q?vZRx8onXeXeEmBl5vmBbSXSDFcLsynhC2TItvA9csUlwy7ZOSM9c3bVXiwnq?=
 =?us-ascii?Q?hsYDQ8lcr94Rb+jzEn2WX5Y7laYODJyafsuGAoqzcGS6H0WL8Dc2ZvOcyWuZ?=
 =?us-ascii?Q?jneEH0ntwem5A8UCYhcwGGV15F1AbURChj9fzHsb+6R7gdFKWhAHvEd4OF6Y?=
 =?us-ascii?Q?mUZNc3sTRrfRIBZCuD81h+uzbAIbmF5vuSQ9kk6o4uzBQ8rTw79U1UwgMDmi?=
 =?us-ascii?Q?7s8OWKAH5zpJcvYIF/hN5dmt4OtEyQuo3bIRrKbtA5LR3me8vyyXEgAW4hiT?=
 =?us-ascii?Q?zJg8L1+gIWTV/ImaYimdQw0lSu9CIbjF4Z2qCdm4sXrxTXZeNT//phJMFExp?=
 =?us-ascii?Q?DQ4soCzYmtiWQkc/rb+gDstDNDQiJ9kcMFOQGkgytcSNnosvmmse2imkXtPl?=
 =?us-ascii?Q?P2Ewo33u6S12V6/jU0ibIKv4rcjDC4T2nA0fPL4/uDuEKqJyu9z4PRsS/MhC?=
 =?us-ascii?Q?ZKtNMRU6PPZxc870g0HBfWt+Coa1lgwqIO9tUbpx2pPnRjsxaiT4w3mbA8RE?=
 =?us-ascii?Q?XtLyJfMz9e7Sz0FQUVe1QucuJUn7sg9HyNFJ9XM/iF/FiJvvA2xIoPJfyyJB?=
 =?us-ascii?Q?55HR+F0EUyOUeqVrDr6z0m4COhIBvwTshTKajPbCQjdQ6bAxIm6UbGPOBZDG?=
 =?us-ascii?Q?5px2UhRAhZi0FEejQhJCc+2wINcUwl+5RJWc6XwR3va8ddV4OQw/mIeWcvwD?=
 =?us-ascii?Q?UpcDeoUG4pVusTCHJ/D8EYQ8vf1bxUKjwxPFqUhGM5GKy8cqfoLOHTraxtKX?=
 =?us-ascii?Q?inIaaP6rIyncl79SKqlovBnnSLBa7P/d7dr3jrJ4PuStyjnCWQ/ZjaOIgEdp?=
 =?us-ascii?Q?SwPOnq0y6Skd/XeosaEvpjBdRlbxc8WzJntu42Ef5LzFGV/uPMvZ6ivB4rVb?=
 =?us-ascii?Q?MbdZftD987E4sHCIfJL3ryRUzaDZymwNnOIs8dTMOrXSa+tvqpaGP8al92eI?=
 =?us-ascii?Q?e0DruuffXvXqPLq9kT9bbeeFYG7EGudT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NV2Fi9xJF5XcH6ESBZC38TDEEKRnZSSnIPmA3q4lMTM6PHMO7swUvwkqe69l?=
 =?us-ascii?Q?y6bRRfCeW5xYJHVuzNJETizh5tO1FAvu0BsnjRNUprgUttjDfrplcEC+NQRc?=
 =?us-ascii?Q?Bren5klTzPU2UALA5+x+1guzSwxeFx+czZJ+ZCyVPAeeLhy3XRHOJvOIxFF5?=
 =?us-ascii?Q?eycP0Y8HGwxIECslVBWu9yHg0XbvmwET8oku8+1i9Sa4/RMN1xxqS3/O9yv5?=
 =?us-ascii?Q?IjInJiQnV0hCkIXc8w/G692PND3s8cgLSrbXI7DEs97+fpRUZ9Ds5WhOGOEj?=
 =?us-ascii?Q?thDjRWMdrEryn4xhnP+aL/A3sWT2Cp5TZwDrEwGS3fOaatWstxkPDzYQUUY1?=
 =?us-ascii?Q?irOFq4dZYZuwFBeLJcOE/OrqW3yICID9/O4TVO6uljd3eszzRaDzkwk2dEeE?=
 =?us-ascii?Q?UWwavK/513FPjflgXEvYr2JRIXlCzmReZzA58UR5gxeZZWu3aA0INGFW3aex?=
 =?us-ascii?Q?ftMfoOJHS7zNa1E2HKS5MTW9oZpTFJ2H1WHaauqd8vmplnauRmFy3DE7EeH8?=
 =?us-ascii?Q?nbJXJ70ch/93MsLbLKWQ9mreHRRTSfQhnP2YJUJIhcVNQzRjfDCFSxtEPX2l?=
 =?us-ascii?Q?a5pgSU+QwKQ5DSsUDAcNraK+3NNgDREG2IUwWZoumMGt94mReLlv2nkcECns?=
 =?us-ascii?Q?z8Ue3f5G4MjUa+bKP1IF4cGtVkjqzyNupTAWrpThHGm5DqlTK5jjy3YBXR3u?=
 =?us-ascii?Q?nXUwyiuIuPthw33194ikhek7/smuaPKrNPiWeb1n2+wL8f7sWXVOYw6MRtcA?=
 =?us-ascii?Q?+K03qdW3kaeVxYGzI4cMRLd5acS4rGb4IiQcJTgz4ZO4Aw/kGqycwKHGYm3d?=
 =?us-ascii?Q?KVt9IUJqv6o5z55g1uVHgCdp/P1/Ehp30ho09+A/UwoYocC3CL0cDnQfi+Ap?=
 =?us-ascii?Q?h0y0Y9od5c/yRiFBQ3Qs4axj5+Z0Ym+p20Vunmv/W3jJOCd3beSUzMlrbcYt?=
 =?us-ascii?Q?nPo9tSw1pbb9vi2JNPwYiJBEPfdXIV9FWHKMMS2uDGJLqqATN/RkdZPTeIEW?=
 =?us-ascii?Q?jneRRjyn8LzykVUb8Euvi5wEIxoKYyMLrPQ24zJHccA4rn2VyD+rB+4ZzqSc?=
 =?us-ascii?Q?CDCUym97fv2x74W5nYOf6GTFlueQ4jMpRscxt0wJsnxo0kbEutBgFEfHtwSO?=
 =?us-ascii?Q?pFn6n0UvZH5fB3VR1VSp5gZu1Q85Iro1IlrY8/wEr95Ulzjy7eNsX4nXTi7w?=
 =?us-ascii?Q?AA4tISQdvTXDAJaIuFjJghcQnWh0eyIubEnjEYRoqLKL5jfPO7JczRrCX9nT?=
 =?us-ascii?Q?v05vU1KAIHKjFrGPU5iv8WqJRZoPwILVv/eiDBAXBCCZyuWVod8f3pBrwY0K?=
 =?us-ascii?Q?9Cf1dcOrM6r8qn5JwcNosR1uDg/zG4KorQJrP922vJAix8pCGxSRxzkkZwXh?=
 =?us-ascii?Q?89o4MAVkIyWINzO2ZYPyb21ABW671Xhron5r0JBsoEoXSAWccFwzE6UNaCxa?=
 =?us-ascii?Q?6NUDbbtyObcxnWafXR+hKG/q0rdIRxj96baMcE1CSuEuasKlKIFfuZcQwqD7?=
 =?us-ascii?Q?+kdgfDeD52hzCs8rkn6SwtKudF36L521tr/lIzaOqppjbih+VuvdfL3Ar6l9?=
 =?us-ascii?Q?p3T7baV6ggWXO1is0tBGOcMbIHgVURuELtdfLsz7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d11bab7b-5bb5-4117-1c02-08de36f5d291
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 07:37:36.2463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfOEQJrwHHtyuqovZyh4mxNWeEpk7HHhP1NkS6E60jtkAec5XRINKXTcCDw+dfEMbGYXLDuID9ld6Ktdvqc4rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4707
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:54PM -0800, Sean Christopherson wrote:
>Now that TDX handles doing VMXON without KVM's involvement, bury the
>top-level APIs to enable and disable virtualization back in kvm_main.c.
>
>No functional change intended.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

