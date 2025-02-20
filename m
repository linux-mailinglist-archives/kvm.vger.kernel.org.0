Return-Path: <kvm+bounces-38810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23FC1A3E8A8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE06A7A7F6E
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363B7267731;
	Thu, 20 Feb 2025 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxr8cao3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE3F26389E;
	Thu, 20 Feb 2025 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094654; cv=fail; b=DhL7NVkeeammQinTP9SDnLsmlhQFxd0Tn/wKNna2Sz5xteeJodTMdfXyzUF6lABoZxrUBeIq3eg3hs0fCxQUXrYzkYTmUtMgsJ1pb3/CUJQqoBX4kg+esyx28OKUN+uOpWbRgTO28OPg/mw2iXW5EVkzplTJ5CrhLo7uYlp7Y0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094654; c=relaxed/simple;
	bh=tqyyASa3gxC3FRRl4qPU7MTpKPdNPknQYmw4kOga9cQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YeiXgL0hz2gUXPM7F4/W8tboXBjw4BfDFTUP8ks+Yp9tuwhMlBFz4vkHx2C4FU7a2yrC7rjLS0/r1SGX32XNWHaLn1lbJhbjOf8KYpq15ykZ1HUCdkdIvNRh0Onu/YvsnzUEZRE7m546B9SjYB4RFvJtD60dVmqAg1FgYlkEgMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxr8cao3; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740094652; x=1771630652;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tqyyASa3gxC3FRRl4qPU7MTpKPdNPknQYmw4kOga9cQ=;
  b=nxr8cao3GRDjv676IqdzHwjFxKiWv4zsMDnXxeijZNYUToGy6DSvsIFQ
   K6CxNFGdy5rSjrXkJTwsDyhKHwaZXNjngcOJcOgCG7dzsnXNh1MHTPUZm
   x5xofoAMYYcJmya6vzb7ZIcSTZhqbbwwafMDMzAufETiMvpzGEV8yhTrD
   YobvabISBZHm/YvLEqpu8ARWhU9sGpuxO5kZ1aQ17m75/xYsDHsQ/e/40
   1K5e5lZGvCka+OsyuGh2FanpgWKT4+mG7cvK/D+P12suGRQwuEqFYMCEP
   VPeO4Agr/Y+APOHUsJADxr+h/Lq9oVKG5wDzwxzkF9xotIhhssqnXBiYj
   g==;
X-CSE-ConnectionGUID: fTdAcp3ORraeOOIrdPrZCA==
X-CSE-MsgGUID: pykjCsfTTw2vvN26K4yLNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="51115615"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="51115615"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 15:37:31 -0800
X-CSE-ConnectionGUID: +jL1lqr3RcWf9ILfNLX4Lg==
X-CSE-MsgGUID: fpzaOhjUTYS9XDtPv7d1rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115050374"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 15:37:30 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 15:37:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 15:37:30 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 15:37:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUHy7wBuAPow5r6rkJTY30RT939pJK8zw7cLG0vds0wttiw1sDPnnpaCHqp5BgZ9KjBU9PCW5KNLLZkxyW7mcHZCpqsm8AcOQcTtmbA4ACrgkwKLAwDuODrITNdxJ7y08K3Q/y6WEl2GHttctCBchPGfy4h78bQs6+3PLAwXJtRMwdb5DNQr4mwZb51CaUYFOUjrnn63Mw/ZSiKGSGPCDqicd9877n1FZhG01uXAsMNpgzweItoaOWT24RsOC56fgMvQMqznjKWO2+WfRBLXuDV7YmRkFrCE5zfafV8R6KBGqa2HDImuhEpL5ZZJGO6WPW1PZL1i3AgXfF37WvWAMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqyyASa3gxC3FRRl4qPU7MTpKPdNPknQYmw4kOga9cQ=;
 b=aOFyAQb89bbdaslTN3FJ1bH1up4i2gVwDstaEBVxoLo4+U2ElzZsB6Q0qR+cdEQlgRBVPxlmoYeqxrQKmwREUXUHIMvJJqs6R2hndiqv2MQDQWb9JlOj6zJltMochseNZcG7W44ftKlpKEZSBIDrE0OvO+Q+mZ5jLdT5FIZeTRyvykhEQgZGLXnsySWjCZ8jtV6jG4fDH+i2vTe1yGINqch1ph5yivWiIKkWqDhX790fxavD60atoSh6RKOetH/ilo28Kx1AjaYwIirJqrh6ojC5fSWDB1z260YG0OkCn8IhsdgAN0dOz5X/ITRnw40RDKKi+BsWLtjo2+S2TJfKTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8490.namprd11.prod.outlook.com (2603:10b6:806:3a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Thu, 20 Feb
 2025 23:37:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8466.013; Thu, 20 Feb 2025
 23:37:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH 07/30] x86/virt/tdx: allocate tdx_sys_info in static
 memory
Thread-Topic: [PATCH 07/30] x86/virt/tdx: allocate tdx_sys_info in static
 memory
Thread-Index: AQHbg7nVjp6n3G5FU0mwAOULIapY1LNQ2VGA
Date: Thu, 20 Feb 2025 23:37:22 +0000
Message-ID: <b907fce640fb893cf76f6aff4031d5ea501f6a74.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-8-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-8-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8490:EE_
x-ms-office365-filtering-correlation-id: be21e692-c0a2-4c60-cf59-08dd5207864e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M3BmdTZKTUlJVW1ob2xFY1l3M3l2RVlGUE5NeGVyQk56bW4vLzVOSzZSS1Bs?=
 =?utf-8?B?bG1vV2dmeUN6bWFHZXNnVk5jVzNxUTZ2OTRPWDlncDFIOHpSOWh4T1dNejRu?=
 =?utf-8?B?Q0RVRnd4MXlkSlJGWUwvZjBQd1FDczVXMEh6MkZZMDVQNEJyOHNGamxzSUYr?=
 =?utf-8?B?S1RlTis2N0J1SER6cXhueWxyNitRQ0pHYXlRMDYzYUZoaWdEYTNVMlNHOWFm?=
 =?utf-8?B?VkhVMUk5WXowT1VvQnVsZVY5MGQzU2prbnArWmNFd0t3aFpKS29iTXVQSzV1?=
 =?utf-8?B?S1Z5dlNmZzJ1OFJxdlRjejE1M3JPM0FxajM2bXlXTml3c0drUEIwVTB1WVVE?=
 =?utf-8?B?dEdYOVlzZDFNQWZ6SlBZQko4eFVROXMxQ2c3eEEyTUJPTHhPV2ZhL1JJRjQ4?=
 =?utf-8?B?bDBhb1RMakdFL1JYWUhxY01MRS9yK2M1MklHYmpFNk42TW96Y1RNUVdiMnd0?=
 =?utf-8?B?WGVaTU0vaU12UnNFMDNHRmV2dk9peG5nVExkWHJ4ZXhyVmhxU0NPbnNMZFpr?=
 =?utf-8?B?ZHQ1bWdMRHpYWkM0WkFkZW13UERQSEVNc2ptcW1xTmlpWTJ0WFBTYnpMeEN1?=
 =?utf-8?B?c0FtSFFOQitoZjEyWlFVV3VwVVZqMFNIdDdTTmtoTTN5Q0hRWUFmZWdKaWlO?=
 =?utf-8?B?OXpjb1E5NEZaRHAvdFpqbGcyVDhZSzFFUVVuRHF6VU5CSHgwR01mS1haSXZl?=
 =?utf-8?B?YURwK1Q2OURzRktKUDdmek5HNCtkRWVvWFlCbWpLZXk5T1hXQ2Z4UDN5bncx?=
 =?utf-8?B?bkQrVkFXUEExcDBXdHF4eEJ4K3BaYUE3enpweDgwWXFMYmRLZG5XbjR5Wlg4?=
 =?utf-8?B?K0hkTWp3Mk5JWlBLTmRCeE9uRW5XMlVCZUxXbjlVN1I2S3JGdDBkY3BTaXJt?=
 =?utf-8?B?WUdDTzQ3TE1BUHlsdWZVVkl1eXFkWVJZeEJyQVZiM1JjZkxTOXQzUnA0NC9h?=
 =?utf-8?B?cUdra0U4L3hkSElydlR0ZS85SG5jZmxEeTNFUjVCOUM2dTdRWVhGeWlDSHkz?=
 =?utf-8?B?ek51bkFoaW1nMFZWbmZKTVdpOG80dDVqK0pONGJEUmlySVcwTWYyaFRiYURO?=
 =?utf-8?B?QlJEVDY3aTJha0NncW9lQ3VlNUUxanhXeXpzdFU0VzhoV21kMUlOTnVSL09q?=
 =?utf-8?B?VjY5TDJiV2FlSUlrVDNoUFV5dG5UMmljUEZLdnJ5V0taOXVVdVlSbjZKUzZH?=
 =?utf-8?B?cmowUmRmQ3BHS1hzQ3gzWFVSUmJCQ1MyVzh3RDJnRXJmK1Fta2tIcE9NRDBV?=
 =?utf-8?B?SFMydkZ4SEF2anVENUcwWTc4a1ZHTmZUWkhWcTZCMjh0R2d5Vzh3UHZTNkxq?=
 =?utf-8?B?U2FRNFYwenJSYmI5bE01TXA4dXhpUmlDSzVrSHU0VTVGaFBrQktuTHJKdTVE?=
 =?utf-8?B?RGVmZW9KK3FCNHBYeXg5L2ZZRTRrVmZYbHF4Y3I4RnJFQVN3QXd5ZDNaRGFU?=
 =?utf-8?B?VW16ZXNWV2x1Mzc0MG05OFI2T0dQMWZQQk5sVENBRGZQZ1lTcHhCWWozcnpB?=
 =?utf-8?B?aGQzaEx0YlpDVWtoNFB6WlcrZVhLVGEzKzZVM1hCQnVhQ0ZSYkxNeGozdWpn?=
 =?utf-8?B?VkxGaXh0aGVUMTdlUW1ySWNNWlIyYnpUK2RuYXgxbVUvSFl0U081SHEzdXJz?=
 =?utf-8?B?cDdGVDhUeVAwaVViVkxqUzlGR2hGVWJEcDN1SVVZTDVlMWpCZUR2N2RnTWtm?=
 =?utf-8?B?dEFmeWtuQ1lyTC9HV1NVOWdKdlJhbmpuWEdNcUw3L05aclh0eEtKZkR0Z1Iy?=
 =?utf-8?B?TjZkZjM0bXpwcTI0MjZoRFFLWEVjVjN0UFBBRjd1dytJK1YvYWdOWHFRUHVT?=
 =?utf-8?B?OTdXdnZ4WGU5cVRlS3A2Q1hFNExaYUE1SUZDTGlXVitlU0Fodzg4cnpuU2Q0?=
 =?utf-8?B?TjkvVUwrK2hMSyt3VThZZ1dZU0pIUGE4V0ptSmJLMkc4VzBBd0tuMk5KMC8y?=
 =?utf-8?Q?BS7KeXwhsYphfMLvrMEMzhlrX03z+MDJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1hKZFdzaXhEemg5UVdGTXM1SFVId0xHSlhFREk3OWN5dnNUS1cwaEFSeGtP?=
 =?utf-8?B?eUliaFNXaGpJamtpWUdpUys3bEZIV3VKZkd2YTJ0T0xpdFRVSVR1enVhQ01q?=
 =?utf-8?B?SXAza2JINmZKOFgzckJMR2tnaktZS2pwcmlCTXpxTXRMc2pBWm5nMVRzL2ht?=
 =?utf-8?B?OFltTzZzVUluMWZPNFNkTGdSckdRY0x6cXF4OXUzSmN2VXhvZW9ydVgwTzg2?=
 =?utf-8?B?TG5KM0RLRCtWWjRwN1hiMDROR0N5RlFKZnNSNUdJWXZDczA1RTh3TXBocFZj?=
 =?utf-8?B?QUVMNytVZmJrY3pYYlMxejZGeTBpT093MGRIYlhhSmtEeTZESzhOalh0VTE1?=
 =?utf-8?B?OTY0NFc2ZVZQeUFaV09keW42N1ZWZWlTbkJxZnV4eFlDdEF2TGNhOG5zc3JR?=
 =?utf-8?B?Lys0Z3lDOU9NNG1DRTVHa1hETW9xNGE3RVo3b2htdUswQ0lhY0pUdmxFc2FF?=
 =?utf-8?B?SVVMclRQSWcwQ0w3U29Xd0ZRU3hUSTJ3V3o2VzFEVDd1dzZTdFJxL0l5NzRI?=
 =?utf-8?B?cThwRXppcWx2TjM5dW9NTkQ2clF2cExjeWFRaFp1bUpCTnVXcEZ5SXVWYzl3?=
 =?utf-8?B?MjI1RnRCUlMvc0tFSHJoZVpwaGlEWk1PcU1oU0k4OGt2Tlo4ek1PSnVzQnd0?=
 =?utf-8?B?SllmRlZiUldreG1IVUhsOTFpQm1OS1BNd1hBUzViU3oveEFGaWFSVFVEc0hB?=
 =?utf-8?B?YjFJaGJGWGp2TWRNY3J3SWxRSzhtYzhTQzhTcVdpbjNYMld4dHU4T01UaHpW?=
 =?utf-8?B?emRrMEdKYVViYlBiaDk0cXIxQUR5SnovNldQQTJQS0dDSXJ5ZmlXaVExaW1J?=
 =?utf-8?B?ZVdGcFpjbGNLYTdaMFIzVmU5UnE0cWZGbUt5ejFWR1J6Q05vTklZQ3dwcmtR?=
 =?utf-8?B?SkU4cXN5RWRxZG1OWStQRElnbXFxYUwzUzhVMXRNVTQ1dXAwaURYaWg3WTJB?=
 =?utf-8?B?VjhNdzZUdWtGWU5LTi9TdHovRGN5MDBuc0VDekJZN3NzM2RSeHlGdkZMSVhG?=
 =?utf-8?B?YXh4bmZYbzZrL2tNaHZYRzl4cmVtSkdnc2x4OEQ3dnJoRm83OE5aY2Q0ZExI?=
 =?utf-8?B?UGZEL3liS3ZqblV4ZFBMQWY3dWRqNUJzVkt1QXVUS2xzSERKWmYyMlUxZGIx?=
 =?utf-8?B?N1o0TUgrSGx2Z3lBWDRGR1kzY2lvZmNJbWdPWDQzaThuZDVxNzlHZE02Zzly?=
 =?utf-8?B?VFZwbTVaZjQwc3FNYmwwWkdHdVhpaWZIcC9XaHNsencvVnhQNmp1eVZ3S2xu?=
 =?utf-8?B?eHRzMWJMUE4vU0pQSFBaemQ5am9jVm9POUZ5MjNwZ25jalJDOGgyNTJZdVVI?=
 =?utf-8?B?OGN3ZmpvRUJpVmFjRXVOMkpWdmhlR1dhbVFLSzVHWkZNemhYL1BpQnBvUFBn?=
 =?utf-8?B?OGN5SkFqeXROQllYbmNvbnZOTmo0bDBoalViN0dram9pczZRUnJLZ3c3VWRE?=
 =?utf-8?B?S0JOWTB4VjIwaTRTSTh5WHF5NFJJbGlGOGRJd1VJemNLZmJsWWlCdEZmWG1i?=
 =?utf-8?B?MmNKdWZOK3k1dHN0TS9TVzF1YUxRSWp4NWF2L2dKcmNZNXNrSnY4bTZpMy9y?=
 =?utf-8?B?d2ZsaHdvdEdueW92bVc4SnRHYUNBQjVKaTQzMGZOQkdOOU1xaGNqQ24yQzNZ?=
 =?utf-8?B?Sk5DRVFIbEtoand6empwQU10ckh4ZTF3OUVwa3lzTVV4MEdMQm1rRCs2ZDJX?=
 =?utf-8?B?b09qZVoxaVFwanUxQ2RkWWFDWTJ5aUFLaHJ3cDVrTFNSTXA1UVFoMlNRTjJC?=
 =?utf-8?B?RVlUakp4VW80bUcvL2tyR2REMm1RaGdKM3RSajFPSHp0aitsNjROZ3JROTRI?=
 =?utf-8?B?S3FMQmlMVEpCSVNNTk4vd1pTdzBYTGhOcWV4NHdlN2hhb1dqQUJJS3NoUy9C?=
 =?utf-8?B?TVBwUU0wZkxPeEdYbDhoMmpXVEc5aC9Zd3ZKWWNkNHpUTEtyZVFQWm90TTVI?=
 =?utf-8?B?clMzSjdOYTB1OEZwUWxScUhYOHRxbXVFREc5RXI4cVc3R2VteHdTYVFqTXhF?=
 =?utf-8?B?T0lJUE50V1BIY2cwT3M5TndNVGJQWnhHZGNZSU5PdkhwdWRObnhyaytLK0tI?=
 =?utf-8?B?R1crZXNacXhRWGcvdk5kTW1wY1plYmkwQ2NyOVdOZWtIYjE1SFRpU3VsWTVC?=
 =?utf-8?B?dDd3NnYvQlozeHM1QTVXazVFVnV0YUlXTzVPcUxUQy9KYlA2MUxjR2ZuTE1K?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E517BA56B4ACC54EA08B81E1934A0CBA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be21e692-c0a2-4c60-cf59-08dd5207864e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 23:37:22.7837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8w0EnHQfE5QIrfbnf3/1XXzLkjC6WV8N7U6YtqNB028fxshu++vmtJTvFHJRu8g9xLE2F/7PSwtbUP89FQpRhnuA/m0fUXCUMs3gR2fJpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8490
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAyLTIwIGF0IDEyOjA1IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBBZGRpbmcgYWxsIHRoZSBpbmZvcm1hdGlvbiB0aGF0IEtWTSBuZWVkcyBpbmNyZWFzZXMgdGhl
IHNpemUgb2Ygc3RydWN0DQo+IHRkeF9zeXNfaW5mbywgdG8gdGhlIHBvaW50IHRoYXQgeW91IGNh
biBnZXQgd2FybmluZ3MgYWJvdXQgdGhlIHN0YWNrDQo+IHNpemUgb2YgaW5pdF90ZHhfbW9kdWxl
KCkuwqAgU2luY2UgS1ZNIGFsc28gbmVlZHMgdG8gcmVhZCB0aGUgVERYIG1ldGFkYXRhDQo+IGFm
dGVyIGluaXRfdGR4X21vZHVsZSgpIHJldHVybnMsIG1ha2UgdGhlIHZhcmlhYmxlIGEgZ2xvYmFs
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNv
bT4NCg0KSXQgbG9va3MgbGlrZSB0aGUgc2FtZSBjb2RlIGp1c3QgbGlmdGVkIGFuZCBtb3ZlZCBl
YXJsaWVyIG91dCBvZiB0aGUgYWxyZWFkeQ0KYWNrZWQgcGF0Y2guDQoNClJldmlld2VkLWJ5OiBS
aWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

