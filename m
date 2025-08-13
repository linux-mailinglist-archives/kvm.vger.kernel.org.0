Return-Path: <kvm+bounces-54585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32A7BB24866
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 13:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36F06171015
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B622F6582;
	Wed, 13 Aug 2025 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjjthHdK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1304E2DA760;
	Wed, 13 Aug 2025 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755084166; cv=fail; b=AAgOas1dSa3MIvigVwIvIxyzjORdjkILfsfx+e+rTK+pVKXOlre60ay+d+kHiOR984V7MKJlSISjaOPN9jPlcC/rlGgbQ5mE0Zm/saN54ZL+YU0pR7gPAsMrl+ChHlVlYLb+wlyH4vYVzcTnPwl/C0f/b7/2vwOsUWZcthonkVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755084166; c=relaxed/simple;
	bh=TkYcVx+ybpF1dxBjO/9Abnew1RyCClMNRGqYPJHpgZs=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KMEj+zA5V22MHXPILSjtzH3yWZedewyxawyI/aXnC4Pq8K9iGFHBse0ZdUH/MtFg503bMeidbyzWn0RiGXgg81Efpov2j3razL63DyI/U+DPyBJGizsXRrnVWbLLf14b5E8ZhBSp2USyVyKzhYtInIk2rtqRXwiP6XPoNh6oxZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QjjthHdK; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755084165; x=1786620165;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=TkYcVx+ybpF1dxBjO/9Abnew1RyCClMNRGqYPJHpgZs=;
  b=QjjthHdKUvzjyUGv9apXduQsAOe0D0S1USuxCV9qg1lRd4/usJGZ++kN
   OnUHQ+qmsDfdu1thIZV2KMuxbwfU6cmfh80xkr5WHbKMHT9L9+zlkCwRn
   92zTb44AR2KtIapV8gvyzCAJHnGMnSv48VJ/5FHAPwiIFo6SVVrAgT/PW
   xh7S+tWh0RSfU/efBeAIpyqnaL6BhcScI5ZJRnMn4OT7h8GD8VwTo2D0t
   QJyzWBZpjUzwch34jFcSmRhJteV+LjUYtWlw3hHmMZ9BzdNf5B5s6eYoa
   +pCmag8pJ41gdIFZDLKqOZ5yKyjRbJyaxMloan87QUdnqCJ8f0uKtI+85
   g==;
X-CSE-ConnectionGUID: c4U8sy/1RrKaDCKaK94vMw==
X-CSE-MsgGUID: 9UdOnYlkTnWOfzmuDoFceg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="74952218"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="74952218"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:22:44 -0700
X-CSE-ConnectionGUID: LdxtFXTyS0GeoBVUaoez0Q==
X-CSE-MsgGUID: nXXyHC/+T+ydPih/iDhg2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166819638"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 04:22:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 04:22:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 04:22:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.75) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 04:22:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b1NLoMaWeLN1QCoE/oM2XNh5uHAwdc4hBv3Zr+h0Qzw4QUQ15tDnmv9faYwrGQEbwE7o1w2J4uWNuzMkT7Ag561RZebSPqm0rRjKm1QLpp2Gu/Cf42SKu9kJHKwO2wRmAXNMrrQ5W8mFywXzC/SEqgpKTXe0TWrszCguv9wjlN84VL58KaGfo8jtt2+Fr4eP1hohHGHWt8sYym3TYgecWUKQ2qYCSkazu7mrzYs/Oron2o5Wd/Mczx8l2LcDzqVi+x5n/pOeK82P/+7P+x9qt+IbRhxw7gAjcQyIDDKjjHIc4JWg85bx2rUGaSR7yrdvNEDmS6nLMtTuZ12GrX1pVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkYcVx+ybpF1dxBjO/9Abnew1RyCClMNRGqYPJHpgZs=;
 b=DAEEZwW783+Kv0XCtb/v2h6QARWWfx991bIxGbIrIn6dFRCjmqbz2icUT5NCg2mQ2IKLUwWPZJQb0igy6ZlmdfJf4Pt5oe75mtFBNwKMWqeGpC/hv7F10zBNOu7DKjhHgktfWx5pNiCtrz8NoyR/RWLWeF6JAAvF44k9QXG0/iaH75Mjz806deXk2V9s8NeM8ciQGRA++aHLMfOWNAtSUEldveXNuxXsC+vHJ+pqnRytn13djbI7yi0W9xV+cvmee3xWl08yIwAICx9NyW5gUUiv2szsylB1rWZyEydfAD+jhnqcanBj31YNu/2g35rvf3E3gu9GtpYnGN4Aicptbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB4789.namprd11.prod.outlook.com (2603:10b6:510:38::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 11:22:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 11:22:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "rongqianfeng@vivo.com" <rongqianfeng@vivo.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: TDX: Remove redundant __GFP_ZERO
Thread-Topic: [PATCH] KVM: TDX: Remove redundant __GFP_ZERO
Thread-Index: AQHcCDiCnYae2x4/ZkmoyVT4pc7gY7RgeLUA
Date: Wed, 13 Aug 2025 11:22:41 +0000
Message-ID: <853938f48aaf9dc693b1a006ab49ae517fb44e16.camel@intel.com>
References: <20250808074532.215098-1-rongqianfeng@vivo.com>
In-Reply-To: <20250808074532.215098-1-rongqianfeng@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB4789:EE_
x-ms-office365-filtering-correlation-id: 678a1240-d432-43c1-ee1f-08ddda5bb7e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?S0MvTFNsNUVaZmV0WEhsd1doRDhERS93dmhJbkRrbVRaYnBwRS9SUmNWNGFK?=
 =?utf-8?B?c1JWRG1iNEFaT2J5dkZYMS9qMG5YS1B4TkZhMkxCV2w5RCtBdTBDOVdYZEJG?=
 =?utf-8?B?eUpnRkYwVjdQbTk1N1pINzBwTEs4a0JjWnUvdUx1Q0RoRGZXaWZ3M0NkQjZE?=
 =?utf-8?B?cUNVeXVhS1gyWTNlQU54Q0dUb0Nja1R0c3YxRU15Mi9kd0Y1bW9OekdQVHZs?=
 =?utf-8?B?cC94R1ZyTEJZR3ZSZEtSNFVzSEE3d0xiS3Zxb0Y3WmpIQWlnNDkyZFJaWG9z?=
 =?utf-8?B?MUlWclN3TmtlMGNSRWtETE1LSXdRWGdMUzVQZVcrK1pVdXdNSGlWQXcvTnBY?=
 =?utf-8?B?NnJSRHdtMWlyQTk3TTVaZnlSaWdxaytNVGZWTW0zczR3WDZUUExDUUdPTkZL?=
 =?utf-8?B?Rmo2bFkwWjJtZFB4S1prOC9OM21UNW03amtJK1lnQml6S2QvZG9KalZIYUJT?=
 =?utf-8?B?NW1Id3VuU3Q1U0drV0JHTGNTeHJ1UStybGcranJFQ1laSU9QVlI0NEYzelJm?=
 =?utf-8?B?TS9mcGlLRzdDQ25oaHo5ZVgvTXBOYUM1R2orK2RuaGZvQ2FyaDhzZmZyaW1k?=
 =?utf-8?B?dUJGZVNXTzR6MFJuSmx4allmUEFmWHhjYmxTalRXVDJodDJIQng1U1hXajdY?=
 =?utf-8?B?N2R4bWc4a0NXMVg3STA0R1BVTUd4eU5YNzZ2ZFpZZ0xXeXhwTVYwNHFucHc0?=
 =?utf-8?B?TDA1K2xlYkU4VHUwVHo5RzZVcnU4NjEreGFxaFNYL204aVRiSWxNMTFUVkxC?=
 =?utf-8?B?RFZ3VTVXd00xQ1dzMW9GSUd6ektmbFJOc2NGeFo2Mk1lNjVoaWNVM2gvN1Vj?=
 =?utf-8?B?RGp0aHpIU0ZydGJnQVJ0bnZJN0RSQWRvNUFKbTI0RURGVS85RGo3M2wzamFk?=
 =?utf-8?B?ODgxcUlscUVLaUNpd2lnWkdZZEl1aXBHRy9TaEpoVHNUWXU1bFJJVHRQVW5V?=
 =?utf-8?B?S0RrTXZ2ejBYMDBxUDVKMlBvclhNdjhocGF1YVBwQXM2am1uMHhSclI2V2k1?=
 =?utf-8?B?c0FkcnhMQVgyNDNKZmVVTzVLeHFFSk1Ed3FaNDBuNWFXTFVvcjU3Z2Z4QS9p?=
 =?utf-8?B?U2ozTFdkcUNXV0UzQ2N4Umg2T3QzOU1MUGtnSk9SZG9ZK0U5bjFWNzJWVk53?=
 =?utf-8?B?YUljcGN0VVhJR3VHVy9ZeXFkTEl6Q2VRblhXK2VDWVI3VmxwZGtWeGthS2tF?=
 =?utf-8?B?MkJBN2sxTmF1a2hiWnRQU0pyYW51akY5dGU3OWYxcFhya1l5Q3dLSGsyN1pz?=
 =?utf-8?B?OE9UTmNtR0xuOHNRMFg4bVpkQUtQVGdNKytQK3R6ejIyWWNuYmY5aGp2N2tR?=
 =?utf-8?B?anJJTXNMWk5oTWF4emZ6Ri9qazhDemI5ZXVRZ1M2LzB4MjNCVFpmaVh6TTlF?=
 =?utf-8?B?bVBCV2JJOTl3U0cvNHl0NHA1WllhL2xta0NqeEhRaHozWDVLNGJvdThIVDRU?=
 =?utf-8?B?TVV3MFFPTzBzdzEzVWYwR0Vod2IyTDh1bjd5aGYxUk82eFl5TzZYYncrSjZ1?=
 =?utf-8?B?Wlg1dUpjOVhld3VkMHpabWpMbzJDQ1I0S3ZMZk44L0dsWTFNV21PMTBxeHJn?=
 =?utf-8?B?SDB6bFZYRTdrNnlxRG9JYUxwTDY1MlhCdXdzQm5OWUN1dG91dlMxVWpoMzNU?=
 =?utf-8?B?R2tsZ1hIemo5T0ZSMW1JaHFLVDRWWHBGWW95dTI3Z0dnK1BqdCtyM2JMN2xz?=
 =?utf-8?B?QXZBdmVZMzhSSEx2ajg5SC9GRnRxSHlvakEvUzNTZVB6Y2JFTnovSlYxa3NH?=
 =?utf-8?B?ZzBtOHFRMzNVRGU4a0swdVpKeXFhYkpCRU5LY0ZqTE9oYkVQSDJMYzdaS3Jz?=
 =?utf-8?B?dWJ1UEFoeWs3NkJ6L2FDSFVQcnJya3VuYStqZkkwclJwaTdSb3U4S2FZc0du?=
 =?utf-8?B?Z1BBVk1JNVgyN2xSRDVTTGFBZXZFVWNwLzVSb1BZc2RwWEdPbmU0STFFYjVT?=
 =?utf-8?B?V1JaUzIwOGFlZ1piWUFBMXAzSVh2RzdDZ2l2Yi9pNnFDT2RMd2s1bW1zcHow?=
 =?utf-8?Q?sVI9n9iMkmTHneVmLkmSOmkpF3SqEo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YldSY29RSmluTlViSzJNK0dwYmlEQnBGdHhKR2dIdks4RjRvOVZRS210WVQr?=
 =?utf-8?B?ZnJnbDFVMlZMaUNmdVBzY2xKUmEzUU1kWXo3QjBMSVRNOHM0Ky9nR0F5T1JE?=
 =?utf-8?B?Qll5QVBqVmI2M1F3MzJrQ09mUklGT0hid0Y3UXRnbDNUVm5jMERDd3NBQXdS?=
 =?utf-8?B?dkFhSWVOK3dCTFpQMHlSd0xDSjJnSU5TWXFJVUk2L0ZxcVBsY2IxWCtVTFVz?=
 =?utf-8?B?aytQdVVvKzBVbzRTWFVkMEZILzZWWkk0dFJpQ3hpcWhaSTlWZkNMcVN6WjBP?=
 =?utf-8?B?THRaR0p2WVp2dS9pckltTStpTzluMFNPcm1CMnhHbWFjZjBUZCtINzlzYmt1?=
 =?utf-8?B?ZlJGMnFyRU9TYVprU2ZYME9vbERHbHNSM1h3dEgzZUpOODZDTmwvRHU0bkg5?=
 =?utf-8?B?MXRUZGo5blFSR3FFREEva2h6c2hqS3FLbEpHK3BUSWZWSys1NnF6QzhFMjRs?=
 =?utf-8?B?eXFZajJDVCsrRmozVHI2VHFPUGdhN2xkN1BTSnJQV2xndDlaTDZUdkRiVHBr?=
 =?utf-8?B?MEJQdjVSUXVPd0NEc3NGUitYN3dXZjhRTHlwVjFFQXUwcndObXpuQkwzeTJC?=
 =?utf-8?B?L2l0Tit0aE13d2ZJbk5SbTV3QVl0ai9uUlJZa2RiZ0N6UjFnbWFTSXB2ZkdT?=
 =?utf-8?B?VzJwSFBmTXJQcFVDb2t3ZXk0Y1Y4UW1YQkgxMWg0OWdQckswbDU1elZOcXlC?=
 =?utf-8?B?aTNpSFYrS1pSK0lFL1lmbkFoMzdVdnFxZkxWbVlMSzljQTR2dHVqcHZWa2RB?=
 =?utf-8?B?N2IvM3hvTEc4NUN6c3BJdlNZV2s4V0tZWEl5eElRL2JkN0dLeEFVSFZGdHg4?=
 =?utf-8?B?UWxHQlZDTjRRdUJMT25SVHF2QWZjY2tzZnEyQUtqQzNuZzg4RXUzSHBwUXND?=
 =?utf-8?B?ZmJzQXRmcWxOdEdGeTV0dmQ5L0ZBNnRlUEF3cUZ0YllCS1NVckl6dlVkSDcz?=
 =?utf-8?B?dU5LWmVMOGJmeEwwVmZqSkVzNnQyVW1hMjkyMVo4SXM3OW5IeXVaaXQzN3c2?=
 =?utf-8?B?cEhCYmVqVnppN0VyMGNuMVhVeG1hM2d1WjlmOWdGUzRGdTArdUZ6OFNPYi8x?=
 =?utf-8?B?eXRHd1dFNDIvaFNreEZnUDFXOGdKbTlHTlhuVVlrU2JCOWN5R3d3aU9sdzhJ?=
 =?utf-8?B?WGw2M3AvVldySm9XSGlxVnBia2p2enBnZkM1a0F4cE00K2VQNjYvbHZzR0dq?=
 =?utf-8?B?d3hWejBtYVVCM0pHWW1saDl4VDJHcXc3RUZMUGo3WW0rTkpJSTNjVWE4Rit5?=
 =?utf-8?B?bUozZ1ZPUnhmS3pwK3pENDAvSW9taW1HRGRaM21XUFU4WmU4MC90Y2hRSDZh?=
 =?utf-8?B?NlgvamtlTVlPb1phcG9GbzJPekFMNytyTEhzUG9panZtUGN4b0YzaGF0ME1u?=
 =?utf-8?B?RDk2MnNTNEt4VEZnaFVWcm9WeVlwNlcvdDZLdWZ0OE5XMkYwTmgxVlQ4MHQx?=
 =?utf-8?B?RTMrcERVdkY5dER0SHc3am1IMTE1SlUxNmhnbllXMnBlNnh2c3UrYUhEbjVP?=
 =?utf-8?B?MWoxaVJYUG53dEs5RVcyUkdMWmxGVWErQlYxamxqdzFDZFIxcTgrNmdNTE9K?=
 =?utf-8?B?TDhCS3ZrSmR0T1RsRWNIMjFOL3lIWlFuRXVFSWM0bHhpNTAwejkyVU5ZSDFD?=
 =?utf-8?B?M0tJRVpZZ2pnazg1TnhwbVlTc1ZaVWpTQjlWYXR1U05yTlFyU29SK29lSC9O?=
 =?utf-8?B?OGpnV1FNTEFEUTBxMSsrbDc2a2dQUjdKSHNGdXVQNGlpQ3hGbU9iMTV1RmU4?=
 =?utf-8?B?bU14dmlMVFZLNWFtL2tXM3RFbE1Oa0UwdzVVQU9UZDZrZndYWG91bHlDOGlv?=
 =?utf-8?B?eGxtdG05NmRmZFVmcGY1cTRZaUxvekpwNFZNMjFVUHVVYnU3eHVKbUVDNTh5?=
 =?utf-8?B?Rnh6THo0UG9rN3dId3F6N3dZLzhOOE5xR2NHYnF4V1dud3dqWmtodHY5YVZi?=
 =?utf-8?B?VnlaUkpBK0xUeVovUHpORGV5SHpjdWFWRCtraTdkZHJ5akJFaElkRTlycHo2?=
 =?utf-8?B?RXRhT3VZdjZqbEhlZG83dzYyMEl5ZkRqb2ZWYVgwc0c0Q3NPTXY4aHVMMnly?=
 =?utf-8?B?TklCRGJJdFpIcVVZdnBzbHZhSXprazc3dWU1YnNXMnFFY2NJSFBlRUJ5bU4y?=
 =?utf-8?Q?5NXuDpbhZXYHOMwz+Mh0ihzem?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E36F7E976FBE2B4F8F0440DDB5AEA840@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 678a1240-d432-43c1-ee1f-08ddda5bb7e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2025 11:22:41.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FxOhbRFf1zL6rAqxbKChe+HTFQnCLGI/9wQDu3U3kt97Lr+gcDR07LAshth0LctWSEdjAyie0cnQlf0sPLcyJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4789
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDE1OjQ1ICswODAwLCBRaWFuZmVuZyBSb25nIHdyb3RlOg0K
PiBSZW1vdmUgdGhlIHJlZHVuZGFudCBfX0dGUF9aRVJPIGZsYWcgZnJvbSBrY2FsbG9jKCkgc2lu
Y2Uga2NhbGxvYygpDQo+IGluaGVyZW50bHkgemVyb2VzIG1lbW9yeS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFFpYW5mZW5nIFJvbmcgPHJvbmdxaWFuZmVuZ0B2aXZvLmNvbT4NCj4gLS0tDQo+ICBh
cmNoL3g4Ni9rdm0vdm14L3RkeC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3Zt
eC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggNTczZDZmN2QxNjk0Li5j
NDRjOGYwYTQxOTAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysr
IGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMjQ4Myw3ICsyNDgzLDcgQEAgc3RhdGlj
IGludCBfX3RkeF90ZF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHRkX3BhcmFtcyAqdGRf
cGFyYW1zLA0KPiAgCS8qIFREVlBTID0gVERWUFIoNEsgcGFnZSkgKyBURENYKG11bHRpcGxlIDRL
IHBhZ2VzKSwgLTEgZm9yIFREVlBSLiAqLw0KPiAgCWt2bV90ZHgtPnRkLnRkY3hfbnJfcGFnZXMg
PSB0ZHhfc3lzaW5mby0+dGRfY3RybC50ZHZwc19iYXNlX3NpemUgLyBQQUdFX1NJWkUgLSAxOw0K
PiAgCXRkY3NfcGFnZXMgPSBrY2FsbG9jKGt2bV90ZHgtPnRkLnRkY3NfbnJfcGFnZXMsIHNpemVv
Zigqa3ZtX3RkeC0+dGQudGRjc19wYWdlcyksDQo+IC0JCQkgICAgIEdGUF9LRVJORUwgfCBfX0dG
UF9aRVJPKTsNCj4gKwkJCSAgICAgR0ZQX0tFUk5FTCk7DQo+ICAJaWYgKCF0ZGNzX3BhZ2VzKQ0K
PiAgCQlnb3RvIGZyZWVfdGRyOw0KPiAgDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo=

