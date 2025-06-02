Return-Path: <kvm+bounces-48186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60114ACBB5A
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 21:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D16DD1760F5
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 19:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C812253FE;
	Mon,  2 Jun 2025 19:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TM68QHcL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081E9DDAB;
	Mon,  2 Jun 2025 19:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748891584; cv=fail; b=kHPOrH4sS9G33uBoUUsxG8j5Wu0ON+XjHPfK8V2O+oCSUMLj7fesMcd6izO4JTI96DG7uM5zy3Mhts+RSlyNVK44SsSKHZyUYa3anin05CpkmYQC7ClVgxOJ9YINDq+0Lsp1Tb+vHGi0pFjf27Ph+YHaBqv4wgERBejtykcYdH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748891584; c=relaxed/simple;
	bh=WAcdIxn851zkz+e8lOxoxnkATWKgLX1B5GZHgjPNSY8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cXXBMc+rBh5crjufoYHTNw9Pwez5GGCD0NcOn6v99KXFSmzPunqHjQIKxMEXVWdWdVNFXYi57r4yX9lDDgxF+t2BGX2Rsm2tiZstjB2S/UGdb5u/nFYuO68nSnaLFg5Un1MYKDiYFa2BXsMuAmyPuC/SFv1ybkAfgtgoLqpL2vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TM68QHcL; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748891582; x=1780427582;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WAcdIxn851zkz+e8lOxoxnkATWKgLX1B5GZHgjPNSY8=;
  b=TM68QHcLVtfQl+okQbs77t7uF9rzJWpK2W8m79+XK5p5pqsMY1ZGeOvo
   KOcApY7iqMq5vjBXPqpBPH7mvDH5BdJVBst4nr/WnmDOPWr1XbHCSn8qx
   7TtodRtbr9UV7Rs2HFuM2H7FlQOabFT9O8pmf1dVjsSdSNl1XYKGgHPTl
   bQxdlHR7//PuN7jlS+gz9Uaa8zx6Kwd8UMgHoGXz1PsJXz92LOEabDDZW
   QfIU1Y0kA9xDqd2OoMgKnNBT5rIKcQ4b4q1RtpzSOedN+4nhNM7Z+tov0
   R9ge377RyAjZXEEuCVdIZ2ziMbDlWra5QLb7nJjwMOdRw3sEStP9+lGTF
   A==;
X-CSE-ConnectionGUID: fq/mvSWlRpmkCos+RRELwA==
X-CSE-MsgGUID: OfVqozRaQbmm8kGQxY8mxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="50828636"
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="50828636"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 12:13:00 -0700
X-CSE-ConnectionGUID: S1IFaZ9MQpuxDAaK2ehJdw==
X-CSE-MsgGUID: y82H4+mGS2mTlfCVyZSh/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,204,1744095600"; 
   d="scan'208";a="149897694"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 12:12:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 12:12:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 12:12:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.65)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 12:12:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/9OrWRAO33zuh8WApZ9wNAUvc/a621Zc0Ah9wbNpFSwJNVIBQh75M3nzbICli8zj4cVBIxheJjVCrP9tsDbnIxnq7I3nOvV0ihgE+6jWZOoukkAVop0GoJCQehl1aXrtNf0yIZ6OfcUBmlXTsF38ZuF0Ufwd35vinqhPTVvCVHwHKPPZh3wmA9q+4KuK/Ln/68ycDiwfadCs6UpL24MNkHtS90/xSiGRewDFwRXa0plQSKvFiuJkZtaLoAEmrZwFBA8CCcoKo4rGV2ttmiOSpvzUpmRjSA+bpVy3CCtmQ2DWXJGLEamPXr0zbztZ3vABm+OEFsQiR2ioMgLErY+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hx4laB9823YjXcFKaGXmpyFlC8BUZ9Wp2xG6ve8KXZM=;
 b=ay+rsTdfAgxHAgRl0Ihcl0G2VshwNKzcR44Q8PftANdn/6B7fRUuqNxbfMWgJGD6HOnZ/aMWnbRrBg0/j4x0RSwmq6AfL+StOjgD7oWVAfbYj2JBW06ls1ZYycVYPHucVPFtHt6uXkoQaepQsdV+13/EbPCZWfdwOAnW9jqa4N0qCm8BX0bItII03mmi215NES9cOt4/W0E9Fr/wv95mDf+4fT/qGoaiThTUNO9RzHpqO1y1SyD9fkCZS7dxS9k84Qzl6o0oqlDJuft3FyGksyZ6gSUhNMmwKULzypPAC8RhUVV5OLMt1nSn0NsOFKDgNsHatLzAD/xI0ZcRXvsAXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB6448.namprd11.prod.outlook.com (2603:10b6:8:c3::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Mon, 2 Jun 2025 19:12:55 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8769.029; Mon, 2 Jun 2025
 19:12:55 +0000
Message-ID: <434810d9-1b36-496d-a10d-41c6c068375e@intel.com>
Date: Mon, 2 Jun 2025 12:12:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
To: Chao Gao <chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>
CC: Sean Christopherson <seanjc@google.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers
	<ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, Kees Cook <kees@kernel.org>, Maxim Levitsky
	<mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, Sohil Mehta
	<sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, "Vignesh
 Balasubramanian" <vigbalas@amd.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aDCo_SczQOUaB2rS@google.com>
 <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com> <aDWbctO/RfTGiCg3@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aDWbctO/RfTGiCg3@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e839c7-1854-458b-5994-08dda2097a9d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TEZ4aFdLcWpXR1hXY1ZFZkZBZVlRdnloNXNLbGpKMW9XTXN0M3VoSE5TdWx4?=
 =?utf-8?B?eFlNV2taTlFIMUpzVW40VDgvcENqZTJmNWVQQWt4TEN1b1IwWEpEZWZTN25r?=
 =?utf-8?B?bGE3M0Npc3JrNXl5OWJHU3h5MHRRWS81WWJBTVhTcmJhNEowS2dLdmF3N3k0?=
 =?utf-8?B?WlBqTkxaczNHSVBmR2VXY3kraDc4cVB4bHhHeFhqNm52ZmJaUGhtdjlaTTI3?=
 =?utf-8?B?MkczUi9md2Y1cVNmYTBLRDVxVGtMNVRIOVJkcktzS2RVeHZpdk5hR25kMWc4?=
 =?utf-8?B?a0pTVTdSWVJyZnE2eEsxRTNrR0pRWTZPVXhIcTdUOXBnK0haek1aMmpMTGx5?=
 =?utf-8?B?eDNpKy93NFVoKzhlZlhLRFE5Ly96a0RKYXRjZ3o3bGh2RTRlT1VLOEkrbnRo?=
 =?utf-8?B?NDlQNGdhNUpuWmphcWtmZE9xK1Fsb3RLVVMyWVJmVzJrVmkwOWNlNUFDcmw5?=
 =?utf-8?B?YnpqU0szSHlHWTR3YklRVTFWOG1OdForM2ZkN2krckcyN2QzRmhjVjFKeSt2?=
 =?utf-8?B?U0N0SWMraWJFUkNnY0VTWmdCTXE0WnhMNFFSblk4MkhRMmV5eHRUSHI0TSth?=
 =?utf-8?B?Z1NVZGxSWXhPMTlrUzY4M1Rna0FQQXE5MmxMbXpEWnYzWXhTMDRyVFZLYTZp?=
 =?utf-8?B?eEpialp1cDd2M3c4azVzU3E1VDBlK1lOUXVualh3bXIvb1pRZ3dLTTJRZ2Vw?=
 =?utf-8?B?VDFVWGhmUDlaWmsvUEZlbzU1N0pJRlB2RElmRWp4VmJpSlBzTndtRHAvTVZV?=
 =?utf-8?B?OG1aYU5aaG1TQ3ZnUFNYczFzMXQvZnpEZHdqcG9pbnhTSy9MMFJwWTcvdGRt?=
 =?utf-8?B?VzZJbExRcHRXRlNsV2VMbXBIQjZOYW44QlNJQk5hQjhCenc1SEw0QUNTaGJ0?=
 =?utf-8?B?R1UrNE5ubHpkNUhhVFczZllGYVl2S0p4NWlrbk81MHhtdkE3S2d5Z0xiMEtP?=
 =?utf-8?B?amlYNHpwbCs4OHR3Vk1IWU1XRHIxTXBlNnhNUDZpSm9FbVViQ1h4Nm1aYzFX?=
 =?utf-8?B?NklrdmpDWkhDUkZpTnFxRkR2S2hJazN0L3pBdG1OdHQ1Q3BHZWxVY1E1VWZW?=
 =?utf-8?B?NzNjaUJHQlZVcHhyWjlSZXVaa1Z3aSt6TGliOC92YmYxSjJRQ2VGNktIaFE2?=
 =?utf-8?B?L2ZNT2diNGF3VHRFR3krMEN3ZjJlOHFNbkpvMm9BekJiY1AxZkJYeXBEWC9w?=
 =?utf-8?B?alhRQjdnMGZBaDJOZFM0UlBVcmJvaHJZa0o1c2x5QzlvUzhyZk9rWXRqYkND?=
 =?utf-8?B?UVRCeUc5RWwyVngxZkh6WTNrWmpNckprUjhDNTNGdWhlWDlKVW1pRlYvOW03?=
 =?utf-8?B?WnNkUlBYM1J3d0lkR25zWWdqZHRpZlp5T0F6bmNZK0lnQ1ZuK212aDc4TTVw?=
 =?utf-8?B?NWppYmxsR0VTRVpKditBbnVFVklOVzVqNmlxSVlyZWFhN0ozUEtFRkFqMlR1?=
 =?utf-8?B?NGZxRldKdk9vZldDbzB1ODdlaDQwaC9OYlpJZEJwL09nLzU3dmlvdklGa0lp?=
 =?utf-8?B?dmJhUEdmQ0xVejhUc0F5Y3JENFhGUUoxM3B6SHUzTXVRQkh3ZytQK1l1TUxa?=
 =?utf-8?B?aHcxNXRwQUxDTXNMc3BjTnR6S0xJRGZHU1htOUdJVEV5by9jVmxjbkkwdkUy?=
 =?utf-8?B?UlhMcXFEdE8ybkFpRWY1WEd5MGNQQkw5V1RmOXViam5sVUs4UjdiYTZ1S2lT?=
 =?utf-8?B?OU1JamFkajFKRGRYSVdzaUIxaG12U3FrckcvVVBiZXRnblNZdGk4QnZWM3Bh?=
 =?utf-8?B?bFk4QXhiS3dIa004NUVKSzcxS0tPZit3alo2TjVHY3kxOGNDQWZhaW14eXky?=
 =?utf-8?B?WXFHcGtRRmxId24zc1J1dTZKUldIcEhKWVhPemNIRGNyRU1oRm41MlNSZ0wr?=
 =?utf-8?B?QkpOUVRIUWRnRnZvNzJEcW54ZmNhMHZwdTJ6ejVxNDZmbldIc1FHeCtWT1ht?=
 =?utf-8?Q?zGgYqynLhww=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHQ4Y1JIbzc1bEZiVEl0T2MxRXh6M3c4QkZSOUVYYnFaeGd6RHQ1TkkxWTFL?=
 =?utf-8?B?eXcyU2JNbzgwVTR5MEtHbFJMUW1JbEtIaG9GL3NIWXA4R0s4UDN1T0h0STJt?=
 =?utf-8?B?eFdrYzBRS1c2N0RWQzE4cmJRVGgxRzZYUjUrZDV6OXVWbE0yMVRHOUgweWdU?=
 =?utf-8?B?VjBOaVE0NDlSZkVTUTNManB5REVMaWRRV3ZqY3BwMGRxczJrNGpzRDRBMUlR?=
 =?utf-8?B?T0xOM2RRTmQ0V0VobkttNmhvZkxxd0xmdWEzQmtpcW5lQkVCQzcySHd0T1BI?=
 =?utf-8?B?SE5PdjRZTmRxanlLTURjVGt6VjhGTEJiQm9VNDJzYUdGVlF0WHF5VDlQZnhP?=
 =?utf-8?B?dVRHd2sraURQUHJ4K1ZxeHltOHV5U01veW84WGlzOUdkT1J0bG9ER0g4MkRO?=
 =?utf-8?B?RGJobnZnVWNmazBQNHFMTjJ0b0xOM1ZrRFc0NnBMVmdXdTBzQ3VaQzU1YmdY?=
 =?utf-8?B?Yk5Hbk5jazhWekdZRFlXaVFXMHgzV2t4V0M3TFJKeTVzUnFQOUhqWDhucytV?=
 =?utf-8?B?bFNZbkxXSy9NWUNzUWpaVFlISk9sZHowditmZXZKbHFzNzZNUlVqaEJWbkhZ?=
 =?utf-8?B?NEo3ODZmUnVMNjFrU0NjU08xWmZUaUN2ejZOQTZwSXBKdklzZXMvdlBMNVZJ?=
 =?utf-8?B?Z0FCaUxvWVhha0tCTk9aamxoL3I4eE4xMDgyOVNrT3NaRlhmK1Z0NVo5cVFU?=
 =?utf-8?B?eHdmcmhzZjZwbUdrcDY5ZzRJZlhMSDZYYmRpbEdvcEl5VXVzNVgzQlNGMmRS?=
 =?utf-8?B?S21zdUU5VThIWHhPbGpSY1FIdmtwTG1FWS9nVUpDUzBQemtEUGhoR1lpdSta?=
 =?utf-8?B?bUUwZWNQQXJYU3EyZmdoU3NkN1c4VEtGTGsvTFZnekxUWXN2azlFWUpVV2JD?=
 =?utf-8?B?bTYrRGRDUUgvcTFDaVVtR2tDWmNPU3ZnSXlacDRFTWpKRlRneFhjcXZYNFNN?=
 =?utf-8?B?WG5MdWZrZ3JNaU5ES29DOXRtdVd4d2xyZjl0WjJSV2N2YlovVnFnNUZCZkkz?=
 =?utf-8?B?bmxOWms4YmNxSG1QNEtjbW45ZFN5TGxwdmpBWU9zZE9NcFdnbk9jTnEzYWlj?=
 =?utf-8?B?Y0x0UFl1Zmxpc1lPODhZYzhXNFgyVW1YL2gzaXZVRjgyVjhLRFFlQnN3QmE1?=
 =?utf-8?B?ejhVeThJd054VitCUGRVTjlHTlFpU1FKd1Z2eUxHdmo0WkJCRnV6M3ZqaTJT?=
 =?utf-8?B?QzZiOVluNDFsL1VucVdVQ3V5bG5PK0pPVERXN3VJaGVDT0E4dG9Hb01yUmlX?=
 =?utf-8?B?dm1vRFR2bnVzUGZhek03L0VscXJvZUt4bCtJSXBiNys4aVlSUHBiektOMTF2?=
 =?utf-8?B?YTROVit2OTBpMTFGa2QySCtMRmErcWdFNGZYMm51bDUybXVqamR1QXFmenE1?=
 =?utf-8?B?NmdSZFcxeElPbjVjUkJOTjJOeENvN2NDNGhJNXpjQ2EzOUFIdlVvZXpvSU4y?=
 =?utf-8?B?ODEyWjV4VGp3VElIdkl1ekRzNkJtY1NyMWNnZ2lHaGZGNFFHYkZrQmc5ZXdq?=
 =?utf-8?B?empteFNqWGFHL293WXZSaWtqMTNEUzhjTFF4VWZFbjhBSTlNb2RHdzJwenlr?=
 =?utf-8?B?U2NhVE9WWGtyYXZrTTdPVmRHTDVJM2NmZWJRcUw5b2FsV0h4ZEhiVENBekN0?=
 =?utf-8?B?cmw1YjJPeHN5bk1rbWxHVVRPTTliZG5JeU0yR2pIU25Hazl3OVpzdVc2TUls?=
 =?utf-8?B?UENkdVBTQWVlczJJV2llbWhKTUVXZUkzQzlGVHh6YUdEeXQ5cklaaHM2WlRh?=
 =?utf-8?B?aGZqbzZ5VG9adzJHNjhYekpkaWRXMHZoRWoydWVWNE5vajQwVEdwcXp4bW1Y?=
 =?utf-8?B?REZ6ODhiQzRCTzk4WVhWb1B2bWxncWlXNU5wSkgxcEpjR0xyMUo3cDRXaUJo?=
 =?utf-8?B?THEyWEQxbVo2c3FVaWFxaTQxS2VpRlBleUNkK2ltUW5WS1kxOG44Nngya2FE?=
 =?utf-8?B?blBZbUtCZnRoUXFCemJVRW8xYTVFaFlzMUdER00zM2dHaTlkdDRuU1BqY2dP?=
 =?utf-8?B?ZEdsMXlaazNtUDFHTWpWQ3FKejFwSnVxYllmMXVQK08zdHpJc1ZkT1UvZFQy?=
 =?utf-8?B?V1hsWnVpMG9La3hvMm1pUGtqeVMvYW1ESUJoRDNPU00wZmpZRmFoY3I4dHpk?=
 =?utf-8?B?aUJub004TVV4ZE5uTHcvd3RyNTd3N2JZSkppR0EzNFEyWGlkNi94Nm5QYjRx?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e839c7-1854-458b-5994-08dda2097a9d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:12:55.5390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FbvnGSNQsqxJezwj6o21D9oRLkjKO6cn2nxP9h1ZjsgwRYSwf/+1A6hFntk5QC+mPqDypghPdaQsVnsV8wVLqoY4hP7mieRdAEVB3pCy7IM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6448
X-OriginatorOrg: intel.com

On 5/27/2025 4:01 AM, Chao Gao wrote:
> 
> *: https://lore.kernel.org/all/88cb75d3-01b9-38ea-e29f-b8fefb548573@intel.com/
> 
> The issue arises because the XFD MSR retains the value (i.e., 0, indicating
> AMX enabled) from the previous process, while both the passed-in fpstate
> (init_fpstate) and the current fpstate have AMX disabled.
> 
> To reproduce this issue, compile the kernel with CONFIG_PREEMPT=y, apply the
> attached diff to the amx selftest and run:
> 
> # numactl -C 1 ./tools/testing/selftests/x86/amx_64
> 
> diff --git a/tools/testing/selftests/x86/amx.c b/tools/testing/selftests/x86/amx.c
> index 40769c16de1b..4d533d1a530d 100644
> --- a/tools/testing/selftests/x86/amx.c
> +++ b/tools/testing/selftests/x86/amx.c
> @@ -430,6 +430,10 @@ static inline void validate_tiledata_regs_changed(struct xsave_buffer *xbuf)
> 		fatal_error("TILEDATA registers did not change");
>   }
>   
> +static void dummy_handler(int sig)
> +{
> +}
> +
>   /* tiledata inheritance test */
>   
>   static void test_fork(void)
> @@ -444,6 +448,10 @@ static void test_fork(void)
> 		/* fork() succeeded.  Now in the parent. */
> 		int status;
>   
> +		req_xtiledata_perm();
> +		load_rand_tiledata(stashed_xsave);
> +		while(1);
> +
> 		wait(&status);
> 		if (!WIFEXITED(status) || WEXITSTATUS(status))
> 			fatal_error("fork test child");
> @@ -452,7 +460,9 @@ static void test_fork(void)
> 	/* fork() succeeded.  Now in the child. */
> 	printf("[RUN]\tCheck tile data inheritance.\n\tBefore fork(), load tiledata\n");
>   
> -	load_rand_tiledata(stashed_xsave);
> +	signal(SIGSEGV, dummy_handler);
> +	while(1)
> +		raise(SIGSEGV);
>   
> 	grandchild = fork();
> 	if (grandchild < 0) {
> @@ -500,9 +510,6 @@ int main(void)
>   
> 	test_dynamic_state();
>   
> -	/* Request permission for the following tests */
> -	req_xtiledata_perm();
> -
> 	test_fork();
>   
> 	/*

The test case creates two processes -- the first uses AMX (task #1), and 
the other continuously sends signals without using AMX (task #2).

This leads to task #2 being preempted by task #1.

This behavior aligns with Sean’s report. From my investigation, the 
issue appears to have existed for quite some time and is not related to 
the changes in this series.

Here’s a summary of my findings:

== Preempt Case ==

To illustrate how the XFD MSR state becomes incorrect in this scenario:

  task #1 (fpstate->xfd=0)  task #2 (fpstate->xfd=0x80000)
  ========================  ==============================
                            handle_signal()
                            -> setup_rt_frame()
                               -> get_siframe()
                                  -> copy_fpstate_to_sigframe()
                                     -> fpregs_unlock()
                                  ...
   ...
   switch_fpu_return()
   -> fpregs_restore_userregs()
      -> restore_fpregs_from_fpstate()
         -> xfd_write_state()
            ^ IA32_XFD_MSR = 0
   ...
                                  ...
                               -> fpu__clear_user_states()
                                  -> fpregs_lock()
                                  -> restore_fpregs_from_init_fpstate()
                                     -> os_rstor()
                                        -> xfd_validate_state()
                                           ^ IA32_XFD_MSR != fpstate->xfd
                                  -> fpregs_mark_active()
                                  -> fpregs_unlock()

Since fpu__clear_user_states() marks the FPU state as valid in the end, 
an XFD MSR sync-up was clearly missing.

== Return-to-Userspace Path ==

Both tasks at that moment are on the return-to-userspace path, but at 
different points in IRQ state:

   * task #2 is inside handle_signal() and already re-enabled IRQs.
   * task #1 is after IRQ is disabled again when calling
     switch_fpu_return().

   local_irq_disable_exit_to_user()
   exit_to_user_mode_prepare()
   -> exit_to_user_mode_loop()
      -> local_irq_enable_exit_to_user()
         -> arch_do_signal_or_restart()
            -> handle_signal()
      -> local_irq_disable_exit_to_user()
   -> arch_exit_user_mode_prepare()
      -> arch_exit_work()
         -> switch_fpu_return()

This implies that fpregs_lock()/fpregs_unlock() is necessary inside 
handle_signal() when XSAVE instructions are invoked.

But, it should be okay for switch_fpu_return() to call 
fpregs_restore_userregs() without fpregs_lock().

== XFD Sanity Checker ==

The XFD sanity checker -- xfd_op_valid() -- correctly caught this issue 
in the test case. However, it may have a false negative when AMX usage 
was flipped between the two tasks.

Despite that, I don't think extending its coverage is worthwhile, as it 
would complicate the logic. The current logic and documentation seem 
sound.

== Fix Consideration ==

I think the fix is straightforward: resynchronize the IA32_XFD MSR in 
fpu__clear_user_states().

The existing xfd_update_state() function is self-contained and already 
performs feature checks and conditional MSR updates. Thus, it is not 
necessary to check the TIF_NEED_FPU_LOAD flag for this.

On the other hand, the sigreturn path already performs the XFD resync 
introduced by this commit:

   672365477ae8a ("x86/fpu: Update XFD state where required")

But I think that change was supposed to cover _both_ signal return and 
signal delivery paths. Sorry, it seems I had overlooked the latter
before.

Thanks,
Chang

