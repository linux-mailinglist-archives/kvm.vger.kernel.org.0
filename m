Return-Path: <kvm+bounces-48955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C005AD485F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 04:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44A2E176DF6
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E690017A2FF;
	Wed, 11 Jun 2025 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l1KLR0NU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F811632D7;
	Wed, 11 Jun 2025 02:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607780; cv=fail; b=Ugx1zc4wGu3469QMvLiMGBD2Z7FD4k7BdbF9ij4Xw0/PojVwuiz6tWwS0FBkTr2fOT46aQ7/5yZYAmUXcDzdA4SEsIJzW0B5N6hndcwTgGrIzP4OOKqky1hZh1A5pfx9gGBifc9OzoJchwwg91dwLsE5JsIjqKvYfLKHFJ4dy9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607780; c=relaxed/simple;
	bh=P0fHg+cTVWiH066b2RydxSx/bDf2Ftgqme53y3WNIqw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q0M3Rf1vxotzT3taC6LhVWdR7Qf7UiL1d6+PVbUIhLZCUITWQjOi6mgxAgzqCGFqeXddHNooPk7BzuvmeP8vdp94Mwvp5ZvvPA/+EqmFAi7MiU8y2K/GmCOVut/m3BIk4MLubzYvoU6J0X1u8h2FtYOQNn4N4zodg69bDdV1wcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l1KLR0NU; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749607778; x=1781143778;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P0fHg+cTVWiH066b2RydxSx/bDf2Ftgqme53y3WNIqw=;
  b=l1KLR0NUYW9KIDMGjqNkGJjzupvXTbq3K9MB0sU9kPIQcGg7g71CpYLk
   C+8zEEKUJag573Hsdj5kO5fSPwwrqmLQWyPnN++/sPHDI4ajyqTdsHRxH
   00GQlCsYD1v6Vdc2QqFo4P+E2UD8EI8OXIBz7hb3/UzAJGhGfgOBjvmTS
   eDnEPgdCkUfcHY+CHUocpzPrRlFMofIT6BaC9kxBWDnvaOO5TAXo/z/Sy
   larZ0PD7VZ41zSZkQZQ1qHpV7mYox21VEV5utgTGS5RldFYfizmnLLFXq
   Ye+wHwhjuh8i9tlope++SQCZcB4ixvsYcdIglXXvmp5Q7/iRYPNcQfCUp
   g==;
X-CSE-ConnectionGUID: 4mCp4B17Rve5h8TpxOMbjQ==
X-CSE-MsgGUID: sWESo0NGQ82GB0g8LbxM3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51446283"
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="51446283"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:09:38 -0700
X-CSE-ConnectionGUID: fnrQ/0NxRpSrFr8oYSbSqg==
X-CSE-MsgGUID: FPQVzRvWT/2i7Ol1vGzTcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,226,1744095600"; 
   d="scan'208";a="184195028"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 19:09:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 19:09:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 19:09:37 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.77)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 10 Jun 2025 19:09:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qki3tyEmKFvHOAwBYpwoJ5r+tk8zSF8bekMTAQU5oBP+kQxDxw0MLS0CGDvJgJ3nwuTAMkNPNPCLpawlKoBrm7peF1ij/OVRSQgPEOXd2L4osPsP6gW8O0ZBxmJNb5XAtQ4H25sdd/gTkeO+7AxQVR/94C32awHqw2EKYA3iPjqbCKjEP2HDREC6ngnNXTjkioosUbkTk4SbtbnMFmM2314WZ2nfJfO5Us0tJw+FBNIXNvmRDB2kOCy2H7R3hymGtqBm4LcTEiertHGNLqhze3DrbXnfzMxfYFIkAR0J7FF7BVErXuu68fWzCu5+VrO/2mWds2CxlBA46aZbEBdiHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0fHg+cTVWiH066b2RydxSx/bDf2Ftgqme53y3WNIqw=;
 b=qWyXlxdy7vslibA3X7FBitGAILJMporGlXkCMPMUYUZ5UPG0EfLA84Da0rh4NjEYBz1IrsS7oll1SNvyc0AwSI+/f8GWI7sKq66wWpCdJmNb53j3MSQ/WuMvatwb3tyfnJ6wScO3vDvnkgtKLBUNRMteMbEix1j5jQRoMOzhGO0SNdr/y7hniO7hMOnnn8c71dAslq/pJ8fRNnIdVf8fYT6JKWnGSt4fZAc49EV6Ypy/Y332NiEp1z6KAb7jwPlEIR/UN6kXOCsuaDLOW4d8KM/J7SREEf+3A+Sbgb8jP6IM9TadOX8NqJzejLTkz3r28O8IqugZL/ygBPZG/AuCww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ2PR11MB8403.namprd11.prod.outlook.com (2603:10b6:a03:53c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 02:09:35 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 02:09:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Thread-Topic: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via
 sysfs
Thread-Index: AQHby8iOaKQWVi2OekCLdyRp2E+nN7PwmlAAgAsen4CAAZs9AA==
Date: Wed, 11 Jun 2025 02:09:35 +0000
Message-ID: <3a1bf1a72473637964a443676e59868fbfbb1ed4.camel@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
	 <20250523095322.88774-6-chao.gao@intel.com>
	 <b7e9cae0cd66a8e7240e575e579ca41cc07f980d.camel@intel.com>
	 <aEeMY7czgden2lmX@intel.com>
In-Reply-To: <aEeMY7czgden2lmX@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ2PR11MB8403:EE_
x-ms-office365-filtering-correlation-id: b25a63c0-a744-4931-c13a-08dda88d0303
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NTl4dGV4eU5nK2ZOQ1pqc29uZ2IyS2xSM0tQTHU1WWtSZ2ZucjVzeXdjWVI0?=
 =?utf-8?B?QnFxZVU5WTl5WmxaSlNoM2RvdXluRHdzeEdnZ0JRZmdiRmFCQnN1NVNiZWZi?=
 =?utf-8?B?N29GUzR3QmdjNHl4R0JRYzBQZUZXKzZNRCtBb1YwUUc1T0hDRHBzOFV3TFQ5?=
 =?utf-8?B?bGhiS05kR0M4S05kVHZNeVlvYXNqY0loVUNVSG40U3FNTjZsOFl0UVVzL1p5?=
 =?utf-8?B?T0IxVERVNHVEb3Y0NjhvUlYrK01yMnRVamhDZHI2aTk4MldvSFByaVIrdXE4?=
 =?utf-8?B?TFZtZWZ3VG51UHlPcDV1RU5jVjV4ckFjUVRoeFZIVmNUTE1xT3pIZHVVMnps?=
 =?utf-8?B?eHduZGxVM1NWSjJwUVpGYXRpY1VwcnJvbXBoQnFvemUyQi8yaDgyRkNkU0hy?=
 =?utf-8?B?SnNJOE05eXpsRGN1NVZob1lJTHp0aGlpaWZXbFhvRm5JV0NqdXN1Sk91YzY4?=
 =?utf-8?B?ZXRKZlhCd1JJekw4aGUrWEZZREk0ZU9QT1VGcmZxOUNyWWtINmlUNDdEK1Vv?=
 =?utf-8?B?emN2V3NvSmxsYjNTeGVTeEh2ZDFxSHUxSFZEUHJ2dm1rOUlKdEJtRFl0cWNM?=
 =?utf-8?B?SWROa2RjTG96K3JkaHc3bXBpT0MvS1VyZmc3Mk1KazdZUFJDSFd1dUQxZ2I4?=
 =?utf-8?B?UFV1NVdCL1lCaFk1elgyVFNsL0FxaElhZ3doM21tUDZ5byt2aWY3dkhSb1hL?=
 =?utf-8?B?cTRNZUdCbzNnb0g5blZVMkp2TnZJTFNVME5pQVFDZys1RnEzZFpSR3BOVlFs?=
 =?utf-8?B?MXJmS09CNTBldU92TjFSRGRMSTN6eEcvcm9JQzhjejU3VllMamY0NjErcTJF?=
 =?utf-8?B?WXY5QjBtTXJFWGY5YVBvRjFYUDFOMG1vSkJqTjhRRmpXdnllaFBzaE81V0E3?=
 =?utf-8?B?R3o0TzBwYmJURlNJVG5jYnQ4eHNBcG1HK0RENUVVeTBPNXhkbkZmRFVZSFd0?=
 =?utf-8?B?a2JWeFl0UzJOMEZ0KzB1TG9pVmo2MXVtYUpzY2JOc3RiUnZSQ0N6QkcvWEtn?=
 =?utf-8?B?MHJmaUpXUWE3L0wzSFNsaEdZR0lvUHZTakM3b3ZYd3FNNDBXcGtjWXNQUDZ6?=
 =?utf-8?B?M1ZFZUpzd0ZHRHJPcnZUaDRUVGJycm1NU1ljS3VYL2lYeXgzMnRjdk5VWWdi?=
 =?utf-8?B?a2tEbjJpb3FMQUlRYVd4eXNNZktxWlYzaW9HWnZydHdsKzFQZ3o1eUpIRzFu?=
 =?utf-8?B?cUhBTWFBMWlKSGVzdVF0MmFramtGYmY4dzMxS2RBYTBjQXZhVnVqbmFhQVFq?=
 =?utf-8?B?TXE1YVZvcDlUdGJoNmtnSDNHREZZZkZQdXdWaVRIbnlGdnFJWlZudnZreURt?=
 =?utf-8?B?SFp3d3RGcjhqbVBKQnlZdjRyc1VxK2dBL3hvaXhQMGR2Zi8vQkxST2hoSVdI?=
 =?utf-8?B?NFJFdjZOM0UxWGxMSzRSMmlWay9JUkoreW1FVThab2FOdXJ0UzFIOE4zTlZE?=
 =?utf-8?B?VnlLK0wyREx1amF1U2lKMkNyY0hJUEpvem9NbjJPb2N2RFVDeGNNQ1BBKzcw?=
 =?utf-8?B?azI0bVVDUlVrZ0xvZVMvTFNJR0M4R1VleWhyTDcwY3ZGL0hiTFNHQkF0Znh4?=
 =?utf-8?B?Y2hEOU5ERTVxcVJSN01tdi9PZGhxYU9KTGpyS0tKdW5XWmJpRFNmU0JXYWlw?=
 =?utf-8?B?Sy81enh5VWtTMGZJWTJjSkVTd25sQVM5T3pESzVVTlJWQjBucHRZT1RTdEZ5?=
 =?utf-8?B?VHV1YzFIUjd3S0p4RlVMRVdnTTZwd2FvN0RkeTBrVCtSM1pPYjMzNTR6bVM3?=
 =?utf-8?B?ekJwc2tHR3RvcmZpZ044S2tZaHJKdEQ0RjdBUnZSL0laazArSll5dUlDQUkw?=
 =?utf-8?B?SVlmd0hHQlJzVWRkRm5CR0dxNDUwRU80TjZKY3RQR0tMV2IyRzArRnlJM3pa?=
 =?utf-8?B?K0hnNUVBRk1KdWNUK2lFYkc4ZHVhekpFRzdhb213RE5aMmFneERGZWI3cnJh?=
 =?utf-8?B?Y0lNbDFVaWtBL1g0d3F4QWo4QWR0bE84KzVGb0RvNjJwbmV5TXpZOFRUdTZJ?=
 =?utf-8?Q?j17rCypQBFdCjmSgnKbhHYY81iPqzk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUhCTkdMNWJJRHRtSkh3VXcwK1dyc3NEQVlna1hZbEFIRmgwSHVweFR5RFlV?=
 =?utf-8?B?SzB2LzJmc2tVbUI4Q1g3bUNVYnJ4UzI4UWtDSjR0aDBtdnZ0UXBhS0VpeXNY?=
 =?utf-8?B?MHpTSTltYnpkZTF6WjJyMHB1QjZweEVOSzBRdzFlTVYzVnR6aWl0ZDZhbEZM?=
 =?utf-8?B?MkpyazMzaTA0UnpWT2ZZYjBoV2NvTVg2Tmlmb1oxQmNGek5XNlVFVTErZWdz?=
 =?utf-8?B?VFFaSkRYSjBXT3RuM0lwL2IrVUtwanBSRDh3T2RhcWRuRnhacmJRY3dFUitZ?=
 =?utf-8?B?UWNoSlZlVkRDVCtZTi9WV2dOWC9rb29HSncxVlREQU5lMVJLYWN5a2xwZkF6?=
 =?utf-8?B?Ynp1R3gvT3g0WnV1dWFYQ2tFM0dIWGtnSFFnNWRwYkZ4ak41dkcrK2VpTUpN?=
 =?utf-8?B?VUZBY1RNYUtiaXNEd01QK0Njc0VranduTlVVRmhsOVo0T0lWMmp5SkJtZjBp?=
 =?utf-8?B?ZjZDdXVLdHorYUxabmJPaWErWnFuYVpoNW4rOFpDZlZYOFFjSDZtMFdjd0k2?=
 =?utf-8?B?bTZnWmxKVjJIUnhBaUIvd2dLWFhBMENjdVRzbDFvWkNNZjNvRG5SSWRNS0Vv?=
 =?utf-8?B?a1JYOUVBTkNrdStIWjZoaGVMbUhnMUcrUVhZTGkzQk9xdEJzbThZa014OTlK?=
 =?utf-8?B?OHpsMStOREM4MnRER291TEJxQnhicG01amFET0R3bVVmODY4cllKRVpjeFRn?=
 =?utf-8?B?TnRxOFljQzBxN3lKQWFNN09hS05HNWJyZXpzaFR3bTVZM0UxdXhkZzUvTTMx?=
 =?utf-8?B?OGhRRFdWMGt4ckZrbnlFdHBobmZsWk9OTngwb2R6ZFNreWpZbWVtSmtyejd5?=
 =?utf-8?B?Z3BUcjE1ZlFidGlkRlh4QzVWSytMLzRaTmJXVjJnSktSbXhmQ0o5cTlqYXNT?=
 =?utf-8?B?bzNGSWRwdFplaXorUSt3Uk1FbFNYcVRqUUVUNDlwRitRVTV2WkhFcUpLSFJJ?=
 =?utf-8?B?eU5RRGc1M29aQmkyQ1BTekwrZ1NQWGFoeEZvQ3FOcGlrM2MrUlhsdm4zOGlW?=
 =?utf-8?B?d1lxRVNnakxiV0Z2Ui94MDk5OThvTWJvVS9xbHc3T0c5cTVhc0V4a2Z5ZmY2?=
 =?utf-8?B?OU9UVGZkUUQzc0VVdmh1aWZMblRTVFBzNTU0TFg2VzhBZWd6TU5hVHNtbzh3?=
 =?utf-8?B?SVQvTDdqTm4ybUNaWWF6eVo0VXNDdG5SSXhhMUhFV0R0YWNlbHZobzI2K092?=
 =?utf-8?B?YUNvOGJ6dmwrVll5ckJpbnRUMUtRaTJOU2RiUUJCZkRORkYvbWQxdHlZNHhJ?=
 =?utf-8?B?NDlXWWIwQ3p6QTFEMHZjUDV5cy9Ga3ByUkR0NVNIdU1IYTY5RnpYd0luTUtC?=
 =?utf-8?B?SFJIVm5MM2d1RE9sVlo4MGdISEdxckhYdi9vMDJGb3p3d1hBMlAyUmdOUm9p?=
 =?utf-8?B?cjRlbGk0Zkt3U1c1NlNEUG04RHV5dmV6LzhwUXFGeUxFbFI0elNpak4rWkV4?=
 =?utf-8?B?QzFFbzZmbEdHUDJaWXBJcFF6K0FlU0VEMXpFcnNEM0UwdU9OWFJzeERyNFRw?=
 =?utf-8?B?a3MrdG1mRG1GYm1qZEpvdjVVV0Y2dXpIdG5UN3BtTGsxRFduRkkvTllPUHVB?=
 =?utf-8?B?cXJVaFp3U1VVQTdDWksrOGF2bG5Ed1pOR0pzdm16bEZySkVBVUtnZEt4SkJm?=
 =?utf-8?B?d0dDZ0hpYktuVVdjQnJucTBSSVk5M2xnZkZNMW5KSkVGcWtVNWt3Vndoc1lG?=
 =?utf-8?B?V2dMeUlSR2tWSU0vb1hSbXRmOTNYZWF4M2JHbWI3MWQza21PcFh4eVVGa1pO?=
 =?utf-8?B?Q2JxYzY0eE5YVHVvMkVWb2NhRGRDWXhaL0dlLzUyVnRJNXFLdFN0Q2JxSDF0?=
 =?utf-8?B?bURiOXM0anpIejhBTStiekIyUzh5QnQ4a0d4NVl1ekJwcFEvT25nbEREendL?=
 =?utf-8?B?eHFvd0o5dHJGRTVlbzJBR2lxamFaVThMclNYc0ZjTGdLNFNNL0ltRmc4U1hF?=
 =?utf-8?B?eDZkQ1prQlk2QXkyU0daQnM4SWpWbGZ3bUpwQzNGOGJpdHltV0NqYncyVXZB?=
 =?utf-8?B?TVU4dk9rRTBiZTJNaDQzVWRnNVhPaVZIaTlyTTBucXM1ZmdHWGtMaEYvQXVR?=
 =?utf-8?B?K1MwY1EzZlVEaU1BcnZYeFArN1NxSWVZQWM0aGh3b1Z1U1F0bFVpUzJRT0hB?=
 =?utf-8?Q?/BQUzrfLZHuxYqjN++WU+3yD1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C64E62FECD0462439FC97E2B0B67C119@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25a63c0-a744-4931-c13a-08dda88d0303
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2025 02:09:35.0357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eMdrrz+pAXhlFlo1Y+VbpJat8vZE7gYmczLb98SsgvLbH6RY/PswSpitwgu4uyDwVs2ZL3gs74U4YRr0bvAglw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8403
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTEwIGF0IDA5OjM3ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
VHVlLCBKdW4gMDMsIDIwMjUgYXQgMDc6NDk6MTdBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiANCj4gPiA+IA0KPiA+ID4gTm90ZSBjaGFuZ2VzIHRvIHRkeF9nbG9iYWxfbWV0YWRhdGEu
e2hjfSBhcmUgYXV0by1nZW5lcmF0ZWQgYnkgZm9sbG93aW5nDQo+ID4gPiB0aGUgaW5zdHJ1Y3Rp
b25zIGRldGFpbGVkIGluIFsxXSwgYWZ0ZXIgbW9kaWZ5aW5nICJ2ZXJzaW9uIiB0byAidmVyc2lv
bnMiDQo+ID4gPiBpbiB0aGUgVERYX1NUUlVDVCBvZiB0ZHgucHkgdG8gYWNjdXJhdGVseSByZWZs
ZWN0IHRoYXQgaXQgaXMgYSBjb2xsZWN0aW9uDQo+ID4gPiBvZiB2ZXJzaW9ucy4NCj4gPiA+IA0K
PiA+IA0KPiA+IFsuLi5dDQo+ID4gDQo+ID4gPiArc3RhdGljIHNzaXplX3QgdmVyc2lvbl9zaG93
KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsDQo+ID4g
PiArCQkJICAgIGNoYXIgKmJ1ZikNCj4gPiA+ICt7DQo+ID4gPiArCWNvbnN0IHN0cnVjdCB0ZHhf
c3lzX2luZm9fdmVyc2lvbnMgKnYgPSAmdGR4X3N5c2luZm8udmVyc2lvbnM7DQo+ID4gPiArDQo+
ID4gPiArCXJldHVybiBzeXNmc19lbWl0KGJ1ZiwgIiV1LiV1LiV1XG4iLCB2LT5tYWpvcl92ZXJz
aW9uLA0KPiA+ID4gKwkJCQkJICAgICB2LT5taW5vcl92ZXJzaW9uLA0KPiA+ID4gKwkJCQkJICAg
ICB2LT51cGRhdGVfdmVyc2lvbik7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBE
RVZJQ0VfQVRUUl9STyh2ZXJzaW9uKTsNCj4gPiA+ICsNCj4gPiANCj4gPiBUaGVuIGZvciB0aGlz
IGF0dHJpYnV0ZSwgSSB0aGluayBpdCBpcyBiZXR0ZXIgdG8gbmFtZSBpdCAndmVyc2lvbnMnIGFz
IHdlbGw/DQo+IA0KPiBVc2luZyAndmVyc2lvbnMnIGZvciBzeXNmcyBtaWdodCBiZSBjb25mdXNp
bmcsIGFzIGl0IGNvdWxkIGltcGx5IG11bHRpcGxlIFREWA0KPiBtb2R1bGVzLiBJdCBtYWtlcyBt
b3JlIHNlbnNlIHRvIG1lIHRoYXQgZWFjaCBtb2R1bGUgaGFzIF9fYSB2ZXJzaW9uX18gaW4gdGhl
DQo+IHgueS56IGZvcm1hdC4NCj4gDQo+IEFuZCB0aGUgY29udmVudGlvbiBmb3Igc3lzZnMgZmls
ZSBuYW1lcyBpcyB0byB1c2UgJ3ZlcnNpb24nLiBFLmcuLA0KPiANCj4gIyBmaW5kIC4gLXR5cGUg
ZiAtZXhlYyBncmVwICd2ZXJzaW9uX3Nob3cnIHt9ICsgfHdjIC1sDQo+IDE4NQ0KPiAjIGZpbmQg
LiAtdHlwZSBmIC1leGVjIGdyZXAgJ3ZlcnNpb25zX3Nob3cnIHt9ICsgfHdjIC1sDQo+IDANCj4g
DQo+IENvbmNhdGVuYXRpbmcgbWFqb3JfdmVyc2lvbi9taW5vcl92ZXJzaW9uIGlzIGtpbmRhIGNv
bW1vbiBpbnNpZGUgdGhlIGtlcm5lbCwNCj4gYnV0ICd2ZXJzaW9ucycgaXMgbm90IHR5cGljYWxs
eSB1c2VkIGFzIGEgc3lzZnMgbmFtZS4NCg0KU3VyZS4NCg0KQnV0IHRoZW4gc2hvdWxkIHdlIGp1
c3QgdXNlICd2ZXJzaW9uJyBpbiB0aGUgbmFtZXMgb2YgdGhlIHN0cnVjdHVyZSBhbmQgdGhlDQp2
YXJpYWJsZSBnZW5lcmF0ZWQgdmlhIHRoZSBzY3JpcHQ/DQoNCkl0IGRvZXNuJ3QgbWFrZSBhIGxv
dCBzZW5zZSB0byBtZSB0byBoYXZlIHRoaXMgaW5jb25zaXN0ZW5jeS4NCg==

