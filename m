Return-Path: <kvm+bounces-41032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0619BA60D25
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D5263BE179
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7991EF0B5;
	Fri, 14 Mar 2025 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0/jUND/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24811EDA1E;
	Fri, 14 Mar 2025 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741944169; cv=fail; b=P7JI2LLSjoL73aFR67Bvm0UPC7zUkork/amorbpI9w8RY6XNzyo4Ft2XkApt3JRatDTvFyNFkIP4TiWAMpD4sVSCLRtrJB36bvbRD0v/TZUV4UT5FD3iUXGvPo9/9zfpR9T9nB44+AsTqPyrzlb6stTdscoIzsSWkd0LXvrs8Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741944169; c=relaxed/simple;
	bh=JlmfCIh11PptMTIj6fudoE0ZD0wqoIo2CKqoguclmUw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XTfajQgCszhrtSMqgKicySBio1W1TCCd6OZgXMX005Ni5s2osYQ+4jX4Q2+4lkpka+GH2EnwyGNbVae9/jKdZEXAd9PWDVT6VuivNh/KU3U9OuytxF/VvNjvlaLZejec/IK9u4l758PJJ9K/VGfyuKcB92EaKFLSkB3uBF7XxLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0/jUND/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741944168; x=1773480168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JlmfCIh11PptMTIj6fudoE0ZD0wqoIo2CKqoguclmUw=;
  b=c0/jUND/vSl2H9s0bmZk8h+DcDPd3K56D/dHp+DALanvYegQSE2jjOZk
   1WRGxHOmul6CkAaChTFxofR50b7wK3999ecQMOFzt0oi+SKft5nGxgUer
   ROfzprTjC7vQSVkhaNUIj6NVAObboILZIrMUk+7Pos94QLU9ZZycyLa76
   +zSk3+cJ6LgT4xEypforEmRQNUHhaqe4kqBjDvoa9EhUlvNCuOsBTrsA0
   k804jgeTwd4lyQ85qjRbTky5o3nYyCGhYWXADciN7z4fCNZPvdb42rUKy
   E0L1iOCgYspzlxcZE1NjIvwDoJdDvanFQ3C9Ez9hPkjqaWOqXo7Jtw32/
   w==;
X-CSE-ConnectionGUID: Ju0HI3CUQIyfpPE99QFaDw==
X-CSE-MsgGUID: VKdGDX7TSg2hOxm7uxjt4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="42954823"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="42954823"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 02:22:47 -0700
X-CSE-ConnectionGUID: NI4FXDkwQYC0jxacalYG+g==
X-CSE-MsgGUID: yzAgjdu6SbGu3gQb/SjDwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121413836"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2025 02:22:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 14 Mar 2025 02:22:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 02:22:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 02:22:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4FXjgVC2dujwKKP/puRGqjiHRsmWMpzu97zaC0Jh9tRc74VDWIQ7Trk9EXUBQ+dgeUMo7V4JWaAtxGZ4/CwOxjCWI/cYdTL08J+SeNIKYKwas39aWMqbwHIJpylNXlz+o8CQ2JsE1EQ/7kMLCBYMsZxqh3BGpRDU7G2xfZS6RPgYl73nT1grySv4rN84FUkhtzmRfeShbo8uzyS5OdvrFHo8kI5I2cmL1Mz6z++MaB2yN6ub5evpUWmqukCuxHm69TxAFUkEXoiWRXMHFexVJlKdfrNvQM3ScjLe0jcBSy+08n7uDR+7+8H4kPYG2xouBK93HnKHJGvOiC97HMMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QurpUnSTQo/GeiIaG2CivAPvzne4VePlh+fAUCZaWes=;
 b=h+rsZxIe5776yJyUxNZ6cycHnPbrVvPkpEs4EjLV3EYg8m69BhbuiyIa5kTpp3IzfF0NhqNvFep8LDOHzryTGmAuE9BYRyKFbOPtpW4iOYML6x5aDL2fKTQOFbxMeDoMc9eqH+J3RdT3sBAkKNd9tPKeJ4MLStaFI0svxbez4kDdyHyzRxcsAZF2fAPvgxkP5rE+ukyGtoSsB6oqYFS+uicufDOoi89gf8e+lAOShtqGyyRuFuvZLdjo+gy7cTHoutZ/g2B8bCaMwhBXNayFsaHhL+TRC5rZgedtJrfvU8uY3p1FjTbv++Lm6w36H2qA9aKZzvFI9DSSlX+bJNMqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4888.namprd11.prod.outlook.com (2603:10b6:510:32::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.28; Fri, 14 Mar 2025 09:21:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 09:21:51 +0000
Date: Fri, 14 Mar 2025 17:20:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <vannapurve@google.com>,
	<ackerleytng@google.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <Z9P01cdqBNGSf9ue@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <20241212063635.712877-4-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241212063635.712877-4-michael.roth@amd.com>
X-ClientProxiedBy: KL1PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:820:f::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: 491929d9-04ec-42a7-b951-08dd62d9a7bc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ky9KWf7AX9DGkejEswrikYduFuBVZfj5gHKXTsyQNjqRi819HqnZoVCLif20?=
 =?us-ascii?Q?vfYguj94CX8nZdlEWZNSQTF/jq1v6jE9BDwGIvnpPR5D+dV0neSQfBNcsM+H?=
 =?us-ascii?Q?YsrMwM+Fwq0nIGA7vmT5HMU/QQ4Zn28pkCvrB+RLltMG5kc9iljW1VdNgGnb?=
 =?us-ascii?Q?TJwmTSRA9cLWyB9YkmgIaXK8q+nOFoU/9EsmE0RsoT/OjXMS3TCH1VUWqwMB?=
 =?us-ascii?Q?cMFGVo84IgcbeVbPfMDfuIgtlEuT+C22HARk5TjY8MDgURSgNSVdkVCiOmQy?=
 =?us-ascii?Q?SdMhjFGmWb8W1ZTn/mueSj78AlfoD3lC7ngXNgUHVJfEWZSq/TBOreTke6Rd?=
 =?us-ascii?Q?pISPM4YzDPzazBnu3YxLi/xxnGzBpfQc4z7anGSQ3ItJb+1pkDC+eQ/75Nfp?=
 =?us-ascii?Q?fp0+PJV0GdDQyFKEM02g+PBo3SZGIdjRx4vRof9UjMgQYKdPMq89lskjVBOD?=
 =?us-ascii?Q?zam8nK0anjSPRrs8yj0P9LVVInODBiJglaNKDSCkiGjlTtw37T0ZICjA4XzG?=
 =?us-ascii?Q?XldYk2DOhnFEV8Fek33ttwmi4uwcNyPscCmxe0hsxibmHupj1aDYo9AU4tKv?=
 =?us-ascii?Q?VEhD1xRJkS4e4PI7ysQBc01gIvFZ/XipS5BhpL/tolp6WrLthOkbD3nL/7TG?=
 =?us-ascii?Q?LlzcMvJ/yWfGJn/XSxXnoN5U079fvSrFZE/2myqFRiXSR7/F7EhaZFSZMTI3?=
 =?us-ascii?Q?vOK/fEkt6CfCGASCfmO5PGGminxhd7KTjfhPot0bsaPn7v69QwwRQLPN8uKt?=
 =?us-ascii?Q?Z58xsDtrViGex0Yn75qrvq9WKpdvCEhxRxog21SE8ohGFYwbD6Gt55CF00EF?=
 =?us-ascii?Q?fcqcJn+cinhIN3yzGG3q7i80aeTGjWcr1dweW6A+b4MVqw1IQIVJU8HEGktG?=
 =?us-ascii?Q?nQDyBmuMFjbtfuQ/P4/ok3Z1FGUN/rEOe5s0wjWR/CZQnTTr4TuSLcKsP0CV?=
 =?us-ascii?Q?nrnhqY93q8WzP3z4MGLHNBnsGQJoJCB7hAZs0PNAnSO0cLoV0qHWf3yBoNrp?=
 =?us-ascii?Q?V7eE7JuYk1P8G67r2MRQ3cZKUHAhBSoykNQKrx8rTtZrbgOCn3tOFrMbni+v?=
 =?us-ascii?Q?DjpEO/uAwPld1zogtevSY3H/i2364whEvKamSZEyKDWS8WqQYWdV8SIjkAdn?=
 =?us-ascii?Q?URcpYa6hf143+UslU1w39HZ3T73JRbtc07SVf+DVitBal/7KIaiDN50CsVLx?=
 =?us-ascii?Q?akBshoqwAAeB1FrPVGXVgBPj3Um7+aLkr3AQ4+Is+oGTiI3kyn25CjKs77ix?=
 =?us-ascii?Q?CoosTk7tieifKTQVPUqDC2yqUK2oooHccjaxI7boCdwrnLFD51vmfvj8PnJV?=
 =?us-ascii?Q?GF+fVWS5JQ6lmRYsrtpGoRkdEPZ66cw4MQmjYoPIhhswNAyDFD+Wyc6SEGMi?=
 =?us-ascii?Q?kM+kdSyvsrml2eDXGNgtJKMmwCJ3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?riWLNlIRX0d1h0e664i48GYHHuGHjIgLoOxfiq0IlntHTL23GMNN4ZFQ46gK?=
 =?us-ascii?Q?f6727r5ZprJqYAQAgJ8lDp2jQfIKJ8YK/XvxRIgr/6Lq3+/3O9lR+JN23FNu?=
 =?us-ascii?Q?mD0yKS6hCHw+4+TKeZWX6eVypat8yBd1qvFuAhD00VRpp0EFtvQnJgOM97nX?=
 =?us-ascii?Q?hhud7q5hXhxwGdXNSgDMojz5sd3zKMyEm9DbUbipyS/zNGL8wKwNlqHsOsoT?=
 =?us-ascii?Q?T+mkAaU2Vl0uKb7elU21UnNmkINmQ4ZrJF1FTnxlsbaQF3mr+9jowRK4QajP?=
 =?us-ascii?Q?b2kp4JpS9t2CuJPkSzSDwI6A8Iru/IGWqcle8xeekkPnJ9zF4pLRVeAhIxJr?=
 =?us-ascii?Q?+feGILX7fygBxeZkZCMBKx9pibY+UC/mKevKXpLxY9at6MS8ZW+MfQTzz7bu?=
 =?us-ascii?Q?21aKfYk22tviyhhjmVXI6206mbX/h6Jyt9U/9dRaFoBUeQTSMLx1x/Atqdt5?=
 =?us-ascii?Q?3cT4b7+aV6gmzH/E4fkt8ET84bzhnuELJ4dtUxUAblOxshSMqZAKCQXpFIc4?=
 =?us-ascii?Q?oDhSFCoKp4WM6fnehZboBN0Yhn43MjzmnAAEjxNl8Sw5vGz3TQdHUo9drEiJ?=
 =?us-ascii?Q?u7lxUGUHZybqi3vW4o3eXQOmbmbPYha7lO0EFGvTIOY03rx3FjKAhRQphtJm?=
 =?us-ascii?Q?esLZJvXssmBxYsu0S6MwRG/lyFOZoDXJT47wnbVVexC5butjJb/zZu/tkNWi?=
 =?us-ascii?Q?UhFkvPve/FAnFF7CiMro57bltXLlF+km76sFjvuDZr7ECwqV32UIXoDrVuYD?=
 =?us-ascii?Q?8WTL2z9c8HkoImh396DO1jxZvZXuZRuVc8/s02f4i/aZgTxws92tVNfcWbkr?=
 =?us-ascii?Q?K4dysx+K5qyKFZ4FnGnAk/pz7+BrMw1YNPbempYrKUdzqnvncMbAkJUj/t7T?=
 =?us-ascii?Q?RwhVa8aJSx/QFw5CNZwkt0kfdH9RgfgOOM8FmBd8b46lphPHxmuAR7pkEvQM?=
 =?us-ascii?Q?BPbuEz1PKWb1HU3sEHVDXEFONSmK6cVAxyZwJDhFkzAORNxw55l9rec+qJP3?=
 =?us-ascii?Q?lX6kKnWAf6ONScUFmtK2gR2G8uzqBOHOFRirZSGhwbxjGkEA0wdQMKp9YDQI?=
 =?us-ascii?Q?JFdfqmLlcA1De7AVa2AN4IMZL0SRXBplcVC7TPlBARj5OkG7qcWo+rvIx6jT?=
 =?us-ascii?Q?qHvIrD7tyssW/Kz2q9C0ENfh5kf1AcSEqEmFMT2OcQXqe6HMPMkb0Gzft5Yj?=
 =?us-ascii?Q?Ulh+RZLtIRCIIEXNmR0EXUiBQxPL+IjADSTmutJjw5d4Aeri4uliMw3aW4SU?=
 =?us-ascii?Q?drU1G5gQVXwEcBgnYrPJGeA2CJtBIOoEWdpRDcOgIsc/HKk7EvtkwxwHU5UG?=
 =?us-ascii?Q?OwSaK5kcRgtLJpZFhb8Y/KrM2yN8UI+nDQ9Thp2Fa1m5Kg2lqkVfOevzQeFP?=
 =?us-ascii?Q?Fjf5K412fWXGL8pU04qRnhFQHKZwyYzJ0++NA18TagpdyWjASwEArLD/xG6G?=
 =?us-ascii?Q?AIEvzxDcH0g6925AKcMYNyIaIz9rLL4ocL/0XR4sDga5lg2mlPS4FnW5api0?=
 =?us-ascii?Q?juSP8j+btq3e5ZhUFiBwWEPz0pckSvqp26a2ChxggPICW4FY5+DZTgBFA3VW?=
 =?us-ascii?Q?G2icSpRJ04BaJi26/o8TGtuZrAcr5zDo0w/oRewQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 491929d9-04ec-42a7-b951-08dd62d9a7bc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 09:21:51.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTVBZrUya40cz2pFpig236k6M+Ur872XCzZeWU4gaFXx5R7mXbXD8Q4Rv9G6k9aylFzCUxqC1LOlAbqKslYvvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4888
X-OriginatorOrg: intel.com

This patch would cause host deadlock when booting up a TDX VM even if huge page
is turned off. I currently reverted this patch. No further debug yet.

On Thu, Dec 12, 2024 at 12:36:33AM -0600, Michael Roth wrote:
> Currently the preparedness tracking relies on holding a folio's lock
> to keep allocations/preparations and corresponding updates to the
> prepared bitmap atomic.
> 
> However, on the invalidation side, the bitmap entry for the GFN/index
> corresponding to a folio might need to be cleared after truncation. In
> these cases the folio's are no longer part of the filemap, so nothing
> guards against a newly-allocated folio getting prepared for the same
> GFN/index, and then subsequently having its bitmap entry cleared by the
> concurrently executing invalidation code.
> 
> Avoid this by ensuring that the filemap invalidation lock is held to
> ensure allocations/preparations and corresponding updates to the
> prepared bitmap are atomic even versus invalidations. Use a shared lock
> in the kvm_gmem_get_pfn() case so vCPUs can still fault in pages in
> parallel.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6907ae9fe149..9a5172de6a03 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -154,6 +154,8 @@ static void kvm_gmem_mark_prepared(struct file *file, pgoff_t index, int order)
>  	unsigned long npages = (1ul << order);
>  	unsigned long *p;
>  
> +	rwsem_assert_held(&file->f_mapping->invalidate_lock);
> +
>  	/* The index isn't necessarily aligned to the requested order. */
>  	index &= ~(npages - 1);
>  	p = i_gmem->prepared + BIT_WORD(index);
> @@ -174,6 +176,8 @@ static void kvm_gmem_mark_range_unprepared(struct inode *inode, pgoff_t index, p
>  	struct kvm_gmem_inode *i_gmem = (struct kvm_gmem_inode *)inode->i_private;
>  	unsigned long *p = i_gmem->prepared + BIT_WORD(index);
>  
> +	rwsem_assert_held(&inode->i_mapping->invalidate_lock);
> +
>  	index &= BITS_PER_LONG - 1;
>  	if (index) {
>  		int first_word_count = min(npages, BITS_PER_LONG - index);
> @@ -200,6 +204,8 @@ static bool kvm_gmem_is_prepared(struct file *file, pgoff_t index, int order)
>  	unsigned long *p;
>  	bool ret;
>  
> +	rwsem_assert_held(&file->f_mapping->invalidate_lock);
> +
>  	/* The index isn't necessarily aligned to the requested order. */
>  	index &= ~(npages - 1);
>  	p = i_gmem->prepared + BIT_WORD(index);
> @@ -232,6 +238,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
>  	pgoff_t index, aligned_index;
>  	int r;
>  
> +	rwsem_assert_held(&file->f_mapping->invalidate_lock);
> +
>  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>  	nr_pages = (1ull << max_order);
>  	WARN_ON(nr_pages > folio_nr_pages(folio));
> @@ -819,12 +827,16 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct file *file = kvm_gmem_get_file(slot);
>  	int max_order_local;
> +	struct address_space *mapping;
>  	struct folio *folio;
>  	int r = 0;
>  
>  	if (!file)
>  		return -EFAULT;
>  
> +	mapping = file->f_inode->i_mapping;
> +	filemap_invalidate_lock_shared(mapping);
> +
>  	/*
>  	 * The caller might pass a NULL 'max_order', but internally this
>  	 * function needs to be aware of any order limitations set by
> @@ -838,6 +850,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
>  	if (IS_ERR(folio)) {
>  		r = PTR_ERR(folio);
> +		filemap_invalidate_unlock_shared(mapping);
>  		goto out;
>  	}
>  
> @@ -845,6 +858,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio, max_order_local);
>  
>  	folio_unlock(folio);
> +	filemap_invalidate_unlock_shared(mapping);
>  
>  	if (!r)
>  		*page = folio_file_page(folio, index);
> -- 
> 2.25.1
> 
> 

