Return-Path: <kvm+bounces-66287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C49ECCDE31
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 23:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 70B71302AE1B
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 22:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2AA7322B68;
	Thu, 18 Dec 2025 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yrk7t4aT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B792F8BEE;
	Thu, 18 Dec 2025 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766098519; cv=fail; b=Tsk4gnjd6RfZLeIrxGOFnAPjEgluWYSywuWAhYVYoKjz8hLZpBGx84ckY1qxlzveLbuyQuIoD4WjORWUFLEpEpoqW8Stkne7s+ciVyUwJNEFQhT+GVkPS4roTBVHrRBV7lgOhN9x4/dCC9LPd6VuM9LN3tAN9HM9ebMsrcHJtcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766098519; c=relaxed/simple;
	bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tX50RDMqxjsHZ2LhPE/h3B0qzyoUD+ZL+wA45I4rpjIUW1XZV+z9TK/wqmcUV86aI5yK/q43WM2ox0z+t31M9u76xHlfeLnw6aWmncDlOHInlnXpeaClDEmCXyDGgC8Gkj0m0nJqTq1upc6jhwty1w5r3wU4+jPIVAN5uvo6WiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yrk7t4aT; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766098517; x=1797634517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
  b=Yrk7t4aTSFHKs0k3MHlGUlUOiQFSR0ruA5s10agVBKJ+vGytXFT+rO+q
   AP5MYhRUKVgFi3SG/0qIvGTsxfsmvi0IW12wkFEtrgv3QuOdRBsbgMxSL
   nL6qtvOE8PwW6h2rxBKjp1Xxwa7T69odar4JWu8yJ2lfsvzb8S3LpCIAm
   LAO8MUWZL1vErp0zl7qyc1rjkvTiktEtbSj7UrodNwkpQaTwVl7NhodwJ
   ww+gsm5WXVSu55KizsZKdpplUKBmuJpRwmvz5//iFP2/UC0aHvWzYEpI9
   5IGBQj+7lTY+7kANq2aTXdYPNLq++BZRRoZL2PstPx+Z39eIhHLRR4qns
   g==;
X-CSE-ConnectionGUID: UuDxNo5fQzmNq42H19AnVw==
X-CSE-MsgGUID: 754rHhFMTwO71unJrBFN7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68100620"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68100620"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:55:16 -0800
X-CSE-ConnectionGUID: ecfdZ6xuRgatFMdlU4mzeA==
X-CSE-MsgGUID: ACR3HXISQ22P/YHX1BaZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203612293"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:55:15 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:55:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 14:55:14 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.24) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:55:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtcanZ38CBMkgEXxD705PC/Sozf2DthSUUd5rORwqx9E+uWHhnMU+ygIIne6scNmcA8B7Ak4wUlrCdN7pLtyfdZOT4iT+A/ELywZUpD4o0tWkADt4B4vJzdb7bgmetzgaTzzjIiOoaBBmWUPHG624uTlAu2bCE40gmXhB8JIZ57mE4QfojWSlGIAlhn1XklNDlIeoUm7KAYdqBn9VgrVquvTAbxCRfijNAUo9Riz/LbVJcocEklPvhdC2gox+LTAkJiv7LazjfMhJqw7aiDiTyj0D+amRC7BQnQRQyCGJIujP4Au1PNKYZxoF8FJKhUt1nwXj4vIjdPvaKeF37l1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
 b=N9LEWXUeZF9/houBP4kCoSD13VhwpAeQttwwz13gOy+5nZDZtnJTtGqFBpwjR7++uVBRZP/QCQiAWl2bm8uKFdkMfFPNQfgmrxTZ/Fs3O9U11M0dAKTOFoikUfJK8QfA4XhJnf/0QiYomBP3n2WXBmPawTcp1K+i2FB65Z5kaPOgYvIbEobyeqwxDuLGMNHUd+eEzsJUzj1Tglvz9w84urN6RdJb9H+MI8YitBlAZWzzx3loQNaXEw/VvysX2JQ+UPg3Sq62h0E3AvtweFtqMRe/Cpe2HOC25iO2+aqnSkORzrAHRxh1uVtOI1SeJrVuawKelRLbczbOBeK1yUEyiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7444.namprd11.prod.outlook.com (2603:10b6:8:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Thu, 18 Dec
 2025 22:55:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 22:55:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "david@redhat.com" <david@redhat.com>, "liam.merwick@oracle.com"
	<liam.merwick@oracle.com>, "seanjc@google.com" <seanjc@google.com>,
	"aik@amd.com" <aik@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/5] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
Thread-Topic: [PATCH v2 0/5] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
Thread-Index: AQHcbdhnozmOvIsW2EmNsgKlh+EZubUoBwSA
Date: Thu, 18 Dec 2025 22:55:10 +0000
Message-ID: <2fccc3c69b20352a7a1558e12991a9b37c582dc7.camel@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7444:EE_
x-ms-office365-filtering-correlation-id: 640b69c6-45ca-4993-b331-08de3e887f27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S1Q1ZXRSK2kvT0FjVTFIbmNucE93eHhwWEdJOVJBdTZBdzZqMlVvdGZ2aWF3?=
 =?utf-8?B?U2NJOEZaYThKa0RmRFdLbnNLRG5pMlhtcVN1YlVtaDFsS3NKQzVQNVAxRDBs?=
 =?utf-8?B?VnV4THN4ZHY0UGRsZ29ZUDErUnJnTWxXdzdwMEV5TlpMOUR0Qjg0TC9iVnRY?=
 =?utf-8?B?OFF0eGxIM1ZZb29VcjFBaCsyRmRpL0xKLzFVVjRMQ0RUdWhJTFQwbDNsS2lU?=
 =?utf-8?B?NjdmWnhia2xVQ2JNWTVId3RndVlXMWN5endJY01mR0tPUHZMQWF3dVMzVXNj?=
 =?utf-8?B?RWh2aGRWd214OHo3TUl6SW53YjlNcjJ0blZXOVhsWlFHdU1TWjJSMW81cS9G?=
 =?utf-8?B?c20wZDMxbGQ2eGFtMUFSTE96eXU2aXo2UjB6cFl1TmtZMGJFdnNEQk1nUEY2?=
 =?utf-8?B?Z3psK2k4Mm0vcWszVHcxS3JPRnVMamxWSzlyMkFKcHZRWWplMXBCaW56NW5R?=
 =?utf-8?B?SWFCR21pNTBIMENlU05NK3VoK1ArbzJsZW1Nek44a08vTFppbmN1SXJNWUhP?=
 =?utf-8?B?WkhjVjhUclppdmMwR1puSCtpRHBFNUhsRm85ckdDbE9GYVpCSUlxWDFRN3Jo?=
 =?utf-8?B?bEVES1ZnRTBsMnVlbmt1bDhWU1daODJucDcxeGNlelRlWVllU21aSlM1dVFq?=
 =?utf-8?B?eWRNMUZuVEhIYStlcURHOUwvYUdNN1ptWXpJWlF6a2VCT2lrdVVWY0pYeXFk?=
 =?utf-8?B?Y2NDcUlVZXZwQ0JxeUNWdUdUTDhvMEN4bGQ5bEdualRzN2k2cUg0MGtjOWdx?=
 =?utf-8?B?ZFpZaHNqUTJKQ1Y0dnFJM0tFODVyb3Nvdm1ITTh5LzVMNG1WVm9wRko4b1ZK?=
 =?utf-8?B?UVl4L2xjdkpMbjl6K1BMblpnUVdJeHRPQ1puZWxjT2NaWmNKb2xUN1JNdFQw?=
 =?utf-8?B?amxyM08yd1d2bVhWWGVnTExRZEs4K1UvLy9FdFdoVU8rKzl6dTF4ZXNCRUZV?=
 =?utf-8?B?N2JUMXQ2WWJvaTNDdm04T3BsY2JNejBCbC9aaElYaVZhYUVZQXVKSlREYUhW?=
 =?utf-8?B?Z2xmSXVza2pVV0FHMkdHUzgrS1loVTQ4Mk8yZjhCejBFVndBTlJ2QkFtMjha?=
 =?utf-8?B?YW42NlRwRzVUTHZDdEdXckwxRWx4TUI5RnIrdmlSVTR5TVQwMWpsQW9yUVNp?=
 =?utf-8?B?ODdLQUlLR3dueTNZNWRlWHB6aUtUQlM4KzVmTjB2UktuVDV6QlNRZkNMYWFP?=
 =?utf-8?B?NHYzaWV3SWE5eXlQN3NqOWp5c0VBZHdON3VHRUpvY2podWk2WUY0NUNJczZT?=
 =?utf-8?B?MlQxWVVmdFc4NjQyY0hqWW9CdFFQRHhQSStmUmppMlFrYmZHZ1BDZTF2aVJU?=
 =?utf-8?B?NEc3RjVwbVU0S2xkSWNabGJtWUtoYXNTU2k5TWlheCtVWnJzblpEcEFlcFcy?=
 =?utf-8?B?bnVubURmNUgzTFMya3BuMjZqN3NZY1FiZyt2NUFaN2R4SDl1MFFybExiTWRv?=
 =?utf-8?B?ZkQwMlAzd2g5Rkl4aEx5eFRZVFdtc1RKQUdGeDlORkxFUGhVT2xJcFhJS05B?=
 =?utf-8?B?N2k5NjA5Z3M0VklRL05xZnlmSjhjL2dRNTJvTVBCRFRzdHlXY3VmeHVnc3ZT?=
 =?utf-8?B?MjZ6V21BcWtpMTV0U3ZaclNISVlBdFdQSUtuNmZPb3JVckllZG83SktIS3li?=
 =?utf-8?B?ZzgvNjhwOW5yVnRsaVdncTFvZUF0NW5iVG81NzZuRFZNeGxubnBacVBCVGlu?=
 =?utf-8?B?T1hxU0hwTXFudTlHQ1FpL3czTnlYM2djNU9SUnRBU1o1R3ZlOHZQWHlJcHZr?=
 =?utf-8?B?SmZ5RWVCRWJvalY1aWQyZGxIaURiOXZrNFg3RWRPdXZ3ZWdxK0x0WDVVU2h1?=
 =?utf-8?B?cnRRNlhxZEYvcWxWSmxzc1Rmb0drVWZaRStOQ2pPYVo4bFFsNXdwTElnK2ZT?=
 =?utf-8?B?UzJxVVpYRFI4ellTT0RLaVB1YU0wYytubVM3OERPRm5lUFlEemRpTmJvdzVH?=
 =?utf-8?B?bDlGL3FWMHBlMEZFUUJIL0dudVZUWVI3QnJaeXZub0NMZXFSUmNHbnNXbjVZ?=
 =?utf-8?B?ckJpVnlUY0hkeEpBbXJtdmVqWlRla0RIWXBIdWtPMG9OZTYwSTUzYm8xczZB?=
 =?utf-8?Q?OanDUL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZyWEFMdXhwaVR4WE5pbHJUeEYvN0c5aTN0QjI2cXdITnppTXBjdkpTNldl?=
 =?utf-8?B?eElxdFpFOWZ1RFJnQXIxclorYUtwMng2eng3ZEdyNzBhOGJCSUJ0Z1BwOWxO?=
 =?utf-8?B?WnJ6NUxweURNL1FrY3NUK1hDNjdUN1FGSjFNQWNFVWQvWU52M3NsbERsdXFH?=
 =?utf-8?B?Y215a3FtSTZTYTQzalQva2tTbHgvenRtTm85VkVXaUhCVnlsM3pWaWlsSmZM?=
 =?utf-8?B?VCtTV3NGajFBM0RJVFg1THZLMXVuYVNTNG5ma0RvWE0yR0gvaDB6Q0Nhdklk?=
 =?utf-8?B?WE9nSE9NOVR1aUE3QTNvc0RuU0RwVE9IMktkU0NsVHRUeDJJQzJ5dVIrYlBS?=
 =?utf-8?B?SmhMSkkzUjhjdWgxWWpCRENzN3JrZmpBWGtYeDRzL1luWG1OUWltTHJYakwx?=
 =?utf-8?B?eTZ5Zm93ckZvZ0R2eldLb285NUMyUWtXOEZPd0xELy9pRnZvSFdqRWw4blVJ?=
 =?utf-8?B?RUFoUmprYktKNTc0Z0lOcC9CMDFtU0xVZUtBTEpFTUhRN3YxeGJseVdUNTJm?=
 =?utf-8?B?Vkt1TW9DaUpJNXcraFRVK0hlWHU0UDcwUkNCMk1zUWszTFRpcmU0Ky82cE5j?=
 =?utf-8?B?eWFlN0t6b1ExcFNHaGJHaGIzd2syNEtWR1ZwRmcvYU5mWC9GekdiTWc4R1ZK?=
 =?utf-8?B?WnltYXpvZmNpY3YyNjZWc05Vc21pWWxubjk5NVVETDJNd20zalZRUE1FWTVH?=
 =?utf-8?B?emNjYVMrVks3aGZJZG1YeWhLMFlsNXM3TTJXVzRoWnlkMzU3Q3R5WEdQd3kz?=
 =?utf-8?B?OElhOUZNZGJManArU05WeDlGT3RkK0VnSjdmNWFtVThhY2RiM2hwclVoc1JS?=
 =?utf-8?B?eHpwN3cwSml5VDkyaDJSSnh5OEdmVm40US8vVDRQRzloODlrdFE4b2JnWFo3?=
 =?utf-8?B?RDNFditrNXhLVERmOXRuMFJsTCtlTlF2TXZ4VjVFRERtWlFsTU4yZlBuanV4?=
 =?utf-8?B?TnJnV2grV0VLVE9hQXhkclE4VmJLWTl1THpRcGpORVdkcmhVNnVIL0JpVThP?=
 =?utf-8?B?NFFheVVDdi9xSk4yWmsxaFJ2ZDRCclhwRzdCMTRmOURwM3hnUmtMT0VieEx0?=
 =?utf-8?B?bVhhanNCMnVpZDhQR2xSM2IvRWxvT3M1ZTBHU1QyY1dldlpZSnlSalYwdFZO?=
 =?utf-8?B?dkVoZFdNczRmSlZEbXdVR3pyYUJqL2gzeGlZZ3NPNWM1ZDVFd0tRZFpmY01Z?=
 =?utf-8?B?SHdaK2pnSGNIY1l4RVdmd0RYc09CamZTYWtER1dkZDRid2hwUGdWMlY1d1JN?=
 =?utf-8?B?S1pnYUFPREZvZDJmblBEbTJYcG50T0VYVUIvV1VsUmw1djlWNEp2cmQ4OGxk?=
 =?utf-8?B?U0tmREJMT3JjZXArSytqNnR3cGlHaW5EcERvclZuejlJRWtGSGRuV0haWEtk?=
 =?utf-8?B?M3cwNEpGTG4yME1UdklYSEtUemRxUGh4T0FkdklkQXljSXZaNjNHM01NbmF2?=
 =?utf-8?B?dEpSZ3hmWFVtMHVtRnhaQTJ6WVNpVTlNajAxWmNXNVpDVlljVk05UDhrZ3ZU?=
 =?utf-8?B?Qjlvc05aVlNDL3V4ZFBwZUN0NTJmY0I4dDhiRVIzUldybFNSODE0RGxaRjFn?=
 =?utf-8?B?MWRlNkk4NlhuMFBWWGQxa014d2E4V1pSWVh0eGhMeG90ZmNMbUplRWV3QStL?=
 =?utf-8?B?aTVOVDVCa2xBLzQzdnd4aFQ5ZnFxY0xSR1d1dUI3bkYvOTUwYzJHbmYzeUtM?=
 =?utf-8?B?cU5nWUlMckM3WkNaNUorVUdYNlZ4VVpvZ1kyaVlBZGVqd0k3VG1XeGlXb1Zk?=
 =?utf-8?B?U1lHY1p2dDM2RHpINCt3cUtIZmJPV2tWbk5xdG1UTGlwNkY5TCtwZ0pRVldB?=
 =?utf-8?B?a3dXQ08zQlpsM00xSldHZ3YwOWQ5RUtSUmNoWkNiNFlaa2Y5MUVraW5XTVZY?=
 =?utf-8?B?UlpGUG5Za1dPOVZ2Q05sNnlHL1NITXVZUXBnK2ZoQlltVzgrOFErd0tyUlhV?=
 =?utf-8?B?Q2ZsM29uQWtxUURUdk95dUFZSTdZaDFXR3ZETFlPTVM0cExzZTRRWlhRZGgw?=
 =?utf-8?B?ZWZJWHUwSThINmRRQzY0N3hrTERiWndqL1dtTEI1MG9FUC90ZC9WZEV2L0Mz?=
 =?utf-8?B?aUhMVk9DR25iQ3NXai9OT0NuNU5aYVplQ3dXKzB6MjZLbFRnWDV0QmlsaGZo?=
 =?utf-8?Q?qyanznRvCw+eIt316uAQBIfst?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20A66209422981448EF0B86ADAB301A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640b69c6-45ca-4993-b331-08de3e887f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 22:55:10.2848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JiLEc1Uo+2OPknH/etPQ5fjR8AicgGOyFJNQhSObYeWMltTDYvrjrZsBS0IkntIH47DYlKilZZDBWqZJo3Wj5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7444
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDA5OjM0IC0wNjAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IEtub3duIGlzc3VlcyAvIFRPRE8NCj4gLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gLSBDb21w
aWxlLXRlc3RlZCBvbmx5IGZvciB0aGUgVERYIGJpdHMgKHRlc3RpbmcvZmVlZGJhY2sgd2VsY29t
ZSEpDQoNCkFwcGxpZWQgdGhpcyBzZXJpZXMgdG8gNi4xOS1yYzEsIGFuZCB0ZXN0ZWQgYm9vdGlu
Zy9kZXN0cm95aW5nIFREIHdvcmtlZA0KZmluZSwgc286DQoNClRlc3RlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

