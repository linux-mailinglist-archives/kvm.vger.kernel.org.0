Return-Path: <kvm+bounces-51206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CABD3AEFF48
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 18:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E090317AAC2
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62FF27C844;
	Tue,  1 Jul 2025 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HE+nOURn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5265327A92B;
	Tue,  1 Jul 2025 16:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751386515; cv=fail; b=gZPQyeMzCkUEGKn+25+dwjgHaHDjs+bEmcuc/WnaTxfzCa6dv1RT120auYN4PTBts7cUXECaYRpslXNJ9zGHPaoRTQtNsYC/0tiE/mLQX89DWJrpeTrLWRFoCFc6BetRYaYB5MZd8idnoVM3lSxnU4foH/+38ZkMmIshTjoeFMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751386515; c=relaxed/simple;
	bh=/lxdw4n2IIiFNDMy9Q1A8NgoH1yLchsLs8u9huUALxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YNus+j+ASwGDYvBtCSxL6vxYD+YxiRxS0nrV30ox2Qwf7bjJOxr1dheVk7AsWg9/4n9RT2bfImDY9XytIb/uTd7DRF0euEXY2x6QYs/lJu5+ug56eTtdJ530L9fBpNqO7EQ4C5/Stg5CHOmtL8RuN4xcziIKWLcorIY3pxLNAnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HE+nOURn; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751386513; x=1782922513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/lxdw4n2IIiFNDMy9Q1A8NgoH1yLchsLs8u9huUALxE=;
  b=HE+nOURnT6Xmj8uBZnZzmMRhpzGppGs6Lr3YMSaKJKOHd9E+ZdbExWBJ
   ia2wtJtPnZSOB/DsjKkZoZ7/BPPMwXAZTKL8srjJYkCrxKwX5kkF8Lyzp
   YxE2+FtjRu8vIXS+oZYo4ymzuVvYp1Ugzp3ou1YyvV+4oASS/cABajMNN
   FHqmcyNJG+SRB2GAttXsrY/2MW95I2qUSp2njj2W+4txXSuivK5dNCWm5
   I717OTJ0rTiDFHIUmQRXderUwPDfmj7t1/PNR3LvO36zN9HgPoq9eRkKY
   5KZmDurjJIku3CUbYyPgaQG2ZOCdeCYh7eBo1ev7qy/9YDQoqlB82ZSGy
   g==;
X-CSE-ConnectionGUID: JYlCI6KOR8ikiPE8+eiuyQ==
X-CSE-MsgGUID: wkJ22kUnQsWiewYugf8JKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="52892751"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="52892751"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:15:12 -0700
X-CSE-ConnectionGUID: Rq2HKpUtRoKHbnd7+8U/pQ==
X-CSE-MsgGUID: wLDTaS26Q9KTUWW39ZJR4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="159327671"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 09:15:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:15:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 09:15:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.64)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 09:15:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxyALLcpkw4wORZLwVpyXqgsA4dPBR/N+GOgQSdCfEfyB0i/Dk7t8IMPmYklFqIgxBMA5IDwtcqKtYzmenHznq0gNek3Dy4Nld9DhTtrkW6f59DPZnOI0jNxsj3QGafj/lfx/Jw8yvczwJLzDFPYyMhzFZA6FUjY4PZqv0DP/N2ZzE1azS7Jz0iAoCSOtU+azX2eykaPG+ZZvVTG+CvvPDEYP6rGbs2RAW5pjcUwjzCtOjlQ2Aa+/VkrRg9odxza51LodPlaZ46dOYABfjW93o+vtEUrTyArqFsFyJQbAKHQa25NghWSGS8zH+iEA5jrn0FFPAhEY0ly7AhnXTl3bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lxdw4n2IIiFNDMy9Q1A8NgoH1yLchsLs8u9huUALxE=;
 b=L7jMJk8iVrJu432dQ8XoBlP9mlqPDdAdEaPTDR1htUKC4lw1m6C9NPr6743SbBr1li1cpdlWhK+CKYAweuibw2hLZtHmMEz+pA77BAGxSQNIoyhoBP4POquERR7sevqC5okF8MWwfHw7HcL18vxOPOiVRE3R+jyuitMmYKKWU2H8hruH1byxapRWBsHoWKlu93/k07TmYcf1ovRccggINiQkVFBmA1w6e+dmgQalYcGFOaqm5qjDBh0HcNEsRmqOSs8b94+1rdxhOqsciNlRKotCCXKIboEDx83TzouusFGNoIscbtcQrAFcXo5QBd60FXdSHxWjamD2E9MsiN9p3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7042.namprd11.prod.outlook.com (2603:10b6:806:299::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 1 Jul
 2025 16:14:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Tue, 1 Jul 2025
 16:14:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAAQargIAAQigAgAAtRYA=
Date: Tue, 1 Jul 2025 16:14:40 +0000
Message-ID: <e9c9470a71ed2c1a5b3715cc8dd5fce79309c5cf.camel@intel.com>
References: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
	 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <aGOr90RZDLEJhieE@yzhao56-desk.sh.intel.com>
	 <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
In-Reply-To: <CAGtprH86-HkfnTMmwdPsKgXxjTomvMWWAeCuZKSieb5o6MvRPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7042:EE_
x-ms-office365-filtering-correlation-id: d2dbe1e4-41c9-4ef4-88ac-08ddb8ba622a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q2RCM3BWUVREY2J5aWVRZlZkaEJ2M0ZLb215VlNhNHNoa0dwZTRsaFVrdWZ3?=
 =?utf-8?B?cmVsOEJac1pSZFZaVWpiVkhrditJaTY0NjRwSGlSblQvOGFLc1RRYnVWQXpP?=
 =?utf-8?B?RGhDeFBLamNuclppWlVnOUtuZk8rNE5UOXdHSG5VOVpDdGREazc4VVlTbC9h?=
 =?utf-8?B?NEFhbFY4YWNtdGlUOWNiL3pYQUg2TTI0RXZGU1UvWEkvK1dDeDAwYTRJdzJa?=
 =?utf-8?B?ZTNOdllvWit5UStsa1FjSDVScXg4ZkpDUGJsc2k2UU1VRUhOM0tRb2pRN1hw?=
 =?utf-8?B?Yk5sTVZUakhicW5CTTY5bTVUVHlOYjAxS1FtWFNDOHEvY1NBWTFQRmU1R0J5?=
 =?utf-8?B?YzVzcWVFMGI2K05qaSs3WjdKTmRvKzE1VnNmZ0t4d1MvSWt3VS8wQWMwTGly?=
 =?utf-8?B?TjN6OURObG01N09FQVRZcERiOVpsdGZlYVNPYnUvUkhLUkVIcnlJT0JWeDVp?=
 =?utf-8?B?NDJxMmNwQnhOV1MyZ2hUekI2R3B2VWxwOVhWdWd1eTlscGgxSWRUekhQUGV1?=
 =?utf-8?B?OXhrU0xReXBiK1JzQzAxSmRzUmtZRHpUTFJGQ2dyTkh6ZkN1czcrai9JN1FT?=
 =?utf-8?B?L0dFaDkya09JTWdzZXcxYmE5N0dhZmhKa2QydWlwNWtoWXkyN1FhK1BwcG8x?=
 =?utf-8?B?dnhUMm54dnNZM1poaUtNT1EzbjE1ZklSYUkyVGk3U3FFY2lYcWpmc0t4bXFw?=
 =?utf-8?B?bmxrWGFQUCtTYTJFTjNrZnFNRUV3bWErbTlaM0dna293bTJnMm5TSTd2Nmxq?=
 =?utf-8?B?YWU0SkNBazlDcEsxY2VqYjZnMXkvZ3I4MCtsSklpcUVTZm9GckNGRUpMdUVW?=
 =?utf-8?B?UktpYXk0M0NNMEpZQ3dkY0EvaGExV2hjcVluTC9KY3B2dTZFS1B4ZGVySURs?=
 =?utf-8?B?V0diK0dTTHNlSmY2aXh4RUM2VmNIRE1jQVhXVlZzUGNsckVmYUtrVmRJOWdt?=
 =?utf-8?B?bmxKaXdLMEl1WmN6ZWI0L1NtQkN2RzFqK2ErMjRrVW0yMFl2NlV0V1dPYkd3?=
 =?utf-8?B?MEUzQ2ZFY1dkZU85Q21ZNU53WkRwRVd2a1MwenVOYWx5QjNXUSsvdytjNHlr?=
 =?utf-8?B?Wm00REpZcyt3VVc4UWVlQWc0ZHRvbEVpeXF1c25HNVBJcTdkcXBSNGhweGQw?=
 =?utf-8?B?bTJGekh3WFpPV2oxRGh5TnIya3cxWm9QalJRaHlVZ0JJbEJmSHd5blNFNzFP?=
 =?utf-8?B?dTdZbWp3QW9MTkdGSFlGOW44VWNZQ0I5R2Ntam1SUk5ERWtyNUhRK0ErY1hT?=
 =?utf-8?B?eFdqODJ3WlFER1YybVBMYXBZdmN5MlVmbnV5VkdYbXd6ZjhrYzlsU25ZS1Vp?=
 =?utf-8?B?NUpBV2FoM0t6ZnNsL29sS1ViNkJkSUxLV1UvZjBPTjhvV0o3NmNlcHdHQmxG?=
 =?utf-8?B?WnJxL0F3ZkphekFMT0lsZ0IrNjBmd0ROcnNQVmNIUEJVOUozNXZKTkRKQ2h3?=
 =?utf-8?B?RHlYdGxNc012WjdhRzlQdmNnaWVxR1ZVbXQ4SVZiakRHOU93MXZHQzFJaGlV?=
 =?utf-8?B?ZjYvdm5lbFZiUjRTenZLTWg3ZnZhOEN2UEQ5K0g1UWNvV3pkWFRQNUU2TmVH?=
 =?utf-8?B?Q0xIaW5xZTdacDR6amFqbHoyTFNVcXdSanU1UWt1YkFQUnE3clgvcnVxcTdw?=
 =?utf-8?B?ME45UFFkczg5TzVnWW9zTWFpMWk4Wi83Zk1xOGhvZHBnaXFpdXNHdEo0bEJq?=
 =?utf-8?B?NWxYbU9qNm9NOHhRNDN1M2xlbnYzbkhDVy9UeUJmaHp4Wm94d1hESFlxTnpB?=
 =?utf-8?B?NUI3aGQzUmkvSThGMUhyWVBCbGFqNFJRTzA2dHZ5STJIakttT2dpdGw0c0J3?=
 =?utf-8?B?TEU1bi9kakkycUhTbWdtdnZpK014VVUzck5JcnU2SDkraWdiS256K0hUOGdi?=
 =?utf-8?B?SDB6RzRlMGc4ZkpNWXFYZ1RZTjRIK1hkcGlFQTBwOVlIeGVFTkQzRGQ2akZv?=
 =?utf-8?B?TTh5ZmhyTGI2Y25kak93aHpYNVExUis3TVJ2VzdsWHpILzQxUWpsQmVwTWRS?=
 =?utf-8?Q?2VtoKrSs80h7TmcTVoJqNbiX9mN98Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEsvS3U0RnhQU0xxTDExQjNrckhIaVVKWldneVdqSjQvU2ZTYUx5dTFWQWN4?=
 =?utf-8?B?Z1BkOEEwSzN3TW9Ic0dQYTRqQ0dPUnRsZklsY0xIM1A2N1pVaHdPNDRvZEcr?=
 =?utf-8?B?QkxTRzdWSzcxdmxrYklHeVZuQ21aR3M3K3c5NkJFTllpc0ZCNkJZcVppZjBp?=
 =?utf-8?B?Nm1sVXF0MTZzVjlQTHl4TjJDS2I0MDg1Y2xMUHJHdDd0K29rVEZNVFMyeU5M?=
 =?utf-8?B?WUtjNVFxRVh4OVVEb3RCSndqSVZ6bndoeDRvQjJtckkwTW94Z0FEMXQ1MHNq?=
 =?utf-8?B?WkFrbGJVRzJJbnJkSVNRU2MyMExCd0dPUUpuajRpRFJoN2YzR3U3aExzUjM2?=
 =?utf-8?B?S2Y2TTQ1UDFCaEtzVmpBbFRIZ3BMYU9JWWUyNzh6M2F6c1J5Y0x0SWxMbkpV?=
 =?utf-8?B?eSszbGFVTGJLQlFydkxXblMzV0NLMmR6QTVBTElCd1ZqMXRwbTV6V0JoUnJH?=
 =?utf-8?B?M1ozL2pRdXpDeXF1SllzOEx5K3FkN3gvMmpEU0MzcStnVldkcEJveXJVL2RQ?=
 =?utf-8?B?Mk5VdVBReFNVdFY2NmREVGJ3eWFsTHpQaG5MM1ZzRkJWWUN3aE80VW5TdTkr?=
 =?utf-8?B?MGlzTjl6Skw3c3ZvQ2w1OGUvdHpzUkw2ajBRWWc5Skw2Q3dhWk9UaGs2dVhx?=
 =?utf-8?B?NGlkanJoTVdwWk5UbUlqT1pLTUttalhoVEY5aE9UQ011bGdBSXJ3Ui9HMU5m?=
 =?utf-8?B?WWJpcFNleWs0TW04Wk5XaFFQZnFwdjg2RnNleXhFZlF5Z2FWWk4wSHV0THNE?=
 =?utf-8?B?ekdNZGx0ZGJTSFdYdVhlNGdzejBORk9CVHpPSnhFU0xOYU1tN3RUMEpnSCtn?=
 =?utf-8?B?SUZxb0RkQTREU2tYdHVEU2RlYi9ZQURFbkR5cy9NUzdBaGdFbHJwOXlFZGhN?=
 =?utf-8?B?KzVYRXU0dkErd0tJcExBR2lNZ1FSY2dBdTJVMkx1Y25oVTlEekFjWVN2RDZV?=
 =?utf-8?B?SlV3Q1dOK0tWZHVvRnlzRmlmQ04vV2huWjVkN3BHOG5YUTRPVkF4aWNoa2Jx?=
 =?utf-8?B?VllkelI3V29qSy9VNVlNMXMwQS91ckZJVEhTZkplMUVxOUQ2WTFBZ01ucGxB?=
 =?utf-8?B?MkdudjBCODJrUW1pcHloVVlJKzJld3Z1RHMySy9zL3ZSYnBJaGhXUFV2MWFF?=
 =?utf-8?B?SGJFSWltcDM1N1ZTbmVIY3ArTGtaWDI1L3p1enZQc20zSThSaWR0TGloUlNp?=
 =?utf-8?B?Y3FxNkxpY3BFd2JKMUpvOXBBSlNxcnlnb1NTazQweEZDbGM3b3JiVXRXZ2E4?=
 =?utf-8?B?Z1lrWVQzN0JpaCtMLzdkalhzSXY1dDcrRjduV29jZDhJckdsM080V3QvRVNN?=
 =?utf-8?B?UHhLcDFHY1FDQmkzNGUySnY3VVlkaTZyR2R3S0FkM09GU01JS2o4bFpWVkVx?=
 =?utf-8?B?SGNaSDMzcGF4Q0VxcnVaRjRzamoxd28zdGxnSWNJYmRjZmp6ZDl2UitWNzYz?=
 =?utf-8?B?b05ZaTAyUWgzRTJ3WkVRajk5UUVUamo0bkdUVUswYkhBcXZ0aERKd01vaXRv?=
 =?utf-8?B?ZjVuQ28zcC8wNDVXcnJ6WkN2NkNVdE56bmJ5aE1zWmFXLzExOFdRRThERjRY?=
 =?utf-8?B?VjJTc1VTRGdIQlZXVGZIRG5DaDRMVTkxU2RiWTFvT0ZnTG9KSjRnbzhRSUFu?=
 =?utf-8?B?VDFJZDVLTm84aXRJZFBRcHBJKzZ5RW8vb29mYXhXRTlHMm9SWUJXYkpocStQ?=
 =?utf-8?B?M0w3WEM3VHVPaWQ5R3Z6TS9PUDhLMS9UMWNJbFpEbU9RTHdZWEtLK1RFRjly?=
 =?utf-8?B?S0pYaGVlaGdIdkRyOHJWaTJObzdhM3dGTW15bTdHVHFQZGtPWUhHVnRxV1R5?=
 =?utf-8?B?Ylk1VGRMK2hpUktIMGhFOFY0VktZeEJPK3krMnhucDJjKzFTL2NhR1NzUmx0?=
 =?utf-8?B?ZDFJalo1a3VqcStoK3JzWW1LVkRsWWkyZnBWWEJJRjhhbmRJNzRxd2Y5UTJD?=
 =?utf-8?B?K1lva1pJUDJ2TENRM1BMU1kzMWVBSlN0V1FZWisxenlzZ25GSnEzY0RZYUQx?=
 =?utf-8?B?d2hWd0tjTHlBa0VSR2srRGlwVjJLQ0YzeVp2TDN1RUZJMTlXZFljd1JyQThk?=
 =?utf-8?B?elNPQ0R5eXJEK1BqZUI1TFVxWWcrMUhISEtjZ1ZDaUxkSERxcmpoV3lHanR2?=
 =?utf-8?B?dmJBeUhzYWt0V2JPdWpmSVZMMXZWNGpTSnlxK0pYZFZ1K2MrTlQxQURBVzhI?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9853D0B181D9A42A072F40D1EB6BED1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2dbe1e4-41c9-4ef4-88ac-08ddb8ba622a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2025 16:14:40.6506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eHg6NWaVZvIfr8aOPHR/6IyLUrsDIeuWYtCZZu4dhro747M4FxnYXMW2AG/o0lWYXQ9bXkLek7auXebLXDds3XoNTDRCvNOkqy6O3hYqj5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7042
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTAxIGF0IDA2OjMyIC0wNzAwLCBWaXNoYWwgQW5uYXB1cnZlIHdyb3Rl
Og0KPiBPbiBUdWUsIEp1bCAxLCAyMDI1IGF0IDI6MzjigK9BTSBZYW4gWmhhbyA8eWFuLnkuemhh
b0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgSnVsIDAxLCAyMDI1IGF0IDAx
OjU1OjQzQU0gKzA4MDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+ID4gU28gZm9yIHRo
aXMgd2UgY2FuIGRvIHNvbWV0aGluZyBzaW1pbGFyLiBIYXZlIHRoZSBhcmNoL3g4NiBzaWRlIG9m
IFREWCBncm93IGENCj4gPiA+IG5ldyB0ZHhfYnVnZ3lfc2h1dGRvd24oKS4gSGF2ZSBpdCBkbyBh
biBhbGwtY3B1IElQSSB0byBraWNrIENQVXMgb3V0IG9mDQo+ID4gPiBTRUFNTU9ERSwgd2Jpdm5k
LCBhbmQgc2V0IGEgIm5vIG1vcmUgc2VhbWNhbGxzIiBib29sLiBUaGVuIGFueSBTRUFNQ0FMTHMg
YWZ0ZXINCj4gPiA+IHRoYXQgd2lsbCByZXR1cm4gYSBURFhfQlVHR1lfU0hVVERPV04gZXJyb3Is
IG9yIHNpbWlsYXIuIEFsbCBURHMgaW4gdGhlIHN5c3RlbQ0KPiA+ID4gZGllLiBaYXAvY2xlYW51
cCBwYXRocyByZXR1cm4gc3VjY2VzcyBpbiB0aGUgYnVnZ3kgc2h1dGRvd24gY2FzZS4NCj4gPiBB
bGwgVERzIGluIHRoZSBzeXN0ZW0gZGllIGNvdWxkIGJlIHRvbyBzZXZlcmUgZm9yIHVubWFwIGVy
cm9ycyBkdWUgdG8gS1ZNIGJ1Z3MuDQo+IA0KPiBBdCB0aGlzIHBvaW50LCBJIGRvbid0IHNlZSBh
IHdheSB0byBxdWFudGlmeSBob3cgYmFkIGEgS1ZNIGJ1ZyBjYW4gZ2V0DQo+IHVubGVzcyB5b3Ug
aGF2ZSBleHBsaWNpdCBpZGVhcyBhYm91dCB0aGUgc2V2ZXJpdHkuIFdlIHNob3VsZCB3b3JrIG9u
DQo+IG1pbmltaXppbmcgS1ZNIHNpZGUgYnVncyB0b28gYW5kIGFzc3VtaW5nIGl0IHdvdWxkIGJl
IGEgcmFyZQ0KPiBvY2N1cnJlbmNlIEkgdGhpbmsgaXQncyBvayB0byB0YWtlIHRoaXMgaW50cnVz
aXZlIG1lYXN1cmUuDQoNClllcywgaXQgZG9lcyBzZWVtIG9uIHRoZSBsaW5lIG9mICJ0b28gc2V2
ZXJlIi4gQnV0IGtlZXBpbmcgYSBsaXN0IG9mIHBhZ2VzIHRvDQpyZWxlYXNlIGluIGEgbm9uLWF0
b21pYyBjb250ZXh0IHNlZW1zIHRvIGNvbXBsZXggZm9yIGFuIGVycm9yIGNhc2UgdGhhdCAoc3Rp
bGwNCm5vdCAxMDAlIGNsZWFyKSBpcyB0aGVvcmV0aWNhbC4NCg0KSW4gdGhlIGFyZ3VtZW50IG9m
IGl0J3MgdG9vIHNldmVyZSwgaXQncyBjbG9zZSB0byBhIEJVR19PTigpIGZvciB0aGUgVERYIHNp
ZGUgb2YNCnRoZSBrZXJuZWwuIEJ1dCBvbiB0aGUgYXJndW1lbnQgb2YgaXQncyBub3QgdG9vIHNl
dmVyZSwgdGhlIHN5c3RlbSByZW1haW5zDQpzdGFibGUuDQoNCj4gDQo+ID4gDQo+ID4gPiBEb2Vz
IGl0IGZpdD8gT3IsIGNhbiB5b3UgZ3V5cyBhcmd1ZSB0aGF0IHRoZSBmYWlsdXJlcyBoZXJlIGFy
ZSBhY3R1YWxseSBub24tDQo+ID4gPiBzcGVjaWFsIGNhc2VzIHRoYXQgYXJlIHdvcnRoIG1vcmUg
Y29tcGxleCByZWNvdmVyeT8gSSByZW1lbWJlciB3ZSB0YWxrZWQgYWJvdXQNCj4gPiA+IElPTU1V
IHBhdHRlcm5zIHRoYXQgYXJlIHNpbWlsYXIsIGJ1dCBpdCBzZWVtcyBsaWtlIHRoZSByZW1haW5p
bmcgY2FzZXMgdW5kZXINCj4gPiA+IGRpc2N1c3Npb24gYXJlIGFib3V0IFREWCBidWdzLg0KPiA+
IEkgZGlkbid0IG1lbnRpb24gVERYIGNvbm5lY3QgcHJldmlvdXNseSB0byBhdm9pZCBpbnRyb2R1
Y2luZyB1bm5lY2Vzc2FyeQ0KPiA+IGNvbXBsZXhpdHkuDQo+ID4gDQo+ID4gRm9yIFREWCBjb25u
ZWN0LCBTLUVQVCBpcyB1c2VkIGZvciBwcml2YXRlIG1hcHBpbmdzIGluIElPTU1VLiBVbm1hcCBj
b3VsZA0KPiA+IHRoZXJlZm9yZSBmYWlsIGR1ZSB0byBwYWdlcyBiZWluZyBwaW5uZWQgZm9yIERN
QS4NCj4gDQo+IFdlIGFyZSBkaXNjdXNzaW5nIHRoaXMgc2NlbmFyaW8gYWxyZWFkeVsxXSwgd2hl
cmUgdGhlIGhvc3Qgd2lsbCBub3QNCj4gcGluIHRoZSBwYWdlcyB1c2VkIGJ5IHNlY3VyZSBETUEg
Zm9yIHRoZSBzYW1lIHJlYXNvbnMgd2h5IHdlIGNhbid0DQo+IGhhdmUgS1ZNIHBpbiB0aGUgZ3Vl
c3RfbWVtZmQgcGFnZXMgbWFwcGVkIGluIFNFUFQuIElzIHRoZXJlIHNvbWUgb3RoZXINCj4ga2lu
ZCBvZiBwaW5uaW5nIHlvdSBhcmUgcmVmZXJyaW5nIHRvPw0KDQpJJ20gd29uZGVyaW5nIGFib3V0
IHRoZSAic29tZXRoaW5nIHdlbnQgd3JvbmcgYW5kIHdlIGNhbid0IGludmFsaWRhdGUiIHBhdHRl
cm4uDQpMaWtlIHRoZSBkZXZpY2UgcmVmdXNlcyB0byBjb29wZXJhdGUuDQoNCj4gDQo+IElmIHRo
ZXJlIGlzIGFuIG9yZGVyaW5nIGluIHdoaWNoIHBhZ2VzIHNob3VsZCBiZSB1bm1hcHBlZCBlLmcu
IGZpcnN0DQo+IGluIHNlY3VyZSBJT01NVSBhbmQgdGhlbiBLVk0gU0VQVCwgdGhlbiB3ZSBjYW4g
ZW5zdXJlIHRoZSByaWdodA0KPiBvcmRlcmluZyBiZXR3ZWVuIGludmFsaWRhdGlvbiBjYWxsYmFj
a3MgZnJvbSBndWVzdF9tZW1mZC4NCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9s
a21sL0NBR3RwckhfcWg4c0VZM3MtSnVjVzNuMVd2b3E3amRWWkREb2t2RzVIelBmMEhWMj1wZ0Bt
YWlsLmdtYWlsLmNvbS8jdA0KDQpUaGUgZ2VuZXJhbCBnaXN0IHNlZW1zIHRvIGJlIHRoYXQgZ3Vl
c3RtZW1mZCBzaG91bGQgYmUgdGhlIG5lcnZlIGNlbnRlciBvZiB0aGVzZQ0KZGVjaXNpb25zLCBh
bmQgaXQgc2hvdWxkIGJlIGdpdmVuIGVub3VnaCBpbmZvcm1hdGlvbiB0byBtYWtlIHRoZSBkZWNp
c2lvbnMgdG8NCmludmFsaWRhdGUgb25seSB3aGVuIHN1Y2Nlc3MgaXMgZ3VhcmFudGVlZC4gTWFr
ZXMgc2Vuc2UuDQoNCkluIHRoaXMgY2FzZSB3ZSBjYW4ndCBrbm93IHRoZSBjb25kaXRpb24gYWhl
YWQgb2YgdGltZS4gSXQgaXMgYSBURFgtb25seQ0KcHJvYmxlbT8gSWYgaXQgaXMsIHRoZW4gd2Ug
bmVlZCB0byBtYWtlIFREWCBiZWhhdmUgbW9yZSBsaWtlIHRoZSBvdGhlcnMuIE9yIGhhdmUNCnNp
bXBsZSB0byBtYWludGFpbiBjb3Atb3V0cyBsaWtlIHRoaXMuDQoNCj4gDQo+ID4gDQo+ID4gU28s
IG15IHRoaW5raW5nIHdhcyB0aGF0IGlmIHRoYXQgaGFwcGVucywgS1ZNIGNvdWxkIHNldCBhIHNw
ZWNpYWwgZmxhZyB0byBmb2xpb3MNCj4gPiBwaW5uZWQgZm9yIHByaXZhdGUgRE1BLg0KPiA+IA0K
PiA+IFRoZW4gZ3Vlc3RfbWVtZmQgY291bGQgY2hlY2sgdGhlIHNwZWNpYWwgZmxhZyBiZWZvcmUg
YWxsb3dpbmcgcHJpdmF0ZS10by1zaGFyZWQNCj4gPiBjb252ZXJzaW9uLCBvciBwdW5jaCBob2xl
Lg0KPiA+IGd1ZXN0X21lbWZkIGNvdWxkIGNoZWNrIHRoaXMgc3BlY2lhbCBmbGFnIGFuZCBjaG9v
c2UgdG8gcG9pc29uIG9yIGxlYWsgdGhlDQo+ID4gZm9saW8uDQo+ID4gDQo+ID4gT3RoZXJ3aXNl
LCBpZiB3ZSBjaG9vc2UgdGR4X2J1Z2d5X3NodXRkb3duKCkgdG8gImRvIGFuIGFsbC1jcHUgSVBJ
IHRvIGtpY2sgQ1BVcw0KPiA+IG91dCBvZiBTRUFNTU9ERSwgd2Jpdm5kLCBhbmQgc2V0IGEgIm5v
IG1vcmUgc2VhbWNhbGxzIiBib29sIiwgRE1BcyBtYXkgc3RpbGwNCj4gPiBoYXZlIGFjY2VzcyB0
byB0aGUgcHJpdmF0ZSBwYWdlcyBtYXBwZWQgaW4gUy1FUFQuDQo+IA0KPiBndWVzdF9tZW1mZCB3
aWxsIGhhdmUgdG8gZW5zdXJlIHRoYXQgcGFnZXMgYXJlIHVubWFwcGVkIGZyb20gc2VjdXJlDQo+
IElPTU1VIHBhZ2V0YWJsZXMgYmVmb3JlIGFsbG93aW5nIHRoZW0gdG8gYmUgdXNlZCBieSB0aGUg
aG9zdC4NCj4gDQo+IElmIHNlY3VyZSBJT01NVSBwYWdldGFibGVzIHVubWFwcGluZyBmYWlscywg
SSB3b3VsZCBhc3N1bWUgaXQgZmFpbHMgaW4NCj4gdGhlIHNpbWlsYXIgY2F0ZWdvcnkgb2YgcmFy
ZSAiS1ZNL1REWCBtb2R1bGUvSU9NTVVGRCIgYnVnIGFuZCBJIHRoaW5rDQo+IGl0IG1ha2VzIHNl
bnNlIHRvIGRvIHRoZSBzYW1lIHRkeF9idWdneV9zaHV0ZG93bigpIHdpdGggc3VjaCBmYWlsdXJl
cw0KPiBhcyB3ZWxsLg0KDQpJdCdzIHRvbyBoeXBvdGhldGljYWwgdG8gcmVhc29uIGFib3V0LiBJ
TU8sIHdlIG5lZWQgdG8ga25vdyBhYm91dCBzcGVjaWZpYw0Kc2ltaWxhciBwYXR0ZXJucyB0byBq
dXN0aWZ5IGEgbW9yZSBjb21wbGV4IGZpbmUgZ3JhaW5lZCBwb2lzb25pbmcgYXBwcm9hY2guDQoN
Cg==

