Return-Path: <kvm+bounces-36098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF1DFA17B31
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF6423A4C6E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0DE1BEF67;
	Tue, 21 Jan 2025 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CAynJfh+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00177219E0
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737454589; cv=fail; b=vB+PQ6EFslrIZyQBS7rkKkjycMbk7bcmf57xJbuw1TZWo/8Ew4RR1dNvnWFO3Xt/nZo6G3c2uHeBO3eMLHq5mgFz2ozDv3/wBG8nSZ57EmH65ccBlHE4ZZ+OOyQx9AjYHM3dk1N5iEmmAvR9U6vvol84PHIL/LXNUKCFHK9dF3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737454589; c=relaxed/simple;
	bh=89kZyJQ9kdMxbObF4wXKJRp5jQFz4AuiYxgA1K0yfyc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J8gclCgJ634s+ePQueIYkPep72duRNgldMNWDhz9Fe1tIHcLT2DAFk9AT0Kp9C7yCabvN6VvUsv1znfjcaGGBP/cw8IyRJlqagIAzJMzEM+/GBAjM6npve+13HQnIKsUbqk4aNCC4+drogVIMnk3z0gXqPuzeo7XpN9xeJuTJM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CAynJfh+; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737454587; x=1768990587;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=89kZyJQ9kdMxbObF4wXKJRp5jQFz4AuiYxgA1K0yfyc=;
  b=CAynJfh+FQsiC9gS3JyvKK4LH2RJrtt1loxFu5iQ39WEmgiaFiJZyibc
   BosVvOFN+1pS6TiLTaKsSIX+Qy2SX1WFLfpd/1sIcunTpnb3yzuec164I
   ZglRzOkjoXCXTj8e4UC+OpJuUpV9wSo7tWeVLmY9VZKMhJAluPSYIX9Gn
   p2uzQNTJIWY/8CJwlfTrM/0BQsJxOvY4nYR6M0WhE5dQKA+YYS1WqxXKk
   shAK5lX+3aU8wG9ndq/eTKOHTcm78NzidpX32s3SR1D6mQiH/KV1IPK0z
   f05TPtJrIZ5fj+WzpHZ6C7owL5HMuNuVtMM+Iu15KePXMlnXnDnq2y6C1
   g==;
X-CSE-ConnectionGUID: GIdFJ4b9ShORIhWSjhjBVQ==
X-CSE-MsgGUID: KgYJtZibR3KLT2TmGh2WjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11321"; a="38021437"
X-IronPort-AV: E=Sophos;i="6.13,221,1732608000"; 
   d="scan'208";a="38021437"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 02:16:26 -0800
X-CSE-ConnectionGUID: zf6bw1TsSR6WhkXWHH87Kg==
X-CSE-MsgGUID: wbGfxf94TGKlnNL/NtDsxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,221,1732608000"; 
   d="scan'208";a="106781880"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jan 2025 02:16:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 21 Jan 2025 02:16:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 21 Jan 2025 02:16:25 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 21 Jan 2025 02:16:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGZ89s55lg98sd8kJK+Ye6SKAtRg8Lr4dRNCYY2SsWW8Gso32umjClL1TSGCyR1D+smCaDvBGENP1CejdckJfbASLVql9dljDtWMGOqqIv9Gmy7TEK9rD6Nurqezm7y92+Rk9oXlg29A1EHfmB4tGx3OJTuczLHJFF7Xk5ClCJeyksQ1VuDXEObpMa5wMpPg5gXyFOaJ0drDWCGfxL1547ccDkNLtOG1BSz9P/x9eK1xBq0Aqkn17JYz6EymgB6oV5dB04b9PdWwgsgcKkxTgx0UJttf5y+7dDk8c6gpc2K0faIct+nWaw3qOanBow+rIVJ6jH5hdrzViGCQpnghkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+k0/bGNJEN+K3Ma2gIJl3/x5vsJX/gbcCGSLp6zLOgE=;
 b=oFvxHRpa/hnjEOBYB0GIkHG92vT4POyaa69h8A6u3nj+dadTOKdNivV+TDShZd0Z661R5V2THJ3BLDgpsU9SrU0d/xGhXClPTMacenD24NB+vSyFG2V18RhGHTNn10L2/fFeKGIdE/hBlC4LQU27qUEnt2+nPyLSEirOvQE3guuINQfR0p7yndEYFSAdg69ElnqCNhmbJutlJ9JPleTny9gtLJCwD/4pwbk5fFDLhMFO8OJprqNGqmOWsu0QpD3e9U+W6CcCxtHowKPq2p73C47IGIXQeHYeUeOnX2IC4var5+RbJdLsiEOHpxOY6sQsC9m9BAlhGIuSH73CthVn9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6746.namprd11.prod.outlook.com (2603:10b6:510:1b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Tue, 21 Jan
 2025 10:16:23 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 10:16:23 +0000
Message-ID: <5515f87d-63a5-4c70-b421-616e706324a5@intel.com>
Date: Tue, 21 Jan 2025 18:16:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com> <Z46RT__q02nhz3dc@x1n>
 <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
 <7176db79-cd04-4968-a61a-a753e3668564@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <7176db79-cd04-4968-a61a-a753e3668564@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b812d2-e3ce-4e38-6b70-08dd3a04a82f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXNOWlE1OTZ3WTkvdnM0ZjUySmp6ZGlnVlVKNjA2cFIzWUMva1FJcnc1azRC?=
 =?utf-8?B?OUJBd3BOYXJnU29jczlOY05nRSs4RkUwdzl2SHZncU5zeC9PKzRYalJOVTBq?=
 =?utf-8?B?NmhzeVJ3UzRkOXJ2dzRyejA2a0M2VVl6UHZEcytibWx3TWcwVUE4Q3pTaXhO?=
 =?utf-8?B?b3hVM3lWNUpUQnlLbEdSYjMvdi9Pb1hIaFN5d09oUk9WTllpNmI2bCtUekcy?=
 =?utf-8?B?cVpnU1ROSys0RzFpRVIwQ2hJVGNjbzNHQ1dxTDlmZkJZMGd1Z0VQdFFOSUZy?=
 =?utf-8?B?ck9LMmZwN1RVNHU0Z2FybENIWE0yVzhUZU9lSGlDSUlRVStQZmg5blduV1BO?=
 =?utf-8?B?dGErc3pXV1lqS3RldlNaY2hlNnA5MmwwN1BkU1FycU45bFByYVpoSGU0dTdq?=
 =?utf-8?B?Nk52cU5nMVZyN2hqZC9GZFV3Lzk1R1dDYjBFTElYOFVtNktjaFVXdVlWcGVw?=
 =?utf-8?B?R2VpK2FXRWpOR1g4T0xQUTNjeUJQUy94anRNdm1ReFFNN1hRRk1XdzJSVUZN?=
 =?utf-8?B?K05xMElFWkpiazJINVFFM0FBN09ENVpmT1RmenE4LzBHOVJDYjQyUEtZZEI1?=
 =?utf-8?B?cTNJRElqZFptRzcyazdheG91dmV5NUlSWExOaGdkODMzeU5OcjIwR25JQ0N6?=
 =?utf-8?B?MVJnSlBLUktZK1FDRGVtQjNoQWM4eDJuNU9remRUZnlOeFVsTTdhTCtjTHpN?=
 =?utf-8?B?dWYxMjBSU1RYT2k2UHFkYnBlQXFEUlZveDVpMmQ0QVNzUHoyU0ZrYVRXVHBE?=
 =?utf-8?B?elY1ME84bVhManZQMmhMYXFobXZCdUFjbStFYko2SXAvTHRHeVcwQTk4Sks1?=
 =?utf-8?B?TWlhaHJKdEJtMUFwUEZvdTVYKytZRXVYU1Z6MFpDeG0xenk3SE5HMncrVzYy?=
 =?utf-8?B?VXN2VlFBa2Fxei9XbURGUXNERE5NSGpMb1pxTy9URkwxZ0htcFdwMXpjTzlB?=
 =?utf-8?B?WEM2Mk9oWThYL0N5aDBoT0ZyaVV4SCt5cFRWMjNkRFkrY3p0L3EzZ2lJSTRt?=
 =?utf-8?B?YlMvb0lVZ3d4a0dMWUF5bC9hTWFMWFoydkRJQ1VQR0toUWFKUFE4aU5mcncv?=
 =?utf-8?B?dXpqbVNiUmVoYy9FaDJuREFqNnhSN3NIenNEK1dNWmJmS2doYnNIeUtEV0pZ?=
 =?utf-8?B?eTNFRllab3hsUzA1Q0cwbzdSQUFiai91YmtodFI3WWZxYjBoQ1hQbTdtYVFq?=
 =?utf-8?B?a3dLcVluclpsc3BSMWE3WktCOUZqSHdrZktqTWNJaWdrVnF4TGxHSU5wSm5r?=
 =?utf-8?B?ZW5zSVdKa21BaEgyT3M3NXpuNEsxT1pyaG9LS0FDTUF6dStIS3pUa1ppTVNu?=
 =?utf-8?B?cGFJc2FhQ0wyRFVOWkYySTY2b2ZsOHlGakk3NDZ3dmRKL05MajVuSjZ1R1Fl?=
 =?utf-8?B?QXJkRmIvZ1JjMy8yYW9DNlpPT3g2YmlYQXpMTlp2OEhrYmt0c012cVNvekRq?=
 =?utf-8?B?QVAzNGVJczZVOC80OTBhMFpjQ0Rxc0RpUUZic0ovQUhxSS9VSExVRGxKYjlt?=
 =?utf-8?B?eWVLeFhaWDFBczBYTXVvSFhLc2k4dFpSdVhzNU41YnNyK1BoN0dqWjd1dlhD?=
 =?utf-8?B?NzI3clVIUU03SnNBRmIwWXFTVFE0SVJIcnpKYTllZEkvMTdveldoangrR0k5?=
 =?utf-8?B?SDZDSnpRalpXQlQ3V2ZpQ3pBdERMaG5VK2pTR0U2M2VJM1dOU2NqTjZNTVlE?=
 =?utf-8?B?NHhYRFNEblB4S1V4MnQvK2tLZjJDS0V4UGVwVVp4dXM0SmJURXVxZ2Zrc2l6?=
 =?utf-8?B?c29WK3NTdWdFbDFGQi9Nem5CVmdEZFFxSjJtV09pWExGbHJmc0haYmFWVVl1?=
 =?utf-8?B?bDFJdW5td2hDN0NaZmRMWTFJWXkva2dDc3RLelU2N2Y4R2YxZllwdWhvODFx?=
 =?utf-8?Q?XFSBU/k6Ro6a1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWdJeVhsZ2MxSWNlRE1odncvaWdpQlErY21iQ01LdG81azVxMWlQREhjQXZT?=
 =?utf-8?B?UHZwNmhUd1g1SXlwZWs5Ujc1alk0YmFWaWU0UmJoaGhSTE83dXJBRHJiRHFk?=
 =?utf-8?B?MFEySXFQekFzblhnY1hMZDRQNnlBblZiQmY1ZUg3a2llbzNFbkVLd1J6WU8x?=
 =?utf-8?B?ZXFWTjdCM0NLdGI5cDRMdmZoLy94cVNCT214QVlqRmxnQ084Wk9FcHBvSmxU?=
 =?utf-8?B?UnNaeUxyYXVNZjAvMGJQVEh6elBrV0RDRU9COURPaGoyRzBCaTYvcUNqQitE?=
 =?utf-8?B?TEh2VmNWVWlNaUxEOVNnYkRYdFJkc04rbTUvUnVtTFBFSHVWWUlVemdLUVVy?=
 =?utf-8?B?UW0xVlNTYVcwTUJWTVZRMms5N2NJYVY1MEU5VWRySWl6ak9kdnE0QnIxQUky?=
 =?utf-8?B?L2IvVmVxSnh1VDBrNStXb0duSURYbEJlK1VoRzBscUFGQjJuTU44c0E3RU1l?=
 =?utf-8?B?STB4U2tFRUhMTUJxYXFhS0VZeStERkI5L0FFWGNQNTRDaEpYWVVZVkl3Ly94?=
 =?utf-8?B?R3dTTWVzdVJBZmRESkNWQ1VCMXdRR0ViK1FQZHhRWC9CeUJwaXhLaVRQOGla?=
 =?utf-8?B?UEZwUHZLZjNyb2grRUd6d0ZoKy9iWU5PZWFrc3hRdFlDdEEzREhUb2Zlc2pY?=
 =?utf-8?B?eFdmRUtBZFdnc2FHSWxMSGVscjYvd08xTzluS0FsR1dCWnlmdUZuZTFwYnpv?=
 =?utf-8?B?QTA0M1ozTUI2RTZuWXJjVm5qRHBsQzRrZ3Z3YUNuK3NCZkxFRXA3WEZWSzlN?=
 =?utf-8?B?Z3RYSTgxdmFDNlhiT2drdU1xSzZtUVZyNzJHa0NEVHFXMHF0WVB1NEd5dnY2?=
 =?utf-8?B?eFVNWmdaTlN0blQ0dS9FN3VkNGRONEszcmhybXN6R3dQR3VTbUl2UTFNbEpa?=
 =?utf-8?B?c1ltSGoveDVCRkdRNExjdVB5Tk1COEY4OEF2L29HNHJlWDFxaitGd0J3VWRh?=
 =?utf-8?B?SEpXdjYrRTV6TG9leGNMZmI1eHBQbDZkWng1Q1BjYlpoYmVjdzZpMlRSQmhW?=
 =?utf-8?B?L0ZoRGkzUW1WU0tPRjVSNi9YUWNkMWVDNG9ZLzMvSy9Yd3ZiZEhGb1ZBVGY5?=
 =?utf-8?B?Q2w3ei9UaVZrNjVlZFVEMVZ1bmFzQkFtK0VHOEx0UzlnV2xJWTNzZzN5YzhE?=
 =?utf-8?B?bk9aZ0srdXRNY3R1Z0Z3YnUybXQ5S1ByTW1jMHpHbFRPdjl0cjNLTTFlV2wx?=
 =?utf-8?B?Q3FvNW9xZHhGOUFVZ0FXNDRSZHlmTllGeGUxMlRFa2gzRDhTNk1Fb2hJbVJi?=
 =?utf-8?B?U1RwdkIyaVp4cjkrSWxVQktsdStwaTFTcC90RUY5OWpZMTNBYnhaTDZTWmdj?=
 =?utf-8?B?VjgyZkZCVW1ZRjJZVTBxbVVHVUxqZTBEd2U4WWF5eUxPc0FxVU9kdlJldisv?=
 =?utf-8?B?MUthTUZLT09YT05WdnhjeTQxcDlkazRjL1hWMlllbkhDRGNTWGc3NHdOZ3hN?=
 =?utf-8?B?WjU1NjIwOVJIeEJpSVFQai9TUTREMEpaUnBvdWhTUWRlU1ltYW03K3VHakl2?=
 =?utf-8?B?YWhBenZlOFJXUDRHRXNza1hIV3AyZ0YxNzIwSDR1V2JueDNoNnk4R3R6NDN2?=
 =?utf-8?B?U2RWWTNNNzFqZk9DKzduTWxJY0w0T2tkOXNsUzFMejMyOWJqbm80QTNXZjZS?=
 =?utf-8?B?Q0tkeFl6UC9PMm81YlplOCtVRE1YbGpCZVgwdHhaY09LLzBDMHErNHA0WU5X?=
 =?utf-8?B?b0NZSWIraDhvUXRTUEZPWHFGUjZmeTRGem5IMDJWNnVhTC9DVmEwMXhnaEU4?=
 =?utf-8?B?YUR6L3JLZlg1M0hPamJORGxBTWk5OENVVzhDaVQ2VHNpQjQ2aHhGZjJPVS9p?=
 =?utf-8?B?bWY1d3dFRVRuZUZFdmM5cEVsU3ZVM3NFdnQ1ODNESFhlUTVpZ0I4QldRK0k0?=
 =?utf-8?B?WWJDVmNXNlVUYlcvOE11ZktCUFE0Tk1FeVd2RUthQnJGa252ZG9xYUZjcVk4?=
 =?utf-8?B?Nlpyc09zS0NWdFo1b2tueFpETVMrekFxQ21SR2ZOc2t1T1pvM3l5eithc2ZV?=
 =?utf-8?B?STUzUTV0YTlYazFFWlJDNmh1MVhGRmw2RVVkVlh0NlFCcEd2NFM0YjJkb0x4?=
 =?utf-8?B?Nno1b3kxK1drajF3b3k2bEpDSnlOZ0JSQWp6SDN5MHJDNWZrcDliVlliMkFU?=
 =?utf-8?B?US9LVFBOTDBqR0ZMZ0VnYVBNN2hWdkh3TUtBSVBUWGY0QjAwS2tpbmV5VnFO?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b812d2-e3ce-4e38-6b70-08dd3a04a82f
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 10:16:23.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zZT1P6xK+Hnmd8Y5BEh+RNVcI4196BvoKWUhpNDky+KYpZOrRjmCW2fGy5pzS+KbS5o75whFEh/wyZjH9Be0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6746
X-OriginatorOrg: intel.com



On 1/21/2025 5:26 PM, David Hildenbrand wrote:
> On 21.01.25 10:00, Chenyi Qiang wrote:
>> Thanks Peter for your review!
>>
>> On 1/21/2025 2:09 AM, Peter Xu wrote:
>>> Two trivial comments I spot:
>>>
>>> On Fri, Dec 13, 2024 at 03:08:44PM +0800, Chenyi Qiang wrote:
>>>> +struct GuestMemfdManager {
>>>> +    Object parent;
>>>> +
>>>> +    /* Managed memory region. */
>>>> +    MemoryRegion *mr;
>>>> +
>>>> +    /*
>>>> +     * 1-setting of the bit represents the memory is populated
>>>> (shared).
>>>> +     */
>>>> +    int32_t bitmap_size;
>>>> +    unsigned long *bitmap;
>>>
>>> Might be clearer to name the bitmap directly as what it represents. 
>>> E.g.,
>>> shared_bitmap?
>>
>> Make sense.
>>
> 
> BTW, I was wondering if this information should be stored/linked from
> the RAMBlock, where we already store the guest_memdfd "int guest_memfd;".
> 
> For example, having a "struct guest_memfd_state", and either embedding
> it in the RAMBlock or dynamically allocating and linking it.
> 
> Alternatively, it would be such an object that we would simply link from
> the RAMBlock. (depending on which object will implement the manager
> interface)
> 
> In any case, having all guest_memfd state that belongs to a RAMBlock at
> a single location might be cleanest.

Good suggestion. Follow the design of this series, we can add link to
the guest_memfd_manager object in RAMBlock.

> 


