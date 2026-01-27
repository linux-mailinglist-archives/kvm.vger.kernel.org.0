Return-Path: <kvm+bounces-69185-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yc1bDDcveGn5ogEAu9opvQ
	(envelope-from <kvm+bounces-69185-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:21:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9928F7F9
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60FBD3013D5F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922483093D8;
	Tue, 27 Jan 2026 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L83ryCYI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550EF1A9FB4;
	Tue, 27 Jan 2026 03:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769484075; cv=fail; b=Kr8YTXDGrbTe+ozMe8RQH1uJCtEvFHKGmkesi2xAVk/3LViWGSv4yA4e7kNlUbvlVcKlrM24jY0SdOihUwBpdbNRl79VNXJhg7oIboRBY0X9MYVyR98/v676vdheXvVGv0jnPkZd11txym5R4RVJgD2ZbAcotkMCWk3XJMuq7Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769484075; c=relaxed/simple;
	bh=E0SwlPZNzAoVeDBhhdHqWT/ffkw2SSqt4HD9vLgsDIU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q4OpzWqKjz4S77iqfCszOq/1MxIZUXVoT/sp0kfX/wJXNj6RNGmf1UfrOeG3l/a1VsrDsZ7/NU++zRExEdZ6vKdKJB4dzsJRJ/wwVZ8AZWGfyJ8vCJbIrMgXVIqVCJkZTA/fX/ODUxX7H+pwyisLNTFUMQs4fz6JAmhs356ROo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L83ryCYI; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769484074; x=1801020074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E0SwlPZNzAoVeDBhhdHqWT/ffkw2SSqt4HD9vLgsDIU=;
  b=L83ryCYIr3z5ogc6ytfH0r+rUh9OFb/aMM/UKjt1+DV1rtwXaiibG46M
   B66t6lMz2JlLsgL3DxaSBePA0uQGqKfC/kHu1YuGgmrrk9Ul+oJMLbmk0
   rg9gBbeRmkCXFd51FO/160T5kvdimfP4AYIJe3T2AuLRshOfDreCT4vkk
   DbwHf6UtHgDauuau1WEEaA4J7R51B7YOJQMjiMmzOEkWuwXwK4ieukTFd
   yyJajZiaGW5IfMVi+qGqTf85BwWNSUxLcx4l/4r0YecFyJsbfwkc9W2AA
   oEHV5yFxJDnJO37IhZincbncFHUmHhKFyB0gblOS+RKfBI9qRRdCuJG5g
   w==;
X-CSE-ConnectionGUID: 3kiymgaoSuK7Mfe9FEifZw==
X-CSE-MsgGUID: x2WBEqkPSCWgnbEE0cYnQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="88083979"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="88083979"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:21:13 -0800
X-CSE-ConnectionGUID: kTohJ1/SSGqXCeH9AKK7sw==
X-CSE-MsgGUID: 2c+FnCv4TWCKD/9HdrbmuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="211962575"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:21:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:21:11 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 19:21:11 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.52) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:21:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aEku0qDw6eNM876RbhMXNj92i1x5g5P/e6DN+RKM5qZOu9saU8rV4ddkMFG1O3dw3j/1TJjE6/5OOeogmMeiM0+2jRireYdXjkNV441s3/Cqs7JqUVe4NtQeU9lHX5UmY6pTvF1SjDUhXZxsvEswTQA871LoJ/nMoOgxAHWORbvVTxh+lJSf+UjZBVSYEHBW2JfYPbGVs2SZLspCC+jPbX+0W5I9ckvb6f9Wwmhtmi/n6qTkTrv3znQhA12YMZYTB/An4w7mqUEFtw4eIARq7TR9Cgmed6qF/M6uFv3C3QiwmNP0ss2wELdncOohI8iJddzSgxcRhwLfQar6WXyONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0SwlPZNzAoVeDBhhdHqWT/ffkw2SSqt4HD9vLgsDIU=;
 b=vPGAHZKPkdp5eHYkPk7AuV07HNM15560zVAEw0ypm86msOe8Sn/gPtScWWlh3zHNBcLWiGJb4lOmdTjzOOEqtevAoAKHe8+aShB7JmID4aX9ex5TZ0bFFJ41HGJQkF6TUc/qAtnoGXPY41gLH5vrUfEhGlqzlbnuaDgNtIAmuUEnu4Hl2+EtnizpmTF3HqMUCqfH/8BlYM1XiyDb2Z1usob8pEcCfAB3MeFgIupFY15LGZGUFhz7HfDePGWyz5FCJ6nNTn12e/f8xlsFiRgTnNFLhlhp92aqReIvq49O7flBgiPLXOQ/Kr6zN66GUfQOmGaQcthMW8wJCAw686gRXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS0PR11MB9504.namprd11.prod.outlook.com (2603:10b6:8:28f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 27 Jan
 2026 03:21:09 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 03:21:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a module
 update request
Thread-Topic: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Thread-Index: AQHcjHkYth7yej19Fki+xmlQ4+sdCLVlXveA
Date: Tue, 27 Jan 2026 03:21:06 +0000
Message-ID: <fc3e72ec4443afd79ccade31e9e0036e645e567b.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-14-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-14-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS0PR11MB9504:EE_
x-ms-office365-filtering-correlation-id: e2b5bc4e-9c81-47cf-4bc7-08de5d531c51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?T0Jlb0pSVHdtcGROWFhwQUpUdWZwbTc2eUc4Qnp1QUorUTFpTjk0Y2x6THFn?=
 =?utf-8?B?RG5zT1dsaHBTY1ROTGMyWjk1a2FEbWZuZXN1R0J2NityL0xzTGhGbXlsT0tJ?=
 =?utf-8?B?YnNxUEdrRGthR0dqdlh6bHZiVTFneWNURHpuTUlyQnZlUU5ZV1VkNmtId0lF?=
 =?utf-8?B?MmVQS3lMUEhiNTNkVTQ3RWovYnFabmdPZTBuQklFRCtGMkR1d0JFQ04zNE5C?=
 =?utf-8?B?Q290TTZvNzNrT2VOUHNCWTNzOE9QMzdVZzY3SmJYOGlsZWtXdHlwbUR0ankv?=
 =?utf-8?B?SHFkYzZkeU5SbTZJd3JPRzlJYXloTjZwMlNiSzFGckZDRXFHSEE2Z05SZnlR?=
 =?utf-8?B?bk54cnRTREtzcnhHRCthLytMQlZlSnhyWEhleDh0ZmFFbHpJamhBSnhVUllC?=
 =?utf-8?B?ODRLZ1hJMzhOeTJJdW40VUM3MHZTZU8yQVN1c0tocmRIMzVjOHo0enZtTVVR?=
 =?utf-8?B?TVlDS2pXVmJiRGJvU3Y4QWlQRjZLQnUyRnBBblRzSmM0QnpmUlNqS2h0cE1l?=
 =?utf-8?B?d2owN1hFWkJac2grTE1OOG90UW8wcXNNYWRpVXd2TzIvcE5hMXBNM05IVmIy?=
 =?utf-8?B?dUEzQ0tKSnQxaWZGamhuQ08yMkRYd1Z0UkEzVUxHaWRtZ1V4WnlEWkFGT3JC?=
 =?utf-8?B?ZmZySWRQM3Z6WUJTcDV1RE0wSW5WUGpFWEpmV3V0c3VUb3IwZmxRMmR6M1Zr?=
 =?utf-8?B?TUk1cnFwRDhuTnorYU5oeStQK3V3OE1xTUJaZUlDUHhwTVZBRndBNWhydHI2?=
 =?utf-8?B?dHBvQXpWTmI3dFpKVXpXUXgrQ0wvZWtoQUJlM3oxcmNsTXBEM29xUEYxVkFu?=
 =?utf-8?B?cVM4Q1RSWUtRWXhlK0F0Z214VG1TQ2YrdW03cWNYazFLc0huclpSclliN3pD?=
 =?utf-8?B?U3BrN25XUGorTzM4L1dyVDVrdFY1ME5yTWM0eWpQZ2NneE5IM0V4dERkYXVy?=
 =?utf-8?B?WnBXNTBRamlpU284QUkyWDdiSUpnQkF6MW1sTld6Z0RLVjUrc1BaRVR6dUVz?=
 =?utf-8?B?SDJHQWE2dWpOcVkwRWVVU0Y5YTQvQ0NOK0xqTnBRQUxNd3REUERNaFdBdm1L?=
 =?utf-8?B?WWh2bGw3eDFKa1Q0TUJuSFZ1K1pVWFFBNDJkTExIaHlYUGpmaDR5MUYreHpJ?=
 =?utf-8?B?M1krTE9mMS83aXZoN0RMa1F3SVNUVkUyMmY1OEMwVkxrQVJBOW5CV1dHL1dv?=
 =?utf-8?B?WTF5WDdEWUp6cnhLdEpYc3k2UGptUy9EeU1wcUZTMzRRSHhLbExMSWZCRDRh?=
 =?utf-8?B?b1pnMzdXV2krdmYxUzROUElPaGt6SlA2aGE4ZWdqSzNvSno4dTFramVzcGRO?=
 =?utf-8?B?OUFQTGhPViszd2Z6YS9HejduTEVNdG5NVnVubzRveDRPSDZJeW5tUU44czFD?=
 =?utf-8?B?aFFXZTFHRlozZVI4Z0llOE84Q2N0YU8wZ3pDMUFzUEVyM0JPeGFNeElDSUxy?=
 =?utf-8?B?UGFNcEtYQmdTSmo3b3hNazB4SzlRQzExOUh4dWcvWG5uSzlUMG5FL1JpNTBL?=
 =?utf-8?B?eHZjRDgwdmlxS3RybEJZeGNFNnhNTm04bUxmc2pLR09qQndHL2ROVEkybExJ?=
 =?utf-8?B?NGpTNWs3OU5wY25KNHVLaGM0cDZiK3IxZmt0YVhRcXNwemgySnM4MzVtU3Ra?=
 =?utf-8?B?SXo0QlZITWpDdnJjaVoyRXNLZTNYd1pPVE1HN2JpSjYyUkNhTXh6eEZ0a0FP?=
 =?utf-8?B?eXhJTlpnbllOc1ZLZHdnUFpSMEsvWmRWM2Y2enFFNTRmMWtrcFJKTHdJTGd5?=
 =?utf-8?B?UWczdXZlUTNuVkFpUTFUWGQrdEY2MlN6T01xQ2pXZE9xUEVGb1FZY1daYlNH?=
 =?utf-8?B?RHp2TmRxSG1hUVdxMlp3OGVQNFlyenRNSFp1SG12eEFpWkNYSWdsU2NtWlVJ?=
 =?utf-8?B?a09qL3lCbmdQV3p3eE5FdFVqQ2UxWmxrR21Db1A2eEdPZ2pndGtFbEx1bk91?=
 =?utf-8?B?WkpCeFZtUFJnRkFCNU42eTNkcU1vdzR4b0NSZWZsa1JVWnZadFJWcVNMWkZZ?=
 =?utf-8?B?Y1REa245WElSbWx1TUxqUEcwajN5eXU4Y0c0VnoyRmcrMzdwMjFtRTNZakNm?=
 =?utf-8?B?THM0QlFDWm42TUo2OVRSejB1bk9WS004V2l1dUdXb0dMbmlPM2FzUTBUbnQ2?=
 =?utf-8?B?Mmt6OU0yakxsVEhkdDN3VURYQlZSZnZJL2VlbHpxVlJLbCtsS2t0aW1PZDBY?=
 =?utf-8?Q?eHwa4BsZhilM6x4jIXrS4B0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDBsNkgzcjlNWUFNb09VN1lzaFZhK1NFUldxSGI2OHZ3K3grUkVkalJwME56?=
 =?utf-8?B?ZURieWI4dzZQZ3VPT0U4QWFsLys0UmZCMytxanRqVUFnMWp4Qzk3dHMxM0JP?=
 =?utf-8?B?ejNUWVc2MkxIVTNPUG5OcmRUNUNhZyt3eWFPY2NUQ0RwVkhNMkZGYmRVYVV0?=
 =?utf-8?B?UGxjQ2lTdkJSVnpVTEdwUVl2bzRiV013R2hPcW5GbGN6TEN1TjIxTVh5QzQ3?=
 =?utf-8?B?WHhna2tva2Z0dXNnNUJQQzhnOGVJZHNOOUhnREZLUXdXNHBRVktSeERvTjVu?=
 =?utf-8?B?ODRwVG91YXREd1FqcGZNZzI5RnQ4OEl0L1hsVlN3V1I2VklnT1Z4citUN0dq?=
 =?utf-8?B?dUJLZktFWFZuQm8yM28rMkZxVVZvbUlTclNhQ2hra3JBbjVIcTZYRi9zUVZQ?=
 =?utf-8?B?cWZ1eU1VbXVySUhQbXRrUkxFNGxqNmlOM2t6Nlc0dzhLREFTbkg2SnRmYk1I?=
 =?utf-8?B?MVQ5RGcrZVFyTGZTT3lKYVhnNFc0T2M4VHloZk9qQnJjQzUrNlplaXZrUEpV?=
 =?utf-8?B?SlBBaVBKdFhacGw4RHVQeDNab2V5eFc3a1lCVzE3bldVNmNkNzUvLy9aeGpl?=
 =?utf-8?B?NUdzbTF0Nm9MZGd4QXZyUWI0aE9MbW1QT2YxQ094blowbU9RUTdrbldpWmhr?=
 =?utf-8?B?c0NuVHFQVkN6a3gxVnR3MHJ1ekUzSlVsMjBhMFFuVVhjTWdSWnRBUEhTTDRh?=
 =?utf-8?B?a1RVVy9iNC9NeEthR1h1SnZKM05YRWEvdVJVU1J4WTFPTW5UUHhjbnNNR1RK?=
 =?utf-8?B?Q0UxVXQ3dGhxVTM0VjlIaTBzZGFNUG9XeVJPd1l3QzVtaTJTUjhzK3hSekRL?=
 =?utf-8?B?czd6UTFSMzhvL1JsSnZiOUx1aitLSnFlbHF5bm02TnRUWUpWVUdONS9uVWdG?=
 =?utf-8?B?cmFkREowMmMwd2NsdXZqcGN2SS9RRHFQOXF4MGdUQThiSnZQZ01uSDFBZDU4?=
 =?utf-8?B?NVFGcU5kUDlMRzZGbVp5bitJTDFKTGtaWElQc3Q2a1RtaEFjTXhNaEZqTEIx?=
 =?utf-8?B?N0VnWm1nMWtHVDlPVXpHeDFLZzhzTStJL2xjcWZxZVVSVGxsMHlZNHR4TjlY?=
 =?utf-8?B?NlBWY0dvWXlKRWJudnZnYytCa3Mwb2N6MlZPbUZZemlrNFZJcFhoOExMU3pw?=
 =?utf-8?B?eDFOVmllSkpvSUpDdm11Q1dmZEhOdzEyU0p1SHA1QS95b3UwVUVYTTAyZU5J?=
 =?utf-8?B?bzA2SkVySWJveXp6Y3V5T25OMHYzY3RiS2VKalF6MytFc08rWFhiMXBBQUxX?=
 =?utf-8?B?QUNBOEhZMmdXTkZrQUY3V3o2L2YrcTAwa0RNMFVBa2RkMWpici9iSTF6RzJs?=
 =?utf-8?B?RjNNRGFIRk5rOHAzcmc1dFdzY1lIbWs1bWQrWEI3cG9jOEt5VW5mVStNU2Ex?=
 =?utf-8?B?TVVZWWEvNklnVElVWldoSkpMMStyWktuUnJzclVpeFV1R25XMlBQYnFHYnZn?=
 =?utf-8?B?ZFlrQlp2cXd5RHUzUTl4M2wwODVHNlVKdWxONU40QkVVd3RxbnZNbC9EWUs2?=
 =?utf-8?B?MXNwbGptNVNJVGdtQ2puT01NLzUrSzAwUHNDM0kvVjBHUWc4cFJWSi9jM3Ry?=
 =?utf-8?B?RlBmcGwrOE1LVytGTE9JUHlJb0lDbitGeUdQeEcyRFVFb1daSkdGbHpqa0ZJ?=
 =?utf-8?B?SVg1bUNqNDZsSXZsOGdNMHdUNENSdHRjak92L0NTOXBWUWRtUUVYWGtlOE1P?=
 =?utf-8?B?L1c0K1NGZmNSZHR2Q3BkYm5hT0gyaG5UZE4vTXZ1WDlvVURQVHlWRU9uaXcv?=
 =?utf-8?B?MlY2YXhLNHlyMUJEeFprZ3dJRGdXM3UzUlAvV0hNR3duTHlPUGNnbFgrTFEy?=
 =?utf-8?B?ckczVDgvYlhzTEthT3RHWFhMT0lvN21wN3RmOHhHM1BwS2M3UXc2amc1YURp?=
 =?utf-8?B?aHJNams4b1NiVGR2bzFqSHJ3Q1ZIbHRXMGRSSlRvSnhWa3IxM3ZWekhrNkJ3?=
 =?utf-8?B?TTFkQlRKTVZoc1ZuZzhDeDBqZ2pJYjlkQXhyNG9pMlJZaGFjMzFBOHNCb0JT?=
 =?utf-8?B?L0x6K0hwcVlzWEVTTGNDSGFXUXlHRlNVOUxEeGsyNUNvZGV3aGg5L2V3Nnhv?=
 =?utf-8?B?TFh2bUhNZ3dsVU9obzhHQlB5eHkrODE5OHE3UlVVNEQ4RHoxV2YwYk9vaCtP?=
 =?utf-8?B?RmtEeWU5NDMzZkRpbnkzTG9OclBUWTJuejNFV1hNdk5EWlo4Q29WaGxxczll?=
 =?utf-8?B?L1I2eGNkQXVpQlNWSlFUVkpERjhnRG5yNFZUNDljcTNUYi84aE1TU2hkdGRv?=
 =?utf-8?B?Z2FjSk5oK0RmM0NOb1Y3UUkzMjlVUUIrYVpRb2VhZDhhMWkweEVyTEltSFVr?=
 =?utf-8?B?RmViaHgvaUhDU0oraERxdjI3UVdwd3VPU0dIbXhQblBxaENjbFhjQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <394D10387F52DE4FA88B91C009DE385A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b5bc4e-9c81-47cf-4bc7-08de5d531c51
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 03:21:07.0871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLq4QTXmZqcFwKwWdqkmsVth7UsmcYEHdteb/uP5Bh4fWpoGsspnikoAsll5UWlDSrCTjumxMVJt9FTUKxnWGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9504
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69185-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 7B9928F7F9
X-Rspamd-Action: no action

DQo+ICsvKg0KPiArICogQWxsb2NhdGUgYW5kIHBvcHVsYXRlIGEgc2VhbWxkcl9wYXJhbXMuDQo+
ICsgKiBOb3RlIHRoYXQgYm90aCBAbW9kdWxlIGFuZCBAc2lnIHNob3VsZCBiZSB2bWFsbG9jJ2Qg
bWVtb3J5Lg0KPiArICovDQo+ICtzdGF0aWMgc3RydWN0IHNlYW1sZHJfcGFyYW1zICphbGxvY19z
ZWFtbGRyX3BhcmFtcyhjb25zdCB2b2lkICptb2R1bGUsIHVuc2lnbmVkIGludCBtb2R1bGVfc2l6
ZSwNCj4gKwkJCQkJCSAgIGNvbnN0IHZvaWQgKnNpZywgdW5zaWduZWQgaW50IHNpZ19zaXplKQ0K
PiArew0KPiArCXN0cnVjdCBzZWFtbGRyX3BhcmFtcyAqcGFyYW1zOw0KPiArCWNvbnN0IHU4ICpw
dHI7DQo+ICsJaW50IGk7DQo+ICsNCj4gKwlCVUlMRF9CVUdfT04oc2l6ZW9mKHN0cnVjdCBzZWFt
bGRyX3BhcmFtcykgIT0gU1pfNEspOw0KPiArCWlmIChtb2R1bGVfc2l6ZSA+IFNFQU1MRFJfTUFY
X05SX01PRFVMRV80S0JfUEFHRVMgKiBTWl80SykNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZB
TCk7DQo+ICsNCj4gKwlpZiAoIUlTX0FMSUdORUQobW9kdWxlX3NpemUsIFNaXzRLKSB8fCBzaWdf
c2l6ZSAhPSBTWl80SyB8fA0KPiArCSAgICAhSVNfQUxJR05FRCgodW5zaWduZWQgbG9uZyltb2R1
bGUsIFNaXzRLKSB8fA0KPiArCSAgICAhSVNfQUxJR05FRCgodW5zaWduZWQgbG9uZylzaWcsIFNa
XzRLKSkNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ICsNCg0KQmFzZWQgb24gdGhl
IHRoZSBibG9iIGZvcm1hdCBsaW5rIGJlbG93LCB3ZSBoYXZlIA0KDQpzdHJ1Y3QgdGR4X2Jsb2IN
CnsNCgkuLi4NCglfdTY0IHNpZ3N0cnVjdFsyNTZdOyAvLyAyS0Igc2lnc3RydWN0LGludGVsX3Rk
eF9tb2R1bGUuc28uc2lnc3RydWN0DQoJX3U2NCByZXNlcnZlZDJbMjU2XTsgLy8gUmVzZXJ2ZWQg
c3BhY2UNCgkuLi4NCn0NCg0KU28gaXQncyBjbGVhciBTSUdTVFJVQ1QgaXMganVzdCAyS0IgYW5k
IHRoZSBzZWNvbmQgaGFsZiAyS0IgaXMgInJlc2VydmVkDQpzcGFjZSIuDQoNCldoeSBpcyB0aGUg
InJlc2VydmVkIHNwYWNlIiB0cmVhdGVkIGFzIHBhcnQgb2YgU0lHU1RSVUNUIGhlcmU/IA0KDQo+
ICsNCj4gKy8qDQo+ICsgKiBJbnRlbCBURFggTW9kdWxlIGJsb2IuIEl0cyBmb3JtYXQgaXMgZGVm
aW5lZCBhdDoNCj4gKyAqIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90ZHgtbW9kdWxlLWJpbmFy
aWVzL2Jsb2IvbWFpbi9ibG9iX3N0cnVjdHVyZS50eHQNCj4gKyAqLw0KPiArc3RydWN0IHRkeF9i
bG9iIHsNCj4gKwl1MTYJdmVyc2lvbjsNCj4gKwl1MTYJY2hlY2tzdW07DQo+ICsJdTMyCW9mZnNl
dF9vZl9tb2R1bGU7DQo+ICsJdTgJc2lnbmF0dXJlWzhdOw0KPiArCXUzMglsZW47DQo+ICsJdTMy
CXJlc3YxOw0KPiArCXU2NAlyZXN2Mls1MDldOw0KDQpOaXQ6ICBQZXJoYXBzIHMvcmVzdi9yc3Zk
ID8NCg0KIiNncmVwIHJzdmQgYXJjaC94ODYgLVJuIiBnYXZlIG1lIGEgYnVuY2ggb2YgcmVzdWx0
cyBidXQgIiNncmVwIHJlc3YiIGdhdmUNCm1lIG11Y2ggbGVzcyAoYW5kIHBhcnQgb2YgdGhlIHJl
c3VsdHMgd2VyZSAncmVzdmQnIGFuZCAncmVzdl94eCcgaW5zdGVhZCBvZg0KcGxhaW4gJ3Jlc3Yn
KS4NCiAgDQo+ICsJdTgJZGF0YVtdOw0KPiArfSBfX3BhY2tlZDsNCg0KRm9yIHRoaXMgc3RydWN0
dXJlLCBJIG5lZWQgdG8gY2xpY2sgdGhlIGxpbmsgYW5kIG9wZW4gaXQgaW4gYSBicm93c2VyIHRv
DQp1bmRlcnN0YW5kIHdoZXJlIGlzIHRoZSBzaWdzdHJ1Y3QgYW5kIG1vZHVsZSwgYW5kIC4uLg0K
DQo+ICtzdGF0aWMgc3RydWN0IHNlYW1sZHJfcGFyYW1zICppbml0X3NlYW1sZHJfcGFyYW1zKGNv
bnN0IHU4ICpkYXRhLCB1MzIgc2l6ZSkNCj4gK3sNCj4gKwljb25zdCBzdHJ1Y3QgdGR4X2Jsb2Ig
KmJsb2IgPSAoY29uc3Qgdm9pZCAqKWRhdGE7DQo+ICsJaW50IG1vZHVsZV9zaXplLCBzaWdfc2l6
ZTsNCj4gKwljb25zdCB2b2lkICpzaWcsICptb2R1bGU7DQo+ICsNCj4gKwlpZiAoYmxvYi0+dmVy
c2lvbiAhPSAweDEwMCkgew0KPiArCQlwcl9lcnIoInVuc3VwcG9ydGVkIGJsb2IgdmVyc2lvbjog
JXhcbiIsIGJsb2ItPnZlcnNpb24pOw0KPiArCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4g
Kwl9DQo+ICsNCj4gKwlpZiAoYmxvYi0+cmVzdjEgfHwgbWVtY2hyX2ludihibG9iLT5yZXN2Miwg
MCwgc2l6ZW9mKGJsb2ItPnJlc3YyKSkpIHsNCj4gKwkJcHJfZXJyKCJub24temVybyByZXNlcnZl
ZCBmaWVsZHNcbiIpOw0KPiArCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gKwl9DQo+ICsN
Cj4gKwkvKiBTcGxpdCB0aGUgZ2l2ZW4gYmxvYiBpbnRvIGEgc2lnc3RydWN0IGFuZCBhIG1vZHVs
ZSAqLw0KPiArCXNpZwkJPSBibG9iLT5kYXRhOw0KPiArCXNpZ19zaXplCT0gYmxvYi0+b2Zmc2V0
X29mX21vZHVsZSAtIHNpemVvZihzdHJ1Y3QgdGR4X2Jsb2IpOw0KPiArCW1vZHVsZQkJPSBkYXRh
ICsgYmxvYi0+b2Zmc2V0X29mX21vZHVsZTsNCj4gKwltb2R1bGVfc2l6ZQk9IHNpemUgLSBibG9i
LT5vZmZzZXRfb2ZfbW9kdWxlOw0KPiArDQoNCi4uLiB0byBzZWUgd2hldGhlciB0aGlzIGNvZGUg
bWFrZXMgc2Vuc2UuDQoNCkkgdW5kZXJzdGFuZCB0aGUNCg0KCS4uLg0KCXU2NAlyc3ZkW04qNTEy
XTsNCgl1OAltb2R1bGVbXTsNCg0KaXMgcGFpbmZ1bCB0byBiZSBkZWNsYXJlZCBleHBsaWNpdGx5
IGluICdzdHJ1Y3QgdGR4X2Jsb2InIGJlY2F1c2UgSUlVQyB3ZQ0KY2Fubm90IHB1dCB0d28gZmxl
eGlibGUgYXJyYXkgbWVtYmVycyBhdCB0aGUgZW5kIG9mIHRoZSBzdHJ1Y3R1cmUuDQoNCkJ1dCBJ
IHRoaW5rIGlmIHdlIGFkZCAnc2lnc3RydWN0JyB0byB0aGUgJ3N0cnVjdCB0ZHhfYmxvYicsIGUu
Zy4sDQoNCnN0cnVjdCB0ZHhfYmxvYiB7DQoJdTE2CXZlcnNpb247DQoJLi4uDQoJdTY0CXJzdmQy
WzUwOV07DQoJdTY0CXNpZ3N0cnVjdFsyNTZdOw0KCXU2NAlyc3ZkM1syNTZdOw0KCXU2NAlkYXRh
Ow0KfSBfX3BhY2tlZDsNCg0KLi4gd2UgY2FuIGp1c3QgdXNlDQoNCglzaWcJCT0gYmxvYi0+c2ln
c3RydWN0Ow0KCXNpZ19zaXplCT0gMksgKG9yIDRLIEkgZG9uJ3QgcXVpdGUgZm9sbG93KTsNCg0K
d2hpY2ggaXMgY2xlYXJlciB0byByZWFkIElNSE8/DQoNCj4gKwlyZXR1cm4gYWxsb2Nfc2VhbWxk
cl9wYXJhbXMobW9kdWxlLCBtb2R1bGVfc2l6ZSwgc2lnLCBzaWdfc2l6ZSk7DQo+ICt9DQo+ICsN
Cg0KDQoNCg==

