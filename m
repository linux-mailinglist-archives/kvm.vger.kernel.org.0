Return-Path: <kvm+bounces-60033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DDABDB56D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4B5F04F467E
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 20:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6A03081C5;
	Tue, 14 Oct 2025 20:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e6ACBng3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E513307AEC;
	Tue, 14 Oct 2025 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760475431; cv=fail; b=TW+iIHtNcT3jtWlYr8lALqMKm0A8lfCeCCW4xnucwOf2shGha7k3pjYWPUKpw3Ez6yLEjV20sLYZ6IXATnrFvvRO6S930CYoIJlfBRgCBihxe+cFiVBazkmpOByM7UvQi6id8CunT1dMLHdNIXdyiQzQyqg6zidJUrjcVmZACOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760475431; c=relaxed/simple;
	bh=mNLzh4PZTWTYyEbU8E6JnOFhSvuesW7R0a+xD42Hcj4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fk+4E91ji7ScOfLPpK2w3oLhLBSA0eKfYkmyAZrIGMfxhvTF9/RWbuEINtjjUsrSogXdkbK1hHfQvog0FTNzh+VJVd87ooGntGf5PMD2/LVXzpCuY3FrZVDwWv0WFkPrFktILeFyVEAkHQfPBxml0nvqRrtVADsngy6PqGQpSYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e6ACBng3; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760475429; x=1792011429;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mNLzh4PZTWTYyEbU8E6JnOFhSvuesW7R0a+xD42Hcj4=;
  b=e6ACBng3apykdtcnUMEt8zDBnnYGpjXMEgYKzjMX0NIhUWkjnTluD8HN
   7z9fA6qGyEJOlCTTx0Z53i306bZ7QYL49xX66I1NRgoRcWvZWMhR3PFzz
   yn/fcj0nDFG6LKta7CUqo3uHKlHZPRNn1pU0ko/8lRuYrB2Z/Aojk6EuL
   S2X5G0bYVGO4hRteVv66DKhu9SYh5aX5PImgzHTVhaLAZMVOTf12mI2+8
   D0QkxenTADExWkm3D6HwTH21xZbixN3YdzhWGAItlX79NE7VOLos97X2J
   Ghu3kYPvrvf2HC6c3BFHCzDyYQkTOs45VvwX4bDJDUv2N9UaijJoJMNBP
   A==;
X-CSE-ConnectionGUID: slr4f2hUTiueECgB8QrDFA==
X-CSE-MsgGUID: kgIWONAUQBSw6LdJCqPGcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="80278564"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="80278564"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:57:08 -0700
X-CSE-ConnectionGUID: cVkvcbZLRjiZAR8zBYfUSQ==
X-CSE-MsgGUID: k1YahRs8RHy9lm52IyMvcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="181529746"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:57:08 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:57:07 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 13:57:07 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.18) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMiEjr6zjygs/gmTQHdpBS8R6g9UqwuksPNHvr0BQv4vfpEFbqARt2r+6iP/WXVex1hfjlAN/SmpeC5PcYHoBOIG8o7O8HzXgCmNF1Phor/OsdL6v568V/v+gU9WLUViE36gzzyYJkg+DfiO/H5VR3mJBI1kNf/yx5cStsuBZFmRvZ0HMLqtamYOThMEsJKWrpVYjGF86+HZWDx5qlu0q81zZq9dtMWoV1/+fQSwcXdu9KZqHSKSeAAsBPSpyjJ4WlcGyIY+Lomol+J4f9EVsIMFcl1cZ8rRYQQCdiAHuPkZIrIgJdFD97XjgX6sONLgK2quJaUdyYe4Mp29K/te7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDVDKnfdg0e3ng1R/bvmiNCIoQWKi6WoCcCk233OV+Q=;
 b=NSGXtfSjWycPmtTx9gvAiQEjJc2YBGLkpiVM2TJ5Ghtkrl8UBas3KWofadGJjzN9lwi2tuVGyGxCfpGJbOgxj5jc8RT+QKXue9u3j85W7cuo/DCFJT2FiP5u4DBY2nwO1Vz7+IgB+8UBYvSgFIq46tLjj9ok+pXjdy3vol8Kojxnd69BZDpoZySE6b4awqv9/4j0ammMJBM6mFfEaQTjyFhf14EuGUm0qs+a17gBmsi0lH88KtKeOYIyRSYKYkzcQrZ0USKIHxTmkY32yGqm2+aOPyEwIbYK2/gpbuPXnB7tu9kMTEFeIWp0nhhPLqL/2heKw6jTYyuR2p3uN+FGgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB5129.namprd11.prod.outlook.com (2603:10b6:806:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 20:57:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 20:57:04 +0000
Message-ID: <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
Date: Tue, 14 Oct 2025 13:57:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Babu Moger <bmoger@amd.com>, <babu.moger@amd.com>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0167.namprd04.prod.outlook.com
 (2603:10b6:303:85::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB5129:EE_
X-MS-Office365-Filtering-Correlation-Id: a17ae8f1-104f-43bb-141b-08de0b643aed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L00vQlpjWTM3ekp1TU4zNE5CUitwYXA2OVcvYlZZc044dTBpNmRuNXMrcjZi?=
 =?utf-8?B?b1QvdUZHQTJsQmgvdnViOVArU0pqK1B3QVhPR2QwZ2taRlRUUXo2c2FqcmFN?=
 =?utf-8?B?M09QM043QzVQWVUxSGtWOHBrM0w5NW9BVmYzZDV5OU1tQzVjTUIxL3ZQdHZv?=
 =?utf-8?B?cjk3WEd5VWlPbHZWQlRaS3ByMFN2OFVycWxzblF1b1pIQldoVmpRRlFrb3ZU?=
 =?utf-8?B?QWhLQytVcmJTTG1BZE1kSHljWEg3cHB1ckR1dCtmR1VPM05DeFRaSTJMMnpo?=
 =?utf-8?B?b3RPVHNvT2tLL2hVc0RuRTY4ckgyNzhnUFVKMXFhY2lRT3hwbWNoVGc0V295?=
 =?utf-8?B?ZGhnM1hTWUdXYjFocDlFSFJxTGtrTVNhcW42ekpqM2tsSlF5SEMrNFZMVWhy?=
 =?utf-8?B?cFlEQVh1Vm0xdDl6L25iVSs3eTcxay9XaUJCdldLQ1hTMTNja2g2TjVRYU9h?=
 =?utf-8?B?UVp0SnZVWjIwZmNnNGU2MnIwUklUL0JrdlFjTU04amp6N0dDcS9HOWNpdDNK?=
 =?utf-8?B?dkRsS1cwdGVmMW5zdmo1THV3VmQvQkQ1N1VUMHRYUHNjYzlCYkQ5a0tvOFFF?=
 =?utf-8?B?KzlhNFZsdWZhNHRHRGJYUnVoVHc3ZWR1MGc2QTRBSXFreG0va3o2UWVtdDdz?=
 =?utf-8?B?bGlxNmxJR0hVNVY1ZGhVT0NzYTFJUkJzdkU1ZXJlV0t5bmFOaHJYN2YrTjJu?=
 =?utf-8?B?cWU5SUFDbDN1S3o1ODlXZHR2MjMwMS9RdW5obEhsOFk3Z0NQd0djTkRZdDhy?=
 =?utf-8?B?N3RzT2d3TUN1TmtRd2xiMUY2UmtBbGtCcGRycThYRGkzeWJMU2p6bFYrZFVv?=
 =?utf-8?B?eFJBdFZ2cHUyMTlOSG1CZ056SjA0K0JGa3hkR2dhUEFoUzhtV2RnSnRXZ29V?=
 =?utf-8?B?ZDVPYXE2bFdZR0l2cVZPTzZqUHRDYUZHYzVXZmhUaHBJN09tUlU4YkVXdFRS?=
 =?utf-8?B?MWxhVmEwWmg3MkNzSmFMbnVCd1lyYW4rVFpkSUM0S0hsMGsxUVl1MytOQ2M0?=
 =?utf-8?B?Z1N5MjRZYk9OZlF5b1BKc09PYmdwL1A1amczZG9EMHVST1llUnlzcmZXaUU1?=
 =?utf-8?B?YjZhUmk1OXFPNWtxeTR1b2ZTT2JaMUw5NWNPOEoxdXNiNG5sZVltY1ZWdG1q?=
 =?utf-8?B?YUlRTDlJdXh3dHpSb1ZGSXVTazFmOFY1ZEdENXR0UHN5MWZ2MENhd3VtMDZm?=
 =?utf-8?B?NmNrNTRMWGIyV1g3T0FiSEJldTFLMXlHbk8vRlIxNTR3T0M5VWladkNQTEhC?=
 =?utf-8?B?MlNQVTVobDZXRE5wVHdBUFoyMVp2Wjh4VVhTTkgzWWtsaTY5RllWK0w4eWtw?=
 =?utf-8?B?Z3JkZVM5MWw5SkU3a01uQnhWY1ppSWplQ0FWcEdHWjMxaTJiSlBJT2pMUU9N?=
 =?utf-8?B?RUcxVmtQUDltNW5yNGZHdmx5Z2QzRkdBSWFYN1FPY2JsQzBOeWhNMEo3T1R4?=
 =?utf-8?B?ZW85a01URnNmWU9qWmxkY3BmeUZJSzRXVHlDN3ZuVVNJOUVtaHNSaGxabitB?=
 =?utf-8?B?aGFCeEJzWWlNdjBTblpFSkFTTDJ0UTNqMG16MHZuNWtleUtiRmpjZkpQbCtD?=
 =?utf-8?B?YWVNTEljNUJyM083Ky9wd2lBMHlHdzVlWGppUW9kT2d4Z2FtY2ltSWE4OW5E?=
 =?utf-8?B?bTZpVEtSSmRTUUllNHVkOUE2U25OT0VVUWE4QXFPM1dwT0NTVlE5MitMWHpp?=
 =?utf-8?B?YSttQ3dIeFRieXpYR2RSVnA2OThOWmxSTUZ2YlFCbDJIa3dKVGJIUmxObXUy?=
 =?utf-8?B?OXhsNXJmSEZzL2Z4Zm9DS2ZzL3N2b2NlZjBIVXJNQWJrUk9ObFduQ1YrQWFO?=
 =?utf-8?B?cjY5MnJ6cGUxaWxNbXJoUXZwMmcxZ0J3eDFHME0xWkhkZU5KZlhsNzBBSjBB?=
 =?utf-8?B?ZmRVNENZYjY5R1M4Z0JHbXpsSVRBOSthYTVnT1pRbGxJWHM5Qms0ZC8wMzZW?=
 =?utf-8?Q?Qisr4An15h4Zm/z9BAoPuKNCf15lIWw5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGw3czk0N3Bld2k4NlJNeG8xdHRXclJ2U0x4MjV1NnlMMk9teWNHbEdmQk9a?=
 =?utf-8?B?UWRlM2tkRTc0MGdnOWxSL1NJUzM5cjgxaTdIZXA3UWk4S29UNGdrU2d5RXVn?=
 =?utf-8?B?YXdQdkdsTWNVNXRqY2RkM0FUVkhIdW1wUWNYRVZHTTVpRFNPSXdNcllvK2o1?=
 =?utf-8?B?aWVmUUlzNkpOemlmWHBQWWF1MHBnS2xyNDNvWlpBY04zRHJEcUNwWExiaFE1?=
 =?utf-8?B?R0V1M1Z6TWhGMmljWm1kRVdUVjdJcjdYZzRGbEF1MTdrYjdrbWJUam9QSVcx?=
 =?utf-8?B?c3dNMUwxNE4xU2dzSnR0QkgvZkhYdGdmaURqNEM2VUNQNERNWUppUm1KaUxq?=
 =?utf-8?B?cnlpMTV3RmhxNytuTUF3RStCaU5zSlFZRUtVK01RdjIzd1dwMVFaUFlZWFNk?=
 =?utf-8?B?ckE4RURHVjJYN3YvYW1Na2FoWDRpMTgrZmx4NHIzaXBpMDZ5WjNHOWdVdDQ1?=
 =?utf-8?B?aVd5UmxxQUh4b1R1UnR1TW9wY0FlTnJBVzUvclhLWWZhdkhQa0MyWGQyVEQ4?=
 =?utf-8?B?Tlg2L0pubnd0bDBUem9OeGxseVNsR1haYVhtTFNQTWlwVTlXTk1zUmxzL0or?=
 =?utf-8?B?SXRWOWNJL2huMVhOU0U5Mkowd2dsRlBaUC83SmpZc3hqdU8xZytTbnJpUXZN?=
 =?utf-8?B?WEhLOTBDejlsZHhlNVJLTHViNmhDOG5tY05yY2UzV0V3TkpKeFhseWdyUjlP?=
 =?utf-8?B?UkwxWjc2RE9NT1pDSURXM2Q5OWIzaEVDQWdIVkxBRGVzMU0weVRPV1V1NnJC?=
 =?utf-8?B?aUtwMENyVEhGZDRIWnhWMlcxOGFKNitycUs2MGNGNE9XMmZLVld3Zk9FWGhi?=
 =?utf-8?B?c3BhNXFXdllZOStxMjk5R0x3ZFFnYU40RDdQbURrMDV4eG9oUGF6aVNCMTJX?=
 =?utf-8?B?aG5jOHlkSThXTWVrT3VIVTNhak5mV3RUQzl4dngybTFZeWFOSThBSHpkOERs?=
 =?utf-8?B?SHZMa1JYL3hPbjYrdlN4R3h1RVhCaFNyVHFqSlNjeXlDR245RWxNYTV0dVY2?=
 =?utf-8?B?bTZZSDZxYjFxVWpGeHFMdmErNkE0OW4yQWpDRk9jSmdhenp0ZFRGUUpaMC9I?=
 =?utf-8?B?NFNJbHJLeXR4SGF4UnRkSy9JVlpxQnpLUE5qNnNmOUR6UHo4YlZQNUpQamJM?=
 =?utf-8?B?YUtkV2ZQRFVWbVpFUlk1YWwvMXRBZ2FkRFVBQWI5ZTk2d2xJWmNQRWlTLzdq?=
 =?utf-8?B?Tk01cElhaWJRdkVpOENmT1dYR1NDMVVIU3diemJNWWRKVEp4cExMZVlieDRh?=
 =?utf-8?B?ckJpdnRNQlVubzN4L0dDbGcrNTNNdDhlNEN1WXBVNlN0ZjVQSEtJMnQ1d2tS?=
 =?utf-8?B?RHpoK3cyWFBybjZxNm1jdFNiZnFKWVMyUnpWSzFSZ0tyK1c5M0lyVUNXWlZV?=
 =?utf-8?B?TzlWRTZhRDV5K0FwK1NOdTJxeVlLYnY3TnY3cTdpTkVKRFBIemg0S2xrcURM?=
 =?utf-8?B?cnpMOUc4aEMzRGlBaVdpblhiTXJKSzc1bVE0U0UvWGJ5RzRtSHpGN1VjK0l4?=
 =?utf-8?B?dVZuYzdJQVlJcHdDTHl4N3M3ZUROcjdMcmw0aXgxenFTN0dSNnF0Wm1UcXNG?=
 =?utf-8?B?N2wvb3IvLzRmV1U3bnVEU0VNVWRCNDZNTWd4eW1iMGg0OXY3VFhzK242NmpT?=
 =?utf-8?B?SHlUc3pLZTVpa3dJRTdNYnRad0gvN25iYUFmWmVjV3llR0hwd2dpWHVIeUh1?=
 =?utf-8?B?cWYyOEtrLzRuWktkZ044ZzAydHlNYXBWWUF5ZXRtSjh4L2pUaFpkQmlBRkZj?=
 =?utf-8?B?Nzkrcmk5bVRya1NCUU1SNjh6ZjJQdGpQZHlVTFYxVk4wYlh4OS91SUNWeEtk?=
 =?utf-8?B?bVpVNTRWTi8wN0t6TmdKNjU1ZE51MUdiNmpLdzBxZnBubWFjSmUzcXE0Qldu?=
 =?utf-8?B?ZWJZT0VyN1orWTcwU3YzLzRDMjlrQXNoQ09VYlFDanpBYXBtWnVUYWRUSHM0?=
 =?utf-8?B?VlBZcEdWS1o3dTlvbFAzdW91dXlKZmgyT2huRGp1eEYvcFpEYlBxa1RZTXd0?=
 =?utf-8?B?K0JtNEs5UXJKdzBFYkZSV0N5OFNrUzNueG9GS0Q3cmtwVEZ0QVVCY3J0dmda?=
 =?utf-8?B?bGhLZFpPaHZLQVVvYU9Od0loNGFER200MURYN3Nzcy9pOEtyYmxoWHZRWTZX?=
 =?utf-8?B?bWRjcVE5SFh4U0QzZWZaaGFiQ3JIZWtiSXlOUVBxWjFPaHdyZGJ6R3VMb1VR?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a17ae8f1-104f-43bb-141b-08de0b643aed
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 20:57:04.8079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynn1V95jSQvfEJKjUqL2p1yHCzpGPhVkNWt9AEKlAG9WE84Be0BEHXHfwahdNRpq784isJmvyaugfyZkHY+oPT4HaktsLrrDMeNN1vZ+QIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5129
X-OriginatorOrg: intel.com

Hi Babu,

On 10/14/25 10:43 AM, Babu Moger wrote:
> On 10/14/25 12:38, Babu Moger wrote:
>> On 10/14/25 11:24, Reinette Chatre wrote:
>>> On 10/7/25 7:38 PM, Reinette Chatre wrote:
>>>> On 10/7/25 10:36 AM, Babu Moger wrote:
>>>>> On 10/6/25 20:23, Reinette Chatre wrote:
>>>>>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>>>>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>>>>>> On 9/30/25 1:26 PM, Babu Moger wrote:

...

>>>>>>>> But wait ... I think there may be a bigger problem when considering systems
>>>>>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>>>>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>>>>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>>>>>>> to default mode and when user attempts to read an event file resctrl will
>>>>>>>> attempt to read it via MSRs that are not supported.
>>>>>>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>>>>>>> to handle this case in show() while preventing user space from switching to
>>>>>>>> "default" mode on write()?
>>>>>>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>>>>>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>>>>>>> events are not created.
>>>>>> By "right now" I assume you mean the current implementation? I think your statement
>>>>>> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
>>>>>> Current implementation will enable MBM events if ABMC is supported. When the
>>>>>> first CPU of a domain comes online after that then resctrl will create the mon_data
>>>>>> files. These files will remain if a user then switches to default mode and if
>>>>>> the user then attempts to read one of these counters then I expect problems.
>>>>> Yes. It will be a problem in the that case.
>>>> Thinking about this more the issue is not about the mon_data files being created since
>>>> they are only created if resctrl is mounted and resctrl_mon_resource_init() is run
>>>> before creating the mountpoint. From what I can tell current MBM events supported by
>>>> ABMC will be enabled at the time resctrl can be mounted so if X86_FEATURE_CQM_MBM_TOTAL
>>>> and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I believe the
>>>> mon_data files will be created.
>>>>
>>>> There is a problem with the actual domain creation during resctrl initialization
>>>> where the MBM state data structures are created and depend on the events being
>>>> enabled then.
>>>> resctrl assumes that if an event is enabled then that event's associated
>>>> rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states exist and if
>>>> those data structures are created (or not created) during CPU online and MBM
>>>> event comes online later then there will be invalid memory accesses.
>>>>
>>>> The conclusion is the same though ... the events need to be initialized during
>>>> resctrl initialization as you note above.
>>>>
>>>>> I am not clear on using config option you mentioned above.
>>>> This is more about what is accomplished by the config option than whether it is
>>>> a config option that controls the flow. More below but I believe there may be
>>>> scenarios where only mbm_event is supported and in that case I expect, even on AMD,
>>>> it may be possible that there is no supported "default" mode and thus:
>>>>   # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
>>>>    [mbm_event]
>>>>
>>>>> What about using the check resctrl_is_mon_event_enabled() in
>>>>>
>>>>> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
>>>>>
>>>> Trying to think through how to support a system that can switch between default
>>>> and mbm_event mode I see a couple of things to consider. This is as I am thinking
>>>> through the flows without able to experiment. I think it may help if you could sanity
>>>> check this with perhaps a few experiments to considering the flows yourself to see where
>>>> I am missing things.
>>>>
>>>> When we are clear on the flows to support and how to interact with user space it will
>>>> be easier to start exchanging code.
>>>>
>>>> a) MBM state data structures
>>>>     As mentioned above, rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states
>>>>     are created during CPU online based on MBM event enabled state. During runtime
>>>>     an enabled MBM event is assumed to have state.
>>>>     To me this implies that any possible MBM event should be enabled during early
>>>>     initialization.
>>>>     A consequence is that any possible MBM event will have its associated event file
>>>>     created even if the active mode of the time cannot support it. (I do not think
>>>>     we want to have event files come and go).
>>>> b) Switching between modes.
>>>>     From what I can tell switching mode is always allowed as long as system supports
>>>>     assignable counters and that may not be correct. Consider a system that supports
>>>>     ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or X86_FEATURE_CQM_MBM_LOCAL ...
>>>>     should it be allowed to switch to "default" mode? At this time I believe this is allowed
>>>>     yet this is an unusable state (as far as MBM goes) and I expect any attempt at reading
>>>>     an event file will result in invalid MSR access?
>>>>     Complexity increases if there is a mismatch in supported events, for example if mbm_event
>>>>     mode supports total and local but default mode only supports one. Should it be allowed
>>>>     to switch modes? If so, user can then still read from both files, the check whether assignable
>>>>     counters is enabled will fail and resctrl will attempt to read both via the counter MSRs,
>>>>     even an unsupported event (continued below).
>>>> c) Read of event file
>>>>     A user can read from event file any time even if active mode (default or mbm_event) does
>>>>     not support it. If mbm_event mode is enabled then resctrl will attempt to use counters,
>>>>     if default mode is enabled then resctrl will attempt to use MSRs.
>>>>     This currently entirely depends on whether mbm_event mode is enabled or not.
>>>>     Perhaps we should add checks here to prevent user from reading an event if the
>>>>     active mode does not support it? Alternatively prevent user from switching to a mode
>>>>     that cannot be supported.
>>>>
>>>> Look forward to how you view things and thoughts on how user may expect to interact with these
>>>> features.
>>
>>
>> Yea.  Taken note of all your points. Sorry for the Iate response. I was investigating on how to fix in a proper way.
>>
>>
>>> I am concerned about this issue. The original changelog only mentions that events are enabled when
>>> they should not be but it looks to me that there is a more serious issue if the user then attempts
>>> to read from such an event. Have you tried the scenario when a user boots with the parameters
>>> mentioned in changelog (rdt=!mbmtotal,!mbmlocal) and then attempts to read one of these events?
>>> Reading from the event will attempt to access its architectural state but from what I can tell
>>> that will not be allocated since the events are not enabled at the time of the allocation.
>>
>>
>> Yes. I saw the issues. It fails to mount in my case with panic trace.

(Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
that creates the MBM event files during mount and then does the initial read of RMID to determine the
starting count? 


>>
>>
>>>
>>> This needs to be fixed during this cycle. A week has passed since my previous message so I do not
>>
>>
>> Yes. I understand your concern.
>>
>>
>>> think that it will be possible to create a full featured solution that keeps X86_FEATURE_ABMC
>>> and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL independent.
>>
>>
>> Agree.
>>
>>
>>>
>>> What do you think of something like below that builds on your original change and additionally
>>> enforces dependency between these features to support the resctrl assumptions? From what I understand
>>> this is ok for current AMD hardware? A not-as-urgent follow-up can make these features independent
>>> again?
>>
>>
>> Yes. I tested it. Works fine.  It defaults to "default" mode if both the events(local and total) are disabled in kernel parameter. That is expected.

Thank you very much for considering it and trying it out. Could you please also check if it
behaves sanely when just one of the MBM events is enabled? For example by just booting with
"rdt=!mbmtotal" or "rdt=!mbmlocal". Only one event's file should be created while it should
still be possible to switch between default and mbm_event mode, event reads from the event
file working as expected in both modes.


>>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> index c8945610d455..fd42fe7b2fdc 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>>> @@ -452,7 +452,16 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>>>           r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
>>>       }
>>>   -    if (rdt_cpu_has(X86_FEATURE_ABMC)) {
>>> +    /*
>>> +     * resctrl assumes a system that supports assignable counters can
>>> +     * switch to "default" mode. Ensure that there is a "default" mode
>>> +     * to switch to. This enforces a dependency between the independent
>>> +     * X86_FEATURE_ABMC and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
>>> +     * hardware features.
>>> +     */
>>> +    if (rdt_cpu_has(X86_FEATURE_ABMC) &&
>>> +        (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) ||
>>> +         rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))) {
>>>           r->mon.mbm_cntr_assignable = true;
>>>           cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
>>>           r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 4076336fbba6..572a9925bd6c 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
>>>           mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>>         if (r->mon.mbm_cntr_assignable) {
>>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>> - resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>> - resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
>>> -        mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
>>> -        mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
>>> -                                   (READS_TO_LOCAL_MEM |
>>> -                                    READS_TO_LOCAL_S_MEM |
>>> - NON_TEMP_WRITE_TO_LOCAL_MEM);
>>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>> +            mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
>>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>> +            mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
>>> +                                       (READS_TO_LOCAL_MEM |
>>> +                                        READS_TO_LOCAL_S_MEM |
>>> + NON_TEMP_WRITE_TO_LOCAL_MEM);
>>>           r->mon.mbm_assign_on_mkdir = true;
>>>           resctrl_file_fflags_init("num_mbm_cntrs",
>>>                        RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>>>
>>>
>>>
>>>
> 
> I can send the official patch if you are ok to go ahead with the patch.

I am ok to go ahead with this patch. Please do rewrite the subject and changelog to highlight the
severity. I'd recommend that the changelog be something like:


	The following BUG/PANIC/splat(?) is encountered on mount of resctrl fs after booting
	a system that has X86_FEATURE_ABMC with the "rdt=!mbmtotal,!mbmlocal" kernel parameters:

	<trimmed backtrace>

	<problem description>

	<description of fix that also mentions it adds dependency where there is none and why this
	 is ok (for now?)>

> 
> Let me know if I can add Signoff from you or you can respond after it is reviewed.

You could add below tags or we can just do the usual review. Either works for me. Let me know if
you would like more collaboration on the changelog.

Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

