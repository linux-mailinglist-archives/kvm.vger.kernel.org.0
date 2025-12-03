Return-Path: <kvm+bounces-65240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8634CA181C
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04B713013386
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE882F5A10;
	Wed,  3 Dec 2025 19:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gBGPl057"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43938264A97;
	Wed,  3 Dec 2025 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764791998; cv=fail; b=TgA+Msi+5kLlxu/+Kq5RV6FMbJfRzQOVhR4/J3ZkC2T7sinv04kgK1sx46u0AiVaOUvkszGkwNB1GvgZyC7a82RSy3MtiKlhCiql+6pIomzoX2llTu6PETCIOsyK1z2XSGjQ+mxUwAyjLetYxvQghO2XD9rc2JLNUlDXq264LQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764791998; c=relaxed/simple;
	bh=lN/rGKf6S6xqWZxKReVpdncsuNvPOTaA8DkiXy+0Xio=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ReuNX54NPGcPF+R63zmOHDSejwzaXQXtsSciVcSzRE+KCc/bkg7e1d6v2FcO9EAxkKWoy4zIXPp1PUFYix0dNsVSJ087u+jxbzRPP+VboQkyqnjuP46zOYoUmZ+0SOjjTY8w/ytAFOi7umY8tDQzc3Zw//9wlAJ1cm3z35Qqn48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gBGPl057; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764791996; x=1796327996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lN/rGKf6S6xqWZxKReVpdncsuNvPOTaA8DkiXy+0Xio=;
  b=gBGPl057p7nP9tzGLGbu1VcbgXVPyh7bnf05NH0SE6Lfm2mMfdWJKa04
   LQ2qd1LufeiX/YvS+4g+t61fU1FeoEe5nlPV7W1g8TuqilMfXdtSIpJOD
   JqBMXYRKsycXnxdoQCHnwIvshTkeQOyZpUB3Lxa0C6fHZKjaXOHzNu5c6
   dUYwDV/veHh8INfTviKkGv9lZD40GuCzFhw9TGItOMWGe0wddru+fk1ZP
   Jl/porUQUgG8y/xxBaepUmQTMWg8KsUaSG/lJ1K7Fr4vwcPVdFKKQBzCe
   yZroCIFTWCfUV79QV9O6/6svMs0xNvbZezdJs52QB73F/iZqQlASNTP4/
   Q==;
X-CSE-ConnectionGUID: 9ALE7lIMSI27uyOKfpwEvw==
X-CSE-MsgGUID: YKE7YQ4HQ2C9aBglhUzWPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="78151684"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="78151684"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 11:59:56 -0800
X-CSE-ConnectionGUID: 7nv3BzDVR9iEfMd0PvXl0A==
X-CSE-MsgGUID: xKa63BJPRPSZjG6duGTZkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="193857152"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 11:59:55 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 11:59:54 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 11:59:54 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 11:59:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQsI7kjjWodHPdv8jyAR5KoaJRx+auR/dJE4xTH0OaYS4MWiemI7NZTVGbdzlPQoLkn52xhddJlPXcsMS3cSIAGBOrtf3tTENlKU0e5CDejNkY+xysYe1tJ8/WjGp93vjJbKWNxrGCAUWUGUJMV+PccUHOGBpVrVGeGUZ14q2PFkuN3qT+i1kThmoYX3ELcFehXt/IfbuAQ8YVbOnctBOWXOWJwgVROOhCxw2aHn4ngOTwlPmCHEviNFsNmxdy0kxroFwy4XQzvq5XL/Ml06HWXqyv2Rw31mzX4L5niuPf3HdhRXCN5S9leurW5bK3JLGa4Pi4zy6DRgtfIrsFdzfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN/rGKf6S6xqWZxKReVpdncsuNvPOTaA8DkiXy+0Xio=;
 b=b4RjWY6JMIRV3zRhkNdh8zk7aR+U42DqDWGhJfogx3FjToEkM13oG/eRM0Fm1TB3ZiJ7ZTcYKbCnBo37d8QiAUBt13j9xUxcQvCtzn80Z1ZJnJMmHVhSi4+YGgqa/OUXugm8ps92Ea1RZp3RgCf6oG8T0sZ0cMiX83Y6GZafMNGwqo8Pejj6FNLdz8Im01+lwnLudL5Iu56+thjY7b5V/xh2z/ka8/JvPzL/L0SuDuLi92iG/905AJZskmit9fggHqfX6YOqlrW2hS48x8NyNn0ecv8O4aghAekXdLitnbiCZWExhQu3WgoavBZHeXNFmvGsPWHWFSoU/dbFMefoGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF63A6024A9.namprd11.prod.outlook.com (2603:10b6:f:fc00::f27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 19:59:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 19:59:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "kas@kernel.org" <kas@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UGu/sAgAa1nwCAAJayAIAAz+YAgAEpIICAAADQgIAAH1uAgAArEgCAAAHBgIAAG3CA
Date: Wed, 3 Dec 2025 19:59:50 +0000
Message-ID: <8bd4850b0c74fbed531232a4a69603882a5562a1.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
	 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
	 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
	 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
	 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
	 <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
	 <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
	 <bb174006cbe969fc71fe71a3e12003ab9052213c.camel@intel.com>
	 <474f5ace-e237-4c01-b0bc-d3e68ecc937b@intel.com>
In-Reply-To: <474f5ace-e237-4c01-b0bc-d3e68ecc937b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF63A6024A9:EE_
x-ms-office365-filtering-correlation-id: 41c474e4-b829-4d82-19ba-08de32a684a4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ckdUbjBqRGJ5ZDFjVFJxcURkUGFXWFdWbk1OenMrRE5hNWtLTURyY3IxSU1v?=
 =?utf-8?B?SnZYRU9nVllnUXlGUnVIVnlrNXg5Q3p1QUFuSXlMWlQ2K2NLcmxRelNLc3By?=
 =?utf-8?B?M1pZR2I5dWhPYTFYYlRBcWZWcTFTeHl4alZsczFGRG8rTEVTOVZ3aGc3ZDNH?=
 =?utf-8?B?dHNlYzRBakFUeUo4S1Rxc1NIelNQRlhiYXlvSUxpNnlxVkl0YWlrYmlwS3lk?=
 =?utf-8?B?Q1dtU0VVbW9yUWQwSWhLYklibXNGakJheHpSQ0JCbGZ4UkpCOTBoZCtuYjhD?=
 =?utf-8?B?anhiTytDanZyRDJTaW5CSHNmYzJFRDh4UXIzQ3ZwSTVtb3p4dmd1aEtra1RR?=
 =?utf-8?B?RmRpS3Q5L2Ruc0R3UjFzdCtPVEJVaFhPYlhUZ1VpTUJDOGdBdVpJd3Jtamkr?=
 =?utf-8?B?NDVicURub2phRWFXUVp2Mjd3b3RYNEF0MGtmNlc0dXEwcityMzBGOS9ydlRH?=
 =?utf-8?B?aEgzSEFxc3E2UTFDcDBkUTBiNUVVcC9CWndrV2pYcFJNQUdtNStZVmo5VDkx?=
 =?utf-8?B?SWFMMmdNcVhON2JLZnlrQ0pCN0FXZWlHdGpXeUhkc0pKTFBiSGttVUtBWTRF?=
 =?utf-8?B?d1NQdmRFNlRoU3QvNTZhWS91WFNiUlBlSkRBa25RZ1hFZVlGVmlObDIwNGN0?=
 =?utf-8?B?Sk1IRFRocjAxdk44Y0VTYVN1RGJBOGJhQlF4S21JbUZ1UXNuV3RINlFNWGRF?=
 =?utf-8?B?OXBEYXR6QnVsZG9MaWk1aTI2ZFFEMitzUUNHTTI5RFVyNTFXYm1ZeTRiWTVu?=
 =?utf-8?B?SCs1bEpQT1U2emFBejlQYk5CMm1aU0cwbUcyKzZPbjN4b3YwRWJubDE5NUFq?=
 =?utf-8?B?V3JRWmpYSVV3dUdkQ3J3MmJBSzRvS2xTZ2wvZFpyWThKTDU4NWxWZXE5Vk1O?=
 =?utf-8?B?eGlSa0NWV242Q1llVVhqYlpPTmc4UnYvRkhCZUJXZ3N1MlM4bnh1dElvbC9k?=
 =?utf-8?B?YjJZTElDM3pUdTVuaEpCbnRiQWRUVzlXY2FTWmFsNllONiswTjdoMTNIMTAz?=
 =?utf-8?B?N3g3Tm1tdFdZSlpkVWlZMkxLZzZleWkyYWZpZzhWTUwzMG1wOHZGN21nY1Bh?=
 =?utf-8?B?NEJOdTloOWg5SnUyOVhuTTRQY0poMmlmenNubUdFVi9NcnNnYTZleHovKzF6?=
 =?utf-8?B?UG5JWmQ0K3YzSmtsUWF1UkZDL3IrREtSOXVDSUM3ckNPUFluUUloT3BPa2ta?=
 =?utf-8?B?WGZaQWV6RU1seENXSG00L05MTytXRVQzRFNJSCt5TjJsM0xna0E5L3dPSW1j?=
 =?utf-8?B?VktHZ20wZ3RjOG5hM05FcTlPM2dyUitoV05aUGxoYytpTUttZ0tjNFZVYWZt?=
 =?utf-8?B?aWdOUDRtSFlzVnFoRFBjWjVaYTh6VmRLOU1BWkRONGtYY0lDUVBaVzJScWpo?=
 =?utf-8?B?VTM3SzErVlRaU3hMNHN6bTZsMWwwRW5KZm1UTTNpUkZoV1A0TUZxUUVzbWhO?=
 =?utf-8?B?WlJJK3FSK2tEcEIrR2pxZlFCZzkvL3gyNk11MEJOQ2tML1VFYjVkcEZYVlNT?=
 =?utf-8?B?dSsrS1FvbVBmeitmUWEvblVLMjJSQlBxL1R4YmVPb2M1aGd6YURHY0dDdVlX?=
 =?utf-8?B?TXZiZjdTejZSblNUd0t6a1hTN0ZDMzVNenB6ZFRtdTVPL1RnQjlSd3pzQmdZ?=
 =?utf-8?B?dXF3YjdOVEwvZGZ6WTc3MkRrdlN6dUdVUFB1VWduUkgvWi9Hdk9wdzJCNGhs?=
 =?utf-8?B?RzlyUXVmWlFvVjJwbVNVa3NKV3YwWVlQMllQcnlmMWorbGpzVFFzbTBjVCtx?=
 =?utf-8?B?UTFKaDdaSEtxTUNFL3IyMGY4Yko4V1h4WDFHNHUzV29NcG9kWCt3MVpvT0xV?=
 =?utf-8?B?UnA0UVIrSWxGS055VXNzMGw3cGVWTlZkNjZiK3Z2ZEVoME5zZTNCWkkzbjU5?=
 =?utf-8?B?alJIZERkTmgzdnZRY1RCcE05aW9pdDhaL0YxbDVWU013QjcxSlFhdGxxbU16?=
 =?utf-8?B?MGt6YUpqem5uOFYrakxXRGw2R0w1NGtyYlFTQUhKV2ZpbTdlaFFPZm5XSjFU?=
 =?utf-8?B?R01EeWlBcXd3OGxXZTRHUG1rYUorTzZIYWlXS3RsQnl0MWgrdmdHbC9Ua1N2?=
 =?utf-8?Q?891cbE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkpOOTczelJPZGJYbEwyTnVjOGZLUURPQ0JDcFdnM0J1SlBJZkJCNXdzNFYz?=
 =?utf-8?B?bGZsYTgzNFdKNzdtOUFvbDlaZ3RiZU1WU25xU1B6Z3BaVkphbXNNSXlZcllC?=
 =?utf-8?B?eXdDaEovQjNraVhLWi8wT2tWNXdXSmtMR1JXd0h0QWpraS9VSzZMZ2drUlpS?=
 =?utf-8?B?RXZ3Mm1hKytiZWhydWZ6ZlZHQ0t0eDJPWnJLTWdxbU4zelFrRSt4cU1EaVBh?=
 =?utf-8?B?Uk9rVC9nZy82enZmR0Nxc1dacy82WXA0cVRjd3p6TkxnTVpWUFVUMmNqcnhI?=
 =?utf-8?B?NjlPVHNpd1E0QUhmdXZEWVpWR1lzejJENnY1UGJvTHhwTjM4cFE2RUpiUDlQ?=
 =?utf-8?B?UHlodWVQV3ZlK2tMQVFhbWt0WUZ6YkFLdmlxTzV1eVFpZXB3VXdRZjYwRjVj?=
 =?utf-8?B?NnNQdHI0R3lnWjZlckxpYUVrWmdKZHdkMi93YkpnWmhTSXFlY0hDWHJ5MDZE?=
 =?utf-8?B?QVoweGRHaEU5UFdWeDQ4NkkzRVZHd0RBbVFRbXBHMitCK25NTmdxOENBUGYv?=
 =?utf-8?B?bDhZV1RwRmhDbUd5Sy9OdkR0T1A0bmh4REdUNnhFbE9QMklxRFBYd3FuNlU5?=
 =?utf-8?B?bzh0L09JODBVdVhIci9ieEtxQm1YOVJrZDdZNjVvclB4Z0FLeEpYaDdqSzJj?=
 =?utf-8?B?ZlBBc25YK2J1NFR6ZXZmTCtVVEJCTytLay83eXVvN3RjWkw3aklUK1FNQzRq?=
 =?utf-8?B?UEovakVOeG5DYTlaM0pJRVE5UE5oNUpwdTZMMWZpTjVpYzhaeGdwOXdKVC84?=
 =?utf-8?B?ampGR2JOQ2loNFZNQkpwMmlzTVRkc2tOZUJ0eXRpUHJCeGk5bEtiMEt6TXl6?=
 =?utf-8?B?TnRnVlN1NXdpcXFMUSswMzZ2T2ZDOUNCdElTWkRlRW1CQko1U3NwZUUrYUU5?=
 =?utf-8?B?TUQyRnlSRmJWMHZSYXBXdHhCMTRtVHNFYlFWZUd4VjBJaHFEUUR4K0o0RGNN?=
 =?utf-8?B?WnBxS2QrbzFVMHFZRlhNanhBRGFLSGlrNU5HWWhJeXZXdnluNVM0N1pKdUox?=
 =?utf-8?B?eW9BOUpKak5BazRwQ3U1bWxvU1hCa3dHRGgrN3pMa3dmN2V0RzZiMlhsVGhm?=
 =?utf-8?B?VEh4R2VqS05QKzZyL3pWa2tlT05ZNXRzNjNqdHUvTmhIcFBSUGJvaWtrWnMx?=
 =?utf-8?B?ZVg0VFg3dWVZdFp1aWdMcUs2d09vNUZhZ01YS3ZDRVp1QXlhL0JPTUsvbkNC?=
 =?utf-8?B?THVtMGk1dTFUY3JJdEU1ZTFFWFhNWCtlMmhJV1RHRWEwaXl1S1Iwa0FuR1hx?=
 =?utf-8?B?Mkd6Q0xsOXgxb0J1bkI0T0pRWEgzOXRzZ2ZJV05NYVJLUVdCVEp2cHNHNE81?=
 =?utf-8?B?akt3OS9HS3QxdHVMQlkzNDBjK0VvTDdyZHV2UStSb1FGdmhPMkFNczZoeFN4?=
 =?utf-8?B?REN2WmJEN2J6bytjZlhRVDFZc0U0QkVMY2hhdkVaVXhzSXlDQ0grbkVmc3ho?=
 =?utf-8?B?RDBEaFZTVTlldnk1UUZyS2ZPT2NqenZIRndKZDk3UUtQZ3hiN015MXVIVllC?=
 =?utf-8?B?TStvQWNoK1ZsZHBsekp5ZFErNnhGUmxsMWJWZFc4ZWpwdHpOSnVDeVN1amZC?=
 =?utf-8?B?bGlidGpqQWJraXNNUG12TDdsWlZVdERUTFZ5aWgzUW9XOXNKeEM3c3JXRzFG?=
 =?utf-8?B?VE1qU2FtaGJ5eTBvSDFOKzBxMFc1SG9nb3lUR2lIU1JEMTFSUXRaRjFuekJ0?=
 =?utf-8?B?OGdTeHRGVzhpQkNVS1lwUGJjNWxiUUV3SEpHb0pqdTlaM2RTelQ2dmhYN3lG?=
 =?utf-8?B?Q082YzNURWhOUGtudnJlZVdhZlB6ei9FYTczNDZEMWFabXoyd0NMZmZkZm9j?=
 =?utf-8?B?dUVocXNnTUNwdll3aGY4U2JlUmRuRE1pQjJyUjQ5c1kvSUdUNmh0cjliT2tt?=
 =?utf-8?B?dWUzSllNWmxkcVBrTzZLMGQ4YnZnOTdFUnNCb055YXJQcDA1RURlcFVOS3lx?=
 =?utf-8?B?OEZ3WllrenNTNVhTTkppdE1laXR5ZXZac0g2eWpvZkxIejhTRWNOY2VUeUN4?=
 =?utf-8?B?dlVNODlCcnIybitFa2J2b1V0RUIydjJ6MXRlWnRVV1lxOWl0SVIxVEk0Y1dt?=
 =?utf-8?B?YnQ0bU4wbG0rOFZ3bGg3RWo1cjRsNUxJTlBFZG5KRjJqV2lHZkpLeENXWkVi?=
 =?utf-8?B?SWl6cTFYcHR6YlgxNVdFN3pxSXQ5UndhcGlOZXppZUZaUGtUeXQwNUhBQzhX?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE9E4F46EE15FC4BA59C450CAEDFD6D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c474e4-b829-4d82-19ba-08de32a684a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 19:59:50.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZeorDxzIio/ngWWOn+easLeDQ32X+MpGllV/Ae2j9Pot4q31r52iTfCagYFwUe7jnbiIaIRPrw3mNgrtp6aSEC5EraQ+mgxyWB7mbgZTWW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF63A6024A9
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEyLTAzIGF0IDEwOjIxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiBUaGFua3MgRGF2ZS4gWWVzLCBsZXQncyBzdGljayB0byB0aGUgc3BlYy4gSSdtIGdvaW5nIHRv
IHRyeSB0byBwdWxsIHRoZQ0KPiA+IGxvb3BzDQo+ID4gb3V0IHRvbyBiZWNhdXNlIHdlIGNhbiBn
ZXQgcmlkIG9mIHRoZSB1bmlvbiBhcnJheSB0aGluZyB0b28uDQo+IA0KPiBBbHNvLCBJIGhvbmVz
dGx5IGRvbid0IHNlZSB0aGUgcHJvYmxlbSB3aXRoIGp1c3QgYWxsb2NhdGluZyBhbiBvcmRlci0x
DQo+IHBhZ2UgZm9yIHRoaXMuIFllYWgsIHRoZSBURFggbW9kdWxlcyBkb2Vzbid0IG5lZWQgcGh5
c2ljYWxseSBjb250aWd1b3VzDQo+IHBhZ2VzLCBidXQgaXQncyBlYXNpZXIgZm9yIF91c18gdG8g
bHVnIHRoZW0gYXJvdW5kIGlmIHRoZXkgYXJlDQo+IHBoeXNpY2FsbHkgY29udGlndW91cy4NCg0K
V2UgaGF2ZSB0d28gc3BpbiBsb2NrcyB0byBjb250ZW5kIHdpdGggZm9yIHRoZXNlIGFsbG9jYXRp
b25zLiBPbmUgaXMgdGhlIGdsb2JhbA0Kc3BpbiBsb2NrIG9uIHRoZSBhcmNoL3g4NiBzaWRlLiBJ
biB0aGlzIGNhc2UsIHRoZSB0aGUgcGFnZXMgZG9uJ3QgaGF2ZSB0byBiZQ0KcGFzc2VkIGZhciwg
bGlrZToNCg0KdGR4X3BhbXRfZ2V0KHNvbWVfcGFnZSwgTlVMTCkNCglwYWdlMSA9IGFsbG9jKCkN
CglwYWdlMiA9IGFsbG9jKCkNCg0KCXNjb3BlZF9ndWFyZChzcGlubG9jaywgJnBhbXRfbG9jaykg
ew0KCQl0ZGhfcGh5bWVtX3BhbXRfYWRkKC4uLCBwYWdlMSwgcGFnZTIpDQoJCQkvKiBQYWNrIGlu
dG8gc3RydWN0ICovDQoJCQlzZWFtY2FsbCgpDQoJfQ0KDQpJIHRoaW5rIGl0J3Mgbm90IHRvbyBi
YWQ/DQoNClRoZW4gdGhlcmUgaXMgdGhlIEtWTSBNTVUgc3BpbiBsb2NrIGR1cmluZyB0aGUgZmF1
bHQgcGF0aC4gVGhpcyBsb2NrIGhhcHBlbnMgd2F5DQp1cCB0aGUgY2FsbCBjaGFpbi4gSXQgZ29l
cyBzb21ldGhpbmcgbGlrZToNCg0KdG9wdXBfdGR4X3BhZ2VzX2NhY2hlKCkgLyogQWRkIG9yZGVy
LTAgcGFnZXMgZm9yIFMtRVBUIHBhZ2UgdGFibGVzIGFuZCBkcGFtdCAqLyANCg0Kc3Bpbl9sb2Nr
KCkNCg0KLi4uIG1hbnkgY2FsbHMgLi4uDQogICAgICAgIG9yZGVyXzBfc19lcHRfcGFnZSB0YWJs
ZSA9IGFsbG9jX2Zyb21fb3JkZXJfMF9jYWNoZSgpOw0KDQogICAgICAgIHRkeF9zZXB0X2xpbmtf
cHJpdmF0ZV9zcHQob3JkZXJfMF9zX2VwdF9wYWdlKQ0KICAgICAgICAgICAgICAgIHRkeF9wYW10
X2dldChvcmRlcl8wX3NfZXB0X3BhZ2UsIG9yZGVyXzBfY2FjaGUpDQogICAgICAgICAgICAgICAg
ICAgICAgICAvKiBhbGxvYyB0d28gcGFnZXMgZnJvbSBvcmRlcl8wX2NhY2hlIGZvciBkcGFtdCAq
Lw0KDQogICAgICAgIHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoZ3Vlc3RfcGFnZSkNCiAgICAg
ICAgICAgICAgICB0ZHhfcGFtdF9nZXQoZ3Vlc3RfcGFnZSwgb3JkZXJfMF9jYWNoZSkNCiAgICAg
ICAgICAgICAgICAgICAgICAgIC8qIGFsbG9jIHR3byBwYWdlcyBmcm9tIG9yZGVyXzBfY2FjaGUg
Zm9yIGRwYW10Ki8NCg0Kc3Bpbl91bmxvY2soKQ0KDQoNClNvIGlmIHdlIGRlY2lkZSB0byBwYXNz
IGEgc2luZ2xlIG9yZGVyLTEgcGFnZSBpbnRvIHRkeF9wYW10X2dldCgpIGluc3RlYWQgb2YNCm9y
ZGVyXzBfY2FjaGUsIHdlIGNhbiBzdG9wIHBhc3NpbmcgdGhlIGNhY2hlIGJldHdlZW4gS1ZNIGFu
ZCBhcmNoL3g4NiwgYnV0IHdlDQp0aGVuIG5lZWQgdHdvIGNhY2hlJ3MgaW5zdGVhZCBvZiBvbmUu
IE9uZSBmb3Igb3JkZXItMCBTLUVQVCBwYWdlIHRhYmxlcyBhbmQgb25lDQpmb3Igb3JkZXItMSBE
UEFNVCBwYWdlIHBhaXJzLg0KDQpBbHNvLCBpZiB3ZSBoYXZlIHRvIGFsbG9jYXRlIHRoZSBvcmRl
ci0xIHBhZ2UgaW4gZWFjaCBjYWxsZXIsIGl0IHNpbXBsaWZpZXMgdGhlDQphcmNoL3g4NiBjb2Rl
LCBidXQgZHVwbGljYXRlcyB0aGUgYWxsb2NhdGlvbiBpbiB0aGUgS1ZNIGNhbGxlcnMgKG9ubHkg
MiB0b2RheQ0KdGhvdWdoKS4NCg0KU28gSSdtIHN1c3BpY2lvdXMgaXQncyBub3QgZ29pbmcgdG8g
YmUgYSBiaWcgd2luLCBidXQgSSdsbCBnaXZlIGl0IGEgdHJ5Lg0KDQo+IA0KPiBQbHVzLCBpZiB5
b3UgcGVybWFuZW50bHkgYWxsb2NhdGUgMiBvcmRlci0wIHBhZ2VzLCB5b3UgYXJlIF9wcm9iYWJs
eV8NCj4gZ29pbmcgdG8gcGVybWFuZW50bHkgZGVzdHJveSAyIHBvdGVudGlhbCBmdXR1cmUgMk1C
IHBhZ2VzLiBUaGUgb3JkZXItMQ0KPiBhbGxvY2F0aW9uIHdpbGwgb25seSBkZXN0cm95IDEuDQoN
CkRvZXNuJ3QgdGhlIGJ1ZGR5IGFsbG9jYXRvciB0cnkgdG8gYXZvaWQgc3BsaXR0aW5nIGxhcmdl
ciBibG9ja3M/IEkgZ3Vlc3MgeW91DQptZWFuIGluIHRoZSB3b3JzdCBjYXNlLCBidXQgdGhlIERQ
QU1UIHNob3VsZCBhbHNvIG5vdCBiZSBhbGxvY2F0ZWQgZm9yZXZlcg0KZWl0aGVyLiBTbyBJIHRo
aW5rIGl0J3Mgb25seSBhdCB0aGUgaW50ZXJzZWN0aW9uIG9mIHR3byB3b3JzdCBjYXNlcz8gV29y
dGggaXQ/DQoNCg0K

