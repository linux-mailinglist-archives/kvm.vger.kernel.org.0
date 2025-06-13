Return-Path: <kvm+bounces-49547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F654AD98BB
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 01:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A01B3B8185
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD61F28C02C;
	Fri, 13 Jun 2025 23:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jz4Wgaop"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03967230274;
	Fri, 13 Jun 2025 23:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857633; cv=fail; b=Neqddhgyyyb0lVc5UWbhwP6s1e9AfCYtdH6y054U5YCRlTP/t2T/g9nBXTastX/PAmw02PrrPwVcapl4xeSfQNF7Vm2Sc9YV4K140VRd8dt06zLNycwqOL3ktirSAQrqw2UMCOSTY4Kj9zI0xVNkCmMqP2goNu2k8+kZDy+oz/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857633; c=relaxed/simple;
	bh=unaFMjJFXeb59AHeZLL+UCGllKLkvERGXROaoOanuvs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mXaUTyotTLQ0rsWfe51DcV1q0ii3phNsF2Ov+MJk9tM7xRwaz+dUAlTcoYz8bRbUfS8Fq/XMgg77Tv198UaPyAxbXhatL8DAZoVAHAA6ux6wEBfja0lW9Swb6SC3qd7naMR5zJyLFnfjIIZTo5FXL4dL42fYYhDve6ycV9ddrBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jz4Wgaop; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749857632; x=1781393632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=unaFMjJFXeb59AHeZLL+UCGllKLkvERGXROaoOanuvs=;
  b=jz4Wgaopbast5+0rsczucksuW4bl5krpdVcUVB2nZFj1ly4sCZjaBSSs
   oAhd886cJ5bqZsgLN/LUjvGf5wsM7WqTP88qLGznEXJUMvzHWXe/63YMi
   5eLd02nD3zUs1qEVb23yNTZEfqPq0A59U7Ts96nNvLd31oCQDxfqcrilQ
   cxYA4knwV5OXAKDfpfXAvUjWKSuPupRUY6Q9hx8K7N8EIjLnZ0LKDQBXJ
   cjCocIQdty0/5No6Sbuy8gpg6xTo8kmppExNS+xvkaRrzq9uek5aMn4NM
   9zS2u12CvE/vjJxu2uisSh3oi52RjPnEytDjUVLyAEFjYrLXxTrBtDWIB
   Q==;
X-CSE-ConnectionGUID: 7W/jCi9NSh6o6/KIVX2uuQ==
X-CSE-MsgGUID: 9lP74rWpQ2SHIgry7WSKOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51952046"
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="51952046"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 16:33:52 -0700
X-CSE-ConnectionGUID: xTX3kG/tTOyFlcU7hJ3YsQ==
X-CSE-MsgGUID: EnkS7tyaTO6M0vMqYADNpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,235,1744095600"; 
   d="scan'208";a="185193840"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 16:33:51 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 16:33:50 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 16:33:50 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 16:33:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sc0XQ74FmSPmtoS9T/h5bey5pe22O6+H8QZo69P9BYv0wKbeyXtvZPdhCUOmnf9P8wYrKvV+8TpPw3D3S3qX2wNASEUEcQDcpymU7e+jR1vItfLbiksM2NTmsQKwmiS1zxVQf084KWm3aAcXPI/Bk4KAyQLnm7aWfaC9Nyx8q0f6qzrC7aPJvdZJL/qZmkR8975eRYN775vNGSjGel6HBdNq5tuYLk3S5G7FGC1zTPMb7Evm77HUo3Qg3ZbRkgabgEH1uLgAAX57hNVGiFeK1W8atvbGdVICG1cBkuVrPhwj2bhY867Bbaf6pDdOC6owJZK39E/YG89NrLkGLwPX0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unaFMjJFXeb59AHeZLL+UCGllKLkvERGXROaoOanuvs=;
 b=tuv6GEf+uSGe2WXPfx7hwHYuDvVZuq4Cbl1zoBBAJQEfdWVbtRJa2uJvJk1AYy6nvLeQn5dhXKczBwx1TT4g5o6qE75lDdUOpF7MzmuwZWpkDjvEDd4HZRZHqioRoNASnuQ8ptvVUQ3sCwOtfRXg9e9q0HohEypbNnELp1l8o4Tmrn2MtTPLUN23xuQ1gKyjaYP8UPZjamSK1xRlR0qKgoXMhrwk3sgBWh0Cwh08l3gpkxki4M/0idJpgiWz+JEn4xIGQ0EchQdQ18SNOD+7Lc0IeaRN1MehSFgVUPkiLpWD0i1jIoZtQNJ8g6wtE1a508wbwOGDXEdOllfHl9nQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7848.namprd11.prod.outlook.com (2603:10b6:930:6c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.22; Fri, 13 Jun
 2025 23:33:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 23:33:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"tabba@google.com" <tabba@google.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygA==
Date: Fri, 13 Jun 2025 23:33:48 +0000
Message-ID: <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
References: <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
	 <aEmVa0YjUIRKvyNy@google.com>
	 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
	 <aEtumIYPJSV49_jL@google.com>
	 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
	 <aEt0ZxzvXngfplmN@google.com>
	 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
	 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
In-Reply-To: <aEyj_5WoC-01SPsV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7848:EE_
x-ms-office365-filtering-correlation-id: 63d696b3-d7a1-48c9-491c-08ddaad2bf17
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WlR0OU1EYmhOTFNLNlRkWnlDRTBoWTlOMVFtVy9uSEprRE1DekpjWHdQb3lW?=
 =?utf-8?B?d0ZrakF0TnBsbnJqRTdHWnRPVHRqODE3KzV0TjVNSS9zdkdSelUzNE10dHVk?=
 =?utf-8?B?NGdyRjdyNi94RDd4VGtqSWVIMTJmeDNOZC9WOWVhblJPMll4T1dhQ092NlYx?=
 =?utf-8?B?cmdKVEYwTFh1WUI0bnBuVVdaRm1NMk5RMHFHWlFsWDhMZEhzMlNQQ2ZXRTJw?=
 =?utf-8?B?RGQwZTVZSC9LTGJuV3VhOTkvVHhPK1UxOWhvYmpIUGFwclhGN2VUMEpmUC9X?=
 =?utf-8?B?eG1lb2ZKOWNrZ3pBUnpNTEZJKzdkNDN4MHFueG10d2U2ckZqbDhxcEJRcHF6?=
 =?utf-8?B?L3A3bUl6dnFtSEIvNmlJL0N3bmJYZWNydFVWZ1JiT1FUMFl6a2hMM2lmQVly?=
 =?utf-8?B?dkxSRnhjYjQ0NXMyWkRJN0piTzRrMVBlUThOd1VYSVZ2VnNSQjVZb2RNVEpE?=
 =?utf-8?B?bmVTSjJ6OVJ4WUxQU1Qwc1FpeGc4cEk4cWlSNU9JL3R0dkQ4djBoK1VDaVVB?=
 =?utf-8?B?R0pEVEkvZkIzT2xoRUdnNjdnOXRVblN4SjNUbWtReGVJQmlMWCtabHlxTHdH?=
 =?utf-8?B?Uy9VeEdwZE9haGYvcWVzM2NtZVlpUnFNR1g4R2xNSi9kYlBWM0RLcnJISDRx?=
 =?utf-8?B?bld2dFkvb091TkVhRER6bTk3TW9EbGZhZDFGbnFaV2cvWFFVZzVHMDd5akZF?=
 =?utf-8?B?b1Z1VUhJUkd1REg3V1U0bXdvY0lKNzJyaHpNaEVKZ3ZKckhaY05SaGJrdEY5?=
 =?utf-8?B?VVUzdHBCbFEreGxiTnoxMHhZREZvNTVIZXVzeVJRN1IyQ2pmT2NlSE9LUlhn?=
 =?utf-8?B?YUovSlpTNGxKOE9RUXJtU3JQVTdobVV5L0RLNW5vK3BpN014L2IveWhIaHNz?=
 =?utf-8?B?bzFTUDBaSVpuc1QrNTdpbVZ5TVdKOHlLTkFBWkg1eGFHSHU2Y0ZlWjZiQ1lX?=
 =?utf-8?B?L3prckdFckYzZ3VPYitYRWd0ZWNkNW5WVDc4YzFGeWNudXhzazBmcVZORDY2?=
 =?utf-8?B?RWVRZUVaaDU0ejY0aGllTUxoMXlwZ3RjN3poT2swelJHdUdLQmRUL3RyYm1W?=
 =?utf-8?B?cFA5M1ljM0pOS0VUWkdzblNMSDlqYjdVejV5eEFHMGtEdG91eUNnMzl2TW1S?=
 =?utf-8?B?NTBjZTBXekJWUmJXSm1aYmhWd3hYZXg5ZFIxT1ByNDdncjV3bFQzTnkzY1JV?=
 =?utf-8?B?NFFiRjI5ZW5mZDBJTS9Xa1c4TUJqNnhuUGY5dmRRMVhBRGdOdWd5aVJyMjFB?=
 =?utf-8?B?TzlmeUpIRjF4R1MrZXFlNVh6cS9tOHZCUFIwNW9aSWJ1bUxTUk9tNTN6OXZY?=
 =?utf-8?B?bDFmNll2U1pJc2tQVlI0V0FBeUt4eWUrajlEOGZVR2RiZHdBK055NTJLMVRi?=
 =?utf-8?B?cGVnd3plZkV1RTlSelE5a2ZiZk00YU4xakU0UEI3RXE1dHAvaXZMdlVRS1dx?=
 =?utf-8?B?cHBNRW9BemxHbjRHdFhJKzFReVdpQVJoaXhzMXllY2RSVG1kT2M0Nm80ZWxH?=
 =?utf-8?B?NklrbGMwQTh4c2RLREMrOGxINysxelBhZWlNS2t4UkJOVDZYdTlZZUdWc3J1?=
 =?utf-8?B?bG9rbWlxSEJwbit3aGpocFFIZkRFOE04MHppc1hEVGlReENWRmg1Wit1dzYw?=
 =?utf-8?B?Q29vVk9VZlpOSWFoOXJ3ZExtdHNqd2NMU2o4YXRTVVM3aXRWSklFOHJVL2lI?=
 =?utf-8?B?dCs5SDJmcTBRM0NrSVNCam1DWVJBdWNHN2d6SUh5cjNTTmJLdEIwYjhUT1Fu?=
 =?utf-8?B?Ty9RSzMyT21CSDVDZHh5aUVmUGpnVC9mQWUwVy93RHFlY3BHajduQXJKSE1B?=
 =?utf-8?B?VDFwQWs4VEhrWG5HNTM1MU03UkV4eFNSM3VUc2VjZzFpRWkzRnVKZ29ONHVj?=
 =?utf-8?B?TmRpVnNJZmhDb0VsamRuQU1DZ0IySHJvc3BwNGdVYU1qaTJZUUlTMXBscTNM?=
 =?utf-8?B?WEpTZmxuTTBza1o1cnJReG9hd0RFa0NXc2JoaHRvbUFuNmVuUnZVZW9vTXVS?=
 =?utf-8?Q?/xioF/QRZOKZHz5O9vU62dIVYaIy8M=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1FzOXhRclpzUjVvOWdab3FYTmtuQlh6QkFwOWQxbit3YlphUEJuTGFtRFBj?=
 =?utf-8?B?MHhiZEFYNTcxOTRwTDh2dG5zUzBuWTd4cEZIQUtVbHdtRTIwTVd0ejBXOXFJ?=
 =?utf-8?B?cGxZT0tXc01jVnBqaE85VXlHVEZMTVIxN3B5NGcxaERlSWx2RHBPcEk0VW85?=
 =?utf-8?B?aXVuQVFPa2J3dGV0UWZma3RHREhUUm1XT1JWZS9rblZyTTdQdU9vNENLQjNR?=
 =?utf-8?B?WlI5WWZzMyszdkZKQXBhR3JOMVl5VnNLRDJha01sMno5TzZVN1hRV2lFNGpI?=
 =?utf-8?B?RjROQlhjaXE3Nlk5bjBQMC83QnBDSFdrZzRJUXBhemhOWmRtWFFwaXhTM3Bi?=
 =?utf-8?B?S0Z2U1YwT3hMWXVxaXlnNVMxL25ndFl2bFhiYzJmaGgvRTZZTlpRMHBsd21r?=
 =?utf-8?B?UHF0dlpMMWx3b2I0dXY4YStwbVlzNjBWNXU4c1NkL3dPaTJQZ2ljb3BWMGFC?=
 =?utf-8?B?Q0czdmtZbjJxSVBlQWdpWTVBSGZHWUZTRDBCNmFENjZBSlVaa05OSUtINGtl?=
 =?utf-8?B?UGdYelhVamlHSW9BU3pOdHV3N2cwZUFETDBUb25LYWpqeDUxOHFuTWJHV0tk?=
 =?utf-8?B?MkNqNVdFeWdvanE0Y25BRldtYWRTNE9mdHI1bG1ReWhPZC9qdzQrWTNaOExz?=
 =?utf-8?B?eUl3ZENSckc0TTNQWnN4WCsrUldsWnJiQVV1OVZUcVYyQ1JZOFFxL3J5UmZD?=
 =?utf-8?B?SGhpRHY2U1Zra3J4amdTTW5CN2JHWGQ4WDNmM3I4V3hUODEwYTNkdTdNTG5z?=
 =?utf-8?B?M3IwVGZYRnRCWXROYVZJVys0bERBM1B6M2hGSmtXbGE0Q3o5STllcFY1VUZV?=
 =?utf-8?B?bURPK3JtbDBUak1sQityeWdta0xNRVg2ejV1Y3dockdDbEdtZTlaRk1MaTZN?=
 =?utf-8?B?WE80clI3L0syWkV4dXJHbUxWZkVKNlBjZDk2RXY2b001dkRGWkN5Y0pPRXda?=
 =?utf-8?B?N25rRElHbHZRMTdCNHZoREhNSTNReHEzcXcvQ2xIZGtPNmpTd2o1OER1c2hM?=
 =?utf-8?B?TDFoSENJbkxiak5NYzJoQ3hSRjM1dk02SjNvS0dGbUpzb0g3bjVlVVBXdzc3?=
 =?utf-8?B?NVY1OEJVd2FzeFQ4SHg1MzVvcUJKTDZUdDB5ZlN1c085WWFFUFdYbjduTzIr?=
 =?utf-8?B?Zkk4cm13eTJsTTkweGRDYlNrTjlkVThGRytkOGhCRExoL2VPY3lyWFZ1Uk4y?=
 =?utf-8?B?SHZ3M2dzLzgzemFERlhzdUNOOWpQeDNObGMzazZLSjZNcm1yeExkN3Z3RGx0?=
 =?utf-8?B?UjExSjJlMDhHVkk4aWVGUzJLd0xiRlpRQS9FSDkra09Lbi9JOWd2VFNDVXIv?=
 =?utf-8?B?ZnpsbWVVOGtlM254empIc0VvT1FUR0l1K0tBa0RqQmdmY2Y0MXpraHFES3ZK?=
 =?utf-8?B?TWorWisvOWlOeVhKWGgvWVhCRmo1ZjZ1MzVRVlpvVC93RVpoem5IS3MyTlc0?=
 =?utf-8?B?OEZxWVc5SnovcmJYZW0rWExvVVpPRkViaDIrOWNXVVBlMElKdytOR1k4NlU3?=
 =?utf-8?B?cTlRR3pkL09TV3puSDNyVDh6SW9yc0FtRE5CWDBNbTBHT0J2QzZKOU1RTUxu?=
 =?utf-8?B?KzVzRUwvVnNlanBrMERQNGVrWnBUWW4vcnkrcElKQ0wvNVlYMmc5ZDk4YlF0?=
 =?utf-8?B?aVF6RmZpVFlONFBrU1c3TjV4VVNVQ05tTGJVUlFxWmJUS2k4ZTZVM3V0elVJ?=
 =?utf-8?B?TnNsNmJsbkQxMzRPN0VTcnEwMGF3U3N4TGxERC8yeHIwVmhHWVU3ZmVldy9R?=
 =?utf-8?B?WHdDVElrK2d2WkZKbXFZMlhycWZjUHV2NmpqUEVrc05GUHcxQnRTa01YRUNk?=
 =?utf-8?B?TGFqUlF6UVlyUmQrcncvRU5kU0J1elZuRDdCMFIvZEpVeUk4UFozNUtJOXht?=
 =?utf-8?B?UUpPU2ZmVm5ESGtoTHJQbmkzMllIZjUzSFZubUYvR1liVTA3eHJBUmhrYm5u?=
 =?utf-8?B?a284ODJBeitSZTFOY2VSVHJES3FGMmJETTU3eDRuWlFOYUsxbVJzdUg4clJK?=
 =?utf-8?B?SFhiRUNkd3hXUWgvdURDUUM1M3FneS9kZ3pZTEpydGtFRjNrNGMvZDFjZndw?=
 =?utf-8?B?YXVOT0JJMWh6aERCVC9mTnkvOEtyZFF6N2tRNEFleXpIVmNiNVZVeE9KTUZl?=
 =?utf-8?B?ZmlPVUt4cjRqTzZvSk8rRlg4WThYV00zTEZQL0d1ZUVybW81WE5ZOVo2bjZQ?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95F77B0922B48E41AF10F43194CEFA3D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d696b3-d7a1-48c9-491c-08ddaad2bf17
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 23:33:48.2024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uemoYYxFk8V8oXF85yY8mYMmnpVxIEm/0687jBoIq7mx4jYPSTlaEdyaNcgAf+GTfKS0ULgdoPso1Cf8H3J4NVxqgdV0QtkwKWqH27RIPhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7848
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTEzIGF0IDE1OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEFyZywgSSBqdXN0IHJlYWxpemVkIGEgb25lLXdheSBvcHQtaW4gd2lsbCBoYXZl
IGEgdGhlb3JldGljYWwgZ2FwLiBJZiB0aGUNCj4gPiBndWVzdA0KPiA+IGtleGVjJ3MsIHRoZSBu
ZXcga2VybmVsIHdpbGwgbmVlZCB0byBtYXRjaCB0aGUgb3B0LWluLg0KPiANCj4gQWxsIHRoZSBt
b3JlIHJlYXNvbiB0byBtYWtlIHRoaXMgYSBwcm9wZXJ0eSBvZiB0aGUgVk0gdGhhdCBpcyBwYXNz
ZWQgdmlhDQo+ICJzdHJ1Y3QgdGRfcGFyYW1zIi7CoCBJLmUuIHB1dCB0aGUgb251cyBvbiB0aGUg
b3duZXIgb2YgdGhlIFZNIHRvIGVuc3VyZSB0aGVpcg0KPiBrZXJuZWwocykgaGF2ZSBiZWVuIHVw
ZGF0ZWQgYWNjb3JkaW5nbHkuDQoNCkhtbSwgaXQgZ2l2ZXMgbWUgcGF1c2UuIEF0IG1pbmltdW0g
aXQgc2hvdWxkIGhhdmUgYW4gZW51bWVyYXRpb24gdG8gdGhlIGd1ZXN0Lg0KDQo+IA0KPiBJIHVu
ZGVyc3RhbmQgdGhhdCB0aGlzIGNvdWxkIGJlIHBhaW5mdWwsIGJ1dCBob25lc3RseSBfYWxsXyBv
ZiBURFggYW5kIFNOUCBpcw0KPiBwYWluZnVsIGZvciB0aGUgZ3Vlc3QuwqAgRS5nLiBJIGRvbid0
IHRoaW5rIGl0J3MgYW55IHdvcnNlIHRoYW4gdGhlIHNlY3VyaXR5DQo+IGlzc3VlcyB3aXRoIFRE
WCAoYW5kIFNOUCkgZ3Vlc3RzIHVzaW5nIGt2bWNsb2NrICh3aGljaCBJJ2QgbG92ZSBzb21lIHJl
dmlld3MNCj4gb24sDQo+IGJ0dykuDQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyNTAyMjcwMjE4NTUuMzI1NzE4OC0zNS1zZWFuamNAZ29vZ2xlLmNvbQ0KDQpPaCwgbmljZS4g
SSBoYWRuJ3Qgc2VlbiB0aGlzLiBBZ3JlZSB0aGF0IGEgY29tcHJlaGVuc2l2ZSBndWVzdCBzZXR1
cCBpcyBxdWl0ZQ0KbWFudWFsLiBCdXQgaGVyZSB3ZSBhcmUgcGxheWluZyB3aXRoIGd1ZXN0IEFC
SS4gSW4gcHJhY3RpY2UsIHllcyBpdCdzIHNpbWlsYXIgdG8NCnBhc3NpbmcgeWV0IGFub3RoZXIg
YXJnIHRvIGdldCBhIGdvb2QgVEQuDQoNCldlIGNhbiBzdGFydCB3aXRoIGEgcHJvdG90eXBlIHRo
ZSBob3N0IHNpZGUgYXJnIGFuZCBzZWUgaG93IGl0IHR1cm5zIG91dC4gSQ0KcmVhbGl6ZWQgd2Ug
bmVlZCB0byB2ZXJpZnkgZWRrMiBhcyB3ZWxsLg0KDQpUaGFua3MgU2Vhbi4NCg==

