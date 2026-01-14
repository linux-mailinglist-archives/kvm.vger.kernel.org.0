Return-Path: <kvm+bounces-68000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB62FD1BFE2
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 02:51:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 626E5302FA08
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F10B2F0C7E;
	Wed, 14 Jan 2026 01:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkCttjf3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C6729E0E5;
	Wed, 14 Jan 2026 01:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768355479; cv=fail; b=oZYI/Bk3idKBZ2Td1ehCC3XTc/lM68mdFIio5WtDlgx1OKh1tFZAxMzvp3GaCujYT/36vlD4ANh8t2QwrT8uue4xS3nZJf1V94ZdJHl+EPMu/e94wrBIyXjs0IJfa4R0/lH0LROjvy07jmbnHV1kZrkv1tU5es+IE/AKDPdkQoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768355479; c=relaxed/simple;
	bh=lbB7wQ+WptRSZd8JiG7Dutxf0/pRDKM84x/IO7gPP9k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CVwB5qfZyiY6lsrDUz1GXYZLODuvUeDhuEOBpY49sRnUwGVirH0PDmmpBVH52xywjmi2kmNTRVXYCo+Q1eAi248WxfwwAb9X8qbyKPjPoh5yJemARwi9TrpK0Cr1zQQPPYmAG8gkFrzcjStpXyJA8VyNMhdWuaNP4RtBECMkiLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkCttjf3; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768355478; x=1799891478;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lbB7wQ+WptRSZd8JiG7Dutxf0/pRDKM84x/IO7gPP9k=;
  b=DkCttjf3DxsTijntGcxl2CtFSbn2Vh6VXStJyyhDh2KqJMU6Z013J8QU
   TzdTgIgMPDSnt2v7Fg7/4FEwvt31z2kmxINOIokkd0n4dFo3Z6Z1aCa/H
   oiSK4DnV1RkPsmvXAh9u7EIyWlmqVXme1yZJEAkVz54IRhbF5fGkjqw0E
   Pz1xB9+3CjZ4NIWnJVvJbCLXAPEpAb1Lg6ZXOrC/hAioZRCNqs3UX4PIL
   KM7VYb9iTQrIoDpFHMox6mfz2kCam8MQVnEU69GFkIDoXWS0WqUrtSulU
   OUjFeegslEH3QfzLg8OkMdBH58fXbqYtzvUaUDEyauZ6+czpH45AzcJnh
   A==;
X-CSE-ConnectionGUID: qDleLuUZSneyy3XKkr5cGg==
X-CSE-MsgGUID: LSUMsfJ4S9i+/sUC3TgrKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="69571834"
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="69571834"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 17:51:17 -0800
X-CSE-ConnectionGUID: +sYQqe74QGWvDPncZd7+Zw==
X-CSE-MsgGUID: uWmXjHWQTKmMw+2BCt8sFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,224,1763452800"; 
   d="scan'208";a="208701909"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 17:51:17 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 17:51:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 17:51:16 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.47)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 17:51:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3R0XCX+FbWYvqLIesbiQ8VuYjNHsAXph/e4ubQ9DToXeXTSqoAE6JU5OFar1h7UQi+ncOH/m38/uB+wU96QZ5fCdUE5gwhlThYH/+U7OTK3dOUUmdc+vOyx7+9bmPQqjDFQP9B/UGrokJBJWKhyB6engvQi8RygRsUo4g9ChcJQFZggNojB1uh0cZf4/MrEDLAHAHkTAB70jKOcTYY8imij2+0yekPRlK9eRs7QFaKD79iGmDbP3iO/P/n8TehhPB/IjIwWGrt+rEqgdfG4FfFBWQsDVoep45yK8wmipovs+pUKc3BUQqTO3AeXkkU1A31N92yfVoM9BUnEkY8r6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NIY4bRrnSfYOekuX5H9gBm1hpHG/swmfVZ4RImTPdg=;
 b=QHk9x6Uuh1kme7aKrBtmDgqB2+s9pg6lvjlhrijLFJphVfUXxIj4qDYiT6/VM268n3gYhhhug4yKxkEUflHCM1K8IErplvtI2DqyCclsM8yIgN9CXnZC8iY7ZbZ3UL/jmvsSN73wCvYo4KpohTylrS/YG9c34NC8Yh3Qcz9BHsljTvvgvrNQYB1SQqcU2yzOE7KavJwGLx7JcTlZ5X8udtH3KuTYhRnEcTAB3rnzo7eeZd14t3y/oPzJRR4YflbgCtPbj/7Qu+ddEFDReoEzHLeYYR2zqtdjmfdzqK3IfUV51IEdkEQ9xMGS+BU2BJeVqFeS40v0ErPfhAqiASHjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7639.namprd11.prod.outlook.com (2603:10b6:806:32a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 01:51:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 01:51:08 +0000
Date: Wed, 14 Jan 2026 09:48:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, Dave Hansen
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<michael.roth@amd.com>, <david@kernel.org>, <sagis@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <nik.borisov@suse.com>,
	<pgonda@google.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<francescolavra.fl@gmail.com>, <jgross@suse.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <kai.huang@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
Message-ID: <aWb16XJuSVuyRu7l@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
 <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
 <17a3a087-bcf2-491f-8a9a-1cd98989b471@intel.com>
 <aWBxFXYPzWnkubNH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHtDJx52+KU3dZfhOMjvWxjX7eJ7WdX8y+kN+bNqpspeg@mail.gmail.com>
 <aWRfVOZpTUdYJ+7C@yzhao56-desk.sh.intel.com>
 <CAGtprH_h-oWaZgF2Gkpb0Cf_CLhk8MSyN7wQgX2D6cFvv1Stgw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_h-oWaZgF2Gkpb0Cf_CLhk8MSyN7wQgX2D6cFvv1Stgw@mail.gmail.com>
X-ClientProxiedBy: TPYP295CA0041.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7639:EE_
X-MS-Office365-Filtering-Correlation-Id: 0260f786-96c3-4460-c462-08de530f62ab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RnZray92NHlndnZpN3gzbUt3RTdFZlJKMXBCZ2tMN2ExRjJHb1BwMEo1QzNR?=
 =?utf-8?B?OHFMdHVsRElvMGp6Sm9qcDRFWnFJdWZHRGxCcUZacFpidk1SWlVoUTBtdXQz?=
 =?utf-8?B?RDFLcVdLT2JtYnBrV1hFMUNCaHNtdTB1TzVsMHBJK1YraDNQWkpiNi9FN0hx?=
 =?utf-8?B?WjZsTkVRMnVRK05ETThXcENSZUxXTVNGdGhCWUZZb0NCK1JYQXY3amZGWXFQ?=
 =?utf-8?B?Z1V0SnI0QVdWTTJ1eHRHU0tvSWhkRHBPekVyNXVKdkxpZjZXVWJ1TWQ4R09k?=
 =?utf-8?B?QzNlZGlUVCtTN3VHbGZsVm5sY1pzTWFmTDljdHJxUElqOWZWUVBDU1BZVC9i?=
 =?utf-8?B?SUt5Rkd4K1BrU3pmaUlUM3I1UHcwazY4VUltTDVHRCthQXZPTFlVdk92OVlB?=
 =?utf-8?B?YXFCVHlRRmtEZlM5Qk1jYXUyVWF4dzhFY3U0Yi9QMDIyOGltNEhvc0Y5eEYy?=
 =?utf-8?B?UnVYakRyVjRVVTUzaWFEeFNXWTRvTzVZQ0ZXNXN0a2ovUFNhcExodHh2YUZC?=
 =?utf-8?B?Mm5GSVFUeWRmdEtHQ3ZmbWVsQkRzRDdPSlFUUzJUa0hmUUVaMmYyNGxOQmI0?=
 =?utf-8?B?b1gvM1dBM3FWV1BXcTNaWVF6YU5iZzBzSWlUL1VONGEydXp3Z2FGQUVsQzBx?=
 =?utf-8?B?Zm5uODhnUlFYRGtvZmpieDZYOVZpUEZKSGRwcHdyYTFBWFZWazJnMHVGeFJl?=
 =?utf-8?B?NjNrdXBaY1FENExOcjlKVVJHMWdhY0NEWFBCc1NLc01sSlpYNW13WnhsS3lK?=
 =?utf-8?B?WmgycWdUSUprQTNwbitNR1ZMcTdoZVFYMUNUVU5mN3pEKzNUV09VNWtXOWNu?=
 =?utf-8?B?WkE1UXg1MytkdVBZTzl5OTFLdjhtaVZMRkQyUUYwKzFOc1JLOVRucU0zYk9x?=
 =?utf-8?B?WExyalNKK2RVTmpudzBibktodFp3OWhlT2QwTlo2RzdlT3B6Y29LUk5WSWJW?=
 =?utf-8?B?bW13MmRPYWFjMlduUmZKbnVJdTVFaU9NSGVPREl4Q0gyaFFmaFN2S1AwQzUz?=
 =?utf-8?B?T3VPRnV2WWE2VnliT01HdCtTeDNSbXJaYTkrUktSS3dTaVF0NHFnazh6Z2dH?=
 =?utf-8?B?dHhhbmlydWdQZG14NG9oSytEbVd4NTcwTHdhS1pMUVVOVUJEaFVaWGFERDZq?=
 =?utf-8?B?MGU4dWQzbkpqeWcyTE5qR0dsckZjU1NlMXpsT2RneFZTenZ1LzVTV3Y0TFkz?=
 =?utf-8?B?cTlxZlpRNmNVWXZCNEVlTEk3MDdjdWhneG1QRCtFTkJyalNEOURUcEMvODB5?=
 =?utf-8?B?R3VNcXB0V05Pa1d1WjJldEFuMk9VSVJCNmd2Q0dzUjdyYUVhOUs0VnhMVVlx?=
 =?utf-8?B?VjJOVmFFN09RZ1F2QTFFZktzT2F4TUpieW1ERG9sL0xWSGVMb3FnZGh5NFM1?=
 =?utf-8?B?Zk93cmRXRXZCYk5HbC94Z1BLTHBTUUFzcVlJa1dHbDJZUDcwVlVQK2oybS9Q?=
 =?utf-8?B?dGFVSERueEZzWW9xTXN0RXZsajdoQUZtdGdhRkVDK2hrL2draDlMRFF6NVhS?=
 =?utf-8?B?bmViaVNQK3dkQ28vbWc1WTdIakVzK0hQa0JZYk1yUHNFYWhKMmJPSU9FOUwz?=
 =?utf-8?B?bWoyY25IM2xzSWpMTUZjMnFFRnZXR1V3NjBjaFNCN2JHV3lrZkxNNGxHR2ha?=
 =?utf-8?B?Y2h0aDhyeHI2MXUzRTdDTjNIRVA3dHhMVTVhTnVMSC9lZEZjc1pGV0l3RHFH?=
 =?utf-8?B?TVczOFZBQ2VwWjhlMGRpQnRhZHc4NEVHbUlmc1B2ZjNvVHoybGk2cXZxTXhy?=
 =?utf-8?B?anFVQTdzbXc5SGk2RURVUWo2MVBEZTN6N3I4VFovZ0ordXcvQzZSeFRyalNC?=
 =?utf-8?B?SjFGYURLV0sza2ZKYkFVelcvb2N1ZXV6UmllSGc0QmN5d0xWQlhqQW5aZVRF?=
 =?utf-8?B?TEJtL3hlc1AwR1YrcmtxRHVob2JxQ2xCSWd1NUlSYjNPQmFIQlhLS240ZGtr?=
 =?utf-8?Q?1QDoLUnZciP5wKT0hsUDPe+TgWq9l2Pm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGJoRFRsQllvTHZ2TDhiUm5XTDliaEFGS0lYbTJ3YkVFWG4xTDNrYnBBWTVS?=
 =?utf-8?B?UXorc3AwNy9zcHhuTG54K2dzMFY3aVNGdUlROVMzckZWbGl3dU5XV01JNUE2?=
 =?utf-8?B?aDJySHQ5S2xkK25ranpqWkRiREFwOGJ3NG5jL2NVRWE1UVppUlVuZ2pLV2JQ?=
 =?utf-8?B?YXBkOUR2VDNndFc1RW5EbzFkSnEyRHJJUmV4ZUR0cXNBVU4yYWxWaHNLWndi?=
 =?utf-8?B?aDVHcFNJb3lUVjdsdERTTldGZHlZTUdoMk9saTBqaG1TbndaMXA5TytWa2wx?=
 =?utf-8?B?QU42UXhKeDh2WHcwMUsxU3Q0ZE43dDhjdUhYTHpmUXNQUXVGd3JsazZvLzJp?=
 =?utf-8?B?SzZxbWRPSis2dGZSMkNUMklpQVA5bzRhNGQ3WCsxVzcrWlhzNkM3ZmJ0S1di?=
 =?utf-8?B?OU1qcDQ3QTBQVEtJaUs4Nk5VSnJwaHIxYm9PU0FZc3l5NVJZM2RKVFpsYUg3?=
 =?utf-8?B?TllSSFRiOEU3b3FtR1JodzUyemJjM28zdEJGWjNUbDNoTlJTOHNzWGgvcStt?=
 =?utf-8?B?dHI1akVFUHZ5UjkzVi95MnR5RC9NbWhxalVRNGVHelNadnFwRjh3OS9oYW52?=
 =?utf-8?B?UFZYcDhuQ3RqUjZud3U3dS9VeTZ0dFVxWE9VcnhmUXhRaFlwekpuNUZIQnVN?=
 =?utf-8?B?SzBucWI5OS8rdFFvY0c0Uk9wMTZLaG5KK2xOcTVXSTFaUHB2M2craDZsQ2lp?=
 =?utf-8?B?Y1FuUFJMTFJHUFV1eUlybHJuOFlhb2E4R1RTUTNlZGRVSHZXRytkS3RVN0pI?=
 =?utf-8?B?VVY4V0xBQjJySWx2UzNKNGw4d0I0MHhGT1k2cDMxVXdsYnBqajZkQ0JSR1BF?=
 =?utf-8?B?Y3BQYjFYbjRmRExzR3Qxb0hXdVNOek80R2Z6czNkdVZlRHRlVXB4ZmN3M0Js?=
 =?utf-8?B?Rkw3dzIvTTk5ZVZDTm5wYTAvN0wwblVFTmJqcGJ5WGMvbk1wdmVlc214SlNR?=
 =?utf-8?B?T1pOUnRSYlJjYkh1ZDdBSmJKNjlQUlhUeHZuMC9Rb2dWT3dsS0VnY2dJcWtt?=
 =?utf-8?B?b2RtUmhBUERzVmhnQTdXZmRJaGUvNGJWZE5SUmZVWXg4SHBWTDY3YytvcXhK?=
 =?utf-8?B?eGRwcVkvaHMvSWl5NVBSWi8yNDRXZmJjaTdRWjJ3YWtpUHZqYjNrTFQ5WktT?=
 =?utf-8?B?NVBsV2VkbHJFMVhBeVJCMjRGaS9yaGUxdHpGWFlxL3l5ZTNDY1RLNXFiZGIr?=
 =?utf-8?B?QjJmSnlNd3lxVUZ1N1pzVmlzZEl0STZwRU5xd2N6YlFXQ0FMemo5VTMxZ3NZ?=
 =?utf-8?B?RTcwY3hLVmpZeG9rTThsenR4dEg3LzVSY3BLYkZWdkFNQzRFcUxCRzhwblF6?=
 =?utf-8?B?anM0ZTA5SVh1UGdNeERlOU1lMjkrOHZwZVQzMm9BWDI5UDNFbjRZK2d2MWpZ?=
 =?utf-8?B?R2ZDVlowcEpkUGtkTlJ5Sys1QXNmWnAwbWdLaW5QYlQrSTFhMHVURStiSTJp?=
 =?utf-8?B?R2lQMDBhOWx4Qmlzb0UxayswaktoeFh6M2JNdTc1TlcwbktTR0tWVE5DcGtL?=
 =?utf-8?B?SnJET2hsYWs1alJDMW0vRUdSL29wd2ZhMlk3cjhwenY0WTVQSWdlVXZrRjBz?=
 =?utf-8?B?VUd5QmVQSmVqOUxCV2tQNkFCNzlnMWJRMFlTM0w1VlR4NTg4Um5GV3RtMmdq?=
 =?utf-8?B?c0t6YlpwZXJ4dktUclkwQ0NmVEdoVEJ2aG5LeWlXZDJ2aFVGTzcvT3ZETWJ1?=
 =?utf-8?B?aDUwTkhJL05xYWdmV0J4WjZvZ0NBbVN5VnhFNVJtdzkwWUE1a2grYkZSOVlG?=
 =?utf-8?B?aTZIQ2ZuQjIxWVloUEpOVzNiVkMwK0hRNzRuRmtDOVFzOEcyQjFNeGJndWNl?=
 =?utf-8?B?endBd3V1eE5ScGwyKzFXK0RITEx6OXdNK20rTUdVbmFpdEh6OGpNNC9JTVJr?=
 =?utf-8?B?TDRjQzUwTFhWTnJJZHdsZzBHSDNyMHNZUXZGenl4aDJJblgyZ1hIcFFIZWdM?=
 =?utf-8?B?UGdWcW1Nc2VuU3NIMDFZSFgyUjZ2MHU5Q0NKZ3RUVkxtMTh4ZGd1MHlodDNw?=
 =?utf-8?B?b1FFZDVkeWlmcVBnT1RCeE91ZDk5L1pneGNYbXg2cmVwWUUrR2IxcmFIYTBh?=
 =?utf-8?B?R2x6bjRJaTVOaGxXckFXdlI2SW9mT2ROSG5PUGNUTkJhbFNVMlhtTkJLSVVP?=
 =?utf-8?B?QzcwMEI4QUFsOFpEaU1RZ0E3U1VtUWFyTWYyVDJ2emExL3RSdDR4elZIeFc3?=
 =?utf-8?B?T0xOUmlDK3g0QTNrdU5uaUZtaDFrbWo3MzlVVWxSSEpTamdlWk5mVzhYRjQ3?=
 =?utf-8?B?WVRweE1ZbGxvU2VqeUUxVXg2Qnp5NEVCakRHeGNIVVVqZEwyUnIxMkRYOTFI?=
 =?utf-8?B?NkllSUJBbTRiaTQ2Um1pMzlMVkc0bEQ5MkZiVUJkZzZsN0NGeEVTUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0260f786-96c3-4460-c462-08de530f62ab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 01:51:08.0023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U05xRuqSWTAnhmq1n1kffLrQB126UZhH/oSXF8LlRKZx/G38I+9IrQfvNbmgzrMx9HRqxxXtzZPONUflRV2Vyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7639
X-OriginatorOrg: intel.com

On Tue, Jan 13, 2026 at 08:50:30AM -0800, Vishal Annapurve wrote:
> On Sun, Jan 11, 2026 at 6:44 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > > > The WARN_ON_ONCE() serves 2 purposes:
> > > > 1. Loudly warn of subtle KVM bugs.
> > > > 2. Ensure "page_to_pfn(base_page + i) == (page_to_pfn(base_page) + i)".
> > > >
> > >
> > > I disagree with checking within TDX code, but if you would still like to
> > > check, 2. that you suggested is less dependent on the concept of how the
> > > kernel groups pages in folios, how about:
> > >
> > >   WARN_ON_ONCE(page_to_pfn(base_page + npages - 1) !=
> > >                page_to_pfn(base_page) + npages - 1);
> > >
> > > The full contiguity check will scan every page, but I think this doesn't
> > > take too many CPU cycles, and would probably catch what you're looking
> > > to catch in most cases.
> > As Dave said,  "struct page" serves to guard against MMIO.
> >
> > e.g., with below memory layout, checking continuity of every PFN is still not
> > enough.
> >
> > PFN 0x1000: Normal RAM
> > PFN 0x1001: MMIO
> > PFN 0x1002: Normal RAM
> >
> 
> I don't see how guest_memfd memory can be interspersed with MMIO regions.
It's about API design.

When KVM invokes tdh_phymem_page_wbinvd_hkid(), passing "struct page *base_page"
and "unsigned long npages", WARN_ON_ONCE() in tdh_phymem_page_wbinvd_hkid() to
ensure those pages belong to a folio can effectively ensure they are physically
contiguous and do not contain MMIO.

Similar to "VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio)" in
__folio_split().

Otherwise, why not just pass "pfn + npages" to tdh_phymem_page_wbinvd_hkid()?

> Is this in reference to the future extension to add private MMIO
> ranges? I think this discussion belongs in the context of TDX connect
> feature patches. I assume shared/private MMIO assignment to the guests
> will happen via completely different paths. And I would assume EPT
> entries will have information about whether the mapped ranges are MMIO
> or normal memory.
> 
> i.e. Anything mapped as normal memory in SEPT entries as a huge range
> should be safe to operate on without needing to cross-check sanity in
> the KVM TDX stack. If a hugerange has MMIO/normal RAM ranges mixed up
> then that is a much bigger problem.
> 
> > Also, is it even safe to reference struct page for PFN 0x1001 (e.g. with
> > SPARSEMEM without SPARSEMEM_VMEMMAP)?
> >
> > Leveraging folio makes it safe and simpler.
> > Since KVM also relies on folio size to determine mapping size, TDX doesn't
> > introduce extra limitations.
> >

