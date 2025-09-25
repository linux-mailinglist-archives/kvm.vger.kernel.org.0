Return-Path: <kvm+bounces-58837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D04BA1F83
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C738627EAE
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 23:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE332ED15F;
	Thu, 25 Sep 2025 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mvt+mdq0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9D02EA17F;
	Thu, 25 Sep 2025 23:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758842890; cv=fail; b=C60YLu0i9cGSXsWrTLpLLom1CGKhaBqgYF4Cgq1mCBFOJIjMmcpznGlLIO0L+2VpiSfpmY8aH0NtyZnWDjcRzIjc+IzZKbGFJPhp/5bnCyUjOIrOKWesWtqb7di+zASfert3d1tIvIwXltCBe5A8qVKA0X46bDcmt5WavWYfJXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758842890; c=relaxed/simple;
	bh=knLRt+cq0BXiUZ9YBfHobyix8GTSj6+mP9GAGBX7sPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hUvMw1nNdrZ1/VES7mSbtcrbyT3p55QxzOD0n4F2pfD7HO9wW94CmvX+b0AE3ihmTxvd+Vu6fxhjVYcjYPwwS5tBUOWn6KugY7JTZf37T3ivObMnexqYeenaXfsVYRBLhJl9Dg0BmzkOMoiwG78WBkOS+hpbifuEH5xQlkNo4DA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mvt+mdq0; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758842888; x=1790378888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=knLRt+cq0BXiUZ9YBfHobyix8GTSj6+mP9GAGBX7sPs=;
  b=Mvt+mdq0J2/4zLpyhVtyhFJYWAPGKUdI3EPSZldPWX1xTiWmN8JGhLlk
   1XgNFz7w6vEv0eCVoI16eeL3atlVSiO/bwDz9FDziU/IMgfFh4WOsEf2K
   ZWH7OJ+aft2G6ip1R4BE+LiIherFcYaO8b9AhreowrXbsP7WKoJfWuYb0
   JyQBgTA5IrTu6w/8wDCel/5/U3XiFjWrpmK5LwbZM+DnAj9azvxfN7TvU
   rUVDCYciGm7FCEipwaWfEXb8SwPeuGFWKOC4/0rt/YW62RNQMxLPAbExL
   qJxLlRxOaz38l8i//5ViaXNfuI+1M5B8Lsut7wTzZ+mPFkn8I3pBwzHEY
   g==;
X-CSE-ConnectionGUID: QOqNfF6ySZmniT3ty6zZnw==
X-CSE-MsgGUID: ChmEzX7iRrKFY2QfyTQTyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="71793989"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="71793989"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:28:08 -0700
X-CSE-ConnectionGUID: ACPgWdqcShigJPOc8JHOCg==
X-CSE-MsgGUID: TsvXrDp2SgGgfxfiOcUN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177396063"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 16:28:08 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:28:07 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 16:28:07 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.41) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 16:28:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ay2n8y2mfGqxhsuIBqQcTn3Y9GoBleiAb7tdm/W5PGImbpGBDkbT3RGSs/krUKBdkCUZpfgqGL1ZdMxi6V/izvYKdgqxeNI1CBbsOWDdbZ8LcIYmKWJvo6yeIsNKMycQgi4v1eX1fyh25Xs8/0rToM0tEMC04T+EYXCenIoEMEeWDtEoZISwS3FeMlGYTtKDazQa7/UBC9LmH6dhvDzzIpESR/xKa0Yw8hrZKH0Mcz58md5ykvDZa2OlFEgB79tlhvfSCmqa7FCYfgj42QgGCXUBYX3DcxpQR5xoXb6TJwXeQkEWRDlBqgOF98ROK7vmJatqfHEItFqs/KuzVScLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knLRt+cq0BXiUZ9YBfHobyix8GTSj6+mP9GAGBX7sPs=;
 b=WNxxzGI1T3LgkbDSkI6oRfMtm4IIuHkk5gw2I6bWxdWcycbLEYTuhPuAcKgt2/BpLWAPYRUte7kt0HBoz+gnO9MU1hvBViEN1o91ZLoUchB6wsfS6qCNC2j1I+UNj+juwODDKeDzY44c+vxArrA3zR09jZ7Et+DJQei38wdeKCLASNkFVujr3PKiUP1oW+PpGUcbdGi+MyNfKKZuzHYNpAZaDTzxi4eNrQWP1nX19nuFbKgoG8lS5Q3sthl7iHHRKfINqgdoZlJFmTVAXzwOG4iHwgCJTzA8KvSd4Qlq9f1dwSNhKHkc/pXRHPCqIdzVyZTLR1KJtIjTCA0oLvN2Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6835.namprd11.prod.outlook.com (2603:10b6:510:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 23:28:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:28:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcKPMzhddSbzRYF0iAPzAr3eQJNbSgYdwAgAQ0UYA=
Date: Thu, 25 Sep 2025 23:28:04 +0000
Message-ID: <3d1da86e140059ec0da3f94ac72044766c94c768.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
	 <90fdfc53-ad71-44f8-846b-dd3f859331dc@linux.intel.com>
In-Reply-To: <90fdfc53-ad71-44f8-846b-dd3f859331dc@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6835:EE_
x-ms-office365-filtering-correlation-id: a4a17c26-0b2e-418b-dd74-08ddfc8b2d08
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VVYyVUI0eTBwNFdieFpRWWxBSG93T1ZMbEVqVFhuR0dPMXE3TXI1V0xhQjJP?=
 =?utf-8?B?K2kzYjFhcTJGZmlPb3E4WHVZNkl4NXhoZlNTV09TQi9Dc0s4MmNlUExzOFMw?=
 =?utf-8?B?Q2dndEo2Mkxrem5EcVRQSVNPZFkvRERRc0ludGUyV21Ddm1uVUdYdTJwbHJ0?=
 =?utf-8?B?a0hZNC9EREl5NFB1QXpYUjU0NWNIa2hEMTFPSGdIM083aDByUGM0RmhXajdG?=
 =?utf-8?B?bEg4N1ZML05ESHVYOElWOUVvbHVCT3E0aUtqVnFzdVIzenFNRE43dEpwVEJq?=
 =?utf-8?B?dm01ZlgxWllNV3gxeldxUk4xbFZQbkdXTzBJTVI1aUFyMDJpRUZuVGJOQnVn?=
 =?utf-8?B?aVpDZzlsZDM0NEFKTTIwMW5hYkxWdUs2bHBaN3pLV25INVdsTFdTYmszMEV2?=
 =?utf-8?B?YWN5WXZWeW9tYTQraDBab241Z2t2NHFQSzJ1YWpqYU9KaHZQWjdqa2VyUDVt?=
 =?utf-8?B?RFB1YjU1a21uUVFCUHAwWmNJNXNtdlkrZnJ2WUpDREhPZFhyMXFmNzNVU2pl?=
 =?utf-8?B?cUFOMDhwaXBGYlE4SGxjQnFMS3U2VTRua0I1alBQeE50WG5sbnY1UzFHYW1q?=
 =?utf-8?B?TUJCTW04eVpuaU40MkdxNXBQelE3ajNzaWhGWUhtbnRyMDdRVytINFJjNUZh?=
 =?utf-8?B?eGdLM09DcUlRbUVJdlk3eVpTTlE0M2VFT2JlSWpLNmNyc3RScGVWOWtNdkZI?=
 =?utf-8?B?VjVLTkRRbTZoTms2SktlU1UxamFRbDdHazZ2aUV6cUx5Tzhkcnk2dmIxdG9k?=
 =?utf-8?B?U1N1RERkeG1BVUxMdVJUaStwVmxNc2xacS82Q1U2RXl0d2NrRWFWcFpXTGE3?=
 =?utf-8?B?ZXRmeHhaYk1walVXa0hmRCtXYnFBb1p2TDBrd3lnT3lmT08vMzV4eUVWTDc3?=
 =?utf-8?B?UC9QMGVHclNVYkl1cU9ORldNNjZwcVpRT08wWWpCZElLK0txVDhtcEtrdStm?=
 =?utf-8?B?aEZUOEhwcXB5eXpQRTErNk1yUUd6VTVmcHpoTE9VQW9IcnVxU0FTc2ZYT2lo?=
 =?utf-8?B?aTJObmZoejhKazdCTG1wdWhBZGdmOFordlZSdDR2eXp6enpKSmVqRUNWZmtL?=
 =?utf-8?B?RFRLbWJRSzNPcTJkMFBWbHM0NGJ2Z3o2Q0MrY1VtT0ZXUS9RdTRTODNWWkgz?=
 =?utf-8?B?aVlobTNZQTQ5YXhHeHNQanNvRVJ4ZGU5Tm1STlVOMjR4cHFXajlmc2NqQklO?=
 =?utf-8?B?LysvRGlKeGZZbHR6UG51ZktxV2IrUWNWOXREUFFPSVdQUWR5eGpSMjdianJV?=
 =?utf-8?B?YUdYcXBPbElmS1VjRzkyVjlDMS9ibGo2UW5FQzRXSWlnZUh6RkFRbWd4T0Uv?=
 =?utf-8?B?b2NzUmNTVVFBbkFwZEQzMVpjRTRLRXpkNDFqS1JQTVNxZ3NZdENnQ0ZmUGdN?=
 =?utf-8?B?Y3ZWOFRidnBlUXhROXg5V0I4Mnk2THRUWDVxZUh6RHdJbUpvME9YOTNCMVNP?=
 =?utf-8?B?VWRidjFYdFlIclM1ZUlUbmlqVUFvVW1JSjN0bnJ6NUJnZ09XelUyakYzVmVs?=
 =?utf-8?B?MWhkL3J6dEF5TWJMdnhWSm9NNS8yZHIxblFOMTZ5TWRDTjBtUzNPSFVWU3F6?=
 =?utf-8?B?b3I3dFRBWWFkaWMrNVpMekFXZnBqYklIVkZXdWE1Rm16d0tGUDF3ZkFTNzE0?=
 =?utf-8?B?cXFyaWVNcFJGSDBtYXdpVG1ENEdKdVFiN1FMQjlrUU1YQWlUOTNKdVJzc2Rh?=
 =?utf-8?B?NDBzbmsrMTY0ZWd3U1diS0lEek5kc2tLY281KzRQcXBqaFlscVlBQmR5M3JH?=
 =?utf-8?B?YXQyYkUwT21yR3kwQytsbjlGRUdzQUxhOHZscDhRNXM0ODdObnF2aThBdCtu?=
 =?utf-8?B?elhuVUFibWVrYzJYZjlJV0xYZGI1T0t4aWxKSFRMam9DT3YxSmsyeFZwSHFB?=
 =?utf-8?B?T2lZbVl1aS9qYVJuNEpsVXE1bWgxWUZoa0VJUEx6RktNR3ZadVYvM2xSZUp5?=
 =?utf-8?B?MEFvdlZYUjN3L0tid1F0RDJTYXFjOWVPZlFYb1JHRmZOMDBrQTF5UnRBZElr?=
 =?utf-8?B?VmEvV205d3VMcXE5RnlyUXBuQ1RtSnRVUXcvY3A2YkdaT3VlWjhvMjFKMEtr?=
 =?utf-8?Q?KeB9zi?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MG5qZzdaK3RwQUduT2w5Qkw3cDJaYlhRQlBPa2JZUm1TTjdyRHdaNEtRKytW?=
 =?utf-8?B?OExhYS9oeVY4OGZvSzhiTkdXY1d1S0hBVlJhYTNEK08wOFM2UU9XYmpJZGVu?=
 =?utf-8?B?T0lJeUY1ZjNaeDdMZDZpWkFPNGRCZU42Y3oybUlzZkg3bWVFdjRsc3BOUitN?=
 =?utf-8?B?RlhqRDFrcGZFUGJhNnM5NDZIcU5LWXVtckVGLzN3NmQ0aU5rYnJuUmo2QmRI?=
 =?utf-8?B?OUZHbEFySEcvYUpqNXlDQ3Y0VVEzNkVxWXcwK2JOc3ViaGVkUXNXY2FWZVVH?=
 =?utf-8?B?blJlWVlpZTZ5UXl3ZjZpSGNhUkpIa2RTR1RJOFh4M2luUVI1cVI1eHBFVzh6?=
 =?utf-8?B?MGt3cUdNL1VOV243UFpFcnZOenlXNmlsSzJmcTVPdURCdVp0c2JRcThZZzEz?=
 =?utf-8?B?Wlp4MFVKNFVNVGNXUkV5S01rNmNYeFRTSHJVRGFhMDBsa1VxaU1XcTVycUxx?=
 =?utf-8?B?aWNBTjVBVXpEL1NKVlVwck1seGJiN1pHTmtiWkl6MkdDNHg4ZHlzSVo5bnd6?=
 =?utf-8?B?QlRoMTlRTnRhVlRHRjNTaitSdXdTL0dFaXZycEEvaXZGcWVYVWZVaXhLQW43?=
 =?utf-8?B?cW5YMVN1NW54bnN2YkFSbnlYSzRUS1BxaVVXYlNlQ1BHbGJLSlMvL0RSZXNk?=
 =?utf-8?B?Z2VxVVlyelpnWTdwbjM1MFBuZzBaQTBSOUphOUFzZ0ZaQTV6MVd2SUlTK3k3?=
 =?utf-8?B?MENzYTN0RkoyYVJPa1d5MVpxczNDN1Rvc0gwdS9UMjYwem9FYzRrQnFPdktF?=
 =?utf-8?B?cDFnNDcyTWpQaVorNE45S3V5Tmw4YUZ1TkZGSHhneTJQQk5QOEFJVlYyd3FO?=
 =?utf-8?B?bGRFbkdrZk16VmFGZUdDSHdhTmlPMElqNXF5ZmFkUkhTOU1MaTZhZlVpcFM2?=
 =?utf-8?B?Ly9ONzZIelBZK001MkhYb01lSEMvRmF5eCt0YmYzU0FhSGNQc3VKaWF2c1Qv?=
 =?utf-8?B?c1lnOU5vK0lxY3IvNFgzLzA4Z2RUMXhsTlBvWEdYa2RMdzR5WnVVMTJyQTNN?=
 =?utf-8?B?VE0xb3hoUkxBY0NvQ0hhZWxEeFo5NnVpc2d4akp3OUFrUm41VlBWQndxVWNU?=
 =?utf-8?B?a0Z1Y0ZkbWF5d0k5Z2pCMytyV0NsUk1aTGZ5TUlDbWJNd3BCMlE0ZUwxcUJW?=
 =?utf-8?B?QUNMMW1xbFBTYzVMNlQyM25VTVJJb2RlQlN3SVVQNW5BRzhZQzNuRHRhSDZ6?=
 =?utf-8?B?VlFrTzR5WDlyNHRFM2x5S3E5dWJXZmRqZDRmTkdNNGtFcm5KWkZzL2FWT0Mr?=
 =?utf-8?B?cW82c0EwMWdCMExyNHNaeDJuVEdjUXFSRk8vTk5OTXNzL21iaWZ2QmtZQnNa?=
 =?utf-8?B?TnYwbUpzTEFIWjgzNlFzQVRlZmFza09JbFRuN0JLUkVPSXdHWkZ4ZWMzZ1Mv?=
 =?utf-8?B?MW1RbWs1VXI0cnJKNmx1SjYwbDRFck5wVlBpN1Raa2ZmOHZIaE90bU0rNSs5?=
 =?utf-8?B?bEp0OUFVOG96M053THVoa1FWZWVMV0l4d3ZXSEYzWmdBUEQzUTdWUnZ2MFNo?=
 =?utf-8?B?VmtvcytnYUF0TUxsbEtIdkRFMnY5OTZmeDB4VmlhUmZkUnhqT1lGczVMWHNY?=
 =?utf-8?B?UER2RGZQZGw1RnBiQk1mNDhVSmkxVVBXaGFTeElZTk1NbWNFTjZOUlFQTllB?=
 =?utf-8?B?bXRacmFKbnl0aEZOb04wSStoc3BHa2YrcFA4NkJFb2NsVVY1bE0ya1NHZzQ3?=
 =?utf-8?B?R0RjU1pjUG5zbDFGYUFJQzA4Nk9VQnFpWVNFTytHRnBMQkxYeTVWdlN1K09K?=
 =?utf-8?B?aGFiNXVwNnJZa0VnUWRYU0VjalVBaGQ1T1VHK1lvTDgrdlpuMTVQOTB1b0dm?=
 =?utf-8?B?L1hlQ1pPU25kVDJOR0tBTXVRZ0ZvczhTd2RYUFhSejdyNHVOUlU5VkdjYTFH?=
 =?utf-8?B?TTNMaGZkOElMekdHVitTbkYwSk9Hb3Q5cmhOOGZpTEF6SkE5NUlQL0p0cjdJ?=
 =?utf-8?B?Q0hzWEMrVUFiSnQzVWZDUDBsckRHL3E4K0RWeGUzWVl2Q3o3R2dNcm1pQ3hy?=
 =?utf-8?B?WTdXTnFzU09SNUJxdEVPRWlWdXVVVC9vS1Y0RVNFWHY0dm1UcVJSZytuWTBB?=
 =?utf-8?B?LzROTGMydytuakk4a09lTEREeVZVRGo4NmI5V2dsbEg1SnlvVEZQTnlkeXJG?=
 =?utf-8?B?T0I2Y3VUNXY2bGdvekZoRjNDSU8zcjR3M25XL1U5WHZPRmdLdG16ZHVqSXI2?=
 =?utf-8?B?NGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71BE066A4AEA2746BCC47CD5B96EAD58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a17c26-0b2e-418b-dd74-08ddfc8b2d08
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2025 23:28:04.2227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypLjPcCKKxgggf/7CGEpQJfyqNYSbu4UE36CPB937ihwkh9wUMfrOzIW7Z21wTNr5qAXFEPr0f/YMCgq6F9q4kv8zPd9vaMTWBcS60FGNu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6835
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDE1OjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE5p
dDoNCj4gcmV0dXJuIFBBR0VfQUxJR04ocGFtdF9zeik7DQoNClllcC4gdGhhbmtzLg0K

