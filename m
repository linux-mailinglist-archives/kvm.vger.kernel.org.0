Return-Path: <kvm+bounces-50479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AAC1AE6223
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 847F64C177A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 10:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41207281376;
	Tue, 24 Jun 2025 10:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9QdwhQS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469B280035;
	Tue, 24 Jun 2025 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760495; cv=fail; b=fhumGO0Q4vWPJRKQ2ZwaRwQg6b7Ag77ImWORg6Zyv7203OjFoZHgzFnk4kupvnmyKQHvDHO6czIYNV8dpfaeBPEoSQY1YMkc5JeIQT/lu/LZPtT6g/NtJBO8SJ3rRNtPiqB+XalFVk5DsLN8sFPsIS+kuLArtVj0o5JIPb/WOXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760495; c=relaxed/simple;
	bh=hExvfACx0YPwyIUdYDtpxkhDvRh+LHfZTfPWeNiLpl4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z/4an6TFrOeo0aoTpWJaaES0by6DynFTcJ6KAyZnIY/7sNzTtCiK9CCpTvBPrVmRF1qS5wVN3SwSgry3MKVJrxiQv91ZyN2piqJBO4EKfCQPPK1VX6ql3mDa0zjQvoKkJONGGvJGcqJkukuo7wBoFxfnwhDq7Uic613nidjAGDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c9QdwhQS; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750760494; x=1782296494;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=hExvfACx0YPwyIUdYDtpxkhDvRh+LHfZTfPWeNiLpl4=;
  b=c9QdwhQSOohH3ANnh+SrwCZM8az2ZUDgpYYxt5tZBCQeh2dMeSKB7w7O
   VK3bjgY1tWT/UoNJ2+Eg3/OxK5FN7rQAb9FxXZkp9Gqu16I7As0RiyQHk
   8e9238IoJ5frbCMokYOq2qBkPvXpLSCaaT8t7XyByE+mKZ3PUBwHMz/Ky
   mLWhPm2WyLY95k5ho0QaOhX86mOZpLzWfc4cWnue8vqeyGFse5n9ALt7q
   dbVPU0aIMIYvG+aoUlydguYPKOdTWQ1LQm2inWDmUCgD7vdICkZAuPlJb
   vl+/5+c1S437uZU9YB0qgbsAIlk2BDAymZLDF4zCRsxbUguwhbKWq+gby
   g==;
X-CSE-ConnectionGUID: FfErv+EjQMy8tXO4USdDXA==
X-CSE-MsgGUID: ONjZ6eIHS0yyZtSlawuHoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="56777530"
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="56777530"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:21:33 -0700
X-CSE-ConnectionGUID: vsL66bjuRQCoFBfZigvsEA==
X-CSE-MsgGUID: dcvB15vlS1iLpY8gJnaTZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,261,1744095600"; 
   d="scan'208";a="152167227"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 03:21:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:21:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 03:21:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.81) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 03:21:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tlJ88hxFiQmnuOR9xc7OYBdDU0pgV7h0LaTRp7yS/IwWx2XfqnOmm71H8D5lDXaayUOzc7OIYoelACYSGBxjH7zUOG6nlLDbw8dQ39I4zwELlzDmwlD6vVFr4Kfw+53DMbGXXtefVwS14E4JBIGwc0GKYSUDG3svkMoBq1G0q656Ld7VM3bZfeQ9qk5KLP7lYWlJfntx6L/dIqJ7ojWx/XCRT+pzMevmEfwpoXuoX32vCZMJBMBjMGH2i1E2nLy6Zd5xWLsJJGGbAzHLEmosGcWidY+Q5i++7k9uYcnQTGWUWsF5XlqcmUXW49BPMK4bNXqdprr7zkRqYRAcNNX+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TA36tC49dNzoATxDPosn5pf/zKi9/AP76SI1SVUdtjQ=;
 b=RuT8KLar0DGtoda4r4AwSg/G35lyjOchUPfQ2hEPQP7tAFiAj/JVcqNnb7kwIqr4tGGfEbTdA4u98PwKrp3iiY8Tci/LZmBsExUBqJ1T0t022GU8qStMmsFqV3qubiUQ5Zk/3ADirvEi0/UhinOoIeJsFwIIqx6u08JWtvwGLMS+dxDUNYFtEx4Mc0vXiEYMs0khdQsNZfMVa0mPaAk51RlRt8I7hedeXHRJFfJGTQFJNQKg2cB89zPywwPPp4GVfsCvPUFMjsUb12ZrVLcLRYcO2Pn2ZgaCpm7DqoIZo59YBWh7m9tRlt60a4gpWPTeWpavK93/F7GdWVLOCA/uwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA3PR11MB9062.namprd11.prod.outlook.com (2603:10b6:208:577::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Tue, 24 Jun
 2025 10:21:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 10:21:28 +0000
Date: Tue, 24 Jun 2025 18:18:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFp7j+2VBhHZiKx/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2PR01CA0140.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA3PR11MB9062:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd25f04-31d3-43e3-0e0e-08ddb308e1a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?p2Q34dRwpQUt3lUfK3WyUopio4P1QNcDls/VMi/G9lBuJf8lQTsCpADTV6xJ?=
 =?us-ascii?Q?9pjLeCgcBoxSn5fXktHLxD6dS+ePlSI3aijK67WaCU7atyf9VfcI1YWKQyF9?=
 =?us-ascii?Q?DVvnHcfCxy8HlIpTMKbuUDQqt2YQCrArUqQdVXkgblLbBPe/RmTzSOsKxUTv?=
 =?us-ascii?Q?fAz97zjTdz73hwlngKvVXFCk7ebz8Yzoxz7d1mzVqvF7pSsZNLIKU2LtFVq9?=
 =?us-ascii?Q?UShePg3Qy6K20rzwIwtI/PobyG8FiSdbjYKzcD5ZvThbqAamSWxj27LyL2Gb?=
 =?us-ascii?Q?4HioMU2zLQV4SxRhhC8GLt8S8xBJ4MDTc+WeczO9KbVw0djr7XlN1dkus/3f?=
 =?us-ascii?Q?s8H43ETePevhGusSUntlby3SkpTOK859Rm3O6e/YG4bXqOHYNyh5QL9uq3Jv?=
 =?us-ascii?Q?DD1HOpIk7YUHpmh5/z6y7i6wdXDBe1Lva+KwoCJRcSDA9RFvocyDF6KKHsv0?=
 =?us-ascii?Q?NA/C/33QHqDsyDx6TTN+vzB0J8Q1mDahRGrWVn55+eBiNEEuF3RF6Wh/atP1?=
 =?us-ascii?Q?njdZQLkKfQatTSakRnr6YcYXC7nij2SvvIAnFvQJjhM/iAITxKy7Ci96DEFS?=
 =?us-ascii?Q?aXV7DNSGwPEg3Nc9mFV/0obH/7f5+sRmbxZZsCQWwx3xblGAf/Glco5B9kwz?=
 =?us-ascii?Q?26HXGBYtuDstjUAx5eFAJMG7kbTI5N4J8QzkhYLgJh7/JkHRoFgCWlO8C8Ts?=
 =?us-ascii?Q?spYQpCQezgpw8jTmRUBQ/VeBqCqcPG1UmdGbHW+Nq/rb2CBfe4EywTIibDD3?=
 =?us-ascii?Q?6MW6o6kgiAGLj0TZYA/ffm7QNYNpuNw6aAcm5UND2dg5CLGBh0KMFBIWU0Ww?=
 =?us-ascii?Q?5IcBGzJezLXnhmg1leLksj4CxdKxHEFi/sgwqzTiVhPHJ+bgkjv0YWOl9Mj9?=
 =?us-ascii?Q?aGNDXCT26J5W2M4ABDJi1XpXUR8Bw18/Pfg9Yirbpr38gQXdv5U5i2DmF+fL?=
 =?us-ascii?Q?0xZV4LshaGXDl4Iao5Ir4l3rd7HjSkb8bIzdkB8LKA5LsACaolyby/GxYxUQ?=
 =?us-ascii?Q?7A+zA/Ujmphmn4ompk8VUjyeBQrTUsTQ/tUQR1T/xo3p+SjaYN1YYh1IUUDz?=
 =?us-ascii?Q?h9V4yv6r9iwf3V1KmF72sHLRybacpvr0gV6lnCPjj3Yyo80ZM5k0/LFRaVn5?=
 =?us-ascii?Q?1+r0DcpCyMtLzMvecQD94qeZH5EeIN6Qiv4TQcjkc6y8J0aw1bvZXksDrXXj?=
 =?us-ascii?Q?D1JJJ0oOX7HQwOEmtUuPTZ1CpW1k/hj8EVzHb/1WvaUrsu47UY8YXkT+Zun5?=
 =?us-ascii?Q?6BY8XoTjWhW98IiYosCMfa+72PTVDYj+FKVUJsQdV38duRO1wrTy+IH3EJ/C?=
 =?us-ascii?Q?xQ1ZnGC8a2w6hCnCZz6jGwXJMJjcvqCG+zZg9t4JFyzGdUPIyH2G/6f1/B31?=
 =?us-ascii?Q?qtgCnFKz/wM7J0XA+Eq1Sl94Ij1Y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tNP3Q/BnaJKK/EDXPzOvsQjOIQSKlYR+O4Qs4tRpLvp+UUCFqYljzqaxCGl/?=
 =?us-ascii?Q?orTj1cSjLqmfCTXQkRQgjgf03RFoGSdYj0jLGIhdrzskLLw088lvjlNd8ztD?=
 =?us-ascii?Q?quD+faMwaintJ8XFY/ktcBCTkcwuOZRdX1jgZN9cVV+FSmW5s+wHjvEXurHQ?=
 =?us-ascii?Q?7oLxqcJg6fHps0N1X6Re8CAfePh9P+7OplMA8HpiukgmmE6eTmgEAimfhxUB?=
 =?us-ascii?Q?TL2LSpMk+5Uu/VdyFaI1ipnbpKy2nhPzlQ2DsCuKUJ92muvuQGH0mqyoKJpx?=
 =?us-ascii?Q?CyRnhZsM4llLeoTl0ImFARz2YYPWhWR69G5bkUSL6BDFk8pGyyKoBitN1dJm?=
 =?us-ascii?Q?caKYFJQunEkOFkhQletGqzkJ5PGZbN7zaECF9GNf2QRjOAJCyIgNvikEWYOH?=
 =?us-ascii?Q?5J4xVUscSCntRQ+scP7CTky6/Eb9Xafy7KMJR0hN2zJjg4F4FFZvTBBdRBFI?=
 =?us-ascii?Q?zTU4F3Yk7QpUg46Ca9podJMNaxWeihxKh89Elp9MT+o1fKFSZSPsAxTWFYwQ?=
 =?us-ascii?Q?Y0ltiMekOpRzzuRBOAFmU/g7TXykgPjUfZeIBl9LzJGGgAUyQUMJbn4lporu?=
 =?us-ascii?Q?Xniuo6EX8eyzXPEMZZqgm90ErJqn0+qEqxAwZa8azqpYtnbrnSmp+kbEZCUt?=
 =?us-ascii?Q?Ous8dEAxicmAjR79pxbBiV2ERz7dKURl0mhCeoWdzaScL4IWWhIFN/QZ3itH?=
 =?us-ascii?Q?R7H59WKDoMOf/NRaERp8vyy+w1p9PnOggdTDMi7u7CsUeO+W6cvjlq5U7cC2?=
 =?us-ascii?Q?1VHYN0h61KEavLSyZBO7SAVz/GTAuV7K5NTA9U9CQUV0IoTsXKDoUrIBGSuC?=
 =?us-ascii?Q?PjK1z3oKKdRPz4ygOcZQXkZ1bsydv14P+hAL8sahEhu9you1lNomGr7rkReV?=
 =?us-ascii?Q?ECvWspz2bmLLi/F+gnh+jEwxHaDI1vgIyae4524kCE0njc47uCBJdIomlyUG?=
 =?us-ascii?Q?i20WOMHMMrZjLz8YLy7UIhEnOCJfvpCD2K95ZAcM7T+vk5MS1Kopnghb6gtc?=
 =?us-ascii?Q?QJx16WU2uQE0V9Qqz6+rx8syzP9c3wisWoE95CV/VQD4gb/phm3Qow7FVy42?=
 =?us-ascii?Q?V8HW1VVpoSgiyPn5KP40UkhgbA8zSN2y4dhMh3jgVkuTq7QG+IKNoxB96NTB?=
 =?us-ascii?Q?868+VTK6W++uRbflE1c/d4kDwt8tQ8GXsxdDfDSiSDcTdk98/87vgqzU+DUx?=
 =?us-ascii?Q?F+P1LYgc29dd5s2EVV5EyM+dOJjHgYv8FeEmziH1LEmhxCtq8oESCSazrAvC?=
 =?us-ascii?Q?ruyS+0cSwFqY9IK7DQcLMDC01RjEFDRtu5eyF1I/j7oFCigtH9oyXfF8yzi1?=
 =?us-ascii?Q?evr+lPxjAUYA5X+GKG4BtR6ai0ve2lWiDq9xLU59Qq7USEO2F8ebsMH6WAzt?=
 =?us-ascii?Q?hb2wggDvTnHZJAGhPpRstQSkEy0IuI2Gh3kR65P9n2yaQ6Vpou03IGF9cXTn?=
 =?us-ascii?Q?7Lt7AMr2Czvrw0c6xxIicz7MZvz6aRVZvdbytAj+rIgcEjeQVyRWtqBtduz3?=
 =?us-ascii?Q?ssjMeKIhQfWXxzFRUArKocpDCipG44+1rgsdA9dkTbSAQ0WJkMiSa6ei288m?=
 =?us-ascii?Q?kMbFbUDHpDmsgO3KLijETBxlZamLDDxH2VTZAUnh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd25f04-31d3-43e3-0e0e-08ddb308e1a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 10:21:28.6994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6ju2YdQPhFBjNUybIYrlhQd4E5JVGYfnQc6bxG661q3TM15bkt1yXL6aGHDnlOX/xalG6Z88SORjigi46StiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9062
X-OriginatorOrg: intel.com

On Mon, Jun 23, 2025 at 03:48:48PM -0700, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> >
> >> On Wed, Jun 18, 2025 at 08:41:38AM +0800, Edgecombe, Rick P wrote:
> >>> On Wed, 2025-06-18 at 08:19 +0800, Yan Zhao wrote:
> >>> > > I don't think a potential bug in KVM is a good enough reason. If we are
> >>> > > concerned can we think about a warning instead?
> >>> > > 
> >>> > > We had talked enhancing kasan to know when a page is mapped into S-EPT in
> >>> > > the
> >>> > > past. So rather than design around potential bugs we could focus on having a
> >>> > > simpler implementation with the infrastructure to catch and fix the bugs.
> >>> > However, if failing to remove a guest private page would only cause memory
> >>> > leak,
> >>> > it's fine. 
> >>> > If TDX does not hold any refcount, guest_memfd has to know that which private
> >>> > page is still mapped. Otherwise, the page may be re-assigned to other kernel
> >>> > components while it may still be mapped in the S-EPT.
> >>> 
> >>> KASAN detects use-after-free's like that. However, the TDX module code is not
> >>> instrumented. It won't check against the KASAN state for it's accesses.
> >>> 
> >>> I had a brief chat about this with Dave and Kirill. A couple ideas were
> >>> discussed. One was to use page_ext to keep a flag that says the page is in-use
> >> Thanks!
> >>
> >> To use page_ext, should we introduce a new flag PAGE_EXT_FIRMWARE_IN_USE,
> >> similar to PAGE_EXT_YOUNG?
> >>
> >> Due to similar issues as those with normal page/folio flags (see the next
> >> comment for details), TDX needs to set PAGE_EXT_FIRMWARE_IN_USE on a
> >> page-by-page basis rather than folio-by-folio.
> >>
> >> Additionally, it seems reasonable for guest_memfd not to copy the
> >> PAGE_EXT_FIRMWARE_IN_USE flag when splitting a huge folio?
> >> (in __folio_split() --> split_folio_to_order(), PAGE_EXT_YOUNG and
> >> PAGE_EXT_IDLE are copied to the new folios though).
> >>
> >> Furthermore, page_ext uses extra memory. With CONFIG_64BIT, should we instead
> >> introduce a PG_firmware_in_use in page flags, similar to PG_young and PG_idle?
> >>
> 
> I think neither page flags nor page_ext will work for us, but see below.
> 
> >>> by the TDX module. There was also some discussion of using a normal page flag,
> >>> and that the reserved page flag might prevent some of the MM operations that
> >>> would be needed on guestmemfd pages. I didn't see the problem when I looked.
> >>> 
> >>> For the solution, basically the SEAMCALL wrappers set a flag when they hand a
> >>> page to the TDX module, and clear it when they successfully reclaim it via
> >>> tdh_mem_page_remove() or tdh_phymem_page_reclaim(). Then if the page makes it
> >>> back to the page allocator, a warning is generated.
> >> After some testing, to use a normal page flag, we may need to set it on a
> >> page-by-page basis rather than folio-by-folio. See "Scheme 1".
> >> And guest_memfd may need to selectively copy page flags when splitting huge
> >> folios. See "Scheme 2".
> >>
> >> Scheme 1: Set/unset page flag on folio-by-folio basis, i.e.
> >>         - set folio reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
> >>         - unset folio reserved after a successful tdh_mem_page_remove() or
> >>           tdh_phymem_page_reclaim().
> >>
> >>         It has problem in following scenario:
> >>         1. tdh_mem_page_aug() adds a 2MB folio. It marks the folio as reserved
> >> 	   via "folio_set_reserved(page_folio(page))"
> >>
> >>         2. convert a 4KB page of the 2MB folio to shared.
> >>         2.1 tdh_mem_page_demote() is executed first.
> >>        
> >>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
> >>             "folio_clear_reserved(page_folio(page))" clears reserved flag for
> >>             the 2MB folio while the rest 511 pages are still mapped in the
> >>             S-EPT.
> >>
> >>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
> >>
> >>
> 
> Folio flags on their own won't work because they're not precise
> enough. A folio can be multiple 4K pages, and if a 4K page had failed to
> unmap, we want to be able to indicate which 4K page had the failure,
> instead of the entire folio. (But see below)
> 
> >> Scheme 2: Set/unset page flag on page-by-page basis, i.e.
> >>         - set page flag reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
> >>         - unset page flag reserved after a successful tdh_mem_page_remove() or
> >>           tdh_phymem_page_reclaim().
> >>
> >>         It has problem in following scenario:
> >>         1. tdh_mem_page_aug() adds a 2MB folio. It marks pages as reserved by
> >>            invoking "SetPageReserved()" on each page.
> >>            As the folio->flags equals to page[0]->flags, folio->flags is also
> >> 	   with reserved set.
> >>
> >>         2. convert a 4KB page of the 2MB folio to shared. say, it's page[4].
> >>         2.1 tdh_mem_page_demote() is executed first.
> >>        
> >>         2.2 tdh_mem_page_remove() then removes the 4KB mapping.
> >>             "ClearPageReserved()" clears reserved flag of page[4] of the 2MB
> >>             folio.
> >>
> >>         2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
> >>              In guestmem_hugetlb_split_folio(), "p->flags = folio->flags" marks
> >>              page[4]->flags as reserved again as page[0] is still reserved.
> >>
> >>             (see the code in https://lore.kernel.org/all/2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com/
> >>             for (i = 1; i < orig_nr_pages; ++i) {
> >>                 struct page *p = folio_page(folio, i);
> >>
> >>                 /* Copy flags from the first page to split pages. */
> >>                 p->flags = folio->flags;
> >>
> >>                 p->mapping = NULL;
> >>                 clear_compound_head(p);
> >>             }
> >>             )
> >>
> 
> Per-page flags won't work because we want to retain HugeTLB Vmemmap
> Optimization (HVO), which allows subsequent (identical) struct pages to
> alias to each other. If we use a per-page flag, then HVO would break
> since struct pages would no longer be identical to each other.
Ah, I overlooked HVO.
In my testing, neither CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON nor
hugetlb_free_vmemmap was set.

With HVO enabled, setting page flags on a per-page basis indeed does not work.
> 
> >> [...]
> 
> Let me try and summarize the current state of this discussion:
Thanks for this summary.


> Topic 1: Does TDX need to somehow indicate that it is using a page?
> 
> This patch series uses refcounts to indicate that TDX is using a page,
> but that complicates private-to-shared conversions.
> 
> During a private-to-shared conversion, guest_memfd assumes that
> guest_memfd is trusted to manage private memory. TDX and other users
> should trust guest_memfd to keep the memory around.
> 
> Yan's position is that holding a refcount is in line with how IOMMU
> takes a refcount when a page is mapped into the IOMMU [1].
> 
> Yan had another suggestion, which is to indicate using a page flag [2].
> 
> I think we're in agreement that we don't want to have TDX hold a
> refcount while the page is mapped into the Secure EPTs, but taking a
> step back, do we really need to indicate (at all) that TDX is using a
> page?
> 
> In [3] Yan said
> 
> > If TDX does not hold any refcount, guest_memfd has to know that which
> > private
> > page is still mapped. Otherwise, the page may be re-assigned to other
> > kernel
> > components while it may still be mapped in the S-EPT.
> 
> If the private page is mapped for regular VM use as private memory,
> guest_memfd is managing that, and the same page will not be re-assigned
> to any other kernel component. guest_memfd does hold refcounts in
> guest_memfd's filemap.
After kvm_gmem_release(), guest_memfd will return folios to hugetlb, so the same
page could be re-assigned to other kernel components that allocate pages from
hugetlb.

> 
> If the private page is still mapped because there was an unmapping
> failure, we can discuss that separately under error handling in Topic 2.
> 
> With this, can I confirm that we are in agreement that TDX does not need
> to indicate that it is using a page, and can trust guest_memfd to keep
> the page around for the VM?
I thought it's not a must until I came across a comment from Sean:
"Should these bail early if the KVM_BUG_ON() is hit?  Calling into the TDX module
after bugging the VM is a bit odd."
https://lore.kernel.org/kvm/Z4r_XNcxPWpgjZio@google.com/#t.

This comment refers to the following scenario:
when a 2MB non-leaf entry in the mirror root is zapped with shared mmu_lock,
BUG_ON() will be triggered for TDX. But by the time handle_removed_pt() is
reached, the 2MB non-leaf entry would have been successfully removed in the
mirror root.

Bailing out early in remove_external_spte() would prevent the removal of 4KB
private guest pages in the S-EPT later due to lacking of corresponding entry in
the mirror root.

Since KVM MMU does not hold guest page's ref count, failing to notify TDX about
the removal of a guest page could result in a situation where a page still
mapped in the S-EPT is freed and re-allocated by the OS. 

Therefore, indicating that TDX is using a page can be less error-prone, though
it does consume more memory.

> Topic 2: How to handle unmapping/splitting errors arising from TDX?
> 
> Previously I was in favor of having unmap() return an error (Rick
> suggested doing a POC, and in a more recent email Rick asked for a
> diffstat), but Vishal and I talked about this and now I agree having
> unmapping return an error is not a good approach for these reasons.
> 
> 1. Unmapping takes a range, and within the range there could be more
>    than one unmapping error. I was previously thinking that unmap()
>    could return 0 for success and the failed PFN on error. Returning a
>    single PFN on error is okay-ish but if there are more errors it could
>    get complicated.
> 
>    Another error return option could be to return the folio where the
>    unmapping/splitting issue happened, but that would not be
>    sufficiently precise, since a folio could be larger than 4K and we
>    want to track errors as precisely as we can to reduce memory loss due
>    to errors.
> 
> 2. What I think Yan has been trying to say: unmap() returning an error
>    is non-standard in the kernel.
> 
> I think (1) is the dealbreaker here and there's no need to do the
> plumbing POC and diffstat.
> 
> So I think we're all in support of indicating unmapping/splitting issues
> without returning anything from unmap(), and the discussed options are
> 
> a. Refcounts: won't work - mostly discussed in this (sub-)thread
>    [3]. Using refcounts makes it impossible to distinguish between
>    transient refcounts and refcounts due to errors.
> 
> b. Page flags: won't work with/can't benefit from HVO.
> 
> Suggestions still in the running:
> 
> c. Folio flags are not precise enough to indicate which page actually
>    had an error, but this could be sufficient if we're willing to just
>    waste the rest of the huge page on unmapping error.
For 1GB folios, more precise info will be better.


> d. Folio flags with folio splitting on error. This means that on
>    unmapping/Secure EPT PTE splitting error, we have to split the
>    (larger than 4K) folio to 4K, and then set a flag on the split folio.
> 
>    The issue I see with this is that splitting pages with HVO applied
>    means doing allocations, and in an error scenario there may not be
>    memory left to split the pages.
Could we restore the page structures before triggering unmap?

> 
> e. Some other data structure in guest_memfd, say, a linked list, and a
>    function like kvm_gmem_add_error_pfn(struct page *page) that would
>    look up the guest_memfd inode from the page and add the page's pfn to
>    the linked list.
>
>    Everywhere in guest_memfd that does unmapping/splitting would then
>    check this linked list to see if the unmapping/splitting
>    succeeded.
> 
>    Everywhere in guest_memfd that allocates pages will also check this
>    linked list to make sure the pages are functional.
> 
>    When guest_memfd truncates, if the page being truncated is on the
>    list, retain the refcount on the page and leak that page.
>
> f. Combination of c and e, something similar to HugeTLB's
>    folio_set_hugetlb_hwpoison(), which sets a flag AND adds the pages in
>    trouble to a linked list on the folio.
That seems like a good idea. If memory allocation for the linked list succeeds,
mark the pages within a folio as troublesome; otherwise, mark the entire folio
as troublesome.

But maybe c is good enough for 2MB folios.

> g. Like f, but basically treat an unmapping error as hardware poisoning.
Not sure if hwpoison bit can be used directly.
Further investigation is needed.

> I'm kind of inclined towards g, to just treat unmapping errors as
> HWPOISON and buying into all the HWPOISON handling requirements. What do
> yall think? Can a TDX unmapping error be considered as memory poisoning?
> 
> 
> [1] https://lore.kernel.org/all/aE%2F1TgUvr0dcaJUg@yzhao56-desk.sh.intel.com/
> [2] https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com/
> [3] https://lore.kernel.org/all/aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com/
> [3] https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/

