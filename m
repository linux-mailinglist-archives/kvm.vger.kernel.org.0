Return-Path: <kvm+bounces-71016-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODSSC3ZNjmkaBgEAu9opvQ
	(envelope-from <kvm+bounces-71016-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:00:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89A2F1316D1
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 23:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4280A30DB6B5
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87FC35D612;
	Thu, 12 Feb 2026 22:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fzM4NT3P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9064E346E64;
	Thu, 12 Feb 2026 22:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933611; cv=fail; b=U/1dlNl/cMHrH9kvVVtzfM0DolSwOTukDKwb1Q2BjLCrLhKF0etEmpuxH9HvNRpk3/DRy2i+jQ/KKCzwdDqP1LnFhaIrz9imh0dmPtH7JP6e2VGjLmwpVs9F6iETYr3sBtp0+DrMG+kjUycVN4bK959xlOvY8//sNkuc3BsHzd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933611; c=relaxed/simple;
	bh=75dMxpPEKBBCtb+x4uwZU3Y5h0KnRSIyPf9XwA8flsE=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=R54TRPzr0SRCD4OsLZjLSrIRBpztdc4pZ0Gr0+fCQXI7davkdpuhv98uHbpDaRoR0UTdVLYDgQVilL0oHLlELEJUMrcSKWnQjlaggsLQwwfazLcB3QZlR4VAp+U4q9Bype6WP814x5dlqU3VgkOWL3Wk8w20pV/yNfTmgcam8Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fzM4NT3P; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770933609; x=1802469609;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=75dMxpPEKBBCtb+x4uwZU3Y5h0KnRSIyPf9XwA8flsE=;
  b=fzM4NT3PQJ126ojhY5UfZdr2hkqvAvd3KeS22dUGmg1nOVtyWRnLuLD5
   yf/TZTqxMc0pa9VFo/2ZCUdxu/m9nJQORvXFG27h1uK5r3mORg5EnWxun
   JBvbRxIgq5FZ7rH0VS0iyRiS4qrXtwcw3uuhdPCrrPFqy8+oqxeIN89w6
   z1Fs9uhvD7WzfdLpGe/nZdtE3S0XRYN/lXTqNuYwVGAQxEwHotZTDpWHx
   8315tuUFtGnSDh9prF2DfvkyytEL/tHJaIgbkyFuz+l3KW2FDh8ORUb1s
   iAPDzK0jpEmyxNLrihfzVRdHCCfUFUo2DJu+xWTDh8G+EfjZTmAibQaIp
   A==;
X-CSE-ConnectionGUID: 1oLAM2bdS9uSRSXl9XHoYw==
X-CSE-MsgGUID: 9vL1BR8uQ3y4b/rg3YdI3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="74721725"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="74721725"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 14:00:09 -0800
X-CSE-ConnectionGUID: VQMp83SsT3GQAf/e+R6rOw==
X-CSE-MsgGUID: QtqlwhroTEW6HqB1xnjtIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="212208373"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 14:00:09 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 14:00:08 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 14:00:08 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.57) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 14:00:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBSgzaLfRACV74DGY2UocI5QWkvbNTQFWLva3AWoFCtp1Dtg0MfY3xlWT/XCi5xTLx8JU0oLXhqp4n8Cq0wiWrwfaC07oi9KaPDPQCP23LO/vXNgfHm79ghA5ee8cta8miclzeByM1cBy0E8Vngd/990HNLVoFFmgSvBtvODOuh176Rd8NwrFj8Clz7+gfQyM41UswjfjsCm127UPcJANdF2hqLD8H/3OgPwRv7syaOnvNpXgkQkWzXqLRHnBZ0G4Hfht7Psj6IodHKl19HDq9AbxEAvaN++0UkENBWQ3Hl3Y2x1KGsdXl/bnX9j8BYOUtlB8fnTkBlRtn6OBAbwJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRv3QxBCwkjFl4tp8HZorysezsl/gZUvk7KFj+DfQzs=;
 b=pRjCMP1T0jNyZsckwswo/u684lUjMqS0i8NbGbBhBmCWeCrnMnuOwPVCdVnWAshBy9jjsMgBnz1uBMayzY093fs7PGV8c7PiJVNa4D5REg80PxRxu1ENzD3GjbrCM0Bobtriv6ubdTzp+YN2YVu904uxwQESMWi9vv3RQgEFU+TjvhypqaqBN5rqG9qOi3NZnzmsyWTH6OW3aDaEDQgWwantRNRekHfpyVyyImB732vLLp+wfzW7cZiU0eufqr/yriN+DuDy2inqT+GmgKBjxDNTdaJIRV7zqqFVDYJshK/v02l3Mrv6O+mP5mBRSVbgzHAQ1aLqtA9q5N9dHFJwKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 22:00:01 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 22:00:01 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 12 Feb 2026 13:59:59 -0800
To: Chao Gao <chao.gao@intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>
CC: <reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>,
	<binbin.wu@linux.intel.com>, <tony.lindgren@linux.intel.com>, Chao Gao
	<chao.gao@intel.com>
Message-ID: <698e4d5f8eb44_2e571001@dwillia2-mobl4.notmuch>
In-Reply-To: <20260212143606.534586-23-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-23-chao.gao@intel.com>
Subject: Re: [PATCH v4 22/24] coco/tdx-host: Document TDX Module update
 expectations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d9174fd-e5e9-451d-5ced-08de6a8211bc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WVhaWStiTUxTR3kxbGVtV3RaOFU0Wk1xM3dkTVZqNXd2cXlDNDB0SEptUG1x?=
 =?utf-8?B?aG12VGRCNUcwL2xIV2UzK25QODI2djZackU1WTliMWh6NjN6ZjdOSmdmL3o0?=
 =?utf-8?B?ZVk4UFlDMWNhb1NsWlZtRThNclM4aFlDVXdvZmlYQ241NEk1bWV0K0xOYm9w?=
 =?utf-8?B?bGlOWXh1VHdaaWlwMEs0Y1NldlpLUHhNUy83VURYZ3dPdWQ4dEx3RzBaUGxD?=
 =?utf-8?B?bGs5K01qTW9ubHM0OHIxR2JUVE0wbnpmN0dEWXJobE1LRE92S3dLbThtS0M3?=
 =?utf-8?B?NmFRRGtKeEMyaWNGZVJLeHhLQmJIZzdCNTZMOVBjbTZyNGRFMDEzZmI1UFNk?=
 =?utf-8?B?aHRFWXlqL05RUkdYVDBMYzRITEV0bG9aNlRKMWFoVnEyRXhvWXpBUm9GM1VZ?=
 =?utf-8?B?Qkt1RVk3enRiV1pCUmoyR2ZkS0VrOW9yeWFuejRGQytuakd2ZFl4bXFwL1px?=
 =?utf-8?B?VHNuMnhCUVBzN3JmRWx6UmpjZ2NMeGNwcDNiZUNGam52RTgvY3JrOE5wSml3?=
 =?utf-8?B?anB2elFKdEpVeHJobUt3TnlaY3ZaOWFhUGJWdExNQm1jYXlnOEVaUUtxRHhE?=
 =?utf-8?B?dmdmWUJTMkkwMCtxaUIwcUJLekh5TC9HbVNpNUlWSDBMMjZ5UG9YdU43amZU?=
 =?utf-8?B?a3FraXdHd1l4cTlwNXU0WTVGeTUwTHJ5ejZWem1aeU15bi9HNzhqcHdMOW1x?=
 =?utf-8?B?dWNCUXdMOVUvMGJJK1VMVVg4L2xTK3FqdHVMbHMzVldLYVlCY004OUVvTDk5?=
 =?utf-8?B?YW44Y2hXdGlZOE44MjVjcFVKc3dsd2ZKSEl5dCtaOXVSNDBIS05Ia3Q3VUt3?=
 =?utf-8?B?Z3ZsbWZoVldqN2pMMSs3eWxPWGwzYW5hekFrUXQ3THBCVjR1MStmOHd3UXc5?=
 =?utf-8?B?OXVRMDFHMzRVeWl2OHhXNENMenlvUTRaR0hUVDBtTDIraTI3L3NUb1FOZFlX?=
 =?utf-8?B?YkNrM2toQVBwZWlKenQ3UGRac2M5OHh1WHhDVmg1bks1K0hkTzJ3TUVVbSt2?=
 =?utf-8?B?bitISzRSSUcyNTUrdkZCUHJ5WVh0VHFOTkxaeUxXTEhtdDYwWUF2YTZ3M245?=
 =?utf-8?B?MkFETDFQN0FkRVQ3Q3p2ZmtiaVVkTWl0YkZrY08zWDhCait4Zm53RUMzemlr?=
 =?utf-8?B?QXhYOXB0T3hQRUEvbno5emlFSVhPNFB6Q0J1aklpYmxuQ05YZEx1UXFYMDlZ?=
 =?utf-8?B?T2Q1ZStKcHV5UlVpWE9nUVJOZllrUUQzRFlaSWVXc3dka3RHVGYwWFVqV0pR?=
 =?utf-8?B?TzVQTGxKTUVTRW81L29kcy9BTzFwK1RXUlhRNTB6NnBxVk1PWkJxZys2MGk0?=
 =?utf-8?B?YmsyWWVadEdnTTZRanVuQlpjYVJuNzZ2eEVmQXRIV0hmYUd6VXFQSzBkbFV2?=
 =?utf-8?B?UXFhU21XYXl0VUx5TkxDaVBRVHd3N0RsRnROK2IzQWM3cVpzcmcwVUNyRUVE?=
 =?utf-8?B?LzBDNUxSL00vV2p2a1VyMlI4ZERBUDBOV3lBTGZHaUwrY3UvUU9hUWZId1U0?=
 =?utf-8?B?S0ViTUlFMko2Rkpla2xNcGEyWWZ1V0pRREU2S1Jwa2o4Z1lYUDJMSG9iQnZy?=
 =?utf-8?B?NTR6YUFKTFFqQTJyb09sYUs0d1BENUd5Y1FRTEd2dDlYeXMxc0h4QXg2KzIx?=
 =?utf-8?B?VWNFeGZMckxRdU5MZE5KOXlYcDVOZ2tLMC9zc0t2L01LNlE4SStiL3ZsajRZ?=
 =?utf-8?B?Y05tRTA2RDF6RUN3a1RhTnFYcHFKaStUUlE2YjZBQlRpYlQrOVY4ZjE1dkZC?=
 =?utf-8?B?UnNEZDFwSHNlNEpnQWN0VjlZTEdiL1llNmRhNU5zVU5iZ3NpdHVkMmpnUmta?=
 =?utf-8?B?c1g1RERhUm1GMEZmeVE0OU5YOS9QbHRZWFhjMkRJLzBFV2Jvblp3aFltM3Ro?=
 =?utf-8?B?ZWlYMzNHSlFWdmNwZjVjRTYxeXY2a253NEljdHMwUXhpM0VzSWk2VnRHTFhs?=
 =?utf-8?B?UnREMy9oSkI1cEQrL0ROVzFCbGhjMWwyanZrOXZKdUdyS0p4dnB4UHV6Rk1O?=
 =?utf-8?B?K0ZuV01xV2M1WStjMzVmUTRiSytKYmVndXVMZW02MGpGNDdDRFJZSmhKdE1u?=
 =?utf-8?B?UWRFRzRRMEw4dHY3N0lwZnhQN3pQRWdqaXB2MzA1enhOWHk5Z2RUYzA3VTlO?=
 =?utf-8?Q?LX5M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmQraTlkeUtiU08xRjFMTXhBV3NtNFBVZENRRzdUbXhlS2xRR0gyUzF4TUsx?=
 =?utf-8?B?QlJZa0NBOStEV05jN0RSYmdzMTFkUU5TeDVlOWdhUkxicEMwV1RKamlJOWl0?=
 =?utf-8?B?cTZ6RTJMZW0rY29OcE9jUGkyM3ZnZ0VpRVNlWDdlTk44UTNFSExjYkRvNmlT?=
 =?utf-8?B?WUtRcFJzL0lEcGZuMk5CMmo0cHdPb2l4QVhDK01QSERENEE4RnJPTmtUdkov?=
 =?utf-8?B?ZG0xRHRzTTZNaXlyK094YkxUci9TdWhNZ1UwT2ZuNFRtRFJ3TlcwTFV4WTlD?=
 =?utf-8?B?dkV0dDdRak1CNkVkZG45WkhxbVFSU1BPdmowZEltSlpCMVNvc0t5TEVHbEN0?=
 =?utf-8?B?SDJjWWhGT2pWLzBQV20zaXFTNG9qejZqQjdMNXBjcFhnd0JNSW9ua1ZaUXU3?=
 =?utf-8?B?ZjBTTnJCTGZDK0RBQVRlSUZ6ZDIwMm1KQW5JVUJaWkQ5YnlaU0NvUDRpOTNZ?=
 =?utf-8?B?cjJ4ZjBNSW9yNm56UWVSc3BrenpkdW5jSkxJVWZFT25EbVN5bk0xQlVkaVhW?=
 =?utf-8?B?bnd1emdiN2FhdUt2ZkpNL3V1eHA5c1hDdGNBQnFON0pGVVg2WnAxajZvSS9U?=
 =?utf-8?B?NVdCZU9jVk5uaVpEdXlLQ1JUVTljSUcxRUxsWUNSLzRxc2QyTHo2UHNUelZo?=
 =?utf-8?B?bGk3NVFPcEVxVTRYK3JrUTlscngyRTE4N01yRWQ3M1A4dGRzODE5bG5LQytS?=
 =?utf-8?B?OGtuMkJ6blZraC8vcTNGZHVDMG5DSXZVVVY4a1NGbTlxVDZ2V1hRRHo2QmFL?=
 =?utf-8?B?Qjh3ZGJDeDJwWnF1Q0p3UTlpcnJXZFpNend1bXVBaGhUalgxSm1BSHFrc1Bt?=
 =?utf-8?B?dU85d0k3eDlYL1kwZTFxWUVSS3JHdGRlTGdUa1dMTzl4U0xLUVprb0Y0b1VZ?=
 =?utf-8?B?cDhMSGwzU0J2blFTeGxCUE9VS0NlMHlSWmFwZHhFWHQ0bE5wb2lrZEMxZ0dT?=
 =?utf-8?B?UkpiRngwTTJWeGJoSTNkajAyc3Z4TFo4em4xSVlQVUdPV0Y0Sy9JZ0tKNkg1?=
 =?utf-8?B?bGdTdW5ueVM0Y2lUbVVZU2VtcWxTeGQvMENQTGFNTmhaeHVlNXZhY3poSHRn?=
 =?utf-8?B?eFBxMGxURXhYUFQwam8yaFdDUWlIdGUrZmRFQTVlNm56Wlg1dnMzVkRRSXpp?=
 =?utf-8?B?T1A3SDdsWC9ZZUxIOGdYdkJmWEFINFloQjdyVnVicjFOZlp5UXVUU1VEMk1j?=
 =?utf-8?B?aEVTWnhsNHd5QzBIbjN2WVBjbSsxUUZNYWhvSVA4SUJpTHQzZHdPTklrdmdt?=
 =?utf-8?B?NTZBZXpycmEzOFovajNiRlc1eGN4TGlRN0xtU2FNcmZyRDN0QW9lelg2cmhj?=
 =?utf-8?B?RVU0cjhya2dCeTVveDdKOGdMOVdMQm52YlV0SEJSZ2pMcGQzem5nWHViZ3FD?=
 =?utf-8?B?dEcxTC9YMUZoUVhWWWhsMm9XditUYzVlZWpxalBFKzUzaWNKaldxMnRSWVNl?=
 =?utf-8?B?UzEzbkFEa2FNVkhpbnBaNUZIZXpLeFMybEo0RTFaQjM0aHhxcmVCODQ5RVVW?=
 =?utf-8?B?RTBUNk1wU3kvUUx4aUtuYy9JVzBpWmF0akdNU2VqNTUxUnQ4MTdodHJqcG9w?=
 =?utf-8?B?RXZHM25iNmVTdUpLWG9VL3loTm5XNEljZTFGMVQyZXdDWmRkelpVSUJmVW5r?=
 =?utf-8?B?Y29Db0xHaEY1aGs3ZHNpQ0U1Ky9oWlpvVFJxUmZ5cVl6TmY1ZFpsajNzUWZl?=
 =?utf-8?B?Zmt6OWdHeU1jNExTdmNrd0xieGpPWEYwNGRjZ0Y0Y1lyYXZpTUhBemo1N0J0?=
 =?utf-8?B?TWxKUlFTZnVpMzNrWXVneUJZckVhMGtjZFVrMzlpaGE1aGRla0REQmJ5NUc1?=
 =?utf-8?B?WDVwVWxNNlRrZ2h2c050TUtEM3VPSHVmYlg3MkN0ZkdkbGpMc0xCdVRiTlEr?=
 =?utf-8?B?OGV6Vldubkt0UDFIUU5PQ3hjQlZXZFJWQUp0bWNBRW5TcXFvS1BtVTRqL1NG?=
 =?utf-8?B?VVJ2a3NlSE9YNXpQamdVeHVIcHArOFNZbGFCaWlkQVphNkFtYXN5WGM4UnJp?=
 =?utf-8?B?Q1hiWWtNWGs2ZmM2YTc2MDhxczZ2U05jL25JY2drTHh3eGpQMWhMWVFTZmkv?=
 =?utf-8?B?S29oZkk3ZTdONkY3MEdBSU5yVDVuaDFpQVNlYk9hRURLNWZtYjZmbHdsRXdv?=
 =?utf-8?B?Q1dxcHNWR0xLcHV1NnJmSnd3eWtoUVV3bmwyblIvTWdINzV4NW1WNXZZei9G?=
 =?utf-8?B?bllzVWVKQitkblNHaFM2MTV4alBrUHBVc3NHbHZTU2YwcXZqUGFiN1kramtC?=
 =?utf-8?B?Nmo2NTNIenpRUlRtWVNEQ3daaTR2cFFhQVA2MjhhVzZoQjJJN0hRdVJBUldQ?=
 =?utf-8?B?OFF1elJhV1c0MHdDcG5IRkovV05IcGhEZXF2STNIcjlvbjlyTG5Tb0ZCOVFv?=
 =?utf-8?Q?temuvFK4PRD0rj/I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9174fd-e5e9-451d-5ced-08de6a8211bc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 22:00:01.1149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1SV2Zx8JdUgn4ukQ9wGPoA3BJOQTwjoem3I6LvlvlrV7fwFuUPOVTxwSDodJI9xhFS6c6GLlxuV3PfCUVmg4m5biHJNevm38GCniGPabNaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NO_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,dwillia2-mobl4.notmuch:mid];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71016-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 89A2F1316D1
X-Rspamd-Action: no action

Chao Gao wrote:
> The TDX Module update protocol facilitates compatible runtime updates.
> 
> Document the compatibility criteria and indicators of various update
> failures, including violations of the compatibility criteria.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
> v4
>  - Drop "compat_capable" kernel ABI [Dan]
>  - Document Linux compatibility expectations and results of violating
>    them [Dan]
> ---
[..]
> +
> +		See tdxctl [1] documentation for how to detect compatible
> +		updates and whether the current platform components catch errors
> +		or let them leak and cause potential TD attestation failures.
> +		[1]: <TBD - tdxctl link>

Delete this paragraph. Do not carry dead documentation in the tree. You
might clarify in the changelog that until tooling arrives it is an
"update at your own risk" scenario in terms of encountering incompatible
updates.  Otherwise, no point in documenting tdxctl vaporware in the
tree.

