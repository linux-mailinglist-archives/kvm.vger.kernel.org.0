Return-Path: <kvm+bounces-68665-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FRiO5whcGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68665-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:45:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5467A4EA7D
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A77D7ABB18
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2272D248B;
	Wed, 21 Jan 2026 00:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GVzZ56p/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4924F1E1DF0;
	Wed, 21 Jan 2026 00:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956301; cv=fail; b=TA3kWLo9k9ZGnnRKzX6ViINFNK3RnelntGOBjTbF8s9vSV/fkS1TbsgczZUVmoUZONbQO0SvRiWGKjbEdVsBe5pp8gweZDd8Xxb9dPe0iaNu7ObB1vphOYRc/IIdQgQZiKukMsg9/etWyx16dSnZBavrt1qzxtiDuMf0qVg6XXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956301; c=relaxed/simple;
	bh=vKAoCzJ9KB7xf5FswS03pmNuwdeP7D1VlszFEjJNuHw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pXtd3BoNXURRJSUGBD6OfLsgvrIzDNFFJwYWxkDu3fbB86UF6f0fBmPThwtE6v7/PnsHpAhJBIfDrD+eAHN/N08iA10qE0Irc3nwQhm03wqWpd3e2AWl/JlPPJ94iejXa4C6C1grd05iLj6WIHioxU4GhngCZG0pZfAg83u+l7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GVzZ56p/; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768956300; x=1800492300;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vKAoCzJ9KB7xf5FswS03pmNuwdeP7D1VlszFEjJNuHw=;
  b=GVzZ56p/VMvcTK5fCqgjTv6q/zMsbibqtcHvRSvMheGPRMUkpLLgYl50
   WhHmHEvNKrQO3szLzyLnPmu11XawyQxCgK/YFWgjWYIK1G8G6QzCXByWy
   AHcs1S55zvNgu5MlaRiDmlu+ZKT2k5dap2LuGdPl99da8F5BEieLjlovH
   r6Y/BMi1olZZdD9O2NUasx/dCkLlf9outQnggh5ehuP8zr0WmvobQoxcL
   Nk/TiiUNM9w/dlpqAqN7O57W2rZB9yKCm6bg7VL8CFz6U1S9wf7E/7Zpw
   9Od9z8Y7aX2yvFlf04xZRWcySg1aSwsHmR9zOagHIANEXtXMb5Tnhk7Ka
   A==;
X-CSE-ConnectionGUID: 6jJ7dk6VQJu4Fs7tR3Heaw==
X-CSE-MsgGUID: L2rs4eKjS3+qaq+kOJthow==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81286879"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81286879"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:45:00 -0800
X-CSE-ConnectionGUID: WWRqovYVRyadfNhnY8tdFg==
X-CSE-MsgGUID: d0o4WXSTQfi4YvtTDCNCLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="243844801"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 16:45:00 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:44:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 16:44:59 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 16:44:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Us6IrBdipqFL23BsbMKwojuffYbmZmfHduMgJqMGsTh42yJu+uTaH9bNimqrnm+yw/7VVX1CAQNeRWWq8J7kthnlQGhSK3Bk7f0OWo0b1TF1EZn2LOPKw4QvyNtxcs0qtdqFEumWYx/yFVzhMjyh96uq3zLipS2u0SU+2C7MdIxFmaMR3dobgaendirj1rvjC08+lz1rla1YZs+iRDRLk/+pslTVJOIAyOO9bEIjw8Iv7Z2rI3YcQFuxPifqVAQ5o2bBL0JBPRfoW6hpoAzUU/+gkjevGu4DQggp7eHXFBGnILv6uALp4wI0StwpnHXCUoRDFpqlmck3bDP9OjIztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuC4ANWgEvTOrHpnjWs60oQQkN6mh3X1znZ4F/ay9AQ=;
 b=mRgq8nrub5N5rgPEcf3MbaKX9V+hNjmokWKqSi/l7EJlUBIz+R+yWL5ULovo3Jtx281nk8iG3n5mvYu9cAezhZTMJUg6InZmwQ3DxY0RN6IaUIJUHuopRd7GjgWMVGto4yFJfu38cWIcIa2XyDinqGbfhYajv2qbrQsyu958aeSzgURz+UgttNWVMmdGSGiEe3N7BLZ1PHUQ8b5/uP/azWUBqaetgL/PflwUan3lSM1jTAWLUlSky33z3VJHzVPbgOs99m/LhF2hZpKPQjYQoP0FPpH6M1Z5Br4fo/cXFg98OyIQLBMWB27vt4jisrzCbHdEeyu6MEfgmW/c3ZSmQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 SA1PR11MB8573.namprd11.prod.outlook.com (2603:10b6:806:3ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 00:44:57 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::fde4:21d1:4d61:92eb%5]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 00:44:57 +0000
Date: Wed, 21 Jan 2026 08:44:47 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 19/22] KVM: nVMX: Handle FRED VMCS fields in nested
 VMX context
Message-ID: <aXAhf+ueMAOkiZrf@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-20-xin@zytor.com>
 <aS6H/vIdKA/rLOxu@intel.com>
 <3F71014C-5692-4180-BC6B-CCD7D2A827BB@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3F71014C-5692-4180-BC6B-CCD7D2A827BB@zytor.com>
X-ClientProxiedBy: TPYP295CA0032.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::13) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|SA1PR11MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 4840f290-cd3f-4edb-a1fc-08de58864cbe
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UXoxb0lWOVBSamdLZGlvdXkxYVlWdkQzODdGbjl2eHhnSGYvTUlWQ291bE82?=
 =?utf-8?B?emRpdEpJa0FiN3ROK1NrSHA0dDNRR2lCSE1IWGlYRHFxOVBHZVUyUllYMFlZ?=
 =?utf-8?B?RnZESi9uOGx5RTQvSGRxTEIvc2prZ0VwQVhnMlpQVmppS01vVnY5Z0xtWFlx?=
 =?utf-8?B?U0ovemxkQWJjNTg1ODVWSFRKcVA3SlNZbEJBeVhSTDlLU2NzdUtrQU9HLzBF?=
 =?utf-8?B?VlNBbkp3Q0V1V3VOaE5EOVk2REVTVVhUdy9Ib2FzditLcjZ2NTF3WkNXcWY5?=
 =?utf-8?B?UDNON2IyNnpkaThVOTAxaTBZMFRHdzQ2U0lVRjZwWEJ6cW9IaUU1eEZHVDZi?=
 =?utf-8?B?RkNnaFlXc0U2NUtRUmFwMGpob1U5SW9pWmlmdVFKa1ROVWFScFlPY042ZlJV?=
 =?utf-8?B?WVNmWk1SeFh5M043cjhwMjlRWnU5dVoxWXhiVEVraVNneVRPYzRjRWpLZnJn?=
 =?utf-8?B?ZlZjWVcyaGtqSHczbVVwMDRsd3BZZ1h6K0ZlYnZLbXBtclJiRGE3Rko5TlBR?=
 =?utf-8?B?Tkp5SGQxQVlCZkFOWlpLUW1EMGd5QzVNUk82L1ppS1RuQ1FVc3g3dVlmRUV4?=
 =?utf-8?B?aDVMUTI4MUtNTGdwQUlNdVNlUHI1UHd4TXBBUWhTTmVJQjd6Mlc5VmVTc0Nm?=
 =?utf-8?B?VUtweFlzc2FoZHFUdDdiYmRqMWppYVE3RnVyMDQ1Qkphd0ltSHk3ZGdYdGNt?=
 =?utf-8?B?Y1V2TzNaNUc1Umo3UE02bFdCVGg5WFM1b3dTQXRlRGc3TmRkY21sOEVEbmNs?=
 =?utf-8?B?eGYxVWgxSVhIT1hkZnFOV25vazY4NnNueEd5cGZSKzhYT2QxZUxHWE15cmtm?=
 =?utf-8?B?V1NhWjBiQXdkZzlvZkZlQ1QzNFd4ZnhtRVBzb3BzbndCYkU3dytTdHhKSWhQ?=
 =?utf-8?B?VTZVNTdmR3g5U2FPd1UzbVRHeHJxMkg5L2JkOUxXNlFXemRjaVF3NWhsRUpI?=
 =?utf-8?B?Vmp0ekNBWTZvLzMwWmp5anJ3NmRCaC9GbWh6TVFJYVg3NUF2ZjdNYUZJSWFk?=
 =?utf-8?B?czYxSTBNb0M4S2FsUFdTOWVNaTlGOUZIT0NObXQwaGhFZ0JMS1VWYjRoM01s?=
 =?utf-8?B?cFh4SmdmR1IxQ2hpZ0RKK09FSVd1MVRLbDRxSWpFekhFaEhpSTJRaE1rRGN6?=
 =?utf-8?B?RnBTY25qeElIWjEyZlZrNFJaL01RdzdSVWFzd0JXRlJIaTBVY0pJUHYvUW5q?=
 =?utf-8?B?SXJ5alBlZnJ4cmRPMG0za1lRYkw4bE14UGU5TFlaSVp3bG9VajdIbThPRWQw?=
 =?utf-8?B?VzAzQm1MNFdRYm81Uk5XQ1VnTGgrVXdFb3hMR0F1alpPQzRBdFpMQVpFTTFp?=
 =?utf-8?B?UElnM25lVnIvL2tiWTYyV0hYTUlIdWc5S1BBdWtqU29EWk14eE1kM3JES0NT?=
 =?utf-8?B?VlU4R2lRZ0dpb0plWkFtRXFnSzg4ZllNQWkrcGVZV1VIZFdKT3ppU2FqbWNU?=
 =?utf-8?B?WElJZGtvSmpLNkpzYmdvWE1GelMrWFlWNGNDeVJEL0w1bjhpN1daVWJUcngr?=
 =?utf-8?B?ZkVwZDBJL2RHSTBMS09ZTUFDMkJhNmsyUTlIdXJNQXhwZEpSK0hNQlIrM0xl?=
 =?utf-8?B?ZGNPeWFUUkV3ZWE3QmIxUGhCRGVRWWVmR1VneXdIRnMwUmRUdk1jc2cxTWVl?=
 =?utf-8?B?ajhEbFNHQlp0eE14UmZDalJOeHNzRTAvc1FJbUh6SGorYmJobUVoMHNhMlQ0?=
 =?utf-8?B?U2VpSCtEeDRSeG1Xa1dmV1BwR2Y4c3NLRDVxTXU2NklZSDNqMWU2QXJvWHNk?=
 =?utf-8?B?eG9RMnNWbE80N3lZTERvVi9seTVteWpLVUplT1NjT3FoWGpPc0MzQTNUVUtL?=
 =?utf-8?B?ak1IanhxejR6bnNwMUgxK1FicDZSNkVTZWhqNVJ2eTFIcEZQaEU4K3FkQkJ1?=
 =?utf-8?B?MnE1cmZFZzZGS3c4RVdaODYzckJ2NDlUTTc4dGdvVWRWOWd2YXBvSmppeFpu?=
 =?utf-8?B?WlV1K0c4aXpJaHZ1MitZcWxGYkhxSjlZUUExK2Z2YmRraysxZGRlMUJ3cGZq?=
 =?utf-8?B?MHVaUVdHczdxVHZ2R3Y2eDhYR1RsOThkNU1neVZjbTJWdU9jNXdkbUc2YXMz?=
 =?utf-8?B?eG41b2RzSG1FZVJ5WjF3ZTZiVlVLdGdvUk96MG0vdGZEeDZ5S3pvNzJJTDFJ?=
 =?utf-8?Q?5cQI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE5NSElJMmR0eW1aZ3BOc0VWSzNoaXkrNGRmemRrQlBMdnV3ZUljZnUwUDY0?=
 =?utf-8?B?VWpjSzFtODlvcmEzb2R5aUxmTzZUSDFHS1dYSWJqNm9ISndiUWdLMS9rSnRa?=
 =?utf-8?B?SzU5YklSWkZyRjAyY0xKVlhtVGFzNndpdFRISE5veUlyYWpGenRISFhkWG9O?=
 =?utf-8?B?b2IvdklOM3NFMzdaaE9oRURTYU1tUEo2YWZ0MGhDQXppSkIzUkdVUEwwVC9q?=
 =?utf-8?B?RWdKNUNzdWtnWmM1T25Pa2FnWWtvOFBrMTBTRzBFVFhJbDlkUStHVnR2UlF6?=
 =?utf-8?B?S2EyNDFwTmZ4R2piY2xqcFVwUjB0dVJtSmdvTld5UmRMZnZXaWQ0Y3ZXTE5G?=
 =?utf-8?B?NTBVNnpVVTJxczFqZjFWU3JpN3ZRL283Vk1wUkFnZzZ3TSswQVhUQnN3NENz?=
 =?utf-8?B?Y3k2dWMwRWxlc1ZOazZBem9mNXgxNk1tWFpvS3luUlVDSkRRcjhsUE9vMndt?=
 =?utf-8?B?Rm10dTVjL2FNQjNvbUVmdWN1MWF5cWF6NWc3QWhhVDFLekJ4SzlPLzFnNCtk?=
 =?utf-8?B?cUwvb0ZyYnRRbndwOUZXbEovSWdKM3BhTjBkSW9tMytBOUVDVE55VDMyWDVJ?=
 =?utf-8?B?bVFwbVpaM1k4akp2MW9GS1pSMWxCdDVaaTJONytybk1YYnlER0xpQnlBN2N6?=
 =?utf-8?B?b0dpekdudms4WVFrK0doT2djWWdkVWhxblNHNmtZRmpwa01HVkFHMTJ3cmtw?=
 =?utf-8?B?eE5CbnBEZUpuQ3VkaE5DenFNclZFSUFoVmNwUUpZWVMyM1FuQzZOUGY4MkxK?=
 =?utf-8?B?RTdKeFV2cWR0OTRwWm0wdzVjSVhDYUZxY0p2dkptWXd1aVgvSmlLZnJkYlhp?=
 =?utf-8?B?MzBXNys0R1BrR0lpVFF4UE5vMTNYMDVmbDNPY1AyRjdsRGsycjAyOHRRNWlk?=
 =?utf-8?B?UWhRd1JXNnRIQlY2NUdmSmd5c2dYVTBFb0VUNkpUbUlxYlZKNzhPbHArSnAz?=
 =?utf-8?B?QzVveWJDMU05ZHZmOHp2bFpjVEk2Ylo0WjBZL3hEbVR5YTJCM0szQ21RSlRu?=
 =?utf-8?B?RzRuN1I5cUlkRURsS3ZlYXd1ZG5KMmtGVkpPMDE1MlMrUVZ3VWJ3VzlNSWtQ?=
 =?utf-8?B?WXF2NkpRYzBZNWZWOEpmb1dwY1RBU3RIMWJNTEc3WjcyRUVKS0VCYm9nVGdh?=
 =?utf-8?B?cmIrTVZIbXk3SUcxZWZZVmZhZytUUTZFRzBEc0REYzlxUlFQRVZhM2tXTzE0?=
 =?utf-8?B?R2pOYzc2Y1pUdGJYT0xjaDBtUlJTQXBFY0djVHEwYThmVzl2Qi9FKzdjQ1FZ?=
 =?utf-8?B?VisvdkhONEpBc1BwL1FCRDhpRmhldm1KM3Bna1Nid3FLeDZpb1AyZ1B1NStR?=
 =?utf-8?B?akRMSWhBYjlzRVYrQUtKRnhqK21XNGdGS3ZFV2hVaWIzS04zVmZQdTlMdDhp?=
 =?utf-8?B?Q0NzNWt4UWRlY1dIVmhDU0h3ZnVURzFlM3NZYURTZ2JncUl0SEJ5QldoSDFv?=
 =?utf-8?B?TndsdGkwQWNOdWMyTXF0dmxwdlpja2JlQ3NDSGJoeHNYWXpWQjV4UDFqNHJB?=
 =?utf-8?B?cTF5ZTg3WkxnTkJQdW5DVWNQQk5qb3UxTDJYRXkrNldGbkZDS3pqYzJmSzNz?=
 =?utf-8?B?WG1TYmE3eGVzRXJ1eUtUL2N0bmpnby8xWHVsbzdzNGVsRlBYV1o1bnluQ1NW?=
 =?utf-8?B?Q2Q0bndYQUtPSnI0azdIU3VwNjJpeVVLZnNHdUZucG9lVDdhWVRFRlBzNWhN?=
 =?utf-8?B?NkpQVWV0S21rT0gwVVJRUUxuL2Z4M3NlM0lCL09BV1pIaUhzakFlZXBnUmUx?=
 =?utf-8?B?c1l2b3E3U0w5elF3OFNCdkhmZ2FWR25vMnUyK0pUM2hKd2hncnJZNzBMSDJF?=
 =?utf-8?B?ZWs5SUVsWTVUWFBHUmRnRi80K2xOV2hNRytjTnV4YUhxcVRtQURFQ25QK00x?=
 =?utf-8?B?NFZVeDdkaUloYU9HajcvSHJkUVVSWDZlV2l1Qk94YUJOYTBxZEE2eCtqZ0Jk?=
 =?utf-8?B?U0RMazZLVDlnVVlpTWd3NUZTNXVpOTUzVE1RUGczWmh0NHlCc0JmV0xoSVJI?=
 =?utf-8?B?MWo5RUorZW1mVUFzalpsL0lZWFpnbXc1Sm5Na1ZMenVjSFlNdDhBZysxM2NV?=
 =?utf-8?B?a2FSdEhRT3BSUDRBcFV4clROR1dMeUpadHhlNGthbzJISTBkRlpyRXlWdlhB?=
 =?utf-8?B?azA2K3hEdGs4T1k4Mzd5ajRYOXRFc0NuRnVjNTg1WUtycEszMHhLdSs4VU4r?=
 =?utf-8?B?S1ZyMGp3MjVIaUcwUjUxTDhlQklTSGFhVG5IVXQ5QzdITTJuN3pEM3VtNzNi?=
 =?utf-8?B?UVUvK3hEU2JBVEhURGpIZkJrZUVhVjdJTGZTU1NUS2FaYmQxdHBhajJRdFJR?=
 =?utf-8?B?amdKUjZTUEZINlA1ZlRUbjNZb3ZKZG9oN3pUQXpPOEF3K2lGWlB3dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4840f290-cd3f-4edb-a1fc-08de58864cbe
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 00:44:57.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kV9BErQFLulcJjdiP31dow6XA5RWN/SRmnwctyEFNnXgUvzVVVr4Tk0BaBCFKOHul3xAnDN2zGbXUN6xcDzL+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8573
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68665-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5467A4EA7D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jan 19, 2026 at 10:30:01PM -0800, Xin Li wrote:
>
>
>> On Dec 1, 2025, at 10:32 PM, Chao Gao <chao.gao@intel.com> wrote:
>> 
>>> +
>>> + nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>>> +  MSR_IA32_FRED_RSP0, MSR_TYPE_RW);
>> 
>> Why is only this specific MSR handled? What about other FRED MSRs?
>
>Peter just gave a good explanation:
>
>https://lore.kernel.org/lkml/f0768546-a767-4d74-956e-b40128272a09@zytor.com/

Do you need to set up vmcs02's MSR bitmap for other FRED MSRs?

Other FRED MSRs are passed through to L1 guests in patch 8. Is there any
concern about passing through them to L2 guests?

