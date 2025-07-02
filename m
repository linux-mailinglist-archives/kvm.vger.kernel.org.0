Return-Path: <kvm+bounces-51312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A844AF5D45
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:37:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBE677B6D44
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE41927E7DE;
	Wed,  2 Jul 2025 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JInVG3Gi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B303196D5;
	Wed,  2 Jul 2025 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751470128; cv=fail; b=P+in2s+cFTdBnLARfnb/c0wffqwqKO4fNBmDEhKJfum4j5cIYKz25LMhrSoKoXppwb1Scl83VUW/QxoPOsOjP+gvSnl+5Q0ZlMUP8u9g/KvmBw0FaZHQecNrOlQADGywb5aR1z/6pD0lxEbJnI0108W+bUMIBNIQnMl55VttUv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751470128; c=relaxed/simple;
	bh=Ctbkz5Yk0gOepUIc+PPM9oCDOuuHanxm02vT2Jjwo8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lBdc0Z7FqfKygK3IVIkxnGfVWxc4Mub7uwZb//fC0CoGi/Kq/IM+ZsUBS/JlHg/oKCkYPh4kVQCGC5c4Asm4mbIg020Q/uP5Dmp7KcWqyJ5h23o3usQwZ66o5Q3kkS8giaTm2WJ0hW3iDZjbq08fkJUID+ZAfWznBskaIqd0Vpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JInVG3Gi; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751470128; x=1783006128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ctbkz5Yk0gOepUIc+PPM9oCDOuuHanxm02vT2Jjwo8M=;
  b=JInVG3GiswZ2MTrGNRda9rm8SQ7Na7XAy0bWUjAc/kh6vIBRNUz7sy3O
   EnectKBmD27Z9xKv4HHGx/CHynmbYyBcrt1UlzU3twiKEEcLqs7XZiwyq
   V3MfREI4DWm26YnwViukNKBipqjxwcxps2xKPb7ZcpqNB1MLoKmnNYA9r
   XxLtBM/ZOipzyrCrtWMQ1PpIjx9pMU12uyNPjIcNQnkNNpoPL4MjQxyxx
   H4KdePYnhoGnmy6HhdUVCdQZGziYxTrBIrPOoWYDbjnKPv8I5X4fEPz5X
   OpMpBtX1ZZ9akbzepCnclhdgHgr769zF1R3YgxbDmE+RiPgddUfF4Fs7b
   g==;
X-CSE-ConnectionGUID: 4RK95QZfR/iY3TufC1FZnw==
X-CSE-MsgGUID: yk0WCYKuQM25othKo5INZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53917654"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53917654"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:28:47 -0700
X-CSE-ConnectionGUID: xevzfPHuS4SYQs6lae2S/Q==
X-CSE-MsgGUID: gFD5OkNmTQqG657KdhDPTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="185052465"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:28:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:28:45 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 08:28:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.46) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uE2FgC+nrjDxJCGAgw60EBcV2kl0PEFvJDcyhMpGCjxxxrOdoSJtU5rmN29L8bT/yjuiFCwYJjxUTqI5JOlMviX0ARYt2DZdoTtkmJ5wScUuODa/36zFDM8iukrQyLBbHbXcrAoFJC2pIEyfHfIsMmV0b/hOhu9ObBUpRNFonsyZlMWxRVSx49xKpEIJllkcEQspzx57l0OVFkM/VEmxc4nBBoLQ7uWVZLHwZu0HTnVEurVvyoPZ/czfIPORBGdrewznivvTGrU7qCxolpMQaj41j5P6dGxMEp1Bo4YQaoDyFT3EZ3zBb466AaAdoFqorE3CK9469P0BfdHQ+V5aEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ctbkz5Yk0gOepUIc+PPM9oCDOuuHanxm02vT2Jjwo8M=;
 b=kca1NVaCXdSC4vQLEi0o29T6pcRW3DEjr+cAZgsbEvI0GNRibYNf8AXHG2thhjGeEBjcNRgRTf5TF5KtM3covN5o7nzh6TCqXurXRzPLmIL8G8IQxD5xjx8Ywxx6JGt53tVwT7FwkZLbyQV4MS1OuJQ+L2HE2l+51Fnax9ARRz/4HexQKCXjl+WHc0Ke0s1dWtFMo6vIDiTp/ts+169diO7gMZx9fkIKM/h70aV798NqE4TxJrL9i8VQP1OOW7sCN851IdBa4FbKRLdvdxfVQQYRgDlmWZNPAIssJ4aV4lIIAGiBjzAbMOPQ9KghOdW6d4P6XSXh4S8M7MVRwZpyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6412.namprd11.prod.outlook.com (2603:10b6:208:3bb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.19; Wed, 2 Jul
 2025 15:28:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 15:28:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngIABC0kAgAB2RoCAAUnBgIAERXKAgABwaoCAABksgIAAJyQAgAB5m4CAALvngIABG5gAgABqKQA=
Date: Wed, 2 Jul 2025 15:28:40 +0000
Message-ID: <76b1025916d52260dc7acc613d4eebdd5bd7f1e9.camel@intel.com>
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
	 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
	 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
	 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
	 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
	 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
	 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
	 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
	 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
	 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
	 <aGT3GlN4cPAcOcSL@yzhao56-desk.sh.intel.com>
In-Reply-To: <aGT3GlN4cPAcOcSL@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6412:EE_
x-ms-office365-filtering-correlation-id: 873b34f3-76a8-46c3-37e9-08ddb97d1fa2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y0poc05ZKzVxY1pXa01NNGNTN3hDWXlITDhad1RxTytzK01yRTl6dTRoWjM5?=
 =?utf-8?B?V3NreXRIWmRMYjZxRXQzSXFtdVZQck82RWl5T0tsczU5MUpEWmtNOGM2Y05u?=
 =?utf-8?B?bjVEWVZib0hpeFVKMWtRV0tVVWV3ZXIvL1JiTTdCUVhsbWcraW9FdzE4aEsz?=
 =?utf-8?B?anFtSjdGaG4xMnlUUkluR0YxQTRQSU1DVHFEK1B6VSt3S0JQNUs2TnFmNDNP?=
 =?utf-8?B?dVpWRmtYVHdwazFWbHhFN0kvTE9yYkt0b0RJQWc2a2F3SnVsaVNTelI3OTFG?=
 =?utf-8?B?WWVKY25EM0Q5VGcxQzBYa1lCTzJpbzdyM0VsOWEyelpFMFU1SnE0YVV0L0I3?=
 =?utf-8?B?SkxRcklIOGtqTTVFQ0JsQ2twcHlNL084Um9RMld1R2FWajdwQ3YzbHdUK25u?=
 =?utf-8?B?cEwwUXg1b2NBMnpqK2pILzNWekMwd0R3T0ltbzZLdFJMLzI4L3lQcFJNWGFp?=
 =?utf-8?B?OWNkZHhweUVFOTNEbDBYTmFqd0YweXVSZlhLNUo5WFBrWS9SQ0FMSG1lcy93?=
 =?utf-8?B?eVpNTHIweFltd3FMNDkxU0RFTDBzRVdZdTBRM3QyMHVxajhPWjV0OFN0UlFX?=
 =?utf-8?B?Z3Z2VGliSUdnc3JUdlU3Nkk4OTczeTYvZmszTlNHWHZKdVlhSFhsbjB1VnZr?=
 =?utf-8?B?dXVDMmVKYmN6OVVHdjVTTy85Yzgxc0pUZW40RWhSWmhKWnNzNlE4Y2JNM0VX?=
 =?utf-8?B?UGlwekx5ait6SC9OSzFRTzFUdXBRSHBqZ2M3Q0VOV0Z1d1ZrbTBVODE1S3pj?=
 =?utf-8?B?QkgvV2QvM08yNmgxdEEzWmJuejErWkNoTDEvQjkzTGdGbWo4ZUE5TEl1STV1?=
 =?utf-8?B?Uk5MNGJOZnVFMCtwbzBnMkNOc1lFVXRvRURCRmpwWDJpaE02d0p1ZmM0Z1ZD?=
 =?utf-8?B?ZDZUNm1XZHdkRVI1b0RPTlJPZHFTRERxVmhobDhwY1JhVnVnQ3NITzJtOWUx?=
 =?utf-8?B?VGRUWUZjVGVjSjlZYnFVR0RjZk5MN2x0MkVRNlJDVmIzZ3RUNS8wOWNzRzZy?=
 =?utf-8?B?YzBvaXpYMnc0VEN4ZFU4OXpuMlBncTkrTzIvdmlIUDJSRFpUY0hKdVZQZEhE?=
 =?utf-8?B?RjA2MHF3VGxRYkdNRE9YWG9QTG56dzQ0VU9oL0hDYnVueFRtOVRRYTVUVnZs?=
 =?utf-8?B?Qk0wTWVabjRCWGRtMG9ZWVRzMkprMG9qZDBYU2NlTitFL1A1clpPQTZZSExv?=
 =?utf-8?B?L1ZGQy83VmpFNWRHN1N4ZG1oVU9GTkY0YzU4blRkdWNaRmlZOU12SDNzTy9R?=
 =?utf-8?B?K2pPRG5ZMmk3WDRYbnMzSGVMQkpjT1J2Z0hoczZtc2F0dU9Za2RoM2VWN3Ev?=
 =?utf-8?B?NGVkWk4wdVd6RVIvZ1RISFVTRzc3NDVSNklkTUdiMTdqUmllQmtyK3lwY09u?=
 =?utf-8?B?akg3N2g2dTkxNWFueHJ3ZVBNZXRtb0FTVWh4UzVtQ0xTekdNK2hrR2FFeEo2?=
 =?utf-8?B?aVpjWjdYYk4zUkl6SDhUUmJ0eW01Wi93QS95STMzUlNKa1R0ajM5YkRjSlhu?=
 =?utf-8?B?SHlNbWdpRDRSTUNobEYyWktEMW5zL2NqeEk1VkFUYUVwdFZYRVdvZGxkVEth?=
 =?utf-8?B?OFFYYUxhSEtRU0NIM3Z4eTdhL01CV1pHUDl6dC9VMFE2RkIySm1kNWdTRHVY?=
 =?utf-8?B?VTcyMXRib08ySmlKb1BTZFh5dTdvOCtkSlNFcG5JTVo5YjBYSzQ2VWJ0bjB5?=
 =?utf-8?B?VkxHd21OOG9FaGxrRVgvSkdEZUZ1Z1VJelpMcUN4L0lTZHZKN1VKTm4wVndT?=
 =?utf-8?B?djZZR2o4L1I2VHpEOE9XclJMUk9yS3YzZGROVnk2SHR2dElmSm5seXRhR3k2?=
 =?utf-8?B?RlVTSzlYaFBzWjZyTGxndFI2SHc5NHVQd1I0bUIvM1U3V1VhQWllYnJxdVlB?=
 =?utf-8?B?NFMvd21qUmlIRTBnYjk2WXVOdmFJNTN0L0hlMjh0OFQwS09WVDFqYTJRUzVV?=
 =?utf-8?B?SzVmNzZKeVFKTlhUV21JUnNMNzFKcjBSUVB1YlJ4U0NCdnQwTkF6eFVTSzJ0?=
 =?utf-8?Q?4OH2ya+hIEjmf5g0Rq+hfPOi2eDbk4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkxTWmlsTXkrd3piWG9TVElVWWZYNktjLzZGR2dCTlpoaUV4UEtjdE0xYjhQ?=
 =?utf-8?B?dTFjbGRheWtXK1JYR3dSN0phZEtDK25aZFpKY3dkeTRldWlwZGFHczRuV1Rq?=
 =?utf-8?B?TGVyRU9ESnZaVmJQSHRWeVAyY2R3QWl6aHpWenRsRTFMbzhzR2lqcUNoTUFO?=
 =?utf-8?B?dUVrK3QvMURNaFBZSDNydVEzTGtKUFdiRzdTZnJPVUZld3MxYUl5Qk94azM3?=
 =?utf-8?B?MkdxNnhNbWwreVRsWFgrWGJ5T0lsbEhZdnRLdzdyWCs5elQvNVJmd2V5VVVJ?=
 =?utf-8?B?NmFQS1hNS3VJOG9tRzJ2bkhyUElpYUdQek9hY2pIMXN5QlM0SzlBb1VpdTI1?=
 =?utf-8?B?ekFIazdsTnZ4MnlQeXV1VzVmbUlCSXZ4VjAyb2hjNmJVZ2xIajYxbFlvY3gy?=
 =?utf-8?B?V2lxM01jbmhOdU11TlN0VXBPbEJzcmdrNHRkWjY4ZEc0U1MxQUFnQkk2ME5C?=
 =?utf-8?B?eitWQ1NqTHNiUHJ5c2s5b2QyL0FPN0FPVXVkKzlHTys3ZGFTUmxiUHdWMWZu?=
 =?utf-8?B?TVQzMzcvMG9QbVFWcjRiUEg5OENRK1V1UzR5bXRBaVJTNWl1cEdnRDRPR25D?=
 =?utf-8?B?TmxDNkFOVW1OUkVOa20xNzFGNHB0ejBmd1RicXRUQXIvRWdQQjFybjZ3Tzlm?=
 =?utf-8?B?YTdoc2hXNWZXL3JIbmp5ZkhWZ09nOTZsT2krdCt4ZURTV1pNMzdrSG40UXBw?=
 =?utf-8?B?SkV0amhRWkxHNTNMZFRQdTJkRDFWa2ZZNHRDMmdSVFVJajBlbEtYOGlYc2Fm?=
 =?utf-8?B?ZUU2YUVBRmV0dk0zTjhqNlJSQm54RVdkV2VQd05UNGF2TUpBYW5VODlJY0dJ?=
 =?utf-8?B?cEgraE9PQmdsT05BTVBUVGRnbWc3a3F2UElTZ1ZqamNMMlRtMkY5OFRUYVFD?=
 =?utf-8?B?aVE2WlBzZjdKT2NWeDlxVzU2bDdEdTFtVWdWV1VYYlVmOHhmSmpvcGJobENC?=
 =?utf-8?B?RGNyQ2o1RlFrUU9GeE5UdFlYS2pZNzVVeHpwdFQrWk9FaGl0NXpnaWJyVFRr?=
 =?utf-8?B?akt4Ullzby9qVG5ibUVoZDRjMTlPL3d3TkxGa3dsR2VHWGRJWGs5cFloR1hn?=
 =?utf-8?B?OGhBZVFmbDJCV0hPSmpaRnczOWFzMXRjQ00vc2c2bU1EbGtIcmhUNTlSNmJL?=
 =?utf-8?B?QU5OSTF3clNLZW1GWldCbXZjeVFGWmNKMUJ6VUtSaVA5bkF6QVZ3K0VWSDVm?=
 =?utf-8?B?UGVvcXdaSHk5RVBwVFNDUzVrSWNNMlRDRnZ5V3gya2VlZFJTMTNzandkb0NY?=
 =?utf-8?B?ZStaOWxJdWNjaURqYkZyVUJBVjJ5QlQ4R25xdGY0QWtpYWJHS0dvVzk1aWlh?=
 =?utf-8?B?aU1NUGcxTkJSUVQ0NFBmRUNOOFl4Ky9icmdkbkkxeEMvcjZFcUYrK1BqMzhi?=
 =?utf-8?B?VXR1bVhIc05FVUx2TGFEd3M0T2pUaUhWTjhNeGcxOXBteUxwbUpUc1dYTG05?=
 =?utf-8?B?OFdWbzgyV0tnbDJ5bWliVXJlMWZraGcrMHEvQlhXdlNHQUZ2UzduUXF2dGgx?=
 =?utf-8?B?YWZQZDBNbTl0bDBya000TkFxZnU2cks1L3F5RWx6K2V2bVNHczI3N2dBakc2?=
 =?utf-8?B?eXlIMkVxU2FlcnFycnIvdHU1VkNWNDN3eCs1YjV6bVArNUxRblE0SHdnTnRT?=
 =?utf-8?B?Uk1WeTNxNFNMQkNzcDZvSWs5VDJpVzgxeDZQL2doV0c4ZmllWUtlU0xkTVdH?=
 =?utf-8?B?Q3BKa3k4TkQ3ZkRTRHdwa0ExV3AyMDFhL2c1ZnRhTUZncDRYNENoK3JVM3hx?=
 =?utf-8?B?MFlSaHNManpzYnFsaVRJVHdsMmRJTTVXaEJjekdZQjM1WTJSRHVkV1NyRGVJ?=
 =?utf-8?B?NzVpR3lXTVdEc2xGNmdkMVhwYVNPU0NBakN4SWQ4bnVGS2UrWkI3NTVwckhJ?=
 =?utf-8?B?aWJyRTlXUnVqcWFHb2FsUUE1N1lnSW0rTlZlbFNmcUtZTWlkRWxvQnFUSytt?=
 =?utf-8?B?TVRtTFEyTFJ0d1M0T0w0c1JzN2dsYnBYVG93QWcrcHpHTWVqSU4wWjk1bGRW?=
 =?utf-8?B?MHE4VE9BL1V0VGVydmVFOVpBeG5OM3JLRWxoSHRIVHBrMUoySGN2bzNrc3JZ?=
 =?utf-8?B?TmJSRHYvbVlaZ1lZeDB1YktzNnBES1EzaHBTd05tL3JZZnE1am0rQnRKR29v?=
 =?utf-8?B?MHlFM3NEaFJFdThtTCtzdlpBRm9iMzU2NEdoMWZUZEt3R1ZhSks3OG5BUW4w?=
 =?utf-8?B?OEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8171D24B58380B418D17AEC36CA3F304@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873b34f3-76a8-46c3-37e9-08ddb97d1fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 15:28:40.8682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpvnpwXaOHX9JhenJr4OcPdFT8qbpvXwr4XzaN0hpSYy93uFIPg40mgeujEBYwrXwZNj5P4VCipVT9xWdpeFZVKmx2kIb0/G8pfhgUK+Aig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6412
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE3OjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBX
aXRoIHRoZSBubyBtb3JlIHNlYW1jYWxsJ3MgYXBwcm9hY2ggaXQgc2hvdWxkIGJlIHNhZmUgKGZv
ciB0aGUgc3lzdGVtKS4NCj4gPiBUaGlzIGlzDQo+ID4gZXNzZW50aWFsbHkgd2hhdCB3ZSBhcmUg
ZG9pbmcgZm9yIGtleGVjLg0KPiBBRkFJSywga2V4ZWMgc3RvcHMgZGV2aWNlcyBmaXJzdCBieSBp
bnZva2luZyBkZXZpY2UncyBzaHV0ZG93biBob29rLg0KPiBTaW1pbGFybHksICJ0aGUgbm8gbW9y
ZSBzZWFtY2FsbCdzIGFwcHJvYWNoIiBzaG91bGQgaW50ZXJhY3Qgd2l0aCBkZXZpY2VzIHRvDQo+
IGF2b2lkIERNQXMgdmlhIHByaXZhdGUga2V5cw0KDQpUaGlzIGlzIGNhbid0IGhhcHBlbiB0b2Rh
eS4NCg==

