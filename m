Return-Path: <kvm+bounces-53178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DFDB0E881
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 04:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820964E516F
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 02:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AC01D5160;
	Wed, 23 Jul 2025 02:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hIR7UoNJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6A1ADC69;
	Wed, 23 Jul 2025 02:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753236856; cv=fail; b=scm3BQJCq+F3MlN6bmnQURqskwwLnKkcRXi1RRSO91lvEZM86byYrEHiIIvWtmbJOUJKHYs3BFTZ4wt96Bw7jCY8TcyR5b2R7uHP4bj2XVmaKrhDt+cC7HuRVqFHobAfCbA07wUw52tTjbXGZ5Hm9rmLaPiUgWz8hr3rY37K3M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753236856; c=relaxed/simple;
	bh=RW8tp/XukV+FcPKqUeErTHNmayDFU1tDD4vjn5Nj364=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V0Bskj3wGOuUJDHQX9JuTPizXcypVmZmuZymP9YY42AY12Jr7hwkklnaAA6YyzmZofInF8kVJxGsZLciYT5cm0bJGj+MJtOjaBHREYzyiedZHD+40zvAk2dfl2Je/cWV5dCV1EJH5w3edHf6no9tuWG/dwmukmrK6ES6E9eFKxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hIR7UoNJ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753236855; x=1784772855;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RW8tp/XukV+FcPKqUeErTHNmayDFU1tDD4vjn5Nj364=;
  b=hIR7UoNJgcWmnhFSz7qDGihWgYXPwHWX/VuWPjrLBgWt++DwzbAlZQEq
   OkbxPTBH6sLX+W1eKT+c+74IPD3qIwSBrkhuNsmWI5VDvLK2WmDT3rRdf
   pp/8sSzjd1PcFWy1whf0BDky0+kywFe8BACNqQnfrI+gXR21jYD0odBEo
   epSh0MBzsvjgoSZo81KftgxZDS/mTeDVP8YEi8mXgE6gSUHEkE0RI6vlp
   V1/wapR6ut/Hz0NrjCkiACFu76bKDzyuWYgeGvSEF2cY5wFnp1VWIBCBO
   2b6qESIOt7DlDrPFcyeUdkjbglL6/GV7JlGcsJzozRpdt+b/CtJd0tTAF
   Q==;
X-CSE-ConnectionGUID: fQBmhxSEQE6YuXFF0BMokw==
X-CSE-MsgGUID: E1aZApPPTlao9mJU+DBZjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="54605101"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="54605101"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 19:14:14 -0700
X-CSE-ConnectionGUID: HxrYe3wGTIyTSk0etGgQ9g==
X-CSE-MsgGUID: QXFFkl3HTyi+aesb5WTgGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159863833"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 19:14:13 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 19:14:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 19:14:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 19:14:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YytiSQC/LK+IRzY0ucqTqWEf+PjzcjbInEuhuzvFRm/4vAcp+6XDuv1K03+3aNnHOsqxwkpKYi2WRYRRPMNEDxDLEh39IEGwwe0g9yZZPO6ypEWoaj/jHJIj3eTKeOCYRysTLj6PolZgYJ2q5sU6K3GrM/KB0B3uG3qF0SKhgihwbfUktkOgQdwyLpTAhC6Zl1+SHnJZryP+tiYN9ZqYU2BNzelLv6QIWCv9eviTtBECzD34jKEOj5jH17hmKA7Nh15trkkwizoIefJtoRW6mtE4PYGdTHCDToKIXtRSstWv2QHsqI9NzT1MvHvZXxmY+JW42AWWLH+jsymMGhTdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RW8tp/XukV+FcPKqUeErTHNmayDFU1tDD4vjn5Nj364=;
 b=xq/bV7H1tqv37W930n4v1O3tjbhZmeifekRICPQm2DLDLAsrcSMKjDSY/m7lKCdnw/Ys1y48f2m+M9ZVxXck0MJtmfITP9KgKZ9ngOnte6oCguQfE4/HQlG5mVSwwvpb/3+RjcwpdhU1K/Q7Ju0tMRd0mzfYwJ/3G2kPWgA5Ud/Ue+DfwatculkODsYFeBe+0PXi5IZXE+ZaL/80c7yrce85SHj0TW2DBGAVNnI2NTq5wpan3axrjN17mlp56ZbApUtHxmuZxe601oG1nqcxNNElPtRgLUtQ2NAtwMdbHsFMZvNcOhKYLC3ZFo1Kkun1FbHoNMduBxZz/ud4RCCDMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB7963.namprd11.prod.outlook.com (2603:10b6:510:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 02:13:57 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 02:13:57 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokAgAEjLQCAALyYAA==
Date: Wed, 23 Jul 2025 02:13:57 +0000
Message-ID: <0aa7bc3f4d6f92b10e27ee8f3019d30da8e14c43.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
	 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
	 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
	 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
	 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
	 <20250722145854.GAaH-nLpCa12zaiOPa@renoirsky.local>
In-Reply-To: <20250722145854.GAaH-nLpCa12zaiOPa@renoirsky.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB7963:EE_
x-ms-office365-filtering-correlation-id: 970f627e-9858-49e0-92f7-08ddc98e94ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U0MwUDV5OXVmL1FEY0R3aFRQTk0zVllUeXo2U0pBRElWWjJycld0VGI4bTZK?=
 =?utf-8?B?SkNGblFWakdwcDBxV0lWaFNTUkc4b0V6Tm02UERiNnhFNkRhWXJwaUx1L2lR?=
 =?utf-8?B?NVFJbEZIME44cnRKVGgzTmJORE04ODgzNk00ZkViYzVQeWc4eDNFRGcwa0lw?=
 =?utf-8?B?V2c1eGlreEZVdDdXbUFRRnYxc2ljZ1EvZTlCQ2N0TmpOL2RLaGl1T0dCbTVD?=
 =?utf-8?B?TUpDVlRBK054eXRCWW1HTmh2SXFMajJacW1HbTA5YmFDMk9nWi92cTQ3NW9U?=
 =?utf-8?B?Mlg0V1ZObzNPQzlSVjhUMWpqM21aVnloZ2pzYkhTdXpXU3hWa0gzSHBpOW14?=
 =?utf-8?B?MWFrUEozMEwybE5UTzdqamN6NUFKbEdxOGdNVWRtbEkrNDFobkhCRHlEMlVI?=
 =?utf-8?B?TEJjVlRycTFQRU10ekozL0RYSWIrM0QvUG5pejhsb3hRdlF0ajI3clhORVdD?=
 =?utf-8?B?dUlHdXJVTkhva3UvUTQ0TkFvWVB2bG4wWkg0K1J3Y1VlWXpiZEtxdWo2a21U?=
 =?utf-8?B?TE5ueFNYbDBnbUtqWlMvMjBDMnRobnFQa2F5ZHp6SlJuWWdtUGRyOGlqT2Qx?=
 =?utf-8?B?aENoQm9BSS9sTWljQVZTMXlwOHhJSzVUVzd3NXFTTFBlZHFQdVdvK2VuK0pv?=
 =?utf-8?B?S24rSVd2Ylg4UE9UUUxvMFZOWmhaYmdsN0tmTUFNNWdWcnA3YzFEOHZ5UmxD?=
 =?utf-8?B?Nm5YdFRJTWdnV1NtdC9HQzlJOFlnK3V6dC9mQkJRYTR2Q1p0QlZ3bUVjZlhB?=
 =?utf-8?B?ck5KWlJteUtob3NtUWNwVndtc0doSnBVdFdpWUMzMy91YXUxeDllb3ZSbU5Q?=
 =?utf-8?B?K1IrK2JBZitEOHZ1Z1d2dlNmbUpPV1NjTndsK2F4OFdhcSt6UFplbVN3RnZy?=
 =?utf-8?B?RVo2TmtOYVBnSGwrd1hiZ3V6Qnd6SkgwY1Rvc2Zmcm5rWUN2OUpTUXF1SDZO?=
 =?utf-8?B?UWhSZ3E3cXdpY2h5c3hvbGdDdXVFTlZDUURWRXlmK201dDI4WU9vY1hzUjda?=
 =?utf-8?B?eGlYa25lTHdzR3V2UWd2R3FYZEg0RnZJU0xTaFo1czN1SS9yQk5BZXF2QTc4?=
 =?utf-8?B?U29IMzV0MlRPakpXT1hTK3F4V1BaNGFic3pXNXI2bmswNEtVK0JLbzFRRWpG?=
 =?utf-8?B?WTFLNlNjcC9OWC9qeDdId0EvK0F6ZkFuT1VtVDhENUZFdHNsYzJ0ZHp6VzNv?=
 =?utf-8?B?SFkxVy92NnZwTE5WMENaRENFcjYwT0FYUTFabHEwcWp5N2oxWlRpSjBMTTlF?=
 =?utf-8?B?NG5MWEdXKzlITWRYUHlXSkwzdFhQR253T01PTWNqUSt2cTJUbU9zM05nYTRI?=
 =?utf-8?B?b09WZXRja25CYi9NcnFMUHB4TWlJcklCVTJjZnlCTFhxS2JidEFmMEVJNXhB?=
 =?utf-8?B?RE44emNTVGRIeG0zS3VLVlFkRnNCUDVQNnlWSzI1a1hXV21KTXJSdWlRK2Fq?=
 =?utf-8?B?VnV4UTBDYkJyOEJRZVk0eXQvZ3hiTUFWYS94Y0pIQ0pEYzAySlZ4cHNtU2ht?=
 =?utf-8?B?THk4bkRyWnNrM2Y2TkIxb2ZlNUxBdUpWVU9xc2hGTjJxRUJHc2JxWWFmclJj?=
 =?utf-8?B?MmR1NkJNVUhtaUhPS2c3Yk51WHhSYUM4T0p0L3EvOE1VQ1U4MGwwVEtQODBJ?=
 =?utf-8?B?OHpMd3pxOWljRFhCd1ZXb2h2OUNWc2RhS2lxYjhEakxDV3FJaTRXSFcvSXF6?=
 =?utf-8?B?SUhvY096ZmJ0UUc2amNtNDFmYU5kbW1GamRMQ0tOUVBiaGlvVDM4NTJ6K2pO?=
 =?utf-8?B?SUdnK2kzTmpNclpZU0V4ZW1OdGUvZ0wyZjg5d295NXNwNkx4Q2o0cWNPcVkr?=
 =?utf-8?B?N2wrVStaUzc0dHBvMS8wamlDTzc1TVVpT1J5cDlrYk04VDhRNU9waWVYbkh0?=
 =?utf-8?B?UlBDbzZKMm9DZ2hnenFhQXZ3VlNlaGliano0SmNoSFZ0YlNQNXA2OFRrS3hN?=
 =?utf-8?B?aGsvQ0hHSDA1VHFWN3RRYWQ4THVnRTMxVDYzWDJRSHUxd1BIdXpDNHlrcmxM?=
 =?utf-8?Q?aeOi6ZiG2ZX4eosNr8kcTZN+TZjLqM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG11cnp1ZTVYVmZoWFNPOGV4T1dBeWtkMXpuWW5YbThnQUJOYTdMSEZWTHZn?=
 =?utf-8?B?cU9WVWhVamRrNjZEVmVYZ1liakRERWFCNTRLekkrNzM3TGZldkY0cC9GYVFZ?=
 =?utf-8?B?UTFVVXRTL1F3RWtFelhXMnJsU0dacGVldG1LQzl0YnppRjZwVTloaDJvT1Zh?=
 =?utf-8?B?NVZmY2RFWExsS29POEhLNWlNRDllSHpNNFBCanFvSzNtMGZmZTE5dDVoY3hQ?=
 =?utf-8?B?QjlUWWN2YVFyME9sS0ZxQm83TFVEN1N4ckh5c29PTWpFZGVIbnJMc0hRNW91?=
 =?utf-8?B?aXBTeS8xbzRmLzIyeUlGdzNMb3d3UXJJTGdCZmV4WmxhWDZ2SWJSTjc4SlFD?=
 =?utf-8?B?aVlSc2thN0c1WkpLeWhEWTFnMEswekNCMUJzWk4vTGhRVzQ4azBncEpISkw3?=
 =?utf-8?B?N2JTNUk1SWlKM2docEZFQWFEUE93SDdKMkhCOHhQbXBlMDlRS1lwdEtuYnY3?=
 =?utf-8?B?UlZiWXJ0aVNQSTluS2E1b3JpL0RUbzNITUlYbUhTU3NRVkdyaE16cHRHY0I5?=
 =?utf-8?B?U0pHazVsNnJQYWUyQ1VSZ2VJVEZMNnhFdEdsYzNJL1Q0V05qQkNwMHpuemdT?=
 =?utf-8?B?OStnaWxJQmJuQm5vTDlMS1UzODdDOUdpSWlCdXdkZkorOVBTR091Y3BaQXND?=
 =?utf-8?B?eDNJb2hicmgwOWNGeS9IQzdHNkprZ3hCaHJSMUdpeUNaOFdISFIrc3pkYUJ5?=
 =?utf-8?B?U0RiUFp2eWRDUFBuUS9CdnBHOWdiS3ZtajJ3SFI2VmhhMVFrbklqTXFISmkx?=
 =?utf-8?B?NW5CWVlYODhLNlZ0RzFaZTE3N2h4aWxMZ2J0YnRweE9xWlRlRENVclRrQWQz?=
 =?utf-8?B?a1ZWTEVCOEQ0NFdXNnVBNDVPYXYwTnRpRXNEZXZ2YkNnQUZGZDJQbTNXa3p5?=
 =?utf-8?B?Ry95SnlPazF2dXk0ejdwL0JDd3pEYTdnNlRMQy9xYjFOdld6QnZuMlU2NWND?=
 =?utf-8?B?VjF2bTErL1NzdmdGc1dienU0STZLUEM0bnQ2dTU1RE1Sa0tJczhhTkdXQTla?=
 =?utf-8?B?YVgvbDM0ZU1EQ085bGdiYUpxREVsMWZsTHpZQldLWXdHSXVVdHJmNms2SGRD?=
 =?utf-8?B?K3FlT0k0UlpMamhVWGdlN0d2RUJ1TEdNZ0YrUFdTTjVxd2l0aCtWRFFXdHor?=
 =?utf-8?B?Qjk1OXBBQlhIQWoyK2V0VzNWOTlOZnRjbzkydlA0VEw2YlRrNTFXVzlNZ3J0?=
 =?utf-8?B?NEc2ei9uZ090Qy9RclFWRUxudHhzbElnSUVuNW9PMXBCdnZnNVlDZWtER0t4?=
 =?utf-8?B?dkpBMGNveW1LcmhDQkcwQmtET2c4dnl4S0hLamxhbmN0M1RRTGdIQk93U1py?=
 =?utf-8?B?S2Z3ekRnYkRoNnovVkNSQ2RXSyswMHBZSDJJajA5QTIxZnR3a0VLaGZtUURO?=
 =?utf-8?B?UW1sTlh0a0RlY095azRqdG4xbFlVUVN0VGs4NU55SEhvRENCcXhiWkJvMTdW?=
 =?utf-8?B?ckdYNUVnV1BKMUJpNzJCVDFYSHI3b3RjMi9LMGlReGtWa01LQnp1Mk12N0lP?=
 =?utf-8?B?ZWpSMWpzd2JEOTdNalRGa3NuOGlxQ0xrbzNqa2VnbnZ4MjRmWSt6Mm1RZ0Ni?=
 =?utf-8?B?VUdMeUNEcUljYm5LQXhteHFYdWQxNUFoandkdG4ybEYrekVPdzVSODhrMUJY?=
 =?utf-8?B?UGcrV3hIRU1KRzh2REVacVZGWVVDTXE2bWd1dkJMMXVtcW5XWVhITVFLaHAw?=
 =?utf-8?B?cVc5clIxTUZ4M2lqaE9qQXQ0TGI4cHM5bzdkM0dvOFVBUHF4VUVKS0QwWTRU?=
 =?utf-8?B?TEw2MXM4MzBET1VxMWxzaHpIMGx3a3g4ejZYaUFJNlB0cGxaNm5oaVFPbG1T?=
 =?utf-8?B?UUQ4TWJlNkk1N3N1c3ZITTZBekdVTXlwR1RxM01JUUk1VUVLS2JNTmN6d1FY?=
 =?utf-8?B?TjBFaUttdDNYU0Y5S2dwMlVsTDM3NTFZRDc4TXlnTnQzWXRyckJjUEdra2V0?=
 =?utf-8?B?aURkL0gvMkk3MFNETVdoSGtESVBXUVVIMVg4TEpYM2pMUEJ5K0ptZ2VIQTJ4?=
 =?utf-8?B?UFJlRTdOaEtidWFzY2pvRGpEcDJHOWlqMW1yRVFFMGNKa0dmWmpkVXp6TUJv?=
 =?utf-8?B?SDdwZ2ZXRGdibnU2SnozaDR2ODZISkdTck1qVE1wRVpGL3pvbU1MY1l5enRp?=
 =?utf-8?Q?bKwjxXxaGV0g0CcJv7oU+qe0a?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B757C726AECDAF42952E4AA1D6450CE9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970f627e-9858-49e0-92f7-08ddc98e94ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 02:13:57.3948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0+1YF626AqU/F/yRaguqHlTJZQ3swmeQOW6iQnFQQmXm+TV5sntnNwhaAKWbsbpQ/uKVBGntFpAFxOC4flagQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7963
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDE2OjU4ICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIE1vbiwgSnVsIDIxLCAyMDI1IGF0IDA5OjM2OjQ4UE0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gTnAgYW5kIHRoYW5rcyEgSSdsbCBhZGRyZXNzIHlvdXIgb3RoZXIgY29tbWVu
dHMgYnV0IEknbGwgc2VlIHdoZXRoZXIgQm9yaXMNCj4gPiBoYXMgYW55IG90aGVyIGNvbW1lbnRz
IGZpcnN0Lg0KPiANCj4gTmFoLCBoZSBoYXNuJ3QuIFRoaXMgbG9va3MgZXhhY3RseSBsaWtlIHdo
YXQgSSBoYWQgaW4gbWluZCBzbyB0aGFua3MgZm9yDQo+IGRvaW5nIGl0Lg0KPiANCg0KSGkgQm9y
aXMsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQpJIGd1ZXNzIHdlIGRvbid0IG5lZWQg
dG8gd2FpdCBvdGhlciBURFggcGF0Y2hlcyB0byByZXNwaW4gdGhpcywgc28gSSBjYW4NCnF1aWNr
bHkgYWRkcmVzcyBjb21tZW50cyBmcm9tIFRvbSBhbmQgaHBhIGFuZCBzZW5kIG91dCB2MiBvZiB0
aGlzIHBhdGNoIGFzDQphIHN0YW5kYWxvbmUgb25lIGlmIHlvdSBwcmVmZXI/ICA6LSkNCg==

