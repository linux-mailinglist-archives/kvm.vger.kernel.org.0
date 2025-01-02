Return-Path: <kvm+bounces-34506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 481AA9FFF92
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 20:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 110B91604C9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281291B85D3;
	Thu,  2 Jan 2025 19:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QVY/5sMV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9A81B5EB5;
	Thu,  2 Jan 2025 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735847112; cv=fail; b=EGsndPQXJW3tNSzKUxuh/MiWqj0sKh7D1VU0eITVLq4G+tebSo09VkFMEFZKMbMP1n91PbpActF2ZXG5DduLhead9YnQoSyBeiQ0HfGLXCd6lAhXHav2n9t8OFu1HFd5mHNlT/JsDJgrg5jmhaHZLvQAL/XOyemiuMIFs2+No2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735847112; c=relaxed/simple;
	bh=hep0zlsF0+6TyL56HNDovYusgaIPETjhCuO7vVTC10s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t7XkPKntEchrESWn+UkC9obJut75EIjxKkbYALSwOrnwjmCwEp9fvEmnl3ISztjHJhomgrBDnSzS7yn+vg9ew5CNQBzvtlFY7kHwlZge1RkmNhY0+cjIw7JVGA6awucxKzWOoaMHvkkMX6o7eulrNGp4ozKMzThMTcXU5lUtdPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QVY/5sMV; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735847110; x=1767383110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hep0zlsF0+6TyL56HNDovYusgaIPETjhCuO7vVTC10s=;
  b=QVY/5sMVx14xBQMwLQ9Jpe8cFH48eEaXORvbJK1pg7jlfZBvll29cSwk
   nnQuclAsVdrmmZ92dIt20zSv8B+OsPp7CA4KDZE6rONo+1FwtMmcw4tY9
   QWldhA04VSTFxQOtE7Dapw9PwJSJKTHOG1Vsbe1Kof0YoyVYEWfzZSpwe
   8/H0BlrpBuoKbz/VVxn+5Kw3m4NGfhT3RoYthXg9AkqFa1OfuRG/bwlrG
   pINolsQgK8XGIAiDSfIYPzDfs4cnXkSDW/z4cO9vAPt38APagwGIrLWYf
   VRb0qzLe+sgDX7fOJ5FrnAo1xZjYCVA7ywwdQqPCUe5GyWia2ZALmq/t/
   Q==;
X-CSE-ConnectionGUID: TxLVLOLBSaymKVo8PlCU6A==
X-CSE-MsgGUID: mal5l0OJRUGher9LqmLKyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="36115558"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36115558"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 11:45:09 -0800
X-CSE-ConnectionGUID: L9RrDlpiQ8SGMbIn094gug==
X-CSE-MsgGUID: pfOLRE1vRu2iYjIjUOSafw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="101445723"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 11:45:03 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 11:45:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 11:45:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 11:45:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FM+fDbegnZ3cYSw4Q/B+8AVhjW1zR71ql+vjBLcFn1WEwVHTMjIe8958llY0m4BfL+V4gOBU5FlJaJLMQjhtMXzRXbciWDNKcSvPZI1udGZhzqQgAZNYc2YmNkYkvM9aUG2MCdg32iARZeGBcBat9qJA6XrWBMUYHrpaExXD/rCIYkW7hfGeD3k5/a0jkGwyIJ99x0Fei6vyakpJER7GMwLZFosPWvYD1cDKiM1pSDNYR6tFczuezAEcCv19LFl+UOfZOP/wvqM9I4KMMLI1X9sPSBd7EAyXN9liKGnA7ecUzesKOFkjF9MOnQ2E7Ff8HFqcM2NTpGsQvkQYMHaJGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hep0zlsF0+6TyL56HNDovYusgaIPETjhCuO7vVTC10s=;
 b=JD8NC6x+MpQQHWk0AnZfSe5VoVvbL8AvbH3UIQbClxw54IKQBT3L2NLE9vWxTXJoEg5IOSBl17FXxi4FNRQCAwwBmDQTDjMuPAYD4owTeUHU/ck4iL6JTB1MP6HQMSRVMIlqTcnqpdqgyOTL/gbF7W/xXn4UH9dp2ABTXPugnvtV32m0aGgcylaPu361gLBuiYIOq16kh62qiByEiKIN+zztAZIEyJ7tKRKfMUbOXZ6SZpEIM1gPdsZAIPZtuUDSSfRkqreC31Ys5Vw6qa1HvN1i6MkGHxODCDfMM+MK5ut/QXlXyzFH6VT8d2lkAzni7LaZqEi5fbYilcYV4c8KiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6980.namprd11.prod.outlook.com (2603:10b6:510:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Thu, 2 Jan
 2025 19:44:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 19:44:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "yuan.yao@intel.com"
	<yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 01/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
Thread-Topic: [PATCH 01/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID
 management
Thread-Index: AQHbXCHWuINFzy5xEEWIVDpRHfhsMbMD5UGA
Date: Thu, 2 Jan 2025 19:44:41 +0000
Message-ID: <ebc7479595d1e64632ebc2171abc80ed3849b3e2.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-2-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-2-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6980:EE_
x-ms-office365-filtering-correlation-id: 1f8cbb8a-49cc-47f3-d2f3-08dd2b65e658
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VGdzOE4zR0ZLRHgzWTJ6SlRnejdhOTdDeDM3QVVmOERGSVVIWkdVQXlUTUJZ?=
 =?utf-8?B?cEFFaUw1QVd5dElTMU9BY1NCeUlET1ptYTZoSFFOY1RvRWN5V1lWSGlEekM1?=
 =?utf-8?B?dm9BZTFUTGFlSEduT2V5MVF3OFdSaFYwTHlacVMzbXhKdExic3JnV0JDbWNw?=
 =?utf-8?B?WVZOR3V1dFBaV2RGYi9DZXE1MGxLcU5YTUljSjlwcUI1OGN3c3Z4QWpXTUVx?=
 =?utf-8?B?V0ZMb2pMWFgrZk92VjBvam1WNDJoNjNWblBua0ZtMDVpcU5xZk4rVDZSUmJM?=
 =?utf-8?B?TFVhcFFpODFhWXl2TmxzZVZaaVhLdkh1S2krMFJsaXcwd1JTRjRPWWlna2JG?=
 =?utf-8?B?NXBBalh1NVJWUnBlKzBMbnp0Ym1iR0thbisvVzM2SHdTTGRkOTFkcjFhV1Q5?=
 =?utf-8?B?dkV1TFdjMUxhRDJRM2VyVm1nYVk1T1RXT3RwMkdKb3ZxYkp0VWhqc0dBN2Nx?=
 =?utf-8?B?WTJJWERybVRTN0pNT1QxVk5VdFFtKzJiZnplUXl0aUFjZ0M2WWptWFY1Z1Zy?=
 =?utf-8?B?YTBUUmRVcGhIalFPUk4xVEtMZGpxa1J3VS9QY0JrNk5sY1VKb0YrbHNHK3Br?=
 =?utf-8?B?SFhaekhHT1M2bkJVRFFWeDRnZEpHdW43cXVpU0p1emxTdm5UT1prcVB2RmRo?=
 =?utf-8?B?NUZoTTVlL0ozdk5QUFpUNXBzamhreVZFbkRaVk5nUS9JTkduUGFobUpHRWo2?=
 =?utf-8?B?eThnSDdtbjExTmJXYWJFRyt1OVNtMXBhbnVaRGIyYnpuUWNreGk2SFg1cGdM?=
 =?utf-8?B?Y0w3czR6TWtsSkU2WjNrb1BxRmZhVCtqU1VxaDhhWHZGUG1sOVNrZ3Y0Nzhl?=
 =?utf-8?B?cnNMckpBdnNXbnpXYXJpUytDTlJGYzVMWC9FUGpPWHcxUlhUSlFibk1DM3VT?=
 =?utf-8?B?S1lPOFVwbWpaanRSM1ZKWUc2M0hKREoyeTlqQnFIUmN2b2pFQkxPTW1HVDRl?=
 =?utf-8?B?YU4zTWd3SkVVN2Z2Z1Q4d0VZcDV0ZDA5MG53SHIrOFNJWFJ1WStuTW4wZ1Y5?=
 =?utf-8?B?eTYvcCtsRlpmSWp1eldYalVkRWdxd1UrN0Y2SEdQalZFcnBxWGFpQ1BTMURs?=
 =?utf-8?B?QVhNOTBUeFRBVmdnQTdRKzkzWW94NFJyWlhCZmRacWdpM08xOVZ5c1dIci95?=
 =?utf-8?B?VEZXMHdHeGN2ZEc4UkMxbnZYdGdZZXJGV00xMzdrTXJxdWFrbWJvLzNTaTlI?=
 =?utf-8?B?Ym84WWxITmlBY2JJTEpsS0lNeUhjSExBdWg3UEMxdG5xS0cxZlJ0dThLRGFV?=
 =?utf-8?B?dHBsRDB6NWNYRGRsV3d4WG9RTkZ6dmVPZXBjbnRuUWhBWjJ6T09QZkFuem9M?=
 =?utf-8?B?dnhXMEhNTW1XT3FtVkR1bnVndmJ5QXlXTzRqaFdBNXZxdUU0VUIzNDcxdXlD?=
 =?utf-8?B?UnVOREFuLzVXZEd6Z3BoRDh2RUUxd1FlSlhxT0RjRFo4WmthcllkMkpRK0dp?=
 =?utf-8?B?VkwzdUFZanRzK0d3ZDR0TjYrZ29mbDNLbFhqNjNWWWlnaklMb1AwQkdxNG92?=
 =?utf-8?B?TnRLODE3VXJrWmhPLzU2U3BNVDR6ejlFaVdkcGlWN21KR3gwZlJLWnhiRk5S?=
 =?utf-8?B?azU0RmFMMnh5TUZUZlRCVnZleDk0OHpDcWFZT3ZnQ25ZZzJZem1hWUZmaDFK?=
 =?utf-8?B?T1MydlpvV0krdHhZZENQcWFSVC9VejNQR0puODlTenZNUGUwdzc1dENYSmxl?=
 =?utf-8?B?dlpTeU5NVnJWV3Y0TG5GbjJmckE3UHpFamkyTTc4aFVpTk01YlNLYnY5OG1V?=
 =?utf-8?B?MEpnQ1RFeTB6d2JlcnN4V2o0YlY4Y2JucUhUOURSL1VpWWpHdGJwakptWmNM?=
 =?utf-8?B?cHhPZi9tRVovM1ZTOHJDazRoS2NuczhhOE5YbGJYbW9vZ01wTEZ1T1VaaVBK?=
 =?utf-8?B?aG93b0haWFdqaDRzZGdxSmk2TThxMVN5bG54RXRvdW8vNk9Zd0VNRThkc0R5?=
 =?utf-8?Q?ApVdl6cAkiVLSW9/qbalCejCAzkNAiZh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxTU1Y1ZjZiNXpkZGp0alEvcTgxcjlUR1pXNkVmc3JXOVRJL3VpRUR4ZmhY?=
 =?utf-8?B?c3MwTDdLdE53SGZkRzR6bWsxWVJCeHJUVTVWejBVTWVJTDNPeTBBZjhPblE4?=
 =?utf-8?B?RVYwb2xDeWNOV1ZYekx0S1FLRE9BRUlaRWxmQXNDUEVJU0VDSVRwaWQrV0p2?=
 =?utf-8?B?ZC9UMERNd1FWYk1iMFpzUWdDenhDRUtmcFBzZEhIOEFpdldGSWkwQXdWMHJw?=
 =?utf-8?B?YmJvLzJxZnZkZEorMUl3UlZyeUN0anhUcEVVYVJQS2g4ZEJZVEg3QzkxNGYw?=
 =?utf-8?B?SGkvbEVCQk1sck11VkdoamFyOTFkVUpwVC9EaGxNK25wTGtXYTRCRlZIUW5X?=
 =?utf-8?B?dElENHNDQVp6Snh6OEhDUlFaL0hrdkRLWitPYmd3L014WWhqOXd0SlMzOFlo?=
 =?utf-8?B?S1k0WHVWVlpLNWZRUzJ4ZHIzK0YrVU5UZ3h1bHRDRkhLbVB1d1R3TTF0eHlN?=
 =?utf-8?B?RjVCR2k0VTBvb2I5c08zNFVqQ3dmWXA2ei9TK0JsQWF1ZEZUdnVtVDZhMkE2?=
 =?utf-8?B?WUhyK2xabU1idjlGNFkvWUtPM2VZaS9LRE4yNDlDUVhoZzk4OFhpRTJBYkhC?=
 =?utf-8?B?QnlLb3NHdnhzbTlKMHZGM1hmaWQzNDNQWC82RUVZeUFCSnA4WFExZWF6QVF6?=
 =?utf-8?B?SFRnU2FUYmhIU0FqZHVVWGdJRW9IQ1NWb1o3TTMzeDcwM2J0dzJuNlVrM1Qr?=
 =?utf-8?B?WnhZS1BtYTNVTEFPb3JoaTFNNmhPTHRCNDVDK1VHd3NkQWRTeVFrSjdLTStB?=
 =?utf-8?B?QjMzckRqaVNpdVZFSDk5L1lzdmlDRFNOT0o3Mnh2T3VDVVl2bzdBRGoyQ1RC?=
 =?utf-8?B?NlFBTHhzU21CM1NDZnhibTBYeFlVaWpKa01KUDhBcTRCMmJHNGtPWlUyYmlP?=
 =?utf-8?B?Zkh2UkRBOXhZcDFJZWZmYjczZzNDOVpmL3VTdHBMaUJ0d214c2dkMXZ4ZWx6?=
 =?utf-8?B?SFpUaVhiV2t4MGk3eitvS056ek10UE1QR24vYlQzTUpsWW96YUE5NU1LeHRy?=
 =?utf-8?B?eTl5eDV4N3p1Y2M5endkcjZKemJVM2E3YStDejlTSk1DV3kydzVISGtEamtO?=
 =?utf-8?B?RU5DaWRaTWhzWjB1UEt2L1R0cTRmd1dpUmF0TVpTNEFseC9PNlk2Nzk0V1dm?=
 =?utf-8?B?d09WMG91R3ZrazB0YnB1NHdaa2VZbE50MU9qbVRlRUpjWWd4WU96Rll6V014?=
 =?utf-8?B?SEYyclZ1dGhXZGptL3g1cDkzMkZzYy9BRHR4dW5iV2VhbEF3KzNHRElxQitu?=
 =?utf-8?B?RWQxbWxsRUttTTcvSjNDT2dGQ1liZWxyUjhtUnAzQ3Nuc1dYamNack1tQW9X?=
 =?utf-8?B?Rk5EdTRtdDBvd0ZmbXk4OE9qNGJ1Mmpxa2JCb3RFUGVja2dnc1UydWlqM0Ju?=
 =?utf-8?B?RzdRSFlpWDk3RjdENnNuNTRhdmMzb29aVXlMbzRjKzh5Q1pxT0RSbjA3TFVK?=
 =?utf-8?B?T1VmZDA3UWhUSHlEalNFeGdJZDFSS1laU2MvYWVzYllLRGxKM1dnZ0ROeEZQ?=
 =?utf-8?B?MVdYbmg0cGhxZ0VNN1VxRGYxeDk0Qy9kbEZ3WWtoTmNyOWs0NWdNWk52WmtJ?=
 =?utf-8?B?MWFnUWZFZDJYN1AzazViSmtxVFNYaHJlMUNEVDRGZDdPRmVKajZidHhVZEpk?=
 =?utf-8?B?VHh4QjhoM3FTMUcyUnMzVHJLWmw3OHRycExWV0pQZEdhMkovTU9ZM2lOcDZs?=
 =?utf-8?B?TURSTmM0aTV3YlRRSm5jenAwZ05rTzdvM0t5MlVzQ1dzTy82ZThMalIxRTV3?=
 =?utf-8?B?SXB5UGRXdnFSTkRuU1lWWlBhWS85aGwvNnJBS0VGUHJYeVhiL3h6b080RHBl?=
 =?utf-8?B?eSt5bzdyRk1MV0xCYU1BVVNUZVBRcTZmdkNJeVczUHc5TW1HUlRYZGszWUlH?=
 =?utf-8?B?MXdsTk0rcnB3cTlFZDMyQzBOMnNxOXE5RUR6cGlRUStYZDcwQmdnY1J1enZN?=
 =?utf-8?B?K3NJQXRpaVVvNWFyTndYczZlUll5aFUxQ2NidWpRZlk1aWVMUTIyZEpoS1pH?=
 =?utf-8?B?MVl1NEJpelBoNy9NWjlPZXVrS0h3Y2tGaUlnZnRNa3F0Q0QydVp2bnF3S01W?=
 =?utf-8?B?UTFKSmpsZWpQb1dUOHpJV1Z6MTJEbXBTWlBCemNyT25WMDJrME5XUWJqdFl4?=
 =?utf-8?B?VTVuVCtIV1NWQXdQbWlDVHVIRkpsK1ZTZDhJcEJtT3BkTmtLQW9xdnhxUFpn?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36110CE0C235E74D93F3B0FB7B3D357E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8cbb8a-49cc-47f3-d2f3-08dd2b65e658
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2025 19:44:41.2583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XeEMGH0rGht6VNqS7idYPOzuWb/HtsUTi+BheOyjuGxoH/K/bR+zo0hr8GAaA0LMO7z3VY3LL1mB/mZIN99IbmlwK6y8LSyPuZGej2bnWKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6980
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBDby1kZXZlbG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlh
bWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmljayBFZGdlY29t
YmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogQmluYmluIFd1
IDxiaW5iaW4ud3VAbGludXguaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogWXVhbiBZYW8gPHl1
YW4ueWFvQGludGVsLmNvbT4NCj4gTWVzc2FnZS1JRDogPDIwMjQxMjAzMDEwMzE3LjgyNzgwMy0y
LXJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256
aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiAtLS0NCg0KVGhpcyBhbmQgdGhlIG5leHQgNSBw
YXRjaGVzIGFyZSBtaXNzaW5nIERhdmUncyBhY2s6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9r
dm0vMDg1NGZiZjAtYzg4NS00MzMxLThlOWQtMzBlYWE1NTdiMjY2QGludGVsLmNvbS8NCg==

