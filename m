Return-Path: <kvm+bounces-60080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA6FBDF79B
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 17:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E5281886D90
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7AFC334393;
	Wed, 15 Oct 2025 15:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpH4p6yV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B942FB62D;
	Wed, 15 Oct 2025 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760543347; cv=fail; b=r7VTt9UaaHH9m7FxrreQvnFjNoLgmoU1syA6De4B4tNr7gpizqwY/R0jbl4iPCQqrTRkviqzzDEc0ebgk7JIaFmd8du77ZuWsZ5I8ww+JH/aUzWCqNRf6NsVS4Sf6kSkNz8uYTXCNPg0PKWfIxlKLaC9CRuKjUCOR3O2fJas/ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760543347; c=relaxed/simple;
	bh=tK+1BYSFos/WF72ZVRA878oIU4Ngf2ef/VWuYxK2+xQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=L9qp4TARmZ7eCeehHi2YGqzwk/2EbgBM8Z4dINL/ZXd2GhCyYT1T1FU8jjAZbbXckMdQrXBMVYoPJNRalcqohaFBpkiy87AQtH1KiBHEAyjnXpG/yDf0+LC3JS6rS5YHO70NPUEXTvySFHSBe6Uh5dMNis3bgnA+xE6lWBffcJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpH4p6yV; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760543346; x=1792079346;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=tK+1BYSFos/WF72ZVRA878oIU4Ngf2ef/VWuYxK2+xQ=;
  b=ZpH4p6yV2xbFII7NDb1+yjHBCtJD8voBaL+Vgum0mwF5iXFsyW6FeEV9
   NJlB+8QX8G27ng7tA07JTNbBxe+J4wO7rmqlmXB32K8WcpVS4mk824eua
   Yahg2Esu0G69jM9r6XJRZsLd2S6cvgqDKemvjcUY/z3c7yBAVBOscT49e
   UTlriIAVVHrmuvPC89XkqfR5QEj0uWlKcLwam9m10y3/uDxfjmFayLqGz
   pVtklvuR65cgIc8fSkCDtPuhBDN1eGle2TgTvofg3OVsAzowBT358d6YA
   6HbKsqKcjY1IEf6TI7ArXufbQadqjSYbX0F6+RPi+ea88a7ccssEJBxIZ
   w==;
X-CSE-ConnectionGUID: mBGyf6bFSE20Bl2ITmSFlA==
X-CSE-MsgGUID: eXmo+y02SYaTm1jwZbcjRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="65343109"
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="65343109"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 08:49:06 -0700
X-CSE-ConnectionGUID: Zqo2uo3UQvWBx+LSnpiaEg==
X-CSE-MsgGUID: 1f+QuI9FSjKIWhrqB/aqfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,231,1754982000"; 
   d="scan'208";a="186225960"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 08:49:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 08:49:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 08:49:05 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.6) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 08:49:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DchptDKirtKUGdTm8rgypEgr3+tI6rYSgAQxYg6wsdSlwnO3f89Ot8q8/JO1JYnix1e6K31cbbv+wvUnEmqAZ+ONqVZEIshcA/v6f9/zT4D8Us8MZh969mzkwYIgt2ycTpdxuR4KJntGRnB7yFZKn1S+IWLNDo9S/GHROZYSdkz3R49ikBqV07Tge9SifDedP5FKZCf9xiQyc/jAn8Ag5aBSxl+/JTy/etwf98IVOpLiQXC4sg26KnJqelgmYc4qySn9fT9AI8+5+pRG0KYXa2JCm+0xQfID5c4VeKPoKjVAXhktdQLH+CNagjPkAO1JM+VZZD4nu5WIGhyg4k6KJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9Uqoihkyji87gw4q2T8JQZI0eM5JrEogZLU7XJ98Hk=;
 b=a6yZD7bHt9FD20ac0Q2UiCSBDE21UgOzzodV2hFPRpH9KzbR8cXenN/LS5lov8ARIZdExWv6bwr+QRlKB1mt99UiSOfi15ba5pcb51ei0YU8Mh5eaqrnPPiNW6x2X8lJ9Ech3d3IGP4Y84I2NPFM+2n3D+B9V18pF9FBLYZrUTwlQlHQgLg8MNoHWHfNMc9Mh/Fo/OGLsukT4/ibVQ6AydOmzzMxi+F63zmzZuwaf8GaQj57TyS6FqaTfZNsbX06D8KgV5A+40m+rag5DHFIdR+TVuCQ5xW4dZHRA9X+EZ09lILmUHJYD9igEMa5Jpqo1iSWH1lVO2Yu34Pl8z7WcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6136.namprd11.prod.outlook.com (2603:10b6:208:3c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 15:49:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 15:49:02 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 15 Oct 2025 08:49:00 -0700
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Message-ID: <68efc26c792a3_19928100a8@dwillia2-mobl4.notmuch>
In-Reply-To: <aO-oIRBhSIZo9mef@google.com>
References: <20251014231042.1399849-1-seanjc@google.com>
 <68eee932c6ef_2f89910045@dwillia2-mobl4.notmuch>
 <aO-oIRBhSIZo9mef@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 89830329-f951-4365-33f1-08de0c025cf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RjNQSzg2WjMzZld2bEFVbDM4eTBrQ3VrVmo2eTNqdWdzWC9yMGIrU0djb0Rz?=
 =?utf-8?B?MFI1RmJLT05vWlEvUlB4NVZFZk1LN21EWHBtMjRkL0VMY1pKajVwZFNwYXFi?=
 =?utf-8?B?TDNKWk5sdVM4UEhUMzc3N2RIWktvWXduSnJzQ1NkQitsa2E5Qk9WMEZleW9S?=
 =?utf-8?B?cXJsS3JtVUNCL0w3NVYvVm1oV1hUMWc2c1cvOFc0WUNBRm4wRjI5Zm90eFJ1?=
 =?utf-8?B?QU5RZmxYMGU4R2ozdFdVOTVUbFdqRGEzd2YyMEN1ZFhIaU0raWZVQWwzVzBC?=
 =?utf-8?B?RjJRYk04N0NpR1AvWHp0L21ZMlpnYUxGZ1N6S2FZSy9xM3B1MHhkdWtWNXVK?=
 =?utf-8?B?MmV4UXZUV0JycDhQOWRaVkpuL2JUb2JpRWZOdWlKalVzdENydjBVQ1BZa3NH?=
 =?utf-8?B?MWlsMEM3SWJ5OU1lRjRMaUVSQTlhcE5RcGxtV2pyZ29aRDlLN0taT0pFY0J3?=
 =?utf-8?B?dlRRKzZIcWNIK3RUTWNFem9wL3NjeEI3VjduRXFmMzBpbzVUN3Y5S01XblYz?=
 =?utf-8?B?VVRrNWJsWnJORDNEaDFVK3dCYldRUWlWbno0dmxzYmVmQ3pOYkdRNDZNY1pD?=
 =?utf-8?B?NUdvOC8wMURiNUNxLy8wdzExcU0yOFBhQkthaHh0WngwTlZCK3JNRngzam5k?=
 =?utf-8?B?dW1LNjRwTDA4UG50NHM3blN5bFJqY3pXUmszYTVIZXdTMjN3U21yeVlTbkJl?=
 =?utf-8?B?dDYxOEg4cWdHLzlNeTJvSkJ1Sit5enc3V1BtS3pjNzIydVNKVzgyWVNjZ1VQ?=
 =?utf-8?B?M3FkcE9kQ2hocXc4eUthRVJMWGNZUlE3MzVydWczSm5JTmRoNTJxT0UxUTBk?=
 =?utf-8?B?QTdkZk1nMHBOcVg5MkdybHNNVmJNOUI0Z0YxVWoyQnNjTTY2SVB0UzRWZmJN?=
 =?utf-8?B?THpMTlZVYkExMTUvWUdKc042MExPUGcralVWSS91V082UWF2VnArb1FGa3Qy?=
 =?utf-8?B?anZ2MzZMMUVSclk0WmQvQ1ZucmRRYWNDNk5JODNTZjc3K2JJeUQvZ2J1SXRq?=
 =?utf-8?B?VWNVbW1YOEFuM0dUNTJOL3JyQXlHMVZxZnUyK21MRWFhbkp2OTkxaTUzamtG?=
 =?utf-8?B?NlEzNVJIUzdMOXg5SEJzMEhmUVdHUlMyWllDSDJBN3V4SzFRODJJYW1DT045?=
 =?utf-8?B?OEE2WG5Ba3FVU3JYK1U1a2liYTBnblhNS1lNVEUra2Z5endwNjEzWW1JSlV6?=
 =?utf-8?B?WmQ3UGlEWllMbzFyeC9jUFArd2hWWElIUG5RbGkyYXFtZUk0R0t5VGpRM1pI?=
 =?utf-8?B?MnExTDA4L2dEaU9qVEpNc2EwUEczbW9mVW1EYzUrQ1ZzVWdRd3ErT0hiME1F?=
 =?utf-8?B?aFNXZlBZTktLYkpxQ01hL2tkVTJTOWdFdkgveTJVUjN2WGsxc1Jva2pZa2FK?=
 =?utf-8?B?OExsU2YwbDhjVFUzbzI5bmNVYUc3UkxQeE1NcmRPdi95S0NERkJ3TW1maXk1?=
 =?utf-8?B?UDQvYVBqcHV6U2kvN1dub0VDQ3BqMERvUkYxbVVVbEc4MlZCb1BoL2pJZXgz?=
 =?utf-8?B?UkczRWlJaHlTZ2dpV0dtNXVHUXZWSW5VRHRBVTR6YzFTSFU1VWFHR3Q0NkFP?=
 =?utf-8?B?VlYrYU03WFY3NDduUndLTWFPWmdsRFZDdzl3SWxBNldtRXpSbGpzNzZ0ZTZ6?=
 =?utf-8?B?Z0ZKV0ZWVDhhTm04N2dOZGE5SlFqRlFrZWxsU2ZmL1JPaEtUL2laOTh0bGlm?=
 =?utf-8?B?TVZpeEphVDVkb05uSFFJN2E1aU9XVVJ5eUptU004cFE2WmZhSllJSy9nTnFn?=
 =?utf-8?B?WkxCVTJqd0dvbEZZVmxiL3U2blJXWU1yd3VWa0JENVd0V1BRSDJVVjh0MnBH?=
 =?utf-8?B?em9OSkxHMTFyVCtpa2FSMWlQd2t3d1pKVjI2SThKYkh6WGVqNmZiTldYQkJD?=
 =?utf-8?B?UW9Ub0xja3ZPMVAwUHNyVmpRcnpIVEhyQ0IycEpCa0lTNE1aZFJrenJzaG9i?=
 =?utf-8?Q?5ABgfx6tJJDpk92w8FdFx6nqfgn2HAaE?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVlBVURONVhaeDlxQ1JYM2lZTVptVkNYYmwvV2hMMnR1cVVBNm1OUjVPMm41?=
 =?utf-8?B?cjc1WDFPT09DMnJiL3V4c1FaSEp4bVJFZk1Ed2F4R0xyNVBWQ255QUhUeWh5?=
 =?utf-8?B?aUJKOGZhUGdMOGdNM1Z6Y0h5ODd2Q3plNnc0ZzZIbEFsUXprTDBEY05lME1N?=
 =?utf-8?B?RG9VaXBOZTJJcGRVcHFMNFhPZnNwL1E1bFF0ZzZ2S2JaOVlSMXlyaVFUY3Bl?=
 =?utf-8?B?WUVPeElEQUJIVlpWaGZudU5BZ2tDSUt6elVxQVgvbDBibG4ra0NvNmtBVWY1?=
 =?utf-8?B?Wkp5R3BsWmMzUkNYTCs0V0RoSW9HdFkwZGZXMkQyQXVCQTJkNHowVVU2MmdP?=
 =?utf-8?B?U1JvZ1dSc1ZSUlIvNmNYSW90TGtqUENUR0prek9kczNEdnVWblRJcFVNZ2pG?=
 =?utf-8?B?OEoyZlFKNHJZWHFVVmdQNXBIRVJnMU5LSTd3aVFFcTE5d0lZajMydzQ5ZGdh?=
 =?utf-8?B?Q05RV2hVQWVqN1dFMHFJNXBhR2tEM05UK0xYSXZzNzFOOVBMdEJBL0cvTzBq?=
 =?utf-8?B?ekx5TUZ6ZHFIVmhJNmxJaHBhZ2xZNXBmY1JnMXRCdGpzOW1hT1RSWWs3dnl1?=
 =?utf-8?B?YnBwYXNpcXhaVXRWZmlBc3FkV0dCYWtseFBkL1VSUVlYbGRQRWdzcnVjRU4r?=
 =?utf-8?B?d1l6UVZEb3hoVGM4YkU2NGduYmRySEk4UDNuOHpFRVp1Z3pxOHJhWS9Scyt1?=
 =?utf-8?B?c05MZkV6UmF4ZWVLOFFwbGFRYlpIYnhLOFdhTEFhVFRJQy9aS25yQzd3dHBt?=
 =?utf-8?B?cDdreUVzQnIrbExQUjBxbEZZNi9KTC9CakMzYS8vdUVLZzBPSWxPZE83bXM1?=
 =?utf-8?B?UzhQYTBnaXIrMzIweVg5Y214MVlSK3U4V0xKTlBJVERjZTZ3QUJocXR4Rjkr?=
 =?utf-8?B?KytNSkhKQTlrbEpXTWptMHpOTlQ4MGdSaFQwdzdsbUN0L3JyM0thOFBDeGVV?=
 =?utf-8?B?ajZTMXMrdytjVlJJWUEwanE4YlRyVEpUN2VvczVtYmJiMXR5NlJMdFp2V05Z?=
 =?utf-8?B?L1VISlg1ek9HTENrd3VUR2NvbFgwRy9ucGJvTkg4Um1Ia2pVS0N0YmpIdTQv?=
 =?utf-8?B?MHB1NEt3czRnTWhPTmxWSWlqNTRldGYxVkJ2K3oydHVBZTZWM2xZb2ltdXJz?=
 =?utf-8?B?RzBTcDFNUUpJbDhDd2d3aEtEWi90T3RZenZWZDlsWDgwbXRDaSs1NUpvemla?=
 =?utf-8?B?OENsUys3Q2Y0U1JsYkNTYllpdWs1M01CYVFJL0l5V0NCelpZbmNidEJUM09N?=
 =?utf-8?B?QnJEb0toLzJnWEdKeDdJdFo3YURHaThzR2RYRXNsak5SREhMU1BOMGFEM3lw?=
 =?utf-8?B?ejh2YmVFeC9HeGN1RG9XK05ldzBjZVNWWGJ6VHBsZ1l1SXJGdmpvYWFPWmha?=
 =?utf-8?B?ZVZ6Tis3TDJXdHhJUG1HdEg5dFVpL3FNaE1KT1Y1cHJySktOTm5zdG5ONDc3?=
 =?utf-8?B?OGwxR0ZlWFZwVHQ4ZGZvbXA0VTZ4K2dHSFVVTDB6b3hOYUFCQ0JEcmRIUSsv?=
 =?utf-8?B?QzhpS2h5NXphZTNUSmJORFZDRTBVbS9wUVp3WGZiNGZoSTlrcmxtSTZjNXZt?=
 =?utf-8?B?bWQrZkt5VDZGRkVBSUVZMktvclhKRm9JWitrcnpiRE9ITmQ2bXBBNUNBUDlp?=
 =?utf-8?B?eC9Ba2NyTllMcXdzSTM0Z1V1NWQ3alh5Wks1SFNZN2NhSVVmcThuSDVBandG?=
 =?utf-8?B?UjB6T1lVNkhnSk00bE04RDhiWlZGVEdpRkFpYkZEcEdxN3VTOUdQZnZsQzJZ?=
 =?utf-8?B?dDZZN3pvM2R4WFlUd0NBbEdsRksyMnZMbWZZTTFEZkt6cy9pZGh4WmdVRW5B?=
 =?utf-8?B?OHR0bnNrQnorRzJaaTJlMWswTER0OVBlZEJudFdNNEZHZHBBSW1CWHlpS0xJ?=
 =?utf-8?B?QjZPdi9hTVVhNGdVeCtJbW1LbnFnK1Q3RXJIYlE4MzZzQWxZSEZnTUs4RUtz?=
 =?utf-8?B?T0RqSWJOTEJNdktabzRBc2owOGxaOVNDWUJtRk01aitzNTFwdW41Tm0ybytw?=
 =?utf-8?B?N0t0VzVsNEphQXpocmRMMldMRDdka1hDUUNmaFNvNGErN1VjNzhMRHRGZTZ5?=
 =?utf-8?B?bUpuMXM4TEVHRjBOb2I2YnpzSEtkUkNFSndJdm1ZZENWcTBCZndSYkVCWGd4?=
 =?utf-8?B?VFFJY29rZnYwVW9heC9JQnpwU210UUEzcThLRXVZb2hpYmF3ZVgycktQUDZJ?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89830329-f951-4365-33f1-08de0c025cf0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 15:49:02.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgGcdJc9Kd7glG31f0U02C3wd1d4oz2bR2fJV1YM+K+smwur3xnHvPZb0hzs9wyFUSSInEKwJYJB/ImSdB5mb5uwM66M5Qb3Om8dWNxoRIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6136
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
[..]
> IMO, any reasonable reading of "inSEAM" is that it is talking about #1, in which
> case the pseudocode effectively says that SEAMCALL should #UD if executed in
> "SEAM VMX non-root operation", but that's obviously not the case based on the
> statement below as well as the TDX-Module code.
> 
> Furthermore, the only transitions for"inSEAM" are that it's set to '1' by SEAMCALL,
> and cleared to '0' by SEAMRET.  That implies that it's _not_ cleared by VM-Enter
> from SEAM VMX root operation to SEAM VMX non-root operation, which reinforces my
> reading of "inSEAM == SEAM operation".

Ah, got it, I see it now. Added this need for clarification to the
errata ticket, and already got an ack on your Note2.

