Return-Path: <kvm+bounces-57727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E38B5983E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 15:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F7EC1BC8633
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 13:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A782B31D75F;
	Tue, 16 Sep 2025 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/PWn06X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A402F7456;
	Tue, 16 Sep 2025 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758030812; cv=fail; b=g0m6iKX7Czd9ciOyXWkhJYUZrgto2TVdxMZgzeQ1x4KV96lp1dkzMC1BiXFlcSohjFP7s6GzaYuo1SHaKbnTQI+u7pl5fMOn3JIkNMxpEjrOWGKanqWiOvieGshH+5lIji1+myXEs5E+WBPk+CiqhlU6tO+2hblm+8YiYpfKPRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758030812; c=relaxed/simple;
	bh=KZpo4PaRe+SrIq2bhM5EqHWPA8yRVbqzTuZFVM0htlQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tkA8cAbFNQ2IryrIpyfkRJT1QbZ3b9SFeKLq4hrsstiVliSz3trkd6b90dGUG5zi7PAY5ZVBHTItM5o3KJFwb5+riOK89nU/Ks9ZMz2W1/59Ik0/JGGdPng15RZTo2uxVA3cGjOAogR91YRq7a91rvp4lhvyiwn9fLpm9D5yKds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/PWn06X; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758030811; x=1789566811;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KZpo4PaRe+SrIq2bhM5EqHWPA8yRVbqzTuZFVM0htlQ=;
  b=M/PWn06XtqwNZrrOuHOUhgQi1no+RCnjFsJnLMQT5e9Ryt0cG7YSyYtD
   4nZCW5b+ZDQ0FOq+7CpYAe4M9U2IgfuTlDVEKw9ksIKffp3kPOhTZWpPb
   p3VU5M0dSmOpghnL215XbXM5XTfBVoB+DBuH1UodG6SwfrY15NaRdfKh3
   EkrUCs4qRgQT//wPW+8A0Ym/mArDPCEijGPighAUn4zmCLChZru6KWnep
   9QAgDeJhA/ELIgOCu24Z6wTZBEt3BhOkU7WuwkxQeZf/hYr6q8h4Sf9Ln
   q7YhYIT1JjobGVDQ65vgONK5ZOr9apo4452qNVe7T3nHpT2+Bo0qeszAm
   Q==;
X-CSE-ConnectionGUID: mxAgy01cR7yWEGiCdvwa1w==
X-CSE-MsgGUID: CJe1mbf4Rj247yhLORlwYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71676396"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="71676396"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 06:53:30 -0700
X-CSE-ConnectionGUID: 0gfBTbbjS3O/IsvYjkYuvw==
X-CSE-MsgGUID: 617BHN/3Sui2Vllakx1a9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="175029649"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 06:53:30 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 06:53:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 06:53:29 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.54) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 06:53:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VvN3jlxV3uXKYjMIaetCmCuXquzEsKBYCguiiBMek8/6nmmf32+0u2qvtuKK7BKD0Was7cT0DqPjynpUhbnsDKIbAZvfC5PrxW5KjNdVqnlPJp1z1XdJtBp6DwKoh2+RMsMhvE+PCuvsxPaU+oTIVe5tMrT3TB7tRx6ijQcEhiS5hqQAVabvF4kgO/FMXSw3NNmSRY2Gnp1s852b9bJ1p7YwA8esC1iEFq1QENvELg5O9tvo3SuEDI4/lmSSdPGTlVVfOOz/1jRUH27zh2XKEj47n+3e2h6Kz88v1rAPMG6037oQ3r/Ov71XgFGCJ6tHc2LdlB8znnGPodCJbdyMiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DMJed+Id2QF7t3jZ4QdhMSGxiRm97CSyFaDustklaI=;
 b=kS94IkAi7wx9AkcBkcQV+5c0MofzIEgbe+ydBQwsnvOd205XH2fxwAlxRordTU0RHz02Wzv5OV0Oh9R7a07H7VXxYyjlgesXjugDn0Gb08F2T6pPAV+lTn1VWbO5n2uPBjrfVrjkE5r1mO4XFLoxe6MKyxDnCtblOkVUd10xWGKFl2OU2GzD+AxM/lnkvar3EUPQTdvaNqv2A2K3AqGd9OQgWsUEdNTbHzCl+K3saDgIwwG+UtV+9DQNetdZX2/6CLlT9muynoUvwYa0+BrPP8BGo17lZdaiFE2VJ30TOU8DAkqnqUW+Lw1aXH4cV6s/99bece1frxBynJxXtKFB4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB8117.namprd11.prod.outlook.com (2603:10b6:806:2f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 13:53:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 13:53:26 +0000
Date: Tue, 16 Sep 2025 21:53:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 00/41] KVM: x86: Mega-CET
Message-ID: <aMlry8TsRAshk8aF@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
X-ClientProxiedBy: SI2PR06CA0012.apcprd06.prod.outlook.com
 (2603:1096:4:186::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c1104a-3715-47cf-27cf-08ddf528689f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uVjZNMar1kKUFAPrItJI9alWHNRJGdqmMLBMIcM+DOi7M8QegAwfscdk6ye2?=
 =?us-ascii?Q?8i+BQSycI1m922dB+5vc2RZoCFkIyohllvG+K46QDgBjenUNztb1V1ZFJ7PT?=
 =?us-ascii?Q?gmriBs7B4ud6EtTBnx5FxET3JGhiV9D7NxmWD3VEbgLrz7BRYccsbW0gQ8A9?=
 =?us-ascii?Q?WgBbwaYqiAJM66j901DGIoeDuqjNqCNBv//Pu7iB4OsPYFuBxw3ueMkxEMjL?=
 =?us-ascii?Q?/sSpGpT4JStUPkUKihV7eXdh3+fk12ktfzXWvi3yPGQKxOsE427JTyCbGcXH?=
 =?us-ascii?Q?sM02zWtW2fu+0JxVo3C7ml+Q5UpUTLfdgO66//AtfyREtr+emgXPOWlmcgy7?=
 =?us-ascii?Q?OYBbJFRNGIvuvjqbFU7DQuGluFJ9CCkVsDoTo7vUhUtK0BmxLa8NwJWxvp3h?=
 =?us-ascii?Q?afTVQFu9KjDnfcsAtrCKM5AT1jnXzRzmW+VtYNDWvE4yj6BhN4vlcw9+bjvB?=
 =?us-ascii?Q?9dn3H9iYn8WtqiNDagMctRbjTHu5cDtqwdtSikXhEd3mgJbdH0m8/OSWSvzV?=
 =?us-ascii?Q?g7gkF5QFdDpZGX4KTbYLlZF7fIyMa66MHwzpaixQyQ9OhOEar136IMgsSq0G?=
 =?us-ascii?Q?zNMEzelODQVBZdZ8PGT+lYCYN+Z5nYe5M8n+kTx5muI/cK+ezmaUBZjaflSg?=
 =?us-ascii?Q?qeEhsWeM5eWQQUWx4VoCOtHlbs//w9LpQiqyWMBcEBQiNdACNT+BmJCspMzZ?=
 =?us-ascii?Q?qfOsBNHZR8gYrwk2Mcah8avAG4hvOshSs9VmwItq04bUZM42AC+vCN/8g1h3?=
 =?us-ascii?Q?yWHXFQeOomYi8TKV5G927abqQPHNY9UnmhTJjn3d3nzLy/JArmgyTAKGxM+5?=
 =?us-ascii?Q?0a0fyPqJd/faK/s2yBiZVvFb92FnNuIsS6YuHAwd0O7EN+qmejZajE1WI6nN?=
 =?us-ascii?Q?7H5+KQpyeCleGVtg1t8fgqmQeU5Z3aQrHazWyHNfHEulkDrjSCYC0GAhYWrA?=
 =?us-ascii?Q?FsxeFu2fQtDi5d7H89Z3zl3zwhGoJf0mtcCGdfJhkKrPIsZwzHpb7bnKQqET?=
 =?us-ascii?Q?ur1lp7mehA+JSTMG91Wo40lG7y+zQO89HvyBe1hmvW5X4MhefOdpmNuF+sLV?=
 =?us-ascii?Q?l2XmFllOyTRVqMoLsWa+cXcPKGrrWxVquPdkDTfx0275AcCGTEl8bkRElwaR?=
 =?us-ascii?Q?qoIP6vUhl3NaJlzKSHOeoFClrOdX/LjOnMvLIa1YGoGchM0C5mOgbqOIfqPS?=
 =?us-ascii?Q?qTOb7cyQNhknO2hg3uuinbEXsQ6tz0aviH43bLTZilFCVzH5rgT72irHRU0F?=
 =?us-ascii?Q?xDCKGsjDYivKQXtd4M0JBDAuzHu7SJLNUHSKPF+kc5I2Hbzox+GZtoPQzM/j?=
 =?us-ascii?Q?tLKRn2qcuCEb2DdTxwU9FI2JMH9Zn4jd4iw0HJF8+aDKnGMB/n5sOV2Fbj2U?=
 =?us-ascii?Q?E3m0PPURy3xAGB3/uTiZgqjcixzH?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JzYeYtNQB0rs3pykIj00fqHo+cXyDg7g21VIiNqV/lPB90IBwsulqr71a8C?=
 =?us-ascii?Q?gHmChHxJP8hFYEH0n2SgNIi6eo7V8CqhIjZp14uj/UXFMPPmCg/p41a3dt2f?=
 =?us-ascii?Q?D89cK7akjdF7DVM3p8nI9l+geE60R6bYWnM+MJtfQGHJvmZdD5Y/J0r0dP7N?=
 =?us-ascii?Q?G8GYo5XwTTy1hp0IKQJAMocmuNFQHg1TW4YQAnVDpdxoDySpTNAwWyGyAqjb?=
 =?us-ascii?Q?eDVhp37t0tJgwbzWxlA3xVlWbr4I0E+FXlRlchBriWN+1aTK2bIx++sLFisH?=
 =?us-ascii?Q?JdGJ1UKvzKPWSBgTo3l5m47vKntEMelkmDUBOMX9/GBf0jaSJGMQnfFu6InI?=
 =?us-ascii?Q?PIWPZUFg82PLLGLxpZgrfn/7fjsu6xltr8g5xSRutf1F0kwlUM3z8gYQCE5i?=
 =?us-ascii?Q?j8vkuSXdi6n8sqH+zxNOYkiZj7ZIk9jpadT+L3oC/McgbZn2Bz2SYftUYZMT?=
 =?us-ascii?Q?GmvAH+NCtpihCgZldUDQW5BJ6daR6aeArmJxVKykwHvf1xk80LvRJl+eOzRt?=
 =?us-ascii?Q?BFQVC47HTuT3qhlWZ6TPVV88ODVCv8yHyo/gLp8UqjglYFNX+EnBCVL9tiod?=
 =?us-ascii?Q?SpNduHkIYpOTU2wAN9Cm5EIznssd5r8J8WdtGj3med5J6sFiPWIQlolUcvcS?=
 =?us-ascii?Q?y3vxIV1OvRlKIZ16v9t4i3OYOkeduTyKOGdTdROIyodMMMHidCjngi0nIWeb?=
 =?us-ascii?Q?4vm9nyyh9ff3q/74QBwLGTYhTZ/uunbyjvj0IEyIupSr9aLeg6kT4TSgA7sR?=
 =?us-ascii?Q?L7AnvZ+J8EdyT8sQ2PljZ1wwFJZS0mRj+PRsh5IDmMgGx5QCEk+9bUpfzOFr?=
 =?us-ascii?Q?L6RpQywO0mlVyDj7+hSojcPX202Ow64DUdBqpRAiFUZ3eCTxzz4yxTkz+Jx6?=
 =?us-ascii?Q?W0OYVNPXXxWSMhIW/KeTlZYD5OvVTawov79m5eXR5n/o9e57tBbRM/WpgUNq?=
 =?us-ascii?Q?JwmAeYw4w3T5c2uwoagbbvqAfDLTVV2BwK54dvPsM7jkYO1/mDhy9Y+vG9Ly?=
 =?us-ascii?Q?x3DBATdKMHVMMwZ+DnUfFEKJyGhMUhhNmnYWnVmzqIFdhslP71T0NQp9XcaR?=
 =?us-ascii?Q?EeE9rb6mPAm+EJmrQVv+wweUoh0KVtoY30XOqNPKrNFCKWWbHktxRWl3Turz?=
 =?us-ascii?Q?tMZ4+vTvo7AtzY+rSNTycgxDzpdoNUNPKNzfXk6VFYJXk5rGca+CsOTEgSV7?=
 =?us-ascii?Q?LNPakHX3x51jnNT7+Hk1fkt27/KbPRZ8q1doe3Wx5vDSufk42Gx/sGBMGx7x?=
 =?us-ascii?Q?ZDv3VffbgPCP5cA7qDaA/9tfS2pO0LIXN3qnZMOW7CeLygYSoSLmv0vay142?=
 =?us-ascii?Q?dxjtiprpzYoLKLU9qV+tpes4ZMqglPFWxUPomOQdoEIXtzcnW/qUYgIWqR5e?=
 =?us-ascii?Q?wSaooBixybHk+hQlfMe4Ey8JoVrOjs1mM7BrAtJN2X9mWgoCAe+nNgUC+IRI?=
 =?us-ascii?Q?lOrk5Oj3IS7bkwnBK/eGvnrdiW3u7OV6bq44yFy/njYPwSTG43M58fl41dsC?=
 =?us-ascii?Q?aqGw3+qBVaHLZMiJ2CgA8GzSuRkB5XQPZeNuq4m8AjNVJBbuBsWIF5qfJ4/E?=
 =?us-ascii?Q?PvZtiBN34FkmRJSgcnqkOkAKc4ODo9sPjyHg/3uE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c1104a-3715-47cf-27cf-08ddf528689f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 13:53:26.2229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWo07jytyOZfgn2rB2fKgVrTScbqJeMoyt+whE4N9Y//PfPai2tPctsmx7/mIaO8b+BbXmF0jU6pWDfriKq6Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8117
X-OriginatorOrg: intel.com

On Fri, Sep 12, 2025 at 04:22:38PM -0700, Sean Christopherson wrote:
>This series is (hopefully) all of the in-flight CET virtualization patches
>in one big bundle.  Please holler if I missed a patch or three as this is what
>I am planning on applying for 6.18 (modulo fixups and whatnot), i.e. if there's
>something else that's needed to enable CET virtualization, now's the time...
>
>Patches 1-3 probably need the most attention, as they are new in v15 and I
>don't have a fully working SEV-ES setup (don't have the right guest firmware,
>ugh).  Though testing on everything would be much appreciated.
>

I tested this series on my EMR system using patched KUT [1][2][3], kselftest,
and glibc tests. No CET test failures or regressions were observed.

[1]: https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/
[2]: https://lore.kernel.org/kvm/20250915144936.113996-1-chao.gao@intel.com/
[3]: https://github.com/xinli-intel/kvm-unit-tests/commit/f1df81c3189a3328adb47c7dd6cd985830fe738f

