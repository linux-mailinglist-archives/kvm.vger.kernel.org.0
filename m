Return-Path: <kvm+bounces-67193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE2ECFB78E
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 01:30:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4ADC93060268
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 00:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2621DED42;
	Wed,  7 Jan 2026 00:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glceOVWe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81F526290;
	Wed,  7 Jan 2026 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767745741; cv=fail; b=IGhz4hQoIePwYHBcHC/KQq7kZSA0hq1a12TMhm6FYcDfrRCTB1qBBH1WB3OEx8d+0otUe0m/XID8Hl70DiDPxui+2ZfChdMomfWhUqA+h1zCUK1K0lsGv7tXVr8hfHcXq5YcawYgtmpnGi27qa+4J6uXIksDDYZbHVcmysCXRjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767745741; c=relaxed/simple;
	bh=PHwZAA4NkpWGHQa/i36cM20hsEK08ZglL7kWiER+rdE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tfT/6req6dIn3EL4Ld10aEjuzKI/Rgip6qFBafTd5Eu6WiZTIvppwubbkpQ4xWYDgFRlznq+flAGJtcaS7ymkHpA1eKnBNR0TryOG+Jt6VICUF0Cb7kIvhEao3GzcSVu/J60AcdU0txSeXmkpLkCp0TjY9zMWJU8X3JsGCzp+gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glceOVWe; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767745740; x=1799281740;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PHwZAA4NkpWGHQa/i36cM20hsEK08ZglL7kWiER+rdE=;
  b=glceOVWeWy/DZNmBFbH/br4hUlE5GjF/l2zTPNLSmUirAEOSpNOjIXTG
   mvyNWCHGWFDov7giZ0kPaChmXDEvVUxmnqlgAOXM6+BIaU33TqWQjV17u
   ze1xDuwd0ybmEPRpx2Q37j5YpGyL3Ac6wiFWK9uOVmjPhUGqwCgP6zzl2
   ZErQTqfSis9gExLdlb//02Cfp5qWOh8cD9YWsMuOrsbqU5nsPVkbTDiAt
   +q058m278nZnJ4KyQLOkwKLCGFwxXGE3lVPAGOf3Ms51+Tsy+ZaBWDgv/
   wXG+qPmDwFtPaBPt3MZtxCNQLASyu+/ykfbpbcHBvGQH5CZxQVBRgkcBD
   A==;
X-CSE-ConnectionGUID: 0llfSamPQimbIijGYgTYqg==
X-CSE-MsgGUID: N3wwAjBJQVeFHEELf/mFcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="79835008"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="79835008"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 16:28:59 -0800
X-CSE-ConnectionGUID: nb6EjaaZRaKj43t4IvwPiQ==
X-CSE-MsgGUID: ZvPS3tRAQ/yHSusTDgEnlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202394174"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 16:28:59 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 16:28:58 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 16:28:58 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.49) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 16:28:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZpdpHIUpSK6rhiBofNBJXmTDM2vzaoeW/Uv/IA3Hu/vGRAk02QyMMWZkG+R26I3skisQlphbo//rvEmOjwukHZ63XvxYSGh7YNhfWeR/MOkmfknb45crdXCewmfotMjxmCAjfioiM6HoildFszsf2jeqfi/C8X6eo/r3xp9rOxX+Kezqjhy7145UJFLWHjUkDBdcdinALIKnF8h3tK+/JSNt6nj7Sz8jTDode6XrR/kUyu5zXBnbUzhD84ZD+ADVPZOsiwfl1hNpFw59ZE4B0/PLduE/kDXYPbJedVDfIlBHKtr+8y7u3oeD7XWu5UFq2y1T5c5BwPh+gxPa/dtBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvtSrQW9/wpxd3DN5rRt0HOZLRMHjCiOkiHJTbXkrbg=;
 b=IosJSUyOpQs3UeE+gt/e4XDpnHsqShMJwEOVPwSbAdq9/L8yGNgsSp0jpfqp/aOr6lE68PmU5jKZKa5DUVpxYcOIk2+xU9J462GYFJEi2GUmSg4PDC98eo+3eC+du98es6wOf4KivPWOTP2bJbc3KMR/KxQcDXYbeJa9ba/XfVZwwhE/r+eJrLfUY01CzUG20fKBQHT9Z2TLR80QVkJdyeKuYZqZEHJY0ix4wVTumSPXopmiDjEjqm0NgndwlShnZQC83sgIuuir2zue+3zbFtmxPhFHwTOaTYho1ELGEsXy+fIZKINQ2j/W96GeQlNz4WwZUeGT1PvG8HHbWpC4Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB6723.namprd11.prod.outlook.com (2603:10b6:510:1af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 00:28:56 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%7]) with mapi id 15.20.9478.005; Wed, 7 Jan 2026
 00:28:56 +0000
Message-ID: <c79eaf34-766e-4637-aa09-7eebbec26e0d@intel.com>
Date: Tue, 6 Jan 2026 16:28:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, <x86@kernel.org>, <stable@vger.kernel.org>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20260101090516.316883-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a03:505::25) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 541a0ba5-06a2-4a1a-562f-08de4d83be1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Qzc4U0lKTlFUQm9xTlp5OEVVT0w2R2pubVNrNVd2Z3o1WVBCUlYzVmtPVzR6?=
 =?utf-8?B?d3dKbU1mYkprNW5QNXpnUExiT3NGRkY3RC9SZlhoQVM5c2RZYkoyNjBDWHVk?=
 =?utf-8?B?bTVlcWdScVVVTDh0MlpOVUUrVkoxYUYxbmRnNSttSEJIMXRlNVFZT0I2V0lK?=
 =?utf-8?B?cjVEdjZCRy9LZ2h1Qmh5UkhsWmpLb2lFYmoxS1U1Y1Bpa08rRURGUlNCcEQr?=
 =?utf-8?B?NFdzdGxYai9lYzJoaW51aHdHL3JxNVpiUGRUMmJ1UnRKWTU2UHJxK2ZoSFJq?=
 =?utf-8?B?a2dqRStXRUV1Y2d4b2swU21PYXBFSCtZWU8wNG5VbnNJRm1ldW1YazV2MFlX?=
 =?utf-8?B?UGh1UkN0cnFUeElmVjZVSWNTb1U4YVkvcFFTdWl2by9QWTJoOW5ZRGpXaXFS?=
 =?utf-8?B?RzBuYWhzcDEvdU1ucTRuY09QbkZPdThEbjlZdzJ5RGU5T0VKL0FlVmxtSEIx?=
 =?utf-8?B?a0E2OEJuNWJxRmQxbkpiL0ZvODQvRm5xSGljMXVnWVRZbTlUaHpZdHk3YjA3?=
 =?utf-8?B?VEU3azdQTDArbUZ5NTQ5N2xRaURxZkpnRjZ2cXkvU3E1bURPUUNISCtHNkdG?=
 =?utf-8?B?eVBqZWdFNXRYcGszRDQwVjNlSWN4RTdTODFtc3V0ek8vcHZheFJNZU94a24x?=
 =?utf-8?B?ZDNMVmxjZFpUWDM1OCtYc1JSZFFSSEd3RFRNeDZrRmxMUGEvakkzeXdCeVpj?=
 =?utf-8?B?R2pkRHJZRDFNMmZzOXMrem1GT3BucTRvNmhhdDQ2SmF1bWE3KytFV3VTdW1Y?=
 =?utf-8?B?amc4bWZFK2ovT2hvakFaWTl0M3V5TUk5T2hpR1JaRHhuN1FsTG5HanUxalpP?=
 =?utf-8?B?MjJSbTNzZ0srakpIV3RHSzg3M0NhOGUySnl0WGZNSCswWEZzekpmblNBbksy?=
 =?utf-8?B?cW5tSXZWb1RFRFMvRlhLcTJtL1h5eVhadDFWQk1MYTVtZTN1V0dGeU9tdytL?=
 =?utf-8?B?MVpoVWhZU3cySkVxMGJXbWVTZURuWi92ZCtWb1VVUTQ4VzhxQkl2STNscHBW?=
 =?utf-8?B?emt3cjNBdFc3Y1lqdUpaTUwwNXBsSWZMOS9GekJwSWZibHdtam1FeVNZZ2d0?=
 =?utf-8?B?ZmpDVC81cDNxbWlHOGFQM0tHSnVXZy9xT2dnZHBlYUNIRTVmeXpTd0dDMExl?=
 =?utf-8?B?V2gwSHJ0cit1ZjBhZGlpS3hacFJ5OE9ocVBaaDM5QncyWmlmWWJyNmd5RzZm?=
 =?utf-8?B?N2pYTjJ5WWhTVGpsZmFHUEhEUCs1bFVDdWlhSFRRR0xrK3NyRzRZSDhTQzRn?=
 =?utf-8?B?WTliT1d3bmk5bVB0R1RheldjNzdpNU5nUHM4aUtWenlERTJ3TU10a2lWdGky?=
 =?utf-8?B?NmF2ejRNSDhkTE83YU5EZFhuNVo3WVk0MVdBY2MxelUwN0pTQnNjelE3aG5X?=
 =?utf-8?B?eVBkdnQwUmMrckJJaFJNdzJtQ3U3N3JQRXZHSnFkSkhadUUxMFdPR204blNT?=
 =?utf-8?B?S2c0MkNnSU5uVm9ReW5nRmdhT0puNEtOdndwVEVZdTFLU1dEV1E0djRvMXVi?=
 =?utf-8?B?eUtUSWUwMEJDY1Z6ZDJNWnBWNkcvMmdZZTAxRThLNmxDaTlaVjM1MGZGTG0r?=
 =?utf-8?B?RGJjWVVsdEFFbHo2UmhPK0tIaGIxSXFGdXhqcEdoY05UamN1UVB5MThKTm1I?=
 =?utf-8?B?REo1RlJ5Um9OOGgvQTh4Qm92bTluY2NXem9ud2dvemtIUHlTZnlUN0hqdmRs?=
 =?utf-8?B?bTE2ZGM3Wk5mQWNYZndpbElvVEhqVTI4WWRTNkl1N0F2L3lnVjdxd2dUTFRH?=
 =?utf-8?B?YjQ5RGZpajRtaStJWVB5dEI3RUt6MCszR0VIc2lZaUlxNW8xWjRWaEROUGNj?=
 =?utf-8?B?WXJJMWF5eTdXMkx0NmFET05zS29DWXFrYU85ckNRdHErRElBWGRJMDRSNzRG?=
 =?utf-8?B?b1Zsc2Q4aDcxM1FKQ3d0V0NHbFl1TTY3TUZTYnRtUTJwMnhtclJIYy83d2hL?=
 =?utf-8?B?M1F6YTU1NUhvdUVqOGtYUjBxbTFyMkNLZmJnNCtveU16M2sxUmd5dldsd3FL?=
 =?utf-8?B?VHpwRkpMd2tBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REZIQXFoUlN2Y2ZYb0J2dldmbzNRNlVTbmdyQ0wyOGcycTVzTjdxZ2NneHJT?=
 =?utf-8?B?Z2ZCUTJ1c1REeVpTbE9HSTUwT1QxYWovZFY0YmtwSGd0c21MUmhaZldVd0RO?=
 =?utf-8?B?alpBdWhOL1hlRkZrclk3c3I4ZXBWYlBEd09BMTYrSlJzU0lDRzhzVnFpSkk3?=
 =?utf-8?B?SmJqZndRUEZ6eTAwcjI5aWlzSXhQWHZBMWpSTkdUL3lFMkxwUlllSzE1ZTdw?=
 =?utf-8?B?SXhEeW9BYmNrYWwxRjh5d292R3hGbGlmWi9rNW8xWmIwQmM5OG5lK2x0L3Vk?=
 =?utf-8?B?dE90a3dHMnhHb092U2p4cmtFdzRHWWJidXdHdW5JaVJkL2VXUENNcUZ6bUM3?=
 =?utf-8?B?eklydEVvelNtOXcxeHhrdVFUSEpQaUdsVFJoOFlLUDlyY2ptN2l1SGtaUnVn?=
 =?utf-8?B?VmIza2prMGIxNGc4TllIb1B4YktMdi9wMm1wY2psenpYdVZoZnZhUEdKM2FB?=
 =?utf-8?B?WEFreDk5cG1XT0czL1V2TWF3NExXQi9zY1R5OXNaZjlUTTRPeHRieGdKeEJD?=
 =?utf-8?B?TGEvd1RWSkhHSTFtblNrZ2JBQkk4MFBTazR6SWRpSVFBT1ExdXhnY0FiRFhO?=
 =?utf-8?B?VXBvM0kyOHVKa1l3MHhLREU4M1FWeWFvU0M3cFhDcEQrTURHQkUwQk5uQ2hX?=
 =?utf-8?B?c0JvUFZkUDdNN2dpUmZJNmxHZnR3bzQzekh6MGFIaWpXNWpGLzdaUk1HRS9w?=
 =?utf-8?B?bGxnSnRQd3hmM0RudmlWdHh6TzNNRnhNZFlpVGpZV2JhSjN6NHB5aXVvbDJY?=
 =?utf-8?B?RnBJRE8vYlpXZWI5WnJ6Z3dCc2o2MzcwL0JSYTdCSmVTZG40Vm1rT2ljcnA4?=
 =?utf-8?B?NnlQSkRESkRqQTg2Zmk0R0x5aEo1NFRKemVCZzVJMkU5cHlqMzNRU3RiamtS?=
 =?utf-8?B?a01vYVR3Nnp4aGpTZ1gyWDFpM29vU3g0RHlTWk4yWGVKdEh0K2tZMldlbVZS?=
 =?utf-8?B?MnRNSGxKMTEzRGRYM25GamNMNUVEa0VwU1lnNWU5S082Y3EyQVI4cUdTUE96?=
 =?utf-8?B?YXpYZXRTK0xOdU5jTkJENzd5TTNadDNKQUk3bVRQUnE3ZTcvMjEzRzE1bmtl?=
 =?utf-8?B?TFdxcms4VXozWnRtd2hWY0JzUDl3UGVNcjdwbENNTE1FUzU3YzQrK1NBNmRC?=
 =?utf-8?B?VU1DV1UvUWVUM0tENTNEMUd2dVIxeDdPM1N6TWZRaXhFdEYzMVRXNngrVi81?=
 =?utf-8?B?cG55M3lhWmZDUXdPbFJFVmI1V1hxZDk2RUpTMnZRY3RxV2V5aHpKa1NNdGZm?=
 =?utf-8?B?Qm1vR2MwcXBIanNLeGdPWldKa1dxQnA4akxkNnkyd1pkTE5PMmlRVnlqUEYx?=
 =?utf-8?B?djQxYmx4T25sZGdvTWlZbU1RbEpvYjdlWkIvRDkwc0NGd1hzckRTWEhMUlFP?=
 =?utf-8?B?bmYzTFpnczFhM1FLZzRmYkdsbHAyaGt2U2FmV0swT2pNUDZiS3prMHNTdFB4?=
 =?utf-8?B?SVB6c0RIRm9aWEJLaHFjaWg3WDJBN1ZzL2N5VmhUcUhpNjg2K0dDcFl3WXZY?=
 =?utf-8?B?RHBMVXRTMjcvVHNKS1hsaEQ1d25PTXpzQmFEK0hQNkU1WHhjYkEyazk5aVkx?=
 =?utf-8?B?QUtKYnlkcE1GNzVmcXNxc1BqU3FjRTdPU0pjQndGVmI5emkzMmpYVTZteGVD?=
 =?utf-8?B?L2JySUV0MzEzcDBtdHF3WHo3SjBtYVovMEVVTTdnNGJEWHVUWHhPSk1Hc3dE?=
 =?utf-8?B?VXpsV21KYkIyRXIvNTJMb1hzamxrWXdQVVdoSlhMa3dDVUQrMEhHRDZWd25K?=
 =?utf-8?B?alBsV3ZJTzBWUTVYcFhoTFl3UHoyaHdRSjdiTFMxQmVsazJjZVAvVU5ta1Bo?=
 =?utf-8?B?RXAvMEVYcUtGQk1WMW9nZlhBejR1SVZKZDdzcDRqNzh3T3IxQ1JmRjhhQXR2?=
 =?utf-8?B?ZFRZclZzMnc5RVZsMmpweVpJVDc3ZTZMdUdQVTJxOGxmb2ZWNmtweGJOeUQr?=
 =?utf-8?B?VE8rUFJORnEzK1BZeDNYZGJlRVhoVWhoUzJhbmNYL1VKa01BUG1PZ09UcDNp?=
 =?utf-8?B?Um9HdGNiMGtSRi93RDNoeHB3Z3ZTT1pKcFFjUTZMdG13ckFkUGhpc2cxZmdj?=
 =?utf-8?B?NkNiWnlRWE0xRGVUNjlZZG9KcmVjSmFoVVZRRVpiUWcvVWxrWUtuUlFoWTR2?=
 =?utf-8?B?NlBzT0s0SjNZdW5nV05uZWlyTEp2OWlYSm50azhBNzY5VW44dkJDUWhkUENj?=
 =?utf-8?B?VXZlWStUZWZ1UnZCRDFVUGhZQVhyTjVSK1JMVXJTbEg1T1h6RHVuNWllclZL?=
 =?utf-8?B?bHRXcENZZE1vSzgrVGlSUy9tUDhoT2tUWktvZTF0eTlycFNVMzNZVHRFR0ls?=
 =?utf-8?B?cFZXSVdxYlo3NjRQdTZXalhkWThrZ1F1RzJPd2FoMHBPQlBCYTUzN2JQMW9t?=
 =?utf-8?Q?AGnry2gTKeYGY9VE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 541a0ba5-06a2-4a1a-562f-08de4d83be1e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 00:28:56.1110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rj0XT3KAwfpg/XvMRmAtskofXU0JhNeMHM1vGp3n5s5uyYLCJpbj3YwRvwEXI7pDF0c+9nrdgPtMQTOLpmijdBUotlG6ORvon1GpVUHWWNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6723
X-OriginatorOrg: intel.com

On 1/1/2026 1:05 AM, Paolo Bonzini wrote:
> 
> Therefore, XFD can only go out of sync with XSTATE_BV in the above
> interrupt case, or in similar scenarios involving preemption on

This seems to restate the scenario already described above; I’m not sure
whether the repetition is intentional.

> preemptible kernels, and it we can consider it (de facto) part of KVM
                            ^^^^^
I assume you meant 'we' here though, you might want to slightly rephrase 
it, given the previous debate:

   https://lore.kernel.org/all/87iko54f42.ffs@tglx/

> ABI that KVM_GET_XSAVE returns XSTATE_BV[i]=0 for XFD-disabled features.

On my side, testing on AMX systems, I was able to reproduce the issue 
described and confirm that this patch resolves it:

   Tested-by: Chang S. Bae <chang.seok.bae@intel.com>

The added guards on these paths also look reasonable to me with the 
established KVM ABI. So,

   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

Thanks,
Chang

