Return-Path: <kvm+bounces-55853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C6DB37DAA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 103CE46066E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F07C33EAE4;
	Wed, 27 Aug 2025 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ipf1WWpS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5C7335BA7;
	Wed, 27 Aug 2025 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756282942; cv=fail; b=FWDdjsqNieOcTgYipUb2lCrMoHzaY1cto/t92v+1gjeneWUlA/gEYcGdhtQg1QaB+TdSi6jtuUiX0Hy5GZeOe6smBPwMD2paCB7oZSwRuZpf+bsD2478sZLi0VEs5GF2wlCdVj0r6Hka2IKUIGYf+T2TuYuBNNXM6MrmQkSUUtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756282942; c=relaxed/simple;
	bh=QfLb1ZLmgRNdGcCvvlWRMChfAP1Qdsg9brkEkL6kkU8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rGolWDa4pUxnFE4NdHfNX0u6WnBCpQC4Www/CfajOl3cCdQVk3SoXWmMrSGNXx6Ug2bRcQQR/zWo5tx9FvQ1/6bqzaT60/W/T9YWXZOXSbBYcO+gB0sUqfnfUA1lQh5Ac5FT1LS8tTI/awAJEGVYcwuzU5o7lxK1qGS+44n/+O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ipf1WWpS; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756282940; x=1787818940;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QfLb1ZLmgRNdGcCvvlWRMChfAP1Qdsg9brkEkL6kkU8=;
  b=Ipf1WWpSSSkvSGIVIgJxX1tMiCmRgTovkjdiYc0cf8goQmBA993A9jDq
   LLTNEFMi6jB5EkTvRMqX6MMsFZuoURbvY/jOPiTT3ShgIW76SZv0CHhNR
   g+RECLuGSVM5cdBFPS1isxv7vRfTiW8lNnIIwBI9UXz68BC2ibsyds6DG
   qeehoCVwWW9V6PaOeHkcLg7yQEYyEr4UBQR9CiBWm8nbi9JrfeWU8XNQK
   yJWSQucXNn98455FQeloRSMyP8VX67fAelB8s4G5Lh5kjafCzH6H3BRX6
   qjFZcdLYc5qvpa2qGLA7jYsNcQSTq0YH9fMxrolWui7zpHbJ/mJFJzMYq
   g==;
X-CSE-ConnectionGUID: kLjzysmRRqKBHv0gUXl0XQ==
X-CSE-MsgGUID: /XuS9xPCTIiWAGRD7qLaxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69244943"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69244943"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:22:19 -0700
X-CSE-ConnectionGUID: x7fsqWT3QeaTpf+B1ocPbA==
X-CSE-MsgGUID: KLpC/rG6SiCjlPGCgF8Reg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173951985"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:22:18 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:22:17 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 01:22:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:22:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yMiKow9J195zMWQyOCYfUZe8xHqK/xpUBKEFfYrfBt2LTQeNrauP+Qke/khGYyujTXpf1QRqHRZVb8aCsRusAKwrHXtRSDLcVdV8FKkFXD76A590FGpaLjMzijrmmEmc3kmM/gFWJtrJcWqtzGY5IsbUNsQV3rs2YkmhXv1KSeK7bKMFlTKvUzNc2fZihj6BxCMcTGTjf1G3X5n7t2tAKKHSUVlL6jBFq+Ec65wWOaktdSEFaZg46WMBQxKiKw7DbVUCG4jUG2RQbIkUQrLZJYcs93qdGb+jVsqHKVnYtmxDGnCmwXeBhK6aL35CvRRAznu66BhCjptb/jxEmViAgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvbGWL/f1aMbu6RX7sqpodSsFgxXHKrYrkR87byRygE=;
 b=bm72FgdWi+AbtlKtaraWk8CHFqQ7L2BnWESUyPdwJ+cl8krRRGNRdoZXPUDyvdZkDrfOcTZzFjgjAIBYy3UQrcT7Kt9EVxdFYJTsCUxOkYS641MP16zk+feulFbATlr3hibRBJFmVM9W09aY7QhZkkucXiIvnXG0MDqFegrXoFqsxZSdvxomiSvySGWz3g0/bBDjkQeIdzETMayWy8B8MjxMIE0TpmWDGQJ0Pm1mZzadMokSB+QO9evJbgjyWy3CE+z5WAzxqhA2x3Nj0ctuhcPZJ4ovq+/KkGihvKXEyRsNOajabPTprL2Y9mnaJ538uWmqA8ivpbu51bCjW93MMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by SA1PR11MB5778.namprd11.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 08:22:13 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 08:22:13 +0000
Message-ID: <7c5ae62f-c4c7-41d8-af00-7a517e3ed309@intel.com>
Date: Wed, 27 Aug 2025 11:22:07 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <vannapurve@google.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	<x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, <yan.y.zhao@intel.com>,
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0268.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::33) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|SA1PR11MB5778:EE_
X-MS-Office365-Filtering-Correlation-Id: 793974fe-8b1f-497a-e4bc-08dde542d359
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aUhDbGNCbVVBby9XdFhBSWtqMklFZmJNelUrN2toZHZqVk9lc3lzZDRpVDJu?=
 =?utf-8?B?YXVCNHU5ZDBjalNCcXpkeHRyaFNvTXd5OE5IbVBVQW5FL25wTlQ1NFcyTlU5?=
 =?utf-8?B?VmErVFgrYTFXdURnZXNxaVJMYUpvTGQvWWtIa1p3c1EvOFU5Y0dpOW02Mk9F?=
 =?utf-8?B?dEtvalhHcXVsVDZVc2QveFQvSk50R2JuejN5WjRDU3JraWJiRXBNVS90aGZG?=
 =?utf-8?B?dmg5UjB0dTdXN3llUys2Q0FHSVFjdzhYb0I5UFQ1cE9aZ2VsVjM0eVRDUUhQ?=
 =?utf-8?B?TnQzeGVIUzNiRjZNSkFYdVJWaFNqZ3NncGNQRHA0SjlMSlpQVXFaTmFGNXVC?=
 =?utf-8?B?ZSt4ajhLVkEzTy9jR1BOaGc5b0gyL1UzakNDQldVUDNOaDRoMWc2akxicFFh?=
 =?utf-8?B?T0I3Vnd0NE1oeWIyYktlVm9yOUlWK2h4TlJ6Q3JkdElnR0tXSU5VRE4wckUy?=
 =?utf-8?B?YmZGakJ2YTRSR2xnUnpKS0VKVW0yMm45cDRnSW0wWTZoYnRTcU5FYVlOYTNS?=
 =?utf-8?B?dWhqaWhqcjV2am5hbGJ2Q05XbWJoOENEUkcwaXYweGhTV2xnQ1I3S0JaUlZB?=
 =?utf-8?B?WXduTlBFeHoveHd2aU5aZFpyeElmZ0YvSVlJa2tIWitGdHVzZkdJVUozRTFD?=
 =?utf-8?B?Nk5oSTVYd2hhZ0Erbi9YUFBpWGd2TmlsZjBlWFE0TTNlRi9uWDhoSUE3OFI3?=
 =?utf-8?B?NXEyMDhMWnFIVXJaZEp3MytiWkdZYXR5UHhjWm9BdlU1NTk2d1ZxZlRSVGUz?=
 =?utf-8?B?WTh5Y2piMUp5UTEwTnhZTFBkc2tuMXJOSGVPWGJ4dXdjZHNoSTV2c09PYXYx?=
 =?utf-8?B?T3hrOUpDVW1LdWJSc0Q3dnVQZ05oSEZQYkJHblkwOTcrT1E3dHNkZk5ZMDda?=
 =?utf-8?B?YklpZzREdlBGWkZMSlo5VW0yTXVNaU1iTi9xZUpDOFd4NE15anRUaU5iL3V1?=
 =?utf-8?B?ZndTWVNHZXdlYjNEbkFPZncrQ3IrcTJoOHBFYlJuNi9uY0tHTVdtMWJ4WkZn?=
 =?utf-8?B?YmxHOW1RNUEzVzQ5dUx0cEJyQ0U0T2g0b3VaZVRZR2FmTVpWeWVUOVZKRjRm?=
 =?utf-8?B?bHhPTzJRVWR6RjZKSWdLa200UWtJSlhIRytJZDVWWWxkbHEzY3RPZjdUWjE1?=
 =?utf-8?B?Y0VuN0lNY0tJSzFWMndkKzNjMFZ3NWhUQzkySDludjgveE5HbnczMnErQnVq?=
 =?utf-8?B?M1ZUS2FOa29XTURQZlVveS9KcDRQUlpGdFZnUkRLMWNWS250UHFKU2NBa1FQ?=
 =?utf-8?B?bU9lYjJmMFQ1YVB3VkNLdE02NjJQenQ3RTlSR0txbzlkODVqMW5NVHhVcmNk?=
 =?utf-8?B?S3g1R1ZVZmhydnZ2NHRpWGFVcGxDbUFUV3B2TXhtWWdVR0E1Q2pxb1V2TFNT?=
 =?utf-8?B?cS9wTFNUbUQvVmx1cFpWRVFmRjFydzFSMTJ6YU1GcHNjMEtnMGhqd3U2OHZI?=
 =?utf-8?B?UnRlTVBhN3MvK2xPUlordzNqUG8vOEswZUFBSG5DeEVYcWFWdW1mQ3o4cWZ5?=
 =?utf-8?B?SzllckNmbE5Ma202bWMvc3creWNqRGhYbU0zZUdsVnpSQThsWUNTSGpYeUVq?=
 =?utf-8?B?M1pNRnNzTGNXZkpBL2xMN0ZvUDlNVU94dElSYnhUTXR4Q05PWHd0b1JFVmtv?=
 =?utf-8?B?Z2J4T3hqY0NhMktOSEkyazBvV29Nb1lYMGNtcWRSWm1jdlJGTHgzbDVpejhV?=
 =?utf-8?B?cit0UkZ3M2xYb2dSWWFmcGFyMWpZeWNoa3BuVkd1eHV6eDRabG1JRmVSblpZ?=
 =?utf-8?B?dE8rMzBZUDFYaVJZV0tjOEVPcTRvQ0ZtNmJmSzV5RzlrZTZLZW55V2xNWDR4?=
 =?utf-8?B?RHF4U3U2SlMwVFVTQWF1azI0eUlmdVBRd1B5U2xERWtDSXh2dmpaMWN6SjIx?=
 =?utf-8?B?djJ5ekpZR0NsYVdSUDAxUTNQVHBGcWtGTFkwZDdWc3NEbWE4eVo5MWw0TTd4?=
 =?utf-8?Q?uGDt/ZxNIxc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alF0bjM1eXgrK0ZkNHRyVDlsYWtMd1QvaVUxYmFKSC9NNWhwYTRrL3NVdkZS?=
 =?utf-8?B?WFF3TGZ1Q2RGeTFnZkUwdlpHc1dIak96bEdMU3JIa1NZWE1oMy9LYXFYZnQx?=
 =?utf-8?B?akZaSE9nNXROZk9hb1hKOVNuamo0U2l0TVB6b1NTdUtqQXhGMGtTOEg1UUgw?=
 =?utf-8?B?TDV0WDNuVVo2Tk5BMnBXTmlweUlmdk5FWTNMVllnd2NYa0tOak11OHpsMUlx?=
 =?utf-8?B?MGRtWGhRZWRaNkJKbktnQlVFcWg4dzlUY3RSRS85NzVWbzhRSXBDZ1Y4T1k2?=
 =?utf-8?B?QmkvaDNRMlgyUGtkTnNSbWR0cUFKRE55cm83a3A0b0p3RDgrcHk2Z3ZSTFJL?=
 =?utf-8?B?ZkRsQ2lMMTFYMlkwRWo0d2xIT3VKemFGbnNBbG9xaWgwK1hYSVBBS0d4cnVE?=
 =?utf-8?B?N0kwTkFtTWhQaG1IcFFOSlVNVjJ1TjhnU1lBTm8wS1BMakZxOXFqNk52aEta?=
 =?utf-8?B?YUQ4eTRQdnoyNENraDFZbmwrenJvZ2NLbzJ0aXNJZGQ0WU5XZUNFU3VyTExq?=
 =?utf-8?B?R1B5WXZFMTBrejNLVHZscXpoZHI3YWJac05vbVplQkJUcU5NTG5xSXpKMDFM?=
 =?utf-8?B?d1JyQzViS3Fwek9YMVhyM1JjTEFJYW1DTk1LMGFmTnFPdHlYL2RnNllVZWpp?=
 =?utf-8?B?Mklkb081OGk3cUlzTUdlTzBLWWt6SUpUenFiM2JOYnlTRmRvMU5WaGRZSjBh?=
 =?utf-8?B?bnVtaDJ1SGtCWEFGMmljV3BOTXQvd0VQZDVGU05jM0RscTVIYlQ3UlUyZk8w?=
 =?utf-8?B?R2tuUnc4dDVMSlFEK05yUlRUS3F6b2w2TkI0Z2p4dDdHcUVoSHY5T2RNRERy?=
 =?utf-8?B?VFlyV0pLMzhzNnNrR1A3U29TcW5IaDdQdWhwbmpGcFNCK3AvZnpvdHdQZjBZ?=
 =?utf-8?B?dTQydVlvMUpWUEZkVHV2YWY0N2NCRW8zUm5kTlMrZFNNQm1NeEJBTkYzeTNG?=
 =?utf-8?B?S1cwb3BYcWJkS3BBdEYwY3FqUTdHQlpDMm9XdDhjQjNhalJaOU9obW8wR25j?=
 =?utf-8?B?aVg0cVJXVlRTZUNYQjBRUzA4cm5tdXU3RlA0TE5RMDErbzYzdVVSa0pqOHlv?=
 =?utf-8?B?MUxYL1BEUkFTVUtmeUU3NGdic3hMMmU0dVJsa2MvQyt3TUw5V2tRL0tmV3Fi?=
 =?utf-8?B?L01ldDlCMm5GV1lCMDBNMXBGUXBjMnU3djMvWS9jQTFaRHdQdmx1Rjdzd0Zh?=
 =?utf-8?B?UXZGa2VCRzl0aUVrMlQzQlpUditMTitUd2hiUHMyK3hKeThDYk52c0svc0NK?=
 =?utf-8?B?TVpVUnd4YTF3OVlmM3NHdWM4ODhacGprU0dvbzZKVzZZYUxuTWhpNzNKM0xq?=
 =?utf-8?B?dkpVMnRqVzl3aWI0VjZzT0YyNzBEQlhlUWRQQ1QvajNNM2hpZzdCd2xUZUJM?=
 =?utf-8?B?Z2lEUzNPamkzL05XY1gyMEc5TzIxZ1krZDZRMkFKWDh5V1hGSmJHSU95RHZH?=
 =?utf-8?B?SkxJNG5nRWhVT1FzV0tlVUhyang1STNhTm1GU21QMUQ4WFVmU013NGZ2L0hy?=
 =?utf-8?B?dWM2Q2M2ZzR1cmppRmE4Y0h2OFdGZUdiZnQvVVRhSkhWUUJKT1BOMk0xaE1s?=
 =?utf-8?B?Y09nZWtLbWp6WlhTcEt1ZFRHVVJzOStJbUhTWUN4YzZ0cUd6L0tHTjc5L1hj?=
 =?utf-8?B?dkFQM3FuQ2FoSmV1ZUpiWkE2R0duYngxNFhFVnVXdDBKb0szRVM0RThLcDF2?=
 =?utf-8?B?akFnMkhmcnhjQXpjOE9meEhhTHU1TmRJNmlDMlJ0QlQ3T3JMT3hDK3MyRjZ2?=
 =?utf-8?B?MU5ZOFFlNDc0dThqZUUvejd3R0o3WFZUWkNMSWxOQnlZai80cVdrdWZYQ1Zw?=
 =?utf-8?B?VzNlZlhvSkQ2Zkl1c0tWcjFpRUYxMUtSUnNpNzAwYjZzaldNMDNabXFhVzd4?=
 =?utf-8?B?WDRhSjVyVzVRalVVS0ZuUmEwcmFuZUpkQjVMYWZ2dWx4QmYyWk1QSUdlaTNr?=
 =?utf-8?B?UTk5VGcvVE1WYjQ3dnhFL1pLZ0lDTXN5MVFHb29KQVc3cmJmK3hhU2srbENO?=
 =?utf-8?B?SU9QRkd2b0hUU2YwVjF1eWlmUzNPUkJiNW55QnA4NlJ4SGVZM0tBanQ2cFBu?=
 =?utf-8?B?cnJvMnJWQ1kvVDFCQnBPWmNFeFpPdWpMMmZkVElienBENVgrc3lxWE4yUXNN?=
 =?utf-8?B?ZTYwa3ozMEQ1SmpWMGdDQWhySkRyRzY1VVFCTitZbFNXOXZLUDJPOWdzYmNm?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 793974fe-8b1f-497a-e4bc-08dde542d359
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 08:22:13.6047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVu6qsdkjH3IpZj77XcGUTMj2fZsnuwL+LPu+PYpq1YR+BrQlcOkWzKSNY84GBzcMedQzWO1L4PJFcA9ooiqtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5778
X-OriginatorOrg: intel.com

On 20/08/2025 00:32, Borislav Petkov wrote:
> On Tue, Aug 19, 2025 at 07:24:34PM +0300, Adrian Hunter wrote:
>> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
>> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
>> valid physical address bits within the machine check bank address register.
>>
>> This is particularly needed in the case of errors in TDX/SEAM non-root mode
>> because the reported address contains the TDX KeyID.  Refer to TDX and
>> TME-MK documentation for more information about KeyIDs.
>>
>> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
>> non-root mode") uses the address to mark the affected page as poisoned, but
>> omits to use the aforementioned mask.
>>
>> Investigation of user space expectations has concluded it would be more
>> correct for the address to contain only address bits in the first place.
>> Refer https://lore.kernel.org/r/807ff02d-7af0-419d-8d14-a4d6c5d5420d@intel.com
>>
>> Mask the address when it is read from the machine check bank address
>> register.  Do not use MCI_ADDR_PHYSADDR because that will be removed in a
>> later patch.
> 
> Why is this patch talking about TDX-something but doing "global" changes to
> mce.addr?
> 
> Why don't you simply do a TDX-specific masking out when you're running on
> in TDX env and leave the rest as is?
> 

How about this?

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 4da4eab56c81..3963d4cd8fc1 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -699,6 +699,8 @@ static noinstr void mce_read_aux(struct mce_hw_err *err, int i)
 		}
 
 		smca_extract_err_addr(m);
+
+		tdx_extract_err_addr(m);
 	}
 
 	if (mce_flags.smca) {
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index b5ba598e54cb..fcf0b84a7c98 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -298,6 +298,16 @@ static inline bool amd_mce_usable_address(struct mce *m) { return false; }
 static inline void smca_extract_err_addr(struct mce *m) { }
 #endif
 
+#ifdef CONFIG_X86_MCE_INTEL
+static __always_inline void tdx_extract_err_addr(struct mce *m)
+{
+	if (boot_cpu_has(X86_FEATURE_TDX_HOST_PLATFORM))
+		m->addr &= GENMASK_ULL(boot_cpu_data.x86_phys_bits - 1, 0);
+}
+#else
+static inline void tdx_extract_err_addr(struct mce *m) { }
+#endif
+
 #ifdef CONFIG_X86_ANCIENT_MCE
 void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 void winchip_mcheck_init(struct cpuinfo_x86 *c);


