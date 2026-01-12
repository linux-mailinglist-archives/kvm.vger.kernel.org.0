Return-Path: <kvm+bounces-67683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0A4D10461
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 02:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5840630123CC
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 01:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB19224234;
	Mon, 12 Jan 2026 01:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZp07+KN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07EB632;
	Mon, 12 Jan 2026 01:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768182150; cv=fail; b=fCnBWw0btXhtH5shN9s7+q/IVeJGC9wzbN6AONUFAoIqsR1lzDHaUfqA8SmGoREL+5/AJdAExevcyBSC+gEG87WkYNvfURKNpbDzEGVKOdtAY0pGato5b0fZW1n4Lnox3gt3GX+OZGDdgg8kocaSwh2t4OIJ43M4z/w1vA8upLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768182150; c=relaxed/simple;
	bh=uCgKiG53GarcHH5Xaa1h70+YbAIxlGwIfmfnH7SNbqQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B06Bzx5bXEGFFGtrOG1mue4o7x4eLg2CLGOOf0quACdmWawVGNXVDYQnAc7CDcuOlB2oQ/51JeBDTRgnNMBgKYxp7y/tleA2WIloglIUBbwrZYZ2y/rDmSSPLGPxp3J0xOjt2fo9TkmjIsVg+FwpUW2Mln8mbP6gSmKlFwZ1e6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZp07+KN; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768182148; x=1799718148;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=uCgKiG53GarcHH5Xaa1h70+YbAIxlGwIfmfnH7SNbqQ=;
  b=PZp07+KNm5qEJx9HVXOvkxkrY/G5XylDcZbFrMmDTBYZeaZwZT0R44Dl
   Cr2u1m7OK64lFrx47SgZVRzR0EIBbbnR44GiDRe2UNM+VtAc6BG0R559C
   RDfTwB/Zapp1iX1i5gcNptS7ZVtWKXioHJUyg+T5kSefp/YPsUvfq9Sq/
   Dtc75P4bWG6jB+ZayIRgAYONfpOXmy3tsur9q9bnaxqpDqUAtAhgIFYWJ
   EgOPpJeuiGFyf/n6vD7ucyzet05QPqlcNd/Dw25eU5PnSyARKdqQairOX
   s77Egd7vhexPkq7sDiZeVSuaFAFH5GiyZm7udVzws7HHm4mWxeN4SY9GP
   Q==;
X-CSE-ConnectionGUID: RwLalk92S5SHvVJTIoUEOA==
X-CSE-MsgGUID: 3H/UG3XMQHeaZOnwd4JSlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80178118"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80178118"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 17:42:27 -0800
X-CSE-ConnectionGUID: EX0LHZPBRgSCH7MQnOaHkw==
X-CSE-MsgGUID: 5kEcml9dRkWNUEfDRChKRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203977898"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 17:42:27 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 17:42:26 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 17:42:26 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 17:42:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MzX60qdnYNkU2ZVPh2YdrDZVyLXLZi5/1Qpc290kGyDIfQW1Hn8zISa4Mw24Tk8SY7mv7/xcitjLX0oQn1VsTd5h90fchfpepTir1FQ+3l4FZcl/zdXoAacUR3Q5PysuP/lCc3OMKYpMIB+tbxAox6T/55nweUj7mXIh+OjFqKp9xbvqqrWc2Z6iao9fOtWMbg5IJt7N7AYkJVAZWDxdNCnAMYLauLzoT+CLIX6x6YGOSi8B/qb6XiRF4BnsWCq6U5gJge9t3iM8UaV8DHZLXvyN2p0OvbQ/d0yfbKzHxoiark4v6sJq3wMj/3rrTf5wdmuGLdGf7ytGAC/oOJ5F2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=En5tUXvckV9XCABe94+4Cg51eCZ0PJsoeol1VgLkDZg=;
 b=a7l+F94aOoLWtX+Pkb35r/u8QJnVSf5s1aLWaJNUmu5UK/ebXUYAMXobyYEnuC9SRmjK2fdhkmtgFzaNqFiDiBv1/OoKbOzBKpfUMMOLMFbQbEtiyWrxvqD1c+J37OKaw1/m12nX5CUCYKd9QehSMJ9xMHyuRSAnKxudsSeBuiW/qURpCRmgQVCRShnhAumjgzVjxntcI2UOFYFGLhnDmeqXBLisvmHPVPoTEjin3Zt4NzN0XvHNAYnM8lp7qqnd92t/hACZ6Hy9QF5QQMh8wBLrjPN6tsxEC7UrYJ6IRMijuLlOwUwM6UiVAIvIWLiwoYwrDWZnAHXGT5t0FZab7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6607.namprd11.prod.outlook.com (2603:10b6:510:1b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 01:42:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 01:42:22 +0000
Date: Mon, 12 Jan 2026 09:39:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<michael.roth@amd.com>, <david@kernel.org>, <sagis@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <nik.borisov@suse.com>,
	<pgonda@google.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<francescolavra.fl@gmail.com>, <jgross@suse.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <kai.huang@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aWRQ2xyc9coA6aCg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com>
 <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com>
 <aV4hAfPZXfKKB+7i@yzhao56-desk.sh.intel.com>
 <diqzqzrzdfvh.fsf@google.com>
 <aWDH3Z/bjA9unACB@yzhao56-desk.sh.intel.com>
 <CAGtprH-E1iizdDE5PD9E3UHXJHNiiu2H4du9NkVt6vNAhV=O4g@mail.gmail.com>
 <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEvNRgGk73cNFSTBB2p4Jbc-KS6YhU0WSd0pv9JVDArvRd=v4g@mail.gmail.com>
X-ClientProxiedBy: KL1PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:820::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6607:EE_
X-MS-Office365-Filtering-Correlation-Id: f404fa6a-1232-4243-eb01-08de517bd4a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MmdGMVFqbTdweEF5d3JmdHMwRmJURlFSaTBCaW15dDllUkF1R3p4S2lJU0hI?=
 =?utf-8?B?dmZvbUwzdS9JcWdIY0E1ekI2djdyOWR4MVRaM1drVlUyVHZWWFZIa1YrQXNN?=
 =?utf-8?B?N0tTZkxQWkRoUzBBUHRlckh6SGV1R1l0aVF1UTd3S2RhVDFhOXdDN3htMkhP?=
 =?utf-8?B?YXBGN2lOTWpIbW9tNkFQTTlwcDJQZVVOR3NxUXlDVGZjTkY2ZnZGZFRFNFpq?=
 =?utf-8?B?NjRZUDd1NC8xS3BxdktMY1E2R2JwSzRJU3J3WnBkSllTZjM3eEYzaUtzL3R2?=
 =?utf-8?B?RndYZzFjN1lwT1B3UDQ5TnhFWXN5Mlg4NGQ2N3AzV0xKWjJIT3l5NklrOXpz?=
 =?utf-8?B?d1NOK3BjNjNEbzFlcnNaWjhtRUpqMUxTYml1TS9WZXlpSFZVaS9IMW9sWVhF?=
 =?utf-8?B?aUdhYWNiUVVRNUJPZ3dlTHppQXJ2a1hlaTlZN2t0SWg0VWRqOXMxNEd0amJv?=
 =?utf-8?B?dGs4cmFFRDVIYkZueDZiTEVybDJvQmtQOGJ2OHZWM3JkZnpHYklkZ25CRVcz?=
 =?utf-8?B?TXRxcUplL3FTRWVuWVBhY3R4S0NxR21mTkdueTRSZDVVNjVVNThjOTArTHZp?=
 =?utf-8?B?dkYwVDZUdXMvZG9sTEthZ2VoTzZGVVRseWUyM2lmMEhVenRtbVhpTzUzSEdw?=
 =?utf-8?B?eml5SjB1OWVXa0JJdVhtRU1PdURjY2xVc0N4WENPbk0wZllBcmdOb05YQXRD?=
 =?utf-8?B?OEkvd0p3bk5sUTVhNVRJU2Q1NmxxY2xKb1psNy8yb21FWDZqQ2lTeUc5T2lD?=
 =?utf-8?B?N3Q4TkgzeE1DU3I5WWlNY1NuWW9BUWNmL0paUXBCRjZSOS8xd3dVWi81STZp?=
 =?utf-8?B?SENKTW1saFkyeG02YURCMkx0RXVSK3k0bkZGYUdKVVdXaWZqUURuem9yRkpz?=
 =?utf-8?B?UzAxcXFjTm1Fc0pvWnBXV3B1bHVNNnZZbzYxQWJEQUdzNVhPZG0xTHU2WVBD?=
 =?utf-8?B?N2FYLzE1UFpLZjZWSklVY2xaMitOemtjc1cyMm55ZFRSZVFBSUtJYkx1MlpI?=
 =?utf-8?B?UFlUMFJYM3AzMDdOVGhXZmZJbXJObmlqVEpMaTRVQlk4Yk1GRC9SUTFBQzVo?=
 =?utf-8?B?M016TTFsai9Gd0QyRERtRmFEbU8vOVNvNk10NDcyejBIY25ud2p5QXJ3ZW5O?=
 =?utf-8?B?S1psZ0NmUzNQdjFvZWsveW9XVGxTUHd5YnV1c2hlUnc4dlVoRFFwUkhoVzY3?=
 =?utf-8?B?aVpKZ1E5eG9uclNhU3FTZ2tBT3R3MmZkRHlZc3Y2aGpVRFplck94OTNKT3U0?=
 =?utf-8?B?Ym5BN1JoQnNLTmQ4c3dLbEQydTU4Qm9ZNTI5aVVUaEo0NFBJUGFCVXNDRWQr?=
 =?utf-8?B?M1Jrb3VWVE1RbU5LS2VaaTZXOTYrbU9GZnJwSmJVQXNCVXdKMW9rZFB4TEpr?=
 =?utf-8?B?SXZGVC9BMUpZTTZjRUhINm51UUtzcVJBYmpsVzVxcTFKWm1JSTZBaWZkT1dh?=
 =?utf-8?B?VzFhdjFMTW9pUXV5Z09CR3lPdzJPMnZHOGNVejNQYStFdmRURTY0b0o5MERN?=
 =?utf-8?B?SmlCT253T1hpQ3JtNDNRcHFFUDd6SXBJdHJiUWRJSTRRT0ZKc29qeVA3N1Nr?=
 =?utf-8?B?SU5EdDNIOHhMVVBlZk96TzVhNjF1eFljV1FZaFEzU2lLeWRJNXpiSy82U0xa?=
 =?utf-8?B?ZVpsaU5hVmVPTWo0akZQazFna0NTb1Y4RmZ2aWpGQzlDK0dCdnhKWXB2ZStY?=
 =?utf-8?B?MWhRVVBTT1MweGlwdnpZSlZ4TktYVzBpWkVyYlVrbXk4ZUlJakRTOVhrVXFh?=
 =?utf-8?B?S3d1dzE0SkhYWUkweXVPeU5UbTFLR3lQa2VCanU4QnhoWkpUWGowMWlLOEwr?=
 =?utf-8?B?NDdoMnJrZnhVSkc4WkFidUJHZjFkenI1Zm5JMXc3UTJOOE94ZCtWZk1tdVpq?=
 =?utf-8?B?VjZ2L0tQaEJreHVRRWp3MlMrZnBrZytHenBnMStuamJKZkdKZ1dYUmY3Uzgw?=
 =?utf-8?Q?VHD/+SwB1zSnA1II2VaoNP2Y3Dno9GSj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c28wdTFFRHJ3MXA3V3F4QjEwWkN4TFRFS3VMNkhqSWVhK3ZYYXVBT1p4MFRY?=
 =?utf-8?B?WVl5SDdCeHdEajRyRURSSStJR0ZyTU1sWmVRYXJ4N2twOWIwL1hlNldqbWxR?=
 =?utf-8?B?RjB6TzI0MG9VaDk5OU05T2taYlNPSkptcU9sTC8rWWxPVUJNUGx3UEE2akRP?=
 =?utf-8?B?cU5Pa0diWVZBQnc4Wmd3bklRSXdqRzZIcGtYTVBIYm96S0M3Q0JyUGh5bElt?=
 =?utf-8?B?NFpCNWJNakZ6WHhQaERmZUdFQm5ZUjNFUEVsczZ1QTVBZXNuU2Q1S1FkRDBL?=
 =?utf-8?B?Z3lVTDJIaHJnODBKbkhWTzJsQXNUamE1WHdZckYzbGF6bTB4YnBCbjVLSWEx?=
 =?utf-8?B?RXpJbG9jTzNoVGNTYitCM1kzWEhaMHMxRys2Y0ZkU2EvTXN0TmFpa0Yzc1Ju?=
 =?utf-8?B?NUR5RHpJSEdERXVDNGVyekVPMlMyUWF0b0hadmNsbVZQUnVjZmhDdXM1L25V?=
 =?utf-8?B?eW9ZYjFNeWhxMTg1WGxNc1lqQzk2NGtpYU0yRVRacUFUUXIxdHgrQ1dONFpu?=
 =?utf-8?B?eVJNdWEvTVFJWU9LdFRiMi9ZanVJNmVvMDdJbWNKcW9ydzJZVXhDM1NmcU11?=
 =?utf-8?B?S1QvK0RpV29icFNwekVhbmc3T0p3Vk4zMzFqRmJtdkdlcFVFb1lmNy80anBR?=
 =?utf-8?B?ckJrNUJLZ2E0dVYyTDBLVStoMmhvOURjTlhPSGl1Q2FNMkhPYzVxcnNoNFp6?=
 =?utf-8?B?TnpDR2NCT0doVFR0YWh2Z2V6S21wV0kxa2Y3QnJLVGM5blJCaml6KzZkRzVO?=
 =?utf-8?B?V0c1N2lURVBKbndIeDlsVWJPYW1YUytkRDRvNXpPN0tZWVlpWEgrTkI4Mjc3?=
 =?utf-8?B?cm5DWDNOanJhTDltWmUvNVlJa2ZocDhqQXQ3NDB6RGx0NkpGUnJka1lSdm00?=
 =?utf-8?B?NUZJVkFiaTJSMW5rVCtJcjg5cUJVNzlHVmM3SmxSbmI2TGxlZW01dmpxUW9T?=
 =?utf-8?B?cHI1NURTY3lLT2s3TlZaTlB4bGZCNy9KQko1VGkzMWQrLzNVNjNwSFdQU1lr?=
 =?utf-8?B?OW5kV09WeVFJajdkRnhrUUZPV2NLdURXYmVSK1RLUWNTQmdrRTFJbEc2UU5K?=
 =?utf-8?B?YmJMemVGV3k4MTUyQlF6cFFHcGsxRXIrK2VBQllGWkZWTXN5Wmw3eldmRG9Y?=
 =?utf-8?B?RWlCNzBJbzkxZ1h1d2FZNlBMazYxakd6b2xsZHU5UnVKM296Y3JENVArZmRk?=
 =?utf-8?B?WkU5UGRmbzJMMzU4Y2ZkTkZTUmpLNjV2VGg2c091dS90MGRuTnozbDRDeEZi?=
 =?utf-8?B?cXpHSFZwMmtYb0xoYmxYK0c1aHRlQVE4MGRqTHZEcmprMmxsZDVLbkNMS2Za?=
 =?utf-8?B?TUtuZVZqeG1sdWNWb3lrOERLditCT01UaTdDOTVBR1NQYUZoWHNRNEVvUjVq?=
 =?utf-8?B?RHZ5c2dLU2M1dzJ0dm14aTlUT09mRXJKQ3FsK0lpTitPdGxWcm5nWXZ6VVdS?=
 =?utf-8?B?cFZneVZEdjRBbXcwOUZ2WFEvWkNnWnV2WnJhWWxPMFBvNDVUcTNiRUZJSnBn?=
 =?utf-8?B?NGNRNEhyckVRWFI3Yk56eURXaThsWDEvTHdvZEs0aXN4WVpMVWpyeU9oM1Y4?=
 =?utf-8?B?MzNVRVk1YXFKUjgrbkI1eVhuK1NxaHVSaHNNYllRN2VGNksvK1RrVnRnUlR0?=
 =?utf-8?B?UkRBazd3TXBLcUZsS3R3MmZHVmlBZUVRcmNqUnRTaFQ2eVNFVHN6Mk5qVEpi?=
 =?utf-8?B?VVpvQk5TUXdEakpzQXVieTdEazRBcCt4bVlsNHg2Ny8yaW4wOXVaQ1BPQVJD?=
 =?utf-8?B?Q0NwVVNQSnRuZm0rZ1RndlNrYmJ3SGR2VmlkSGtydVlrcEh3NUxsanUvbGJa?=
 =?utf-8?B?c2Yra28vYWJVa2xYR2gvUnZJdlRUKzFDcENKV1ZLNHhBN3BIa20zRW0rODBC?=
 =?utf-8?B?QllueE5icHZ0MkY1bkJnYU5UM3I1U1Z4NW8vT0orbjFqektKbEVNcXR2YmRa?=
 =?utf-8?B?b2hGWGw4YUljYjQrckl2NnVQL2Q4bThNSlhweGxHYnBUTk96Nk9WZ2ZrdEg3?=
 =?utf-8?B?eTJ1Zmk2VFBtOFFQWGVxL2xoTU4ycnVKRmllVVpGayt4bllhMC9PYjBMK3dE?=
 =?utf-8?B?UjI1VU9Hd0RBejFETkxNamduVEpIQUF1NFVKZUo3dHpNc2diM3E5WlA0S3hK?=
 =?utf-8?B?SG5meWZXTDlYRWsxV0pES3FGMk9ieWFJVTFBOWtqNjQwQXVKMmNPV0VrbDIv?=
 =?utf-8?B?ZitMTWdLTDdOV3F3djFTdTdFUDFXdG14VVNRbk5Mdi9rMWFUcWNRZDNMTEJ2?=
 =?utf-8?B?QWt0c1FKMC84VHkyZFViYjU4ZFZ4U3BjR0tFZ3o2UzRUMFRwaWkwVEw2SkdB?=
 =?utf-8?B?dENzUk5LSU5aL0xaYjlzNUMrVDhveUp4ZjdETmpHR2RaaFNkYThxQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f404fa6a-1232-4243-eb01-08de517bd4a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 01:42:22.6354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAChtgYeewLK/P07Ld2RmTOAaQu2U09NFWkWTtNjYu5okZMbSUVm4uW+HLmO8Es9DmtlAQhUJZL2g9ZZJYC/rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6607
X-OriginatorOrg: intel.com

On Fri, Jan 09, 2026 at 10:07:00AM -0800, Ackerley Tng wrote:
> Vishal Annapurve <vannapurve@google.com> writes:
> 
> > On Fri, Jan 9, 2026 at 1:21 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >>
> >> On Thu, Jan 08, 2026 at 12:11:14PM -0800, Ackerley Tng wrote:
> >> > Yan Zhao <yan.y.zhao@intel.com> writes:
> >> >
> >> > > On Tue, Jan 06, 2026 at 03:43:29PM -0800, Sean Christopherson wrote:
> >> > >> On Tue, Jan 06, 2026, Ackerley Tng wrote:
> >> > >> > Sean Christopherson <seanjc@google.com> writes:
> >> > >> >
> >> > >> > > On Tue, Jan 06, 2026, Ackerley Tng wrote:
> >> > >> > >> Vishal Annapurve <vannapurve@google.com> writes:
> >> > >> > >>
> >> > >> > >> > On Tue, Jan 6, 2026 at 2:19 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >> > >> > >> >>
> >> > >> > >> >> - EPT mapping size and folio size
> >> > >> > >> >>
> >> > >> > >> >>   This series is built upon the rule in KVM that the mapping size in the
> >> > >> > >> >>   KVM-managed secondary MMU is no larger than the backend folio size.
> >> > >> > >> >>
> >> > >> > >>
> >> > >> > >> I'm not familiar with this rule and would like to find out more. Why is
> >> > >> > >> this rule imposed?
> >> > >> > >
> >> > >> > > Because it's the only sane way to safely map memory into the guest? :-D
> >> > >> > >
> >> > >> > >> Is this rule there just because traditionally folio sizes also define the
> >> > >> > >> limit of contiguity, and so the mapping size must not be greater than folio
> >> > >> > >> size in case the block of memory represented by the folio is not contiguous?
> >> > >> > >
> >> > >> > > Pre-guest_memfd, KVM didn't care about folios.  KVM's mapping size was (and still
> >> > >> > > is) strictly bound by the host mapping size.  That's handles contiguous addresses,
> >> > >> > > but it _also_ handles contiguous protections (e.g. RWX) and other attributes.
> >> > >> > >
> >> > >> > >> In guest_memfd's case, even if the folio is split (just for refcount
> >> > >> > >> tracking purposese on private to shared conversion), the memory is still
> >> > >> > >> contiguous up to the original folio's size. Will the contiguity address
> >> > >> > >> the concerns?
> >> > >> > >
> >> > >> > > Not really?  Why would the folio be split if the memory _and its attributes_ are
> >> > >> > > fully contiguous?  If the attributes are mixed, KVM must not create a mapping
> >> > >> > > spanning mixed ranges, i.e. with multiple folios.
> >> > >> >
> >> > >> > The folio can be split if any (or all) of the pages in a huge page range
> >> > >> > are shared (in the CoCo sense). So in a 1G block of memory, even if the
> >> > >> > attributes all read 0 (!KVM_MEMORY_ATTRIBUTE_PRIVATE), the folio
> >> > >> > would be split, and the split folios are necessary for tracking users of
> >> > >> > shared pages using struct page refcounts.
> >> > >>
> >> > >> Ahh, that's what the refcounting was referring to.  Gotcha.
> >> > >>
> >> > >> > However the split folios in that 1G range are still fully contiguous.
> >> > >> >
> >> > >> > The process of conversion will split the EPT entries soon after the
> >> > >> > folios are split so the rule remains upheld.
> >> >
> >> > Correction here: If we go with splitting from 1G to 4K uniformly on
> >> > sharing, only the EPT entries around the shared 4K folio will have their
> >> > page table entries split, so many of the EPT entries will be at 2M level
> >> > though the folios are 4K sized. This would be last beyond the conversion
> >> > process.
> >> >
> >> > > Overall, I don't think allowing folios smaller than the mappings while
> >> > > conversion is in progress brings enough benefit.
> >> > >
> >> >
> >> > I'll look into making the restructuring process always succeed, but off
> >> > the top of my head that's hard because
> >> >
> >> > 1. HugeTLB Vmemmap Optimization code would have to be refactored to
> >> >    use pre-allocated pages, which is refactoring deep in HugeTLB code
> >> >
> >> > 2. If we want to split non-uniformly such that only the folios that are
> >> >    shared are 4K, and the remaining folios are as large as possible (PMD
> >> >    sized as much as possible), it gets complex to figure out how many
> >> >    pages to allocate ahead of time.
> >> >
> >> > So it's complex and will probably delay HugeTLB+conversion support even
> >> > more!
> >> >
> >> > > Cons:
> >> > > (1) TDX's zapping callback has no idea whether the zapping is caused by an
> >> > >     in-progress private-to-shared conversion or other reasons. It also has no
> >> > >     idea if the attributes of the underlying folios remain unchanged during an
> >> > >     in-progress private-to-shared conversion. Even if the assertion Ackerley
> >> > >     mentioned is true, it's not easy to drop the sanity checks in TDX's zapping
> >> > >     callback for in-progress private-to-shared conversion alone (which would
> >> > >     increase TDX's dependency on guest_memfd's specific implementation even if
> >> > >     it's feasible).
> >> > >
> >> > >     Removing the sanity checks entirely in TDX's zapping callback is confusing
> >> > >     and would show a bad/false expectation from KVM -- what if a huge folio is
> >> > >     incorrectly split while it's still mapped in KVM (by a buggy guest_memfd or
> >> > >     others) in other conditions? And then do we still need the check in TDX's
> >> > >     mapping callback? If not, does it mean TDX huge pages can stop relying on
> >> > >     guest_memfd's ability to allocate huge folios, as KVM could still create
> >> > >     huge mappings as long as small folios are physically contiguous with
> >> > >     homogeneous memory attributes?
> >> > >
> >> > > (2) Allowing folios smaller than the mapping would require splitting S-EPT in
> >> > >     kvm_gmem_error_folio() before kvm_gmem_zap(). Though one may argue that the
> >> > >     invalidate lock held in __kvm_gmem_set_attributes() could guard against
> >> > >     concurrent kvm_gmem_error_folio(), it still doesn't seem clean and looks
> >> > >     error-prone. (This may also apply to kvm_gmem_migrate_folio() potentially).
> >> > >
> >> >
> >> > I think the central question I have among all the above is what TDX
> >> > needs to actually care about (putting aside what KVM's folio size/memory
> >> > contiguity vs mapping level rule for a while).
> >> >
> >> > I think TDX code can check what it cares about (if required to aid
> >> > debugging, as Dave suggested). Does TDX actually care about folio sizes,
> >> > or does it actually care about memory contiguity and alignment?
> >> TDX cares about memory contiguity. A single folio ensures memory contiguity.
> >
> > In this slightly unusual case, I think the guarantee needed here is
> > that as long as a range is mapped into SEPT entries, guest_memfd
> > ensures that the complete range stays private.
> >
> > i.e. I think it should be safe to rely on guest_memfd here,
> > irrespective of the folio sizes:
> > 1) KVM TDX stack should be able to reclaim the complete range when unmapping.
> > 2) KVM TDX stack can assume that as long as memory is mapped in SEPT
> > entries, guest_memfd will not let host userspace mappings to access
> > guest private memory.
> >
> >>
> >> Allowing one S-EPT mapping to cover multiple folios may also mean it's no longer
> >> reasonable to pass "struct page" to tdh_phymem_page_wbinvd_hkid() for a
> >> contiguous range larger than the page's folio range.
> >
> > What's the issue with passing the (struct page*, unsigned long nr_pages) pair?
> >
> >>
> >> Additionally, we don't split private mappings in kvm_gmem_error_folio().
> >> If smaller folios are allowed, splitting private mapping is required there.
> 
> It was discussed before that for memory failure handling, we will want
> to split huge pages, we will get to it! The trouble is that guest_memfd
> took the page from HugeTLB (unlike buddy or HugeTLB which manages memory
> from the ground up), so we'll still need to figure out it's okay to let
> HugeTLB deal with it when freeing, and when I last looked, HugeTLB
> doesn't actually deal with poisoned folios on freeing, so there's more
> work to do on the HugeTLB side.
> 
> This is a good point, although IIUC it is a separate issue. The need to
> split private mappings on memory failure is not for confidentiality in
> the TDX sense but to ensure that the guest doesn't use the failed
> memory. In that case, contiguity is broken by the failed memory. The
> folio is split, the private EPTs are split. The folio size should still
> not be checked in TDX code. guest_memfd knows contiguity got broken, so
> guest_memfd calls TDX code to split the EPTs.

Hmm, maybe the key is that we need to split S-EPT first before allowing
guest_memfd to split the backend folio. If splitting S-EPT fails, don't do the
folio splitting.

This is better than performing folio splitting while it's mapped as huge in
S-EPT, since in the latter case, kvm_gmem_error_folio() needs to try to split
S-EPT. If the S-EPT splitting fails, falling back to zapping the huge mapping in
kvm_gmem_error_folio() would still trigger the over-zapping issue.

In the primary MMU, it follows the rule of unmapping a folio before splitting,
truncating, or migrating a folio. For S-EPT, considering the cost of zapping
more ranges than necessary, maybe a trade-off is to always split S-EPT before
allowing backend folio splitting.

Does this look good to you?

So, to convert a 2MB range from private to shared, even though guest_memfd will
eventually zap the entire 2MB range, do the S-EPT splitting first! If it fails,
don't split the backend folio.

Even if folio splitting may fail later, it just leaves split S-EPT mappings,
which matters little, especially after we support S-EPT promotion later.

The benefit is that we don't need to worry even in the case when guest_memfd
splits a 1GB folio directly to 4KB granularity, potentially introducing the
over-zapping issue later.

> > Yes, I believe splitting private mappings will be invoked to ensure
> > that the whole huge folio is not unmapped from KVM due to an error on
> > just a 4K page. Is that a problem?
> >
> > If splitting fails, the implementation can fall back to completely
> > zapping the folio range.
> >
> >> (e.g., after splitting a 1GB folio to 4KB folios with 2MB mappings. Also, is it
> >> possible for splitting a huge folio to fail partially, without merging the huge
> >> folio back or further zapping?).
> 
> The current stance is to allow splitting failures and not undo that
> splitting failure, so there's no merge back to fix the splitting
> failure. (Not set in stone yet, I think merging back could turn out to
> be a requirement from the mm side, which comes with more complexity in
> restructuring logic.)
> 
> If it is not merged back on a split failure, the pages are still
> contiguous, the pages are guaranteed contiguous while they are owned by
> guest_memfd (even in the case of memory failure, if I get my way :P) so
> TDX can still trust that.
> 
> I think you're worried that on split failure some folios are split, but
> the private EPTs for those are not split, but the memory for those
> unsplit private EPTs are still contiguous, and on split failure we quit
> early so guest_memfd still tracks the ranges as private.
> 
> Privateness and contiguity are preserved so I think TDX should be good
> with that? The TD can still run. IIUC it is part of the plan that on
> splitting failure, conversion ioctl returns failure, guest is informed
> of conversion failure so that it can do whatever it should do to clean
> up.
As above, what about the idea of always requesting KVM to split S-EPT before
guest_memfd splits a folio?

I think splitting S-EPT first is already required for all cases anyway, except
for the private-to-shared conversion of a full 2MB or 1GB range.

Requesting S-EPT splitting when it's about to do folio splitting is better than
leaving huge mappings with split folios and having to patch things up here and
there, just to make the single case of private-to-shared conversion easier.

> > Yes, splitting can fail partially, but guest_memfd will not make the
> > ranges available to host userspace and derivatives until:
> > 1) The complete range to be converted is split to 4K granularity.
> > 2) The complete range to be converted is zapped from KVM EPT mappings.
> >
> >> Not sure if there're other edge cases we're still missing.
> >>
> 
> As you said, at the core TDX is concerned about contiguity of the memory
> ranges (start_addr, length) that it was given. Contiguity is guaranteed
> by guest_memfd while the folio is in guest_memfd ownership up to the
> boundaries of the original folio, before any restructuring. So if we're
> looking for edge cases, I think they would be around
> truncation. Can't think of anything now.
Potentially, folio migration, if we support it in the future.

> (guest_memfd will also ensure truncation of anything less than the
> original size of the folio before restructuring is blocked, regardless
> of the current size of the folio)
> >> > Separately, KVM could also enforce the folio size/memory contiguity vs
> >> > mapping level rule, but TDX code shouldn't enforce KVM's rules. So if
> >> > the check is deemed necessary, it still shouldn't be in TDX code, I
> >> > think.
> >> >
> >> > > Pro: Preventing zapping private memory until conversion is successful is good.
> >> > >
> >> > > However, could we achieve this benefit in other ways? For example, is it
> >> > > possible to ensure hugetlb_restructuring_split_folio() can't fail by ensuring
> >> > > split_entries() can't fail (via pre-allocation?) and disabling hugetlb_vmemmap
> >> > > optimization? (hugetlb_vmemmap conversion is super slow according to my
> >> > > observation and I always disable it).
> >> >
> >> > HugeTLB vmemmap optimization gives us 1.6% of memory in savings. For a
> >> > huge VM, multiplied by a large number of hosts, this is not a trivial
> >> > amount of memory. It's one of the key reasons why we are using HugeTLB
> >> > in guest_memfd in the first place, other than to be able to get high
> >> > level page table mappings. We want this in production.
> >> >
> >> > > Or pre-allocation for
> >> > > vmemmap_remap_alloc()?
> >> > >
> >> >
> >> > Will investigate if this is possible as mentioned above. Thanks for the
> >> > suggestion again!
> >> >
> >> > > Dropping TDX's sanity check may only serve as our last resort. IMHO, zapping
> >> > > private memory before conversion succeeds is still better than introducing the
> >> > > mess between folio size and mapping size.
> >> > >
> >> > >> > I guess perhaps the question is, is it okay if the folios are smaller
> >> > >> > than the mapping while conversion is in progress? Does the order matter
> >> > >> > (split page table entries first vs split folios first)?
> >> > >>
> >> > >> Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> >> > >> conceptually totally fine, i.e. I'm not totally opposed to adding support for
> >> > >> mapping multiple guest_memfd folios with a single hugepage.   As to whether we
> >> > >> do (a) nothing, (b) change the refcounting, or (c) add support for mapping
> >> > >> multiple folios in one page, probably comes down to which option provides "good
> >> > >> enough" performance without incurring too much complexity.
> >> >
> 

