Return-Path: <kvm+bounces-51764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D1AAFCCC6
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 15:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56D151882811
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 13:56:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885C22DECB6;
	Tue,  8 Jul 2025 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R+XRPRe7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938502DEA9C;
	Tue,  8 Jul 2025 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751982975; cv=fail; b=SXz1v5cU33VgGAMv/7fDWQeIv4gZxbFddBlv3LLDVUXakSOnio8x6VzJH+sFrkfoOYosnaamZ32pbewApKlJ554Codv1PXK5GU+d8owJsESR4SlMthacDwrwdwNtNWteVN5uzch8dVOQq4D79WkfvP+p4vYrkqizXpmcaYPSAKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751982975; c=relaxed/simple;
	bh=82MVqFhXOe6qkj323oRoKvW58+Nb6QrqiutphT6KGlE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qj7zVyr7bwI2UGCPhDeC6x3tEvKDnSz7IocbQmHr/sRom0egQ6vaz66R28BRhVoRdvKFDn4dsTnWCxmRXhNLtgWCNvFKfqDtPlBHlwprBZkNhH9VLK7sDkebs//F/GA84DrgHQ1ZsFj2F2665c9I9x/YDwarxj7aP5IGcesA3NQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R+XRPRe7; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751982973; x=1783518973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=82MVqFhXOe6qkj323oRoKvW58+Nb6QrqiutphT6KGlE=;
  b=R+XRPRe7J8/4OdB4hpjHXxxm7h4YHMcxmHnSz8Y/CmLFaD0ezOGfQ0N2
   Sg8RguYI27PWKPfPbbCzRd0x4oCXuhmVxCvmz3bE1pJGzDuOUKncaTbS3
   OvbNIxy5byaayb2DQYg0sGC4p+dRsNPXyhwUtRQtHMEw1vFtSQdB+q45t
   oMb0EDfduCjuInmnf4E+pfKupT5AwZgK5WvcbbMGigwZ21npw7WqXApzK
   289AXMR7+2kQ/4n+jykRW9Mx9S6JypGXnq7ypbY4LgCvDPgtbyz7iblNb
   63NvgV5JMbkktKyJJZ3Zvt9Rb/Rj35DNOjE596ZFRP3ahVppjTIP1A1Hk
   Q==;
X-CSE-ConnectionGUID: OrKagnscRbGYr0mFgU9k5w==
X-CSE-MsgGUID: A7hSXxxfSzOf1eyP5XTpXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="71806444"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="71806444"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 06:56:12 -0700
X-CSE-ConnectionGUID: PeWtbP27QXar5Wx+lvxXcg==
X-CSE-MsgGUID: HRTAWIvPQLG03PDpAa7iuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="186466005"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 06:56:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 06:56:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 06:56:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.68) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 06:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1jeLRt07/5KmHYQkZIMAW5HYa3CpF2saTUV2Hf+BsdsPEF2UIWgCoHJlFZ72NPL87CC5psco5ijht+SUSOTlxVMmtfdyOxiVytdnG+WgCoXaV1EotOxzKHm0TggK6cbCF4d1oolsCSGpIMQ+4aSlocQhLLIEyZkN8z9+tbhJplkTgVgj2XVcXMiEFU1VDGWW8xhs0Jne05acPvZntRn+DIP5HiGFpuXAVrUIZrpfLpbivLTbmTy5xzxpq9JvrokVVAFE2QiM/XPsmTVVjFihYokdf+yxXI0oaSOOIHEOiumS80UTb3wO7mhFeCWG9JejoENKxbwvf9btUx1vv7+Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82MVqFhXOe6qkj323oRoKvW58+Nb6QrqiutphT6KGlE=;
 b=quAQ8MvC0H5EZ/xgoF4P+RluUq8Ad66VAP+hEBoOitl3qjRG6KL0vyz1YxqqioOOyj0YaSw9KuGdl6swSp1l/8xVexsovfpkchQFCyMcJCtoViNdrH3bn1QegaJIz7xwlYvzkldCKZ+6w2ySfsD9aji11Sfw/MTX8ULb/Dg0TkPOsJ729lFCn4UTQXCseKkKZKFGg1pZn5bR/Zzlk/vBrfH+sN91StpxL4bN4fx5iW+U3X5w4VLUQTiZQ/wEWHaDfuQdUvwB1KKiclVS4Q2OmdCuvxLhHuQg/O8T5uF5d9FKJSekTzPihkVrXr5ttPAR9Qp6RORcDn2WRRIqjxDqfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4931.namprd11.prod.outlook.com (2603:10b6:303:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 8 Jul
 2025 13:55:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 13:55:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Topic: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Thread-Index: AQHbtMXhHrhcZKCSdkuquayYYQc4lbQoYJcAgABV1QA=
Date: Tue, 8 Jul 2025 13:55:39 +0000
Message-ID: <9259fbcd6db7853d8bf3e1e0b70efdbb8ce258f8.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030428.32687-1-yan.y.zhao@intel.com>
	 <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGzbWhEPhL/NjyQW@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4931:EE_
x-ms-office365-filtering-correlation-id: 967d8a44-ee48-4473-c020-08ddbe271f12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R2hKNmYya1RiVFZuSTE5aUtBcHNZOEowWjB6V29rbmpKZ2xaaDRWVVU5R3RJ?=
 =?utf-8?B?VU5RUmVWTHVhVzBJMmJNbGVGWDF2ejN2UERkazFJQnd0TzFvVDQ4SEtEelht?=
 =?utf-8?B?eUc4eWpITHd2SS9kcXlLNjZQTGIyMFdxN2JSSkxyOHZnRmlaSmQwUEpsTk1x?=
 =?utf-8?B?TGY5a0ExYUxFeXRQUk00U0x2TThnNU80elpoZndEM09CMXN0eC9mUE5CR2Nj?=
 =?utf-8?B?SVhSeXlxYzliV0FMRzEwUlY5d1R6RU14U2E3d3NKL3FhZkZTUjlOMEFxaHp6?=
 =?utf-8?B?TmozOEN0YW5YSk1jWEx1MmFuZXpvN0dDTkNqT1hDTWlTU2I2cDRGR1VvREdN?=
 =?utf-8?B?bGhCSVVRNkszNVBSRWVmZy9OQXF6anVrb01RTUpGVUtFenp3bHNyL3ZDRTlT?=
 =?utf-8?B?TE11L3Iyd2hPc2NFY2lCaDZiLzZUOS90WnlZa1Q2Y1RGU0sxRjNMWDhWL0hN?=
 =?utf-8?B?eWRMMG1YUERaN0lOS1IrVmhPRGNsbVN0SktaRU55SHdGRGVmTFZiYlhNSWpk?=
 =?utf-8?B?R1V0WmpuQnAwT2RXa05WVmlJNE4rQjArZ09UK0xSS05IUmRCdWNRZEJMQXYv?=
 =?utf-8?B?Tk5FZDgwRGFrNTlaOVBXcjFEUHNmMm85UTJucmF4U2tyb1JjWVh3VCtIM1Bn?=
 =?utf-8?B?c2JLVjRVV2E3ay9MR2JxVXBYNW4zSitPWlNyM3dDTnFxNW1pOEYvdkxzRGxW?=
 =?utf-8?B?MitnaXFsbzhLRnhWY0t3UmVyK2N1S2l3TWZOZy9KVFo0VXB2cldxanhBVHVv?=
 =?utf-8?B?N1E3YnMwbmZhUzg0V3h2dmczSTdvOS8wQmd2ckg3UERMNUtZempJQTVJdm10?=
 =?utf-8?B?SEVvcHM0ay9DOGd4YVB1RjJvOXRRbmJsM2dyMUJpTVh2eGFwYm1oazBiQjhp?=
 =?utf-8?B?YmFNL3Bqd05NVWxja2dsdzZTMG9IZGlhcmtTT1JpaVhORGowalZRaGFlNmR4?=
 =?utf-8?B?VW5wemZZQnNRV1o3RGFBYXB1ZUpvVnFqU1BSbHMvdndqLytWTXpZMnVJa2RN?=
 =?utf-8?B?T09rbUM1Y1F1Vmx5R3ZmQWZPWE1vTmR1eDg0QUs2S1ZuOVZGZFdTSGM3OU15?=
 =?utf-8?B?YWlvKzE1RHhYc2t4OUppUVkyYXBXRW9kYk5hZFAzRk1IelBJVmFBUFNYTmcx?=
 =?utf-8?B?VXRiK3dydnlZYUNqcStrUHBBckZ0bTBka3p3UmVwaDZXaHZqTitJelFCdGNk?=
 =?utf-8?B?M2NDUE12N1RpNGNJZGc4U0RnVVJpQ28vdWZTQkhSY0owN3RRUGlqVFhwaDdB?=
 =?utf-8?B?Tlg3clRpS2FIdzR1MmlHdklDUVdwai9VeFR4a1RDY1NyMWN6OUE0Q1E3UmNE?=
 =?utf-8?B?NzFaaWMvcHhaT3BIMTdmZVI1MS9NSXI3MDU5SjlTOUJnNk9TV0tlTzlOaFYy?=
 =?utf-8?B?QWVQT2hHb1JxYkhmSnJUNUI3WEd0dW1iWjl4dkdZRXpqWWJqOGFsM3hDQWhz?=
 =?utf-8?B?V21IeURhd2tsUUhXK2poTEs1OG1kcHBJNW85NFRBazhEbXdReURrcmZFQ3N3?=
 =?utf-8?B?aWJERkR6cUNpUWMyVjlHQ2NJNlpUR0ZlQko3ekVGajVqZ3BsbTJxMnh6WTZ1?=
 =?utf-8?B?T2lmR1gvcEs1eEh3NXgvNlh2bW9SY2JWa2ZNK1FDN09Edld0emtiNmNvR21V?=
 =?utf-8?B?b2NaZEJqZms0V2hRQVNSZFVHeENQODh3NHkrRFRVV1F3MTVMcDFSOVIwdmRl?=
 =?utf-8?B?NFJhSXh3ZUpQYXdhempRSHNxckxudUZjZkJlazFzeUpCNW1SdXlZaW01WTFY?=
 =?utf-8?B?ZXJpemVCOFlzUm5SQ0QzYjl4UGZtWlpzNDhMTUhzWUZEL2VyNmU2bDUycmRE?=
 =?utf-8?B?Yk4yVGxnN2EwNkpRT08xVnpORnl1N2QwK3dQZ0FsYWtDZ21CaHBQalRlYW9F?=
 =?utf-8?B?a3JmMi93QnZ3b0pobkhsbldzSWE3c1k2R3pjWmxXNXUwYjI2Y0RrbnJYTlhr?=
 =?utf-8?Q?JdpnWuBTDdBcyuflpYbqiSp6jD327iwe?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2tmbjBOUUl4a0xneHV3OUExaDBKTHpNVjM2L2xJQlZKOGtEM3lmbXllZlNr?=
 =?utf-8?B?MGxFZ3Q2Z3FIVklqdHJQb3FlTzcyRGdqZ3RHY2NiMDlhb3RMeHRydWJocU5p?=
 =?utf-8?B?aUJpU2lnYzBqLzlqcks3RG9KOU1kdFM1Ykg0UWEzb045Q0xLV29lYmFqaWw0?=
 =?utf-8?B?MFUwRUdlWjAwVDl6UEVaVXNyMGRaT0VadGY3bmQyNVpzaUlTYXJva1FrV05D?=
 =?utf-8?B?dEpFdVFnbHJaL2hTb1pLd0pOTGJIQjhyWm5zKzladGNaTDludFRJQmI5R2RF?=
 =?utf-8?B?U2VKK3lycEZ1WUU1K2xFL0hKQXdYbEh1Tkd6bmtKSlNsVXZESWFEQ3FEZWJ1?=
 =?utf-8?B?cDAzVXJXNE5rK2QxejBRZnN3RUd5SFZ4T2MwWkxGWXFtelNUNVlGdVQ5M0o5?=
 =?utf-8?B?U1ZBMmRDcVJ2anhMd2kxVGV6N2E5VVdmT0RuM2U1V2k1SjVXMnpxOUNURDIy?=
 =?utf-8?B?KzRHc2FKNllSdS9jcGFIcnQwSlFSZzFlcEh2eWIyOFE4QkpMUk80K3JPQVNk?=
 =?utf-8?B?WndBREJOa2xwSmFFTkxYTXN5ZXJGVE1IcS9jUU8wWUE5WG5jUUg3MGkvbWNE?=
 =?utf-8?B?ZUxFcDBValM4YVRjc21odW5xbWRGTVBmTG5IUzc4Qy81bmhMQnZaakU0TGxj?=
 =?utf-8?B?amQ5V3RKZGJYUGg5ZnB2SE9vOEtDcVd5MTdFY3FBYkQ5V1dCVkE0eEJZZDRx?=
 =?utf-8?B?RW91b2lQMXZIWXFrRjFka21hZUFDWlkwUGxqZjB5amRYSVA1QlFDUk8vait4?=
 =?utf-8?B?dTNuWnZiNHV2ZjlVK2h4cWtNalFlb0ZBUGFpTW5iUFVhNEMxc0ZWbHBqcW5x?=
 =?utf-8?B?VXhQVHd3ek5pRVJUR1RHZU5Qam1vY1FLT2FRVDBpdjFjU1BzR2gwV0hiMkZt?=
 =?utf-8?B?c1FhRS9xNEI0bHBsQ2tKTG0vckhmL2VjMmNpMXNKQnk4eG1GTC9vS1c5Vnds?=
 =?utf-8?B?RmI3cXhRaDZDTUkrVHB1dEVLSXBFWFdRV2ViNkJWU1RFbU1iVHNESGt2eTlQ?=
 =?utf-8?B?Q1U2L09RbjRMYi9YdUFNL2QyU2tFcmsxb1ZSeTRlV1JuNXVwMHhtWFZJY05V?=
 =?utf-8?B?Nmlvd1B5OUl4cTVaWjdOQ3RWTUlCQjhQMlVyUEhrMllDeDNQYW9paUR2dHZ1?=
 =?utf-8?B?MDJQTGtlS3lmWEJyUEJZdFBOZXVtbFFQSCtEemJYSG5KMUxoM2NtL1ZRSnZt?=
 =?utf-8?B?TmI1ZGVkY1NDWmZmb0E2cklxcE9tV2l1YVBjQm4yYXk1ajhnRnlKSVhKSzlO?=
 =?utf-8?B?K2owb1BKNFFOU2pEdUV6b05vTWJBb2hkRS9QcTdqUUlEQ3VWWDVYK09SN1Nw?=
 =?utf-8?B?YVpRMmd3dlBiYVFtMnVHb0ZwUnZoSEFRV0tzaWtsT2x6OFFDckRSTHFvV2Ji?=
 =?utf-8?B?QS9kL25yczltc1FTZ3gxd0lOellaSktQdHZibldMNjJNelBjdGdmalN6eHN1?=
 =?utf-8?B?dExNOHZudjd2U2doWGZSWjhETWFVck9ScUFObTRmSzZVQnBoNXI3RWFFU1BF?=
 =?utf-8?B?WE9YSTlzZ1phT1VwZk1mOExyMUhLRDJxYzY1UzhkdU90RkEwSzZDeWI4amNE?=
 =?utf-8?B?KzRoKzBVOW9PVnBUMG1rT212L3pPNVVGZHZRL1lRUEdLVUZ5ZFZiODhUSE1q?=
 =?utf-8?B?OENpcjVOT1JmRGZrN05saFFCd0RSQjdlQ3ErUGhDVVFaUHBpVFNYMjJra1Z1?=
 =?utf-8?B?Ykd5SVBiOWx5NUljZlFKc0tFWUJIa1ZKbXIwTWJXUTdlYW1rUFl0VmtjZVJI?=
 =?utf-8?B?U0l5WnkrMFlLTnFvbnZjeHBKcTR6YzNOOUxLTXFLQ3B2MEZIUmdjbWVnMDRr?=
 =?utf-8?B?bFlDdlBmOUQxdjQ2ejlWTXF2LzVaRWdQMzkxaytZbWJSOXVhbVVsQ05EallG?=
 =?utf-8?B?eEI3R0pCUkhIbTkyMlIwZ09zOTRVdG9KU3BZNTdYZnJka1ZUR0FEaVd4MmRi?=
 =?utf-8?B?RlhRcmwrU2I0cHR2QkVsTnJ1a0U2VWlwUW5WZWpRQUFJeWNmTDJyTjM2SkNi?=
 =?utf-8?B?aFVFUStaQVU3bTVpV3hUUEtXVkRkV2d5MUNUVW5lV2J2OExsczM1QVB4MUJU?=
 =?utf-8?B?OTdzcytIQUNwc2VHNG9hWEd3MzJmZk1RYXJiZ05KTnhyV1MwbldvMGw1K1ZP?=
 =?utf-8?B?NjFraE5wV1Q0OE9ZOVJkUkVRdXF0MmlvQ3FzT1pjbmQ0enFPclpwQUhlczRn?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A75084E3F4E844BA8BF2482C5683B18@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967d8a44-ee48-4473-c020-08ddbe271f12
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 13:55:39.0503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: larOS6M2kfKHzd9NIUZY5XIXPZFuWJZ532az6BMBeEG7NQXFGx9qm2SGKtd4FJcFh2W7QQ/C2764T3XHRaPVgjzsmMSaWGjPz7X8ycgI7ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4931
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDE2OjQ4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VGh1LCBBcHIgMjQsIDIwMjUgYXQgMTE6MDQ6MjhBTSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3Zp
cnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IGY1ZTJhOTM3YzFlNy4uYTY2ZDUwMWI1Njc3IDEw
MDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ICsrKyBiL2Fy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBAIC0xNTk1LDkgKzE1OTUsMTggQEAgdTY0
IHRkaF9tZW1fcGFnZV9hdWcoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIGludCBsZXZlbCwg
c3RydWN0IHBhZ2UgKnBhZ2UsIHUNCj4gQWNjb3JkaW5nIHRvIHRoZSBkaXNjdXNzaW9uIGluIERQ
QU1UIFsqXSwNCj4gImhwYSBoZXJlIHBvaW50cyB0byBhIDJNIHJlZ2lvbiB0aGF0IHBhbXRfcGFn
ZXMgY292ZXJzLiBXZSBkb24ndCBoYXZlDQo+IHN0cnVjdCBwYWdlIHRoYXQgcmVwcmVzZW50cyBp
dC4gUGFzc2luZyA0ayBzdHJ1Y3QgcGFnZSB3b3VsZCBiZQ0KPiBtaXNsZWFkaW5nIElNTy4iDQo+
IA0KPiBTaG91bGQgd2UgdXBkYXRlIHRkaF9tZW1fcGFnZV9hdWcoKSBhY2NvcmRpbmdseSB0byB1
c2UgaHBhPw0KPiBPciB1c2Ugc3RydWN0IGZvbGlvIGluc3RlYWQ/DQo+IA0KPiBbKl0gaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzNjb2Fxa2NmcDd4dHB2aDJ4NGtwaDU1cWxvcHVwa25tN2Rt
enFveDZmYWt6YWVkaGVtQGEyb3lzYnZic2hwbS8NCg0KVGhlIG9yaWdpbmFsIHNlYW1jYWxsIHdy
YXBwZXIgcGF0Y2hlcyB1c2VkICJ1NjQgaHBhIiwgZXRjIGV2ZXJ5d2hlcmUuIFRoZQ0KZmVlZGJh
Y2sgd2FzIHRoYXQgaXQgd2FzIHRvbyBlcnJvciBwcm9uZSB0byBub3QgaGF2ZSB0eXBlcy4gV2Ug
bG9va2VkIGF0IHVzaW5nDQprdm0gdHlwZXMgKGhwYV90LCBldGMpLCBidXQgdGhlIHR5cGUgY2hl
Y2tpbmcgd2FzIHN0aWxsIGp1c3Qgc3VyZmFjZSBsZXZlbCBbMF0uDQoNClNvIHRoZSBnb2FsIGlz
IHRvIHJlZHVjZSBlcnJvcnMgYW5kIGltcHJvdmUgY29kZSByZWFkYWJpbGl0eS4gV2UgY2FuIGNv
bnNpZGVyDQpicmVha2luZyBzeW1tZXRyeSBpZiBpdCBpcyBiZXR0ZXIgdGhhdCB3YXkuIEluIHRo
aXMgY2FzZSB0aG91Z2gsIHdoeSBub3QgdXNlDQpzdHJ1Y3QgZm9saW8/DQoNClswXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vMzBkMGNlZjUtODJkNS00MzI1LWIxNDktMGU5OTgzM2I4Nzg1
QGludGVsLmNvbS8NCg==

