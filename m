Return-Path: <kvm+bounces-61188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C93C0F4D3
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7887C5612B5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E00304BA8;
	Mon, 27 Oct 2025 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QxAzjQeS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390F313522;
	Mon, 27 Oct 2025 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761582217; cv=fail; b=bL3wW2+YndaLlIObrWTbx4MJz1+x6vY3nBUI6NahKzewxOaaXLb0cdNwHVHrSwQB3leFFtqwtgH0oPCRDiMMoI8GCE50Px0lUibfZ9EvnLC+oqGOFXKbFNdB4HSGUdhfLwWsZW5CaQVo3kWq7HuVKJG1aJtxYwsEDYx8eAPEoV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761582217; c=relaxed/simple;
	bh=Lue9ZIOC/LVYkYCIsADjFuefNUMUuCbsTacPYOImFkA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HYvjgM5GDXj7SGEelbH/Ji7JcFaQkxWsSwBcc+PNVayBhqppUNi27FVbMliOC2Ikzz/AqokIPQtleWQQaY+IgZuqjrbudscH4ESJC9hL+dSLWr172biDVqeve/tORpEK3SGl0LMXGanzFU8cDImcVdzoFoKEkT19fj8EODAaHF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QxAzjQeS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761582216; x=1793118216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lue9ZIOC/LVYkYCIsADjFuefNUMUuCbsTacPYOImFkA=;
  b=QxAzjQeSzoOLFBbMV8nOeoUxqImLHGNmGWXLdn4GPUPUU7/7dKR5wDfh
   7yFnT6CZV6GILBngWC+bg/DGXYv/RE3I/yxZUYyghCAGDDAvsRg9l23wL
   SqkJotkg68CLLWtgRUAcaeEalZfm0J8oB+9iHm8GuLLClYzusLDDErslS
   /G9+hIVoIkfm/FYXOrqn6wgzon2i23FPrIRJ+IdAulCaMtv9szsfBnw9g
   1v7ckDo0S8i/8ajnLpVX5cugsiRDjlPVN+H4w2W9Fq5sLUVcgVlSN5d0U
   zn/0+FAdzyM6wb+4QBuF8ZNL8sU3QkdKTQtuAKT4eiSKMdEiFXOZ4N2ou
   g==;
X-CSE-ConnectionGUID: kNGFWZn+SA2dFaJT7iaTtA==
X-CSE-MsgGUID: oMMDOX0ySV+bnOHQRubuNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81298675"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="81298675"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 09:23:35 -0700
X-CSE-ConnectionGUID: QugKIJ1MQq2qAFRv0aSzVQ==
X-CSE-MsgGUID: hyDDsxq+TcajWufnPESiAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="184783940"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 09:23:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 09:23:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 09:23:34 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.24)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 09:23:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l8GQwTKuJkVIR7YPc0P9MA+FuI9NE8mv4K+nCV1hnkVFpR5D9Bnpa7xqWVUIMYQBmcYD9BLJLlqV+gQEV0+14fIL2wguZYAIoYE9wfmGqNrGuEoPJ40Sm+mHxLmTMSRH3MUg5R4/Llu9OMdkTGzxyYuj4ItTCNJZLIqpfk7ha+EJG2ooNGIJfWCA1zPkcnbcxaE5fMThncRUF5hfs/zyozWJfh+k3uM+th2ObMO4g37WQNMG8wXN/Kfll0MZvYX4Sv+Zpuh103CLQp9vVfy4wqqa38K8ESJfpP/1iV62xWpvQHqPFV8k+md681ubEElWEnvx6Vk9QXv1ScU7dxgkBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lue9ZIOC/LVYkYCIsADjFuefNUMUuCbsTacPYOImFkA=;
 b=xJrE6zByVopcGs+kf42XlXSH6iq9+CZg0uXKBI0KpXF1+t25D5aMZZ/dvx2cMajWaF5IKCMtDS/3kVR6816nAfHEPLTBob1ANa4u2k1kcHKAFdkQdrYsQumXx+ARTyYBF594THSEmJvwHHEc5ANT5lE3SNBN3qiGOtwswQo6ooV490aL6U4gPrY9b3f1taM1M3gWseqF9uae4gti5KVCNetA88kNGmB+SjbhCIU6crL6dmrg1WXUax51PqkybCyWCN0EuM79kjmjSbjc44s0FAJ+6aqNNc0RC+bzs7SSpJtUnmFIufOZ0RbBO6FKPV9RSWnq3RqE8JUWMadHDh2IqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS4PPFDBB3A2AD4.namprd11.prod.outlook.com (2603:10b6:f:fc02::57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 16:23:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 16:23:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rjYKVDrbStp0ijSyOb5IRdm7TVayCAgAAVmwCAAQScAA==
Date: Mon, 27 Oct 2025 16:23:28 +0000
Message-ID: <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
	 <20250901160930.1785244-5-pbonzini@redhat.com>
	 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
	 <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
In-Reply-To: <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS4PPFDBB3A2AD4:EE_
x-ms-office365-filtering-correlation-id: 51686fb5-fcd4-44cd-c33a-08de157529da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cjhNdmg2cnUvVDNtM0RBQzQzRldDOHp0eUVBMHVNY0F5d251ZEd2ZEdWS0dY?=
 =?utf-8?B?MXRTK0FiWnVtOUlhQjdURmdjY04zMGMxdXdoc2xmV2UxL2hLK0twMENrYnVz?=
 =?utf-8?B?UHF3TU5LMkdPRWZRNWhQakxFRzRmWFg2U0FHaVY5eVQvUlFkcnFIaXJwSUdu?=
 =?utf-8?B?SWhMbnJDZEVORXFkNGFYQ3k5OFkrM0w5aEpEUTVMTHNkdEp2UVBjZTJkTmQ2?=
 =?utf-8?B?bFlmL0ZOTjRzbGpOczFBT2tkdmlpdE1BZEYwQWpBb3A1NHNsNzY4aUI2Q3cr?=
 =?utf-8?B?ZkZmVkU5UDVsYlJjalFEMkNqOEMzc2hOTnh1NXJoWHc3b1FKNVRXckdqU2FY?=
 =?utf-8?B?aktzSnBQSVdiZjYxUWE5d0w0TzhSVnVzU05yRE1EL05xSW1zL1Rjc094VExM?=
 =?utf-8?B?S3RMKzcxaHFoakVjdmZoeU5FTzZqVWtDTlg2aEkrbmpGRm1xL3VmbUErU3Er?=
 =?utf-8?B?TmpaRFlzL0p6U0R3TlI1ZUZGZVpINlVEcnNHcjkzeXk1eVVmK1hvaXhRNkNr?=
 =?utf-8?B?MWVsVk1Gelgxb3FIbnEwcWhWYnlaUDMwRGZVOHhRU3JrSXVDUjV6TVRJWXN1?=
 =?utf-8?B?NjhpeE1HQWFTM2poa0VXeU5uWTdQOE5mbGQ5M1BlU1pUODR3Yk95VVlrVCtD?=
 =?utf-8?B?OFczOEZXN2d0eXRWY3dXL1o2Z2xSV0JQd3k1SisvQXJvRXFRaFp0S1lxdXNz?=
 =?utf-8?B?cjhBMmxEek4wZ3JKWDZHb09NNjcvbHpGME51UjNQb0xSVU41REIxQ2lmcHpa?=
 =?utf-8?B?ZjMrcFBaYkhsODhmRFNOWHhoR0w1SGd5cDlCUVBrMDllOEd0Sm1LTWVrTFIx?=
 =?utf-8?B?cUdWdXBpbDAvbWU0bDBYZmZ4aHNIQ1pZRGFJdDBFV3lidHpmNEFCQnVWT25R?=
 =?utf-8?B?Mm90WHZWQ0w5enpya2htaDhuN29YOHhiWUhZWVFsazQ0OGFTZmxDcGFOQlV4?=
 =?utf-8?B?d1lZZWl4VlUxM0dPSnUvM3UrMHl4aGRkY05LZWVTL1FLcnRiUnBvUlFHTm5k?=
 =?utf-8?B?bHMxNVc5Um1oQWtVQUc2b1lVMXJWL3JWMGtTMEpHbjNQUkswMk9ReUhONHdx?=
 =?utf-8?B?eHZPNWdjaEYrYnRoQzdrS1l3N2ZIV3NNL3p5SXJiQnJWTEN6b25JVEJFS1U0?=
 =?utf-8?B?ekRlbFFPNnBzaDRDU3dQMzdkSUxLNDdoS2dUdk4yUll4M3VZd0FEVUZ5OE5T?=
 =?utf-8?B?KythVmhwT0xVYWpPclpXRjQzN2JmR3I4dk9RVWJUb3NCRVR1VHk0SU9Tb21m?=
 =?utf-8?B?d2VzbkwyQTI3enVRcVViZ0hGU20yODBES0VRTk0zdUMwMCtQUlVIemMzMEtn?=
 =?utf-8?B?WWdKQVdPTm1xWndtdXNmK1FlSHJFbmZGVWJlYjVONlBZWWk0SkhMeEkzTXpE?=
 =?utf-8?B?elpnT3NDc1VqVkFTeDZCSUpGK2hvcWdYWFMzcXEyVit6dmZJOEVoV3Zha0tu?=
 =?utf-8?B?MmRpVTdnZk96aStLT1luUWxOMnVSMXJLRDRldm1rR2x0ZFY1Vk02am83UUxQ?=
 =?utf-8?B?YW4wbnppa3p6eUV3bmhUYy9lcFBmSTBIbjJybDZQMlVFU0E1RVloL29WRTJr?=
 =?utf-8?B?Q2paM2dyM2JzR0JIbEM1YVIwVjgvOGp1VjdZWERMQk5HYXVtRnhMRCs2eHlH?=
 =?utf-8?B?Q2dJZEt0UnlBaFhwb3ovaXB5eEFCdVhZbnVsYVRsQmRJYVhWNHQ4UkdMUjZy?=
 =?utf-8?B?WDFGUE5yS0hiQ1JpajdvdzVNWmtaa1lJN3dyeWxBMzFCVE16YzVBR2dEVU9W?=
 =?utf-8?B?UjBWR0g2RkhKRUdlU1YvU0ZyWS9WbUxCK214SGlnYzNRdnVyTks3Y0M2YkF6?=
 =?utf-8?B?Tmw1OUJIc1BYSS9pRXJmZmlNNTVJTE1OS3VhcDUyRHZESk1BTlZrNmJNNHUy?=
 =?utf-8?B?S2cvbmN2M2hNcXMxMyt5Z25POXk4Q0RUYWJtRExZN1ZhOXpjcWRKUVN6ZWlC?=
 =?utf-8?B?RHU5WFFWWWl6THc4dG1WZE9IYUpjOXFCUWhKRjloYXJGSDJ5RWo1WE55Mk9h?=
 =?utf-8?B?cUdFSVN4NEZlT25jazhzYllGZ3JmbUZWN0xqY2hzWlRndUZzK3NNTkFRdml2?=
 =?utf-8?Q?qBUO3G?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDZ2aEsrSlNCVjNUMGt1dEZMN1FKUFozRGRBa3FLVTB1Y05uTTE3d3lYQysy?=
 =?utf-8?B?eVlyamIxTDBzaTFMSGdmUnkwZUFiL0U2NGdGcFROOW8xeVY1UUh1THlIQVdC?=
 =?utf-8?B?UzJVNlkrdUVodm9mMWV2MjNMUzhZNldGbFNnMWhBaVZKdEhrdkxHaVVkZ2Zl?=
 =?utf-8?B?dE1KTFFSdHZSemxVRjNJNHpIUXNPS2cvNWh5dWNMZ21qQUVMMzR0ZkFWMTli?=
 =?utf-8?B?Z0ZGN3hZbm5MNlo3VnJkMlpJNkgwa096Z2M1NWlka0FOUnVnTFZXRlRjdTNK?=
 =?utf-8?B?a0tIS09PNk1xODAwVVZ2VXNlem1QUzFMcGhtL21wems1R0xrUCtyc3BmSGFS?=
 =?utf-8?B?ZTZNaUVaYlo4eVNuYlByUkQxeTltcTNjNUNVQTExdlFvWXZndHRhekFCdXNU?=
 =?utf-8?B?Q29qTkpvWEZSUmluYjl3SWJHTG52UzE0bmJwcVYxYllib25lZjN3OExjMFpx?=
 =?utf-8?B?Nm5RZElnbXg2NjFkdFRmRVJiRkdVa3VyeHdNYUxOQXlrbU11T0lQSnc0U3JW?=
 =?utf-8?B?WlN3SW8rQm4zcEFKMEs5TjdvSTlnRzd3ZTl2QnJoV3dOZWpzTDVLQzJLcDRR?=
 =?utf-8?B?NldWTC9vSW4rY29veVVBOW0yRFhaNnFXMmJwVGZpbzlWOFJWYWlhRldReGJo?=
 =?utf-8?B?QnR0dHFVQnY5MzJwQmZteEkyU21KVDBqeVFoM0tNUnVsUkxsRnJLYXFlWkRq?=
 =?utf-8?B?OU05NG92c3gvT2llNnVqbVZLWDduQi84cnlMQ1N6Z3JtSndPeTU5V0pLL1Qw?=
 =?utf-8?B?TGV6aG0wRFNqbHJnbXVMeDR2eFJVQnFiNWM1RkhLb2FEY1Bjc1ZnM096aXRY?=
 =?utf-8?B?dGVLRnVUaGhPTEJkQXQ0dHNlSERsbXdVQlpDRmhVckZCck1PenJycW9rVWVF?=
 =?utf-8?B?ZlBoYmxEVStxczdhNWp4dXFhVGhwQ0pwL0xiS1pkbDV2R083Q3RxUm5pOSt6?=
 =?utf-8?B?L1JtYVhhUjhrOWQ4aERxYlMvaldpSmZtOG1pelNZSExtak1vcUNGL0haQWZq?=
 =?utf-8?B?NUtHTXRna3paREIrTE9lTEdIL1NhUGRUSm8wSWVsSmYvMURMSHg5SnAzUnV6?=
 =?utf-8?B?UmFIVFlqSDFNdTNwMXk0dHVGa08vUXorYTZSbW1zc1hLSVFGamRFQkFzbjk5?=
 =?utf-8?B?dG0xaG5FTTUrZHlXYzNOeWIwQVh1cHArS3V4YnVoTDVRNFRQVncyNWtDY25o?=
 =?utf-8?B?MkRuTzQ0dTJvU09naHdvQS9XVitrM1ZDOThqMUpUL3F1TFRObER6OThNeG42?=
 =?utf-8?B?MFdCcUJDRzA0ZEl2RVJwQmNFb3JyOElNTGVvSG5RbFAvUUNTM1NyZHhSRUFI?=
 =?utf-8?B?L0VtekhjRzM0ZXZiVFdZdnRBL0sxWHdIWDJrbE1ZZEorUko1SXBpMm1Zbndo?=
 =?utf-8?B?M3RBdmJiVDZSTjRwbjhUbDdXbVQ2NTVEenRVMEMxWTdOdjVrVm5BYk0yUHBp?=
 =?utf-8?B?ejY4WXB1M0g4MGlVTzBRVC9HZVFiSnE4Um52bDJhU0xTZ0RpRmM0WUozVEtt?=
 =?utf-8?B?cmdaYU81RXBMWG9IRC9KcE9lNmlFVnJ5cVlHWWE0TUxqcmZGNDdNM2VMS1ZQ?=
 =?utf-8?B?ZWxYUDNVMVBXUmw1aHUxWXBzSDYreXBkZi8yZEFxTExjT0VoOGhWdjhCUkJu?=
 =?utf-8?B?M0ZuVU16cnlaS202SnhuNzRuR0NVd2pBdjJWK1FFTGxBOVN3dS9mNXI2ZlJn?=
 =?utf-8?B?ZlkvcWtRMmhlUjlLMEYxU1lCWHVOSlZQVGIrSkNLYkdOR0sycHo1LzNpV2V5?=
 =?utf-8?B?b0pwWFNQUkJ1WENqZkVxSityWngvWjNWZisxRUd6bEpxQmM5YWdENzhhMnNz?=
 =?utf-8?B?dGIySTBMa3JGZUhkVGIyditISkVxSUtPaUNvUmNYWVE4bEUxVFNqTWVlaDYv?=
 =?utf-8?B?NFE0UC9oSm1QZXNxVU5abTJPZDB4VHRQa3NXQXBYUm81Smp4bHB0QXNvc0JK?=
 =?utf-8?B?cmtENW15K1YvTHJYcEVGT003eTJpVnZObkNUeENYSUpWL205akt2RHRQN0dT?=
 =?utf-8?B?dHQvYXNQc2NFN0FVQWh3TVgwTlo0VWhpdi9QVVNHUmtvTHhIRmwzYWtrQkFs?=
 =?utf-8?B?VGRZSFp4WUhTbHZtNnhpUWY4S2l1MUJTUHFjbEJqU3MvNkhTdlpjWWEwMjZW?=
 =?utf-8?B?d1FZOVJIZWRsMVdmOG5qQU5UcTV2bVpzTmE3eGlNcFc4ZWl3a0VKajVlRmEr?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D8AAF6D5E5487418F16B9BCB803C9D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51686fb5-fcd4-44cd-c33a-08de157529da
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 16:23:29.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wGg8jE+O01KStWKA8EYl2icbVOAa5DcEpOD/SGPVVPobt6v3n1Lqe2Xr5zI8FDj5eEH65+ZDlJ33NV+LGFV0almzh4rWQP6gJ2F7Gup5uG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFDBB3A2AD4
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDAwOjUwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+IElJVUMsIGtlcm5lbCBkb2Vzbid0IGRvbmF0ZSBhbnkgb2YgaXQncyBhdmFpbGFibGUg
bWVtb3J5IHRvIFREWCBtb2R1bGUNCj4gPiBpZiBURFggaXMgbm90IGFjdHVhbGx5IGVuYWJsZWQg
KGkuZS4gaWYgImt2bS5pbnRlbC50ZHg9eSIga2VybmVsDQo+ID4gY29tbWFuZCBsaW5lIHBhcmFt
ZXRlciBpcyBtaXNzaW5nKS4NCj4gDQo+IFJpZ2h0IChmb3Igbm93IEtWTSBpcyB0aGUgb25seSBp
bi1rZXJuZWwgVERYIHVzZXIpLg0KPiANCj4gPiANCj4gPiBXaHkgaXMgaXQgdW5zYWZlIHRvIGFs
bG93IGtleGVjL2tkdW1wIGlmICJrdm0uaW50ZWwudGR4PXkiIGlzIG5vdA0KPiA+IHN1cHBsaWVk
IHRvIHRoZSBrZXJuZWw/DQo+IA0KPiBJdCBjYW4gYmUgcmVsYXhlZC7CoCBQbGVhc2Ugc2VlIHRo
ZSBhYm92ZSBxdW90ZWQgdGV4dCBmcm9tIHRoZSBjaGFuZ2Vsb2c6DQo+IA0KPiDCoD4gSXQncyBm
ZWFzaWJsZSB0byBmdXJ0aGVyIHJlbGF4IHRoaXMgbGltaXRhdGlvbiwgaS5lLiwgb25seSBmYWls
IGtleGVjDQo+IMKgPiB3aGVuIFREWCBpcyBhY3R1YWxseSBlbmFibGVkIGJ5IHRoZSBrZXJuZWwu
wqAgQnV0IHRoaXMgaXMgc3RpbGwgYSBoYWxmDQo+IMKgPiBtZWFzdXJlIGNvbXBhcmVkIHRvIHJl
c2V0dGluZyBURFggcHJpdmF0ZSBtZW1vcnkgc28ganVzdCBkbyB0aGUgc2ltcGxlc3QNCj4gwqA+
IHRoaW5nIGZvciBub3cuDQoNCkkgdGhpbmsgS1ZNIGNvdWxkIGJlIHJlLWluc2VydGVkIHdpdGgg
ZGlmZmVyZW50IG1vZHVsZSBwYXJhbXM/IEFzIGluLCB0aGUgdHdvDQppbi10cmVlIHVzZXJzIGNv
dWxkIGJlIHR3byBzZXBhcmF0ZSBpbnNlcnRpb25zIG9mIHRoZSBLVk0gbW9kdWxlLiBUaGF0IHNl
ZW1zDQpsaWtlIHNvbWV0aGluZyB0aGF0IGNvdWxkIGVhc2lseSBjb21lIHVwIGluIHRoZSByZWFs
IHdvcmxkLCBpZiBhIHVzZXIgcmUtaW5zZXJ0cw0KZm9yIHRoZSBwdXJwb3NlIG9mIGVuYWJsaW5n
IFREWC4gSSB0aGluayB0aGUgYWJvdmUgcXVvdGUgd2FzIHRhbGtpbmcgYWJvdXQNCmFub3RoZXIg
d2F5IG9mIGNoZWNraW5nIGlmIGl0J3MgZW5hYmxlZC4NCg==

