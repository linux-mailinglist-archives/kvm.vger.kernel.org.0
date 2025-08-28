Return-Path: <kvm+bounces-56032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6016B3942D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FD911C227AB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E4527B341;
	Thu, 28 Aug 2025 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/bPqCJE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE8E274B2B;
	Thu, 28 Aug 2025 06:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756363750; cv=fail; b=M6wv3yh/uYIgCpVhW+OA79dYOb6ZK9S+2GJS7IqxyCl8/PADulr8QhsgQWagQSIEpd3poArHptUdrHN52o771GXPURyU/RvzEUXCGmQ7YmiR6+ELVBVEy310/iskc8v5YxszFPTMvvr/F8IshvATYXG8JyZrTrGe/9AjnfOmjak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756363750; c=relaxed/simple;
	bh=7h8/4J50p6UXsIGCWsiKDUWUBtJG6GVf7C2WPHM1N0E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D6usu8rD76jwRPIJI7xXOpLWvjX4Xfb69+lfWtRWNIccV744qFpd8Q5W0Rw1XSx3TE2kgrGTGdoTMOnAnRSP35Fo3FORbQ+xDnZ55CvmjAsimhcWWeFE80LzvvHw0jFTFz9lvpdhO6ugDlJ8IvxtVo2QTITeCviZ7ZR5n0lwvYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/bPqCJE; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756363748; x=1787899748;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=7h8/4J50p6UXsIGCWsiKDUWUBtJG6GVf7C2WPHM1N0E=;
  b=j/bPqCJE1MzF/AW5FHqpoV/Wgg6NjNy/EzsE/KBlv8IX2I4iFXDUzuT/
   VZSAxLDfBB0LsloItG1hP1GqoxgyZbta1Sf4c1S0+twonJJJWMenfyKpr
   5JJVu3yCuW3r7tPiN1PpBAJ6SmiCMhW8n5zqomzAHH29/uNralmblo/uN
   TwO6LpQ+wbpWrJZHNYKTpDU2YccwmcEYIMtYSLMJzWY7IzUbtSmYTN/VI
   zxUKaDwkLQvKaew98nmqyH4DIYCFD9PQMlu6zmCz8BVvkSdg60lIQjJI8
   VYgT4jlHx85MZEISWT01UVEzwYG4BuTlqqojYj0XDihdFHLubQIUwx4wl
   A==;
X-CSE-ConnectionGUID: XeDLhugnSN6suMYqhLfjmw==
X-CSE-MsgGUID: xMCxC5kiSqa06U5jv3SmIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58688782"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58688782"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:49:07 -0700
X-CSE-ConnectionGUID: pVQc9Ev/Qde56QA+rBA38w==
X-CSE-MsgGUID: 9IKAg2lyS7+em+pFP9Bkyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169329249"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 23:49:08 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:49:06 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 23:49:06 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.81)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 23:49:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mE+z7PqFcC90AxyN0fxSgLPX5joY4uwHAFilBV8E820c6WoZalMbV02tZDlZffDWO3Z4InWJwYOiLRFr9upu1sOzxUxVVYp84i9Gz2LVZmZaGdCZNzLVq2pj00AClOSBx+my1kaOCEDuz0a3QUtfCIHj83SJjJljjWotY+hkgwRKxO2c7ncIsVivMURYfn/cIHtcKE33ZTp0AfP0W45KuW99O3NJUyH3O6Rauq3yUkVv/b8IyZLBzd68DUrF/f15R/yY58qYKXgcNJmDzDMrOEV1I9odpaP9e+LaHQTrjcMzZlIh0r5CEqvBjqxw1K1vb9wzetLGisqgHtwTUKazaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXOH+9TDckn+8Su6Jhf3sgDRDHzx0pfEpdnlNulcaJ0=;
 b=ovl/vA/HplmlcFyzz2DSNfQFbmqZkUzM4naeWcLDgqI47OojOclqXE5VVP+/JiP4KDzHUFKkCzuu/qsqTgwIoSHUfyBh+sAkRtnZpGDY1PbDS6GBRy+xoPIfnXBZfKQA1/HBABkNHvkDZvyIukcf/V50FmSekH3z5PIGpAfOO41jgWMcZeMaiIZWdNDQEi3HfQwuk5OG8KrVChgBRI3h+Qwq7fivcuA96SBIJaCQP/LmtFVd1yHO907YcRVu5ZiMgoQDyf3WFvziUtQd5agSSYUFetzxDFAnwB6PxeSSh2z92CKmPivhitOfqJXC/Q0dZih6fMuH55//4dwDQeKL4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 06:49:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 06:49:04 +0000
Date: Thu, 28 Aug 2025 14:48:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Message-ID: <aK/7rgrUdC2cBiYd@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-9-seanjc@google.com>
 <afacb9fb28259d154c0a6a9d30089b7bb057cd61.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afacb9fb28259d154c0a6a9d30089b7bb057cd61.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6291:EE_
X-MS-Office365-Filtering-Correlation-Id: 7794257e-76f6-4de0-b0dd-08dde5fefa32
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Mv+kLkCSlFjPtBqt8pQR1eAG5jDhNTwzzWRd3fgEMFHGER0fE/NVPE12Dh?=
 =?iso-8859-1?Q?pze0fGsIPbMR0QaB/Itix++A2K5umv2pwo88oOdRmopHquOT07K1vE6yiA?=
 =?iso-8859-1?Q?/78zpE4rjWN3Iqex2tAeJikj0rIJG98D1/BrqsNeWpJDJy8G1O716IyXvd?=
 =?iso-8859-1?Q?KFLrUlRByBdj4WGoDSFJDYdd0O6wDG1hdl5DRbmfm36Uqelgj6nGFzZ1H9?=
 =?iso-8859-1?Q?EIUcTZ/y+65nmKdeiXO7a794uY6+y+nyv2AEDwBRMlhZZSOj/NEsJUODfO?=
 =?iso-8859-1?Q?Af8XzG8//tQgvWmFtPIeVhaUv/B7wnPWpdwNMKvrrE3aQpNyV1nepn8AiH?=
 =?iso-8859-1?Q?2WQaoPAZLmys+u4kUADdqoredNqXkM+k2s37vEM39DL9S+WPtNgR8dCVZE?=
 =?iso-8859-1?Q?P2CBB1CGrCYKdQARBB7uZLPrc9YsoWKbrTs6/xwAWKVNSV+mCK1wa5xvhP?=
 =?iso-8859-1?Q?IedCh+JbI6Y+OtdH8Z1RERoPKla8zSFBab0JAqbrWbNybHxi+ZnvRRHm6z?=
 =?iso-8859-1?Q?kWPCpnC8YEYbe8TwUVXdWXY1s6xidezSa0VNqgAUCPyowf8+t3BFsVAAy/?=
 =?iso-8859-1?Q?1ySw6CjyxKxLi6Obgp/Je0rwVOYaV95m5bL1mTqr9BVk92yus5IJWkMTlS?=
 =?iso-8859-1?Q?srp0nJTYsBL2XZ9LbQY8/A+XWKYfgMD0ZqUUYxnZKA8Ls+cF+KkfKXHgYK?=
 =?iso-8859-1?Q?BicuZHcETFaYiohh1Y7eJRiiIcQKzyUGUQiZm8SovhJegpJgIvcVK6Zx3/?=
 =?iso-8859-1?Q?17Rwkz1afBdU7WVdn87vUHxk7W2G8IiMcY5iT40Of8uMxdM0Ibk+Ulz8BE?=
 =?iso-8859-1?Q?ZFOwNORi3X10gpty4fPZ0w0l2l3yUst7dK2IJcR0scXyvFCy5ERWkZQodp?=
 =?iso-8859-1?Q?wf8+T9U5F4rLk5kKS7rW2v/P5u5hknpG5yqamF1OAuTnTTzzbX51PHLx5B?=
 =?iso-8859-1?Q?NeWS3xxZ4jepj+00u4nkwznTlXCq3D78xYdpNF+6G73Mm50PziVsSsxVj5?=
 =?iso-8859-1?Q?VcoaYpIzGm2LsW0++vkJEDdRbuwjrDBeizFgjTGwv+xqhn02yySuU+InYY?=
 =?iso-8859-1?Q?UrSBUAcrgFmYW1htR9sfSio5ofXGNbHauW4d7cpu5bXteSC00Vwd9cdJml?=
 =?iso-8859-1?Q?Uqnqpc0gnVDVVQVxrkmWKcSmDo+rl9O9VUnq+f1P3OlDpZMyAK9Flf2s9p?=
 =?iso-8859-1?Q?5KkGgW0KAOQnDfLhnjLJp+6DOMo8z/raNOti/hMjGabubic9sJSaAmqXFy?=
 =?iso-8859-1?Q?+xI35wmjfLiKEQiGxNEk5ImTT/7MURvaK/zlfkCw4ApzfkXHSo4+4R/RgE?=
 =?iso-8859-1?Q?G4zHi6vZBD079isoHu0zaOIeteQKdzrDT8QntQ0epYHHVwljMBFQExsiDY?=
 =?iso-8859-1?Q?7lbI9eR0BtKWVj8WjCNTuTtaNL4ahxLvRCT2Wq1kMekt2CJWp/6+FB+hli?=
 =?iso-8859-1?Q?ZNlMUkMrBWDTDn1yOG86JFpKD1MW2RY1mwt4xw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?okK7flvaJ9zjfLU+X3WpOf4TAXGA9fM6VCMyD0i0tbsoleXx/uN+qmuytn?=
 =?iso-8859-1?Q?thT3nm3AmijM6UJOs8Z1dTCFTKTtrXOnOA0udS5ghhOOzknx0PBMhX+bhC?=
 =?iso-8859-1?Q?9fVtAqd+diejfzUAEhrBUdmD1w3BAs+0EJGFOiIhc3KGHZCHtfThHQxms6?=
 =?iso-8859-1?Q?Iej2/M//n2a1gIdLsYWzi82yQ4rePZ6mg+6WhGaLEr4mt8aec6yg7MHozO?=
 =?iso-8859-1?Q?MQLNZuv9lW9egmj/hREcUFODVkYlgbC6VkbWxldd1vzZxIEeNR2sBkMNG2?=
 =?iso-8859-1?Q?GGwtCu+BEoDskwO8CKaLOEnyyp+8OAxMvCINMQPXwtmmdsdDInAvv1BqEt?=
 =?iso-8859-1?Q?cB8nzfZ+HoUWivwba+5stRY8+elCTeqqdgXIvACslagbT7/f7wEPDgcGlo?=
 =?iso-8859-1?Q?eZa4KjFoGRxSpaMsCM8nTyxgNhAf9y8dt4FpyIjjVV/XQLP2FD//LEhQCK?=
 =?iso-8859-1?Q?x+XL8zrrNbmKia6vL6brrrfVv4qcSe5mIdgyLzx2n7szDL+ns/AoW/0Omn?=
 =?iso-8859-1?Q?Bp3CTgYgtBDOrTNyi7vACRvnyy0hzGxUyKmj3E0ZC9mHL5NMLPL1ik/w/X?=
 =?iso-8859-1?Q?n5cxtKnRJZj7ZlzkWZVeQOGlQXkVR8kwICoJkiDDFHmicWhu04kTNK4SbC?=
 =?iso-8859-1?Q?QoC+Kuuy4hujy3pMplk2aPQfMOtWnCvXVLVIQVIQOZ+kOojlXA8VfGjVbU?=
 =?iso-8859-1?Q?RzdNe09+lTcxUTXvhEGf++XSfOdeCekkO3xFEaiXKoztKuWP6lD4lp+SYy?=
 =?iso-8859-1?Q?Wx3I9u9qINJIwfX8DkvIhyoGr1wT6RdtWpX6pH0jdZY7XadNAyMIIRDdGh?=
 =?iso-8859-1?Q?OHBG3ML8wxMq604hTljdAYKPfVflRRMXlArcQSZ6lfr9gEoRSzx6UXPoSr?=
 =?iso-8859-1?Q?9HqkRIBP1W9EL8O9N3Iac66reCvG7DmDcxME3LKUJUQpmzbxiMNFAY9xej?=
 =?iso-8859-1?Q?ZSCwyUacYlS27MULy5AG8fSU7J3btIMDGc8cbGNw/0fU7PxQN8cMQpFPIC?=
 =?iso-8859-1?Q?IKYMf+CNKcFFhVlPiZXbtyqsVOwdYAKqIXEzYU1cZ20Uj++eow5ryLnoZa?=
 =?iso-8859-1?Q?8UhOPF6izStZMfjOhKCyl95Ayf8Y8n/R9DO7PeUKmpb+BiT2vP8GchB6Vr?=
 =?iso-8859-1?Q?k6rXOV0xO9suYZ+RI6BG3jA0dHdMHzCakQGFmLiSGuq5U0W55asFEz4Hyt?=
 =?iso-8859-1?Q?omcYZXrmA4FZe9QacJLK/eeA5jt8Kvk1vQsAR4rfg8CZUTXCHoazJMv9Rx?=
 =?iso-8859-1?Q?AU8m4Q8tZv49MRL8y6NWShjRisDNID2mcjpc+T9ogKOvB1a1nHDGKQ80Tz?=
 =?iso-8859-1?Q?UT6qLFLSWxUrQO+RZOBayGwfp1n6zTN589t9LS8IJ2+WbTumISNoMLbeNe?=
 =?iso-8859-1?Q?cagi9d8FvCBfaN1h4P+ZIOzGX0NqbNA+JRyDtOWE7IBIp2bwX4bd0qF+j4?=
 =?iso-8859-1?Q?THHqohkACdUba9QTfa0GecNBfLDoo8t/24JmM+ch3UsPTIU4Zveo++la4d?=
 =?iso-8859-1?Q?TtufVJrR8wl73QqCDT2auoNrPeynfa6d7lYtOTpR7jOQEV13JFvoIHns62?=
 =?iso-8859-1?Q?xeXoxMG/kYA2Y6rayjhDLn5QgjJSNQInzEYp6VOYfK+G3+30QEVJu+nFD3?=
 =?iso-8859-1?Q?v+fjXUqBN3SLgMD+OY8fwqp2A1Lr2kqvuj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7794257e-76f6-4de0-b0dd-08dde5fefa32
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 06:49:03.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4Uzg0vvDR7CUMDwIZK362rFUsTstkK+ecEJAm55Z/xwAZjGVg+QD6t9eKrRuygKUwiXOCNzKp/NcsBfxOGcaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 10:56:18AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-08-26 at 17:05 -0700, Sean Christopherson wrote:
> > Use atomic64_dec_return() when decrementing the number of "pre-mapped"
> > S-EPT pages to ensure that the count can't go negative without KVM
> > noticing.  In theory, checking for '0' and then decrementing in a separate
> > operation could miss a 0=>-1 transition.  In practice, such a condition is
> > impossible because nr_premapped is protected by slots_lock, i.e. doesn't
> > actually need to be an atomic (that wart will be addressed shortly).
> > 
> > Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
> > ensures the VM is dead, i.e. there's no point in trying to limp along.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> 
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> This area has gone through a lot of designs. In the v19 era PAGE.ADD got
> performed deep inside the fault by stuffing the source page in the vCPU. Then we
> switched to having userspace call KVM_PRE_FAULT_MEMORY manually to pre-populare
> the mirror EPT, and then have TDX code look up the PFN. Then nearer the end, we
> switched to current code which does something like KVM_PRE_FAULT_MEMORY
> internally, then looks up what got faulted and does the PAGE.ADD. Then the
> version in this series which does it even more directly.
Right.
If we invoke PAGE.ADD directly in tdx_sept_set_private_spte() (similar to
PAGE.AUG), then we'll have to have some way to pass in the source page info.

So, rather than passing around the source page, we opted to record the count
of pages mapped in M-EPT while still unmapped in S-EPT, i.e.,

1. map a page in M-EPT
2. increase nr_premapped.
3. map the page in S-EPT
4. decrease nr_premapped.

If a page is zapped in M-EPT before 3, decrease nr_premapped. So if 3 is
executed successfully after zapping of the M-EPT, decrease nr_premapped too.
The unbalancing of nr_premapped due to the double decrease indicates the
mismatching between M-EPT and S-EPT.
If 3 never comes or fails, it's ok.


> nr_premapped got added during the KVM_PRE_FAULT_MEMORY era. I personally didn't
> like it, but it was needed because userspace could do unexpected things. Now it
> seems like its only purpose is to generate a KVM_BUG_ON() in
> tdx_sept_zap_private_spte(). I wonder if we could drop it all together and
> accept less KVM_BUG_ON() coverage. It seems weird to focus in on this specific
> error case.
> 
> Yan, am I missing something?
Hmm, I still think it's safer to keep the nr_premapped to detect any unexpected
code change.

