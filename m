Return-Path: <kvm+bounces-67154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC63CF98DA
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 18:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21D3F306C74A
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5807833A9E2;
	Tue,  6 Jan 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hRNQjYyb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347C19258E;
	Tue,  6 Jan 2026 17:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767718872; cv=fail; b=nR2l5EmRGVXSzGbGdPDkZYfeRKzmv8vaRCg+xH9516FLjNXKuwTxmw32hh23eOCv6UADsAFLpscPLD++Zyv4B3R36XpTGiDk/bqnLYoJxRtubjJ39oR549/7BY8xWdZj2jZQf3dS1oI5rpOSJlDpu2wVPJ57IMv6tZiKjOCdBhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767718872; c=relaxed/simple;
	bh=VJCXzpXUkdJbDz3mc4VDO3hiKUzTHM1ghTXjXpksET4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BMNJsBqFPzIDE3qdZkq0+7gKAbjrV7IC7PuzqEwA6x7eOotqu3iLKfcGA+tS8eJIap6XfKdXIWJrHMTlpf7DQDVfcyiER+A8nDCgyN9W5LN5odI/9J3e0qLUMgakN77rKk0+rryH/UzGWnAeX2TvxG0nigcUhKfilrLM8F8yc5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hRNQjYyb; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767718871; x=1799254871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VJCXzpXUkdJbDz3mc4VDO3hiKUzTHM1ghTXjXpksET4=;
  b=hRNQjYybzHa9/B139tPY9TIKBIxPN/tB1HH5VMH6g1w4XsJDUXK9uNVp
   5VW6gJ4fNd3ev4hnFDAc+GvcjPyvvrmujJan2sEpyhTEEbU1urydRTG67
   XiqkaWHL5Hsdpp1J7idJ+2UGlg/jxRSRVCMMbkfHrYuKuYn/3JI9cBEpk
   gqepxTU76jMBObkmMq+A5pml6Ho4CJTdJR2f5w2rp8P5Mup1zGam5UCA+
   Hz/d7QYcfxAIdUJoazG35fI1gj37i+10DPsAOGsTwkKStsvrGKlAnmZ0Q
   MC89pl2gkHOqnCp3WW3CpHKh2II0a/UirzYHRg0KkcytHS2nr6ugtILGZ
   Q==;
X-CSE-ConnectionGUID: AGJi0O6YRkyQJ2EG0JGf6g==
X-CSE-MsgGUID: DMicCvtGQ4qfB92dgSPD+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="68282519"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="68282519"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 09:01:10 -0800
X-CSE-ConnectionGUID: mubozLkCRv65ZTYtSt4ZWA==
X-CSE-MsgGUID: 0nC4P8WTQ4O3izOF7/UctQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="233396021"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 09:01:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 09:01:09 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 6 Jan 2026 09:01:09 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 6 Jan 2026 09:01:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umpQ+69alcWBQU7cm4rC867IjMvQN1suOrJ7gWcs1ibq1iR48vgYtXfNuXoxLg6Ujuz5FV4QdyGMl4omAOCoPY1c5li3ICKUKPU20f24PR+a4kx1p9onz1wccofj+9ie766NpdmBZEOgeAa88IvbOvmV0D+w+2s39qsshcCH7BbyT7gF18IpY0y2D2vzSKxc7roMVvLN0dqywXo8sFRsVe3fqhy7AdRpBOehW3kjUUBwhWpc2TGpnwUIj4eXEQZAC+BKvn+oHKlOssi2Qfqi/H08JU5ByPscTfHYtWrpM5fPgJbt6I1YYgP7IcOEJ+ayUwGDJDXMeUDf8AuccyTbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJCXzpXUkdJbDz3mc4VDO3hiKUzTHM1ghTXjXpksET4=;
 b=bFvam/RDQ/vx8mOigHlBg/2FTXahGtZ4Cc+b/8Z/s+zCE+UuXvNA+xNcwRuO0UULgfSkxSaywWHZOBTvHW27ginO4f29rPdAnl4i476nvYHt9W4MrIeHtMjlecqbz+A9bIVSS9qAf9EFiOXaeAstazuT0HgyIARK+cGDegK+FuZgwNFzE0ZlDR33KJFUJX1PKKtT/bA2HchOeLb+5koJhUAJVlTm+cSqE7WE9qXzrVoZvkRTUP+7uU5wsObI6h6RsjL//4s4RhAEHFKUfFzTjszlnLXxogopr593S686GQ5+j/CjC9yN6YSW771j5SWA7vy2k+t+RcOIK31sBUNOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6673.namprd11.prod.outlook.com (2603:10b6:510:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 17:00:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 17:00:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcWoEG0U6tpU/nuka5qLmVaBAkzLUwtToAgBO02gCAAGMxgIAA2fqA
Date: Tue, 6 Jan 2026 17:00:48 +0000
Message-ID: <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
	 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
	 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
	 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
In-Reply-To: <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6673:EE_
x-ms-office365-filtering-correlation-id: a25fe58e-b04e-468a-ad5d-08de4d452425
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?c2J2RlNGVUllUzZCTEFqeWJlQ1o0Y2Nnb0l3SUVhZ3BhVFI5Nmt2QWR1RVBC?=
 =?utf-8?B?Y0ZKSDNlS2FTT0xEeEZEazJybUxDUWpzdW1uNkdUb1RuQUY3bzdsTXNTRDRJ?=
 =?utf-8?B?QUY5QS9lSzJpRWhnbW1UNVMwZXRkV3dXV1k4TG9abEpvRUtjR09mMWJpenFs?=
 =?utf-8?B?ZTVNN3pSMFhmMWlUUHBXaUpOTm9KZDAvV0E1QlliNTJUbS9BemZldEp3MWI0?=
 =?utf-8?B?a3VxbkEzeTZwSlJPRmtjdkVVWFlIR3AxZ2xsakgxbEpacEpLVFRHcC9aNWRH?=
 =?utf-8?B?MXQxWVNBUjlXRmNOY2F2VEozSG5GTzB0RENmdmlsT3FuWUtDYVZhWWtUdVhl?=
 =?utf-8?B?OXRRajdvSzAvRkx0czgyS3I4Z3o3dkNwVHViWGExZVpxOVNFa25WMm1xS01a?=
 =?utf-8?B?dFJlTmkwa1V0R2lxbHJ2RDYvcTlSckdpZmdyTTgzWTVPaEFSckFMQnRhMmpO?=
 =?utf-8?B?cGFVa1lxUTVnWVpqaElwRjN3RTU5SXIyM1E4bWRraVl6UlRpam1MOWV1bWNU?=
 =?utf-8?B?dHl6SWJDNTdCZWc4Mi83dllBS2Rqb2p2SXFPL0lyanJyT3lvMUxMbjd2SFJx?=
 =?utf-8?B?NzVGejU5WHUrL0xtcnhvaWhsQU1PNHQzc1J4ajBadlgycE5jSW9wS0lySndz?=
 =?utf-8?B?L3M3d2NXbFl3dHVzVmM5aGl1Z0N1RXJ2M1RPcHkyY1ZTVUxMZjljUjltSnpu?=
 =?utf-8?B?RmIrY1d0aFBqcVZpM3hxQ2tCUE5sakRZa0dVWWVsUWdJTWtwSGFlbWk0dEd6?=
 =?utf-8?B?ZmxJaHZyS09EK2x4VGJWTHR2SGJGRXlrNW1NclhsenV1THlqRllFTTd1bjY3?=
 =?utf-8?B?S0RWZzByT09rZHYwWDdTTVYzQVU3WmxrSXovYXZjUzhkbG9vankwcFU0Znp0?=
 =?utf-8?B?SzU2VGR1cXFTKzNSaWpxN3NrRFF2NFNmMjdzQlFmRGFrd2prc0FrUWJaRVhH?=
 =?utf-8?B?WSs1d3FGWGdkbk83Z0g0cmI3UG5kRC9XbldXenc2bjZYbTlZTi9ySDVSMU1q?=
 =?utf-8?B?RUlvcFRIU2R2VGdqbk56QVprejJ1QlhpTkYrbmpkS09pYkhWVm1tSnVkcHJR?=
 =?utf-8?B?WWZCc2FMVFhnOGdwZGFud2ZJTzNGT0ZXVmFNV2gxR01TcjVrVkZEVzAzY1Fu?=
 =?utf-8?B?MmdIT3RQUmVKK3J1NHYxTXFEeFI1UUloWHlSdWdHeFJLcUNjUHIwYzNrY3hw?=
 =?utf-8?B?M2NyanJ6S1c3OUdkeFlVTXptUWFHWW9ZS0xRVitnbC9ReXdHaUVZTkxZK2Rt?=
 =?utf-8?B?Z2JhQ1AzZ2VNYnJlN0JDZzJiMzRGbFZVb2pSSjhyZE5qWVBzcHRkQitvZzFw?=
 =?utf-8?B?NkhheTNEVE53SFZWUjRZTk9mb29BdG15YUZ1cTFvTUMxMi9BbnFLS2FnaG4z?=
 =?utf-8?B?bk0rSTNkODFqY1hVZ3ltN2dwbG9xNnpESlN3Q3h5aWQvZlQ0MGhUSElwM21T?=
 =?utf-8?B?REdkcmpNZDhndTJLYlRDT05mckJxRGp0YytIZW4xbnA5UHdBU2Z0VUpUVGNt?=
 =?utf-8?B?ejAxUC8yQy9jUHlxUmVHeTM3YkpSS0Y5QjUwVlVzRTZRck9WSWZnWlpkMStx?=
 =?utf-8?B?OEVWM2pkMC80NkhZdmdwMlZiODRYdFAvS3ZuYkNvRktGUjl5ak1DQXRXWTVr?=
 =?utf-8?B?RFJDSUQxR3BTZW5xbW5FazRqVUVEWEF5dnRsa2lhTFpoSUxLdGF1S2dQUk9R?=
 =?utf-8?B?c1FmTS9mVDRiN2NEY1lMTU56bCtHZTh2LzBYS0Z2R0NDUUtodmltTWpFclZM?=
 =?utf-8?B?TVNERTh2NHg2ekNuOUcyY01zY3RlNlE4SVFHMURraXBwT0h5WXZEVzQwV1c2?=
 =?utf-8?B?K254aVpSSXpLb1JvSG9mbitMQ1hER2JwaUlUMEtpWkxRTFlnUGt1cldnbjI4?=
 =?utf-8?B?TkxpbHhSbGdSeVdTMGgzQThxSUV4RXZpR2djVzQ2Tm5nMVRGZ1NoL0tiVzZO?=
 =?utf-8?B?RVlTWDNkcEVEd1AvZ3BWQXRTWjVReDA4a3VoRXdod1hyOVpESjByZENTaWpp?=
 =?utf-8?B?RHIvcUZGUmdVV2xSeU56U3FiRjR2eDdZMlBLYnhON3NPMHNjaU44Mk5aNkYw?=
 =?utf-8?Q?8fm+OT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZllwSEZCL3RZYkh6bnc1akRhMmtXZW1MQ1ZnNHAyK0MxeWNCRzF2M0s3cEFp?=
 =?utf-8?B?SDF1VmxVVXlJcENtMy82cWVzRm1qMURSbUFwR21RdVYwNjVTdktJbnhneS8v?=
 =?utf-8?B?NzkrTGVUbnFUYnU5MklTN1o4bEEwekREclA4dmNSb21wU3lqK2c5R0VxOUQ4?=
 =?utf-8?B?Z215UXk5cGhwNTErTXVUeXRZaXJ1OEVPdWNhY3llRWMxalROQ08rbVBiN09Y?=
 =?utf-8?B?Zi9kQlB6cVNIZUt3RnRzYjZuWlRESjBRWXcxaFE2UjEvNjF0TUVXYndkcTQ1?=
 =?utf-8?B?ZDBYUDhUU20xTHVFTUQyZG1MVUNKTk5tUlIwWGlxckRNQmVlT1A1ODZhaFpJ?=
 =?utf-8?B?ancxckxNdGVybTl6aE1yZzg1QVorSEViZHI4T0RLL0Q5WGFpVzFJQXFMVXJX?=
 =?utf-8?B?WFlraEN3N25QWmhTWW9ZYXJTWnc2NG9lTVFaQmVKcEQ4Z2pUcG5zblBKcm1m?=
 =?utf-8?B?WW5ZL3lHMVJoOXNLYzEyeWtLR2FuNDE2YjFkNWtIVEl2SDZ5d2V3WXB6MFVB?=
 =?utf-8?B?Umw0aWNGVHJiWHA0elRLdkxGemlKRmErckpmREN0U1RwRUVMYm1uYWdNMTBO?=
 =?utf-8?B?bDdXM3c2U2RHd3NuRTR3Y0pwUEVnK2xoL0ljRFdoN2wzRUNYQkJUYzhqTzVO?=
 =?utf-8?B?MTFrT0NYUlB5RGI1RkQ4c01TbFNua3JMYWNCQkZTQ0RmVUE0djBLcURHOHNH?=
 =?utf-8?B?M1hIOGZvcnJ3blJ1SlVIUEtqZ1phRXJpa2JFQk5EK09nOGMzRVlwSW9tK080?=
 =?utf-8?B?L2l3SFAvdmF0T3owaTJwVXd0TDNVUTRxUENodWZITFVaVVM0SWFLeFVEbWdw?=
 =?utf-8?B?dnBhSUhKakhiWG5TOTJ0aVVGOC9VaTFId2NpbWIzRGg0b1MvdmRMQkcralFo?=
 =?utf-8?B?ZlEvU2xNb21GMThKK2J1bnloUUw5MFZPWGJRY3ZZbG0wN0JIUkpidHRmanBn?=
 =?utf-8?B?QU9GcWNodGxhYkJCL3JpWjRvYTBONEJhdkU5UURTNzJTbisybVlGVkdmR24w?=
 =?utf-8?B?SGVsc1YwNkpJU1dBcnl6b1hPWE4wNjg3MGVHdXVHZTNFakIyNjNxRVo4aGJ4?=
 =?utf-8?B?dHB3OUtUYlFkSDB1UmpwNEw0K2ZEVE5xVWo1NFlpZmZCMmJ6VWg1SkIrY2cz?=
 =?utf-8?B?eC9jc3JNbFh4dDUvWjJ1QXFnc3FRQnppbHErR2pQTUxtT2FFTlJGOEpzMzN2?=
 =?utf-8?B?S1ZkNnlyUlNpMzEwOVZIa05QUGEvMktZaUFWTnBTOUhXWUhuNUZLVmhOVXk0?=
 =?utf-8?B?czJRUlEyclNBYlFBOVBjUkNjWkU1ckVPamJyYUI3dXdKMi9Cb2dSOHdWSU16?=
 =?utf-8?B?eGJnNkV3WCtsMVV6eWxubXFOYTh3R0VtTGhvM1htczNpWDVZSlYyQTlkRVpN?=
 =?utf-8?B?WFVURWtXVXZhc0FCSGlsQjg1MFBjNUtrczNoaEVPcTlnbUVkR2dYblUzVEtZ?=
 =?utf-8?B?MkNab0pubW8ybmh4OUlvNUtZNHhDNzdpellUWElucWgxNUI3dkgxZitkUG5J?=
 =?utf-8?B?VXFlRWFydWcwM3dHWkswcFVnSEVQdlM3eHhyZWxZUTJhcUo1Z1AweU5IdWRy?=
 =?utf-8?B?RUY3MFZsS3h1OGhTdmdDTmhmL1ExUllFSVVQNms2NCtxUkorTjBqS0xwV1RQ?=
 =?utf-8?B?U3J3R3ltMUxkR1VKZkZYaGlneXF6MmxEaTNJemZydlE3Z0dVNnN2MGxBcnhX?=
 =?utf-8?B?U2ZvbzBDWnd0RmREclIxSEVuTUd5VWh3R25ndHZtaE80QVEvN0piNGRZYTNS?=
 =?utf-8?B?K053YUg3ZzhEb1I3Rk9HTTlDRThlWmRXYi95Nk5XSktUOUcvMGl3bzlCTG1Z?=
 =?utf-8?B?emp6YzZJTTJGQU44WXE2QWgxSTRWdVg1OGxucWlvV0c5N21SWjh0dW1MY3cy?=
 =?utf-8?B?cllQRXhONDlvVDViaDZlQWNMd0hFeXMxaS8vREt0ZnFqS01HYktaK0NKSEVJ?=
 =?utf-8?B?SVhZSnByNVRTY0JSTGJCc2xWWXl2eTdSZFBtMCt2KzhQMS9WMmxicmZBRUhD?=
 =?utf-8?B?R3pLWlBjajgyeVhZd0F2RjlMTnNVNjR5bWM4YW1vaXVpVi9sZWhCUUpCejkw?=
 =?utf-8?B?YXRaUFFnYUZJa3I4blRyVzU1MjczQnVnb0h0TWFVR2oxY25UNnp3WjhjZ1d1?=
 =?utf-8?B?MFU2ZlFLYmRFVGN0UDlHZTJGbk0xTDFtWGdoc3QyMG05eFlURFp1WWFxaTZ3?=
 =?utf-8?B?VE5tbDBMcVBsTGhLb0lSZk52WExzV2s3YVB6YlNWMjRhWURlNWxXSnd6bFV2?=
 =?utf-8?B?QlhjdU9RaFFsMFV2TUJaTUR3MFg1VUFIeEtWeVFSTG9zZi9CRllQVlpqdlZo?=
 =?utf-8?B?d0luUUwxSEIrTmJWN2QrT1QwTDRYTFE0SndqNXBIMlpCaDJ0b2wzRFducjVo?=
 =?utf-8?Q?al+bYHVsRSqDg7hM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C21385D65F7514990DFB8DF724CD3DA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25fe58e-b04e-468a-ad5d-08de4d452425
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 17:00:48.7547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjG/Ss15bxtWp2pWTPXFihyF2+wpCASROGgBkitrjYfs5bMKyj5RzLUlewCf64FvBwDN5AZH/oAINOtzLwa9iTDxK1MosYnfOgGWNOSIYCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6673
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDEyOjAxICswODAwLCBYdSBZaWx1biB3cm90ZToNCj4gWWVz
IHRoZSBleHRyYSBpbmRlbnRhdGlvbiBpcyB1bmNvbnZlbnRpb25hbCwgYnV0IGV2ZXJ5dGhpbmcg
aGVyZSBpcywNCj4gYW5kIHdlIGtub3cgd2Ugd2lsbCBldmVudHVhbGx5IGNoYW5nZSB0aGVtIGFs
bC4gU28gSSBtb3JlIHByZWZlcg0KPiBzaW1wbGUgY2hhbmdlcyBiYXNlZCBvbjoNCj4gDQo+IMKg
IGlmICghcmV0ICYmICEocmV0ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoMHhBQkNERUYsICZ2
YWwpKSkNCj4gDQo+IHJhdGhlciB0aGFuIG5lYXQgYnV0IG1vcmUgTE9DICh3aGVuIGJvdGggYXJl
IGVhc3kgdG8gcmVhZCkuDQoNClRoaXMgd2hvbGUgY29kZSBzdHlsZSB3YXMgb3B0aW1pemVkIHRv
IGJlIHZlcmlmaWFibGUsIG5vdCBmb3IgTE9DLiBLYWkNCm9yaWdpbmFsbHkgaGFkIHNldmVyYWwg
bWFjcm8gYmFzZWQgc29sdXRpb24gdGhhdCBoYWQgYSBidW5jaCBvZiBjb2RlDQpyZXVzZSBiZWZv
cmUgdGhpcyBzdHlsZSBnb3Qgc2V0dGxlZCBvbiBhcyBwYXJ0IG9mIHRoZSBjb2RlIGdlbi4gSXQN
CndvdWxkIGRlZmluaXRlbHkgYmUgYSBnb29kIHRoaW5nIHRvIHJldmlldyB0aGUgcHJldmlvdXMg
dmVyc2lvbnMgYmVmb3JlDQp3b3JraW5nIG9uIHlldCBhbm90aGVyIHNvbHV0aW9uIHRvIG1ldGFk
YXRhIHJlYWRpbmcuDQoNCj4gDQo+IEFueXdheSwgdGhpcyBpcyB0cml2aWFsIGNvbmNlcm4uIEkg
aGF2ZSBtb3JlIG9wdGlvbmFsIGZpZWxkcyB0byBhZGQNCj4gYW5kIHdpbGwgZm9sbG93IHRoZSBm
aW5hbCBkZWNpc2lvbi4NCg0KVGhpcyBpcyB0aGUga2luZCBvZiB0aGluZyB0aGF0IHNob3VsZG4n
dCBuZWVkIGEgY2xldmVyIHNvbHV0aW9uLiBUaGVyZQ0KKnNob3VsZCogYmUgYSB3YXkgdG8gbW9y
ZSBzaW1wbHkgY29weSBzdHJ1Y3R1cmVkIGRhdGEgZnJvbSB0aGUgVERYDQptb2R1bGUuDQoNCkkg
ZG8gdGhpbmsgdGhpcyBpcyBhIGdvb2QgYXJlYSBmb3IgY2xlYW51cCwgYnV0IGxldCdzIG5vdCBv
dmVyaGF1bCBpdA0KanVzdCB0byBnZXQgYSBzbWFsbCBpbmNyZW1lbnRhbCBiZW5lZml0LiBJZiB3
ZSBuZWVkIGEgbmV3IGludGVyZmFjZSBpbg0KdGhlIFREWCBtb2R1bGUsIGxldCdzIGV4cGxvcmUg
aXQgYW5kIGFjdHVhbGx5IGdldCB0byBzb21ldGhpbmcgc2ltcGxlLg0K

