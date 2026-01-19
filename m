Return-Path: <kvm+bounces-68484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7622D3A216
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BEB73067670
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B521F350D4A;
	Mon, 19 Jan 2026 08:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dFEYpfjn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634DC350A0B;
	Mon, 19 Jan 2026 08:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768812618; cv=fail; b=h2ciPWaspKC0pMrqpw3EhfIenD6mXwQArc5uXFabkzNth3RhBuEpsMZvr7HqKZWADaaT0ek4Ow/wrSOKN5dADW6XnTZy0DMcspL+cA00Ov0Lnk1HfUaVMWHeQfHZIcDanu5JrVDL13CiXPhVp6s+4Iqaakn7J9sGdItYgj7APjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768812618; c=relaxed/simple;
	bh=JzmzcJbgzqQPeOZyM5LAGgMBWvqfVqz5ATTxKUPPbhc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iTxAIdZriXde8d2n1kltz46xietRSLRBE8VyEWeY+dkkOUrTBySSYrBN/IO7gBp8woIaLubKrN4n1TdlCVYOYA9SRtqFfOVNOCRJ2mU4nxJMg9oSukTJUjKxjb8BkKi1teuZyOIPc6fq9TYHWGRC5QQcl54+IVJZl29IVs0MIYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dFEYpfjn; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768812617; x=1800348617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JzmzcJbgzqQPeOZyM5LAGgMBWvqfVqz5ATTxKUPPbhc=;
  b=dFEYpfjnGjGu1sM8p7/6DdBcfkBlm+PP5POdZZ5JEUYlwJ1uHHx2DeJs
   cgXXW2uV1e+iUVqFmdxqGbvB0QBBeQYbZZ/f5OOLCXezwht9acxPpfNfe
   2ayi4wzJv9PEKy06xHVgikL33EzTYyVPS1lzxD6sYZ/RTwfnexEwIPehJ
   xxr2PIgAt01KOL5E7ruz1JWe3Dec44TN8mGnx6VuZl2lOpSGGbb7P+qga
   VLYatK8jAnkmFFfANgo0zwfW2V1viguS9i3YFrr9eNSDBmrgk8HpS/1mI
   hH0ZS0huPCpzvWK6Sh9/jZ6ij4b9FjT2V5yHdJjVWAJ06/XzlXjPMTCiR
   A==;
X-CSE-ConnectionGUID: 2nFsYrWfRHuwYyfvneBneQ==
X-CSE-MsgGUID: tsYMyfISQq6bBpLrV3woNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69219841"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69219841"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:50:16 -0800
X-CSE-ConnectionGUID: vmR/aZKUSOy2N18Q2MbH7A==
X-CSE-MsgGUID: jE/IcDu7RPG3fHDUsPf8Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210319931"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:50:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 00:50:15 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 00:50:15 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 19 Jan 2026 00:50:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnRwTiKjJJ1MEpx266r+2s/Sx0aK1peGQVDHOuF1HrXB+tNdDzshKBazauasB0TRmkXMqmqZ/kCEjz1lLYale/3pOafbBkpQINUZx8yia4FVHkTfN/hbxK4VwopP1oiYV0Z5g5FIDka2SQeYMgWnH05rzM711KmvFbMzqPhxd2cVu4ohCOBsAIzzPhK2ep7yVrnU2wUKFwo7M5Eriy4ZkQlfkajPNrtMJv6Ra9AvGw/b1ul5m84aoV5KYpki0rp/HWHVzwBgCEyYOiJo6UxJxU7hEB7ThCyCn3H3jIiUm6/SmRfTpMIDUjT1kpSWwAvxNhjhyC/QeNRvC1EYqqyBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzmzcJbgzqQPeOZyM5LAGgMBWvqfVqz5ATTxKUPPbhc=;
 b=UE5yPrH+j817CbEyb9Axp29yQzNCOyRsfhIj0T6sSQ3PFt1OFcP1qkDCrmbZYOrQYsBPFhrbg6C1n8bT2qRaAorbljzj+JZTAbpWFmxUttTRJfQDjmxnO6ugkxnelITgN7LdIflEMhkYx0dQJg+aWPWvxB6f0ELIQ6lgAoowBYDG5KscJmzHTfi++WfjJB4LY52EwMX4Xv3RDoyB+jVXSnDCyf25naixc7AkEr9AprcKcY4BKkM9I8KaHgwS6YD9/DfS3SQSR7unWvMTAV917ehsszcp+iKJ9LPY996sqnuL+vEKlHH5V00Bwuk5S1VKbSknmlqMyIQghJ0Mq0exyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB7177.namprd11.prod.outlook.com (2603:10b6:610:153::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 08:49:58 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 08:49:58 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcfvaNGzJc+xBW3kWaSmjSCr7TyLVTNhiAgAJOnoCAA0M3AIAAd0CAgAAEDAA=
Date: Mon, 19 Jan 2026 08:49:58 +0000
Message-ID: <e69815db698474e113dec16bd33116e54cb21c2a.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
		 <20260106102136.25108-1-yan.y.zhao@intel.com>
		 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
		 <aWrMIeCw2eaTbK5Z@google.com> <aW2Iwpuwoyod8eQc@yzhao56-desk.sh.intel.com>
	 <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
In-Reply-To: <3ef110f63cbbc65d6d4cbf737b26c09cb7b44e7c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB7177:EE_
x-ms-office365-filtering-correlation-id: e85b32fa-662a-43f3-5fca-08de5737b9bb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QVZ4TlZuU25YZGlnczMxUWQ1M3BUc1RGd1JFZFh2bVo3V2p5YzIvWUFIS09U?=
 =?utf-8?B?V2V4cTZERVVrNncxeW1TMGNwSTNvOXpRY2ZUWnM2ZEtyU0FpQ2FBa2VGNHYv?=
 =?utf-8?B?Z1kvZzg1ZWd1U0thWlJnZjNpZ0VxMklZVE42LzdQV3FlWjV2TER1b3FibUJM?=
 =?utf-8?B?Y1F6SzJxODgvN1lJYThtYkphaE1ZWlZBNzAvQWx3cjZqSWNoVUJubWdDclhq?=
 =?utf-8?B?bndEamJ3SEN1SVB5UmxxZmk1YlVlVnQxV0svdmRLbU5LSW12WFM1TnF1VkRU?=
 =?utf-8?B?ejcxZGlMMTFZcW1kcGRTTUxSRWJDakVpdkl1d0JZSkhxSFkrdTNKRlY3OENP?=
 =?utf-8?B?bk1JUmVBR2d6RzE2OGxQRDV5Slg2N09MSnY1cDJCWWNObktCQVk5eW1vaEpY?=
 =?utf-8?B?TzhIdS9kZENSZHMrd3AwdGxlZjhRQ2JLTG10VFhIaER6VktlOGFRVmlMUUlt?=
 =?utf-8?B?N1h6ZVlLTXdSWW0wOWFsZWlGL3laN1B6ckFqR2E5QWlTa21UN1BwTkU2Sk1G?=
 =?utf-8?B?TU5oYW4wY2MrbDdnRmljM3NrUEhVR01PRW9EMlFWclBpRWcrenRFUEFhdXVi?=
 =?utf-8?B?RkJhTWRXaU9ZZWU2RUdJcXRySU85dWFicFdSdFBxbi9vdFpZcGY4dkEzeDRk?=
 =?utf-8?B?OHpuTmV5U282L0tsSVB5UllqRlFMWkpQcnFjeGQydU8waG1iaW5nWUdUZlJT?=
 =?utf-8?B?V0tVZ2V6QUhsU0szSXZMLzZsZTVpcXZ3OGs1TkNhMkdRZVlya1dDcm1HdHR6?=
 =?utf-8?B?cktrdmxaOUdvcjB5cEJUeWZBTytNYWR2UFZraE9nekJ1UGFFTHZiUTFRWnlo?=
 =?utf-8?B?Z3I1WVBkblIrR1NaYVc3bHhVaUIvUFp6K3RCL1ZwQjFjckVkbXVlOG1uOVlS?=
 =?utf-8?B?eGJhTXE1NWM3TnFEdGVvc3VOTkdncjNuNHE1eEJqVnZRa2ZiNTFjL05zWjV6?=
 =?utf-8?B?ckdZdDVubG4zVTNVZ1FkVWVIT0dYYnZmK1hZaVc3d0ZtVlZSdmxKd2lNWlJO?=
 =?utf-8?B?Zk14bXF5VkRTS3JWVHJSbGZaRG1mTm9EUEZpazBTb1E5a3c3QlNIc0gyYmZp?=
 =?utf-8?B?anE3eE5PcEt2cUFybDF0OGx1eTAvbnBFaHZwT1ZyaldXR0VIcVV0eWJ4S1Ur?=
 =?utf-8?B?anVUaElaK1ZhMCt5a2dFSVlpZ3JFOGxEdHJ0c1lJR0F1TDdPUmVoWmp5Zk55?=
 =?utf-8?B?V0kxOXVkSUI5TU5XYmFIb1hPQkZ1ZzhDblNiR3k4cFFrNHllTG5hVk1qbUw2?=
 =?utf-8?B?SDF5WUI1MDZHR0loeWk0cTI0MXNoaVIvU0pyelRuc1R2eC9FNEltWXY2T2Zn?=
 =?utf-8?B?NnU1SEYvS0tRcWxVL0ZRdFlLN0E5MGdXZ3NvY3V6LzQ0SEpLTFltM3c2dmdB?=
 =?utf-8?B?UlZEbDJ2MVdoK3dRQml4ejREZmgweGZUQnhNYjZYTm5TZUJ5VVhsdVBxaHZz?=
 =?utf-8?B?VlYwOXEyZlBGV1hWUGRjdlZTTjY3MEdGYjEveWRDZjdHUVdVN1lMejgzU3E4?=
 =?utf-8?B?T3N3U0xLRG9pQ2tWd2UrWjZqckR1RVJPcVdQN2pJRFUzZ3EzMUJhTTdCL1N2?=
 =?utf-8?B?OTdqcmZENmxtTjhhWVcyMXpkZXFDR2VVcWo1QzBJQkp2eTM4UDdjaWVrc1Fx?=
 =?utf-8?B?Y0FQQUVoWGc4dWJBelBkUkpqZFFwUFFQNFZLRUtFcVA4bFR2cDN3UmFqaUFF?=
 =?utf-8?B?V0RiZVVhOStodnJXcjZuZ0lLd3cxTzNnMk10YnA5YUhaUS9YbmxvVzNnMXNa?=
 =?utf-8?B?ZDQ3WjVnZXE3VERmM20wZFZnOHRZUlFiU0hYdUViaFdFYk5aeTFLT0RmYWVL?=
 =?utf-8?B?cjFPc2h6dkFMOGsvcTRYbE1HSXNZZHFpSDBtVGtTODBvUWhmdVUzMnpBc215?=
 =?utf-8?B?aHJWWkk4T3pKN2FLZWxnS2ZDMGw4cHFjNnpWbTAxMHJlZ0hYNTV4RlE4TmF3?=
 =?utf-8?B?ZWRkWlk3WmsyZ3RkeGdHNXRTeHFzenlTV0d4dGdkU1BWQnNRMHpZMXIyc2RI?=
 =?utf-8?B?Z2w1MFI3K0V3WEdLeVlyaldqY1R4S0oxem54Nm9iR2FGeWRoWnRFK2toWnRL?=
 =?utf-8?B?SkV1UitzUjl5czBUeTMwQVExOEsxV1dOTmhJUTE0NlRHWEpxVFFwZHE0RkpC?=
 =?utf-8?B?RThLM0FNTmFaVGYva1o5R3c1Yk9kVUJ1YkhhVHdISnZPam5meGxCRkdkZWdJ?=
 =?utf-8?Q?tHaBGe4N/Vk0e64Oo9S+SqE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1NRME5TTTIraHNROU45Zm82L2NJYXRNL0xDOWtaKzBoVTJqM3VSYndCSFg0?=
 =?utf-8?B?RFNmYnVnUktnMDlwTTRJS1lUUCtiUERtV2RsbElra3NUbnRuOVM1Y0tFNkh1?=
 =?utf-8?B?RzRCU2Nuc0c5RWNVOFVMK20wbHpSaEFjWTYvVXhYVE1Tcndod1A5RWNxM1ZS?=
 =?utf-8?B?eVRpWDA1ZEJtYTVONTdvQ1NNS2NhaTdtbHZVczZ4NTdUU05SZi9UdEVvYnY3?=
 =?utf-8?B?Nm1pRS8yQkU4cUg0MStHRGgyMTdhOTJpUTdIZ1h4U2xMQUNjR2NibnVkMXRI?=
 =?utf-8?B?UEhmWFFaU2s3cWtCZ2pJaWgwTW5IWjZpcndXUmJjRGZoQnVheUJycFJGbU9F?=
 =?utf-8?B?UDRGVUJvZDBNL3p5QThkblNLc1JSUWlWaDhmWmdGWmF5OXpza1M2aTJXSzdZ?=
 =?utf-8?B?ZWR3Tm91cjBWREJDS0NrNW0yVHg3aEV2aEQ4dFBoNTBmNWJsb1U1WTE4YU1j?=
 =?utf-8?B?a3BpZ2R5WktHZFQ5KzRoTE5qcEgraWJaSXR0YnhNcDVPMnRYSElpdGJ6aG1K?=
 =?utf-8?B?UkNSSVl5RHF0cXRkNWc1M1h1MS9Cb3p5L1B4Rnl2WkxWdWlqckp0NmVyVjgw?=
 =?utf-8?B?b0FtNGJwWGhoSVRMNEhIdE9ocDhycGRDZENST0JpLzJIRGVKMHVpUitjc2Vm?=
 =?utf-8?B?STNaNU10ejBwQ2VCdGEySFMyZkk4RlIyL1VIVGVvdmc5SkZOdS9sU0R4aWcy?=
 =?utf-8?B?N0lBVDc4cEVSYlNobHFJQ0dndVVSemROUlVCN2EzY1JlMENjV3JHKzJHdVFk?=
 =?utf-8?B?bUUzMkVPUmlDaERaZFRXVDdJSXRNZjNiNExtSDNraG41eUdKbkY2VEwwMllq?=
 =?utf-8?B?QjdSQXZCOUFnZVhRU2RZVmpaTlhqS0V4SE44KzEwRU5rSExxUGFkRWI1S0pk?=
 =?utf-8?B?ZVdwRVlhTERYckFaNDdBM3hSZndvRWJYOXRpWWJYVFkrV3c3WnQ2RXl3NEJW?=
 =?utf-8?B?RjRvVnRpR2NuNzhva1dGdnJHSmtXMEw0MjQ2Q0tpd3Q5cHk2NlFsYjY3Ynow?=
 =?utf-8?B?ZFBya3cyd1o2dy9DejFmdFFyTEYzZVJ5bmVNN1VaK0ZscFIzTUxSdjRMTGNm?=
 =?utf-8?B?VU9iZGgyUWFjS0RhKzZYQ0dBaUdxQnpKYWlKb3crQlc1NEZDVUZWRVFHa2ty?=
 =?utf-8?B?VVl2VTRBeWZpYmZTVDk4VkExUlgzcGZETG1CR0pvTWthMUhzV3RxZzI5U3Z1?=
 =?utf-8?B?TDRZMENBU1pRWEtTdFNYL2cxSUZSTVNscG9NUDJFNkFEanprcGRSZVhJRko4?=
 =?utf-8?B?NER0TDE1T3pnQW9hOFBXa0FsVXZIRGswQnpaR2YvVmZGb2g0NkU1cnp6MWkr?=
 =?utf-8?B?V1lWd1paNzBNVEp0WkVGSllpL0luTjFvNFN3Q3dKZlFKbllPTlRacG53ZnFz?=
 =?utf-8?B?YVRxZVdVY2NEOVVUV0pFRVllMDhJeHp0ZEdOZTJjNWpqdy9SdGZkQ21tSkow?=
 =?utf-8?B?YjVVUjVjM3cvNXJOL0U1SjhZb0hFT2RNdXJDdXhjeWhaYUMwMTk4UXpLOUtU?=
 =?utf-8?B?Z1hodnVBQ2pHbHFiLzh4RzlBMW82VEVCNjQvU3J5YW9kWnFqM3FGUDBVU2Qx?=
 =?utf-8?B?MndHZFlFSzB1ektjUmxYYmJSaXYzTkxsNWtRWmt3Q0I0alBheUdzUGFQbnFh?=
 =?utf-8?B?QjBIdmdIR3dpY2o4ZWNkcGwybERCUC9HMXJRL2Z3SzlDaDlWZm9YeGlUN3RF?=
 =?utf-8?B?aWNQazVNUmRHWWp3cGpCQ0JYZzlyNEpGNTJoVllDNFJhbm1FOHArQkxMTnk4?=
 =?utf-8?B?ZGdnN093TS81S2hRejVhS2RiYUplTnFUek4ySlZXUGtMN1JaL0NvSjAzMjV0?=
 =?utf-8?B?NEtpVzFXanlnb213OWtkWm1nSkM3My84K3ZPV1Y1RzNaeEpOL2xJWFJZVE1B?=
 =?utf-8?B?b25HK201SmpOYWRmaVNlZi91dkV2eXhoL3RINFF6aTNZRWZwRzdIZ2JlcGxw?=
 =?utf-8?B?V2J2S3V3RGVacmtLUk95YzhJajlCeHRxUzlBQkFUSUFvMWRYYzVPcHlBbi9H?=
 =?utf-8?B?RHRsOHRrd3RvWU1IRmNtZHZFQmFhQ2pIWi96aFJTVFF6UzhDeDJ0d1F3UHdY?=
 =?utf-8?B?MThCOXpsRk5qL0xpQmxvYXFmR1ZVNjBibE1rRDV0dmUveWxUOHpBYStZcDRz?=
 =?utf-8?B?bmFIaVo3RWZLYjhHUlQ3cUN4RXlrZHNCRjRiRkJhWS8wSDlNYlRwaWtLRHYw?=
 =?utf-8?B?MGlWRVdQWUpOYkNER1pkN0ZZYkdreXJvUjhVNm1wb3ROcDJWcm5LOWE1TGRW?=
 =?utf-8?B?d0tHcEpnMVZjOHZDdVhEZURYekR3dDFOME5HNFE5bGY4Q0hjVDZicUdQdUh2?=
 =?utf-8?B?a2VIVjVMcUUvY2Y0VnRkbThMUk05ZU5saWtPUGtRQ1QzYUx5NGVFUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C8F583BD5279B4298F6834B50AE75F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e85b32fa-662a-43f3-5fca-08de5737b9bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2026 08:49:58.3511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CISVy0uwDGcV2G3cTZZ6/Y5A4cPnseYQPNmsXLa430/zXddoH2/JShBOi9ZC9xF+rVJ0ERSCAxdrvq9FDeSoAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7177
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTE5IGF0IDA4OjM1ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjYtMDEtMTkgYXQgMDk6MjggKzA4MDAsIFpoYW8sIFlhbiBZIHdyb3RlOg0KPiA+
ID4gSSBmaW5kIHRoZSAiY3Jvc3NfYm91bmRhcnkiIHRlcm1pbmlub2xvZ3kgZXh0cmVtZWx5IGNv
bmZ1c2luZy7CoCBJIGFsc28gZGlzbGlrZQ0KPiA+ID4gdGhlIGNvbmNlcHQgaXRzZWxmLCBpbiB0
aGUgc2Vuc2UgdGhhdCBpdCBzaG92ZXMgYSB3ZWlyZCwgc3BlY2lmaWMgY29uY2VwdCBpbnRvDQo+
ID4gPiB0aGUgZ3V0cyBvZiB0aGUgVERQIE1NVS4NCj4gPiA+IFRoZSBvdGhlciB3YXJ0IGlzIHRo
YXQgaXQncyBpbmVmZmljaWVudCB3aGVuIHB1bmNoaW5nIGEgbGFyZ2UgaG9sZS7CoCBFLmcuIHNh
eQ0KPiA+ID4gdGhlcmUncyBhIDE2VGlCIGd1ZXN0X21lbWZkIGluc3RhbmNlIChubyBpZGVhIGlm
IHRoYXQncyBldmVuIHBvc3NpYmxlKSwgYW5kIHRoZW4NCj4gPiA+IHVzZXJwYWNlIHB1bmNoZXMg
YSAxMlRpQiBob2xlLsKgIFdhbGtpbmcgYWxsIH4xMlRpQiBqdXN0IHRvIF9tYXliZV8gc3BsaXQg
dGhlIGhlYWQNCj4gPiA+IGFuZCB0YWlsIHBhZ2VzIGlzIGFzaW5pbmUuDQo+ID4gVGhhdCdzIGEg
cmVhc29uYWJsZSBjb25jZXJuLiBJIGFjdHVhbGx5IHRob3VnaHQgYWJvdXQgaXQuDQo+ID4gTXkg
Y29uc2lkZXJhdGlvbiB3YXMgYXMgZm9sbG93czoNCj4gPiBDdXJyZW50bHksIHdlIGRvbid0IGhh
dmUgc3VjaCBsYXJnZSBhcmVhcy4gVXN1YWxseSwgdGhlIGNvbnZlcnNpb24gcmFuZ2VzIGFyZQ0K
PiA+IGxlc3MgdGhhbiAxR0IuIFRob3VnaCB0aGUgaW5pdGlhbCBjb252ZXJzaW9uIHdoaWNoIGNv
bnZlcnRzIGFsbCBtZW1vcnkgZnJvbQ0KPiA+IHByaXZhdGUgdG8gc2hhcmVkIG1heSBiZSB3aWRl
LCB0aGVyZSBhcmUgdXN1YWxseSBubyBtYXBwaW5ncyBhdCB0aGF0IHN0YWdlLiBTbywNCj4gPiB0
aGUgdHJhdmVyc2FsIHNob3VsZCBiZSB2ZXJ5IGZhc3QgKHNpbmNlIHRoZSB0cmF2ZXJzYWwgZG9l
c24ndCBldmVuIG5lZWQgdG8gZ28NCj4gPiBkb3duIHRvIHRoZSAyTUIvMUdCIGxldmVsKS4NCj4g
PiANCj4gPiBJZiB0aGUgY2FsbGVyIG9mIGt2bV9zcGxpdF9jcm9zc19ib3VuZGFyeV9sZWFmcygp
IGZpbmRzIGl0IG5lZWRzIHRvIGNvbnZlcnQgYQ0KPiA+IHZlcnkgbGFyZ2UgcmFuZ2UgYXQgcnVu
dGltZSwgaXQgY2FuIG9wdGltaXplIGJ5IGludm9raW5nIHRoZSBBUEkgdHdpY2U6DQo+ID4gb25j
ZSBmb3IgcmFuZ2UgW3N0YXJ0LCBBTElHTihzdGFydCwgMUdCKSksIGFuZA0KPiA+IG9uY2UgZm9y
IHJhbmdlIFtBTElHTl9ET1dOKGVuZCwgMUdCKSwgZW5kKS4NCj4gPiANCj4gPiBJIGNhbiBhbHNv
IGltcGxlbWVudCB0aGlzIG9wdGltaXphdGlvbiB3aXRoaW4ga3ZtX3NwbGl0X2Nyb3NzX2JvdW5k
YXJ5X2xlYWZzKCkNCj4gPiBieSBjaGVja2luZyB0aGUgcmFuZ2Ugc2l6ZSBpZiB5b3UgdGhpbmsg
dGhhdCB3b3VsZCBiZSBiZXR0ZXIuDQo+IA0KPiBJIGFtIG5vdCBzdXJlIHdoeSBkbyB3ZSBldmVu
IG5lZWQga3ZtX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCksIGlmIHlvdQ0KPiB3YW50IHRv
IGRvIG9wdGltaXphdGlvbi4NCj4gDQo+IEkgdGhpbmsgSSd2ZSByYWlzZWQgdGhpcyBpbiB2Miwg
YW5kIGFza2VkIHdoeSBub3QganVzdCBsZXR0aW5nIHRoZSBjYWxsZXINCj4gdG8gZmlndXJlIG91
dCB0aGUgcmFuZ2VzIHRvIHNwbGl0IGZvciBhIGdpdmVuIHJhbmdlIChzZWUgYXQgdGhlIGVuZCBv
Zg0KPiBbKl0pLCBiZWNhdXNlIHRoZSAiY3Jvc3MgYm91bmRhcnkiIGNhbiBvbmx5IGhhcHBlbiBh
dCB0aGUgYmVnaW5uaW5nIGFuZA0KPiBlbmQgb2YgdGhlIGdpdmVuIHJhbmdlLCBpZiBwb3NzaWJs
ZS4NCj4gDQo+IFsqXToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzM1ZmQ3ZDcwNDc1
ZDU3NDNhM2M0NWJjNWI4MTE4NDAzMDM2ZTQzOWIuY2FtZWxAaW50ZWwuY29tLw0KDQpIbW0uLiB0
aGlua2luZyBhZ2FpbiwgaWYgeW91IGhhdmUgbXVsdGlwbGUgcGxhY2VzIG5lZWRpbmcgdG8gZG8g
dGhpcywgdGhlbg0Ka3ZtX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCkgbWF5IHNlcnZlIGFz
IGEgaGVscGVyIHRvIGNhbGN1bGF0ZSB0aGUNCnJhbmdlcyB0byBzcGxpdC4NCg==

