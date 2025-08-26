Return-Path: <kvm+bounces-55735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C98B35775
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 10:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B018B2A159F
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 08:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD53428689A;
	Tue, 26 Aug 2025 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9gV4wgR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AA827D77B
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756197758; cv=fail; b=i36ZBb+QVGkL6jV7TwrxbTaTl7O7pPqx63yoDXyS9e2tDIWDTlcckfUD9XSGV9BqMW5wcw65OhFrSBqiyXczyPmltepLXR58JYBmhJVVPf6ZQOjln3ymbG+alX8VbfRQ+urgw9qDGcSK6CEbv5KoWIOrpKRAmkAbKPeP+rjV14M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756197758; c=relaxed/simple;
	bh=7g4XmRlB075YMrAWpa+0fpTaVOSy6Ln6O+/VDAn/JHM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=daAGgcaPMxCn2r76LhfTnnBx1bdHIXuYAqIwJvEejQTr1g7j5lWlRYjW1qPfzt+l7Z6Fh80GAu9QpUF6WOJKU7w+4Bgulvq6BcyAcrae/kbBfA2kON3jE7Zdodt8rdeJ80QPRSz2NzSwAIjBDeBr/s3sM4TURBLDk/UxiyHDEsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9gV4wgR; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756197757; x=1787733757;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7g4XmRlB075YMrAWpa+0fpTaVOSy6Ln6O+/VDAn/JHM=;
  b=e9gV4wgRXann7ql99s8XLPV05sKRVEE4hureT+EOrsi+XEyI2ZtfBz0m
   WfqQ3Rajv8PFaQquAjaIO47KlMu/e53fmUXgAKFPMLxGzX8jx1lRjpT9u
   00OTbTv8tH/2y0NnD+z1iwD7RoPKM6+ioLDKpcX12poUATr2zCEfAozL7
   Czt8GKIW6m8R05ULQMHJU3G5kDS2jB0GZsVx+PcZBNRHMquxa0qsYnUk0
   0GFwlP9GoZ3av8KVGE2gDnMF28egGYdT55NxXryUpOK/9wfamVeliccsj
   xCWRYzUPyiO2UT/sDz5Y4y/4TuJpgeizAQp8/pFGfWngcMdSSCPOcgfmS
   w==;
X-CSE-ConnectionGUID: EsOK8D7+Rqe6BsmZDAdLyw==
X-CSE-MsgGUID: +yWIbOEuQQyUmMY6XoAzCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62254755"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62254755"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 01:42:36 -0700
X-CSE-ConnectionGUID: Bg7+LEuIQ0Cu7ZOyVC8x2w==
X-CSE-MsgGUID: DSbEBW/2QYu+BS8USwf5xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="174785206"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 01:42:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 01:42:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 01:42:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 01:42:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYC5zAqwZz6o+i9YVELx21I5sWI5yvaWl/D8kFpi+GHCkl0IOaeEORsnQsnqkIW5vy5Tam7s0WN639QwC6qvEhgGRqs0k84iyaugi8mqyWZyFdW295pyb4JahcLGV/an5Fwww/meKfOzM2c+8DLrRVJJ7098xm+ESgJHWp8ArR7yeXpQyXc66M8ZCGATBjaWQc5e/poduAIqhiHRTOBPSO6C5qO7FI4u0TAnQ5PW6Oz+tZWK8KT2afwdjIleGqF+w/ON/GtIdxlTztVlplpQYsyJNUGNz5iSjCxA6fUbMNSu/ZCvjCSYFenrGGlAS9YH1Zv6vNsgqrPeS7nkJgx/hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+d3Zwbgi5qprOGzsi37SR5htA7aPxzrbaXNbNoHFQKc=;
 b=qfsbDO2lmUTfASOq29Jzwknl4d2HFxfBhzUlVw+7+3c7Pi+ebCi9jtZN0qTS1RTaO54mgSPrq1rJ/f3A30KGwHqXZS8TDzcfYvTObzR6RhoFhHU89s8QDY+91sruJEcp5q70Ct9otGvtGTUj9ICJirhxZeMTZTLjWSbKQFhLGCApD8U7d5YMzRxg8JRZyqqIOzKJ10cBzabKJLPemAk+9uUb8CGuRhAk0Qwub7s9+ZEsvMJam33fscdaqqFR06hchhNqmhLpaGEWt0xOumuSHK9aA+YtdJhfC/a/lOg906owUBW+C8amX6LBACJzLchoEbOOfA5/8ULKpjZ6ZBP6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CH3PR11MB8563.namprd11.prod.outlook.com (2603:10b6:610:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 08:42:28 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 08:42:28 +0000
Message-ID: <2b5a8cd9-2ab4-4386-95fd-ea70348384ea@intel.com>
Date: Tue, 26 Aug 2025 16:42:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/2] nVMX: Improve IA32_DEBUGCTLMSR test on
 debug controls
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20250811063035.12626-1-chenyi.qiang@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20250811063035.12626-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0093.apcprd02.prod.outlook.com
 (2603:1096:4:90::33) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CH3PR11MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a6dc5f-ed10-4d41-cbcf-08dde47c7d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SVorZENpcWVxdTU2ZUcrOS84cEhKMHJPZ1AyZXlTTTMweks4cHlRTjQrSlJB?=
 =?utf-8?B?K0NWQTRJOG9Oc3QzU3B1blA4aEFvQkdRY2hnQ2ZvcER0eGtYMnB3T2MraHZ0?=
 =?utf-8?B?TWZTb3lnRWtyTENYS3R6c1hXZWMyYU53aDFCTUNKenVRNzl4bmtFTHdndFBD?=
 =?utf-8?B?dGt4RjdGTXdpVVV5Q0ZLZ3VoOTNHOGxQK3M1SVZGblFYelhSQXRGMWlyZUZz?=
 =?utf-8?B?L1JxL0IzdS9GeTZHYmkxY3BuRjFRYkc2UXZrdnlMY3BjNG5xS2RDZWZSQTZY?=
 =?utf-8?B?V3RaakpYdkFyTDNyb2o4YVFQMGs4L09KR3YzOHJMRVFlT3JMZjNSb2FGTFow?=
 =?utf-8?B?ZllZY0hFb3lkUDAwQWZSRlBzaUR4U2tPdnJKWVAzazJDalJXdkZyS1RmWits?=
 =?utf-8?B?Uk5aNkNEbmZJSldkcWhRVFFwY2dQK0dWelM1N3B4dzdUVmljMUhjTkZmNjBN?=
 =?utf-8?B?SHUvNVZpTU1SU3RFQ3p6ZUtqUkV2bUpPc1plL0VRcWlFbm4vcjFDOHlNbWxK?=
 =?utf-8?B?bmcxeitlMVVuUlBXdG15R2EzWElpa3RyZlRWMnBGdnlGcGJseHZBay9XQXlt?=
 =?utf-8?B?ZWVxLzBPdk9nVk8wK2xvcTlJVnFDY0lGbklJZXZqWXZ6TVk4d1pDWEY1VDVY?=
 =?utf-8?B?b3AyVE41VDJjb0wwQnptZWVyR2RGakJXWkNTRUplRnZDWHA5NUx6NCtzWGh3?=
 =?utf-8?B?YVlhNWRxM1NHb29OVnR6K3g2L3hVNlQ5dktaNTVYOUVETkxIcUJKN09ORVhn?=
 =?utf-8?B?NXZkeE0yM0dVSUFIV0VCbEp6YUJvSmJxRWczSWc2Sm5JNm1UOCtOVzd2b0Ri?=
 =?utf-8?B?SlMxSk50R3ArODV0TThDUGdaQWtHUVlEMTA1dWJjOEpZMUFLMzVHQkx1ektH?=
 =?utf-8?B?VE1BTzhWZWE0cGNMWXZDY25UZnBnZEFxZU5adFBrYzJYbno5TVhVNUxYYXN0?=
 =?utf-8?B?TUEwL2J6bkNLRlBZYW84d2FRN0pNQXFkbHJuMUtjVVdNTFE2QU5GM2grS3Uw?=
 =?utf-8?B?aXBWNEQwVVBXYURoeGg3SS9LMnZTTFgxRHU3YTVWdkFFb1lBMmdPZUhTWnpj?=
 =?utf-8?B?Z0Fldi9UTll1UFVac0JGMUxDMVdSTWUxSnBhZjc4NVprVk93MlB6dnJ2M1Qw?=
 =?utf-8?B?YVROSjNWM2VLZnFpUFVuSVc3K3EzRE1jT0lpSWVPSkdyeHQ4R0orUS9zbnBz?=
 =?utf-8?B?bE9jTG8xZWE0RktEYm91ckZsUjlQLzNKWm1LdTU4cDB5Ri9IRmVDOXdzT2Iz?=
 =?utf-8?B?ZUR2dThOVjlvTVhpdzg4dUpINUcwM0ZBNnRhbnJDcC9HZFEwUUt4S2o2ODlZ?=
 =?utf-8?B?akV2d1Q1Mm5UczhpS3hlQU5PQ1NITU9kMzR4VVN1cHEyTThJMjYwTm9wTk1C?=
 =?utf-8?B?VlR3VmdhRjErRDlVYU13aUhaN1RZa0sraHFCQlRyZ3I5VDVMSm9ZaXc2NU53?=
 =?utf-8?B?cXlTaHdIZHMwUVU1RElPUlJWOGYxSmRsaUdFV1ZsSzQ3c1lONkl2MXluM2N2?=
 =?utf-8?B?Yk9HMTZzM2cwZGthRVNzdkV0cldhN0pHNFh0c3hMbllEblFVbW5YT3Rxd09L?=
 =?utf-8?B?YzAvL2NBYTl4Smltd0JSS3ZPcnQ2dHlEUWk2RXM0c2pGL1loVStralZicUdp?=
 =?utf-8?B?UVhOLzBnUzg5dVh1dVRTc1o4MTE3VHZGMkRWcDBDYnRGY3Nuc2h4QTJ4WXAx?=
 =?utf-8?B?SHVWaTIvMjR3V2h6T2JPRFFvalpkNFgyRWV5dlRTeUlwK2Z6M0xTYU8raEs0?=
 =?utf-8?B?RG9QdkdiSVpWZnpHbGt1bWVUbTdHdkdkcGo5VWF2VzJtWWJaU0t1N0cvQVFv?=
 =?utf-8?B?Ykg4RDRKd3Q4VFN0VDVZcm5ISmZvSVFUWXVXVlFMN2RMWkY4VUF2RVFvT3lC?=
 =?utf-8?B?QUR5dU1jOE1ZWmxCRTJIaUVGd1lGZVhEOUR6aWN6UTQxZ3JFV2U1OTdnNzNn?=
 =?utf-8?Q?eWFljQ8sfKY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmJTOGRJdThTWk9tZUdaL3A3bkZOQUxOZFNnMmpQNUFDKzdhc1V1RW9iUjlv?=
 =?utf-8?B?SGROSkczeGNIUjBHMk1QR1RhRkRlNDNjcCsvNkd4V1AzQTRxUTl6blJzQlpG?=
 =?utf-8?B?OXVDeGExVFgvZ3IyV3A5L1lqMkJ6L0FDY3VGQzc1blBuck1wVnhjbCs5ZlJI?=
 =?utf-8?B?WTEvdVF1TGxZLzdMZ2haWHArRk9sZ3p3K0RLRlBZTnMwZXBFcVRzQlo4TEE1?=
 =?utf-8?B?a0c3c2pxS0ZNazMvaHk1dUpTYS9LdElVaWRsMDdEVmdJa01MM2xyODJ0UFFn?=
 =?utf-8?B?N0xXOXVORG1zaGxQUHFpNVZIRVNJUkFkYlVyMHo5RlZzWWduRk9GM3lLRkVh?=
 =?utf-8?B?L2dHZ3ovVnJOZksvWkk3VTFIQ0FDbklOVmJEN0cvYnk4TlJSb04yNTJFbDg1?=
 =?utf-8?B?bGxwZWtxQTNib2xlR3NtTXk1Zll1T0NFNzF2ekhkakVDZW93VnRibXRkaWpr?=
 =?utf-8?B?ZERuNWdPaTYyOGVPNWQ1YUh1N3NRd0hnTEkrQzhPQVpGSE0zU2dWTlZhUWtz?=
 =?utf-8?B?YnRXQzl6UmxIaFU5SFZlR0V4ajkrY1ZFUEdrMmVuYXRDblluQnE1Ry9SVklQ?=
 =?utf-8?B?ZitBN0cxZ3JzcUN5OXdnbkpLOTJ1RGRWVXVacHNMRFNWdDdMV0FlbGFndUVx?=
 =?utf-8?B?SmpsTFFEeTM3djd5WW43dzN0VzFIcFdLZkgzWG5lcXJuYWJJa0NuY3hmaXEw?=
 =?utf-8?B?cXlMVnZudzZpVkQ2MmMyTGdraDdmM1ZKSW9MVTZ0ZlYvMm9GQ3JBVEtrNy9q?=
 =?utf-8?B?OU9xSUpFSmVidG9BL2VNd2xuZDUrTWtXTDVBZGhxZVBhTE5GMG5naDQ5dTlr?=
 =?utf-8?B?VjZBRnVOM3lrYjZ1eGlUbCtqM09GQXc2dU5GQ09oN0EvSHBZZnAvd25mVDVx?=
 =?utf-8?B?VTVNcFc3YnBYbVZCeXVzNXg5dURzTjhya3JzMG9GR1FHNDJRb05RdDlJWGVl?=
 =?utf-8?B?VUJncHJwaC8vckRXY1VHVzE0OEt5cHJ6eTNhRFdOUnd3TEpOcEZOa1ZGRmd1?=
 =?utf-8?B?OTVhNytOZFh5S29QNS84NHhCenl6UVZrWHQvQnlnVDR2SUQrbWE1T1Z6VkpK?=
 =?utf-8?B?VmxZcFoyMFlVT1dOamE4N3hJVEI3U2VmMjFVcU5TZ0pudmRmNXEvSlVWa1E4?=
 =?utf-8?B?NzV0cVVmODlIVWd6QitRd2FFcHEvcC9uWFJ4RzlkMEZldS93V1BhNWcwek9J?=
 =?utf-8?B?MjVuVUkzNkhWNzRsOXJMK25OY3RaT1lGa1RSY21FNWFkVG1ZWTYzSzZsK0Rq?=
 =?utf-8?B?WC9nUCs1MFk1eXpKWWhwWXJpSUwxaFpOQ0F3VDcvR3BueUllQ25wamwxaldr?=
 =?utf-8?B?T2JUVFV5TDhOQm5BOGRsM2Z5eVZ6eno3WUFoaEZBTGNVUk1kc2w0V0Vibmx2?=
 =?utf-8?B?WkpoRExTTFZxMVNXcmp2b3Q1TTdnMGpoYmw5MW9TL0pmQlVhc2hUTEFZd1dI?=
 =?utf-8?B?MDNvMmo2T3J3SkM2OTlzUzhZL2pVN1VGaTZ5K21wTVBKdFNaakxNaHljc3FE?=
 =?utf-8?B?alJtRUdxY2RIblFpclhJK0lsM1Z6TjBBak5KUTQ2RDBVVk42NzNUNGViSzNr?=
 =?utf-8?B?cTdodkpZdjlNUTFDMzI4WjBCOXBaenFEY2thQjRLYUJpRjllWFNCY3B5ekdD?=
 =?utf-8?B?V25UVUJvM0M3cFE3U1pJNnJCM2tZUFI2R1JGQlFsTmFRMVM0TElwdFdWeVBj?=
 =?utf-8?B?QjJ4anlXSGdhaCtkSGZialVXbjdMM3drVDQvMm9YYjlUQkplVVE5dTVyZjhQ?=
 =?utf-8?B?ZHU0Y0F4Y1EyN2dDa0RRT1o3QjlMQnVYUTUyS3IzclI4MjRJNGR5eHkwT254?=
 =?utf-8?B?a3duQVJualcveVVIc2hyYVd2WDV0Tk13SkpSZ2MzMysvNURCSVVvTmpJZG9u?=
 =?utf-8?B?RDVGNVVuRjhlNDArRk4wSEhyZUxCeU5oSmJ3RUloa0FYU3UrdU45R1VTQmlL?=
 =?utf-8?B?VG8zNlVnbXcyRHZLWkNXU3Q1Z0JRaElpaDhEWGtkV09rOUw3RGh4eUFsVU1G?=
 =?utf-8?B?OHo0R2V6RDZMeFpadjEvMk9hY3VBeWE2enVrcTBRQVA3VnU1aHNxVmlod3Iw?=
 =?utf-8?B?RVFsL2VQblRzY1NmcWxzWFpPTzRHMUd6a0w4enFzQUZyaW1xOGxBSVltL253?=
 =?utf-8?B?eDNsYUF4ejJtb0Y5bUV1WlVwamRnUHdtN1BDb01hQURMOU9GYTVxQ2NnM3cy?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a6dc5f-ed10-4d41-cbcf-08dde47c7d43
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 08:42:28.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3vuCNcy4WkKdm004TjtCY8yzxo4YABwJ5q9jmx7OoWOhH/Bd5dO3w2foUgfp6uwTvX9tYujwC2nvKk7IuUncQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8563
X-OriginatorOrg: intel.com


A kindly ping.

Hi Paolo/Sean, any comments on changing the nested debugctls test to suppress the warning in this manner? 

On 8/11/2025 2:30 PM, Chenyi Qiang wrote:
> Current nested debugctls test focuses on DR7 value and fakes the result of
> IA32_DEBUGCTLMSR in comment. Although the test can pass because DR7 is the
> only criterion to determine the result, there are some error messages
> appearing in dmesg due to accessing to BTF | LBR bits in IA32_DEBUGCTLMSR
> with report_ignored_msrs KVM parameter enabled.
> 
> Try to avoid these error messages by using some valid bit in
> IA32_DEBUGCTLMSR in a separate test.
> 
> Chenyi Qiang (2):
>   nVMX: Remove the IA32_DEBUGCTLMSR access in debugctls test
>   nVMX: Test IA32_DEBUGCTLMSR behavior on set and cleared save/load
>     debug controls
> 
>  x86/vmx_tests.c | 134 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 102 insertions(+), 32 deletions(-)
> 
> 
> base-commit: 989726f28e1e2137a5cafbe187fffc335cc15b2a


