Return-Path: <kvm+bounces-68638-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKDIH2DGb2mgMQAAu9opvQ
	(envelope-from <kvm+bounces-68638-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:16:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D55D4943C
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:16:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D0EC238E6BC
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7699844D022;
	Tue, 20 Jan 2026 18:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l6Co9d+G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FC744A72C;
	Tue, 20 Jan 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932443; cv=fail; b=G6QArxkXSuNTt2O5tUj+Fj4re4DRbFwuVMr4k7tR5CxxTxD04nHjHvDXR14IHyeNGRLIPjjCgpknAjPxdcBqzcmo+/Hys4XMeXmJC451DV6sHiTzjX08yFdVML2jl4YUv/decaLVQWkvZBY3W2Ba38c30Tp/r8sTm+SCkC7NTJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932443; c=relaxed/simple;
	bh=hBnGWiLDTe0DGXGZQH0FQyWJ8mxaoaZ8IgwH7YJJzZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MaXzO1m2zl9uuCd4SpYNO72pYJ0Jjliee7ccFVKqCvM/jkctIAeApMZCO20c5ovd0jEOeF6fcvlVz6UGnZAd+sBJeCCPN7TSTUU+fGbnvPjH4NPlhV8kPQcVjWbktKiOJ9fv+ZVLLJfZO+idsMhF+g6AGqicNI26BEKyG2mRrdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l6Co9d+G; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768932441; x=1800468441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hBnGWiLDTe0DGXGZQH0FQyWJ8mxaoaZ8IgwH7YJJzZI=;
  b=l6Co9d+GcaTai1SRjF+VxCGx5PSCWwqKZ2nHOBLPdPsWOKFYNU6i2XEm
   wR3wB/GLWUFdPMlcn3V0na6aUvMh8raVNz86QNcsBbOP3U3w81sbda/+V
   ECBgpA+A1urUZmjyFFdx5uc0qdDZGga+sQw5qp69yDB8/0hmxMdetYxs7
   pb/Q0fdh5nLyzTDhtaRWca5U1LrhgSA2nPgFtMRSsOhQ81wadq1IHQ2xv
   XBFUzgN9ncz1N8iVLIBvaZxnEN9yl+qYYT82IX1fio+V2xW8tOPj8a5c8
   wN8Mxjy0qeWDfkZzgF2DsTt4oFz8Bf3TH1vHmYB3WwtLt0ggUug4Jw3ZI
   g==;
X-CSE-ConnectionGUID: 86E4jYO5SWihhHexL4M2tg==
X-CSE-MsgGUID: shM/4ug7RraNn28l0ic3ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="72737636"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="72737636"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 10:07:19 -0800
X-CSE-ConnectionGUID: DJ/YUceGRIq9+qfCIoDg4Q==
X-CSE-MsgGUID: VrnCa1qKTdKYAw0Osf0D8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="210341501"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 10:07:19 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 10:07:17 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 10:07:17 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.12) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 10:07:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8Ln40a6aL1ZgRfHmzd4vx6Df7IsIybL8xxVopb9ZSFJdJiqSVl1hd0jAyAxfzM9ThNAkI55vlRv0oKE/4wP4uv+shOIQOOio+NT6dQHGzxcGzEDHijI2ZjwPdv340v++fQS8WzUB8VEveJOssMKknUkbII/ylV0Bk58wCK2xPmAeDF698EpBjPMrkHxQRKp2ZW0GCmPSRLEYBCegIvPyTSueleap5yvZAgQKRxgR0sYvMcMgdgkWFMNsz79OhjncQSLW4FOwV4XoX5N26BNcrg0wqJ8V90teD+JDhSiXetACxp7sz0Kk6tDYHay0Ot/dJ4B5SkJ1+3xFSee2+gDow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBnGWiLDTe0DGXGZQH0FQyWJ8mxaoaZ8IgwH7YJJzZI=;
 b=SXUAME3CQAz5MHPzNoL3e/Vsn/ipEnaT27IEajzotTzw/BiP/8/TB4WTf6NlffUGkcgLokm2B2ocYxz/IVQ7ONXyDqE5EtvmuOjhubqzPPgUqvwj3h4vqSCXUg07r8lM4962cpzgaiq3ayvTXC/zI7oIzehNKIPQBzALTXqxjM3ends5gHoyuU8a6DmcOaUhxg0sq8yzvoVGl1LUTMGMQA9mYvR3af7Cbs487B63mS/kDCR01IJXUvkpUaTnRrDyN3WZ4RCznjpyU29pJHN4lVNitxSCJQEQJbNNabanHOZC9uu0K9m2TQq0mIVk3egWsgclgO96sss/ps1xYZ8ufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6724.namprd11.prod.outlook.com (2603:10b6:510:1b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 18:07:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 18:07:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Bae, Chang Seok"
	<chang.seok.bae@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>, "Fang,
 Peter" <peter.fang@intel.com>
Subject: Re: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit to
 guests
Thread-Topic: [PATCH v2 14/16] KVM: x86: Expose APX foundational feature bit
 to guests
Thread-Index: AQHciQhPajoUy38nHUuePUWMi6isZrVbXSAA
Date: Tue, 20 Jan 2026 18:07:11 +0000
Message-ID: <ecde45c32b56b4954d2220b8686effd6622866cb.camel@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
	 <20260112235408.168200-15-chang.seok.bae@intel.com>
	 <2dd73d71-ae88-4b17-8229-2cebecca7782@intel.com>
In-Reply-To: <2dd73d71-ae88-4b17-8229-2cebecca7782@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6724:EE_
x-ms-office365-filtering-correlation-id: 908532d3-ae18-4dec-c4d2-08de584ebbf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OHNuZmtyYUttZ3BBVEZnVC85VzF3bkNWK0x4VDhNT2JOdzVhTTZKb3hDa09m?=
 =?utf-8?B?S2xYbjVXbjJQcWJ0ekdsYnR1dzRMZ09wb0ZGMkViVi9udzZZT2d1S2xFSjd5?=
 =?utf-8?B?Rmk0d0I1bTcyWGY4dmU3a3RHcXB3TUtCdno0N2dBTE5RTDdxVkpONUZmcnpj?=
 =?utf-8?B?TUlWbHptODZ3ZU11Ymkwd2sxQUt4ZnV2U1JLVFAxS1p5aGtpdDB3QU1tOU9M?=
 =?utf-8?B?YTB3eU5HZUF6OXI4Z3FSVXJSOHh3bWFld1E2TUZlb08xU1JZRm53VmFxWVM3?=
 =?utf-8?B?ZHdITnZsVzVxeVV2bklhSHRxVkY0VGc3T1BsU0ZISisvRkJNZjRtVE4vRHc3?=
 =?utf-8?B?UDh6MkhGaE16L3U2d2pCaVVZQjZVZTJrOENLaXlYTmt0ZFpjQ3crVVVobkhH?=
 =?utf-8?B?S3E0T2twUjl5Y2hZQ2ZSZnJkL3orTkRubG9sdUk4Ni84TUtCN2ZJOTVHRkR4?=
 =?utf-8?B?U0dQUTN1RktwTmVJOGZqQkkyY3ByeGhBOEhmTTlyT1Y4a2trWEo4eUtWRlhh?=
 =?utf-8?B?d01RVmNKc0RuLytNY0EvblRxeW90a0xpVFFJeHRxTXNLQ3phZG9rYzcrbGVR?=
 =?utf-8?B?NDBVajFQRFZkcmhxVzAvNUJ6bG5hV3JuSFB6NjFDSkpmdmRramFFRTQ5K1RO?=
 =?utf-8?B?cEV3ejlDRHh5SjhkMmphRFRqeXJ4UmlPTHllTEFwekgyUXBrMFZla0dDbG1H?=
 =?utf-8?B?V3k2cWN5aTg0dURqTHNzRHVMQXlUblg4N3EreEtORkZ3bFNOUUptb0RwL0FB?=
 =?utf-8?B?SlMyWkl2Q3AxbTJBSzlBM3JQcGtiM0w5dDcwbEd3RXpoLytSNWlaaXo4TnlT?=
 =?utf-8?B?Ty8wS1NNWkRqN3R4S1RpRzJoL1VNeENpd2p6NmtxUGU1Tnd3ajBIbm9sbFVm?=
 =?utf-8?B?emp0aUxNWE16VWlTWU1rcUVTN3JzcEFkQnVZR1U0MWpINEh3cE1vUnM0UnFQ?=
 =?utf-8?B?Z1p2TjIyd21jK0lhc3o1Q3ZVb1RvcmdicU9maVpZVjFsSHZkS2VPZ2NFZDJ4?=
 =?utf-8?B?dmNvSHJKbkx2U2JPa0dNSDdjeW1OT0tJalVzZlU0Rnh0bVNhSEVzUnNGbFNX?=
 =?utf-8?B?SnRTNk0rTnlTSWcwdnJZWTJVK2hpaDRjSDdScHVGY0FwaGRNc1FKM3ppbmpu?=
 =?utf-8?B?T25VeHhXZFFhYlBJNVB2MUZFem1DSTFYSXVKeUk4b1ZPMXpUM2Q5cDVTTCto?=
 =?utf-8?B?UjFxaUN0a2ozVS9JdVhyelJKOXlNazZvdjNDMDlabnVCaWt4UGYzYlYvWG1E?=
 =?utf-8?B?NXY0a09MM2h4dFZzcWo1V2w0aFl2b1c1a2NjSzFRSnBMOGY4Mkg5ZXpwZVhh?=
 =?utf-8?B?eElaZ3Z0cjQwRG92V1BMZ09JQWF0V1NHMG16Y2xyL3gxa08xSDNtVjhhYTNK?=
 =?utf-8?B?VFN4UDdDb0hiaHBQZnpZelk1ZkFyRDhyVmZEUjQ5WHBzLytySVZ0QVAzV0F5?=
 =?utf-8?B?d0ZzVzNnSFBNeHdyVEN6aVIzRUcxQnk2Z2RWNjdTOVhpTk54ck9ERFllcmp5?=
 =?utf-8?B?WFp6eXRPSVNlcUhybCtmSzcyQXRqb25YVkZXQ0x0T2s2UHlZZHlseDBmdUx5?=
 =?utf-8?B?cFJHd2pmb1RMbjIxVzdqTTVSUys0a2lXMGpBYXB0YXlNbEhhSVJjbzlOcGVz?=
 =?utf-8?B?cHFaZldhVmF4NURyMkZNbXBNd2VsZ2kwbGdLZTMrMEttWVVpN3NWZnBPOGZQ?=
 =?utf-8?B?Y1RVK2RqR0ZkbjVPc2dONlgvMWJCbytJcjEzU2t3WFdtdDlPSXo2WjU5UE9L?=
 =?utf-8?B?aitEejFCbitEazR4dmNramlZZE52TTlIeTJmSTc1K2Nsa2NGTGFRR1gxaUxk?=
 =?utf-8?B?OUtFTExsOE9IaWQwVVRCeUtkZWlDa0FTZ29ZditPcDJPM2IralN3Ui8rVHMz?=
 =?utf-8?B?RHhpcERDTzZJZ2NSMlpEaFB5S1M1VGp1VnRpQm5NUHhqczdhLzFvdTltWm5K?=
 =?utf-8?B?MlZkVHBKWGFOTTIwMjN2czBOM3NXa1NGMzRUVGNjVmxUZk1Dako0eU01a2lK?=
 =?utf-8?B?TkVmQzUxeHA4c3p2RnJjakR2KzAwYVYxc1FvN3JLK25Icy9hU291ZGlHSmNw?=
 =?utf-8?B?ZXJTNEgyc2h6aWRETHRoOVM4NXYya21lZHoxZVV4YXBHTVBOVFNvMElKa0dN?=
 =?utf-8?B?LzRBUlNLOVpRYmNsR3VDcTVKdSsvQXBvZUpMYWgxMzBaMTlKK3JsQ0w2ZTdK?=
 =?utf-8?Q?fkYQ42ONahDsEHGSEtOB/k8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2hxemlDVXhXWFF6R2lINnBNNkFIWGhkTVpIaWRhVXlZczFrTlM2TStpTElR?=
 =?utf-8?B?eTNyVnZXdE9uVVZ0dWRvVDN5emtIUkowWmllbnJrSUlzVkIyelNCeDd4Yzkr?=
 =?utf-8?B?a3Zrdyt0VW5ab3RjMEQ4VnBUY1p1M0JsMTVZM3NHWERIK1ZOWkxXUTJsOElF?=
 =?utf-8?B?allOUUo4VTQwcEJrYkpDY1QwVWJxQ2N6R0JPVnhDZGdmdlE2K3FNckNINVl2?=
 =?utf-8?B?Znk2ZDlBVzY3c1ozb0FOSjBMWEY4dGVWRUEwWWtDTU1VQTJTWGd4emlCbFFp?=
 =?utf-8?B?amVHSk8wWU5VSjVnajZCQ093KzZibFBJN0JBTVlBUzlTZnVDK2dySXlCYTZJ?=
 =?utf-8?B?L2tlV2lhUG9kZWxFTVRWd3Z1TG9DT2tSbXR3cVdGb1lPY0YrdFB4YW1VeW52?=
 =?utf-8?B?dk5abWZsTFV0bFdUdkFCTzQ2SmUyMU16TTFqS0hkWHFJcGRlMHBIUTdYdWxy?=
 =?utf-8?B?dUZmdUhUMG5sU1lsZnNRS253MFVEQVpDeWkrWDlXWWtJR2NrYm80TEIxSVNU?=
 =?utf-8?B?YWZwSVR1Wmw0Um4yVENGYjdLS3pzT0E0Q3o3OE9BVWluY0wyQmNnWUFZZjh0?=
 =?utf-8?B?TnUyakpGZU9oZGExV1oxOCtIZE5DTERFU01mdmxtNFBGaHIxd3VUT1krNFNT?=
 =?utf-8?B?WmJmWTNhS1liV0twQmhTUHhkV0pRUWQwNGhlVzg1SHdFWkpTQXp0dTVRU0NO?=
 =?utf-8?B?bXlGYXJMOUtpYkRja2pZbWg0VWk5dmgrTmZ6c0diK1ZXcFVFVHcxalMwdzNQ?=
 =?utf-8?B?YSswby9wdDhhY0xSYTJYVUpPWjVoODVOSW5HaFprb2ZCYU5xR1F5c1JrSVJC?=
 =?utf-8?B?RnBPcFVndHlOUDFZdmVNOFlpMVVob1dhRFRHRFdUaW9YNHh3SDg2WVR1YXdE?=
 =?utf-8?B?L3pBVXBOSUZUdFFJWDAzN3hWMXp2MXlBM2d2UDVVMThsdmJVTzYxUjhEVE52?=
 =?utf-8?B?cmRENkRhVFNZSU9OZzd4ZGljV1czaUgraThOTlJsdUJBN3FaMzlFajhVS2dS?=
 =?utf-8?B?cnJyOFE1NzIybDczR3VPU3JWUkNVTG9VWjBEYVNheHFjVG9BRjJnWTQxRVBj?=
 =?utf-8?B?dmVYWHpNbjA1cnlwdlBDc0RQUWdoZnJReDdzU3JEUkx4eWZuQlVnVlJMcjJS?=
 =?utf-8?B?WTRTN1hHNzFwVlpVamdZRUVvbHlERW9NZGxEdzd3VHJ0NjV3R05RY2VETFJY?=
 =?utf-8?B?UkZ4MmZFanJsM1BPK3Z2QnRFZzFjUXlDYmsyblRsTERzR1JSeGZSQlRYWm1M?=
 =?utf-8?B?RWRkYVFFcjdUZ3dGM2xUNVNiUmZPTTAxcTdKU3VUYWtWbk9WUjJvOXM1dEZO?=
 =?utf-8?B?MHBZdVdDZGNvS25ISmNNN09INUNPQ25kZGE2Q29INGxIMWxLZ0VDZTRsOWc3?=
 =?utf-8?B?Zkc5Z1I1bjJXeitPVzdSMVU1QWVIRzQ4UEVJblBQOUdHYkkrWVMyR1JSUE1H?=
 =?utf-8?B?Nk1jcmxyd0hWV2tpVklvSU9IcE1jejZWUE5ZVkN2MXBISHM5RjRSdGtnVG9t?=
 =?utf-8?B?dHFha0liKzNhdFJCenFkYVJ6a2U2cE83KzB4Ti9vMmo3d3g0bldFMnh1eGFa?=
 =?utf-8?B?WVovVS9NemlvUlQzaXFyTzZGWHhwYVlSQkZSK3RyRUNRQzgvUi9tK3BMSHNH?=
 =?utf-8?B?d2YybU96em1XQkpHWWdKZmJqWEc3UHVwM0JXbFd5blZJcDIzZHpJVUJmOERi?=
 =?utf-8?B?ZDNHTnBKMnRyZ2xYSDlEcEQrQTB4aUh3eDlWdSsyU2thUGpFcjBrOEJEd3Bt?=
 =?utf-8?B?V3lQZkZWb2RaWW1Hd0NKSmlLcXMwcEZocHNYQmE2VVFTSkdwcW1HR0poVTNz?=
 =?utf-8?B?dEVGaW5ZUVU4V1VwWnRnaUFBYVlNUXhBL3BZR0w1SDByanJWWDNhRFFqOWl3?=
 =?utf-8?B?ZzlXSzF0TVo0dXJQdjJ4Slg0NURHSU8wNzVrbm1XMkM0clRUdDl1Q05Zc0tM?=
 =?utf-8?B?Q3RqdWNUTHRnUERQR0VSejlYeHVuS3lSUWlRR01pRStQd3R5RHR1Nnh0R2h1?=
 =?utf-8?B?NWFtQWZDQWQ1L0g0bjdkcVJ4NlhSQ3U0WDVCbnVxbWY5L2FnYkFUdGgvVXdM?=
 =?utf-8?B?dEdoVXQwSS8xVkM0dHZhbGo4ZVdTd0pldVlsdlVoekpSeWVPL3NkS1dpS2tQ?=
 =?utf-8?B?NEdNTGFsdFBsV3ZBN0tMbHBRNi9acVRyeXdWOUhZQUNKclR1Qk04TnJFaWdr?=
 =?utf-8?B?dFpEZFpVUzlVeTJOalpWWTN5b2ZBWmJXM2NWbGNobGl6ZzMvcSttUUZMeCt1?=
 =?utf-8?B?V1NBYThrTHM1UHZtVnVrSTd5dGM3RFRyYmVHUkpoSGkzaktWY2dMVm9LLzAr?=
 =?utf-8?B?SmdvVjNIZHVlNm9WbUtLL2YxaFJ5OE1ac0R2WHpaNXpxUWxvS0xORmhsRExr?=
 =?utf-8?Q?r0yd42HzSBw3e5yM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <461DDFBE1BAE96498B51F97CEBD3210E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908532d3-ae18-4dec-c4d2-08de584ebbf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 18:07:11.7120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfTQJg9NsnB+t1QeFVYBZGOeCubEev3YwP9CP4Z13Sm8/Og+f+Vsl5enpnVVeKoZ0C8DZj0NXvrhK4QubcA2lF2YQArMupVifI4ZARmdUvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6724
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68638-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,intel.com:mid,intel.com:dkim];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1D55D4943C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

T24gTW9uLCAyMDI2LTAxLTE5IGF0IDEzOjU1ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiAr
IFJpY2sgYW5kIEJpbmJpbg0KPiANCj4gT24gMS8xMy8yMDI2IDc6NTQgQU0sIENoYW5nIFMuIEJh
ZSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYv
a3ZtL3g4Ni5jDQo+ID4gaW5kZXggMTg5YTAzNDgzZDAzLi42N2IzMzEyYWI3MzcgMTAwNjQ0DQo+
ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5j
DQo+ID4gQEAgLTIxNCw3ICsyMTQsOCBAQCBzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IGt2
bV91c2VyX3JldHVybl9tc3JzLCB1c2VyX3JldHVybl9tc3JzKTsNCj4gPiDCoMKgICNkZWZpbmUg
S1ZNX1NVUFBPUlRFRF9YQ1IwwqDCoMKgwqAgKFhGRUFUVVJFX01BU0tfRlAgfCBYRkVBVFVSRV9N
QVNLX1NTRSBcDQo+ID4gwqDCoMKgCQkJCXwgWEZFQVRVUkVfTUFTS19ZTU0gfCBYRkVBVFVSRV9N
QVNLX0JORFJFR1MgXA0KPiA+IMKgwqDCoAkJCQl8IFhGRUFUVVJFX01BU0tfQk5EQ1NSIHwgWEZF
QVRVUkVfTUFTS19BVlg1MTIgXA0KPiA+IC0JCQkJfCBYRkVBVFVSRV9NQVNLX1BLUlUgfCBYRkVB
VFVSRV9NQVNLX1hUSUxFKQ0KPiA+ICsJCQkJfCBYRkVBVFVSRV9NQVNLX1BLUlUgfCBYRkVBVFVS
RV9NQVNLX1hUSUxFIFwNCj4gPiArCQkJCXwgWEZFQVRVUkVfTUFTS19BUFgpDQo+ID4gwqDCoCAN
Cj4gDQo+IE5vdCBhbnkgaW50ZW50aW9uIG9mIHRoaXMgcGF0Y2gsIGJ1dCB0aGlzIGNoYW5nZSBl
dmVudHVhbGx5IGFsbG93cyB0aGUgDQo+IHVzZXJzcGFjZSB0byBleHBvc2UgQVBYIHRvIFREWCBn
dWVzdHMuDQo+IA0KPiBXaXRob3V0IGFueSBtZW50aW9uaW5nIG9mIFREWCBBUFggdGVzdHMgYW5k
IHZhbGlkYXRpb24gbGlrZSB0aGUgb25lIGZvciANCj4gQ0VUWzFdLCBJIHRoaW5rIGl0J3MgdW5z
YWZlIHRvIGFsbG93IGl0IGZvciBURFggZ3Vlc3RzLg0KPiANCg0KVGhhdCB3YXMgYW4gZXNwZWNp
YWxseSBvZGQgb25lLg0KDQo+ICBFLmcuLCB0aGUgd29yc3QgDQo+IGNhc2Ugd291bGQgYmUgS1ZN
IG1pZ2h0IG5lZWQgZXh0cmEgaGFuZGxpbmcgdG8ga2VlcCBob3N0J3MgDQo+IHN0YXRlcy9mdW5j
dGlvbmFsaXRpZXMgY29ycmVjdCBvbmNlIFREIGd1ZXN0IGlzIGFibGUgdG8gbWFuYWdlIEFQWC4N
Cj4gDQo+IEknbSB0aGlua2luZyBtYXliZSB3ZSBuZWVkIGludHJvZHVjZSBhIHN1cHBvcnRlZCBt
YXNrLCANCj4gS1ZNX1NVUFBPUlRFRF9URF9YRkFNLCBsaWtlIEtWTV9TVVBQT1JURURfVERfQVRU
UlMuIFNvIHRoYXQgYW55IG5ldyBYRkFNIA0KPiByZWxhdGVkIGZlYXR1cmUgZm9yIFREIG5lZWRz
IHRoZSBleHBsaWNpdCBlbmFibGluZyBpbiBLVk0sIGFuZCBwZW9wbGUgDQo+IHdvcmsgb24gdGhl
IG5ldyBYU0FWRSByZWxhdGVkIGZlYXR1cmUgZW5hYmxpbmcgZm9yIG5vcm1hbCBWTXMgZG9uJ3Qg
bmVlZCANCj4gdG8gd29ycnkgYWJvdXQgdGhlIHBvdGVudGlhbCBURFggaW1wYWN0Lg0KDQpXZSBt
aWdodCBuZWVkIGl0LiBCdXQgaW4gZ2VuZXJhbCwgSSBhZ3JlZSBLVk0gZW5hYmxpbmcgZm9yIG5l
dyBmZWF0dXJlcyBuZWVkcyB0bw0KY29uc2lkZXIgdGhlIFREWCBpbXBhY3Qgbm93LiBGb3IgQVBY
LCBpdCBsb29rcyBsaWtlIHdlIGRvbid0IG5lZWQgdG8gYWRkIGEgbmV3DQp0eXBlIG9mIHN1cHBv
cnRlZCBmZWF0dXJlIHRyYWNraW5nIGJlY2F1c2UgdGhlIFREWCBBUFggYXJjaCBpcyBwdWJsaWMu
DQoNCkNoYW5nLCBsZXQncyBjaXJjbGUgYmFjayBpbnRlcm5hbGx5IGFuZCBmaWd1cmUgb3V0IHdo
byBvd25zIHdoYXQuDQoNCj4gDQo+IFsxXSANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
L2VjYWFlZjY1Y2YxY2Q5MGViOGY4M2U2YTUzZDk2ODljOGIwYjlhMjIuY2FtZWxAaW50ZWwuY29t
Lw0KDQo=

