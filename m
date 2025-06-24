Return-Path: <kvm+bounces-50483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4DEAE62A8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF1323A88BD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 10:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F37284B3C;
	Tue, 24 Jun 2025 10:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HUqnecbt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB128466F;
	Tue, 24 Jun 2025 10:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761474; cv=fail; b=chSIbhOh+WTR5Ip/X3CHT+/RYgIHUV4osTiaIc8eqNkDcaTgeWCKQzWxVughUV830ertp1er7wCkMPYKy5DvxEUAn+znvt5wscmDFLyh970tGUa1KlSdRZY6fXmrXceZuY0PWalOPPGidmis725LGO/Me1vhBgdx7AdvnzQr5xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761474; c=relaxed/simple;
	bh=3LLop8EUrrMSm6lK6II8OHNtbq+QQEOkwuq56Uqz/J8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GRWTdmfKqEyYbBlumb5fN4oIn1YTj4koBDJR4/LFHb6FZgS7kS2SWGiVogFlQI0CucZZtsk097si2L8t/bmgM1L/9BROkGoc6OndJMFv4RXGQFX9XaqgIdbDTVni6uamEVRskFuIGEoOirMl3DrNmWkZydJ1kYHFAvan/I8bWJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HUqnecbt; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750761473; x=1782297473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3LLop8EUrrMSm6lK6II8OHNtbq+QQEOkwuq56Uqz/J8=;
  b=HUqnecbtlNm2zYj21GFQmKyIE+nxPEGsIndCRBDM/5h4uSiPKlhmQ67D
   io7VwiN9pTMmzAhxpyyXG1iaG1KlFwYqHNR1RQeil9ygv77A8a2yBVRhp
   1ehRTglTx/GglLNquzwGYp4YbVadXitr2yN9YgwCRDp3b1BHYycS9fQZO
   Emw3xXSOeyx8vYZroC41+G2ALYtVZZYj31u0puKcwD1G0eBd74NdZEFvq
   gFINSwN7edm05oXGmxqc4iPQxif1r2ZLVB6pdT8OSBsz4jd4lSNo6dqkX
   6omHjJ1KnHYPqMTvnyWwgqcICUCzdesvgTJGPsZymigIv+hTPr6MhM0Zu
   g==;
X-CSE-ConnectionGUID: sf/WRcq5QiaV3lrUioyauQ==
X-CSE-MsgGUID: Hcim1Tt1RbGx7Gr3/QdCqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="56801145"
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="56801145"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:37:49 -0700
X-CSE-ConnectionGUID: cktSgwUiSYiaNHbGVdc++w==
X-CSE-MsgGUID: nqkjWoMkS1O233utXlLOig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="151301741"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:37:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:37:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 03:37:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.40) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnG40mpTzh9osMeE9J2uLewscCGKyoRDqnLQ0yqs5LTBOBsxdOpb4yzYKgHQQLDAGc5jlS7ENuhaCo7RECMNz+Ihwt6/GqPvvUSBUPe+s5mF/tHmHV/lcwOq9R3J1oNv8exLV5HYOhe/IayMt2jRgvyb4J3qz54XrRGc7IY3jTONhjkLnVSo/lTd7aB8T7Lg8AU+7Na0xR5QzKbshPobW7trFYBq3USC6bMho8lXGLCJOaH5k2E6qPOBeBSC7gBahF2BaPHg9X1tDDUTg4hcZ6OVW218sSFgYY5P5C0S+VspfpP6KN6xiNsmPTKrRyewCEGxpFzmqh59xF38DiuQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LLop8EUrrMSm6lK6II8OHNtbq+QQEOkwuq56Uqz/J8=;
 b=vkwQNmC7ArvNESArukmLIuWeUYRAAQa1OSkoX50uZczrKF40IVLrLVeNGalVv3hCZKINt+Pl1BCsEWmSrP0L8BgAeWPtxA0tP/3/6HclmFhjMGL213xqUrkUF2sl8oZ4j8tqoCIFfXfi7Ew3A3QeGgMRwi+YFvLfYqxn9KDIlR5Sl2Ca4d4ByxP1t+heK2+ha99tfsJftpkzh7CB3zSZlwEy3Dbxz7B+5nICKrjTcB9zoMttZUFhHdjtyJldnN9fw/H5ckb/PJTjjGzbqrKOxuQfALGn2qG2dLsTHM4BHBYgx0bEs2drTyQ/GtKDgqH5sypcA40UF4FDR5zXL8Xg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Tue, 24 Jun
 2025 10:37:31 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Tue, 24 Jun 2025
 10:37:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Neeraj.Upadhyay@amd.com" <Neeraj.Upadhyay@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tiala@microsoft.com"
	<tiala@microsoft.com>, "Vasant.Hegde@amd.com" <Vasant.Hegde@amd.com>,
	"Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "huibo.wang@amd.com"
	<huibo.wang@amd.com>, "Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>,
	"nikunj@amd.com" <nikunj@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>,
	"naveen.rao@amd.com" <naveen.rao@amd.com>, "David.Kaplan@amd.com"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v7 18/37] x86/apic: Simplify bitwise operations on
 apic bitmap
Thread-Topic: [RFC PATCH v7 18/37] x86/apic: Simplify bitwise operations on
 apic bitmap
Thread-Index: AQHb2jHUeGq6Av+EQEyHYnPyplmmObQSM5IA
Date: Tue, 24 Jun 2025 10:37:31 +0000
Message-ID: <2f4603f4c74ba21776ad6beff5f5b98025c99973.camel@intel.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
	 <20250610175424.209796-19-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250610175424.209796-19-Neeraj.Upadhyay@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BY1PR11MB8053:EE_
x-ms-office365-filtering-correlation-id: 92c21a8b-0fa4-4ff0-8b99-08ddb30b1fad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y1lrQlFKWHpDT2ZZMFJ5VDQvR1BIRFlKRGhSc2Nxb1RJU29Yd2hNUnNWbzRZ?=
 =?utf-8?B?SkM3KzlCakUyemNaUXJxQ05sVWxET1RxMGFSMDN2RDlOSVEzcUNHWFM2amhR?=
 =?utf-8?B?bGJuVDdPL1RRT1BxT3lpM3ZVRzZCcVZLT3FTN0NVWnU0MVg3VXhZdnhIOUU0?=
 =?utf-8?B?cXQvL0Z5M1krMGZramphU013bHlMaFFMa0FTVlNka2pITFlqYnROb05zaE0r?=
 =?utf-8?B?L2FDaG10bDYzWVFlaW5BVWk3aTBPOUs5Y3RaQ3Y3MTlTbUhiZnJEQ1ZaaDQw?=
 =?utf-8?B?VnB1NmVhRFQvNDV4aWNoelRzKzE1UEQ0SUxoSjFWdFREZGdtQVRzZjM5elgx?=
 =?utf-8?B?SG1qSjJqc0ZpcEcxOVF3NjdVWGNXdXRSSmpZR21DcUlnR0pBNzlNajVFU216?=
 =?utf-8?B?bktYYVFoNmI1dzA3dFY5K2lHK1kwczRSemlTSlFEMVQrN2hGR1RmcG04cUpZ?=
 =?utf-8?B?MCtRRm1jcmJlbFFXZnU2K3BLdHBpMUMrQmphTzdtZVFrZGFiS1pRVjZncGxK?=
 =?utf-8?B?YkZNeko4OWNJYWxHM1FNUllXTFFxS1IvbElHVG56U2YvRExzZzBEa2JlMHly?=
 =?utf-8?B?U215cVcyOFFoaWtOOGNhZFhGMHl2RGhySllEcWJNRHovS1FqQU85Z1VRZng3?=
 =?utf-8?B?V2NtcVZCY3FObEVzL2Y1WVR6aGRKL0lkZ3B0K2lKTzAxZTBBQkFqSmxwaG52?=
 =?utf-8?B?Mm5pbytzQWJiRVoxQ1F3Z0M1akZNdEdBTkVpOGcwTjJzMThvcUkrT2NZZjU3?=
 =?utf-8?B?OEwxdWhoYlhiQWZqSmpOaEM2S2FZWm43blBzYWZSbXlSN2s5L0ppY0MvenVH?=
 =?utf-8?B?cEY5bDd1aElSL1l1YWZvaFRJRHR1eW1BeVFTVytPS1JlY2VsNTl0U1NldklK?=
 =?utf-8?B?VElFS0gvY1FjbXlqOVFCTmMzWi85VWJHYUt1V1RpUTU4a0tCa2VWNWNWK3dj?=
 =?utf-8?B?ZGRjMlNFbWR1ZCtRQlRTZjF2OFNrVWQzZUVHNGV2eVFiSS80TEJVK0dMT3ly?=
 =?utf-8?B?NUNPd0YyTXZyUUd3SHhvN0pXV1NvMUp4RHVIN1M4Z09GS080S29rK0hLbEpD?=
 =?utf-8?B?N2graERnWGVObXFhWUZudGRCY1QrWlN1SXNuVVNwSWRWWVlORXY1dnpUWkd6?=
 =?utf-8?B?Tmd5ZWdDTUtWUTQxZHJPKytnOVBKOGdFdkxQc1NiSU9Jc3R0dTFQbGFpTWp2?=
 =?utf-8?B?Yk9wcEY0RGN4YWg1b3JmOTUvSU1UTmh6ajZLdG5YZW4wZ0l3QlFNbEVuREor?=
 =?utf-8?B?MjRXSVpCa3lSMTdwZzNRamhaeDNJWmQ3cENZc1BQSGkyVTNYL0pxdHhnTjVn?=
 =?utf-8?B?UW1LcWdRQWxnaTBoQm8vS1Irc2tNMEY4Vnc1S2VZbW9YUnB3MHM1TWRPUThU?=
 =?utf-8?B?aDU1d2JOaFlRVkxpR2RSNWxkVFZSZ2pETU45blFZb0pXb05RUW1ONWx5RWxB?=
 =?utf-8?B?T1c1MmdzMW1GL0o0emM2eldwYlpjVmpnQzlPdk1hZlhLd3hNTE1ZTHB0Tmd6?=
 =?utf-8?B?SlJhZDRwTTBNRElmMklVbVhoczRKV1pQV2VFTnZCZjR5VEJZeHk1TXgzTzBB?=
 =?utf-8?B?KzhQeWl4dVFzZlZSbWhISzdhaFNwWVhSTmkxT0UrSGVlWkdBREViaGNvb1da?=
 =?utf-8?B?dlhRSjZONmFrOWd4YjlFR0ZRSUJIWngwNzFxNjhJVld4VFJ2WXN5MjM1NlJ6?=
 =?utf-8?B?YVo0bnFMelNkMXNqSXpXZzh4VlVEUU1qWUh3NmROL0F2YS9mdDJVdldzcVBa?=
 =?utf-8?B?eEIxZkk0elF1QWZmVGZjR1ZiRlNqSUVyZFpyOGEzMDdWVFB6YVFOVDh4VWdL?=
 =?utf-8?B?clB6Z0c5UFJUMXBkaE9IZWV0bWNNWTNkK1hHLzkrZzhQYUMyc0hpM2djK05k?=
 =?utf-8?B?VXE3Z1RwcjRDQ0F5VURrdmtNR3VyS3RaZWlzVTNpZU5VNUJFS25oTndTTVNO?=
 =?utf-8?B?SSsyb1ZtcDRLaW5YaGMvc0hKVjVPdEl0QXcwSHRiNiswK0FwU1hja21KZ3Ns?=
 =?utf-8?Q?zv32fcnAC5fPXVuUIqFUTwpqdiQntw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmJsMHdlTUZYMWJybjkvVXNnY2hoL2NUWjYvRHZxVm5wTU5XMkh2TUcxQzRz?=
 =?utf-8?B?OEVoSWtnNWJJTGJsQ1pqb3FrZHhqa1dYYnBXL0FWbHlZSDhWR2h5WWRxaTE1?=
 =?utf-8?B?bWZRWGt1U2tOREhVSi9PUy9WRk1EbjBKVVpNeWlyOFQ1WEpNZlplWHh1dEdq?=
 =?utf-8?B?blUvVzBzSjFLUzB3NDlIVFZwQnJxYVRwRkVPbHp3QWhtOGlveERHS1U4Q3Z6?=
 =?utf-8?B?SUZubjZIUm9yL1p5ck55ZlROM2VvOHBXQ2d1SGt6eTFNZmZRa0Mxdm9KWFJh?=
 =?utf-8?B?cFk0RE9GcGNKTzlXQmxSYUxsb3ZiSjdsWTgzOGc1bFRRcThvc1pHRVlsamlH?=
 =?utf-8?B?WjVvemgwaTRCWGt4NXh3b1k4emRXSE80WlFKaXZzcFliR1JZdUZsV0lJNUlL?=
 =?utf-8?B?MU52MkozVGY4eGIyY1llcUY3eVlxeWtBbXNQb2RoR0E4WUpjUjRpOTRvbGF2?=
 =?utf-8?B?V1JXaHFaOVpSRHl4Q0MzdFRHb1JtOSt5V0tBdktGa3Y2M3BLM1F0aTZCdC8r?=
 =?utf-8?B?eTZNdFFYd3dkdU5YMVFjS1d6N0JLT1dFbWhGRXlheVE2NmJXaTlkenBpamFk?=
 =?utf-8?B?OG5vSFEwdWlHVUVuRzVvZGhOVUJNYUppM291aTMyM0pzS3k0S2VydytRdFlv?=
 =?utf-8?B?TWkvUTkxNzQzWk5KZDZBeXdENVhNU25Qc2k5bmtQRVNGMHROQXd3M3R4WEJY?=
 =?utf-8?B?WjdCRUJkNGlrTFdMbmJJeWlXQzZMWFJYWmQ5UlJnNVR0TzFvYWtXR2FYYWRN?=
 =?utf-8?B?c3VucjQ3aGt2Q3ZZZTRSQnV0R1FKQWE2Y0MyRkFnVDQzR0tNVVVxd0RNalBp?=
 =?utf-8?B?Y2Fab0lUSTRtVVdxMWFoT0pmMWF5U3FUNXFtbVE3MHFoa1ZFRzYvbjRDVHI2?=
 =?utf-8?B?K1RzYXZPclczMkpHNHVsMHZRelZ5OEluU3JJRFRtbjliMC9MdmJKUmYzdE1Z?=
 =?utf-8?B?WXM0L2dlT21TT0cvV25FNjVRcWZzUmJlemZmcVVhOEp3TDlXdUh6d3hMSmFT?=
 =?utf-8?B?NHo3WXdRcDhzLy9ZMlhuRnpQZmQ3djU1NCtUeGxvekw2T29uZ01tZEYrMTNs?=
 =?utf-8?B?V0hMWHNvODc5cHZIU0IzcURNNWJubzFkeGlITlhTZ3pPWGZKdnhxTkFLVmF3?=
 =?utf-8?B?Vzh6T0RqN2JvMnpYanFucVkrdGM5Y1pFYjMxaVd0Yy9KdkJyejFiU2w1UVBa?=
 =?utf-8?B?WUdjb213TXFXZkkzYjk2OXpudU5aMjFXQURWeXNHSlVyWU9sMDd2Vm5YUnor?=
 =?utf-8?B?bDROekxTcWs2SVJPbVVqcHh2SlVNd2ltVmxtcHJPNmRzT2NrUm5lQWljK3BL?=
 =?utf-8?B?QUhwK2NYVEMycXFPZXlJdittR2R2N0ZPY0pKbnN6WSsvRnhGNFFpWEI4bUVh?=
 =?utf-8?B?SGgwOVhFL1ZJOFg4OGZMdTRxMkg5alp1ajZDK0I3WHRtSGhIWlUvc2I3d256?=
 =?utf-8?B?VHhNbVFDOHAwMGtWNUxqTTF0YnF3a0NLTGZpOHNYVHFCT2JJT2JRZ2ZhZk5O?=
 =?utf-8?B?ajFzY042bEdzNGNkSDh3Zm5EdmFlZXVhRnNjTmtqVDhkdXg1ZzFZSElZY2Iw?=
 =?utf-8?B?OHJBM2RhQTdJeUFGbS83K0Zaa1ZEcEFORG9nbTAzdjJnWWhrTEtwM3JUSEdJ?=
 =?utf-8?B?TWJjTkkrZUlMM3BDRUZYcGNLd1FwTm5pTThKaytaaUp4SDFjaUZzcWFzZnVM?=
 =?utf-8?B?U2FjajV4eEY1QW41VUEzWGdTWkRFRUF6a0srdC9Rb0IvY09GSTdMUm9QbFpX?=
 =?utf-8?B?MnJ3b1ZmY2JFSGM1WG9jMHlzcVREcDQ0KzN6MHQzUldOVXFvTS93alJzMitQ?=
 =?utf-8?B?bGg0eTJITXE1MWUvQ1BOYXdpbTVocWJycnJYTmVJS0Y2Rm55ZEtsT2tnMFFJ?=
 =?utf-8?B?RlJscHdSeUlqeTFraGZScHk0S1owNS9ZTEdQRnZDOHExT2pYNmVSQklmWmp5?=
 =?utf-8?B?S2d0R0J5NDY2cktkNWdPR2RMd0NiMm9ocGxBc1FYcm42Q3piYVZUL08yM3h2?=
 =?utf-8?B?WmZpZTdJUWM0T3ZDWU9oUWhEeDlpeWFDaVU0VEZaY3VqcWVrZVJPcm5HUnVO?=
 =?utf-8?B?cm04Zk5PNWZjbG1HQUtvQUpaMk1hdjFUczluMlBrWXBhU0V0ZnJPRklnMGJn?=
 =?utf-8?Q?iE9HuvDB4Wyok2BIlQjn8f6jS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <964A7376BEC19C40A61B542467931174@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c21a8b-0fa4-4ff0-8b99-08ddb30b1fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 10:37:31.3309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y0LskmpTKkyoBBq8XSWRUY2Cmx10T5qJb/pEJXQLUP/jzmoor10ceYE2NyLUacaKT98vUk/nobEnj6DYRqcXRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTEwIGF0IDIzOjI0ICswNTMwLCBOZWVyYWogVXBhZGh5YXkgd3JvdGU6
DQo+IFVzZSAncmVncycgYXMgYSBjb250aWd1b3VzIGxpbmVhciBiaXRtYXAgaW4gIGFwaWNfe3Nl
dHwNCgkJCQkJICAgICAgXg0KCQkJCQkgICAgICBkb3VibGUgd2hpdGVzcGFjZSBoZXJlDQoNCj4g
Y2xlYXJ8dGVzdH1fdmVjdG9yKCkgd2hpbGUgZG9pbmcgYml0d2lzZSBvcGVyYXRpb25zLg0KPiBU
aGlzIG1ha2VzIHRoZSBjb2RlIHNpbXBsZXIgYnkgZWxpbWluYXRpbmcgdGhlIG5lZWQgdG8NCj4g
ZGV0ZXJtaW5lIHRoZSBvZmZzZXQgb2YgdGhlIDMyLWJpdCByZWdpc3RlciBhbmQgdGhlIHZlY3Rv
cg0KPiBiaXQgbG9jYXRpb24gd2l0aGluIHRoYXQgcmVnaXN0ZXIgcHJpb3IgdG8gcGVyZm9ybWlu
Zw0KPiBiaXR3aXNlIG9wZXJhdGlvbnMuDQo+IA0KPiBUaGlzIGNoYW5nZSByZXN1bHRzIGluIHNs
aWdodCBpbmNyZWFzZSBpbiBnZW5lcmF0ZWQgY29kZQ0KPiBzaXplIGZvciBnY2MtMTQuMi4NCg0K
U2VlbXMgdGhlIHRleHQgd3JhcCBoZXJlIGlzIGRpZmZlcmVudCBmcm9tIG90aGVyIHBhdGNoZXMs
IGkuZS4sIHRoZQ0KJ3RleHR3aWR0aCcgc2VlbXMgbXVjaCBzbWFsbGVyLg0KDQo+IA0KPiAtIFdp
dGhvdXQgY2hhbmdlDQo+IA0KPiBhcGljX3NldF92ZWN0b3I6DQoNClBlcmhhcHMgYWRkIGEgYmxh
bmsgbGluZSBoZXJlIHRvIG1ha2UgaXQgZWFzaWVyIHRvIHJlYWQgKGFsc28gY29uc2lzdGVudA0K
d2l0aCBiZWxvdykuDQoNCj4gODkgZjggICAgICAgICAgICAgbW92ICAgICVlZGksJWVheA0KPiA4
MyBlNyAxZiAgICAgICAgICBhbmQgICAgJDB4MWYsJWVkaQ0KPiBjMSBlOCAwNSAgICAgICAgICBz
aHIgICAgJDB4NSwlZWF4DQo+IGMxIGUwIDA0ICAgICAgICAgIHNobCAgICAkMHg0LCVlYXgNCj4g
NDggMDEgYzYgICAgICAgICAgYWRkICAgICVyYXgsJXJzaQ0KPiBmMCA0OCAwZiBhYiAzZSAgICBs
b2NrIGJ0cyAlcmRpLCglcnNpKQ0KPiBjMyAgICAgICAgICAgICAgICByZXQNCj4gDQo+IC0gV2l0
aCBjaGFuZ2UNCj4gDQo+IGFwaWNfc2V0X3ZlY3RvcjoNCj4gDQo+IDg5IGY4ICAgICAgICAgICAg
IG1vdiAgICAlZWRpLCVlYXgNCj4gYzEgZTggMDUgICAgICAgICAgc2hyICAgICQweDUsJWVheA0K
PiA4ZCAwNCA0MCAgICAgICAgICBsZWEgICAgKCVyYXgsJXJheCwyKSwlZWF4DQo+IGMxIGUwIDA1
ICAgICAgICAgIHNobCAgICAkMHg1LCVlYXgNCj4gMDEgZjggICAgICAgICAgICAgYWRkICAgICVl
ZGksJWVheA0KPiA4OSBjMCAgICAgICAgICAgICBtb3YgICAgJWVheCwlZWF4DQo+IGYwIDQ4IDBm
IGFiIDNlICAgIGxvY2sgYnRzICVyYXgsKCVyc2kpDQo+IGMzICAgICAgICAgICAgICAgIHJldA0K
PiANCj4gQnV0LCBsYXBpYy5vIHRleHQgc2l6ZSAoYnl0ZXMpIGRlY3JlYXNlcyB3aXRoIHRoaXMg
Y2hhbmdlOg0KPiANCj4gT2JqICAgICAgICBPbGQtc2l6ZSAgICAgIE5ldy1zaXplDQo+IA0KPiBs
YXBpYy5vICAgIDI4ODMyICAgICAgICAgMjg3NjgNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5lZXJh
aiBVcGFkaHlheSA8TmVlcmFqLlVwYWRoeWF5QGFtZC5jb20+DQo=

