Return-Path: <kvm+bounces-68673-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCKLH/AxcGkSXAAAu9opvQ
	(envelope-from <kvm+bounces-68673-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:54:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D56774F66B
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9C2E250D2FA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0403D3242C0;
	Wed, 21 Jan 2026 01:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCkDaUeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4557429B8E8;
	Wed, 21 Jan 2026 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960473; cv=fail; b=vEnomHCirzWvi4t82kIAdVuiUOUoBN+BkACiAv0U9asmTxIuUl453qe/TsxyPy2NVq9pRAC9F4Z5pxQ7j3z0ZmemnDLODa0d7H+sQFegt2yYbDu3YcAAlKb84pSjrv7ih1NAhH51e2AFDfQK21AuhTFSrOL8NxgP+brVhL6vXD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960473; c=relaxed/simple;
	bh=YpIT/kpEoft2h/QiE7swynbcbBq+i/ryEQs1/6WFtvg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BbJgqgidb9hqDV2Rc1xNtiB+Tu2VX06kVzbzjjOXs5kO5780VaQqBOlClJe2Of5PQeELsDLAtiEGEUv4Lw86y8NqikKTL6Zue6oxaBl5Z89640VkM74Wamo0dFwwjbqN1CTIm3O3hZwnn1zCE0mU8X1Wn7D44xyqlSWOhYeN34s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UCkDaUeJ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768960468; x=1800496468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YpIT/kpEoft2h/QiE7swynbcbBq+i/ryEQs1/6WFtvg=;
  b=UCkDaUeJgBhLzVsPArBbOf0K4KE7r/DVBAitfAK1Iah9XsTGVqv3j1jL
   +1edMyDOQNZpEPpTgOFzZjxDxPJlW45xz4sqgDXFswRrTxVlqNCM5SJbG
   on1MueyJLqJMlip4J9b61N0+Fmq/0D67duGmZa82zWl/6eRmOXMv4B+mr
   IFJ61osBBqSoXnx8rspJng3BmNqhGnCXjzB3AHmoOrewfpjyXn76Irl8y
   owy3L7SEvOukPzCcq6YetmHk23nCoISb3V01r+hW5zdA5s34HTtbhsysJ
   40tOLxhDpEqn4Bc7L+v0UtIvuysRIIA6srrkd0wloUgXG2kwXb2RwfhUr
   w==;
X-CSE-ConnectionGUID: 9CzEj+A3S1+/2+dqbXvURA==
X-CSE-MsgGUID: OB4WSwJrQl6qqUGUzZwdyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="69380122"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="69380122"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 17:54:20 -0800
X-CSE-ConnectionGUID: onEqGaI/S5mJSH2lo5hQgw==
X-CSE-MsgGUID: nHglbBVYRaemH0Y5EUlJMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="205536175"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 17:54:20 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 17:54:19 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 17:54:18 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 17:54:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPDT+1reBuhBVsGkkeeIXcr06AiMwRMiC7wYgDL2f9we2FtcuY8AUqZ2GM+2F+LbKyEzCavHkXtm06YVUA6RRDgzVgWgpErJ8XZR+nfVuf1vBIBEEfHxs+RuQ9PFbKxJlTgOYLAsHLnCdhrKANBTTiLZKWePgf+3A10gxr1IFTBaVn+/k5KHXy8FanmtOKG5/fUaAxKEXq4vzYVYtrzDCN140JvnCFltFgMxDY6jdscne7orHP9w0FtXE9TQlQQSszWuDYPwDBhY/6sL5NDEG3xWwqFHGnkJSoLSj81JTd4pDwkLqptuRCipVd8/XA29+LUF2BXE4A5FKNsinYen3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpIT/kpEoft2h/QiE7swynbcbBq+i/ryEQs1/6WFtvg=;
 b=Bx2/HdusjIbQAeZj4KuUmaaPwa6TZUmyRUk4Yju0I8cmeN+NexHZu7Xj1kpEyq040rQCBnimhAlPEC+BKMS119owweOeuXvVPFJimnCT2bas/UkHZoGyGdnRq3FtZzuDD8UuH0bj+pHSKjxbGQB2TAOLRwFjvmD5X0qobQMMKBxkh3aoiSjgokym/qkvlhq0kzN3Qrhdp0QyMDcmKS4G1rz1gdku8fqLtoBmxJpNtNRCCma99wXYE0fSgCxpgE00WZjqXn+SCtj5JKT5KF5gHvZZlX3zV3qD6MS6zKE7s0ua7kRA9SivUYeDo0BhQoODL4Q2ZevH3nCi/4w53GPTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7900.namprd11.prod.outlook.com (2603:10b6:930:7a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Wed, 21 Jan
 2026 01:54:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 01:54:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Topic: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Index: AQHcfvbSydlt/e/FU0SaQnkHllxJ3bVb88AA
Date: Wed, 21 Jan 2026 01:54:14 +0000
Message-ID: <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102331.25244-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106102331.25244-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7900:EE_
x-ms-office365-filtering-correlation-id: 445527c6-67e3-40a8-97ed-08de588ffac4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?czBtRkRiTG1MeFZHNWNVUzh0MHI1SWhCdVJ3amdRdWJYSlZ3ZHRBYzlIb3Na?=
 =?utf-8?B?TlhYem4wd3VBY1QwM3ZHbGNTc0RtaGlLS3pHcUZFcmd5aEphTG9wV2M4V2pa?=
 =?utf-8?B?L2tjYzF1Njc0elBYaDFXZmkwNUdZOUdYNm80aG5JOSsrQnFPR28vYjNpOExM?=
 =?utf-8?B?RjgraVRha1QzSVZXUkVqZ242M1BibGRQY0dqRXR5OEY4a2hmbWswZi8yajhi?=
 =?utf-8?B?UnJWY2x4eTdmUDdKaVJ2NWV1ZXIxVzZaUWhXWkZyYmsycGZ4dW1LRDZ0V0tw?=
 =?utf-8?B?N0MySGVXNGFKOXNrL0hmSFovZlNkT0R4cVVsL2RKblRDaFRzaTh0ODdCbk9p?=
 =?utf-8?B?VkNyRnRiU0lsSTc3c29QTlFRZzdiVWdpSWNNVUZkL0dTaERUU1FtdG93dzNR?=
 =?utf-8?B?c0dsSnVVZ0k5UVd4Yk93THZGL3dDSkxuWjNINVlHMzdnejJxdkRGT0s3SzRu?=
 =?utf-8?B?R0JIR3RuTmFwRGNkUjY1d3pRUUFWRWNIenZkR1BVSjB3T2lMK0twbzhuL1I0?=
 =?utf-8?B?V3I1OTJyaVJEbS9xR3lLOVZCK1I1NUhUN2Q4VU1aT2pza3BDeEFvbTZjak1j?=
 =?utf-8?B?dEViR1daUncyRGUzWFc1ZWQ3ZVFzUFAxK2ZpV3pncjc1c3VUY1dGeTNyaWUv?=
 =?utf-8?B?MkNGRW1LdVhPQkJTNWtNeXdSL1FqU2VuTnZXYVZOZzNoUU0zMGNWRzZma212?=
 =?utf-8?B?UEpTS0hlQi9ROXpTNjUxMUd6MnV1QzhFSkpvamJIdXlWSXEzY3YxM1dsdmpF?=
 =?utf-8?B?c3ViY0tvSlA5VFZqMmZRTzJvaElZVkZEVkJTd0JMU01adU5SK0pTalBXblFj?=
 =?utf-8?B?UFZxY3F3WlUvb3JXVm9QbTZ4QmxUbUJQYktBbE4xUnFGdnplUFkyclV1T2N4?=
 =?utf-8?B?bXEwUFBZSVVlaDBYM3kzaXRBSDNOaUdaWVpZRnlqS0c0WUViaHg1SWQ0M3lH?=
 =?utf-8?B?SFg0MEdGeTdONUZXQXpSZktSUGVkeEwyTXdGNGF6UmM5c3Y3QVZjajBpSWVh?=
 =?utf-8?B?SWhQU1hJNGJvb1phNjNkRy8rOVhmTGJNT3RpK2hCS3NiV0xCSFlHWEhzZjVw?=
 =?utf-8?B?a1BxbUJuNXpDM214SkhObUJSUC9neWk0WkZTa1dURWUxNnVaVHRHRTRoTHI5?=
 =?utf-8?B?aTBpd3NPNVl3S0h2c0k3QllubGpzbTMySUJCQnpFK0hSNm1XY2xTc29kZGpE?=
 =?utf-8?B?Z3FYdWVqYzAvZkZYbThkc2E1OWVFTDFuMDd4TDk1RlNLNFpWV0pJMjYxNDdI?=
 =?utf-8?B?R1pZNnFVM2p3N0pvZ3k1WDhvWXkzY1NtczU4eXhIazlCTWkwRnE3SmlaeDNY?=
 =?utf-8?B?andoOWQ5M01JVHhsNER5ZlNuU1hVQnVXUzUzWEJJYU01b29sNGdSTUVxU0Qz?=
 =?utf-8?B?ZXR2bkNwRW1VeFhod3FDY1dTQTNFd1JPMkpRWDdRVitxQmZTbUFWTzUrUWtE?=
 =?utf-8?B?V0lydlprbFV2NkNXSEZ6cFBVY0tFRjc4d1NuMXA1d1FuTllQbnhOWU05a051?=
 =?utf-8?B?ZTFaQ1RoMjBvK3A0Qm9Nd0QwT2JJMUxFSndGY3NEVDEzbHR5N3JIdUtWeGpo?=
 =?utf-8?B?Y1pLWTQrMFBwVVMxelg0Tlo2enRpOVplb2JkRDFRVGY3VFdZSmRGQ1JDczBT?=
 =?utf-8?B?bDdiUHBLWkhPa2h2b0tLS2phUlQ5L3JNK0l2WFdFTU1GeXl2blFHYTJYQ0Ez?=
 =?utf-8?B?RUhCTTRGSFhFMkcxTHlUZm9NenNvcWdXdUMyTVFPVkxLdTlpMW9INHI5TlRZ?=
 =?utf-8?B?bXZ4VGc2TWhFeDJsSVdJWU5laDZXSmdNWmNNWTNDcG1JNXR5a1JOcDkvWUow?=
 =?utf-8?B?b0oxTmU1NkI2MnIzUnBiZTJmYUx4N0ZZVkJtRmdrWU9MdkpiWDA2dExieGhW?=
 =?utf-8?B?a0RtRHhpT2lldmdsQktxV3BFMHhURS9TZFNuNzJaYWpVdkEwNGRscVlab0lR?=
 =?utf-8?B?TUU3TktJOE4wTVpwTHZwMGljM00wMXRuOFpyeEU4VHFGR1BnL1NqM2puRmk5?=
 =?utf-8?B?NC90YlpJdTNGTFdxNGFreFMvS1AzNk9ubHVSMFcyenBVR283Z1hnLzkxL3ZO?=
 =?utf-8?B?ZUxLYVFMVzVramlJYUdsT1JNU3VVYTRCa29nVUhicEIreEdEVmZWdVdZRFdI?=
 =?utf-8?B?OUlDVVUyRjRBUXVlS2swUzdtUG1wYmFRNGxEVzNpWUJpVjFxSFo1Y05Ic0Mv?=
 =?utf-8?Q?XjbV1q6biQhMnPylTVM9nMI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUlMdEtLNkdnbVRHTEZwdlMzckZyZ0RNWnppNkhIeEljTnZ6eVQ0Z0x0RC95?=
 =?utf-8?B?M2tvRU0vNHY4RnJpTFE4Z3gycGhKa3hPenRVN0Q4b00vRGRZZWxyVWovNEds?=
 =?utf-8?B?d0N0K3pKbysxWnZuenpWK2NOUFlXcE9rZEM4dU5Zc0I0RkZsWGQydjJRSERE?=
 =?utf-8?B?VDh2a3dYSWp5YnFOb1k2ZTl5ZzliVEtXMjg0TEV0MFovMGRjL04wNHc1aGVo?=
 =?utf-8?B?RW9jSXlrbFZIRkdkS1BUaktWSzNnKzVsYitUbXFnaUMzb2hBZ29YWFNVL29j?=
 =?utf-8?B?QWpUSGt6YmlUa0VWMlhoMHIwR1hkNXRBdGdYYVZqQ2lJU0VIZE12TEFBcHBI?=
 =?utf-8?B?U1R4YnA5dHplN1pHMm1SVERpWVVlT25mZGs5aFdQeE13TE5paWFVcis1N2Rl?=
 =?utf-8?B?Rzg1Skg5NkptV1J0S05ydXczajZLRGFoN2J2RUxzVDJoZm92LzhJYjJnK0JN?=
 =?utf-8?B?WkF6TDRML0pDOWkvaWFKMTFZTnV5aktSdXNHSGhEYjZhL2dRMmtQTjFRZkZT?=
 =?utf-8?B?T01HZlllNkRIeCt2SDdWU3FsOGZHYlg0UHBxakhnUzRQY3g4N3lCQ040VkdO?=
 =?utf-8?B?azBoU2lyUHEvUWFFTzFYZUR4b0JPV0svbUtGMXlRSDkzaU1QOGVIbm9pVnpL?=
 =?utf-8?B?Q1BKMytmd1QxYjFmY0xLWFdaWmtQTEgxV08wTkhJTmNRTWFRZ2FyaU1Kbklw?=
 =?utf-8?B?QnkvTHFyanFLblEwblBhMkdkWXByUFZVRDJWV1NHNS9NU1BNUmR6Y01mL0ZX?=
 =?utf-8?B?Y0F1cG9NaHF5eGhGaDNOdDdCZUNMM3VZTFdDYWZhM2dwa09ObU04VXUySktY?=
 =?utf-8?B?WHYrZnN4UG4zeDJabUFjYVJDZTFCZUQ1R1h2UUE5QUllZEg1VTNmekhTMnB2?=
 =?utf-8?B?eVBZMm0xQm1NWTlOMUJRZXBTU3MvZWtxR3poOCt1WGE1eG04QlFmVjkyT3Va?=
 =?utf-8?B?MlBvZHdoTFovcEQ5eWM3SER1bDZ2R21KdUJkVG5oaWdnUE5qVmxlTWpKZ1hY?=
 =?utf-8?B?TnRpYXAyZWdyd0dZL0ZmV25XMmZmMmdLZEF1dmRZNi9LTk5EaUJLcVR1R1Jy?=
 =?utf-8?B?VkEwaGRkYnk1VUNETkRLMHkyNmhyeEQ1dFlqZWpKRUhFTWN1SSs2bTZha2JJ?=
 =?utf-8?B?M1RWR0lmRElpOWY1bmcwMDErMWJxOURnUUpyNWJlR0I3TmZSMU5oVGZNQ1Q5?=
 =?utf-8?B?eVE0cTg2d0xyeDdyN2tNNjBKUTlPSjFObWJuUkMvWGxMVldHOHhYVE40UXU0?=
 =?utf-8?B?b0ZpSmlWY0wzSDdjb2t0TFBaZllNK1RkN3BxbHlwVC80TE5UalFpcDVndFlH?=
 =?utf-8?B?MmhSZk5KMC9vUEFMcFlTMDBLa1FUNFBuVlUreC9uck9yOW1xSEhUbkhyUjBm?=
 =?utf-8?B?UnhySG1QTVNtZ0MwNnJnZlljWjdlSUZaY3JaQXZENXJIVUxjWUpFZmdWQ1k4?=
 =?utf-8?B?SDRicVRoL2NyMFhRNmhRM0JnQmhvYTNGM2s1aHZldWl5bGdlMTV4UjNEWkxW?=
 =?utf-8?B?ZndjRldBVUhpc0ErdHY3cUlSOXltbXBiYlppRDU1TkNxUy9rRUpaWStiOCtH?=
 =?utf-8?B?dlVNYWxaait0WHZEZ0d6bDl4ckxXVVJnTDJYc0JqSHp6ODRvSHpCWXM5T3ZS?=
 =?utf-8?B?dDFLMFVrZE9qK2VMcndIQnF6YnhDL1BnQThCTDVTTS9TOG52NXp4UmNjS1Yv?=
 =?utf-8?B?c3crSTlJSTJSYUlDOFM4bHhPTTVKaE1nSEVqMjA1Ny9wTWEzb0hCYkJaT3Q0?=
 =?utf-8?B?K0JyMWdxT1A3KytFSVN1TGVJZWVQWVhqWHNOMThtZUlKdElXTmdXRmxRSDUz?=
 =?utf-8?B?NElKZFdUdmRDS25UNk9WQlIxZEdjRHBRMmlGMjZzeDlrUVBkVmJJM3lCY0Fo?=
 =?utf-8?B?NUhFNTkzcmp0NjQxUmhLZU1XWVdZbU8xdFFEMkREc3lROVo0eXo5Y3c4NXFh?=
 =?utf-8?B?dDFWMjFMYXNQWk5lMjhoazh3SFM5bk9yalNtYjJyTTZCSitqVXhhc3lRV0hD?=
 =?utf-8?B?NGx0SVlEUUNlOUlUbnRYa3N4TUdQRlNDenlrTHNXMGplejVhRHM4WkxzODFC?=
 =?utf-8?B?dWFITXNEL0JJakxxTHg2ZXhzVGEzbU5CeUdGWTVzSlNFOGw0RGIyYk5HODFh?=
 =?utf-8?B?a1ZUOEk4bmR4UmY4em90T09LdWpEMzJmTkNBVDBTaEJRRit0RjJkSWM0Y2Zj?=
 =?utf-8?B?bWtoejExM0hBRVVERldOTytBM29qSTAwb3c5d3puOVZjUkJNWEdNUHBlNjlW?=
 =?utf-8?B?ZG9TaWJ1WWVKcVE1NWhYUHE1dGN6K3Y2YWJLUHVobUZpWmhzc1JhK1JoL2hO?=
 =?utf-8?B?ZDJUcXpTUDZzcHZJQmpUN25uOFNwV0c3em1QaUlHZ1pwSmc2MENwZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CFC772368CFFF4CB57DB9F93A6C4ECF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445527c6-67e3-40a8-97ed-08de588ffac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 01:54:14.3614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJxUHyqX8EthY5WVlV+YKt1N4RPe8fUyp13VCYXeCDCNWAp73+uTwGq/MMS4TG11rOA1dZTA13u3lfDinE7NrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7900
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [2.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68673-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FREEMAIL_CC(0.00)[vger.kernel.org,intel.com,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	DKIM_TRACE(0.00)[intel.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D56774F66B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjIzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW50
cm9kdWNlIHBlci1WTSBleHRlcm5hbCBjYWNoZSBmb3Igc3BsaXR0aW5nIHRoZSBleHRlcm5hbCBw
YWdlIHRhYmxlIGJ5DQo+IGFkZGluZyBLVk0geDg2IG9wcyBmb3IgY2FjaGUgInRvcHVwIiwgImZy
ZWUiLCAibmVlZCB0b3B1cCIgb3BlcmF0aW9ucy4NCj4gDQo+IEludm9rZSB0aGUgS1ZNIHg4NiBv
cHMgZm9yICJ0b3B1cCIsICJuZWVkIHRvcHVwIiBmb3IgdGhlIHBlci1WTSBleHRlcm5hbA0KPiBz
cGxpdCBjYWNoZSB3aGVuIHNwbGl0dGluZyB0aGUgbWlycm9yIHJvb3QgaW4NCj4gdGRwX21tdV9z
cGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSB3aGVyZSB0aGVyZSdzIG5vIHBlci12Q1BVIGNvbnRleHQu
DQo+IA0KPiBJbnZva2UgdGhlIEtWTSB4ODYgb3AgZm9yICJmcmVlIiB0byBkZXN0cm95IHRoZSBw
ZXItVk0gZXh0ZXJuYWwgc3BsaXQgY2FjaGUNCj4gd2hlbiBLVk0gZnJlZXMgbWVtb3J5IGNhY2hl
cy4NCj4gDQo+IFRoaXMgcGVyLVZNIGV4dGVybmFsIHNwbGl0IGNhY2hlIGlzIG9ubHkgdXNlZCB3
aGVuIHBlci12Q1BVIGNvbnRleHQgaXMgbm90DQo+IGF2YWlsYWJsZS4gVXNlIHRoZSBwZXItdkNQ
VSBleHRlcm5hbCBmYXVsdCBjYWNoZSBpbiB0aGUgZmF1bHQgcGF0aA0KPiB3aGVuIHBlci12Q1BV
IGNvbnRleHQgaXMgYXZhaWxhYmxlLg0KPiANCj4gVGhlIHBlci1WTSBleHRlcm5hbCBzcGxpdCBj
YWNoZSBpcyBwcm90ZWN0ZWQgdW5kZXIgYm90aCBrdm0tPm1tdV9sb2NrIGFuZCBhDQo+IGNhY2hl
IGxvY2sgaW5zaWRlIHZlbmRvciBpbXBsZW1lbnRhdGlvbnMgdG8gZW5zdXJlIHRoYXQgdGhlcmUn
cmUgZW5vdWdoDQo+IHBhZ2VzIGluIGNhY2hlIGZvciBvbmUgc3BsaXQ6DQo+IA0KPiAtIERlcXVl
dWluZyBvZiB0aGUgcGVyLVZNIGV4dGVybmFsIHNwbGl0IGNhY2hlIGlzIGluDQo+ICAga3ZtX3g4
Nl9vcHMuc3BsaXRfZXh0ZXJuYWxfc3B0ZSgpIHVuZGVyIG1tdV9sb2NrLg0KPiANCj4gLSBZaWVs
ZCB0aGUgdHJhdmVyc2FsIGluIHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkgYWZ0ZXIg
dG9wdXAgb2YNCj4gICB0aGUgcGVyLVZNIGNhY2hlLCBzbyB0aGF0IG5lZWRfdG9wdXAoKSBpcyBj
aGVja2VkIGFnYWluIGFmdGVyDQo+ICAgcmUtYWNxdWlyaW5nIHRoZSBtbXVfbG9jay4NCj4gDQo+
IC0gVmVuZG9yIGltcGxlbWVudGF0aW9ucyBvZiB0aGUgcGVyLVZNIGV4dGVybmFsIHNwbGl0IGNh
Y2hlIHByb3ZpZGUgYQ0KPiAgIGNhY2hlIGxvY2sgdG8gcHJvdGVjdCB0aGUgZW5xdWV1ZS9kZXF1
ZXVlIG9mIHBhZ2VzIGludG8vZnJvbSB0aGUgY2FjaGUuDQo+IA0KPiBIZXJlJ3MgdGhlIHNlcXVl
bmNlIHRvIHNob3cgaG93IGVub3VnaCBwYWdlcyBpbiBjYWNoZSBpcyBndWFyYW50ZWVkLg0KPiAN
Cj4gYS4gd2l0aCB3cml0ZSBtbXVfbG9jazoNCj4gDQo+ICAgIDEuIHdyaXRlX2xvY2soJmt2bS0+
bW11X2xvY2spDQo+ICAgICAgIGt2bV94ODZfb3BzLm5lZWRfdG9wdXAoKQ0KPiANCj4gICAgMi4g
d3JpdGVfdW5sb2NrKCZrdm0tPm1tdV9sb2NrKQ0KPiAgICAgICBrdm1feDg2X29wcy50b3B1cCgp
IC0tPiBpbiB2ZW5kb3I6DQo+ICAgICAgIHsNCj4gICAgICAgICBhbGxvY2F0ZSBwYWdlcw0KPiAg
ICAgICAgIGdldCBjYWNoZSBsb2NrDQo+ICAgICAgICAgZW5xdWV1ZSBwYWdlcyBpbiBjYWNoZQ0K
PiAgICAgICAgIHB1dCBjYWNoZSBsb2NrDQo+ICAgICAgIH0NCj4gDQo+ICAgIDMuIHdyaXRlX2xv
Y2soJmt2bS0+bW11X2xvY2spDQo+ICAgICAgIGt2bV94ODZfb3BzLm5lZWRfdG9wdXAoKSAoZ290
byAyIGlmIHRvcHVwIGlzIG5lY2Vzc2FyeSkgICgqKQ0KPiANCj4gICAgICAga3ZtX3g4Nl9vcHMu
c3BsaXRfZXh0ZXJuYWxfc3B0ZSgpIC0tPiBpbiB2ZW5kb3I6DQo+ICAgICAgIHsNCj4gICAgICAg
ICAgZ2V0IGNhY2hlIGxvY2sNCj4gICAgICAgICAgZGVxdWV1ZSBwYWdlcyBpbiBjYWNoZQ0KPiAg
ICAgICAgICBwdXQgY2FjaGUgbG9jaw0KPiAgICAgICB9DQo+ICAgICAgIHdyaXRlX3VubG9jaygm
a3ZtLT5tbXVfbG9jaykNCj4gDQo+IGIuIHdpdGggcmVhZCBtbXVfbG9jaywNCj4gDQo+ICAgIDEu
IHJlYWRfbG9jaygma3ZtLT5tbXVfbG9jaykNCj4gICAgICAga3ZtX3g4Nl9vcHMubmVlZF90b3B1
cCgpDQo+IA0KPiAgICAyLiByZWFkX3VubG9jaygma3ZtLT5tbXVfbG9jaykNCj4gICAgICAga3Zt
X3g4Nl9vcHMudG9wdXAoKSAtLT4gaW4gdmVuZG9yOg0KPiAgICAgICB7DQo+ICAgICAgICAgYWxs
b2NhdGUgcGFnZXMNCj4gICAgICAgICBnZXQgY2FjaGUgbG9jaw0KPiAgICAgICAgIGVucXVldWUg
cGFnZXMgaW4gY2FjaGUNCj4gICAgICAgICBwdXQgY2FjaGUgbG9jaw0KPiAgICAgICB9DQo+IA0K
PiAgICAzLiByZWFkX2xvY2soJmt2bS0+bW11X2xvY2spDQo+ICAgICAgIGt2bV94ODZfb3BzLm5l
ZWRfdG9wdXAoKSAoZ290byAyIGlmIHRvcHVwIGlzIG5lY2Vzc2FyeSkNCj4gDQo+ICAgICAgIGt2
bV94ODZfb3BzLnNwbGl0X2V4dGVybmFsX3NwdGUoKSAtLT4gaW4gdmVuZG9yOg0KPiAgICAgICB7
DQo+ICAgICAgICAgIGdldCBjYWNoZSBsb2NrDQo+ICAgICAgICAgIGt2bV94ODZfb3BzLm5lZWRf
dG9wdXAoKSAocmV0dXJuIHJldHJ5IGlmIHRvcHVwIGlzIG5lY2Vzc2FyeSkgKCoqKQ0KPiAgICAg
ICAgICBkZXF1ZXVlIHBhZ2VzIGluIGNhY2hlDQo+ICAgICAgICAgIHB1dCBjYWNoZSBsb2NrDQo+
ICAgICAgIH0NCj4gDQo+ICAgICAgIHJlYWRfdW5sb2NrKCZrdm0tPm1tdV9sb2NrKQ0KPiANCj4g
RHVlIHRvICgqKSBhbmQgKCoqKSBpbiBzdGVwIDMsIGVub3VnaCBwYWdlcyBmb3Igc3BsaXQgaXMg
Z3VhcmFudGVlZC4NCg0KSXQgZmVlbHMgbGlrZSBlbm9ybW91cyBwYWluIHRvIG1ha2Ugc3VyZSB0
aGVyZSdzIGVub3VnaCBvYmplY3RzIGluIHRoZQ0KY2FjaGUsIF9lc3BlY2lhbGx5XyB1bmRlciBN
TVUgcmVhZCBsb2NrIC0tIHlvdSBuZWVkIGFuIGFkZGl0aW9uYWwgY2FjaGUNCmxvY2sgYW5kIG5l
ZWQgdG8gY2FsbCBuZWVkX3RvcHVwKCkgdHdpY2UgZm9yIHRoYXQsIGFuZCB0aGUgY2FsbGVyIG5l
ZWRzDQpoYW5kbGUgLUVBR0FJTi4NCg0KVGhhdCBiZWluZyBzYWlkLCBJIF90aGlua18gdGhpcyBp
cyBhbHNvIHRoZSByZWFzb24gdGhhdA0KdGRwX21tdV9hbGxvY19zcF9mb3Jfc3BsaXQoKSBjaG9z
ZSB0byBqdXN0IHVzZSBub3JtYWwgbWVtb3J5IGFsbG9jYXRpb24NCmZvciBhbGxvY2F0aW5nIHNw
IGFuZCBzcC0+c3B0IGJ1dCBub3QgdXNlIGEgcGVyLVZNIGNhY2hlIG9mIEtWTSdzDQprdm1fbW11
X21lbW9yeV9jYWNoZS4NCg0KSSBoYXZlIGJlZW4gdGhpbmtpbmcgd2hldGhlciB3ZSBjYW4gc2lt
cGxpZnkgdGhlIHNvbHV0aW9uLCBub3Qgb25seSBqdXN0DQpmb3IgYXZvaWRpbmcgdGhpcyBjb21w
bGljYXRlZCBtZW1vcnkgY2FjaGUgdG9wdXAtdGhlbi1jb25zdW1lIG1lY2hhbmlzbQ0KdW5kZXIg
TU1VIHJlYWQgbG9jaywgYnV0IGFsc28gZm9yIGF2b2lkaW5nIGtpbmRhIGR1cGxpY2F0ZWQgY29k
ZSBhYm91dCBob3cNCnRvIGNhbGN1bGF0ZSBob3cgbWFueSBEUEFNVCBwYWdlcyBuZWVkZWQgdG8g
dG9wdXAgZXRjIGJldHdlZW4geW91ciBuZXh0DQpwYXRjaCBhbmQgc2ltaWxhciBjb2RlIGluIERQ
QU1UIHNlcmllcyBmb3IgdGhlIHBlci12Q1BVIGNhY2hlLg0KDQpJSVJDLCB0aGUgcGVyLVZNIERQ
QU1UIGNhY2hlIChpbiB5b3VyIG5leHQgcGF0Y2gpIGNvdmVycyBib3RoIFMtRVBUIHBhZ2VzDQph
bmQgdGhlIG1hcHBlZCAyTSByYW5nZSB3aGVuIHNwbGl0dGluZy4NCg0KLSBGb3IgUy1FUFQgcGFn
ZXMsIHRoZXkgYXJlIF9BTFdBWVNfIDRLLCBzbyB3ZSBjYW4gYWN0dWFsbHkgdXNlDQp0ZHhfYWxs
b2NfcGFnZSgpIGRpcmVjdGx5IHdoaWNoIGFsc28gaGFuZGxlcyBEUEFNVCBwYWdlcyBpbnRlcm5h
bGx5Lg0KDQpIZXJlIGluIHRkcF9tbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpOg0KDQoJc3AtPmV4
dGVybmFsX3NwdCA9IHRkeF9hbGxvY19wYWdlKCk7DQoNCkZvciB0aGUgZmF1bHQgcGF0aCB3ZSBu
ZWVkIHRvIHVzZSB0aGUgbm9ybWFsICdrdm1fbW11X21lbW9yeV9jYWNoZScgYnV0DQp0aGF0J3Mg
cGVyLXZDUFUgY2FjaGUgd2hpY2ggZG9lc24ndCBoYXZlIHRoZSBwYWluIG9mIHBlci1WTSBjYWNo
ZS4gIEFzIEkNCm1lbnRpb25lZCBpbiB2MywgSSBiZWxpZXZlIHdlIGNhbiBhbHNvIGhvb2sgdG8g
dXNlIHRkeF9hbGxvY19wYWdlKCkgaWYgd2UNCmFkZCB0d28gbmV3IG9ial9hbGxvYygpL2ZyZWUo
KSBjYWxsYmFjayB0byAna3ZtX21tdV9tZW1vcnlfY2FjaGUnOg0KDQpodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9rdm0vOWU3MjI2MTYwMmJkYWI5MTRjZjdmZjZmN2NiOTIxZTM1Mzg1MTM2ZS5jYW1l
bEBpbnRlbC5jb20vDQoNClNvIHdlIGNhbiBnZXQgcmlkIG9mIHRoZSBwZXItVk0gRFBBTVQgY2Fj
aGUgZm9yIFMtRVBUIHBhZ2VzLg0KDQotIEZvciBEUEFNVCBwYWdlcyBmb3IgdGhlIFREWCBndWVz
dCBwcml2YXRlIG1lbW9yeSwgSSB0aGluayB3ZSBjYW4gYWxzbw0KZ2V0IHJpZCBvZiB0aGUgcGVy
LVZNIERQQU1UIGNhY2hlIGlmIHdlIHVzZSAna3ZtX21tdV9wYWdlJyB0byBjYXJyeSB0aGUNCm5l
ZWRlZCBEUEFNVCBwYWdlczoNCg0KLS0tIGEvYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwu
aA0KKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJuYWwuaA0KQEAgLTExMSw2ICsxMTEs
NyBAQCBzdHJ1Y3Qga3ZtX21tdV9wYWdlIHsNCiAgICAgICAgICAgICAgICAgKiBQYXNzZWQgdG8g
VERYIG1vZHVsZSwgbm90IGFjY2Vzc2VkIGJ5IEtWTS4NCiAgICAgICAgICAgICAgICAgKi8NCiAg
ICAgICAgICAgICAgICB2b2lkICpleHRlcm5hbF9zcHQ7DQorICAgICAgICAgICAgICAgdm9pZCAq
bGVhZl9sZXZlbF9wcml2YXRlOw0KICAgICAgICB9Ow0KDQpUaGVuIHdlIGNhbiBkZWZpbmUgYSBz
dHJ1Y3R1cmUgd2hpY2ggY29udGFpbnMgRFBBTVQgcGFnZXMgZm9yIGEgZ2l2ZW4gMk0NCnJhbmdl
Og0KDQoJc3RydWN0IHRkeF9kbWFwdF9tZXRhZGF0YSB7DQoJCXN0cnVjdCBwYWdlICpwYWdlMTsN
CgkJc3RydWN0IHBhZ2UgKnBhZ2UyOw0KCX07DQoNClRoZW4gd2hlbiB3ZSBhbGxvY2F0ZSBzcC0+
ZXh0ZXJuYWxfc3B0LCB3ZSBjYW4gYWxzbyBhbGxvY2F0ZSBpdCBmb3INCmxlYWZfbGV2ZWxfcHJp
dmF0ZSB2aWEga3ZtX3g4Nl9vcHMgY2FsbCB3aGVuIHdlIHRoZSAnc3AnIGlzIGFjdHVhbGx5IHRo
ZQ0KbGFzdCBsZXZlbCBwYWdlIHRhYmxlLg0KDQpJbiB0aGlzIGNhc2UsIEkgdGhpbmsgd2UgY2Fu
IGdldCByaWQgb2YgdGhlIHBlci1WTSBEUEFNVCBjYWNoZT8NCg0KRm9yIHRoZSBmYXVsdCBwYXRo
LCBzaW1pbGFybHksIEkgYmVsaWV2ZSB3ZSBjYW4gdXNlIGEgcGVyLXZDUFUgY2FjaGUgZm9yDQon
c3RydWN0IHRkeF9kcGFtdF9tZW10YWRhdGEnIGlmIHdlIHV0aWxpemUgdGhlIHR3byBuZXcgb2Jq
X2FsbG9jKCkvZnJlZSgpDQpob29rcy4NCg0KVGhlIGNvc3QgaXMgdGhlIG5ldyAnbGVhZl9sZXZl
bF9wcml2YXRlJyB0YWtlcyBhZGRpdGlvbmFsIDgtYnl0ZXMgZm9yIG5vbi0NClREWCBndWVzdHMg
ZXZlbiB0aGV5IGFyZSBuZXZlciB1c2VkLCBidXQgaWYgd2hhdCBJIHNhaWQgYWJvdmUgaXMgZmVh
c2libGUsDQptYXliZSBpdCdzIHdvcnRoIHRoZSBjb3N0Lg0KDQpCdXQgaXQncyBjb21wbGV0ZWx5
IHBvc3NpYmxlIHRoYXQgSSBtaXNzZWQgc29tZXRoaW5nLiAgQW55IHRob3VnaHRzPw0KDQoNCg==

