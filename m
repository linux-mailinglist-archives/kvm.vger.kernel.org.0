Return-Path: <kvm+bounces-34034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 325959F5E87
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 07:20:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C966169616
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 06:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011A0155A4E;
	Wed, 18 Dec 2024 06:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nwcC0Fl3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2033F9;
	Wed, 18 Dec 2024 06:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734502801; cv=fail; b=QfQm/wSheROVjp4MQxDKntIrKcUSVbg1fDBxbzwg3CYiZH3lH5vKaZR4mGfE/2M1nOh8QNGHH+R+H6nAjSsj1DQ7okyZ1vSWYW1ir3jdbYVg9Vw4jmkZkZRod6pbw/kE/irwk3d3R+Slw9DVTB8ZdMMET0hYF6RCbrcHJnSngGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734502801; c=relaxed/simple;
	bh=2lZ3w47PKdxdRRegoHAmXN6ISiOEi/jNeMBkFOBxHug=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IAYufkjPaTnkYr8PCApjmrmtS08BvWEm3lnBRAxHNozZck57vKGRR3r6vRW4XXCd8NhcrImytK9JYoxWxcRhOzI18Q+aEYLTHo0Y0BQO3lprmxg/tfP+bGsOIL1skOzvoaQ73Pes1Blm5jnFX1N5bPrJo/Tg8cJ7VnIAnnRLH1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nwcC0Fl3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734502799; x=1766038799;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2lZ3w47PKdxdRRegoHAmXN6ISiOEi/jNeMBkFOBxHug=;
  b=nwcC0Fl3vRdIz3bPbkBPWFg0UcIPASniC63durCpOJymI12u91s2yIj4
   zfgYQcZ6lBua1SAVAuRwoJ+6d7CWZhr6Xb9em/U7AefMHPKxIyXDbARmP
   nIngLNhvYx39aIBlzNM2uH2vtH+h1D0figmUzNDPJgZu1K0GP45KFwCDb
   Oz8ioJdvLqLeVV/xwWzDyFQVN81nzbo6RksnamY2VHqzz4KPqDESyUXEm
   Kbtk+Y7ii/a/hm3iKnuRZSRFdRCFh793gIZE3zKEmBPlckOxKJA5srtof
   TU+l/uffvDugXzD/0oHmLsCa7h7qoFyFaMi/5H49m7IhZ5qYmUoD8nsES
   w==;
X-CSE-ConnectionGUID: goYPr7RFTRmtXyYdkBR+fw==
X-CSE-MsgGUID: M11B87UlRUmtqUn9GMldag==
X-IronPort-AV: E=McAfee;i="6700,10204,11289"; a="45654142"
X-IronPort-AV: E=Sophos;i="6.12,244,1728975600"; 
   d="scan'208";a="45654142"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2024 22:19:58 -0800
X-CSE-ConnectionGUID: 5VXLW/ypSm+ABYIMLHkFlg==
X-CSE-MsgGUID: X1K6fWv5SkW38+MNY0CURA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,244,1728975600"; 
   d="scan'208";a="97990436"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2024 22:19:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 17 Dec 2024 22:19:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 17 Dec 2024 22:19:57 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 17 Dec 2024 22:19:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IjeJXI4HKOc0tIUcX4Js79wcZnuYMMaNmc98gKNPDr73q/A5n9g9jLST0qlVUuF8u9DHs9l2dl9uAm+TBOQVnybToSTwA3kcf6n8Q+VE4JYBCFyMvqfR5ZrchNGqhxWRQZA6tOfpcophiW9sxBMGwKfnIWrO+NrSflKH8w8gdgLGsA0pRnlD9PkWLTrHHgVL529ZA2S0KH43ng2XjPqNN2/IMVMV04Ryq9p80zDIaMU81Pr0+QmtjkPdunI0he1gapbWOOA86b1CEHvUn6F8V5qukUgcxupRDjFWc1nJg0lRGDVM+GUk/sUvJz6Wycw6gOlmBakNqAfiZi6DNJ1yUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zm+/IIKhLLKV6Sji8xmxh8ml/OuDqupEGPPlOCx+9zg=;
 b=cqgfRboj6XKa004ntYHzmMfukGDj2HL/c/AdMNXWlH3VmdFcoSBGm/exIzNDfPzh3vFKSo/51oGlXUtxR5nyDjq9KvHKf/+aubllpYkDddqkV4/8gfOC6W150S+dpyzLXHrJM7+HGvHFwbcj77n0W7gHBK74HnjYbX0bMdIpPycrTnLtlpV97vyVnIQuepqAN6mQK+1RxqZC7uEKBWBXVC5lXum+nbS0YbVoSeSli3gG1W0VSPyyrXFcn1A5pYiGR4Q7vttjaD1H/uhK9PZ0btaWAnJR87P7SIMEW8wtDEHTKhJZnEVuB7nlGCmtKW0zhThRqbHRiywnYYA3cvtXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8144.namprd11.prod.outlook.com (2603:10b6:610:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 06:19:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 06:19:23 +0000
Date: Wed, 18 Dec 2024 13:45:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Message-ID: <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
 <20241121115703.26381-1-yan.y.zhao@intel.com>
 <Z2IJP-T8NVsanjNd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z2IJP-T8NVsanjNd@google.com>
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: cf38b016-af77-4ee3-57d1-08dd1f2bea09
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7/0G+/NSI3igcxOgf8V1CEoJfD3unmbVFGj86l6VcPf7q2b9UsiAg0rFQJXp?=
 =?us-ascii?Q?oc/LSdNvPYmdfpJW9HV3SVRm2rUdytc8dMnlBXlb+wkCruGuyqn25c6QRrUA?=
 =?us-ascii?Q?OAWAlCdkBoKASnfnr4JDaEGw1oeqY9F2kJ1k+Y2VNKFPXRdsF1LTfjjhZ1wa?=
 =?us-ascii?Q?ktjGBNwYVY35yIPAPjtJ2RVw5F0gQRLWFG3oTqW0BaafoOBCmlrL7ZLWi8E2?=
 =?us-ascii?Q?0UxqzIXze5SO2hdS+QdBcUXUQ0gqppNdh0jZQAFHu64E+nqUo2m1tuf3RmoK?=
 =?us-ascii?Q?PMUR7m4rp3EkIptJRZD6OdpgMshiD4qkfdLNpL6fZFex07dgrquKAlAMGSRR?=
 =?us-ascii?Q?T47sn3YyT+OtT4hlY6d4bz9ZmUpXZFfycod4RF/aqj5Yy6EJmAtvJuYcuBVc?=
 =?us-ascii?Q?H6yyn8X8Z9t9CvbHdvhtsuvZulA21q/xbLX04PUrl3zOo6T+ffQ3oQD/WG4T?=
 =?us-ascii?Q?kiHLGLZE0OzJZGpEQa2ckdpqBSmHm15VihkdqpdvxNyOsmK6Xkq+kRYhHU/q?=
 =?us-ascii?Q?r2RHS6MA4VI2mo3iYgLkylGjGbXn3rRW6Wg4lKgq7096crg6ridDakSzQ2LU?=
 =?us-ascii?Q?/dvOMLAYhRQZBdB95vwcls0TQ+8Ebwg0US0f1FTFBZfPgpRaaN/ZmGc8BNx8?=
 =?us-ascii?Q?1fDcfwdxdIdTTbAMe0Mb0nsj4IT03C2iI9GJiE6u+g120up6qNZKx7O1e51M?=
 =?us-ascii?Q?dSh2pu5l8zuWDk/bRaMnW7sAgbzS6yWh5HuZ+Ima+7b4XNXAFtHrUZ9jyg2B?=
 =?us-ascii?Q?R4FTyiRm4GHsltDq3F/iLesR2UPyyx1XJl6vDiylc4dAped+OvC2MB0ya2uR?=
 =?us-ascii?Q?0bcDCjTjJ56U9PulH/Ur4MYqwJS5qSMVT45c0/yrmPmMrN5g0Ns9SDanesYz?=
 =?us-ascii?Q?hysXc1AyrijS+0uqguqjZOXO9b9wqhHz5nMBvETmzuY32oPGehy8YQgfLvWO?=
 =?us-ascii?Q?4Z5XKtCp00KWX9fMLY/UJPczhCIpIsR37OMQeChWTlvYKv7GK3EwyD/CRdCH?=
 =?us-ascii?Q?S0aZNhY0PNBZxWTKdmY53IfwaIZBgzRwuoVdHmdcAYno+bPgjIYKfS0Vq4Yr?=
 =?us-ascii?Q?NwMz7jtfafwugZaUmZRNYz2USQBWRPSfeQZt5CH/b+7Mtcy3WDDkK5y3WA/v?=
 =?us-ascii?Q?xH389r5iqjkZYhKeZdybvqQqtn0Hv3DKC8b5TgkMeyaN+JuAaBeyqLNayuYz?=
 =?us-ascii?Q?DIAUKPzrUuj/1+vt+lrNiTgJLeAThVaPx8NgRvC/mTnraGUprm/RL724HLql?=
 =?us-ascii?Q?9pidlY5C2o0anqTZc+nK0cbLr0D2LN+Z/RH/LS/6QoBPFpoMmosOFqVQPpcB?=
 =?us-ascii?Q?aaP4ivOhMCNfszVun3rjlg6/E6CJT+rquGTAJO7M8ny1rxmsWSVkxVq7fUSW?=
 =?us-ascii?Q?efI2/V/o3M0V1vnZ1W1OrJ8lA1ri?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?inhaiqIQslIHkk8nW6YtzbtnInNFgIfK7eFbYlo7QXxALnmmk8crvfbSieLN?=
 =?us-ascii?Q?yG+Gcnca/tDQobR68c6q/Wf0sVXnXwE+baNWNEEU8mbaiN639tAocsqDaTFR?=
 =?us-ascii?Q?v+DcmaUp/9YSXYiE3AsNrkdKYnwoFvj8Uad20kdBZq4MAuPLQEpCVJ/YyV8R?=
 =?us-ascii?Q?N30jWL0HwqyU3I9sDfWNkoXaykLvYZxCa6Re/Xe7AK3UODFU2YvDSP4yLd+X?=
 =?us-ascii?Q?s+iJ479+7c8cO6/Dsb4kj7ds5SxJMUvZubBL+KPF83Op1+Gud8Wvb7VZ3nuB?=
 =?us-ascii?Q?YkG81Ad+xnnOmjSsM2kv2d+9NqHiwExMVrkj4lC1+O2X4bWaZQcjegADf2Gx?=
 =?us-ascii?Q?oorcKVHAlvZaUuliFMp3eji/euyOioY3VtTL6nJNHri2ntw3Ffwy4lwmZrXl?=
 =?us-ascii?Q?neoOWnaYr4JO7H/89qfELCnJdP6VQJxzx9YLoyDUjIkUaj15n0UuERmFvF6D?=
 =?us-ascii?Q?tf/GYh0GsBLHtuGbktUw6HSKiteKbI73kBoM1woO8Jq+tL26w+XUrzytcWJM?=
 =?us-ascii?Q?R4jzhwEiz+2QU6II56UlloaVy4gw8Mz508faiXUz2DyxC5Mr3oB1yQ5IYeZ6?=
 =?us-ascii?Q?IWe/BRGNVeUrEXWKkBAGLm5xz6h3LhsmnXF2Xo1rAx9kvq8zlFAG0tqd4Y+K?=
 =?us-ascii?Q?iCopgmtH0+kSi2sHJjfxXcfjydew7fbzczySnJul636yQpF9Yg9iSGQcS2kV?=
 =?us-ascii?Q?4DCspIl+dHdLcWZCrO25n6gdMcCaiC4kpnINwWmQLlSpzvMvz+YhxHFrcagn?=
 =?us-ascii?Q?IAEjRAbdWDEGiwDPkA17ZMhxrUGdB5VPrLYnPu4BgXSBasqvVgdlMQRu6p7E?=
 =?us-ascii?Q?MaKqPf/MTkwtG9Kw+pucAVwubtFwt/GrssIHM9t0HVePHo+DdW6SL+7sdc+g?=
 =?us-ascii?Q?uzW6vrNsk84B0BGbETAycqP++Rk2X3VwilKiqkcHgCov/2GhY0r5G8gr9nHY?=
 =?us-ascii?Q?L9oChxXZQxTewCxMUNEZC2zOGrsiJC3jBTKDb8RATfEmnrJyLOgeTMEOFKmK?=
 =?us-ascii?Q?SIi7RUUWxtcouHMHchZXXFnTnDHyU+r76WuJDZIMx09ij3RIdNIm7qP3QDKB?=
 =?us-ascii?Q?Txqv+YVeu/yWMRz/kZk6bUOKDkLmq7hzL46mp17VDAwR2tocJcOboSEqFgUJ?=
 =?us-ascii?Q?xYRKsbnx5Q0ZszjRABKHf+p/DTUPeR6Gkse2RsLRcZSpOBz+snqSlBsxQAMA?=
 =?us-ascii?Q?Qf5q9RlSZtuhJI0VOz0hyV2Ff5VZpMCQrgnqM9YejKjH83teNWN2hC9mSwzH?=
 =?us-ascii?Q?HhvfxLCIL3skJuEtet4xScTKen2uraVSs4N7Wu8OJ8y1IhXJbmzju0giBH9P?=
 =?us-ascii?Q?BuZRdjJt5h7k/Q+oOO7Vbf093owPteZUxq1BLZGUC3+y9Owlx8Fr1q5fa8b1?=
 =?us-ascii?Q?3d4GpiGSM/eD3pVy5irarY1qdGzXUX5Djv4dOr1bU7irLYcBHnSRVl/+ToLD?=
 =?us-ascii?Q?AFxGzMoXfgyTLgzLDhxLyPkCxeuayh1Wpo1K5Pq+Ib4mh9H3PGmnIySk8WOr?=
 =?us-ascii?Q?5C0jJXItiDz4eApKFVV4WxhGFICOLH9OB7qDSOnWHUivN3NJ03jnmh0+jix2?=
 =?us-ascii?Q?cJcJ8o3fdAuOupXtcY6dUP2FXpqT7LtwXio6wxnF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf38b016-af77-4ee3-57d1-08dd1f2bea09
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 06:19:23.0476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymECprnVNMdE2wYcutT6+mS2Z7yAU5MsEoOikjU3KV4VZw4StH3ve62kBBadK1wJfgmQl6n4BGatDVKYorKgJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8144
X-OriginatorOrg: intel.com

On Tue, Dec 17, 2024 at 03:29:03PM -0800, Sean Christopherson wrote:
> On Thu, Nov 21, 2024, Yan Zhao wrote:
> > For tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove(),
> > 
> > - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only once.
> > - During the retry, kick off all vCPUs and prevent any vCPU from entering
> >   to avoid potential contentions.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/vmx/tdx.c          | 49 +++++++++++++++++++++++++--------
> >  2 files changed, 40 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 521c7cf725bc..bb7592110337 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -123,6 +123,8 @@
> >  #define KVM_REQ_HV_TLB_FLUSH \
> >  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> > +#define KVM_REQ_NO_VCPU_ENTER_INPROGRESS \
> > +	KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  
> >  #define CR0_RESERVED_BITS                                               \
> >  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 60d9e9d050ad..ed6b41bbcec6 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -311,6 +311,20 @@ static void tdx_clear_page(unsigned long page_pa)
> >  	__mb();
> >  }
> >  
> > +static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> > +{
> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);
> 
> I vote for making this a common request with a more succient name, e.g. KVM_REQ_PAUSE.
KVM_REQ_PAUSE looks good to me. But will the "pause" cause any confusion with
the guest's pause state?

> And with appropriate helpers in common code.  I could have sworn I floated this
> idea in the past for something else, but apparently not.  The only thing I can
Yes, you suggested me to implement it via a request, similar to
KVM_REQ_MCLOCK_INPROGRESS. [1].
(I didn't add your suggested-by tag in this patch because it's just an RFC).

[1] https://lore.kernel.org/kvm/ZuR09EqzU1WbQYGd@google.com/

> find is an old arm64 version for pausing vCPUs to emulated.  Hmm, maybe I was
> thinking of KVM_REQ_OUTSIDE_GUEST_MODE?
KVM_REQ_OUTSIDE_GUEST_MODE just kicks vCPUs outside guest mode, it does not set
a bit in vcpu->requests to prevent later vCPUs entering.

> Anyways, I don't see any reason to make this an arch specific request.
After making it non-arch specific, probably we need an atomic counter for the
start/stop requests in the common helpers. So I just made it TDX-specific to
keep it simple in the RFC.

Will do in non-arch specific way if you think it's worth.



