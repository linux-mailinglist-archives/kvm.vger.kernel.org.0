Return-Path: <kvm+bounces-53185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9286FB0ECE5
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F0EA3A635C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEEE2797A4;
	Wed, 23 Jul 2025 08:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="APz+J+CV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C7827978C;
	Wed, 23 Jul 2025 08:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753258423; cv=fail; b=Rh1tbqcboRy9HZMvsmj8SFsVBBVSR++rW3zWu+TNPwE4RyzCXCXi4gSAO3928AJdyJ38OB139BPkLKQjhq46nmchsC6+QcFTecJl92zYcscqrmUB+M+J5s6AqknknP1PF1qtf4O8KW5lkRQ/qXZec2iRYmQMfadvnLcGlsQfkQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753258423; c=relaxed/simple;
	bh=JzgUOz5uVxMfRx1RTOJmI3VDRtNAUvgJk1svObMyVa4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I6kkUjBBHKFOr7GjZVU2sN7NqWJ0Gb8DDOGxtdTmjuOiRhvbxSdHlhjjBH6Zw9doMsNFfBZj4vw+3h/AWpXAGfGlWh62Xrlhi1pk6JD0AauQYSm57cPriJumcpIBm4kAGqai4qPrWuvOea8fgSP/sEtCbY3EBS+tfIWQYUWFB00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=APz+J+CV; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753258421; x=1784794421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JzgUOz5uVxMfRx1RTOJmI3VDRtNAUvgJk1svObMyVa4=;
  b=APz+J+CV1HiRAjDfN9MoVbcD/mqUe59Rtp5D1jL3LiFG5GODDwyS4Geb
   dRG6OOVrda+dRgOD3OOgBfD1O5X2Tvv1VYC/m6dbRmmsYZtfeok8AWsSA
   jspwjUIxWNA+80uO2zs/hFxPr7hl7u07QyvFMOWcH0q5dt5ar5sJFwJuU
   ROFvPw6BO2ooSguagFLEZjIh7jnVFpkoxLWPrXTf/4CC0/AdMWSH6i/lw
   tFLdX+Rqy6lCy5i+R5ltWPq3XW7lm3SJCokxpBakEBJhDIl23sTklXZoI
   GztBwoUdKH/Z3nXW5/6ft6jBsSTwUPBBgxsPLaTZVPZNjJKMipxcSRMOK
   w==;
X-CSE-ConnectionGUID: 6J4Rcc6/RzaUPQRt6Dqkcg==
X-CSE-MsgGUID: qoa11t4zTr+rqpPmpYUApw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55640105"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55640105"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:13:41 -0700
X-CSE-ConnectionGUID: UljT+RqgSVmQptXBG06mww==
X-CSE-MsgGUID: GsP0fDrvS/mZz7rQMrmctg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163413230"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:13:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 01:13:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 01:13:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.82) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 01:13:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Llzbhqr5W3W/oR85LzlrB/UoS4zFy4Nm/k+he/j/XXOV+Rj4hQOdAnMamQmx2YBkEhwYcXr4iqqYeRLiTZbxF9Y2TXF+40HIO8aGTZj74aQMNl553uqPXktFSmyx29mEzxCfiIsQqgz9MR8hx7frO7eFwaz1+pRgAT7TabBFXS0sRUhNP5ihA0QYNFg6I3nSjjmRgltdRWFv9Zq/7Uu3nXI4CvleAlfU/crcFfpt902V5EGWv8XXYxSlFk9MrZh490Thds8H9xm3BtI+iPNUQTa9V8DurAolrx7CKugStAWjp6T7ZxFEKgMgs821Rbq7WTWCuH1vrj4GD801+k30hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzgUOz5uVxMfRx1RTOJmI3VDRtNAUvgJk1svObMyVa4=;
 b=pg0sXR1o0coVALb9AMpT5lGml8IZXkJAuyRhouUndaNB/kRilWX3ufxFHyjN3+U+h3ZY1saMD4sSxgFe1/pWXhYebFYvGmtX6qCvb+lo9BZ2/rQEdga+ZW7STiN/AP2dx4KX2E3bzcnGddVrytZi5A31Wm2HcFo5UjXLvRTh0JAzKFF1/yiaJvD2rv67aQ3fb5kRDoOBMWeVJrd5midKAInJJA0pbH0fraKTdkXWvBIb9OO4Y803L77bWcbjktP5vXIuHTPTPFbte4m3pHx3sDgrXj5H8C5Znzf7u3/4T7OJ5J13UDQcl634vvrIEnhMJQFCRkBV/01Tz1DLS1X5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB6891.namprd11.prod.outlook.com (2603:10b6:930:5c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 23 Jul
 2025 08:13:37 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 08:13:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokAgAAYrgCAAAYskIAABDyAgAARSYCAAAKSgIACDU8A
Date: Wed, 23 Jul 2025 08:13:36 +0000
Message-ID: <dad9d6d52d5f0fabef85ae40ce293edfad530574.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
			 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
			 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
			 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
			 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
			 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
			 <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
			 <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com>
			 <c494ea025188c6b1dcf7ef97a49fcd1cf2dab501.camel@intel.com>
		 <D6A63DDD-6A33-4A78-8A3F-2A7D0ACC9902@zytor.com>
	 <c198c40d6df2d48dd6050ec003abb78c065f1b40.camel@intel.com>
In-Reply-To: <c198c40d6df2d48dd6050ec003abb78c065f1b40.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB6891:EE_
x-ms-office365-filtering-correlation-id: 90cbb697-9ef0-4334-de95-08ddc9c0d2c0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bDlnYU1BRDJtOHVlUlVRT0JQU2JKc2xMaFo4ZnNUanJHT2ZLdGNLODlKbExp?=
 =?utf-8?B?dk1yalJzSDNyZVd2NXBMREw5NGpSUnh3NTRJNlJkQjk3emMra0YvMmNFVm9E?=
 =?utf-8?B?TVdhNlJrYkxtQjgwc2l4TjJ3ZXB0VWw5b2JneTBHOVozNVB0alpnQ0oxbEFY?=
 =?utf-8?B?UFlObzF6WittRmFYZ1duUmp5NWdVWVFSS1RLVWZOQ2tWbnNUZjM2WisxOENK?=
 =?utf-8?B?dGNrQU5HczI3Y3dCL2lBS2ZCZnVTYlJQZ2VpeTlqVzJkbDcvTTk3MVJWdkg1?=
 =?utf-8?B?TDlnVDVyT1VwdGdkMW9Sek15WGo0ZVBPMHVKTTRydUh2NWdkRUVMamZPSmxV?=
 =?utf-8?B?c2JlSGw5RjhQUUpaSTZLb05adHhSN3crd3ZONlM4bjVlQ0lpaGVOOTB5eVJ5?=
 =?utf-8?B?bkhMMitZSlVCRUtQMHJlY2xrd3p3ZHM1aGN2eTVsYTM2akMwd2d4VlZkQXhZ?=
 =?utf-8?B?Mi82cEh0NUFvaENNZDJ3RlRBSFBtWjBsU2p4VGVML2hiM1FEOHBrSGtpZ0ox?=
 =?utf-8?B?Ulg4Umo4dDU1eGZEcVlXNFlNUnE0VlFoR1VaM3VNMEFsTUczeXdxTUlzeldR?=
 =?utf-8?B?b2sxK0N3RjdER2N2UGdHKzJnRm80T0xlTVhzQUZKdVJ1elpQYmIwVm1PWFFQ?=
 =?utf-8?B?M285ek81bDgwQzdUQ2ZVZytsNDEvYkJFdUVwVUZicEZ0S29XNTl6ZnF2WUFV?=
 =?utf-8?B?UVl6aHVjRGtOa3lSN3kyMXF4bkNWTng3dnFoMkxmK3doczhwcmFrSGovNWEz?=
 =?utf-8?B?QW1CRzNUSWhBS1VMakhWcVA0K0VKYnBsOWRPR1V1QVpTbnhrN05TTHhCT0FO?=
 =?utf-8?B?MzlWUkh5THV5TkF6alhqTHpCRkNPMjhpWXJMZEdEQlFiSlpaNUU2ajRvL29G?=
 =?utf-8?B?dHFhcVN5RDVhU0NSL1FzbDBycHhmbGZsZnNZTzhnRkxRQ2h5dHNWMUNMSmdh?=
 =?utf-8?B?WVByVkY0blk5ZG9SV09uaStXekt5RUhDQVpDY3hlaTBrSWYrTmRtUE4rbk0x?=
 =?utf-8?B?WUZodm5GbGZHSms1cHZlaHNFUTdFYlNTeHk0U1l0WWRlak83cmpRMk1Mc3ll?=
 =?utf-8?B?c2ZmNkREMlhIbWtaLzhmaUI2QkRPWTZhNHBFNmFWanZTS2pYNFQrUnBlaVA1?=
 =?utf-8?B?bDBkNXNXbFB3R1hhc1g5MytGM0wycFNadGI3NjUwWkNsMVhsOHhQcXNRWFdv?=
 =?utf-8?B?ekhXa1Bic2k4clhaUC9xcGJobXptbWQ0Ymh0UTg1cCszSnl1NjJyTjdCdzJj?=
 =?utf-8?B?YklZYTZ3QmJwMVE3bjBiQzgybzRNWG9ReXNwZjA1QXY5U2FyMUk0bGpwY0lT?=
 =?utf-8?B?VXpvR3BhcG9BR0RoUlVjT2FFYzVMRzlCb3lBYmpQNjF3TFlNTE0rNklJdTJ0?=
 =?utf-8?B?bFU0RHg2RURHY0xCeWxuUjB2dm1kQTZ0Qk04cFYwVVhMQU1ndXdpRlhzVFdy?=
 =?utf-8?B?ODdyTmY1cDZtVWlMa0pOdlQ3aTJQYnM2dDBTNTlXWHdoeDVNZ1Q0b0NHM0dD?=
 =?utf-8?B?Wm9xLysyeFlMUHNQSlMrRUpRaC84ZnY2NWZPb1NTTTloK0laWFdJb2w3RXRK?=
 =?utf-8?B?SjJBcFVmcDJoY2ZmMjllcUxOODlybHFuNDVVRHNCM05aUHhyemp2ZkhMb1ox?=
 =?utf-8?B?SWdOM3B3czdQSjh6WHdHSFlPeEhKNDRiRmd5SnArUEI3Y0gzaVBhM1VKaVRW?=
 =?utf-8?B?K2IybGVxMVdxR25FaTg0Wnd5RU9qM2FxalZqNmhzL0ZZeXRpdTlYMHFNTEpB?=
 =?utf-8?B?OTRPa3RDMmF4Qm9SRy9IRkRsbllrYjNNdGRLdURpcW5sVG9BOXpFampxVFFM?=
 =?utf-8?B?L2VrNEoyMXhJNFZERm1hOXVIeTkxV3MvV0NySG1peU0yelVOUmZpVEVJSWpW?=
 =?utf-8?B?eG9JS1o2bHF3UG9ha3BTREROc0EraDVnWUxnM1RmZ2NlME5BYlNjVUtOWXEr?=
 =?utf-8?B?RzBLNk9zVXBvTWZwYWlzVUdoUlRCTm1iaTIxbGVLaW9XbTd4N0UxTVZWSi9k?=
 =?utf-8?Q?FnAwYao1yZxvV8pk/K1eiEEax+oSXQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjU2RkNaL0djQjV2bnFZUGNpQVJEQjNjcjVtVSsxbGIrSFgxTzVDQ0pzMTAw?=
 =?utf-8?B?eDVwYUladVprZlB4M29oVndPNzVEY2kxQTdwK1lRTnZOQk9qOTRYWG5zeHdo?=
 =?utf-8?B?Smp6WWJpSlFHKy9tcEppRlkxSU0veEJBdzJDNVFPYm80Q01uQ1hLKzRvODBp?=
 =?utf-8?B?MTI5dGZ0Y283TE05dGgrV3E4MDZaZzZ3UVZyZkN6czE4MEhLa05UeTlZN29t?=
 =?utf-8?B?Z0NaZkoySWwrajRyRFpCdUhYOUdSTEFuQTB5V0UzU2kxL2dZVUdXT2lXdndt?=
 =?utf-8?B?aDVuRFVVOVRvbXVyUS9vZnNIV0dQY3ZKQzIvaHU4Umg2VEhSdTZyVVp5dnd5?=
 =?utf-8?B?eisvYURteEFUMmtnZW84eERDY0tVbWxMREV3YlczNGlMVDJ0MkZvcWMwS3Ey?=
 =?utf-8?B?ekJqbWxzdkRDWENOSDFsczhqTG95aVlyWGN3NW0xZlEwbEtwb2xINmlkRGFD?=
 =?utf-8?B?end1U2lDRjdmanU1QURlTjJvZk5WUk9UZmQ1d2hGRnRPa0d6NEhFci9OTFN4?=
 =?utf-8?B?QmZibWsvNFFFcE1ScEY1ejUwZVhGZW1OWngzRk4wNDUwQmpvcVg2MDFvR2Ra?=
 =?utf-8?B?Nkwwd1ZiNkptNHV0cnkzeWk1TWhsb2JYWmFDSVVsaHJQT05kdjhneG1vVm41?=
 =?utf-8?B?bEk2MThmaU1aTiszUVplMWdvTmxiL09NR2RjWWJlbWtoSm50Y3BDaHF5em5t?=
 =?utf-8?B?V1ZuTzhqbnhIRGRvU1FLbjZOaEFkRHN4ZXJ4T0xiUTJUUStzdGpJQlgzbGE3?=
 =?utf-8?B?OXFzaVQ0UVlSODVJNi9LblB6TENlWUJ5QkIvTWdCanpTaFJGTHhZMjM1THB3?=
 =?utf-8?B?T1NMakE1Tzc3cjFmdTduemRLd2J2d3QyRzBMbjR1OEQ1UnUwa2pxT0pyV2hl?=
 =?utf-8?B?eitrUWl0ZWFVRlBjTVFuTmZ4dk5Gd25ndWkzN0ZoSlYyOFhCRFRibFpCQXRB?=
 =?utf-8?B?VVgrU2EvdEVQaEZxdWxUQ09KZStkZzdiK2EyaUQ5RC83ek4waUgrQllaN0J0?=
 =?utf-8?B?WUpNcFdZd09LeUFSMjBseGJDazl0Z3BnZEo2ZmlPRCt3QWkxK2s0bDlyeW1s?=
 =?utf-8?B?UjV6cnh4VkxYOG1RNmZFR0dNYm9KYmo5SGxhOXQzVTJjKzhwL00yWm5yRkZ1?=
 =?utf-8?B?MVNoWFBFaHRkcmY1YUUvRG1oMVREVXJiS2VTRlhzMHU5c0lrbEtBKzhhaElL?=
 =?utf-8?B?NHo4WHpIN0RDbFhEbklNUk5rdDcyWnI0YlZnTDB0cEwvYTg3NjR0OXVod24x?=
 =?utf-8?B?bERhM2Jra1FMbWgzVTdhU0lrVnUxaWJWSEVIVlZaUzZ5TFA0RlFURGpYc3pt?=
 =?utf-8?B?VWxmVjN4aEx3Q3EwNGMzVWpqdmlKWXhkV3dPZFliL3JqcURHK3NLSjhQbDFi?=
 =?utf-8?B?QWp3SkRPWXV2ZU5CVS84UGhUTytJNzdlZENOdGhPYVBnQyszUW9rdE5EZzF0?=
 =?utf-8?B?ZFVjMXQ0ZktBdUNIKzA2ak9TNHcwUUVSQmhuY0JqVENRQlY0R2dNcmIvYlBB?=
 =?utf-8?B?VWx5aU5Yb1hvTFNzbys2eXlzd1YxU3B5UTZ0bDlrRlR4eXpGZ2RHOXZiaURr?=
 =?utf-8?B?YlV0SzduTkRLQ241ZUZWTjgvQmRoSGUyU1dFVjk3Z1hhdk5OUXF5WkdremRH?=
 =?utf-8?B?aWF1UVlPbDN5VXBZc24wQWIrMG1uY2JjUWZjSWt0UGpJN1A4bUZ5MUt1MTBO?=
 =?utf-8?B?c1JQQkRwb2lzbWxJRjVQMDdmSllDSmZIaHl0cWJ1cWZraFZ4SHhucndjZCtj?=
 =?utf-8?B?eDloZGs3UWJDQzFmMjR4OHM1cytCc0RsUWx1enZtY29xeHZDTklRMjB0MnVi?=
 =?utf-8?B?dXQydWVWdURXRVlNdnhGWnV3Q3d4d0ZjUW55NCtHWkxtVmxzaDNxbU9TaVpS?=
 =?utf-8?B?YlpmYXRUdW5mOUphVXlqNHk5QWVqVnFmNFNWdkxWYk9OU0dycGpacVQ3UXBu?=
 =?utf-8?B?Wk1aRHVpT3B1d255bG95dnJMMTgzR2dmcVIzdTBkS0QvNDNJK1RTTHpaa05F?=
 =?utf-8?B?R2Z0MDJNSTFZelpiak5XZFpGNFhFOCtqMzd5S2x6MktycXdIL0d0aEozK3Ji?=
 =?utf-8?B?UnVlbFliWFNicm5ncWorczZnNysxSWFvNGtFc0xpV25WaTdHcW9hWVZoaUZq?=
 =?utf-8?Q?S9FGiUALjWXIWoWZhaboXPhAC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD5660FBF6481C489CE98F708FD5D408@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cbb697-9ef0-4334-de95-08ddc9c0d2c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 08:13:36.2906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpNRy6Hvq90/TLyFp03mydfjlLU3vCuafOxtqC2ib/QySAC+FPy1UMGTFSWg1E5EaKnNLJY4w0UVWSvKNVeMIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6891
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDAwOjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjUtMDctMjEgYXQgMTc6NDQgLTA3MDAsIEguIFBldGVyIEFudmluIHdyb3RlOg0K
PiA+IE9uIEp1bHkgMjEsIDIwMjUgNDo0MjoyMiBQTSBQRFQsICJIdWFuZywgS2FpIiA8a2FpLmh1
YW5nQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjUtMDctMjEgYXQgMjM6Mjkg
KzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ID4gT24gSnVseSAyMSwgMjAyNSAyOjM2
OjQ4IFBNIFBEVCwgIkh1YW5nLCBLYWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4g
PiA+ID4gPiA+IE9uIE1vbiwgMjAyNS0wNy0yMSBhdCAxNjoyNyAtMDUwMCwgVG9tIExlbmRhY2t5
IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+ID4gPiBAQCAtMjA0LDcgKzIwMiw3IEBADQo+ID4gPiA+
ID4gU1lNX0NPREVfU1RBUlRfTE9DQUxfTk9BTElHTihpZGVudGl0eV9tYXBwZWQpDQo+ID4gPiA+
ID4gPiA+ID4gPiA+IMKgwqAJICogZW50cmllcyB0aGF0IHdpbGwgY29uZmxpY3Qgd2l0aCB0aGUg
bm93IHVuZW5jcnlwdGVkIG1lbW9yeQ0KPiA+ID4gPiA+ID4gPiA+ID4gPiDCoMKgCSAqIHVzZWQg
Ynkga2V4ZWMuIEZsdXNoIHRoZSBjYWNoZXMgYmVmb3JlIGNvcHlpbmcgdGhlIGtlcm5lbC4NCj4g
PiA+ID4gPiA+ID4gPiA+ID4gwqDCoAkgKi8NCj4gPiA+ID4gPiA+ID4gPiA+ID4gLQl0ZXN0cQkl
cjgsICVyOA0KPiA+ID4gPiA+ID4gPiA+ID4gPiArCXRlc3RxCSRSRUxPQ19LRVJORUxfSE9TVF9N
RU1fQUNUSVZFLCAlcjExDQo+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+IEht
bW0uLi4gY2FuJ3QgYm90aCBiaXRzIGJlIHNldCBhdCB0aGUgc2FtZSB0aW1lPyBJZiBzbywgdGhl
biB0aGlzDQo+ID4gPiA+ID4gPiA+ID4gPiB3aWxsIGZhaWwuIFRoaXMgc2hvdWxkIGJlIGRvaW5n
IGJpdCB0ZXN0cyBub3cuDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gVEVTVCBp
bnN0cnVjdGlvbiBwZXJmb3JtcyBsb2dpY2FsIEFORCBvZiB0aGUgdHdvIG9wZXJhbmRzLA0KPiA+
ID4gPiA+ID4gPiA+IHRoZXJlZm9yZSB0aGUgYWJvdmUgZXF1YWxzIHRvOg0KPiA+ID4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gPiA+IMKgCXNldCBaRiBpZiAiUjExIEFORCBCSVQoMSkgPT0gMCIu
DQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gV2hldGhlciB0aGVyZSdzIGFueSBv
dGhlciBiaXRzIHNldCBpbiBSMTEgZG9lc24ndCBpbXBhY3QgdGhlIGFib3ZlLCByaWdodD8NCj4g
PiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IERvaCEgTXkgYmFk
LCB5ZXMsIG5vdCBzdXJlIHdoYXQgSSB3YXMgdGhpbmtpbmcgdGhlcmUuDQo+ID4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBOcCBhbmQgdGhhbmtzISBJJ2xsIGFkZHJlc3Mg
eW91ciBvdGhlciBjb21tZW50cyBidXQgSSdsbCBzZWUgd2hldGhlcg0KPiA+ID4gPiA+ID4gQm9y
aXMgaGFzIGFueSBvdGhlciBjb21tZW50cyBmaXJzdC4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFlvdSBjYW4gdXNlIHRlc3RiIGluIHRoaXMgY2FzZSB0byBzYXZlIDMgYnl0
ZXMsIHRvby4NCj4gPiA+ID4gDQo+ID4gPiA+IFllYWggSSBjYW4gZG8gdGhhdCwgdGhhbmtzIGZv
ciB0aGUgaW5mbyENCj4gPiA+IA0KPiA+ID4gSSBqdXN0IHRyaWVkLiAgSSBuZWVkIHRvIGRvOg0K
PiA+ID4gDQo+ID4gPiAJdGVzdGIJJFJFTE9DX0tFUk5FTF9IT1NUX01FTV9BQ1RJVkUsICVyMTFi
DQo+ID4gPiANCj4gPiA+IGluIG9yZGVyIHRvIGNvbXBpbGUsIG90aGVyd2lzZSB1c2luZyBwbGFp
biAlcjExIGdlbmVyYXRlczoNCj4gPiA+IA0KPiA+ID4gYXJjaC94ODYva2VybmVsL3JlbG9jYXRl
X2tlcm5lbF82NC5TOjIxMjogRXJyb3I6IGAlcjExJyBub3QgYWxsb3dlZCB3aXRoDQo+ID4gPiBg
dGVzdGInDQo+ID4gPiANCj4gPiA+IEknbGwgZG8gc29tZSB0ZXN0IGFuZCBpZiB0aGVyZSdzIG5v
IHByb2JsZW0gSSdsbCBzd2l0Y2ggdG8gdXNlIHRoaXMgd2F5LA0KPiA+ID4gYXNzdW1pbmcgaXQg
c3RpbGwgc2F2ZXMgdXMgMy1ieXRlcy4NCj4gPiA+IA0KPiA+IA0KPiA+IFRoYXQgd29ya3MganVz
dCBmaW5lLg0KPiANCj4gWWVhaCBJIGhhdmUgbm93IHRlc3RlZC4gVGhhbmtzIDotKQ0KDQpTb3Jy
eSBmb3IgbXVsdGlwbGUgZW1haWxzLiAgT25lIG1pbm9yIHRoaW5nIHJlbGF0ZWQgdG8gdXNpbmcg
dGVzdGI6DQoNCldpdGggdGhpcyBwYXRjaCB0aGVyZSdzIG9uZSBtb3ZsIHRvIFIxMToNCg0KICAg
IG1vdmwgICAgJFJFTE9DX0tFUk5FTF9QUkVTRVJWRV9DT05URVhULCAlcjExZA0KDQpJIHRoaW5r
IGl0IHdvdWxkIGJlIGJldHRlciB0byBtYWtlIGl0IGNvbnNpc3RlbnQgd2l0aCB0ZXN0YjoNCg0K
ICAgIG1vdmIgICAgJFJFTE9DX0tFUk5FTF9QUkVTRVJWRV9DT05URVhULCAlcjExYg0KDQpQbGVh
c2UgbGV0IG1lIGtub3cgaWYgdGhlcmUncyBhbnkgY29uY2Vybj8NCg==

