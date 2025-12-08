Return-Path: <kvm+bounces-65512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EC4B0CAE27C
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 21:27:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F0CF300670A
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 20:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B9C2D8367;
	Mon,  8 Dec 2025 20:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUbv4Q+r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD89526056D;
	Mon,  8 Dec 2025 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765225659; cv=fail; b=oQ2k9QPvJVkYoECU1ls5L3l7EHEs085Qgo1H1+5qxQzeHJaTnBRvUD3OJ88P7u/hnaSoPu7f6otwht4EY20lOro0G6DVcxaKdAL2nvXKFhgg85eYzBntdXFKB+STZ0i765uGF/UVQgvpVusrbi6Ph6r2wGu7btd+20ascIYBI+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765225659; c=relaxed/simple;
	bh=k3zsQTSGEr84l+H9iK5/VYkeduItM6Ds9wDnGy2tGeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=StB+mVbKXyshnPgZCp5z66EVb5tN0y2Fg466TRXcEp2Qc5UcIkKdiqahRqjYoHNvsUsS3XWMFG7OjRG0MTkmGEKmAOAg8l0pS8QAzX2AYAmBh8UdYP3HsCqPw70YhE/zasi3BeVeyPHKCvR2SoMs4DrXSPc6JtU687AHOWwgUqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUbv4Q+r; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765225658; x=1796761658;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k3zsQTSGEr84l+H9iK5/VYkeduItM6Ds9wDnGy2tGeE=;
  b=MUbv4Q+rMZniYFb7qjMFiKOt/iZh6NLlSMZ3315A98MaldTwexcLOKd5
   gNac94UtnViL4Xapt8IaQgbnUjAo3YpIWuPhTXosY9dV9XrbuXO6yzd3B
   Z8OFNSIWPsu74fP+WyLkF+1YNd2TCNmwchPQS++yo92W1ngySBpuAd74R
   di88Q4WO5JBM7vQQxUt79tWo32XLYA7ACJdekL/CZ1nnE5Wd2/FZwJ8uO
   AdYMVJVi3XO9frgtX+iemz3+RexUe6PIn41o9I9mE8cqd6rfACp9d8u90
   Qua/U4nxTXbtRoDeRgBD3pwPy6SRPEThIqQ4tKyFByVa2MTQMEIuQAZjf
   w==;
X-CSE-ConnectionGUID: jd8GsfzrR1eKHOuYL15dLA==
X-CSE-MsgGUID: Nxqg37enQRyqJOt/z/YqWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="92651025"
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="92651025"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 12:27:37 -0800
X-CSE-ConnectionGUID: Ry+0jYM7RG6gwmohgEvvTA==
X-CSE-MsgGUID: VwTpY5ToQLSxOTsj3wHZNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="196795673"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 12:27:37 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 12:27:36 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 12:27:36 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.16) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 12:27:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MA8xZnuPyx2FLL1Nus+S3FP7dVMoR12bWx0WHbazN2sr4Q7GGr+i1Y5riIoVROqxXbEzb250QIhrsB1PaEhZb7o2LEifXvTJaXfDos1l2N6qxnMfk55is8mQw3rCPDONNGgX17FwId8UX20fAdRxS83vHxbow6632rsiuJng6eUX6j93cu4MKXKGQNVySc+lYv6S4WegA/cowY/ss+Frfmx9XzIHrDncLDpW6bBll4fUwuSsULV6p4fD6c/3gTOBCP8+EAMp/Zh8O1gXgSXxNNEpxmwrXewP7/kvSF+pAJcAzul/2KShw1pItE2QApbqSmzd1rA3mdy9NM9Twcqi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3zsQTSGEr84l+H9iK5/VYkeduItM6Ds9wDnGy2tGeE=;
 b=UYFcJ2zZSGTbdIW4o9h27vyY4lfIllIbqsBfFiIHo4wb3cz3bRdE6Bjhu/q15xGux30m5103FC1lOb9BC+2Izg5m2CoS4pOS0mLLrnGGmDGlKVCkHCZY+SghC402B06M9l3KsWchCGqItzR5ICApSNouB+iisCOf9ljPRTrrisFeil8bX4p0UxBK6XhGF6qnQ5tWXIfV+iDrg1uJhGr2qB0oDgExL13FCPEkk8Lw6r1js3LsIv13oFBiTemjor79jShNKa6dxA7qH2+TsUfOjaXFLs9HulNBstngla1AYKZg150SNOcfxwqTh8OFbvmpwUGJqP8EkCFQPbMd+i9sdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4658.namprd11.prod.outlook.com (2603:10b6:5:28f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 20:27:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 20:27:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UXkXWAgAC7sIA=
Date: Mon, 8 Dec 2025 20:27:31 +0000
Message-ID: <7e4dc2a683ce9cf5703399d233c71d4a3cc5ac53.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <aTaXQSu0j/9Y0bsY@yzhao56-desk.sh.intel.com>
In-Reply-To: <aTaXQSu0j/9Y0bsY@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4658:EE_
x-ms-office365-filtering-correlation-id: 72d457e3-99da-4e14-7420-08de36983718
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QjFVbUNoSGY2L000UWpTYnRGTWo1bFh0Z2xORlBKWkt1azVmQ0lDYk5UU0x6?=
 =?utf-8?B?dlJLcVZraUJWSlJ6RFE3OEFYaHhIbnlweFJmNFc4WnNDVzdhYjI5RGtaNmFw?=
 =?utf-8?B?cnR6eGZXYkFLM1NVaXZnbzI2QWREVHdlbjVxdXllMHBnT3czdXlHakk4eit4?=
 =?utf-8?B?eDNNTk13d1JRYmlZNk1qNW1VWDkrSkV0ejBIemU1YlQ0S21iVkd4eFFhNi9J?=
 =?utf-8?B?d2RFeEZNN0RCc3dydStWbWZCM2c0dUN5WWFuQ0kyR1RqT2REc2NndzR5emp5?=
 =?utf-8?B?M2swcndURGdLNm9GajlCOTVCQkQwZmFEUFlBVGFGN0s2SG8vd0RqQXNEdkoy?=
 =?utf-8?B?dVRSU3ppWTErWklOU0Nhb1ZSQW1jUXIrKzVRMFlaVVpVMmNVZ2JaWmU3c3F4?=
 =?utf-8?B?emprV3F2ZkJndVQyN2pTOHhMd0ltQ0xLYTJPSkhrRUh5TGtSUktzUDFydlcy?=
 =?utf-8?B?ZzBadTlZQVQ2bk9uOW03TUJRdEp5K29LMTlZdllMSElxTWNPbXljQUdOalJn?=
 =?utf-8?B?TVJIcllLVXB5RS9SNU02MjFjcUk4YlhoNnNVVCtJYk9jZExYWXBMbGd4R1lI?=
 =?utf-8?B?cnlxTy9vMEluVkJWcEhwOTUvZTg0MVJUZ2lvNEtja1A5Y3ljNW9CS0x5UmlR?=
 =?utf-8?B?SzZYUm5EMmlBb3lyNzlwMjRqR2l4ZUF4VHNRT0FteDNCZGM1RXhnNXY4WlJj?=
 =?utf-8?B?SzFoQlc1V0pkSFYxTG0xTi9MRDlodFRFdXp1dFJqUzViZWxWaW9zTTJlYUpM?=
 =?utf-8?B?TzBaaktBcjl4NnZKbXJiRHY1VGhJV0FzelRyQzJLRkVWMk1jWDE2d3IwbkRF?=
 =?utf-8?B?TExOazl5WmI4YlV4R29qL2JSdmVJZ2dFcS9yM1dINXorRlBiYldIUUJlN3NC?=
 =?utf-8?B?alY2bnJIbytpeW55Zm9HZzVmdEI5UnlNbFUvc0tnYjhHaEpFVzlreUUrYUdD?=
 =?utf-8?B?YVZaRG5QZnREMkgxV045YzZ4QUJpZFFQQXlzWjJpRUhoWCtXbWlFZUNtOEJv?=
 =?utf-8?B?OFRrcFQxUmx3UzUrU1NOOWZHWUc5eGpPbWxFNWltd1pvMStpS0xMTTAvckNC?=
 =?utf-8?B?a0FleVd2VVVpQ0dacXVBZXVvNUU1ZEVod1dyQmlLVE5UQWJSM1VvVkJscmt5?=
 =?utf-8?B?eVpwMnZ1ekpPUzBmbGJGSmRhamJFMUtoZDViZ0FsNkZDZzVtVnB2MmJKV2Jj?=
 =?utf-8?B?UXZhbE1PMHMxSHhzSENRMVY0alVUanBoNkxHVFVqZEZkTytmK21KN1NwUXNT?=
 =?utf-8?B?LzNEMTBiOFNwUUpFT3lrc2RxZGtXOVh1a24ydDI4SU9Ddkl5MWE2bHc0aHZ5?=
 =?utf-8?B?RGxHRGxLLzhtK0dJQnJCM0xRcnhucDBmTlNxdG84a1U0SzQ3SDlTRkc1V3Bw?=
 =?utf-8?B?TUVSNHpaWXBTbDc4ZXlGUVM0aGl2RXlwTlpLUFBDV1FiRnFnUytDMmZ6dlpF?=
 =?utf-8?B?ZjhpRlFEbzhyOTVxNDNlbFRSUUVOWWlXUVNpbVhOdWhRZk5peGVzeVBjZ0ZB?=
 =?utf-8?B?M1hSMER4SG9lZkxIdk52dExWVDhZWmpyTVFaaWRrVHZlaE5ObVB5NWpnaUhs?=
 =?utf-8?B?ZVJFVERkK3BVSW0ybjhIc2tWelozL0ExazFkVmZNTHVwdUxvbm1MR2hicmRT?=
 =?utf-8?B?QW9wSDE4WmlvWHJCb29yb20yeDM5dXVKQlNEbTFXSjlRUUVpWFBxUlM0T1Jt?=
 =?utf-8?B?ZGl5aDNqRDNjeUlQdTJRTnExOUFESlpBMkxHNnJSL2RQbmFhL214aVdIS2sz?=
 =?utf-8?B?TW5lV2Qwa2oxZy9TK2g4VFVhZWt6cE1ha2lPMmZ4RjF1L2JuSzZOc0ZzZW9R?=
 =?utf-8?B?b2NpWVp5UTBYL2ZHaFZnU0MrUXJYek1GNDhuR2x5dmFyTTBwcjlFMzNWQXB2?=
 =?utf-8?B?Tng2YVpnQk5ZNGhzSlM0bzkxQ0pIdG1UUzlIK3FMS3hkSkVvWWE3NnRtU2Nm?=
 =?utf-8?B?ZFl4WGZLa1htQ0hFS1BZRElOaWZzNVhhc1FNdk4zUXN6WElySzVhNjlvdHNj?=
 =?utf-8?B?Q0RsQjhYbThheVNod3NiSjJvbFp6NzRTQVdFWmJpaTBrZ1ZxYmRuakZodVdC?=
 =?utf-8?Q?VBBddE?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d09HQzJITk91OFQ4NThKMlAxYkF3aWpZSlNWZjdraVVrMHR0SkV3YS9KMXBp?=
 =?utf-8?B?RVJSaElDbm5UN2k5ZEdMOG41LytjTjZFNXVOaDhHeEkxMHJzQVp1RzNKS2tp?=
 =?utf-8?B?c2ZQYlZoSlBKRytrbytwSDBtTWFTNmNWeEl6MSs3d29IL0JPTDlTQ2F3RjFU?=
 =?utf-8?B?YURPcWFBTi9VYW9pTlp0Vm5rNnFwN0pBRzhBdTh5UkxOY3RGdnhhZEl2aXBP?=
 =?utf-8?B?M2t2b0R5RUxITFdSbkh3L2J5MHpKVkNSVnhyVUxkZDIvT0hPamtWZG9qSlhU?=
 =?utf-8?B?Nkx5UEIzSHV3dE8xdW1vQUg2S25lclh3aXdTbU9HSEFicTk1M0phUzRraE9Z?=
 =?utf-8?B?L3hieTBjTVBWcHRpR1I3QlV0V3BLcjJCRGprYnlVSzRFZDFaYkdyMjMvU2xG?=
 =?utf-8?B?dkFVNHdhTzZTbHhDM2Y5aDVvcDFsS3FqQWxSUlAySDVMaXpyeHlSUVJ2dlJT?=
 =?utf-8?B?M05DUm80aUVEenZ2ak13UHpKNmhEQmZrNmVWRDZCaVN3amVmNlVNcno2TkNF?=
 =?utf-8?B?b0ZmeUZrWVNFVVM0MlB4d1JXemR6L3oxd3cvTHl0N29mRmM4ZWMyd1N4YXJK?=
 =?utf-8?B?YXl2Vkoya2N6TlVGem9mMzd2TVBMS0phQUNGeU5TT1Z4akE2VXdrYVRMMnlL?=
 =?utf-8?B?NGpPTWpQVHhUQ3FYUHN2cElBcU92SmdXSlVvM2lUL1IyRlFoS3hMOHZtREV0?=
 =?utf-8?B?ZG1qQ3VkSnZPL1NVQWNQbGt0Ymt3dTZxNklFSVFDNVN3Y2pBZUIxNmtQWmZr?=
 =?utf-8?B?MnpVb1pSOTZ6K252QktFS2ZzQ3E3RWRTMGJ2RWlFZDgvTXVFeUlPYVlBbnJW?=
 =?utf-8?B?OEdLdThrNDZJK1ZZTmNUMGlZNXlieDhhclZiaXl5VGg5bDhiWjc3QUw5dGxw?=
 =?utf-8?B?ekpNdHRlYTd2RElCUDB1WXRDdmRyeTBCUlpIRkpoTUlzODhpWGl5cTllckpw?=
 =?utf-8?B?TzUvOUxTZ1RmMFNuUUY3cXBjbnpZcUdMUGdMZXNQYUFIeHM2T3BGL0V4QTFC?=
 =?utf-8?B?cmYzaDJvZjNxRGtqNG9JckFTZ3loakg0YTVhTEV0VHZ6Q0x1MWFCOHVuQ2ZJ?=
 =?utf-8?B?R21iOVJGK0pXa3NHMm05OUl3cFA4cGx4K0FPMHlJOXNsYVlxSnQ3TVlITmk5?=
 =?utf-8?B?S0tvNVlNb2pGNldCSE9jRDlkKzZRc3JxUEUyY3BEUnoyZkJDeGFvaTd3TUVj?=
 =?utf-8?B?aStSbnRrZFNnY3VCQzV1cndTeWIwZmxWdUhtTnlqemwwNmV0M25CaUh1Yk1C?=
 =?utf-8?B?dTlUUnJra1psUVo0VjJWc1BlSjI4K3huVEd6RzlVNVZUM3hldnRsYTdXbkM0?=
 =?utf-8?B?Q1g2amJqUTIxeGlkZkNiZGZNMXMwNE9ZUGJ2RHA0UnZ6eWc4bUFYbi9JeUtI?=
 =?utf-8?B?NXpDZG0vejYvWVUvRFRpczR5NHVVN1BYbUVXbHJlOG1GdkdEUys1VTBLRml2?=
 =?utf-8?B?SHhhWHREOUVPNEZhTEhBbjdNdmJVb05xUFh4NmRTNnF2VGtuZzdtOFRJR1FC?=
 =?utf-8?B?RGVySlNhd3VpcDl4ejdsNFpwbXNoM25HKytJT0NleUllWldOYnJpYUxNTTJN?=
 =?utf-8?B?OXFwdzBMOUdzcW9iUHRvWERlWnFiYTIrN3N4MEdHN0pubE5Vam1RUFRRejJ6?=
 =?utf-8?B?aDN2QW4wamdlTkRsRzRsQkFGYUkyU3VndjY5REdBWDJkQUVaMzBVT2s3ZFJU?=
 =?utf-8?B?RXpQazhyZWFwQUJBWGpaWmZGZG5ESi85Mjg0L2FneVlrdWlxclEwcGtwY2xr?=
 =?utf-8?B?TUp6NzhpK0t0QkdlL0tHcWFLaVRaejlTYmoyM3FuOVU5Y2J0aDd4Y2QvRjlP?=
 =?utf-8?B?bjlxTkprekJVNkRGc0F1TVJKL3pLR3hJREZYazJUdGt3L1IyeVlGbmNzZ2t5?=
 =?utf-8?B?VUM3d0FKbGVxMEdLc1ladXl4Qm9NRGVqZE1lejRaS0NzcVplcTk0RitTYWUx?=
 =?utf-8?B?dHYzMTQ3eVlHVy8xRXFEeVRIbGRjdzA4a29oK1lCOFYxYXpPM25IRkxzNVhE?=
 =?utf-8?B?b2pHM2tOTURuQWxDMFNXNk9uQmRtYXJxV3cybXpEcS9WUTY4MEdRWXp2NVNy?=
 =?utf-8?B?cHYxSjV2M1IyaHVneUdXWlpTanZpU0xNU3AzazdVMkF1K1VpMllleVNzaEVV?=
 =?utf-8?B?QUsvZmJqSkx0UVIxMjNocmJsYzUvaWpRbW1ka2VSWTd6K1ZPRXNtUkhKWlZH?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFE933454B38534BA9B2F34E85D4B5C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d457e3-99da-4e14-7420-08de36983718
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 20:27:31.9874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hbnC0cp3Nw+xzon35TervnhSeEpMGfR2pAzSnVvfGRAlur0IRU+iQkv0wXFlOQI+DBC1cdlxAh/1ZcJICkTDQr/QVgwitXh0D8X+NCNBXkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4658
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEyLTA4IGF0IDE3OjE1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
ZmFpbHVyZSB0byBhbGxvY2F0ZSB0aGUgMm5kIHBhZ2UsIGluc3RlYWQgb2YgemVyb2luZyBvdXQg
dGhlIHJlc3Qgb2YgdGhlDQo+IGFycmF5IGFuZCBoYXZpbmcgdGhlIGNhbGxlciBpbnZva2UgZnJl
ZV9wYW10X2FycmF5KCkgdG8gZnJlZSB0aGUgMXN0IHBhZ2UsDQo+IGNvdWxkIHdlIGZyZWUgdGhl
IDFzdCBwYWdlIGhlcmUgZGlyZWN0bHk/DQo+IA0KPiBVcG9uIGFsbG9jX3BhbXRfYXJyYXkoKSBl
cnJvciwgdGhlIHBhZ2VzIHNob3VsZG4ndCBoYXZlIGJlZW4gcGFzc2VkIHRvIHRoZSBURFgNCj4g
bW9kdWxlLCBzbyB0aGVyZSdzIG5vIG5lZWQgdG8gaW52b2tlIHRkeF9xdWlya19yZXNldF9wYWRk
cigpIGFzIGluDQo+IGZyZWVfcGFtdF9hcnJheSgpLCByaWdodD8NCg0KV2UgZG9uJ3Qgd2FudCB0
byBvcHRpbWl6ZSB0aGUgZXJyb3IgcGF0aC4gU28gSSB0aGluayBsZXNzIGNvZGUgaXMgYmV0dGVy
IHRoYW4NCm1ha2luZyBpdCBzbGlnaHRseSBmYXN0ZXIgaW4gYW4gdWx0cmEgcmFyZSBjYXNlLg0K
DQo+IA0KPiBJdCdzIGFsc28gc29tZXdoYXQgc3RyYW5nZSB0byBoYXZlIHRoZSBjYWxsZXIgdG8g
aW52b2tlIGZyZWVfcGFtdF9hcnJheSgpIGFmdGVyDQo+IGFsbG9jX3BhbXRfYXJyYXkoKSBmYWls
cy4NCg0KWWVhLCBJIGFncmVlIHRoaXMgY29kZSBpcyBhIGJpdCBvZGQuIEJhc2VkIG9uIHRoZSBk
aXNjdXNzaW9uIHdpdGggTmlrb2xheSBhbmQNCkRhdmUsIHRoaXMgY2FuIGJlIGxlc3MgdmFyaWFi
bGUuIEl0IHNob3VsZCBnZXQgc2ltcGxpZmllZCBhcyBwYXJ0IG9mIHRoYXQuDQo=

