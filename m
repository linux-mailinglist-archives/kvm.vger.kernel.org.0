Return-Path: <kvm+bounces-48276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3768DACC1B5
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 10:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1F3B188FDA2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC5928032E;
	Tue,  3 Jun 2025 08:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iMNNvEfI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F30268FFF;
	Tue,  3 Jun 2025 08:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748938035; cv=fail; b=Yzu9M84LnDiqtoE26oJXczPcCZs7awph+z1n68Z9061fWe3oemNe2w3+2Hc8G9DMgzZ1GsJY+Ax9LNebGCWTRu5mppA2PY9yIiIKo3tfbDw4ZU+Nb+PUA6DZuLr/ADJb/vVVVcouM/Fxafrq+V1f7QiQzHL0y4WwvTpv7mMob60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748938035; c=relaxed/simple;
	bh=x+e6cX+h3ZDEdik89OPMKEh/elDeZI4GAYDvcHHycu8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hho2kdzZ23oiUnXA3T1hharG2kJi6fbmNtznX++BxB3LpBdurX9OY7Y0vyOWLr0TPcQO4fOeEnzdWZiiASWKBNiy9Bkvg/QlFJ7teQI0F3RS89ndThKWh8tZBVoAn39LHVTYNWGEIPMbZp9powUH7rw9bF8eFmRBFkkFpgPPZtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iMNNvEfI; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748938034; x=1780474034;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x+e6cX+h3ZDEdik89OPMKEh/elDeZI4GAYDvcHHycu8=;
  b=iMNNvEfI0L8sJTO0MzAu16AdmQPRKMx0KGD2pVkRb7PrNvODWwcb++LV
   AqMAgGfB/uqQ8S3rfEqqgt6najHRRj9h88nT/ER+FNgm9Yrpe4hSUzXA9
   d/lzVNVEYRFIEP1SBEUZjHeMybpk3LGt7Qsg2ByYpN9nUcwy+m8uFfxs8
   DlxdXdkS43Bm3jkjTZSbvI0ewetboio0pZy7W6APQy0HQcLYr7vNyYf25
   8OoseXnD+KuD6mMJNAclq2a68hfq6u60TH9W10CyohtM/PY1neMzkEl94
   Vb32U+C1NHecV0jYkuQjEM1e0wuq/cZGyej19B+aQ1qZ3SwAu6KcX4An3
   g==;
X-CSE-ConnectionGUID: W/feKuSmQCenMdpRtIU2BA==
X-CSE-MsgGUID: 0kqqFlv1T5GkJWR6N1Jh5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="61585498"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="61585498"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 01:07:11 -0700
X-CSE-ConnectionGUID: M7sDqFByT+qMR7YYly6KnA==
X-CSE-MsgGUID: qgOxm8qISZ+Z640t7QEYcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="175740236"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 01:07:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 01:07:10 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 01:07:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 01:07:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVxOhDGm02r6OUuSCjTcWdyLShF2ZhHnOYCE6g0AuRt5gVz6A+wpSFnuZRHuSW14ZDmDhSgAqHIWIb48JAPUyZopZ9Q2GxLYwHqHNNfdH+MwAO7FRhOnxhR+TDSV+uMzjDQa2aK7EFqOqp3r4+3z3O18zjr/COX37+0qvtPEW+v8UcsQxMC7BL5RxsDnJMQcwCTCIjmRxkrutSd0mn5m92RkjTKZzOzHdpXqYQov9asDnFHyzd3XZcu5Kp/R76bZgiaQqpcy1Q4/0Kv2Fdi3T1H45I1JRt0ZRhDg7EqdD30NmLLqUD8Br+3a3hoA1OWbkjOM6mHrxMppJe2cEiXYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGI/sIpOk46aTWSBuCr6VlL9aMk6Fkk96xF68u2n5Ro=;
 b=ACXwS+v5N869lCv8YR34XChcFEkil/5ze/jCu4CCqvPMU2fctBoL++yCypEitLWi6bjRz6Edd4nhwZeFFNZ/E7RAIznzNitdNQpPIMw51wxcL+4COdEbSTi5q37aDGB1dUDR9iafhzCMVfkTtseCjr/NoHVpKNLczo7yd89mMwd8XxqnHQjdYGH0aNbEBjKUCsWSF1w+ny7htFNVY3CaG0CVfgLj2r24cB3TrWFv+vxyHalwZena9H6cB3CMu1uddVFffkx2K/zZ8Syx37n9A5VWG96lBZYHCyRsmEAmZ4N0+4E+iv7AmQ/RlDWR9qLpzluDDKAivDwLJZnnxjaGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB7112.namprd11.prod.outlook.com (2603:10b6:806:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Tue, 3 Jun
 2025 08:06:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 08:06:54 +0000
Date: Tue, 3 Jun 2025 16:06:45 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 04/28] KVM: SVM: Kill the VM instead of the host if MSR
 interception is buggy
Message-ID: <aD6tFSu5dvEQs8dJ@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-5-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0242.apcprd06.prod.outlook.com
 (2603:1096:4:ac::26) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB7112:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f0483d-1bbe-4711-4867-08dda2759a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ol1wulrjv6qHDTxXoUaBCUgw9NA0I14AYKprML3b1JCVUG0A/dCG33V8d8fZ?=
 =?us-ascii?Q?vQJJiFGoslUhZXrSsZ39mQ/m5PasUU8Gxoh4XqmgeaEJKHMVNhNHHIkxfZjO?=
 =?us-ascii?Q?9CkZmSpwyoKzB9MzfLCfKGRAn3hmjMXprcCwDkdXCr5FG6zjOvgMDpNqJwTe?=
 =?us-ascii?Q?8hqgDvN464HAaVIFcYeXX+atJFDVX2DPIRxYrulbCJTvuUWgijnDpzZXJzFL?=
 =?us-ascii?Q?AnonPRWXtz62yiYzaZvG0EbadmVuF4073f/8dwTIGLC/igc7bckb97hTotIC?=
 =?us-ascii?Q?pOUfgwiiq1HSvbSTXBFUtWzElAiT+F7X17QaKInYjqvf7A4utGIVMCYk1bjE?=
 =?us-ascii?Q?q5m+imqafQI0CYKvqDC5sEWZv+mXONLZ7Ndmxl9PU8v61bguzlpMsiUXFLvx?=
 =?us-ascii?Q?g9xfmLNQPv6scL1vzMUGxbvjBVZtrr89CfkmMsf2a+qbEiJjEbaPOWNWr8FX?=
 =?us-ascii?Q?dmYsJerI10kog5Emas9c7b61C92tg1vvTuoVBrvAAczS4qlYHd1/sO0OeQGZ?=
 =?us-ascii?Q?/Xoy3D01CJS/4isgUZh5v+qeK4OzMfWByUde2mf3MhvZd4jNFtBDIT5omgOf?=
 =?us-ascii?Q?9oTxMOfjXoItcOzG9VYtAZfsVrAVfi2UqiLz7EXRw/eUmnhrWHKnz6hljU3m?=
 =?us-ascii?Q?msM3aiEGwtnJRaFxcCJKe0uBCanCmXc6b5ERaG6mpaWui4wE9qejvGMgcK86?=
 =?us-ascii?Q?KR4ZtDv0AjTKw8R4mBOpL7q8PX7fYilOq2BMoaVBhjkEGn+qs0rZFb+sus9m?=
 =?us-ascii?Q?dYFRLfrNGpKFSQyKyHGDg+TVFtcns5EJJ+z0ieBrQCLTWOZXMu9I2BcrvWYC?=
 =?us-ascii?Q?iCY4eDLDqEtO7hBo+ZAgaQMVrVCaRFdvGT7UzEN11OKzdwLPFulsEA/TNM8r?=
 =?us-ascii?Q?kOYS9CMYjoQ+UUpc5Kxmosa1yI/cTOf+iLyQQ3CXStos17ZMrfcE591F7g2J?=
 =?us-ascii?Q?jQKltZzmT49isKCnIIujYWm5f6XW/BaCQ/NrJ8/of22rswVhMyO148Sbx+p8?=
 =?us-ascii?Q?H6dAbMaKFseiX8bS+2uNOejv/Y1C/G+XdscYumkOVHFhhuEr7Anu0wXzFKEq?=
 =?us-ascii?Q?UAr8L8f0GG2UtyEVUBX4q2Sy+OjSO1+Rmy0WOVBNuYr5wvJajL5U4uZk9Wlm?=
 =?us-ascii?Q?JCp8+nrYW8yOij229C6WmJU1+gL9gY4hQFbVsLzcbD6tEsS7XbHhVZT0I2ZN?=
 =?us-ascii?Q?adRr1K7TzO8QWRdYjz6l5/ATVp+gjrGz1Dc4TzK6FuPxgIieGrkYhf4FjqPl?=
 =?us-ascii?Q?tQVz+LhvwvQJh6z3pR24LhNe/cPjjTKRoY+BdBI0B5opAPFUmBEFkTa94AA7?=
 =?us-ascii?Q?iuvoaEkoXsQT2ItYR0aPDKrZR2st7gA5dOXBto/TLutnIcpIPpKuARR9+rnW?=
 =?us-ascii?Q?9Ug0eYmxdOz0g5GRYrV+vqFEwPh/VnnkcdY5t4qkY3dRBP7ZKiI2JXa6+RH/?=
 =?us-ascii?Q?8q52qWpAD1c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Dp05uPBOfN86/cMXJokJoGptCTM7k3QugK6/DX5NPm2aZhTVmnH3V1jQFmk?=
 =?us-ascii?Q?7dkAf6AE7lDS3HKwFJ6SW87bFEQQtC3a4/R9OOfc/50r1tItv3GXdnV8NAeG?=
 =?us-ascii?Q?PyBI2LGge+AXgtihvQ7DaJ5PC/iWiJLkzAdp/mOc16m29SN5LjM4LhrnlDji?=
 =?us-ascii?Q?Eum/D9eWnUHJekIMXkLL6DYcQDAHtmueiAcB9Dcws37iCEhduUJmozTPZXMf?=
 =?us-ascii?Q?jhTlBUngBgVHby2gZfnUu2fv19J+FlKar+J+2hYRwHR/pZxDezG8KV1aGEDk?=
 =?us-ascii?Q?geVwign31z0f1mBz1HZvxMho8a38Lz3g4w3jfA8HqC2Q73haF4a37m5j4VTe?=
 =?us-ascii?Q?Tiqc8vD2mXCYBDVDeEhQZAdX0Q/K8OTkPz9fcUeitLhU33MkGsfK2XEPWeLp?=
 =?us-ascii?Q?foyPW6L8s+CWfp0g3944cxsZQqAcUHO9uwMTKmbxMTxaXS30NBWWpmyij+HB?=
 =?us-ascii?Q?0GkbmoHq79/36nwM3PUqiATwIcBewvzZ0lppKA1SChXlJ8yTFv6Fb1nIBYjZ?=
 =?us-ascii?Q?0KbrhPwNBc8flM0rAOIIQMfmCUdst1GxDyA649+9/0OU2qsJHrpQhYSydkCv?=
 =?us-ascii?Q?ZbAetFEtMlLo8EoyddPHwLCKQOZKH/4ocimvTZ7rZHo+ZeezJ/E1WhkfsZWK?=
 =?us-ascii?Q?+jX7vEUvVCPNH2eUKdETc5+456DUGKP3wmX4rO5ANxcXNEGDD0+M3g9376FY?=
 =?us-ascii?Q?DnLUEQEpeMd1ZMrYhRJP7NRqKlJQ5j//dy7W72IDIxTAuzAcuZ+Qy7OBFr+R?=
 =?us-ascii?Q?CJZJiRWuKUb16jfksmEAaK8Vu26JKoau8h6/Z1kBWjSodz/UdpGKi4UCXaKs?=
 =?us-ascii?Q?CN/eppsR4xPeEdh7cEJoeYA77wbpK+pOjpgca4b83RUawLlcYWjP1uJ4VFrz?=
 =?us-ascii?Q?BUKEM+wYGzUL3tC+h6/0e+NValKLUNBOxG05bowCMH2GgG8gWVvAgUUiPZiz?=
 =?us-ascii?Q?VhNL5KU31o9Hr79cPBF62foSGQC87S0YOKx+jrhfJMvYSTBMnXVm+9bgZZmX?=
 =?us-ascii?Q?/mQnuBd2V275G3MeaxeH2an578p8iCLulR9myhAVrC3vhCEXus7LfiqOlNC2?=
 =?us-ascii?Q?0O140KrgWfJIfmu8cfuOCrLb3HhOcfkN0mZvo1Th15ZXFpnSM0WhNOSrDKPN?=
 =?us-ascii?Q?eMQ8kSoYJwX1TPJWvPQkHAnP4SynhXSre1fMuRyxhxrRG4KcKbrKEm2QUnvq?=
 =?us-ascii?Q?djj3Ce9fd5r0MJmfgjW8axCiIkFajN6PjF58glIc/vWDOopQr6r+CO79Em8o?=
 =?us-ascii?Q?JoVuMKA7ag/8b6C4qVxvR5+vxvasshgg8J3ht33jUnfFEUP2aGXosm+zrcVE?=
 =?us-ascii?Q?9HVZuPIw67UgqYsVhB1HXwsyg84BMtx/DWIhTj4GImogYalWSjD+M6C0Wf18?=
 =?us-ascii?Q?X7n9+jPBKXMthOym9Xdk2Nh61gaPGNC0bdQa3eRohUpEuz+AAwgwLcRVxyeL?=
 =?us-ascii?Q?AAFJKi5Qkgd8CFK0CqI5DFs3YE5DBWDBsW5UEbTYjkP0CsdsxI0EzeAffj0A?=
 =?us-ascii?Q?P9sWPCl07TKavlMfeZj62aKutxcpZn7cTcplHbV2YRl15/JTZPcsWKMpB4Va?=
 =?us-ascii?Q?5bnJp7GS4PvFYPhcCy+H8RBJlO84rvqX2IA0cjIZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f0483d-1bbe-4711-4867-08dda2759a40
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 08:06:54.1378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DS7Jdc6F7jBiOgTcsuEmI5N9Oc9xWZB/GM5wyUWYQ0IZapcKSGUeNRyRQbkxNE26wwBneZLO39d8QL1c90Bgaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7112
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:49PM -0700, Sean Christopherson wrote:
>WARN and kill the VM instead of panicking the host if KVM attempts to set
>or query MSR interception for an unsupported MSR.  Accessing the MSR
>interception bitmaps only meaningfully affects post-VMRUN behavior, and
>KVM_BUG_ON() is guaranteed to prevent the current vCPU from doing VMRUN,
>i.e. there is no need to panic the entire host.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/svm/svm.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index 36a99b87a47f..d5d11cb0c987 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -827,7 +827,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> 	bit_write = 2 * (msr & 0x0f) + 1;
> 	tmp       = msrpm[offset];

not an issue with this patch. but shouldn't the offset be checked against
MSR_INVALID before being used to index msrpm[]?

> 
>-	BUG_ON(offset == MSR_INVALID);
>+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
>+		return false;
> 
> 	return test_bit(bit_write, &tmp);
> }
>@@ -858,7 +859,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
> 	bit_write = 2 * (msr & 0x0f) + 1;
> 	tmp       = msrpm[offset];
> 
>-	BUG_ON(offset == MSR_INVALID);
>+	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
>+		return;
> 
> 	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
> 	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
>-- 
>2.49.0.1204.g71687c7c1d-goog
>

