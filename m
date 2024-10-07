Return-Path: <kvm+bounces-28043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4589922E6
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 05:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3972281688
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 03:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAB418633;
	Mon,  7 Oct 2024 03:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B9+gPUWB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F217999;
	Mon,  7 Oct 2024 03:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728270435; cv=fail; b=ZPMfKGk17NzmTKKb4GfRPILBwnrL3nbIGIAmZ9QL8eQggyuxpB4TO5GRuJiEpRbVJfW50eQFA4c8EhDCL//s9GsD9iId4Y+f9BY8D4q+0Z3BErFty+iMRnesSBJfrAwArVWNG1XCJ3vSqkYaixFfGrJbgxV17BWLrtMjx41Kgeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728270435; c=relaxed/simple;
	bh=Gv/dj+Tz0HaU+HiE2NxxNjH2qHJ/QSrgkqHupI0e6/A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=foJKMwRc8SYDDSEpGYLOPyusY9n8DjViQTolUFnoXbSlAdglWomuEDU09kkNNfg++0JsKHJ062IT7gOYg8jJwZAYDmYkuzXTdh2fkd4EnEkrk27uziKObJyckaosRW6OLl6QfRmUuXyBrSHMrk5lSZ8hsv6WaFiw0Diwh7DzK+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B9+gPUWB; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728270434; x=1759806434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gv/dj+Tz0HaU+HiE2NxxNjH2qHJ/QSrgkqHupI0e6/A=;
  b=B9+gPUWB+l5Omt9D7BJwGbEuxhji5IRP7ntHL0KmXogAvsOYFKQWLbJ7
   ShpX0c+MI2EGq9fS8KB8WeU+9Ypnt2yn4LM76TL1ObyNko0Mas+qKD/Tf
   H1ppIsidyBjDDGEvpPDS0U0Wj1CKLn93zO5TvvKS5LDefHo47VB9A0HEZ
   B7Gyzs1mJuWqIFRuhttNhk0Kd7/3fTeMvVthc23TRAZKc3Ln4tTZmP23P
   9RAJlw6pq7kzYkrIeN/4cJu3gT5MOkMQD8qE6GhDc1ZKTCcze75NnJckv
   ApNWQu4eIS7JI6cpL9K/D++gmJOb3n88Livzv59pltP/l+kMJTXJjr43l
   A==;
X-CSE-ConnectionGUID: rsVfg1akQmehov7T/XvWXA==
X-CSE-MsgGUID: bKseoFzDRtenNkYCj0f0FA==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="27216755"
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="27216755"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2024 20:07:13 -0700
X-CSE-ConnectionGUID: ox5rh+trSF+KYnXYeQslpg==
X-CSE-MsgGUID: 3L3JEf0XS6uD+iLL3g2RSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="74904736"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Oct 2024 20:07:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 6 Oct 2024 20:07:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 6 Oct 2024 20:07:11 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 6 Oct 2024 20:07:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 6 Oct 2024 20:07:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfdroYTKk66JcqySg883JeGOKbhqslaLcfKR05jBu1t5/KK6eryHESC+jaMsWiHzw8PM6zwIt8aVSJzQCnVJ8UiRnlrO2j0xnCaRQhh+BPOJI5c853c7ol1XHH+6hblL5EVrw7Q4AkWVdjWB7nPYBneJhhzl0QbJceMItM2Aad8oiJzxBfbtsveV/RZNMXLbiTSSraxxoQxuxkHkdnOM+45KjF/U9V/QvS0VbON0s+8OV7g39WAAWbBIWsQxbBdZ3OyFurOlaay4/qR2JhNkUkwXBER904jzNtoPFdOflT8+2aeapIjEXDW8M8VXORlUKOi25zwwaPT4RfvpgwkAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv/dj+Tz0HaU+HiE2NxxNjH2qHJ/QSrgkqHupI0e6/A=;
 b=pllLAfZaZ2Nxq8T8zTdWITUyfiGtI7GN3Z1BEl/gQXTiOa1q6Q6+hIQyVzLk89w//OWnaj/Gz4LItzUkBUV55AO+Zd1waD5RbpIlHVmEVcqE6JnB0OovoxmTGAuJsS3aT0hYoE/MUz19zF4Yj7J0QSVWo58+U7N9QiBnIt6IjsvGB4toPwsxWo9j1QPSrR8HJmVZvPfCjIViL76EL4F2VWkQkg0J/6Yr70Qly5+3fdcA861a/IThst4j96sFDx+BAWaJSNiXEJgnBPCbYU6G7dqeezlSo7GnXqeRyvGjQQXAqzT2p6h48S1UdoVcauNIuUN6ZzE6bqEIORuPJbk0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6538.namprd11.prod.outlook.com (2603:10b6:208:3a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Mon, 7 Oct
 2024 03:07:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 03:07:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v4 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHbDnRp8EihSraYXkOZ/V8hjcAzkrJqOf0AgABuTACAAAERgIAACvwAgAbdloCAAC7wAIAATPiAgABqcYCACDbNAA==
Date: Mon, 7 Oct 2024 03:07:08 +0000
Message-ID: <271368d1cf0d3b3167038a01ba9e9d1e940cb507.camel@intel.com>
References: <cover.1727173372.git.kai.huang@intel.com>
	 <101f6f252db860ad7a7433596006da0d210dd5cb.1727173372.git.kai.huang@intel.com>
	 <408dee3f-a466-4746-92d3-adf54d35ec7c@intel.com>
	 <62ca1338-2d10-4299-ab7e-361a811bd667@intel.com>
	 <a03f740b-6b0c-4a64-9ff1-7eba3ac7a583@intel.com>
	 <1b14e28b-972e-4277-898f-8e2dcb77e144@intel.com>
	 <66fbab2b73591_964fe29434@dwillia2-xfh.jf.intel.com.notmuch>
	 <d3fa4260c50c8d4101f8476c1cc4d6474b5800ce.camel@intel.com>
	 <9514d5b8-73ba-47c8-93a9-baee56471503@intel.com>
	 <74a88c3df6e51ab8dd92fdd147e4282bfa73615b.camel@intel.com>
In-Reply-To: <74a88c3df6e51ab8dd92fdd147e4282bfa73615b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6538:EE_
x-ms-office365-filtering-correlation-id: 56b73285-75bf-466e-2f0d-08dce67d21a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VUlxK1dlbStzaUtnZ0lMVmNTdTBtcEtDWG9wNUFMTmo0TDM2dkROZnhsZjNj?=
 =?utf-8?B?aGxDdWlGWmdKQy9tWmQ2emVzY05pT2lUYjM2Y1VPeVpVVDY3WXNDRU9UT2RD?=
 =?utf-8?B?L0RrQjRsQUYyOHdQRXNxNGFRYjlmMWI3VElMZjNVVDA5ZGNYQXVJTisvT0NP?=
 =?utf-8?B?b0piSGlEdUxSaGtPNHI4VHBzYkorWXdMazRvSzJNZ3ZzU1UyQmpFYkZiME5W?=
 =?utf-8?B?d3VleC9wbDNhSHB5TzFpOXpPeWVrODMzREhJZVAwcnZYL1NDNU1GMU1pWkdJ?=
 =?utf-8?B?OUxhU0ZCWklqOGNCTW1JbDA4ckY0UmlrbExYeldiazUvL2FQRkI2c2M1SEI5?=
 =?utf-8?B?cUJESHhtQ05Ea3pmbzg2cVAybUo5Q2g3MENwU0pZQS81Z0lSNFV4ZUs5S3VU?=
 =?utf-8?B?ZnBhSDZneHc0WVl6QW0zd3JxMkE5ckx0Nnl1b2JzKzJyTVNhRnFSb0piSFZq?=
 =?utf-8?B?cmMvU1BkaXZXQ3BXTXZYVWxpa0VUdFloL3QwNTZaQnNYOGJVRVdqZVo0T2pw?=
 =?utf-8?B?UTRGTHRaUTZTTHd6SERLMjM2ZG93U0k5eUh0ejgyQUM5WGQrT3lVaUhtRlVM?=
 =?utf-8?B?c2ZvWkRIM2FnUVdlQXA3MjA2a1RzZkhpT0VmaDFMdWdtb0ZNUHhHWnljTVdZ?=
 =?utf-8?B?TlY2RkxrRmJyUkRsNkF5TXM5UXgrU212NWhWUlpuakt3Q2VHU25DdDY1ME9S?=
 =?utf-8?B?MUtoMFRXeXJtMEZpMDk4Qk5EY2NPUW10ODVibk1CV09HWmZjbitGNU1CVG5N?=
 =?utf-8?B?NUJHMG1JSmtSakxUY1VhWWVnV0dNSEJLRkJNeUx4V001NG4vRDlPdlVTN25Y?=
 =?utf-8?B?L3NvU2kxUUhNaEp2M3VzL0M0S2tZaEk4ZmhvSGZQdCtVTEJWRUgwL2plWm1z?=
 =?utf-8?B?ejN4c1ZNNXNYUm00cWFiVU10K0thcE9IOUhaSlZnN0ZOQUViczhMR1lOelkr?=
 =?utf-8?B?a21pVTlCQlNVNmVWTjVjRWk0QXlKYnl5MVV6TEFTYVpJc01QMUpRRGszSmVi?=
 =?utf-8?B?Z0QwWitKdzFsei9HM0RiSDNGUnh3TSt3L2lMRGFSUDZ0bDRRemIrUkl4U3V6?=
 =?utf-8?B?L0dJbnAvb1VCVURGdmduNjllYmU0U2w0bWtHMmpsSW1oWGVoQzNOVTZhWWl1?=
 =?utf-8?B?MDhnZ0ZValp3eHVkS1F6cS80WHJOS0lHNzQ3OFRmYjRrTk9GRlZwUDJwaEtw?=
 =?utf-8?B?NXA1bldrc3NCS09CTkRDZTY1SUpaSGRkOGhaMUhGdC9BT3hmdTBHNmZiWk1V?=
 =?utf-8?B?Zm1iV3hXaEJlUVRSM0p2SDZBaEpJYjR2VFE5a0pYZE03a1ZzVjdYd0dCRVlI?=
 =?utf-8?B?YWFpMThodWx1bkQwSmJhN2RQRFZHZ3pSVFYrQUxEVk16dVk5YkxyRFZyeTFm?=
 =?utf-8?B?UE1TRWJNSERJeUR0U21IR3dpa1dwakVVd1J5elFNVUs4enRYWnNNSjRKMFBj?=
 =?utf-8?B?aEh3RktKWDd5aWRBWWxHRlhjUlhWQ1Bhb1VQR0JKMGlMUnBwb0ZCYnpqU2RL?=
 =?utf-8?B?TStRNkhmVmZFeGNiZDlyREt0MFRmdGprOVNiVGgwTGQrTHNRSU5OMTRLZlJr?=
 =?utf-8?B?RkJoMVptb05leERQZGJSdHRrMFRxY3ZlUXBJTUF5U3FVV0VjQmNNYlRQUmVp?=
 =?utf-8?B?czNTQTVRS2NzQnJYRVUydkVyUnBkVElMZkxFZmpCYVhNbzJSVjRSYXdVRXg1?=
 =?utf-8?B?YnV2Q1ZHdEZpTXJvdW5jd2FXZmE2NjRVNW43c2tjMXRtSGVMcjQwM3JXajNU?=
 =?utf-8?B?WmxrYUNUNWdpdTNxTFNaM3B4eENIK3QzWGdzbFVCVEIzY3kzM0JIZjYwb25h?=
 =?utf-8?Q?lz95h2M2H/Jvsa5V9RfjfZvci3Cx9W2hd7vgw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFpRK3Q3VzdrQ0RMOGpvdjJHREYxdXdyYlY1K0YwWjVJRCtUWUVsdFR1blFi?=
 =?utf-8?B?T3B3RDF6SzNRQmRyTWxVenNvUUZMUjFoL1JPZ2hnRnlLd2JaQTNETzhteEx2?=
 =?utf-8?B?aGNtNUUxMTMwa1lvWldDMTh1emxHdnMyWU1jaHRPdnZScWVrekZ5SXlkenND?=
 =?utf-8?B?YWQ2eWdIamJQeEgzTUY0SjFLSUg1emJlcjVGMmo1OGdUOEo0UDExaUJRZzZP?=
 =?utf-8?B?STg0Y0tTdWpOL3QwTGVYbW1wa1hEOWxWVU5BNmRzUSsvS3JiMlJWN3NtL1ZN?=
 =?utf-8?B?ZFJHWkdmNHlkZXpMd2ozcWR1UmhJN3JFQjlCV0xIR3FWdWxHWFh3ZElEVGI2?=
 =?utf-8?B?Z0RQRklGK2l1dC90RTJVem5WVk9MclQ2RjRyaktYT1R6UTJzV3pyR21xR1VK?=
 =?utf-8?B?UUtKa0VwS3F5eFM4QTMxSVlvRG1HeEpTbDdwUG1UZm4xdUpDSlZNQWlNN2Fh?=
 =?utf-8?B?bjhLeXg3TEZuWjMvWHd4K3cxNTIyUktwMkd5S3dxZHFPNzRlOWpOd0hYRUVv?=
 =?utf-8?B?WFpFVmFDT3d0ZzZ4NmlvanZmNEE4bzg1SCs1T1FSUk1SUGcvNzY2c2dUNVlv?=
 =?utf-8?B?QVhhSHI4UTRySHVRRGdnR003V2RXUXpkSjMyK2MySmI4a215aVhsaWdVYUcw?=
 =?utf-8?B?SUhwQ2pWVHZZdlZwejAxb29maGFQbUM3TUY0ZnZhOXBlN2N6WXlLK01iRmFH?=
 =?utf-8?B?eUpFUFFsanhMTXBXNjFlT0pqMVlXakxhMU1rRlB1cE9GaDRuMHhMZmpGaEc4?=
 =?utf-8?B?UVVpS3VYUmpIaVp5cmt5dDk1bXhnRVl6NmJXUWJ2MzZvdGZQdUtaRUNtRTd4?=
 =?utf-8?B?cmFMbEFSSEk0K05ENDdtOTdvWjdXK0RHMCsyZUdzK2p2YjVRbnlrZ2dKSnlF?=
 =?utf-8?B?eGhwNjdNUFRaN2NFa251M2RJNHVncDlJeEsvQWhJYjF5Y0NQazB3Mm82WDNX?=
 =?utf-8?B?T3QzNm9ZQlRnSkk2TUlVeTJITGFwdUpUTTQ2M1JUYUFTYXdDaUVQOXIwS0JX?=
 =?utf-8?B?MFB2RWJPKzFwZ3FEZGhVTktaWlppOC8rREtQZXR2M2NWVjV1RTF5Mk1XQXk0?=
 =?utf-8?B?b2NTaWFqR0hLU3lWVkQ5SGhlcGtCZzVUUlpzMG8wN1ZWTFh1Mk1KdXJQeUNo?=
 =?utf-8?B?TUpkQXJ2ekZDeEl2MGxSR2cwYXhPWXBsZUtzS0E5YTZSWFZEVHdQSmtKaElL?=
 =?utf-8?B?encvMytPdkhKaTlYZm9qZXdVdHJrb29CNDRoa3VkSGJqTHA3eUoyVU5jS051?=
 =?utf-8?B?VWJ1NytLM0U2a1h5U1c2SjlhTUJydUM3KzNRKzhMcndtOW9TQStKU0ZKWXd1?=
 =?utf-8?B?M1I5SkNMaUlON0o2Tkx0VVl4RlN3S1piVEtLNkhUWFdac0ttVXJxYWIzeWND?=
 =?utf-8?B?WWlLcVRjRHJDZFJwNUFUeGZlZWxJVzFYWmwvZ2cxcmxCbUh3WDhBSDgyUFZG?=
 =?utf-8?B?ZW01S1hQcGU2di8vZWY0alpjcHo5Q21tRE1IWnFhM2N5VmcrMHNMVTZiZHB5?=
 =?utf-8?B?R1RGNXZPVDUyckhTVzM2NGlEQmJTald5UG9UUDNoN1dNSkxDU1h1eEg3VWNr?=
 =?utf-8?B?N1ZIQ2xEaUhmQUpNeERoNDRJbHZGeE1ZbEFwbEVON2RkeVdqaE9MV1Erd0tY?=
 =?utf-8?B?M2dteXpTVHpSMVcrMXloN2RWazRtcGlqS1NDUkZGK1ZNczk3djkzY2hOSWNG?=
 =?utf-8?B?cldMOEIrN3ZOdXI1THFoTmVvRlJyakhma2xobnVMMVgxa2VvYVhUN0E0TVZu?=
 =?utf-8?B?MmN0UnlWMEdwTjZJZE5PMVpSQmZPdkVWOW9JZjVySGZPMjZKZ2hMbmxDQmRR?=
 =?utf-8?B?R3gyckJsSVNmOC9oNVpzVFZtSm16WTFhZkRNSjdWTVFGbXVrMVFsVGhhTnFh?=
 =?utf-8?B?Y09mYVowWHBvWm1wZ3oyMS8zaWJIa21JalQ3d2ozd0ZpR1ZuZFNxUnBRaE9I?=
 =?utf-8?B?Wm91L0RYWmM2akJqV2tLd3hvN1lrcFNEd3JmQk42bFRyeDRHd2R5NkdCNDdr?=
 =?utf-8?B?Rnp0V25tak9IZGhiZmVsemZDcndBbGkzYXZhaXhBOUsyYVVjZVJuNUx2M3BH?=
 =?utf-8?B?TDU5VzFxVzY1N1MwMWZRMjQvZjhiM1htWnR3TVdCd0hMME1IdmVua3NGUE5R?=
 =?utf-8?Q?cg7cfzxDCzU06dPxK7sfnxZnJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEE9CB67C1E69C49B0759D295A51ED61@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b73285-75bf-466e-2f0d-08dce67d21a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2024 03:07:08.9297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jselGBd7PDnAIzxyG5OB43SEKvetx8DwKyxqCCd/U73CbTzmma2Nk5wsAF5d3gSiyHjnkvKUQyfefb08gP+tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6538
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEwLTAxIGF0IDIxOjQwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUdWUsIDIwMjQtMTAtMDEgYXQgMDg6MTkgLTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDEwLzEvMjQgMDM6NDQsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBQbGVhc2UgbGV0IG1l
IGtub3cgaWYgeW91IGhhdmUgYW55IGNvbmNlcm4/ICBPdGhlcndpc2UgSSB3aWxsIGdvIHdpdGgN
Cj4gPiA+IHRoaXMgcm91dGUuDQo+ID4gSSBzdGlsbCBzZWUgc29tZSBsb25nIHVud2llbGR5ICNk
ZWZpbmVzIGluIHRoZSBtYWlsIHRocmVhZC4gIFRoYXQncyBteQ0KPiA+IGJpZ2dlc3Qgd29ycnku
DQo+IA0KPiBJIHN1cHBvc2UgeW91IG1lYW4gdGhlIHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKCkg
bWFjcm8/DQo+IA0KPiBXZSBjYW4gc3BsaXQgdGhhdCBpbnRvIHR3byBzbWFsbGVyIG1hY3JvcyBi
eSBtb3ZpbmcgQlVJTERfQlVHX09OKCkgb3V0Og0KPiANCj4gLyogRG9uJ3QgdXNlIHRoaXMgZGly
ZWN0bHksIHVzZSByZWFkX3N5c19tZXRhZGF0YV9yZWFkKCkgaW5zdGVhZC4gKi8NCj4gI2RlZmlu
ZSBfX3JlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKF9maWVsZF9pZCwgX3ZhbHB0cikgICBcDQo+ICh7
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0K
PiAgICAgICAgIHU2NCBfX190bXA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gICAgICAgICBpbnQgX19fcmV0OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBcDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXA0KPiAgICAgICAgIF9fX3JldCA9IHRkaF9zeXNfcmQoX2ZpZWxkX2lkLCAmX19f
dG1wKTsgICAgICAgIFwNCj4gICAgICAgICAqX3ZhbHB0ciA9IF9fX3RtcDsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXA0KPiAgICAgICAgIF9fX3JldDsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gfSkNCj4gDQo+IC8qIEBfdmFscHRyIG11c3Qg
YmUgcG9pbnRlciBvZiB1OC91MTYvdTMyL3U2NC4gKi8NCj4gI2RlZmluZSByZWFkX3N5c19tZXRh
ZGF0YV9maWVsZChfZmllbGRfaWQsIF92YWxwdHIpICAgICBcDQo+ICh7ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiAgICAgICAgIEJVSUxE
X0JVR19PTihNRF9GSUVMRF9FTEVfU0laRShfZmllbGRfaWQpICE9ICAgIFwNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgc2l6ZW9mKCpfdmFscHRyKSk7ICAgICAgICAgICAgICBcDQo+ICAgICAg
ICAgX19yZWFkX3N5c19tZXRhZGF0YV9maWVsZChfZmllbGRfaWQsIF92YWxwdHIpOyAgXA0KPiB9
KQ0KPiANCj4gRG9lcyB0aGlzIGxvb2sgZ29vZCB0byB5b3U/DQoNCkhpIERhdmUsDQoNCldvdWxk
IHlvdSBsZXQgbWUga25vdyBhcmUgeW91IE9LIHdpdGggdGhpcz8NCg0KSWYgbm90LCBJIHdpbGwg
cmV2ZXJ0IGJhY2sgdG8gd2hhdCB5b3Ugc3VnZ2VzdGVkOg0KDQpodHRwczovL2xvcmUua2VybmVs
Lm9yZy9sa21sL2NvdmVyLjE3MjcxNzMzNzIuZ2l0LmthaS5odWFuZ0BpbnRlbC5jb20vVC8jbTM4
NzQwODBlZjE1OGE0NzA0YzQwODIyNTlkMzU5NGFhMGEzMjJmYzgNCg==

