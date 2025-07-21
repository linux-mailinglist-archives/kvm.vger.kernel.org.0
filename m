Return-Path: <kvm+bounces-53027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D12FEB0CC66
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:20:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 065235428FD
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1004242914;
	Mon, 21 Jul 2025 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMHvSOmG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAEB23DEAD;
	Mon, 21 Jul 2025 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753132816; cv=fail; b=J/Khbik0JeKXKK+zNkTj+CjKtV8W/Zm5mS9UC5xznfEDtZv1pWnnrjvbHs8RsY8nzTQNCg8Ti0dvGMXTAl7WAWTIUzJPdNkaQrsheKfxJLFOfZ9im/pAvMB9D1/t2NLjtEu6beDFf5ITIypTmKPFgVv/6jY0cHZqfWRzLrcajRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753132816; c=relaxed/simple;
	bh=Qqd2OArHliy3yv8ORzL5FGmQWgeGYpLbYzgsd+QtXeo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uOYHkE1SBbBtaYIxUWv3Gki+ra4KBY3SsimqRfPzc0Th101RL+Xm89cud+VXv6OH1SsuVL5M9GreMBnXX1//sCJ4pK2LDxf+PxQpDmPyaYP641/XdvDkTwQTD6oxidSNaOCH4cuOMtFfz2EM/8BDAjwh3mJwAFo98+Kha4mmATo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XMHvSOmG; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753132814; x=1784668814;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Qqd2OArHliy3yv8ORzL5FGmQWgeGYpLbYzgsd+QtXeo=;
  b=XMHvSOmGTvI+fD749evA5GQO2481lMsC82UAMEpQVRBvl4+GioDBA0tv
   g6LINXBB8sJEvlYloL7C5gZXPNLGKYi25YpXz99x3N7Y5RmJdsyXx8+BF
   5sW857RFyO5zkANti+0NAge+AaHrSSiHhVXdEvFgDQxgo8WgeKqjUy8u7
   8csXO+SemM3nCqOvEoVWOoiuTKidX44scCjguvwOXB812k5fAGQNTt4kL
   tBk7ByjzrCzuArpBxDttssDfLvlrS6x0s5b6rn+xNJQrMcZw/C978jvDS
   oGM1h5oFhUzbVUjHMF3SbrkusgcVDuSAIRQbNjPoVZLnEk6rf5UiUS/Pt
   A==;
X-CSE-ConnectionGUID: ZUFyQfJGTnC20kw0K/Ddow==
X-CSE-MsgGUID: 9i5xVTEcTNGfJ/5uBYAReg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55321938"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55321938"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:20:13 -0700
X-CSE-ConnectionGUID: A6FapqGFQR2RIWroZfVBJw==
X-CSE-MsgGUID: OmkOeYb4SKC3uAuNNs4DLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="158611799"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:20:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:20:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 14:20:11 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.46)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qnn+VLRL8HTwSlBjo+uBrs39ROSfe1HdOg4Z6TU0+ibZXNjroW5oaAE6ElsRoh6TewT97sszcAMa7qnN/2HR2nb6VGGSwK9sll/PdJzYBHwAws7ZWlMmRAQ9urT7AVQKp3GNPEp3gTak9QCmXjjwP3lsNE+YgXMuwwi90o+lS5Tq7eJCq8/qVYcnyduJGUhZJp5c+lumRPEOLCf1JVqkiohKJ9fhnwG/ArWqQxZ0RhbdYnQp142Wkp67V3E5wlTU02P6+nNS1pkQReKaAGkTGPT70OnkEpDPpqmzV4u9WzQj8t1+IqtMtd4QsEBRlSYgy5A5WsYdOaXmU/sKliEbeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qqd2OArHliy3yv8ORzL5FGmQWgeGYpLbYzgsd+QtXeo=;
 b=WB77737rPcHw6Lsnbwg6EE4NKY3N4zsqn7SlQJbvRiBc4lqT9JY5bQtg8Sih8eGyi4Ms8oi2dyF8xgdZtnLYM0q2e0bziReRgREm9TZnOiwyEar8j86Uw5Z1bkQfXl4VchEmcpKhVhjLqX7hELngo80COeMO6m0ofqonqZPfTbo6Z/YOJzYmfmtXs7N9dYsgkASXhUhK65W9nkX+U0nflGOLzTE33FB+mTU+vpGeJLhGIk4GwRe9BhjNRpFt3REUyZijGsDR5ApmbT3s0nrirHRX3QtDFJbfxkqa/c6/Q3ThjW4YZURNhekEkdO8kngKEYRd5b/EyvPRAfpQIvc0ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB8256.namprd11.prod.outlook.com (2603:10b6:806:253::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:20:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 21:20:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Gao,
 Chao" <chao.gao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "sagis@google.com" <sagis@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwA=
Date: Mon, 21 Jul 2025 21:20:08 +0000
Message-ID: <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
	 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
In-Reply-To: <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB8256:EE_
x-ms-office365-filtering-correlation-id: 624f8b48-62bb-40d3-fdbe-08ddc89c5e7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NlRmUkpwWjZHaFhKYkNZUldlVDl1Z1FiTmRCTFFmL1NpMmV5RUxGb25pWE9E?=
 =?utf-8?B?SlZWd290UWNDdlNsYmlMNUM3dzM0NTNxZE1TYXQzKzE3MnJFN1ZKc2FvaHhq?=
 =?utf-8?B?czFnSGZvZnAzK1N3Vml0WkdnQlRqMTJjU1YxMktFeEsxTDU0ckJHaDRxWXJx?=
 =?utf-8?B?aWZzQmJ5YzY3OTYwZ3ZVVnZEMmJBNkRQandidG9EZ29RZzhIU1gxTXZVOFYx?=
 =?utf-8?B?LzVDNDdMb2lBQ1VNYVZvN09CbzNUamgzb3l0ZU9GSzJ1bUN4cEQvQXhyWnNC?=
 =?utf-8?B?aVIwS25WR1Z4R3RQcmwza1RET2lUNVQyRFFpQnk3bDJaVDFidVE1ZHQ2em9x?=
 =?utf-8?B?eDNrWnJ1TkJybW9pOGlpTEFsTngyWEVtMTNPQXRoM3ZSTGJnQXNTQ1JHWGR1?=
 =?utf-8?B?Y2Q2MXpoSEYwamplMWJFOVI3RXk2M01RQzE2R0FVOVlENUdORDFjcHhXY1N5?=
 =?utf-8?B?UlF4a0VhVDhOWExxU043OGNHczI0LzhpWnMzR0dkNFRHWGl4NXR6UHhTbkl2?=
 =?utf-8?B?VlJCUkEyT0k4NEM3bm5nRFVtYjdaMkJWd2ttWjltQTlHT0lKMUdKV093bjRt?=
 =?utf-8?B?YU9SejJpK3R0MTM0Q1VKekw0U2RKQzdKaTdwSHhaVTVvM2xoQjVLaCtVOERk?=
 =?utf-8?B?bWljK1VvcnJLWlF5bTRiay85RUZJT1NkalV3ajV2dXo1cVROQ0pFbjAvM3Ev?=
 =?utf-8?B?M1RvcWxVNDZvcUM4a2FwbitEbURoSXZmRzY0Ym5Za25NeTVKT2c3VG5ZbDBF?=
 =?utf-8?B?cUx5QytQemxxSTVnTHNXanpNTStidklPWE4xaTFqbTFWaFVjQWNLMTZFTTdR?=
 =?utf-8?B?Lzd0cUtYVnNtQ2crSjJMK1NjZUJpc2xwR1JVekZpemYzOUNyTjVzM3lRc2pZ?=
 =?utf-8?B?dSt6ams0cTRmOSt5NDV4aUhQVEpNWTA4NE83dkJXVHRIaGpsWUlmVCtrTnpt?=
 =?utf-8?B?MDNqQjVRMEFJQTdyT2JBbGQ3MXNZdXd2ZUhnZ1g0dEg3aDVTU1o1aTZ1OG5o?=
 =?utf-8?B?OCtReTRtdXA0QTI0K1dRenhJM0JMb1BOUFYzak9YZUI1OVc3YzVFaFFONDJI?=
 =?utf-8?B?bHBPa0tUYTZFOG85MHIzeHh2d0dsRWlnaWYxSUVUQTFLNVBBOGFyMVNRdUVh?=
 =?utf-8?B?QmdOZGRtV0FvZHp5TysrbG4xYndjcHdLZ3hvMWpCN2hueTc0WG1KczZ1ZHk1?=
 =?utf-8?B?OHRWNzhCVjZ2NmVBTUIyVFpyVVdUYW5VQXZNZitOWUk3RDVFV3QyV2xGelFO?=
 =?utf-8?B?VmdML25IV1lnaktaeC9DV1VPalRFU1FkM1g3WjAwYUZvdjdoeGZzYXRvUnZH?=
 =?utf-8?B?VnlSM0Vqa1FHU1R6SE1LSW5JVnU5WEhITUp5eTlmUzErbWMwRGR0cndsSWZ5?=
 =?utf-8?B?MkFLZUJERE0zamJvamIrVE5JUnBrSnJ2YmpROGhDS3BYajBPc3YvZm4xTEV0?=
 =?utf-8?B?eHhDVHl3NVh0WEFIMk85ZFBUOVBrbFJ2NE01Yi9MVU04NVB6K0U4c2pnQVhP?=
 =?utf-8?B?RGQ5cTV5MkZ2ZjVHWGZOVE9EM1AxajJaVENiUzByWDdyNlhoa2JQRlNPZGxH?=
 =?utf-8?B?L0FOSDVOcWNvRGFPOHhGV3BjS3Iydld3QThmbVN1N05uT1hrT2lVdmpQUHpw?=
 =?utf-8?B?cGpHZ3I4UmdRTEgxaE9zMTA1S0MzVHFFU1Z2ZnFHNTBQSERtcmM2UmZKQ0Rt?=
 =?utf-8?B?Q2JVcFFFUDBGWUpJakdSRXdyVFhGeU1CRmNDaXpjRXhucXVlbzNwcHQ2MzBK?=
 =?utf-8?B?RXlpZkswaHBJcEhibFdjVnNvZlBKQ2NBUlhxRnJYRk52UmR1SzROeWFFVkxZ?=
 =?utf-8?B?cjBoRFh5RGpQdk5SYlJKN1Mzdzhkak4rT3pMeWFaMjUrUFhqT0hXVHpnOEFM?=
 =?utf-8?B?TXBzWXZyZXB2ckU0WkxBcFk2MGcwbFZXQ2ZyZk5oS3NtWDc3Rk9hdS8wUHN6?=
 =?utf-8?B?S1VuUlp1S3Z5bGVQZlV1bVptMlNIdlBPclRwWHFOQjFPMDAxOVlWRzRTdjFB?=
 =?utf-8?B?VklEYXNvNndBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zm9DRmpGenlheGpYbFdXbUgyYm1rTXZyNGhaS295M2lURFVqRkV3YmlNaUt6?=
 =?utf-8?B?cktqdEQwUFdwYVFMN01NVTVhcVVMeU5hcWgrSHdyTEpKVTJ1VGo4WHBNbitP?=
 =?utf-8?B?eUdreEVHSnlmQmtjdkJYSUQ0ajM4R2tRS2JOeVFaTXI0V1dOZHo2VjlwS2FS?=
 =?utf-8?B?S2hLb1o4aGVFN2RaUDB3b2JMOWFuZkNvOTIrTzl5cmMxYUNZVzBsc3ZDNHA1?=
 =?utf-8?B?Ykk2RHh6VzIzdGMwZFZHMTRKaVJ3OHVSSWY0ZkQ1T2hlZXprV21lbnpqVUYx?=
 =?utf-8?B?a2pKWEZrMUczcDU3b0tKbjV3M1NwSEMwelFXbUtkV2c1NEI2ZkYvOEF6K2E4?=
 =?utf-8?B?b0tBR2FpenBhQlJHL3MyUThSRXVVKytIY3dheW0vSCtUb0ZLRzEvMDVmL3dq?=
 =?utf-8?B?NDZqV29yMG5QUE9oeUl2c1FDUWFycnhGeHdxSmZvMkphTzN6cEhmN3VxUXJy?=
 =?utf-8?B?dE9CY1hxVGZKVWh2c3VrQlVyajlSYm5Rc1RXNlRHSGpINFdQdG9NeCtldUFx?=
 =?utf-8?B?b0U1UkJ5Tmpidld4UnBXRE4rbXRLWWhVd3hpMGFxb215RjFqZ0VQZytxMXJN?=
 =?utf-8?B?MkNrMmZpWlBZVVJzUXV4ZGIzYXJPbEtVVFljTW1TdTd0QXRuWW44VE1qTDE0?=
 =?utf-8?B?bm1rSU1xaVl6QjZXMnRJYTEyc0RweUwvUVFQclh1QiswQ1A3akVoM2F2V3NX?=
 =?utf-8?B?U2VkTTJVUDNCT2d5VzBWZkpJclhxOGVxc1hSYzQ0Z1ZYSnFKZktKb28wY1lp?=
 =?utf-8?B?WnEvemZJeTNEemMydnV6ZUQ0T3h4N014TFZUYllIT1J5blM5cmZna1BlMUhF?=
 =?utf-8?B?WlplNGZUU2FEZmZFTndrc3pRZHM1Z3JHQjZWRFdDamNWbmxOaUFVTWhRUHc5?=
 =?utf-8?B?ZFphcGpJcFlZd0I4SXhJTGV0cEJVQnNNV2txeTJ0NkFwb3NOdGY4cU95T2Vv?=
 =?utf-8?B?RkhsWVNYWlBYTjFZYmJvUi9QS1c5QXZxb1N6UVpYSmlJN0V6ZDBsblpGUGVl?=
 =?utf-8?B?Qnl3ZXpGR2xmR1F0RTV5YVp4OGkvMWthOUJCS1V2M0lXRFlLOXRkTFFOcUdP?=
 =?utf-8?B?encyNjlraEFrNU1Gd3I0Zmg2Ync5Ri9obW5NVTNYeXlTdnZUMGhFVG56OU9j?=
 =?utf-8?B?Wk9va1JOUmRTSzJXODkrOEw3YklzSG11QU9SSlQ5MW4zVkYwcU5FaFZOYWhz?=
 =?utf-8?B?UGFVZEtMVjRJODlpMmd5M3B0ZlZJV2xMYWpoQ2xSMThZUEhUNDBOZHI5V1cr?=
 =?utf-8?B?cGw4UnJrS25qTnIvc3VEa3BSTHdUU1MwVXVvS0dNcU01bjBGcEs5eWlvdXhn?=
 =?utf-8?B?czBCTXQ0ajRRNGJLNkdUVHovZHBHenZXeWUzOTMxWGpxVDZ0azRldW1xVTNS?=
 =?utf-8?B?L0pXWnR5SWwyazdmMU0vT2NTS29vbEVIcFdWSUVtQ0xtWGpyU09kRDJ1WkJY?=
 =?utf-8?B?V2tTR0d3R0hxYVE3K1Y3MHhZMXRPajRIQ1grbG5IWCt2Yi9uZi9FUWlPOElo?=
 =?utf-8?B?SjQzcEZFK2JLVjBLdnRSN2UvMWgvMVErMkMxYnVBeUFwU3g5eWg4ZmVPYnk0?=
 =?utf-8?B?QldabEkwR3Z1UWxnRUpjbks1VVR2dDZQMHRpS2FWVEd6TlR5dG9RejF4cEUr?=
 =?utf-8?B?QzRqRmxKL0N6NEQ3Rm10RjNkQTkyM0JFSzdLSjF2SXFqLzdya0dSVHVMSWt2?=
 =?utf-8?B?NnJ2WTdFOHlUVnI1N0E1R2dLQlRlM0dhS1N6ZldqOEo3MmgvUHdET29DU1pm?=
 =?utf-8?B?Z1pzSHhwNUIvaVhhM2NKNHU1MitnWjExMDJvNkdtSW5CMlFkeTJhYTdZZ1NW?=
 =?utf-8?B?eDFONENaL0UzdDFtVndEUzJENlY4VzdsUWF3T2NNWThuWnJRTWxCbXpyajFh?=
 =?utf-8?B?cnY1UWh3OS9ualluRFRYMmtvc0JOV0FUNUtLSHV2akg4UVZydUNreUVBanNv?=
 =?utf-8?B?WmV6a2QwWXlwL3doNEszbmk2cm5meXlYU0VwK0xKblRlN0hnR0dUdytNZWto?=
 =?utf-8?B?YWp3YzVQcUhKcCs2SkpwMW9HQS9XUndUczJ5bm1JaWI0Z3c4TExLSVNjTHht?=
 =?utf-8?B?Si9Scm95WE4xT3ZVWi8vNHlDR2ZBbFYyVUoyb1ZnTFh1em53LzRnNmVnZGc2?=
 =?utf-8?Q?zUdcNbwPgFZIPX0Aax/iuq2uc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F715A3F2CBE2D04AA28CDD98E828A80B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624f8b48-62bb-40d3-fdbe-08ddc89c5e7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 21:20:08.1900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KNoJHl2XjXyqs26sEVUANp1whhO5R1/1ARj1Sd7wsXvgL6xF4sVfbOfhC888LEOdz8nAaGyJhIS052WnHpm8aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8256
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDA5OjQwIC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDcvMTcvMjUgMTY6NDYsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBEdXJpbmcga2V4ZWMsIHRo
ZSBrZXJuZWwganVtcHMgdG8gdGhlIG5ldyBrZXJuZWwgaW4gcmVsb2NhdGVfa2VybmVsKCksDQo+
ID4gd2hpY2ggaXMgaW1wbGVtZW50ZWQgaW4gYXNzZW1ibHkgYW5kIGJvdGggMzItYml0IGFuZCA2
NC1iaXQgaGF2ZSB0aGVpcg0KPiA+IG93biB2ZXJzaW9uLg0KPiA+IA0KPiA+IEN1cnJlbnRseSwg
Zm9yIGJvdGggMzItYml0IGFuZCA2NC1iaXQsIHRoZSBsYXN0IHR3byBwYXJhbWV0ZXJzIG9mIHRo
ZQ0KPiA+IHJlbG9jYXRlX2tlcm5lbCgpIGFyZSBib3RoICd1bnNpZ25lZCBpbnQnIGJ1dCBhY3R1
YWxseSB0aGV5IG9ubHkgY29udmV5DQo+ID4gYSBib29sZWFuLCBpLmUuLCBvbmUgYml0IGluZm9y
bWF0aW9uLiAgVGhlICd1bnNpZ25lZCBpbnQnIGhhcyBlbm91Z2gNCj4gPiBzcGFjZSB0byBjYXJy
eSB0d28gYml0cyBpbmZvcm1hdGlvbiB0aGVyZWZvcmUgdGhlcmUncyBubyBuZWVkIHRvIHBhc3MN
Cj4gPiB0aGUgdHdvIGJvb2xlYW5zIGluIHR3byBzZXBhcmF0ZSAndW5zaWduZWQgaW50Jy4NCj4g
PiANCj4gPiBDb25zb2xpZGF0ZSB0aGUgbGFzdCB0d28gZnVuY3Rpb24gcGFyYW1ldGVycyBvZiBy
ZWxvY2F0ZV9rZXJuZWwoKSBpbnRvIGENCj4gPiBzaW5nbGUgJ3Vuc2lnbmVkIGludCcgYW5kIHBh
c3MgZmxhZ3MgaW5zdGVhZC4NCj4gPiANCj4gPiBPbmx5IGNvbnNvbGlkYXRlIHRoZSA2NC1iaXQg
dmVyc2lvbiBhbGJlaXQgdGhlIHNpbWlsYXIgb3B0aW1pemF0aW9uIGNhbg0KPiA+IGJlIGRvbmUg
Zm9yIHRoZSAzMi1iaXQgdmVyc2lvbiB0b28uICBEb24ndCBib3RoZXIgY2hhbmdpbmcgdGhlIDMy
LWJpdA0KPiA+IHZlcnNpb24gd2hpbGUgaXQgaXMgd29ya2luZyAoc2luY2UgYXNzZW1ibHkgY29k
ZSBjaGFuZ2UgaXMgcmVxdWlyZWQpLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFu
ZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYvaW5jbHVkZS9h
c20va2V4ZWMuaCAgICAgICAgIHwgMTIgKysrKysrKysrKy0tDQo+ID4gIGFyY2gveDg2L2tlcm5l
bC9tYWNoaW5lX2tleGVjXzY0LmMgICB8IDIyICsrKysrKysrKysrKystLS0tLS0tLS0NCj4gPiAg
YXJjaC94ODYva2VybmVsL3JlbG9jYXRlX2tlcm5lbF82NC5TIHwgMTkgKysrKysrKysrLS0tLS0t
LS0tLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9u
cygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rZXhlYy5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va2V4ZWMuaA0KPiA+IGluZGV4IGYyYWQ3NzkyOWQ2ZS4u
NWYwOTc5MWRjNGU5IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2tleGVj
LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rZXhlYy5oDQo+ID4gQEAgLTEzLDYg
KzEzLDE1IEBADQo+ID4gICMgZGVmaW5lIEtFWEVDX0RFQlVHX0VYQ19IQU5ETEVSX1NJWkUJNiAv
KiBQVVNISSwgUFVTSEksIDItYnl0ZSBKTVAgKi8NCj4gPiAgI2VuZGlmDQo+ID4gIA0KPiA+ICsj
aWZkZWYgQ09ORklHX1g4Nl82NA0KPiA+ICsNCj4gPiArI2luY2x1ZGUgPGxpbnV4L2JpdHMuaD4N
Cj4gPiArDQo+ID4gKyNkZWZpbmUgUkVMT0NfS0VSTkVMX1BSRVNFUlZFX0NPTlRFWFQJQklUKDAp
DQo+ID4gKyNkZWZpbmUgUkVMT0NfS0VSTkVMX0hPU1RfTUVNX0FDVElWRQlCSVQoMSkNCj4gDQo+
IFRoaXMgaXNuJ3QgYXMgZGVzY3JpcHRpdmUgd2l0aCAiRU5DIiByZW1vdmVkIGZyb20gdGhlIG5h
bWUuIEl0J3MgYWxtb3N0DQo+IGxpa2UgeW91IHJlYWQgdGhpcyBhbmQgdGhpbmsgaXQgc2hvdWxk
IGFsd2F5cyBiZSAxIGJlY2F1c2UgdGhlIGtlcm5lbA0KPiBhbHdheXMgaGFzIGhvc3QgbWVtb3J5
IGFjdGl2ZS4NCg0KSGkgVG9tLA0KDQpUaGFua3MgZm9yIHJldmlldy4NCg0KUmlnaHQuICBJJ2xs
IGFkZCAiRU5DIiB0byB0aGUgbmFtZS4NCg0KPiANCj4gPiArDQo+ID4gKyNlbmRpZg0KPiA+ICsN
Cj4gPiAgIyBkZWZpbmUgS0VYRUNfQ09OVFJPTF9QQUdFX1NJWkUJNDA5Ng0KPiA+ICAjIGRlZmlu
ZSBLRVhFQ19DT05UUk9MX0NPREVfTUFYX1NJWkUJMjA0OA0KPiA+ICANCj4gPiBAQCAtMTIxLDgg
KzEzMCw3IEBAIHR5cGVkZWYgdW5zaWduZWQgbG9uZw0KPiA+ICByZWxvY2F0ZV9rZXJuZWxfZm4o
dW5zaWduZWQgbG9uZyBpbmRpcmVjdGlvbl9wYWdlLA0KPiA+ICAJCSAgIHVuc2lnbmVkIGxvbmcg
cGFfY29udHJvbF9wYWdlLA0KPiA+ICAJCSAgIHVuc2lnbmVkIGxvbmcgc3RhcnRfYWRkcmVzcywN
Cj4gPiAtCQkgICB1bnNpZ25lZCBpbnQgcHJlc2VydmVfY29udGV4dCwNCj4gPiAtCQkgICB1bnNp
Z25lZCBpbnQgaG9zdF9tZW1fZW5jX2FjdGl2ZSk7DQo+ID4gKwkJICAgdW5zaWduZWQgaW50IGZs
YWdzKTsNCj4gPiAgI2VuZGlmDQo+ID4gIGV4dGVybiByZWxvY2F0ZV9rZXJuZWxfZm4gcmVsb2Nh
dGVfa2VybmVsOw0KPiA+ICAjZGVmaW5lIEFSQ0hfSEFTX0tJTUFHRV9BUkNIDQo+ID4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvbWFjaGluZV9rZXhlY182NC5jDQo+ID4gaW5kZXggNjk3ZmI5OTQwNmU2Li4yNWNmZjM4ZjVl
NjAgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva2VybmVsL21hY2hpbmVfa2V4ZWNfNjQuYw0K
PiA+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCj4gPiBAQCAtMzg0
LDE2ICszODQsMTAgQEAgdm9pZCBfX25vY2ZpIG1hY2hpbmVfa2V4ZWMoc3RydWN0IGtpbWFnZSAq
aW1hZ2UpDQo+ID4gIHsNCj4gPiAgCXVuc2lnbmVkIGxvbmcgcmVsb2Nfc3RhcnQgPSAodW5zaWdu
ZWQgbG9uZylfX3JlbG9jYXRlX2tlcm5lbF9zdGFydDsNCj4gPiAgCXJlbG9jYXRlX2tlcm5lbF9m
biAqcmVsb2NhdGVfa2VybmVsX3B0cjsNCj4gPiAtCXVuc2lnbmVkIGludCBob3N0X21lbV9lbmNf
YWN0aXZlOw0KPiA+ICsJdW5zaWduZWQgaW50IHJlbG9jYXRlX2tlcm5lbF9mbGFnczsNCj4gPiAg
CWludCBzYXZlX2Z0cmFjZV9lbmFibGVkOw0KPiA+ICAJdm9pZCAqY29udHJvbF9wYWdlOw0KPiA+
ICANCj4gPiAtCS8qDQo+ID4gLQkgKiBUaGlzIG11c3QgYmUgZG9uZSBiZWZvcmUgbG9hZF9zZWdt
ZW50cygpIHNpbmNlIGlmIGNhbGwgZGVwdGggdHJhY2tpbmcNCj4gPiAtCSAqIGlzIHVzZWQgdGhl
biBHUyBtdXN0IGJlIHZhbGlkIHRvIG1ha2UgYW55IGZ1bmN0aW9uIGNhbGxzLg0KPiA+IC0JICov
DQo+ID4gLQlob3N0X21lbV9lbmNfYWN0aXZlID0gY2NfcGxhdGZvcm1faGFzKENDX0FUVFJfSE9T
VF9NRU1fRU5DUllQVCk7DQo+ID4gLQ0KPiA+ICAjaWZkZWYgQ09ORklHX0tFWEVDX0pVTVANCj4g
PiAgCWlmIChpbWFnZS0+cHJlc2VydmVfY29udGV4dCkNCj4gPiAgCQlzYXZlX3Byb2Nlc3Nvcl9z
dGF0ZSgpOw0KPiA+IEBAIC00MjcsNiArNDIxLDE3IEBAIHZvaWQgX19ub2NmaSBtYWNoaW5lX2tl
eGVjKHN0cnVjdCBraW1hZ2UgKmltYWdlKQ0KPiA+ICAJICovDQo+ID4gIAlyZWxvY2F0ZV9rZXJu
ZWxfcHRyID0gY29udHJvbF9wYWdlICsgKHVuc2lnbmVkIGxvbmcpcmVsb2NhdGVfa2VybmVsIC0g
cmVsb2Nfc3RhcnQ7DQo+ID4gIA0KPiA+ICsJcmVsb2NhdGVfa2VybmVsX2ZsYWdzID0gMDsNCj4g
PiArCWlmIChpbWFnZS0+cHJlc2VydmVfY29udGV4dCkNCj4gPiArCQlyZWxvY2F0ZV9rZXJuZWxf
ZmxhZ3MgfD0gUkVMT0NfS0VSTkVMX1BSRVNFUlZFX0NPTlRFWFQ7DQo+ID4gKw0KPiA+ICsJLyoN
Cj4gPiArCSAqIFRoaXMgbXVzdCBiZSBkb25lIGJlZm9yZSBsb2FkX3NlZ21lbnRzKCkgc2luY2Ug
aWYgY2FsbCBkZXB0aCB0cmFja2luZw0KPiA+ICsJICogaXMgdXNlZCB0aGVuIEdTIG11c3QgYmUg
dmFsaWQgdG8gbWFrZSBhbnkgZnVuY3Rpb24gY2FsbHMuDQo+ID4gKwkgKi8NCj4gPiArCWlmIChj
Y19wbGF0Zm9ybV9oYXMoQ0NfQVRUUl9IT1NUX01FTV9FTkNSWVBUKSkNCj4gPiArCQlyZWxvY2F0
ZV9rZXJuZWxfZmxhZ3MgfD0gUkVMT0NfS0VSTkVMX0hPU1RfTUVNX0FDVElWRTsNCj4gPiArDQo+
ID4gIAkvKg0KPiA+ICAJICogVGhlIHNlZ21lbnQgcmVnaXN0ZXJzIGFyZSBmdW5ueSB0aGluZ3Ms
IHRoZXkgaGF2ZSBib3RoIGENCj4gPiAgCSAqIHZpc2libGUgYW5kIGFuIGludmlzaWJsZSBwYXJ0
LiAgV2hlbmV2ZXIgdGhlIHZpc2libGUgcGFydCBpcw0KPiA+IEBAIC00NDMsOCArNDQ4LDcgQEAg
dm9pZCBfX25vY2ZpIG1hY2hpbmVfa2V4ZWMoc3RydWN0IGtpbWFnZSAqaW1hZ2UpDQo+ID4gIAlp
bWFnZS0+c3RhcnQgPSByZWxvY2F0ZV9rZXJuZWxfcHRyKCh1bnNpZ25lZCBsb25nKWltYWdlLT5o
ZWFkLA0KPiA+ICAJCQkJCSAgIHZpcnRfdG9fcGh5cyhjb250cm9sX3BhZ2UpLA0KPiA+ICAJCQkJ
CSAgIGltYWdlLT5zdGFydCwNCj4gPiAtCQkJCQkgICBpbWFnZS0+cHJlc2VydmVfY29udGV4dCwN
Cj4gPiAtCQkJCQkgICBob3N0X21lbV9lbmNfYWN0aXZlKTsNCj4gPiArCQkJCQkgICByZWxvY2F0
ZV9rZXJuZWxfZmxhZ3MpOw0KPiA+ICANCj4gPiAgI2lmZGVmIENPTkZJR19LRVhFQ19KVU1QDQo+
ID4gIAlpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQpDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUyBiL2FyY2gveDg2L2tlcm5lbC9yZWxvY2F0
ZV9rZXJuZWxfNjQuUw0KPiA+IGluZGV4IGVhNjA0ZjRkMGI1Mi4uMWRmYTMyM2IzM2Q1IDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUw0KPiA+ICsr
KyBiL2FyY2gveDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUw0KPiA+IEBAIC02Niw4ICs2
Niw3IEBAIFNZTV9DT0RFX1NUQVJUX05PQUxJR04ocmVsb2NhdGVfa2VybmVsKQ0KPiA+ICAJICog
JXJkaSBpbmRpcmVjdGlvbl9wYWdlDQo+ID4gIAkgKiAlcnNpIHBhX2NvbnRyb2xfcGFnZQ0KPiA+
ICAJICogJXJkeCBzdGFydCBhZGRyZXNzDQo+ID4gLQkgKiAlcmN4IHByZXNlcnZlX2NvbnRleHQN
Cj4gPiAtCSAqICVyOCAgaG9zdF9tZW1fZW5jX2FjdGl2ZQ0KPiA+ICsJICogJXJjeCBmbGFnczog
UkVMT0NfS0VSTkVMXyoNCj4gPiAgCSAqLw0KPiA+ICANCj4gPiAgCS8qIFNhdmUgdGhlIENQVSBj
b250ZXh0LCB1c2VkIGZvciBqdW1waW5nIGJhY2sgKi8NCj4gPiBAQCAtMTExLDcgKzExMCw3IEBA
IFNZTV9DT0RFX1NUQVJUX05PQUxJR04ocmVsb2NhdGVfa2VybmVsKQ0KPiA+ICAJLyogc2F2ZSBp
bmRpcmVjdGlvbiBsaXN0IGZvciBqdW1waW5nIGJhY2sgKi8NCj4gPiAgCW1vdnEJJXJkaSwgcGFf
YmFja3VwX3BhZ2VzX21hcCglcmlwKQ0KPiA+ICANCj4gPiAtCS8qIFNhdmUgdGhlIHByZXNlcnZl
X2NvbnRleHQgdG8gJXIxMSBhcyBzd2FwX3BhZ2VzIGNsb2JiZXJzICVyY3guICovDQo+ID4gKwkv
KiBTYXZlIHRoZSBmbGFncyB0byAlcjExIGFzIHN3YXBfcGFnZXMgY2xvYmJlcnMgJXJjeC4gKi8N
Cj4gPiAgCW1vdnEJJXJjeCwgJXIxMQ0KPiA+ICANCj4gPiAgCS8qIHNldHVwIGEgbmV3IHN0YWNr
IGF0IHRoZSBlbmQgb2YgdGhlIHBoeXNpY2FsIGNvbnRyb2wgcGFnZSAqLw0KPiA+IEBAIC0xMjks
OSArMTI4LDggQEAgU1lNX0NPREVfU1RBUlRfTE9DQUxfTk9BTElHTihpZGVudGl0eV9tYXBwZWQp
DQo+ID4gIAkvKg0KPiA+ICAJICogJXJkaQlpbmRpcmVjdGlvbiBwYWdlDQo+ID4gIAkgKiAlcmR4
IHN0YXJ0IGFkZHJlc3MNCj4gPiAtCSAqICVyOCBob3N0X21lbV9lbmNfYWN0aXZlDQo+ID4gIAkg
KiAlcjkgcGFnZSB0YWJsZSBwYWdlDQo+ID4gLQkgKiAlcjExIHByZXNlcnZlX2NvbnRleHQNCj4g
PiArCSAqICVyMTEgZmxhZ3M6IFJFTE9DX0tFUk5FTF8qDQo+ID4gIAkgKiAlcjEzIG9yaWdpbmFs
IENSNCB3aGVuIHJlbG9jYXRlX2tlcm5lbCgpIHdhcyBpbnZva2VkDQo+ID4gIAkgKi8NCj4gPiAg
DQo+ID4gQEAgLTIwNCw3ICsyMDIsNyBAQCBTWU1fQ09ERV9TVEFSVF9MT0NBTF9OT0FMSUdOKGlk
ZW50aXR5X21hcHBlZCkNCj4gPiAgCSAqIGVudHJpZXMgdGhhdCB3aWxsIGNvbmZsaWN0IHdpdGgg
dGhlIG5vdyB1bmVuY3J5cHRlZCBtZW1vcnkNCj4gPiAgCSAqIHVzZWQgYnkga2V4ZWMuIEZsdXNo
IHRoZSBjYWNoZXMgYmVmb3JlIGNvcHlpbmcgdGhlIGtlcm5lbC4NCj4gPiAgCSAqLw0KPiA+IC0J
dGVzdHEJJXI4LCAlcjgNCj4gPiArCXRlc3RxCSRSRUxPQ19LRVJORUxfSE9TVF9NRU1fQUNUSVZF
LCAlcjExDQo+IA0KPiBIbW1tLi4uIGNhbid0IGJvdGggYml0cyBiZSBzZXQgYXQgdGhlIHNhbWUg
dGltZT8gSWYgc28sIHRoZW4gdGhpcyB3aWxsDQo+IGZhaWwuIFRoaXMgc2hvdWxkIGJlIGRvaW5n
IGJpdCB0ZXN0cyBub3cuDQoNClRFU1QgaW5zdHJ1Y3Rpb24gcGVyZm9ybXMgbG9naWNhbCBBTkQg
b2YgdGhlIHR3byBvcGVyYW5kcywgdGhlcmVmb3JlIHRoZQ0KYWJvdmUgZXF1YWxzIHRvOg0KDQoJ
c2V0IFpGIGlmICJSMTEgQU5EIEJJVCgxKSA9PSAwIi4NCg0KV2hldGhlciB0aGVyZSdzIGFueSBv
dGhlciBiaXRzIHNldCBpbiBSMTEgZG9lc24ndCBpbXBhY3QgdGhlIGFib3ZlLCByaWdodD8NCiAN
Cj4gDQo+ID4gIAlqeiAuTHNtZV9vZmYNCj4gPiAgCXdiaW52ZA0KPiA+ICAuTHNtZV9vZmY6DQo+
ID4gQEAgLTIyMCw3ICsyMTgsNyBAQCBTWU1fQ09ERV9TVEFSVF9MT0NBTF9OT0FMSUdOKGlkZW50
aXR5X21hcHBlZCkNCj4gPiAgCW1vdnEJJWNyMywgJXJheA0KPiA+ICAJbW92cQklcmF4LCAlY3Iz
DQo+ID4gIA0KPiA+IC0JdGVzdHEJJXIxMSwgJXIxMQkvKiBwcmVzZXJ2ZV9jb250ZXh0ICovDQo+
ID4gKwl0ZXN0cQkkUkVMT0NfS0VSTkVMX1BSRVNFUlZFX0NPTlRFWFQsICVyMTENCj4gPiAgCWpu
eiAuTHJlbG9jYXRlDQo+ID4gIA0KPiA+ICAJLyoNCj4gPiBAQCAtMjczLDcgKzI3MSw3IEBAIFNZ
TV9DT0RFX1NUQVJUX0xPQ0FMX05PQUxJR04oaWRlbnRpdHlfbWFwcGVkKQ0KPiA+ICAJQU5OT1RB
VEVfTk9FTkRCUg0KPiA+ICAJYW5kcQkkUEFHRV9NQVNLLCAlcjgNCj4gPiAgCWxlYQlQQUdFX1NJ
WkUoJXI4KSwgJXJzcA0KPiA+IC0JbW92bAkkMSwgJXIxMWQJLyogRW5zdXJlIHByZXNlcnZlX2Nv
bnRleHQgZmxhZyBpcyBzZXQgKi8NCj4gPiArCW1vdmwJJFJFTE9DX0tFUk5FTF9QUkVTRVJWRV9D
T05URVhULCAlcjExZAkvKiBFbnN1cmUgcHJlc2VydmVfY29udGV4dCBmbGFnIGlzIHNldCAqLw0K
PiANCj4gQW5kIHRoaXMgd2lsbCBjbGVhciBhbnkgdmFsdWUgdGhhdCB3YXMgaW4gcjExIHZzIHNl
dHRpbmcgYSBzaW5nbGUgYml0Lg0KPiBOb3Qgc3VyZSBpdCBjdXJyZW50bHkgaGFzIGFueSBlZmZl
Y3QgYmVjYXVzZSByOCAod2hlcmUgdGhlIG1lbW9yeQ0KPiBlbmNyeXB0aW9uIHNldHRpbmcgd2Fz
IGhlbGQpIGlzIG1vZGlmaWVkIGp1c3QgYmVmb3JlIHRoaXMuIEJ1dCBpZiBhbnkNCj4gYml0cyBh
cmUgYWRkZWQgaW4gdGhlIGZ1dHVyZSB0aGF0IGFyZSBuZWVkZWQgcGFzdCBoZXJlLCB0aGlzIHdp
bGwgYmUgYQ0KPiBwcm9ibGVtLg0KDQpSaWdodC4gIEl0J3MganVzdCBmb3IgdGhlDQoNCgljYWxs
IHN3YXBfcGFnZXMNCg0KcmlnaHQgYWZ0ZXIgaXQuICBOb3RoaW5nIGVsc2UgbGF0ZXIgdXNlcyBS
RUxPQ19LRVJORUxfUFJFU0VSVkVfQ09OVEVYVCBvcg0KUkVMT0NfS0VSTkVMX0hPU1RfTUVNX0FD
VElWRS4NCg0KTWF5YmUgd2UgY2FuIGFkZCBhIGNvbW1lbnQgdG8gcmVtaW5kIHRoYXQgYWxsIG90
aGVyIGZsYWdzIGFyZSBub3QgcmVzdG9yZWQNCnNvIGlmIHNvbWVvbmUgd2FudHMgdG8gYWRkIGEg
bmV3IGJpdCBhbmQgdXNlIGl0IGF0IGEgbGF0ZXIgaGUvc2hlIGNhbiBzZWU/DQoNCgkvKg0KCSAq
IEVuc3VyZSBSRUxPQ19LRVJORUxfUFJFU0VSVkVfQ09OVEVYVCBmbGFnIGlzIHNldCBzbyBzd2Fw
X3BhZ2VzDQoJICogY2FuIGRvIHRoaW5ncyBjb3JyZWN0bHkuICBOb3RlIHRoaXMgZG9lc24ndCBy
ZXN0b3JlIGFueSBvdGhlcsKgDQoJICogUkVMT0NfS0VSTkVMXyogZmxhZ3MgdGhhdMKgd2VyZSBw
YXNzZWQgdG8gcmVsb2NhdGVfa2VybmVsKCkuDQoJICovDQo+IA0KPiA+ICAJY2FsbAlzd2FwX3Bh
Z2VzDQo+ID4gIAltb3ZxCWtleGVjX3ZhX2NvbnRyb2xfcGFnZSglcmlwKSwgJXJheA0KPiA+ICAw
OglhZGRxCSR2aXJ0dWFsX21hcHBlZCAtIDBiLCAlcmF4DQo+ID4gQEAgLTMyMSw3ICszMTksNyBA
QCBTWU1fQ09ERV9TVEFSVF9MT0NBTF9OT0FMSUdOKHN3YXBfcGFnZXMpDQo+ID4gIAlVTldJTkRf
SElOVF9FTkRfT0ZfU1RBQ0sNCj4gPiAgCS8qDQo+ID4gIAkgKiAlcmRpIGluZGlyZWN0aW9uIHBh
Z2UNCj4gPiAtCSAqICVyMTEgcHJlc2VydmVfY29udGV4dA0KPiA+ICsJICogJXIxMSBmbGFnczog
UkVMT0NfS0VSTkVMXyoNCj4gPiAgCSAqLw0KPiA+ICAJbW92cQklcmRpLCAlcmN4CS8qIFB1dCB0
aGUgaW5kaXJlY3Rpb25fcGFnZSBpbiAlcmN4ICovDQo+ID4gIAl4b3JsCSVlZGksICVlZGkNCj4g
PiBAQCAtMzU3LDcgKzM1NSw4IEBAIFNZTV9DT0RFX1NUQVJUX0xPQ0FMX05PQUxJR04oc3dhcF9w
YWdlcykNCj4gPiAgCW1vdnEJJXJkaSwgJXJkeCAgICAvKiBTYXZlIGRlc3RpbmF0aW9uIHBhZ2Ug
dG8gJXJkeCAqLw0KPiA+ICAJbW92cQklcnNpLCAlcmF4ICAgIC8qIFNhdmUgc291cmNlIHBhZ2Ug
dG8gJXJheCAqLw0KPiA+ICANCj4gPiAtCXRlc3RxCSVyMTEsICVyMTEgICAgLyogT25seSBhY3R1
YWxseSBzd2FwIGZvciA6OnByZXNlcnZlX2NvbnRleHQgKi8NCj4gPiArCS8qIE9ubHkgYWN0dWFs
bHkgc3dhcCBmb3IgOjpwcmVzZXJ2ZV9jb250ZXh0ICovDQo+ID4gKwl0ZXN0cQkkUkVMT0NfS0VS
TkVMX1BSRVNFUlZFX0NPTlRFWFQsICVyMTENCj4gDQo+IERpdHRvIGhlcmUgb24gdGhlIGJpdCB0
ZXN0aW5nLg0KDQpJIGRvbid0IHNlZSBhbnkgcHJvYmxlbT8gIFBsZWFzZSBzZWUgYWJvdmUuDQo=

