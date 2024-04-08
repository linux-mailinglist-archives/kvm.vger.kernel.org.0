Return-Path: <kvm+bounces-13908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC31A89CAED
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 19:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4301C2396E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 17:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2001B143C7B;
	Mon,  8 Apr 2024 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N5hxqwRo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E311E489;
	Mon,  8 Apr 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712598133; cv=fail; b=QugFaz4vnxMsTS0uBo5nDu3riwC3xHgHYkUgRkQH8Pu8SlmNzYfqvn7/HRi4EdTUY9g5cId/TOz56Fbx7nnBXVe99hgd0iTLtcY3UJDfklWLgEbGdE0mR+R1VUu1XWE72mh/kX+RK7XvVGsuyMJ5Ua4Z0aYeK2oA26/KgKlVCtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712598133; c=relaxed/simple;
	bh=9IQGEACtnYI/pzPB73HuUdCNaF3Ail5BGjF9uCRK4/s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TDkGL8vwERaTI+B612QfB9C2CAwzaO6wmzIboMHRyFuvm907LZKgmpRn2lXpUCYXtfomVrIBri9ZiYwiLKvsvaT3SUS+nTu2bx811BYOC48h8xGKJ9Q95SbKhNJi8hEbqKDa7T686g6SwcNvFKdrk3YKcZHWMG+i8AOrZNesZHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N5hxqwRo; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712598131; x=1744134131;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9IQGEACtnYI/pzPB73HuUdCNaF3Ail5BGjF9uCRK4/s=;
  b=N5hxqwRoZOP60+vD1eIhSk+DFU8jEy4Uocxc6SrV+N3LxNqZtWtGlN3Z
   ZZSbLRlEcWntd5jhoiYkpggtN7eCMRUh3p9xkUkddDqk8qsF47fyerchY
   ud9W5VOn2Ir1ySZLt2N8M5QQ4Xxf9CxWGJImVFJoaIV979qEd+JFk7tF/
   +LKPx/Xr3S2XY+eGzRIrlj5PGeMP6+eiRMQSAsYqF6R3jgp/fixWYwKIS
   GzzeDbPiEWe1aKRD3aKAUD1vhOFtxqb1Db+IUW9F5GmW2G5nNZzz/kH3B
   ATWaRwR457wNr6a0Ker39oajBYVRr02jPEACbK4V0Bol3CZ8sLGAhpmHo
   w==;
X-CSE-ConnectionGUID: Pcoxlik9Rja13LK7ciNVew==
X-CSE-MsgGUID: tP74FS9FTWCTB4UJaNiBow==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="11669554"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="11669554"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 10:42:11 -0700
X-CSE-ConnectionGUID: 9W/vBUNrQdun6/WLZjPzUw==
X-CSE-MsgGUID: oUr2rcf5TgayZxD+x8AQMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="43135828"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 10:42:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 10:42:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 10:42:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 10:42:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 10:42:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP6Pb0CuplKaTRcIiQruPcciatgHONxzhnyII7qyTk2q6jmo7ceavEkq5WKLlgQchGeZ9hnDniNrw8w2uN8BFEWg+LIVeL9d0nAChH8s1IZfR0KQqv6PRUo1jpR5oPgr2utrCuVmKWjnfAmTO2cP+27YUEKTJBr621rOuMnV6QcgFRQ/XW8Lhv3F8F2zhnya3547KOlev7L8xLugcxb7RKwCz0XYUfmIWtmKmbjUFdgeD0dmNx00tJg0VP+UOZNxGqAATRM60zKBnLf65SBqvUiE9bl6Q1xlPqX28mBHV+ksYEuCxO3CZVHN1VK+T7TtBeo0jvQ7jdy0npzFOZMwBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IQGEACtnYI/pzPB73HuUdCNaF3Ail5BGjF9uCRK4/s=;
 b=m2PUOSy7sX+VfBeYnqhSJsUTUJpXNY2AR23Nh9KNXmLF7aRPftkaOqpxnWkoBGHmljEyDNiXwdNXBr7DYoycAnrpxdJH+mQ239iRmoifVDif+UxoEOyh5fjWP/gtjnGyuOaeB2An6USwYJvhrgyYGvjnE+3oCnXARNqy1JY7YZ2vokDnEvlfLXswVvPjnvN8A90bCqsCpzxxuafW1DgfEiReXCgC4eyYgqcTWFkkqulywFM30DtKtS7piNFwzvMqy6WZCVwRVkLBRTpni3o3N5Qrj8pHC829KrPkiCzO932a5W8+ccqfPXH3BRyTFuvso+sIQnrRha88eQPZnER4kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Mon, 8 Apr
 2024 17:42:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Mon, 8 Apr 2024
 17:42:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pankaj.gupta@amd.com"
	<pankaj.gupta@amd.com>, "srutherford@google.com" <srutherford@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wang, Wei W"
	<wei.w.wang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AA==
Date: Mon, 8 Apr 2024 17:42:07 +0000
Message-ID: <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
In-Reply-To: <ZhQZYzkDPMxXe2RN@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6011:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rV9Uxfj9zL8lI2XfQxy8qJxhC5JDkSwuQnivNG7XIsxO0gdH+EEIO9XjP+T2tF9mbBDq5Jxa1ujFKm+3YN+sIS6+00pVloeHJtqcMOnrWuna/5IEf+8DhbkvsWwNZPoNCfOQc5Da7vZRwbCdjmVf500IB9b6EkQC8E8HrULmORZvzMicCz1a09hhxMLYnqUp1nvf1OAL9tNiNOHJ0aXkhLDqD4Dp1+qsCQMDuJMuniVF1jekRpss9Tzb/nJjdZEkfYjQeLXyj+1w0Cpt60M72mrRlU10cQCwHtPdG/Pgnanjm/Xv40yQ8kkkiH0mbr2KlGa6h6JKoUZVS8SGz8NYSsk03/p7XjwR/+gvt67I5wpEHukOpALRBO/F8VCQXRJknDLG1MrHOGPa2prVK7mSFOxorAvSbNNzPhJNxn7FrcGoLqaFcyEDrkpcvoLGh72iDjCrkudLbqOSpOBG3FtLZxTw/jBuU3pW0l3mi1ylx+7swHSh41YQmqSwZLq3cG7+HWIhguueJpYDD51YP2AuMKJX45yw5XX9QjsNF9rBM/qfnSqNtPbwwEzEoG+2ZthEhISQhET1jPVq7jal1s28JzqXb9ywmc+31pS//enBHz0XsufwgRRCt5XvgYT2kGd/OWq2QMp5PONDZ0Mihvjicg19blb8u5z7efoQzU6emqI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHJqZFg1aVpCb0dlZHJYdGZoNXplZlluekkyVEpIYnYyQ2s0eFI0bHBRcVZn?=
 =?utf-8?B?V0UzQ3MrclpLamRGZXVjaklSeElpQnpiZU5FYVYyeU41bkRzdjEwRUpxWUxY?=
 =?utf-8?B?SW43b2lJb3FvTjJTNzd1RmJxVXcvYkRGbk5LOXppMUpRdnlGWHdVV3h4RmJL?=
 =?utf-8?B?bTlPdU4zUk5HYlJIOWhKaVFReXFDTkt3ckplQUlwalpqdWwrYjNQL2ttNnhR?=
 =?utf-8?B?V2M2KzBEUFhXWVV0cXhraVhGV1JiaVNEWHlySG83QkQ1YnVTMFkyVmJRSzhp?=
 =?utf-8?B?WFhrT3FNeDVIbEY3RS8ydTh4NHFRVmZ6NWJxbGdoNTd4dU54YVJmWnZvQWl0?=
 =?utf-8?B?SElnenRUc3A2ckU2WDhMTUkxMjhiTmZGcWVMOE1rOTExd0NNTFpzUXkrc2ZF?=
 =?utf-8?B?cFIzeWYxcGtFRXpaYXVNNUtiZnBCanNQekY2MmgxVll5QkNtYnV1UWFOeHZk?=
 =?utf-8?B?K29ObkhWNm5xS0I1Sm1yUVFINmdDZFJUcG9MWkpNM0pHMXBkS1hkUHdIaW1J?=
 =?utf-8?B?U0pEQ0oyR0tCZnlaT1FGcWFCNFRiMUlFZTBINXZXU3ZBRW9oMlplK1BYQ2h6?=
 =?utf-8?B?VjFoSEd5RGV4Ly8waVpzb2tiVlI1dGtxZndhaC9sMVZ3aE9pMGR4Y2NJTXh5?=
 =?utf-8?B?OWViK0xPUGZEMWtNaXJJUTUveHdTbjNic0E2bCtqeDJRN2RreXQvQnc3L0Rt?=
 =?utf-8?B?UVZIdVRyREE3V2JLaWdpbnFJTjlYSXZ3SEpUeHVXMkVFdlpTb3A2VjFlSXRB?=
 =?utf-8?B?cEZ2WjBWMCs5S0h0dXJxbnJOa2xmM045OWtRTzB5Y092TDU2V2xHYmU3YzVU?=
 =?utf-8?B?SzJwWTFyZTV2L0tFeFFTam5kRjArTVIxRDlmeWdxYWZQTTZWbU9GYWp3THZR?=
 =?utf-8?B?YmF3Y05KREEyUG1qWXJEUkhVeG9DYVNNRitDbUhMSGpncHduZ0gzSUgrRUhu?=
 =?utf-8?B?cUFFaEtlVDF4aHVQeDV1QlpVaVBobVIwNkVGT1U3RjBqbWNPQzgweUx6aGpk?=
 =?utf-8?B?TURvWVZCa0Jkb1JMeTdZWkxyZEdOLzFKWTM0bDFlVXdVems4ZTI4WGZYZTBm?=
 =?utf-8?B?a093em9MRzlXU21OZnFvZ09nZ1YxaFh6NVBIeU9RMzFxRmZNUkxYQUV6SlUz?=
 =?utf-8?B?aVJvc2pRTXFtYjRZS0sxNjdvOHZ1bGxTMHlyYlBvcnNmL3BYWWw5Y2JEMUpw?=
 =?utf-8?B?SFJ6SGFSSEIrK2lZRVNuakd3b1k1TUJJdEUzWkphcEJkN0hSRmVHZTh3OGJY?=
 =?utf-8?B?eVR6Y2lpVU5OTW9NVXd1aUdRUEtXS2xIK0V4RkRPWnRKQi8zeTZuMnJvS1VO?=
 =?utf-8?B?OW5HMS9URUd1WmM0aDhYbjNhNFBJVjdWM0dxKzB1azRlMUw0aG1PYURpN3hp?=
 =?utf-8?B?U0tPU3BUcmFEYzU0WEswcHVFaVVhVHg1YVhFS1U5ZmxKRkxjTVhDTDQrZzNF?=
 =?utf-8?B?ZGo1MnYzWjFRakJIVWVNNWE1a2RmbjgrdU81aEdSNTBmSUlPcXpIdTBlZnpu?=
 =?utf-8?B?cnFTOXQwQStpblJuMHpRdzc0UTdGd0xWYm52dWhqR1lTUFFLZHdRSHVwQjhB?=
 =?utf-8?B?S1RCWS9aMHdQaTFTNHJhWGIvYUlrd1oyRWdJL0hNSXJMWkF5UUhtd2ozWG4v?=
 =?utf-8?B?WUlIUjluRVVGTm5EcThXbXVxLzFUai9hZThudGdxcml2cHdwT3duUlcyQjdP?=
 =?utf-8?B?MVhURU43SmF3NjZteWZFczQ2MGlRckV4ckE1c0dOUGNHcGhlZVAwTnZqcTha?=
 =?utf-8?B?QzYramJxR1FvVmFZeXVPanRHY2xZWVdKQnE5SU5nM2dtSXNjY1dZWHM2cHpk?=
 =?utf-8?B?SHpwNXUyUVNJZk5RNkU4ZW03R2NJc09WWW14UUNqczd3UDQvOWprSHg5YjJr?=
 =?utf-8?B?RmhTajJCOG1MUTltU1l1SE9QamhCTnRLS0h1UEd5VUNXWTVNNWNWRWVyQlNQ?=
 =?utf-8?B?bzhPak1YeUNacVdUckc3YWpUa3BPVFg5M0FuQzU5OXdOSHZuT1RrT0Y5eEll?=
 =?utf-8?B?cXh6aHZ0THZVYTBXUUZJSU5iYXJQUFMxT0xTYUovalJSaWM5QWNBSHlYWXFH?=
 =?utf-8?B?LzRPZGNWWTV4a3M0ZmtNdzRSZnB0TjdIUm9xODhBb3l5R3NaZGpMMk1GU29R?=
 =?utf-8?B?U0NpbEMzS3c1SE1KVE5jVHBnczlOZUFVSlltbFU1ZzlBWVB2Z2hKZ0xGZFNm?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE314BB62124D64F97DF2C6F2B902CBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95450f91-8106-46af-42ad-08dc57f335f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 17:42:07.3859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fCJoSHpcP4gJRpfM/oa/jzgWbm6sJP1/0AcJ16iJJdprrm+6/yCPU0Itv4g6TYcukskHfLWXM0hyc884AlC9FlgwAGNnu4gmjUfQwoQ+HA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDA5OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEFub3RoZXIgb3B0aW9uIGlzIHRoYXQsIEtWTSBkb2Vzbid0IGFsbG93IHVzZXJz
cGFjZSB0byBjb25maWd1cmUNCj4gPiBDUFVJRCgweDgwMDBfMDAwOCkuRUFYWzc6MF0uIEluc3Rl
YWQsIGl0IHByb3ZpZGVzIGEgZ3BhdyBmaWVsZCBpbiBzdHJ1Y3QNCj4gPiBrdm1fdGR4X2luaXRf
dm0gZm9yIHVzZXJzcGFjZSB0byBjb25maWd1cmUgZGlyZWN0bHkuDQo+ID4gDQo+ID4gV2hhdCBk
byB5b3UgcHJlZmVyPw0KPiANCj4gSG1tLCBuZWl0aGVyLsKgIEkgdGhpbmsgdGhlIGJlc3QgYXBw
cm9hY2ggaXMgdG8gYnVpbGQgb24gR2VyZCdzIHNlcmllcyB0byBoYXZlIEtWTQ0KPiBzZWxlY3Qg
NC1sZXZlbCB2cy4gNS1sZXZlbCBiYXNlZCBvbiB0aGUgZW51bWVyYXRlZCBndWVzdC5NQVhQSFlB
RERSLCBub3Qgb24NCj4gaG9zdC5NQVhQSFlBRERSLg0KDQpTbyB0aGVuIEdQQVcgd291bGQgYmUg
Y29kZWQgdG8gYmFzaWNhbGx5IGJlc3QgZml0IHRoZSBzdXBwb3J0ZWQgZ3Vlc3QuTUFYUEhZQURE
UiB3aXRoaW4gS1ZNLiBRRU1VDQpjb3VsZCBsb29rIGF0IHRoZSBzdXBwb3J0ZWQgZ3Vlc3QuTUFY
UEhZQUREUiBhbmQgdXNlIG1hdGNoaW5nIGxvZ2ljIHRvIGRldGVybWluZSBHUEFXLg0KDQpPciBh
cmUgeW91IHN1Z2dlc3RpbmcgdGhhdCBLVk0gc2hvdWxkIGxvb2sgYXQgdGhlIHZhbHVlIG9mIENQ
VUlEKDBYODAwMF8wMDA4KS5lYXhbMjM6MTZdIHBhc3NlZCBmcm9tDQp1c2Vyc3BhY2U/DQoNCkkn
bSBub3QgZm9sbG93aW5nIHRoZSBjb2RlIGV4YW1wbGVzIGludm9sdmluZyBzdHJ1Y3Qga3ZtX3Zj
cHUuIFNpbmNlIFREWCBjb25maWd1cmVzIHRoZXNlIGF0IGEgVk0NCmxldmVsLCB0aGVyZSBpc24n
dCBhIHZjcHUuDQoNClRoZSBjaGFsbGVuZ2UgZm9yIFREWCB3aXRoIHRoZSBLVk1fR0VUX1NVUFBP
UlRFRF9DUFVJRC9LVk1fU0VUX0NQVUlEIGxhbmd1YWdlIG9mDQplbnVtZXJhdGlvbi9lbmFibGlu
ZyBvZiBmZWF0dXJlcywgaXMgdGhhdCBub3QgYWxsIENQVUlEIGxlYWZzIGFyZSBjb25maWd1cmFi
bGUgZm9yIFREWC4gVG9kYXkNCktWTV9TRVRfQ1BVSUQgc29ydCBvZiBzZXJ2ZXMgdHdvIHJvbGVz
LiBDb25maWd1cmluZyBDUFVJRCB2YWx1ZXMgYW5kIGFjdHVhbGx5IGVuYWJsaW5nIGZlYXR1cmUN
CnZpcnR1YWxpemF0aW9uIGxvZ2ljLiBJbiB0aGUgY3VycmVudCBURFggbW9kdWxlIENQVUlEIDB4
ODAwMF8wMDA4IGlzIG5vdCBjb25maWd1cmFibGUuIFNvIHRoZSBURFgNCmNvZGUgaW4gS1ZNIHdv
dWxkIGhhdmUgdG8ganVzdCBwZWFrIGF0IHRoZSB2YWx1ZSBhbmQgZGlzY2FyZCBpdC4NCg0KSWYg
d2UgdHJ5IHRvIHVzZSBhIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEL0tWTV9TRVRfQ1BVSUQgbW9k
ZWwsIHRoZW4gbWF5YmUgd2UgY291bGQgY2xhcmlmeSB0aGluZ3MNCmJ5IGV4cG9zaW5nIHdoaWNo
IGxlYWZzIGFyZSBjb25maWd1cmFibGUuIFRoZW4gdXNlcnNwYWNlIGNhbiBrbm93IHdoaWNoIENQ
VUlEIGxlYWZzIGFyZSBpbmZvcm1hdGlvbg0KZm9yIEtWTSwgYW5kIHdoaWNoIGFyZSBhY3R1YWxs
eSBjb250cm9sbGluZyB0aGUgcmVzdWx0IG9mIHRoZSBDUFVJRCBpbnN0cnVjdGlvbiBpbiB0aGUg
VEQuDQoNCg==

