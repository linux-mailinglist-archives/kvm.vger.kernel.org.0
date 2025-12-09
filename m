Return-Path: <kvm+bounces-65546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5954ECAF21A
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 08:28:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD2A7307A9CE
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 07:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5D22868AB;
	Tue,  9 Dec 2025 07:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BMXpSmpR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C76C281376;
	Tue,  9 Dec 2025 07:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765265218; cv=fail; b=qP5OBydWpEqLdL6wbPCsbayYtBVEd2cqwyAUnzS+PrBJFViPD21Ah9Af7RRANxommCKIcQ6eBtGJ81rmrG8OQ3Y3y9uICSHy2Lq2WwfLI4QAI3u+YbFHEPb72YKODt6ajwQyPIhHJA/H09iX9LPRM5g4ALLO8OFw5lP1i76DKIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765265218; c=relaxed/simple;
	bh=pKTotpJG1Tt03GLwaQnuKIiigfLvn6km5bqXmAN4/yk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hLzjGCp6HRHF1lYdmKP8kLyvPakxuVab7ZiikzwC5BJIVP5IXDLWHF3fbhPT3k+eFx0KC4X56bxFhTGOKS03llCV13fxunE3p9knDwWe0Qc/6IX0A5S2dtuBixLupdsMcgrYAQUpePKKAEmAhteFMRZNmDxs/tiA5oADrBRItT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BMXpSmpR; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765265217; x=1796801217;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pKTotpJG1Tt03GLwaQnuKIiigfLvn6km5bqXmAN4/yk=;
  b=BMXpSmpRhohTlPMcKCCLwGj+3jwAJsOSGOK/wpYFQcKnkCzZcUsqhllI
   fcKuSAjNZfwsRnh0C9h4m7XAHYD8UylS0fHsV5v07cr/fHC5hrTF2wylS
   xfngpTcUNxVoZiPgGORnMYtPiMhRYOjcPOz4JIEJyeajo/SLZbHw0xWKD
   bnxqP5yOU0MzfEe8soy4KTjnVmKMmBd9mnNPA5E0BDr1rOcJS4TfmXT3o
   /2MeTg6u1rq2E843aoV6seYmsCTUn9y38yIYrCD9ErJP7JZag2NNycxNR
   94DtZKUubS2yZXa1PwsFFYBfVWs6EqVP4lEnFpza/CsKFQirzhqg7LTl9
   g==;
X-CSE-ConnectionGUID: YrVV3DcNSvatVWtIX0vJFg==
X-CSE-MsgGUID: rhkyaNbnRKGD9eW82z0ORQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="66940737"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="66940737"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:26:57 -0800
X-CSE-ConnectionGUID: lalNHf48Rmq3kxHIGDKwtw==
X-CSE-MsgGUID: z86lYZjDR/mA8UX/ZRK8sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="195231080"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 23:26:57 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:26:56 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 23:26:56 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 23:26:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KchYqJWnFS69xmsaRl101C+DmdtGaAOeBrKtD2UNJIm9gJoFbMce1onKwnhVHGAUpwc1MfgwrlLYBWjgsTnPu+lyfoozHwdVT4pdTZ7oFuQXaIdq3g95x63ZgkZ8w+ms7IiNsutX9K1oXYC8L4X282pNOeVtwBm3blhauFFY/c4Kz8xrRM/A7FtTJAGfttFbL+1NqhAcy+66fs4nSuTBYt/FA07qLbQP/7dwluVvAUQJhObTetlfEeMQqNUK9nmBntP89b//yV9bIMXoQa8V2DPGsscWiEs922/rFawvwTMwRS2n8AChR8zJQhJ1zxob4NPvKUO3XI9qq7HBLrAizg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGReELhBblT5vtESuXGtW8qM1xUe4wvIJjJc+5vkaas=;
 b=HN8bhsQqF6B2yOhfqcI6tC2vnzT7mvQWOAQ6svUxl4QaUITC3VDnD7WYMgA+UZJdvEJFjxVUXVNoF1UQobKRnO9CjQIGln/vGNbWs9h8uVWKlHpmzMHQaAAXnB64iY4EWucrqxlidn7nNTBpQWwibAzazSWIlMNvACxFhIlrhAXiC5w1a6YSB62a9qz8Hy0ZDLa7ESIei4jFuA5k02dAds3zv3DN9Cg/GOp/nI5uk4XdNbzJRud6GnZxfVO7dQUQLP6/EuHhLan8GlmFIerq9T5Foi95Sq85C8RRiSDpcI4sxXX3hT5y+JZIyG4AuPEcxDWyX/mE4iS9aHxUZH4AsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6442.namprd11.prod.outlook.com (2603:10b6:208:3a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 07:26:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 07:26:49 +0000
Date: Tue, 9 Dec 2025 15:26:37 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 4/7] x86/virt/tdx: Tag a pile of functions as __init,
 and globals as __ro_after_init
Message-ID: <aTfPLVvUgic2XoYN@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
 <20251206011054.494190-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-5-seanjc@google.com>
X-ClientProxiedBy: KU0P306CA0068.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e8b40b-a850-423a-d849-08de36f450c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?izBG4YQHCfxiAONNQSKZ/dM8t7S7oDY03ncvE+q6/305MKScwkrWnnKAr1tg?=
 =?us-ascii?Q?0ml/CRqyRbDVMsqN9W0tKfdz3UB4UNw1nJQKkOa9XNQ00SZQG7sbroc1KAoG?=
 =?us-ascii?Q?ZMBnCbQBVffY8DT7LyMPX2IxJj0dE6rlZdSKnTVb1tzg87R8TUYOI/KNGdTs?=
 =?us-ascii?Q?GWnvoeTwuTQQZtoQqciS2WDxAGSlGdIx8eT3BSQQYKmuRxfyg0J3CXDCLrg8?=
 =?us-ascii?Q?kh36lFzKfRbFVmihqtd/BC2ewIcZjqecB4BoMSKUXOFYMZTg9Ejc6rNCE4BC?=
 =?us-ascii?Q?MxSDRILClwkBv7ZziOx3zAdiAfAEKw6GvAyEUq5SsP1S9wLdEZFdOucBSKP7?=
 =?us-ascii?Q?LsqptF9FSWGHZrrBhC3g01AY/pCwyaPugI9GX3tOCd2HXzb27SKEKKqektlP?=
 =?us-ascii?Q?Y7pakNcSJ65NsvSwogVvAhS4HdOWHyMcMWo1OeLIMTfgK3SvVIlx45XApEJV?=
 =?us-ascii?Q?lqgs7stjsb7ZWXbat2vsutFULEUDf0btbRLeHJeexr++/K730AbAz7g7v2ur?=
 =?us-ascii?Q?F9mOmQYyVMRZZyxhKJgEWHvJNKO+VSJsb/WeFzJ5h38t8iNlcQdu2FzqvGCn?=
 =?us-ascii?Q?JKCaDNTKP3azks7kVQ707Nfxywj/7Gk4UPrEy+j49nRKJTnqYadnk44sk05k?=
 =?us-ascii?Q?U1UDvAgTWJF82z92NnBHZgiEsbdf84QV9ufCslxt4Nv0Uz7euEI6qYHOgAzq?=
 =?us-ascii?Q?HGQ4UKVTgkrZblcSWAisWVXABMO1MAw/fyWYrID2DM/sKgbuUk1gD4h4+T71?=
 =?us-ascii?Q?mYw5cDNYghFcVrr2ZBJhGpxLSzQ+L9KHeP5herZm78AzC+leOaTiM+sXAZ0l?=
 =?us-ascii?Q?m3V8FKXRNGSihuf996qV/55wuYzQyuEme/wsU2K3LUTiUO7zOlzALqvdVEtD?=
 =?us-ascii?Q?ThDWda9el/LWS71lI2n/Iu5zcnnzenHg9Y1+2xy7EgJaDLiEp2CrDWWKe16i?=
 =?us-ascii?Q?Y7BCRNj5JeCXTT8yNCy7AermLZdgTi+IaXNWKxysma/pj85Z1VBqJXGnzDX/?=
 =?us-ascii?Q?lnOOPKMdz83ztO+Mo635LYRT2fLPjVQCQhXoOEzU7MAw9GaQtcovwhayueDF?=
 =?us-ascii?Q?0rLwPegTqDxjd1/wu1fMOv8PiWaUT8U2PDSMdvxpk/B15MThmKO5TmK6Qq/t?=
 =?us-ascii?Q?TXaQyA1ptiZG4sWrcCtLSLkKnfQxJwE7ImI43S2SeT5lTfpKIgpKVxWUbkw1?=
 =?us-ascii?Q?bC7uCKb3MMQ0IF257vaK1X0n+REM/6LhWsWJxHlBoThYbQ0OWbuJPZJqWlIK?=
 =?us-ascii?Q?SPnlCzL7sCiw2XR/xPi/frk+oV749XgcvI5id4ZJo1PyD9P4b4JcO+KGmiEI?=
 =?us-ascii?Q?v3ET8KCOEIIJNoGwLFWVIyMyrmyCdK51Iek5l5ymY4p0JwD74Ah8+T7UAPfN?=
 =?us-ascii?Q?1e8y5rsUR9c3osQ3SKa3GNYtPi7Gg/5LGeB/vV2x86EUzsXQm2ovCHArLaL6?=
 =?us-ascii?Q?AG4Rm/+W1hIDDIRX69Ao+w9+UFDs/vlQ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xg82PYtXuayiCsIx4kLAWfSSbi1+uiHTqbPhQX3KAMbJJ4xKmlhBlo9gKyX8?=
 =?us-ascii?Q?xdbB1tEUReSJ0UnKVg7mAoaItiO6YNhSzZ7wAlbqWlRgjI61/FWWbwngv9Dv?=
 =?us-ascii?Q?teM7/xOao2G55IGBWJNOGrT0Sq+tZMI1Du/SiiT1osTU53FRtb90t1A+bjPZ?=
 =?us-ascii?Q?zkHnRPVhlZeAzX3yLE9JXQO/8tin2a1VaX9Qb3es53Dx87cEhfTIELAPFsBz?=
 =?us-ascii?Q?0VaVL4xXH/9lFYPOqberpkn98yxwEPUfuK3/bxSJt3wbgIUpQLb6U5LZYSlw?=
 =?us-ascii?Q?h2MjLpEryOimo6ayEk/3wQ42/jIvkPHDCSU9UlIo9j4XoYGNga8uPowQGZYW?=
 =?us-ascii?Q?CZrC1mIx2aOvYAFZIsd4WwrXmFzOdm4xI76wAcg6HDHS/atuflH8kNufz7Ym?=
 =?us-ascii?Q?+ipXwt2kmOWgQ7F4gd3Jtb5KNjyPIYhAiWtuKXBIAj2z3FRltT6VI+YErW0H?=
 =?us-ascii?Q?Z/UOt5n/62jmMDwiPXtX+/ZlIdON0tqljfUXCbzhxuVBmAD6sZS3Dq3v7QFL?=
 =?us-ascii?Q?igMbU1P4anRxUaDk07tG3JFoaXE0LLBKh9gxkJbZaHcZ+rXD/KVu3rVG1nst?=
 =?us-ascii?Q?91dKEOB70qPUDDs6CFKsGfNl21XqYve7NXJXcS7Qe0ZhdRjz6+i0BBkw7uBe?=
 =?us-ascii?Q?gtKOsSWHtuUeWCkFwSxGSTX4TunUUU9efDoaVzMZAZCdqTA8asPNcqp60jDK?=
 =?us-ascii?Q?tlZaMeW/8H9UlyVlwJdX//xRU+qmA58w4l8hdVCzXmOiuDkoEnTreKtjvIVo?=
 =?us-ascii?Q?69XVaY89lKhviDhQGVJlkxM6LQqgf+pIynpuYyKTagroTf92cRpFDE+NGw1u?=
 =?us-ascii?Q?ZlhekxcsYTQuDF7NYREgL0+luwagWDHA5VPwEAYVxiUky83QMXjTPZJtUGxb?=
 =?us-ascii?Q?SWL4SSqPhhW9XUitOy+BvRqLXBkesLYbqtBH+EJU7aqOrgxV4zABzm/vguyb?=
 =?us-ascii?Q?ykygAga2H5XAYMHV18FmFhLHBSfX3goLOKfJxl1Uiq0gdN18VPMJF7mTZf+a?=
 =?us-ascii?Q?OzHfy4aaAwUtxa1Thjpnd3kg92sgFDlt1d8Vqhbmt9Vk4m48J2SXvuftSJYE?=
 =?us-ascii?Q?TftqHCQuYWLHGJJzCo1c731lc07ZJDS5bF2ztcrpgMydRXMhWMFb6qYsbeZn?=
 =?us-ascii?Q?JyFnrx+gXgf66cx5VKl8JJd4vWoEgyywtgkfM/ffY0pDR7XD969wtOuDaMfU?=
 =?us-ascii?Q?VGpnT4aqhg7XZ8xcH5O/7RikJn3yF8lR1EA7ZIIskeQNKl+SgNAQHKglkUdH?=
 =?us-ascii?Q?WDWq/P9SzxCsRmUuRV1BtOvoWgWThxh92Dr9IqEK4LnlGSrN8JypqBH2JtV/?=
 =?us-ascii?Q?kqS4HUb8/SfEZA3YDi/6Vczp4Vgp32rWH81lyvHZJQs7jAJrt5dEUeBe4/eS?=
 =?us-ascii?Q?xPVy4/z7akmqrKGVpQqybxY8KZgCAr4M8AJBydaz84w/mtX0LyuXbNym2JYx?=
 =?us-ascii?Q?IFynRNOlO/0d1Z9NsL+LZp8IlvxWvOa89vJVMIH6wYbo+NIpCLAiydJjNpXe?=
 =?us-ascii?Q?/CRqJTuDECBIh6cXa67X4v7mK+2kcost/UjTAeb1kcEuxrAVRXANAAZ4T85T?=
 =?us-ascii?Q?XlSCUcWZN7uLgSdnaDtjT+G9LrdgJfmgY57euFyv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e8b40b-a850-423a-d849-08de36f450c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 07:26:48.9151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrOee8/AqLr6tbaWpDxLkthAkxBM06BYWAASRfT+6OhBScjuAaoyhv3NBucM3UbiRLBg3RoUzzRSBBJMLS8mjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6442
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:51PM -0800, Sean Christopherson wrote:
>Now that TDX-Module initialization is done during subsys init, tag all
>related functions as __init, and relevant data as __ro_after_init.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

Two nits:

1. do_global_key_config() and config_global_keyid() can be tagged as __init.
2. Double space after the __init tag of free_pamt()

>-static void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
>+static __init  void free_pamt(unsigned long pamt_base, unsigned long pamt_size)

	       ^^

> {
> 	free_contig_range(pamt_base >> PAGE_SHIFT, pamt_size >> PAGE_SHIFT);
> }
> 

