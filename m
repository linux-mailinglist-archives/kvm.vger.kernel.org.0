Return-Path: <kvm+bounces-42172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DF5A74835
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 11:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14026189C0B7
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 10:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AEE821A94D;
	Fri, 28 Mar 2025 10:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dyEgpKqC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D608F49;
	Fri, 28 Mar 2025 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743157611; cv=fail; b=bdX+NUBwarBIA8ogRjY570l8XPLhq3a4LQIW6wWwxYUzfXHD1ZzUP7SJqJyq4JxLdHFrYGas4zqSUi06xUaIAp69L/D8vqBv14eedf/TpZvWQd7HN4iAwNcByTaUCEBE43zN2/OppuNU/54qTq5txyyYPrTO9n+6YYthMo+Xn8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743157611; c=relaxed/simple;
	bh=XQ6BwFZSon0r7pEA/M1LrOHJP8WnA6gbwNkQWWahSI8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pIga9sX5IYhKMBUlN/N102q7LCheDK8lDGKI4NjWmUJ//iMnAWSKOLo0jRQSMuGeJsbP9siYhVmIiaxa5S7giReRrCZ8WjWoGkaABZqDTG4qE9ig3G1sMBp5GoDbT0QCtO9fqaQlPSZYwnejkUxmmFDfoO26xpqkcnYwZPHGJ/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dyEgpKqC; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743157609; x=1774693609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQ6BwFZSon0r7pEA/M1LrOHJP8WnA6gbwNkQWWahSI8=;
  b=dyEgpKqCqcT7hgN5nrL2EsT3/+hLJnA+O3KdLcB/7ZIHGfsDule4knlt
   TLFfUkTqYaa0B5UVhlfu6dBuCF4AAx0vqJcK9JeyTOJDiYlMm0YmPLJ5C
   Xs1NX02lDjFMupcqyd/LDqlqnD8nBpBHFQB9GdhSdG67Oo5sY8UY9OAG2
   HbltUe0uH6LVBtmn88376ueCLCFcfGoI0uuNXnRvbPRMlHDy81gfjT6di
   p8thiHv2aHP2uosWa+zcXnZ7wI7A+P4GFVIhO1VooXgMvotHFupwk1jVN
   K/rCQ/hVZU08+/vTEF1OpzSRq4lHxunvMhhb1R8YhvXhwXtHFuAlBzZel
   Q==;
X-CSE-ConnectionGUID: v/TKTvVUSCSYAnGMWsptUQ==
X-CSE-MsgGUID: 5iFWnTQYQzyfmDqaXT31Ag==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44697553"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="44697553"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 03:26:47 -0700
X-CSE-ConnectionGUID: WSukf++TSfiAULSHpdErIw==
X-CSE-MsgGUID: EUYNVHA+RSm+yTNytdIvJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="125400737"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 03:26:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 28 Mar 2025 03:26:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 28 Mar 2025 03:26:46 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Mar 2025 03:26:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vb333LhAOqHKTmrQZgSgsfjtyBWq5KZsMP+cCnGNnkDVYFykEj6dtEwwVhGVsk/LObE0vNMtr7L5ZHStybTyeAYiKEPty1bE20XzgaTmTJ6ETwsoYAS8uwKRVXIn5XpwWm3B7ysJU0h29/c01GNdew8BEdkL02nMnKWXZMCF5WV0tRuYec6YGvVZSgitKtc9N8ug5DtBXG6e6iYtWPxtJuDfS6RjwSYhwUS0PeVb+3H0e845v0Wl/YuS8NWfYQv9BMdUubXrrCI6fnu3My3F19EcjUEXXZBj9E5QbYwIMcPeOnnS48gMK0XqXBWf2nvoI+IhaqZprwVtLBQf/nNJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/I8weqmbyGsZzkr8tnYgC6J6hx5/fwOzyNNVnlcpPg=;
 b=BgnQe/Q6Xcx/xCTPKn8dN+lJsfbC59/z/+k4Znd7EbcVBy31ZO2JSqDpysSVAypEfYpATKRPgd788guQNMf57saordPp9NayAEnzVwjzeYRRNCFvzN5/4q0IuMljvTZG48xsNrsbihtKDMY3ypFL5dcKPFeR/gTTUar+4leyTQucm++YJSB8++RKQ74WOQhfHkMTZTAzeqVmo3/8lJcRe6SpHNoCeKdmG9Ni+hbHFn/PfBP+shXTGUjBCuphT6lIQhWsFEw7QDQr3hsCe1VnEw9lU5lnxHncZJNSP2DR+PNy02Y0ILumCkB2Xya1IrYG67D2hOfZ4Y48Zj4Cq4I8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 10:26:29 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 10:26:29 +0000
Message-ID: <d7e220ab-3000-408b-9dd6-0e7ee06d79ec@intel.com>
Date: Fri, 28 Mar 2025 12:26:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <Z-V0qyTn2bXdrPF7@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z-V0qyTn2bXdrPF7@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: WA1P291CA0002.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:19::26) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|SJ2PR11MB8587:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a7cb458-7897-461a-8a32-08dd6de30039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VzRJZk5qY3Fiem55N0tlK3AyNThna29McEd5d3g2UlhOVnlJcTMvam9JSXUw?=
 =?utf-8?B?cGNlK040RzR1MFlVdnloQWJaSktrbnE0bHNyM3VDcVJJNG1Pa214ZmNHbFRM?=
 =?utf-8?B?R05DNks1VzhHTVBlMFVsZXp6QnI3T2k4cnl0UWxpVmI1WVNVcHlqMVVkOFF4?=
 =?utf-8?B?Z1pqbi9GVFVSS1pvdVpnT1czcTdSdGtmYTdYMm5JWkpEM1NqUmRIanVuaDlR?=
 =?utf-8?B?OFFwODJldWlXZ2I5WXRQeVVBZlFXTUZwUGpJSHR4OEZXMWlGNlAxam5Mc1Nm?=
 =?utf-8?B?OTJZeXZEN2NucnBUaGF5V082Z0M2aHlkajhoNzdHMVhpREFCSG5GaFhGQ0dH?=
 =?utf-8?B?cVM0S1Q3S2pJUk8yWXVjSTZrdXFPU1FxZnhiSnhQdEdoVGJ3QnRkWk0yRkg2?=
 =?utf-8?B?M0R5Wmg2aWM5QzdGVE5NUy9zTE1TMEhoaDVjT3JBRkRKZURRbGpkSkVYTElr?=
 =?utf-8?B?OUVsK2NLRDV3M2duYXQ4Y1RrMTRHK0JadklrMkFWY0pSR1BGMzF1Rmt2TnM3?=
 =?utf-8?B?MWJJb3pjM1ljeG5iOEg4b3pZSW1PQTJzTDU0SVdKRnZNdE15QnpmZXdjMlNp?=
 =?utf-8?B?QjMvUGwyT1YvVWo1RVBNb0ZlcjlmNkFnbjNWL3pDb1RKaWdBNVRjZW5yWXRz?=
 =?utf-8?B?eG5nV1BacUw4N044WjIzUXFkc29tU01Lb3ppQ1FZclY5c2VnL2R4OE9vZ3JK?=
 =?utf-8?B?S25SU3F0MFZHSmJROFRWa2hHTEVyWkY1eC8vcTZ2YVplMlNJZEpnSzNINGN3?=
 =?utf-8?B?dE5OVUV2RndXR3MrSEg5dHpJL0FVcjZRS3J0MEtoTHFUWG91WU1FbEFzWVJV?=
 =?utf-8?B?QWpHWDBpRUVxUEZ3ZXF5cDlxU29jMFcyYzJHSHRMZ092b0V6TFBlWEpZeCtZ?=
 =?utf-8?B?RndWRW1YWHZNeDlZWkFUa3dDUGJ1ZkNpVW81dU51dHE5clZqNlY0Um9JSExN?=
 =?utf-8?B?dWFvNHdmeDgvK3JNVzlaSmVoWEJTMDY3TVJ5a2c0ZWRnNnZtWXkvZlBYYWR5?=
 =?utf-8?B?MjJRV1lmNzhYckNuYzlUMnRMdEZxaEdCaG05QXRnRHIvcDVLd2pmS0J1cmVU?=
 =?utf-8?B?K1dRcDYzaER4cHB0aklWODA4RUNjUEhLeFRwVk5kcUpEcTFhd0lSaGd1c2p6?=
 =?utf-8?B?ZUFocHdMZ3RJcjNzL0l5WnVSclJId1U2U3RERElmK1NaMEJyV0loZTFWcFhL?=
 =?utf-8?B?TU13VnRrQjFIMTdaNy9QYXNhSVJmMjZoekkweFBsblc3YVppajh6OHZWT1Jr?=
 =?utf-8?B?Y2szOFA5dE14SENZTmZmclFTeHdkakRBeVI0L0dXdVpJcmtkV2grZ3hyYlo4?=
 =?utf-8?B?ald1REFnbXFsMFpQS1lwSVpYMUw4UDgrLzN1aGRrcnc1M0gwOTl6Y3BLZ3h4?=
 =?utf-8?B?eWtpTVprMk5mdGVDeDZwNzhOTElVSFVzU3BuR1F4WGRCVnozenFTUndtNnBD?=
 =?utf-8?B?eEpLeXZhRWE3YjJJZ1NhZk5HL0FyeDN4cTF1WkJoelRzUTUxejlFREFaUkhH?=
 =?utf-8?B?QldlZmNRdnVzZHdQZUFBZ05UWEdFU3dhUjY1YW5WbUtrR2pQeVF1UTFudThq?=
 =?utf-8?B?NzJwTWNsV1hVUGVCREJteVRZdnZYTWczcG1jOFFXMGI5cXJjUkhWTlorWHJh?=
 =?utf-8?B?TGhabTRmSllFSjdrNW5qb2xCT0taZ25Ma0libVlFbTFkK24vQ3loQURQVGZh?=
 =?utf-8?B?Vnkzcnk3ZzlpaE10UFB2RDlLaFcxK0ZRc3ovVGNuNnY4RDYzSCtlcHA3QjFG?=
 =?utf-8?B?L1ZteUJWMkpRcE41aHdWOW1UdGtRZjJIcFpVVlVsMS9HbEJSQUh3ays4NUN1?=
 =?utf-8?B?QXJHMWtIN1dlU3hyRkJ4UmswZEVzWWE0VjNVWkIvQnJTNFZ6aUt4eFkydi9S?=
 =?utf-8?Q?5kPYdUvGN0k49?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlBndXRYeDhycytXRno1ZFlBR0VIdGRjdVQxR0dXcnZRMmUvWVoxMVRkS2lY?=
 =?utf-8?B?b3hBQTZzbjZPMktqOWttZkJyM2k1SHRUVWY2RDJxM25TYjlPZTZHSmhHM1pk?=
 =?utf-8?B?citjeTZXemoyYVA1Znl2QmZmbDR5a3lKMnpONE14WHUxU250dmxqbHl4Wndt?=
 =?utf-8?B?dWFicUdKenVPK2xrUlhSQ2plTDRaZ2lyZmlpWVpvUXg0SEVVZFZhOVo4RGRx?=
 =?utf-8?B?UUc2cENabFFBbTd6KzZYQXNkeE1PR21LKzBLbFNKeTluU3R3TXVzbUc2b2tp?=
 =?utf-8?B?NmptUWtqeEVwUXFoMERQcFFyc0NkRjBESHY4YnkwcVVpQXJoMG5mWG14blFk?=
 =?utf-8?B?bjdaeE13Z2dTZGIxem4vdXBwcmZ1dm9ZbEhDemtOSktrUnRDVDNxbjRua0l5?=
 =?utf-8?B?NXBTVGkyMnJTTFM1SHdJbndRR0pzSGJZZC90dy9SWEpYOGxZdjY2dmcxdGtk?=
 =?utf-8?B?Q0daMUl0ZDR1VmdtUUR4ZFhUcVI4eTNqeXg1NnRhRFlqUWY0QjZSY3NjSmJR?=
 =?utf-8?B?N2hGQ0NLdVhKL3k1ck1BRU9hSEZjcWtrZERwYVd5b0h4dU54Y3IvMVJ3T3d0?=
 =?utf-8?B?eWoxWXk1Z0pndDVIc29FUVpIYkJsOG5PKzBWRmZvSFF6akMxUGZaUzBNM3Z2?=
 =?utf-8?B?TjA4b05SQ0RhTG12Z2E4REZ2QXRGU3NwRmsyV1FzUVA4YWVuU0RVcHFRQ3Nv?=
 =?utf-8?B?SjhxT3dVK05SbU9nd0k3WkszaUpTNi8zOVE0VU9DWTBMWTNFMlVrdU85WDFw?=
 =?utf-8?B?RFVQWFdYRFQwVkN4VnFIcVZickUvdkZoWE4vWFMya0kwVndqVjhVZmlUaGFO?=
 =?utf-8?B?cE9jY1N0bHljcEpXMUpXL2tEcWdiMmc4eTM0cjZXWVJrMjd2UDI0WGRFOFVX?=
 =?utf-8?B?Y2hPYUZETTE1RXZ4U3ZQT0tYNU9iODlQRW52TnVQWWhVUHplbXZVOVRtYmFS?=
 =?utf-8?B?TjVDcFhOZGx3elNXQUNUM2lRRWhjWDhEaENWL3l2TWhvWTlpcThXVXlJSjBH?=
 =?utf-8?B?b2JFei9FUWlMekhBWStwTUtsU2s4OVBOVFV6LzBUYVRuMllWWUl6M29YblM2?=
 =?utf-8?B?YW14NzdWajI0bW12THUybjZzRkt3QjJHVnlZWGE3VXNZakxnWXdKcUZoSi9R?=
 =?utf-8?B?d0ptOGZZSmhuS1NXelZMRDJycFliVEpLMHVZUEZLMXBLSHJySUY3K0dkYmQ2?=
 =?utf-8?B?SHNkQ3JGeHhLUWdpeUw4c1dmSWhyMkJWR3VJRk5qRGZvTUVuRThHS1kycGFo?=
 =?utf-8?B?cytYQllzU2lIVi9QOUtNcXUrT2JQMUJOR1pFbzVmUDNhWVJoWC9UWEhwWUs0?=
 =?utf-8?B?TGxoOGpTV1JDcHlxY0NkTEUzeWUyN05WYlYvOXByOUJGVWUyTFFYdG1pTVFs?=
 =?utf-8?B?WXBtOXd6eWRPU05SeGh1cS8yWTV5czhVYzQwc1ZDQW9NaFp3QUZPd0RYZWNN?=
 =?utf-8?B?UWEweEdlS25MWDh5T3JVOE92NVhxRTB6NURtMG4wRDJDUDFWTDdnV1pPN2Zt?=
 =?utf-8?B?Y3ZQUCtYbVhZQnpHOTVhMUR4U0tDTzU5U1o5MWpWdFFoenBEM3FydnNweCtB?=
 =?utf-8?B?aDlpR242L1l6cXdFcUJhS25IOEF2cGh0QXpWaTR0L3RVN0ZObHBRT3Z6Njdm?=
 =?utf-8?B?dTA3TUtyd2N0cFRDcGxVUjVQNEVtZHJnT0dwY0QzMkFoRkkxWHBJaU1IejJL?=
 =?utf-8?B?Q2dhaGpWdXk1WmxhTmxDeTBYWU4wSnFvNjVrVThvSi9ic09VV3kzUVpBMTJ4?=
 =?utf-8?B?RUh4TVNldkZqVE50MjdtdThVRmN2cXRYNnljM2NweWw0RmhBRVRxLzQzeE1R?=
 =?utf-8?B?aHJTaExrSjNBdEt4OXF0WW9rYjk2MmlGWXdESUhRamxvbGFPZXpQTncweXdm?=
 =?utf-8?B?czhmak4xTm9lVW1XZkhFWEV0V0RnZlJPQ1M0L2VVRkU1ekdPVVkzb3dORS81?=
 =?utf-8?B?eEFWTTlxOXhHZ25Za0FadXRTSE8vMk1MMk10QXpPcE0zWHhJak5NWU1WQzgw?=
 =?utf-8?B?MW95Vm4xRnd5VzF4V1FDWVBxakliWXZTc2t2cnBPSzNsYkRyQ1JUbHdCd1NJ?=
 =?utf-8?B?MmJDR1BONlIvcFQ4TmZwZS9Dc1VJb1l6T2dIS1ZLbmtreGE0WU0wKzZqWnFR?=
 =?utf-8?B?OXo4VmhPNXZWV1pyNjI4SmR6WFkwRzdEQ1Y1RGx6Sk9xbjlTMFBkU0VQbXpU?=
 =?utf-8?B?eGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7cb458-7897-461a-8a32-08dd6de30039
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 10:26:28.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZcK3mhjuuYJB7EcEJaf8JUcHEbh/aOLXfcE35XDMr8WuXFzxaNHVFznCZveuHsHVn+7ZteJo0LBOBlwNoXSO4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8587
X-OriginatorOrg: intel.com

On 27/03/25 17:54, Sean Christopherson wrote:
> On Thu, Mar 13, 2025, Adrian Hunter wrote:
>> Improve TDX shutdown performance by adding a more efficient shutdown
>> operation at the cost of adding separate branches for the TDX MMU
>> operations for normal runtime and shutdown.  This more efficient method was
>> previously used in earlier versions of the TDX patches, but was removed to
>> simplify the initial upstreaming.  This is an RFC, and still needs a proper
>> upstream commit log. It is intended to be an eventual follow up to base
>> support.
> 
> ...
> 
>> == Options ==
>>
>>   1. Start TD teardown earlier so that when pages are removed,
>>   they can be reclaimed faster.
>>   2. Defer page removal until after TD teardown has started.
>>   3. A combination of 1 and 2.
>>
>> Option 1 is problematic because it means putting the TD into a non-runnable
>> state while it is potentially still active. Also, as mentioned above, Sean
>> effectively NAK'ed it.
> 
> Option 2 is just as gross, arguably even worse.  I NAK'd a flavor of option 1,
> not the base concept of initiating teardown before all references to the VM are
> put.
> 
> AFAICT, nothing outright prevents adding a TDX sub-ioctl to terminate the VM.
> The locking is a bit heinous, but I would prefer heavy locking to deferring
> reclaim and pinning inodes.
> 
> Oh FFS.  This is also an opportunity to cleanup RISC-V's insidious copy-paste of
> ARM.  Because extracting (un)lock_all_vcpus() to common code would have been sooo
> hard.  *sigh*
> 
> Very roughly, something like the below (*completely* untested).

Thank you!  I will give it a test.

> 
> An alternative to taking mmu_lock would be to lock all bound guest_memfds, but I
> think I prefer taking mmu_lock is it's easier to reason about the safety of freeing
> the HKID.  Note, the truncation phase of a PUNCH_HOLE could still run in parallel,
> but that's a-ok.  The only part of PUNCH_HOLE that needs to be blocked is the call
> to kvm_mmu_unmap_gfn_range().
> 
> ---
>  arch/x86/kvm/vmx/tdx.c | 61 ++++++++++++++++++++++++++++++------------
>  1 file changed, 44 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 87f188021cbd..6fb595c272ab 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -472,7 +472,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
>  		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
>  }
>  
> -void tdx_mmu_release_hkid(struct kvm *kvm)
> +static void __tdx_release_hkid(struct kvm *kvm, bool terminate)
>  {
>  	bool packages_allocated, targets_allocated;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -485,10 +485,11 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	if (!is_hkid_assigned(kvm_tdx))
>  		return;
>  
> +	if (KVM_BUG_ON(refcount_read(&kvm->users_count) && !terminate))
> +		return;
> +
>  	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
>  	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> -	cpus_read_lock();
> -
>  	kvm_for_each_vcpu(j, vcpu, kvm)
>  		tdx_flush_vp_on_cpu(vcpu);
>  
> @@ -500,12 +501,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	 */
>  	mutex_lock(&tdx_lock);
>  
> -	/*
> -	 * Releasing HKID is in vm_destroy().
> -	 * After the above flushing vps, there should be no more vCPU
> -	 * associations, as all vCPU fds have been released at this stage.
> -	 */
>  	err = tdh_mng_vpflushdone(&kvm_tdx->td);
> +	/* Uh, what's going on here? */
>  	if (err == TDX_FLUSHVP_NOT_DONE)
>  		goto out;

Looks like it should not be needed.

First introduced here:

	[PATCH v16 071/116] KVM: TDX: handle vcpu migration over logical processor
	https://lore.kernel.org/af6cb5e6abae5a19d6d2eeb452d29a96233e5a44.1697471314.git.isaku.yamahata@intel.com

Explained a bit

	Re: [PATCH v17 071/116] KVM: TDX: handle vcpu migration over logical processor
	https://lore.kernel.org/20231117080804.GF1277973@ls.amr.corp.intel.com

And explained a bit more:

	Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical processor
	https://lore.kernel.org/all/20240415224828.GS3039520@ls.amr.corp.intel.com/

>  	if (KVM_BUG_ON(err, kvm)) {
> @@ -515,6 +512,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  		goto out;
>  	}
>  
> +	write_lock(&kvm->mmu_lock);
>  	for_each_online_cpu(i) {
>  		if (packages_allocated &&
>  		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> @@ -539,14 +537,21 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	} else {
>  		tdx_hkid_free(kvm_tdx);
>  	}
> -
> +	write_unlock(&kvm->mmu_lock);
>  out:
>  	mutex_unlock(&tdx_lock);
> -	cpus_read_unlock();
>  	free_cpumask_var(targets);
>  	free_cpumask_var(packages);
>  }
>  
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	cpus_read_lock();
> +	__tdx_release_hkid(kvm, false);
> +	cpus_read_unlock();
> +}
> +
> +
>  static void tdx_reclaim_td_control_pages(struct kvm *kvm)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1789,13 +1794,10 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  	struct page *page = pfn_to_page(pfn);
>  	int ret;
>  
> -	/*
> -	 * HKID is released after all private pages have been removed, and set
> -	 * before any might be populated. Warn if zapping is attempted when
> -	 * there can't be anything populated in the private EPT.
> -	 */
> -	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -		return -EINVAL;
> +	if (!is_hkid_assigned(to_kvm_tdx(kvm)), kvm) {
> +		WARN_ON_ONCE(!kvm->vm_dead);
> +		return tdx_reclaim_page(pfn_to_page(pfn));
> +	}
>  
>  	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>  	if (ret <= 0)
> @@ -2790,6 +2792,28 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  	return 0;
>  }
>  
> +static int tdx_td_terminate(struct kvm *kvm)
> +{
> +	struct kvm_memory_slot *slot;
> +	struct kvm_memslots *slots;
> +	int bkt;
> +
> +	cpus_read_lock();
> +	guard(mutex)(&kvm->lock);
> +
> +	r = kvm_lock_all_vcpus();
> +	if (r)
> +		goto out;
> +
> +	kvm_vm_dead(kvm);
> +	kvm_unlock_all_vcpus();
> +
> +	__tdx_release_hkid(kvm);
> +out:
> +	cpus_read_unlock();
> +	return r;
> +}
> +
>  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_tdx_cmd tdx_cmd;
> @@ -2805,6 +2829,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
>  	if (tdx_cmd.hw_error)
>  		return -EINVAL;
>  
> +	if (tdx_cmd.id == KVM_TDX_TERMINATE_VM)
> +		return tdx_td_terminate(kvm);
> +
>  	mutex_lock(&kvm->lock);
>  
>  	switch (tdx_cmd.id) {
> 
> base-commit: 2156c3c7d60c5be9c0d9ab1fedccffe3c55a2ca0


