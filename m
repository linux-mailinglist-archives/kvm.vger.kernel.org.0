Return-Path: <kvm+bounces-56679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83520B41A37
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 11:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08C3C1BA3FC8
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 09:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277D72EB5BD;
	Wed,  3 Sep 2025 09:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c8jo8zh8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0B31B3935;
	Wed,  3 Sep 2025 09:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756892345; cv=fail; b=KKZvWC0ALJUDerMd0sPLxUhK40IQFLISbT9vbU6CDw5PKeimhOpX2lsQHcQW/2SUX65vBu3m1MNIZNmM7NZ4hK30wjtUjRIgROsrs00cC3FZGk5+eixxN45TYWywqlgtsbAakidMyCKpj42oQPZzzQ57HXl1YvvRHyYT/KMT7fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756892345; c=relaxed/simple;
	bh=/lyPUu1MQUtxFyajW+RsUav75hocHhSBFKB8UrAIKn8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eSpoLZ/vZ9e0mKFOsE/HbAjwMtkrgwQksPQ8u/Af7of6H7b9cfm3jLT203Et83+5z0OVB0RgNlg67NFoOOaf9u/7FEabWUanW6Zbsql/U3wGMe7jo6eXCnpKjNN+npt7gccfAl88n3Xjzi0i/3XKtN4QdMSXAlo1qL05rWbIlro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c8jo8zh8; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756892343; x=1788428343;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/lyPUu1MQUtxFyajW+RsUav75hocHhSBFKB8UrAIKn8=;
  b=c8jo8zh8ka0aJ7MhuJdjuBa2xEUvjetBNDT8+mMp1bCIUfSt5YJzGNN7
   obRiXmspttcBuMo/b/oz0EIwnKTpYMx67j+60BNvlKBixUn1MhSqdV4wl
   1PW7wGcQteKUQR4gbTjtlIt9V2rMXgzOT7AA8Lx+dNWk66OUyRliGe2A1
   5lWeofmD3R3+3ZwDATQ0Dd021eyQcz0+tHYIUcp0tsXLMxRNHumCFWeBn
   +25tndj/L5sci0B/aSHJEGwuV+B2y1NH2hOyc9eVvsYqWpBlNqIWPz4SM
   j0XK5k2FNkBQK2TtZ5lBvAiPUzd4VI6BHJaeuv56fbRfu5Rsj4h6sg0fq
   g==;
X-CSE-ConnectionGUID: ZC8tDAgiTIyLGGf9VCQtZw==
X-CSE-MsgGUID: r0OEjLGBTiuZJaCFe7YIvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="70577169"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="70577169"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:39:02 -0700
X-CSE-ConnectionGUID: aGpNaaXuTGaWde4uEQBMSg==
X-CSE-MsgGUID: mAkLmR2OSMa1xvsxMH2VWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171690044"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 02:39:02 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:39:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 02:39:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.85) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 02:39:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FK65ABhtqLY1aXE5qB1ONPdtVR8ZOhxbv4ifuPy4Epa6m0hT695TU4JnKWB+rA6IE47vEAQY2rGtVjPEx8EqjrCa8c6ED6/Pk6qa/cjIBYyJzfo88VQTYkr8pZ6DQxQSm6mMg8C/zQieZJWnnDSx4ipQDUzEi3e7fKvG4WB0ybytCVxFeDu2cADPSRkwQyX0UwHUqN3iPC7S1+6lXmlShc4OwLP/ljD+4q8G+D+v6kJE7rw7d1Je5KyVnFEwO58PlVA73UEy5vFKAxfx4BgZ/1wjUbC5qx7K9LnXStEP0nBsikyI8nIIshDPaOSzRbHMzbjVngxInLrgnG+hw4upng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3irkBId7UNWvyA1QBEdwA36YVKQVIePNP/3aIllJVQ=;
 b=iGWqUd5aHgBpYPZ0P2f41iGIjOW0z6UUfGRuQfcsnNCb+wiErSNJIxjjoj/iR5qZqqyGXNk8OlsUGotn8WJuebFuNivM3MEf9Dq/g0zizDbKKKegtIwlG3JeNYWcGafFnYw95rgV7Q8hxXhQyIgbxHF4B4VxfT0COd3+vabEUtLnrMkBNFX7yoRJ3U3YZjl52UDMeoAcA+N3k49jFjj3BOfBOfBoK4dndjr1WWYpuYlNesSPkrIdHDIe7JJecFm8+4aMb4FKBFjLSSzdUzOGoB83zL7/W7brUa+aQtXr9AUKj0djihFADUBj2eOVYO/d86UR3TlQgpucYJqhNmkkcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7316.namprd11.prod.outlook.com (2603:10b6:930:9f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.27; Wed, 3 Sep 2025 09:38:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 09:38:57 +0000
Date: Wed, 3 Sep 2025 17:37:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vannapurve@google.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aLgMd6X1qINCjozy@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <ce8da923-ae46-4c8d-9efe-a43fd29749a4@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce8da923-ae46-4c8d-9efe-a43fd29749a4@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f09c111-896d-4a2b-fe5c-08ddeacdb478
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NWmns9sTc4An4G/4/o/qAs3At90OQvYPRjZU9+Pjgh3wny3ucRJTCextsOsx?=
 =?us-ascii?Q?CKwwKHkS96ZGHOIE7OPkdZgeeKjVcz6/eB2r6TJksLrKBvBZHXA2z42OyGml?=
 =?us-ascii?Q?TcfWrI6ONUh7OI8pGPtP0qjw4Q9wyKaMxojiW/kHJoHNfGO1M9B2r5Gx4mQJ?=
 =?us-ascii?Q?boS4jfQ301RLoTpm0UROEAxQawne7f5nFkeSnpxiaSgkpwqYYqejZ9h/3oDG?=
 =?us-ascii?Q?BOexXu1tlJHDzDrtR7a+x+4QvnvUFkS7yL0/DR+uOevbyuYIvcAnMHqBaIJg?=
 =?us-ascii?Q?jkYXt8jEgMy0UMkMEYsH2o6EySsWwExUiCX1l0keI3i/y+X5j0qgzvo2ofrR?=
 =?us-ascii?Q?/vf7T95KUGdCedENTvco+PT7+DUZfOSs6Wm4gOJHXVS66WEYrhPqzIVtmv0O?=
 =?us-ascii?Q?F3PJaYV+Qlk80sUSKA/XWMTJEMfELTM6oVSAdPmFym8EIFzt1oDQLEOhU4FK?=
 =?us-ascii?Q?XcxI2007fTDPiCjgVBr3DyfZ47/u6PEJzbXeyK3kDFnvfHajvtdCl9BiHoOm?=
 =?us-ascii?Q?8fLQJBDe2cMMkw5HYj82otYCLKPnpqcqbDD/Xr7jz1gDdW8RazO0IyCqdoRK?=
 =?us-ascii?Q?jHhfI9CvO3HekQFJA4xLhUA+x9WWHnOmz7yeQxORiRC9+UoA/sj5MAClfyjS?=
 =?us-ascii?Q?HRF3JdLSO7R/liFQOSUxbUAfxHqCLnXjTrPNWywKUBPYRtNTd4tZdbwlV7KW?=
 =?us-ascii?Q?mdqqGehJoJ117U2NzlNyYWAreOz5nbCKGBjf9BVH6v+i82lStu2AfYWSNr7Q?=
 =?us-ascii?Q?a6e/hHj9MwLns6dg9rDFfT+68ABWsQJX3NA28WFH19/NAE7LhmfL9r+FhfTk?=
 =?us-ascii?Q?gM5pV0eShsXD3vB8UzNPv8qZ5u11RGwuR0NpOXMgCyjyzrVI2KIlR3kgYlp4?=
 =?us-ascii?Q?Wc0Q4g+nWktndDEwALmnBtAofEfYFEzhMQAgcQ9cPkBWKEjYLr+2tuXXYHw8?=
 =?us-ascii?Q?OeBp9eLb7Wwv8bEb6n7CMc3RItMwIk3EMAhqkSjopWlMpDPfyUld3DA88K8B?=
 =?us-ascii?Q?L8U8e02mzNGDuqwvU13EhBLNgzvOLO8qSJ+tMFudYEkkWcAyjBjjqdSuIesS?=
 =?us-ascii?Q?q3h8med0QpOa2NeIjNZIbBDgfs30IUJemD/DQERFyqlK1/aypizXq5/SvuDl?=
 =?us-ascii?Q?JMJcXqZ24d2Pp5hSj/C0oiFeaLD+z8HJepuphPEnwGsFEMGwJzSFzcAU9Fu3?=
 =?us-ascii?Q?MBimxUXCHnMSnfjhriMWQL8Bj4B2JUKvnDviJ9TzAW+10PyIZLO8Zf5vm8v2?=
 =?us-ascii?Q?OvtzNFeuWRxPoWazLJifLnQiPTwXXcBXuI4pT/2KfykE2uTXjClSMLFfYgL4?=
 =?us-ascii?Q?DqRSlfYZXkCuzwQVBCLJWuUL7TM7Mg8drL3Vdka0lX1xYEvLiqJspi9JiGGF?=
 =?us-ascii?Q?4l/fPOg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y/1+JRPT2G8408z8uLBS51ytA7q3NKRUPHvs0+uYNNOntzaWXRqwvOni8u2t?=
 =?us-ascii?Q?7TdMvh5LXkX+lEMe9ROwvf19Sq7s9lAUV9+jAe7SCUKX9gAUK4LbSvbW4JyP?=
 =?us-ascii?Q?9jM6MvYJnvSmJtk5lc4XO3wbKJSSr+Ebm1MbAj/spUu6WKnQJSyknYAPVFTi?=
 =?us-ascii?Q?FLSytKbfyKupCoSyRcCCEhMOWAKCBqRLK0cT69A5uxHuJmGIwFvSBgRNq8Eh?=
 =?us-ascii?Q?pEbPTgDO4FNL+OARGL9I/TMeUBJwrjG+ugW04HrUtv49FqwvnKcKwS7whojz?=
 =?us-ascii?Q?F9x9ErtnkoPz6hAUlUAeX6CQ8SUGixdUiCqHKFDM7D0t/v5pEhuS+YqRBXzw?=
 =?us-ascii?Q?x9hnu9yfoskIZigqEcyMJ3lBBEG8IqeEDg6VboYRWbOwm1GjDymcanjl6TKd?=
 =?us-ascii?Q?VZn94kiB2/HQ0Sih/+3QP/iEu7up96A7XP0pmpVsmXaV2LY+IACYp2eq8CBd?=
 =?us-ascii?Q?R1uDfo7/42Kv25jpk4Lana0hvrwm7rjpCOVg8IK+rY+yB7lQDC+MooI1UAKs?=
 =?us-ascii?Q?lNzjFRSlNNUF14Cm6EoZ8hHXh/fM6UZUMsy0/GYMJsjAWKzdxxMO/cREmbAC?=
 =?us-ascii?Q?Hcwg8sjWrRykgrR7/wPoMBFEKl37aL97sccvNnGeqVW/8IsCOQkxVDQT9Dtr?=
 =?us-ascii?Q?p57GHF0c8nuBIW86nWY4jRNxojx3ljwh4ofjCyCy3hlID8RyCe4m5lwk9P8L?=
 =?us-ascii?Q?rjOVJt5N6w9DjNnC/MoxoL20b31uiR0nHGpjtzZOiDdNC4EUb7u4h5yAqwhn?=
 =?us-ascii?Q?CW+AjVzIB5UfXvYxOVQnvABHmDo710noSl29BCKMrPfW3LCF9MT3tvNWn1/a?=
 =?us-ascii?Q?CW3wSqvpHRh/jBjcSvgYct7ebN9pJdhBPA66F2VyYYfcx4VTt1giF1iZ18bB?=
 =?us-ascii?Q?jManBNUKpKGxSDsxwGamGA6Os1H9F9xNPZ3An5QX3x78pm7UQH4wMz21ep13?=
 =?us-ascii?Q?o6BG9tN+n7r7J8ZqNxj837Km5pk/68FsKI+WbE9BYoDozWPXM5vit1mhf4oD?=
 =?us-ascii?Q?k43+JpFEjGUIXuoxk8d6qb0bgCFwj8OZmEZSzeV9Mz+hRw0gRamb0lioPAnQ?=
 =?us-ascii?Q?+LgStZkycIolOJi6SzhmN2MgXeHYKL4Eg8j91R3ACI6l07+l1mbhmWJAIhVC?=
 =?us-ascii?Q?HjorOTO51uH+7dMDDycEdNEoTk1cDsxP7iq2QFnq95khU3F/4blNLWbUPsQ0?=
 =?us-ascii?Q?gbSTLVZJ2utzsc3I/no9h6H/qet8/bMSXptOaV2Hn6WZcFP1emWjvTMmUuBP?=
 =?us-ascii?Q?/3ouiIalvVuYn9WNzSUDDFP92l1EaQ42e+M03ZuwGtc7oLfE3vPAl8z/DL+C?=
 =?us-ascii?Q?KjphKKoBS/HLGrqtindcJbgwP5sG4Ca4IayCdZOqf3kGFqHhc8wyZ4fKAMRX?=
 =?us-ascii?Q?mi/SgKdvqTE+2yrMZlt5Bs+Gk9Izy4HJDb0ooZXsop12lI2leBpHKKw+ZJsg?=
 =?us-ascii?Q?N5zRfZ004Ses535TH0yhCDewyat6mdhJIdwVGDmg/XcHB1Gs5GwcLWTTNqiz?=
 =?us-ascii?Q?TqEMgV2hVNtRo33x8TUG98LQrnn9QGfzc7gUoyqZcPed5vhj/zLA4A7IcD6s?=
 =?us-ascii?Q?MP6t3eeOyZjyWCtRXRZA9oIqdg+SczjTev9RYAiB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f09c111-896d-4a2b-fe5c-08ddeacdb478
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 09:38:57.5435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuq06Ww2593CXv89RJ/1wDkKFUU3r4Rc5hl6gxt638fxQU5T/MKb0aeClpFfopx1BTQtaWHswTTmSUqOtcqnig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7316
X-OriginatorOrg: intel.com

On Wed, Sep 03, 2025 at 03:36:49PM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:44 PM, Yan Zhao wrote:
> > TDX requires guests to accept S-EPT mappings created by the host KVM. Due
> > to the current implementation of the TDX module, if a guest accepts a GFN
> > at a lower level after KVM maps it at a higher level, the TDX module will
> > emulate an EPT violation VMExit to KVM instead of returning a size mismatch
> > error to the guest. If KVM fails to perform page splitting in the VMExit
> > handler, the guest's accept operation will be triggered again upon
> > re-entering the guest, causing a repeated EPT violation VMExit.
> > 
> > The TDX module thus enables the EPT violation VMExit to carry the guest's
> > accept level when the VMExit is caused by the guest's accept operation.
> > 
> > Therefore, in TDX's EPT violation handler
> > (1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
> >      from mapping at a higher a level than the guest's accept level.
> > 
> > (2) Split any existing huge mapping at the fault GFN to avoid unsupported
> >      splitting under the shared mmu_lock by TDX.
> > 
> > Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can
> > perform the actual splitting under shared mmu_lock with enhanced TDX
> > modules, (1) is possible to be called under shared mmu_lock, and (2) would
> > become unnecessary.
> 
> The description for (1) and (2) reversed?
No.
After supporting splitting under shared mmu_lock,
- setting guest inhibit bit can be performed under shared mmu_lock. (*)
- splitting existing huge mapping under write mmu_lock here would be unnecessary.

(*) is still required to convey the info of which max level the guest requires.
    (as explained in "Open 1: How to pass guest's ACCEPT level info" in the
    cover letter).


> > As an optimization, this patch calls hugepage_test_guest_inhibit() without
> > holding the mmu_lock to reduce the frequency of acquiring the write
> > mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
> > is not already set. This is safe because the guest inhibit bit is set in a
> > one-way manner while the splitting under the write mmu_lock is performed
> > before setting the guest inhibit bit.
> > 
> > Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
> > Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> > RFC v2
> > - Change tdx_get_accept_level() to tdx_check_accept_level().
> > - Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
> >    to change KVM mapping level in a global way according to guest accept
> >    level. (Rick, Sean).
> > 
> > RFC v1:
> > - Introduce tdx_get_accept_level() to get guest accept level.
> > - Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
> >    accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
> >    mapping level.
> > ---
> >   arch/x86/kvm/vmx/tdx.c      | 50 +++++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx_arch.h |  3 +++
> >   2 files changed, 53 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 035d81275be4..71115058e5e6 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2019,6 +2019,53 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
> >   	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
> >   }
> > +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
> > +{
> > +	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct kvm *kvm = vcpu->kvm;
> > +	u64 eeq_type, eeq_info;
> > +	int level = -1;
> > +
> > +	if (!slot)
> > +		return 0;
> > +
> > +	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> > +	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
> > +		return 0;
> > +
> > +	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > +		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > +
> > +	level = (eeq_info & GENMASK(2, 0)) + 1;
> > +
> > +	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
> > +		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
> > +			gfn_t base_gfn = gfn_round_for_level(gfn, level);
> > +			struct kvm_gfn_range gfn_range = {
> > +				.start = base_gfn,
> > +				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
> > +				.slot = slot,
> > +				.may_block = true,
> > +				.attr_filter = KVM_FILTER_PRIVATE,
> > +			};
> > +
> > +			scoped_guard(write_lock, &kvm->mmu_lock) {
> > +				int ret;
> > +
> > +				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
> > +				if (ret)
> > +					return ret;
> 
> kvm_split_cross_boundary_leafs() calls kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(), which could return flush as 1 if any of the huge page crossing boundary is split, return directly when ret is non-zero seems not right. Also, the TLB flush should also be taken care because in kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(), TLB flush is only done for negative return value.
Oh, good catch!

I forgot about the 2 facts. Will fix them.

> > +
> > +				hugepage_set_guest_inhibit(slot, gfn, level + 1);
> > +				if (level == PG_LEVEL_4K)
> > +					hugepage_set_guest_inhibit(slot, gfn, level + 2);
> > +			}
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> >   static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   {
> >   	unsigned long exit_qual;
> > @@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   		 */
> >   		exit_qual = EPT_VIOLATION_ACC_WRITE;
> > +		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
> > +			return RET_PF_RETRY;
> > +
> >   		/* Only private GPA triggers zero-step mitigation */
> >   		local_retry = true;
> >   	} else {
> > diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> > index a30e880849e3..af006a73ee05 100644
> > --- a/arch/x86/kvm/vmx/tdx_arch.h
> > +++ b/arch/x86/kvm/vmx/tdx_arch.h
> > @@ -82,7 +82,10 @@ struct tdx_cpuid_value {
> >   #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
> >   #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
> > +#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
> >   #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
> > +#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
> > +#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
> >   /*
> >    * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> >    */
> 

