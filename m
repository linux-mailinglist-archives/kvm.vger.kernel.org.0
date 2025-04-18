Return-Path: <kvm+bounces-43683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C525AA93F3A
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 22:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD25F4637D1
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A575E241674;
	Fri, 18 Apr 2025 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VLC3P7bH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7C815442A;
	Fri, 18 Apr 2025 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745009517; cv=fail; b=Ni0eZhIwW47epFeAHYZ1XS61rbF2SlxCYTLC4s6mO3jR2PcuAETt3dTgUXeXDly3C2jkQe6qABxIOJCIQxf8SvGtUpe3t5zWDUuypowLttR+WqZ2Q6dNd5DP2sFgc5s7tFTh2BRQIKJRSceYdgkWSMTanhFWVxIEsaYRhJcWMzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745009517; c=relaxed/simple;
	bh=QjjserWHoFWqj+kDg2aYk3l4/58xnFOQJSKFHfXNUmY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cVMgNpSXCyVanSmN1WWGPHgFEZQhx/TE33/u5isOvCjWqHK7KBZQqIju+1DwrIUrO3vG8UJgnPopP6XfLBhbTVBPtpgxcLOJZXJ+prUVe73KGEr113zMjToqXXpmWaQO/HHQjHkrFVxERMA14PtkuMLVtzRwm03JyFeG6Ascr/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VLC3P7bH; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745009515; x=1776545515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QjjserWHoFWqj+kDg2aYk3l4/58xnFOQJSKFHfXNUmY=;
  b=VLC3P7bHBp8zc//PEDxLKIiGrJQVBvz3pqCY7GiELJuX7jCgplouTkTq
   SsuKj7SKUJ7gDgxXC1b5KJB9PHjhibPWnzuOCA70Tg11PW3quYbdnOPDR
   v7Z/Te5U3ZOjx+s9OfzUwM8rgjiSz/d3VaAXgXYMxmt4gFzqhzWsOAxwC
   bwC9cStQD0g4smJmv88lQvTGH39J6RgLS6fbhJgQLwhAcDYJeGQIAPzQi
   pY/8xJK2Ubv7pD6mpFvPmv4OFtNXNdy0/Ua1ZnyQhJ2TKxtT54hE4Y3wV
   /zOpEBWZuZQmwmUgqoMuTpxgw24okDiunAY6cXRFrYKHqp3YHOYI1rHGJ
   g==;
X-CSE-ConnectionGUID: 3WXJK/BPST6A2Qm/C4M1sQ==
X-CSE-MsgGUID: DLJW8xj/Te+o3uvv2AczBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="50472563"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="50472563"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:51:53 -0700
X-CSE-ConnectionGUID: uBhY07ELSRGUTSk0hcy30w==
X-CSE-MsgGUID: VCjFViRzRf6ATLeOE4eOCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="130948766"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 13:51:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 13:51:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 13:51:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 13:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8A3ecNuIaY9rU5Kt9JktEuYGqe8tSmlNzgeq9vcT6jsRDxeIqql3HUjujb1llsh0fT+MEAqOswtoKPUxD2yFyzGwQLs9JBfNYTFJ1fz5Swswb43VA/eCQ7FIwXYwlTCUkDTXNMyBzSLaevzyWmUxiN8yNRuM57h1BG9Xf2cyvCh564d5jn3tepv5ExhRa2gYF/eO7g1f4a0BI8YjLh4vDpNib+JBFXklut6ScD3LX88ihiUKt58mFboxJQR0u5dzagpJeLtxBtl9CWG+kiahS0ihwc/WUPP3nBsTPYNho/dHb1xxnnv6ebZC248gSPEf5QztXm9oRjtF0ucSsc3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FM1z86vSoTVYYBw3YRF5O5ZOPVivgXpwxgPVFSlCLeo=;
 b=GSZEqwzgfXVv+j7QS0epBxQkDN1ZDaIEpmDW8etlBcM2V+yv/YaDPWvNCiVWpE1ZH0HTopHvrr82EScWlCdDlY6rOizIdNE4rGzETY6tRu3ut0T9kjbGc/n2TGbH5obDxAkzoUZRFTkPhF1OiiRqze/CYgpNV/NLjO4Ebo3HvJiJm7sI/oOUeqTwikXSNfDGkzE/Hi15VZy9IjADzDIE67mDhWu8TJDVq6g+h0nqCbdFobcJmoqi7Duh97WV1FmU9xWBl7SVK4dDTOPYAtbAHiqFa+r1eRbo6lu3EF60G0qI2Wum37yUER1w5N5h+Z7z3kD1KJMoPOEklg81B/Opog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 MW3PR11MB4635.namprd11.prod.outlook.com (2603:10b6:303:2c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Fri, 18 Apr 2025 20:51:04 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%4]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 20:51:04 +0000
Message-ID: <cd14e94f-dbf8-4a2b-9e92-66dd23a3940b@intel.com>
Date: Fri, 18 Apr 2025 13:51:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] x86/fpu: Drop @perm from guest pseudo FPU
 container
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Stanislav Spassov <stanspas@amazon.de>,
	"Eric Biggers" <ebiggers@google.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-3-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250410072605.2358393-3-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::33) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|MW3PR11MB4635:EE_
X-MS-Office365-Filtering-Correlation-Id: 4677185d-3539-4ebc-5269-08dd7ebabc23
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a1BZV1M3QzhpTkhnMWdvT2d0bmk5YUQ2VHdYQjdWNWVzUUkzY2RmZkYvZlJk?=
 =?utf-8?B?WldPaDEyVU9taUhSTUdrbVAzWHlRNS8rWm0yZWRSbkRwb3loZVF5eVJFcjdu?=
 =?utf-8?B?UDdRNUdpS1pxQjRFRmxtbElkUXJWRXpXekJmWEZGa2hxczVTMURZUkpkb01I?=
 =?utf-8?B?c2dJNFg4Rjl4TTF3Ui9vUTNIbUh6WWhZQ2w5WHY3NnAvRG51VGJaUXArM1FW?=
 =?utf-8?B?RkZzMW5WSnd3T0FlcWt4MVJlMUlYODJxcXZCS3dSZnQydHNiblUzS3Jndjkz?=
 =?utf-8?B?a3dqd08wRE92Mm0rUElxVlpKcEVTUm1LWW9jUDZ5bWdKQWZHM1BZK2xGblJN?=
 =?utf-8?B?QVhHNHdSZjAxYm0yODdoNTVqRS8yd1prZzBQRC9hbWV0OEUybkxpSndVL1p6?=
 =?utf-8?B?NW16a3FCYWlJRmRETnpKRFRGRno0NzZ3eVprcHZTeXc5blpaWW1pYVppRzlW?=
 =?utf-8?B?dEYrTHVZamVPbks5UUxtMFBxZW5rZzhMZWJHQUowUEFhcllQOUxWdzhEb1gz?=
 =?utf-8?B?TWhUR0x5TmdHc2RVYndOQlgyMTNzNnhNS3k5eWRuRytsZ2l5b1NzcEdnYWN0?=
 =?utf-8?B?Q2xtV2tKMGhiblVsZm5qNU1TdkJBUEZUbzlzYnlEMjdPRlVaVzBVRFNNbXNL?=
 =?utf-8?B?RzFJUWEwYXFGUHBYRUdmZSt6c0U4KzEzM2R4cUVtVXh6UEVPdkNOWXZkTUR0?=
 =?utf-8?B?TG5xMnF3Tk1FbGVWR0N1MFNHUWRTNTlpSTRreWdPa3hJWk02WnpjbkhhTHZN?=
 =?utf-8?B?eDNwa0NhTHpDOHNkZWxHUjdENTQ4UThIOFdpYTc4NHVqRG9CM1p5eFhWUnlz?=
 =?utf-8?B?allYQU41QnpiYmVJOS8rSEkxb0VjVGhVU3BJdHhiQ0RwVi93VGtESVF4K0d5?=
 =?utf-8?B?ZTIyNlcyaXdhWGhZaUxsREYvU0JHbU0xUWJHcDVaR3BGN3o3TDFDV1BUbzVR?=
 =?utf-8?B?WDhkb1dGV0c0Uk1wL0tqbXhsMU1rdzBQNDhHRkpicFkrY1JCUHFOSjh4a20x?=
 =?utf-8?B?Zit4S1Q3bWVBMEdhK2l5UTY0RmswNXlubTRPeFQzUTVuMkVXdGZtLzVqaTBu?=
 =?utf-8?B?MnRXNVlDeUJjMEJQa0tzSjJNc0wyNnNzUDVtOHZBaStDWXlOM05oOWFleVlr?=
 =?utf-8?B?N2pYODlNeWduUzFwaE1tYWJiNERPMkxDK3hia3JMWWFaZjE0SGZveXQ2dzlq?=
 =?utf-8?B?cHFGVVhlSWhDZzBHZWVJbVZ4eld1MDczeUJ2c1BKUFJIVzRiUHZJQkk4K1Vv?=
 =?utf-8?B?M3lYaWo5MWFVQThzQzdkKzhva1RlQlpBY09UY2toYWZPMWdmWmVXUVhXYTJa?=
 =?utf-8?B?elhPNkNybG1TdEg5VGR4RUN5b3Yva1NDb3R6ODl4OHE3TG5HZHp1UE5sVUxv?=
 =?utf-8?B?WFBMQzF0eDBtajBSYitnem5MaWdVZVlrY3lZYVhHdUkrazVkSFA4Y1EzMEli?=
 =?utf-8?B?eXFieWtITThUdStFdUtaaHJ5UVpxOENTanNHcld2VjBXRm0wWk5lODF3ZCtM?=
 =?utf-8?B?SDAybnpSUGFMdDNKbHNKdjRSUjBEUlRmRExiSzc2bTFWSzJCcml3bURrSlVN?=
 =?utf-8?B?TjJmL1VraWhsMm1VUTdOVEEyZVAzTXl1QXBpdDJTR1pEdFBqbXRmalVaZ01U?=
 =?utf-8?B?Tml4NXR6a0htME5UUk94d2RpNEU5RlBGQjZUSmVGRXMvL245ZmY1ODlkdTlz?=
 =?utf-8?B?TXR4eis1NHVzeWREbWhOZ24yUDFJZjc3dXUwdGgvZlZHTE1HcGJTMlZDVXNl?=
 =?utf-8?B?clZXOHBwek1saTYxU2N4Uk1WY1FGaERYZ2FjL1RnUzBjK3F4SWFNWjhMYW9n?=
 =?utf-8?B?by96RWxoa3Z2UHcxa1Urd1Rrdk15SWlqRWZLakVhVU9mZkFNSSt2R2d4SGRk?=
 =?utf-8?B?RW5KRnpMTzhWZU53SVBzb2t6Umc1V2dTUDQ0T2pOdzJFbm5zVlp3NXlsejlM?=
 =?utf-8?Q?uhQHU1ZrOcI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVhWNFpuUWl4MU5sbFF6emk1ZnFvY0VrNjJ6YzFGbDVWTENxSnU2M1JnSnN1?=
 =?utf-8?B?ZFVBTjBrVGgrQmh6OFRMeGdsbFNVZDFzczZHOS91REdhbWRqSkJodGlzY09l?=
 =?utf-8?B?MDkwUnZXUm5SYWR6alczR05HdjZZcS9tTGJJUFh4cEdKUEZFWTZHMUVxRDZm?=
 =?utf-8?B?NTZRVTlWcTVuc3htL3JiQ2FTWVVTK0tNRkl2cFRaTlFjZ0hoSGlaU1ZrSSsx?=
 =?utf-8?B?dERScUhKQllkTStNQlhMYS9RSEFzZ3d2QTBDaDhrV2FaUGtJTDdUbm9tZ1Jp?=
 =?utf-8?B?UDNmVWV1dDNiZE5WSkVXRlpWZEdwUitFQ2RJekF4Ymd5dGQ5cUU2WlpDTFBv?=
 =?utf-8?B?cm9aUlRETE1vbUFPRHEyOFoyUzVtVzRqc2ZqZHdCeVJ1b1NKUUNrcGVIb0Zs?=
 =?utf-8?B?TEppdEMrUzk4SjBTS1Q2VVZWRW4vcU9JU01OWHNoOUlPbk9UZjRUajVqVkVh?=
 =?utf-8?B?TVpoOTFETXcyS3phUzZiS1R0TUFFQVJBM1B3OGhLc2JrR2dHVlBScVAvdjd5?=
 =?utf-8?B?UFVpZW12QkRrWTJrMm4wcWJDNit2dnh1cUlBcTFucnhmY0Q4bUlnWHN3ZFN3?=
 =?utf-8?B?WXp4bmVIRVF2aFBaYklhN3dFclNTV3hkSCtDUDFVb0lIMExsMEROa1F5aktq?=
 =?utf-8?B?bjNzSnBIb1VIOUxreXM4bGVSakRUc1d3Q3diNTVrbWs1ZUxnTEFpVFdwbmhP?=
 =?utf-8?B?enFLMkNhaXhEalViY040aktOR3crblBLbDRqTmdqeUk3UnJnVmpPMUZ4bmRu?=
 =?utf-8?B?eG5HSHRzY1dpQjBBczArczdGWlpnd0cvOWx4aVk0Yk8zWms0V3IzOGxsSGM0?=
 =?utf-8?B?d25GeGg3QitNQ1VIcmFFYWxCTVRscUpvcisvWTRqaHBaRWdtbHAyeWFtdzBr?=
 =?utf-8?B?Q3RZWlJRbUkyQ2krRGpyUmxTMjQ1UWE0ay8zTmFib0FLcW15d3J6ckhMZUhm?=
 =?utf-8?B?MVk2UGpxMzU1RkQwTC9KbEVJWWpudmVKQjc1eEFjZmpKSFVPeFlHY0IzWlFL?=
 =?utf-8?B?YzFLaDZQc1M1aXVwbVowc3Boc0pZM1NhMERkbzlqbllyS0tMdWp0eGxxSldz?=
 =?utf-8?B?T3pIWGQxNGVZaDVGL00wVEJSeTQxS3FQMDYya0ZuWDZONXBLZlFrbTNQWmd3?=
 =?utf-8?B?emNvU25tWHhIUUVTT29yM0J6RldaZUhMV1NqNkpCM1lJYWxtRFEwU2NleHd1?=
 =?utf-8?B?by9aTndVOVp5aXJhUk51eG5HRDlOMUE1QXhaa2p2TDN1NzUrSW1TZXhQZyt3?=
 =?utf-8?B?bWpNT2w3MzZSVkdvNFZHbTRTYVh3WjI2UndBOUNhLzF3bXViYVZPb1Y0RHhW?=
 =?utf-8?B?M3lFSmp2RWYzRExCVVZRSFREenkvd0JFdlQvS2JFYmNoc3hEdmd4Qk9JTjFk?=
 =?utf-8?B?VHdjN0I1U2lHbmJaY0w5Q3FMUVhIZnN6Z0V4RE10S3ZpdnVIbmVwWkJNOUpm?=
 =?utf-8?B?VFpSYzAvaXZZaVRRT01qQm5aSmVoN1FjM24vd0prTHozUXBPNlVQb3hDKzR1?=
 =?utf-8?B?Q3Y4RG4xdDY2dERlQ2ZsNm1RRHRVTmRJc1RuS3NFQ24rOUJXem1HZjNOejRr?=
 =?utf-8?B?YUp4Z1A2bm5UQ3dJTUwrRTRqNVI3SzhyRzZSTVpRV2NaRXYwc1BnTDVxSUxx?=
 =?utf-8?B?ZHhwOUpEVDdnOERpaXVMRVZzTnNWZlgwbVhKUjU5Uk5ROS9yUFduRW52cTl3?=
 =?utf-8?B?bjF3YkpDK0x5aU5aT0VpbXNscVB0WmlCTzFCOWdMNlkraFdjbFZNSHlneVFY?=
 =?utf-8?B?QmFKNXBydHoyQzZaTmJJWTVsVTRwNzV5d3Fud2c4VE1ydEYrbVYzdlp2L01x?=
 =?utf-8?B?amFrdlgzaDMxb292dTU4OCtPNjNCeTZ6L0dhNnAwdWVDak9ORUNETHR1dElS?=
 =?utf-8?B?VXVnWG1kdGNhRlZMTzJhL0NOTVlENnN6T2FRYUU2SmNtTExRVExUclppSlpP?=
 =?utf-8?B?Vmt5YjNuMU1OSUlEVk0rMzYzdGZyZzdpZHRsaHBIK3BKeVhKVkkwQXVOa3ox?=
 =?utf-8?B?enEvUmdZZ3h0cElHT1B6TXcxdlNtRFJ4WlBnYU92YlIwdGZUdzIwU3lTUStp?=
 =?utf-8?B?OUxJK0tseTBFVXJDRVZzYTN3Y1hSemRUUjNhd1JORDVrYWc2c3dSWjJkMkdp?=
 =?utf-8?B?YnNiTm5VTnViN3FuaTVxQldqTk5DMHhQWlprV2pxL2N6bnpMOUtCVDBJVjIy?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4677185d-3539-4ebc-5269-08dd7ebabc23
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 20:51:04.4554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKNtwRbTjMdWtn4VR9X8I45orztLL11DcVyRSTtvuAowfVHRZYeG8H7AFNjasHjKlbmVwXvKLiHViXV4aEClehoV/fKuoLugNO6QOkIuRtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4635
X-OriginatorOrg: intel.com

On 4/10/2025 12:24 AM, Chao Gao wrote:
> Remove @perm from the guest pseudo FPU container. The field is
> initialized during allocation and never used later.
> 
> Rename fpu_init_guest_permissions() to show that its sole purpose is to
> lock down guest permissions.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>

This patch appears to be new in V3, as I can see from the diff here:

https://github.com/ChangSeokBae/kernel/compare/xstate-scet-chao-v2...xstate-scet-chao-v3

However, I don’t see any relevant comment from Maxim on your V2 series. 
Unlike patch 1, this one doesn’t include a URL referencing the 
suggestion either -- so I suspect the Suggested-by tag might be incorrect.
> @@ -255,7 +252,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>   	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
>   		gfpu->uabi_size = fpu_user_cfg.default_size;
>   
> -	fpu_init_guest_permissions(gfpu);
> +	fpu_lock_guest_permissions();

As a future improvement, you might consider updating this to:

     if (xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED)
         fpu_lock_guest_permissions();

Or, embed the check inside fpu_lock_guest_permissions():

     if (xstate_get_guest_group_perm() & FPU_GUEST_PERM_LOCKED)
         return;

But for this patch itself, the change looks good to me. Please feel free 
to add my tag:

     Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

Thanks,
Chang

