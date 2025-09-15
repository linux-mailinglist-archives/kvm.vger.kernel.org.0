Return-Path: <kvm+bounces-57522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C946EB572C9
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 255121896487
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE762EC567;
	Mon, 15 Sep 2025 08:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZULFjVjK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7171C2C0292;
	Mon, 15 Sep 2025 08:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757924595; cv=fail; b=GZsNoN/4uGhb1+MqCVYqvy/xpVeWqCIt2CNZXnWT2pvu+dsRYEm4KCQkGQiy/TlhXfghzkkumZZvHNwEtppNYpAFJD4OSwOSHeueFSqBlT8UGAjD24Zv0wfM6qrwXjkFdYX1TEZXFg+cWcfKq8OxS0pfNOAMTDvgh3ZsTB+3m2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757924595; c=relaxed/simple;
	bh=PF2F+1bMq+UkBjLtOlOzpaoduwJ3DYZ8pajfgRS0/MQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=knLtxi6c0T5C6HDOZX049OlRAY477JdxqGVzpl0hADElusWKc+wP64BS/SHtlK3tHfUalKx+jEHcuUfqhFu/ckifoYc9JB1dTrWNZjBqYkpvi63vktbCtZj01Re7TNNNy7872a/c29TDZ4NCfE9x4GHrSmPDOPwRj1JraopI6Jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZULFjVjK; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757924593; x=1789460593;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PF2F+1bMq+UkBjLtOlOzpaoduwJ3DYZ8pajfgRS0/MQ=;
  b=ZULFjVjK16swhvhjDia4qMurAxwIhoFbBN9L9N8jtd17JtauHQaFnOIn
   g8OhDl5ioBnZeSx4YF59GCvLs0Q/1EY2l4wBu81T7D5NdZG1MqYApeGbe
   AatPGWIz82FqBSOG5SqyBheJyJXXqA5Ze0McLkl1tSNmm58Cme0PMkzmu
   z95cTm7kDYnzK+cdvJnm0N5O9Jaa+rQ/R4oNEEBGrmP+2AsHhfIVKo7M2
   TpXNl5ov889cbZ4kJ2hGlsMxpsjCINbU83AM+JK68WiwhfOFr3f+QK44d
   WABRkSI+9vEBDh0kztmtw6yDp6Tn85V15H5uOf2h36CgXIeJSwro+Tk+d
   Q==;
X-CSE-ConnectionGUID: 5tiFo6eMQIymWVWLceNxRg==
X-CSE-MsgGUID: 8y02DdVTRuqqRippEpqflw==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="60275456"
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="60275456"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 01:23:12 -0700
X-CSE-ConnectionGUID: ZhuMluHnSMuU9n5AEuA1Zg==
X-CSE-MsgGUID: vwjbANVsQHaxKxFCcPSkrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,265,1751266800"; 
   d="scan'208";a="179726685"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 01:23:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 01:23:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 01:23:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.81)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 01:23:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuB71Z14PDOpP1JK3gCQjqXTMANMpnu+ZW5OlhjLo70RK9yAA/KE4ENdodonIPcrunMSQEopC9lEYpaCj/cw1dtO8GE0s32UEREy19sN58Li66aMJ2hWNpukyL16e7A3cWj3lk8Ni03rmwZQJ+sQ2D0nQscGlhGkYewTGKcSwmpFKWWSlwM1HHcvASK7L9ZKy3FoNdQVoxknTrxQLrO9re8sjOAraIiGHuhngSEAaQp5aIL6uWAri0xGlN6C0gP0ksl2VUvvOAbU9Qcwgof79zGAWMAFoQMvZv7a3resVsnwdbZWN+TmqqWxHbyLEHNCSmxQw1+wUB/jVasmV+6dpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBMu6ryT7saUi8GY8Mw9/xkFkVGZdrVW3ZSepn1UpfI=;
 b=IZ9WmFTBLMgWXjiAkAifA/uxZR3g39q/vq3sC8vT/ebk1hjXFaCthCk8jtuDABW/7sEhM0cUzkTAqqnIAkHnbR5zA3EzhOzySNaznoLFOOhC+1ldioJdk436J9pVZ13xFOs/nNpX//RlekGWVQ7qcBQ9HlZF0aH37E54D11dD5ICOwQDhesV8d4AOtU8VYm+ryekOGP2ObxAm05b5uxi7z/EBuhlxpHnkmdpkWfz3puQUtmLin7WG+CelE42XeuVi08RyLIEVlzIt64ZEhml6ZdB2FthZfeq2pvonI2lVoe/aYDY5IPINeetHSjRcHu2xw26RozFbSIQmMWXIBjrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB8853.namprd11.prod.outlook.com (2603:10b6:8:255::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 08:23:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9115.017; Mon, 15 Sep 2025
 08:23:07 +0000
Date: Mon, 15 Sep 2025 16:22:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v15 35/41] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
Message-ID: <aMfM4Fu+Q6gpZKYF@intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-36-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250912232319.429659-36-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: e946d2fb-6f00-46a0-d9f2-08ddf4311919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YyBQ77cZWo/BrkOZ1E8YtpYUhNbKtV05JdO24YuFNx6itZQbdElL7ynM3yrA?=
 =?us-ascii?Q?BEFdjhDq9PsruXHdGZ0XzKm+0OvqfVxouNEG7b2Y1FX0e6xNhESQC4+J8Hmb?=
 =?us-ascii?Q?wR6olC43S3g/hfCySAiD9lqFNpeS9eNvMh+CkbVLuRfeTkMjpgKk8tutPUn9?=
 =?us-ascii?Q?7e2ms0UqZ6hh68cN59Gm0/TNcKHELOW5AvRj0iRKbEDHDpAXqdXjlcTvlNQy?=
 =?us-ascii?Q?6aDNvg5n4Y7WrnKQQV4Z9OryJ7BkVz9i7iyGNYSV8rYiP03Btgx1fFL69tmA?=
 =?us-ascii?Q?rfP+6S69d7+/p2CaKREc10G2otbtJsOHxurLOiOVM3p5yM4w6YKdcxYbfGld?=
 =?us-ascii?Q?qctgxxZXuGNHQDSAcyxOt+T8vKaIu0dqL9naCxbutpvxfTukq96LBKeZbWBn?=
 =?us-ascii?Q?TdR6GTFX6XkNq2mMMqIAXqgQgwRUbuLDBySbtOM5UUxoLirk5x3rHqddExaP?=
 =?us-ascii?Q?i0CgEzWpFBJ7QWjiGtQ37UJ837j7GOBcemzLRuUoumx1IDatKjbzjTBESsnk?=
 =?us-ascii?Q?J/R4T6oFI5K6NPc9ODA7jnZo3S2fH6ye3Psz5iy1jSiF6W8J5/PHe+doIdZx?=
 =?us-ascii?Q?LQW6MkgtIzR1xX3dIPBaEToM95xQtuRrcGSDtFE6ilBf0bneYB+lcfNk6UEl?=
 =?us-ascii?Q?ZFzzZs2HnURGy26xb/gdebmNJai+WuVqLTf1foqPPz/S4ta9elX2Nm7Ep36S?=
 =?us-ascii?Q?LlX2l5K4dVGjTubLQ5Xekza/KN89APwAgjXbSa3CVXOt7+UiU/Y0w8xwFw6A?=
 =?us-ascii?Q?6I4w3Hmwq4+KRth508mXA8xLC1u7VY0+0g2jnyNzPEhbmhDG9zkb/PJmKMTg?=
 =?us-ascii?Q?I9LvEcQqMx4cacSFd7G+PeBsu0pVatuvYOvIc4no2rdolpQNmhXuaxjiFAzo?=
 =?us-ascii?Q?1fNtg2C7dfCNe591300L707RASrujz2JiUupHCQpKLrb+y1BcfdgHwamaD4S?=
 =?us-ascii?Q?5baA/w9JTb2rgzFB6cUo6pdDHcVK4Ww6vLeTGfht10Jo54HYN6mtc4/pz/XA?=
 =?us-ascii?Q?eiL4NNkCzKxHHK6aEip0okFFVr/LxB7WlAtsgu7ZL/eySTkv0HtutGp8yZj2?=
 =?us-ascii?Q?0bjXQ0LM3fSNTt9lEgwHiPftuDz/L/nsWXZUjHuLT3JjMCtuypQ+W1eSzfU7?=
 =?us-ascii?Q?/svplO4Uwg55nF/mFbY4MYjv8LzKHdS6jkSVyCOTObN84Y0XxVjIiRJY8zaz?=
 =?us-ascii?Q?RR3utYiOL1WjVlYIi6qCPdqqkYdp/ZwivVV6zVaQOZ3HMvqS1UnqYjn0zkVM?=
 =?us-ascii?Q?I2hc7RnBDjSg7t7KaSFmfMFiqzPgwmCcDMpwBRerMH1cXcP6qU4FAFPv1QRI?=
 =?us-ascii?Q?vTUq1vlR0TPQnj9cxJvA+EE7Rbf3Q1tfytVTxqkeOb675TKx7dxAE2iKXXi+?=
 =?us-ascii?Q?DgkhRbl2bAFv+hqjnN5lsBN5UPtdBy8jyzvp6hPqG6L/kArMHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iCrRpPRfB9tjH4F5my81lgmz9Qvvw4fJRHjK2Ozyyh06BSB9nXeAQ6Eunka+?=
 =?us-ascii?Q?GSmUrIdYbeNMZJZAMuy+p5hIiuMGrf8nb160Rt6WW6GBoWeiKTiXaR7CTlRU?=
 =?us-ascii?Q?Zz7NzqZXtpYmewIIVpOMolzO3LfUWa8oMm2nN1mn2ic91yf/EQys7t952/YV?=
 =?us-ascii?Q?e3VPFCnXf9720TweLXTdis+MRV0CFE3UzUOSovMQi7GJ7eocTgupascdxFlg?=
 =?us-ascii?Q?VIn6mV8+jKbbBSPn3EsYRTLvSBlT4Yoih/RgiKReIqj17hfkjWlb7NhKgRwB?=
 =?us-ascii?Q?s5fG/Exipk1gjJytwzHcZMHfodksJwMVJF9ToxSRhi3nFPjZd7UrCHjFXLE3?=
 =?us-ascii?Q?PUTv64BS+mLtUXx4E4fg2BK7HzvT0WTkqa6qr5j4IZVZFp58+4CGpsPZpUmu?=
 =?us-ascii?Q?dav059nHc1Cq0t0Zxqwg7PXs7/C9rGT2dkEIrRKkcDfBTXAtok7xtrRzBpKP?=
 =?us-ascii?Q?R0AvUreTQzpiV75XQFKEba+ycymaAyjvb8YGh/UbSb6EtCITphV6vqwJrnVn?=
 =?us-ascii?Q?emOwOmURr3laq3oXzN98F5xamFImQzJ21dl3kAlGlj2l4/AkhlRiXe+o1AOn?=
 =?us-ascii?Q?/22MUY97fzC01BEtJIVTm8VEoEIAp55CC5FdSd3KbyoCl27TzGsNh+g0pGMT?=
 =?us-ascii?Q?1FKeGk+Hm3nyKGDpLprH72UKM56a0IR9Zr83stEFTPrGhDkOh2fCMrJL4pZX?=
 =?us-ascii?Q?Zka1CUU0wpKmN3KjOIze6esOQb1pGWJAA2CChgc7ewwJPjGK4C+oepnYkU6S?=
 =?us-ascii?Q?XPjbk/Rjp9acaOz669uPG8uSeu1rF91REodLwwtTwyTFDx/l9leczhkX4UFO?=
 =?us-ascii?Q?Xy3JDDxP3kxR4p1QAWVQcIjcsGmN7G19PFoDPz28uAdEzxOJV0RrtwsOsrUk?=
 =?us-ascii?Q?D0oZdQK9mEGqPda5y3rMScYnXcln7wK+z5w5UpqmsIJXquEyTbJa/Oe/Ly80?=
 =?us-ascii?Q?LrvY89CjIbozAgiQeRyS3WmYguad06uvtbOUbdKs0pYJEMwdh4WQCUpC6+mh?=
 =?us-ascii?Q?huFuPZXlm2r/6QCM7aaBylxbK1ZzgZ1DZ3FeK8jGn2FhXb4eAqhDiUpxLlzf?=
 =?us-ascii?Q?Qy58iXm3GH+SlSmGKrTXshMeuny8bVKlewc9Tru+fJobszXmCj3Eyq4adm1i?=
 =?us-ascii?Q?PcoVxEvc9IJSnkKnjcAhfigSUjis+mCOBziaxdvGZQIrAw7gI8dWpahdHBcf?=
 =?us-ascii?Q?Hw4upJtZ+Gj+nxe4zuTnXRwLA8Cim4QjzVFM8M7l925H4dBvVHSoNsGZB13w?=
 =?us-ascii?Q?fILkiWxdW2+q1icyVjr4Vom6bT7DA5jz+3fpn/VjizxQYRDNYs7sxdFwN2B/?=
 =?us-ascii?Q?VSva+j4YHOPW26gpYq7jRJTulJZzN7cas62U2mgZ8EZR0YIdTpQdEn7RX15h?=
 =?us-ascii?Q?9YDBzFohXRLn6KnBGAjYBAiKXsMJUTbYIib9E5Vb4VgfHv+ye1xRRjJX7YO6?=
 =?us-ascii?Q?/DfjniSFmN6qP4oKoUmAAF8Xk3KI6GRKDliv+iDtO5MMw+JcoGCdtAW0bw+9?=
 =?us-ascii?Q?TBxiaOB9uErplkWlvUV+7KgTptyAu6lEYCEhlrHG8AFSJ1khH0HVHw85Lobm?=
 =?us-ascii?Q?ksPTuWxii5nP3/yG7BvyXK0DBFhfcy9bmRojZpHn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e946d2fb-6f00-46a0-d9f2-08ddf4311919
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:23:07.0429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vAnWtHngF+t2V63QXIQmZsfSVB8SFbQJXABJ9qqMq3Hqa+XofkCdPKIL0GlMR5PlB5FkCSRgQywf5juetwSmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8853
X-OriginatorOrg: intel.com

>+static void __vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
>+{
>+	int i;
>+
>+	for (i = 0; i < NR_VCPUS; i++)
>+		do_vcpu_run(vcpus[i]);
>+}
>+
>+static void vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
>+{
>+	__vcpus_run(vcpus, NR_VCPUS);
>+	__vcpus_run(vcpus, NR_VCPUS);

...

>+	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
>+		sync_global_to_guest(vm, idx);
>+
>+		vcpus_run(vcpus, NR_VCPUS);
>+		vcpus_run(vcpus, NR_VCPUS);

We enter each vCPU 4 times for each MSR here. If I count correctly, only two of
them are needed as the guest code syncs with the host twice for each MSR (one in
guest_test_{un,}supported_msr(), the other at the end of guest_main()).

