Return-Path: <kvm+bounces-58108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD04EB87997
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:29:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731FB7E08F3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A0522069A;
	Fri, 19 Sep 2025 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MiOxtf4H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6921FF26;
	Fri, 19 Sep 2025 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245385; cv=fail; b=iybs7E/Xa8KBaPyaltrZScoMWVOYTdA+Ju5t0828viC3LvKz6/BB0LOQYbSxQnD/b3mPofak8eQIykvoGXdKD+NxOGs8tQiOKr9FJqm60iuaPSHGd/FPauJfAE0A2Tti0A3ii2j/ibKOUgeNvJzVEZ9MH09VXrmbdQT7/9gnuBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245385; c=relaxed/simple;
	bh=0A+1kv9UwNyzPvcc75b/iePgeoGxDYzQxIynyLIZ7aI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DlEzKDE/ZKBwQVDiC/WG0FFm16j/o0XAR9dtlWwOmXxEPGPMaUBHdPes3hFI5X7w1PxKBIzlE8MW+DxxI3XMASP8CYyiTru4YkH75UqP9zd0Ed8L7qyK6oUE47l5UqiRItzaYY3joJL0BoRQ+4H72mPn9N6MYEY9yg/pGKO0gv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MiOxtf4H; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758245384; x=1789781384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0A+1kv9UwNyzPvcc75b/iePgeoGxDYzQxIynyLIZ7aI=;
  b=MiOxtf4H+Vww4W1+WPtmiJq1GS5JpIEe9fOwIB1w+WfTXq3w8Jr2HY5r
   lsb4INFuJSPY0W+fnkxJ3i/5aXbbrjptUNycLjHqT2bK67rP0LeHBPi4Y
   J2ir7JT+vfk2pOhlJIe0ipbkywcx+iuKlZ1Kw1Bn2fr0w92VOYG1GBFEi
   5Z/7vD9Raudr/xXkWIdj9QVAqWuIAoej+SwB6qJcUGd4Gjb242L2niLrD
   qkb++Trht+hXq76Yfd1X09Zpm0dNyTp8ZfRFkLjwQBxcileWrxUpJhaki
   AyUF9mspjzkOokrlDx0aK7uzhdP8T7TAYqvREPYpHVaASIj/4G+7Sbk/e
   w==;
X-CSE-ConnectionGUID: b/AQenkgQ16ymyFf8edhDQ==
X-CSE-MsgGUID: wcc2J66+QUisxKgOehEVWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="59630171"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="59630171"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 18:29:44 -0700
X-CSE-ConnectionGUID: DpwqCzESSdup0W9JT3J3/w==
X-CSE-MsgGUID: FDw6ubGFSG6v3MGSeTttZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="175764861"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 18:29:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 18:29:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 18:29:43 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 18:29:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2SuOV7c+NJwhDCmi/LXcUA5geno3dn/OwyVekVGnYWlu61z6gm1/QgRbssj2PNCzj0qqa4zW8BRgOTlXYDvSy+Skg01CtL3GTUC1BhDzO6mJoKNc7R7gIH2r5n25rsYjgg1I2vmhwCq7+zlKT2gv3koJrSsbZrXtObkP/S1hJSyrV2czfHCuYqg2EzmZcJjdZhYrybukATWqo6/3gdWfmSpaCYojMO8Jnb7udkM0LBtP2hMGPAdH4FN0uOf8lZQBSelxFXGNKNmmCOk69n5wAReVyg34kyJ+9rczJwccEuSj43HozDuTLIy5BaxihUqUtea6gn+o7MvFHPTWAi94Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0A+1kv9UwNyzPvcc75b/iePgeoGxDYzQxIynyLIZ7aI=;
 b=BhbUBb7E8A6hnKuMAFteX11tfarugPkhIUKA2veTqF3EbycwfaxjKfl0Q3SszvInTbIfhvkQ1bGrJEWH5T6gVzUQxXFA2QMYdD+8BZPxcO3qM0LfjO3UGZnfFbNNXpvipt3+VnoyAxwRsa7E1eRgC5wR66wd54ngjEGPJzkfGqEIBIDQATRvI97gJzc9oMACK/iv0WHeDG6WW5/R4nABVIPZmMMmc7iFYwzXyOcBpadV5WNBsR4aBc1N/XFObA4BiRsPrMX3plSUHsAoan3mG+YNfvMIp9hKoMD0XBHcjkhHKzQU8l9eFVBw5GJJKPFIgS5eNfxMaxcIN0b+PXLvKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH8PR11MB9508.namprd11.prod.outlook.com (2603:10b6:610:2bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 19 Sep
 2025 01:29:38 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 01:29:38 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v3 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcKPMxZM5D8fzz+UCC7ed8PEA7hrSZt88A
Date: Fri, 19 Sep 2025 01:29:38 +0000
Message-ID: <56c3ac5d2b691e3c9aaaa9a8e2127d367e1bfd02.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-2-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH8PR11MB9508:EE_
x-ms-office365-filtering-correlation-id: 5e84d095-77fe-4583-e499-08ddf71bffa9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RG5oRm1KZFVsaFFlQTNtVmxSSjhEYUdJeGtPZWcrQXovVFFINEc3NmxhdGo0?=
 =?utf-8?B?NGpta2s2Mms4U25qMGkxTlpiQXI0NlRNSWg0enExMlJCQ0dST0R6ZkxjTmtN?=
 =?utf-8?B?SS9sOUlTci9oN0kwUngwQVA1VmppbTVSZUFnaDRoZ3gveDdJTGdwZTBCZnYr?=
 =?utf-8?B?MlFBeG5rZUVWN2YyWmVqdG0yZFV1Mlcwdy9URy9vN2M2SnBLS3N1UTN1UW5R?=
 =?utf-8?B?NVFDV01LSi9hcDVqSUFwU0xIcVlhY0Q0M2lpZmRWVTJWZUVGYkwxVG1hR20v?=
 =?utf-8?B?L1EzM085cjVDUVdnMWs4TzBGNndEVWRlaEVmQ3llZDRRRVErQlVxYWxUTmZI?=
 =?utf-8?B?U2dDUGxteGlXY2JuK0h0VThVY2hzNnBPenBCZUtrQWlyOHRDVEUyVEpuenRS?=
 =?utf-8?B?Rmg3c3JpNUFGWGlWbGpVdmMvRHF5Q0hheU5OWWwweWk2bXAzaXlvZXJrdlU3?=
 =?utf-8?B?ZzUrb3V3V3IzWGw4djVNQWR3MlJFdWlNNFMwSGdIS0ovcjlFZ0xtdGZtM3pC?=
 =?utf-8?B?SEo0L0ovdlYxeTBYRmN3TVFURytaM0xJZW05L2pGYlI1RXNPajdpOG10YWp2?=
 =?utf-8?B?QkFNQ21Ody9ETENNeGozTmVBQ2xIN2w1aEJ3SUpOTFJqV0VuV2F6Z215aHhG?=
 =?utf-8?B?YjlIZHFyaGpiY0hiQlR6NittVnV4UXlqR0pMc0MrTXFMblNyK2E3NSs3T2l4?=
 =?utf-8?B?OVMxYTAyNVMzbkVsR3hWWCtpOW9aOUcrVzQ4aDh2V1J6bzJjU3hhbURROG5Z?=
 =?utf-8?B?YnZha0dPUC9JM1lMb2dsaUlwQVl0SVRTWW5yUXVHdy9vWkRzUkRBVFdSWjhB?=
 =?utf-8?B?NEI3YVBNaVZQeWJZNGMvYXRYVFptRjRWSFI2bTI0a2I2M2pSNDVwZDg2QmNn?=
 =?utf-8?B?OU1DcVJyOTVsZkdYcU90cDNMVUxWdnk0R1ZyMXFhbk9WeFRDdmpyejMvYUMv?=
 =?utf-8?B?QkNoRm5WM0NqV0RqSHhFSGdqVS90R1dYZnZOVXlCWnE1cWt6OGEyT0VJUDlo?=
 =?utf-8?B?eExHY09NME5Od3ZPNmwydFBlMC9SYXBvcXF3UHhUTDNPd3ZZcmtMbUdjeEpS?=
 =?utf-8?B?c1hiVlJaZ0hvY0cyY0hSNVV2ZDdGbnJMblNJcEhDOGNGdzkxb2N2djMyUFRB?=
 =?utf-8?B?ektlVmU2WW9NTGdqVFNqSzF5djE0dlZWVk5IZWlPTk5GYXVyeGhpQmVNc2hT?=
 =?utf-8?B?d2g1a0d4dWFNajVVMVRkZDhBNTZqVkNldDliMU5KR1l5a3F1cHdQTW03SjhH?=
 =?utf-8?B?N1hTY0U3ODBaSEpFYmgrZ25CM3ZVVEYralhoeFV5OHBlcmE3Ymh6Z3NySkd5?=
 =?utf-8?B?SGIxOWpGRmtpaW42aFlyb3JBQjVaMHBpKzFwc25CeXdaZk1ScUVCWGV3U2NP?=
 =?utf-8?B?Vk9aQ1JGb1ZOMEQwaDZiQm5yWHBjWUsxOWVYTllQOTlwQzR0SGNwQkE1djRN?=
 =?utf-8?B?Um8xSHdSaUpsN1BjMGZZMTBPYXNranFwUkdTNDBRRndMdjc5eUt2V3F5NWgz?=
 =?utf-8?B?QnZoTkV0OFcyMWRBVHRuZEllaXE5WVE0RGd5d0NiY1pvM3dyb2JadHlGWnV5?=
 =?utf-8?B?VHBoSzdNTVpNcWhUWVdmeUVjZENUZXRDSk05dEpRWU9adHNKaStaQy9lRGpM?=
 =?utf-8?B?aEtSTitXVGhiaHIwSjdqVVZ2NWk1TWdBOXJydUVReVhRVjkrQk51VDVzdzRT?=
 =?utf-8?B?amlEVk52NjVXbzEwSDRucExJRVNaR2MwUnV4RWpqeUxrYUx6VDNCZ214bUIw?=
 =?utf-8?B?SUF0ZmxuMWx0SXlFS1Z6SEYrRG5mR1ZHbXhZd2JLZGlFVjBvQWo1MlJ4eDd2?=
 =?utf-8?B?Rk5pLzg1UURKUkdSa0p1SjlNNkUyeDlmcXlGYjhOOFhpTkFybVgya0pMTnhR?=
 =?utf-8?B?ZWwwVkh3czFhY09hVUMzcmJPbW5SQVJBbmNmSTlGTmZmWDh3WTBNYnY3MUl5?=
 =?utf-8?B?MGhhMW5JOVBaZnAwQzluOUxRYklEa1ZqU2JHb1NhcUVqUG1hd0NYRWNXWGQ4?=
 =?utf-8?Q?/i2PzebZJC3BYkvcrp8/XCraCvMoHs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3ovT0J4WHI1cE9haXRwYllxWWVYVGhaZTFPOTdpem02c2NRNVE5NmMrQWw2?=
 =?utf-8?B?VVRvYnMrcm1Hd1Y1czFWZkZrTjV4M0Q3QVJLeHpidEhLdkdMMElzV1JCdTRM?=
 =?utf-8?B?SkhOTmc5SC9hQ2hEVDNBalA0eUEyc2t2VHNUQkNwMmE0MHp3RUpSblh6K21G?=
 =?utf-8?B?Snp0cGNTSkxXT1BzckpwSHJmRzN1MHNuanNucWFaTHJvR0hFOTlXb3l5Rmky?=
 =?utf-8?B?MjlpUGhpY1ovZ0xpcXhNdFVMLzBrYUdyV3paWkk4N295cjdtc3NLaWQ2SUYr?=
 =?utf-8?B?aXR3MVVWVUFRUHB6VFJ0K0RKYWFJS0ZSZmVJREJpaWJla0RJZXRtaS8zWmow?=
 =?utf-8?B?VmhwbzlCbDJObzZyamRJRW4xZUM1cG1MNjVTcW1VbWJkc2NhVlU3LzlLTS96?=
 =?utf-8?B?UlRFK1JRR1dqVG03NEFNTDQzTjZSMk9JeEN6UGdMaWoxSmtkTVJNZnR4ZWFj?=
 =?utf-8?B?ekEwQXdDSkxvejZkYXlrazVKWFJoSTRGS005Zi9pM1l4d0FJcU9YdUVwbWFz?=
 =?utf-8?B?WVA2WlpVVFk5RWxRUE16TkQvL09RU0RKeHNwU1hEdi9vcnE2TnJUM3FabmZn?=
 =?utf-8?B?ZDU3UEQ3K1ZybVVhWDF3ZzNFSU5VcjhSVGd1eGxTdWoydzJ5VUJFVGtDSXdn?=
 =?utf-8?B?MDJqSE9MNkRDRVNzVnhzNWs2aGZNLzArOFFkOHNHZWRFUUwwdGxyMXZDSHNK?=
 =?utf-8?B?cms3czBJV3crdHRDekZJV3MrWTNGQkQ2bVg1Zi81a0hxNGJiUmFRV2l3L3hP?=
 =?utf-8?B?eUdoUUdYRnFmS3lTa3JuSzZlOFVzNVZId0x2K053dDJISStKc3BaK01VUUow?=
 =?utf-8?B?cTRBZGhPZjVrZExadWd3OUkxVDR5elRoUlh1WmsyK29ZMVd4U2swMXhYdWEx?=
 =?utf-8?B?MEdTWCsramVMS1NUenQzcFcxVDcweFIyNTRhczZsYzZ1Rmp3ZG1QQm1icSs4?=
 =?utf-8?B?V3UrcncxcnpYSm1kdy9jbXdndVpxbWtmYXJzTlRRaXlWWmNVTXJvTzUrMHdz?=
 =?utf-8?B?a2FzYXYwU3ZNa0Y4aU0yUFBBRlFkVjJTU0x3b0U0UnhpZDZtVEZzRDNTUWxk?=
 =?utf-8?B?aTZPaGtnd2Y0alkrc0R4eGt2RWIvRzN1YUUySTJ4VEVZa3k2U3pUSm5lMkQr?=
 =?utf-8?B?NlpSZm5BRHRpbVJhZTNZTnR2RkxVOXdqTFhFZUxpRWFNbDBzc3ZZN2FMYnRF?=
 =?utf-8?B?TlUwTzVYeSttWFRQVHZia2FzdkdhT1pQVSsrS0FjakdKVEtVODQySFVnZTJB?=
 =?utf-8?B?TzdQMXFiRVRjQVBmRmVmc2JQYUhieXdDOGxKOTJMZ3JmaWMxQ1hmKzBqcjk0?=
 =?utf-8?B?aHBwdUI3OGwxeDRCM2M3UXp0MGx2cENxQnJhVGQrYnFkbTlaU054NkFuNWxy?=
 =?utf-8?B?UEpZL1lNU0lrWGlWNnlkN1ZjenFDckd0WTJ4ZnlObURMeUE5OUZjdmtjNnMw?=
 =?utf-8?B?TW9KeW1HbE5SV3V5em5VY04vSDZFcTN2MEhsS0VkeGVSOXZCYmc1KzJYMWc2?=
 =?utf-8?B?cDhoR3NFdTh1WTFPOURnSTJZZ1FCV1NmbkttMjJSQ0pKcWwyZXJrOFdFY3pp?=
 =?utf-8?B?LzBjZXZTT3JzdjUwNHY5U3NXSXkrK3VCRi9DcE1BRmZ0WDYvU0cwbVljTGU5?=
 =?utf-8?B?dW9PWWpFSEw2TGtHL2lYcGVveTlZU3VxclRYMDdUN2M5OHNsSnhEM2VDWG95?=
 =?utf-8?B?YUI0VytHOWhoRWFNZFhuVUNHdm9OR0VMN2pkUTNyM1hGWlE5NjVvVG9ZVVZQ?=
 =?utf-8?B?RnhwQXgwdGRGQTVvNDgzRnJlWmVkc28yTHYyMGhNQjI5SzdWRkk3ZXlaK1Bq?=
 =?utf-8?B?SU5Zc2R0djVkNmNyNGtWMHFJKzZNR3NkdURNRVRTZnRQS2hGQWFsU2w0eVVi?=
 =?utf-8?B?b2kvWDFhcmM1TTlSVDFid2JnZEp0OGpGbDhVQS9hS1RqeWNxTU16L2p6U0Zp?=
 =?utf-8?B?TGIzUytIOUtYQ2oyK3Vka0dKRDVuRGpBcThOKzc0STY2Z3F3b2RNenpmN0lI?=
 =?utf-8?B?bEFYRjJiZUZNUFNHV2xsSCtLQUdJcHdGS3NVSk1qVXphdWdEZG5MTXBWcEJ0?=
 =?utf-8?B?RWVqd2s4Y0Y4UzRjK0t1TThsbVhOOXdnK2hvbWUzaldFVGw3b3FTb3VxeE90?=
 =?utf-8?Q?aET+BfqG/ZP9mJDkmdRE7PEsH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1EF154EF738E249BD0750277A0B009C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e84d095-77fe-4583-e499-08ddf71bffa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 01:29:38.1771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fciSVJcwl2hrd4jdreS2BUcp98Pv59jDuxDNAz3sCBkuNy7z2J9SOBkTIn+qe4bOUa8QsAJS6sXRKJLGCSFRMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR11MB9508
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjIyIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gRnJvbTogIktpcmlsbCBBLiBTaHV0ZW1vdiIgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRl
bC5jb20+DQo+IA0KPiBUb2RheSB0aGVyZSBhcmUgdHdvIHNlcGFyYXRlIGxvY2F0aW9ucyB3aGVy
ZSBURFggZXJyb3IgY29kZXMgYXJlIGRlZmluZWQ6DQo+ICAgICAgICAgIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3RkeC5oDQo+ICAgICAgICAgIGFyY2gveDg2L2t2bS92bXgvdGR4LmgNCj4gDQo+IFRo
ZXkgaGF2ZSBzb21lIG92ZXJsYXAgdGhhdCBpcyBhbHJlYWR5IGRlZmluZWQgc2ltaWxhcmx5LiBS
ZWR1Y2UgdGhlDQo+IGR1cGxpY2F0aW9uIGFuZCBwcmVwYXJlIHRvIGludHJvZHVjZSBzb21lIGhl
bHBlcnMgZm9yIHRoZXNlIGVycm9yIGNvZGVzIGluDQo+IHRoZSBjZW50cmFsIHBsYWNlIGJ5IHVu
aWZ5aW5nIHRoZW0uIEpvaW4gdGhlbSBhdDoNCj4gICAgICAgICBhc20vc2hhcmVkL3RkeF9lcnJu
by5oDQo+IC4uLmFuZCB1cGRhdGUgdGhlIGhlYWRlcnMgdGhhdCBjb250YWluZWQgdGhlIGR1cGxp
Y2F0ZWQgZGVmaW5pdGlvbnMgdG8NCj4gaW5jbHVkZSB0aGUgbmV3IHVuaWZpZWQgaGVhZGVyLg0K
DQpUaGUgZXhpc3RpbmcgYXNtL3NoYXJlZC90ZHguaCBpcyB1c2VkIGZvciBzaGFyaW5nIFREWCBj
b2RlIGJldHdlZW4gdGhlDQplYXJseSBjb21wcmVzc2VkIGNvZGUgYW5kIHRoZSBub3JtYWwga2Vy
bmVsIGNvZGUgYWZ0ZXIgdGhhdCwgaS5lLiwgaXQncw0Kbm90IGZvciBzaGFyaW5nIGJldHdlZW4g
VERYIGd1ZXN0IGFuZCBob3N0Lg0KDQpBbnkgcmVhc29uIHRvIHB1dCB0aGUgbmV3IHRkeF9lcnJu
by5oIHVuZGVyIGFzbS9zaGFyZWQvID8NCg==

