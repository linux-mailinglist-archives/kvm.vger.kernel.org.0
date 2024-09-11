Return-Path: <kvm+bounces-26450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 548BE974851
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 04:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78A8E1C2580D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D38E2C6AF;
	Wed, 11 Sep 2024 02:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I4ctQg9M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2E7161;
	Wed, 11 Sep 2024 02:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726022906; cv=fail; b=AQ35A/TBwql2XHJ97cHj+rb1+SseFBSDADX2Rq2kFukId3PnukeC7Hu8s4kecdXUrPx8zRW3N4fG5PdnAwHv64rSIOGVTQGdj4pwQj7oa+UFOLP3L7w/L+uZ8zD4yBffLsFqLpC4LuEIFXih7f+mag/iR+vumn13UCtfJwBmfEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726022906; c=relaxed/simple;
	bh=nvKz8LlJ6Y5ccCKncgWAFY7DF6YAWtHNoP7yGly6KlE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pk1jTnnKVUDMsFxNMd91Z++8gsmmVTg7gJSa6lwB/3Dv9X7R8QdWUECxX6xazCaG+QB/LhoxMazEVgVHgZcl7vQUyLewVgQ/rGys+VQT67omeKxebzmGHuU1sSAv7yiAu8yRVWjuOctiiPBaDi+SSDRF7q1ApMh6S1lBLB1cRzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I4ctQg9M; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726022904; x=1757558904;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nvKz8LlJ6Y5ccCKncgWAFY7DF6YAWtHNoP7yGly6KlE=;
  b=I4ctQg9MeTPsGsmH9fCrP4vPzXXsD5hG7BW/FetpnT9/9FqPyVn57gdO
   PGmj8/t+PbrD6LlUkzPYdIGdqhPRxHAAEgXtkbQ3WS6VaXxXea8LAK0J3
   NY+0GHXMhUnm00fgkXH41ieUMzxkpapqukiEk5YYZiifukmiJXUhgDbIO
   oVOZc0AObFcaxKlAXBN40jrtN7WwUok0zcOLwoiYlGRezFku1YvUUdF2q
   1Q3gaf8zoMacGl4eMmVQO7d1Ejf6ynz7b9s9pmF2oX3McffRKWCra9tkg
   TpZvzrCXHk8HkpYBqKmfFBaop3lFDbnnBEv1/YWtYztfMsJHKhlqicLRw
   g==;
X-CSE-ConnectionGUID: TYV0cjKuTjipgo7tqNADtA==
X-CSE-MsgGUID: szu3Cy6vSXyolCqZ8y0sqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="42279952"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="42279952"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 19:48:23 -0700
X-CSE-ConnectionGUID: 6CL09c/KR2GRNSZ8/ExH0w==
X-CSE-MsgGUID: nGgfwOngR4mxAbACAhix9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67067779"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 19:48:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 19:48:22 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 19:48:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8jkUVtldEIjTmcFnff7bgQOFKuCFZlJIwy6dlMIx6jaLO/gr6/8SM1RNvT0Q0sUGdGdVYJghhdCg48jwKYx+BvXj7LSpSaYiD1pX3iVjientWGvH/Rv9D5fD2nI+r1NJmnMA0q4q+DlCGEj2kKzt92VzDnw2WXmsY3I448GbOCunSv2ErcLLksAKELUQwlZuIrSPsfBbJ0HnWVDschKinsZleUmZZlj9gF3VqYerKlH91RuSujyMaNDa/6OIOKXRJYPOsLPh7hvJV5AtdqCUinVaYmfjg6C2D4/WIQ8ibhRNWuMmMBmKbG5POlWtVZdeFSysJRwgzjr9C0ADpwyHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKzL8IWckIvsf+BUxSV2tbOwsBRogHXmREAps+6Xi9o=;
 b=tly1YqNze62XtDFSUkN0mLDrqPMKIOdYGoQTpyAhB5SOErcGvWFTkWhkM85625lbRRtlpQT9OX3h4zc68NnzXk6WBECtESKmVp7+hhGc371/6FXz1EeaQKle/Gv0S/J3nDZFC49HAG0/YhsvZeMR6vG7rmK5NiF2lg+izpSP1k1HYJASjRgmgFT3F65vNvIe1CPLgWLoRFPC3LhL4uzNoQWtZUNyFF670XDEnMUCG2cFHtQpJB5kC9jqEAx1BlDr8NChAnOkn7llId+oflgiIeGO+VPm8zzYkd1yb6CZLiVCu3DYbIYLf0+BFe9V8ExoMSY87eNEXuQUe77bJjpqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8374.namprd11.prod.outlook.com (2603:10b6:806:385::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Wed, 11 Sep
 2024 02:48:20 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7918.024; Wed, 11 Sep 2024
 02:48:20 +0000
Date: Wed, 11 Sep 2024 10:48:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <isaku.yamahata@gmail.com>,
	<yan.y.zhao@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/21] KVM: TDX: Add load_mmu_pgd method for TDX
Message-ID: <ZuEE6fflBualiidx@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240904030751.117579-8-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e986b2b-9b01-46d0-d8ac-08dcd20c31d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dex+6yr//yq9t0mAjaKGaivYIkSi53+DsYUi1L6k8dNFGtTHViDVXsUPTggP?=
 =?us-ascii?Q?4/vP6bdtkAOcZ8dm5t0uWrrcgQUOQBVDBFjpOgz0+oY/3jeKjrWXHkhVgDZI?=
 =?us-ascii?Q?jiT/ovVDKxj2Wm1J4gNHg4QoM58U2sQuyEVUbr5PSqLuk9YL/THRBRJyX/VM?=
 =?us-ascii?Q?Kdhr3ki1lrHaO8LBak86fj5DN029DpE6tw9UBwZ9aGHPPBCDcD85/0D4ysNi?=
 =?us-ascii?Q?SlEA54BMBIL/MYXJumX4UZMypz4gRtM/1CSAHN3khTmoMGtkJuYTRemJps1D?=
 =?us-ascii?Q?4EZWovWE0U5V0hcJRSMEOC3A4YPcsVyEhEoUimNvu7I/Xt2ll/U0tlTpEEyw?=
 =?us-ascii?Q?3LGtVmocYXu1YY5F/n7aclQWFxv+8+Qa8y6FKQNBcKhXubbl+SUUTg8rbHG9?=
 =?us-ascii?Q?wfi+VEAuh9w3gD0WM5F8gr1b3wTfbcTvEP1FM4QtSSijOvq7c2VjuOtk+We+?=
 =?us-ascii?Q?pCRr0ry2hRoBfZuNkFx+7KTUhhbViJ1rufj1LAUB1Ph/iyq3fZhRHhFEVaQ9?=
 =?us-ascii?Q?eAO65/Hbk7aI69HpOgNCXk9dip4YCiMW+uKwpVck/UntpcSPsIzNjaVF1Noj?=
 =?us-ascii?Q?qhcU5tsI0f4KtXDnlC4Ma4P422FhxJdCqlRYQTaMDIF6sLV0zeIuW3As6G57?=
 =?us-ascii?Q?zSq4Ar8iRdgV0Zyq20RLwHsoNGmd4Rpe23BQGVZwZqMdFlY2UbERmFq6jACQ?=
 =?us-ascii?Q?wyehI5XIVGa9FRgN6anLyI1iYdTE2A46+8rT1m3624Dsw2OzqH5pMQ7k+nsZ?=
 =?us-ascii?Q?Ys5BCA+J+J6dCt8dKpCEprOeq5AgoJyZHmNDlQSiP864TF+vKYW6G0EA8bzP?=
 =?us-ascii?Q?7nVJ4atM9cIKjTWFWbRUR/uPvdjI+1+vyeME0/qmZteeRQGs5EaHSCZA9LNQ?=
 =?us-ascii?Q?rWH2ZDiZODQog6jlE8UA83gQAcNHsA7mpkqzU8/tW8O4dz1EySqhbtkikO3t?=
 =?us-ascii?Q?qCxLu1brEwgL4Xx6t2rcv33Edw/myCxzqWBHz0oKCf1Dsc+BlPbO4Q6HcbeN?=
 =?us-ascii?Q?+mg7f18t9hKD2UtIOCBIy0TgnGijQuLayldZooHS55swo2tR4kAOgrd0pUJ6?=
 =?us-ascii?Q?QzFoBbXVXQFEGU2aApbaH1M0kORx31Li2wDilBCZBQ/Igw6T+yv2aHpe7Q3h?=
 =?us-ascii?Q?Q7/cM/2GS/9NQwRA30j7QGPTTf+KB9z20hXnjW67e8G1EVgFyYeD042eNB48?=
 =?us-ascii?Q?Ax19CvQ3YskOlUI1fTHIvNaB6VN/8zNiB4FYZ1bxSp7FJS/nqyHjJreYmeQ4?=
 =?us-ascii?Q?77PznGGXiRyD+C01sgRugtN8h8Onxg62dgn1Y6cynzD5YVLBApwOLIIZkA5J?=
 =?us-ascii?Q?j8gptV5YBckOkXoCuHkDjCISPeubI9Fdpa9jGaKgEsU9Iw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7GxSHrQB4PFlhsXiMRDqjD6+Ae3K3Nop6R2C00prdNd4ZTiRoQ5FejAS0YR1?=
 =?us-ascii?Q?OqPcnvo5ndxgwGt2xSf/4QXYDCwzl9KuqoMBogsbK52j5ivOX2pdElDE7ARJ?=
 =?us-ascii?Q?O59mi4qg3zV6x8bI8BgKQOkrmu9jCfg6lC/+dO18kKxqSWtiW6sXY9cfJR1K?=
 =?us-ascii?Q?4caY/9TUmIt/6vu7AAykmaqGtVHi4FGIi52tsZr/7AbU2KiGa9NT6eT56WIt?=
 =?us-ascii?Q?8RB5tTYDyBW5ypE27dKKVBPDMuhuQMaqX690/We7hPT/+751GpdRSCHDkKVH?=
 =?us-ascii?Q?k67bhffZyCYPFe4OkoR6T8AteV74Wng20JTFAXIjq6CdTETOiW5CH9pj4Fma?=
 =?us-ascii?Q?RtXVv1K/T+mSmZ/JymOSSqy/n/Uufo0qEK+yq21N/SxJ5cVYcMm3KADcHjaR?=
 =?us-ascii?Q?CFG3dOWzRi6qk/t9oD7ImGcWi1hOb+UeYPY3sIwgQli8ArDa95nnPaewIQHQ?=
 =?us-ascii?Q?5vqr6B7kvWZr48NaD+y64qV3BBnUCcxOnOUepklkE65zH/Tto5ajqwlqVe/s?=
 =?us-ascii?Q?02n4YJ7+xoDd5YirLgKoyHAhsZZgOF20SNfONx0/76IflD/ZdY1ymWD2zMKG?=
 =?us-ascii?Q?1pPMBrqVjBOIsMP+01Ns695qNk+0YbaJScKWwZMVyio/T37Sm1pMVMcrm3sx?=
 =?us-ascii?Q?PAW3e/CFJcQ2KRaTM6HQIt60I935BEn2DNKH4jlEcYQL+f/TgNvuqPTAFGUn?=
 =?us-ascii?Q?ibNpfermUrSEuj6dzgLlFKCHaGSzp+/MuOH5/tVLHuVzgFgDTcpRno2Or8Lt?=
 =?us-ascii?Q?E+eccT9T4Wi5Kc1v8cBSFjJsO628SfmlmRa44rlN+j1vO3SjymU5k4rPXSeO?=
 =?us-ascii?Q?XhgtNDxoL3ocE61v8whOkkkJLU/yRViL0HSdrTkCuC6i9oiQwuiJ6EDrTzOB?=
 =?us-ascii?Q?Pe9iasQXd6NmLGzII87QFGPiCK+Ix+sDlIjjra+c6rmHOLwZ7LrlwlNrQF9q?=
 =?us-ascii?Q?D2F98smSnkDXGpfQlUamrjeIpqHzaJjVU9djhOULybKG+UtI+5tCh+XIUGtp?=
 =?us-ascii?Q?jn2scylTg4+1tjwReHNMaq9gk5urZ1EbYvjHLjU6Bv5ysPvEDCn69cr4U2U+?=
 =?us-ascii?Q?GTG5NPydXySOmHeYbyoqSWWkYcSHTeQCeSfxhpSvN+e4utJ16wwSKRC8nE1u?=
 =?us-ascii?Q?i4Lm0byQFfaUwOx6kHTJY2kyJ1eXqx2G+i53wE3kfbhT3F1XwaTCwh3kY+NU?=
 =?us-ascii?Q?FFBrk+y/BdQ/m3nXtqKsw47quEQlBS+RaKYBPpR+ZWH2ULleRynVuA5Oh0/W?=
 =?us-ascii?Q?xUgp4xHnyGpZaAiyej0xkM879VF0khvaamvFhBuh7xA2YAji6iWhVtb7Qfwa?=
 =?us-ascii?Q?lUSmyERUeQqkCp9XuQNenP4DcXClHeAfJGMCG1ihSDHaDJ4jUN3iWYZ0JTUr?=
 =?us-ascii?Q?qyB56XgjMHbyrjy9wk4qK6mOSwsbmTjwRroteHy0b0+R3QYTVQ1NrbPUz1Td?=
 =?us-ascii?Q?BOQQ6BykYQS+jNacUe1agQpAeL7LBUuLaaB2stW6GJ/0RHbt6yY1siunFWAj?=
 =?us-ascii?Q?yc+C2LFeOPFeLeuoJ1X7u/eyqf9dOttKNEUeBGFbmZhcWNxNEFUGlPZ1O9KG?=
 =?us-ascii?Q?zHw9WSklQD74Cojrd31/vOhQfHO1pimLJi1+PVKs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e986b2b-9b01-46d0-d8ac-08dcd20c31d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 02:48:20.0650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VwzCs7hikc+qhHZZQxL2Fx/pfUpyfL5JkiJGsV2hixTxZKqozz/0gxMBHQR+N+q1G3R8EAkrhQelj8MBexfSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8374
X-OriginatorOrg: intel.com

On Tue, Sep 03, 2024 at 08:07:37PM -0700, Rick Edgecombe wrote:
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>
>TDX uses two EPT pointers, one for the private half of the GPA space and
>one for the shared half. The private half uses the normal EPT_POINTER vmcs
>field, which is managed in a special way by the TDX module. For TDX, KVM is
>not allowed to operate on it directly. The shared half uses a new
>SHARED_EPT_POINTER field and will be managed by the conventional MMU
>management operations that operate directly on the EPT root. This means for
>TDX the .load_mmu_pgd() operation will need to know to use the
>SHARED_EPT_POINTER field instead of the normal one. Add a new wrapper in
>x86 ops for load_mmu_pgd() that either directs the write to the existing
>vmx implementation or a TDX one.
>
>tdx_load_mmu_pgd() is so much simpler than vmx_load_mmu_pgd() since for the
>TDX mode of operation, EPT will always be used and KVM does not need to be
>involved in virtualization of CR3 behavior. So tdx_load_mmu_pgd() can
>simply write to SHARED_EPT_POINTER.
>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>---
>TDX MMU part 2 v1:
>- update the commit msg with the version rephrased by Rick.
>  https://lore.kernel.org/all/78b1024ec3f5868e228baf797c6be98c5397bd49.camel@intel.com/
>
>v19:
>- Add WARN_ON_ONCE() to tdx_load_mmu_pgd() and drop unconditional mask
>---
> arch/x86/include/asm/vmx.h |  1 +
> arch/x86/kvm/vmx/main.c    | 13 ++++++++++++-
> arch/x86/kvm/vmx/tdx.c     |  5 +++++
> arch/x86/kvm/vmx/x86_ops.h |  4 ++++
> 4 files changed, 22 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>index d77a31039f24..3e003183a4f7 100644
>--- a/arch/x86/include/asm/vmx.h
>+++ b/arch/x86/include/asm/vmx.h
>@@ -237,6 +237,7 @@ enum vmcs_field {
> 	TSC_MULTIPLIER_HIGH             = 0x00002033,
> 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
> 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
>+	SHARED_EPT_POINTER		= 0x0000203C,
> 	PID_POINTER_TABLE		= 0x00002042,
> 	PID_POINTER_TABLE_HIGH		= 0x00002043,
> 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>index d63685ea95ce..c9dfa3aa866c 100644
>--- a/arch/x86/kvm/vmx/main.c
>+++ b/arch/x86/kvm/vmx/main.c
>@@ -100,6 +100,17 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	vmx_vcpu_reset(vcpu, init_event);
> }
> 
>+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>+			int pgd_level)
>+{
>+	if (is_td_vcpu(vcpu)) {
>+		tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>+		return;
>+	}
>+
>+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>+}
>+
> static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> {
> 	if (!is_td(kvm))
>@@ -229,7 +240,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> 	.write_tsc_offset = vmx_write_tsc_offset,
> 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
> 
>-	.load_mmu_pgd = vmx_load_mmu_pgd,
>+	.load_mmu_pgd = vt_load_mmu_pgd,
> 
> 	.check_intercept = vmx_check_intercept,
> 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 2ef95c84ee5b..8f43977ef4c6 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -428,6 +428,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 	 */
> }
> 
>+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>+{

pgd_level isn't used. So, I think we can either drop it or assert that it matches
the secure EPT level.

>+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>+}

