Return-Path: <kvm+bounces-23288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF09948651
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BE9B1F2202F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36BD916D9DD;
	Mon,  5 Aug 2024 23:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZPmqoDZo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9A14F9F1;
	Mon,  5 Aug 2024 23:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901556; cv=fail; b=bPew64ubtCCWunNUdrP37j6dkWd3gUDgWBcc1xjbj9OPJXK+bZq5SY+KLXGhi1yIZbhEUdlnIF+8ABsg0F+WWomNycQDMd5YC2l5flgu5xk66oeqDbqJigFB8+jAL3SjFNbSw5NvT+MPIeb7YCDOTFEOlCDTIFCZSB9xBWTum3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901556; c=relaxed/simple;
	bh=EydnIt+HG3eQ8pLeXvQA9jvtl3AwnTHevybwaQDqLZM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NS3o2gV6JpKhELVMACu6ruD+EeWKdZ6MrvWt+SHggZGz+iQp6GdDctPXd7shkKgDMzSGkVg2syY2QgZy42yfgzlGcvBQwdAE2Ijjbp1JSTLGww5nNwZknw8C74xFoNdkA57PpqEjfXxPtBFdX/BblHf7e+ubTunlPdXtvF8xZJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZPmqoDZo; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722901555; x=1754437555;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EydnIt+HG3eQ8pLeXvQA9jvtl3AwnTHevybwaQDqLZM=;
  b=ZPmqoDZokefm56zpRKycXJTHF7rHZaR11EySahXTsLTSynw0VL25Fkb1
   UrJSiS4X7opVd6wcJI/90Xmgs5ov+yhyUAA9/XmDHQ3Miajl1g+PgPT8P
   Czp2pGmPCxnkUdx+jcnBrm4ZPL1YdTPtrQdPDfcxYOGmAiR+DKk68o8oQ
   Pz9fhW1TchNC0rAs/55Zpw5zR0jjxmqGjV+ySXIz1MJLZ10iuN1fTCAEu
   hXLOMOHy4mLd2+1viWSeYNwl/ZfDv//k6d1SsqER4HjAmNlFU76ahxUSu
   mI//CRaGp7etJQb5mfVemrF7xL9/hLkgStTOAPz1GFwH+Z+nSxHD3hOFb
   Q==;
X-CSE-ConnectionGUID: Lpn9Zm10RquslQvpsRrhvg==
X-CSE-MsgGUID: fQjaM65eQUm2gz3Vb6boOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="24657980"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="24657980"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 16:45:54 -0700
X-CSE-ConnectionGUID: EE7uycpzQym+a7M9N3DvmA==
X-CSE-MsgGUID: +cEpuycrSde/pKefzyU+EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="56248030"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 16:45:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:45:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:45:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 16:45:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 16:45:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNAgDgcnoiTkhHhAPdnqgMsuCFMvVyeo1HCINoYM8M3KTfjvHVnMoAxPLi7AqLlW4XKuc8BcbZ0yFgWFsJ/ESgy1mlm09uKJ3QgO+CNByB07P3vaCCn56bzOgTriu7XD15PuR9BqROKZfZsHgvTjv4LOtc/0JdJz6vnW0mqtQaTpdlg/mQUkBvXF/NY4LL3B43LvJvKXA6TeZFn+Ynrr4bsqv2r4py22iK8CjsQlcxBNkkFRs5ELzicth7mumEAyZ/DCmkXRRwZoEA57FoVBnsVIpGPbbYIwHL/ZHnYGCx3A/8eWym7SuzkK2XdHUPeXe1heOjYY19fSOLgJm/qzvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeKshAcqALGh9F19fV4srKkrP5rne2qVbl7lmFwgJ5M=;
 b=bhZC0eub5eXUY0oRU0+rv4+mCopo+5GMcR07dhsqNgsLCDMvOwQGtNGkvl2VCG453T8Hmh3GaezwtpOaCZf19j+vUn6D+Mw0YWY72Kf7cCR3GkBjSqIXX8SRAIOSHC/MvrHEZQII9AkjpiV0Wxwxsq1cUrHEvVnaiXrlqwVygsGvCRk+fsaA3ic4CQKh+wgsLYShwBfUOhsYFpgDD1ywnuuj67K80BUHAYPit2orHPVufD8VAF2BvoycFsFuFg2dOOVnbAZbQEl9MEqrS2obXgA30Gt3tAtbq6yoyso6r1nEtEYzSgt+866r7EmnKYkyrL+LESnRSNzozeeIry3f7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7549.namprd11.prod.outlook.com (2603:10b6:510:27b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.33; Mon, 5 Aug
 2024 23:45:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Mon, 5 Aug 2024
 23:45:50 +0000
Date: Mon, 5 Aug 2024 16:45:46 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 03/10] x86/virt/tdx: Support global metadata read for
 all element sizes
Message-ID: <66b1642a825e7_4fc729449@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <442637364b55c8a721f72a201e838eb5c271e0eb.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <442637364b55c8a721f72a201e838eb5c271e0eb.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:303:86::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: 33747b9c-46ef-4bad-e383-08dcb5a8bc6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qOaEPCyG8Me4YbzXUtb2mX+az7JOVPzNEk8lFpPeKnSQ9nVFCTSzfNkNUOpL?=
 =?us-ascii?Q?9obGSyZqEp6nxL+h2MAL/9TnQ4dAgH5SIunPL+U79/0XdsMBMtKbH7OGjjfb?=
 =?us-ascii?Q?ULz/6HdN9X7FBa4+e1K0ypUFrVrQlUKx9PtRUxuunp+2dYoOBCHM9MR7A026?=
 =?us-ascii?Q?b1nDJNgFKhgGt9PRGnpq13sDU7Cwmkz2hA2iIXkbSKR7aA2emsnc3NDgS7Bm?=
 =?us-ascii?Q?rrz0i1xd7w0dGzulsjGt5QAJt+zKUC/3l9Sm8uoA1c13100UzszHkiRdC/T6?=
 =?us-ascii?Q?xkan81ot1b93dX4H7QSnmk2hGTUM2luZQa5klMuO8j0zACo9UgH6LEDngmGi?=
 =?us-ascii?Q?ifuMWPf4ya7r/zzR6yv6Rey3j0q44DCyqdiSrA0R8GMvAA5oJR8os8XjGXAZ?=
 =?us-ascii?Q?8EcxdPl8JKN4UOCmxHt13HYXCkyz/kIpvNAFBxQ9YeE+LRMORo7pgpAMt7zT?=
 =?us-ascii?Q?dTAiiPglLDPJu5Y3lUvWDRXeA69KIMrKTUP6NlwVVmglVjFcf8hVTn7v+FH5?=
 =?us-ascii?Q?OZSQcTu3fTfcYyqDX4y1uPLbX/RTykGXfdPC3SRlTeFEIH/4VosJPw72B+Ao?=
 =?us-ascii?Q?M2SmuVoMSCOHolNTOesqDbEjZjNZqbNOyWoAgtLVSsFiboAYlqeV/ronfhF1?=
 =?us-ascii?Q?Kgd3ZxeGjc/WHNHbG/eJOFURD0RhxhXjJLz8wYy2KFH1RWP9qMSqSbyL9OKJ?=
 =?us-ascii?Q?dg6zxNghs1b1dl0xUq26FMkjRcIojRN0FQtNI0BfkpXIU2RCEtTqVREpnKP1?=
 =?us-ascii?Q?JFrY52LFHVswKHsAeKTHOucR8ioNlqHYanNl9tbz+gmoAZ3VZuMl5+LfpyG/?=
 =?us-ascii?Q?PavoxwyZGEKUsscfQgJyY6tLCPisAEpG37YwAlWeAX139f0eADoClTpALVHX?=
 =?us-ascii?Q?WGn6CXnbKP9Pf8tanm2URUE/tpmUTiIjFJFDtS9EDqgswp2Q74XArDeIdnyl?=
 =?us-ascii?Q?NlN4RXqCSRM79zQ9JrsTDLFiqaR0GhvjYN2zZ0W5oAC2D1sHJlP7XlEqkO7B?=
 =?us-ascii?Q?/UU62mw9aH0jE5HOTl5YhTwpK+lRLyi8htINj8fDBN9Lq5aFkDh5786HadKr?=
 =?us-ascii?Q?ZYubHTdWo1nRf93Fd48zH5vVuMpY2ELtRK1yWJ4jtdmKXdpU5zJQW7ubkXst?=
 =?us-ascii?Q?EAmj0gObwVDeqo4ssDQL/SIKFd4ekYOoHBzD3THgO7XRv4tWnWS0HZiMo37S?=
 =?us-ascii?Q?pSPaTEcRnmp2t8SQdnWyJTYylKUhBKgEQc4wEDhm4AL9OI/EKi2mZlI3HbUJ?=
 =?us-ascii?Q?USy+RAU1oorXdGn0asV6et5MpH9mS/bq+SzoK2lmnljKssCjfCY4sBvHlo9z?=
 =?us-ascii?Q?Lmrxn6N8MHnHutePPRFLH2Omh7ORJsqdmXJ3uGPRG4xjS9cTj2yWFolvFL7u?=
 =?us-ascii?Q?Gkf25/k7MI/myC6G+aLnj8aTdqG5?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t9zJuE7soS9YxaKZilBPGGkr9hvk/G8K42Y7HnVPA25s3Vd55gDYj9kcMJ1n?=
 =?us-ascii?Q?Xz2vFWdh4XU/qC6gpG5tArrjQJv6wVo6uX0P13JHr9grEOZ10rOnJlYakl0N?=
 =?us-ascii?Q?qqQRvMEbyHs/J0l1Gcq4rbqtN1/YnOnMTGm236XRyWl/MPIkVeUwCM8R5hhR?=
 =?us-ascii?Q?Jp7WkonpJ9M/rYKNBG1JHLS/A/brwiorII/bxJdPMrmdgOJAF33YOgkS0Yhi?=
 =?us-ascii?Q?sijjTEeT8IlmV9kWXE5gD+MYv8ZCgxwZdjgknl22KoDHV6IGy/NxTXANdnFK?=
 =?us-ascii?Q?vQgthmelOmr34wdxdzRItPo3T4wY6NLG0TKtFvxxmSC+dbPNyOhGckmFdGmY?=
 =?us-ascii?Q?xTIlF3P7OeUXbm3405Cmw93LHx2M9wWHN6U15bf98d7zp58KxUcoCG25eNmR?=
 =?us-ascii?Q?DplC9UQHrOa6wF9gOgVXfho8oHSHHteThhI36XXnj4eGYQX5VYC2QTzuErTH?=
 =?us-ascii?Q?KvqxxUosCVDobHlyNvnRnXExqMh4rIVKxvv8kMtwWwr0uOxuYMkbSmyyJ7P9?=
 =?us-ascii?Q?3eEHA5a/3uSmb9iB+Kxi8JDIcQrH5PKpCHSEByMeCMtELsxFOF/NyrGOhOyL?=
 =?us-ascii?Q?LqYk3VgUvuxkq1wf6KbJ/DUWdNDZcYIdsLEMpt7PJ8KzwJr6qbGbZafNX3yd?=
 =?us-ascii?Q?KXVOwIl5zyWy13T5q9w1AlTdmXkDkrDm1ZoJfFQdWxBNe2ih7DY9SoatZbl9?=
 =?us-ascii?Q?Qow59DjfUyjFah9AH+v3kodTMK1Aoshq1vZLKpKsdtUHKKPYaE4JaBJSHryE?=
 =?us-ascii?Q?YN5D9xdUP3vo8Mg8wnTcAdUeRKUQEgD8E06Qpr/Te7szLFNwM7aMbtQjDxBf?=
 =?us-ascii?Q?czXz+9LnMAuqSN+t9tWlJUJodG5L6rRjxal3hERu517f/UEH0La/MoZ+/9QI?=
 =?us-ascii?Q?XZ7yHKjJYzEBlqRqojonmx/zdNDw/mjc2KJ0CwiFW3jcWG0iF3PvyZSD5Fyj?=
 =?us-ascii?Q?iBtO7XZEdp+iThqArje4rRgUD2LY6rzwCjWZexk8HlLJJVBmWzjJEKMk+8ap?=
 =?us-ascii?Q?MCZiC+ivNgs553w3XKl4gXqX+HYV1D9sXb0RvqrFSVworMmMC7fsBrcyDZao?=
 =?us-ascii?Q?BxchJVvvPnMS5Yy39K+1YRnB0Jfqlws9Eebf3rcbq5t5LiVBjOaI89vnYIDS?=
 =?us-ascii?Q?fqIdtRpwE8DnqdDqIKC/1kk5JsCUxDDpIJ83qIvajKTBpjtt8elZFfgYAFil?=
 =?us-ascii?Q?ziodh5Uh1XAoepr/pPfyl7txQc6z7gY6Sa8pllDPP5IPzIHCEzt9Fv/O+b5T?=
 =?us-ascii?Q?DB3nioOFASDLEIPBvCNKJmABKO3wjZvL57lmdIjztkVJ65DaHVz7Pl+BR1x+?=
 =?us-ascii?Q?oQbbEwwklsjcazwsWmshs6TUptc/UMIr87Cq5sXx4Z8SR9+vajSo1nyFNRw7?=
 =?us-ascii?Q?UXKL2EP2Gj5oYEsTOznziUHHBvhQ28JEtS1R/Q4EPDGHxT5h15a5TWQcdd5I?=
 =?us-ascii?Q?CCaAOxHfqtUA2rtY8AopnkMm58ieN7thSPwyvkECbECuHDPfPBOEkutHs4Ax?=
 =?us-ascii?Q?eXE08csLPKVQxngBq9PR68SuzW/0rvN1Ti+AClVimJIGa2Uk6dHniO4XhWAd?=
 =?us-ascii?Q?Ms76dsDWVdythDuOLaPkGIuXu2Im6DFdXiaSRlXqvw4kTnAKpoWynK6m6ipp?=
 =?us-ascii?Q?qA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33747b9c-46ef-4bad-e383-08dcb5a8bc6d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 23:45:50.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VWxtJlrm5gJ0DAVLq7hz45O01PWsmkx22qaCPVBQdOmlGjbtn16iEM4IuBkTzAsfjpdhwfOcBa4yEI+cZ/0FhAmg/H22YKPnsVd/B7azv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7549
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The TDX module provides "global metadata fields" for software to query.
> Each metadata field is accessible by a unique "metadata field ID".  TDX
> supports 8/16/32/64 bits metadata element sizes.  The size of each
> metadata field is encoded in its associated metadata field ID.
> 
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields for module initialization.  All these metadata fields
> are 16-bit, and the kernel only supports reading 16-bit fields.
> 
> Future changes will need to read more metadata fields with other element
> sizes.  To resolve this once for all, extend the existing metadata
> reading code to support reading all element sizes.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
> 
> v1 -> v2 (Nikolay):
>  - MD_FIELD_BYTES() -> MD_FIELD_ELE_SIZE().
>  - 'bytes' -> 'size' in stbuf_read_sysmd_field().
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 29 ++++++++++++++++-------------
>  arch/x86/virt/vmx/tdx/tdx.h |  3 ++-
>  2 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2ce03c3ea017..4644b324ff86 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -270,23 +270,25 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>  	return 0;
>  }
>  
> -static int read_sys_metadata_field16(u64 field_id,
> -				     int offset,
> -				     void *stbuf)
> +/*
> + * Read one global metadata field and store the data to a location of a
> + * given buffer specified by the offset and size (in bytes).
> + */
> +static int stbuf_read_sysmd_field(u64 field_id, void *stbuf, int offset,
> +				  int size)
>  {
> -	u16 *member = stbuf + offset;
> +	void *member = stbuf + offset;
>  	u64 tmp;
>  	int ret;
>  
> -	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
> -			MD_FIELD_ID_ELE_SIZE_16BIT))
> +	if (WARN_ON_ONCE(MD_FIELD_ELE_SIZE(field_id) != size))
>  		return -EINVAL;

Per the last patch, re: unrolling @fields, it's unfortunate to have a
runtime warning for something that could have been verified at compile
time.

