Return-Path: <kvm+bounces-59559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E13D1BC0523
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 08:22:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6783034CA3A
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 06:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F55D221FA4;
	Tue,  7 Oct 2025 06:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F//e+L9v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8C1B2186;
	Tue,  7 Oct 2025 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759818148; cv=fail; b=EJkyGTRFZH3guc2uB6YiM/+vo5k/oj2RzIlZFcUP/P7s5U4cI+DkkrV8oa9Vt3YVUO38CU6JGYqC9AQh4j9j9FadrX008sg7QbVWBKzDwZ+ndHF9usQaEuLwu7Oq7Gr3ExdhcatdNs8O7K35JZWVmvsvVNpFUoYDv7qdRSlND1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759818148; c=relaxed/simple;
	bh=Bp6WAtwPBhWQe8WflshuqV2j7ZV/jFwNelCuLiHiG2E=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CpYHfQNFIDxi8f9IoFWnqGkMREDuVP6WLsV5QkUD6VQEpf4ILWyAsJ1xcRQfVJC1oxC6ILV/M6vq21xz/3V/8IeB52SRgDnNjQQspOcDdYcyraBezK+irqVA7gsSX0QEIMU3+Agw6jq0htBZqpRmwpOyxzAbKgHpK/2gYFeNdVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F//e+L9v; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759818146; x=1791354146;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bp6WAtwPBhWQe8WflshuqV2j7ZV/jFwNelCuLiHiG2E=;
  b=F//e+L9vKoPgo5o8vD1LNRZl/GtazlSGnvv9w6T/YLDOJys8Vp+V7DaY
   lNqVxvWsaoEbIC0xqweYjgcy68YJ9XGyNWMu1JPoq6eVyYRsYKYo36qRQ
   Y14kLtDQjr3N08ZUhTSEOqGhiegfGCGEFlTy4t9WTvhfxPAq7WhqBYp/2
   UG0kYzbmf+dEEIlcKPwKroVSlTo1bq4BzrqSLDAq9YDM6h1iIrQQDY84Q
   p4AiUxYi83CSK4KqZTHP4fDN4gGfdCLZGSVpSWsta8N5Zy+akogOCMoZv
   rDO0z1PILbCA+Ho/wilLCJ9Ko6Rx70JXOh6CLNEGbu/3kS0yHkN2CUPyT
   w==;
X-CSE-ConnectionGUID: ilJFmUt1TvOX8lPyQL6WEg==
X-CSE-MsgGUID: 74P2WK54TSqcBMYbcpJ+6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="64613015"
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="64613015"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 23:22:24 -0700
X-CSE-ConnectionGUID: DC2KfBNwRxajbpx62zTBgQ==
X-CSE-MsgGUID: 5bE35rqsRYu/BuY0IOhdUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="179653603"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 23:22:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 23:22:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 23:22:23 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.63) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 23:22:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dqo8bQOugnH+IOsXWgnThgZ5ISxv0HqTSMqewANM/KwOHvK+mEWKe1DvIzhUg8HsxlpZdXFLbGlBiqmTqI+xxCgLq9Qx28INygrwvqhyQE1AmeQM9wPkWETrsuMF3jhrSGt68qlFJyd4T9lunEizGXJG6VfqhW6PB2hp5qy9FjtW/20Ftkebn/WRVfc/sdC8thhKAsyJCj64vK464Mp5d1b9aKvXfiAqhBvd3ZVRf85SX4JIzpMacXraw1/OJErlFktZ3YcRDGr7CcDVPxColiKgi5q3zPnry+QOcx3X6SgMZGvPNmwkJKzBAOcgoYFFypaDVdrVJSdJAMQ7CM/f1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhbU6vGyBigIH38kf9AmoeSR+C45nK0cum2upMcY48g=;
 b=aYYB7wtHL6lU9alX+Q3fi1D9xgYIp7vBWx5DSyMqE+5b6SzB8wGx45g5kqBfZckMJJgLkRdgqbxNbwJ+9ZmO+1vNhLqG0GxzdEBOgKyHGOjosxrAtvVwrFmPJcxQ8JGZPOqr24KnCfBubcmEwf4j/f8lSNvWSGUc5n9a52jKAmK2xSxsEX4vJAavS+oeeBa8qpENkwerWwdMG3wD5jwFqKnBRp6n12ICTEmiKjyOKNQraCZWXQ2erByEXdQ9gxNNZzxb2s/vnkYnDYt9A4LysIJ6QFSq2sFnnktPfnPfUCSvFsIYxWveLaKadeGT93Vv3TG0KhZ+U6vAA7unFUQDlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12)
 by SN7PR11MB7140.namprd11.prod.outlook.com (2603:10b6:806:2a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Tue, 7 Oct
 2025 06:22:17 +0000
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525]) by SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 06:22:17 +0000
Message-ID: <00d0f3f3-d2b4-4885-9a49-5e6f8390142b@intel.com>
Date: Tue, 7 Oct 2025 11:52:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: REGRESSION on linux-next (next-20250919)
Content-Language: en-GB
From: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
To: Sean Christopherson <seanjc@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
CC: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, "Suresh
 Kumar Kurmi" <suresh.kumar.kurmi@intel.com>, Jani Saarinen
	<jani.saarinen@intel.com>, <lucas.demarchi@intel.com>,
	<linux-perf-users@vger.kernel.org>, <kvm@vger.kernel.org>
References: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
 <25af94f5-79e3-4005-964e-e77b1320a16e@linux.intel.com>
 <aNvyjkuDLOfxAANd@google.com>
 <3bbc4e6d-9f52-483c-a25d-166dca62fb25@intel.com>
In-Reply-To: <3bbc4e6d-9f52-483c-a25d-166dca62fb25@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::17) To SJ1PR11MB6129.namprd11.prod.outlook.com
 (2603:10b6:a03:488::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6129:EE_|SN7PR11MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 78881c69-8ef6-4229-f9ae-08de0569dcf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eTlDcWVIMW5aRTIyYzBCQ2tuSVRLaG1CcHc1QWVvb2xUSUQzM3FDQmo4bkV2?=
 =?utf-8?B?aFphbHlCVkR3cjMvRHM1dGVKYU9IYVJNN2l6d1AydjJ2cDk2aU5USlU4b3hh?=
 =?utf-8?B?aDIyUjFMaWdQZ1QxODlLMy9CUTYzK2Y1WFV6M203alhvWVErSmtWdTNwbFEr?=
 =?utf-8?B?b1JiZWl1ZFpyd2hYRUJRbzJoaHJCb280TXJzenozYzV0YWlLT2lRVVJ0VDBD?=
 =?utf-8?B?RldVdUVMQzl5bk9xTWJnMVZiWGRCU0xReTNtcEE0aWtLc0pTdXZ1WmpVRW9H?=
 =?utf-8?B?SUdOdWlxMnl1R2R6VkxjT21uNTFJV0VNeG5EWVhjR0ViSG9tNjRZODRaKy92?=
 =?utf-8?B?UnorcmxFUWxCQlV6Z3hERitoTzlybG9sREVYT2NvTjBzYTF1SWRaMkVIV1BP?=
 =?utf-8?B?OWJwdTNQRlB6NWdJMlluVE5JdUtla2MxMlFaa0lieDdJekQ1Yml2d3JKS25F?=
 =?utf-8?B?RkgwQ3lUdlo4U0w3aTFscVF0OC9jYnI4UWc2WE1EbU5qTkpvUjl5VzdmQXRh?=
 =?utf-8?B?VGRyN05sMGFJbDBjQnlYNG82RE1sVmlMc1RsWWFYUS9KY1VGRi9pSFlpVDR4?=
 =?utf-8?B?OXpuSWV4ZG8yOU9lSm5XbEZsTEdsR3c1Z1JpUW9WYWprUFpxTkh2NEUreE83?=
 =?utf-8?B?TUVrU25GdC9FYVNOa2g4WEFxMHBvZ0lXNDc2MnB3ZUxVK011cDNoOXJzeHo0?=
 =?utf-8?B?cUc5eHdMZFVXQ3RuRUNaTnBka3dIU1ppU2pxRVhuNWVNRVk2RGxxY3Q2TE5B?=
 =?utf-8?B?NTlnWFdiQ0Y5ZGZyL21JcXd3aC8vblBhOEY0YXdDNU8zQWNiK1B1ZThscVhn?=
 =?utf-8?B?SjNwQk5OTGl5cnE2TG9YMUdkUFhxbjVvOFNWYmNJKzAzWEhjYUZMb3c1UDFV?=
 =?utf-8?B?ZGloVmxCSW1ValpkL2NycDgvcXdPRW40MThNUW5uaUlwTDFNVGVkVHZZOTc2?=
 =?utf-8?B?dGdkQ2pnRkI4VFp1bytad3BRMm0xNXlXZS9uSE9hZ29yMnZLbHEzTm4rdmQw?=
 =?utf-8?B?cm5ETUVSVTZuTkhzcGJJNDg5eTN1ajNmRUNRQXhDTmFBczNuYVJIVEUxRS9w?=
 =?utf-8?B?dmVtRWxIblpacnVTZGZmVE44UGNQWmFWQWhZUXJNVUNYWTlnN1RvMkFqbzlL?=
 =?utf-8?B?YVJkSVZTOUVuaXJES012cXVLdEtMd25Sd0VNZGJPZFArOWVvWlR1djlhaW1s?=
 =?utf-8?B?R2VIVXU5T2l1VVM3KzlLOHR1eGxJUUVCdXRFazg2dmdxOUpGcmIySXpYWU52?=
 =?utf-8?B?TG9LZkJwdmVYOVBORzRzditEdUhVVTNKdDBpZTd2MWZ3N0JSUVBIakxwNGl3?=
 =?utf-8?B?bmYwMHNZVFpackdPQVliWHFYb2toSTZBS21aV3Q4UklYZWZFeWdOVFU3WTJM?=
 =?utf-8?B?aXNtY1pQblduQ1NnV0NzaXBLTGtMbVhwWCsvWHhmM2dVaFZ3YTJyWGtOSHJU?=
 =?utf-8?B?a25HN3laZXI5NDhnZlYvcDhzZEltUE9MeTlWWlM2Z0RWNE8vRWlLWU1MeDJL?=
 =?utf-8?B?aVR2T0ZPS0VsZ09FbFJic1dXSExDcndlTjM1WHZEdHdHVVVFZEMwMWtpWFky?=
 =?utf-8?B?MUZ1dXphOEgwa3BaNjFLc1RMWUduMVQ3YkVWemduc0Jjb0FhY2lKRmthNzNr?=
 =?utf-8?B?RU1KSVRIc0poaDVSSmZLekdkWFN4RXhYRkNhNDIzdUViRElua3JpU09yQ044?=
 =?utf-8?B?bGJnRHE4N0tkZjU1TzNTdDhKUjBOb29IR3czWUdmOWo5UlRRT2hHcTR5MlV4?=
 =?utf-8?B?QUxtcUlKbG11MTcybGpFKzhPL1pvSVRaazl4cXlvUXBNazVWM2tRbkNDRU8w?=
 =?utf-8?B?TytkUUxKemlkQ3FBRUY4RkViRFBYanZQWHF2bEVmeDdySmFKNkR5aHV3UVNJ?=
 =?utf-8?B?RCt4TGp1TnFmK0g0UThVR1N3eFpWK3ZyRFlpOFdEWUZNYjc4cWJGVzI5Mko2?=
 =?utf-8?Q?ObpzEYfCRGTuC5CLWJraID8gbgb78wh8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6129.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUFNbGp6TDhEak5zd1piTkVDSGpDVWZPTXVnaERTOUFRaGJqeVhPbzFWUHh3?=
 =?utf-8?B?Q1kxSS8wVHhzWEZaSDhXeVBDak9TOW5sc0x4VGFYNXRydGRyOVRBdTE3SnBW?=
 =?utf-8?B?RUxMU3VwYlVFUi9kc3hOWG41SDNpN0g1RWZxcFhoSHNieGwzRDQvaUhHaUJQ?=
 =?utf-8?B?TjdBZU0vYzdXRU5sMHNRZko1MWlpdThYK2xSNlJXSDZjSmRIRGpQRVMwdmpx?=
 =?utf-8?B?eVpxekVHUjNOMGpXdEhGTFVpbWhHY0sxbDhkcGJnQ2dRbGhZbjlNYlRFQmUy?=
 =?utf-8?B?bkpwMG1YNHpmaEJNekVaa2FBZkgwZWxOMDVUcVlJUzVvVVB4VmVzNGF0VWNQ?=
 =?utf-8?B?WnlpditRT1JPRDlBSDNZYStpRkVEMlYwL3lrREZHOUliWHRya1U2cWFXdW9n?=
 =?utf-8?B?ckRIV0dxQmpaVUFrMjY4YXgwNWhKV3BhN1ZiRTZHMmpVa2NoUFJuZzdQNnoy?=
 =?utf-8?B?eHBCTGJSNHZwVlVsd0hVcDFXWW0rSmxhcFNzTFg3dnlEQS9wMGxOU25wK2Jn?=
 =?utf-8?B?czh1YlhoZjFwU3phRGJiT0t2enB1OGRCeDF3cEpnWG1XMU5JS1Znblk1OHhN?=
 =?utf-8?B?d25LMzhsNlNOZnVZNHMvVGhTeEN5akdEWGpEMEN6Zmd2V2FpT1BzbVBidUNU?=
 =?utf-8?B?Qi9JaDFTUzBKcWg1NmFYaTdyaXZ0cHNQT3VrNnY3bndJU1lTWjVWMnJrU1hG?=
 =?utf-8?B?bkJCWG1YNm1DVFcxUW15bEVoaUY4amY4MVdrZHgwUngzWHA3cTdIRHd6amty?=
 =?utf-8?B?SmdSbXY1NWdVdTBtUXdHMWlVQktCRXYxNG4wUDlmSkZCbWhpcWVjSnlMdEJI?=
 =?utf-8?B?c1R1SmJTcXY4ZFhqRDBhZnk3QU5NQlF0SnBUTlVZZWM2Vk5keTBoN3VSWEFS?=
 =?utf-8?B?d1l1eXB4VGNHM04rT2Jod0VOKzZwMlRUK3N2dU5pbkwxTENUVHUrRjVNTFRD?=
 =?utf-8?B?b3hpbmFwSHU0U0dlc01uTGxUUjkzQzgxL0tZZmlRR040WUZsQmNYOG1Ga3NQ?=
 =?utf-8?B?MnM3eDNlRmdDTDNXb2tOR3B3cnVPa0poRUNkNkNWMFMwRGU5bnI4QVh6cnNK?=
 =?utf-8?B?aXpZWHEyczJZZXlyb0Y4NmQ3RW0zVGtNNmdGNEtvVEx6Yk9seXh3dUhhTXNB?=
 =?utf-8?B?aFl2aHNwMG1SZi9WMzhpekNsN0N4U3c2NlZtMjBJSTJQendRdTNrYW9ZMzhE?=
 =?utf-8?B?bDhwZUpCT1IwVHhZOHdWTy90bzV5Q1ZOeHVEa256OW5BdSsrV1RVK2RMcmdR?=
 =?utf-8?B?T2dKRW5oSnFnWmVXalVzRGgzZ3cyUHkxWWhHRHZIRUpPdjRPVXBUdmhWY0hF?=
 =?utf-8?B?VVp3VFZNMGp0bzNTV0dxUlBUTGxkd0l3azg2elRZaWlrRXFnSW1xSHhTdnZh?=
 =?utf-8?B?R1ZDbE1nNVh0NWxOZkxDKzJhalRZcEo3V1ZkZmNUVU9hcFVObENMUFNQa1ZH?=
 =?utf-8?B?OThlZmhpU0ZQRkNJRStuV0toejY3RnJJWGhvSlZSTFNvYzd0UVk2ZStrZDM2?=
 =?utf-8?B?SkZrcnJEWmRGQUVSaDRPVGVKMjY5OUJQMTI3KzM5MzM3OGhSNzZTVVpVUUNw?=
 =?utf-8?B?WUxSc2tZek9vc0RRbXlBY2F6aXNRVitEb0o1TEkzNVQvQWZyU0dZSkpmTnl6?=
 =?utf-8?B?dTJTT0lNWUxmVlJtcG4zNXF5U2hrT1JuS2NnWkw1ZEZXZ21TeGFWOUdDN2c4?=
 =?utf-8?B?OHpnYnFZdVVjYVVwcks1L2RRSEtIVnRMa3NuSWE1djc1UlhxQTFwTWNieHAv?=
 =?utf-8?B?M0FHZ050d0RMZno0TU4raXlJN01iUUkwcHVyR0pGSmxxKzd5bitvSFI4L3Fm?=
 =?utf-8?B?TEVSb0NhbFlWRGNQcE5WRU1sV2V5SDF5Q3ZPVjBRcVB4ZW5IYS82L3RpUG1y?=
 =?utf-8?B?Szk3Z28rZmFnRjNUQlRJOWJIaXlQaElGcVRMYllEMkc5RmVkdktzclRyYnZn?=
 =?utf-8?B?bHlRN1Q0VVpXTWJVK3ZUaVlGMVJ0NEZIckV6dlBYdlVxMXllK3dhZWJKQ2hv?=
 =?utf-8?B?cVo0cDlBQ0pSMjVHWE1FM0lTcHNiOExsbW1GSHRDV045NHdrbWFrMW5ONm11?=
 =?utf-8?B?UWl6b3Y5WDY5bWJlY1Y2RXJ3VlFnK1FxVG02ckhxSS9CSGJhcmtFOGRSc0xp?=
 =?utf-8?B?ZVJGVS90c3BQOUtFUjlUSWRJalV4UnhUbVJWNVlvV0dEN3UwY3RHQlpwb05q?=
 =?utf-8?Q?XNmmDoRZ2inwE8eks2k4Ock=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78881c69-8ef6-4229-f9ae-08de0569dcf7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6129.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 06:22:17.3378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhGWsyW27kGGWYnBw1oUS6LVwVER7R3WZddXkdY7vBsHZZc5dl2/GUKnBpmIsZ86tvNLMKxv4zwKPAEKcOhzU1/aFthP9b9UfSwEQixViww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7140
X-OriginatorOrg: intel.com

Hi,

On 10/6/2025 1:33 PM, Borah, Chaitanya Kumar wrote:
> Thank you for your responses.
> 
> Following change fixes the issue for us.
> 
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 40ac4cb44ed2..487ad19a236e 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -108,16 +108,18 @@ void kvm_init_pmu_capability(const struct 
> kvm_pmu_ops *pmu_ops)
>          bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
>          int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
> 
> -       perf_get_x86_pmu_capability(&kvm_host_pmu);
> -
>          /*
>           * Hybrid PMUs don't play nice with virtualization without careful
>           * configuration by userspace, and KVM's APIs for reporting 
> supported
>           * vPMU features do not account for hybrid PMUs.  Disable vPMU 
> support
>           * for hybrid PMUs until KVM gains a way to let userspace opt-in.
>           */
> -       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
> +       if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) {
>                  enable_pmu = false;
> +               memset(&kvm_host_pmu, 0, sizeof(kvm_host_pmu));
> +       } else {
> +               perf_get_x86_pmu_capability(&kvm_host_pmu);
> +       }

Can we expect a formal patch soon?

Regards

Chaitanya

