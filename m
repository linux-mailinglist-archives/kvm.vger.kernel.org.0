Return-Path: <kvm+bounces-58441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5DC5B9403F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAE3318A701D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBB027055F;
	Tue, 23 Sep 2025 02:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lEGefzqA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A19148850;
	Tue, 23 Sep 2025 02:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595089; cv=fail; b=bN9Dvnkcp1bSdysKvzWZcIHzYo1LSxQzYGsjfZCkKo9Mxxd07wVK+RQyD8qGYaczbkghGYs1LAokL3OPwJSnPdKJARyw5l4j4gl2lKgLbRbv12vjIepiJ035d965TaLUKzGFhU2hCj2LFNw5EhaFCclPgD/UzQ0Iowd2hM4svX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595089; c=relaxed/simple;
	bh=J9EcYoe0pWmRcEFH2MD88/PO+z0OOx9N/FRVjzOhNso=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DFTrS7wUncBLQRqdvQSObSO+lhtdxHr6J2MDn1aXzufzcFWtpp/+bg+e2yXzkLR56c/k2TRX6/izUi5glp3HMuzAnmJuiHvcM2qXPH+MrgDEQ60w/7yH6jdPCnpwM/w6AUr6JKbUVhdhUH8opXPpCGt6yg/PPAzGEUG9PAvTq80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lEGefzqA; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758595088; x=1790131088;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J9EcYoe0pWmRcEFH2MD88/PO+z0OOx9N/FRVjzOhNso=;
  b=lEGefzqArUHOOkqM/nlu2rUetTpRjOVGlTPQlfbCu8BfuNU7d1UkWLUc
   TQUZVMiqqxpvPWPcT013qk5lGsbblZ+e+z0ToPtpC+T5Zvzb5siqtA1Z9
   8bI/0IVXHvqs1esHqFeSaWqBEoJaA5/tcZJF0A9klRXXM5FV7TREjUy+/
   59QyAVFLWUAisdfO1cSA9WacKAbtJbMlc6qlimW/FJXvtdZ6uB3GbC8MY
   98dn5oweAAVkrwi1bI8VhviIuIXeYYJUTfhmQ/y3Dba6z8tEn3Ul+cnAS
   2s5cX/BordGSa8G/zRuwtPsTb4xQB61omda9bC7syVuJo/+8SXCETS0OS
   g==;
X-CSE-ConnectionGUID: o/qyHH0/Q+a2Q7h/vtLeaw==
X-CSE-MsgGUID: ATkGSRltSWuE7WpOisET9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="63496753"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="63496753"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:38:07 -0700
X-CSE-ConnectionGUID: bAIkJRmES5GlgzT6f9RLKA==
X-CSE-MsgGUID: WQuXaMbZQFKYKzvCv3b3bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="181025088"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:38:07 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 19:38:06 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 19:38:06 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.12) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 19:38:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQb+2Hu4cH4fPEvbB+Si6TcN/8xk4QGOLo6eTVASF4rE4fy0e+eLBSol5rKWIC0kgXY5F9dF/1rllGRYYCYnoSuQ82kr6IoOY8/n+5B3fBAWam3Y2DCdsQLpkRsh0tZL5ztkMXal4SSNLuWNRueHhcrgNqvSbhkn2mEGb6aYGXjLBMz//m3A/y7wUQBMjbBa2LqCT25xmJZoRZq56IS4fNwtFzDQklvgiH1yg8kJnL9oTLe45oHMy/EGEpevSksKgqxKZ6OemcWYs1cx5OUQzL+XijP+mHTVsfwj5qlFAgsfIn1scP2zDahUQqGtHbT+fLETdfQLTqlf0wUykEOLxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4yX5BVGH4ezk/6mT/zMtS1HOtNp4PEnVhbXx/7ypPw=;
 b=j+LeNoSGu1kQGIKIU9LdCmKjvHy+JQyjxVk25Tv30X4Mo0fnlFt7kP972r/Od6SSKvnebR9jeSTQcPprurUq0tq68/Z1IW5gkYeTk+svC141PWQTW3QHCEYa8xBlJppfa/jI24j1iK5mbUkb+43G0D+KsPs3uScqGG8Ta/tSkt0kebgE/Pnai6M/s6bg2bieu788CsCYu0oEFvoLkuu3NbDEPa5i93b66ek2pU7y4JCHysXZk4ug54DQfRncvtOp+yJ/smCne5jstMIpCgDg7tsnQ+l9xq7b9ZWQiUb9M8aAAGJr/HtZlBUO7e6xIvVmtVtUDzz8lRcnXSdoO7xeCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB7414.namprd11.prod.outlook.com (2603:10b6:806:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 02:38:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 02:38:01 +0000
Date: Tue, 23 Sep 2025 10:37:50 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 29/51] KVM: VMX: Configure nested capabilities after
 CPU capabilities
Message-ID: <aNIH/ozYmopOuCui@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-30-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-30-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b8c829-8d59-4d5f-1fab-08ddfa4a3703
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LkthGEV11YwpvzipkwK4jGChnNdCjQFphRPfzq1zKSTedJAGzOvDi7KlCgFB?=
 =?us-ascii?Q?ZyCKM/xpT79yMmQAUMzLEFaMWxht9hOvh860/Z1FZYY14ZdEgVJPQn6d18qV?=
 =?us-ascii?Q?KDSxoDOxMpEJM5K5hzWTEkx5w8Y96ZpH86wVxS+qNomh57Sz/+JRcZS0KJLz?=
 =?us-ascii?Q?394wyqvx1RFCQhz5+FA7dnGnJhtxbTWHamLXMi4dgcs+hOecGqJQAtSumgtz?=
 =?us-ascii?Q?KxKSf28jl0PGoOSj5Q77hKfKh4NcEsavahmEHgCa9D/ZhPad11OAjSQw1Ef3?=
 =?us-ascii?Q?ASfpjpIZlmuInCHn0K1yMHqhRkBFQMsjHIiuZeyHSVv8zUniwl+XF6xItcM7?=
 =?us-ascii?Q?PUcZH+DXd5Tw7ZO4lQEdNkHxQXSBqBv6NjfIBFaBIYsgkhqXmP9Q7HWA87qL?=
 =?us-ascii?Q?99H5IkZ8PleAychEl4bGUt+Q2LwzribY6wLtT4pk8hfDx0tgVShdMXl4jhF4?=
 =?us-ascii?Q?ZUQOaBMayaJEtlE7GsNCnUiLiwYqTltyP4wvzCmNAobGjKiJennPY32m6d9U?=
 =?us-ascii?Q?JQIkmAZICJ3ap75aST7Ha2T33hDy6CAdMjbl1UmjWzzpSfXypm8bvvNUcJee?=
 =?us-ascii?Q?pcTEs+b9PVS/D1W6uwIjhgGFUUsso6pzuqupiUNbcvD1XErYFAXULQ216mXR?=
 =?us-ascii?Q?ed8rk4cTJY6ktLYT2ugNSFVSsrRVPTXxrEUpW5rjUs0hfIkpcHrUtO+7dYzq?=
 =?us-ascii?Q?UGdVYRbUmEvH3YpjmtIu0Si7ffiYV75D/DR7QO/glV6R/Q1ur6f2OxfTxRt0?=
 =?us-ascii?Q?xrdWYh2zmL9udiJb7wo+NTfawgDGKc94eMWj/55l5BmTLR2xOMARPJwFSMup?=
 =?us-ascii?Q?XophK4uAhII5k1QbWyWGTjgor7rJyuw8QjAs8vjITcH3ugPIFZFN+wkEWAGz?=
 =?us-ascii?Q?WrrDMjTdnFlsf2FiBszImWypA8ZppnJmgnSKOEbfTRI/BKxckIkOqhbizlnC?=
 =?us-ascii?Q?XxkKkyF+FEuYxo0/C/8RdBtPLQwKcg/P+v3VMsWTFVtKLGMMXdDCxk90C7YR?=
 =?us-ascii?Q?aOns/uH/p/CHKdpGBkJraDN0btwgowgQp7mCYNKNoxykdv++1Dow0eMh88vb?=
 =?us-ascii?Q?bfIO25BkQw+WrY/kkeABwhaj6pBv83dBRj+mJpk/50GXavfX01yF2W0VVE5X?=
 =?us-ascii?Q?5WAd5GYuLa++yshkR8GW5qCRrzjhlPdWqmzQEm1c6/HtqYiyrDSf31eOL0Qo?=
 =?us-ascii?Q?2KKMMMgiRl/XOor6CFNf3yjaTCR5rvd9iMo8CK1IKMuzpzB1U0Kfqx7MqWDW?=
 =?us-ascii?Q?y7/ZS144N1bAahuqnGpnNqqkELQTs1jmepo5uEtBdFy4qKfDjUnW5eT5mHXk?=
 =?us-ascii?Q?XDCEJf2DWEt1XKtTEsA8jxc56K0EVGCKeCC49PZ0ZrimNxLp0+Ufk15OP9rk?=
 =?us-ascii?Q?OC1b/je3Imz83QqWdypA8Xm29yrZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1Kjh2w6kPGcA0flpkJSXfwBGVNIg5R1yadAZQWb+UzH4jW/oM3r+ymOaU+n?=
 =?us-ascii?Q?p79C+n9CGeo8Q2oNhqg7oZIhOY1E292qST00jUANLnlpce08PQJooRc2EfD1?=
 =?us-ascii?Q?odFrcyfB5Gf3LxZcD7xw+YYKdi/9Eyy9SC7rWqF/x0WptSe7E1ZsMiRN7sJ6?=
 =?us-ascii?Q?Ra7OxfRiFl//56Qo3rwy/T3KCgkC+XXIAqamEwu/R1RkBfQWyKPThCFmax6q?=
 =?us-ascii?Q?MTHWmJL5Piypyp5IaajPoWrsSoR57T4FUx63yAS9wE3eVsxZVAaVB0QDrlgv?=
 =?us-ascii?Q?0Zdgdj797wjqq2iueUswgRynoyEEdkpp+1I7QvzJRvyj7h6NJzsyqBf8vsw+?=
 =?us-ascii?Q?jjaM3B71nuxLLoTvhN0a3vpyVxIdCLlDGSzdh1WXdRbUvYAijPY8rd3Dp3Gf?=
 =?us-ascii?Q?aSe2CikcnkdWH5meiJT5FbPNegjfJq2dPlbAKn0blIvepsGJeLeIXNtw7eVa?=
 =?us-ascii?Q?OmQH3hbP6smFBFwdG2+W05Nw45RqW80JUw44HpuYBcYUhiwUBpWWKhLW4Jhk?=
 =?us-ascii?Q?1GKwaHCSWvEk1zS9snt0btcNBZxttwHivZlmGzeyIMItrHocX4jmF1+7E3bK?=
 =?us-ascii?Q?X1hSHlC6iXLcAyXjwBltzAxzWwpUDNXrgwd5K8Dp/aGyQsnXDsoJbuiFOD6j?=
 =?us-ascii?Q?hp3iIwJ7SWtXs4ffrTd+qCX29yphSaLlM66bJzZMTYdBBTBR5L0UnAUQwe5L?=
 =?us-ascii?Q?LO2lAshZigWT75Dwd/Fj0rEXfywxP1ngu5QB6Hq9+wRX6ZqXnKyagyBpOJoC?=
 =?us-ascii?Q?i32VA3zio3tMJvYEc2xyEtay9+Y+j0qiKYVeZZ/CP4LI5EKAvzRrMunX0LSm?=
 =?us-ascii?Q?7JOaS6s7rxcUhkKEV9OULQn0bNZbd+AC5WCttL+aoDpvcl6c6qz1e/mUoa6b?=
 =?us-ascii?Q?0sg1TTRN7vwLJUhqNdyI7PtlrfO4BRyYVcDcMjUpjp8v+XQGZN42gmaA4fJQ?=
 =?us-ascii?Q?EWhIKvxsMIz9KAvT66gITG+7zX9dzDZCnXLpAg8N7UFRCqA2xFbylGPqJrg9?=
 =?us-ascii?Q?IIvcpjm5Z5Eqbo7aQ3HpUyHWrQ6175pvc5x6sYhmzhvCxjRFU31BZ+YHUC2L?=
 =?us-ascii?Q?HnzsEFNqqc2T9wqOUE8DVv76p3pMPXH7DUKGIikOoSfkav2A2UD8MlvTPnXo?=
 =?us-ascii?Q?rtNGUGZcJ4Ag/olG0asBZ+p6lRWeEbIvZKNzNMCCB8TW9cpFWsLOTpuUJBb+?=
 =?us-ascii?Q?RjoJqJjaE3ZGHi/eOYqmJtumyQtH/0BLdo/0xsBmauIATYEpfymds+9DtA30?=
 =?us-ascii?Q?5c/tqq6GD+VIUmZNJ2RiurroUdn1z3bsYnCEb7FXDFYROLzMS0OqDQ7cO+D3?=
 =?us-ascii?Q?woHPLPRRCsU9vrip+aj11gZ9B8uMqPAr4NGarpasyE2rEyj5BCcAED9WjPNh?=
 =?us-ascii?Q?tBfNp4LfCXbtC+7sUiSgOwV+mTjZHp1xNfJjddpLBbXmgGNoPA0Vbjr7iB5Y?=
 =?us-ascii?Q?m+H6eDbws+7hjWbn+4iDpAvw1ByQ4+rW9ZD9gf2PdQnaWlzo1MjKfdQGHp24?=
 =?us-ascii?Q?oLX6bMRQA58627iObBLYXl/BFkn8Ob1HRkRD/VJ0DvzOy2a/KfBeRe39wfdy?=
 =?us-ascii?Q?J9gdJAl3Livz4oD8zWW27l4T95L3+uGumlrbAF62?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b8c829-8d59-4d5f-1fab-08ddfa4a3703
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 02:38:01.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUOQQCEv4xZbseYFCAJKMKDuW6A19soS9UDkIeB6dPv0sC33+GH/CseBsRVuiLnPmTRfP6tt7O0wRQ1TUWAFgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7414
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 03:32:36PM -0700, Sean Christopherson wrote:
>Swap the order between configuring nested VMX capabilities and base CPU
>capabilities, so that nested VMX support can be conditioned on core KVM
>support, e.g. to allow conditioning support for LOAD_CET_STATE on the
>presence of IBT or SHSTK.  Because the sanity checks on nested VMX config
>performed by vmx_check_processor_compat() run _after_ vmx_hardware_setup(),
>any use of kvm_cpu_cap_has() when configuring nested VMX support will lead
>to failures in vmx_check_processor_compat().
>
>While swapping the order of two (or more) configuration flows can lead to
>a game of whack-a-mole, in this case nested support inarguably should be
>done after base support.  KVM should never condition base support on nested
>support, because nested support is fully optional, while obviously it's
>desirable to condition nested support on base support.  And there's zero
>evidence the current ordering was intentional, e.g. commit 66a6950f9995
>("KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking")
>likely placed the call to kvm_set_cpu_caps() after nested setup because it
>looked pretty.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

I had a feeling I'd seen this patch before :). After some searching in lore, I
tracked it down:
https://lore.kernel.org/kvm/20241001050110.3643764-22-xin@zytor.com/

