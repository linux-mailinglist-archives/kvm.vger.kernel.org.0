Return-Path: <kvm+bounces-71855-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAH5NEUyn2lXZQQAu9opvQ
	(envelope-from <kvm+bounces-71855-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:32:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A02419B981
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9B373008D2C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 207FD3D905D;
	Wed, 25 Feb 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4cR7Ftz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60C22701B8;
	Wed, 25 Feb 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040760; cv=fail; b=T+snZcz9sE3s/qKZ69ZWOKpf9FUaRtJBRoDegwT2qZ3h4hVPBXD/FM5MsJZq3BMhBbUdP9JZ7i06grfCLfu190urPEB8xu/ADqnX94eDnEHxbHn2VvyJ8Qgy74YrpF6NClJz90IdiaU2vX6Q/ON09234U7maq3/sH7K1yvmox+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040760; c=relaxed/simple;
	bh=W4RsjitUsObvyT4lsy7HzkopeSfOIcd8C/0ZiLlovZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LvttDzBozYRCLkoE1NjdivQNxFnWF0kNmEOM37j7XIiMhATk+8jOUmyKCFUHhqVlOnhWo68q/AkLaGaBok9AIiksoBQOvIc0z0Addt2N7q9GrMFLsHpmoARZFWmkw/O4WmSsPUVxGgV/+maXUlq86PpWXIKEWVE6dV/MNNewv7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l4cR7Ftz; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772040759; x=1803576759;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W4RsjitUsObvyT4lsy7HzkopeSfOIcd8C/0ZiLlovZk=;
  b=l4cR7Ftzv71Kmtfhi31wxmkayx36soVjAaZMI4QigyyGdk4wimnKyv+l
   FqWkZywjYSM3+W3D0cf6br5YZGCxgpTqm68Oi9CapMGp/JoyfSd5nrO4n
   Lpatbar6qCcavrNbQgIWfvbPjrmkjOzZXGeVXpKwzQKCG3Cj/1yh3EwPW
   LEWQJWo1EGHDZ2ysaG04rIq0vQpbrtOWuRjcF/aXno83cux2heirlsB/9
   AmBFh4rbwYJqwUOZDW2Rn4BC72zrO649QEymCyA14poOvcuC7Hojl9E37
   sTiO358dzlex4coQ/4+kdqB4mFNkQiNgnH1FA9P60TUOR/DrAWfBOw9LE
   w==;
X-CSE-ConnectionGUID: bhVD3CZEQA2eHep9gtuFBg==
X-CSE-MsgGUID: RxYWbPUvQlaUypw47kKtsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="90500444"
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="90500444"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 09:32:39 -0800
X-CSE-ConnectionGUID: 7+/toTrfTaC5WV677ZlIww==
X-CSE-MsgGUID: g5bFiLYvThKIUWUwWWdtOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,310,1763452800"; 
   d="scan'208";a="215524969"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 09:32:39 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 09:32:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 25 Feb 2026 09:32:37 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 09:32:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXYzQq348BqFtFvgcBUqFrTLf+4AOXdkCwofsqrT55vsXo8AGbGAwkNS8QaBBiMVkuxYwal0qyoQOJhO6f96hi8i6iWdjussomddoF/6Ll3ONQAV/M0R2ILmn0boVdutNUDRJNNztwvsF6O/9A8hgwGQgJHiZR5hErMm7c5Zjv+eUGIR6KJzPd2JBl4QK0h6HBOyrWVZ2N5QCehMeMFfeqQKb+6nGUq3A25fRkCTCRGJSi/RgTKPcItqQaz2mSGuEXpToyzXffv8zpnhXNbFHEibyA7bduqn0aZieQ/7RHVtJ4fN9G3pEaxhTC8mIp67A1E0wgBR7etMbzpskP9jwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4RsjitUsObvyT4lsy7HzkopeSfOIcd8C/0ZiLlovZk=;
 b=mlvtPatXwJbPVmZBZwhJJqfh161tDlkH0T22kmCd64XWn7eakXuXU6y1XPVuT9BrjP1/IULF2HOlbfQVBYpeJeTMOz4Eso0ZMgpcGSGpCiDggPy1kfgsOnjGd43MWlD6NZcLXLsi3p72VvW7kZOnqPs4OanzP4mO9GQtWiN/ts0EyLsA9PLp79Gk3idHuRYN8zdgUmDDn+fybkpPKv4BsZNjj7wpWAmiHOklbkmSn6tRk3J64DDPUJK3npxyjMRmUFXppY91OfJjc/oCtqL/Mg+HvX4RTQIp7V9WBjMBnGhIEQOjh8gI7oVLg1NNUx6CJRogHAd5+gUZ/BGxU8s2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by IA3PR11MB9374.namprd11.prod.outlook.com (2603:10b6:208:581::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 17:32:31 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::893d:78de:7a85:7c8c]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::893d:78de:7a85:7c8c%4]) with mapi id 15.20.9632.010; Wed, 25 Feb 2026
 17:32:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com"
	<zhangjiaji1@huawei.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
Thread-Topic: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
Thread-Index: AQHcpfUGc3v1KRHdhkGJDe4TPYfE/rWTrYOA
Date: Wed, 25 Feb 2026 17:32:30 +0000
Message-ID: <1993dd78bb601516e5e096b205b1137ecb80426e.camel@intel.com>
References: <20260225012049.920665-1-seanjc@google.com>
In-Reply-To: <20260225012049.920665-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|IA3PR11MB9374:EE_
x-ms-office365-filtering-correlation-id: a9427b9a-88fa-46be-2950-08de7493da29
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: n0bwNfV5Fe8FDYxSESifM7UO2jfdup/a6An3KwOOw/gJTkTQvO8aoZ6xCPZjtqs0JkHKBfR5061CO3YqwwCiQSm9hVc0EOb7J7Zu74iu4YWjPdbu8TFG5nbn0+V4nVMqx4o79Kp0R4c74erRRzOTwIg9XIyLjOKn0mTz+Lv9qMCaFFKzb9zE/Bdnp6EOZJVI22KMEZJXq9wcB+WczaKyW6B01Dj1Zrn19N99PkDNXdqKwE8ryH0/fmLEhnlnL7Bu211qfx7vHLYkTvCa/ogW3jrn2Ypu6oJ/StLAQu9OUm/EWteJE9PpInQO7IysxPeygrIKVIoiXiRvt8qQUR+htezO0dkqN3YEkXcWcqDZfpTc4w11BvGZ8p4REYrRUlrWfmG+GLnK5dOcH5emjMT1Vo07XmBVO2dL3rMbLjpePlb7nXhuZx8/vCt8OA3eDcTAp7KNmgZmPqwZQurkCw+Z25cstN9kSmlv+hOLo+nzzbdc4tpiZc0209Os+LW7acZtoMKYQAEoQDdJFYMWfgI3hgUPWxY7NsWUhnWUPoraIJXi5a99LiZiuiavNUIKhGb9OMtugCrmC40602Jy+KZWDDbJEGWtO4f6JXPIcpcBTu15QX7OTBMQFzQ3CP2kskfQzUf9MmvOzygEc0D88PUz56Q5ns4Frb3zpmLaItfH0Ai3aRaL/nKgc+fg4klnYYDIkYzYMNdxDXmGEbL2X1sYHK1JhJaiIGDL0ipJIcPbv/3LFTVfKAXq/xStlpuj1eAJCFNa1mPmvqu6R8AcZGrv44M7RNVvPJPoxzmZvees17Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlg4TDNyUXRsZStVaWFiVnFUUDdCSjFQWk0xVWZBM09jTERFdWpqL0o2dndC?=
 =?utf-8?B?UmFIS0t4b0JKaGk2WGZVVlFpa2xDbUtCYVBxV01CV2gwRTIvMmJKcHVURXcr?=
 =?utf-8?B?RFo4aUpxVURqSW9sTjUxUnBYV2ZSY0s0NDg3dG8wSHc2ZjlLZjc1dnB3NTBF?=
 =?utf-8?B?bWcxY2dIWnVtSGlEK01oMy9QMUJrSjFrK3JKQVFzWms4aEN5SEUvb3hkSnFJ?=
 =?utf-8?B?bFg2OHIzazE4UCtQMUhWRUNRRjlIdlZNL1NCbkZ4NjdZb0UyNmtydHB6cC84?=
 =?utf-8?B?dy9KQTVmeldRc0QxUEZGTEQ4N3lTSEFaN3h6blhqOUlZSm1XRWErMVB1b2xW?=
 =?utf-8?B?WnhQSm9lRkdoWWh1Z3dBall2d1NUUXZlWk92SkRQbGFINDJ6QmV1Qit5QldQ?=
 =?utf-8?B?NnBYQ0djZnVEdGhMcHNXR25LWWxJOG9nMVFGMjFZR1FCUTVOVkx2Yzg4bFBv?=
 =?utf-8?B?VEYwVGlGalh1UHBISFhNdHFMUG9DNU9RVkIzRDJHZkpRVTBFR0JvSmJNTEdC?=
 =?utf-8?B?VHBZR3N4YVRlYkY0TTJkZDdZOFhCcTMvRUxubWtmSzhoOHBPTnZBOThrR0tS?=
 =?utf-8?B?UEN5Q1dudWhwNTZvSkc2eHRxTGNnRTRkS3pIbWcvbzk2b1JYQlFPdXN6THRP?=
 =?utf-8?B?SHpadXZSaERyUUlyV2tDZS9HSUhaMTN0TE9MdmpoVnRiR25CZzIwVU4xajRv?=
 =?utf-8?B?UytacHllMW1ZbXJWRHV4Y0NuWG94OWRIK1NaVWlzanBTRnp3bUlOa0ZWZlVI?=
 =?utf-8?B?WDVlZUxSVWQwZTNHZUIxU25YTklqVUJhS3J2VWtzRDgvdXhraHcrZy93dFp0?=
 =?utf-8?B?K3VEcng2aEVTQVFjN0d5WXdEV0dQcU15Und2NXhidVZiUHNEKzBGR3lGdTNB?=
 =?utf-8?B?Q2NIVUFUbTlUVXMrRmc5eTc3a1M3SjBWNktyRlY5VmNiWHZ6TFA3dDU2cWtZ?=
 =?utf-8?B?eHFyY0lDY3NDZmdmVTAyU2kwdGdjcmpYT2IyTGdWWEFGZzYzS3AxVnZkdGxR?=
 =?utf-8?B?QjF2WTRVb3ZISHQzVXA2aWlRNUVhd3EvWlJQdTF4dVpFemhFU1N4K3FPRk9P?=
 =?utf-8?B?WGdFaWlLVGlXNjNwY1hOYWhxSlFTTEF4QnNWZzJrWmsyYmFad1AvRlV0Ykgv?=
 =?utf-8?B?elBwb3BadmVUOHJYNUdnOEsvM2p4RGR3QzlqMWhJRWFRZUMya05ZMU1ncURU?=
 =?utf-8?B?Q2UrS3NVbml3T1BaNXlmRXNtclU5UGY1ODNYZWZDYm9aT2FUTTZlUVdTV3I5?=
 =?utf-8?B?RmNIMkJ2dW9mMDdvUHhjVnhNTEp2L3o3ZFAzQWloZXNmZXRWRDgyN25KMzBU?=
 =?utf-8?B?SDZVSzJwRHBUck5hSVZKV2FCWmdmdEN3N2JnREVWTDZoSnU3eXdXbUNBYUdh?=
 =?utf-8?B?SWJzd3hKZDJGclRCMStvME9wQjgwa28yV1BveEMwTWw3NFloK0k5VXJNSDhZ?=
 =?utf-8?B?T09MYStoVmNhYUpCbEVDdngrSXRuOUxHUmhXVFFTRzYyUkE4OXBvTVhmcEha?=
 =?utf-8?B?NGQyUGtCTm54VjJYdERXcVpNSHJYeTVacHRvbEFpeVNZbWZNUXJOaXBLU3ls?=
 =?utf-8?B?WkpwRGZ2UGdsT3RQa0U2b0NKTmtVTmxWK21oSFE2b1BVQVg2R1U1eVZjeVFU?=
 =?utf-8?B?Q0RWdW45bEIydXNsM1FzeTN1NlJUc3BWUFJkbC95MzNyRnNEMDA5MHhZZGdj?=
 =?utf-8?B?L2JuRUJ6d0FIMC85NTJnRUpUcW85OVN3SFJ2K1VicEYrSDlzK3l5YitpcGFV?=
 =?utf-8?B?VlpXV1NWbHVvYTh4R3l4UEpsRk13RnA0TnNjaitIMmlQRmlSRmZzNnJtVWVa?=
 =?utf-8?B?VXZHNFMzYWh2a2lkc0N3eWRYc0tTby9ZZUVjQmZnWHJDMnFodmhhN3cyZXl5?=
 =?utf-8?B?MjZIcDFPYUx0Mk4vem5uR2tIenBuc1pGMWQrRkhUa3BHR0dCRkNVaXFlK2s1?=
 =?utf-8?B?UmcxWnFSaTlxMk5rTlhtemN3QU11WW9BYm93SEoyaU9UcEpmSlc2S24vcXoy?=
 =?utf-8?B?ZWQ3aUI5RmlsUjRrUzJVZis1OVFLcE9wOWM3bWVONU9nZCs4d2VkN25hUDFI?=
 =?utf-8?B?bUwvdlVsbEFPdGI1OEJSRmZzNVJBNERjMnJjY3hzK1RnNzlQVDN0TCtON3lY?=
 =?utf-8?B?dTlNVUZnWHVuQ0lDRG54R2tZbXNRMSt1eDhWZmp2ZVBGdDZBMS9TWU1IUFhh?=
 =?utf-8?B?bWRkWlh2WTZpalc1Y0wrN1NRSmpIUlpZR3htMWhOMVZZcExpU3dRTERDS0FR?=
 =?utf-8?B?V1VFMHB0R3U1ZUdJd0dQa21SWG5iS2xvbldhUzFKQ1dIWjlBcUowa0RDekEz?=
 =?utf-8?B?dTNQc3pkMG40QXAvV3p3SDJ0VVpSdHVnbHR2S2VTWTFmR0h5T2J2UHJHeFV3?=
 =?utf-8?Q?kyrcgQ7+yrNiHg/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C043495A78C9D4D83103861C5F8CF78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9427b9a-88fa-46be-2950-08de7493da29
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 17:32:30.1582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jufXT42D6P45PCgap/6/+pvgrJFkjWJhk0E28tqYaDi/8kDq1iOzisZObTImS6DSARK9cn+96fkRXBKeLPzWZr0C3fGc87iVX8j2uu+Wzs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9374
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71855-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 3A02419B981
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDE3OjIwIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGaXggYSBVQUYgc3RhY2sgYnVnIHdoZXJlIEtWTSByZWZlcmVuY2VzIGEgc3RhY2sg
cG9pbnRlciBhcm91bmQgYW4gZXhpdCB0bw0KPiB1c2Vyc3BhY2UsIGFuZCB0aGVuIGNsZWFuIHVw
IHRoZSByZWxhdGVkIGNvZGUgdG8gdHJ5IHRvIG1ha2UgaXQgZWFzaWVyIHRvDQo+IG1haW50YWlu
IChub3QgbmVjZXNzYXJpbHkgImVhc3kiLCBidXQgImVhc2llciIpLg0KPiANCj4gVGhlIFNFVi1F
UyBhbmQgVERYIGNoYW5nZXMgYXJlIGNvbXBpbGUtdGVzdGVkIG9ubHkuDQoNCkkgcmFuIGl0IHRo
cm91Z2ggb3VyIFREWCBDSS4NCg0KVGVzdGVkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVk
Z2Vjb21iZUBpbnRlbC5jb20+DQo=

