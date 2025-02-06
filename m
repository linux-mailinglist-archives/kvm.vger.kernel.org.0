Return-Path: <kvm+bounces-37540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1B3A2B666
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 00:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B08887A20F9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 23:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEABD22FF5C;
	Thu,  6 Feb 2025 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4WTajDz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303EB2417F7
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738883379; cv=fail; b=bb5Ir2XN2YVnbMXHq8vXVOPhxtvfDaRUOj1lkaDSDmeWq0uToI99inbigkIFQnythGm1QyucN5D6Im+rWD2FRcjIDtaRZjKq4aX6TFtc0G/HKgeQaiBK1OdaQpedkevLFsFQc9TMghPIkONJ705bVlRuAV/vuZvsRd/iUrpLCdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738883379; c=relaxed/simple;
	bh=NgoZezuHj8XECsHV7G1KEUN8ErHDAlrRwovhpvgPzh4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bRvRlj3cXzU9m/bhvONIM3L0kTZjbc7aVJaOOrRgDhCpmfUBHg2sGHPLMbqK65IPOB5yMPDMxlqjaRq2cl6PWaNUP2wLXzGP9FgrYZYo+igd54k6S7B5InLNMhIsVutSt/L/YPhgwJK2Mw0yPj5ol3YJ7wkKg+t5qJWuFIXW544=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e4WTajDz; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738883377; x=1770419377;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NgoZezuHj8XECsHV7G1KEUN8ErHDAlrRwovhpvgPzh4=;
  b=e4WTajDzUCPEBv4qf9ZlLxu80ZsepJMZMbYYHAhSk7fbsWOAhpX217mO
   fKgO/SMeEnZ5lGO8a6rwCsZ8mCxJKd+RaOn9b5TWpVfj5pveQZ0sYy6W5
   SSQZKGRF8QLpfMww7yDM62JC5RcbPqhP0K+5onzwp0fAYmKb9BwHrDdVV
   VkPp297zCeLijBrfw/6u408rE9DJbj8qwlN6rYh7L6eLUXRQr01ICIDoW
   lK8Xj6vrtysVH7c2HxRHs/z7+jEHdYCmhTEp4T1SjpVTDU4HVzfajBJPu
   C42RbYA2f0TK+JxZlf0P5x6tBB7pnjXYf2cfm+yfYgEBd5G5VACNapZjX
   A==;
X-CSE-ConnectionGUID: nGeF3zzwQfezmuqDScdS4A==
X-CSE-MsgGUID: HfUsH1MST0C9G6ZgA4KQQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="43274813"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="43274813"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 15:09:36 -0800
X-CSE-ConnectionGUID: 6FutV6LzT6uc2Wc++5vYLg==
X-CSE-MsgGUID: hyY+jA+WTYO9jHPK57lVZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="116390536"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2025 15:09:36 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 6 Feb 2025 15:09:35 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 6 Feb 2025 15:09:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Feb 2025 15:09:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNlehaBgbw1T2gjaqUkxQahU9c1ZzCQdjnoYNUo6W0BzdhriSDR9wc5V546ty/PMyIKnrwG9RKmPBh66Q53r16Cy4HyWC3aot+pQAUtDcL3rgQK008sYAY21rFLHQaNhHeYeIOA9RflJ6zFXYDXeWth7wAVHOKr0JpFJxSyebgbnbilmqHyqQnEYvBaW/M33fceDng//hWVNjTZXlLEcKQpKHBNqXkPsR6cVs7h3kgPojC2qKWojSdJ2zQJE1194jyc/1oq7rjGHaLn7NIh1XFf40PbLBnOy4Khca+5cffCGDCSKwLrTf8tK8rprkveuSeNyW1t8h0RBraEM3iBbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tNinsC9AzknObVdJ93bC58fYosCzcVcrbRYem7xsWc=;
 b=aZtwrxYgfdgjbQI64/lpMMqC93nrOnW04K0Lb+FscVDUCq+UZG6f/2OBVtK8ZuN0BpWDOGxK66N1vUjKURzM48WL8pmJ4lSB6SHPbIyGXKk4hXeZKES94RwuJU8FX8/5LMozU0g4ps/90LihcO1B+AVmhqFieyuwwc9cK+J6HOUKKT3cNiJsQa5RZuQ00VaOvFutlsPvOIdYvwQBJ453+MkEhBPsGqTDZGm4WbMctzqCb17FFHysfBC7KktPWrsAOPUk8zjeXMmWLzFMFb7Bjto6gJMLDPYacVvEI3VCTdkl6/sQ31LX6t6Abkx0QsjgOPEKzFROYLMYc7i4KhITWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6747.namprd11.prod.outlook.com (2603:10b6:510:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Thu, 6 Feb
 2025 23:09:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.8422.011; Thu, 6 Feb 2025
 23:09:32 +0000
Message-ID: <d06757d2-68c4-4ff8-99d9-5da5324ccb36@intel.com>
Date: Fri, 7 Feb 2025 12:09:26 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm:kvm-coco-queue-20250129 43/129]
 arch/x86/kvm/vmx/main.c:176:13: error: 'vt_exit' undeclared; did you mean
 'vmx_exit'?
To: lkp <lkp@intel.com>
CC: "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen, Farrah"
	<Farrah.Chen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <202501311811.fRf67aOn-lkp@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <202501311811.fRf67aOn-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0212.namprd04.prod.outlook.com
 (2603:10b6:303:87::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: e993486f-29b8-4eff-1671-08dd470350d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ckUvNEFhM2Nhajk3ZWJVMkxDWFpGcDR5QWF1MEVvcTFyRGVVcUNuQkpDVGl4?=
 =?utf-8?B?RmxnRzFZajdURm85VVlzdUVjdTlIQlorUTVMZEJUYUhIV0x6MzFOUVFneXFW?=
 =?utf-8?B?bDVmeisrN2RnamFDZ0dSRkRZb0RudjdFcVNXejBEdTNyRWIydEFnTVBPRHdZ?=
 =?utf-8?B?U2hXWm9lSkl5ZFo3ZHM1THBNNGdFa0kzaVpnUHVENjVJMjlmdmd1OHNVTFhu?=
 =?utf-8?B?a0JqRCt6MW55eGtEalRqUDlrbEs3T3NwcHFDYi9GZXpxQ05tNityS3hmaFRY?=
 =?utf-8?B?dTg0Y2NZem14UUtjb1RLOXlIdVJXLzVFelpBQk52T3hyTFM5M092a3F5YWZZ?=
 =?utf-8?B?djVKTFgwV3pDMXhjN1ZocVhvZEVTNE02S3ZvUHoxTWszc3cwTExzSEdHOVha?=
 =?utf-8?B?R3h5Q05rQmxvWmRjZDlJTzQ5STFYVWxnazdLNVkvTlRiSGZEL0VScjNuYVdN?=
 =?utf-8?B?OUlPaERaamdhb0lPeGxVZ2lEckJiMS9tYW1ZM0d0QkxUbC80SmhWSmd2eGF2?=
 =?utf-8?B?SXlXdG9TSTZpajFST0hJdTZpRXRCS2VaQkJ1RGx3UmxGNUc0RnppdnE4L3Rn?=
 =?utf-8?B?VUlKTW1JZVA0NDZ5NGs2QWpZQnQrMWk4eUVQeXJMZ2ZTZ3VOUk5NN0lOd0lv?=
 =?utf-8?B?ckI2NFVnOSsxZ1VkTi9NaXRJOExNVXF6bHVlNUlUUUM5M2RqNHlEcFc0alhx?=
 =?utf-8?B?UnhvQkFCSXl6cDhCT0dWdVVBY2RjaGRWSlpoV2kxSGNob3lVdjA0c05OWUVP?=
 =?utf-8?B?ZGJxWC9hTUp5UWZaVkUxeEhoSEdyUTlkVUtkNWREd0lVbXBUdnhyMDh4SjVy?=
 =?utf-8?B?QWtKaE9WMGg1SHNQcGYrMUsrVlNNWUQrbmdPVFFrNkhpZUljNkNIU2V4OEdQ?=
 =?utf-8?B?ZW81WEpHWis3VHVvNGduNmczNlF6OHBEVGc2N21tY1oxMnVRNnI1a202Rjl6?=
 =?utf-8?B?MDF4UEZIMG1PQUliTXVUczI3VFhGVmpIVDV5Wk10ci9mZEtLZnRyZCs1dzNH?=
 =?utf-8?B?K2UrNGZqdXhOamtQUHhjZXVMZmRuSWE3TTJwN3p1eWlSQU8vVnRaejFuUDNN?=
 =?utf-8?B?UTdKaHNOWjBxakE4NmtSb0FGMXpCMUNxbUEzMFdybVNCbVYyVEYzQzgrc1FR?=
 =?utf-8?B?S1Y4enpuSVNYZ3haR0Q3b3k0VGczV29EelJDT2w0SWdyK1QxRDQ3QXZEZ0xj?=
 =?utf-8?B?YlRrR1FHUDhKcDBNTHpyWk5ZU3JiSGVXd2FwY3BjMWZFTU5OQ2NxY2xZQy8r?=
 =?utf-8?B?VUszY0F0QkpGSXdJVEVGY0orREgyQW9STW5YdVdYNkQ3UkZqbm5pclpPb284?=
 =?utf-8?B?SUVlOU12bmtSN0c1L1YyQTAwWmtJanM2L25JWks3N3ZOOUlMVUZYTVVHUEVa?=
 =?utf-8?B?OEI5RzF3S2hkOTRQMTZxMG53V1dGZkVlTkp6bE5VUVAyNS96Ums0OUhGZXBC?=
 =?utf-8?B?azZqbVpURmpTdExqZDBMYVhLOE5oVXZ1ZDRHeWVVemExMHVQMzZDbXBEc2VY?=
 =?utf-8?B?dnhDaHBXVWdNZjc3ci9PcmQwY2NpMkhFTXkxSXJmZnRSVEZ3b1lzSGFjMHNH?=
 =?utf-8?B?bkMxSlQ5YVZidzJ2d3FiME40QkVLWGVXWndic0c0SHc4TExVUkRmMmloTGdk?=
 =?utf-8?B?WmRqd1p3Zy9Dd0dhZ0NCRll1dVZXRG11ZGNkMmVUdDVxbDNrK3lRWG9QNW00?=
 =?utf-8?B?R1A2Wk0yQ1Jmb0F6Q2crRlUzVlZoSFBOM2M3bGFiYW53bThzYW9tRkNFczJC?=
 =?utf-8?B?bnpUTnNmeTh0ZzRrZHBONDNtTVJEUFJ1MEROMHhEdGp2Wlo2d0VhV1FqYzk3?=
 =?utf-8?B?Q1pyM1lkbVdQNDRxSEFBQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGMrQVN4U0VhR2ZsbTB6S0NodWtWQjcxMitFWWlaY01qVXdMdDZrUWd2THBE?=
 =?utf-8?B?Z3dxLzZjMjB1OHpad28rS2c2amIvY05yNmllRFFBRUFhd2Y2K0pqZWxpZmhl?=
 =?utf-8?B?MURBZ1h6TzVqRVlLUkV1RmdjM3VzRmM3MTlqQ0RTZ2RwV2pEL1V6dXo2UWgy?=
 =?utf-8?B?QUhDUHZMemFBRTZsbzRjMFU5OUhUeGVZd3JIckk5OWQ4WXhXZElZS2VBSGJv?=
 =?utf-8?B?S29tZnlLQlZFVkhjUXdwTHB0bTRha2dFb0E3MjFVbGluRkwraEs4NmtMSEd5?=
 =?utf-8?B?TysxT3RkTmpKYUVma3hOTVBGUWtPWXFNd2Y1bkxCdGFxeUN2cWRybURUb3hN?=
 =?utf-8?B?K1UwdFNlK0k4eE45TFByMW5raU8rNE1SZGx5TVoxSDVDNld2MFpKYjRvZlVs?=
 =?utf-8?B?UEpJWGVzS0J2US9YYVpFbHc3L252cENnUGlIYmhRVmdEdUNWdWVtWkQrc0k2?=
 =?utf-8?B?N2VGeU1xaExmYnVNZDZlbG5wMHdnTXdRcm4vYTZ0Y2xteHYyQkxYTGJWbVR1?=
 =?utf-8?B?Q3g2M3d1OGxPaUVVMmRzS3E4K3hJQ3ZianE4dVdBVjRFWDVIRitvSHpycndF?=
 =?utf-8?B?Y1BhZzlsUzlVZjRRMzh3bmJPZytSTjI0K3FkQmZXeGxUYU9nSThtRXFRNm1i?=
 =?utf-8?B?R3B0RnA2WElvVHZZRjdxVm5Udmt3OE5pTnFQajF5cFY2QXhWZzkvZ0hiYzJP?=
 =?utf-8?B?TlRrdlNFMy9KSGttRWxZV0JwVXdyY3VOSEVlNjdsMC8vMWJoaEpQQ2duQ3VS?=
 =?utf-8?B?UDVibGtJdUJsNlJRK1FrMzdXWk1sRHowaVhLRnZzdENZS0hrNTg0WnpDdDRL?=
 =?utf-8?B?Y2UzN3g4TFZJSGliMmNrTlFtdU0yYUdacno4L1BScUV4bnBYRkxkNFlrclJy?=
 =?utf-8?B?UkpzcE5ZM2FKcTR4Y0xPblF3bndVOEF3QVdpNHZibTRDSEFmR1A1YUdaNUZ0?=
 =?utf-8?B?ZnZyK0M2Mm9GTXV3TlN4ZDZjYzlIaG5BVTIyUFBqWS95KzgxOWYwQU80bGto?=
 =?utf-8?B?ekp4T0JqZ2taMEdQd3lyaXdseHhEejBTT01xK0xQT2xQVG5HVG5sa0tHOG1i?=
 =?utf-8?B?a1c1QkdkdmxvWGZKaWlJK1VKSUVha2ZlQ0wyM25WeWFjNzBOekIrNi9tUnJM?=
 =?utf-8?B?a3poUXVjYnprbTFCYk12TmV3Wm40ekdObE94ODZGVEYxWWlTRWFjNmx4aUdL?=
 =?utf-8?B?R0kyVnZRVFJCK28rdG5LTE40RlFJSUY1Q0pwQ2hTZlZPRGpLYnRqK2V1clov?=
 =?utf-8?B?ejlWSXdLVE16MXBFZGdjd3ROc09ITVpodlVRY21GOUVmaUZoM3JpSmxvRzRK?=
 =?utf-8?B?emlxbjBqMnV5RXRrdHJzYkpRRE5nODhpcHhHcVoveis3M21XTzF3VzhDc05L?=
 =?utf-8?B?anVxdXltUXhZL3JWbjd6UGtVZ1pZTWZySVJaTlpkTnJ2RDc4Tkd4RHZMSXI5?=
 =?utf-8?B?ZjRkVEUyMlh0TWVmWElsSzZCZGhTaEljRHhueGpWWW9YeFQ1WnhiOHJWTHlw?=
 =?utf-8?B?TmpoMzdZZGRiZU82U0VDZkljeXYxKzR5RlRqT1ljMTZ2b1F3RFduY0ZEcFc2?=
 =?utf-8?B?NmtXZE5NQVdwTmd5bDZyelE2dHFsKzRxUVd6akFMbEFHQzVpQTYzSmZjMjIy?=
 =?utf-8?B?SU8xMVgzK3NZUU5zMTB0UzV2a2dNb0JwNDJRS0NwZkZrK1AwUXVteDFoS2dP?=
 =?utf-8?B?V2lHR2g4dUQrQ2hzV0ZLcFVaSFhVZVZnWHNRY0JEcWNVZHlZdndjeWU3NjdZ?=
 =?utf-8?B?eFpCdUc0eEJVSEtpd1Z4UnMwaks0QVdOL3loc3R2aVJjMzAyYW9QNElzNExU?=
 =?utf-8?B?VG1VeEtvb1F1NGlneVVRcFJCaFFIMUh6M0ZWeCtobWxFbVNCSzExNXpMSU9G?=
 =?utf-8?B?dlprNnowMVRqUXh1V0RVVTljUlRuTTRXL3hSUWZLdzR3YW5CNWhJaHNlMXpD?=
 =?utf-8?B?V3RlL1AzWVYyOW5RQ3M2cnVKOHFPSGpleXB1VEFvc0c1cmFGL3dqNXczd2dQ?=
 =?utf-8?B?YTl1WmxFK3F5VnhDZHJTZFlWTU1XNHZGaHpHWTJ6Y1pURFJTNmcxNHhBVWRt?=
 =?utf-8?B?SGVkejRPUU1INHFzTTZCV2ZQWlRXNWJjc09OSWgvZWplb2Q5OFJabHFnQlBG?=
 =?utf-8?Q?zBNlJsRakJL+nLOSYgY/ypnn0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e993486f-29b8-4eff-1671-08dd470350d6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 23:09:32.5196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jr3KiR4MCNaNPbe7fEjQj9fzYxaX0rtJhPuhfO+F2B8zHkVE5thdKnTJMbcl3x+q/vAoL7T74cBpb5C+kvf/pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6747
X-OriginatorOrg: intel.com



On 31/01/2025 11:57 pm, lkp wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue-20250129
> head:   0bc4f452607db4e7eee4d3056cd6ec98636260bc
> commit: 4b55a8f7c5f508fe1dd0005aecc81bbb5676aaec [43/129] KVM: VMX: Refactor VMX module init/exit functions
> config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20250131/202501311811.fRf67aOn-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250131/202501311811.fRf67aOn-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202501311811.fRf67aOn-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from include/linux/kallsyms.h:14,
>                      from include/linux/ftrace.h:13,
>                      from include/linux/kvm_host.h:32,
>                      from arch/x86/kvm/vmx/x86_ops.h:5,
>                      from arch/x86/kvm/vmx/main.c:4:
>     arch/x86/kvm/vmx/main.c: In function '__exittest':
>>> arch/x86/kvm/vmx/main.c:176:13: error: 'vt_exit' undeclared (first use in this function); did you mean 'vmx_exit'?
>       176 | module_exit(vt_exit);

[...]

>     171	static void __vt_exit(void)
>     172	{
>     173		vmx_exit();
>     174		kvm_x86_vendor_exit();
>     175	}
>   > 176	module_exit(vt_exit);
>     177	
> 

The above module_exit(vt_exit) was mistakenly added in the branch 
kvm-coco-queue-20250129, causing this build issue.  There's the second 
module_exit(vt_exit) (the right one) right after this:

+static void __vt_exit(void)
+{
+       vmx_exit();
+       kvm_x86_vendor_exit();
+}
+module_exit(vt_exit);		<--- mistakenly added
+
+static void __exit vt_exit(void)
+{
+       kvm_exit();
+       __vt_exit();
+}
+module_exit(vt_exit);		<--- the right one

The kvm-coco-queue branch doesn't have this issue.




