Return-Path: <kvm+bounces-62988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77179C5614C
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 08:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9150E3B912A
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F7832938F;
	Thu, 13 Nov 2025 07:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJPncspN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486873246E3;
	Thu, 13 Nov 2025 07:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763019462; cv=fail; b=MS4Cz9luRg+oLdxmdxae9r2CiSO0+Uj8R8aBGMexXa0PXNYsKiSBKYde0JCrXJpIWcbvE1ekZCzMlrS5T44Smcq4zKKu5CMMPLuaY0gJWFK8JiAyN5ExeSyXXiqJkTD58izTOC8G0QWbyFZYGzEsvQbmDt5cU/YGoZCX5rb9DPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763019462; c=relaxed/simple;
	bh=CHHiE/2RvaHufm5KHgpDuXlVk58K5MKSJpgyFAnyXuU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KNyjwi/6nsNQOWY7A0cnd92G25AcHpEHqJaUz3mJocD4HoromLxL24JGYMFNyhNsxvfp+6A2Yr3mqYZyOBdd704nPC8t5vd3dIPpu/SUn8gNe3NbxJvgaUeyD6JwgmHNs3tqQIQXI+R5p9LjDRxwdyKBTvHgofKSfMjbjkwDeUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJPncspN; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763019458; x=1794555458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CHHiE/2RvaHufm5KHgpDuXlVk58K5MKSJpgyFAnyXuU=;
  b=lJPncspNOfoT3Y6qO1jggJcV0k984/k/At6TDgYCJCpOuYSDqR+Uk1FK
   7v39pCYZSPPkGZENVA/7ka4LNUGOuNEjO1EU5Ud99OOQn6j2A7mSAjLpO
   iwhqd0htWfUbOHXdS/cX1gMH5rUI5XQ3Iad9O+H3lnKB2fkzzvoZS67He
   /BqlyUIXD6DL82AwwRDS94M223mxN28PmSiM7ysCZ2ul/YiWGfK0ZffSI
   tQ3yexC7vLV8O+ZMsmNUl2OZmza4QigbyVlRx5yH1HOGNcAuqKMUpQNvV
   UP2trDJVX5e38nzKXy7KJNkF9ltrj/qOy4MKDKpr6urFi6gHW+JPYglSO
   A==;
X-CSE-ConnectionGUID: eaTzMmGsQJGj0QKyBx0vTw==
X-CSE-MsgGUID: Hdb+h8tUQiqivdeHttCTyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64098495"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="64098495"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 23:37:33 -0800
X-CSE-ConnectionGUID: S59AZVLJQLKzo25/b9+17Q==
X-CSE-MsgGUID: cjx5NdKnTP24GhQ6PH+jNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="193849063"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 23:37:33 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 23:37:32 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 23:37:32 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.19) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 23:37:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=weywIlqd7UMGc5Co5qAIs3QM6oNdNWAV1C+7He+IjXXPkDMj7R8gU19uYpWQBOjg059Ycnue9ME3PI/Dfwpb+4Uextz/YBGppLd/mUZrFaoIU720FFsa42kEG42Mn5rmNtkuoXegVd/4gez85Vh8HDZJF/iPNUp3zuakF2Hwvldr1zSA6uJm/HFJRnMCZ0lxddPXjqXO2jSZO3Se1AJhMf2v3P6lrOTxmrDdLHtSJmjWT1fnjogibvnod55gi1+DxVyj1PxjJrODwCpOBwYeO3BHD+1gZhTyjwR0OYijraibAGcwG14+mnFmTCja3gXPI4qJbXxV4G4sD1X1b9tT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHHiE/2RvaHufm5KHgpDuXlVk58K5MKSJpgyFAnyXuU=;
 b=iq1BJkXr/TT2COxMl8ya1T5mptyRmuxeWTcDo09IQliBMGUZgkuecBb6lFNiRpq2mJ4PGhCncfWrcL+F9SNFoCyasypbAxDDyJJjGJAwgEB9VtzIY82j/a50zfWNvt3HabBt4i3WSUy46+Al1Tj0bLj0enjRgWirRYwZujPZEzMJXO3YVp1MDHpEhu0UI5Ve3806tDbmkX++OFdb8+da3zKXEnN+oHSpzhKuhXC/HFFVkpORD0hiFprVmlSXo1EmH5F+zPcxCldt1PB7+m+te48q0UfyjOKmfyH1zyto+EfSVw9qvcNSZTjJGw/CJ2abdZ92lnHWLYHH/0PrhX7ZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM6PR11MB4692.namprd11.prod.outlook.com (2603:10b6:5:2aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 07:37:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 07:37:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Topic: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Thread-Index: AQHcB3+qgPjJH8tKFUSGhVyOSb/37LTtyqyAgAGHLgCAAB2CgIABDeuAgABUcYA=
Date: Thu, 13 Nov 2025 07:37:29 +0000
Message-ID: <01731a9a0346b08577fad75ae560c650145c7f39.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094202.4481-1-yan.y.zhao@intel.com>
	 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
	 <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
	 <858777470674b2ddd594997e94116167dee81705.camel@intel.com>
	 <aRVD4fAB7NISgY+8@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRVD4fAB7NISgY+8@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM6PR11MB4692:EE_
x-ms-office365-filtering-correlation-id: d46e1640-e011-44d7-3731-08de2287801c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SHVYWDlhL3Q3NnJjcUE0RE13cXltWk5hZE9ualBCWUxJbC8zdm1tZjdDQS96?=
 =?utf-8?B?RnRnVGc2djVlUVNXQWdFcHpkWWxIR2QxTnpRVmZlWk9uS2xVOEdSY2o4UjVX?=
 =?utf-8?B?OGV1S2lkVkZLNmt2dmV2MFFnZkE1TnUra3llemFKbUg4UnV5YVNjNU1zZ1Vy?=
 =?utf-8?B?VmVYU2FsSTBpaW43TjlnTXJxQkRZMGxUcHhyVkdHR0dtWVVmTmdtV1hhSzI2?=
 =?utf-8?B?bHV5czVnTlZwYjArWFpHdmFYRjAvMzM4MGF1M1Z6SmIvdWxBMWJzTU53bE5U?=
 =?utf-8?B?TDYvVWtSaEV4Z2U0TWJoTHN0UFRXSDFpaXBwUk1vUWtUUlBPSlB0eUhVc3JN?=
 =?utf-8?B?ZGNRVHlXR3hNdm43MGZ6RHFFY1hTVlhYaWt2WExjZGRia1BaL3FjL1RZa1Vp?=
 =?utf-8?B?MkpJRmp4LzlNWlpSNnFJd2tmVWNCTVR0TEJPTVM3Y2F6aGp0L2lFNk92U2N3?=
 =?utf-8?B?OUVIWmxwaXRNWTduYWVCc3NLV1lxUXQ4RGY4NzRTL3ZSSXZtaEdLelFyY0tq?=
 =?utf-8?B?YVlycFE2VFJ5WDNRTFVIUkl2dFA2U0hGcGl4L3NDNithMG5qcnhlWWVrZ0x2?=
 =?utf-8?B?bEJ5eE5EaCtPRUI2cHN3NnBDK2dHTTlHOGhxaEZ3OWZMcWt2dlA4ZEtwZU1C?=
 =?utf-8?B?RVBLdFJrKzlhU2JPQUxMdmpKYnhXaHVDMFlEV0VsRGcwL25wdWJYRElET1lC?=
 =?utf-8?B?czM1T0tENGZYZ1ZvYk5IclBzOGRtVmdvZGRCRVhaYi9kZ2xjMWFXbWJueks5?=
 =?utf-8?B?VG1KdllrVUkvYmkrcHR4TVVxSEZhUkthS3hJOWNTaE9uRUNxNVY4dVR4bUJo?=
 =?utf-8?B?Ry82cWVNZHRYdWdIZGFKSjZjeXNYRG1DUlZleE1FRTVQSHRHVFRVN0ViRzVB?=
 =?utf-8?B?ek9KRTlLZ1RmQ2RUY2lzaHBIOTlWWTdHMG9Vd2UyZjNPaXNJazF5UlJpVnNX?=
 =?utf-8?B?UnZGd2p6K3VKNHg3ZkY0dUlkRlIzQnBKYmRadUtiWW4wRVFHRURleVp2SXpz?=
 =?utf-8?B?Snl3cGZxNDBuR2Zkd2tVTmZDdXlhSlcwd25EVlRWUy9hNFBxTFVRYUR0VzlU?=
 =?utf-8?B?S2xzejAyd0hWUU83M2lCTlk3blQxK2ZtdGVjeVJOMWZJRlNQQzNCcE4vbFdK?=
 =?utf-8?B?eDd0Q1pqR3FZRkV0a0ZEeTVodTNOaFJxSlJCVHBITjFTSlF4UFZjSnZmbCtM?=
 =?utf-8?B?V3QxL3RHdnMzWUhqUWxkeUtuNnNncHdLVUhLL0FwMHU4ZzN3aCtZNmx5QXZY?=
 =?utf-8?B?cDRyZzhoTXQ0N0kvTHRTZFdEL1cralIzL2JpbEN3dUM2OGo4dDlRdERweEI3?=
 =?utf-8?B?L2ZSK2ZyWk0vck14SVVzUEgvTm9UcEVYa2dwOHNmQTZobE5pN1VJd2tWc2l0?=
 =?utf-8?B?QU42dThvcUdBbTJqYkoySXRtaG1jK3NwT0dZVDNKQnJSZTllNWV4ZThCT1du?=
 =?utf-8?B?UHZUSjFaQ0hISGk3M1pJaDF1dDAzd0JaTjJwTWRDOUJ3VkRUcHJRUHl5MWhP?=
 =?utf-8?B?ZzYrb1NlSTVMTGZGRmRGK2poVm5wWUlQWkREeTAzbG9WMit4TCtjR1ZRclpQ?=
 =?utf-8?B?ZCtjU3Z5c3lZL1lCK09JYkZjblFJbnp1T2ZtNDB3MWwxVzRkMWZ1R3UyUmhR?=
 =?utf-8?B?UnR4NTRXeHBSbUVFSXprVWFUZEVSSlJmOFRlOTk5Rkc4S01vdkF2NFFWYVpW?=
 =?utf-8?B?TmlhMGp6UFF3amlRMmdFRFNXeDBBdGhzc1hvWVgrWVZNK3hpcmlYNVpsb1Ux?=
 =?utf-8?B?Yi9RRDFHay9FclpoeHlrSG1hdW9SL3hhQitMdURuTjVRRTRZNllzbkhCVlZn?=
 =?utf-8?B?UEhZMXdmZEVwY2JVMXQ1QW5ZSWJWbmFLM2RrdGV2eVlFaEZmSFVsSC9lZWg3?=
 =?utf-8?B?SzFCWjd6KytLaEk2YTlZUytKeXFHQmxqUVF0Vi9tTTIzNVZieVJKcEs0bW9y?=
 =?utf-8?B?TkgyeTc2Z0FqZE43eFNzeEs1eC8xMjM0dTczNzF0ckhPbnUxYzVRWHdsUGY3?=
 =?utf-8?B?RHFSY0ZpcVZHbGFtSmlMZWk0RS9INmIwbnhGNExZUWpIOWY1WlYrRGJVZHRK?=
 =?utf-8?Q?naNKzv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3IrbVgxbnZSc3ZzZHNKNGxURjlLNTBYVG5EbnA3S0lIN2hVd3djM2hudk9Q?=
 =?utf-8?B?c04rUVlBTXdvOFU3VGROcHhBdC9PU201Vzg0MnJ5QVM5aDI1TWFvM1hVS2RT?=
 =?utf-8?B?UUNBNHc4N0FPOEJYajViYUdnSTdqcm9wQ3U3bUtXMXNocmt1V3NuZXhWN01Z?=
 =?utf-8?B?ZTZTU0V4UnQwcVoyanlQTzVCK0RKNXJXVlZ1TTVuY2ZZU2x3T0g4R3BrNVlL?=
 =?utf-8?B?NjZ2K2lxZ2RRWThzeFdKTmM0V29iVUNIZWZtcGFTUHZmRkM5YTJFN1JrT1dM?=
 =?utf-8?B?VUZTbnhGZ2FvVkthd1YzcGtVVU94SWZ6bzJOQ0todHRpREFva2lsaGRrUHQx?=
 =?utf-8?B?VVNHb3ozd2Izd2RUMXlPcmRwNUNHNW4yLzE2dExsL3ZNc1pnSkR1YXZ5eCtH?=
 =?utf-8?B?bHFKUVUxNnlTYzd1c21YN2pNUHVzcGRpaUpzODBRVjhzWEI4MUthK2h5WjUr?=
 =?utf-8?B?Vzh6MkRZb3VCNDBpSkxzWmF5WmxZUUZGMVF2NHdwTVo2aERITmc4d2h2alJo?=
 =?utf-8?B?RHkzaytMamE0WDZJWUxmOW5HWFhJU1lOZlFuWTVRVkNGZVNpSi9JUTljVzV4?=
 =?utf-8?B?UXNMMUZ2MFc2Ui9tLzFnZzZwcUxRTElrMFJSUGpuR05VQ2lYdzJLMWp2YmFT?=
 =?utf-8?B?OStRVEh5bk9JM2d0QW5zVkcvRXBSYnVVZE5FNEhwTlM1OEdlNTJsTVVJa294?=
 =?utf-8?B?WmtLNkFkcTE5clZzMWErVXQwenpGSng4NGdyd3MxZVBFTGZaWXJIVHRRcmZl?=
 =?utf-8?B?N3ZIUDhpSGJlck44bEt4VWFZc1M0YVNTZVF6alB6N2hBYkJQUi96c2c4N21x?=
 =?utf-8?B?VWp4MkdRZHArUk8xMndFMFQrTDdLeG44cnRVQnBTWmIveEdKa1BpUkJOYVpF?=
 =?utf-8?B?UUM4MFdaQVZoMUZldmxxanYzRzFjTHFCb1VkWG5aMVhzd29vbGpoTjdBU2J2?=
 =?utf-8?B?YXl0dVQ2c3RZdktrQkZ0OC9RUWdMTm1KQUV0c3hja3FRU3g2cGd5WHpGSlQr?=
 =?utf-8?B?VU9VWXhEdW13ZXcvWHJqTTZSNUdXSEgvc2Voa3JEUXhPdzZqaDZYazBDMHlQ?=
 =?utf-8?B?RTZDOHJWK0lYZjdJU3N2QTkzWmZDVXhkYnFVNVpzM2Vpc2k2bGRBT2grT3hP?=
 =?utf-8?B?NnZFSEdYaStxTk42b1lBU2dZWkZJNWsydWU1dkVUZWFHbWhtaHR4WnpIRHhL?=
 =?utf-8?B?eWhRVWVndTVCN1krWE5tMGx5aHBHaW5mVkxvY21KZnBWdzVTT2NUK3NNM1JI?=
 =?utf-8?B?MmhhSzM3aXBOSnk1Mk9uR0dUd2R0UEM3NmxkNVF5NDRhY29yS2ZvS3BDalZB?=
 =?utf-8?B?K1doNkErS09vU3ZjRHBFNkVKRkN6SE9TSnVSWnNnRWtLNjZac1FLVzdCM1Fy?=
 =?utf-8?B?M3RBaDhubzNOaEFQM0c2UUdiY1dHNElRMmVxN2w0UWJRRzYvWGg4VHlNbmdu?=
 =?utf-8?B?WXh1S0d2aDI2T2E2NzNISEJ0cHJOZGdORzBqY1VUc0VzRVZNV0FFT1RYbFVZ?=
 =?utf-8?B?UmJlSks0Z1BjR3VPMEcwZzVXTlMzSXFDUVBmbmhJajRsdXUwV2puQm1QUG55?=
 =?utf-8?B?K3BwVUdBVHZRcUdxc0VGY2hZeld6cmlBeVBsVzdHOG1UMk93MXZQbFVqT3dO?=
 =?utf-8?B?cXR3SkQ1eU5BTDZjbGVYM29xWTNLZ21GK3gveG80MTZYWVBLbHU1TmltOXF0?=
 =?utf-8?B?eHFtaENVeTZvek9GL1haeEJRbWtZUkdLaytUS1pqRGZFcmFHZXpYamUvZjB3?=
 =?utf-8?B?SW0wb2l6bWgvYS9NamxLNWQzb2JNSXQ0UEhnSnJzNCt3N0h4S21DcnJQYjRY?=
 =?utf-8?B?RkZBTFdmc1haRnI3Q1VmQkpwN1hoSmliSHhYNGN0Y1R1bUFnMFNtT1l5MnZh?=
 =?utf-8?B?bW9BRkZ4UkRNR1d4bTBKVnJOU3VmMkJpaXBSbmZVZU1EQk1sWEJDcmJYZUdy?=
 =?utf-8?B?V0k5YWYrVkNxU2RreTh1NVdXY3RqMGJOd25RUDhjOXZOSUZjWk1WNDVHdnlv?=
 =?utf-8?B?N0NJd1dBZnZTampGa2NaZCtEUUk1djlGajB2cGF0bFdhdDVGT3AyTEJMaHpU?=
 =?utf-8?B?bHBpMXpEakZmaS9pYmRSVHRYT0FnQitMSHpubVVaejJ4QVBoY2ovV0liZVVW?=
 =?utf-8?Q?qORxUApStNsevbXLAu6ZKu6Ka?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <857A958B917AD44EBE4212F24C011645@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46e1640-e011-44d7-3731-08de2287801c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 07:37:29.8132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YZMt6OorL69H3TJYVO1L0mx8jE+v1vsPlh0qHKRv6c8Kzg2/CmwDQ82XzsiWbRY5YWDGICvmGmAMbBhY2z3gew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4692
X-OriginatorOrg: intel.com

DQpUaGFua3MgZm9yIGFsbCB0aGUgZXhwbGFuYXRpb24uDQoNClsuLi5dDQoNCg0KPiBJbiBbNl0s
IHRoZSBuZXcgZm9saW9fcGFnZSgpIGltcGxlbWVudGF0aW9uIGlzDQo+IA0KPiBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBwYWdlICpmb2xpb19wYWdlKHN0cnVjdCBmb2xpbyAqZm9saW8sIHVuc2lnbmVk
IGxvbmcgbikNCj4gew0KPiAJcmV0dXJuICZmb2xpby0+cGFnZSArIG47DQo+IH0NCj4gDQo+IFNv
LCBpbnZva2luZyBmb2xpb19wYWdlKCkgc2hvdWxkIGJlIGVxdWFsIHRvIHBhZ2UrKyBpbiBvdXIg
Y2FzZS4NCj4gDQo+IFs2XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNTA5MDExNTAz
NTkuODY3MjUyLTEzLWRhdmlkQHJlZGhhdC5jb20NCg0KU3VyZS4gIEJ1dCBpdCBzZWVtcyB5b3Ug
d2lsbCBuZWVkIHRvIHdhaXQgYWxsIHBhdGNoZXMgdGhhdCB5b3UgbWVudGlvbmVkIHRvDQpiZSBt
ZXJnZWQgdG8gc2FmZWx5IHVzZSAncGFnZSsrJyBmb3IgcGFnZXMgaW4gYSBmb2xpbz8NCg0KQW5k
IGlmIHlvdSBkbzoNCg0KCWZvciAoaSA9IDA7IGkgPCBucGFnZXM7IGkrKykNCgl7DQoJCXN0cnVj
dCBwYWdlICpwID0gZm9saW9fcGFnZShmb2xpbywgc3RhcnRfaWR4ICsgaSk7DQoJCXN0cnVjdCB0
ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHt9Ow0KDQoJCWFyZ3MucmN4ID0gbWtfa2V5ZWRfcGFkZHIo
aGtpZCwgcCk7DQoJCS4uLg0KCX0NCg0KSXQgc2hvdWxkIHdvcmsgdy9vIGFueSBkZXBlbmRlbmN5
Pw0KDQpBbnl3YXksIEkgZG9uJ3QgaGF2ZSBhbnkgc3Ryb25nIG9waW5pb24sIGFzIGxvbmcgYXMg
aXQgd29ya3MuICBZb3UgbWF5DQpjaG9vc2Ugd2hhdCB5b3Ugd2FudC4gOi0pDQo=

