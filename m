Return-Path: <kvm+bounces-55582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451ADB3337F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 03:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2BFF7A284D
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 01:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675A120C029;
	Mon, 25 Aug 2025 01:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="krmEedy/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C871B139E;
	Mon, 25 Aug 2025 01:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756084933; cv=fail; b=oS2mL9lpiHbl4thZlK+JI4p8kh1gAz/k1p9n9i/seWfld2V+gXcwakjyeaJVvnumDBwzsQ6A8EMNzTfepxdfUS2wfNu0Zt+hBQoAVGKkCFyqJdvSDDthzVJB8UTHbpJaZ9b8dmYTzTlhnv/46O4qBPFi3i/v5uN39vwrSsO1Pf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756084933; c=relaxed/simple;
	bh=l37nklSL3Jx9Pt+mmHqmEeQzfsVVoksChke1Yx+y4ts=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HKDTzhS6+hyhr+vzfee/pCTBnLkbFkYq6weMGtWXCtOngs+GQ99Nqnpxz2kQl/oUrxTGh2eOmPOXkySeRVl5GvhBXRwPAGSW16am72CNuJhUjAhdOO9AlMV0C8kBoxghPKxVeB+dTdZ9TfS5rvkj4cpUzCv4t4vG8EJYTff+nI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=krmEedy/; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756084931; x=1787620931;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l37nklSL3Jx9Pt+mmHqmEeQzfsVVoksChke1Yx+y4ts=;
  b=krmEedy/xMQ81UjYNvQQMz3nZm5ma8cdbV6M4Asbe4DGNZXHe8FiXVgx
   fviCFZM+/o926ETlrtSCtdvA4HTCgsUBnVZIG1900NyAHhpCdUaj13bg4
   MVrStgjguI0keExea3D7lESS+hbuMoUCeApqMArZ1TbmokhXskrEr5MQn
   AwjfigDRGtZQQ8r3MlAFKpAjYa6STpakqo0AIkjg0ZbnnIVgtGJWIgxa2
   ULN7mmd+BhUCkdv+Sgf+QKUk8FVIrUjRxSR2iRG1C4TVAOK7KIVogJ//+
   BQ6oRruyIbOOO31ftyYNMdgGRkFDeWnY/CkMPDJrhLxJkd7gcwB833Mvi
   Q==;
X-CSE-ConnectionGUID: GUy+5tzEQpm0UTdDyP1BPQ==
X-CSE-MsgGUID: jNQNP4AFRcayEYH5bWigVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="69724869"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="69724869"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:22:11 -0700
X-CSE-ConnectionGUID: jR47hc8TRhqzad4qnN+A/Q==
X-CSE-MsgGUID: EfyTM3gZRnurqZoLaL1LPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168378324"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 18:22:09 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:22:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 24 Aug 2025 18:22:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.47)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 24 Aug 2025 18:22:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sOGBRSBoAKKmBDzJy0rPk8crIOeXBXCS7ioZD/QErx2K4EDIEPuu1UI9CUbv+aJibJpnun7tjpIgygLLlEuI6spkPuhcs+fCzyus0i4crH2vSSPOdm13+LXKI6M3Bt0w+Eo1H8Z0h0u7qW0AV1z4Xn1qadayB6MV7wDF9HNw+uefx0JtkgysWWX9b/LbOuwBQKvtCUoTXuKgvHkAJM5vMV3BQSiBvq2lv8YZV1jdWdZ6M9IV5bWOqG1UOtQm3AFmXwlG925O32UfQmdArDDHwj7+Cf+UsCqnEpBRMsaUjwE8CMHhEr1Qp+2GMa183a2GMIf38oQJhptIYqiIpfsVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi4CZrTtsZtojbdIM8FHNzCAxV7YiCxcFE/wbP+YPDs=;
 b=muQgmhpKwC02vBIxD6BbOK2uakBVWknmB0Ai0rlPf5UfeiZpDSmJyiTJ74e+Ijtor9W9i0TtmfgW5Jdyk2z5bB17Mtc2ywZrnVOGG3TFIjVHDG0h5F2TxtA6N2Lq4DnhLetKdy7Z9wW0TNb/xYrQaaswYzriLBzKlLmWIkKMDCXbhl0NEH3C6aMnVx23kI6hSh8V6U64xTCOtXKWjJONcorH7RhRQFPdCLZONo1713tpLIaawiaLG9brDzwWO3NVtI8s5kSru7vzU0DvJrAFr1OHlP3BCAQYM/Qhr5AxOaeshxqHcem1DyK6QZxlKs02WuTSOzP9uR20yFphgDiBZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4895.namprd11.prod.outlook.com (2603:10b6:a03:2de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 01:22:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 01:22:06 +0000
Date: Mon, 25 Aug 2025 09:21:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: John Allen <john.allen@amd.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 3/5] KVM: x86: SVM: Pass through shadow stack MSRs
Message-ID: <aKu6sp1ikRetv/Q1@intel.com>
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-4-john.allen@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250806204510.59083-4-john.allen@amd.com>
X-ClientProxiedBy: SGAP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::33)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: d58857b8-7f94-461a-b094-08dde375ce11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?52NIVqkcWj+A/AVRntnoiep+vi1YQ+Voay2gdLQ1WX6vR+Hnds98jwOlKeST?=
 =?us-ascii?Q?YhtUQRAX4lx4K+GPyAYKB84hRQhqfRyWayi7hr93bYS52Vq6bwdCPitaYQsS?=
 =?us-ascii?Q?LbRS2ur5ueqDMjnDUCEz9YvMp4FjRfElXxMIQ2VteZeAKXYIpQGxp/GsQuoo?=
 =?us-ascii?Q?tAtORKb8MxF6tPvI2XZzrHde6x9NBhc+qFRa4jO5knW8m9nWQ+9561QzxUbv?=
 =?us-ascii?Q?0kokA7AazMwdMOTupg0tEE+feRVlZGjTgaikHs+rtyaB3CzHfwknorTLOhs2?=
 =?us-ascii?Q?Oa66xQEBeB5FZNtg/n1y2+Xn2y8kkABeCId+345y9RYxNKKL9xDuu6Xj4PZg?=
 =?us-ascii?Q?yQ6jpIVAK2xmhfxPkhCN11z5FVxkRx0o5yBisUCgRsU4G63pG6zCPV3/jhBu?=
 =?us-ascii?Q?kE8IbEI1BMI5QnLeBv3FGdkM9ufR6HhKj55Wna98swEnxwIJ/p09LTQEk/nO?=
 =?us-ascii?Q?JCahGNgkrNRHrUhX0aUkXLY/DrgN6w2yfgi6p/6cajg3FSOvr2dh2FFBQph+?=
 =?us-ascii?Q?TTmFsQyGd6lH1fkjjKfOGA6sHsqGxocnncUYv8TlBarQIL1KHuV/6xx9XN4b?=
 =?us-ascii?Q?d2HkECXTbRQcHdfRCE1N08DwKNBgQeTr5geBjKwpqoxU57pYVfhuJFzPFdd5?=
 =?us-ascii?Q?UHp/us/92pGbc9g/735Dh6mW8DSYOCsSwZIU+r4mWaJa3u7+jhO14YZXTvpx?=
 =?us-ascii?Q?bXTh/4idoI2wr1uiul0xWrxjiZTqLMyWQ7MmTVKotmvW04Op/8ScBRehfIC4?=
 =?us-ascii?Q?ddELb7nqAJEvzmOW6s36sQUZC21UlkKtMbgOJktGyubQJcLUCzllp53ADVvw?=
 =?us-ascii?Q?VFqqTE8Wbe2mUFDE/LBlibUbgR5VKT6cKHHAH1L6e21IOLW+DqAf3Lb5e4p0?=
 =?us-ascii?Q?7VJdqNsmZXdmSXzuFjDqK6eDQhJVcqog06j7O9fZBSl3/Fp/7fd4m2ISQkk5?=
 =?us-ascii?Q?0M5B8K9uhu+u6+GFq2p/kFl195kYzQ4oT92shSXNvJjyQWxoO4Aa9iCQjmU1?=
 =?us-ascii?Q?80Fgkh0XmJK27slukrT5Qk3qZYFcCssM0AagpZhQXpyl0EGl7xLW5waqFlL5?=
 =?us-ascii?Q?2/lDhhbMSz0f3YP6sKweFZMhQ+FwxAvQdITGkqHiJM2za1xQuQUfzodZ9mq0?=
 =?us-ascii?Q?/5wXr3WV6jz1OPd18pohLxLTduK3z8RvxS59YFYYxW1Y18r3ohdQmV5dz3CX?=
 =?us-ascii?Q?FEP/KsE5hdmotsiHg0sxP4XEIzvV5Kln3jImqQLQeiQpqb/sJ8igoZv5o650?=
 =?us-ascii?Q?mg4OCTcFC7UVqV4on8OqyaqX46CzWgs5LVaB+pNZlyZmUw91/LU0Pan4tTgm?=
 =?us-ascii?Q?J2Cs+A+FoVum++G1Msbi69UMqWI0gKQxlMo4exS9moq0JoUw+xrEI+Qk9HFr?=
 =?us-ascii?Q?7bQCU3otzmCOG5jufYQuPZFRcMe/sHucUWAXsgDWjBli0rJYlH8u98wv5D1Z?=
 =?us-ascii?Q?gHTAnP+rmQg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zk1MiKXy3Gj84GVJC374saudbKZysdPAO7EbZ0bS1nkfqPnuc1aCah7rfEJ3?=
 =?us-ascii?Q?o2cd/W//T6W0UXBDd2TZiltmZiOjB3cNKN88ThrdbTFlinm7QV0TFBTBXk8B?=
 =?us-ascii?Q?w8lHbA5eGazbjtZGOdkMyMQEWChlO7yow0W/iVw3mohXrX3I71jpd15qJG5R?=
 =?us-ascii?Q?A1m095yna9Y5m3wWOG+2B3ePEZKjj5Y4GryEK68D5V2xRNjM0VvvwtJTGcVF?=
 =?us-ascii?Q?3E0w6Ga6USjAJoBfPGsvTRlLXPXPzHehlfIjEr9C/2Z2msu26qQflapo8T0Y?=
 =?us-ascii?Q?VsTYAGJzfY4bvUng5FfLP2XYf3IME25gW5XT7Qxp9AhkJS2jGQ5quB/nFOBJ?=
 =?us-ascii?Q?z89ljbhbd5CJiBvYEULYET+LqAdiSbUHYc/1R8ZjaF6moonlO6jnOe0W+rTQ?=
 =?us-ascii?Q?xbFqxEYzABHtbskjnsf0GR0Dm5T2F+rvlZspy7i8sKiX1WME39ANXUrq3WCK?=
 =?us-ascii?Q?3b03dxSSOOtzOZB/G4S/b05BDRuihdBDFIyJD0nz01FNGWyAkwElfy8r81XR?=
 =?us-ascii?Q?zrfair2oklFCeHMmEfB9Ai4IFVqF7oyKNgptxuSxS5IXEcVFZWi9/aSojoq3?=
 =?us-ascii?Q?Qvl2BtshnDpLevM0Qai1ORr7fUKrmghnFT4X3Cv14fyai9UQD4Xx8g7zF6qp?=
 =?us-ascii?Q?g5Hm2xbeDFQvmCimDdWYdxoqtHignQLXXcKios/OntmxPbgHAQaCFfRpR7Ge?=
 =?us-ascii?Q?Hu6Kfmd0BLdBVizg3i0vA+WAMzOJUSFz+oCH4F2fVG57ucjxIE8Og+bKMap7?=
 =?us-ascii?Q?gLbPYwHr6xajGGVaGpHq5DJzdAIrNqWqRdCp+YIsNrM2Qp+4AVC0dZhNV5tC?=
 =?us-ascii?Q?hfOcbpMyD+7OAVSu6sK3t922J8EMLncyVVVi5+Izb6ku6yOHjSrY7ijjawlV?=
 =?us-ascii?Q?r6kMK57kEdkYAT2D+UBKmmfNxvrCqItg3c7qjjqSQeH/FStYhEuPwJ9Yx/qp?=
 =?us-ascii?Q?Dd92X1RiH31fuu8aZ8PRr41jHddICRGVL8x31rx/0bwPw1kBIkyxosOfTAAc?=
 =?us-ascii?Q?u1vg8D5pR5RXafIYflngGJUPMBLvFHGILEEY0W7dSXOpB9PzEtog29GAijib?=
 =?us-ascii?Q?x58jKVK4gMLNCEgP52n4MOoPbs0L6YHjc0d1ynOcv/ZnEFUFBeJ1lMkC7Dlh?=
 =?us-ascii?Q?pU0Vgcn329RzMz26NKro1lonc4ntnemcFZimpvKZ53743vToLhTG9ButzeJ0?=
 =?us-ascii?Q?LogkaamAURMBeklfrDJzdTtY8KFJ2H0bxU/twlfWlKZZ5tZbCzMTtrJN6ipk?=
 =?us-ascii?Q?Cd18z7wkPY1epIwTT8GZGiLATY0jLe67jNsCeBBryTJn3PSqfpdfGuLvVH1z?=
 =?us-ascii?Q?nFOzY6KGxbU8QxGbT2YHq1b0qsfbrhSTow8vQih16retMl1vPcat+CyqOswq?=
 =?us-ascii?Q?yk1p8As6TY5KAKPLdQzGTcgxWVRbOjsvSU/c0vQDtd4co82XH8HasohqvSVj?=
 =?us-ascii?Q?y1/eUEht9ojUrjzb7zdJb639kjdL7URl5tOaoSlp6swrdzmEq0UPPE1ZSwE1?=
 =?us-ascii?Q?DDAB9df2o1ccrIK6iHM4xfNvWBBf64Du/AEQX2zsV/m1O5jrNzUeT4mO5h0m?=
 =?us-ascii?Q?10cKICwYYU7KZTkRltmXUf/IxbnS8oybwD6xoK6J?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d58857b8-7f94-461a-b094-08dde375ce11
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 01:22:06.6535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nkFXXKypTdSuGjZDBwbNl5zwTfoYHQFYQnARvKN1ssU2TMJM6gizsacOt+//sxF11nRMMuBPlayZ1n8k94Dqmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4895
X-OriginatorOrg: intel.com

On Wed, Aug 06, 2025 at 08:45:08PM +0000, John Allen wrote:
>If kvm supports shadow stack, pass through shadow stack MSRs to improve
>guest performance.

The changelog is a bit sparse. Perhaps you could include something similar
to what I did in my v13 version:

Pass through shadow stack MSRs that are managed by XSAVE, as they cannot be
intercepted without also intercepting XSAVE. However, intercepting XSAVE would
likely cause unacceptable performance overhead.

MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.

>
>Signed-off-by: John Allen <john.allen@amd.com>
>---
> arch/x86/kvm/svm/svm.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index a027d3c37181..82cde3578c96 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -838,6 +838,18 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> 	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
> 				  guest_cpuid_is_intel_compatible(vcpu));
> 
>+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>+		bool shstk_enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
>+
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, !shstk_enabled);
>+		svm_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, !shstk_enabled);

MSR_IA32_INT_SSP_TAB should be intercepted unless there is a justification for
pass-through. See Sean's comment below

https://lore.kernel.org/kvm/aKTGVvOb8PZ7mzVr@google.com/

With above nits fixed,

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+	}
>+
> 	if (sev_es_guest(vcpu->kvm))
> 		sev_es_recalc_msr_intercepts(vcpu);
> 
>-- 
>2.34.1
>

