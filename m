Return-Path: <kvm+bounces-63422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D012C660D0
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 21:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2C623506EB
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86023328E2;
	Mon, 17 Nov 2025 20:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bajhNDjT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3853009C1;
	Mon, 17 Nov 2025 20:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409705; cv=fail; b=VKSsoBGiO4nyvq6ERR5KitjVItfDE6pT1tcuD70RcjLEuVDXCEF0PduV3luwJoixMEWXj69AAGlXkcprM/m90M3B1E/arKlFkf/KOvleTt+yuNBnnTh1SUkepMqL54aANytxdipUHQNaSP3m8rhcNoCDALFvX91IcNZPXP+OjuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409705; c=relaxed/simple;
	bh=87DzrkGQGID0WkOioUiUUum/1mjQiF8hS5aLFLOW6C8=;
	h=Content-Type:Message-ID:Date:Subject:From:To:CC:References:
	 In-Reply-To:MIME-Version; b=gqawWaqswbAY62JhzWA+NWdOzaD7Ig47AKFkYIUaoEek7V0EccJRFKTgv7jivHsRhWB3bEaiiuqiZxZaACmkgH8os9ABtYg9KgEVyXBuM8obR+hMH2BpFkt9NbuGVlNwUFgdKdVW8WXCZuI3W+En50lXe1c3HU+h4HmWFv5DCx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bajhNDjT; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409704; x=1794945704;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:mime-version;
  bh=87DzrkGQGID0WkOioUiUUum/1mjQiF8hS5aLFLOW6C8=;
  b=bajhNDjTqhkLjlTX/bLMGba4yJEQjK1kealhGaRyKuNotgfMBKrCCvj5
   a1RcdFxLq8TkSDWx1WpQEMXd+cO9TaRjspMTwvAjWRJGYAQNvws0+uN6E
   v9Lf4JTw6u2I/4rQMlR6JjcfzO/JGx4fnaNUk4lZoewDZj3HAUzbFTCO6
   HNsp8iQSkQBLmJYgEpBjxA3KV+FBIooQF4+2AY+TjEBbKpouVEjLYjtks
   XlxcZuD8uSceMLVj7YYdVP750mqckVosR2Mkc3tcZYD0org5r/kmyZYlU
   6NkcnkPlKK4s1y+GlfHY3TNN0n8Ycw1io6vVOYw6nLdc4FaPk86z966Qd
   A==;
X-CSE-ConnectionGUID: 0TyQJdG6SFKLlkgUpRT82g==
X-CSE-MsgGUID: eDTvTVHaTq6p+fGbFVfbOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="88069715"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="diff'?scan'208";a="88069715"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 12:01:44 -0800
X-CSE-ConnectionGUID: ePR8l43KT8qfkBFmGLBngw==
X-CSE-MsgGUID: SHjR+OQCQIy2cqDc4in3jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="diff'?scan'208";a="189841077"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 12:01:43 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 12:01:43 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 12:01:43 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.1) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 12:01:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f30GJ9kbhLFTVpdV3+tt6iKSmALEUHBu/xwHQmbR3dau6RlyTzKnvIQHdz++B2EQj5VoSsqyMJsgiNk08ucwsE4MLxq/hLzumJWEpIfYpNUUZBst1kFwUSIOv3HX8e4OsBs/BzciS+iFpJu5CnAWjnTY9L79vFWT7zknH1GVH1CyHEoAXTalwdqHQsOuUMdduMKRl+Gcwne/9dI3Zb7dfzJ465+VainUiiH/bFrpRJuH2ReZp7vRa9WLhtvrjdZ8pD1Q+hPDeaH6qTM1DuEcq9NSqdkc+dydDGt81ffacQS3EZcgGHo2ieYpXbJzv9gcAN7Q+Ar0EP/UtpJ4cNSCBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fQsdYO3XxkZ4cjr4b/Pq4IbqoS7m+fhzXaNVXIc/Rc=;
 b=wKLnkO32QVUv/PYquFXUVQmOHv/fdHFzzTXt9hNMuSCZ0N42zzfdHeMe/hZm4n+c23nQpewhFyYaiR0T20q8+fO3/wNO1qj95QkNGhWfhR+UQRHyme9DYqih6EwKabt5MRuqR+TuGXJDWDmxZ5O+8rRVUzsWH1p52G7pyCGzgdkubSkKW0ExX2zUUEd3PFaqchw0IYkX8RsMLBncqsu1qVz6QRdtI1qL1p9TMKne7bnaxkcELzHR5k9tj3yT7+S0j+uGebB8l9JFSm8t8aCPhgRloomgwMk/n52kKlTmYo6+jEXNn1y7uRK7P8MoOB0nN2p5YGsYuETigUPqAHupig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CY8PR11MB7083.namprd11.prod.outlook.com (2603:10b6:930:51::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.21; Mon, 17 Nov 2025 20:01:33 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 20:01:33 +0000
Content-Type: multipart/mixed;
	boundary="------------I4PTSNrr2n6vbpWUekESyB3G"
Message-ID: <a4058352-2628-45d6-86d6-92ac1eef4cad@intel.com>
Date: Mon, 17 Nov 2025 12:01:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 16/20] KVM: x86: Decode REX2 prefix in the emulator
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-17-chang.seok.bae@intel.com>
 <6a093929-5e35-485a-934c-e0913d14ac14@redhat.com>
 <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com>
Content-Language: en-US
In-Reply-To: <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com>
X-ClientProxiedBy: SJ0PR05CA0109.namprd05.prod.outlook.com
 (2603:10b6:a03:334::24) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CY8PR11MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: f83788e9-8936-43f4-a341-08de26141b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|4053099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RkphRFI5K05HVUkza3NWZkV5aHNISHlTRUZjNU1aUHlQVWFQSDZSV3RZNGha?=
 =?utf-8?B?TExpYm1VVXNjcjJpZmlscXVKRmhrbHBQeFByUHk4OFFZdlUxR1FwTjJlVm5q?=
 =?utf-8?B?eEhzOVdFemRhNU80VUNpSVlQU1JYdGpxSjQwN0VSL2pVMVVkVG83NCsyTEpp?=
 =?utf-8?B?VHBJdUNkQ0tuQUVBWktIWEdoUmUzSkxJN1BHVFNzTXBhZi9KZVZqYndFNVRU?=
 =?utf-8?B?S05LL3pHUTRscHFmTDZFVnZSbU83elZ2MHFEdFZFNkZDbU13N0FRVTYvVmZj?=
 =?utf-8?B?NW10UVFGVkdORmhFOFZVaHhuUFhKclFOaTFOd0hwR1VoUE1RcmlRVmVIRDFT?=
 =?utf-8?B?K2pjMGN5N0xaTHlVU1diM2RPeHlWaUJTalU1a29ZQmxHRTVKQ2MvRnNTcHdE?=
 =?utf-8?B?VVVhQ0NmUlJTR0grRnJOSXpYOVVISC94MTNSQ1RBVXU1cGRYUm96UkZNSzRI?=
 =?utf-8?B?QXl4QWsxTjFZOVd5WUFRRk5rUnZrL0htcmMxcjYyOUFRVXFRc3pmZ0gzUWF5?=
 =?utf-8?B?TkRCN2VVYlNlWXV6RVVhY0poL0dLdUtITE42c1NGWll2a1V1M1dpUWhMOG1J?=
 =?utf-8?B?c2ZHZlNXa2NiZnQrRGVTdkQvT3FNalRmTkQ0Y0tNY3hWUkptMGNhZStrcUlw?=
 =?utf-8?B?VFRJTHRBdGs5U1VzbWlwNG13MUNvTXZmbjFZSXl0U01CSkEwUGpKK04yNG82?=
 =?utf-8?B?UUsyeXo2ZGNJd0V0NDdTanpVVmRQRE9UMEt0aU02L05Oa0hud1FJdFQ0MzB3?=
 =?utf-8?B?bVQ2MEZONDZiaWsrRGFjVVMweE1pR3BEVjhIYmw0NVdjYmpYYmNLZVNvU081?=
 =?utf-8?B?MkErblQwSkdoTjVhTlVXUEhZYVBNL3hnZnNQcy9vb2J5dmlHejIxbnVYY29G?=
 =?utf-8?B?Q1ZRd0xuNVBXRGFTQnRmYkJiU1JJM3VDeHZ1WVpyTkxXWVFmc1Q5WnpqQTZq?=
 =?utf-8?B?Q3diWGpXdEdRdDdTempBZURMdHpLZ2M0T2pNdUt6c0p6UnRDR0xiMGVXVHV3?=
 =?utf-8?B?b0prREw3SVl2SG9GSkR2TWpndVpRUzRqUmxFSGxYTTZkRUsyTWJPdk1VeVR3?=
 =?utf-8?B?dWFNTmxnTmFrMWNzdU90MC9WS1FCbTZrZGFpSVRwRTlzZENpa3cySjVwaXVv?=
 =?utf-8?B?NHA0cFN5bFpQeFFHSG1sOXYrcjh4N0NqS2M5bGNiUG5xL3F0NWt5cnhxMVhB?=
 =?utf-8?B?NmxGbC9rcmdJdXY3Y3VkUFR2b2wybFJPZS9zY3c2a3VDRHlDUzVMVzRxZEhE?=
 =?utf-8?B?N3ppZE8vcU9JTWQ3bVRqOHg3SGVsdUo1Zit6dHNlekZRU2UvWEVrcHRMTU55?=
 =?utf-8?B?REhRZEFEWThDL2RHN2daYjdOdHFobE9IeHpKTG1NQmN0ZnRaZXpYYlpxUWxs?=
 =?utf-8?B?d3RYc3dGQnZGYVZMR2E3RzFJOXRLeTJ0T1EyZEx6TWs2cHZVaEhObzFweW9V?=
 =?utf-8?B?N2EzQXdRakNQSzJvZ3NSQ2dTVThIbTJiSjdyZlREUkNDWWk0ZXY4MFJCU1dn?=
 =?utf-8?B?UVNHM3h5ejkvWnNRQXFVQ1lNVkNDWENkaTNuUkZFQkczcis5RWNsRFdHQW1x?=
 =?utf-8?B?Z21rbVMreEhpcWlxVEVlVXlvdVc3UVl2OFova0xxdzNHcEZVcnYzTjdWM3RK?=
 =?utf-8?B?MklNUllXK2E1aXppb2svN3BiLzNhSFhCTW1RWFllT0JFTTNnamY3WVJjSUg4?=
 =?utf-8?B?amgzbkE3MEFKSUJReFU3SUZJcm1QbDhyRU94UXo2RnVOV3laWUJDWWZyNlMv?=
 =?utf-8?B?SGZZV1cwRWhJUDhLM21ibkpMTnBQUDBXTnJpeWJVM2tWbTF3WS81T0N6aUpE?=
 =?utf-8?B?THJhL0gwNjN1NHdwUVpXNmJpR1pqbjRGd3hkZ3B0cUN5SWFJc1lnN3l1UDFY?=
 =?utf-8?B?QXQ5V2VNOEdWaFVKZHdDQWhiMW4zMXloTE1qNWRURm5OSWxxUWd3c3dIRE5S?=
 =?utf-8?B?bTNyKzZMZWQ5bjRpYmZYSVFEaEEzOTNKREQvakNRVG5Pc1A0TXNpR0RJQXRs?=
 =?utf-8?B?enpkRzFMNzJBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmR1S3kyKzM0UTF5dm1tZDZyVjJwcW1UM1gxSFQxb3ZHVGNlcnB3bUpqM0tx?=
 =?utf-8?B?RGxZa0ZMdWY0YkhxbkQ0T2RqL1Y3NURLa1RoRXpNMzhNb3JmWGtyOVVUb2lw?=
 =?utf-8?B?YVJ6M043cTJqYVk1b1dCd0svUjJLeW9HNDhZaFU5ZUszWHhRc1pObEQ1aUMy?=
 =?utf-8?B?MHY2WGx6TXFaS1djNVliN1BEUG1hdzhTbGh2WEh4ZHJUQnRXWERjZlRtQ3BQ?=
 =?utf-8?B?UFQ5ZVBHcEVQOU8yUEoydEhwcURoVXQ5U29Mamx3TUcvMmZEZHYxUVM3Nndk?=
 =?utf-8?B?endoaGxrYmxoYUVjK2lYOUNhb1Z5ME1NeE9TOFlvcGtiT2kzQzBZQ282ckJM?=
 =?utf-8?B?ZlJiNW5PQ0twZStDc1hQQmw0QlNrNWFRR0tyekd5SGY4OUdpTFdEbFFBWitK?=
 =?utf-8?B?aVlUYk95NzZ5Ukp1bEhidzkyQnFsQVU5ZS9oS21sV2xMT0RPK0lMV29VT2dS?=
 =?utf-8?B?S1kxWU1aVnU4TFJUdm05LzZlKzZhVjVKdERFNS9HQXBacmNKKzFUeHQyWlpE?=
 =?utf-8?B?OEdLR1VleFZzZ0JKb2trSVZTUTVPUTRselV4cXZVTEh6ckd4OVBQa2dwak1i?=
 =?utf-8?B?blpoSDl3TFZDR2syeVhuOG1zSjJJRmdORUkvRG03VEEwSjE5aytwMDRyM09S?=
 =?utf-8?B?NUFHTk9EZHlJbUoxR21mcEYzOUJIbXpacHRsck1vcFVRTm9KNWxGTkl2ZXRx?=
 =?utf-8?B?Q1JKand5RTNxUXpDQUs4cjN1UFlaMlE1ZDlaM2pLYnF3dllydC9SZ1RXWThG?=
 =?utf-8?B?T1lteVV3ckRmQklocUREZCtDeHlDdlJaREF5amZPc1dtRXRQSTBXTXBSNTAv?=
 =?utf-8?B?eFRsL1RzRDlZdjc1akdqbWpmQXpTWEpUNEJ6RERCa25CZEhKNENtdFQyTmpM?=
 =?utf-8?B?WmFJNHVNSUV5NjlYWTVqcUNxdG9OallkNUpDb0d3NlJxYmpLbXNpOXlHOXZQ?=
 =?utf-8?B?MVY3dHJCeE1reGRLSGh1VERmaDh2YTNmSlM5OGEra0cxUkoxQlQ1T2U3TGpR?=
 =?utf-8?B?d2F1YWN4a09aQlQ1UHZmcFRyeWpzRTEyREJTOUo2NWhEQkp3TDlEd1FkNGNO?=
 =?utf-8?B?UHZ3bFBxVnRtMlRwU21vNkFIQjczVHpDaU41aFowZXFNWk1kbjJubVgzN3Ni?=
 =?utf-8?B?dWh0bGJqVnhOc2FqQUVxZW9GSU4xQkhycGlaUXlOSFVtS2FZT3plUkdacStS?=
 =?utf-8?B?emxnQ1k5TzJFUUxydDNPclgybGY0b01FUmJ6NUhBYUNPNnM4dU5BaStKNmdk?=
 =?utf-8?B?WFFBd01NSDMzeUZLQzdveDBIanpBeFdoQzA2NkI2b1A5QW5pMnVPYURleE9S?=
 =?utf-8?B?RjVnRHN5eW44UnFQRkNHdkExR3E1aW9mNUVVVlVZUGFjckZtNzc0RWhEUXVX?=
 =?utf-8?B?NmxLR2FoNHVwcE5rMHBIUEx6MlVTeTNUU3hCVThUWFI1cmdFTDFqNmxMZGFD?=
 =?utf-8?B?R2JYRUhacWlzQVRpdVVhZjNVcDd6ZnQwbGdZUllHUzhMbFBBQ0YySHBvUk1I?=
 =?utf-8?B?elVIaVA0dXdjbG1xeUpwT2xDdk4wNjUrTjNUNjU4U25CSllMejh2S1cwYzdJ?=
 =?utf-8?B?R25pUmJNa25IdTllUUIvN0RaWWQwQlcrRXc4aWdaN0JYNGlram84b3RHeCtz?=
 =?utf-8?B?T2hxZFF5eURVQnlZRjkvaFpnSFdRL0o2R0VwTHdVTkRINlQycmRoNFNZQytU?=
 =?utf-8?B?NW9Gek5IdkJvZTVmS2R0RjUwZDArY0dMUTV6SWh5UjJJZWI3NG1GemluWkYv?=
 =?utf-8?B?N3JzQXFuTUczb2ZqNVkyVlN2M1UyZktvSVhqQm9pTjI3YklKMFY3VlZ4WVFK?=
 =?utf-8?B?NGxxakdNVTNpdVhlanI2NjliUWg3R3o5SFN5R0FDWCtvMFFzY0U4SlRzOEVZ?=
 =?utf-8?B?MzlBNTA3OWQ0Sk9zb2FnYVpVc1JTejNZMVpIR2xlNC9kb1pGRUhKYVNjeDdF?=
 =?utf-8?B?SUVyaWRsY2VQK2tXNTVpY2RoRGpaS2k3NWtmRHE1MjQ3NVFTQ08vdmVGeVpU?=
 =?utf-8?B?MjAyM1BpOXIyVFB6KzY5aWFNeTczNERkOUFHdFdGL2Y2WElYb0JwNWl2TTRu?=
 =?utf-8?B?VFNIbW5haHArZHNtc0JWeERwNVAxVnRPNzhrV08ycVpqcElkN3BET0w2S3Rh?=
 =?utf-8?B?OXN5aUZ2V2RBMHpxbGVaalRIZzVjY0x0LzdOWThZU1lqTlM2YWxCSHI0aUlO?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f83788e9-8936-43f4-a341-08de26141b37
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 20:01:33.3268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRGkQ6VYAusvHv5T6OU2lNl+eCdfyZdJCrPyXBgcjKNm97oWzi1n0FjB6dhT6HLdza83qIe0bQrhOzDZOzJN0JoPzdVVlXJVNmLmu/Y+ZRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7083
X-OriginatorOrg: intel.com

--------------I4PTSNrr2n6vbpWUekESyB3G
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 11/13/2025 3:30 PM, Chang S. Bae wrote:
> On 11/11/2025 9:55 AM, Paolo Bonzini wrote:
>> On 11/10/25 19:01, Chang S. Bae wrote:
>>>
>>>           case 0x40 ... 0x4f: /* REX */
>>>               if (mode != X86EMUL_MODE_PROT64)
>>>                   goto done_prefixes;
>>> +            if (ctxt->rex_prefix == REX2_PREFIX)
>>> +                break;
>>>               ctxt->rex_prefix = REX_PREFIX;
>>>               ctxt->rex.raw    = 0x0f & ctxt->b;
>>>               continue;
>>> +        case 0xd5: /* REX2 */
>>> +            if (mode != X86EMUL_MODE_PROT64)
>>> +                goto done_prefixes;

[...]

>>> +            if (ctxt->rex_prefix == REX2_PREFIX &&
>>> +                ctxt->rex.bits.m0 == 0)
>>> +                break;
>>> +            ctxt->rex_prefix = REX2_PREFIX;
>>> +            ctxt->rex.raw    = insn_fetch(u8, ctxt);
>>> +            continue;
>> After REX2 always comes the main opcode byte, so you can "goto 
>> done_prefixes" here.  Or even jump here already; in pseudocode:
>>
>>      ctxt->b = insn_fetch(u8, ctxt);
>>      if (rex2 & REX_M)
>>          goto decode_twobyte;
>>      else
>>          goto decode_onebyte;
> 
> Yes, agreed. I think this makes the control flow more explicit.

While rebasing onto your VEX series, I noticed a couple of missings:

   (1) Jumping directly to the decode path skips the ctxt->op_bytes
       setup.
   (2) It also removes the logic that detects the invalid sequence:
       REX2->REX (unless intentional).

Perhaps it makes sense to simply continue prefix parsing. Then, at
'done_prefixes', we can check the M bit next to the W-bit check and jump
to the two-byte decode path.

I’ve attached a revised diff on top of the VEX series.
--------------I4PTSNrr2n6vbpWUekESyB3G
Content-Type: text/plain; charset="UTF-8"; name="PATCH16_again.diff"
Content-Disposition: attachment; filename="PATCH16_again.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMgYi9hcmNoL3g4Ni9rdm0vZW11bGF0
ZS5jCmluZGV4IDFiM2RhM2JhMjZiOC4uM2E2Njc0MWI2YzhjIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vZW11bGF0ZS5jCisrKyBiL2FyY2gveDg2L2t2bS9lbXVsYXRlLmMKQEAgLTI0NSw2ICsy
NDUsNyBAQCBlbnVtIHsKIAlSRVhfWCA9IDIsCiAJUkVYX1IgPSA0LAogCVJFWF9XID0gOCwKKwlS
RVhfTSA9IDB4ODAsCiB9OwogCiBzdGF0aWMgdm9pZCB3cml0ZWJhY2tfcmVnaXN0ZXJzKHN0cnVj
dCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0KQpAQCAtNDg0OSw2ICs0ODUwLDE4IEBAIHN0YXRpYyBp
bnQgeDg2X2RlY29kZV9hdngoc3RydWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQsCiAJcmV0dXJu
IHJjOwogfQogCitzdGF0aWMgaW5saW5lIGJvb2wgcmV4Ml9pbnZhbGlkKHN0cnVjdCB4ODZfZW11
bGF0ZV9jdHh0ICpjdHh0KQoreworCWNvbnN0IHN0cnVjdCB4ODZfZW11bGF0ZV9vcHMgKm9wcyA9
IGN0eHQtPm9wczsKKwl1NjQgeGNyID0gMDsKKworCXJldHVybiBjdHh0LT5yZXhfcHJlZml4ID09
IFJFWF9QUkVGSVggfHwKKwkgICAgICAgKGN0eHQtPnJleF9wcmVmaXggPT0gUkVYMl9QUkVGSVgg
JiYgIShjdHh0LT5yZXhfYml0cyAmIFJFWF9NKSkgfHwKKwkgICAgICAgIShvcHMtPmdldF9jcihj
dHh0LCA0KSAmIFg4Nl9DUjRfT1NYU0FWRSkgfHwKKwkgICAgICAgb3BzLT5nZXRfeGNyKGN0eHQs
IDAsICZ4Y3IpIHx8CisJICAgICAgICEoeGNyICYgWEZFQVRVUkVfTUFTS19BUFgpOworfQorCiBp
bnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0LCB2b2lkICpp
bnNuLCBpbnQgaW5zbl9sZW4sIGludCBlbXVsYXRpb25fdHlwZSkKIHsKIAlpbnQgcmMgPSBYODZF
TVVMX0NPTlRJTlVFOwpAQCAtNDkwMiw3ICs0OTE1LDcgQEAgaW50IHg4Nl9kZWNvZGVfaW5zbihz
dHJ1Y3QgeDg2X2VtdWxhdGVfY3R4dCAqY3R4dCwgdm9pZCAqaW5zbiwgaW50IGluc25fbGVuLCBp
bnQKIAljdHh0LT5vcF9ieXRlcyA9IGRlZl9vcF9ieXRlczsKIAljdHh0LT5hZF9ieXRlcyA9IGRl
Zl9hZF9ieXRlczsKIAotCS8qIExlZ2FjeSBwcmVmaXhlcy4gKi8KKwkvKiBMZWdhY3kgYW5kIFJF
WC9SRVgyIHByZWZpeGVzLiAqLwogCWZvciAoOzspIHsKIAkJc3dpdGNoIChjdHh0LT5iID0gaW5z
bl9mZXRjaCh1OCwgY3R4dCkpIHsKIAkJY2FzZSAweDY2OgkvKiBvcGVyYW5kLXNpemUgb3ZlcnJp
ZGUgKi8KQEAgLTQ5NDUsOSArNDk1OCwyMyBAQCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4
ODZfZW11bGF0ZV9jdHh0ICpjdHh0LCB2b2lkICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCQlj
YXNlIDB4NDAgLi4uIDB4NGY6IC8qIFJFWCAqLwogCQkJaWYgKG1vZGUgIT0gWDg2RU1VTF9NT0RF
X1BST1Q2NCkKIAkJCQlnb3RvIGRvbmVfcHJlZml4ZXM7CisJCQlpZiAoY3R4dC0+cmV4X3ByZWZp
eCA9PSBSRVgyX1BSRUZJWCkgeworCQkJCW9wY29kZSA9IHVkOworCQkJCWdvdG8gZG9uZV9tb2Ry
bTsKKwkJCX0KIAkJCWN0eHQtPnJleF9wcmVmaXggPSBSRVhfUFJFRklYOwogCQkJY3R4dC0+cmV4
X2JpdHMgICA9IGN0eHQtPmIgJiAweGY7CiAJCQljb250aW51ZTsKKwkJY2FzZSAweGQ1OiAvKiBS
RVgyICovCisJCQlpZiAobW9kZSAhPSBYODZFTVVMX01PREVfUFJPVDY0KQorCQkJCWdvdG8gZG9u
ZV9wcmVmaXhlczsKKwkJCWlmIChyZXgyX2ludmFsaWQoY3R4dCkpIHsKKwkJCQlvcGNvZGUgPSB1
ZDsKKwkJCQlnb3RvIGRvbmVfbW9kcm07CisJCQl9CisJCQljdHh0LT5yZXhfcHJlZml4ID0gUkVY
Ml9QUkVGSVg7CisJCQljdHh0LT5yZXhfYml0cyAgID0gaW5zbl9mZXRjaCh1OCwgY3R4dCk7CisJ
CQljb250aW51ZTsKIAkJY2FzZSAweGYwOgkvKiBMT0NLICovCiAJCQljdHh0LT5sb2NrX3ByZWZp
eCA9IDE7CiAJCQlicmVhazsKQEAgLTQ5NzAsNiArNDk5Nyw5IEBAIGludCB4ODZfZGVjb2RlX2lu
c24oc3RydWN0IHg4Nl9lbXVsYXRlX2N0eHQgKmN0eHQsIHZvaWQgKmluc24sIGludCBpbnNuX2xl
biwgaW50CiAJaWYgKGN0eHQtPnJleF9iaXRzICYgUkVYX1cpCiAJCWN0eHQtPm9wX2J5dGVzID0g
ODsKIAorCWlmIChjdHh0LT5yZXhfYml0cyAmIFJFWF9NKQorCQlnb3RvIGRlY29kZV90d29ieXRl
czsKKwogCS8qIE9wY29kZSBieXRlKHMpLiAqLwogCWlmIChjdHh0LT5iID09IDB4YzQgfHwgY3R4
dC0+YiA9PSAweGM1KSB7CiAJCS8qIFZFWCBvciBMRFMvTEVTICovCkBAIC00OTg3LDggKzUwMTcs
OSBAQCBpbnQgeDg2X2RlY29kZV9pbnNuKHN0cnVjdCB4ODZfZW11bGF0ZV9jdHh0ICpjdHh0LCB2
b2lkICppbnNuLCBpbnQgaW5zbl9sZW4sIGludAogCQkJZ290byBkb25lOwogCX0gZWxzZSBpZiAo
Y3R4dC0+YiA9PSAweDBmKSB7CiAJCS8qIFR3by0gb3IgdGhyZWUtYnl0ZSBvcGNvZGUgKi8KLQkJ
Y3R4dC0+b3Bjb2RlX2xlbiA9IDI7CiAJCWN0eHQtPmIgPSBpbnNuX2ZldGNoKHU4LCBjdHh0KTsK
K2RlY29kZV90d29ieXRlczoKKwkJY3R4dC0+b3Bjb2RlX2xlbiA9IDI7CiAJCW9wY29kZSA9IHR3
b2J5dGVfdGFibGVbY3R4dC0+Yl07CiAKIAkJLyogMEZfMzggb3Bjb2RlIG1hcCAqLwo=

--------------I4PTSNrr2n6vbpWUekESyB3G--

