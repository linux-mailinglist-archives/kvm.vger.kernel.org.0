Return-Path: <kvm+bounces-46407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C04AB605A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 03:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AA5A3BAD37
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 01:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0259E149C41;
	Wed, 14 May 2025 01:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GiipBVgg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633B343146;
	Wed, 14 May 2025 01:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747185152; cv=fail; b=bKBSmOLhp1czoUSlmlerc3reDMjzGpZkxtvDqo5zIQCt61x4AxRb/+zWuVdn7w34r4HDT/8TUr55zZiJg+stK5hBa1tJ6/3LTVusPgAtmzQDh9KHRlWzArRmXQzOR7fw5StY80035hebojOfIiPMFDqxJJVpU13USwSn2QvpP34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747185152; c=relaxed/simple;
	bh=GUdjHxBgJvaVQ1rGI+bhTigcpMYTQuhra1ucmLHmufk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tbc19AQXWcjOAS8DAir9vN4vbGKc+WJcXIywd3ya7vlluV/upWbA0/kVl8AZhrH9nG7901EB/OOeSL4xEC0q1eUJTeGFl2g2PkNRDaBG4XmYfr1DccTMxh95BXfKbmWVYBg4Qa9QloBYNY4RfNQdxPJaZ183aQB0cm8vdaYfueM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GiipBVgg; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747185150; x=1778721150;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GUdjHxBgJvaVQ1rGI+bhTigcpMYTQuhra1ucmLHmufk=;
  b=GiipBVgg61F1oRsRKkdV8NB9nUGnYm8afOgyT60HiT0fP2HYsC5nNAWN
   buT/aSXnHcbeBv53ANrW0nIa0vBDFHdLGIukFzgwvZZ/bZIPNYKfEcg8D
   AYVGcKSBQzHnIlex7YkZGHSYo2RDTvWOqGm2OCBbnmiQ0dQNuPZY57I2W
   epa8MxrpCqj6OrLkm+nBOyTQW2XSYgSrL2elWB6Lsk5u3IjSL02YxUqFf
   pSCTlddzE1m2XA2jWJZZ3qe9LfH7KfMBOKMblPNa8YF2yIhs/G36KGr+A
   8WC98pV74eSGh+YHcoQUxyWz5KzTTTzyC6ppdXApS3T5dhWjYVj0Ytcc6
   Q==;
X-CSE-ConnectionGUID: RG15HJHgRfyPed5o2qwzlg==
X-CSE-MsgGUID: ZR2H/a/bS5+7uRYSJ/Vb0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49208007"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49208007"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:12:29 -0700
X-CSE-ConnectionGUID: wk2LfIWxRmWrM6hUeyyl1g==
X-CSE-MsgGUID: VQ8GZf12TkyKegKdOu8piQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142639450"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 18:12:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 18:12:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 18:12:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 18:12:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qoH9bHSbk0BONqSbQqHiOmrnbiA8GNh8NAcZS9PD0hrPWgI8VxuMlyl/ASAfkpMUPT5q85CzBqfOdVRynWBy6fsjuiWKQgA7laKZaPUAs/7ThkWc152YnKtKW8aIqLAJj3HeZM2r1LJ+UsuG7iTCybL+mbLRm4kxePQBONF/uygD6+VvBZGn3RUpeGiegqpjQlxuLKAWnXLnVkbXKwG+eRF/+YxIaPZ42fBNR7zZbISpXiUXKlSgFvHDq+39SjBVkc2N2HuyOrJT+livE8FskYlyLigtZUt8SSxYfNRg3GhnY6mKHuGcjaacrbt8tEwpr6GMxFdBHfJUZVatX6LGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3kZ6eqQ09gKzWUZyYYpEy+klteJ+iBOVM/3NZ1jQ+U=;
 b=UF5epjRNk2rpCdJXgG3eLxm/DNGjp2FQfC3/evqPGaEkMjl5vObftrzzOxutRV7T9cAPZZInVfyVn73q5nMkBMqozrvhPU/qN5WDoz/yG+9RJ6mwxU5L1dT6AEOfJSro44JlaUhl1kNFLBQBzIKyjfWTfou3YIGGXj6G7FPBiSuvs6PPjkrl1RT8poS/vY8HB4Of/ALwUSK7B3LBMTzmdnzFH0bShnEOJFmj1/M3mpcw8NcSRKzqDT5Als0afPvZPl/mfzry6dIUdNrF1JiYhXpBkrHgCDDjIXlOrgqDhq0BjfJ23iC1OWSrheIb+vzlDTgjp8TAFHosICJy7GAlzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by PH0PR11MB5192.namprd11.prod.outlook.com (2603:10b6:510:3b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 14 May
 2025 01:11:44 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 01:11:44 +0000
Message-ID: <6a7f0639-78fc-4721-8d84-6224c83c07d2@intel.com>
Date: Wed, 14 May 2025 13:11:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 11/12] KVM: TDX: Reclaim PAMT memory
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>
CC: <rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<yan.y.zhao@intel.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-12-kirill.shutemov@linux.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20250502130828.4071412-12-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To BYAPR11MB3303.namprd11.prod.outlook.com
 (2603:10b6:a03:18::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3303:EE_|PH0PR11MB5192:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f824a5-3ad3-4307-3354-08dd92844aa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2VNUGdRNWxja1VwUHBqK2ZEdzg0d2puZ1gzSTZsTENNMCtQZC8zV0E3czFD?=
 =?utf-8?B?YjhFTENyRk9mUEQvQ1pjYmZxYnFFQVhYOWV2NVl0YWlOaDdxVkI5M21DVWFt?=
 =?utf-8?B?VzVUSElBZ1dCUTlua2hZWjNFRUlyTTVQS1hXME0vZVk1RVlvT3FGQ3ZMMTNu?=
 =?utf-8?B?NExPdmRld3orMzR5dFNuYkJNLzJZSGZ3cHRFZ01zN3VhVW54WTdVT21ZZDIv?=
 =?utf-8?B?RCswdmFRdjlNRU8yR1UxWjZKK2lCRHhMUDBkeDA3bTB6bS9tWXJwbjNNZldY?=
 =?utf-8?B?QmE4bUxudWVxV2lUREpUZmZWemhDUGF4dmxFbmxnWFRhRDJaak51ZWp2cUJP?=
 =?utf-8?B?TjNBMVA3NFM0STBOQituWUVpTHJWNGhXRUIrMUlLNXNWTFJXRHF6Z2IwV0tY?=
 =?utf-8?B?bHBlZmt4OXl2N0dtYkRoeGYwM2U0OUwvbjJWdXBRQURiOFlBTmlrUkRaUjhZ?=
 =?utf-8?B?Q1pkNHlJNE9LQUZZcnRBTjc0TzV4L3l1ZzBOcVZIeVpRMHpER2k0Rk9TUUR1?=
 =?utf-8?B?Nmk2b20zU1BOanY4SDFPZkVHOGlQRk0xU3NZY1kxU0Flci9IYTVqVERxTXky?=
 =?utf-8?B?RjVkWE44T3BPaSthd1M5bHovbExyTW45TnIyYUNsT2RVZkFqNWhJWmhSazFI?=
 =?utf-8?B?dXVTUVU4MTFKbW0xdmh5ZDAwQ0VWQWg0YmM5QTBmNDlDcXVyYkM0emFIdW4v?=
 =?utf-8?B?S1BjaDVldlBqNC80KzhzeDh2OUNncXZ6cW5qYVlLcU9HV0hISlhQdkpuajlX?=
 =?utf-8?B?RVhpWSs3bFczNkJ0RjdGbEhaU1hjMVFzc2hBckNoSk1QakVkNUFvVk5RVUNL?=
 =?utf-8?B?K2RTemVOSUpmVW5lVmJ3OGEzMmpuWG9zdGRDdzE3SnBXUytaQU4zSk5SK3Rk?=
 =?utf-8?B?UXllYjZoa0ZxenlUQ3lGTTFqbmtjSEE2Unl3WDNjUDVyRmI0ejRGRE9UV3dL?=
 =?utf-8?B?ajFZNlBtWUJ2M2QrbHJIMmlzaUV6ekZ6R1RlTzlJMFdSNWpOWWRvRzlvcmFa?=
 =?utf-8?B?ell4VUg4Ulh2VW1SckhJeFREbHhMWVJRRGZVelBPbndUVTN4cGp3U1BBQmhB?=
 =?utf-8?B?UW9PVzFkMTFZUDdhdXd0Z1ZBc2d4OWJGR3RlZjQwMzc5REdnVy82NTlLS2JC?=
 =?utf-8?B?Vmt3amYwZEQ1YlBZQXI2MEtzR2tDTlYwWllGSDQxaHZaL09zVEtKVEp5Vm1j?=
 =?utf-8?B?K2J0d2x0dDZOSHA0VFRQSWt1cE1EdGtlNUZGRFhnQTlOVHN0U01iVVIwdU9z?=
 =?utf-8?B?OTBIK3ZqdWRiV0tSQjEveUp5L1dySU5QcnpjTklORG8xcHAxRHROa0dGamFi?=
 =?utf-8?B?cEh0ZHdvWjZpTm15V0ErTzk2akEwMzRCRGxycElpbCtJTEc1bXdoUksvaGVa?=
 =?utf-8?B?Y050MDlka3Y3cEZaNSt5MGo1ekZ6a0QwK0dsNEpYMmw5RkxkMnhmcEhwbUZF?=
 =?utf-8?B?V0FVMVJ1Vmg4OGZNTlRseS9wSWJyUHNVVjNrQVFDZVhtOEtLRjdZeG1xMndT?=
 =?utf-8?B?ZkFLK0h6ZW0zNERjazV6OTVESzFMNGxSWW5HbFpuVjgrSUJoc05BbkJ2M1JF?=
 =?utf-8?B?c0VTcWwzOU8yeUp3ZzYxc3JveHE1RDlHVTlVQkg3czR2clZUeFQwMlRYZnpE?=
 =?utf-8?B?a0ZKOVMrRFlLaVllN0o0S1k1MXBWWUdIWnJScTJrOHArTXd6QkVuT1JpWUxZ?=
 =?utf-8?B?aDRGNjErUVpGOUQxTWUrYSs4UEkxdGhIL1ZQTk1rRWNadWdvOVNOcGxSNy9H?=
 =?utf-8?B?Tk1HODl2WDF6QytmcXJMSWQycHNMMGxhd056QUFwWjd3V3o4ZWJvMGxOcHNH?=
 =?utf-8?B?c3h6UHNnVGwzRVdLN0hVZVZMVlJOK1RjcVk3T1RMVlFTaDNuVktacnBhdlhI?=
 =?utf-8?B?T0o0bVZHT2M2RFFOZnRjb0VOSVk0aHpUNjA3cnBXdGJVaFV0dURLVU55VXZO?=
 =?utf-8?Q?C8I29076q4A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmJZRGdxM1RGeklaS0djRk8zNnFya0Y4R09abGFaRnpwdXNiTzM0QmQzZkNw?=
 =?utf-8?B?TzVWUnNETFVJS2dFMEVwVC80ZlVDc3IzRm9wcGNSd3l5dmNxUkV2SDNULytC?=
 =?utf-8?B?dmo1TWJzV3BhTjMraWJnaWZNdytMM05Rc3lpL29GSFNtVGhNTStwa3JvV05h?=
 =?utf-8?B?ZE1pdWc1YklkcVUvRmN0SlVxa01HckVPY0czVUp2d0pyeEdab2cvb2k3aW13?=
 =?utf-8?B?WlBvWmFIQll2RklEYTJlak5aQjd6K2lxT3JhcjUva0RiUEZQVGRsNDJlS1lU?=
 =?utf-8?B?a1lOMHhBSWZ5Y1pHa1B6OXZnWWF1SVZIbW9jNldLQXVHVXdRT3B2STExU0NR?=
 =?utf-8?B?RTVuMG1wVFViSk56clFPS25kOExVMjB5THk0cGJoWVYrWHFyRVdvZG00K0pB?=
 =?utf-8?B?VXpuZG1vOEtRNnVEa1dKa0VtSEMwNGRTRVBsNGs0aWJlQnYyQW5XcnpLaWly?=
 =?utf-8?B?TlB4ZWREQllta2VkVVMrc0tDSkdOWmwrZk5uUlpOdzVpTkJWbHRCbUhTWThu?=
 =?utf-8?B?TXlzMXF4bTFDOGgyK250OGlYMDJraGZNUzlmYStOODJTaGw5U1JCblNUeldr?=
 =?utf-8?B?Nkw5aEJoQktBckloalNRQTdydmpEQ2x6TXBJZEFJVjZlYWtiM01SOUR1ZitN?=
 =?utf-8?B?dUlPc0VxaVZSeXdia0tqMUlqSTRJRkpGVjNrQmp5UVVleHN4aGtXT3hjdkE4?=
 =?utf-8?B?UENCbVBDdEs4WG5KQmRlM1ZNLzZFQTVJQWlZM3NKLzUxUm1MMjBjeXlPNkZx?=
 =?utf-8?B?Nk5xWDhHanpJZ3JTZUs0UHREWVZScVNRNlNNekUrRUlORi9oS3BpSEg2YVpX?=
 =?utf-8?B?Z29ENytqUUR5UjJSZnc3UEEwMlNoNnhaWFk0OVhYT1FHdmZCUmd5VnBMbnc5?=
 =?utf-8?B?WUcvQXZiN1BSc3NCNWZ3UlRyaGM3MFpXYXIxeWxDOWlZTndpWlNQbG9pR21K?=
 =?utf-8?B?cmlVN0lQUkhCcG9UQ1M3Y201cHdCU3pKQ1lhcDk5N2hRdXVveVd0VDZZcUE0?=
 =?utf-8?B?b09tRFFHK0NJMkcveFd3L1MxOTdyTzZhTWR0UTlJRGxJMTR4T0tDSjJaREZu?=
 =?utf-8?B?ZkFEbWFyZ09EZjJXbjVuaitSMjZJQnlZNmQ4bEs0Zi9JYjMzMXVrUkZyckg4?=
 =?utf-8?B?L3FNcDhoSHZkdEFTR1dzeVdNREtBNzJLZDgrTUc4Y0tzSFJPVVF6bTc1R1hl?=
 =?utf-8?B?RENxMzlVbTI2VWlsUUQ3clpNNFZwK2tNMGhMY3V2MzRKcFNGZnpPU2tuSWw3?=
 =?utf-8?B?c3g3V3lBaW4rdDJrV3ZuemkvVllFeEFJTjBMaWpOOXM0aE5DNTNrVFVqSlBD?=
 =?utf-8?B?b2JZc0kvOUQycGZwb1VFRjFkVEdYN29nUUw2K0g0UGJjQWJqb0dMSUU3WmNM?=
 =?utf-8?B?c01sQ3p1S3lLMjhqZ1VQZy9JenlGM3J1VmM4SWJrMGo4N3BleTRvM1dxdk1P?=
 =?utf-8?B?WThsb2tTVStsa1BGK1V4WnlCenA2MkFHdmtGK2hWUTFHNjR1WVNFWFN3SGJp?=
 =?utf-8?B?SDRqM3ZtOVBUVm1UZXJZcm4zNWFuYm9rYjJMZ283Z21PL3pOT2ZyM09xeFEy?=
 =?utf-8?B?K3RBTDhZdzNXMmNxYitPaHIzZ3VDOThkNDNjVnNMTTVYTzNHcC9uMkZXTVd0?=
 =?utf-8?B?SThocFN6TzJISkFqSGZ0K00vRGx1VXhWVlhQcm9kVTBFUVhza3RQMlU5WDZJ?=
 =?utf-8?B?dnFvZUlEbGlhbVRrUGdKWVB6c3F3cmNoYjJ0TmNJam9iY3V4SjVMWFR6czEw?=
 =?utf-8?B?Z0NONzNRdi8xQUkzRUxEcE56VTF6aUZmMEpnQ1BxTWxwYTAyUzZtdDZlMnNz?=
 =?utf-8?B?b3JDSzBNNFdBTFdaZkN2eUJyWjhrWGNnNlNuVS9ralRINzJ6Z2lkd2prZlBj?=
 =?utf-8?B?LzZ1eW9rVVMzTDU4RythYXhvZ3BqcjZpVmY1M1Y2KzgzMlZKeW1UWHFjR0FN?=
 =?utf-8?B?R1hKZGdOR2RjaGYwWFlXdjBUVkd6MzhvaDY0c1VmVENIUU1KdThsTmdKcG5B?=
 =?utf-8?B?VlpnWUJycFhWWlRhaGJDMGlkQ05jMU5KNmtHdTlsY0kxUFMxZThQOHdUOWp2?=
 =?utf-8?B?cklHSVk5c3I1dkp3NWQ1WkExVUdqeWlTc1FuUDJrbkhRLzZQbE9ZQzhrUkxH?=
 =?utf-8?Q?8RJUBpbS0gt5S0Aq4aLWv5jGJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f824a5-3ad3-4307-3354-08dd92844aa1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 01:11:44.3984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JDNyjQTFZ8Nq7zrWKTiCVNlakS/Yldj9ydc35K/V8D5Q4cWM1DcWUGaUZVYSyI+6Lts1vKrgw6cVtu11o/naw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5192
X-OriginatorOrg: intel.com



On 3/05/2025 1:08 am, Kirill A. Shutemov wrote:
> The PAMT memory holds metadata for TDX-protected memory. With Dynamic
> PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
> with a few pages that cover 2M of host physical memory.
> 
> PAMT memory can be reclaimed when the last user is gone. It can happen
> in a few code paths:
> 
> - On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
>    tdx_reclaim_page().
> 
> - On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().
> 
> - In tdx_sept_zap_private_spte() for pages that were in the queue to be
>    added with TDH.MEM.PAGE.ADD, but it never happened due to an error.
> 
> Add tdx_pamt_put() in these code paths.

IMHO, instead of explicitly hooking tdx_pamt_put() to various places, we 
should just do tdx_free_page() for the pages that were allocated by 
tdx_alloc_page() (i.e., control pages, SEPT pages).

That means, IMHO, we should do PAMT allocation/free when we actually 
*allocate* and *free* the target TDX private page(s).  I.e., we should:

- For TDX private pages with normal kernel allocation (control pages, 
SEPT pages etc), we use tdx_alloc_page() and tdx_free_page().
- For TDX private pages in page cache, i.e., guest_memfd, since we 
cannot use tdx_{alloc|free}_page(), we hook guest_memfd code to call 
tdx_pamt_{get|put}().

(I wish there's a way to unify the above two as well, but I don't have a 
simple way to do that.)

I believe this can help simplifying the code.

So, ...

> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0f06ae7ff6b9..352f7b41f611 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -487,8 +487,11 @@ static int tdx_reclaim_page(struct page *page)
>   	int r;
>   
>   	r = __tdx_reclaim_page(page);
> -	if (!r)
> +	if (!r) {
>   		tdx_clear_page(page);
> +		tdx_pamt_put(page);
> +	}
> +
>   	return r;
>   }
>   

... I think this change should be removed, and ...

[...]

> +	tdx_pamt_put(kvm_tdx->td.tdr_page);
>   
>   	__free_page(kvm_tdx->td.tdr_page);

... The above two should be just:

	tdx_free_page(kvm_tdx->td.tdr_page);

and ...

>   	kvm_tdx->td.tdr_page = NULL;
> @@ -1768,6 +1772,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   		return -EIO;
>   	}
>   	tdx_clear_page(page);
> +	tdx_pamt_put(page);
>   	tdx_unpin(kvm, page);
>   	return 0;
>   }
> @@ -1848,6 +1853,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
>   	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
>   		atomic64_dec(&kvm_tdx->nr_premapped);
> +		tdx_pamt_put(page);
>   		tdx_unpin(kvm, page);
>   		return 0;
>   	}
... the above should be removed too.

For PAMT associated with sp->external_spt, we can call tdx_pamt_put() 
when we free sp->external_spt.

For PAMT associated with TDX memory in guest_memfd, we can have a 
guest_memfd specific a_ops->folio_invalidate() in which we can have a 
hook opposite to kvm_gmem_prepare_folio() to do tdx_pamt_put().  That 
should cover all the cases, right?

Or anything I missed?



