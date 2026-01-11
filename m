Return-Path: <kvm+bounces-67677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 301C0D100A6
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 23:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6D1CC302E631
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 22:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDBC2D5412;
	Sun, 11 Jan 2026 22:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jdTlRnJR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D39243964;
	Sun, 11 Jan 2026 22:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768169741; cv=fail; b=MH/4DICBrrWXeDYUtWvd2Jnm31xUww6JmumiKtUhF9KUFZZy18K29Y98cphQhTs1xF4j/jC05xlsJO4lBP4ofzhXYrg6uvv9eHeFN+kWHAgoKA6f2iOzN85Im004wxdTSgW6QrDswdls1cY6FIL+nb4zIzdRvAUK4h20uSbYLWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768169741; c=relaxed/simple;
	bh=ZRHYZpGa40PLmPTKSLnXHkQR2eoS7+NpuJwoX5P9s9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T67YUXCJHyZPerLSP6S2pg2+sOPh+F9q7Qo3idsNq93ySzwxkoOm2fJKsafR+RU2pVtTKc4Ieayga7gP97rtYaER7xymVvzdx1WjZDIH56lEBMKCrGU1TQNBP+OCLuPwVPOBjFcJjfDZp511vUpy+W1lyXGgNQCQFqSrXJF/CHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jdTlRnJR; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768169741; x=1799705741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZRHYZpGa40PLmPTKSLnXHkQR2eoS7+NpuJwoX5P9s9M=;
  b=jdTlRnJRHVGNyf+s5pGOBZxmCIjvOlaIfMeUKUsGhc4015Lrrwojs5aS
   NK5IC/IKy9Hy1k6Xq3VXr5i8ofFIsodueN9kr6cHmAHByM0en2SW2x3iC
   ObFxx7mH6S9QZcVQlICemktpXKBoM0D8+CzaSt5qTNp++1PL+sLbfr4AV
   X9lm6TE5Zx3aUuZMR1uQMDl8YBc7Skz5G3GzD3Wic12rMbeV8l7HU+1Kt
   Cvq72D/n5dJP/Ce+J9Dvd/XTB5JN4EqetddssHfja028kdVChl5E4wJfq
   25fLSkywOV4bowBS4V0C/K5HV+f5/ueUy6pLNAjEnepU0awzdPHl/o5JK
   g==;
X-CSE-ConnectionGUID: 4aDucVCORiGJ9bMEVAaFRQ==
X-CSE-MsgGUID: p+EtpSO/SySOuC5AMPz69A==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69366991"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69366991"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 14:15:40 -0800
X-CSE-ConnectionGUID: 9BsR2CE5Q1mXpoTleq3lCA==
X-CSE-MsgGUID: +GxdgSpXRXKBeGUPsHEBQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203739418"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 14:15:40 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 14:15:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 14:15:39 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 14:15:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ulnv+NPqxvvX+kHdiM6YzHS14oF39NO+3x0HrkatpY6FT1s1dcccOI5Hx4lG6jFsEb+LuLr+qXUzv+bqWOszyCvRx4xcm5zyPOF0rConWMxsBobPZJmHioscIbKTmLg+1/hC3HoyToMKxZSi2Htv1AcfCRGGSDIEa+55NgsukJFoUFEFS0MCuDkSFi+Nq0IurVJZMPANl9FlReSiHZW2CbFBIMOH52I5d5dtyuebWC3p4mUlUFwm7Ba7N9t8QM26wgSYgc/rpqzMJRRO5JVIzhPasXngF7hFnqaANxIZx7wF/GE5BoLBIW3h17+tredsKIz7LkWXA220XkzukpV1fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRHYZpGa40PLmPTKSLnXHkQR2eoS7+NpuJwoX5P9s9M=;
 b=UWaYrWY76wP7IUlFI4Ld7rgCRIWy6JhFHZUUjo9h7bNoBqPJQRsNMC+TenZiUYMIc+G/COZ6XEPnLXB2u5mFuu+ZBRjNJDjgMZiEpdggZ5pHG1PDFpCWewQ3yklQqWNMGnDkt3GA6ZPqodu/1RJQnbQr21oy1Szlp9j4274dTGK7BYwRCFgQbG/sXoYLwC6C3TGtfnv8rTn9qXIRUJyxQrUl1rQL55KSu+ouEVlq7hgld0K3AE65WXV2GS0WtkI7BfBWx6/QroS402y143vamT/ZcZ95u4+OFU+DPJmNnXrQe+tek017nX1e0BEW6fglPKC3FEi5cOmVS86jufrv6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7730.namprd11.prod.outlook.com (2603:10b6:930:74::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 22:15:37 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 22:15:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Topic: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Index: AQHcgZw9qbcQKpS8Gke0n3vObG+xu7VNjGMA
Date: Sun, 11 Jan 2026 22:15:37 +0000
Message-ID: <8282860187d71541e0de8ee10214db4ff53782e7.camel@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7730:EE_
x-ms-office365-filtering-correlation-id: c48f77b8-9fa7-4778-679c-08de515ef29a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Zm9pY2FQQ1pLNjB4azFFVmJCMEp5eGt4eTBHRnVrcGJVMEdTNU1DYlBEdERo?=
 =?utf-8?B?b2QxZGh0RXhPUGFmbGY2RHF0dkZPNTFra1p3QzBLanpKUXIvWituU3hCN2ph?=
 =?utf-8?B?U1BzbG1aeFRGZHRVZWhKZmVnVEx3QUFLakE5QURscnN1azQrSzk2QzA1UzlU?=
 =?utf-8?B?cE1RaUZLZTZGd3ovMU8rTzY4a2pOMHdtR0lvazVScEtCTTFmMzlwS3JHQU9I?=
 =?utf-8?B?Y2dsNmUvbXRoWnlFK2FPTVhkcHhyTkdWZVdXZEY0QUU3RVY4cEw4bUZKZkUw?=
 =?utf-8?B?dWlsUElxUkZVUjllZlNjUVpoazRVMDFLcTdGSzRlQi82U1I2OUFaSjRuK1V5?=
 =?utf-8?B?UU5LZ2x2VWlRTk9mMEdZN1lLdytGZHVWTDlPcVBWeFRpekhjT1k2bUpWNFlp?=
 =?utf-8?B?TlFQUzJER3dZR1lzUlVRRURUL2swUWtpbEZNaTV5d1NuTkd3SFZZakZtZWYv?=
 =?utf-8?B?WEVvYnN0eXBqSTk0ZnI1Y3JTSDlDR2JuOVBpQWplQzNPb0xlVWFKM0xZTmZG?=
 =?utf-8?B?bGV1OS9EbTVrZnpXYm5mQmxaTk5BUXdsSzZoZWIxbUNGRzhYbXFmbHlRMlc3?=
 =?utf-8?B?YlZtMFFHUjlvMUU2ZVBnMGVaUGs1ODlpYXd3aEZEQUxzVGJldUdZbFR6SEZt?=
 =?utf-8?B?SkZJOHllT3hja25IeVExR1lCM0xCNHMxMEJVcXE0MGZjQnloT1hpSTZqOUgw?=
 =?utf-8?B?eUR2ZXlGc0REVXJKODUzeFpMa1QrY2lOd2NwaCt3Y3BhZUFMNkpqaFVzQ0Jw?=
 =?utf-8?B?Qk03SzAzZDFCajJxT2hlTGVUZWNpSnluOStuL0oxa0NGV0lnMERYcXUxUW1U?=
 =?utf-8?B?aUZOWEpodWdUTzBaeDdiT3d0WktkVlhVYlc4VWlUVDJIQ2pBY3FlMnBRczNo?=
 =?utf-8?B?TDV0b1NNMDlickZ5NUxpeFExRDRhcnZKOTBiSUNUNngxbUpTdml1d0ordk44?=
 =?utf-8?B?ZkpvNVZSZ24rYnlmTkVzd1pieFBEZm9uazNYZDBKMFZFU0xweFprcXlpV2lQ?=
 =?utf-8?B?ZnduUVZST2JSbUZRZENiMkh2Rk4xdE1MTEhlTERVTnJwYUhZemoxSHpWS1Fw?=
 =?utf-8?B?RlJzM2dDaVl3aGRQRkppSUdOQmE5c2J6T1dNclBpajE0TGRkWHd6U3Vzd2dx?=
 =?utf-8?B?bm1hZ1laVmR3Zld1ZUJrWUNCbXB0M1lJZ1NCUUVWRy9OejNwNi8yaE53YmVE?=
 =?utf-8?B?Wm5qR0ZHbUNJYWxnWUF4cmZnbjJQeFpEOWpMSzEvU3dxeC9FWTB4bldma0hN?=
 =?utf-8?B?djRaZTh5cFJDc1gvVDFFS1Nvc01VNkN5ZEpxd3JieXV5VVZiOHZ5QzR2Szlw?=
 =?utf-8?B?bVEwRkhndHZVTUxCRGwwK2lIaTlBamhlUXpKRmhSV2pvVDdZUXNuQ0JnVG84?=
 =?utf-8?B?cFpwTC9CSndTOFdzZWdZakJkakNBSU9EUVB2MWwybHc5cjRnSDdnVmtjNEJt?=
 =?utf-8?B?ODJnbjBzMnBIc0d3Z2g1VFliMnBOY1ZuZm1ZUldadW4wUGdHVEZXdzJDd045?=
 =?utf-8?B?R0c2d3ZzaldoajZoS3hqcDRyd2g1dlgyN1lhUEZvZ0xOMVd6Qk95QWhvcTI4?=
 =?utf-8?B?RE1Sa0FHa1h0OC9GSlhsandsZnVzbDFBQUNxeUpuMjdUU2JIOWJrTXAzN3lR?=
 =?utf-8?B?UkpFYmo0TjI0UHRkNUJ4RGh6c214MHUxV3pjbjBhTVAvenYzankzVjl4WWMx?=
 =?utf-8?B?YXRHL0tnN2dONjNUdjhMOTFmdlJDM2xyNHg3ek5IOG5yZnBiZzNxUzhMZFV5?=
 =?utf-8?B?NTg0Y2REYTEreVZ4S3NhajM5TlQ3U2xXN0I3U0Q2QThrWHpSNlZWUkZHQlpN?=
 =?utf-8?B?VTZhQ255aDdCMllQeC9oK0RPMEUrQUFCNXN5SWlqTHdaYkVUZ3JIMUtwc21H?=
 =?utf-8?B?b0czYVA4WnFUN0o4VE1CVTRBa1BPODU5Y1o0VjY4aDdCZlRINGhabm9xclNM?=
 =?utf-8?B?S0hPbmZOS0Y3dlJQV2RqZlVnY0FpM1Z4UXFvSHR0bjhBWHZmWEdMdnpreHln?=
 =?utf-8?B?NWZsNGhjakpKZC91Q2I5MlFKYTJLdHFwYWdLc3EvbE9BSVkzM3JYTDcrTHJz?=
 =?utf-8?Q?LgIQyP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzJlM0FxNnVKcnBUMGpER2NyU0tTb3d4ZHU4QkFoQWNOdXp2blVGQjNXeWxP?=
 =?utf-8?B?emZOTGkzWEdCSGw2MDU5S2FNOWZMNEVVOVFYWno3ZFF4WGZIMFZuOU1PUjUw?=
 =?utf-8?B?QkxMQ0hxVlhva21jTGExZlAxMExEei9oblo5QTlPYnFhVHlGWDg1dURzVXRL?=
 =?utf-8?B?dFFmVFVPaFZmTXkyWEpwbUE0UVJCV1R5L0RRMnEvWUZFZURwNU5EUTJTOG9y?=
 =?utf-8?B?bEw0WGNWclgwVzZFZTFNTEFNY2NQWlVIR1dyUXRCWWttdWVzRm43dWZTdG9n?=
 =?utf-8?B?YytueHJ3OUxBOTdYajB1ZEkxVjlTR3VoTUcvUDBBMUViME5IeWpyc3k5b0VW?=
 =?utf-8?B?MHNIQUJZbmJYb3Vzb0JpN0FFOHluMHlrN1B2WFNsUEI4QU1JSGxuOXFMWXVT?=
 =?utf-8?B?UWpBc1lHREQ3ZVNVUVJMb0dDeEJML1Z1UHY0VGd6dDZwY3dyZnZOUXBxSUtK?=
 =?utf-8?B?UkloOEJuQXF5ajEyclo5aURnQTNDM3JpaWU1Tm5MbkdURm9DUlpZWHRtWXN5?=
 =?utf-8?B?SmhIc3JxczBIbUdJeG0zbjExT3NNLzhoZmtHU0JocjhjV3VubldwRTAyRHBa?=
 =?utf-8?B?VXVwOW4rWEFjYUg1cW1UTnlIcitOYmtKYWhMV1p5S2dBY2R4QkhrNGRmbXpC?=
 =?utf-8?B?eFdqNHpKQXZPSlkyOHdyclNpZmd4anlIT1AxY0lldzFmWEJueHdTcklmd0Iy?=
 =?utf-8?B?SElRYTNzNUJIdjJoN2lxc0w4QXpoZ3RvUWJnZHQyOTF0eVVsZzhmbTh3RGJ0?=
 =?utf-8?B?U3dQcUlKTEJhdFNJdXNDZEt2cnVybE1PUEdaQjMrMlkzcHdoVFlXem9IbG8r?=
 =?utf-8?B?bnRDQzRSZVdTR0N1eWZHUTlwbXVyMVFJWU0vbGZBZ05sYVhJdS9DUHd3K0FM?=
 =?utf-8?B?eEZaQmRiSDM0N0o5SUZmakVmTHYvb1lGMXpSb25KQ3hiNXQ5THVoQzg0NDc3?=
 =?utf-8?B?dkdQRHd0Qk1xZURXakFhTXFWUDZnZ2xqS1o5dkNINnUrdEswcjRQbU5RNExX?=
 =?utf-8?B?R0RhVWwyTURtRytXUnZ2akI2WENZeFNpMkFqNFZVSHhlWXJpOGhML1RFNk05?=
 =?utf-8?B?KzdpbTZiWmZxTm14OWJFYVRxbmFJam9FWTdGZDhEMXNmSFVrbmR3MkhPMXpL?=
 =?utf-8?B?UkM1SUwvSHBUSituaXJCMjdaYWdFb0g4QzZrQ0E5bVhPT2RBckpoQ1AxNjlE?=
 =?utf-8?B?c2cwMS9HSkhoZ3NTakF0MUNLMDBxN0k4N3JJb21xNWhpUVlTcjc0VldBaXJw?=
 =?utf-8?B?NnUzRHpNQS9QNERRVmNRdUhiRW1LTmpGczFsNFI2OTFQN2lrb0dTQmZ2WlZB?=
 =?utf-8?B?eFkrM2t3ajFWSUxUVUZhVGZYUVF3V3d5d3MxRW9FalNVRi82a2lBcnlmYU5Q?=
 =?utf-8?B?STNaN2NDOHZKZWNUMWxDR2x6WEp1dnYwUkZKNThlTm0yUWRERy9PaXROSys5?=
 =?utf-8?B?V0pOQ3dNTDlEY2lpeSszZ3RMYTdHdThvUzBJUHBUMFJ2cC81cnp4OG5ETkNi?=
 =?utf-8?B?bzJkUzcwS0t5bmFWY1FDNXczV0V0Tkg4ZHVQVlE3dGJpTFF3Vy9VL1pHM0w2?=
 =?utf-8?B?dnRCek0xMlJtUlh3YTFIeXIrYkQ0bU14ZjA5SlBGaVd3blg4NWFaaERHV2Zu?=
 =?utf-8?B?N1l4NUFSUEVMZWhIaUtKK0lNNnJJWURBa2l1RlVpQ3ltcGJOMVVrK2UyaWl5?=
 =?utf-8?B?VUhRMkdtcFVXek5nVlhjdGM5R0x5aGVYa0ZNN3ExNDJRZm1Od2orZXc5NkYw?=
 =?utf-8?B?Z0o2aGxZYnF2NzlzWCs1Umx5TUhZWDNuendWOVAwbUtPbkVxY1UxVVR5WDZF?=
 =?utf-8?B?UGN2UHJWVTRKOGtJb29CUi9FUW5TYUpUTjlEa1ZoYWRPcnN1aURSNDN3aWlt?=
 =?utf-8?B?TnlpaENWK3hrRUNhWXZOd0NHdDVCNThSY2V2dDc4bWgzZDZDQ3FKaTdWZHpi?=
 =?utf-8?B?enVHTDdDV2Ztd0pTbEtSVU56NHphbVdMT3pZYVQrbGVSMVpDWTE4ZEhLSjVN?=
 =?utf-8?B?RklJRVhDT3J1dUNFZTdWQXI1bmpITkk1NktPOVF1SXJJa0IyWnFPZzJyR1p3?=
 =?utf-8?B?dFlRTmhiTFhocEtEbWRpVEhxR08xem93Q2lwcVA5YlZ4MHAxZkY3NEtyMjNk?=
 =?utf-8?B?SitFRHFxcnVEU3NLU05wSENNOHdrbjQ4aUhxbDJIWGxPK3d3a1U4VS9Yc2NZ?=
 =?utf-8?B?d1lHL3k3bmUwZm8wZTRJSzJwdXgxc29adWlrWGhkckZPMkN6Ri9WKzJQSDMz?=
 =?utf-8?B?YkhNaXBlNXRDdGp3UDFMc21wRllxUDRCS2l3MjVFSWJtTUFybnAvSHRtTVhD?=
 =?utf-8?B?T3Z3ck54S1k4UmlETE1zWklnb25lM1ZJbElpT09td0lHV2NsNW1sQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7A53506F7E21F44A38A21B94CD4B6FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48f77b8-9fa7-4778-679c-08de515ef29a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2026 22:15:37.2096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tzubKF5SrpRTUn8IWjn/38nvr2NRaU5X4Byctr9oPU9sIR0T/lWnt0i8Zq8oJnOxc54fxlCDzrajH78MbVB6HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7730
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDEyOjE0IC0wNzAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+ID09PSBQcm9ibGVtICYgU29sdXRpb24gPT09DQo+IA0KPiBDdXJyZW50bHksIHRoZXJlIGlz
IG5laXRoZXIgYW4gQUJJLCBub3IgYW55IG90aGVyIHdheSB0byBkZXRlcm1pbmUgZnJvbQ0KPiB0
aGUgaG9zdCBzeXN0ZW0sIHdoYXQgdmVyc2lvbiBvZiB0aGUgVERYIG1vZHVsZSBpcyBydW5uaW5n
LiBBIHN5c2ZzIEFCSQ0KPiBmb3IgdGhpcyBoYXMgYmVlbiBwcm9wb3NlZCBpbiBbMV0sIGJ1dCBp
dCBtYXkgbmVlZCBhZGRpdGlvbmFsIGRpc2N1c3Npb24uDQo+IA0KPiBNYW55L21vc3QgVERYIGRl
dmVsb3BlcnMgYWxyZWFkeSBjYXJyeSBwYXRjaGVzIGxpa2UgdGhpcyBpbiB0aGVpcg0KPiBkZXZl
bG9wbWVudCBicmFuY2hlcy4gSXQgY2FuIGJlIHRyaWNreSB0byBrbm93IHdoaWNoIFREWCBtb2R1
bGUgaXMNCj4gYWN0dWFsbHkgbG9hZGVkIG9uIGEgc3lzdGVtLCBhbmQgc28gdGhpcyBmdW5jdGlv
bmFsaXR5IGhhcyBiZWVuIG5lZWRlZA0KPiByZWd1bGFybHkgZm9yIGRldmVsb3BtZW50IGFuZCBw
cm9jZXNzaW5nIGJ1ZyByZXBvcnRzLiBIZW5jZSwgaXQgaXMNCj4gcHJ1ZGVudCB0byBicmVhayBv
dXQgdGhlIHBhdGNoZXMgdG8gcmV0cmlldmUgYW5kIHByaW50IHRoZSBURFggbW9kdWxlDQo+IHZl
cnNpb24sIGFzIHRob3NlIHBhcnRzIGFyZSB2ZXJ5IHN0cmFpZ2h0Zm9yd2FyZCwgYW5kIGdldCBz
b21lIGxldmVsIG9mDQo+IGRlYnVnYWJpbGl0eSBhbmQgdHJhY2VhYmlsaXR5IGZvciBURFggaG9z
dCBzeXN0ZW1zLg0KDQpCaWcgdGhhbmtzIGZvciBwaWNraW5nIHRoaXMgdXA6DQoNClJldmlld2Vk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

