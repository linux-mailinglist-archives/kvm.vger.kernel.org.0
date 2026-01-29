Return-Path: <kvm+bounces-69505-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id VJjJFdjzemnDAAIAu9opvQ
	(envelope-from <kvm+bounces-69505-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:44:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A69AC016
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 06:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DA8B53008992
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 05:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F272EB860;
	Thu, 29 Jan 2026 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKelQ9cC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906512E8B66;
	Thu, 29 Jan 2026 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769665493; cv=fail; b=dfbIYAxH8+p4fC7cHh/pHHKt/I7NCIn0ZG8p1MVp71ex88tLIGdoQHEnoX9hXuCTBPg3DEgQeIa1e+kyYcpFZ2lflS6UES+Ik48kTAZvfddKPjj9jSs8ckqcafpYCl42KdfoU6VZpgUzWm+GtmKXY+Wez60wddNrq+jUEE5yF1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769665493; c=relaxed/simple;
	bh=a33bqKqs+8woSuovqNg1QQ7W3DpiQCc/byAT+ipI5dw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Izf1sMJlLmTvtKDS+nzLeuk06Jo1IBShblEwM56XTPnFt96Jlwqlxxy/cG1uaIARurqdWCyBqcPA6UpDjoDe+Hle0sakzE7rKGhIignPeh2MICH8CvOuhQij/SLxi7OF8AzEIWsfTYEePyyMvZAio93Ogox18GN3+lI9fusAsks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKelQ9cC; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769665492; x=1801201492;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a33bqKqs+8woSuovqNg1QQ7W3DpiQCc/byAT+ipI5dw=;
  b=kKelQ9cCjggJ9SnOmh3NIE8VutmUrbqe36JAvtIkn3FfUvmCLqn82vWR
   jckxn3yP1SgN3VuGC9Ayy+CauHIv8Kw4Cmi1ne4XAYn6mkdB45wYKvr/c
   jAUcaY8al4JbRkfSvmrovus5qKJGgiLsVntcPDB6CcO+trVZvgQ/Jew/D
   cpAFSBwR5UBxvg5WJp4daAd+tXoHupDhz7tYN4BGQchjj2MuYVQ7TJY0q
   76NGeMcJ8kLhxwdhG7fJjVO72CFaa25xCpJ0L/1DIUswycyRlyU9CeUq4
   v+NqqIwEvsG11X6ejhtybraG7VCpkIQWx8dTbez3QQ9OjKMF4Q0YuWl0O
   g==;
X-CSE-ConnectionGUID: RPd23Wa+Qd6XLHcAUdG7SA==
X-CSE-MsgGUID: cvkSjfMEQe2BLt1w+AiXCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="88465849"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="88465849"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 21:44:51 -0800
X-CSE-ConnectionGUID: b3r1OvyvRcK31tmBzX/lCg==
X-CSE-MsgGUID: SuD3UBAXTNOQCMBXT1gWWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="239722704"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 21:44:50 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 21:44:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 21:44:50 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 21:44:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPLKtfO3Y5ptVejILipjExQmamM/isNw/tX3v3xF4MsIFnOza2ekNOi/33Gu1Xa3lztiTxecHSQFylF1OPjlx7LqKtSNpKam0ym3KhdzJwLJttAyBUfhGs5R1D99GHCrKOpBnycc7+qk+GbJk90uclzstTh/Vft201vX60gAoKRKfwMm+e9M+jRx0jzNub8NVyJevJLHsz6oFOvRPcfEoYqRGNIAAu7l9mrh+m6CxWRjWTPGTUgdFR7ZEzpju7u+mo04i0MIY8o4nCrFMVAu3UYwCopAKTJGwRjWzbfsyo7nDqAxitDtJLhkru/kzb7sE1Q9oSMJYTtOogsfJQSdsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a33bqKqs+8woSuovqNg1QQ7W3DpiQCc/byAT+ipI5dw=;
 b=VTXOxRmfLd7DJmhJfVYhCZHT7gBHfuyVGBo+nlQHrEDSK/1G0S/jRQnIxAifgckBotxunwDvaWS1Nl66FIQLqZF2Qked9k9dEk/BhP3cpOTT7FB6kL1M6r3XdIZKP87yqVj0udA7htuNYYV4bXewX0UtPbNj7nUQqOuZJ14uwGEp6Ms6UmzH7kw02rbaQw3epthTUl/OgztxAe8bE8Fvg1WuG67hu6qEbG8og8WVdHBCEQ02GXh6DM89qLeQM4LsvPaxi5o7Dq1Bk2rhT45kyHDTlCQSVCh7eNa/+Hhl0hEXqWXgsdWnQVwewZr4bqwcV/e6HYp2apWhPGlNvmSeFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB9523.namprd11.prod.outlook.com (2603:10b6:510:3b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 29 Jan
 2026 05:44:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 05:44:41 +0000
Date: Thu, 29 Jan 2026 13:44:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 01/26] x86/virt/tdx: Print SEAMCALL leaf numbers in
 decimal
Message-ID: <aXrzu53C1PCEHtcU@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-2-chao.gao@intel.com>
 <fafd9381-b8be-40eb-a68f-da4c81e2653c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fafd9381-b8be-40eb-a68f-da4c81e2653c@intel.com>
X-ClientProxiedBy: SI2PR01CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 92212857-5807-44d1-5f8e-08de5ef97fc6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YeZNOg4G/YzaIW3iPaxVK6LLIuISrcilLUqMA7O+9WX1FyRW58WuMHxT2zYt?=
 =?us-ascii?Q?5ltwZ6sKUuRY4aIcYktbV6o5i4fxwSCE1yAclpsyLHOjU4ONQW7Xai66h9Hp?=
 =?us-ascii?Q?hxng9Q9yjBOkmn/WaoFD479NEcCbmR4oI0GZ0QBcxa4EJ0ezAUJ/7y97lJ7v?=
 =?us-ascii?Q?/yl9pYIJ8MiciuoSR2WLdo81ZbsvH/BwWo0hydBoH4CUsxoAMI22ttz69zrQ?=
 =?us-ascii?Q?XEw56uDiRWNKeyYBON31XfaJL8qrBrHFZy/FKknmiQ0SxvZoq5/v7kmn+t0y?=
 =?us-ascii?Q?XfBvCjWrX4cfnSIPTYiLiXmYZLqwTe5r/7A8HzntPd6zwm6t5SMXaN7Xk8g6?=
 =?us-ascii?Q?4NGFQTmq0FSohDNHUx9W6+qI+TORmNK3AFW/QWx51jItVlkx9ikhXjDVE3UK?=
 =?us-ascii?Q?cog0DavHJwp/73NoSVuextxfeeKxpy5AKnxpw/EzBNtfKPRa/6G4nSVRBkI7?=
 =?us-ascii?Q?Fsv98mw450MnroBKzUOB9ee3D2nvokhB5aANTULcPUbvxc4YGv/LSl93XVbB?=
 =?us-ascii?Q?6Jw1AXXjV1rK2Bz7empI4BERfnGR/n07NSVKxQe1MwkMSjsyJ901MZ0mjp1b?=
 =?us-ascii?Q?n2XsEMYAmFeSTd+Lksf2lBnwNdGBS+ydc0r1WrTrZ5p4VbaNZ9BvIFXfbZus?=
 =?us-ascii?Q?NTq4y1nxSBgrLBDBIWg6S1QvYOHMRgitjBdQunyr+eFJOr5XbL+J2HaSlGCu?=
 =?us-ascii?Q?6Z+sjn/YdhyVsyT1hSE+HzVemvDQNGIXSWR6WGggpPRVAK3FtBl5tVXFK0xB?=
 =?us-ascii?Q?PKYY/eHfd3Qk87uFMHzO0XQVUixf0nihqe79YYW+b0z+/n5RB/hvm3GAUO0x?=
 =?us-ascii?Q?JI+9OaRTJqcxxMmkABvgvoKuFBy00oScGwsIdE0Xlit4AY7qx3uffNLrfgfm?=
 =?us-ascii?Q?Oyos2c4swYOgOXY1O+LEvd+wmXBhdPswogmaxhpM7Olafamh8PJJsc0WgFCH?=
 =?us-ascii?Q?jKjSRd0PP1Y1ra1lc9v+zx29viCEPXWzk1mH9vra3ENBh1kijlKLlH7e1HHl?=
 =?us-ascii?Q?RV9dAZjWO7WPjkGomXDl0s4A/ip2v3X5jW0nlE+WQxT6ZpT9vnrl/9HPeeHx?=
 =?us-ascii?Q?ZGVbesWVXcQIzlWe4qNUafEIoQ2DUB8inO/r7tHcwSqzJbCdsm4uY/xMjVxV?=
 =?us-ascii?Q?dngeKgv56VoDw6IT6LTccyF8ZpXJf2KfRKfmHmHdH5WaxIUKCguuuRV2CKfz?=
 =?us-ascii?Q?SdDQo1xYAJg3/Sxk1BuYDvW4t68roNOCGM/YKfPRnl73CqMZDIPN809a2sAF?=
 =?us-ascii?Q?fDX+Vqsj5i4jfV0bAkzDWM0ikpQ3z8Hkn6wSh7io7k6TCGoARO0WImZQBIXR?=
 =?us-ascii?Q?ULQd8eHRkbtIDd3xEF8qy5PZ1qdg9KEo6VDOIm3F4xvSwiJKSFHzPd406Kk/?=
 =?us-ascii?Q?+W3QXF9f49TNguOD3lAjVHTbPUlcy+UeWUD7STeoP2sb60IcyvUf+redoOee?=
 =?us-ascii?Q?iQ4BvHWVgb2BG9b4mvSijLzNENTMfy+UJQz1GN7oWD94cHDwxUJj4tZiAXa0?=
 =?us-ascii?Q?n1561P6unooJzi0Sihm7qQm3p6HqkXgwvm6Kq+YQ4Bvbtxp03U8c3jX43zkM?=
 =?us-ascii?Q?Wn0fH8SlhScxXRZNetk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2b8+t5omCiuAlSUSPsxddQi5HKPygITTi/sWi+l2ZKu8nrmi1Tctb+lqGqe6?=
 =?us-ascii?Q?1Gw9orfT2+F6G9U4HQ8SeM2d8x0EFdUZgd3YWrVvpjagQALkQ3iPumEJ4BQH?=
 =?us-ascii?Q?9qcRuBmCB6grCcLKDonfCb0o9pqDgOt8t6ily0O7Zh6PBnrLvAIh7XICNoZD?=
 =?us-ascii?Q?paE+93ecapbkmbK1s4/m4h1EfRzb5V5fMYOwXc6Tw93E4eYtZGjxgxAPf2+B?=
 =?us-ascii?Q?ekC7lDz6mNQXIkwfcH3YyORG7L+yaqaudnvgbzIC1iv++skzwVmgAxSTehWE?=
 =?us-ascii?Q?epqIfuEHI/OWTu8xAqe97niFFtIew6b96buTs7zbjguoQ21YTkWQozloUyvv?=
 =?us-ascii?Q?o8ZVI81OmPN/kOOXoekhn+XVIbftbTuESkul8yXn0AahGIKkUd0DXY78sRgd?=
 =?us-ascii?Q?mFho1y0Cw6g96avfugREjTesSnHCE5SDMBC01G7DjYKd6VSvAoe3eRY0ns+M?=
 =?us-ascii?Q?a4AZOmrhiN6idy1szeorsuFvVPkGUDOr6PXrFBuKuLOTo39lvDBrjW7FPKh9?=
 =?us-ascii?Q?PLaFlEhAPZyL8iUFt8fodqN8k/F4+so6HruVTlJFcVeYidS6iewbrtycAii5?=
 =?us-ascii?Q?f1MzZkQNAUPqu2jXLd3DMzgGnrj1tEA8dTuvjEmH4nY2dlif9S0onRYiuu6H?=
 =?us-ascii?Q?3ATrn73y1gRrrsmVh2deLJ2ZAc/MC3gEiSq7EYEZNWwtuCHNd/aOEK1NkSMb?=
 =?us-ascii?Q?YBSzbaoBHcaW4RqlXYO2aXJMygrr1fvAy9mjM6OEYoTtTOrLLVjJnAosMcq1?=
 =?us-ascii?Q?GOz7e3Z9D8fbq4PWA7BC0t4ip3IzBcrhm9A/VF32RtOGOo5qyaV9c1L3CMZo?=
 =?us-ascii?Q?cepQ08Z3aESbHIdgb3Jy/k1GP29lhUcXf2vfT7SrGdKwajhouJTU2CwDygax?=
 =?us-ascii?Q?p2PkvH9V3B2xF4a0mGijit74lT6X0A7ArRFLbFtJgfsM++4zA4mjgYUOQYMc?=
 =?us-ascii?Q?MIq1J9UySqJhCf/mbGisPtGwlUygZBFQBzGm1oto5V//9I2WXac7zYSxTFQg?=
 =?us-ascii?Q?Xd2/SBBTuQ/3kpNP7CcbUKMLbl8Opc4DDBEnt6CfCMWMCp0bvRkM2DRHTK/V?=
 =?us-ascii?Q?5XdnWpQFLh83ohUgQyYqLbLbrbdaPmocgBok0f/znjfzO1ec0Rv4KzjdLf+1?=
 =?us-ascii?Q?ynh7ZZfXci/S9sxUHLghjMLLQjPXNbc/bXH3CHwMor1VIcpkKznzZM7+i78W?=
 =?us-ascii?Q?a6Ox4EuDhqVeMwYL1GhOoOQkc2TOVJ2r6UVZlwLu5/IeLU4sGVbctdM2mwPa?=
 =?us-ascii?Q?hOGYirzAsdInbG5fw7zaMjNdGmaMJyfu0h5Ek5TLzT4wDCxyoQkfjYm7Zc3G?=
 =?us-ascii?Q?5cPA+xPZ5GdV/OX/wHMhrKnIMwZ0yvcY5HIZiVvLsIAjSQ10SitSs6FQAY0q?=
 =?us-ascii?Q?9Me240qUOP49uqwvGvjNDklL1d6MNz75TKLRAk9dyQuR55EjP0KTm5NTFLEm?=
 =?us-ascii?Q?f93TgKDjv+yzTQVpDw4qIzmMnJOOL9E0rOo99gsR2YXZvFQETlfazNeET0lw?=
 =?us-ascii?Q?KicOPixp0S1/CmRw7CkQ7VDzudn9GkfKlyR7Y16eMZktJOi075x7flh0S8BT?=
 =?us-ascii?Q?XKFWwHRTBrTYFTbxypSmz5Vk9T320fxEhJLEc/FCpOx5ox3xxihYIaLp+VyB?=
 =?us-ascii?Q?zaHdWuJqQqt9V2jHuCZy0UqR1BRMSWfmAb52QRTMS2B/gFoPcQeIQuEb+Hg4?=
 =?us-ascii?Q?ckOm0HdtAGU8lceIxud2XxzYwbX2u65iwyseCe3V8Lv3BU73mFKcFcbFMofb?=
 =?us-ascii?Q?9+kzmTiHFw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92212857-5807-44d1-5f8e-08de5ef97fc6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 05:44:41.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AObKvhpHWVheVoTwiRTNfmDhUHQOfOzF6xQJytn4mDKbTQhO/t6kzL9atNFwLSFXcV75hKpEvEBxpP7AAznvWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9523
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69505-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E0A69AC016
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 08:26:43AM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> Both TDX spec and kernel defines SEAMCALL leaf numbers as decimal. Printing
>> them in hex makes no sense. Correct it.
>
>This patch has zero to do with "Runtime TDX Module update support". Why
>is it in this series?

Will drop it.

It was included because it came up during review of previous versions.

