Return-Path: <kvm+bounces-44472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7DDA9DE9E
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 04:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 642D3840C6F
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B852202988;
	Sun, 27 Apr 2025 02:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFOSFUaP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90A7081E
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 02:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745720000; cv=fail; b=Jx1Jb0kBZxtF1pgEHPnnPsH+kkQXQxPmzDc2jKyfM6ZSvJcJVqRenyUj3dxPeqMRASmDjBPHQI/YM3gm0QC2M53AlD+gjryv0aqJcDkA0LdhX4oAYpE+nsnvxQ9teno2DltAWLV9cGrhQDZDGrz/iQC5NwKzESD6hL0UZtcuP7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745720000; c=relaxed/simple;
	bh=7Q5VfcOgnoGp+FmPxkK4MTcQplMO89abe1nQ9IfEOj4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NU+DPLnFB1GI5rO+AHey0dzt++gs8iVr3lQIUyihzk/q0H11+nrIQQtj3UUoX4TD72RJQS/ywSuCRuvjMi1gHLzZijEeSX6b4t8cXA4NOGVQtQdXBF39hXcJ6pKC0+rvAl5UJUWxfq2RUlXqxtme1vK0j9yI5g7pkwT0E5Mp/OQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFOSFUaP; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745719998; x=1777255998;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Q5VfcOgnoGp+FmPxkK4MTcQplMO89abe1nQ9IfEOj4=;
  b=lFOSFUaPLc5lDpHv/tugXjrvfIV+n3Z3u47nO2rU3Q//M7nWEcrQJNKe
   7x0N9ZOphGMUi79FUPxHNqsyYOlk0rURnG1p7TvAItnAweCOblTMUf46C
   B1ltfIZeBKir7Alf1zClzQnNxg/eSP+PgmgwbqWKeyXHaxyovpgli9fvH
   FvDI3HVHH/mhI6jtYj4oVjq5Uv9A/JB5gaFUe4ZHSKDSWme0JwL79aPsg
   40XQp/hZtl62tt+AC6iyBorF1beRqFuQccgVisPabYCQzhZjxRJe+cNuf
   kwDp515KWfPjXWgvx6mwHS0OX0Bnd5NcTOqvNJJ2OH5CT5J21mUpAmcNa
   g==;
X-CSE-ConnectionGUID: vORcW9dTQkeF1f7mJFIAgw==
X-CSE-MsgGUID: 4aCQZyzETY6McdgmNldfaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="57531960"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="57531960"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:13:16 -0700
X-CSE-ConnectionGUID: Ec4AROn4Q+WIr6WarUA0Aw==
X-CSE-MsgGUID: A0ptesquQQGCXddKmYvMbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="138025540"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:13:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sat, 26 Apr 2025 19:13:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sat, 26 Apr 2025 19:13:15 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sat, 26 Apr 2025 19:13:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQyU/E1DbdKpHADtTxupBdCv5+oLKeKGzsy4GD5rGMU9d2JAvs14R2nMjYbXb91H4wnhk4dZtCU1U3RAxQixj/EG4OkcihRYtVGGyuIAzvlo6z3kuMfgukYZmTIOq1XdsJpaQEnTFSnFHasbrysq3kJKKryQyVmN0O95vqVlcXTB0PkJjQynokRdxIgeBm0xCMLUtf+NXinuZd/a6j1lLUUFJ7kvCoUREZKbZ/61U/at0KObBFom2eTSyMyzdr/gAfyQN5Y/5IafPoLktrn2zGMVqHNNM455EhUV6KzCh2Refj/EPWbYauad3p09q+h5s/rPHnLfE/bAA02Yp8fEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOAtvAjJZqND9ul/ep0pqhDkRneT9zJQdeHcXfTmuic=;
 b=DMzGtcDIgQSatAcr5dU6KBgMIuxEcSnxC2+G8ICWiJxX1P7v+Q+9ouuyaxYwqQ8FpCtpTsFDF061eGj7AdsyAHWqIWTPzUGDj7Dhm1m4GPh8JhkXt8E26jDnIpijqZzhk+XZksKZzXWVF0U1ednBwlBEj3/qLyoqzwth46r5J4WXt3KxbgBL8LObW55Q+/OfoWkqelntsKBV+uhCmFvesLzha/vItnFAsn+mPrylbmLqGlE8uX2OCwe56UvQ4U0U3F0U/iV7dO3lh9u7DjOE2GOdshhHi1LhiUYsNZxuwN+KxnRgwbMYoQ1ySzAf8i0S2AVAgi2stCydTEg00o3E1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MN2PR11MB4535.namprd11.prod.outlook.com (2603:10b6:208:24e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.29; Sun, 27 Apr
 2025 02:13:12 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8678.028; Sun, 27 Apr 2025
 02:13:12 +0000
Message-ID: <16aaa2a8-f699-4543-b408-fcef69d596f7@intel.com>
Date: Sun, 27 Apr 2025 10:13:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] memory: Unify the definiton of
 ReplayRamPopulate() and ReplayRamDiscard()
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-4-chenyi.qiang@intel.com>
 <37cace3c-942e-457d-8a1a-fa37050428a7@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <37cace3c-942e-457d-8a1a-fa37050428a7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU0P306CA0081.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MN2PR11MB4535:EE_
X-MS-Office365-Filtering-Correlation-Id: f799465a-8234-4597-4ae0-08dd85310fda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RkxuVm9xWW5xWWIwaDcyWkZaNDU5ekVjWi9vaFRLTS9DRzgraXhCdFp3L3U2?=
 =?utf-8?B?dDJ2N1FiSVhybFVtOW5GOVdaTVloeEJkbEFteUl3WmNDQStlSTdlYzZxTkI2?=
 =?utf-8?B?Q01HN3BWVVQvcjN0NXhjcldOOWx0UHpXVGhJeVd5RDJGMlRuVnpsaU95WmFL?=
 =?utf-8?B?NVBBSnFRV3VEMXlLdTFSQVNMaDlRb0g4Rkp3Y2RqZGpyVC9uTTUxYkV6THBy?=
 =?utf-8?B?ZUoxTk95bVhqa1FRajhLQUl1MHk4KzJlVzdrWm5hQldtYkRJS2NKZDJHd2ZB?=
 =?utf-8?B?SUV5eTRtSUEyZkFINXYxTTdTTDdkMFJhWFlkUWpwMEV4Tmd5VlF1bnhPb2xL?=
 =?utf-8?B?Rk5Sd1BCZ3lUNFJnRmNwYzBJeUkwQWExM1pIbU4rT2ttWEtGT1VTTnFLWlBN?=
 =?utf-8?B?NEowRUdWUVZHRkFpbWRtQ3pEbk8vclFOUGhOWjdXdTd4MTZDcGUxa3p1SE5Y?=
 =?utf-8?B?M0hhcFNUQzR5YXZCMzQ2VldlSEhsaElGNko3NEIwSnFMd2thUEhBU1BBbW5V?=
 =?utf-8?B?Y1JlM1hRcWh3RDkvQWlyTkNBSnlKbHFvV2k0QStValZweVZlZ0gyZzBKSHB6?=
 =?utf-8?B?WjZISHhuUGRaVndVRXA5UVJaK0IrRnY5L29ydkRpVi9IUExmeFpWb0hvVmNH?=
 =?utf-8?B?Tzl4RUYyZ2loanlORmRJK0pOQVpzc3ByUU8wK3JXUVRYbVhyVHBpVW5QeUZi?=
 =?utf-8?B?b01tcTZvb2VhZ0lhRkRXcjk3Q0ZtV0h4NWp6aWUrRWdVSVlkTmVtQXBpMDJT?=
 =?utf-8?B?WE5VL2hQVGExY1pyOXllZFFqQS9MU24vYTl5ckdJYlpMSEZmZ3ZXS0NRK2pI?=
 =?utf-8?B?dGZNQzZHbHFOZEpSUGZ6cXgxS0dWM1NTNVFsUW5yWkl2QjRuRCtoRU9lYUdt?=
 =?utf-8?B?dXlDWkhDNExzRUtDdFJEYUdRUEtJbVY1Y09kbzk3bW1QUk9pQWtzYWJuaWJX?=
 =?utf-8?B?b3dqUEgrY01zR1FQcURMMjN1cDVJT2RrL3NEdGdTbFpiVnQvdnNFY0NKdDJl?=
 =?utf-8?B?WHUwaiszMDlKdHB1VW1UOFNsSXEzMzF4NXBuREx2emJla2pXdHI2WUlJcmM5?=
 =?utf-8?B?M1VyQjdEL3l6SytpYXpWREZYL0lGb2dHZGppaE5kTzV6K1VCY09xQmZUd0Fp?=
 =?utf-8?B?ZFNHZjlMS0QrZ1RSVWlHcC9HRFBmZGxmWTFSQzhUdStNSENtVmEva0hCU1lX?=
 =?utf-8?B?NzJTMXpVYXA2ZlFTOEJiQTg0dzdiL0xCRUMyOVpmaTNEaUFDamE3RkxHM0lo?=
 =?utf-8?B?aFVyS0pSMnZpbFdmTmVyeEhIZS9JbDhTQUgzNk5VTlk4UkJSZUNRN0tVNity?=
 =?utf-8?B?OVpPZnl2blVIdU9yR3hLc0NMaTg1aXpnaitWN2dtUVVEVVRQUHlpTUVQU29o?=
 =?utf-8?B?Zm1VY0V0MzBMdWNuUkdxK0lQK25EalN0cHpMcFJYdkVobVFVc0ZtRmtNK0FV?=
 =?utf-8?B?bjNYcE1pRTFPL2NtckFSVDVUL21OQ1EvR2hDQUxIK25ranNSSWJMSnI5bVpt?=
 =?utf-8?B?c1hONGtPL2FMdU9yWnJFRThHeEc1d082Q3BNNjlYVjJFU2Y0OTdJVTd5T2Ra?=
 =?utf-8?B?cEN5S1h4eER5TUptRkxzakRwVnN6Tm1wUFBMNTJpbHZVcWpIcHlFODdVTVZr?=
 =?utf-8?B?N1dmWmFyM3Y0MFQ1M3VEMmVaa1hDRXJJTnR2NXY2NVZ1WSs0K3Q5TTlWZzd2?=
 =?utf-8?B?VUszOG9VNzJFV3NSY3MzMGpacjlXYVJGWTY2K0tzeFpuKy9PZ2ZLVThaVXpl?=
 =?utf-8?B?eVNlUXc0cDJCSWFGVDNvMDUvK3VDU1Nab29LOHlGbUFnNitQaWJhdktjQUhk?=
 =?utf-8?B?OTdsOXYyT05vNVRpTVhqN3hoMitGdU1ody8vSmxnQVVKL3FWcTlHNFlKdHcr?=
 =?utf-8?B?cEdJWmJGWElnVnNUeW50ZTczZGpsckR0MEs3WlREYmRkMjRCTEhHVE1HZTVv?=
 =?utf-8?Q?09ZlaspPI8Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWlUcXd4OFczcW9hSDh0d1dKelVFZExtdkNPQU8vdjdOOFlIa0VKNVphNTVz?=
 =?utf-8?B?ZER1a25qVU9SUXBVZlpzSnFTU1RGZGZUMjViVE55MEZiVDhSd1E4dnByRjZD?=
 =?utf-8?B?Y0dHdzlZZW5jcUJ4d2s3cSsrUU8zOHpPaFUyM29xRzcxN1phcDlXMjMrMm5X?=
 =?utf-8?B?SFM1WmJib3hOWE03cTFFdXpyZnJHR09kOVFkTXIxa2svOEN1a1N6UmtrZktW?=
 =?utf-8?B?aGxoVjRlLzc3ZnQ4ZmFGYVZEenRPY1pPTk5uekszWTBxRU5yREpOWWtMSGRN?=
 =?utf-8?B?TUlJek1hODNpSW9ZVTRJMCtCQzdEbkJaNjBZZk1JbWRBT3FjODBoQ094VmN3?=
 =?utf-8?B?MVhaZzlqZVFoelgzQktCcGJkWE4wMmRrczNNQlZkR1RKb2NpYXRJK3hEZldm?=
 =?utf-8?B?Lzc3cnlHT0JMRnZ2d3FoYnVEZnZZaDhBelJjdVBQb2wyY3ZiS3psQTNSdmpB?=
 =?utf-8?B?Mk1iNkVMbVJXRlpLL0dxdlNrWWRseEI3Nmp4MFZaQ3R1OUdYZUtDNG5LTWRh?=
 =?utf-8?B?R0Z0NnhUVGJTSDhpN1BiMmVCdjgwNFhaSW0xb1dqQ1YwaXlRV2d3RzhtOCtm?=
 =?utf-8?B?bytJVzFrTFB4WE5xaVU4cW5IUFdTaUx4N3NCOHdtMmM5V0Z0WGF4SFZiNHBR?=
 =?utf-8?B?ODh0YzMxaDZyN1Y1WnNyeTdiM0RsMTB4cFFxKzIyb0M2YXVzakhYbVpmKzdn?=
 =?utf-8?B?T0VjZ2t5THpiUUxZUnEwMXkwWkMrVXlyMWtlVzJRakEzdFdFdkE2NlJiSHBk?=
 =?utf-8?B?NEFaMncycHpNYzRqTGdERy9iOE1KVVcxa29LVG9ZWU4xaS9IZ1VwNXo2bGd4?=
 =?utf-8?B?Q1g4S1dKaUJuTnhXTGRIc3JPczNTRFBsQ05SOTV1VzI0NnVQQlVhdXdVS3Zt?=
 =?utf-8?B?ZExFR1IrQ2dKUGh3QWxQUGZvaGdzWkRiZVkzUnp3SEtvc2FEU2IyRmNnUDlD?=
 =?utf-8?B?TWpxc0dKdS9SNFhxVnJhb0t2b3BnTjU1bEFoUlpKa0ltTG9sTndCa0sxUGth?=
 =?utf-8?B?QWwrTmUzc2MvS0RpellpL1c3cG9LdDVzbGd3Z2FQaG9ZSHIyaHlxdlNNNzFW?=
 =?utf-8?B?ckkrZFlZMkp6VHlPcndGdFhKUGVjbEVZb1F4cGJTWm1vL3NpRldFL1FnVTVw?=
 =?utf-8?B?T2paMUpPZUo3YnBua3pQS2c2VSs5UHU0OWVhNXowdzVnQTc1dkU0YVhYN2tL?=
 =?utf-8?B?WmRpaVFiaFpVN1FQSVpMM3FDM1N0M3FjanhRVlZITVdWQWdoWmxEcXVhanBt?=
 =?utf-8?B?RHR5aTgxd2NBSUFUdUthaTI4S0lGUWc0bG51cUJ3c1B0SnFOaStvNHBXNjhD?=
 =?utf-8?B?eTQ0SGZHUkRFMVBFcE9vZWx2QVpVc2NjSEZ0Uy9kR2ZacWRUdnVIbnZMdEtp?=
 =?utf-8?B?Q09ScFhqbHA3Z2trMnZxMHh3U2s1ZVBxQU1SMFlTcUw2amtjbDMzMHBvMVJX?=
 =?utf-8?B?KzhMd1RtWEJkMHAyQlpmK2dWdUVuVUpkWk03ZVlvWkd2YU5LVzhRdG1DWGc0?=
 =?utf-8?B?S20zQnhtNmllYjZ1RzMyQjVib29nNDBsWkVKaUlySFlNdS9aSVdQRUZSNjJS?=
 =?utf-8?B?elVrZXRCUzNiVmJIU0lra3J4VHlYMjB2RE02cDJ5WnRVVDZ4R0ZldzJ2V2h2?=
 =?utf-8?B?VUF5RlRreU9QYURNNFlwaUdYcjFVUlVYNE9YSHVHdllzQnczVCtKVzEzTXVv?=
 =?utf-8?B?ZFNOSjhsRW9xZnZ4SkdoTmJqcmw3dkRIV3RaK0FzUU5uWVdnbmExN042V2dT?=
 =?utf-8?B?bFFRU3lUVjVaTGtzOHRsOUllK3IvQndPV3Q0clE3UlVXcHlUM0dRSlBhUGdP?=
 =?utf-8?B?Z2xYRkZZS0pDZU9wSkZSNUQxQlBjWVNHT2k5dFFzSlJjRk9wTFF2cVdlNWJj?=
 =?utf-8?B?OGNQR0hkdHlHMmtGOHdVLzJrQS8rbTZJcWVieDEvNUhOSnpMWGtlYjJ1OGE5?=
 =?utf-8?B?Wnh6RUY0ZWd3RCtQYXcxb1h6Z1RQQXpRc1JsQTZVdDltMjVMWXdTRHVDQXVP?=
 =?utf-8?B?ZTJ1WFZma25sNytWZmJXTkhwYzFXWXdVMjhRUzErVDlERmhqeU85RXN5SE83?=
 =?utf-8?B?UGtRcERTMEIzNXJ3cEVOQU5kN1dCbm1yYjlNS0JuVmt5dHo0ek5tLzhSNTZV?=
 =?utf-8?B?YTBXWVozM05ybTYrS2h2am9MUmZUTWhILytBZUdxZDJ6YVZaZ0Y4OU11eHli?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f799465a-8234-4597-4ae0-08dd85310fda
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2025 02:13:12.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tT15jp1Had9JYQTGuhovoykpvqnX6l+wqSzUaByt359GUJoTjhLvkna9togS3oYo0NQaEgxSwCfrEs+saDeBeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4535
X-OriginatorOrg: intel.com



On 4/25/2025 8:42 PM, David Hildenbrand wrote:
> On 07.04.25 09:49, Chenyi Qiang wrote:
>> Update ReplayRamDiscard() function to return the result and unify the
>> ReplayRamPopulate() and ReplayRamDiscard() to ReplayStateChange() at
>> the same time due to their identical definitions. This unification
>> simplifies related structures, such as VirtIOMEMReplayData, which makes
>> it more cleaner and maintainable.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - Modify the commit message. We won't use Replay() operation when
>>        doing the attribute change like v3.
>>
>> Changes in v3:
>>      - Newly added.
>> ---
> 
> [...]
> 
>>   -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void
>> *opaque);
>> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void
>> *opaque);
>> +typedef int (*ReplayStateChange)(MemoryRegionSection *section, void
>> *opaque);
>>   
> 
> But it's not a state change.
> 
> ReplayRamState maybe?

OK. Will rename it to ReplayRamDiscardState as mentioned in another
thread. Thanks.

> 
> [...]
>>   /*
>> diff --git a/system/memory.c b/system/memory.c
>> index 62d6b410f0..b5ab729e13 100644
>> --- a/system/memory.c
>> +++ b/system/memory.c
>> @@ -2147,7 +2147,7 @@ bool ram_discard_manager_is_populated(const
>> RamDiscardManager *rdm,
>>     int ram_discard_manager_replay_populated(const RamDiscardManager
>> *rdm,
>>                                            MemoryRegionSection *section,
>> -                                         ReplayRamPopulate replay_fn,
>> +                                         ReplayStateChange replay_fn,
>>                                            void *opaque)
>>   {
>>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>> @@ -2156,15 +2156,15 @@ int ram_discard_manager_replay_populated(const
>> RamDiscardManager *rdm,
>>       return rdmc->replay_populated(rdm, section, replay_fn, opaque);
>>   }
>>   -void ram_discard_manager_replay_discarded(const RamDiscardManager
>> *rdm,
>> -                                          MemoryRegionSection *section,
>> -                                          ReplayRamDiscard replay_fn,
>> -                                          void *opaque)
>> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
>> +                                         MemoryRegionSection *section,
>> +                                         ReplayStateChange replay_fn,
>> +                                         void *opaque)
>>   {
>>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>>         g_assert(rdmc->replay_discarded);
>> -    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>> +    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>>   }
> 
> The idea was that ram_discard_manager_replay_discarded() would never be
> able to fail. But I don't think this really matters, because the
> function is provided by the caller, that can just always return 0 --
> like we do in dirty_bitmap_clear_section() now.
> 
> So yeah, this looks fine to me, given that we don't call it a "state
> change" when we are merely replaying a selected state.
> 


