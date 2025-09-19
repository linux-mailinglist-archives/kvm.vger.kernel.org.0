Return-Path: <kvm+bounces-58095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B127DB8789C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4367165B49
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6903C1E8329;
	Fri, 19 Sep 2025 00:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+h+kTZQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422C34BA5A;
	Fri, 19 Sep 2025 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243023; cv=fail; b=EJ4Q8GeZgqz2085gb4XzRgO4z7efT8p38/zkmwngUdMexOnaiG36AKbwNYLrUifWldM1mee4Sil5sIovEC1Aq3QAiXGKqio9sLIUVTS9R/b3ggj3CnKvkzsT8C6IN4AHbOZcqMTrvvvbo/gTQAPSa0blMMY1NigvpOkjlZZV1yo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243023; c=relaxed/simple;
	bh=dHEwG8W5AVHKkao8IrTvhtBYS0el0RmbV1G9yFX47Xg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Th5T2egRZe+4MJHfUz9o7oM+qSdgqJU4RL6pVnAcrehDe+qa5h/cu10ZZVfSGIX3Au/1ErxMyv3M2gCT25wSqvOV8RtQbht18P2kVfIc9GGehitYBqAC6I02oC4S5ahdBd9xK9Vqw2u9qqkO2/tmnZBlwt2m0a4WCtBdmTz8UJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n+h+kTZQ; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758243021; x=1789779021;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=dHEwG8W5AVHKkao8IrTvhtBYS0el0RmbV1G9yFX47Xg=;
  b=n+h+kTZQTIBlVzb8Qdo3iqYdlOKNMTf1OXavVC3Dy5V2ZoZ0zoe/a3hL
   N7MCSu+x/H27mLvCKfoMZTaHoHlQ6djuVqOczD5NcTyBXJeCnNnY1sN5F
   P5785+xBcPSDr2HsbkEwBEh8dU7zqc2YsmyYCByoabzkQxtmqkI3PP3HM
   yth8rVRERrl4aJnwWb3iGyfBZ+gvnOPv/EsgT70WM12x0omZSf56Fg5dG
   rsID1egEkXEBi+5yBBE82NMG7cAYFD5TX8xWPMGctA9dtnvVS+/oycrgo
   cP86HwcmaeaaiRKhFc0t6qNGSvHmq0GKTO8hbOfy6mpGQZ/2CkwYBzQnn
   A==;
X-CSE-ConnectionGUID: 4nXfPlCsToaSXo97iugSYA==
X-CSE-MsgGUID: 0W+0sd/MR7GOJMvy/67L4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="72018055"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="72018055"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 17:50:19 -0700
X-CSE-ConnectionGUID: PJsFGvBySgOi9w8eo4l4Gg==
X-CSE-MsgGUID: VbUylHYaS7SaUoahRYI9bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="175617086"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 17:50:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 17:50:17 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 17:50:17 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 17:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeiVQXbtuhvVOwQESfFIWlHOvKf4vonK0agbgwo0Vb5KdzoDsG3SXJnZKPfHC0Y2vIVUQX4UMqJFPUtjaCL5iMrOmQTqe/Lo2fs82LkoBrlwST7So055pSfyt/+4ds3pYZU62Woql05v00SjzDSD5lT6j44HXXrNRE11ZNabsTQGwrr3T9QSHpCsEOP48kyLDDK411PM9V0jKkM8j4Z37bEmLGROx2d0e8RK+t+N3GdT0h5cOfIfgok0O/cZn7k1zOhVHC41gcCQzfP21Z9jCKIjgLxmS1dMjxw8jc1HI4UqZwZyNZvTsEdtTHvMkFDWt1sQYYSZc61uKACulRnpWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHEwG8W5AVHKkao8IrTvhtBYS0el0RmbV1G9yFX47Xg=;
 b=wvSGtQNhvqXJ8gKzgNFQug319NqBa4kFoR8063qFFa9dQUAd9mvipAN1O+78gt2HEJPY0ZhTDyxFHI3t4T1pBnohuX9S2zxZKin8eEytJ7HrWXMu/X5LeYmO7vl2eMgKKant2WZbb+763RuYR2rdZHABRFFonCAQreBilXgjZUoOKy6mf6DmJ764RlRW0DNeJf/SfZC+n9JIQ9ZySFdI25TwHTa757MXqnZ6FuKVUvC0ue4cwaF7kl9PcJcQl32hyc6eLMZ4Wo63oZnYCodBXhUdB4KD0QhNz/hkHX/2SqGNRVmKjiyXKkH81MGz4jPV4kIlNvuJoqSsyZCC/DChgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA2PR11MB5115.namprd11.prod.outlook.com (2603:10b6:806:118::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 00:50:14 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 00:50:14 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Topic: [PATCH v3 03/16] x86/virt/tdx: Simplify tdmr_get_pamt_sz()
Thread-Index: AQHcKPMz2V4/6BgfR0eBHfX1eLJwcrSZrM6A
Date: Fri, 19 Sep 2025 00:50:14 +0000
Message-ID: <1c29a3fdbc608d597a29cd5a92f40901792a8d7c.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-4-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-4-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA2PR11MB5115:EE_
x-ms-office365-filtering-correlation-id: c1e4b87f-1cdf-464e-d33d-08ddf7167ead
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SElnTmFIaUFlUFhFL2htWjBFbDV5eFdwNVFleW5sVGdXSTd3YjRXdUlVRitt?=
 =?utf-8?B?eFk5aHlKUmNhWDRmSmlvcDBFV25HMWNmUVJaN0w1MjN5UUpFSkYxMVduWmw5?=
 =?utf-8?B?d3NUWDdsM2tnb3lQTVlLWG1hazRoeFc0Q21QcFgrOW5SK01uZVFZRUNhZXRK?=
 =?utf-8?B?a1RXTmZwRlRrbCtoV20yYXZUcU5JOUhkWEZUL0MyK2hSdWFsRTU0eHFKNkVJ?=
 =?utf-8?B?N1FFTmFXU1hHYUxybzRJcHlWVDZ2ZVQ5V1FuNDVYWVJSdnlOZTdqWHBjWkdM?=
 =?utf-8?B?eEVvQ0x1L3Y2dGR0bEJuNlhWNFVyZkloaVgzUldIL203WTVtdTFrV0VERWVi?=
 =?utf-8?B?TEk5SGVhaVU0ZEhRUDZrVnNtaGNXR2tnaE9jN29Bb1ZiNlloT0xlZDJ4dnJv?=
 =?utf-8?B?c0Z1WDRqWm1nTUxtUzhLT3FORDQwUzJxRXVtcU1JQnZyK0RVTHFqdmU2cFFx?=
 =?utf-8?B?ZGRUVFN2eSs0QWk3ZXdXMHlMbkV1NWdYdENPY3ZBNll0VlJiSFU1NHdtUVJm?=
 =?utf-8?B?S3RhM2Fpd04zVGI5d2hma1l0akRLVHBVTE5Cc1RtOHBaZWdodU5sRWdZWmU3?=
 =?utf-8?B?MHRyM1RIemJmUmZkTkdNbnROeERZODBrZ0JIaTFUT3dzY3gzcVdNeHBmenRT?=
 =?utf-8?B?VkVFcmNaZ0x3bjlKckpZYWJvNnJxUEppM1dVRVhvY21yRjIzMzBWaXRtR3Vl?=
 =?utf-8?B?eFNuMmpNWitJbW1sTTdJOU1UbVZRUk1ndnkzdzJMR21pTkR6TThBMHZmdjhx?=
 =?utf-8?B?YW5OSUo5NG02TEJlWnRPNXlFZmhCTmJ1cXJKb0ROYkJPL28yMXlXS1lVUk5j?=
 =?utf-8?B?bTBsSnhGOFE4ZXBFOEU5NG9tTStWY0ViV29GRVJnTWlNTkM2UTZ2OWZXbzBX?=
 =?utf-8?B?UlhRZG53YktjVnErc2VzdWNpa1ZNaURPYWo1dGVVYUlqMVh5c1ZEOFdiNnB1?=
 =?utf-8?B?YXVmdCtXUmEyQXY2dFdLRllGUnlBRzZUZGdyd0VGSnhJWEVLR2cxOVNZZG1s?=
 =?utf-8?B?U1ZBTDd0OWJueWZSVXl1eFA3MUNUV01RcmJEdFBITm0xMTRLL0h4Vks4K3Uz?=
 =?utf-8?B?eDJHR2V6eEZjSnlCckxidjgvcjBmV0dLelhEMmZ6eHFHWTNzYkFLaEZYU09J?=
 =?utf-8?B?REVSV1NkSzRKbVBNQXY0UTdqNGQ5U0FiZlFwT1Rvc2xoSFZSK1RhUzYrdWF3?=
 =?utf-8?B?Y3NhcE9WT1R1YXM1T2lxQ3l2Q3ZBMzUybVBLT3lYVDgxU29PaVg2ODQ0ZEN0?=
 =?utf-8?B?QS9WL29MUE41UytnWERYT1h3UGxIK0VwZUlTdU5TbTBabThYVUprZi95bTV6?=
 =?utf-8?B?dVArdnVJOWVxZEhnTXEyME1pV2RRR29qL0lURXQ1aTZSemRIejd2aEoxZ05M?=
 =?utf-8?B?WHNJWDQ2Y3lwbUJYbU9qU1RKU3RsSnZvWmh4QWNSY3hpaGp3TVhxUjh5Tkh1?=
 =?utf-8?B?TFR5VFg0dWhVVFVicTBYR0dwcGVNQnROSTIvMlNxVEp1ZDM2QXp1SHdHQTZy?=
 =?utf-8?B?MXBKdTVxUTNhRU1QU3NPUWJmdXFidXFETzJCQjNpUE9rVVpkMlNOYkJydjdV?=
 =?utf-8?B?aTJ6Ukl3ZGZUaUREV21zRndKS3lIcFAwendVWEwrdzk2d2l5UEdzdlZLVHB5?=
 =?utf-8?B?REljZnR0ZnlEMjYvTzB4YmlEYWVjdkZZMU5jME93UnJuMGhKM3ExOWRMWnRp?=
 =?utf-8?B?TlcySkdBRlZFL0NpQ0pUL3VXWldaZXhTRkNRL3A4N0RhUDFtNFNaOXBtalhp?=
 =?utf-8?B?WFBFVmk2TGpydUtpRUVCT1pYQ3g0VWVkZDdyQ3lKVVdESnRNYlpxYjJza3dn?=
 =?utf-8?B?SzU3d2xEa0EyamN1NkttWG1QMkNBY1E4YWp3QzA4UzBDMFp1QTVUcUdXWUxW?=
 =?utf-8?B?RWx5STZETVptVzlOcVZqOERDMnNDQkNDVWxuNG9JRHF0cm1Ec0VUWEgzNnFn?=
 =?utf-8?B?TUdjZ0xyOFhacWJCOGtHVE5ORGRKeFowRy9ROUZaYmdvOW91YjZvdUtxNkZs?=
 =?utf-8?Q?Q9XZikcplGzWEEbs85whObpz5384RA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2YxcSsxK0J0U1F0aERramFETmpEUngrU2lwZFVFWWdsUVpoeWN3T05JUk9l?=
 =?utf-8?B?YUFMYlNoOXExMVU0bVNyY3dGb3VvaXVwZEppdll0aW5BeGRRbGdZeVkrMHk5?=
 =?utf-8?B?SnNsREphdVoxTC92blJXR09rY1JibXdKdFo4KzJZYTYrNGJNak91bThsUTcx?=
 =?utf-8?B?T0J0cHpJeXVUR3NRdXRFU3ZMSFFnVnJOcnR2L2N6S1o4TUhIREVxa252VEQx?=
 =?utf-8?B?M2xURFRLZUV6VWlzQXdzUTVGaWsrQmRNWDZ1ZDE0eTZjTHliTWRGRnc3NEZt?=
 =?utf-8?B?VkMyR2hhMVN6VmZnbkx6TEVyVy9CTWw2Y21rQmVvMFpObmNneklpR0JrbEJ4?=
 =?utf-8?B?MWg3ZmVpTGswUkIvRzlxYWI2TUR2SXNzbTl2OW11MGxZYnhEUHNPUEFQc1RR?=
 =?utf-8?B?eGtFU3A3b0RlOFNjL3BVQkYyOEpLczJMZWl0b3dyWll4ZmN2UDVMaUNFb3Rl?=
 =?utf-8?B?TVBlc2kyVnBUaU5SUmRQV0lLMURTOHF4cXVHbHRacU5jczgvMXJiNnllS2VP?=
 =?utf-8?B?QlQrNFJJam51cmhrMVlHRm1nREQzNGo5SDRqWjNXOTBPeVBINGdFaE10Tk4z?=
 =?utf-8?B?cUtaUm1NTzdnVEhZUEhmbzFNQ2FuSTQxVzl4UDZ1K2ZETGJ5LzQrMW52SnFQ?=
 =?utf-8?B?WEhxUk5xaFlRcHg1L0ZLZzlFWXMyNGVZdjQ5SEtlVS9PVnZuQWJTeUQxNm8z?=
 =?utf-8?B?T0pacmhuR1pEL1BHeFBacllLYU5sQ291dmx6eHVKZGZoTnFtUDdCMVdOVk5a?=
 =?utf-8?B?TE02V0NRR0U0bE9JN2s4MlAwd1RZWWtkSkRWNytWRjBqcFZvUlBZK2pvZmJm?=
 =?utf-8?B?YmxtYU8xUXZ3K2MxbjR6N1FodmZWZ0xaZUVKb2xHcjhReU5sY3NZM1JaTDIx?=
 =?utf-8?B?VzJzbzhqNU9nK1Z4aUZTazhxTktwQ1pRWmZDYzk4Rngxbk5WTnUxM2c3aGxu?=
 =?utf-8?B?eURQbVpnQXlHUW5LS1BpZHV5VEZVZEJFeHpWVzRET0VoeTQzK2NTc1JWcjFZ?=
 =?utf-8?B?bmZybWRCdlR0K0RmSU5GU3JkUE8vTVJPS2FwWW1ZbXdZSHppb3h6V1RUcytO?=
 =?utf-8?B?MnZJdnZEL0RxQnpPY0w1SzJ3VDJTSXIxajhXT01HL1hPSUNOZGZUVXpFYnZH?=
 =?utf-8?B?MTdrOUszcDBvQUhTaU40cVpYbWsvQVEwYjFXZnMxTitQdStTQ2hsS0hwQ3I5?=
 =?utf-8?B?SzkzNlh6amh6VDE4SXdZQm5QaWcyQTBqdHVDdFhpeHl3NkNFQW9ONzhwV2cw?=
 =?utf-8?B?TzVXUm5maDFWVTVkcWZlMDE5dDBBblZvYUNjUmd1M2hYSDRDYU9qSzVhem82?=
 =?utf-8?B?T1RqU1pGeENQQllqVmdhN1h3NjMwN3ZlekNaV0QwVkhCcXgxc0Roc01qMTNq?=
 =?utf-8?B?cHFhYWZaS0J3aGVaUUpaRERoM0Y1U0xITjE3WmVMM1RDSisvTzFWakNtVmw1?=
 =?utf-8?B?WGFUV1BFNHZ5aG5GOFVKUFRlMzVKUm5zZDNPSENHWTNINXFWemhmK0VPTGJr?=
 =?utf-8?B?OFNiNEt4WWQvbUtWenh6UVAvL1RYRTdkNW5VVVpLTndxeWprc29xOGZKWkRF?=
 =?utf-8?B?QkhLaG02YVFnUEcxaFgvdDhwWkNncHZQRlFXcUtJaUlEOGFtUzhnZDluajl6?=
 =?utf-8?B?VlVUeFAyenVZODVHcEdMdUppRS9sQzBtSk5QaTM1bTJ2Qk1vMkl1L2Myb0Zx?=
 =?utf-8?B?aWd4TDZVeDYwT3d6dStLUmw3VHFxVDFvR09ad3BuVUJyeit2dTBIczI0OUp5?=
 =?utf-8?B?WGk0bVdtcFhBSnlYUFE3VDBNZEJBczlkbmFEYjZiQUozTER5TW5HYlh3RFNa?=
 =?utf-8?B?UHdGbVIrcWRtQ21JUVpLYzNWb1pCR21JV0RFODRwR0cycXJXYnNDSGxjT3JX?=
 =?utf-8?B?VHhXZkgybDlDOGdkekVpdlg2ZCtqRlU4b3UrK090a016WXVUTDdGYkxNS0Jx?=
 =?utf-8?B?WFZmUFAvckZIbktvUFB0S0ZIVUt1eW95M2VoV3FrVVZDbXpkUFJyVE0yUG82?=
 =?utf-8?B?aUVVVlRMdjVIb1pURTB0VHdsdDk1S2tyZkw4ejA0TlYzTmNzNXA5ZWlyOHQw?=
 =?utf-8?B?WVRHMDhUQ3F2LytSeVloSnBDK1pFck5mWXViMEMwZW1nSmNNVzJwNDVaV2pw?=
 =?utf-8?Q?MtNqUUBpHsl5/ecI8af+aMoAu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B201C789D5C5244B5B71118AAD90410@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e4b87f-1cdf-464e-d33d-08ddf7167ead
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 00:50:14.2935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IUd+n3ncfqzQd4sS055aVnJdaMrnjiS9PUBNpb5s1K4F8UzD6Z7vRNJQ87uZ4qJrkcpaPtNQAkrmMVG99+7m0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5115
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjIyIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gRm9yIGVhY2ggbWVtb3J5IHJlZ2lvbiB0aGF0IHRoZSBURFggbW9kdWxlIG1pZ2h0IHVzZSAo
VERNUiksIHRoZSB0aHJlZQ0KPiBzZXBhcmF0ZSBQQU1UIGFsbG9jYXRpb25zIGFyZSBuZWVkZWQu
IE9uZSBmb3IgZWFjaCBzdXBwb3J0ZWQgcGFnZSBzaXplDQo+ICgxR0IsIDJNQiwgNEtCKS4gVGhl
c2Ugc3RvcmUgaW5mb3JtYXRpb24gb24gZWFjaCBwYWdlIGluIHRoZSBURE1SLiBJbg0KPiBMaW51
eCwgdGhleSBhcmUgYWxsb2NhdGVkIG91dCBvZiBvbmUgcGh5c2ljYWxseSBjb250aWd1b3VzIGJs
b2NrLCBpbiBvcmRlcg0KPiB0byBtb3JlIGVmZmljaWVudGx5IHVzZSBzb21lIGludGVybmFsIFRE
WCBtb2R1bGUgYm9vayBrZWVwaW5nIHJlc291cmNlcy4NCj4gU28gc29tZSBzaW1wbGUgbWF0aCBp
cyBuZWVkZWQgdG8gYnJlYWsgdGhlIHNpbmdsZSBsYXJnZSBhbGxvY2F0aW9uIGludG8NCj4gdGhy
ZWUgc21hbGxlciBhbGxvY2F0aW9ucyBmb3IgZWFjaCBwYWdlIHNpemUuDQo+IA0KPiBUaGVyZSBh
cmUgc29tZSBjb21tb25hbGl0aWVzIGluIHRoZSBtYXRoIG5lZWRlZCB0byBjYWxjdWxhdGUgdGhl
IGJhc2UgYW5kDQo+IHNpemUgZm9yIGVhY2ggc21hbGxlciBhbGxvY2F0aW9uLCBhbmQgc28gYW4g
ZWZmb3J0IHdhcyBtYWRlIHRvIHNoYXJlIGxvZ2ljDQo+IGFjcm9zcyB0aGUgdGhyZWUuIFVuZm9y
dHVuYXRlbHkgZG9pbmcgdGhpcyB0dXJuZWQgb3V0IG5hdHVyYWxseSB0b3J0dXJlZCwNCj4gd2l0
aCBhIGxvb3AgaXRlcmF0aW5nIG92ZXIgdGhlIHRocmVlIHBhZ2Ugc2l6ZXMsIG9ubHkgdG8gY2Fs
bCBpbnRvIGENCj4gZnVuY3Rpb24gd2l0aCBhIGNhc2Ugc3RhdGVtZW50IGZvciBlYWNoIHBhZ2Ug
c2l6ZS4gSW4gdGhlIGZ1dHVyZSBEeW5hbWljDQo+IFBBTVQgd2lsbCBhZGQgbW9yZSBsb2dpYyB0
aGF0IGlzIHNwZWNpYWwgdG8gdGhlIDRLQiBwYWdlIHNpemUsIG1ha2luZyB0aGUNCj4gYmVuZWZp
dCBvZiB0aGUgbWF0aCBzaGFyaW5nIGV2ZW4gbW9yZSBxdWVzdGlvbmFibGUuDQo+IA0KPiBUaHJl
ZSBpcyBub3QgYSB2ZXJ5IGhpZ2ggbnVtYmVyLCBzbyBnZXQgcmlkIG9mIHRoZSBsb29wIGFuZCBq
dXN0IGR1cGxpY2F0ZQ0KPiB0aGUgc21hbGwgY2FsY3VsYXRpb24gdGhyZWUgdGltZXMuIEluIGRv
aW5nIHNvLCBzZXR1cCBmb3IgZnV0dXJlIER5bmFtaWMNCj4gUEFNVCBjaGFuZ2VzIGFuZCBkcm9w
IGEgbmV0IDMzIGxpbmVzIG9mIGNvZGUuDQo+IA0KPiBTaW5jZSB0aGUgbG9vcCB0aGF0IGl0ZXJh
dGVzIG92ZXIgaXQgaXMgZ29uZSwgZnVydGhlciBzaW1wbGlmeSB0aGUgY29kZSBieQ0KPiBkcm9w
cGluZyB0aGUgYXJyYXkgb2YgaW50ZXJtZWRpYXRlIHNpemUgYW5kIGJhc2Ugc3RvcmFnZS4gSnVz
dCBzdG9yZSB0aGUNCj4gdmFsdWVzIHRvIHRoZWlyIGZpbmFsIGxvY2F0aW9ucy4gQWNjZXB0IHRo
ZSBzbWFsbCBjb21wbGljYXRpb24gb2YgaGF2aW5nDQo+IHRvIGNsZWFyIHRkbXItPnBhbXRfNGtf
YmFzZSBpbiB0aGUgZXJyb3IgcGF0aCwgc28gdGhhdCB0ZG1yX2RvX3BhbXRfZnVuYygpDQo+IHdp
bGwgbm90IHRyeSB0byBvcGVyYXRlIG9uIHRoZSBURE1SIHN0cnVjdCB3aGVuIGF0dGVtcHRpbmcg
dG8gZnJlZSBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAu
ZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gLS0tDQo+IHYzOg0KPiAgLSBOZXcgcGF0Y2gNCj4gLS0t
DQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA2OSArKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwg
NTEgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5jIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+IGluZGV4IGU5NjJmZmZhNzNh
Ni4uMzhkYWU4MjViYmI5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4
LmMNCj4gKysrIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+IEBAIC00NDUsMzAgKzQ0
NSwxNiBAQCBzdGF0aWMgaW50IGZpbGxfb3V0X3RkbXJzKHN0cnVjdCBsaXN0X2hlYWQgKnRtYl9s
aXN0LA0KPiAgICogUEFNVCBzaXplIGlzIGFsd2F5cyBhbGlnbmVkIHVwIHRvIDRLIHBhZ2UgYm91
bmRhcnkuDQo+ICAgKi8NCj4gIHN0YXRpYyB1bnNpZ25lZCBsb25nIHRkbXJfZ2V0X3BhbXRfc3oo
c3RydWN0IHRkbXJfaW5mbyAqdGRtciwgaW50IHBnc3osDQo+IC0JCQkJICAgICAgdTE2IHBhbXRf
ZW50cnlfc2l6ZSkNCj4gKwkJCQkgICAgICB1MTYgcGFtdF9lbnRyeV9zaXplW10pDQoNCkFGQUlD
VCB5b3UgZG9uJ3QgbmVlZCBwYXNzIHRoZSB3aG9sZSAncGFtdF9lbnRyeV9zaXplW10nIGFycmF5
LCBwYXNzaW5nDQp0aGUgY29ycmVjdCBwYW10X2VudHJ5X3NpemUgc2hvdWxkIGJlIGVub3VnaC4N
Cg0KPiAgew0KPiAgCXVuc2lnbmVkIGxvbmcgcGFtdF9zeiwgbnJfcGFtdF9lbnRyaWVzOw0KPiAr
CWNvbnN0IGludCB0ZHhfcGdfc2l6ZV9zaGlmdFtdID0geyBQQUdFX1NISUZULCBQTURfU0hJRlQs
IFBVRF9TSElGVCB9Ow0KPiAgDQo+IC0Jc3dpdGNoIChwZ3N6KSB7DQo+IC0JY2FzZSBURFhfUFNf
NEs6DQo+IC0JCW5yX3BhbXRfZW50cmllcyA9IHRkbXItPnNpemUgPj4gUEFHRV9TSElGVDsNCj4g
LQkJYnJlYWs7DQo+IC0JY2FzZSBURFhfUFNfMk06DQo+IC0JCW5yX3BhbXRfZW50cmllcyA9IHRk
bXItPnNpemUgPj4gUE1EX1NISUZUOw0KPiAtCQlicmVhazsNCj4gLQljYXNlIFREWF9QU18xRzoN
Cj4gLQkJbnJfcGFtdF9lbnRyaWVzID0gdGRtci0+c2l6ZSA+PiBQVURfU0hJRlQ7DQo+IC0JCWJy
ZWFrOw0KPiAtCWRlZmF1bHQ6DQo+IC0JCVdBUk5fT05fT05DRSgxKTsNCj4gLQkJcmV0dXJuIDA7
DQo+IC0JfQ0KPiArCW5yX3BhbXRfZW50cmllcyA9IHRkbXItPnNpemUgPj4gdGR4X3BnX3NpemVf
c2hpZnRbcGdzel07DQo+ICsJcGFtdF9zeiA9IG5yX3BhbXRfZW50cmllcyAqIHBhbXRfZW50cnlf
c2l6ZVtwZ3N6XTsNCj4gIA0KPiAtCXBhbXRfc3ogPSBucl9wYW10X2VudHJpZXMgKiBwYW10X2Vu
dHJ5X3NpemU7DQo+ICAJLyogVERYIHJlcXVpcmVzIFBBTVQgc2l6ZSBtdXN0IGJlIDRLIGFsaWdu
ZWQgKi8NCj4gLQlwYW10X3N6ID0gQUxJR04ocGFtdF9zeiwgUEFHRV9TSVpFKTsNCj4gLQ0KPiAt
CXJldHVybiBwYW10X3N6Ow0KPiArCXJldHVybiBQQUdFX0FMSUdOKHBhbXRfc3opOw0KPiAgfQ0K
PiAgDQo+ICAvKg0KPiBAQCAtNTA5LDI1ICs0OTUsMTkgQEAgc3RhdGljIGludCB0ZG1yX3NldF91
cF9wYW10KHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIsDQo+ICAJCQkgICAgc3RydWN0IGxpc3RfaGVh
ZCAqdG1iX2xpc3QsDQo+ICAJCQkgICAgdTE2IHBhbXRfZW50cnlfc2l6ZVtdKQ0KPiAgew0KPiAt
CXVuc2lnbmVkIGxvbmcgcGFtdF9iYXNlW1REWF9QU19OUl07DQo+IC0JdW5zaWduZWQgbG9uZyBw
YW10X3NpemVbVERYX1BTX05SXTsNCj4gLQl1bnNpZ25lZCBsb25nIHRkbXJfcGFtdF9iYXNlOw0K
PiAgCXVuc2lnbmVkIGxvbmcgdGRtcl9wYW10X3NpemU7DQo+ICAJc3RydWN0IHBhZ2UgKnBhbXQ7
DQo+IC0JaW50IHBnc3osIG5pZDsNCj4gLQ0KPiArCWludCBuaWQ7DQo+ICAJbmlkID0gdGRtcl9n
ZXRfbmlkKHRkbXIsIHRtYl9saXN0KTsNCj4gIA0KPiAgCS8qDQo+ICAJICogQ2FsY3VsYXRlIHRo
ZSBQQU1UIHNpemUgZm9yIGVhY2ggVERYIHN1cHBvcnRlZCBwYWdlIHNpemUNCj4gIAkgKiBhbmQg
dGhlIHRvdGFsIFBBTVQgc2l6ZS4NCj4gIAkgKi8NCj4gLQl0ZG1yX3BhbXRfc2l6ZSA9IDA7DQo+
IC0JZm9yIChwZ3N6ID0gVERYX1BTXzRLOyBwZ3N6IDwgVERYX1BTX05SOyBwZ3N6KyspIHsNCj4g
LQkJcGFtdF9zaXplW3Bnc3pdID0gdGRtcl9nZXRfcGFtdF9zeih0ZG1yLCBwZ3N6LA0KPiAtCQkJ
CQlwYW10X2VudHJ5X3NpemVbcGdzel0pOw0KPiAtCQl0ZG1yX3BhbXRfc2l6ZSArPSBwYW10X3Np
emVbcGdzel07DQo+IC0JfQ0KPiArCXRkbXItPnBhbXRfNGtfc2l6ZSA9IHRkbXJfZ2V0X3BhbXRf
c3oodGRtciwgVERYX1BTXzRLLCBwYW10X2VudHJ5X3NpemUpOw0KPiArCXRkbXItPnBhbXRfMm1f
c2l6ZSA9IHRkbXJfZ2V0X3BhbXRfc3oodGRtciwgVERYX1BTXzJNLCBwYW10X2VudHJ5X3NpemUp
Ow0KPiArCXRkbXItPnBhbXRfMWdfc2l6ZSA9IHRkbXJfZ2V0X3BhbXRfc3oodGRtciwgVERYX1BT
XzFHLCBwYW10X2VudHJ5X3NpemUpOw0KPiArCXRkbXJfcGFtdF9zaXplID0gdGRtci0+cGFtdF80
a19zaXplICsgdGRtci0+cGFtdF8ybV9zaXplICsgdGRtci0+cGFtdF8xZ19zaXplOw0KPiAgDQo+
ICAJLyoNCj4gIAkgKiBBbGxvY2F0ZSBvbmUgY2h1bmsgb2YgcGh5c2ljYWxseSBjb250aWd1b3Vz
IG1lbW9yeSBmb3IgYWxsDQo+IEBAIC01MzUsMjYgKzUxNSwxNiBAQCBzdGF0aWMgaW50IHRkbXJf
c2V0X3VwX3BhbXQoc3RydWN0IHRkbXJfaW5mbyAqdGRtciwNCj4gIAkgKiBpbiBvdmVybGFwcGVk
IFRETVJzLg0KPiAgCSAqLw0KPiAgCXBhbXQgPSBhbGxvY19jb250aWdfcGFnZXModGRtcl9wYW10
X3NpemUgPj4gUEFHRV9TSElGVCwgR0ZQX0tFUk5FTCwNCj4gLQkJCW5pZCwgJm5vZGVfb25saW5l
X21hcCk7DQo+IC0JaWYgKCFwYW10KQ0KPiArCQkJCSAgbmlkLCAmbm9kZV9vbmxpbmVfbWFwKTsN
Cj4gKwlpZiAoIXBhbXQpIHsNCj4gKwkJLyogWmVybyBiYXNlIHNvIHRoYXQgdGhlIGVycm9yIHBh
dGggd2lsbCBza2lwIGZyZWVpbmcuICovDQo+ICsJCXRkbXItPnBhbXRfNGtfYmFzZSA9IDA7DQo+
ICAJCXJldHVybiAtRU5PTUVNOw0KDQpEbyB5b3UgbmVlZCB0byB6ZXJvIHRoZSBiYXNlIGhlcmU/
ICBJSVVDLCBpdCBoYXNuJ3QgYmVlbiBzZXR1cCB5ZXQgaWYgUEFNVA0KYWxsb2NhdGlvbiBmYWls
cy4gIEFsbCBURE1ScyBhcmUgYWxsb2NhdGVkIHdpdGggX19HRlBfWkVSTywgc28gaXQgc2hvdWxk
DQpiZSAwIGFscmVhZHkgd2hlbiBQQU1UIGFsbG9jYXRpb24gZmFpbHMgaGVyZS4NCg0KPiAtDQo+
IC0JLyoNCj4gLQkgKiBCcmVhayB0aGUgY29udGlndW91cyBhbGxvY2F0aW9uIGJhY2sgdXAgaW50
byB0aGUNCj4gLQkgKiBpbmRpdmlkdWFsIFBBTVRzIGZvciBlYWNoIHBhZ2Ugc2l6ZS4NCj4gLQkg
Ki8NCj4gLQl0ZG1yX3BhbXRfYmFzZSA9IHBhZ2VfdG9fcGZuKHBhbXQpIDw8IFBBR0VfU0hJRlQ7
DQo+IC0JZm9yIChwZ3N6ID0gVERYX1BTXzRLOyBwZ3N6IDwgVERYX1BTX05SOyBwZ3N6KyspIHsN
Cj4gLQkJcGFtdF9iYXNlW3Bnc3pdID0gdGRtcl9wYW10X2Jhc2U7DQo+IC0JCXRkbXJfcGFtdF9i
YXNlICs9IHBhbXRfc2l6ZVtwZ3N6XTsNCj4gIAl9DQo+ICANCj4gLQl0ZG1yLT5wYW10XzRrX2Jh
c2UgPSBwYW10X2Jhc2VbVERYX1BTXzRLXTsNCj4gLQl0ZG1yLT5wYW10XzRrX3NpemUgPSBwYW10
X3NpemVbVERYX1BTXzRLXTsNCj4gLQl0ZG1yLT5wYW10XzJtX2Jhc2UgPSBwYW10X2Jhc2VbVERY
X1BTXzJNXTsNCj4gLQl0ZG1yLT5wYW10XzJtX3NpemUgPSBwYW10X3NpemVbVERYX1BTXzJNXTsN
Cj4gLQl0ZG1yLT5wYW10XzFnX2Jhc2UgPSBwYW10X2Jhc2VbVERYX1BTXzFHXTsNCj4gLQl0ZG1y
LT5wYW10XzFnX3NpemUgPSBwYW10X3NpemVbVERYX1BTXzFHXTsNCj4gKwl0ZG1yLT5wYW10XzRr
X2Jhc2UgPSBwYWdlX3RvX3BoeXMocGFtdCk7DQo+ICsJdGRtci0+cGFtdF8ybV9iYXNlID0gdGRt
ci0+cGFtdF80a19iYXNlICsgdGRtci0+cGFtdF80a19zaXplOw0KPiArCXRkbXItPnBhbXRfMWdf
YmFzZSA9IHRkbXItPnBhbXRfMm1fYmFzZSArIHRkbXItPnBhbXRfMm1fc2l6ZTsNCj4gIA0KPiAg
CXJldHVybiAwOw0KPiAgfQ0KPiBAQCAtNTg1LDEwICs1NTUsNyBAQCBzdGF0aWMgdm9pZCB0ZG1y
X2RvX3BhbXRfZnVuYyhzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLA0KPiAgCXRkbXJfZ2V0X3BhbXQo
dGRtciwgJnBhbXRfYmFzZSwgJnBhbXRfc2l6ZSk7DQo+ICANCj4gIAkvKiBEbyBub3RoaW5nIGlm
IFBBTVQgaGFzbid0IGJlZW4gYWxsb2NhdGVkIGZvciB0aGlzIFRETVIgKi8NCj4gLQlpZiAoIXBh
bXRfc2l6ZSkNCj4gLQkJcmV0dXJuOw0KPiAtDQo+IC0JaWYgKFdBUk5fT05fT05DRSghcGFtdF9i
YXNlKSkNCj4gKwlpZiAoIXBhbXRfYmFzZSkNCj4gIAkJcmV0dXJuOw0KPiAgDQo+ICAJcGFtdF9m
dW5jKHBhbXRfYmFzZSwgcGFtdF9zaXplKTsNCg==

