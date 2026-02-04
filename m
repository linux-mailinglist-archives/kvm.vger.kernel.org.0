Return-Path: <kvm+bounces-70264-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAgfNOOVg2nYpgMAu9opvQ
	(envelope-from <kvm+bounces-70264-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:54:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 54051EBC85
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:54:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E634304018D
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A653C3F23B1;
	Wed,  4 Feb 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cRHi1102"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91287156F20;
	Wed,  4 Feb 2026 18:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231221; cv=fail; b=nrpBU5PoiqT3ugq7zXBbyfBRG8fbriQLweVjh1z8kddm6KMHUWsxmzrYkpXkCRnL775niRtz/zqQ3YZH3Lc02srBHQNkEJpkvFPnCuGJPROA4s6FmRrmMBGmrsIxYDIW2Wc7GRHIhVyNLHVbjDar4I/Jc8WSW+W+fQnDNlhHJcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231221; c=relaxed/simple;
	bh=ri5lCNcx+QbKrB9Viv2DVTpf37a7I3bLgxZQ1M3OW5M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LavuAj7WurQ7TbktXDZfFcRklWTduSeBnviduFO2aGLAsDfPJN/nPCtpe+mtH8QuL199aKSQw89B0u1YTorwV7HMDVQYwgivhdUg8lrCUSLvwuHGTCER2kGtxn+BqDTfli6NRc7Ohby9ZaJEN2iRkQY1hg9iPveJBGOXVsqL1g0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cRHi1102; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770231221; x=1801767221;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ri5lCNcx+QbKrB9Viv2DVTpf37a7I3bLgxZQ1M3OW5M=;
  b=cRHi110212f+mHodBKmsLbwXfR4iWFLin1FWTjIyhDqvG2yVZfTCYM8O
   4KzMboBEAIBkTo5lbn1Uzm6dYOBIzxR25jhcmXerSTVQn5CP5o3QXidfO
   Ul5k7QWijFJexqslh991k0c2Nh5ihWtL2sIf+ACaGEVv+qdEpTCHEEZL5
   PMHYT0MIwXGkM1RFaJabSwlJUWR/Wwb4t3oI17+f51U93a/dPlgNcCRMw
   hQtdILAdCugwDa0anVsx1lH8FrzlFuRvS2QNO7oesZsnY4HMsM78rVlmF
   l9tndRTGy43//QLIQ3bhXwVZO6aTvhe/YgkB0SVpOYMqptsmvVh37tlJe
   Q==;
X-CSE-ConnectionGUID: 12q2b6vHQC+7YIGTqiKFOg==
X-CSE-MsgGUID: 0wFUqFzMQmmFkDkOyS6H+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71461416"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="71461416"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 10:53:38 -0800
X-CSE-ConnectionGUID: JY0FS9C3R66jS8MFFwyjhQ==
X-CSE-MsgGUID: rrAF6u6yQbK4MDng1OY+Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="215233174"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 10:53:38 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 10:53:37 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 4 Feb 2026 10:53:37 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 4 Feb 2026 10:53:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vt1sSc7/t3m7S1KCqH6GP9snxE1BQ2MW4y87F4LW9nRIw5yXHdQtX2XDOCDrTJbUS2mQAyswDSF4piLhklw0tOjuV7jV6eCb/vpoCKoH7cYRh6TlkvJvzbWYjaM6OzhqLVxobDVq7J0bRhvr5rqYqQBaibic/mT7mylK/YDoQvzxw07fzADGnD1rWhGVdEkTMZs/9v9Zo4UywG4a1HWcRErnkLROG5jIDpfaKEcUg0HDP/oI9ySh0SyJw0EY4/uWPEl6bGFmTsTgadi74hnev3YYZK/sPLtaj06yjBRJy7BEhgX255HXWogbNeQg6xHhedQwocmvckEkapGlVO87PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mcui8+/ic6ABQ/53XHhz/iPU8EcGH00PR/gBFVOIZWs=;
 b=mUddonVdMCPkRW9XQVL934zjgOm0eNjsJhebPO5gXnjKb7KYWYfLtQ0+4U4Y5ck+Oow6RlptMAtNopdTvI7XkRVVthB+lIHWSNIpa2Eyf+p2A6YPjjMw7FZ+tGSG+37aCHoZii8U6FGxT9Z7yqnSUDGozPqFZKgREb2QaOaRlgLqoupdWWVSqSEuhG7TNVCQkhrLzTtzwgVZVsTAklv3SAx71CE5XGzt7n8AxUc9wb5H4+7GjV9EtsTae58fLlr6TdEU8xsj9Dv850GfWeKGsFya9p0meU/BPo2NwKreNVJXNhLoByLZbpgEiIUgT5c9N3h5VcG3601tUcUnv0Dj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by DS0PR11MB8163.namprd11.prod.outlook.com (2603:10b6:8:165::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 18:53:33 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9587.010; Wed, 4 Feb 2026
 18:53:33 +0000
Message-ID: <722b53a7-7560-4a1b-ab26-73eeed3dffa5@intel.com>
Date: Wed, 4 Feb 2026 10:53:28 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] x86/x2apic: disable x2apic on resume if the kernel
 expects so
Content-Language: en-US
To: Shashank Balaji <shashank.mahadasyam@sony.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "K. Y. Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<decui@microsoft.com>, Long Li <longli@microsoft.com>, Ajay Kaher
	<ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	<linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <jailhouse-dev@googlegroups.com>,
	<kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>, Rahul Bukte
	<rahul.bukte@sony.com>, Daniel Palmer <daniel.palmer@sony.com>, Tim Bird
	<tim.bird@sony.com>, <stable@vger.kernel.org>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-1-71c8f488a88b@sony.com>
 <0149c37d-7065-4c72-ab56-4cea1a6c15d0@intel.com>
 <aYMOqXTYMJ_IlEFA@JPC00244420>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aYMOqXTYMJ_IlEFA@JPC00244420>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:a03:331::9) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|DS0PR11MB8163:EE_
X-MS-Office365-Filtering-Correlation-Id: 8057de85-c57d-46e6-3aab-08de641eb22b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UHJJcld6MkRoZnpwMWsrRitmYi9pQ1VLRVVRaGJrVHhWNzY1dkdkSDNpTmVH?=
 =?utf-8?B?Z1ZPdzRFOVNobHdkWFd3ZHg1YjRneHdGSWlmMzhwVkh2dUJPMWxJM0NvVlhQ?=
 =?utf-8?B?UGozOWFyQnhuMmk3dmMvQXpBVXhPNVJQbVRtdnpKcGZVY1VHQnpEYlByckJU?=
 =?utf-8?B?c3ZFYVVIZFhjcXlJb05iSk8zcEZJWE1tQ0hFWkgrWjJuSndKeVp1Q3dGTCs3?=
 =?utf-8?B?Y2l4ZmdWZWIrOTE4NnJrYWc0R1VrWWlqR25NbjRnR2xCT0RYeThLdVVxemo4?=
 =?utf-8?B?M2o2R2RNNXlwK2Q0ajdVQnIxak9yanZVWitUeFl0RWhUZFdXaWNzamlkenVH?=
 =?utf-8?B?MHptcEJDYnlneXFTaExiTFg0ZXZKMGlEckhGQlJXN3BRUDVmN0VGUFBuVUkw?=
 =?utf-8?B?QUxDSWZ6bHpDd2grR0NiOUtMcGxWNmY3NWFqb2ZlYW5ZVDdvUWRpLzIzMnl5?=
 =?utf-8?B?YTZFWDR2cXNsUklRNnA2SytSYnVCbGphMDhjUHhCREllM3RwZUZHMDk5MnFp?=
 =?utf-8?B?MHZCa0ZSRTFrd2xTTDd6dzFqSW5iMk95YUdYb3pkTG5wdjVud0JwSXUyMTBP?=
 =?utf-8?B?N1BKTHI0dVVmcjY5ejI3QjZocDdmUk41amcwV1N5YTEweVkzOFVENWhzTzJu?=
 =?utf-8?B?aGJpdEJwb3MrS1pJYWxYM2I1WDI1YmVyTXhWeW0rd1ZGUHU2N21zUnUyL0I3?=
 =?utf-8?B?SG9SZHhBQUdUb0ViRUM0aEZUOUdYNUJhaFV4OXRVeGxXaWVpd1BYdU1vOWsw?=
 =?utf-8?B?cDZHck9nQmNWajU4bnFHRTgvTFYrY2xOVmY4NkNBK0s3a1NRbWw1OGRUMjNi?=
 =?utf-8?B?VC9hdkl3VHdvTlp5MURYSnJUSTYzU3hDNFE5SEpFTjJ3NUR0U2RBTjErakxM?=
 =?utf-8?B?a0R0eDlBVENXT3JDVW9RZ0x4M0JmZm1tSVFZb1owQ3c3QkhmRzFLNHBNb01t?=
 =?utf-8?B?U1kydDN2cEVrMVp1WUJuSXlyZ3N0TmxmYzM4KzFZUDFjV1duMElmZUx2NVlY?=
 =?utf-8?B?Q2FxTW9pY0RMZ3pMZ1RPMU8vY2RpV3ZTY1VVUzVTRzR0QUd3YzRFOGF4Y3Y3?=
 =?utf-8?B?dXg5NUFVczVmMmJvSlVocTVvakJSZkxMRkFockNrRHRveW5QSHo4Zkd5WHdY?=
 =?utf-8?B?RzBoblNNUk50a1NaQjNPck9DeXJEK20ydFZKdmo4RFhmUFRkaVZwS2JZMEVw?=
 =?utf-8?B?ckk3MThub2l2N1BYZmNxdW9oZ0t4ekQ1WGJZSmlyMkpRNUFXQTV3RWowQ0VV?=
 =?utf-8?B?akpDcktKRmdwbGIveW4vQWtJSDMyaU1NZW44TTdVUFpLYjJpaCtydndrcGdq?=
 =?utf-8?B?YitVajM0NXZJR1UzbVUyVDAvOHhKaVFyWHllczNoZkRvbkYrc3htamxXU0sx?=
 =?utf-8?B?eDVVUGtTNEcvbWVtY29hY2R0MkxJYXhINDM2cG1ETXZObXloZVVTY0xPK1Fv?=
 =?utf-8?B?WUI1WkswUUxUZXJmelo4RU1sVFlaMWhVbWVuMnl2ckU5dGtPU2xOV0xHazhJ?=
 =?utf-8?B?SGxORTZPdERZL1dmRGUrL0RUOERrRG5HeGF2bllQWkdEOE1hSU5vd2pBdkJy?=
 =?utf-8?B?UVJSN21PTzVpaWVGTkZ5S2Fva2FkTURmL2hXSjNTZFNWdW8xS1hlb0FLQ3NK?=
 =?utf-8?B?Z080YW9YcGRBWFNqaGpxekk2eTB2SGgxR3ZBZWlLZkNKK2xEYXFjSzdhMGpI?=
 =?utf-8?B?c0xQc2U3TWxxMC9ITmJPelU5bUVFVG1zNWhTcnNOOXFqS1A0R3pYQTVOMkZK?=
 =?utf-8?B?dXlCTUV1YVlaeDZsdWlzTHkrUlBOVFBKZHZmbVRjS0FQSy9iUTNzTUN2ek5a?=
 =?utf-8?B?N2dUbmFFTG5ZQ0EwTzgwTDc2cXFXeUd5endRcUxyMzB4ZVZ1Z0M2M3pFdVVK?=
 =?utf-8?B?NXBkcGNiVkRDZjBpT0RNQlcvUUxaR2xGN2hCWnk3b1RIV3N4dWZ1SEpzT1ZK?=
 =?utf-8?B?cC93TFpsalpoQTR1MWQwV1d0UHNSa2R6M0NoTjdpMFNCekhVbFVlZzMvQWxB?=
 =?utf-8?B?VHVpWWQ5Z0N6b0lxa0VjSDJabEcrVTV2c1hSYWsydmh1L0NjSXpHNDE1Vi9L?=
 =?utf-8?B?dmNBNVJFT2RneHBJVUplSXFlWnNsVkdzZHFCbFZaUFEyY3Btd0Q3QUx3VGVO?=
 =?utf-8?Q?c0QE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVdERVBpWFlabWZ0dzB5Mmt2TzVhNkQwN0Y0Ym01SHdFOC93WTlIeEJuK2Z0?=
 =?utf-8?B?SnFPWnlINjNMTzhoRUN4SVNML3ROSS9LUG54WlNGb2dBcWdpRTlDemZuT0dM?=
 =?utf-8?B?bEQrV2NMYWEzQXgxSHh2NmFDczFYOHJmVzdXVGR6c1o4TkhMbUZmZzd1VWs4?=
 =?utf-8?B?VlNzTWpobFZOTHdDS0xlYjNSeUk1U3F5dXFWNk93RnA1TTZrcmN4ZkoxY0x5?=
 =?utf-8?B?RVYydzIvUmI3Z1dDSFJwTjJwVUJlL0NRV3BqTE5ubyt1YkZrL0gyVGcwSlE5?=
 =?utf-8?B?ZUFmbWRqbUV0M3NUdHNMWGtwSFBHWFM2eDM1Tnl0NmIyMEZKRXdRUit3MjN6?=
 =?utf-8?B?NForbTRjNlRmUmdYRyszUFRVR3o4bTNHWmxqRVM3QzlRdmt5T21GbmpiaVF3?=
 =?utf-8?B?cnI4TlYzdDVCN3V4c3ZldVhNZ0c5eXZkQVNwTGNRNG5HYVk0NWE3R1RFZGFO?=
 =?utf-8?B?b2RxT1lyZkRjY0FtNFNLcHpQQXNsTmxqM3ByWDY2ZDllZzZnWkllWlJoNzR6?=
 =?utf-8?B?K2pyeFpUK25hbVVBZEJ5ZzFIVlZBK2VGVCtLVHhjMFI4Uyt1MlpBS29XN3pB?=
 =?utf-8?B?N1FEckpmbko1TVFCNk41aHRWVTFIWFV5UVBTNWtLTDRvUUNMQnpNamQxTkhs?=
 =?utf-8?B?QWE5RkFscDkyQWVqSjRwV0UrcHpzRDg3aUN1L09DZGdvWEw3UjhQVnhxVDhh?=
 =?utf-8?B?WDNTUVAzdGptNGJRRWNadGorczAxWUZxeFhiaWZaOFZGN1Q2NGlFMk5WMVBF?=
 =?utf-8?B?REJEcGw4TXJUcTgwbG5VdUlJZk1YNThzN1Z2MlVVWCt0cmpoMjRhVVJMTE5u?=
 =?utf-8?B?Z2xPOHJ6cENYK1pEL0tzekU1bnhlRVBvMjAwT1Y4NzhYN2JJazg5YytPVURN?=
 =?utf-8?B?TWNDeCsrUnRabjM0V0JVSjV6Y3I2Zlg3Yzl2cEdlQlNEZS9MRkVVQkdVbUxC?=
 =?utf-8?B?eDFrWGlWcmY3WHdIeXV1SmJuYVA3RC9XSExMQlVuVkNVQUpldngyR3pvV3Rt?=
 =?utf-8?B?NHUwWU5GNWc5ZFZCdGwrWTlwa3VlMW8wK3Z2alhKc3lpRUVSSWoxZVg1bWRW?=
 =?utf-8?B?TFJHN0JLWGg2VFAySFRIMnhiU01FSi84eDVTY05qWnY2cGxybzlXTEVOeFlz?=
 =?utf-8?B?SDFDNGNDSHdPTktuZGZYVG9tSDVZa2NyU1pCRU94Q2tIY0c3MVQ5MEJLTGI0?=
 =?utf-8?B?K1I3RDlXVnhwTEhoU1lJZTlIVTR2YUJBbnRqMEt0NGU5eFZDbWRlcFJsWXN1?=
 =?utf-8?B?Y2t3MEM1TmVPdnYwbnZBQXVUSHUwYnZFS1ZRYVdnemYvT1VYM3diMXYzU053?=
 =?utf-8?B?N3VnQVFDQmxETFh5ZUxkVlhoVkFTQ2F6cjM1VVd4YWdVZmFLSFdCdUg2R1R4?=
 =?utf-8?B?TWJyT1YwOEttZEtDdUZYOXhYRTNKVjFLbU5OYUN3ZnRaUWFTKzZVajNrTFJy?=
 =?utf-8?B?czlpOERyRG9TcWc3dnVtVUJwOGNSLzREMkNZQXhyY0xIQTZhVTFka3NYMDg0?=
 =?utf-8?B?dnNmQmZHeGJkWUZHNk51dXJRRldzMTkwWCtMQWNRYWloV3hjZ3lXbHk4UWo4?=
 =?utf-8?B?cHVlVnlEcitRc2VSVE1Ha0lRR0diK0llZSsyb1NzdzFHOFA0ZVh4emJEckFJ?=
 =?utf-8?B?dGMzVkQ5c0toOWNlRzBrcWV4a0RGUjZ0eFhYdW1mK3M4cFhVazJSUWlUVHZD?=
 =?utf-8?B?b3JJaGlNeXNNcit6cHlZaTVRQ0F4eWJUWTdXYlFWbjU4UGU4Rmp5S2FkalJj?=
 =?utf-8?B?b2VKWFkxZjNSRDdkSTNEME1IV3lGZnRISjlNTUpsV2tmZmVLWUtDZklHajgw?=
 =?utf-8?B?dCtUYWFsdVgvT2s5L2hUaFZyUGVwTjJoOEFLaHNzWmFleC9kWVM2Ri9HdHIy?=
 =?utf-8?B?QW82UTMzVmZFRzhoZzZBL0laZFM2bzRlZzBZWjQwSzV0ZUx3S3ZoMmUwY3R5?=
 =?utf-8?B?dDF4bjBkRXZ5d0lqM3paWTBmbXp3dy9oMGo4Ujk3NEl0WlFwNW9CRGdzT09H?=
 =?utf-8?B?SVBMYnFEbTdacUF4dVNFcmtENUJuNUhZRFZobkJ4UWw2dWMvRXMxN3dURzhZ?=
 =?utf-8?B?R3Z3TkRpN0s4enNSRDlaM3d2STBjQVNWRTZSekhOa3NCZmVYMzZrSDJ1RFRZ?=
 =?utf-8?B?T01nd1ZSN2lrZE42dk9zaUUwQnBCNlN4UnVmNG5Wa1BGbHNSZjVxRi9zZklL?=
 =?utf-8?B?QndIRkV3TkZTOWNibEF3QjZWTTZwVFlzbHlMVHY2UWxPd1FXVlpiSW1lVWVt?=
 =?utf-8?B?eTlncFhOejVOc3lYTEV5Z1RuN3ZQQmc3cmZLeVk4emlrbTJWczBJRHU2Lzdm?=
 =?utf-8?B?eUdJRjZqYVZEaGVxRUMxREhQUDBGeUNBQzJFOGNaa0ZqbHFCRHZyZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8057de85-c57d-46e6-3aab-08de641eb22b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 18:53:33.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bn8zWyXjfURZZWpZ8USJ9E9fy+x9qqoK6hkqYi0fqroGsjUFnlJdA2VuDyDV2paTFNxcyZJZDYggHvdx+jLsrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8163
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70264-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sohil.mehta@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 54051EBC85
X-Rspamd-Action: no action

On 2/4/2026 1:17 AM, Shashank Balaji wrote:

> __x2apic_disable disables x2apic only if boot_cpu_has(X86_FEATURE_APIC)
> and x2apic is already enabled. 

I meant the X86_FEATURE_X2APIC and not X86_FEATURE_APIC. But, thinking
about it more, checking that the CPU is really in X2APIC mode by reading
the MSR is good enough.

> x2apic_enabled also does the same checks,
> the only difference being, it uses rdmsrq_safe instead of just rdmsrq,
> which is what __x2apic_disable uses. The safe version is because of
> Boris' suggestion [1]. If that's applicable here as well, then rdmsrq in
> __x2apic_disable should be changed to rdmsrq_safe.

I don't know if there is a strong justification for changing to
rdmsrq_safe() over here. Also, that would be beyond the scope of this
patch. In general, it's better to avoid such changes unless an actual
issue pops up.

> 
>> I considered if an error message should be printed along with this. But,
>> I am not sure if it can really be called a firmware issue. It's probably
>> just that newer CPUs might have started defaulting to x2apic on.
>>
>> Can you specify what platform you are encountering this?
> 
> 
> I'm not sure it's the CPU defaulting to x2apic on. As per Section
> 12.12.5.1 of the Intel SDM:
> 
> 	On coming out of reset, the local APIC unit is enabled and is in
> 	the xAPIC mode: IA32_APIC_BASE[EN]=1 and IA32_APIC_BASE[EXTD]=0.
> 
> So, the CPU should be turning on in xapic mode. In fact, when x2apic is
> disabled in the firmware, this problem doesn't happen.
> 

It's a bit odd then that the firmware chooses to enable x2apic without
the OS requesting it.

Linux maintains a concept of X2APIC_ON_LOCKED in x2apic_state which is
based on the hardware preference to keep the apic in X2APIC mode.

When you have x2apic enabled in firmware, but the system is in XAPIC
mode, can you read the values in MSR_IA32_ARCH_CAPABILITIES and
MSR_IA32_XAPIC_DISABLE_STATUS?

XAPIC shouldn't be disabled because you are running in that mode. But,
it would be good to confirm.


> Either way, a pr_warn maybe helpful. How about "x2apic re-enabled by the
> firmware during resume. Disabling\n"?

I mainly want to make sure the firmware is really at fault before we add
such a print. But it seems likely now that the firmware messed up.



