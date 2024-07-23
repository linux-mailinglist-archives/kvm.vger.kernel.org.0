Return-Path: <kvm+bounces-22082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5695A939881
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 05:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0BEF1F2223E
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 03:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AD613BC0C;
	Tue, 23 Jul 2024 03:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiKLKPQq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4669139587
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 03:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721703607; cv=fail; b=uXilAQ+ktpZw/wTF1NI83uXI4aRkR0g6aUuMpEzWj4Vf1ItTAw+QdVttDaM+6VAmCZVkz7WtbBVOSe5kw/Wcf/wG2cTM6n7YefgbQx2klQmnCwBf717LgQywl0NTwuA/FhekedgdBloEybmCik2TzQGf8EjfaPDzarb7Cpz1+Ds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721703607; c=relaxed/simple;
	bh=RSVYmyKSEqjq8FMhAINp4ucgcQXCfSmxK102tlamQJI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IPPv+vQeTlFodMUOcFkh2/NJepPRWwNdhP2XuAyGugwA2ysdh/q0vIYEh8n2hkXlsSQkv0S6c/hT/jVQTcgxERuljghTHGTIDkh2w9eiF+NMawfMqFU5r7nSjddabJou9m7RWGF7o0oG3umnJKQSHsy/bA5uYXH56D4a9ezA4eM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiKLKPQq; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721703606; x=1753239606;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=RSVYmyKSEqjq8FMhAINp4ucgcQXCfSmxK102tlamQJI=;
  b=fiKLKPQq71kvz3PXKu8yBmcbwW4FWBBFvRhbS5fsg8qmZV2jrmEUUGaA
   HZ6a27YyfJXQbFJgWPxKxxK5hPbzXCIw3zxOX4AYv02yUgeZyNR4jaP8m
   HBvXdn5J0Gxv5NTlFTbH7Y4/m/6hPTK74S/vPiI7kzjd3a+Bx91OT3muz
   /d6KB9IIrHq6ziMCaF6sm+A3S/fNIcgb4w2PwBxl6Fz4BHptnCs8sJNe3
   ojm5s2+J9EXkUv5p8DM3KN/ek1mRrKlFf2UzYbkj2j6dQBeJStkqx80K1
   FuwvezG8Y+flTDzCQqZC3C4ccRLLpo4BqvdtWdrJd9ztNTbozabb4fjc5
   A==;
X-CSE-ConnectionGUID: qdf3GwJsT9G5l1G0eUq8Tg==
X-CSE-MsgGUID: 6b8ui4l8Q3ajgwmR7cOrUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11141"; a="18924675"
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="18924675"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2024 20:00:05 -0700
X-CSE-ConnectionGUID: So7J741MRTWgRQbeqWlTAQ==
X-CSE-MsgGUID: J5zPxruAQqGknqRaEm4PjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,229,1716274800"; 
   d="scan'208";a="51785832"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Jul 2024 20:00:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 22 Jul 2024 20:00:03 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 22 Jul 2024 20:00:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 22 Jul 2024 20:00:03 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 22 Jul 2024 19:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+aO3uDVntJMyAVhD6qppLqdwYEyk7YaWMYSbGePO/NGdETvpYL4J3XaEsJmuAyQxhoI7iYQitvxxKg7v4EVuMeI/98sLHDl2cpJPoYC+NZpd+QZhCuA0n8br9fgyEje7ZwsMfz9q8wvRB4oQIn3/jhWBIV8EQ6sLpNYOq+sAE0Ms4C+9QBhom++R5jd9asFHoiCFvyr+5Xd4uSWSogrld3TQEAGKHZHuG/huQo1BXmpUL6SJJNaiufUVm1OH5BDXy3WiysFyTlHZfCU09PaIWbhMxs4Udky5q4QbWkiChVOUi41k5/OA+T21O3AFdfiqIZIzG/8h4X390GTSVo2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yx2lJfNZF+QTHCb0QF4+h82qy4osxDsjMCbevXezOU=;
 b=md56CeYKc3UROQsv73CPrG0hecm5Keh9fZ2qIMhSNn+G9QWNQP+jTyiNNgKWp8uzNzr40Co1QMgFtMJ5U2nIPdlpTa7p/wQD9DAoRP1Yp42cCjl0eGIUn+onkovm8nZxG0q+9HARChF6uP8c8+74yhXj1I2Ejv5q69wyMX+j+eDNw9zaGKMt42hW8VIjsD4R4v8o1/6pVfqgApqtaFNR2nlI9a/8kltnzDpWdZnZhrQ5Rk3fW0F89KWGHZTqBAwTnFud1jfrWwxUt5MNnyfo/sRH/+YGSIpk7i7ipLEM+2Q0ueXEDxxenU5GsjN3vpxjtYSIX0T4n9c5TSVZhNviSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6617.namprd11.prod.outlook.com (2603:10b6:303:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 23 Jul
 2024 02:59:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 02:59:47 +0000
Message-ID: <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
Date: Tue, 23 Jul 2024 11:03:58 +0800
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_FW=3A_About_the_patch_=E2=80=9Dhttps=3A//lore=2Eker?=
 =?UTF-8?Q?nel=2Eorg/linux-iommu/20240412082121=2E33382-1-yi=2El=2Eliu=40int?=
 =?UTF-8?Q?el=2Ecom/_=E2=80=9C_for_help?=
To: XueMei Yue <xuemeiyue@petaio.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0069.apcprd02.prod.outlook.com
 (2603:1096:4:54::33) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b6b05af-ae44-44ba-cede-08dcaac382b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|220923002;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NlRpMkxXUkFCTk91b2ZBN0lieTFiZ0FKa3VaeHQ4MlZPTys1WUpJdXFYQkxu?=
 =?utf-8?B?QVlFM1gxRElwNWhOa3NHVDMrUFJJOGpnOHo0TlJUM0lvNjJCOGtJd2t1WUg4?=
 =?utf-8?B?MDBBRmNJZEU1UitiU2ZMZElhL1U4R1AvTEJlN0hmSEVMOXNvMldqd0w0ZllL?=
 =?utf-8?B?czZJeHd1cWU5TnA0djI0eHd2Y2IwdDByRnVQa2JCZGhXTmEzNWp5RmFqWFdh?=
 =?utf-8?B?ZU9ZV25aNGY5c0JOMDJsVnh6Wng4b2hGaS9yNHNwWTlER3NwTWtScTFxYmJj?=
 =?utf-8?B?MTF5cFBIWC9TNkd3ck5KeDRyK3Bvc0FvUzNkVytXWmk4SUUxNnZGS3Y1bHNC?=
 =?utf-8?B?S2ttekRtSGpNRlIyU1JrdjRTWWVvb0ExTm9wWkpidm9Nd3c0NGwwVTdNZG5R?=
 =?utf-8?B?ZHR0a2szamsvUzBVMTFteVFnd1N3L2tJWUVZemxPeThvblhvM05DUmNHQXFS?=
 =?utf-8?B?UnhWU3NSTlVxbEVObzA2UVBPQ09Sb3ZQYmlITXJ6aWJKNmVTekxDNVpnS1dP?=
 =?utf-8?B?aTkyZEZtd0RSZVlSdWtUN0pDYXFoZTVLQ3ZTZFRldjZ6SkpvejBpMGJBa0dE?=
 =?utf-8?B?cU1mOWI3TjNaYnl6U2FWa2lvTTRrcHBjcnFwYXY0OFVtSTVjT1J1b1RkaUEw?=
 =?utf-8?B?Nzl1THhCbmdzQXdDaXJJSGdFRlJRYzdtcEtRNXM5Mm92TXlWemFHLzBlRXo4?=
 =?utf-8?B?N0M1TDBMdUpmSmlUamNTYWpYS1cxc1htQ3VNRzRPZHpRRURBVm9GMUEvNllI?=
 =?utf-8?B?TWlyQVpqV1lYRU4zUldmZmhHSlcrQ21IMGxkQi9GWkphU0NUeGJndzVlTDVk?=
 =?utf-8?B?R2UvNHVjN3E4Vzgva0V5ZFZMT3l1Q2tQbHdBNHZ1bk1FOGxFR3hDSFhYNDBu?=
 =?utf-8?B?V2JlODduVXFLRGEwMU1yNG96UjEwRmppbzJBbnZ5YzlXRi9MSzR1VmF5djJK?=
 =?utf-8?B?dSt2UXhoOGhKZ0hTZlhxb054b1N0R2Q0UHZHanJmUi90d1lLVzNhZytMT05s?=
 =?utf-8?B?c203Wk9CMzl5U3NoSjJtQmVONlpTM2RGODJ5Ym5UT1k1M0llUk9KZGhlcmtS?=
 =?utf-8?B?a0wzbUFWL2dkQ2N1bG1PS0Mwa2hickdVUHg1dE0ydkhMaGlqdkZ3OVFXYkcr?=
 =?utf-8?B?cGh3Y1hVWFdCRG9KZWVzVjQxMFNtRlZWTEdpOHRDTXBHNzFKTkdsVGdJTDd3?=
 =?utf-8?B?eGxydklLanpFZHNhVU9zV3RHZmJCWUhWcGljeW9pM3JjODZVQlN2T01KVXJ2?=
 =?utf-8?B?VEhRQk9sWHZ3SWZ1OEp0K3VhOFBFQVpLbE9icjkwMHNmZkRNWTk5M2FreEZD?=
 =?utf-8?B?eUxqYWE0RTRGbTFFd3ZMZTE2TnQzUzZEajAxWE00dFVZVy9ielcrNGI3a0Er?=
 =?utf-8?B?WFoxUEx1cWVGY3MxTmdDMFRSYnEyRFZ5ZHFYRlA5RGNNM3FYZjBHOVErd1BM?=
 =?utf-8?B?TTMxbzdkU21YTEVFSnZ5UEV5cFA1dEh4am8wb2FCdXZWL0lzWWpKa3FiWjJk?=
 =?utf-8?B?UmlmK1ZhR0RiUE5PNkhnMUtPcWtnRVA2WkQ2RUhWVTdMTXZCUkxySEg2TkNT?=
 =?utf-8?B?V1k1MFV2dFl5WVVUWWdNVWMzcWxndlpKdU9md2RQWTVOOFA5NVpLQnlMSGxz?=
 =?utf-8?B?VWp2RisvQ0o5OW1Ud0JPK3lCRGxCMlVOTXpPRDl3ZTU0Z0tDOXN2eUl0M2ti?=
 =?utf-8?B?SjZGNUtxTWlOS3NmczEyODNmOWNCSzVxdFRNdEp4b2NzMEtGd0U0cm1mZCtl?=
 =?utf-8?B?VXd3ZVY4RWlwMGdqVU5rY1ZoMzlkSlBlU3V0Z2hNMUJQZkNCanlCckFEcFJ4?=
 =?utf-8?Q?qniFO2dy9uRhVWYwKqSutnZf5SWi0BEeHhOSs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXVwRSswV3VOSWJNWU16VGxockh2clRQWjhFZUIwendkd3ErNk9HYzR4cjhn?=
 =?utf-8?B?YzZUNGt5K2NHZlFrTEtJcUNtMXlyYy9EUHJBTnYyUEhhK3U0VGJHQzkrUk1S?=
 =?utf-8?B?RHhmQzBYOVRZRHRKNHhuZXI4OWorMjBvUENROXdORHNoWnZEOG5qVmwvQ2lI?=
 =?utf-8?B?T0trMzlpTWZDYUpXUFV2V3ZNTjVNbENxcEUzVUtadUpXQVF4Qiszd1ZGQXBk?=
 =?utf-8?B?OFMzdG92VWxETW9YQ0ZEVFJKbVNHbmxyM0JoamZQUCtWcVJBMGxCN24vRmdv?=
 =?utf-8?B?ZmFlTXZIRyt0cDFFaW9wbXNGbVp4ZW94QmxIZUJ1NDQ2bWpsSUF3Q0tJWTl0?=
 =?utf-8?B?UzhMMDBnT0QvNDlpMlhsMnZXbjllZW94QzhZRTFUY3Q1c3ZKUk9LelMrSkxD?=
 =?utf-8?B?VzBZZEc5SE0xS3pBZlYzdERtTjlDU2tYcVhkMVA1L3NkdUtoN0w0b0N6MWJC?=
 =?utf-8?B?a1JUSGc0SjBNZzZaSDA3OXloNlQ0azF5SEdOeFlJUmw1dHIwdXVBZzZ0M21R?=
 =?utf-8?B?TTVBUWJxQnp4dDZXdG1sNlpVcms5RW03OHVYL3lVemNZTFBSc0U5TDJNTytk?=
 =?utf-8?B?REsvMWtadXl5TVZyOGNaRjlLME5CeVlab3dEYnhrSFZsd1FnZzhmeWM1R3pF?=
 =?utf-8?B?NVVzT1FYV3VDaGwvenZHRHkyZytmNy9TZjJHK0Z6QXhFU2o4SmIrSHhaMTJG?=
 =?utf-8?B?VVlseHVhU2FyUVdQSE55STc2TTltSE9iVVRndG1WcEV1WUl3T3M5KzI5V2Qz?=
 =?utf-8?B?TW5IT21ka3Fpa2tZbmlaWWEyK213Nmw0R0pMUnFSV2cwOXF1QlhLd3kzYnZh?=
 =?utf-8?B?MmtBQVJtdUI3dkJaUDRzZVhmUXh5Y2hFVVhsOXVjbStzcmhjcXA2Zm9Xbm5q?=
 =?utf-8?B?V25FWUpZV2RNeUJvR3FUNFVDQVU3RFBCWnIxb1pQQTIxTDJmbnlaNnpTU2lK?=
 =?utf-8?B?LzBKL2l3WGh3eElKSDI4bFZ4OFVQUUUrOHkyRlpMcXFCSnY5R2xST216aCtl?=
 =?utf-8?B?SFUrQnBpK1hOTHdEREcyMGhEVzdmdDJrd0o0ellZM2VwclpGbUNQdERmalRR?=
 =?utf-8?B?T01ZWXZ0bXFmNlJBcDdCNTJmMi8rd3Vwc0NsWDlXYk9zeklhWkR6dFNUbUgz?=
 =?utf-8?B?TUJWUUhUZktocFNnTlVoOU9pRDZOTWJOb0VDbzhMOGhGZE5IYjAzWk5pVmJW?=
 =?utf-8?B?K1lWSzZ4WVVYRzBEWnRyWE1GTDhzU2pjODQ3WFc0emNHMlFXaktFbmFhelB0?=
 =?utf-8?B?b3M4bUpSUDBKbkYyaC9VYUpjSWdOamRuT1poSlMvWjZIOWE2TC9kMnlwai9H?=
 =?utf-8?B?TDdhMDU3Tk4vS3pVVy9ZZ0I4dUFwLytoQ1hYOEhvVmpZVkZZamFlblI5UFBD?=
 =?utf-8?B?ZWkzTWNIOUpYTmdvdnpOckNpTWdnT0lBU3pMbjZPdXBza1RXencveVlGVmc0?=
 =?utf-8?B?c0xrb0ZyL0FaQmxsOUlUajkwOEVxK1RoaU9yTW9rakFQblg5Z2dWTDFWYmVK?=
 =?utf-8?B?cnQrc1VKNGprK3N3bFJtdHhpdlk0aHY3ZnVWYjk4MVZRdGJLYjVxZnNrRXR1?=
 =?utf-8?B?MzFIcGRwOGxnNFJNdnJtUTg4TVd1ZGVHWjlqNWNIY2xDaGFjZGo4Q3pTL0oy?=
 =?utf-8?B?SFJnYzZJc1dNTmdiblR0Nll4TnorTWdyYmVuS3BkeFcwZmJUdzdhbEZOaW5E?=
 =?utf-8?B?NDNjNlkzY0tpL2JlUTZ0eWNTY0krTDhUdEZkSTJ0b21JRTF4TGdwWWd5cTNM?=
 =?utf-8?B?djJvckJlMzBhdERYaVBMYmE2WTJKZ3NBNmJQNjcySzh5QlNYQUNYWXljRGt4?=
 =?utf-8?B?U3ZrVy9RV3ZNWjJ0Z2QrWUpoV2FCV0lBU3drdFQ0bXl0azlQY2pRZGNQS29G?=
 =?utf-8?B?UXVlRkg5L3RnZmhCT0ZsbkFJUE8yODBaQ2FVbEZ0WVZPQS9sSG9GV3RtcGhu?=
 =?utf-8?B?NEN0ZUdZOUQ1MDN3Q3RnUkFFZ1RDMWRTSWUrM3FjeUR6RE91QlF6bmRuMVFp?=
 =?utf-8?B?RWJBMExlNVlQTnd4bXBVVWFMZE1uZnB2dWZqMU1yNE84c1BWRVV2SzM2cDZv?=
 =?utf-8?B?RzZWNWlZYWRGTkZCZzFvNkhSZk13RGUxNnRaNG5YZHBmb2wwNy8rVStYZy9B?=
 =?utf-8?Q?Nh0AW4D+kfY9gAzMclnjGoiuE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6b05af-ae44-44ba-cede-08dcaac382b8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 02:59:47.1231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8xkXgtLB2Z4nIe7pT9XtLgf5kxPGu7CEs5gsHvG3vl1VIuiJej1KckTqd+bq5s9w7YrWEB80yExbFVvV+3uJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6617
X-OriginatorOrg: intel.com

On 2024/7/23 10:52, XueMei Yue wrote:
> DEAR ALL ,
> 
> No  I  have know the root cause ,  the issue  ouccured when below code run my AMD test PC.
> 
> So  could you guys  give  some suggestion ?  Will very much appreciate if you feel free to reply！！
> 
> [cid:image001.png@01DADCEE.6F2E3F80]

For the people that cannot see the picture. It shows the pasid attach
path failed as the domain->ops->set_dev_pasid is null, hence failed with
EOPNOTSUPP errno.

I don't think the AMD iommu driver has supported the set_dev_pasid callback
for the non-SVA domains. Suravee can keep me honest. And you may also need
to check if your test PC has the PASID capability.

-- 
Regards,
Yi Liu

