Return-Path: <kvm+bounces-68301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF78D30240
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C07FF3004636
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C462F36827B;
	Fri, 16 Jan 2026 11:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jdZwvOV1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC8536922F;
	Fri, 16 Jan 2026 11:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768561834; cv=fail; b=sOEK0O/JuhXFZFO/YN2hVbzhxQzCNWIAnVJ3hGlepa+i+6YA/g+O9dJK/kur8YvbF77QFmSZEO+4HE7sBjLhtIpto6zefEHKWQ2/bys3WVnOxKrftPQoLQ+FcEhImdzxTVW6aTwB5JqLb1e4mbGmOE2auO9IkG8C+jOwiiqf/CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768561834; c=relaxed/simple;
	bh=rOcGxmam+TdX85eGLtfrkC5QRKt+GOJExLVkVdFmxwE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EuEQ1+6G/wJZxn9UC/dOE2F4huNZCFY/wGzc508eW9d4Q6/1lWGoaWBNsfKbpqTU6UfdVqVxmYqSHdytSJNRbSO59d9NoP8vuh/qHwjUEiUL2+cNrAb63Ukyg/G+gHwnEo+/pn/Y16aH1tUK+MNU3MkOCl81EuVyYKCh3/VUaVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jdZwvOV1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768561823; x=1800097823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rOcGxmam+TdX85eGLtfrkC5QRKt+GOJExLVkVdFmxwE=;
  b=jdZwvOV1sI6obiflHIPqw7CfLy6N/IcRA/G9WMy4rOjqFzMmqiUxSdxa
   MNPI+ywRcsJkGJ81mYDeL1BbpUSNWBNeuWewPf/WHECZYKL5TQRyhHDAp
   L55f/9QEk4+KRsJGgVuJopvKJWQDm0I7ZoHqHb/2GWq1p//ORMzWqBosd
   dVEKoN6kMCZlyKgdaodRaX30Xi/sZwF8ApUqU7WsK5CMPbjHPpbr44G9r
   Pw495qvInA4aWAawRxPhVbdgXrJrTHCGFHPV5Ph00e8cLpIHWyr0i1Ne8
   CVv+OlOz0obcOQ1HFIIp2IIUveX1Bs1L1NC1FXatWnhk36Lfm++tOGjk5
   g==;
X-CSE-ConnectionGUID: Vhkld8zXQj2Wdo6BTOGZ6w==
X-CSE-MsgGUID: /vUuZCoySs2ud/TfTs1BnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930341"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930341"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:10:16 -0800
X-CSE-ConnectionGUID: 6jTMJcKfQEiRwwALPmS4xw==
X-CSE-MsgGUID: lTcLLD8GRZq0OUhtgNteEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="228236742"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:10:15 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:10:14 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 03:10:14 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 03:10:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PPo1joz4HM7ONTEpgKl9a20D53aN9oaq/79eFmVndGVRSEvNY5wJqKleEMa49vv+e0lUKQnVdNMCZYCmbPs3bYcSfTX2vwRH2xfiUVzJwU2/Wxu42BpU0uRLVb6PyVU8UrkkSsJDyGCE7jfCc8+u0GVTnxt9h2wLHsEdCG+o1nskyREmG3XneHTGaxCXUF9yj7SDAK6nmRlGFKo8b/ADN+fsDNkxKaPaWfPazqk8S0HIXvckXh6I3QeqKOyfHOQVDQBdriXu5ZYFUHgi5NZIyipIrqgzLkbQdZWyYKsvu7uIo9FZ+06O8Dq3SybgBYI11xkTEwQ4utZpp3BeP7llKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOcGxmam+TdX85eGLtfrkC5QRKt+GOJExLVkVdFmxwE=;
 b=kLwWaU9GBlTk7M6aIpE52SxFbxufpE9DD7Y1xx3QOgn+McgNzRAMXSVNgZpEGQ1++y7DQTZHaYCv1NPBTkKHAaGADAqmdJUnDGyc5oVFq2RdbNQ0+OWF7eEeTitHcFVjXn7aoQduz4GeIuTjqS7alTSrQCFNrXKgsIUIHq+zEzVluiPpmGvsS34zODjhU8yrOEV2R7t6G721DamWokW6kRCvIKHzZHMUS5bmEbUYQQezBF9bhZlK9kr+f/yqNRWEurPuvfNnlo0ttTFtMKEmxD2Om4XcqVHwnxDbHNHwruIEVDy0LBvD7r7uN9GImlP5LqYjOndtiJvtP8hJsIO3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 11:10:06 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Fri, 16 Jan 2026
 11:10:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sagis@google.com" <sagis@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHcfvYqSBTaRjpSZEO/4jcRgCnGbrVUCRMAgAB/DoCAACtDgA==
Date: Fri, 16 Jan 2026 11:10:05 +0000
Message-ID: <baf6df2cc63d8e897455168c1bf07180fc9c1db8.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106101849.24889-1-yan.y.zhao@intel.com>
	 <ec1085b898566cc45311342ff7020904e5d19b2f.camel@intel.com>
	 <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
In-Reply-To: <aWn4P2zx1u+27ZPp@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB4981:EE_
x-ms-office365-filtering-correlation-id: 95a475f5-173a-4747-8c20-08de54efcd96
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZVdKb2xRZjdFaEdEZU5PYjBhLzhpWDJkb2xJNFhGc01pTU80RFZhSG5FYWV5?=
 =?utf-8?B?Tk1qM1hsY0w2S3dmMzhMY2E1SjdGWEQ2Z2s2dW1KOHcvQzdjT0JFRmpGbzR3?=
 =?utf-8?B?aVpieEhEWHVWOGZtQTRJdE92UXZTcDNad3NXN1hrQWJsSW1RSXplVWNLMHEv?=
 =?utf-8?B?cTdtNzQ0MEx0U3NwdlRPQ25hMkpLK0dBMWltT01lM0Y4enZBaHlDaDZkSHlm?=
 =?utf-8?B?U0VkaTAxZHBJTlhOcFRxSis1RmJvUWxiNmFTU1BQUys3Skd0eTd5S2hPZ21n?=
 =?utf-8?B?bVVHdDFNVU1vQ0t1QklsVjdPQUJ6UHdwYm5iVWNZM21uV0pUcTluVEIzdnMr?=
 =?utf-8?B?eGh0K2Q0Sk11ZUxOZ0wrT3ZhTjVmN3JJdlhZR0hDUGlGQnRjU25IMHV2MHRD?=
 =?utf-8?B?RlU0K2o5bHhsYkNDRDYyeG5NamZ5WTRqczE3WnVuanRkZzJRSDFqRHR1ZGEx?=
 =?utf-8?B?QlB0SjRCaGhuL0k2THp0RWc0Z2M4emtQWk91ekJjcnhzd2w2ZVg5UFVaek5q?=
 =?utf-8?B?eTFPT3ZFNDFNVnl3akNXUU1sVitaYU82OE5rSHFYRW93aFFxY25DZmRSUDEy?=
 =?utf-8?B?VjE3YVVUMmF5b0hLdDNqSUpKeHorTHZ5Z3Y0a0VYd2Zja01VQ3lkUVp2aUFu?=
 =?utf-8?B?ZEUrV2tsM1dEYnh3WTJLc0lHaU1aTUh0eVZLYnNWTk5jenY4cTFMNzNSZFIy?=
 =?utf-8?B?dGtJaEFWSXRLUHU3ejMxeGZkQmhDaGlGU0NqU01XQzgzZlNJdzZreU40MWpu?=
 =?utf-8?B?bk4yQkhkTGloS2gwRW9KcnhTZ0h1K1haemdrcnU0US94c0ltcVRzMFBoanJI?=
 =?utf-8?B?eExiS01BdDZQUGdQWDh4cXVXOWJ5eE5GTzlUbjBQeXBUV0NyR0llWGxOZUVC?=
 =?utf-8?B?Rks1aEczbGY1c3p5eGRBRjhVdUhPaCsvSFRzZjlIaEFpRTRhS0RWaEljUW5N?=
 =?utf-8?B?SkprSUhOT0dCR0lNNnZjOUIydE83NDJPU0JtNkl5S3Eva1VIbWI3SlRWMHA1?=
 =?utf-8?B?S2VRNGlYekhwUURwL0I4Tk0yK2tydU1sTUZvZ0VFNjhLV2l4eTFzYnZQbzlZ?=
 =?utf-8?B?NTM3eXp4K0t0b3hDZ2tGdWJmM2pESE52RUlUOW5QR1l2SnFoMWRKNU5BSGJz?=
 =?utf-8?B?RHhMM0dtN2FadzMzenIwajR2VWRBazBJWXFzNmNuYTcyc3daYzNMMXJYeFdT?=
 =?utf-8?B?R3VRL0pNbXcvRC9UNU9Ib1V3MnBjMWNWSXduV0RIM3BSVEpBMUhhd0NPNlBt?=
 =?utf-8?B?SUtnQVJqaklIL05MaC9pMzlTYW5naS9qdy9sWGdNZGEvaEU4WEJaTmNBamZF?=
 =?utf-8?B?alI2SCsyamVBVE5xUUFoeWdNL3BOcjlSTDF2UjFUMkhtNHoyeGhzVno5TTBP?=
 =?utf-8?B?S2lrbUlmZ1Bqbzg3VUpDaG5wNmRrOWh0WmQ2S1RGNlJMSytlWmxNYzhOTldD?=
 =?utf-8?B?UnVsUDgwSkZZbngybU9FNURTU05CT1Vxa3Iycm9ySkZQUlR4SVZXSVNIV0Zu?=
 =?utf-8?B?NzhzM3k1a0haejlvR1l2am5xSlkxWTFNcnpWRXlaRmZRdy8ydW5Fb3MzUFFG?=
 =?utf-8?B?SWN3U3RBaGR0K2VJR3RGTGhLdHZpYWJVL1lCeWs0RW1ud04zT29ySldzcVkr?=
 =?utf-8?B?NFdkMmc2b0RLUmZkOGdTL3c0OWF1VFR6MTd5b2UzaFIrL0xFMDlHdXNkR2h6?=
 =?utf-8?B?NmJ5TmRaWkNEeVlQYWh0Uk4xM1hOK3FrUG93SGVoNDE0azVhR2YwUnQ1M1ZX?=
 =?utf-8?B?UWdVazZTbGM2YkZsSUV0WEFEWVNIWUo1bk1QTGk0OXVWMVZ4RFJReldhNlY5?=
 =?utf-8?B?bWhwOUNqbUhoUkJyc0RoemdHYVBrMmxOY0ZLOEhlWE9XUGd6ckN2ZHBmYlVE?=
 =?utf-8?B?ZHFtWG9GblU5bThIQmhKbmlrUXoxT1RmRGRuYU9meWZ3NFBraEdhdnljUGVK?=
 =?utf-8?B?Q2MxUzJQL0dnbTRrVUh3dGQ1WUw2YkZvc2tDYmFoWHlNencyMjdMZ0x3eGR5?=
 =?utf-8?B?Nzg3VDlnc0F6eHpWcWpJV1Yyb2FweHpTSXdGM3hWME13TGpOUy8zRmxST1Zr?=
 =?utf-8?B?cmgrTk52OFY4STdIenhGWW5UNFdMTW5IMEhhSWkydCtQV0lGbUExQ0kwSG9N?=
 =?utf-8?B?VEhUc29DWGw5dCtLWnI4S0VsTUVJQit6YS9IUnp4U3VxV3A0TEFGNU1JK3la?=
 =?utf-8?Q?ZzIi2O9pvTyB+YoFeX88fX8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWV0cTYxZWtJMVJVSzl0TWdwZjNBOE1udTlncXphN3d5b20zOGZ5L3JTNmJV?=
 =?utf-8?B?b21iNkVvSnNTTzhkeGZlSnMwS0xsT0tiNjhxYUhHc3Nxbm5jeGpyb2J5OERr?=
 =?utf-8?B?VnU0WmFNL0NKRjVQbFk3RXpZYi9NV3FvVE82b1lOL3h1RXk4QkRRV0t3QkJC?=
 =?utf-8?B?S0I3c1E1SFhZbytuOEFHSzNhcUx2Q0JlRE1zVng0TnVEbk5CS3hNNm12Z05n?=
 =?utf-8?B?L0FIeXhmdkxTNlp2cVhra1RzREtXUUZ6YzBYcE9VOUlxemg2bm1CTUM1RmV4?=
 =?utf-8?B?TVJnSHdrM0VzVDFrN2dKaFBrdkxRcTViMUVVamJ1OXI1YjJYQmV4QkduN1Zz?=
 =?utf-8?B?QzBhQXRnbG5YMWJpaG5lZHJ2aHYyNXF5QVJzbUFTdzM1RWRmYURxYjlCcEFn?=
 =?utf-8?B?cDZLZEhCL21CQ3BhTnNTZ1lSZ0RMbUhVdFhweSsyaVlibCtQMHV1VERobWZk?=
 =?utf-8?B?MTBWZm96cDhISitFQUQwb1dpZ1NmaWQ2SlNoRzdlNFBjWnhyT2lTVDNBS0My?=
 =?utf-8?B?eFdYNURSdWZYU2hkcGQvSmhBek9zMU5nVGplT0xhYnp2clhKODFaSEx2UHc2?=
 =?utf-8?B?Q2RDdzlybnhJT1BpYmhNRG9NbEJOblgycVZvRHI4TXp6elQ2cEFyejFXRk90?=
 =?utf-8?B?YWhCN2syVVVISWZjUmZKQ2o3K21UNGZ5UXJITVFaQ3M0SnBmK1RlOVYyQjBz?=
 =?utf-8?B?Um8rK09IV0dpSjN6NjBxblowRitmZzZaQis5ajJIT1VhaklMT0MzTUpPTWtU?=
 =?utf-8?B?NjloTHJOSkZsbXdYN3NPMWFRSXhCMGJiYjNFVGdyRWtoSVV3OTRzWldTbHZi?=
 =?utf-8?B?cTU5eHpCSjU1VU9JL0VuYjV1UW0vZHN0VmQ0TDd4MEZDSDZXNkcyNUhIQUxJ?=
 =?utf-8?B?WFQyWkY3SUZ5SWlwZ0lWRmJrOTdPR0ZYUnhKWFVOOXFvN0VoeXU0M0d4ay9s?=
 =?utf-8?B?b2tSMVhBNCtsOWZlRGc3SENpYWxWYm5CakxnN3dnck42NVRIMEJla3h5a1l6?=
 =?utf-8?B?NTNhRGpja1dUVEQzSklmRkVYNGtmSVpSMmJjQUNEVnhLUDZjVzFYR1oxTmsw?=
 =?utf-8?B?UHM0WkEzdTA3VmppanFvVjhGVXlLWVp6UVFySnVuSWw0bGJMVG40OXN3dThJ?=
 =?utf-8?B?dllPb3NFSmprNWFhR3g3WEN3Qit4VlFvcXBHUEdaMm51SGpZdU41SmF3UytO?=
 =?utf-8?B?ZjNwa2trZWVGcGZ4ZTBaVHY1c0U5ZXdHNDRMMFBxeHU3TFBseElNaFkzSHMv?=
 =?utf-8?B?QzE2SFlaL2xUemVZaFJieDM1RnNndkZGUlVZTVFGc3Q0bm03a0tHUHV0VGlL?=
 =?utf-8?B?ZHhrU0ducGZNeUszK05QdU01bzN3UEFET2M4eVcwYlo1WmhESUQwL2U4OEZR?=
 =?utf-8?B?Y1AwMTg0TzhHU1pLcjdEbDUxM2s2M3lsYk50ZVRzTWo2YTcvTHN1b0hPTHJJ?=
 =?utf-8?B?bzRlL0dRTFF3S0lYZFhCTU9BK2tyRi9TYlB5emo0aE1XcXZ6MEZXL3hjdWp1?=
 =?utf-8?B?aVVFZUhwM2F6czE1dDVHcTZ0UktJUEMvd2diV29LUzFqbjFjclVxeWttSWR1?=
 =?utf-8?B?b3N6NGpXYktJMVJWN0drMU01am1BU0tjNENQZFlsMVQxVEQ4MWFtL0R2Y0ht?=
 =?utf-8?B?R2ZXWHNaY25MVEpRUHc4WVMxeWw4UlUxdi93VFl1V0FLd3ZLbE8zUWt4WWpn?=
 =?utf-8?B?WU93ODlQVTJMUFpIY1ZUYU1pekhFY1hpNXIxL1dUNHBEMEwvVTBTR1JFY0Iw?=
 =?utf-8?B?U0Z1ZnRLLzcyTXF4aEZWN1hKS3BIelc2MHpkYStMUHVvQnoyQk1DbW5Jd2Mr?=
 =?utf-8?B?c3FpNEI1UzZJdk5GUmVZT2tnb1hlYW9lSUFMaFkzVmtOQUQvWFduLzhrUXJs?=
 =?utf-8?B?bmxISUcyUlpUSFE2bU5tL1RPUE0vQTdPYUFDNDVkMVlFYkJXdEV2WlppVkhT?=
 =?utf-8?B?eFdLV2Uyc0c4L2NUeGY5K1EraFlhcXJXRStNU0g0RCtwRmNVS2w3UTAvTWhz?=
 =?utf-8?B?TkhSZ1hnbmV4Y2RlY3lCV201K09FZmtadnZibVRFa3JyekttNC83TnZDeVAz?=
 =?utf-8?B?VzZ0MGNSM3paeVIybFZzRXdBZms2UFIrZzBWVDEyQVlhOUdIU3o5SVlXZk94?=
 =?utf-8?B?WTZBVFdPZWkwQ3NqSjM3YzFocm5aL3Y2N21zSncvVTBXSFhIczU2N1ZSSHg2?=
 =?utf-8?B?OW1kLzlNT0ZDTkxZMVlzOWxQdDdGVGdCRUdLZHZZUU1wNkZQUjlkMnRyN3Qx?=
 =?utf-8?B?VUJUdHF4aU9jRjROMHhNaitvbXplK1QxTllTT1Q4QXlLWmZ1YnVJL00wcDdP?=
 =?utf-8?B?c05ZNG5TYzlSZ0l4THBaWSt1WFd4MkMwa3VZNkJic1p4TkRvTWpJZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C26B68829546B74B86922E280682C9FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a475f5-173a-4747-8c20-08de54efcd96
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 11:10:05.5791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m4AzYFIXuUL9u325MDiRWe6+Lbj9zH+iEAafYazhjH/un1iyg2yuKy+BKytprwwShEZQKPSGLhLiW1k0KY6fXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDE2OjM1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSGkg
S2FpLA0KPiBUaGFua3MgZm9yIHJldmlld2luZyENCj4gDQo+IE9uIEZyaSwgSmFuIDE2LCAyMDI2
IGF0IDA5OjAwOjI5QU0gKzA4MDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gDQo+ID4gPiANCj4g
PiA+IEVuYWJsZSB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCkgb25seSBvbiBURFggbW9kdWxlcyB0aGF0
IHN1cHBvcnQgZmVhdHVyZQ0KPiA+ID4gVERYX0ZFQVRVUkVTMC5FTkhBTkNFX0RFTU9URV9JTlRF
UlJVUFRJQklMSVRZLCB3aGljaCBkb2VzIG5vdCByZXR1cm4gZXJyb3INCj4gPiA+IFREWF9JTlRF
UlJVUFRFRF9SRVNUQVJUQUJMRSBvbiBiYXNpYyBURFggKGkuZS4sIHdpdGhvdXQgVEQgcGFydGl0
aW9uKSBbMl0uDQo+ID4gPiANCj4gPiA+IFRoaXMgaXMgYmVjYXVzZSBlcnJvciBURFhfSU5URVJS
VVBURURfUkVTVEFSVEFCTEUgaXMgZGlmZmljdWx0IHRvIGhhbmRsZS4NCj4gPiA+IFRoZSBURFgg
bW9kdWxlIHByb3ZpZGVzIG5vIGd1YXJhbnRlZWQgbWF4aW11bSByZXRyeSBjb3VudCB0byBlbnN1
cmUgZm9yd2FyZA0KPiA+ID4gcHJvZ3Jlc3Mgb2YgdGhlIGRlbW90aW9uLiBJbnRlcnJ1cHQgc3Rv
cm1zIGNvdWxkIHRoZW4gcmVzdWx0IGluIGEgRG9TIGlmDQo+ID4gPiBob3N0IHNpbXBseSByZXRy
aWVzIGVuZGxlc3NseSBmb3IgVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRBQkxFLiBEaXNhYmxpbmcN
Cj4gPiA+IGludGVycnVwdHMgYmVmb3JlIGludm9raW5nIHRoZSBTRUFNQ0FMTCBhbHNvIGRvZXNu
J3Qgd29yayBiZWNhdXNlIE5NSXMgY2FuDQo+ID4gPiBhbHNvIHRyaWdnZXIgVERYX0lOVEVSUlVQ
VEVEX1JFU1RBUlRBQkxFLiBUaGVyZWZvcmUsIHRoZSB0cmFkZW9mZiBmb3IgYmFzaWMNCj4gPiA+
IFREWCBpcyB0byBkaXNhYmxlIHRoZSBURFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUgZXJyb3Ig
Z2l2ZW4gdGhlDQo+ID4gPiByZWFzb25hYmxlIGV4ZWN1dGlvbiB0aW1lIGZvciBkZW1vdGlvbi4g
WzFdDQo+ID4gPiANCj4gPiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gdjM6DQo+ID4gPiAtIFVz
ZSBhIHZhciBuYW1lIHRoYXQgY2xlYXJseSB0ZWxsIHRoYXQgdGhlIHBhZ2UgaXMgdXNlZCBhcyBh
IHBhZ2UgdGFibGUNCj4gPiA+ICAgcGFnZS4gKEJpbmJpbikuDQo+ID4gPiAtIENoZWNrIGlmIFRE
WCBtb2R1bGUgc3VwcG9ydHMgZmVhdHVyZSBFTkhBTkNFX0RFTU9URV9JTlRFUlJVUFRJQklMSVRZ
Lg0KPiA+ID4gICAoS2FpKS4NCj4gPiA+IA0KPiA+IFsuLi5dDQo+ID4gDQo+ID4gPiArdTY0IHRk
aF9tZW1fcGFnZV9kZW1vdGUoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIGludCBsZXZlbCwg
c3RydWN0IHBhZ2UgKm5ld19zZXB0X3BhZ2UsDQo+ID4gPiArCQkJdTY0ICpleHRfZXJyMSwgdTY0
ICpleHRfZXJyMikNCj4gPiA+ICt7DQo+ID4gPiArCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJn
cyA9IHsNCj4gPiA+ICsJCS5yY3ggPSBncGEgfCBsZXZlbCwNCj4gPiA+ICsJCS5yZHggPSB0ZHhf
dGRyX3BhKHRkKSwNCj4gPiA+ICsJCS5yOCA9IHBhZ2VfdG9fcGh5cyhuZXdfc2VwdF9wYWdlKSwN
Cj4gPiA+ICsJfTsNCj4gPiA+ICsJdTY0IHJldDsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCF0ZHhf
c3VwcG9ydHNfZGVtb3RlX25vaW50ZXJydXB0KCZ0ZHhfc3lzaW5mbykpDQo+ID4gPiArCQlyZXR1
cm4gVERYX1NXX0VSUk9SOw0KPiA+ID4gDQo+ID4gDQo+ID4gRm9yIHRoZSByZWNvcmQsIHdoaWxl
IEkgcmVwbGllZCBteSBzdWdnZXN0aW9uIFsqXSB0byB0aGlzIHBhdGNoIGluIHYyLCBpdA0KPiA+
IHdhcyBiYXNpY2FsbHkgYmVjYXVzZSB0aGUgZGlzY3Vzc2lvbiB3YXMgYWxyZWFkeSBpbiB0aGF0
IHBhdGNoIC0tIEkgZGlkbid0DQo+ID4gbWVhbiB0byBkbyB0aGlzIGNoZWNrIGluc2lkZSB0ZGhf
bWVtX3BhZ2VfZGVtb3RlKCksIGJ1dCBkbyB0aGlzIGNoZWNrIGluDQo+ID4gS1ZNIHBhZ2UgZmF1
bHQgcGF0Y2ggYW5kIHJldHVybiA0SyBhcyBtYXhpbXVtIG1hcHBpbmcgbGV2ZWwuDQo+ID4gDQo+
ID4gVGhlIHByZWNpc2Ugd29yZHMgd2VyZToNCj4gPiANCj4gPiAgIFNvIGlmIHRoZSBkZWNpc2lv
biBpcyB0byBub3QgdXNlIDJNIHBhZ2Ugd2hlbiBUREhfTUVNX1BBR0VfREVNT1RFIGNhbiANCj4g
PiAgIHJldHVybiBURFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUsIG1heWJlIHdlIGNhbiBqdXN0
IGNoZWNrIHRoaXMgDQo+ID4gICBlbnVtZXJhdGlvbiBpbiBmYXVsdCBoYW5kbGVyIGFuZCBhbHdh
eXMgbWFrZSBtYXBwaW5nIGxldmVsIGFzIDRLPw0KPiBSaWdodC4gSSBmb2xsb3dlZCBpdCBpbiB0
aGUgbGFzdCBwYXRjaCAocGF0Y2ggMjQpLg0KPiANCj4gPiBMb29raW5nIGF0IHRoaXMgc2VyaWVz
LCB0aGlzIGlzIGV2ZW50dWFsbHkgZG9uZSBpbiB5b3VyIGxhc3QgcGF0Y2guICBCdXQgSQ0KPiA+
IGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgd2hhdCdzIHRoZSBhZGRpdGlvbmFsIHZhbHVlIG9mIGRv
aW5nIHN1Y2ggY2hlY2sgYW5kDQo+ID4gcmV0dXJuIFREWF9TV19FUlJPUiBpbiB0aGlzIFNFQU1D
QUxMIHdyYXBwZXIuDQo+ID4gDQo+ID4gQ3VycmVudGx5IGluIHRoaXMgc2VyaWVzLCBpdCBkb2Vz
bid0IG1hdHRlciB3aGV0aGVyIHRoaXMgd3JhcHBlciByZXR1cm5zDQo+ID4gVERYX1NXX0VSUk9S
IG9yIHRoZSByZWFsIFREWF9JTlRFUlJVUFRFRF9SRVNUQVJUQUJMRSAtLSBLVk0gdGVybWluYXRl
cyB0aGUNCj4gPiBURCBhbnl3YXkgKHNlZSB5b3VyIHBhdGNoIDgpIGJlY2F1c2UgdGhpcyBpcyB1
bmV4cGVjdGVkIGFzIGNoZWNrZWQgaW4geW91cg0KPiA+IGxhc3QgcGF0Y2guDQo+ID4gDQo+ID4g
SU1ITyB3ZSBzaG91bGQgZ2V0IHJpZCBvZiB0aGlzIGNoZWNrIGluIHRoaXMgbG93IGxldmVsIHdy
YXBwZXIuDQo+IFlvdSBhcmUgcmlnaHQsIHRoZSB3cmFwcGVyIHNob3VsZG4ndCBoaXQgdGhpcyBl
cnJvciBhZnRlciB0aGUgbGFzdCBwYXRjaC4NCj4gDQo+IEhvd2V2ZXIsIEkgZm91bmQgaXQncyBi
ZXR0ZXIgdG8gaW50cm9kdWNlIHRoZSBmZWF0dXJlIGJpdA0KPiBURFhfRkVBVFVSRVMwX0VOSEFO
Q0VfREVNT1RFX0lOVEVSUlVQVElCSUxJVFkgYW5kIHRoZSBoZWxwZXINCj4gdGR4X3N1cHBvcnRz
X2RlbW90ZV9ub2ludGVycnVwdCgpIHRvZ2V0aGVyIHdpdGggdGhlIGRlbW90ZSBTRUFNQ0FMTCB3
cmFwcGVyLg0KPiBUaGlzIHdheSwgcGVvcGxlIGNhbiB1bmRlcnN0YW5kIGhvdyB0aGUgVERYX0lO
VEVSUlVQVEVEX1JFU1RBUlRBQkxFIGVycm9yIGlzDQo+IGhhbmRsZWQgZm9yIHRoaXMgU0VBTUNB
TEwuwqANCj4gDQoNClNvIHRoZSAiaGFuZGxpbmciIGhlcmUgaXMgYmFzaWNhbGx5IG1ha2luZyBE
RU1PVEUgU0VBTUNBTEwgdW5hdmFpbGFibGUNCndoZW4gREVNT1RFIGlzIGludGVycnVwdGlibGUg
YXQgbG93IFNFQU1DQUxMIHdyYXBwZXIgbGV2ZWwuDQoNCkkgZ3Vlc3MgeW91IGNhbiBhcmd1ZSB0
aGlzIGhhcyBzb21lIHZhbHVlIHNpbmNlIGl0IHRlbGxzIHVzZXJzICJkb24ndCBldmVuDQp0cnkg
dG8gY2FsbCBtZSB3aGVuIEkgYW0gaW50ZXJydXB0aWJsZSBiZWNhdXNlIEkgYW0gbm90IGF2YWls
YWJsZSIuIMKgDQoNCkhvd2V2ZXIsIElNSE8gdGhpcyBhbHNvIGltcGxpZXMgdGhlIGJlbmVmaXQg
aXMgbW9zdGx5IGZvciB0aGUgY2FzZSB3aGVyZQ0KdGhlIHVzZXIgd2FudHMgdG8gdXNlIHRoaXMg
d3JhcHBlciB0byB0ZWxsIHdoZXRoZXIgREVNT1RFIGlzIGF2YWlsYWJsZS4gDQpFLmcuLA0KDQoJ
ZXJyID0gdGRoX21lbV9wYWdlX2RlbW90ZSguLi4pOw0KCWlmIChlcnIgPT0gVERYX1NXX0VSUk9S
KQ0KCQllbmFibGVfdGR4X2h1Z2VwYWdlID0gZmFsc2U7DQoNCkJ1dCBpbiB0aGlzIHNlcmllcyB5
b3UgYXJlIHVzaW5nIHRkeF9zdXBwb3J0c19kZW1vdGVfbm9pbnRlcnJ1cHQoKSBmb3INCnRoaXMg
cHVycG9zZSwgd2hpY2ggaXMgYmV0dGVyIElNSE8uDQoNClNvIG1heWJlIHRoZXJlJ3MgYSAqdGhl
b3JldGljYWwqIHZhbHVlIHRvIGhhdmUgdGhlIGNoZWNrIGhlcmUsIGJ1dCBJIGRvbid0DQpzZWUg
YW55ICpyZWFsKiB2YWx1ZS4NCg0KQnV0IEkgZG9uJ3QgaGF2ZSBzdHJvbmcgb3BpbmlvbiBlaXRo
ZXIgLS0gSSBndWVzcyBJIGp1c3QgZG9uJ3QgbGlrZSBtYWtpbmcNCnRoZXNlIGxvdyBsZXZlbCBT
RUFNQ0FMTCB3cmFwcGVycyBtb3JlIGNvbXBsaWNhdGVkIHRoYW4gd2hhdCB0aGUgU0VBTUNBTEwN
CmRvZXMgLS0gYW5kIGl0J3MgdXAgdG8geW91IHRvIGRlY2lkZS4gOi0pDQoNCj4gDQo+IFdoYXQg
ZG8geW91IHRoaW5rIGFib3V0IGNoYW5naW5nIGl0IHRvIGEgV0FSTl9PTl9PTkNFKCk/IGkuZS4s
DQo+IFdBUk5fT05fT05DRSghdGR4X3N1cHBvcnRzX2RlbW90ZV9ub2ludGVycnVwdCgmdGR4X3N5
c2luZm8pKTsNCg0KV2hhdCdzIHlvdXIgaW50ZW50aW9uPw0KDQpXL28gdGhlIFdBUk4oKSwgdGhl
IGNhbGxlciBfY2FuXyBjYWxsIHRoaXMgd3JhcHBlciAoaS5lLiwgbm90IGEga2VybmVsDQpidWcp
IGJ1dCBpdCBhbHdheXMgZ2V0IGEgU1ctZGVmaW5lZCBlcnJvci4gIEFnYWluLCBtYXliZSBpdCBo
YXMgdmFsdWUgZm9yDQp0aGUgY2FzZSB3aGVyZSB0aGUgY2FsbGVyIHdhbnRzIHRvIHVzZSB0aGlz
IHRvIHRlbGwgd2hldGhlciBERU1PVEUgaXMNCmF2YWlsYWJsZS4NCg0KV2l0aCB0aGUgV0FSTigp
LCBpdCdzIGEga2VybmVsIGJ1ZyB0byBjYWxsIHRoZSB3cmFwcGVyLCBhbmQgdGhlIGNhbGxlcg0K
bmVlZHMgdG8gdXNlIG90aGVyIHdheSAoaS5lLiwgdGR4X3N1cHBvcnRzX2RlbW90ZV9ub2ludGVy
cnVwdCgpKSB0byB0ZWxsDQp3aGV0aGVyIERFTU9URSBpcyBhdmFpbGFibGUuDQoNClNvIGlmIHlv
dSB3YW50IHRoZSBjaGVjaywgcHJvYmFibHkgV0FSTigpIGlzIGEgYmV0dGVyIGlkZWEgc2luY2Ug
SSBzdXBwb3NlDQp3ZSBhbHdheXMgd2FudCB1c2VycyB0byB1c2UgdGR4X3N1cHBvcnRzX2RlbW90
ZV9ub2ludGVycnVwdCgpIHRvIGtub3cNCndoZXRoZXIgREVNT1RFIGNhbiBiZSBkb25lLCBhbmQg
dGhlIFdBUk4oKSBpcyBqdXN0IHRvIGNhdGNoIGJ1Zy4NCg==

