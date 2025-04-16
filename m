Return-Path: <kvm+bounces-43384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A585A8AE5E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 05:13:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03BD23ADA90
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 03:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE50B227E95;
	Wed, 16 Apr 2025 03:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RcOil56K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465D1A83E5
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 03:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744773176; cv=fail; b=nVtYeBR0HUqopcQDIKbrImyWVniuFQhE94/HVRobT6+y0pG9SyRrQDxtUPf5i+MYYIFnSLBsvp+sTKiezjXYeEVlkOZ26EMTjLNd/kIs59LuF9XBPSgaWc+yNlYylj7iymKhLidJMeKzF8en2y9rb9aGs7FOQGHmqloPeFsLH+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744773176; c=relaxed/simple;
	bh=61WXife8oF11VZpf4mFjxNZSRXx1DMCzBhygoaKdLHY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nSj3MJf8+LPcxsYRyqbP/3ZzqXzrqphMAXq/gnlylK6wWC2NW6cvTbkpZttqBxUMFx4a8X6fLpEUX8tdUF92aIfRE3IcwAn88daC/ZZdAzQQs5PgCcZqnpaCvzUPFM/HEJo0sKo0IK2XQmyoRLsSdP8g8pR2pK8svsZ08x/ic20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RcOil56K; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744773174; x=1776309174;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=61WXife8oF11VZpf4mFjxNZSRXx1DMCzBhygoaKdLHY=;
  b=RcOil56K+8q+7uNL13Ze2LJFbeNsDRYq8sgrXxS1nVZV+oI7TnmK9oRr
   j12Uk0UdlpXu9AP5QHnLUlzDrTdIhejIbjvD2QHkvDwUpEg6q2rjjwZed
   EvK6u56WEilA+BgsVugdmXo92xGD37+laPsYMynVh6FTrJB0cT+QqYouj
   u75AQynNAe9bZjnXvzgb1McTZgzbUalIfmUcq/77vNyLLwC4Sm+hIiphI
   Mi/MdxTWqNVMpqG6jTevBSFxNEqhhncRg2JpJt6jc+rZewId+Uf/AEOaN
   FRQk9bra9ekVIyCtDcDCNLUe5OYlvr43RyWmFpK97bpxEH5LWnCwKq7mA
   g==;
X-CSE-ConnectionGUID: pm/XW2/vSsODov5QwOChTg==
X-CSE-MsgGUID: ledMszM6TXak7eNYZCvFGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="56482215"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="56482215"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 20:12:53 -0700
X-CSE-ConnectionGUID: puYxfxdfTJ2ljcvU5bgfcQ==
X-CSE-MsgGUID: 61ZlVIc4QEOiMAQ1p6ot+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="161347273"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 20:12:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 20:12:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 20:12:51 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 20:12:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1ZcHpVft9m3GB2ut6tK8IGI2h0BWUDP4qPIg5CxpYCMj5FVR0xkBVSDeLXholqT7GSltHY1bro3oYgNhzPz2C3kJC0VGKpl5iIpdR0/5t40ZBwgrQ1p7zF69BPlRnAf+OQy53zaSGavgVBdmODg8CNM+nRZ+yoR5+BFi8SL2KM+sxwLMgLSJWuXmqnuVZ3eAv8pMTobooHNP9eiN4PL/vVf/JBUk4SGc2XrP0oE6BDGr/kx/T0LGy0BSr0rOgo2i7UJVGdPcChZhrwwQ1W7SV81cGmj4mxKR5bjFNkz/9UGTHhkoRyQvAZZEsmdLk23KmxSPQ7ESy/iuZBXUigUhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61WXife8oF11VZpf4mFjxNZSRXx1DMCzBhygoaKdLHY=;
 b=NNum6Np3AxTRNisoHFKoliIr+yzxbFQDBMisXND5AjYcIFAQM4IGSc+zz1ymUGOLXV4Np7PO5DYWlB/1VEZmw0RF3wFQZWJWrt6dYqHsX5sImVU2CVYokAPvebd5DPxYTJZfBsY8Gr7ze3Ny4RqGj2s/tcnwbBt/NQsLAcbVRDSkmE2hslPmEAtqLouTgigjiglLRkhkr4DFuUKVeq265otjnJGP5qB8C6YxQHmXiZ0aNY4yVqNF8oApXf39U+S4LBTYHD6TMV4NGtVStZj9laHgaZSQPW1JKKx4YNyYMRSl1eYu63AWgWdY1Q0J93yXd2psgpPerkOhtBWctt4bXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.30; Wed, 16 Apr
 2025 03:12:43 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%5]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 03:12:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Wu, Binbin" <binbin.wu@intel.com>
Subject: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
Thread-Topic: Drop "KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall"
Thread-Index: AQHbrn1r/RS1njTk+UWrxwhSHT7GDA==
Date: Wed, 16 Apr 2025 03:12:42 +0000
Message-ID: <da3e2f6bdc67b1b02d99a6b57ffc9df48a0f4743.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|PH7PR11MB6793:EE_
x-ms-office365-filtering-correlation-id: 17c94e96-25ce-47d5-d66c-08dd7c948d87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T0VxbHA5bG5iWlp0SFZnNXZRWFh1bHJUNm1vSmZ5YndvTGNjc2NjS3RnM3Jq?=
 =?utf-8?B?ZnB2RXF5dEx6U0l2UmJEV3ZUZjVYL1EyYUh2MmN1d2RVZElhcEdzZWRJWkNl?=
 =?utf-8?B?ZjUxS216aXVWelVXQ2lybHkwaCtJVVBjeS83aFRabGM3aVFWbzk5dnFhdUdU?=
 =?utf-8?B?ckdTZy9hKzZ3YnhEU1hibmdJZWtrRkVPckRXWWE1V1V5TkNJUVV5M1lzckY5?=
 =?utf-8?B?aXRuQjEzYjJzRFBTL093M1FCeTRJVVVMdGdOT2lDek4rWHhFRzlHbTJBRHJG?=
 =?utf-8?B?U1ZyMTdJeE8ycFVDT2w1KzNacVF3blRSTXRSMTZ2bEplSVVWeUhFblhrYmZZ?=
 =?utf-8?B?WVhjLzlQRkUvTS8zN3JGNjFRd1JNblRlTVEyUVZpZFFkOW1JenRoOUk3NWR4?=
 =?utf-8?B?ZE1OTGJUN0JWVXpWUWowZGF6akhtVEpaMkFSQytwOEo3S2RlTWVaaC9uUXdn?=
 =?utf-8?B?M1VORGxEMFZBdzZkdGxEUS9rMjhoQkNQTkE4WWwwc21ZNXVLSm9oMUVWZnhF?=
 =?utf-8?B?SDJSQ3FGa0pxQjlyWHVnY3d3UERJMzNKV0NyYmdmV2JlcFZxR09TSXBNVXBh?=
 =?utf-8?B?dmVyMk9sOWZNZU13ZGN4WE13bXFHangycWpjUkpsNGZoU3pRWE0zbGdpZ0pV?=
 =?utf-8?B?V01neHk5andESkNrT3NzNktvcGQyRkp5Rm5qMHpTNHlJS2ZUWUkwNnZQaFpQ?=
 =?utf-8?B?ZHNSSkVvdTFqTHRLZ2NXTnUrOEszTGJkdER3Skh3YkcyWXVYRENtbzBjVWVI?=
 =?utf-8?B?SHdtWE5JcXhqV21OZVN0YXBqZFZlUU5tay9PZTIxZVdnNTJqUkgybVduU25D?=
 =?utf-8?B?Y3FvYklrRlExc25LUnNtOHR3N2VoWWZHb2ZOdzBtc1JsMDA0TUNnSGRYcmpl?=
 =?utf-8?B?aFJkRERhZVUzbnFrblNJQlh3Q3FGNTUzWEFUVG00a28wdGw1MzVMZlpaVDZX?=
 =?utf-8?B?bkpsVkR5TTh1eUNkeVBtZnEwQzhlZE5lS0R5anEwRFNUQlY4N2hZVTFKQjQr?=
 =?utf-8?B?ZVNidEpNd2o5TXRZYkRuVk5PVXphbFNlSUtLMWdpVmdOMVZoOFU3djRhbjdr?=
 =?utf-8?B?eHplL2lvUW5jUnlPYnJUU2I5TVgzZFhLVzQ5YnQ2b01TWVlUdmgxQys5OGRF?=
 =?utf-8?B?aURpTWRYZHVnd280K2JDYmhYREpCeEZ5L3ZHOFkycGJDdTB0OU5GbmpNbkhn?=
 =?utf-8?B?ZmZsc3puSGE5U2tKeGhUcTRZczl2QThaWHBKYU1JVUdQa1V6QWpZWWVhUTBO?=
 =?utf-8?B?NGhYT0ZTRVBGRnVYeFk0Z1VtOHhuQ2xyL0d2Z3pKZDd4cFhIWjhFbms5bUdl?=
 =?utf-8?B?OGh2YzdSMmZJTVVlMHFleUxGaTVMdUtRZUFOUWhjY1ZDZ2J2cEVDcjdQMnEz?=
 =?utf-8?B?NFNYc3hPTW8rRXY1cmhkQ3dsdTBPVVltaE43WDRXNVpIVlYrL3ViS1d1bzE4?=
 =?utf-8?B?d0dibVg2U3hqUTJueU1uVVFlRUgrQmpjNFNISnZNV1M4QkFnSzBYWDUvMVF4?=
 =?utf-8?B?TWpJeTkwRFE1Y09VQkk3ZlBQZENVdTJRekRkUVpxcXJOSFlZWmdocHBIMmIr?=
 =?utf-8?B?ZkNFQjE3V3BFRjlRRm0wSms2MXFkNzlxTmFWbXhkdGRaUXpEdXVhVElnWUJZ?=
 =?utf-8?B?MlY0cExqK2FqQUdxVk5rWEtZWHFLb3k5MS8vZkZMN1lGbzRFRFYrZlBZenR2?=
 =?utf-8?B?a2kwbnFRYjlveWpOai92SnNKN2FVbjkzTy91TXdYajhybC8vWWJJWmpRVGp4?=
 =?utf-8?B?WWowT3d1Ny9ROU5rd1Vlc21tZDVuZ2Eyb0xNS2RuRzloZlNFUW9kVktEZnYx?=
 =?utf-8?B?SlhUMjFYWWNVOUM2c1oyRGNxbWxxVHcvNWpqemhLY00vbXVHK0h4LzBnalgx?=
 =?utf-8?B?bkRlNnUwQi9YdDE1bXo2UU12V1dJdGZRVWtpUnA4TVdHVDhVRE5yTmY4VnpT?=
 =?utf-8?B?bVJZWktUN3B5ZTEyakFRaDB2ZmdWM2dGQk9iQnB6TTlqWmZscGloMVJpUHNu?=
 =?utf-8?Q?d9We2wEgwXsuU00IQX1NDaFdi8p1ic=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUFtakNibjVrWjlvM3VxYnBRQktFSWJzZExTekxFdzVMQ2hTTHpyTmtsMkY5?=
 =?utf-8?B?MUZna3p3NFdXYUJ2Y1FGUVZUUmFrYkFGUndENFYvaDZ1dGRwTVh6bWFtOXBF?=
 =?utf-8?B?VndBM2ZwMk5HYm13aXNxYk9qcTdtM1pMWDRTeU83ZkIxSTNIMmcrYWpnaFlU?=
 =?utf-8?B?N3dDN1JKWUlQUFFISlhYVEk2ZG92NjNIcEc0V2l6TEdwNnRTSGlBTGpSLzBw?=
 =?utf-8?B?N08rRHNuNWx1UnVxSXJzRThoYkpiQVNsTm9PZTZPeEVHVnN4Y1FBT05hTkto?=
 =?utf-8?B?R2V4b0hZejQwaU0rbTJtYXVFTkVsQWhydzBPQVp6N1RKbEwvZ0w0RjFQbWlW?=
 =?utf-8?B?ZmtZcXVvV0RoQ1hTRE5hQjM3Z0pkL0VQcnpHYiswcmVuUmlQKzRpeDR3ZG9r?=
 =?utf-8?B?U0kveVhzN1hiTXVCK0hQbFVvNEdCdExkSWNsS01SbTRVcUhFK1dncnMzZ3pH?=
 =?utf-8?B?ejRqRjh0UXlNZS9iZFhhWHBObTZIMkNTaDVSaVRhaXlHdU5NVytZVkZWcHp0?=
 =?utf-8?B?eStoUVZCZVRRSm5Ma0pBRCt3ZldWUU9mVmo3eVU2cjhEbVN1NGEzNGQ3dlVj?=
 =?utf-8?B?UjJBSlNOeTFmOGlQbHdoU012Q0FtNC9vQXA4cFA1SkNvZ0V2RDhzMXNvSE5r?=
 =?utf-8?B?ajk1YXdlcE1IU00wMnl6dWhGSmhKd3o5MG0vMmJGU3VoR3ExWEtLTG8rdGE0?=
 =?utf-8?B?Um5Pa2tFa2p0U0haaTB1VVYzMFVkazBFbmlId3JNcXZqY0c1RTFCMXJjK2FB?=
 =?utf-8?B?K2xmMUxCa3Z1SXR6QzJjSlA3WlhSQUt4eFhzOXNTT3JFS3FDM1BQeGg5cDl4?=
 =?utf-8?B?MFlMQmhoMXNmeVdyK0ZYc0VlMVltWTJUcTFnTUxndjdvcUxycmlvRnlPZWI3?=
 =?utf-8?B?WU9qMERJamg1K1RzbUxuZWtaRXhsYnR1SDBpcGJGWm1UY0xCbCtsMTQ2UXpy?=
 =?utf-8?B?djlUWitGRnI3cmtRMkN3T0Uvcjl1dlFKTC8vS2swcTVUd1B6Zk4wNjUydkl1?=
 =?utf-8?B?RGxBN0NmeDE1cHp0blQxVjRVN09pVW5lckhtcmNDdzliV24yVjFCV0M5Qnhj?=
 =?utf-8?B?MDIveHBnWEwrbldPbU1MVlVYdzFZOVhhNVlNcDRrZEI4eW9wbnltOEUrZlVt?=
 =?utf-8?B?ZEpPWmRCTi9pNXBGREhkR09mcEVZQ1J1aXJDcWtDS2lhemRoZXQ2QUtzbmpv?=
 =?utf-8?B?QzFJcnBLYml1cDhOQWcvSVFsLzFDOGFvclZrN1pxOCs1amdTR0pDQ2U0U3Vi?=
 =?utf-8?B?Ni8zdVFQbDdOT0FqRzZ0NVJDckVFbDd5SnJLUGZVWEFmVFZMcWsvMmlSMEhX?=
 =?utf-8?B?YVNZMVc2aW44aXdFOTRMMy90ZWRmN3FITVdiaDViN2tXbXlkaXZvaWVVWTIw?=
 =?utf-8?B?R2tqUDd2OGRoSmcrVkgydUxjeXAvMjdXQXUyUHErVmcwa1RiODNBcWc2Wlh2?=
 =?utf-8?B?Qkp0alRMNExGNFFxYzY3c1Ftc0RJZHV0UE5oOUt5bi9hRm9oN2Z0d3hyOVIv?=
 =?utf-8?B?YkkrYjk0clo0UkVLb1BqWHRuMnNqV3p0MTJjRTBWVW05eFVjd3lFczE5ZVBx?=
 =?utf-8?B?YWRTeVlMRFBIL3RoTkprNWMrRHc4eXlsdXh3TmhwdTdUQWo4d1lnZ2lWVGJR?=
 =?utf-8?B?cHIveGxEN0ZKYXZGUWxJMGJHWGJQYVMzKytvazFpakhVam1IQ1dqeFZZR1pJ?=
 =?utf-8?B?eTJsd3FSQktUcUFrOVRtZlRVMU5iaVNvQW80TWhuWnhRbmhnZG5IWnVoRGpI?=
 =?utf-8?B?VGtFYlhVWEVic1ZOay96RFdZdmxzSytnTlFGNmFDUDlOOUduRzNxeGpCcDRj?=
 =?utf-8?B?d0R1OFJyNjFRem9jLzFvZVlGOFFwanlUVjdKY3dRY1NlZWdxUU1QMzUvZlln?=
 =?utf-8?B?QjRNUGVjN3JOMmluMVNXTnQxSVFOYU93THh5RDdQcUdNVnl6U1M5ZkxGSnIr?=
 =?utf-8?B?QUVKOXdIK3NSSExCSUNTcWtJZzgyQzZwUFRDTnB6akhuak5oZWc4SVhFbUtZ?=
 =?utf-8?B?dU5rRVRsYkhIY043cjh1S2d6Q1B1Vmd0N0JIK2ttK0NxNVRJS2tBcXVIQ0E1?=
 =?utf-8?B?QitVL0lxelB2Y0k0S1FlYTZOdXdMblUzZ2dnZ3pYYkpXdmR2VXVpUklCOHhL?=
 =?utf-8?B?cjFFdCtUcmd0OGw2STVTdVZlZ1NlbnJWcG9GNjAzcThvS1YrZ3pnZWYxNmhE?=
 =?utf-8?B?L3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17219CDAED4D4340A0525A0A5A44193E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c94e96-25ce-47d5-d66c-08dd7c948d87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2025 03:12:42.7889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 33s/jVfQeaoVhRIZsr9Juu1GaW31Ns2ldJH7ce9vqbJsQ3UWmgraUqt2hkj657ykUlF3gEyyZTPnyonCypRu98u+H/tIw/gUw58Y2pGF1OY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com

SGksDQoNCldlIHNob3VsZCBjb25zaWRlciBkcm9wcGluZy9yZXZlcnRpbmcgIktWTTogVERYOiBI
YW5kbGUNClRERy5WUC5WTUNBTEw8R2V0VGRWbUNhbGxJbmZvPiBoeXBlcmNhbGwiIGZyb20gdGhl
IGJhc2UgVERYIG1lcmdlLiBUaGUgcmVhc29uIGlzDQpiZWNhdXNlIFhpYW95YW8gbm90aWNlZCB0
aGF0IHRoZSBHSENJIHNwZWNbMF0gaW1wbGllcyB0aGF0IEtWTSBzaG91bGQgb25seQ0KcmV0dXJu
IHN1Y2Nlc3MgZm9yIHRoYXQgVERWTUNBTEwgaWYgKmFsbCogVERWTUNBTExzIGFyZSBzdXBwb3J0
ZWQsIGJ1dCBLVk0gZG9lcw0KdGhhdCBkZXNwaXRlIHNraXBwaW5nIGltcGxlbWVudGluZyBhIGZl
dy4gT24gaW52ZXN0aWdhdGlvbiB0aGVyZSBhcmUgYWxzbyBubw0KdXNlcnMgZXhjZXB0IGl0cyBz
ZWxmdGVzdFsxXSwgYW5kIHRoZSBzcGVjIGlzIGFtYmlndW91cyBvbiB0aGUgcmlnaHQgd2F5IHRv
DQpoYW5kbGUgdGhlIGNhc2UgaW4gcXVlc3Rpb24uDQoNClRoZSBzcGVjIHRhbGtzIGFib3V0IFZN
TXMgbm90IHN1cHBvcnRpbmcgYWxsIFREVk1DQUxMcywgYnV0IGRvZXNuJ3Qgc2F5IGhvdyB0bw0K
ZW51bWVyYXRlIHRoaXMgKGkuZS4gaXQgZG9lc24ndCBzYXlzIHdoYXQgdGhlIEdldFRkVm1DYWxs
SW5mbyBWTU1zIHNob3VsZCBkbw0KaW5zdGVhZCBvZiBzdWNjZWVkKS4gSXQgYWN0dWFsbHkgZG9l
c24ndCBjb3ZlciBob3cgdG8gaGFuZGxlIGlmIHRoZSBndWVzdCBjYWxscw0KYW4gdW5zdXBwb3J0
ZWQgVERWTUNBTEwgZWl0aGVyLiBIaXN0b3JpY2FsbHksIEtWTSBwYXRjaGVzIGhhdmUgcmV0dXJu
ZWQNClREVk1DQUxMX1NUQVRVU19JTlZBTElEX09QRVJBTkQgZm9yIGFueSB1bmtub3duIFREVk1D
QUxMLCBhcyBhIHJlYXNvbmFibGUNCmludGVycHJldGF0aW9uIG9mIHRoZSBhbWJpZ3VvdXMgc3Bl
Yy4gU28gdGhlIHNwZWMgbmVlZHMgdG8gZ2V0IGNsYXJpZmllZCBpbiB0aGlzDQp3aG9sZSBhcmVh
Lg0KDQpTaW5jZSB0aGVyZSBhcmUgbm8gcmVhbCBjYWxsZXJzIGxldCdzIGp1c3QgZHJvcCBHZXRU
ZFZtQ2FsbEluZm8gZm9yIG5vdy4gV2UgY2FuDQphZGQgaXQgYmFjayB3aGVuIHRoZSBHSENJIGZv
bGtzIGFtZW5kIHRoZSBzcGVjIHRvIGNsb3NlIHRoZSBhbWJpZ3VpdGllcy4gQXMgYQ0KYm9udXMg
d2UgY2FuIHNhdmUgc29tZSBjb2RlIGZvciB0aGUgbWVyZ2UuDQoNCldlIGRyb3BwZWQgdGhlIHBh
dGNoIGludGVybmFsbHkgYW5kIGRpZCBzb21lIHRlc3RpbmcuIEFsc28sIEJpbmJpbiBhbmQgSQ0K
c2VhcmNoZWQgdGhlIGd1ZXN0IGNvZGUgZm9yIGFueSByYXJlIGNhbGxlcnMuIEV2ZXJ5dGhpbmcg
c2VlbXMgZmluZSB0byBkcm9wIGl0Lg0KDQpJZiB3ZSB3YW50IHRvIGxlYXZlIGl0IGluLCBpdCdz
IHByb2JhYmx5IG5vdCBhIGRpc2FzdGVyLiBXZSdsbCBqdXN0IHNsaWdodGx5DQpkaXZlcmdlIGZy
b20gdGhlIHNwZWMuIEl0IG1heSBub3QgYmUgYSBwcm9ibGVtIGRlcGVuZGluZyBvbiBob3cgdGhl
IGFtYmlndWl0eQ0KcmVzb2x2ZXMgaW4gZnV0dXJlIHNwZWMgdXBkYXRlcy4NCg0KVGhhbmtzLA0K
DQpSaWNrDQoNClswXQ0KaHR0cHM6Ly93d3cuaW50ZWwuY29tL2NvbnRlbnQvd3d3L3VzL2VuL2Nv
bnRlbnQtZGV0YWlscy83MjY3OTAvZ3Vlc3QtaG9zdC1jb21tdW5pY2F0aW9uLWludGVyZmFjZS1n
aGNpLWZvci1pbnRlbC10cnVzdC1kb21haW4tZXh0ZW5zaW9ucy1pbnRlbC10ZHguaHRtbA0KWzFd
DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNTA0MTQyMTQ4MDEuMjY5MzI5NC0xNC1z
YWdpc0Bnb29nbGUuY29tLw0K

