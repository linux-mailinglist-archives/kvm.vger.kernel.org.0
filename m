Return-Path: <kvm+bounces-65540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 32CB9CAEDA7
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 05:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B2AD302AFA9
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 04:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9B22C236B;
	Tue,  9 Dec 2025 04:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lf/8ULfw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D756621CFFD;
	Tue,  9 Dec 2025 04:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765253999; cv=fail; b=t9SG+ZT/jcOYcx9f5JHCRQhxxv6melj4v+g4HaVsJ3d4tywuzrZ3g9KM3Fsy0gd5wlyim3FKpENeBQNmhv0C6Fhszufq+gdHYzzFeH14IhfMSNGpk0CKSlD2a1xLsTOiLGjdtp89GrVcR/gneMYsW3aObsOeYyGx0zdWal+05tE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765253999; c=relaxed/simple;
	bh=vOoKF7y8I/kscmqR4pwsbOAWOajBTmLklkFICzOP3Wc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=UJN6tOWKGUWqzp8iz6Z7D1QnaPhf2BnOc9uuY29O4b934oO1m0/LbKqYVzfzh9eDPsc98u5Psr5Ole7l97N0RsqK2EjqoyrjQ1XI9ymlv+XkGTO2BI1hBOLd+DgeLTTpD2wbD4SMezXhOkOIPZjJtDLitlpnxPVwqQ3Gnp9q7C0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lf/8ULfw; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765253998; x=1796789998;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=vOoKF7y8I/kscmqR4pwsbOAWOajBTmLklkFICzOP3Wc=;
  b=lf/8ULfwzMbKKb+G0JjV6edpBC4WJe82JBmnqFBsPfoHD+0lsN70FLWM
   QdxIyoEJLPzuwKTebhmEZz4SF6XxR0d7t+O4NZnVbW3lI3ortvtK8NknX
   j+wvM3crokYav0mQPF0PqIAuQx6i7e2PUf9V+il/jQ9Imw3no9VmNf8hp
   EP4akmRSHm5sgobWyfROeLPPrLn+ZBeb6VgKL3v2zqB8l2UD5mfhpMznE
   I3t4KeiuNcUt/zLV8Ep0wBTp2frDkm1p3sqFABUVvTHLuH9G4Ak79pjVR
   Ci/XXHf2fKHttVQfu2sHZZjygm5KYzHEnk24k+SARw1b6K+l8/Mo7Iu5O
   A==;
X-CSE-ConnectionGUID: 2U7MWyllS7Cr/ScINpZd1g==
X-CSE-MsgGUID: wOGVVmd8Rv2fWtN7/yHxHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="66390340"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="66390340"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:19:57 -0800
X-CSE-ConnectionGUID: h7JQSiUpQYKTlBKMIVuQ9Q==
X-CSE-MsgGUID: ZNPhB1mJTjmL+5jbHP+GKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="219470992"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 20:19:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:19:56 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 20:19:56 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 20:19:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcBcSQ0DDqaWj5UzwrofS4NqsqupK5dgDEE3f3X++oZtNyo7mKd1y0XWxFjHfJO1p+DSfWgkCTVmyxNPtQ7juTWna+8OViJ1jJZUXH3pHPMxDieaD65tKjOEa264UPJT0t+a8q26djOgpGlrBB9C3qt2ziJPzEmAz3WbHTebdzG1SxYiEoWSZv+EiTDA6OHUb2exwnQctt0oHkZ6dbRu9Z9hHluUXHVwkCSWSAKfEzr4Q/onCRI082O5ZVnoBPe45EW3r/44G6vgN8ojCGgtbrTMp9Mbqkbgq+lMoYejVLyXJ4gq0e6TlOag7pGaSMf61lJHZT9Et+c/LrHN2+WOrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1I98sXoepViGfqwlC2KlUygObk94xkB1PY6bn3OK1yU=;
 b=ogfZwmu6TPhTSMGeOWwRy8amwpTtHGwVdh5wTQnO0uFQBCMiSodJb+qK/J/jwgwxqocjEPJsa5BGZZIILi+CBNxfYsRAcBriUouto0TQSV39zuHn9UXew6zGoXvqfNdbbDxzdscGJtuXHM0QA0+O6K1XOPPUEouMzU3JU3lsTgldVZligHRAmOkPVxmoeTpbPd6b5INswJCWe5tXuyY0sRWwHExxM7a0nN951mcAO5OzhTQoWkLv8wIoY6TjBbWlDPQwdg3OvISDkQaV20z4TaEvxR476e5MWcIBQIQ/zLAFFxsc8YbC2AYKVMBhZOeEvN45TR8APiPDpZHoIHw1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6285.namprd11.prod.outlook.com (2603:10b6:8:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 04:19:47 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 04:19:47 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 9 Dec 2025 13:19:44 +0900
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, Chao Gao <chao.gao@intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <6937a36082007_1b2e1004f@dwillia2-mobl4.notmuch>
In-Reply-To: <20251206011054.494190-7-seanjc@google.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-7-seanjc@google.com>
Subject: Re: [PATCH v2 6/7] x86/virt/tdx: Use ida_is_empty() to detect if any
 TDs may be running
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0378.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::23) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: fafe9720-4c69-49ba-252b-08de36da305e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZDZLSTBmaEFDTUpHckJKRnpsL0dKL1VHcFJCVXk0UmsxSkhJMVljVGdza1gr?=
 =?utf-8?B?SCs1U3dqMU5YcGJRSUsrQU12aUxzZ2o5aHF0ODE3RHEvc1V0V0t2QTB4RTlP?=
 =?utf-8?B?UUZCOVV1ejlVUXVHeUdzd3JuRFlBV0NURTgxV3VXc0h0ekxDVlJhYmNJdkg0?=
 =?utf-8?B?bjFaMndqTDZTUmhZalBGR2xZUWZhZ1RKLzJHNEJKdUlEdHlXN1h5dXloVXRq?=
 =?utf-8?B?MGI4SVI0dnZIL0Q5eHJuVXQzUXQ5SzVhcDNoU3UwaXZYenBOenNSSzRSUGJG?=
 =?utf-8?B?eUlFNGhBandvTHRuT3dZeEtFWEJuZlh4VFNXSjh4Z25ycnB0WVVCWGlrVXRu?=
 =?utf-8?B?UEdtSTFRY2FBVFlRVUNQSW1DdXJxLzZubndJbUcycEZHejJHOGJVOVRhTThR?=
 =?utf-8?B?amI3emNoTXJrQSt4MmNPeXdEOTBveWZHZzFTK2VadjI3QzIwWDA3UWpnRUZE?=
 =?utf-8?B?RGE4ejFSRVJadk1KVnkvRlBlK3dGc0Z2RGs0SVFHUDNQaFhtWDFiWW9LcExo?=
 =?utf-8?B?ZkFTVHRqY0s0RnFIVWdoSGc2dmljelpWWTIrNXhXUW1EL1hkckN3aGhRT3NE?=
 =?utf-8?B?ck5WZGRSNUxHRkZRWkkrakhBVFhVVXJqNXJkangvRExxSTZhcVdXNHhValNW?=
 =?utf-8?B?MXVvOW5ZelU4UUNnRHd4eHhEbm1lb25ndnJ5d2tiNW5YZlpseFJ1d1NpRkdI?=
 =?utf-8?B?M2h6dzJqbVRQZlVTOWdqRi8wZjJDRjVKZm5URW02UzdZRkM4OE1XaXFZU2Nl?=
 =?utf-8?B?a244QTVYc0pEa0ppRlVjcWE2VFoxZzNXY1IyaXlwWWwwQmhxWTh4MHdtaFV2?=
 =?utf-8?B?TEQ5enBUdnZCbVhNczVYNk85OFY3disxSDhwczlLeUJleTc5QjhkL2ZZbXdC?=
 =?utf-8?B?ZFdhckhreXpuT0ZpbG8zNUpmWWF5djFUWFdraEpjSkx2WmJtemhvUGNGWWxp?=
 =?utf-8?B?ZW5DYklSeUE5OHNnT2gyZE5veWZiTGhYZXlFekxTV05EcVpiS2ExL3pZUU5u?=
 =?utf-8?B?MDNjK2t1bDBuSXIxTVk5UDV5K3NzOVA3dklmTjc2REJ0WUNKejltajc3ZzhB?=
 =?utf-8?B?dXpHMEZtVDZyZ1Mxd2RISzRrcS92YUFDR2F5UmZKdG53RWY3QVFMb2F2VlFm?=
 =?utf-8?B?WGZoUURCMVYxaXRYZUJlNENoUW9iZDEwSE9nZU56UnhCd3FPUGg4eklTQ1dG?=
 =?utf-8?B?b2w4UUZWMTc4eFpid1hvK0ozUWhuTVdFWUVJTGJBbUtUcm1LL0hyVzhqVGgr?=
 =?utf-8?B?SW1SbGpQVUd1c0s2U2RvK21HZU5KLy9jc2ZTbTBHV1JYUWs0RU53dzBlZEFj?=
 =?utf-8?B?QW12VXhYY2w4ajVyZUY3bEFzYTZHQXFEZHlUMllaZDQ3SWJOclNKQ3V0UnRx?=
 =?utf-8?B?ZXFLOUZDZjdrcFVMOHBZQmpaSWcrQ055ZlpQdGtObU1qd0F4QzdOdklVcTJZ?=
 =?utf-8?B?OTROMmNSZW4zcFU0d1doa1p4eGptR2N2cTZ3K2VpTnlmQUhPdnhkY05FQ28v?=
 =?utf-8?B?cXEycEZDZTd6WW1QOHYraVZTZGZ0N3IrVnZQOUJlS001Qm5CRnYrV3N0N1d1?=
 =?utf-8?B?cnZFQkdQSERMeUhoRG1sczFiK3JXL1BWUU1TeHUzTE00RDVZT0RDOFdNWCtw?=
 =?utf-8?B?ZHlxQWt2L1FpT0N3Q1NRMnVzRU9MQXhGVk9jblE5VWluSlI2UGRNOTg3WGlE?=
 =?utf-8?B?MWlLNVJDY2V3QVRxUXhIakd5OHI1RFAvM0JYdDNyUGthU3hRZjgvdUkrWXcw?=
 =?utf-8?B?dDloREc3Y2QrRmE5aVFSMm95NGtEUjRJV0dNSjNaQlV6STR5d0Z0TGwzbFlI?=
 =?utf-8?B?Z0N0dW5kT0Z2ck9xNzhVeHBaR2VMVDdlOWtxcVk4T0o1a2lhQzhadkJrNStH?=
 =?utf-8?B?bitSV3RkOUhkZ01RN3Y0ZWNBT3YrNkc4UkFhcStKczZBc2FmeDJTdDhwc2gw?=
 =?utf-8?Q?23m7vH19zgSUECSpRlI3yzHMIPtaMqP+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUphUnh3d3FCVE54YlNGQnViSlh5eDkwQ3RxWVBrUXBpeGFJbkExRXFyQnpS?=
 =?utf-8?B?RjlUSXdnV3VxcmIvekZneWd0UVo0RUo3enAvMHM5RStoTG5PT2E0Z2xIajJa?=
 =?utf-8?B?U3lHa0pGcklqaGRHS3dqcitZdXR5R1VJeWFvczRYNGpJc2R0VmxQdUFYeWd0?=
 =?utf-8?B?RG9WMEhNazQ2UFNpRGwyaHcrcUJuVzRXbktCT2VLUE5JUnVPZTQ2UTRzTTJV?=
 =?utf-8?B?VUcyMDNiclFvc2NGS1I4dGc0UEdpNmF4RUw5KzBURUlzNnUvRWFwMW96NzVZ?=
 =?utf-8?B?S3hHNGpyRGJEc1QweWdZeFZ4TGViRmxDeVV2MGNuS09DYjZMaHk2eFEzV09I?=
 =?utf-8?B?MXNWMDh3SFdkYVVKbmF3SWNyQndpaXZOYm5KbVorNWk1UGwrREpMS2NSYTh4?=
 =?utf-8?B?TlVESkVzbjRaS3pOSFIzZ3k2OSs0RnZZRk9YaFNpZ1hjWXcwYm5Cd2tjL0RS?=
 =?utf-8?B?NUtGRmFBQjc1WG5RVG40RzVtKzE3MGo5akp6OStYdGc5ZXlQamlYMkM4emJY?=
 =?utf-8?B?dWtmTjdYUzBEVE1JaWFock1hQU4xWkllSlZqVkFHa0YrS09lcGtvc0gybFVM?=
 =?utf-8?B?R3FrdlZHblVBUjE2RlA4ZVA5VVBWYXNDSWFJM3JMeFFJQUZPcUZwbXdyZ0My?=
 =?utf-8?B?Ni9kUVVTR0xhd0p1eFJ3blR0b3J5TnVvRTlhM2xQMDRaQ1FwOVF0azZVQmt4?=
 =?utf-8?B?MnAvaDNQbjBoMVBCTUtYZCtpaGw4U1BtTWxkaU1EeGZDc2FtMWw0TGYxTUVU?=
 =?utf-8?B?MERpeThiZUFSc3ZiZjNWcFl4SEZkYW41enFPNngzQi9BS1YvL2w1REpXcEQ0?=
 =?utf-8?B?ZTZzT3lWbXBVSzJNSDdQMCtGMzlreGFGc3hWWG1FNnRmRWF2QW9PNk44YzMv?=
 =?utf-8?B?M3BXOTZBTlQxTlVtc3pIMEZGSm1FMVFmMUtXRENmYmtJTGh1RzZwc3dwa0VB?=
 =?utf-8?B?a1ZUTDMrSjlKZmlyQWNKZkRhamh3T1BvTWhkTVI4MjRUVEEyQ0FTNCttTmVv?=
 =?utf-8?B?QnpMN2ZWN1c0bVh3T1dPb3F0R3BsNnpMdmFyN2NkUHAzbzVwZjFuZzc1cFds?=
 =?utf-8?B?VmZJUGhOZXhmSThmTmduaHFhOHM2aE1TMW9XL21OeHkxOEtjdWFvYkE0eVc2?=
 =?utf-8?B?ek1SM1ZRd1k1SUFKVUVtcUJmVVh2KzUyK1dEU2V2UVBSQm1JZHlmeUZ2T3ps?=
 =?utf-8?B?NTM4UHBzT1NWR2RqODZtQThIRVJ2aG9MemRMcy82VjVUUVBleEJZL3VYRXFn?=
 =?utf-8?B?V0RidkEzN0dBMHBabFpkUVZrVkMxdHp6RDBQc2pRUXRneXJEL01GSFVnNW4v?=
 =?utf-8?B?Q2lpZFp4Q2JMWXN4QTFaQVBPdGpVaEV6Uy9JUHdublJCRkNIZGwrV2xSTHUr?=
 =?utf-8?B?dHBINUkzWXRPU2l6V3R4Mkd4UHNTVkZ5MEVRSkpDc2RPaWxqVDRZNzdMNkxj?=
 =?utf-8?B?N2ZnSmlTMklYUlNweDZHUy9nMTM4SmxISDBJTnFpQlFVNFRzbTl1Y29kdm1M?=
 =?utf-8?B?YnVrc2FYU0RoTWVNUjRMdnBEdHh5VmNsS0xleVA1TFN1eUI4Vm9LekhnRTVU?=
 =?utf-8?B?bmZ6aFZuUWF6akMwVU1kL0E3cDREWkdiaEdWMXM3S2ZIejRpRWlWSUNYdWVx?=
 =?utf-8?B?UjNSU0N2N0ZlRGFUaUJGNzRJa3k3VFFnUTYvd3QzcXltdGxzYStrd1BTZ2ZF?=
 =?utf-8?B?RmhrNUt5VFFPVlZPWGpFZjY3Ny9vczdvNXZ6aDE2YUxUUWVKZGJxczl4OXZO?=
 =?utf-8?B?YlRKV3JoVUhnRGczcm44ZHM3bk1qbTlrTWhvTlo1c0VpVllLd0MvaGNEejJx?=
 =?utf-8?B?NTJzbGRRVE96bVAwdllQcUxyTHFhTDhsSG5hSkkrL2RYdUpuR3BhMkhRS29M?=
 =?utf-8?B?T3I2UHF4ZDVTY29zWmlOT0hId25IbVd0T2dCWUlrSWxITEczTUJZQnZSNDhu?=
 =?utf-8?B?UG55T3NvYjcwbFhiMjdteHVXRmU1SFFJUnBxUzJYeVlzOTRqU3JkcElPZHAr?=
 =?utf-8?B?UzJmNTJReUpJUVdQVEYxNWt3UUxoWTM2eFVwWURSWUFjOHJEK1I0OXJUOGdM?=
 =?utf-8?B?YWE4M2RkRlBiTnlySHY1dVc5aldEblRhTzh1NUYvRjNtaGZmaXAvTHYyZEZX?=
 =?utf-8?B?Uk1Wc1REQUxOdnVvL2c1c1dPUkhXMHcweHpubGV6aldwR3JSa05KbGx0UEpG?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fafe9720-4c69-49ba-252b-08de36da305e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 04:19:47.6941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjp//BnqxjjNVPvI/wF2SBxN6iQZLOv21LjjDjty9wZO6OfxpjU40jlY//8MY1DTke5kt0hv3LxOOK/J+JB4Uj5Qs90E2Er4h3rqVcW4gVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6285
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Drop nr_configured_hkid and instead use ida_is_empty() to detect if any
> HKIDs have been allocated/configured.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

