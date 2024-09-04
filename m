Return-Path: <kvm+bounces-25885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 264C096BF7B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49F2D1C245A8
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6A01DA611;
	Wed,  4 Sep 2024 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NV1JyW/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC601DA602;
	Wed,  4 Sep 2024 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725458526; cv=fail; b=cBqjGeRV3qltU8fXpUUxGcHw8HuqivsprZaLPER18842RIl9nlefXXM4KFo2uICNhT1kO2xBLEcKKozRazOgKbq6kDdZ5CuONLCmJjQwpQ69uo9uxNXtgntlJfjkbx0xF8P/kScSxXm6qQqtzMKGXtNhh0CmTpgcTBrMiIpY7cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725458526; c=relaxed/simple;
	bh=JS23WxxsloS+Wrr18FpL6u4e+312XAnYDHhZCrgaa30=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rYxtCNm/hGCDMhOcHdD9gNVxBGhObxhYwqgL4K4VsvpvxK6X+z6IIETI+DOHHqxcQWPOUO3OQaYEKbajW1uc8G5FlILepF3EXJZab2DCJAlOEp1IvXQD/JRseOq1KV0y7uZBTMATWhi0frZPYODK1rme8RYaWvID02Ccv4q0xdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NV1JyW/Z; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725458526; x=1756994526;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JS23WxxsloS+Wrr18FpL6u4e+312XAnYDHhZCrgaa30=;
  b=NV1JyW/Zq65uqSPXIYBNXX74lMJbrRmvszzA0cdCJQbC6NrOv8XJslkS
   72RUhEpgthz7icXmk2mYm93LZ1/ydm4Ronyud5O2pQ+FrOQySNC3SDRWE
   8EppJadyt8HxtqbVonleQ5t9fdQeVgQjsR0khCe2772izr1+4hWret/zu
   jlkpd/I2CFOJk/px+hygVqlOOWDqmTs5MzWYy5ybvWG8Xm8nSlsU0S8fw
   rRWK2TNmZZsiI+YlHMp1vhqLrnAiNrDcqqdo1wwdA82NxJ7+6d6Jn2FUz
   ig8xb5Udo53X16yp48Ht4B09LMl1aBvxK8JiuPSNh859fxgkUvoHBuY5P
   g==;
X-CSE-ConnectionGUID: f1rvI9leQfWhiya/CJ1tjg==
X-CSE-MsgGUID: ujqomCrMTEaimRPGBMRkwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24262353"
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="24262353"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 07:02:05 -0700
X-CSE-ConnectionGUID: WN/HibaJTIScIaNC8XE1Gw==
X-CSE-MsgGUID: YPpdZvp/TWCCYPczgUuSjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,202,1719903600"; 
   d="scan'208";a="69442420"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 07:02:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 07:02:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 07:02:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 07:02:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 07:02:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PUnKgry1cBECdILQ9UbyMiKtP4LQQH1ceaAMp6X0dgFdIPoV7kHscHGBIJr+ZJC1KHhXoQPok/hI43QhkBFSgKJC05Cc7QMRuNiIedma94KoPGDfFI9sxZzMheqX9xZJun0J3GHrbkWMJPw9O0BrhYA0vUBQvywmzsPpqYWHcGs2ByiqwkHLI+RTEN452OjTxY13XHMDPlaL4Lw203EwL6BkRhhE1MNEIoShXuJPxyVDDSjDPI92bB/i+LJXsyRim+rSPdLrQbpLfsS6d8UM+48Q5tw7cO5jCEcSbvZhyd0VDpyN2ciQM/UYoTTkhLkNLD+lFzXNMW6iXpFfOyE0NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS23WxxsloS+Wrr18FpL6u4e+312XAnYDHhZCrgaa30=;
 b=iV+qIYLoJ6ekBFzVEEuiFvNB8buHELjJciSdaTaszvDeNEw/PePvAXvogyZh9Z09hYfD9IwB4PlebMgpdpKh4ZD7u4LIEFFRm3fUrp1g47FoxiOvHmKs8XAbf2c124IBmoPCuGp59xrmLyp/xr236guMZsgEO1r91DfFCnXEDCPk7kFC0Z0KgevCIPuMY+wBVPddtSKn+A/uBJfn+fzwwW+FrDLw8Fb1kR4fyPZ1pcsr2bUAYRUbcF6Jc6A0wZaRnJlweRHnIr9P4CYwBxL91KJqnoB5BRUNErrS4FGo6Jd2ytsJKURxoY/7s7xLHSEwgvT3Ib6oIqbKSqOQGJSg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8398.namprd11.prod.outlook.com (2603:10b6:208:487::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Wed, 4 Sep
 2024 14:01:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 14:01:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Topic: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Index: AQHa/ne7pTzhAEMIUUeBkR4uOlaw8bJHD/cAgACZDgA=
Date: Wed, 4 Sep 2024 14:01:47 +0000
Message-ID: <925ef12f51fe22cd9154196a68137b6d106f9227.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
	 <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
In-Reply-To: <Ztfn5gh5888PmEIe@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8398:EE_
x-ms-office365-filtering-correlation-id: 40be6ddd-350d-4248-17b1-08dcccea1dfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R25laHZGV1c1LzZWY3NPVlc1Q1pRQVgzcEw3MnR5djlyMHEvQ3Rudyt6cmRI?=
 =?utf-8?B?TnYrUVpVZkwrZlV1ZzVqVlMyYW9QV0VXU0QwL3czMG9XckllOCtBcm5iYzlU?=
 =?utf-8?B?MS8xd0NLMFhTRGdSclVJTzd2aEJuck0reGIwSGhLNUUrbDdTTU9yRmVsVkNV?=
 =?utf-8?B?Z1FWVlBxQklaNmFsODVmTFBnQTcyWDkwQjUwZm9hbUoyNDZRZnMvZ2dVYXNm?=
 =?utf-8?B?ekVETHgrbzF1Ym82QW9oRTNQcEtrT0M5bThtcitjOFIvZ0RjUGk3Zk5XM3Ew?=
 =?utf-8?B?TXg0SDVGTzlvSHpBMTNhTEswT2hMbWpGYStXR0swRGJPUFRqdVQ5eU9GM205?=
 =?utf-8?B?TXRBcDVrcFVjeWl5RDhURW01ZEZHQlJKQ3RXaVUrM05EM21PeFZ0dFNVU09C?=
 =?utf-8?B?MWNNYW9vK3h0cE9rYkM3d1lFNVhTWWtpSUtaSFhHZjY4U2laUm9HV0crUWRQ?=
 =?utf-8?B?OHpkZkNxY2E0ZnF2bnNqdFovN0EvQ0lhZnV4Rmo5enJ4Z0EvMEc4QnNoTG1m?=
 =?utf-8?B?OTM5SFc3TW00bXdoMVNJZmZKMjVMV1JlZFFvSE1FaU5PWGxJSG52Q3FHbVJZ?=
 =?utf-8?B?eW9WUkNhaG45S3pGSjdVamxOVm9vUkczQ1k3Qytad2ZKN2hyRGNtYWxOYVFC?=
 =?utf-8?B?RkpnMThhMk9lMGV2SWRTcGJvcnBNSC8zZU00dmVOcDRLR3RoQ0QxVmM3d3Bo?=
 =?utf-8?B?R1I4bVFDdzlBb1pXdmV1WXdKKzVRRXZ1L3pRTDArUmhQNTZ0QklmR3QyQU5S?=
 =?utf-8?B?YTJsY3IrbGFGSTBteHQvWXJtSkJCUnVPQ25BZFBJbTFPcEhJVENlZWZYZ2k4?=
 =?utf-8?B?bUdSVGhTamFzcmhPMGpqMU9sZHZURFFRQ0R0TjZqSmIxV1BQQ1pWKzRwQlVT?=
 =?utf-8?B?NlRhTzVVWmpBOXBrOWE2SnBIdTZyQm9WclUxL1dQeXR5T2VYY2pqNmhEckgw?=
 =?utf-8?B?Tm9DMFBNK1VXU29JcXB5N3JvTHdMZllQaHJXd3lLMnFBNmVwMkVsVGdqV21o?=
 =?utf-8?B?am1ucWFMTFBsQ0FLeGh3MkkvNi9mOHFDb1V3T0Q2RG1pRENRS3dUZnZ4T3RV?=
 =?utf-8?B?T3A1NXBKQ2dpZnFSNkpOS3pnZStDM2VYVjlQWGNwMVRuMU9WVWpGZ2VGRUU1?=
 =?utf-8?B?R2dHVzJuVmRRMGlWMi9RTlAwdGl4SG5xZ2llVHJMQkVzWmpqSmpJY3Nod3N4?=
 =?utf-8?B?eDZjQmp0a2ZFQWh0Y044c0dXNm9MSHQ4aVY4SnRiRTdYbjBxc1NtbWhNeURU?=
 =?utf-8?B?aXBUcDU3NnBMM3Ewa2ZEWSsxRVRlN2RuNlRoa09lRi9YRFY3eGhpdnNDM0xY?=
 =?utf-8?B?RDRCeFRVdDVoTk95S3F3YUxlOWVsNm0ycGt6RTBBdm1naldFdTN0Y2FCekg3?=
 =?utf-8?B?WEliaVBlRXBCRHdFUFN1VkpPSWQ3NkpVWlN6RTk3b215WWVZQ3FJSXJFbHJZ?=
 =?utf-8?B?bFI4UzVlT3RrS3F6Y1V6QXpPVHV4dGFWZ1YyQ0VYUFlwYTYxb1BxdTZLWnJG?=
 =?utf-8?B?VVF6QjVYREZUZ2l0bzhxUnlQa2dYNGF0Q3FaaVdVVlJacXczblpDTWlaVFFU?=
 =?utf-8?B?cWVTeFE4R0FjNzBXcDk4dDVWZ0dsdlJxMFQxWG0wYitNUGM2M21odWV2WFdm?=
 =?utf-8?B?TFR4TC8vdEk3dSs4cVZ5SDA2OXBQTHBUVzVuTXowS0hXQjJoZUxDUzJmellv?=
 =?utf-8?B?MUlzYzhBeTZXem9kUHVOQWN3QmQ3WXpuVWxBUUk4QWN2MEN1eUFKelZNdUJR?=
 =?utf-8?B?OTNweGsxR1VKbnpKOVpKU2xkYklaVEVKc1RhUThySEZiSEJFMWMzQ3k1Q2Fw?=
 =?utf-8?B?R0NGWVNCN0toUTZHZWthS2xmTHFJMTBUZ29TZmdkN1lWbVZvV1JmWlllaWdR?=
 =?utf-8?B?cjk2TGU1d2o5a3F1d3pjL3BNNEUxOWs2b3BERnZ5U1puZnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmhlaXIvSGFybExvZFhxbmIwRFZJQkQ2UjlsblBCdGh6TjF4eUY0QXJmWEJx?=
 =?utf-8?B?dm1RQUpZalFYaFUwWVNqckNRUW54akxmUHB2TFN5VFNvQVF2ZWNjc0ZjVkZO?=
 =?utf-8?B?TVJDdUV2RXlJbTM1Y25mMHBEYTVFRlRFb3paSEhXbVZQdVNOcEJzWTFjT2hB?=
 =?utf-8?B?S3pUUEdpRWZjTnJrYm5xMUVZWXBrcEszbTY0Vzc3SWNWSlUycFgwNW0xYzJQ?=
 =?utf-8?B?YldnTFJUZytNLzlaRG1QVXlXTFladTJuTDRUR01IakRJTDhkM1BybW83cnc4?=
 =?utf-8?B?cFFmS2R4VVdQMVNOcXRFUkRsZUVMVXExSEc2NzJjaHhTNDI4Y3lFdzdUM3FK?=
 =?utf-8?B?QzFnakRVbG4rc1pPeWZzSmdkY3ZFcHZDS0x4Y3dkN3BLWmpXUzM4RS9wVE5L?=
 =?utf-8?B?a0RtSVM3NnZ3ZmNxdERYNFNYQnV2bzhHTksybEJCNDJoeFBtL1cxampYTUM5?=
 =?utf-8?B?ak16SlJIeWhDc1g0VTA1TmZLUVdjaTc2UndjMWNMczd5a0dHOFQvMERYU24z?=
 =?utf-8?B?S3dLQjUwa1kraVN2Yk43cXkvanZNRUp1Zm1pRGZobFhWN3FDSHYyWjdlTFNN?=
 =?utf-8?B?M0tTbjlDQkxDbTlFdmRIL1hNd1lidXlianFMWGFBUVptS1J5YWo2OU1YQkZu?=
 =?utf-8?B?Z0UxWVFEQkQ5djg2UFZkWUZUeE9ONWhvT1kvMHpCY2F3bHJEUm9INVo3UTlO?=
 =?utf-8?B?ZFEydmZzRkJqYTFheGJtaXZQNWVCcjRkVmlhNzBZNDI0dHNCUldsU1JhalhK?=
 =?utf-8?B?RjladjVXcXJrSkx2QmNkYTRDV2RBT0FqZ293VUJlb3JNMXR3NmtIc1VyNzRE?=
 =?utf-8?B?WlRyYVljbDNZUm9WLzFZTlUzNkkwcDdSbzZSMWFicGxKcnFPNXBWUEwwU1E1?=
 =?utf-8?B?YTJjVS9vaTBFSkl5ZlFtQjlqcHVyZjJveFVVK0lBdDVaSGdTL2ZOMm1ZOGlO?=
 =?utf-8?B?Ujk3eXZ2a3prSFhUZXRiZXpDTkNsdEFxd3hYaUxSMVpFQlpYR0Y4MGJCdk1P?=
 =?utf-8?B?UER3OEdpVHAyYU40b2pzdWQ4WVFsSEt1elFZcnRnSUdQR1RtWS9UUGhSRlpW?=
 =?utf-8?B?M1BoaUlnbnJEakpJS1I2TkhZRldYSWhseVBYaU9ZUndySG1oN3kyWUJocVVK?=
 =?utf-8?B?U1ZRdTJNaURNVjM0QVF0bkh6Q3BpYVZ0d2tCVWI0RmJxdGdDRHdPZ3Zuaktm?=
 =?utf-8?B?ZVpkK2MyQ3lpNklQREs1SXo5Y3FZTld1SUZjakExd2pRV2FTK0lCMnZRbDI5?=
 =?utf-8?B?aTVsZEJWTlBvbHZKYjh5NWg2TFZOTEV1T28wUkpHaGlxZVpJU1dsQWQrMys4?=
 =?utf-8?B?ak5BcGxoWmtLTm5yVG1NZ2VmeG1rTDFIaFlHVGJsRG1jSmVJemtxV3k0QlUv?=
 =?utf-8?B?SXBnRDhsVTB6U3pJUm9JMFNaNGV1cnR1bnlZSUtRZWE1eElnV3B2aExadGph?=
 =?utf-8?B?VmlxZnNHU1ZwOUJSc1o4ZXl1YjR0RXRxV3ZjWUlJQURUNGx3cUpPczF1WGpH?=
 =?utf-8?B?b1NxR0hCMldxU3RXTTR6dlNTRzM0MkVDV3llcGt2RXcrczlQcXBNMmxmRnp2?=
 =?utf-8?B?RXhUdWRNb3RaanZEM3drOHVQS3psTVZGd1pyZSthd3Q5Ykl4bVBuTXlnU2dJ?=
 =?utf-8?B?MXFNZkFOUVhJc1hzWmpZeUJpcnFXWHpXM1Ntb1JLODNnNm04N3p1M0ZONDRa?=
 =?utf-8?B?YlkzY0J4VDJwN2dTcjlaUDFhSWpCQTk5Qkwxb1ovcVRJbjZKcmFVOGNZQlR2?=
 =?utf-8?B?T2g4TE9uZnpFNyswRjVCKzJKQVhjUlJVWEFBa1AxYlJPMlJpR2tqNFNMeWdn?=
 =?utf-8?B?K0lEYXNzMnFKNmE5VUZkS1pJTUwzNGVTdSszTWN4TGx5R0UyTmRwTWI2WS9o?=
 =?utf-8?B?Vzd0aXpzdWtnZURBYWsrSkg0eVE5NkRtcEtQVTZXRGl0TktsY0t6bFE0V0V3?=
 =?utf-8?B?cGlYa1ZIRS9uUkFMVWxaWUQ2V042K1VOUWYzazJoYm5rbG1BQ1FMUkdlcHNM?=
 =?utf-8?B?QmRIcXlIYS9LZEFUL0xSVUd5eHFZcXhQT3Q3VUpTbmp0T2pqRFB6dmphd3ho?=
 =?utf-8?B?R290TzkxSFY3YWcvZml1dXFqMGhjbkFpRHFoYSsxa1JmcFp5QlVkYmJGQStE?=
 =?utf-8?B?Y2pFTXoxSFNxeTEzMVhYL3VEU3phc1JvSURheXdSZm9iRUNUUi9jTmpUdlRR?=
 =?utf-8?Q?er0qwlY+3y5fYUsB6+YjI/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A742CD15916EC49AA73B3356080A448@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40be6ddd-350d-4248-17b1-08dcccea1dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2024 14:01:47.6481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M07U126hd4iH0Oyn6cUdJt+rSinnYXf8g4Bn1UH64vGnAS3E02nBWzVN+q99jwwPH3RaP8bSvMzmsU30VkmX9eBPt/l01riw288yxsxGp1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8398
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTA0IGF0IDEyOjUzICswODAwLCBZYW4gWmhhbyB3cm90ZToKPiA+ICvC
oMKgwqDCoMKgwqDCoGlmICgha3ZtX21lbV9pc19wcml2YXRlKGt2bSwgZ2ZuKSkgewo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldCA9IC1FRkFVTFQ7Cj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXRfcHV0X3BhZ2U7Cj4gPiArwqDCoMKgwqDCoMKg
wqB9Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgwqByZXQgPSBrdm1fdGRwX21hcF9wYWdlKHZjcHUs
IGdwYSwgZXJyb3JfY29kZSwgJmxldmVsKTsKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChyZXQgPCAw
KQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3B1dF9wYWdlOwo+
ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgcmVhZF9sb2NrKCZrdm0tPm1tdV9sb2NrKTsKPiBBbHRo
b3VnaCBtaXJyb3JlZCByb290IGNhbid0IGJlIHphcHBlZCB3aXRoIHNoYXJlZCBsb2NrIGN1cnJl
bnRseSwgaXMgaXQKPiBiZXR0ZXIgdG8gaG9sZCB3cml0ZV9sb2NrKCkgaGVyZT8KPiAKPiBJdCBz
aG91bGQgYnJpbmcgbm8gZXh0cmEgb3ZlcmhlYWQgaW4gYSBub3JtYWwgY29uZGl0aW9uIHdoZW4g
dGhlCj4gdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZSgpIGlzIGNhbGxlZC4KCkkgdGhpbmsgd2Ugc2hv
dWxkIGhvbGQgdGhlIHdlYWtlc3QgbG9jayB3ZSBjYW4uIE90aGVyd2lzZSBzb21lZGF5IHNvbWVv
bmUgY291bGQKcnVuIGludG8gaXQgYW5kIHRoaW5rIHRoZSB3cml0ZV9sb2NrKCkgaXMgcmVxdWly
ZWQuIEl0IHdpbGwgYWRkIGNvbmZ1c2lvbi4KCldoYXQgd2FzIHRoZSBiZW5lZml0IG9mIGEgd3Jp
dGUgbG9jaz8gSnVzdCBpbiBjYXNlIHdlIGdvdCBpdCB3cm9uZz8K

