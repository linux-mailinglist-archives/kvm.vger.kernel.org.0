Return-Path: <kvm+bounces-55016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 490A3B2CA6E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C20AD1C2577F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9535E2FF17F;
	Tue, 19 Aug 2025 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMm3fV0f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B362E228B;
	Tue, 19 Aug 2025 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624014; cv=fail; b=gdetPsN0TTKRSDed6zRn1gb5MPlya4QvZVPfy6L2tDmgT0GaoLvtwYTGjUWF9uO3H0JXW4xAKNQcLsP9dHZNHt8dR3KN5+FDrvdUVD88fRrP4UTflx8IOgSNS5UqM04hVoUwF9vZnOcl2tsJPyYz/HRCP6/nI2BgBOIo/996/n4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624014; c=relaxed/simple;
	bh=/M/j881zbd4fh/8BG4HXGaJzVvqRIXntL4IzjrIH0Wc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NqQImUIqHcQyIHGOyjzB/ddGP7SlKAqnkCfzCBKbad717Cx+ua1hCCkngdDJC3SUbyJrgTTiG/aCZwxKyB3MOY5pt5nosECEuTI8xSUMzE6AWbDTukaFI0bP0qjbQmSlYZEUqFa8euxOWphWFRtZLZP/BesnXDO2b9d8snERnqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMm3fV0f; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755624013; x=1787160013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/M/j881zbd4fh/8BG4HXGaJzVvqRIXntL4IzjrIH0Wc=;
  b=bMm3fV0fEbiOi5pBo7yqRaxXpsZSAQ+xNgly6XN3EzR9EghRf+h6EI26
   KGuuVE3F5Nl6HZUkWjYOrecnDEo6CBHEaKQtlZtt2hUMbeTx8YT5oTrP9
   3S79n27H1Atl6YP5L/mEYS+t4R5dXpKFBp3Ki7CJ6RRTW1ergdJv28XYs
   DTXRpPig97VwRVq2Jj8USiSqWwnZ3hXo0ert1DUZIUBfd3A/Fy2lwAHuM
   whZ3edCN1uanebW2edffI7H1RiEiH5YK0k5xphk22BpVe+0sEchIANdAl
   xcJ3ZrOsG5gMtQv8jKVkFc307cF5Jv2G+e0krXuZAofdM36GwOWI7j0JY
   g==;
X-CSE-ConnectionGUID: NfPz30S5T0q3daJUoKb+HA==
X-CSE-MsgGUID: yGPj/axcSFa8/bD+2LhBIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="69250823"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="69250823"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:19:46 -0700
X-CSE-ConnectionGUID: odtwFQqqS/O+u0I3Gz6Xug==
X-CSE-MsgGUID: yUEPRgmFSeWSuxXZ4zWxDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167526137"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 10:19:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:19:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 10:19:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.58)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 10:19:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8I1gaTH+Mzcp3Ze5cphW5UGppS/pMd1hDRLnF11IK/MNjIdyMV1VjsoMYfVkcJvA7jv0lE1fwLKZR84JYvAiVklqkXE0YxDntsZnRy+sW3YDM23lxy1Gt09NKUy2UcFrhUESjzdxiCSTM+kqW16zvUH5bii36DfW1okC1uWJ+CQnZoWa7XSVxMweMm9iOUaSZNd8xqTEoB/TT2SkTZZSMdwq1bXX3vyotqrDjX1sSJhGD+3vqMudkosYC8gWyBQ3bkhm2apyYKFt2cShqWTD9eLD5kCbK9G6tDv6rInE+iej+ehxwj/PpDVqk+J3314Eu5Ty12VVMSIdeSF1MvNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/M/j881zbd4fh/8BG4HXGaJzVvqRIXntL4IzjrIH0Wc=;
 b=DH2NYwfVlYsalwQBILc54LwNSwwGPWvoFg5zteY40IwXBRWFSMbxCmLZMHsjRD1AKFDPW0huLHAFpY9XaE12jrO0eqp68CkD/lJIpEFcqr6o4fYBF7OB42fsyRXKh77kokZIe1O0IeInkfTAydI22yggM4Q2dTveWrvu3PmgnVjir/2TTwuXFn6kEBjN45BWo43ibG1wkAgbuv9rJtdJLRx545uL6YBJ0aWrKGw1F/9fRUGoe4ZlYz2+xvCA+2uBtHlgB73VsiMFXWGqQJ2nCwBcZ0MnGsdmIfY7aACf93OrvFG5H82R9v2tHXTT4X/46xAMCKkiN5yi5L5/h8QvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 17:19:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 17:19:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"minipli@grsecurity.net" <minipli@grsecurity.net>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "xin@zytor.com" <xin@zytor.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
Thread-Topic: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
Thread-Index: AQHcCzS9G8FIC6Po/0iRr1FasZOvlbRqMNeAgAATpIA=
Date: Tue, 19 Aug 2025 17:19:42 +0000
Message-ID: <a06cef50bff3ac618ec4feaa501d416f9841c7a1.camel@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
	 <20250812025606.74625-16-chao.gao@intel.com> <aKShs0btGwLtYlVc@google.com>
In-Reply-To: <aKShs0btGwLtYlVc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7944:EE_
x-ms-office365-filtering-correlation-id: d4df802b-2633-43df-1eae-08dddf44961a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VDFYaU54ZEtRSExQN3pvWm9KU1h2UXUvYWw1aTUyVEdUcTBWUUV1M3BRVHUr?=
 =?utf-8?B?ZnNLZnBVZWRPdnA5ZmxiQUZEaXpYOTNDQmZSaDRlUytzV2Y0T2Q5SjNjZXpt?=
 =?utf-8?B?TGl2czdBN3ZGYVlYY0taS2VYVzBEeDRWTnl4Sm44MEtBUWJzWjBNLzJWK1hj?=
 =?utf-8?B?NzgvcUR6eWZWRndWdWd1djd4dzUzQXozTnVTZ1F0SWFkWmZob2taMkZqODdV?=
 =?utf-8?B?SHVXZjMrYUd4eDByYkFLbmpTRit5bGQyNHl2dk13NDF6YlAxK1BPanpOQXpx?=
 =?utf-8?B?T00rckEyYkUxdHExRmZ2cUt3MkNVQVZoRkdlL3ptOERuM005QW5ZT2ZIWVBa?=
 =?utf-8?B?NlJwWlRyd0I4MElQNzgrdXlEaVVZMDNPdjRjU05Nc09xYThER09Rd3ExV0to?=
 =?utf-8?B?TTc2V1MwclFFUHVFcVBVTVZGSkJuc0F6T0IrSURkSjl2ZmIyLzRKd1JRK2JY?=
 =?utf-8?B?Y0QxWURPcWI4aXNFOXJvdDJ6ajJ3YU1lUGFnQldYVWlNYS9yMUJHa3pjMXBh?=
 =?utf-8?B?Y21CVjFwbnVoWitGbU9USWl3UkMrZlBKMk16Q2RGL01Ya1BUYTNhbTU1bWdD?=
 =?utf-8?B?aHMzNHNRMTQ1MFo4OUI1SDNRZHNCVWJmOVdkR2FyY3BHTVlmVmZLUU9xRUxO?=
 =?utf-8?B?UXlJZW10THUzbkxXb1UvR0J4Z1E2a2xubExGayt0QUVFUHJNRXlrMnhtVDdw?=
 =?utf-8?B?NFFhNjhXcHBlTkhRMS83R2lCZkpOUWdIV1JUaG0weHowV3FJY0RiUENYOExM?=
 =?utf-8?B?ZXhkdURRM1FiSmZXYlpuYXpKdXU1Q3FkUk9COHpwQkRzUFlUMCtqcm5DRkZo?=
 =?utf-8?B?NmlkYURNd3lsTExiRDVFRmlyVjZPS3BkSHpDOElLall3VTRlcVk2Y1AwVXZQ?=
 =?utf-8?B?OGorRGtPc2d5ZkdkTFZ3U1JUUmFhVDdNblhBbGVlaXNXcjlDcHQ2c1hDU0NK?=
 =?utf-8?B?NitNTUF4b2pPYTIra1A1cFJEQ0lIak9EZ2JSZGxkd0RCV1hHckRuYzl5Z1Uv?=
 =?utf-8?B?cms3RGtaUUExYWUrMmR2aW5jVkdXVGRzRUpkRzdrYmkraWM4eVNlTmU1Vk1I?=
 =?utf-8?B?Vy9DbG1FMTMwWFgyc0xXZkh0NlhKZmtJZEdBSDF5ZWpQQ212bloyNGNSaW8w?=
 =?utf-8?B?TVdQOEEyZktNQ3VXa1Q5cEF5cXZLNTRTcGtOb2dqaGJTMlMxNEZSbk12RVlD?=
 =?utf-8?B?S2pLSCtnLzRtVTRycjAwQi85alpicUN5aW5lR2htK3B6eWNuOHdISWtvRU8r?=
 =?utf-8?B?dkFiNTNoVlBHVW9rMS9keUh0b05DRm54eWlEaTE3Q1BWRmtNU0t5L1pOMWdr?=
 =?utf-8?B?MGRLdHNRaGJSS0ZpcXUwcU5obklxM2s5OHpza1JiWVVZTVdNUUJ2VUNCQzdv?=
 =?utf-8?B?dUdlb0xTc2FNWGYxc212UlJuWFJqeGh1NDZGWThlVTR2NXdJNWJkUlBwNHhG?=
 =?utf-8?B?cjJEblNJNE9YbEtEOWxwSjMvY1ZZbkVTa3VWekVRNFNXR0FzcVZLNkdyaE5Z?=
 =?utf-8?B?VWs5VmZSajVDTnVLSmFBcHBOZXlvVk5YMGUrMUJ6dm04eWRJNUZjNFB4WjZw?=
 =?utf-8?B?VWNJb1pPVWI3NWdOeEJQeVlGVmpIRGpYZlVEeGVpamVIOUcwWEVvMDhZWkFZ?=
 =?utf-8?B?L3JtcENuVkVOSm1WSGNyQTZaelZ0WVRQRm82dmtNM3dsN2xzbFBSTjNtb1Ra?=
 =?utf-8?B?V1pBRTRXRTYyKzBvdDBCcHo1b3B1dmQxblZzRUFYSnF3bC94dElxbEVBdEZT?=
 =?utf-8?B?bk80Znc4MjdOZ1gweWZxY0ZMdTZFdWIyTmc3KzdKUXpQS2pBWjdMZGQ2NkZz?=
 =?utf-8?B?cDh0V0pianNpYUp2YUpkZ0w1RmtHZHhKRzBwcUFnck1ZWDIzQXRtcDZvYlVS?=
 =?utf-8?B?Vk43aFl1VU0zaitKN0ZrSHJ0Ry9xdGpha3BaMkFMa2U4ZjB6elg1RWYyc0Vu?=
 =?utf-8?B?T2kzTW54RTY5bFByT3hnVUYyZ0o5ckJLdUIxOXQ0eUtVd2o0VnNqcTVQa1Jw?=
 =?utf-8?B?SGlHMkhJaEF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXU0M0NHSk1JcE00eVJ3STl0dTRKckg3M3NYUS9Ma2I0WjM5ZEJEeTA3bDhz?=
 =?utf-8?B?ODlmeFE1RStQZzIrUDdYU3phc1FJU3RmOFZjSitLMkxhMGw5dkVmcG1EV2dG?=
 =?utf-8?B?TXpkWnBMVTc0RGsya2xnUGthcDVsOGJoQmxlK1BhYkpDbFpzWTd5Ui9zMUEz?=
 =?utf-8?B?aGZ3NGxTc0N2b3FhWXR5cWFqWStBck1YMlpJemRDcjBwcFgzVE1vaUFlQlBU?=
 =?utf-8?B?K2Q1Szk5Mm1mdTExTllsQmFLUVA0S1BKb0wyVy8rR3FPMUViQThGVm1QaFhJ?=
 =?utf-8?B?OHdZMlZXWmxxMXlZaXNTSWVqbjFrZ2pWekt4Tkxob3Q1WTl0d2ZHTzZHY2xt?=
 =?utf-8?B?Y3BiYU82NHE1blFGRmV0Rmt1SGZrSW9jSmxHdTVRUFlwL2pySkJ5M21TK2ZS?=
 =?utf-8?B?VkN0QUtLS1gwWlZ3TFZEUzVOMWF2dnlYZ09FM2c4OFNsWUl1Mm5wTldON3pP?=
 =?utf-8?B?SmZGbDhPcjVtVk5kdE4ycG0xczBxZnBQcmVGRU00K3ZEdE9vYUlEbHdLa1Zx?=
 =?utf-8?B?MGYxR1ozM1d2Qnc0L0lsUFl2cDdkTXdndjBzMWpFakhlcVYwVlVUQ29Yb0to?=
 =?utf-8?B?TUlOL0ZOSVZIeS9TdU43RWJKbERqMzVsc0VBVzN2SGpmS25vbE1tV0JMd28z?=
 =?utf-8?B?cENlYlpHMXJZdUhZZlJTZ1BxU0NaQkUrZ29xY2dob3VEL2RVMVZmR00wRGJS?=
 =?utf-8?B?Nng0VEI5UVdNbll1Tmw4Njlhc1h3TytQazd6REs2a3V3ODZiSk9tT28veU90?=
 =?utf-8?B?NkRJMlF5ZXlnOHpUUklHVEZzQ0UzS1FzVUw1WHMzcVdMNFhNMFo3d1gwcUta?=
 =?utf-8?B?L3d1bmkySmh0TGhNdG9qTW5GSGdtcnduQzlWR0pxelhZbDltZ2NEM0VjdElZ?=
 =?utf-8?B?RC9uYjdpb0VNVGVWRnlSUVBmK1VsU2pwdXFxVGY3dW15SXhqN2YzVFJPa2c4?=
 =?utf-8?B?Q0ZIMTUvbGdaUWhXamxLYTB1Z1lFNlNRQ25oeDB5TEFzOGNrMVlCbURQUlhT?=
 =?utf-8?B?eXMwSm5XN0VhNnA5KzJXZWxNYzB6TWxmeUNMdkxxUXpQVjhDc3lkQ0tuNTBz?=
 =?utf-8?B?R0NPcEJPN3BYMjZyMTUvYkpMaG90MTJKVWtSelkzb054dk5xV0UxVFhPaXF1?=
 =?utf-8?B?Y2RwZXFZTng4UlQ5QnM2ckJkdlFUamlnQSt0bUhza2k5dmZhdlBwYnVpZEk5?=
 =?utf-8?B?Ynh6QmJQR29mRmNLajlaWHdSamkxWC9XdzZVU3dLTjRoa0lGcFVDZExtMXlK?=
 =?utf-8?B?L0pvZjZDMWY5dkhXVVpKZlJ0bGhLYmJiT1hMTzdxYy8yVmhTcnRWREI2NUd2?=
 =?utf-8?B?c0NXRm54bCtmMFV0Tnp1SkxBWlhBMlFDdU5Hd09zalNJZDVMN0tmZ08rUXRS?=
 =?utf-8?B?TUN6eEFiQ05XN3NLK0dGcktNSjZDWnJKOWNXZ2p3WmFpdTdRRDRsWVZ0WTAw?=
 =?utf-8?B?NG1SQkVHTjJFcUU5a2JkcDdHWlZIVDR2RTlyY1MwT2RYUjgreDUzQnlLa2Zw?=
 =?utf-8?B?cG5JL1VFOU4ydWdLSmtGNEl2eWV4am5sN0FHUW5SUXZ2RmJFWTJnRFdoc2dx?=
 =?utf-8?B?YkxpbGE1NjdFMkwwOFgvZEJVdzZLaU5YU0p3UGpXSlBJVWxnWjVocHFmMC9v?=
 =?utf-8?B?dEZnRXBncExWanBsTUhGMVk5K2lxUGttd0hrWlFuOE1UVG1nVndsZk5YSnI0?=
 =?utf-8?B?dUc3SFQ5aGcwRVhkNVNnN3g0V3lyN3c1emt2Tk5tM25Pc1NSaTZLL2xQZkhY?=
 =?utf-8?B?bmJDZHlQR21xSGdlaUV6TDZvQkVxZE56V3ZmWG1sTXk5L1hFandXWk1IUnVS?=
 =?utf-8?B?a3FrYnk4ZkRHSjJvRUN5ci90UXpINGx0QnJ3cnNraC9aQXlwTUR1K2JhTTB5?=
 =?utf-8?B?QllSeGRYdHhiQnpsblNZd1dGY1ZxWGdjMTF0N2x3cXkwbnNML1FKWmx4R3Nx?=
 =?utf-8?B?SEpGSWR6K3U2dFJlbkRIaCszeGgwampDeEx4dW1NeUpiTi9kNEtXTUJsSjNx?=
 =?utf-8?B?WEVMd0xUdkJyOEpvby9zeFZoclBHUjAwOUNtVFVuV0RvSHRYMTZXd1lqb29q?=
 =?utf-8?B?Z04yOEk4UmJadWwvWTRTaENmM3FuS3pRYVpYV2pvSnlBWUg5T3ZLRXFLcnlW?=
 =?utf-8?B?bTdvQWNVcEtKTnNyd0NvYTZweUZVRGhEZ1kvTklDWS9iYUY3NC84UnZReTlP?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39321DCEF51F76439EBBA1E63ABD4BE3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4df802b-2633-43df-1eae-08dddf44961a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 17:19:42.4903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MzmJ9aIdbZil4QjUwJZq/HIJyVYYSGxgkKBBKKpzWK89Qfcgaeyq1cEkbBCjdtV1EeZOueQuu7o3znhJzn1AGxIcCYOAtMlf4Z/+48WwPb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTE5IGF0IDA5OjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGlzIGVtdWxhdGlvbiBpcyB3cm9uZyAoaW4gbm8gc21hbGwgcGFydCBiZWNhdXNl
IHRoZSBhcmNoaXRlY3R1cmUgc3Vja3MpLsKgIEZyb20NCj4gdGhlIFNETToNCj4gDQo+IMKgIElm
IHRoZSBwcm9jZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBJbnRlbCA2NCBhcmNoaXRlY3R1cmUsIHRo
ZXNlIGZpZWxkcyBoYXZlIG9ubHkNCj4gwqAgMzIgYml0czsgYml0cyA2MzozMiBvZiB0aGUgTVNS
cyBhcmUgcmVzZXJ2ZWQuDQo+IA0KPiDCoCBPbiBwcm9jZXNzb3JzIHRoYXQgc3VwcG9ydCBJbnRl
bCA2NCBhcmNoaXRlY3R1cmUgdGhpcyB2YWx1ZSBjYW5ub3QgcmVwcmVzZW50IGENCj4gwqAgbm9u
LWNhbm9uaWNhbCBhZGRyZXNzLg0KPiANCj4gwqAgSW4gcHJvdGVjdGVkIG1vZGUsIG9ubHkgMzE6
MCBhcmUgbG9hZGVkLg0KPiANCj4gVGhhdCBtZWFucyBLVk0gbmVlZHMgdG8gZHJvcCBiaXRzIDYz
OjMyIGlmIHRoZSB2Q1BVIGRvZXNuJ3QgaGF2ZSBMTSBvciBpZiB0aGUgdkNQVQ0KPiBpc24ndCBp
biA2NC1iaXQgbW9kZS7CoCBUaGUgbGFzdCBvbmUgaXMgZXNwZWNpYWxseSBmcnVzdHJhdGluZywg
YmVjYXVzZSBzb2Z0d2FyZQ0KPiBjYW4gc3RpbGwgZ2V0IGEgNjQtYml0IHZhbHVlIGludG8gdGhl
IE1TUnMgd2hpbGUgcnVubmluZyBpbiBwcm90ZWN0ZWQsIGUuZy4gYnkNCj4gc3dpdGNoaW5nIHRv
IDY0LWJpdCBtb2RlLCBkb2luZyBXUk1TUnMsIHRoZW4gc3dpdGNoaW5nIGJhY2sgdG8gMzItYml0
IG1vZGUuDQo+IA0KPiBCdXQsIHRoZXJlJ3MgcHJvYmFibHkgbm8gcG9pbnQgaW4gYWN0dWFsbHkg
dHJ5aW5nIHRvIGNvcnJlY3RseSBlbXVsYXRlL3ZpcnR1YWxpemUNCj4gdGhlIFByb3RlY3RlZCBN
b2RlIGJlaGF2aW9yLCBiZWNhdXNlIHRoZSBNU1JzIGNhbiBiZSB3cml0dGVuIHZpYSBYUlNUT1Is
IGFuZCB0bw0KPiBjbG9zZSB0aGF0IGhvbGUgS1ZNIHdvdWxkIG5lZWQgdG8gdHJhcC1hbmQtZW11
bGF0ZSBYUlNUT1IuwqAgTm8gdGhhbmtzLg0KPiANCj4gVW5sZXNzIHNvbWVvbmUgaGFzIGEgYmV0
dGVyIGlkZWEsIEknbSBpbmNsaW5lZCB0byB0YWtlIGFuIGVycmF0dW0gZm9yIHRoaXMsIGkuZS4N
Cj4ganVzdCBzd2VlcCBpdCB1bmRlciB0aGUgcnVnLg0KDQpTb3VuZHMgb2sgdG8gbWUuIEFsbCBJ
IGNvdWxkIHRoaW5rIHdvdWxkIGJlIHNvbWV0aGluZyBsaWtlIHVzZSB0aGUgQ1IvRUZFUg0KaW50
ZXJjZXB0aW9ucyBhbmQganVzdCBleGl0IHRvIHVzZXJzcGFjZSBpZiAoQ1IwLlBFICYmICFFRkVS
LkxNICYmIENSNC5DRVQpLiBCdXQNCnRoaXMgd291bGQgcmVxdWlyZSBzb21lIHJvdG90aWxsaW5n
IGFuZCB0aGVuIGxpa2VseSByZW1haW4gdW4tZXhlcmNpc2VkLiBOb3QNCnN1cmUgaXQncyB3b3J0
aCBpdC4NCg==

