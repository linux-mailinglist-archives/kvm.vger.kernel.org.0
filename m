Return-Path: <kvm+bounces-63666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 502EDC6CA5F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 815244EA127
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D77AC2EAB6B;
	Wed, 19 Nov 2025 03:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gUusJ3CO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDFD1C5D7D;
	Wed, 19 Nov 2025 03:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763523848; cv=fail; b=cdSDPyB+GNA09k+Qjz6jSFmdHwYW1sEtEUcJezKblrvH6fORaLX8PUOpTb9A6nDHjfvpgn9BibsDwTNJgSo/cuP4eCs2H/jPtu8kbfAq+/PB1r5h/hHwbfyf/bKYI0sqj0uGBmhK/xMSxMXicZu8CknBERFygTvICcYwgiFUZ+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763523848; c=relaxed/simple;
	bh=e/z8dYxy9OZIUwxAs4ZqJW+9N2NjdkgXO79IXfEf0Y8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NKne3QoKP42x6vMQKayeMydK/ZeX6rJrWro5JCGAlcba5bjvMetnfFUNROKIcWA61O6hwP2u+2OLRsAHcNvjHXihx+dYD9omcbOuw1hkRhHEFUCutPtKTi3VXoMcbAs5VW7LmpoiESYSddtKIeAQx/WQ2x7VpBcgwo99D/9nFh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gUusJ3CO; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763523847; x=1795059847;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=e/z8dYxy9OZIUwxAs4ZqJW+9N2NjdkgXO79IXfEf0Y8=;
  b=gUusJ3COGw0avd9jHmWviH/CocZxOef3W3fvQv9gU4QIiukijHsHDObm
   wZlEesdbyz1oR0Szb2mSlc+e/kF0K3GrH5OONRbVlQTO3Uot+4aKYJq9a
   GsmlpdyHbIHibODZ3+QgGKKwkZRECYAoBIOxZmhdCyDCAbebjSNfrHLn4
   HtcDCCycb6Klfops/OPeNro5bL5757R4QZX+66RJRKqg51/GaIJp6FbJ2
   85YglSdb7UmWNAwLrGD5LtYjpTGJdlOFm0cfBUh/jngqlkD2wOWvtWlp1
   v6IoFBvggjuq7MdEzfdKgKtM0L8yr8YsqHxHEBT/AyaQgUU4Ur8DegcCb
   A==;
X-CSE-ConnectionGUID: GbXBAT+qRCmHaYf+y5nQnQ==
X-CSE-MsgGUID: 9/sipkx3SuO8c+25q/R9+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="64562038"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="64562038"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:44:05 -0800
X-CSE-ConnectionGUID: D/V+RN9OQy+bxTBzK0/w3g==
X-CSE-MsgGUID: +fgnbYyjSu63JYLnrSpmHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190734894"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:44:05 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:44:04 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 19:44:04 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:44:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhyF0u8BNjZqpjcU0c/6aQj9fU3B/lEe3+IIkVXUH8nKWtGgpKYmAaelGbidVk9r98uO8pa5qBIlfPYBNLl8nqmPMk4NaaSmIchdCbHQb5nVKKGL27e6cVIX7Y+3xm40jA9ectMEAJR+BwSiKrk0QgIIFvYUw5Z2FQk32foePfmUr8P6LnRf8s46tpKTsf8qtl0TSj2xI6Rmy/jHkUVtaeNbfab/pYDyMiqOnZs6MqVgB9Kw0OMsvn5OrGITi6xnweyCiPTfUrwWMLabmphR9wR9BzCvClz1hVXdXic1kl1aBPe6tn8dPnlr1PGbpxhPrEFQHEhm/aPOSSQCbXzvBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/opcAYIr15K7zfEwcqfiB5Eeitbx+MILSpGmI/t+vA=;
 b=cVJGoh9eHTD1ax3Lsq18380N4d9EZGMMXwTJgfJ/EZ6DkEbZSC3iXNAO/7iVJLoNWIhitdYkFWBvTJkTaKp5ABUb9fQAGOKzGOUVt6FTQc7Act8U9mUvCT1Qb4Wmzb7BC/Kw9gHpNECttQFxlcmWDM9kHCuI5ZDfef0Sl54rJA/2e9v+ZtacUW+/q20+3S0y5rvRDjwPxqp7yIcAHfgCg/I4riuHQKinJYF/APuBERdUIK/w2HQjy+o3o7Qf9QaHTtNEkQsP7Cn6PBBiuMtR9G8jq9ksp0iO4txALixvy2za7Wgizxi2/d0ZOxYiq5KZEb9tbCEnCxEIWkI/yMynRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8122.namprd11.prod.outlook.com (2603:10b6:510:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.23; Wed, 19 Nov
 2025 03:44:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 03:44:01 +0000
Date: Wed, 19 Nov 2025 11:41:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aR08f/n7j0RyGlUn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
 <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
 <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8122:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e06cff5-7946-4ce1-855f-08de271de0e3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HDvmrfimOjgTPb21GlB4IrKgSWZSANN4ECggGXOOtR9BaAcQn+pukrgJ0p9Z?=
 =?us-ascii?Q?FBSOtpHH9cG2FyBuDod9US9E5Oj2IuTCyjtwU6EFE7F2DQ99lrSXG1kZGbxn?=
 =?us-ascii?Q?yM5ysiZS5F8abIUD0BE18a6PNEjo6t1cBRzLCTurkUmCdBQAo7AL1sH91uRW?=
 =?us-ascii?Q?ASsXiGsonuMEWfA3lMQIHFETBHOwyufAStXbWL7ZNl0lZJnbtzK7jprFrsrD?=
 =?us-ascii?Q?408NCDQ8bCGYV/BZ3E1zFZAkL+4c5mhU9LB0itBnSt3RnO4Ige2HX333qCa0?=
 =?us-ascii?Q?sDfaos9pMi7Uxd0o7CK+bKEacnZxRjnmngoltO4GuDqAwrB8aIomxlLp0vUw?=
 =?us-ascii?Q?H/pc/SiRgFudAr7Xfk6DN5lIogzXs9QP8/CzNQCSRXGVBGxvCDLDDvtvl6Lm?=
 =?us-ascii?Q?bfabskpDcSdUJIW2xNnQdvkGtbMDNDnsTj8GKD+zOW0YqOg4l6qC0IHriClA?=
 =?us-ascii?Q?2DoXPAwITE63qu9Es8WwB68FYV86RDpMeEUlpxzNmwFO2Y9miaBSLvi7EqXX?=
 =?us-ascii?Q?L3fdVEubSUYdYBEwnnguFIQXULxhw07zcwGNFkmxdCy8lip6roixqi4IzkHM?=
 =?us-ascii?Q?Au+WmyFcX/qrJdOFk6jA0i86nXuMK5uQIjQmwWOVxmmmgtzyIYq45IBk6xy8?=
 =?us-ascii?Q?TQfuqwDd9iEmIu3tBKyLdxGg4p4EQuVL/tBWraowpu8jGdccvEytwRGyYBhl?=
 =?us-ascii?Q?m1Ja6AXBesU01V8Z5dYJ2q5NVuVg67RZeYf+QEWO5SFexjsSFHj+puxAT5LX?=
 =?us-ascii?Q?oudabiAqhzQEcOdFXLQf40RF8vr0J3QRWnR+I2jmv+m85o7ePjmdo/b/hywh?=
 =?us-ascii?Q?+xqUjBBVz4zJ158Adw8E25dtPIXbq4fa9GVCM8v1GFHIt0Jrye4VrMBC4Vwy?=
 =?us-ascii?Q?7zse6XkbX/W+RtqPYUPfD5CHkLJG7xiKDiZdjiVAUzA4ru8olkua4jwb7zFZ?=
 =?us-ascii?Q?7Yqe6chwdA9vjb6UaFkAItCd6taIHxEOFHNjZISxSelJQ9uyh1Z1Ng5B1Nn4?=
 =?us-ascii?Q?jyTDrGclsDQ267vjXK5izNSS1kcMjJR5yp5GisYFatysUiFE3+7ovc2cLZ26?=
 =?us-ascii?Q?SJKvG+yx6VDENlGGLRLhy/5XNwc4TcxjFdhW3MNCyV2+Ep7T+i9QFm98bL3h?=
 =?us-ascii?Q?uP74urUNST1jW9DPFJn3hZk0bg1JWD/5mgsudu3dV5c9TwEa0iBtjeI7kYSn?=
 =?us-ascii?Q?VC/xKY2CNIjgpar4+goVdFedR9vyuH+LtmTMEc4sYD9Bb6XHQuhHxen/oVg+?=
 =?us-ascii?Q?OPX7G2K5zOaZHfvQFqxps0ZNrDwdTSVACxIcUbtwv0jcypbq0l3kTGL19RPZ?=
 =?us-ascii?Q?nCr0uMH/jhWD0benwALMxfS6bSwn4SK6gzBE291RoiHxiMyhvmMgSDrQpXD3?=
 =?us-ascii?Q?/2mcUVDE1/Z9bHrvMHnatGf8GQYwFW5F7A0Y5dQ5nEwvSLnY9XIdQCovIv9i?=
 =?us-ascii?Q?6ZSuJ10PK+kDP7nRzvOVydwAIdiRaTIDEjimcqXlBONgJJ7M+VzppQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GB2K5Oe2P1fE1/AxlPaTy7hJ7axPLshBtqsXVl2IpweHxIJCNd/ByEF4kkQ3?=
 =?us-ascii?Q?RGKTEyv1jhROT8IxeO6dxbT/fljLf/vqcvtrzZ0z3wkgUcuGcxkjM16A2SIq?=
 =?us-ascii?Q?uIj91Pra6tWqJvxEJUgQi4/Ee6i2tlUrxaN+zX34L3D04OqIuJa5+gTKyFYx?=
 =?us-ascii?Q?xeYOxgNDpcyD5FJeMftWuebZUx8qpovGmNe/ZL2PFW2n2VpmpiSCgmYHCHBY?=
 =?us-ascii?Q?KAgeS0uaDci2DRk74JkqqdZZeYG6pxXIRFHgQ1vX7KdknGBhW4WkT9cQMomA?=
 =?us-ascii?Q?k+sv5BKIQoTpxQUmNYghrasaAGPvBU3P8ZlON6TtUSi03SVZNmq8nUnlH5Hg?=
 =?us-ascii?Q?TCYzT7QrLA75JSqZUA4mPe+mCPIAPw5EwKqCClQzMbNhH6uOWe7pUdugl3st?=
 =?us-ascii?Q?jqJK9wnB7ZfuRRf8W+D6AXVIKAlK2Qk5d/TIKn0mgSus1ARwR/4/pLADpffQ?=
 =?us-ascii?Q?RTem0OHPxlDbYhmzr7FoCSKaUWKlh0bQ8wEFOGdINDIGwTrjhZM2Wo/5M7M9?=
 =?us-ascii?Q?0Zdbze8BXgNBiTjJfelkjDkd72/VjVV9R/UtXtnoZixieyUBKTElo/0PQrHI?=
 =?us-ascii?Q?f12wP3zYnrpvfprapmwCcvZLVX9vtSHwYU19lHN7LgFxv4kVhYmnSnew92dy?=
 =?us-ascii?Q?z/0i54lHsWrInVwxD0oCMbQfNFc5ZaNC61pO2mX1QuMPedAuk9cr0gPt2C6G?=
 =?us-ascii?Q?08fbnmzrky/i0mVFFmlRW4mbJXMw4TlBanPlfvJ+HJX9e9C/SHu1pxO2N6pn?=
 =?us-ascii?Q?YTc7Pb69VycB288d0hzl1qpV5/o2QZJZIEgwdpEFs+8qnqPqAKPOWiFwip+7?=
 =?us-ascii?Q?ROeY3y5jcMLMUteE93d+nn49xztoo6Wn4MyfHmenYJntIjKsgHOneAY/KXgx?=
 =?us-ascii?Q?HbC8VDi/uxCyGbfOTKyF1JqjtKj82goe6aB91qLY9sEkNEM8acG1NI413War?=
 =?us-ascii?Q?mq4c2z9btcTq59jFDOrAtz/xINkRYw5xq3ec60LfbqPclcZfle4shH2b8So1?=
 =?us-ascii?Q?Jw8Cz52lcQgGmu4EOrd6MZAFiQBQWNgrnuYn5gjzTtgc1Zw7+SwiX+/cgxzp?=
 =?us-ascii?Q?HzYENiXwWGgPo9nwYBH6RiUQJVoG2BMI8uHAaeEJW0UhjVPkkqMl5djXnTav?=
 =?us-ascii?Q?FzxlKCwmbqTfAUigjP6sF+wY0Kk7t5ojE4JfwutuMhHOQ4httbYdV+K5DZNB?=
 =?us-ascii?Q?jUAbK6l6DiwhOOlqco4GLACa8KnOpyCMPPacq0HdAPpxTp1yzLJ0ZetgCGUS?=
 =?us-ascii?Q?4hOULyWQbTaPcaXJ+cUMW8zLVqqKlzJLSX2wp/Xbfud/EgdE8z+IMFSXvnmo?=
 =?us-ascii?Q?MTAx5z3dAkh1jeSzshAP696/xmtlAlfadoWHffzxUsUTvGynTcgvw9VZ42if?=
 =?us-ascii?Q?HWylLKbJAiObhXz2OzFNSQ9elYf+etVJE6ul9CVv/Hj1CpvY8pUdwbCUB73l?=
 =?us-ascii?Q?jBRkyVj39K0nTD2JEytSonLTs7TI9Bav8cJ2Xxi1/Cv/N56nKP9KlC5mNSce?=
 =?us-ascii?Q?8CQbvRqQCiV3ToGM8W4kFoApUinw76NrH/FKhtcIXByIe03VRGeOcCsqgMgw?=
 =?us-ascii?Q?tmPIzgQ78np+lp99YRV+e/kxa1FdPUIggoG/BCUp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e06cff5-7946-4ce1-855f-08de271de0e3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 03:44:01.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0EfQftG7COTUkEMiCRNn0JE93GEzGAHvtszCpRxv/IdQMV2nGy/UaGdNvYu/poxkM0hRw2Z9Vh7rHtf9JKbRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8122
X-OriginatorOrg: intel.com

Hi Kai and all,

Let me summarize my points clearly in advance:
(I guess I failed to do it explicitly in my previous mails [1][2]).

- I agree with Kai's suggestion to return a "bool *split" to callers of
  kvm_split_cross_boundary_leafs(). The callers can choose to do TLB flush or
  not, since we don't want them to do TLB flush unconditionally. (see the "Note"
  below).

- I think it's OK to skip TLB flush before tdp_mmu_iter_cond_resched() releases
  the mmu_lock in tdp_mmu_split_huge_pages_root(), as there's no known use case
  impacted up to now, according to the analysis in [1].

- Invoke kvm_flush_remote_tlbs() for tdp_mmu_split_huge_pages_root() in this
  series is for
  a) code completeness.
     kvm_split_cross_boundary_leafs() does not force that the root must be a
     mirror root.

     TDX alone doesn't require invoking kvm_flush_remote_tlbs() as it's done
     implicitly in tdx_sept_split_private_spt(). TDX share memory also does not
     invoke kvm_split_cross_boundary_leafs().

  b) code consistency.
     kvm_unmap_gfn_range() also returns flush for callers to invoke
     kvm_flush_remote_tlbs(), even when the range is of KVM_FILTER_PRIVATE
     alone.

I'll update the patch with proper comments to explain the above points if you
are agreed.

Thanks
Yan

Note:
Currently there are 3 callers of kvm_split_cross_boundary_leafs():
1) tdx_check_accept_level(), which actually has no need to invoke
   kvm_flush_remote_tlbs() since it splits mirror root only.

2) kvm_arch_pre_set_memory_attributes(), which can combine the flush together
   with the TLB flush due to kvm_unmap_gfn_range().

3) kvm_gmem_split_private(), which is invoked by gmem punch_hole and gmem
   conversion from private to shared. The caller can choose to do TLB flush
   separately or together with kvm_gmem_zap() later.


[1] https://lore.kernel.org/all/aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com
[2] https://lore.kernel.org/all/aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com

On Tue, Nov 18, 2025 at 06:49:31PM +0800, Huang, Kai wrote:
> > >
Will reply the rest of your mail seperately later.

