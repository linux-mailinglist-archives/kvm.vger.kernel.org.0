Return-Path: <kvm+bounces-16829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A338BE25A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD604B29CEA
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 12:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F222815B153;
	Tue,  7 May 2024 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZqhDaPRU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9937D1509BC;
	Tue,  7 May 2024 12:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715085639; cv=fail; b=ZkIuZemPIHXafQ6/VQ2PBNALgHt9/wyiDHgy3kDuaLmnUYR21UIrTWlPlqZYrjQT9lVQCLF8nSFbRtZOynKoQssEhURX9JAwFV2Yp9B7O2Z7LkU+89pIA7BjA58MCjT/O7hUtUvRx2qloJN5n0Iem9P42+jUK82MVoap4+4p8nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715085639; c=relaxed/simple;
	bh=nEiwyJg2Cj6af9Q3Ds74uIWyQwroZzo4txOc+1af1WI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uzJRmlLz9LwL8USDZGyfQlDP5qL4zdWJZhmis9EnWYzCvR3IiynsRISoz7e7kSkaA04gjXZVn7zj9Skdw9R+Dh4uNk1r9EKAyuZ36lljq4jZ4B/NtW/jpMVPGjD5Fx/J6BEmvUU+RyF5b+dNP+c7qEV7jNicoweZ3w8MF9WoWuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZqhDaPRU; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715085637; x=1746621637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nEiwyJg2Cj6af9Q3Ds74uIWyQwroZzo4txOc+1af1WI=;
  b=ZqhDaPRUOWfBO0BNoQX0nClVlcECT//Fa481FQUkmL5Ig0qhzks7wfNb
   vEMIfWIyol6uIGndpcSYXT/HavzvgbTTe3tFNLBAbX1Ki8RYXjvAyViOb
   SsHHHaZtbF5k2LB9wHgRkrIipbCCTtflEp2U9P874b2h3w12DiSakb8j+
   w5AzUmirAWoLzxExW0Bx0f+Vs87u85KbL4R+m9d4cxV/iiIaiYzl+rUU+
   Xwpi/RxUwqz1oE2wFx046UgWfU6k3xmpOWaGBNzzt5JXT5p3ZRqsG/STu
   641/Qrgx+9L5+IFh00W9kEgFGSze449i4MxmSa225cjX/EerHJ+GqX1ZL
   A==;
X-CSE-ConnectionGUID: u8O3bOYPS4OVQvn09KVduw==
X-CSE-MsgGUID: Tfy91PaLSuOgrF8hhS6tOA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10727194"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="10727194"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 05:40:37 -0700
X-CSE-ConnectionGUID: S3GzRBOvTiC2z6YFO7Z/+Q==
X-CSE-MsgGUID: LFcikaAQSUK5lRarQkL5PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="33317096"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 05:40:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 05:40:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 05:40:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 05:40:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4r/76iUEz1dD6CzNMeSCXyroOOaTF0zWJJ8/n0VVw2SshWiToQ110uxkac8ocmizbxgstQSha/nfoxFuvcfLDDLnzpTsVSMV2C9Udy2J9hJ7us0iHzkFezEdNNS9wh1KX3WdTL9aUrCN6JWYEG6GOONOG0HtlAPcfWwidh7hUKYX6nBRhqx6cWzsRGHIGwn0pQTkOzw3NvLuGIe7upSBqa17bA4ciEV13evjwUGUdvXSqPD0YvbvnAem63zPPKR0PTaDuaG34e1IBhhKpCPKN5kZ0rwe04oLIS2Si/sFqg1buWiEaedUVGXj1j/+2Tvbda0TZp9Pqv7MkTRaUNUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nEiwyJg2Cj6af9Q3Ds74uIWyQwroZzo4txOc+1af1WI=;
 b=Jd85H7LioExLWzAUcUGLePrbBH+Gel70ZFo9jmgQqUL7uFY79CHWD087qj1Wwv3uk9tCcqxZ79mN2ZZrzloN56IdCh8n1JM+uNAecE+F4bKfOjTfkzDv5wsaeJP2j+yxyctGfT8D0WSnFUdvumHHAoNVp/pNTeEyshNPyBYECb5g8kNLD18FNpu1FicQ04qLPMBS+1Yv18aapRZ9Mjhm44Ew7dP2kiie8ruE/iTHDV2WBfvYAz7gg6EDaJQ/Du1x1zIbOa0dk8ESvsmhjWdVKD0p41GGlCFU9usOC3xrrs62Ce+JqeW9eQAWLfj4qqLCdnZ7iIThzHVUHQc6/+dHEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 12:40:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 12:40:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgBv6ywA=
Date: Tue, 7 May 2024 12:40:33 +0000
Message-ID: <0ddb198c9a8ae72519c3f7847089d84a8de4821f.camel@intel.com>
References: <Zhftbqo-0lW-uGGg@google.com>
	 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
	 <Zh7KrSwJXu-odQpN@google.com>
	 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
	 <Zh_exbWc90khzmYm@google.com>
	 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
	 <ZiBc13qU6P3OBn7w@google.com>
	 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
In-Reply-To: <ZiKoqMk-wZKdiar9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB8289:EE_
x-ms-office365-filtering-correlation-id: c57e08a2-e928-4b00-4ea9-08dc6e92e316
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WWhva2NacmtpalhtTkg0M3FoMklUenZGa0pOUHZ5cit5R1dxUXJBRWhWV2hQ?=
 =?utf-8?B?ZkxOK29JRDVobWxsSkVBZUVBcFRreFNPZFMzNTVxL3Q3QVVHeHF2K3d0dzRH?=
 =?utf-8?B?TXlVNVFkaEdsWUd0VWhXUzQ5SnhyR0pGNW04VUV0dEhPZDdFYkExMk9BVEMv?=
 =?utf-8?B?RGNvRk5nRGxjSHd5dG1qUE0yTVFmQkdkSUIwRi8vMmJXS1EvTjAyMFhza21Q?=
 =?utf-8?B?eDhxeFNwQ0dWNVprRFNRK1Bna21aL3EyZGo1ZjltREtmN1d0UEZiTVVYQnU4?=
 =?utf-8?B?TXVJNDBHV213QmZiS1U5YnJ2SUovTlQxRmV5cG1Sa0I5S1pqNUpBS3MrWlpF?=
 =?utf-8?B?d3JFNnovN21qUlRJS3UvMWp3RXQwem8ybEpFNkNqZWU3ek9Xdm5WRmd0NGxy?=
 =?utf-8?B?VFRyd1ptUlBkckxxWUxMMFZ2dGtaRU0zMHVEV2gvbVUyeGd3S2E2cWVDNUtt?=
 =?utf-8?B?TExNa1JLa3Ura0FsbFFHNDZXNkE5MFlLVFFINjQxWll6S0o2eHZ4Y0lIWTdy?=
 =?utf-8?B?R3hCTUpMQWMwU1ZkWTNTYU54c05sTys5S29ITHJzMGRVRWhhVkN5QThZOGR2?=
 =?utf-8?B?R2hPMUJlaVRSTDdSUlJMOGhkd1BjR0kzMk8rVVI3WWZlODI2SEd5dDVzZGk0?=
 =?utf-8?B?S3FXUTBPcGRKZUowRFp1bTVTNFU3TUY4Qm8ybmk4aFpxdGdjRmJpcGQ0cTVS?=
 =?utf-8?B?dmdTc29ZUmZRbW9UZHdiNFVRaGp3aFg4R2k2YTh1cjRCcVAyTVVMNU9Wb3Yv?=
 =?utf-8?B?MXdZZGpiK08rZTRQaVRacnlHM3Fwb0hyNWZYb0tWNXZzc3JhUVNReTNZaGVs?=
 =?utf-8?B?UTlza0ppZU0zRFRoaWw0eUNBWXdvRzVoN0dhSVRDcWw1ZmtlRFMwaGx1UDRI?=
 =?utf-8?B?amg4SXJKVnlPMm9jWHE5b21FZnJzYkVDVXNsb3crQVp5UHJ0cTlBTVk4ZUJR?=
 =?utf-8?B?N3duMmNHbHJjWXQwc3REci9NcEpmMWVFKzEwVkpmR3Q5eU0yMjduNGJZb0pS?=
 =?utf-8?B?VXVTMkFHakdaMk82aDYwNWlXL25oVk4zUWk4Ty9kNmExeHZVdjFMVTZWZ2Ra?=
 =?utf-8?B?OGFUVnpXQVhXVlhMMU80VXhrS1RucGRxUlk2V0c1VWxUWGtXblBXWUtqSnRK?=
 =?utf-8?B?eUgzamNxMEpma2x5YkdIMnF2OGxLVmJaTEFuU0FSL2pwMzNmMmt6eDBvcStU?=
 =?utf-8?B?M1o1blNHOU1OdmpPZTFpOXRXdm1xeG1KRHVRRWx3NnVKRW5VMjBrTXVKajdq?=
 =?utf-8?B?ZUZDd280cndPKzZDeGF0bjFpeEV0bXR0dStncmJDbWVoWThIYmdlOVlaMnJo?=
 =?utf-8?B?K0dubmhkL1JnTUgzcmM4eGJSVHd6N012dm1wYjJsSCt4UDZhYkdBYTYvMEdC?=
 =?utf-8?B?VUhSRTFHOVJiQ3MzemtrKzhsWE02Rjk3eExnUU9XdDVqZDVOTkg5akNnczE1?=
 =?utf-8?B?blk4M201U1BrbFBFTVhqSW1lTUI4enBRY1dIV3daa1NGeDFWd1hoNGNSSkN1?=
 =?utf-8?B?SjBBdm4xQkVYVEluejB2emc3SWdGQisvVjEvRmNsdWlwcWhpRUhYa1d1TFpH?=
 =?utf-8?B?NHliVXFiL0haNUx1U2xxcm5CcmNQUlExYVZnWlhjTXYycXF1bXhmWmpWTUJt?=
 =?utf-8?B?QWdyQjZCR2N5b0dYQlh1RlhHNk55QXNwUUZjb1pQc21NZjN3T3FiRmRMbzBI?=
 =?utf-8?B?bHgyTTNZT2xxdU1UZjFYMXNHMTVQNXlHdmJISnFsNjM4bGRKdWpqTHlFUUx5?=
 =?utf-8?B?VkhscjlOYTBuanVLRzhrZ0pXM3BsdWxsdG9qelBiRHp6VUdrWnovbUlwa0Y4?=
 =?utf-8?B?T21UWlZyTTllNm1yamMwZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlVQMER1T25lVGlvSm1Za2N0dEhZWWhqeDlZUkJ3d2ppcStBVGhhS2l0UGhs?=
 =?utf-8?B?WHJiUXZhLzFMU2xBNnJSVDAvNldnOUE3RzRjRHJzemtQUFFOd0VsR0UrQWF4?=
 =?utf-8?B?REhvSjQ2bWdkQTAvMkpvNzRhTnE3dFNiNlFtWkRhMTFtOWlOcElwQTkvUG9M?=
 =?utf-8?B?U0N5Y1dIeHB4YVc3M2ZzNFFtUkUxd2pGRjRCdUo4SzBnN0Z5TzAzQXdBRzU0?=
 =?utf-8?B?dUdBQWpSL1NxWTgzSzNzSFFQYmE4VkxEc2dJREZ0SG0zcUZXVytuT1gyRURB?=
 =?utf-8?B?STBnR2tQV2ErUDErblMySEhJOXE3VStXMzh0T0swbVJ1ZWUzMWlXNEhPTUJm?=
 =?utf-8?B?VVVMbzdVeTNqL2wzaTdtcG9XSnYrSDlNTWJia2szeStGYVhoV2FmaHVCKzVm?=
 =?utf-8?B?NUZ6cDR2NE4xOUlDM3hjaTAzZHB1bnYzYm82MlJ4RmxIK1g2VU1FTGVISm5J?=
 =?utf-8?B?VHBjUUFyV2hFdjAyYUc1dGtUejZSdmRSNWVMbURQSWRQZHV1NVhFMnBkcldn?=
 =?utf-8?B?SEpzbnM0TnM4ZHY4YlNIVG81YXVweEk0djR6ZjJMdlFvcXpibE1UeG5LeGsx?=
 =?utf-8?B?ZTFkM2J1UnJESVZIa2JQNncrbURkMDNzay9saHIvTXBmNnJ5U3MyNk1RYjB4?=
 =?utf-8?B?NGtKT1l6UW0rVWVMWUhqUnc1UWlHbWg4SG5qdG0yY2RKUS85UGNKUk83SWx6?=
 =?utf-8?B?TXBGSDFlR3AyOHI5ZjBZL1NQcmRkdUhybkhOSEVWZHN1SE53T3VYZWJOL1Az?=
 =?utf-8?B?Qk5sVDlZOFZkTVNLc3lLTTBNSEdqQ3JxQmlSS2oreXBINS9ydm9yckw3NEY1?=
 =?utf-8?B?NHUyeXJyaEYvWFdSWk9JU1IwTHV6SHNtdko4U2lLblpJT1dQamtSTW01S2Iv?=
 =?utf-8?B?SFRRNVVJdS90dDZBTFkwT0FqTXNuZEJmbjcxaTY1dG1UUGRKTS92YzBISlNi?=
 =?utf-8?B?TytzZnRZcEZ4T2JJTVNMZGRVZkh2ekdQV3JsRjZLVENHMncxTDVicDZxdm4r?=
 =?utf-8?B?ejB3NSt4L0NRRTJYZzNOYXhqMTlFUGViVHVYeVE1WG5VckR1S3VOYWpORXNW?=
 =?utf-8?B?dWgvSGlxY1RiUGFySWx1VXRoYk1iMW14RWxuaU5YZVV0MjNXRWhmMFVTeUJu?=
 =?utf-8?B?VDh0Z0w1R3EzcFhzb3h1RFdydFY2WWk4dkRHdHk0bzFBL0xNK1VGYVJtakdZ?=
 =?utf-8?B?ODVWNXl5TlViQjdGaGxhVHBCeVRrWVpPYWR0QzQ1cDJ2V0RLUUh5Sm9WMlFp?=
 =?utf-8?B?R25xcktuZzJFdldxSE1ja2FIM1VFKzdZdy9WRFBWQ3RPcCtLaDVhS1lOLzAv?=
 =?utf-8?B?dFlHZUE0aXZJcTBiUUpqdnE4NHU3a0JoYmdheEdJb1Jua2FpRTRhb0xtb0hT?=
 =?utf-8?B?R3lCTklvVEpwNVN4ZFJLTnZoQWpQUnhqVlhqRUdNV1NxcHRUQVQyUnNsOFRZ?=
 =?utf-8?B?R3JuZzRZZVR3cEkrR1RCM0NkOHdvL1I0MkIyUVN1MFRqLzBvMFYxU1E4Nk5a?=
 =?utf-8?B?SGlyTXVTMWhiYlhxcE9oUndmSTdtZjM3NXUxTTcvdFhJSklPbFFYaFBPYWZl?=
 =?utf-8?B?dXhKajdkNStmS2x3cG82VTIzYVptdWo1a0xNblhQaDc3aDQ4c0YrR0RMQWwv?=
 =?utf-8?B?bEllOVBwVTlrVHh3T0dwczJDaEgyajB2TjlHRnJBbG03cmdCdzZvWDlQKzdY?=
 =?utf-8?B?emdYNkRCVVFCdEI5RGg3TlpObmN3VFYwTmxmbjVkd0daeGdGc0lFV1Rjblds?=
 =?utf-8?B?NUI3RUFDYVNTU2JEVTdoTlg2cEVUTmZJNkVYbGNJRjdTY0ZtOUFVUm13TExi?=
 =?utf-8?B?UGtHL1NaR0FQdzJycDdvTlJEVWlGZlJ3SDc1ZXRxNWpmWUhONXVESXR0UTRx?=
 =?utf-8?B?MHk4UVN2RWQvMmFTenY0dFh5YjVWazd0TDFrZFBrbTZNblJ1a1Y0cXNaTG01?=
 =?utf-8?B?UVdGK1pjQ0VRR2lLbksvdFA4Tk9xY0ZWcGlvMWViQ04xblR5cnQ4d3cwaVpN?=
 =?utf-8?B?bVhDTFlSb1NWZlRVNU9KUTltWFRhSUtXYVN2SG1tMjFLclltSUZLOEZKVlg4?=
 =?utf-8?B?TUFxQm5KWEowVkxFWkJaWlYyRmdOZVIxS2QrWW1IdVo0QXlZSVRkOXIrdWlr?=
 =?utf-8?Q?v/na5L4neO0qTnRJd02WwffIZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A7ECC8C2A1CC344A6386EE64C1BD415@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57e08a2-e928-4b00-4ea9-08dc6e92e316
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 12:40:33.3847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AABD52sVTwKwAI9kSFSjyMKgntR/vSei6ztDj3BD/uOJZmXyb9YlJrENvER7JmdZ3C2ewrsmX9kdQkGh+ET4Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8289
X-OriginatorOrg: intel.com

DQo+ID4gDQo+ID4gU28gSSB0aGluayB3ZSBoYXZlIGNvbnNlbnN1cyB0byBnbyB3aXRoIHRoZSBh
cHByb2FjaCB0aGF0IHNob3dzIGluIHlvdXINCj4gPiBzZWNvbmQgZGlmZiAtLSB0aGF0IGlzIHRv
IGFsd2F5cyBlbmFibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIG1vZHVsZSBsb2FkaW5nDQo+ID4g
Zm9yIGFsbCBvdGhlciBBUkNIcyBvdGhlciB0aGFuIHg4NiwgZm9yIHdoaWNoIHdlIG9ubHkgYWx3
YXlzIGVuYWJsZXMNCj4gPiB2aXJ0dWFsaXphdGlvbiBkdXJpbmcgbW9kdWxlIGxvYWRpbmcgZm9y
IFREWC4NCj4gDQo+IEFzc3VtaW5nIHRoZSBvdGhlciBhcmNoIG1haW50YWluZXJzIGFyZSBvayB3
aXRoIHRoYXQgYXBwcm9hY2guICBJZiB3YWl0aW5nIHVudGlsDQo+IGEgVk0gaXMgY3JlYXRlZCBp
cyBkZXNpcmFibGUgZm9yIG90aGVyIGFyY2hpdGVjdHVyZXMsIHRoZW4gd2UnbGwgbmVlZCB0byBm
aWd1cmUNCj4gb3V0IGEgcGxhbiBiLiAgRS5nLiBLVk0gYXJtNjQgZG9lc24ndCBzdXBwb3J0IGJl
aW5nIGJ1aWx0IGFzIGEgbW9kdWxlLCBzbyBlbmFibGluZw0KPiBoYXJkd2FyZSBkdXJpbmcgaW5p
dGlhbGl6YXRpb24gd291bGQgbWVhbiB2aXJ0dWFsaXphdGlvbiBpcyBlbmFibGVkIGZvciBhbnkg
a2VybmVsDQo+IHRoYXQgaXMgYnVpbHQgd2l0aCBDT05GSUdfS1ZNPXkuDQo+IA0KPiBBY3R1YWxs
eSwgZHVoLiAgVGhlcmUncyBhYnNvbHV0ZWx5IG5vIHJlYXNvbiB0byBmb3JjZSBvdGhlciBhcmNo
aXRlY3R1cmVzIHRvDQo+IGNob29zZSB3aGVuIHRvIGVuYWJsZSB2aXJ0dWFsaXphdGlvbi4gIEFz
IGV2aWRlbmNlZCBieSB0aGUgbWFzc2FnaW5nIHRvIGhhdmUgeDg2DQo+IGtlZXAgZW5hYmxpbmcg
dmlydHVhbGl6YXRpb24gb24tZGVtYW5kIGZvciAhVERYLCB0aGUgY2xlYW51cHMgZG9uJ3QgY29t
ZSBmcm9tDQo+IGVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIGR1cmluZyBtb2R1bGUgbG9hZCwgdGhl
eSBjb21lIGZyb20gcmVnaXN0ZXJpbmcgY3B1dXAgYW5kDQo+IHN5c2NvcmUgb3BzIHdoZW4gdmly
dHVhbGl6YXRpb24gaXMgZW5hYmxlZC4NCj4gDQo+IEkuZS4gd2UgY2FuIGtlZXAga3ZtX3VzYWdl
X2NvdW50IGluIGNvbW1vbiBjb2RlLCBhbmQganVzdCBkbyBleGFjdGx5IHdoYXQgSQ0KPiBwcm9w
b3NlZCBmb3Iga3ZtX3g4Nl9lbmFibGVfdmlydHVhbGl6YXRpb24oKS4NCj4gDQo+IEkgaGF2ZSBw
YXRjaGVzIHRvIGRvIHRoaXMsIGFuZCBpbml0aWFsIHRlc3Rpbmcgc3VnZ2VzdHMgdGhleSBhcmVu
J3Qgd2lsZGx5DQo+IGJyb2tlbi4gIEknbGwgcG9zdCB0aGVtIHNvb24taXNoLCBhc3N1bWluZyBu
b3RoaW5nIHBvcHMgdXAgaW4gdGVzdGluZy4gIFRoZXkgYXJlDQo+IGNsZWFuIGVub3VnaCB0aGF0
IHRoZXkgY2FuIGxhbmQgaW4gYWR2YW5jZSBvZiBURFgsIGUuZy4gaW4ga3ZtLWNvY28tcXVldWUg
ZXZlbg0KPiBiZWZvcmUgb3RoZXIgYXJjaGl0ZWN0dXJlcyB2ZXJpZnkgSSBkaWRuJ3QgYnJlYWsg
dGhlbS4NCj4gDQoNCkhpIFNlYW4sDQoNCkp1c3Qgd2FudCB0byBjaGVjayB3aXRoIHlvdSB3aGF0
IGlzIHlvdXIgcGxhbiBvbiB0aGlzPw0KDQpQbGVhc2UgZmVlbCBmcmVlIHRvIGxldCBtZSBrbm93
IGlmIHRoZXJlJ3MgYW55dGhpbmcgdGhhdCBJIGNhbiBoZWxwLiANClRoYW5rcy4NCg==

