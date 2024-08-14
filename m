Return-Path: <kvm+bounces-24180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B834952158
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:36:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CAEC1F22A18
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325AC1BC076;
	Wed, 14 Aug 2024 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g9u8pN+E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBCD1BBBE4;
	Wed, 14 Aug 2024 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723656935; cv=fail; b=CkQg/B/6K8Zuqsl8TPv9QYHSM03vSVU+YdzE7/2Mn6N784PU7Fv6zerDE8OxGPD3ZD7p+g6hsNHig+AZREofWZni9tgGfl+hIosdxSWs41DxAGDbnSXDxCTvrfTT/3YSOLtVwkb5aCXCNHH7gYwSg7SXGrB9yKuNWUEcSM/CTXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723656935; c=relaxed/simple;
	bh=zN12jeUd8iJnTYmxfH9EBaS4fOGkCvVeY7G1YRXc40Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dltk6jqHenZMZT/lyFunnytxq26upA+nfR5VEANd0P5qum97ZFDKv4DUK4riV0A0qmPMxNPb5Cf4Od4XfRU7snMbDgbKk/7xV7I02dKIOiMPAsFHNVXGwls8tuj6fANxoBIzj6sQ+ytB3ld0FG36se2JrFl/b/6kHxEOuuDerzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g9u8pN+E; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723656934; x=1755192934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zN12jeUd8iJnTYmxfH9EBaS4fOGkCvVeY7G1YRXc40Y=;
  b=g9u8pN+E2R9/mLzBZWBH4syu8tI3lY1ynteZ9YwKQWtgnf3yCkE8tUmx
   DkxRqW0M1JNz5zJT4n0wEANvkDyicZJLI+bKgrlPCarpC+es/Qv1qi0kS
   xTOmKD8uh0SY3c04x89Tf/FpWWoWcW6IqnPv2uSmADXJaVtie2GWTaKgj
   h6hrqvxU4t2FpgKwc5Tb+h0riGYgDQ4noNwRzGMzbOOaWrFneAMM9lTWk
   FLowoUF2QaNE0Y708DwhEve0PEUT6Qz/owvJdv56r4SqQrhiX6dMhl2so
   YstbN2dfI+PmlMrWXX7N1nHUjdqnSCyYlH/yqxPri0tDPNzqpm6ZD5Uvk
   g==;
X-CSE-ConnectionGUID: bHF2RVdpSy2B/VkZeh2kgg==
X-CSE-MsgGUID: 9Ztm01ycRPyL9pw0130ptw==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="32518564"
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="32518564"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 10:35:32 -0700
X-CSE-ConnectionGUID: ORctoW7nSFK3NmfibA7eiw==
X-CSE-MsgGUID: P8BLjOSDSoaAqeJlQ4tRJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="59054065"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 10:35:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 10:35:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 10:35:29 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 10:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8p/YhBWYLA1tbk9tchw5sTzrqdVcH4GTZnyoNGeFKk4AdPbAdnqu9aVZSxWgccbvX988vWcDIpLSg9ggmQGeZOty3ROXn2wXAXTFD0sPWCxsnMdIyeuO7of4gcE43Xc3r2lbr2Sf8dGc65qP1ermKYQW15ODhKRlwKggB7qqhXEgC4h1dt/ef2qqjgCIXawpEL/wA1jpWITjKXAZkiRb6+aDjCLirjPoMnvdBd461dy+XZBStgb1q+yHCH4XsHxWk/RHlFT9HTnIj15hXmtwyA6Q/+drtpS9cBipAsPHUGZ/7COfTmSArloIX0G1e8n81XB8GuMI0x4Wbrbnm7DKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zN12jeUd8iJnTYmxfH9EBaS4fOGkCvVeY7G1YRXc40Y=;
 b=I9PU25MLUABoVoiNuLu7VBJmCIUYQUvUiR8BpGpA/+LZGqjo9f47jlZa1CrTKA07OVhQVxRGpjJFZ/NK7L6qrEHM2HSsNYbdQi2Oap7Mw0ei3kw5HwH6bTAJ6IRUu1KuGc8dDMceHViXL22HmRsC/LTt9m3rC6qOIcyniNfrzylZORGTXkCk4OQI4TnQCuMezEqzuTWRtZJoVjn+cO0ozF096x2Jc7kIMALjlwhohjb3UHX+bSwfniIpfyBZLMk5d3y42lrHHnvzsMk8hQAIPTYUOh5EKzI1dilGTiuTCN3UCF8R5Pz74YUFROdSazR0fD7M10QbyDbtXVyzKN1FUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6704.namprd11.prod.outlook.com (2603:10b6:806:267::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 17:35:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 17:35:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrIlD2UAgAA9hYCAAKAxAIAAB+kAgACfaICAAC8xgIAAQwEA
Date: Wed, 14 Aug 2024 17:35:26 +0000
Message-ID: <67f05b7fee1c81ef4b4be62785cfd9a36df9e4c0.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <ZrtEvEh4UJ6ZbPq5@chao-email>
	 <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com>
	 <Zrv+uHq2/mm4H58x@chao-email> <ZrwFWiSQc6pRHrCG@google.com>
	 <ZryLE+wNxhYHpyIP@chao-email> <Zryyqe6ibAR9h-yq@google.com>
In-Reply-To: <Zryyqe6ibAR9h-yq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6704:EE_
x-ms-office365-filtering-correlation-id: 9a1e65e9-e1e9-4c73-4fcd-08dcbc877c06
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NXgwallsTHlXL0p3dDNjTlBINTZlbjFXdTRRdkxmbzhXUzRoRTdobHJ2cEd0?=
 =?utf-8?B?NVlNak81NlYrbjlrbTFNYnUxSGpNSzJKUTg2SGNNQ3RUZ3dWNFlOSnNLR2kv?=
 =?utf-8?B?TG1RU1lsSFQxWGhqUDVoZ21TQVpEc2E2SXptN3p2a0lRSDBEeUhVTW9aRU9o?=
 =?utf-8?B?dEtkRUdBR1JHOGQ5OGZHcjNLbzRtYnVxN25pTjdjMDZJejNBNmlsTEVJaVhx?=
 =?utf-8?B?MDJxQklhbnljZjN0YlhaYkxscmZtaGR6eE5zeEVMMllhZi9pVDZocGsyeGh0?=
 =?utf-8?B?M0QreE1GR1I3WTBxUS9QTFJWTjh5dHdlYXhKeStaZFRTMjMxb1dKNFQrYVVa?=
 =?utf-8?B?MXFIMnFIdVZDcEhlUitzKzczTHhwcU55bEo2RUF2NlJGQ2p0RUhpT1Y1VjBk?=
 =?utf-8?B?eEZ6TkE5a3Nua29jRDA0N2pWajh2eXAwWDE3d3A0aFpKbGNvVktZVlJtaUpi?=
 =?utf-8?B?eTZzaXRrdkltckowZmoyVGpHNElHZG9yYThNNkhrRW02UzNtNXpiSnNFSU53?=
 =?utf-8?B?TGdaaFBCV1pHdGRHRDhSSzNoTnhMV2tPN3ppSUE3TkFpVHZWeTh6RnFDV1g5?=
 =?utf-8?B?MkZKcUh4c3c3dEgrMmtUMnB6U0FlRlZSM24rNm5NWG9JaGo5RDFhQzhzL2tH?=
 =?utf-8?B?M2duUGpCYldzOFRmRW8zNExpbHZ1b0F6STRtK0lpZHgwMGVJN3RtOUdKcTdp?=
 =?utf-8?B?TlM0S3VaeUZET3FSZyswUjdSaktTZysxcW1yUEQrZExpN29pOXFRcUlzdUdQ?=
 =?utf-8?B?UmxMQ3BYMGt6aVNHNGNMRTFSZW10dzVqQTFteXA5aGw5WmZOMUJucWt1eUk3?=
 =?utf-8?B?YzdNekVCa3BiT0duTXZoVGxqMmYzc0ExN21zUUtHUno2NDIvVGdiM1dDV242?=
 =?utf-8?B?R3hqS0lnU0JUQTRjdnBYWVZvTitQTERPYnpyUHJzaDJ3N0daK0o3Yld0NXJ3?=
 =?utf-8?B?V1NGK0xobWNkclgwRktkTE95dElyblROaVhqRm9xb2tpWTlKeE9pVzQzeXZT?=
 =?utf-8?B?OGVEcW1pNEtFcTNuUGJ4NXlxa1pYOWdaR1lsemtZeWNIYU1QN0JGR3d3eVlt?=
 =?utf-8?B?ZXVVZCtXOWNiN09zM0dOamRpeUZqSWFJTFQ4STdvVzdlb29sUXF3WHo2d3cx?=
 =?utf-8?B?ZEpFYVdoa2NQQUlQOXVpMUxkOWtrWmI2WmxYUnNOVFJ0MWozUDV0cStJMUU1?=
 =?utf-8?B?SUJ0UzhZclRDY0o3QUk5ZUFSUklWMnR1eEkyVDlmaktJemMxVGhnK2JhQmZ3?=
 =?utf-8?B?ZU9waHhGNTRqdlhrM2xzZDhNc3ZNWGZjdGk3RmNZaU5yVGRMb1R1Q3ZIOWVM?=
 =?utf-8?B?djJFMFZTZnpWT0NxeGJpd3JDZitabVY2UnZDOHhVNEFSRjB2c3V5ZHdNUzkz?=
 =?utf-8?B?Y0YyTEFEU1BRU1JkdmpFV1JGSlhVQ0srTmFobnVHY0thdy9Pci9XaDlremcr?=
 =?utf-8?B?cUZaVzU1NUh0eVJvSHBmMXpyZEtSd0ZGT3UzWHd6dGJCVWpEQlZsdUNJNzZh?=
 =?utf-8?B?NDNNdk9JTm5NNnZZS3ZyYlQyVkp5QW9wZjF5Q1NodVZJdnFpbUVZQnowc2Z3?=
 =?utf-8?B?b1pQK3VkZlBxUm1XRUF5RlA3VUl4MnQ1V0ZsaEdkcHZDRFRGSUExNzkxVHh6?=
 =?utf-8?B?WWNGR3ZCZ2lkRlQ2cjdmQi85Mk9INHNCblE5eWVTMmxOaVAvd2lWUldPSVJX?=
 =?utf-8?B?QnM4ME5lYmYzQnBCeDZmK3d2REJncElPK0ttYysxWXoyajMvWU90QnArNUt5?=
 =?utf-8?B?Vlc2YWVhZzVQNmRwVjlHVTIwSWlsV1d3N0N2RzZDeW5lR1RYWU9GSnB6VFF4?=
 =?utf-8?B?L1lHdWU3MUxuTmdUTnZ2ckt0T1RvWXFaNnYrMlZ5ZjlQUkdDb0s1MFRVREhM?=
 =?utf-8?B?ZTI5S1Z1OVJCdC9SYWxyVzh4amVtQXRoYkZTbVc3NXE0T1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1E3Wkdma3Bsc0JTMEppUGs1VTh1RkpkSGRQSzRoS29VdnZIMHVXSTZWcEdI?=
 =?utf-8?B?dThrYUFLbTJPaW12OCtNdVU4R2VucEtscVRlRjBEd3FZb2NpdnJvQjYvV2Q2?=
 =?utf-8?B?ekRWK2o2SDc1dzdWVlhybkcvR1RHWTB4NmphQS9PcEhzQnVCcllmdmNKeGRr?=
 =?utf-8?B?QTJQc1NiU1UvUDlkUFBtWXdFT0wxamt3WXNlZEdLWjd3VkVKVkROV01uUTlL?=
 =?utf-8?B?eVFveW9ibklPL1YrUk1MdnVJbzlHRGpoNVhXaTkwUCt6UmJHVS9sY2EzNTdX?=
 =?utf-8?B?eGpqcTNpT0p5cXNJZjF0ako3SmxLcmNGRzFYTlZ3b1Y0LzV2eGxRNFFRdzlP?=
 =?utf-8?B?czliajVoVzdqaFpDb1dsdjY0SW9NZUpJMlRZTEUvamxjMW9HQ0kzOFMwTmtl?=
 =?utf-8?B?NVUxMnRpakJNSXFlbnY1RVdMWmhiTUN2V2xodnZzNUxYbVBmeG1ZU21jelJ1?=
 =?utf-8?B?NWQyTjc4cStPdjhlZCs3a012WXd5bnB6bDBtek9Ic3U0SS9SWW9pZ1VveFJ4?=
 =?utf-8?B?NERrNFhvVndWMHc1NGh0YllyR2ZsZW5ITzFXQWVHaVgycDJ5cEZEd01XNmFE?=
 =?utf-8?B?aExodXAyREhzYlBIcFNVT2NRYlltdW1PcTYvbEtZbzJYVXRWOGhRMGgvd0Qx?=
 =?utf-8?B?N0Z3MmVlVG43Uno0TUZldVBTV0Ezc29QZG5iTjhlMERlNW5GUkVrcVdmM1VU?=
 =?utf-8?B?MVhzZFgrdHF0Nlh2cE82OTA1UVpiaWxZaWZ1MXNlcnZaVnpSVG5wWUtUaWdo?=
 =?utf-8?B?c2p2TmdvRStYK1piSTYxTEJVT1JrYjI0SzYxMkoxYmJ0UEpHamVqWTcvUWxk?=
 =?utf-8?B?MjMyRUY3bTI1K3c4RFYvejY5d0lEQ0p6Tk93SGpWYUdobkZlbCsxMmRyZUtI?=
 =?utf-8?B?dlhIRlZXUUN2UUtzc2pDbXAwVTNlOWQwb1p2dlNxOGd4Q2t3dHU5dG1RbXFm?=
 =?utf-8?B?MnZDb3prc255K3o4cGV1WFVTVlFnMVE3MCtFRHEzWGNENlN2UEJSa2NTMkFE?=
 =?utf-8?B?bFFEK3dKM293RjNGMGkyMXhhZ2ZoZkxGRGtHdTFTUm8vaWtSeFVaTC9VZm00?=
 =?utf-8?B?VzYvQ2pUa0w3NlNhdDVzVFBsMjBaQUppa1lqdzdlUGlCL1hIQnB6VU13MFlo?=
 =?utf-8?B?ajM3ekhtZ2JUZUpGSWhhZWRFaTN5NVdzOUZTQTRvNEUzTTRiaEpnY1E5SUhQ?=
 =?utf-8?B?YzFFZGwwVGJUbHMxRTRVcEUzdTd6SDFCdWMxLy9qTXlmR3FubW9uSjhSQ2ZM?=
 =?utf-8?B?OHJ1c1V0Qjcxc21DVytyMm9UUkVDdVpDUEZjaXhDWmkwdGdYYnVGbUVTMTVR?=
 =?utf-8?B?VWlwMWt0Wlc3OUpqUXRtMlRqM1dLZnJ6N3VIZGdVS3QvblpManJNeDlKMWYw?=
 =?utf-8?B?WU5UK3dDcEtkd0NuNkhNSUJqTllGb2Z5WmtIV2ExdHBxbW4zTUV2Ums5a1lZ?=
 =?utf-8?B?YmZudHRxTnJ0SVNybVVhRURWSGUwNVdYdzZhL2p3VGcyZzNoVHJQajh3Rnhu?=
 =?utf-8?B?QW0za0ZUV3EzOHA1WjhZeUdVc3J6UllRZ1Z1bHd1Ulg0MjdwQjljaXhOWWZ3?=
 =?utf-8?B?VFRrZE9ndGV2UGhRa3hMSFdiZk5IcDZYRWhHRnoxQlk5V1l3aFdGV29qZXZE?=
 =?utf-8?B?VThvWHlsQTNXTlFPTCtBVFdDSHpWblk0dU1LajYzS1BHWVBkanRmcVBKdndJ?=
 =?utf-8?B?SUVnTjhKNFZ3RkY4OCtuTDJyWVNrYUZBYlNaOWxDYnFoZElqSmh3dEppLzJQ?=
 =?utf-8?B?U0M3RWNlQ01sU25jeW93RUhBaHBhYlVRZlEwSUpxSkR3T2ROb0lnaG5xSUJ3?=
 =?utf-8?B?SGJSemlTU095UzhKb2ZKcFJVd3pYSDA0ZDZtb05DTDRoSG1lZXlDaDJzRzI5?=
 =?utf-8?B?c0xkR1hydVRvNDZEaThvNzdKaHB3aEpxK2Y5Z0tiU1BmMVZZRWJ0ejZ3WnNx?=
 =?utf-8?B?Nk9MWDNSTlI4QzFLb3g3aEJYWC9TN2tFVlZVSHBRTTVoNkdIYTRSUmVNamFZ?=
 =?utf-8?B?UXNvVGJINHF6Rzc5V1lHa3pjNzJqSW5Ic3dkTVBkYnZ4SDZ1c1pRU2IyeDB0?=
 =?utf-8?B?bVlXSWs0WUVrdlBoWDl0RmF1U3B1azVhVkVDSkpMTzNsMk10ZktkSU0xWDBD?=
 =?utf-8?B?K0EzYTVOanY1ZE01cEhQazhCUS80Ti9RTSt2a1AyK3VPZk9CMDJXNlI1RXNq?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35346BC992EB164AA82E7E9F5F9E6D32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1e65e9-e1e9-4c73-4fcd-08dcbc877c06
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 17:35:26.6720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MSZqBs5f7xBH0cP/IqKBAA09zemZVKQ1bqBz/TgzaBZHhlW0Mxyr0hkfNUjyWad9QQoh6IZIsbneo4cyvAV4KCkbXpNfVJleq2G0pWZvFq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6704
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTE0IGF0IDA2OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9uZSBzY2VuYXJpbyB3aGVyZSAiZml4ZWQtMSIgYml0cyBjYW4gaGVscCBpczog
d2UgZGlzY292ZXIgYSBzZWN1cml0eSBpc3N1ZQ0KPiA+IGFuZA0KPiA+IHJlbGVhc2UgYSBtaWNy
b2NvZGUgdXBkYXRlIHRvIGV4cG9zZSBhIGZlYXR1cmUgaW5kaWNhdGluZyB3aGljaCBDUFVzIGFy
ZQ0KPiA+IHZ1bG5lcmFibGUuIGlmIHRoZSBURFggbW9kdWxlIGFsbG93cyB0aGUgVk1NIHRvIGNv
bmZpZ3VyZSB0aGUgZmVhdHVyZSBhcyAwDQo+ID4gKGkuZS4sIG5vdCB2dWxuZXJhYmxlKSBvbiB2
dWxuZXJhYmxlIENQVXMsIGEgVEQgbWlnaHQgaW5jb3JyZWN0bHkgYXNzdW1lDQo+ID4gaXQncw0K
PiA+IG5vdCB2dWxuZXJhYmxlLCBjcmVhdGluZyBhIHNlY3VyaXR5IGlzc3VlLg0KPiA+IA0KPiA+
IEkgdGhpbmsgaW4gYWJvdmUgY2FzZSwgdGhlIFREWCBtb2R1bGUgaGFzIHRvIGFkZCBhICJmaXhl
ZC0xIiBiaXQuIEFuIGV4YW1wbGUNCj4gPiBvZg0KPiA+IHN1Y2ggYSBmZWF0dXJlIGlzIFJSU0JB
IGluIHRoZSBJQTMyX0FSQ0hfQ0FQQUJJTElUSUVTIE1TUi4NCj4gDQo+IFRoYXQgd291bGQgYmUg
ZmluZSwgSSB3b3VsZCBjbGFzc2lmeSB0aGF0IGFzIHJlYXNvbmFibGUuwqAgSG93ZXZlciwgdGhh
dA0KPiBzY2VuYXJpbw0KPiBkb2Vzbid0IHJlYWxseSB3b3JrIGluIHByYWN0aWNlLCBhdCBsZWFz
dCBub3QgdGhlIHdheSBJbnRlbCBwcm9iYWJseSBob3BlcyBpdA0KPiBwbGF5cyBvdXQuwqAgRm9y
IHRoZSBuZXcgZml4ZWQtMSBiaXQgdG8gcHJvdmlkZSB2YWx1ZSwgaXQgd291bGQgcmVxdWlyZSBh
IGd1ZXN0DQo+IHJlYm9vdCBhbmQgbGlrZWx5IGEgZ3VldHMga2VybmVsIHVwZ3JhZGUuDQoNCklm
IHdlIGFsbG93ICJyZWFzb25hYmxlIiBmaXhlZCBiaXRzLCB3ZSBuZWVkIHRvIGRlY2lkZSBob3cg
dG8gaGFuZGxlIGFueSB0aGF0DQpLVk0gc2VlcyBidXQgZG9lc24ndCBrbm93IGFib3V0LiBOb3Qg
ZmlsdGVyaW5nIHRoZW0gaXMgc2ltcGxlciB0byBpbXBsZW1lbnQuDQpGaWx0ZXJpbmcgdGhlbSBz
ZWVtcyBhIGxpdHRsZSBtb3JlIGNvbnRyb2xsZWQgdG8gbWUuDQoNCkl0IG1pZ2h0IGRlcGVuZCBv
biBob3cgcmVhc29uYWJsZSwgInJlYXNvbmFibGUiIHR1cm5zIG91dC4gTWF5YmUgd2UgZ2l2ZSBu
b3QNCmZpbHRlcmluZyBhIHRyeSBhbmQgc2VlIGhvdyBpdCBnb2VzLiBJZiB3ZSBydW4gaW50byBh
IHByb2JsZW0sIHdlIGNhbiBmaWx0ZXIgbmV3DQpiaXRzIGZyb20gdGhhdCBwb2ludCwgYW5kIGFk
ZCBhIHF1aXJrIGZvciB3aGF0ZXZlciB0aGUgaXNzdWUgaXMuIEknbSBzdGlsbCBvbg0KdGhlIGZl
bmNlLg0K

