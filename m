Return-Path: <kvm+bounces-63087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8F9C5A843
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 360D83A708E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DD332825D;
	Thu, 13 Nov 2025 23:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Juzee69R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727AA328249;
	Thu, 13 Nov 2025 23:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075985; cv=fail; b=LKsr7Y94OzYPvWMLrYY/AH2W2TVfnbbQZwgLDaT0G8qJ3Km+6N5Eairwoqej3erS8SYkfftFc/IICe4S05kiSrx9Yh4kktPQPzyaVtzzAQBxjciq72bW6X90pqCxObQZR3V3ILrRbQzFhVoKYforHAoP/Bv6i54AYMdh/91MRvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075985; c=relaxed/simple;
	bh=saIz3k/fbckkmIgzLrSano5LgbSY/vbWsvyNAsv/sxw=;
	h=Content-Type:Message-ID:Date:Subject:To:CC:References:From:
	 In-Reply-To:MIME-Version; b=HuhuhnvLE+7wufjcbUfFgrghw3/4zNGyLvE+xsYF1VICUgDtY0mZDWbbqM0JEoRnhl+N4pLct3FnXZF9h2hdktuNUGgjknnNxVyFX6v+5mkAyTIYMWnCy31wUpOmV3/sDXth01uVowCc1L7IMb96SB7V38TJ1c6bj32WC30o5LQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Juzee69R; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763075984; x=1794611984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=saIz3k/fbckkmIgzLrSano5LgbSY/vbWsvyNAsv/sxw=;
  b=Juzee69RNi5mfbOH652+gHO+B4V/XLHRvDcSGWlzXUSf1spW1ijNYCbg
   EnkKqaO8WPXwMxCq+SBbXFLvCze8ebcXo2uc3Ch4gIqgvVN0CYRwVq2OS
   mcwFBNjVmXBTc5Cesm4s/3j88qsfnfk3Ek3TAQGa3lhl7+55VSayVXbi4
   WmLUxifY6QBMX6UEbrH/aY2RftCIcxYRRiBkSfELgoANJiXcd+cVgT+SL
   vgNimS52PAwLgDbv5x73nF/Y2hIGSr8EKln6OVE8Vdc7jXsM3+Z19opFX
   5JhqhgB5nURCxMbw0RfdS0i0TbN7MTtykfVOebEyztzNcT0rzUUb8F7Ux
   Q==;
X-CSE-ConnectionGUID: 4MW9vQxCTl+I6epUrQEL6g==
X-CSE-MsgGUID: rRwee1M7SZ6yQipvIemm/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65097980"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="diff'?scan'208";a="65097980"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:19:43 -0800
X-CSE-ConnectionGUID: MljEkwDiTSubylpW9ZeNmA==
X-CSE-MsgGUID: x4aI2FamSfiPcmDbid6x8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="diff'?scan'208";a="188913462"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:19:43 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:19:42 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:19:42 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:19:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fF17ySrgS3yj3BlmQX5w5YO0Q477KEDH204WntGXXjAI2chF+appTlTT6I01jZehbNRc9fSF7MbCEvpaA+M/UaRNnTMdVXai7QP7YeDefzY/exgNVJZ/8fB5sKm4xrZuUF89sRoXAuxftFKhiF/lYKrFpzzSWFckPIH919PvY+JdhKqlLZ51OaD3GyEzQCmV+f3CcP0Ykwruemurc/fwzGxdVsBXktDcpSwSIsp0IcYug+tv9qBL9E3Fsec9Uny31LAA7lAxgSxGfqoKSAQn91/EQXlDCx23hgPHL8Bp4OlS/NN7qg8pJbpNOb6MgRakP4ifhNeunhIgv1vCkDHubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxVZQvl3yRUblYslongv/FEiMECZA7RhzFYz8JKH+p4=;
 b=x6Yw4BiozaBqYfodOj6FvMcenRcyouYRjIa54pkCs2MXNpofOx+KnJkFjnI59ynTKFoRgeB+XdvRWcXA4NMLkAh+nYhF07NdQfekazUMyW5XOpxQfzoXJGwT8FiTQ8itg5ptSxset29ijOM++vVTLySRRIAa2TOQQ2VBniAoK16YsX5HZt38sK5D4MxeYVZbz2TtKHxb6boPeXZ/3j171o6WW4uocu9r5wR4IKGOAyAgBJTeOy4YPWIziD9pFB6NEvghxPadjCYrOfsCpQ2mHo1geS65yp5m47jBGEDhMd/rFAGc4XJrNYDhl9PtDL1tJmHdPDpXNiTRnol+kvPAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 23:19:40 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:19:40 +0000
Content-Type: multipart/mixed;
	boundary="------------xBLo0B0D0CBAshRe4ZoTOif4"
Message-ID: <ec2aa287-b8b2-4a60-b0fa-757588ea236a@intel.com>
Date: Thu, 13 Nov 2025 15:19:37 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 02/20] KVM: x86: Refactor GPR accessors to
 differentiate register access types
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-3-chang.seok.bae@intel.com>
 <7cff2a78-94f3-4746-9833-c2a1bf51eed6@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <7cff2a78-94f3-4746-9833-c2a1bf51eed6@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::35) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 621ad318-b6b0-46b2-3d04-08de230b1e87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|4053099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnVGSzY0bmVwSUt6Z1FUYzg5eXE1WXhxaVRDZTU4d2NUOG8wZlBYanJLMkxs?=
 =?utf-8?B?R2o1Z2gydldwS3hGV1pVS3FlMlBQOHRRL3p6Nnl1Z1FOUEhQL3ZiNitKenc0?=
 =?utf-8?B?bml4KzhFRHpaNGVmSUVoMDZmNTdHZTM3RnFFSW1rR2dFdDhFNTBiTHNENTNq?=
 =?utf-8?B?VVBwTUpFeTlWMVVsUW9YS2lVM09qaXllbzFkWi9lZnBDZmNLWjlLY3FNQ0sr?=
 =?utf-8?B?aFVKWlpvTCtiOHFQUW9SblJCN3VCUTZqaXJyUi9WL2hSaVh5c3VRaCtocC9H?=
 =?utf-8?B?RE03UmFlT3g0UVFLdjFZOGZ6bVBTbGl0NGRkeGZGUUlPbm1wS2NYMG9ac0xY?=
 =?utf-8?B?Q0RFc2Z0R2MwbkxmR1JYQ3M1TW05ZHA0M201a3p4MGd6cm9nbk1neHFhTXhv?=
 =?utf-8?B?MHBVNEhnYmZJa1ViQW9SbDhFL3RkS011UENSVlJnUmk5bS9PWHA1emJGc1dW?=
 =?utf-8?B?TEVJZHA1bERuOTlzRG1QaGd5U29tejlDLzR4RzlPcjRuZlhrdS9SSUVEMTJS?=
 =?utf-8?B?RWdSWElTOCtDNGxQZy9rYWc2YjdHMzRpR3dlVzdvN0xBblFRMFNPS0t2djVo?=
 =?utf-8?B?bW5hdXR5eDZoT1hlUHZoRE1qUlRXN1Y2RGgva0FpbC9aNGJTS0lnMGUyZ0x4?=
 =?utf-8?B?a3RqTEw3dW9KS3FveGsxcXdTQzNxZE1ObXR0bXo1NEJ5NDBVVXQyV2ZyamZT?=
 =?utf-8?B?UVpmQjIxeW5EM3F2WXVSWWJ1QTVFb29GN05RZkpIeGVyQWJLNG9tWk5rTm0r?=
 =?utf-8?B?WjhBNDlYa1pEeEFQYWhNZExTdmtYZkMyODZtaE1OdG5pYkg5ODNYZUtYQTZF?=
 =?utf-8?B?cHRoaGxlaWF6WVpkcGtLRERpRDlYNjFDa3V0K3YwRXQ5bVhUSnpFM2JxUXk3?=
 =?utf-8?B?amVJZGFGNURma0tadkp0YmJsdXVrcTdteTlVcDg2NWdvbFdTVFlsRVBPU1pN?=
 =?utf-8?B?aFQvZE1mdk0wK20yU0RtOUxLMDR4L2cxVUNSRTcyZkJZdWl2NENnVkZmbDF5?=
 =?utf-8?B?eE9JdzZ3QUxSdzd5Y050OTltSXMybUN1TzdmcTZDNmppUXV3dXltR3A1eWVs?=
 =?utf-8?B?b0JMTjZlN0FQVnAydi9CRnl4NkcramF2Slp3NC9QTmtkR1JZb3I0YVk2eEtP?=
 =?utf-8?B?Z3VoK1RKWk9tMXpTL3JxMnFZb1Zpc0FwT29jdGsvTXVFRnJ6VG4ydFc3R1JW?=
 =?utf-8?B?ek54RWdpVit4bExJcHVXTUVpTVA4RHVkZGxJNjg1aWYrY3pIOHo5NEtndnJY?=
 =?utf-8?B?c1ZHSGNhdFFocDF4bno4MkxMN1A4OVlTa0JnYXc4SGFTeWt6Uk82c1lNV1Fr?=
 =?utf-8?B?YnByN1JsWXoyTlNKcUc1S0tyc25BU0FvZjNoc0puRy9wbTBkV1czZDBNaTFs?=
 =?utf-8?B?UEFHbmc2RDVuVjA5UlRKbGxQek5kOFBpQWhRR09ZR0tUc0FCdkY1akUzT1Er?=
 =?utf-8?B?N0JLUW9rVnF0QTMvczN1RTNMRVhsUVRuNnM2TitiZm43MkRtYVFrMExnUDg4?=
 =?utf-8?B?L05GdkYwbi9xUUZTZ3JUaE9HdkpKcnU3NHIxVHlZVS9kSGlwNjgxbXZuY3Q2?=
 =?utf-8?B?WncrT0pLdzZKZEwzTEhNb1luZ2N0MzZYWUxxRlZPNVQ3WTl2THFPdk9HOWpv?=
 =?utf-8?B?aUJydVVodUdnSHFTT2lwUzd1RXRDUWlUMU83bTMzT2xKSUZJSTBlMVo4VGN5?=
 =?utf-8?B?bngyaVNDOHJsM2lZSHU5L2RGeFkvUHlUOTZuQXpSaWxUQTBJbVgzSFpiZzBs?=
 =?utf-8?B?dmdhcmluVXhKNG9leWNIM1c3UUFQYjJLZkxsYWM1OElyQ21zTDlTT0pRWW9n?=
 =?utf-8?B?S2Y2VGVOM2FvVTl0M3dPdzcvSGQvT2MxM0NtaXFmTC9Fa0puVHlLVHlCd2Vp?=
 =?utf-8?B?QWlKZk5kTUNnbzA4QmNDWml2MVVDQ29STjdHUHhtU0Y5UFN2L0xZdTJQQk5B?=
 =?utf-8?Q?c63CVQLIUAPJgMqBTiDM41SnOLa4ajSA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTRZc0o2WFBJUHROaDArUHp2WlgyUEgxZnlnMGlKV1RpUGNCSUxpOTVYR3BH?=
 =?utf-8?B?N1o0TkhacW4wRkE5OWY2ZldTRnEzaUVOWFE5SDZqUGQ0SDZOaU5mbXVMVXNE?=
 =?utf-8?B?N2thUzlYVnRsV09kWUJobUl6M1VTOTBZc3lpL2U3eDI1N1BRTnBZRUcwWnJV?=
 =?utf-8?B?TzVrZWVHeXB5SEdzRElkZmJQd1p3T011bm91elZGdDlGTTF2b1NNanlTcWxP?=
 =?utf-8?B?b2U1dFNzdnVRVWRMTUxNcUlsQ0hPVkNDSjNWMXZJak1ENlFiK29wNGdWMTMw?=
 =?utf-8?B?aG9DNkJ4cmo2YXp4eWNGN3hFWXEvTENhVzRWekZWR0J0emhENzVkNHBJeldv?=
 =?utf-8?B?T0FrQVNYcHJtNi94d0lpdEt2a0hsT3pXZnE4OENvRW9UdU9OQUQrQ2J3bWRX?=
 =?utf-8?B?c3hrK1g3dzNKSXBSOVhXVnZlY1B4djVicjRJSG84M3NiUEFqeVBVd0ZZZElO?=
 =?utf-8?B?MUtXbXFYRzRPWGxVeUFDUG5rNFRpdmhOUWlqMlErcTVLM1QxT0w5eWZUN2xn?=
 =?utf-8?B?SmxTdElGb3FCbjBCeENkSXFXb0pvMXlYdmhmZDY3VTliQ2N3RkhGOTZsT1VB?=
 =?utf-8?B?alpiTDBPSm5jczV2dWxnQll5TmZXbTBvcE1zVUdWTzZpZmlKS3FOa0xtSUlM?=
 =?utf-8?B?OTUvQnI2TmdWSnVmdWhnODlzcnIwUVNISU8zUEg3aTZwbEVZMEtqYyt1bWFL?=
 =?utf-8?B?M3crb3pmcTFUMHMrbGVPYlZPcWluY3dCZVJXRTVxL3V2Y3NzNVBsTVRRWHg2?=
 =?utf-8?B?K2V5b01XeWM2RndnZ0FIcktNQlJ3MDJIWjNIdDArMTEyUXJRMm9Pd2dIMGhu?=
 =?utf-8?B?OFU0Z3BSeDZqMmlOMmZ3TDdpcWR1NDBrWkNScThKVzJFY2hod2xjMnlERzJ2?=
 =?utf-8?B?cTQwZmUrL2IrS2dhYnRWRk9tMzhJT3FubHBCcVRWVzZuSlZ3VVZVLzhCMC9q?=
 =?utf-8?B?V0VDWElicGhyRWhiMjBwZmxKSmRpd1FDaTRkOUlJVWlWUGd3VzJzRkJLZEt2?=
 =?utf-8?B?dkxOUEJabmZYaEVCUk1JVWllUVBKRUxCdEFOalFNN0R5TDNBNE5WbHlzZVg0?=
 =?utf-8?B?ZHkybE04NmVRZTVkaERtejZvVGdpVHdBSzdvdVpJMnVHQlA5Nlh4b3J6RFpV?=
 =?utf-8?B?L3RKTDM3Y3lUQXlTbThPTGZ4MWthSXNtK3F2QkhIcmpJOU5heFNodU44d3dh?=
 =?utf-8?B?a3g5bjY0Y29oYzA0VGVkOWt1b3BjWDdtK3ZGOGEvSEI5RFlDeUhzb3hmMS9B?=
 =?utf-8?B?WHF5d21lTDV2dUNwZnZ0UXdTWUJ1UjN5Qzg3dkJXSEtGN0xoeUNOWktNTjlF?=
 =?utf-8?B?bTBvdWRrNHJ1akVQRHdtZW5VRXJiZUlOSHB0aHdQTkFyVjRRNG5qZ1BCNVBR?=
 =?utf-8?B?RjRTWmIrZnBTL2hQUXRqaXB1cFZjQXpSVUU5MVlKSHdPa3RJTisyTGxTQ3lL?=
 =?utf-8?B?dG15ekFCTEVjUU9uWHNDMEI0QVZhVHdQZEVRc1h3UXdlbFNhcUlhZkE4Lzg3?=
 =?utf-8?B?K2dKWWdIb0ZXVWhYSElzckZYaW9xWjFxZDNDSWFpRytPRDh3Mnh0clh5a1pI?=
 =?utf-8?B?L1h2aG9HVm9xYXRMSHhJeXZBNExKQThEeVNsekpwcGR1a2RQMTV2VUJHWDFT?=
 =?utf-8?B?LzRabjlBUGYyZ0MwQSsydHhrdUVCWWJ0ZDljeHVYdUV3eGY5emN6QXFkWlBo?=
 =?utf-8?B?ZnZDQTRzMTdMQjdENHAralRiL1hPaWhNQno1bUpRdis5bXE0UkwxRDhkbjBK?=
 =?utf-8?B?SUlqMjFnN0srUjRIU0pLbUtrZzFORWZlWkh3Qk1UOTlZTDZRZlB6Nm5LTHNH?=
 =?utf-8?B?WEVBekt4WVNpT1NWMEVHekdHNEkrYVZGWmVIMWRUT1R2Y2dOKzdnbjQ4L0Qy?=
 =?utf-8?B?WlpycTcyVGE3VjN4RHNiajYzekowcmFTb1dxS003QlJ6Tk1HR3pjNmVOYjEx?=
 =?utf-8?B?NGVtUGZkNnpIQnVJOWQzaDVXRXBDRXlJb2Z5cTV3V0wxM1BCRGE1UlMrY0Fx?=
 =?utf-8?B?L21DNHlUUGkyamd1UVljNmtOdzJtRzFLVmJlV2ZYbithZ0JGSElOaGhWYVBt?=
 =?utf-8?B?SVdLV2x4b0doM1hFMVN1RW5BRUM0KzZJT21sMjQ0M0JPd01wbU5Ga3VMZEpa?=
 =?utf-8?B?dDBWekFoT3NkbCs3eitQWWtzS2wvZ0xqNGNRdFNMeGs5MHZmaGthQUVQdWlm?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 621ad318-b6b0-46b2-3d04-08de230b1e87
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:19:39.8901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +A3bIFydk3IPJkzNIC0nSRvZW84XgT1MmDZhaLM56T87KILTMOSGrNMdth4jf/vJUBo12vdaL7E8q0JJteG5t28O7iCrfXcu7n2rXuSu00c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com

--------------xBLo0B0D0CBAshRe4ZoTOif4
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/2025 10:08 AM, Paolo Bonzini wrote:
> 
> Do not inline these, they're quite large.  Leave them in x86.c.
> 
> Also please add a KVM_APX Kconfig symbol and add "select KVM_APX if 
> X86_64" to KVM_INTEL.
> 
> This way, AMD and 32-bit use the same logic to elide all the EGPR code.

Yeah, that makes sense. Here is diff on top of this patch:
--------------xBLo0B0D0CBAshRe4ZoTOif4
Content-Type: text/plain; charset="UTF-8"; name="PATCH2.diff"
Content-Disposition: attachment; filename="PATCH2.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9LY29uZmlnIGIvYXJjaC94ODYva3ZtL0tjb25maWcK
aW5kZXggMjc4ZjA4MTk0ZWM4Li5lMGZiNDYwYjZkMzcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2
bS9LY29uZmlnCisrKyBiL2FyY2gveDg2L2t2bS9LY29uZmlnCkBAIC05MywxMCArOTMsMTQgQEAg
Y29uZmlnIEtWTV9TV19QUk9URUNURURfVk0KIAogCSAgSWYgdW5zdXJlLCBzYXkgIk4iLgogCitj
b25maWcgS1ZNX0FQWAorCWJvb2wKKwogY29uZmlnIEtWTV9JTlRFTAogCXRyaXN0YXRlICJLVk0g
Zm9yIEludGVsIChhbmQgY29tcGF0aWJsZSkgcHJvY2Vzc29ycyBzdXBwb3J0IgogCWRlcGVuZHMg
b24gS1ZNICYmIElBMzJfRkVBVF9DVEwKIAlzZWxlY3QgWDg2X0ZSRUQgaWYgWDg2XzY0CisJc2Vs
ZWN0IEtWTV9BUFggaWYgeDg2XzY0CiAJaGVscAogCSAgUHJvdmlkZXMgc3VwcG9ydCBmb3IgS1ZN
IG9uIHByb2Nlc3NvcnMgZXF1aXBwZWQgd2l0aCBJbnRlbCdzIFZUCiAJICBleHRlbnNpb25zLCBh
LmsuYS4gVmlydHVhbCBNYWNoaW5lIEV4dGVuc2lvbnMgKFZNWCkuCmRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMKaW5kZXggNjAzMDU3ZWE3NDIxLi41
MDYwYWZjOGI0ZjggMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2bS94ODYuYworKysgYi9hcmNoL3g4
Ni9rdm0veDg2LmMKQEAgLTEyNTksNiArMTI1OSwzOCBAQCBzdGF0aWMgaW5saW5lIHU2NCBrdm1f
Z3Vlc3Rfc3VwcG9ydGVkX3hmZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiB9CiAjZW5kaWYKIAor
I2lmZGVmIENPTkZJR19LVk1fQVBYCit1bnNpZ25lZCBsb25nIGt2bV9ncHJfcmVhZF9yYXcoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnKQoreworCXN3aXRjaCAocmVnKSB7CisJY2FzZSBW
Q1BVX1JFR1NfUkFYIC4uLiBWQ1BVX1JFR1NfUjE1OgorCQlyZXR1cm4ga3ZtX3JlZ2lzdGVyX3Jl
YWRfcmF3KHZjcHUsIHJlZyk7CisJY2FzZSBWQ1BVX1hSRUdfUjE2IC4uLiBWQ1BVX1hSRUdfUjMx
OgorCQlyZXR1cm4ga3ZtX3JlYWRfZWdwcihyZWcpOworCWRlZmF1bHQ6CisJCVdBUk5fT05fT05D
RSgxKTsKKwl9CisKKwlyZXR1cm4gMDsKK30KK0VYUE9SVF9TWU1CT0xfRk9SX0tWTV9JTlRFUk5B
TChrdm1fZ3ByX3JlYWRfcmF3KTsKKwordm9pZCBrdm1fZ3ByX3dyaXRlX3JhdyhzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIGludCByZWcsIHVuc2lnbmVkIGxvbmcgdmFsKQoreworCXN3aXRjaCAocmVn
KSB7CisJY2FzZSBWQ1BVX1JFR1NfUkFYIC4uLiBWQ1BVX1JFR1NfUjE1OgorCQlrdm1fcmVnaXN0
ZXJfd3JpdGVfcmF3KHZjcHUsIHJlZywgdmFsKTsKKwkJYnJlYWs7CisJY2FzZSBWQ1BVX1hSRUdf
UjE2IC4uLiBWQ1BVX1hSRUdfUjMxOgorCQlrdm1fd3JpdGVfZWdwcihyZWcsIHZhbCk7CisJCWJy
ZWFrOworCWRlZmF1bHQ6CisJCVdBUk5fT05fT05DRSgxKTsKKwl9Cit9CitFWFBPUlRfU1lNQk9M
X0ZPUl9LVk1fSU5URVJOQUwoa3ZtX2dwcl93cml0ZV9yYXcpOworI2VuZGlmCisKIGludCBfX2t2
bV9zZXRfeGNyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIGluZGV4LCB1NjQgeGNyKQogewog
CXU2NCB4Y3IwID0geGNyOwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5oIGIvYXJjaC94
ODYva3ZtL3g4Ni5oCmluZGV4IDc0YWU4ZjEyYjVhMS4uNGUyM2M5MTVmODU1IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9rdm0veDg2LmgKKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5oCkBAIC00MDAsNDEg
KzQwMCwxNiBAQCBzdGF0aWMgaW5saW5lIGJvb2wgdmNwdV9tYXRjaF9tbWlvX2dwYShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGdwYSkKIAlyZXR1cm4gZmFsc2U7CiB9CiAKLSNpZmRlZiBD
T05GSUdfWDg2XzY0Ci1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgX2t2bV9ncHJfcmVhZChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCByZWcpCi17Ci0Jc3dpdGNoIChyZWcpIHsKLQljYXNl
IFZDUFVfUkVHU19SQVggLi4uIFZDUFVfUkVHU19SMTU6Ci0JCXJldHVybiBrdm1fcmVnaXN0ZXJf
cmVhZF9yYXcodmNwdSwgcmVnKTsKLQljYXNlIFZDUFVfWFJFR19SMTYgLi4uIFZDUFVfWFJFR19S
MzE6Ci0JCXJldHVybiBrdm1fcmVhZF9lZ3ByKHJlZyk7Ci0JZGVmYXVsdDoKLQkJV0FSTl9PTl9P
TkNFKDEpOwotCX0KLQotCXJldHVybiAwOwotfQotCi1zdGF0aWMgaW5saW5lIHZvaWQgX2t2bV9n
cHJfd3JpdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnLCB1bnNpZ25lZCBsb25nIHZh
bCkKLXsKLQlzd2l0Y2ggKHJlZykgewotCWNhc2UgVkNQVV9SRUdTX1JBWCAuLi4gVkNQVV9SRUdT
X1IxNToKLQkJa3ZtX3JlZ2lzdGVyX3dyaXRlX3Jhdyh2Y3B1LCByZWcsIHZhbCk7Ci0JCWJyZWFr
OwotCWNhc2UgVkNQVV9YUkVHX1IxNiAuLi4gVkNQVV9YUkVHX1IzMToKLQkJa3ZtX3dyaXRlX2Vn
cHIocmVnLCB2YWwpOwotCQlicmVhazsKLQlkZWZhdWx0OgotCQlXQVJOX09OX09OQ0UoMSk7Ci0J
fQotfQorI2lmZGVmIENPTkZJR19LVk1fQVBYCit1bnNpZ25lZCBsb25nIGt2bV9ncHJfcmVhZF9y
YXcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnKTsKK3ZvaWQga3ZtX2dwcl93cml0ZV9y
YXcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnLCB1bnNpZ25lZCBsb25nIHZhbCk7CiAj
ZWxzZQotc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIF9rdm1fZ3ByX3JlYWQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBpbnQgcmVnKQorc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGt2bV9n
cHJfcmVhZF9yYXcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnKQogewogCXJldHVybiBr
dm1fcmVnaXN0ZXJfcmVhZF9yYXcodmNwdSwgcmVnKTsKIH0KIAotc3RhdGljIGlubGluZSB2b2lk
IF9rdm1fZ3ByX3dyaXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IHJlZywgdW5zaWduZWQg
bG9uZyB2YWwpCitzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2dwcl93cml0ZV9yYXcoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBpbnQgcmVnLCB1bnNpZ25lZCBsb25nIHZhbCkKIHsKIAlrdm1fcmVnaXN0
ZXJfd3JpdGVfcmF3KHZjcHUsIHJlZywgdmFsKTsKIH0KQEAgLTQ0Miw3ICs0MTcsNyBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgX2t2bV9ncHJfd3JpdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQg
cmVnLCB1bnNpZ25lZCBsb25nCiAKIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBrdm1fZ3By
X3JlYWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnKQogewotCXVuc2lnbmVkIGxvbmcg
dmFsID0gX2t2bV9ncHJfcmVhZCh2Y3B1LCByZWcpOworCXVuc2lnbmVkIGxvbmcgdmFsID0ga3Zt
X2dwcl9yZWFkX3Jhdyh2Y3B1LCByZWcpOwogCiAJcmV0dXJuIGlzXzY0X2JpdF9tb2RlKHZjcHUp
ID8gdmFsIDogKHUzMil2YWw7CiB9CkBAIC00NTEsNyArNDI2LDcgQEAgc3RhdGljIGlubGluZSB2
b2lkIGt2bV9ncHJfd3JpdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgcmVnLCB1bnNpZ25l
ZCBsb25nIHYKIHsKIAlpZiAoIWlzXzY0X2JpdF9tb2RlKHZjcHUpKQogCQl2YWwgPSAodTMyKXZh
bDsKLQlfa3ZtX2dwcl93cml0ZSh2Y3B1LCByZWcsIHZhbCk7CisJa3ZtX2dwcl93cml0ZV9yYXco
dmNwdSwgcmVnLCB2YWwpOwogfQogCiBzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2NoZWNrX2hhc19x
dWlyayhzdHJ1Y3Qga3ZtICprdm0sIHU2NCBxdWlyaykKCg==

--------------xBLo0B0D0CBAshRe4ZoTOif4--

