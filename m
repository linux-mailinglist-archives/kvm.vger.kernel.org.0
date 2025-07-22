Return-Path: <kvm+bounces-53079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D38F6B0D1F9
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 08:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00FD517DB25
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 06:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C4B2BE65A;
	Tue, 22 Jul 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iGEvkXK0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174241C84DE;
	Tue, 22 Jul 2025 06:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753166266; cv=fail; b=Ikd5E4gv/a5YniQy6NhGmMPFQg2HwpfS/PLEgUAwUeTzzaR9SOWXNaZKhuMVybVl9Fy1W20MBeg12jA5A31ZzGvGA+cvpPjuC/uQ8whG2yKx16jY3AHXxZDszs1YGc5miiLZd+Ef/16OJICIdyE3d+ci/CYwOdnR0Seq7RBgt/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753166266; c=relaxed/simple;
	bh=oT1HtAqT8ZAtKjLcxXVrig/9k3uJtGcqkv/OrnUoBjs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nGCg7BmJrlNOPtpNaYNgm0xeg6648sHOOWSBKp8oyaymDT2pe7iwEKuy0KB7BuBmCJwt+rkyhMUw51aOrx+cxSLqLKK7CY+aP53UvhLqk2DS7HzTeVJUTzxhld62/qyyGULL0CnSAU6K/Tu1FyJ0VJ/sh10BChBNsLKqce9NeSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iGEvkXK0; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753166265; x=1784702265;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=oT1HtAqT8ZAtKjLcxXVrig/9k3uJtGcqkv/OrnUoBjs=;
  b=iGEvkXK0M5YL+L9PfWN+yt8Ow+xdkaSHsyB7WUZm+j/MtjQOYkZZ+f5r
   0Og71BaWiRgZERwKbbkPxnxaG3pJjNfVorhLe8zsdFjMVt7T8kohOZQ4r
   sE1NS/FoE/WKT0i8XsggMCOsoJd/aGN1gvMJk+MD3S7q+mF45qL0IaUE4
   DMXZb2Zp38O2zEB2GREJJR5tIiwOi9DegBmqYp9qhFln5Nugrci9xooRW
   AZWhLfIvOFA6i/FB+VFkPSgAAN3FLlI8s/+qZTfrqvwNi2SYkmC9Dwne/
   Ds8HAYbKmqDZnEjD88tuy2/tTp+4NYj7D9XxkDU4nIbnEPDmFSXF8DMga
   A==;
X-CSE-ConnectionGUID: H0oarQqOQDS7Porf4vAJXw==
X-CSE-MsgGUID: cJQSSgslSDeqNVJCDWO8Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="72855087"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="72855087"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:37:45 -0700
X-CSE-ConnectionGUID: TX1FYQuSS1uGlpRW0XakrA==
X-CSE-MsgGUID: 749Zay5ERRafrQz6EebLzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="164533391"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 23:37:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 23:37:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 23:37:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.77) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 21 Jul 2025 23:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=liWCfMdhmrzvOKEUvxNJ52PLJVFiMALsdBd00+OmEtkinKO/LvHAwHA/uq7Xt5xiMRDYI1C7cNhzB0DeQCel11ZW4xLPi3Z/c3lf49T+QJkVybAZf0XNAUalYxKCvRYLe2pskNfTSRiUH/vk6YrE2n6VMXboMsrGtz9Cdzbd4EA/BANNEI9WaqcfWWr0G9KnBc4AMBrTSO7ZVtCEnLN6rKd6nyhmJoKeMOLZEQDmrQdrQkhUsK/bCbJBFfQx3Cf0TdgMLg7Cm8OofiLIRRal9FeTp9JtSvJGOeiFykIX9tDAY/2ecgUuW8Cm3aeh/S4WeBURlkHzvrTHz2pHuXVmNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2MKAt9fneD9/kCppFwm6FetDwTVi6i2lX/03pzvB/o=;
 b=UEkd9zQ4jU4A1RjP3BpZH0TeAByOs8ae5iCqVUcvdqgtMleh+kktJK3jxErEX0SSkY/hFh9rvDnTM3ln9d7AuIEmRFRKRBmeOWnastU+v8RKR0X1pM4yw/N9mNVy8FesTnf2PG08g1HgX95xWrC9eaAl674r19K5MtUmEY3fS7zR7D6ci6F6g+8fLqPjeLEt+f9qul7tJ2GSNjFIf1sPYBZrnE+6xegq6V+Tz0dR9IiptTL2Jp0NbJUFaMVo+HQLm3eYWSo1vLsENcRfqM94VJKi5CxJGCj7+nCyQVy8y53ldShwL+Gcnr8XrbTKJn+tstw4jtWZNLI+u4vdxZvOFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6337.namprd11.prod.outlook.com (2603:10b6:208:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 06:37:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 06:37:38 +0000
Date: Tue, 22 Jul 2025 14:37:06 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aH8xkkArWBrjzYfk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
 <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
 <aHb/ETOMSQRm1bMO@yzhao56-desk>
 <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
 <aHnghFAH5N7eiCXo@yzhao56-desk.sh.intel.com>
 <diqz8qkg6b8l.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqz8qkg6b8l.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2PR04CA0185.apcprd04.prod.outlook.com
 (2603:1096:4:14::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: 3338b5d4-4bb7-4a8d-6863-08ddc8ea4024
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LLqSCv8SUPq8pejJPPuTw7xo+lCTeuhX/YCGh1B3kJ2hLiLnnxCvqwonUSqO?=
 =?us-ascii?Q?1b0mKiu1rz/+kXnIPFC4Wez+ZC1p0niNDOwd/nRevEr5NJutr30OiRKaQFII?=
 =?us-ascii?Q?7NzH//ZMnCXE0NPgvOqi1tAjiql/uDiW8Ru9+/IXeUzi5rgnNOfRCAZD+BAz?=
 =?us-ascii?Q?0+afVCceBpMNvHPveCyya115bZcyOarlcJoArsRRQKgjeVf6swX0/jd04ciR?=
 =?us-ascii?Q?zvIxkzEmJpCjy9PIbfhm3rPx1KI0gkfUKM5gJXOzEmjtTHftX7g7F2G/hVF3?=
 =?us-ascii?Q?ukvq6K5BjaqfwPKtnYY17ndsmCMRil21gRmDYAKDyp87AdX21lLRhQpXhEXI?=
 =?us-ascii?Q?ts+e5jveE4jTq6MUSAdL/pnkSDlN2Txly6wCAbtBNXJQk1SfhiDfAwJXyR1n?=
 =?us-ascii?Q?D/lv0k52L5M+86exTJueeKzRfKLnAqs2Wbfzg+Q5WHzJQiOTLX5QeKP9Tcf+?=
 =?us-ascii?Q?Dx+Wf5NRo7QLPkX0Y8gK0qUMF+/Iugj0hFkqZTsExu8pMsPFBLB+Ij30cUsR?=
 =?us-ascii?Q?YA/JpOeyV8yC009PENQh2WBMSDJnKCnAYBEJh8ZMlJ550HKEzlX2J67zM+6z?=
 =?us-ascii?Q?54tsP66CRkjnEk8hPVmmkw1B8edHbJ2xDmN5jv/x9O2A7KthFXI1Ws97/n0/?=
 =?us-ascii?Q?zyzndV9VnTXAnaaIaLQVG3BUUA+4alt1Y5npSN+elpIXQcpu1eJ2MJ3TPRkg?=
 =?us-ascii?Q?xFJLqHylsEV57ipJHrk0X0/a0IEoWALbd0ijeeP2QBtgF1KjCg3p+KRQKgAE?=
 =?us-ascii?Q?vLRI6lS66vEmSAdrKO7HYexYUFNewvr7LSZdPjnbgKWrv7bkOX+ocmi44nJT?=
 =?us-ascii?Q?NOJtkBQh+U02JrCdwvn1T5C4VG515lu2HpBa8fpRsjQ1uPQqE59J1dTRetip?=
 =?us-ascii?Q?bJBBSt6ObVHNG5wt+Z/dHczaNDjuTemOkC5Elv2aEuTUQzIoixLbGeuNbs6F?=
 =?us-ascii?Q?O3Q2low/NfRjiyRMxaPk1IrAMnKahOhoLGmviWG6W8gtu7og9wibD6QnUx6t?=
 =?us-ascii?Q?I+zZ0MioKjNPhV7FRizn0I9eLRz1T3dKoGQgazSGPn2L1d7Y5zO+spniEAST?=
 =?us-ascii?Q?mHCaBfSuEl/bxhwIFv9i3G9vmUhcU/QzrMCgoGvRTleAG368qxxT2mEH0i7/?=
 =?us-ascii?Q?JyQJakmz7udNNCS17B8uLwn0kVHd4IOjCu7Pir/9PhE5S37tCcfoKxFtEDDC?=
 =?us-ascii?Q?I/u9pzlEIfmE18knoYTlE/uenPx6rY5m2YO1f0n6sXGSNpoZtLyFT0pun4zR?=
 =?us-ascii?Q?TLE5yzHZoMC8I0BKyPLcgd65Sr7icIquILUEHI8ViRFaz3aZVXkG8FFJ9DbS?=
 =?us-ascii?Q?51Jfn8Huee3v7/JynkL6CkndLRXmFuRpVfH1KEZicv3HvigPnVc4XVkJ1ewP?=
 =?us-ascii?Q?4UCw/ElZ8v1oJZC0G37PT8leX32A+zQPkOsC7A6OxxvRGKjX2pCKPgryDpBS?=
 =?us-ascii?Q?dD9aSZUKMnI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vwed1+SxAFSyu1NOeMIEopOFu+qcTeMIz+SLdwITzXKpYM0CdBThpeSBKaf7?=
 =?us-ascii?Q?ssrKD3iVuizqanwtBpYc/ks0yWibUc6iDahbhFciXyDlCWfqB6R8+ReSXqxt?=
 =?us-ascii?Q?Y0+GCNGOlmYjLq7Cxm/K3JN35QFFXjYws7KOtsJtPOdWV0JJp8F2PxnTDSQn?=
 =?us-ascii?Q?mU1dNjrZ7KowvfS/GIl8JYYC206NfFkUbEkSaSNXAYLiBP5x/IWRjG90+XYX?=
 =?us-ascii?Q?3uK3Vg2kG3MSt+BKUR+g2tFqfl7pZIK05ZhF7MMBNDWyiFqkOETDN5DdGfGJ?=
 =?us-ascii?Q?A5Nr5v4Cd8apbAMf09x2MipSfGh6JkmzuH55tNuOaGaBSjdjshgLnzGr73yL?=
 =?us-ascii?Q?PQpmB0qL+twcflzEDK7jUB/IIZiAFWWKeprWFXp8OwAwRBfv70HgKN/l8ncx?=
 =?us-ascii?Q?6itBvSgjM1Etr1uCH1F858+ZBEsYMV1PgtEZ8D28wF+kkfh7srFtplB+S0qU?=
 =?us-ascii?Q?TZ84Rbdd6HkzY7M25CMdGdFOEwr8Okb9JS8KJ19SybbErLlv81pVZaDlFSYr?=
 =?us-ascii?Q?XabVF6G4Bd88v5sGt6+hzqyJhXEe5ooJml1owJXzQ52lqTk3XQkyQD2hv+vB?=
 =?us-ascii?Q?uLPgrgAkEz54SRspJlnkyh8IfhAYUEmKmUFAWaOjcfB0dScDlDksAACH3wbp?=
 =?us-ascii?Q?jVQKY/aPp+YoP/z0QB4znLlLjkMpI005ZC77+POlLGhRiPusWSvNApBD3xea?=
 =?us-ascii?Q?EWTkW2Gjz8rLxtFaJ79iXKQH+NGksMyhP/tpR6JZTXz4lqtERkRTjyTl9uTU?=
 =?us-ascii?Q?YFFjXn4tDjmGU2aOkpkUXUHy54Qm/DU09WYLfQwyg7W9Owcg5yB4m2fxSjay?=
 =?us-ascii?Q?fxHiX+dIrms51Ul4NNNt3Id+TCjZvVhQUuk/5AAHIp/B2C0+0IgIpxh12Mfd?=
 =?us-ascii?Q?tuVuYx0Pp/y1AdPyuOmqVuysj8DE7Xk/CiGDAQRnJ/Ib9PIVgeOhVpKxuHBC?=
 =?us-ascii?Q?KMYxXJPgM0bXz+cAzL/vGWjHIOOdr5IZTb2Kmoy8NH6AbF89LQQerJL1pXsO?=
 =?us-ascii?Q?umNdh8fqyMUc4HWRTJK1+UbQIsVwg716TkhGHhWUlren3zyGyYgurJV+qUVm?=
 =?us-ascii?Q?OEdUpR7tt1v7tV15B7kbokV008zSzLmjQfAcBHsVQQYTZdbsaInnyTxbbcel?=
 =?us-ascii?Q?lO9vojd1bQh2UFcWZon34XoZ/MnIXfkK/9oVPtGcdWU2p4QH/AkJLakAKa4s?=
 =?us-ascii?Q?FiG++LqpQQRf0v4gcmpgVe0ZjqvurqfzS2z5Kl0gNdq8lnjC9N1MABZ7HcLX?=
 =?us-ascii?Q?DlofcoxXzmPpNURqnbz04BC+v/3iQKRDY0UNYIDMQFzqoHftA4qDxK2QPK3l?=
 =?us-ascii?Q?R3qAcsl6FGyMqjqY0PZ9x5YZZCDq8TBbfkbRFoMgkNqjy07d2rbGQ9leD26m?=
 =?us-ascii?Q?O+bhyqU6/EEawZhbgS4WGHNcPu8k/tOQJLTH5NkBDiwDTBjFJrEeGmun5bML?=
 =?us-ascii?Q?4TyauYtTOCGaqSmrl2VbM8dfCcAjJzGniNGn1WupoTEjOox9dcp1uy+rmhvI?=
 =?us-ascii?Q?H4Pe+k+wcedH0p7liZEEBkx4Y8tJptoatZgfohQiha1jLbOXbXqRwYNXsXnD?=
 =?us-ascii?Q?25N6hmtoyhnccf95L7YlPp9bJyV7Hz4lEUlaNhiw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3338b5d4-4bb7-4a8d-6863-08ddc8ea4024
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 06:37:38.2287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vku09x/ZZg2doKT6EgYlrqejsKkrIHXHphHGTQyIDHjbIZcj5P4Q22MQQ/yN7lzBTV3WtQxeMHIhoRFZsrHzqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6337
X-OriginatorOrg: intel.com

On Mon, Jul 21, 2025 at 10:33:14PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Wed, Jul 16, 2025 at 01:57:55PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >> 
> >> > On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
> >> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >> >> 
> >> >> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> >> >> >> Hi Yan,
> >> >> >> 
> >> >> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
> >> >> >> series [1], we took into account conversion failures too. The steps are
> >> >> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> >> >> >> series from GitHub [2] because the steps for conversion changed in two
> >> >> >> separate patches.)
> >> >> > ...
> >> >> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
> >> >> >
> >> >> > Hi Ackerley,
> >> >> > Thanks for providing this branch.
> >> >> 
> >> >> Here's the WIP branch [1], which I initially wasn't intending to make
> >> >> super public since it's not even RFC standard yet and I didn't want to
> >> >> add to the many guest_memfd in-flight series, but since you referred to
> >> >> it, [2] is a v2 of the WIP branch :)
> >> >> 
> >> >> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
> >> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
> >> > Hi Ackerley,
> >> >
> >> > I'm working on preparing TDX huge page v2 based on [2] from you. The current
> >> > decision is that the code base of TDX huge page v2 needs to include DPAMT
> >> > and VM shutdown optimization as well.
> >> >
> >> > So, we think kvm-x86/next is a good candidate for us.
> >> > (It is in repo https://github.com/kvm-x86/linux.git
> >> >  commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
> >> >  which already includes code for VM shutdown optimization).
> >> > I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.
> >> >
> >> > Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
> >> > from your side. A straightforward rebase is sufficient, with no need for
> >> > any code modification. And it's better to be completed by the end of next
> >> > week.
> >> >
> >> > We thought it might be easier for you to do that (but depending on your
> >> > bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
> >> > parallel.
> >> >
> >> 
> >> I'm a little tied up with some internal work, is it okay if, for the
> > No problem.
> >
> >> next RFC, you base the changes that you need to make for TDX huge page
> >> v2 and DPAMT on the base of [2]?
> >
> >> That will save both of us the rebasing. [2] was also based on (some
> >> other version of) kvm/next.
> >> 
> >> I think it's okay since the main goal is to show that it works. I'll
> >> let you know when I can get to a guest_memfd_HugeTLB v3 (and all the
> >> other patches that go into [2]).
> > Hmm, the upstream practice is to post code based on latest version, and
> > there're lots TDX relates fixes in latest kvm-x86/next.
> >
> 
> Yup I understand.
> 
> For guest_memfd//HugeTLB I'm still waiting for guest_memfd//mmap
> (managed by Fuad) to settle, and there are plenty of comments for the
> guest_memfd//conversion component to iron out still, so the full update
> to v3 will take longer than I think you want to wait.
> 
> I'd say for RFCs it's okay to post patch series based on some snapshot,
> since there are so many series in flight?
> 
> To unblock you, if posting based on a snapshot is really not okay, here
> are some other options I can think of:
> 
> a. Use [2] and posting a link to a WIP tree, similar to how [2] was
>    done
> b. Use some placeholder patches, assuming some interfaces to
>    guest_memfd//HugeTLB, like how the first few patches in this series
>    assumes some interfaces of guest_memfd with THP support, and post a
>    series based on assumed interfaces
> 
> Please let me know if one of those options allow you to proceed, thanks!
Do you see any issues with directly rebasing [2] onto 6.16.0-rc6?

We currently prefer this approach. We have tested [2] for some time, and TDX
huge page series doesn't rely on the implementation details of guest_memfd.

It's ok if you are currently occupied by Google's internal tasks. No worries.

> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
> >> 
> >> > However, if it's difficult for you, please feel free to let us know.
> >> >
> >> > Thanks
> >> > Yan

