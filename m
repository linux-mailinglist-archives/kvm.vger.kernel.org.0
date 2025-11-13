Return-Path: <kvm+bounces-63088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA5FC5A849
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 279D23ABD6D
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24494328265;
	Thu, 13 Nov 2025 23:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hr0t7mZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F632E093A;
	Thu, 13 Nov 2025 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076042; cv=fail; b=eUT6ebjU3Gt7lsJqCoXScUiXFxMOtaeIk8Ql1aaTFcZM7kmt7UssuIvCzqrucxWAmajDEcHQRHRjUKcMutLnPJ4SOP9QfBYHc/9J39Wq/SNIeG7GUAXE5YhRRqi15mrfxzVwNJdng5WnI2bpOi1urfa1CUZ/OGQJ/OlxbYx8Ktc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076042; c=relaxed/simple;
	bh=8/75AtqhtYQn9Hy0jvBRVhsODSxdBvV0Gjf2KY8xqxs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LnRF1OFeX3gZc8RHhhsyJr0XyLdMoTvrc1X0bb7DcKg7D2nGMqJwK9ejemjWkJSDgnasaANTQ2bLyvHu62hZuDZXF7NmH0MtfbI3e5TiqKb9BonvJPnYl5ilgvjciUx+prkqP0+tAoHHVJRATp6Lb/EA4CanxzUrny9QDYpDm+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hr0t7mZ5; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076041; x=1794612041;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8/75AtqhtYQn9Hy0jvBRVhsODSxdBvV0Gjf2KY8xqxs=;
  b=Hr0t7mZ5sfaOzUTWnb6O9WgKXXzLeujEdgWeDWhwu9sYdhP1Y1WYnbju
   n4bMCKyH026xemLBPP9figKOnXdGUnQ0wMTdqUJ7Guq9SEj0H5Ifb8OJp
   +pA5ugSLgjHGwFhEh8mf8pM5lGkqgtdmMAWVVHSUmTTKl4llLiVg/J7d8
   A67db1jIlCYRqUI/jwfWUC9PQ7xzc/E5r7qTLmhW2pai7Cie/SsB8FiF9
   ZsEd+YWbInPk2YAdB1byRsYnKEeURPNJcKuiR3k5+a7sYCSuPCF6wOMM4
   xUwllmY5/z0DaLf5YL7IwRZ4g1Rr/Xx45u5IAYYb+013gcwVVfn0d6+K0
   w==;
X-CSE-ConnectionGUID: bFU01rGOSe2knfMVtekr8Q==
X-CSE-MsgGUID: dzxUXCxJTIiiPez5Msdqsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65200218"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="65200218"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:20:40 -0800
X-CSE-ConnectionGUID: SM47jmejRXOVaREQk93kwQ==
X-CSE-MsgGUID: cKaFNxZfRmKE6WklI8F/Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="226956470"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:20:40 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:20:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:20:39 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:20:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNeMHY942C/5o8ZzcxWcddh2ExYakC8ImDi56/QU65VZMfFvurXDVRjW/fS15TyD2vqf1AfYbUoHvfpuZfykOE5rdtjm1TKTfqoV50JE1y7iGVdCS68CyFMIvlxIIBZ4Yl/X2m9J+tVNoSmN/AmdGakRbjpdV9pd2RnDwexAzgZA5tafIBKaVZdNHk9AkwnG/ZlA4xwxzzA16lLccOoAsetjWKauzt3nNSxSuou7D9rZHO3Yeou2vejqVMntBGOm9Rn+aej4M7XSG4AtZ+me8xJyPOAibEmFSJ36w+Q5/FpjCxqjr9SPhgeOZRbTB8u7muStT3XNf66CmAkKZBYMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44tMZRQ6Oxa+GqzTIaZKXMC5S4AoM7xu0KvVGpGBwKI=;
 b=ALURl+y8eIbjQ5Q6pFVuo/xuyy4xciAsCnNXi6y1nOwFdwm10/WY+A1xlEE5PG9tc6oTcExyVi+DkMwFjDygI+dofXgDwox0u/PifMS6I4vbboBo6mS3UczPg2v21/fwpyiRNrSEShs4xwN35Ya9JZowxdegzJGIpUZcGPAzi92vYoIDIfgTgN5qap6nv/z6zRV6igQtqKhWnDkvDc4DmgTRAIvxX/Gf16jivN2HwF8Ki2M0LGoiWJSyAs2beakJkgYmj9khtv9QgV48P3munB/491ktEizP1Q+KOpk8+cNTMQo4YxWKJH9SQFDaFYu+R/FjJfdAKv3CZB6rhKCWuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:20:37 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:20:37 +0000
Message-ID: <b76fe2d5-d50e-47e2-b9ba-3686316e1c76@intel.com>
Date: Thu, 13 Nov 2025 15:20:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com>
 <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::31) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8cfd81-aa67-4a99-84a3-08de230b40d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dXVDa2hVdWY2V1dCRERmOFFrblF2QmNrVndETUlSQVJINERFZHBqZGJKNFF1?=
 =?utf-8?B?c1diSnN1ZzRvalNKbjIzQnR4U0pjYVNHd1lGTDdkQlVrU21HVmd0K0pTcUZn?=
 =?utf-8?B?SUphQ2QwTWFtU3RPZm83UDdkTmZDa2ZQeE8wNGtZRU1GaWtGcEFYaTZRTjhr?=
 =?utf-8?B?TWMzZ25zeXNEblpSWHRYWWVaNmNVVWRlT2RJdHd0elpVQ0ZjZ1N4emJwUlRZ?=
 =?utf-8?B?OERsUnphOWRvSkRnMm1ETEgxbThqRUh6ZFZ5TitiODh6VkV1ci8zZGhNNko5?=
 =?utf-8?B?dlNGblRpdHZRVGpmRkFES2tTa1ZNY2RCU3hZYk5KT3hvWkd0UUZNNW9qdnFt?=
 =?utf-8?B?WGZPTURkRkdpdFZiL2xEWkFwUmFJeUxlYTRhRHU1RXBZT3psZUI4WjVqRXZq?=
 =?utf-8?B?Rkc2VVNNN1pCdGFHT3NvNUM4dXdRRDJIalY2NU5yT2VJNWJ2VkZDS0YyS3ls?=
 =?utf-8?B?RHJ6Mis2cGVvNjFtaTdqQXA3NHpUaEZQcHBsT2p3am45RVhFU2N5dUU1bTFZ?=
 =?utf-8?B?cFJCYktCam50UW1RaE5XNFU4bkhNRElvZWd1K3VlaFNLbWNZbUJINXlKdzJX?=
 =?utf-8?B?YXNvQ05BWlJHaVZNcWc1djFNcENwblJSb3VjbHdZZFpTTmE4eFRDMSt2cFZk?=
 =?utf-8?B?WmZLWVRZQTgzTUhMSlZnK1Y4MVJUUEZmWFFZS0pERFVpTDEvNGNJOGFqdmU1?=
 =?utf-8?B?L05kVS9sbmNuSzVOUisreFhUOE8zbFpKYWZVY25tQm1RQWY4MGlObCtYclJU?=
 =?utf-8?B?bTgrNGhreVY5SjJHV01XZTZGeW9wUitaRUtkSVF0VWVlWjliZ00yK0IranRY?=
 =?utf-8?B?R214TXE1NVhvZitpTmhuUW1ZUGE3Nnh4cnhaejQ5KzJYdCt1bjVpczVoUTF1?=
 =?utf-8?B?ZGo2clFBbmR0T0gwV0FoSDNjVFFVZmI4WXN3NEY2RG9ZOHByVndZZzc2RnpQ?=
 =?utf-8?B?cVZMdVZtdy9wREJJTHZMZ1BpU1IwdDdNMEVVbEpjMUlYUDhlWU1YK25YcE5V?=
 =?utf-8?B?UUdCS0Yra1Qwekp2NDV3UlNGcGtZZWVzWCtsT3l4UjYyOGF0SWZOWXArUElJ?=
 =?utf-8?B?QVBRQ3lwM0psRVV4OGIyOEV3TTBGZzAxOUJWUkFUUWkrWDcxVVhyYnpHVVEx?=
 =?utf-8?B?ZlJWVlRpTDBBTHZkT3NOZ0FQMHlFNU9TMi9TY3ZONFlCVlhkL2NTdGR5N3hG?=
 =?utf-8?B?WkZ6akViWnRScjJkVDlkL1hCVWNaUlpNN2x1emhYak9jZUUwdm0zQzV5WWc2?=
 =?utf-8?B?b3BNN2I2UjRvZFhUYU5hN0lpS01KdCtDK09uYi9qVGtLZmpTR0p4WFJpLzZ0?=
 =?utf-8?B?ZzNnMUQ3bHhIT1pZVjJtOU5hOUFjMGxZQXhaNjBUNFpJaXlGYmdaOVEyWFRE?=
 =?utf-8?B?SDVUUDZSK2RMSkViOFpwU2VlRUYxbjNzWXZoRk00dnhMeVF3L3cyK0NkQ1VL?=
 =?utf-8?B?T2YxNGMwM29ubVlubUJqUUpsU2RCSmdHc3Y1UUl2ZWVybUtoQkJ6Q1YzNzlm?=
 =?utf-8?B?NG5tYWlERFBUZm9HbGE2QzdyVmFmSVhXaGNZNlhiZG9JdkVnNTJxQ0R0NEJT?=
 =?utf-8?B?eWxTWHdJcnc0N3l3SWhucXlmUzRmTmVYODJKOW9TM2ZNNXhnOGpPeVJaTm1u?=
 =?utf-8?B?bnhDbml6YndFY3RhQjhwVlY3N3Y4V29zTGZNV0VUaldnQ0FBbDBiM0toY1BT?=
 =?utf-8?B?MUxxNmhyR1JhM213dXc0NmY1Yzg3empPakJRY3ZBVjVMK0krOTY0Qm5KRnFO?=
 =?utf-8?B?OTRCZzF6ZUc1YkJJQjBPVEx0dHBJcWNPcDBqbTNocWFjMnJjSENVMVVVeFJv?=
 =?utf-8?B?cERkS1FRRk9VcG5hYURPdDd5akV1Q3dWSm5XU0VyZEF1eUt2QVZWM0N4QXg3?=
 =?utf-8?B?alRTNjlqZGgzV1FVaDBWaGU5cldPYWdSQzF5ZlV3NC8veDE2VVlMakkxYUQr?=
 =?utf-8?Q?Abw3aGx+66chU0jJU7y0dHPidgUCUn/B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUI0bU0rRG9QdDFwbFBKMjc3bW1MWVJVMjlvYWZvb3BpaVMzc2FZWlZJZDZR?=
 =?utf-8?B?Q2Y1ZUJNZEV0U1BXcjlkWUo3UitwUU9sYjNyWlJ2dllIWTcrWEl1VHQ2SU0y?=
 =?utf-8?B?cFFyR3VMeWdFcytPR1hkUDZkUys4YndaYmJyRTFTU0M2aDJ1ZU9SWSs1aDd2?=
 =?utf-8?B?VytxSFBGejhMYzFmYWxmdmZMRmdVQjUxRldZWmtqVGRySWlld2FxT2ZZaHNY?=
 =?utf-8?B?TzhMeUxkZWtvU1U0RlBzb3NGTm5JaFZnME1UWUxJVmdYVjRsYVFTMVFCVzRH?=
 =?utf-8?B?S3Z4dmpvL3JGUENnNFdxU1puSmd2OTBuTjVBOGlVWVVzcHlvOStPTkdNcy9N?=
 =?utf-8?B?OTFjdGZhUnM5ODl5QVBXSHRDU3BpM1NXaktXcDBRWjEraCtpNG0zNEZIN0Nl?=
 =?utf-8?B?QmZoUU1MSzI2WEU5bGJkeDVYT1dWUnVNMzg0ZFRwdzlDY2lJcXJhaFNHMXk3?=
 =?utf-8?B?bUdDY0JkVlg1a1N3d0JCY2V6WiszTmxXVFlZM3MyeXFabzNRS3pNdmNqOXgy?=
 =?utf-8?B?eEZZTTlXWFdTMjk0L0VYVnBod0hCcXF6L2ozMmtqMXlNblY4Q1lQVG5rVmFw?=
 =?utf-8?B?eHg3MVNaY3pEQUU4TmNKK2tjd0c3dEo2UmtLc2FvTVE5VThMNVRPQ2NiY2x1?=
 =?utf-8?B?bkVXQjRvTERQMUFYS1hJS0NoS25ReE5PVFY4d3A0S09UUE15M3U0MkNHWGtE?=
 =?utf-8?B?R2hwUTVOdEYvY3FLWjlqemh5R0NWU0xSVnMySm9hS0hvL1RhditYMHVyVmVi?=
 =?utf-8?B?UkNrMFV5aFEzeTdvM3Jkd2paaHRGL2ZNbTJWTWxXdUc1cE5CQm8wNkZpSzZy?=
 =?utf-8?B?cEp6SjdnODlqWStxL2pDRlFPSS9ndGhLV3NCci96ZU5BSWRKaU5DWGE4RDlk?=
 =?utf-8?B?UmpmYUZlUFpWMzllSUZLVUs1U1dMWWVtcmQxSnpQZDRibE5GT1c2dWFaa3pT?=
 =?utf-8?B?OFV5dVJxNkFyRFo3OUNPRHBhREQvTVN6T1NqamRoems2QTJvVTVuMW5Kdmxj?=
 =?utf-8?B?NFdWeVY1L2xaV1dQb0U4c3hUTFh0cFlZUGdMbUIvbEVaWmpISUxJNndTS3pk?=
 =?utf-8?B?clNKNVRGb2pRclp6TnBwRFVFcCtweHBabXpHMVZWVlY4ZFB5V0RJMDUzWmpS?=
 =?utf-8?B?S1ZnNzYzVmRxYXdFc1RtSGxSSnR0YUtoZUUzNVVGbGZlUUszR1FNTG5SODNO?=
 =?utf-8?B?aTlhOFdtb3BFTGhMUk9FU1IxWE1wU2IzM2laayttVE93bUt1UmdnWkRhM3dm?=
 =?utf-8?B?b1Q0ZDkwcnpwZ1NWdkRLVThQck52REtsbzlGNHF5K3J3cUgvb2U3R1VSTmxV?=
 =?utf-8?B?SERxYmw4M1N2dFBtaERvUWpkTGIyK3NHZmVQUUlJMytLVmRIeW9WR09FMHlL?=
 =?utf-8?B?Sm1QK09vbysyd3NiczZTeUVYQktoa1IxZlM2SjdrbWNIMW8veEdUc3dONzMy?=
 =?utf-8?B?Z08waFI2UVFLSTk3Qy81M2VVWGhrWU9idTNWaENpTzcreU1IMFZEeG5JWkFG?=
 =?utf-8?B?a00wUWdrdG5ZOFZVeFBXVHNCT3ljeXlCSkxKaW5EOUNyRG9MRGg2VzhWQUtR?=
 =?utf-8?B?eVNpc0wzczdMSmIzOW9GSmhaT29RU2hpNTIyRXFaRlRLcytFU2FudE1lS25L?=
 =?utf-8?B?REVxRmk4ZFl2S2tVei8xa0d3cVBIK3QwV0lzOUt6a1Q0SE9hWG1FTU52eWFl?=
 =?utf-8?B?QmZHRm5lRU91am1Sckx2RHhIQVVnSlN5ejZCM3pXRnp1Z2s1WnpHeGVySEo2?=
 =?utf-8?B?WndSL3NkQnVUR3JPNUc1UGZTOGpwRTA0MlQvSHN6NnAvQlYvM29ncVNudEFM?=
 =?utf-8?B?ZGVVMGRpUW5IOFNLVkpEVWJ2Z2xNdDVDVHJXNWpRTGRpbHJlUWZCZVdIVnl0?=
 =?utf-8?B?Sko0Z1E1RWwyN2NRcUxJbVcxbk9EWjdERzhhNk9pMUlWU0g5eis3S3lzRmFo?=
 =?utf-8?B?ZWtUZDFsZUY4L055UzVPSUNGdDhLdmR2UWVCUkpweWphcDRyYklhSDVKcmtG?=
 =?utf-8?B?NVU5VnExck0zSEl5amV1WjhUN2FhSFU5VkpUcDFybW9teHhLaWhHSXd1VWRW?=
 =?utf-8?B?ZjhGc0tJM00xSC8yVWY1VDM3UFdrQ3Jia1d2bUNkRWs2SUFWZ2J1UXlaUHZD?=
 =?utf-8?B?MWQ2VytpbkJydDkwTmgxOGcrSG1QSENld0tSQXpWOFlsVWkvUHdZSE9MZjVZ?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8cfd81-aa67-4a99-84a3-08de230b40d6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:20:37.4016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djvYQmyKur0h2zrkkb9Z5HfIMCjJ3i0bhk6SHKvl+1GMrsh24qSuHCRWx8pp+COIrhQfkMVH178W22Q0lUOnvd+/vKjPPBva392DjsRvDrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com

On 11/11/2025 9:48 AM, Paolo Bonzini wrote:
> 
> but here you must not check XCR0, the extended instruction information 
> field is always available.  The spec says "A non-Intel® APX enabled VMM 
> is free to continue using the legacy definition of the field, since lack 
> of Intel® APX enabling will guarantee that regIDs are only 4-bits, 
> maximum" but you can also use the extended instruction information field 
> if you want.  So, I'd make this also static_cpu_has(X86_FEATURE_APX).

I just got confirmation from the hardware folks. The CPUID enumeration 
alone is sufficient to indicate the presence and usability of the 
extended instruction information field, regardless of the XCR0 state.

