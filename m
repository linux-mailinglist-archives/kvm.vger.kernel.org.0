Return-Path: <kvm+bounces-55585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C71EB333AC
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 03:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F78C7AA5CA
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 01:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 113AE221DB0;
	Mon, 25 Aug 2025 01:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bAy63Diu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80251917E3;
	Mon, 25 Aug 2025 01:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756086391; cv=fail; b=fP/sml2h4od7mgbf9PAibwQtUUNdSM9r8l+ttffkYgCCHIb0u1i9Vnu1Eg1s9pRSS5EG23204bHdCHk9mi2cOiASg4Ixh1WqUNOsFfAw7WjIyLCsut/ZW4M8ONqZfT5YAM7eAR+/PdTFOok1I7UPAMVCo+onujHR3J7PXQNFXcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756086391; c=relaxed/simple;
	bh=ugvH/EvcXk7z3EtNpE2xwBntJdmhukRBT6KyHaT6I/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sOh5NWbUBoZZ/7j+6/UwagGVyvrqXbirnJdrZHBBAMIgl7m4e5O86R1VKFBAdBB+G11Cq7kbtxeS4wkZmFFw7w7tRX0NGWxgXhrsp/YFWohUJ914ts1v1sOUfDXiqPuIwOyB3pF1j3X7BE953waWZqmKo7M8XgBGKSntQoioOoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bAy63Diu; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756086389; x=1787622389;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ugvH/EvcXk7z3EtNpE2xwBntJdmhukRBT6KyHaT6I/c=;
  b=bAy63Diu+BZVC6/haj+oXUjePtV9OW/GXo2lKrdv4KqJsAaHwbKcomuy
   S3nBWcEveBuyjrKdQzVWyaDYd4FCutDy7lAn2eyN9aapTqV5Sra7SqnNT
   pR2HLbe8K1jVXu3+imlxjPqglJ8npBvorS9PfUcrpCFfUWYJ+7akQl/Ko
   v9og39qdM2QgY+37WsH5ioGzoyV4vRpqOiQXAQjsDHCL6sErgPgvvaOP8
   QsZmlMVyhNCtwKp1pk+7/6shegGUSMRm1E6ooG6TmFmgC4Ruw1kqkbdcc
   x+NFQDJvGab+aRVDhvdgzpW+mfzOUdJ/FmYmXMYIe0GbVyRzQq1HrlOBf
   Q==;
X-CSE-ConnectionGUID: gil8cC2NRQyt7URWjMIl/g==
X-CSE-MsgGUID: rbPjxHLHQOiQq7fOCy2ehA==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="58437731"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58437731"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:46:28 -0700
X-CSE-ConnectionGUID: ODsollwLRjS/ImBnW6yIEg==
X-CSE-MsgGUID: deNXNgZWToaK+e8d0l9ymA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169993770"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:46:28 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:46:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 18:46:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.51)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:46:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VA7iIqDrDLGcr7DGqAVlFQhXGp5mj/OhUDbu1b2fn87xL77avh+4MJgBvbLRYtKVaO2bNVYKI7FdBssCpLM/5mZBZYYfTBkBqERxnl/5xZ5sJ1LfExk2OQzC0DPm4XZf8rxdecdkI98eNnLSCPH+Krk7/xhL77hOoZ/R/7j+iqweMdSE25kOhVlSxrw9ivgzdWfk1YD53j/2hqafZgyWYX3DnAie4ZLvsPiNSB4f+qHCXTeK1SgLAFoshw25OWWDVrSNqAHFYcxVbCwN74nK1HXBNPpkKWDufigERD/NEfnxWleLclX8dgNGYO8j6B4XBNzKShL2cUd4SfT6te2eOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVniUP7NSQgfSL/nh7SveVTRw6TSMwrzFXjbqopv/wg=;
 b=u8XWqRJ+y83/Pe70bjXqmCUON3zvIH0W7PokjzesLHJ7h6Fh0QOog+sm6ezpjeRJw8XQz0m0AvR3fq/OecAxzVkxcBbSxFXC9aVeWheAET0mXYoKlWcZQ3YhL6hEEB9by9fBjlAK2utU2E073NX1YxxP/y3jyp8KD34lAhzJ9gwkpYqLQfB7W6vClR7cS+Buf+7DxYK3rbcFHmWIrz2QJfZ+/1+atNg5XCy9X55zYPtYtJa2PicAKpKYjo8UN0jKBM+ZIUHA8NtJWi9jMdx6/JlmAtA0LbITQq1qAqqh4pxUKpz+Gk2MAqfnYnQfaTMwW6tPRx3owsW05plzcGoJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4847.namprd11.prod.outlook.com (2603:10b6:a03:2d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 01:46:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 01:46:24 +0000
Date: Mon, 25 Aug 2025 09:46:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: John Allen <john.allen@amd.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 4/5] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
Message-ID: <aKvAZeY+Q8r02u0Q@intel.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-5-john.allen@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250806204510.59083-5-john.allen@amd.com>
X-ClientProxiedBy: SG2PR01CA0196.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4847:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a8cd6a-b73b-4829-2ba1-08dde3793319
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XPW4Po0mtF8UoHoeKYM7y8+bgSIzDoYh878QoV6ZegUqayd+qBwnF3Kudtlg?=
 =?us-ascii?Q?BgObrKj1IhIGJ/AQ5Hhj0RVZYuesq4jiNMjoTz7XdCbHSC/FFEbHV9Ec3b/m?=
 =?us-ascii?Q?UTDoRnjtpJE9buimHfOuHcIOWRM5bStG6JWmXsknLaw6jbvXStLjzt3K/lot?=
 =?us-ascii?Q?TwxS/CmyexPutKccpXorfum/RfnCIC5rJk2wX/t8CinxH/qe5S1JiXq/suKO?=
 =?us-ascii?Q?DyZoAdcGLwW+uxeq7N0sLpD7wFstlmusP4u3xHG5ctkcWhgLj73GbJ8LV/xj?=
 =?us-ascii?Q?7qdbaDW61hm+GXOkvWDq2L7VTiANetARBgi8GvD2U5+YVJRKt+D5a0xYrDsO?=
 =?us-ascii?Q?OTZgWkXI+zJxuNvR/SRamBtd04KD373/mCLyVVUJf1drGvNWjdEQm+PQMInP?=
 =?us-ascii?Q?z1yzqOEqd89LPADarJemeyxl/bveaUg6aWsncJNjWVIy3Fd+9xeU1aOnymzO?=
 =?us-ascii?Q?cH2Ya3BpywshgSQWXJGkjslg21KwItJmwV8HZjzFWtle/RADOlSOcJWOXZhf?=
 =?us-ascii?Q?lugLUKiI1izV1aSPAmJAk666WyOA5sc/jezX9T7GTfABR1xrv9pJqgK7E0l+?=
 =?us-ascii?Q?8Vw1d7awKJ+yVeBttsmsN9WsyRPUYmhwJX2ZEH7AwzEHt7kYowCvCA2v4k/5?=
 =?us-ascii?Q?OX/mtOe3uuRrJpBGFk+pfuOeMI1+cjiRZ81ShXFL9/IS9clsK8uiseAIZGq3?=
 =?us-ascii?Q?Aeaf4LeGCJauEJr81yGAKsi7BkfdX5lxV2XlTx2Q5ENZp648G9pvxBgknI5K?=
 =?us-ascii?Q?lx860jBDrm7AM8r49RiFUd1N+3h9x45tfcdu1TTRAQQtDZ3Th5bazns5V2QO?=
 =?us-ascii?Q?arlHJaRCb8R6ypUVwBSlw1t6sXOr69XzwFc2vCVdYW+MpxMh5k5Cx1sOmwMK?=
 =?us-ascii?Q?OsItS/EJcBnAwU5T8MPiAMl79xjC2RZ3fIoMkY5tXHZsVgwMX6KjqmE3Dvx0?=
 =?us-ascii?Q?M3pgy124LQ3GPfMlUbtxwVbnYOJ2Zd7SfazYUcGf8avzaeSYk6fBdmRUwi4y?=
 =?us-ascii?Q?phe6jyfys7dCNFd/xnGr6hENwA+mw0xjfhI5aqU+UBZ0TuQ1CypEyhmB1Ymv?=
 =?us-ascii?Q?tLbrGbfmIny38Fhbvoe1hkmSwkHbhFXRtFVX3GfI2u4IIAhvy0jV0gFTrfG/?=
 =?us-ascii?Q?UDh/sxNjFXwgoimIOPOSm3g16FEp8yk1GZfx8PSNGFdNwx+1WUj6+oT9TsvR?=
 =?us-ascii?Q?sCPsNFB7GKW/cWfGdtPqzWdNCPCT4RVwQAU3UQmfQF3XrpWBk5kL2Oux1uPh?=
 =?us-ascii?Q?s6lQ1k92ciGun9dY+OOeV/i5HbxVBS+NrOVyg/Z4YiORbZhWJPrpOSiIJqv9?=
 =?us-ascii?Q?K5ALb1SrzJKHqgLuJpOIuCl1VxmCPYBwSXvZnpLzODxRUMDvk9dCJ+V0UNgQ?=
 =?us-ascii?Q?dkWiC+05EeomGGNaTJonZiZQAJIu4dIdgJKFhwwUOOS6Xzr5cQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ylV45J82AexOkPEHxM7Ww8iFhdB7IjvnHjgi8iVAlsMfRT6C7lcRG7O66Q1O?=
 =?us-ascii?Q?KW0yqo3lJhyO/rebDeOBi5o5lqwCQRbXZBvGbPmc2Ob18f+LJb2V58LS/ddy?=
 =?us-ascii?Q?ImtVi7bHgQGhp9VF2M/ScbSn6+CJvU6dHMFLoXNFtm/X2vKKEq4jkDHxo3/j?=
 =?us-ascii?Q?FZyFMZ/Zz9gBM4zW1/n0gJSpBVedH9a6PRDpynLUApCDpJ4eGKD/mj0sxQrr?=
 =?us-ascii?Q?7UZR0qLE+eXu0olzPcGmrJjrl039QvbL08EU4qQ+S55IrXklMy4BrXI+PM7G?=
 =?us-ascii?Q?Wi1c5ykInfnFCGkF646v57FxjvrZIpZltGvJF6k2VnD/AeH22/V0Fq5jIRqn?=
 =?us-ascii?Q?1wZ10fIJOrI1aA2pL/nO+mTXGRhoXwRuIXFes7WJk2wdw3HT3Ay0k7pW3Sqk?=
 =?us-ascii?Q?JaQWuSPUo6rBKLopiG8k4UxjpLPwsg9s/uhX9sDEbIElT8C0S74OtRQEjUIK?=
 =?us-ascii?Q?8061e6TWZ35ua7TyDfKCu6N4ts/cBWHR6N1FmKWL1mj8okbxjQGdAYIhz/pC?=
 =?us-ascii?Q?/24neq/R6sjlPyXH6KWnFZKsWu6PagLBpUt0j5GYaPfn0DkJ47k4nud33sqE?=
 =?us-ascii?Q?Z1UmR16UjrI9yc+uaUIckf19Snjzs3xFIFJZDK+iIFPEtrK+fivldTicFmn6?=
 =?us-ascii?Q?ZF7RrXFvwJZcC4M1oFIZdsiOfytPJybKr1RicNj1lxtHoV5ggUx95Qjfu4Rs?=
 =?us-ascii?Q?UUd196qNUAl74iGZoT1KRruiOTZAGcRPH2WAw6xZgJL2+yLwlnXXXCtqi82a?=
 =?us-ascii?Q?OFnOoJtRZgbQ3ETEIwu3uj8GiHwUv5wEcYxIHB9lkr8Br2MNY2o0jU3je59Z?=
 =?us-ascii?Q?CSPydWLO0I/OQQwiZb8vP3UHF1l+eGRbKAk2nWw/QM8mapIQoW4v5pAluBww?=
 =?us-ascii?Q?gD9OafhP4KtOk8QnQ3L+8oxJi4sdhFYny05gJQcfiaN8bXPnDdzeaXv3scxH?=
 =?us-ascii?Q?rwpRsgtCcAOx8bXS4cgzrTBmb19mCJwI0zPGp+ypE9K+W2D7ItncH37VygmZ?=
 =?us-ascii?Q?Z8Scag2xG1i3y84HjZ4iupS320dEF4/FGiaVU9RHl0fFhioWRQkWso+xnu6g?=
 =?us-ascii?Q?2zGgG+edflARSPKKXvYNmyctNVj7PecSZwfUK6NQO9lI5eSZwimLIosGmdvu?=
 =?us-ascii?Q?fGGJE1ztIxeXCbRt12JSXdY1KMYbPPmBOovlshZKlSBIiNtETkZGgI42wMLb?=
 =?us-ascii?Q?1opLhN3Q9PYc1cVy0/K9nMfzYEmweK9JXA6zkzJoZ8inlRnqUKEzJAH1nDB8?=
 =?us-ascii?Q?N6LzHZNXby0iBbw/oB+ZjYTIvsFhDOFBx9s/QT26oZbs3W/I+hodAVcbrPQR?=
 =?us-ascii?Q?roOdJesSo/FsTgjnU9U7nrkMbqudPSRWWqsPouVXfhi1UecJJUwpTLak06b5?=
 =?us-ascii?Q?vZHO557OcbuGOdQFnyQNDE+0Vun4bfVgbczLomkjunSGSVNc6t+XmUNzVCCt?=
 =?us-ascii?Q?EKrYdT/Ub1mdlyDj4jaBHJ2FxhCMAqSJGzgwhuT5WEpB/9fFBIXQasU+TIu7?=
 =?us-ascii?Q?gdbPJchA6QtJFp+hpTGzM2OSKQ5m7WWisQnQqPaeIjOXgKkc6sjggJ6Rg+be?=
 =?us-ascii?Q?npyqtTw3TBOu/PcYLtmoW97a6GF5NB7UTTkEepKR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a8cd6a-b73b-4829-2ba1-08dde3793319
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 01:46:24.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2KCNmf2iH6iBb5HC1ANgUPzoHdk7wVUKTTgLIGVTyTS+wD9+qwCFmH/2MFYHPHJmjLnELCWUwNJtXxjdecN3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4847
X-OriginatorOrg: intel.com

On Wed, Aug 06, 2025 at 08:45:09PM +0000, John Allen wrote:
>When a guest issues a cpuid instruction for Fn0000000D_x0B
>(CetUserOffset), KVM will intercept and need to access the guest
>MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
>included in the GHCB to be visible to the hypervisor.
>
>Signed-off-by: John Allen <john.allen@amd.com>
>---
>v2:
>  - Omit passing through XSS as this has already been properly
>    implemented in a26b7cd22546 ("KVM: SEV: Do not intercept
>    accesses to MSR_IA32_XSS for SEV-ES guests")
>v3:
>  - Move guest kernel GHCB_ACCESSORS definition to new series.
>---
> arch/x86/kvm/svm/sev.c | 9 +++++++--
> arch/x86/kvm/svm/svm.h | 1 +
> 2 files changed, 8 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>index 3f20f6eb1ef6..2905a62e7bf2 100644
>--- a/arch/x86/kvm/svm/sev.c
>+++ b/arch/x86/kvm/svm/sev.c
>@@ -3239,8 +3239,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> 
> 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
> 
>-	if (kvm_ghcb_xcr0_is_valid(svm)) {
>-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
>+	if (kvm_ghcb_xcr0_is_valid(svm) || kvm_ghcb_xss_is_valid(svm)) {
>+		if (kvm_ghcb_xcr0_is_valid(svm))
>+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
>+
>+		if (kvm_ghcb_xss_is_valid(svm))
>+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
>+
> 		vcpu->arch.cpuid_dynamic_bits_dirty = true;

It seems a bit odd to me. How about:

	if (kvm_ghcb_xcr0_is_valid(svm)) {
		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
		vcpu->arch.cpuid_dynamic_bits_dirty = true;
	}

	if (kvm_ghcb_xss_is_valid(svm)) {
		vcpu->arch.xss = ghcb_get_xss(ghcb);
		vcpu->arch.cpuid_dynamic_bits_dirty = true;
	}

This looks better because it has less indentation and reduces the number
of "if" statements by one.

> 	}
> 
>diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>index dabd69d6fd15..b189647d8389 100644
>--- a/arch/x86/kvm/svm/svm.h
>+++ b/arch/x86/kvm/svm/svm.h
>@@ -925,5 +925,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
> DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
> DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
> DEFINE_KVM_GHCB_ACCESSORS(xcr0)
>+DEFINE_KVM_GHCB_ACCESSORS(xss)
> 
> #endif
>-- 
>2.34.1
>

