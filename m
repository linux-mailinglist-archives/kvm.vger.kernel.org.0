Return-Path: <kvm+bounces-68858-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOh9AoLMcWl1MQAAu9opvQ
	(envelope-from <kvm+bounces-68858-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:06:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE236265F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B84054FA28D
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3576347DFB4;
	Thu, 22 Jan 2026 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="doqmJtCc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60533D6460;
	Thu, 22 Jan 2026 07:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769065582; cv=fail; b=M1xV7mI362VQYbe9sC9ASFD/tL/TvkCHNTEWwhLjv+yD+UZdpG3ebrKf/s+3+3LMea4gD1+wDE0/pzMY0+h8aBDVNLXnAOMiG+3RC+pKXLGKa3yqfKrkVyU4gpwh3UOdSvjMzSPHFv/1itaRUbafkSWoCDc1B4RGnUDOQl358lY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769065582; c=relaxed/simple;
	bh=W0Xjmt+RFX7UMv8l6pxeOcjsEjwhVA1+YYkZwb17MpI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a/eeUHwVo0Sg06tptfRZ6Vzn40vw6PqFKJ1t6SCHsOlH4qVYNWbsxjaG9vWIvoRMZ1Pq56jFMpEjLG8kVfD+hnt7TwRlMwToAIK3o1VGzYw1UCyZ6rjmWcFqjyYp36GT27Hp6PWAeHnR6vqeXKGllLnHxRru0y8e2ICqjuAnxC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=doqmJtCc; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769065580; x=1800601580;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=W0Xjmt+RFX7UMv8l6pxeOcjsEjwhVA1+YYkZwb17MpI=;
  b=doqmJtCciNexZKwIVjqs7jwAh9mx8WheCaGJmZlk2+DEkwd2x/I5rbXI
   G54TF9KkHTar0OmUqgHtoO4CNL5XG8+kOL11qvs3+4VFoIv39HrVAMrXZ
   VeWVRT2KCFMWKzOag6eYdjRAvsvz5yAmCOM15x53jPQ46a73+s38DTBam
   wowQoLlpvCcshzpMf7Gr/I6bkT0+lwjISXwmIUtnfxuZvrF7zN8zZCnuZ
   nFgDD38BqXfGGKfy2h3y5IwRuB2oiQtpck5Heu0NBJ66zqsUWsLAd04ga
   dJ11wPWZ2ChA/pTidInsGTIY2D4d5R1Zh9aw0sQeaD7Ul3VUQy5DoQbM2
   A==;
X-CSE-ConnectionGUID: kV5nCjpWSp+KLC05aIZpRw==
X-CSE-MsgGUID: qyRpuEXhQ62kgxqpkUpnbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="81020389"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="81020389"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:06:14 -0800
X-CSE-ConnectionGUID: UmwTk5CSRzabc/82/XJuHg==
X-CSE-MsgGUID: b32xZp67RZu1UZhuNsAonw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="237921089"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:06:14 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:06:13 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:06:13 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:06:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQaffZzWuqhyQ+ODgn64cy8F7N+XhOQzd72cHLM5Ez/mylE0F4+kOkQnPo7Ruhb7nuJhCh2XQ9ETZ7JCVZZyRlsLX+CM3BviUO/ZxDqg8FBNtC5zEcXmRPGnSXxQ2XM7wDmS8tMnRh7M3CBja/dibvKjRgkBRyoNLdhP1OboZvz3FlJDzybG21Iu3wjQFkycAZA6oQ11zZSlCk5y6R/9DGJkKZfXs0qbivSQMLllYNDdKnHidO6n5cwVYV2Xk2M5RmomVltMJ4pmND68/f03rCnOmeJC+v/MItkzpjUQL/HW5AY13mXSXykPHfSItOupPRpmPJKKGgmUsTv7HgIhcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpDNISvmJKfH+wT7JOp0mfid0X9cOOMSZqeFqV6TWbc=;
 b=Tkim0xMTxj92pg3SP3wHvRk1qCJ5vVsDpgdD4DCIJRACY3SEaUd3yvbWhBxKM6nuoVbnBtvX5j/0G0XcsPpwFf0vTQNw5hB04XrtE7BujtJ5Fjc+0r9OCHFH9KH2P/fvuJOc4Bpe+btZmjLv/o/8IDeeP2BxEJNHMjTfvTvAPsiyFlsmvZw53BAYsk88VE4PdDap4VmsbGu3mb4hl5EaD3cqZqkg5JXm94ZvFZlF1ILFW0nWhc/8pju1AqbttPzC+4eeJd9voRgqjUqpHPrmVUH4sm2TonI8TPLX54imnLDuctpnLue0UVu8p7J57wciko/N043MWHvsYjmMGENQzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PPF213267FEE.namprd11.prod.outlook.com (2603:10b6:f:fc00::f14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 07:06:06 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 07:06:06 +0000
Date: Thu, 22 Jan 2026 15:03:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Kai Huang <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du
	<fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao
	<chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org"
	<david@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Chao P
 Peng" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Message-ID: <aXHLsorSWHRslpZh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106102331.25244-1-yan.y.zhao@intel.com>
 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
 <aXENNKjAKTM9UJNH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXENNKjAKTM9UJNH@google.com>
X-ClientProxiedBy: SG2PR04CA0175.apcprd04.prod.outlook.com
 (2603:1096:4:14::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PPF213267FEE:EE_
X-MS-Office365-Filtering-Correlation-Id: c96a1da0-6449-4e20-ca6a-08de5984b655
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jd1JRsAyC8fpTjq/quMC3j9Nl/JuMC1xrHth8ue71i4hSYZ5gCDzxd4cCd/B?=
 =?us-ascii?Q?JHE8LTgBlvqxPwagp5Gbe7j0bcp5GlIkA8KXlXUeEGNOnEvnuOlgRLJ5fsqA?=
 =?us-ascii?Q?DoyuAE/eVtgStL7ti8YiIhP4zWEZTRKb/+IYtxhS5SVjaTMAm0HUmqfCLCc8?=
 =?us-ascii?Q?KV/oQiW9GKi9ApoiL0d+ioXIPw+1EiBV+6al4KCortf5tVya8xzgid9Z5zzu?=
 =?us-ascii?Q?t7rpwKQrCV2sciS+m7qiM8sJLVFMDk8Kx5d0vfOpiFo+Yf6NTkqACeas0zKY?=
 =?us-ascii?Q?bq9SJafDcvKi6uSKsdT+lRP7cUsabzrfjKsyI0x7S+Uj7zwhstVuM69RRxrJ?=
 =?us-ascii?Q?xs8dHsIDFV+Yx7Vkp6zOj1dumdaqiUeiUVAxJsDveBn0OSu0YLi7cLV8nGAy?=
 =?us-ascii?Q?x6YvtVgFJ3zgA1lrTr6l92wezUAca32rqP1hI/1f0izDEZFEHhVUIjXY/dxq?=
 =?us-ascii?Q?83LgIxWyTRZsm0BC7S01TyL/n76TVgL8zWXIBTM+J9H9KcdX9pRWFz7+8SgT?=
 =?us-ascii?Q?8vwMT50n4JPktAOw1SIRsDW7+qrK6muNJy98HjQbgGHOcyEmu7hkJHGqm8oj?=
 =?us-ascii?Q?+44YunZ/aulQ8IXcbcUurAc7ZODpjOBPQDAOVvuI3IFQ29/xNq6dOK91g7ls?=
 =?us-ascii?Q?uLBdsxMdKDKNC7Kao3z8hwG6/6FwzopAmePkvtci5hRDIDBDTScQ10Y8uFE7?=
 =?us-ascii?Q?uTxObLqZVlcSoQEVR2F5kGu2Rvf6cwkObMPajN81M8P/tSY9mu3m0SWRfAPG?=
 =?us-ascii?Q?BMhlb9hQKB5HpFFr4kcuOCSvy/Z2yduEYyHMEkC53JUcYItlOiojlcMnd94Y?=
 =?us-ascii?Q?f7FjFC+R7ybdkKxrIGj2IVjTEIqAFPiFYd0rlopSJQ2yBZD3F9h71VW5HKL7?=
 =?us-ascii?Q?d0a6mDSUXF+J0OETTbkuHwCRu/jdr9ZGTmyqAxx2h02Cw9TDd0j/EGfyE8Qi?=
 =?us-ascii?Q?Frh8X7XhLY4V6MvSSBX1/eOlKgXD/ZPJp7fe6LaHi+q+tnKYVXk3m5UUvEr9?=
 =?us-ascii?Q?Hpvyzj9J5jSvQnOTt/27yeoXKHqsIrn9e70MZ9KJSln6wcQLd9SX596pnetE?=
 =?us-ascii?Q?WniWTPE6YFs+PYwOeGQ323QeEUja6NLQybMF8ASWjgR7rnznfdGmqjlWrfJW?=
 =?us-ascii?Q?KUIggzIS8CU0sT5ApaGTqMhssLjbc+dkYOvjzVf4ZIRiG6sRire7M8tiIOwC?=
 =?us-ascii?Q?DqMHCyKn5nB1GTQJOEsZcK2quhevuUNRLSooYc2dKuwKE+BfKFxXPe4sVEEX?=
 =?us-ascii?Q?/knkYpoYYgLmJDOPYIsOlE1iMhHkMyikYEqKHmNVdw53u5VP7Stftw13ADsB?=
 =?us-ascii?Q?0X4KOj909IJXOQOu2UHU4nnK+djE93VLam2gTZqOCGrP25uPfNyYvGNKkB1g?=
 =?us-ascii?Q?sNYM4jsAFij1Rmu92HPcuNFkMAdFFc02+RWk9Gls9MQDr7XspdIu13Pl8vYO?=
 =?us-ascii?Q?7FCjo7ENoUtKJ6jmtshdj/BdJ/uYbtgK21+QPeVqAy9BjJ1wGPKyD+hzcOUg?=
 =?us-ascii?Q?T2hkV3m4TFV7u8mNHj+guba4T7LtpbmDAkQRbU+FpZyzhq5sOmhFBIUxmkbW?=
 =?us-ascii?Q?F3bh6PY+ND+8qeoWLSA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0LBeF4yjFwQgQMYNxrNhjXoh2EsSDb1i8xuYZm3RQoW2HeFQXc/lH/W29Vs3?=
 =?us-ascii?Q?v/eFTwdFtipa6NTCI7NBaHLYI86u2QNnFoTDyah+tkb1lDOYztXSoygXWfCv?=
 =?us-ascii?Q?+c0JgcXvMd4ugmyTqkHjxNKr0tazGX9ompWeDnDxETmEX5nMJ6RqYYUOtjRF?=
 =?us-ascii?Q?Sd5hGoqd9NqWHLFsWD5+75G/4lO6fLsFSnnrSuDDIWUYCVe/Admu6LIMEFba?=
 =?us-ascii?Q?lbec0YozLNTn1KpSBIX3m2YX9jh0Ndc/ukhptXyWeBVRHZw53wL+Lgzog7iQ?=
 =?us-ascii?Q?a7ErsBtwVErruGqQpJ7JOJwfWdU+paw57Ob8yH+6n8xNHEQ4wOCSsqzjn5JG?=
 =?us-ascii?Q?Yf50bYtaLyZBUiRIngkryhcsoF5MInWs1NqSrlWC6JRQd9o2qat4W95M9wjT?=
 =?us-ascii?Q?SauAm1m+DecqZuPeejd6srxsw5Tj1cD7UoaOjfN61+S0/gmy0yau+8Mwlaus?=
 =?us-ascii?Q?Az6Zc6K2yqBD2ojh24zTT+9vGLOWX3vSU/BbKrrpVRXZWFoaVZC9mpyJq74x?=
 =?us-ascii?Q?5N34paoP979vqaVtYYkhfkPDUSVuSfFtJDjulpDUKP+aXOZWAiKOJbVeHgcA?=
 =?us-ascii?Q?bho3qFC9Gdpozbv+JUG8y4gPwBwXEhmy7iVH9V7qZoJOswP30zGJl3b7gGrX?=
 =?us-ascii?Q?wgVa2O4SuXnn1j3zcjnM5XNoo2F1yUDXcntr0Z8qdhd/5NwOxSu5Le9r1Sru?=
 =?us-ascii?Q?EdCpGVLkTu6PXjQGWTHwAlFhb2RVRv2dZg+1fx7SdagAqUl5QuBuTXTonpOo?=
 =?us-ascii?Q?ImlSGkrHIFIb/kKz4ugBrkycoah1J3eETiLwgFOukVs83UM2CIm5CMEx0MCs?=
 =?us-ascii?Q?fLwslVPUC40FNBxzI3z7+z66ojLC4ms4cej7Z9JbIQbhlEcDNwYAUc7ttQnA?=
 =?us-ascii?Q?aRjXyLDzcEiy9NTdLiroFrwx6jdjtJUzEj1zT6ALo7JqR4xkixM9ZGsCNgp4?=
 =?us-ascii?Q?5CKmneR0jTgNUnRugDCYIHmgaIuhD1Xl6MablTI2P8k6C665E0kcILuCd2sL?=
 =?us-ascii?Q?gIodFnnGE5tUy3+LdJBV7qVEnaKwqU6R1GXfMPcU6NDsrDtYAxn+TL2qC7Ob?=
 =?us-ascii?Q?omhghPORrRMvTLzIfiPaFkCgGCAelvuS3jvxqkN656jgc/UMDzLWO18PnlPV?=
 =?us-ascii?Q?dtqX0xC0QmJBZtCNJWOMS4jSohmcMrBtfmcwiq88uHgCumjFBPBsm47FsQ0b?=
 =?us-ascii?Q?USLMFQm+SPIMbXokEsO8iNiRsb/BY/TpsBjSDevaBeIVeKTQgRYWPxnzp9Le?=
 =?us-ascii?Q?DWLBymh3vFN2mSmOFb6mK7D2vrzlFeAWkQUGQhSEnXvlpytqi0rYtcT/u2cC?=
 =?us-ascii?Q?M1L+02OUQzMHamNc0XP7bUtIInlA4bLnEhmFy5QuRjd75rmW3KkrwmqCA9vR?=
 =?us-ascii?Q?4FGiG14GH7+m17P78cYo29i/Y/UQlvi7MBU2i+wVVknK+Ntf4iVNJyHqBW6c?=
 =?us-ascii?Q?E0woQ5XuHbx9vlkmRt8g+gnJfEnW0LFSsGoctOANt88xlolQb8VDv8ooEZ2z?=
 =?us-ascii?Q?5NTByIzsWxTSxuZsn8GKFRoFw9C6NkzuhYyezDkZz4HWnSBFW0G3AWPA6lvp?=
 =?us-ascii?Q?mlLwJOoFNgq+uxI0BbQzoWMr9kkOv5rK2Gw6maF52n8mg2BFX21lACSeoaWe?=
 =?us-ascii?Q?kPYMX3aCfwyti1jhSwXE++JEhaWQEOirSVZ3MvoW0Trx5gK9bSInIHRkRWWJ?=
 =?us-ascii?Q?2jgRQ15fBNSoB97ulzvwlFd6qzTos+tmurbIjHlKO0bZKHAnqDhtMU/zlXy8?=
 =?us-ascii?Q?HEUkd9FZng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c96a1da0-6449-4e20-ca6a-08de5984b655
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 07:06:06.4442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9a7NAqWyD2Gbz2RdEUuzPo2rX+QbyodSJ31UbBdVSjpRhOJ8lBO2S1ZzmqN44mgMlt4JMhTiahXhS2K5VOPJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF213267FEE
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,google.com,kernel.org,linux.intel.com,suse.com,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-68858-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	DKIM_TRACE(0.00)[intel.com:+];
	REPLYTO_EQ_FROM(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,yzhao56-desk.sh.intel.com:mid];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6DE236265F
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 09:30:28AM -0800, Sean Christopherson wrote:
> On Wed, Jan 21, 2026, Kai Huang wrote:
> > On Tue, 2026-01-06 at 18:23 +0800, Yan Zhao wrote:
> > I have been thinking whether we can simplify the solution, not only just
> > for avoiding this complicated memory cache topup-then-consume mechanism
> > under MMU read lock, but also for avoiding kinda duplicated code about how
> > to calculate how many DPAMT pages needed to topup etc between your next
> > patch and similar code in DPAMT series for the per-vCPU cache.
> > 
> > IIRC, the per-VM DPAMT cache (in your next patch) covers both S-EPT pages
> > and the mapped 2M range when splitting.
> > 
> > - For S-EPT pages, they are _ALWAYS_ 4K, so we can actually use
> > tdx_alloc_page() directly which also handles DPAMT pages internally.
> > 
> > Here in tdp_mmmu_alloc_sp_for_split():
> > 
> > 	sp->external_spt = tdx_alloc_page();
> > 
> > For the fault path we need to use the normal 'kvm_mmu_memory_cache' but
> > that's per-vCPU cache which doesn't have the pain of per-VM cache.  As I
> > mentioned in v3, I believe we can also hook to use tdx_alloc_page() if we
> > add two new obj_alloc()/free() callback to 'kvm_mmu_memory_cache':
> > 
> > https://lore.kernel.org/kvm/9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com/
> > 
> > So we can get rid of the per-VM DPAMT cache for S-EPT pages.
> > 
> > - For DPAMT pages for the TDX guest private memory, I think we can also
> > get rid of the per-VM DPAMT cache if we use 'kvm_mmu_page' to carry the
> > needed DPAMT pages:
> > 
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -111,6 +111,7 @@ struct kvm_mmu_page {
> >                  * Passed to TDX module, not accessed by KVM.
> >                  */
> >                 void *external_spt;
> > +               void *leaf_level_private;
> >         };
> 
> There's no need to put this in with external_spt, we could throw it in a new union
> with unsync_child_bitmap (TDP MMU can't have unsync children).  IIRC, the main
> reason I've never suggested unionizing unsync_child_bitmap is that overloading
> the bitmap would risk corruption if KVM ever marked a TDP MMU page as unsync, but
> that's easy enough to guard against:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d568512201d..d6c6768c1f50 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1917,9 +1917,10 @@ static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
>  
>  static void mark_unsync(u64 *spte)
>  {
> -       struct kvm_mmu_page *sp;
> +       struct kvm_mmu_page *sp = sptep_to_sp(spte);
>  
> -       sp = sptep_to_sp(spte);
> +       if (WARN_ON_ONCE(is_tdp_mmu_page(sp)))
> +               return;
>         if (__test_and_set_bit(spte_index(spte), sp->unsync_child_bitmap))
>                 return;
>         if (sp->unsync_children++)
> 
> 
> I might send a patch to do that even if we don't overload the bitmap, as a
> hardening measure.
> 
> > Then we can define a structure which contains DPAMT pages for a given 2M
> > range:
> > 
> > 	struct tdx_dmapt_metadata {
> > 		struct page *page1;
> > 		struct page *page2;
> > 	};

Note: we need 4 pages to split a 2MB range, 2 for the new S-EPT page, 2 for the
2MB guest memory range.


> > Then when we allocate sp->external_spt, we can also allocate it for
> > leaf_level_private via kvm_x86_ops call when we the 'sp' is actually the
> > last level page table.
> > 
> > In this case, I think we can get rid of the per-VM DPAMT cache?
> > 
> > For the fault path, similarly, I believe we can use a per-vCPU cache for
> > 'struct tdx_dpamt_memtadata' if we utilize the two new obj_alloc()/free()
> > hooks.
> > 
> > The cost is the new 'leaf_level_private' takes additional 8-bytes for non-
> > TDX guests even they are never used, but if what I said above is feasible,
> > maybe it's worth the cost.
> > 
> > But it's completely possible that I missed something.  Any thoughts?
> 
> I *LOVE* the core idea (seriously, this made my week), though I think we should
Me too!

> take it a step further and _immediately_ do DPAMT maintenance on allocation.
> I.e. do tdx_pamt_get() via tdx_alloc_control_page() when KVM tops up the S-EPT
> SP cache instead of waiting until KVM links the SP.  Then KVM doesn't need to
> track PAMT pages except for memory that is mapped into a guest, and we end up
> with better symmetry and more consistency throughout TDX.  E.g. all pages that
> KVM allocates and gifts to the TDX-Module will allocated and freed via the same
> TDX APIs.
Not sure if I understand this paragraph correctly.

I'm wondering if it can help us get rid of asymmetry. e.g.
When KVM wants to split a 2MB page, it allocates a sp for level 4K, which
contains 2 PAMT pages for the new S-EPT page.
During split, the 2 PAMT pages are installed successfully. However, the
splitting fails due to DEMOTE failure. Then, it looks like KVM needs to
uninstall and free the 2 PAMT pages for the new S-EPT page, right?

However, some other threads may have consumed the 2 PAMT pages for an adjacent
4KB page within the same 2MB range of the new S-EPT page.
So, KVM still can't free the 2 PAMT pages allocated from it.

Will check your patches for better understanding.

> Absolute worst case scenario, KVM allocates 40 (KVM's SP cache capacity) PAMT
> entries per-vCPU that end up being free without ever being gifted to the TDX-Module.
> But I doubt that will be a problem in practice, because odds are good the adjacent
> pages/pfns will already have been consumed, i.e. the "speculative" allocation is
> really just bumping the refcount.  And _if_ it's a problem, e.g. results in too
> many wasted DPAMT entries, then it's one we can solve in KVM by tuning the cache
> capacity to less aggresively allocate DPAMT entries.
> 
> I'll send compile-tested v4 for the DPAMT series later today (I think I can get
> it out today), as I have other non-trival feedback that I've accumulated when
> going through the patches.

