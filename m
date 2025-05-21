Return-Path: <kvm+bounces-47249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAF7ABEF64
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEB9D3AADFA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BD723D284;
	Wed, 21 May 2025 09:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XCDdkCCN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F223C517;
	Wed, 21 May 2025 09:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747819117; cv=fail; b=Euk//ue8b5B2a1pCVzuYGlkHAn6P9KbXI6VL2QqlJBFofLom4YQux5+8+2HVH8xg0IllPSTruJEJStDap+bDMFF0NDK6crzHMY3bChSM7iDp18QpwFc5ec4BqXm6dwJO3Mq2UjpIEiKuplU4mvSZ5oqLVNiysZOiYCvLqbW4Erg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747819117; c=relaxed/simple;
	bh=gYsvEzHWm4ojj+em+XdHbOck1dZXbYFi95+DsRuTsTA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o4cN7gQfxNHB3pbnn9UldUCg64hWV7/up0P6GKNm+XERw0RLB2yxn2Y8fSdTkXhtff3UvemuCTixMzgRMpky6rN+E0NoN+hFFX5urHWRPBUlSyOlo7/nDQXKhK8Kzkl469g8/x4LMEdTuR+Qoqz1Qj7S4oihHk6F9D2MgB17qJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XCDdkCCN; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747819113; x=1779355113;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gYsvEzHWm4ojj+em+XdHbOck1dZXbYFi95+DsRuTsTA=;
  b=XCDdkCCNAciyPMe0iBXIbhSH6vUR6dwVeNUuxZHQtN0xMnZT6usdpfLu
   w4Gj7PEH25VC0ErNGd1Qb3Vbbp5YmkWlJhNoolIGm80+yN1M4jbk6sh71
   SJyCU8968KDUUAJE2R2JWwVxGcTF69qViQyN4RIck5xS69oeMNkwyQL//
   O3k2vHX4YBfisPM6Nqn/aqvKtETONQfeWrH+95rh9OANg5aOCoaX/SeEt
   10hpunC3KwSjz5rQv0ia4zUT3hCKzBRBrv5XsmUFH9pmZlXU7hz7UK2qY
   VMRs22xVPWA4P7/Kmr75UDMB1AHVdFz7oLQFOCWpNQyz+PW+4cTeFrf3i
   g==;
X-CSE-ConnectionGUID: hiP4f4GySDux9Y0lYgikKw==
X-CSE-MsgGUID: /UTtJrHyQTG+C0p32gBR6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="60446026"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="60446026"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:18:29 -0700
X-CSE-ConnectionGUID: v76lKg1ETJCh7dG4LrzLEA==
X-CSE-MsgGUID: 3SwjjwPQTRa+cGCYW/yJ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="170983890"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 02:18:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 02:18:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 02:18:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 02:18:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lrh9H+8r1HovU03Cr7LwPxP8Klw7oW9pS4l2Rllryw/HjT/NW1b3sUF10EOPu8kGM86ySE7eNJI4pe72tKve9ItyiKBylQC6FDl9xtp6hPg5Ljq2dbMMtTjvwh/oMYOc1/DSh4eIEtJd0XjBJoT1hu2+U4R6d2nKOf1ZlYGAH/5H6h3WxLmB2wCfeZ2pMMuiVZarthXfTY/FWVPNUS58ejESfJM53j26TJZxBwHeCIvqFAMXdyhehFuRUS9OrzEJKhsatyfakQx9kY2sHmdZYqadNIvRhLzJprn+Kt49jwRy2qjDs6qylGefzKJqsSjReg/W5GqLmz9hbBjxQDzLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+82x9cRH43Wvt41CdWqoH3hp6H46LFN6Aw+lh3Krqg=;
 b=M4vd2VgYU2HeuN5qEZvu8rOUojtxp1T33S+xjXhgeLM5fjHjyFL1LvLi1+hk17k9BNVYjUwmE8VvW2YyheZC20BWCwHqWQ2WDxP9tO4FUEVJQV3CS4N8/qscdi+b2DsLIi+PSRbvwd6vrjXL5xTpD9SDE7GaM/lcs5VUSDrNb/EtaxSYmoznp+b1GQPngUR3+fY0HwhoCZLWIVFri10QtzN3ulxg3CDqmpB5onYUCO8HfAGiRozTIo0XFvmf/i23ETavkHtbabN8oYc3G7r2N4lAxJqsmUXjPGF/SXhU3PaHL9b09OsFp4Hlg2mVeKKsT+c5xgQfGuX2edQb3Rc5Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 21 May
 2025 09:18:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 09:18:19 +0000
Date: Wed, 21 May 2025 17:16:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, James Houghton
	<jthoughton@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 4/6] KVM: Check for empty mask of harvested dirty ring
 entries in caller
Message-ID: <aC2Z2U/HR5wAay3s@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250516213540.2546077-1-seanjc@google.com>
 <20250516213540.2546077-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250516213540.2546077-5-seanjc@google.com>
X-ClientProxiedBy: KL1PR0401CA0006.apcprd04.prod.outlook.com
 (2603:1096:820:f::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: bb295b8f-8313-44bd-d119-08dd98486d0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/ElipO/qiPgqAhwU42q0hxSQi8NXffSjVk2+7qkDb7CAjddD9lGUwOaFLR1v?=
 =?us-ascii?Q?F3iitRbqM1sk0RnvZHmPL6pJpns+Ym7Be3mN49XLW9mN/Kjam1ONf027jTd3?=
 =?us-ascii?Q?68Vd0fiOuEXgfmjUxwDmHRC09F9uutisYdjjKHBK2I/0QsCVNrr3nP9zQlEf?=
 =?us-ascii?Q?6Stxz5kKHTFpO+b58XMahs0m0VAHM6NIfD9EAtCGG5dwGcja4HqxzU88Juik?=
 =?us-ascii?Q?HZWVF90KBVtFDHhVrFZ7sfks7ZaZ8LkjTcKXoNVKN4vu1fo+xEMrRD867Sx+?=
 =?us-ascii?Q?0SjPzh2w1sY+AunmA4EU7zbDOUj0gjlY92XRRRMK3UFgsTsKXrTkIs9Ey9NL?=
 =?us-ascii?Q?1jaCUtW3FJadfmtXxzf/g2aY6vg0J3rriD3WON63xszI07Qu16PzW7L4e2Kd?=
 =?us-ascii?Q?aJveFTApBb9sSZBY1d1bcIXMeKbGC9nmywa/V31EnxU5lu6RIkppGPfuOVUf?=
 =?us-ascii?Q?I8jZZxgl9wN13sE0J1oDOo3HFG7eiHHrzil5HDEmb8AyhC8OnkW0fs8ZWtpi?=
 =?us-ascii?Q?WEX1WvCpbIQNXgjrAzzt/iedfXHPOy2KlxUKUdSls8CNhcr7z7ReMDe39rWn?=
 =?us-ascii?Q?JzVNpfWb5vGMCKgwG+Vp6b2SMxnzA7nwwWHriDEJQPdxaed1f6c4vI1Ybb9X?=
 =?us-ascii?Q?Fwjuw6Hqxy2UOve0lzchU4YoaHeGazoFcM0CJJpefbF1gN8Hw73XiemqaJX4?=
 =?us-ascii?Q?uNfQNCNZaaL7CbJ+2yCMEkpQKz7GsPrS0p/uga7bYiZ2QDteqes627O/HRUo?=
 =?us-ascii?Q?mAMlK0Rnden1WW9btI4uLjd7LJK52QHTBeTDzc5hF3T8EgjN76Ifm+P4WVZI?=
 =?us-ascii?Q?kwHOtM0i/huEphDcv6WhpDWSUcCaiidRk0PSwHPF81Bir5jAK9MaDmg08Ulv?=
 =?us-ascii?Q?cw46ixN6YQ+5Y236hNVe+Rc4VKn0aup9hYxkC4A4PXId4I00ECPNqNrnu1E8?=
 =?us-ascii?Q?dSTNwdFaWtfMdtHx/tvYMpKpo4dXkoxVLUm4hfe90lA8dQ3gp7M5k05YEiwi?=
 =?us-ascii?Q?csCw9Lw5NT64JSd3/ToQNO5BLJXZBUK4SHa8PfYAMn90CgNw+y69mfyzc2n3?=
 =?us-ascii?Q?6AhAJkZd5naRjnRdvy4CXl5WRKPKWkwZeg4d9rPf9VjEkq12iB527/+vO7Ft?=
 =?us-ascii?Q?j86EYGwLkmLcOj3FKTZkbF+xDW9Raq1VTPJat3RbcHpUZUszxbqUgv8E9qoB?=
 =?us-ascii?Q?oKsOgyzlCezuHa8y2yjeXVJ+lC83+KW1qhYuO+idDkEvtWj8JA1xInz0hZlh?=
 =?us-ascii?Q?b19DFAiKRwIMRv3ZhPmYZtbW7ru9/014xJITLGeyI+Z+eP++UDZtt5eIDpwA?=
 =?us-ascii?Q?8rBDciePOx+R7IONSEFiR+2yFKZbaz/bem5xQ4J12n/LorN1Fk4PlXqTruby?=
 =?us-ascii?Q?OjZ7AaMi2qI8wkHurfcXqoJhff6nx/bHVzhnLFKFmbGUCMbRmQulLYqkxqxg?=
 =?us-ascii?Q?GZmF7JRKQyA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RTRZ6opMBVSRJ/CSuGQ8AGJsSpziGjMS1BR0m3daXtP2tbnk1G8sNC86y1uL?=
 =?us-ascii?Q?h07gsFWZYXc+Z+2nKg8dapef+2OIEaUqnLMLdETzWeUD19ZI2Cz11qv0tzKz?=
 =?us-ascii?Q?COey8gBBHV0C+13zqT/bdJ9ZuBt0SgPMU1Xgd5dLj21mItiKR94y2nGBHyzF?=
 =?us-ascii?Q?LQEc7zdlcGXMB6Rf5CVTyw4faLP5+cjJMeYfh8VDno9XSbT9N3Y1awknKES2?=
 =?us-ascii?Q?7JpLyw0DqJ96Tr2Kg8tej0Gfy+kFfvKWFVuMlbOKh0uJOR7ptbm6o/+Gt1Cu?=
 =?us-ascii?Q?3OReiDn6w8NfADqbASPIUFA/dBO/1DBor4eK4Sx99f6ZjhilWJq5EbdKEMZ3?=
 =?us-ascii?Q?/6qtn+cTA0YBzksP5b3I1S/fLYan/TjA4qMTQ18f7Ti/TOQ7iDRhQDRPoPqO?=
 =?us-ascii?Q?B744Ri+r8/r2IlGZtbA3tqEmErZSj4s0CNyhohZrvwS9AGlZgsupVEaWwyiN?=
 =?us-ascii?Q?DbEcgWgjGNPkg9OlZpqjo0rU5jh/6tbybPVkfR0Z7vwDyTPtXTBw47gciQ5T?=
 =?us-ascii?Q?OygOyS1XSUmVTsgK51GX/J2XBKOk6gLOYd4vPBB7a68FH2TUko2AvDLLvLP6?=
 =?us-ascii?Q?7h78gHPpKiYCqCJGV7/gt2n9FWvCanbUKSXEooSDpc65E/JiObITjY9kLl2S?=
 =?us-ascii?Q?HWdrbzofhFeoIdwBLjha75322JA6ES/g7AFc9PP3grKvMCyjpnJZo8Zf/HLf?=
 =?us-ascii?Q?7gno//Q0DA5Lt4bOs3DHvS9eIPS1Q8G1rbg46OQvLC8LPgg2HKm4YTd6sjGB?=
 =?us-ascii?Q?BWXzWLnDKEIAxG2x3j8dpCW6czidPC1chC/tRvlUvrdpFAP7c8GBT4o/Oafq?=
 =?us-ascii?Q?DW7qsRS3EmlkXpkT/4LyeYFZpuAMKBruyXHplAn+9GsCC613slSS3nQjjabz?=
 =?us-ascii?Q?CYiTuzn5mpK7+1fKbWlSEBUCjvTIJN9keb6CBxbeuP2nGuq36Qjtm1v+EQ0T?=
 =?us-ascii?Q?R9J5VyTiVVhP8yw7T7R7xLIh6DBnYXK1y1BquIFmrKPU6yIpGA1xwkbb7LAm?=
 =?us-ascii?Q?WvyiXtmli2j+SMVRg4xPvnZC7yATLAdLecnjwVhryBvrg2Yge1Us2R8K2CSD?=
 =?us-ascii?Q?k+AX9xw4YL8ZUlXoR+BvvbrpCM0NFQ4uRVscs8+900bvXgfK7VfCVlXIfnho?=
 =?us-ascii?Q?nteAF69GBiBTEUtK49Cn3TohQf44cw2m+37Xe1BbyovRMJQZXHbqJn6jsNCg?=
 =?us-ascii?Q?aQ88PWl7eZC0Zc450IwpYrrFX93j6I+PR1A9m+kW7mpVfOgnnnrnPZRoLi92?=
 =?us-ascii?Q?GVu5hS+k+dLo+YGIsy7lYu/4ze4ZV6eyRHmoon+kYiR0siZUWmyOHa4uS6uf?=
 =?us-ascii?Q?67SEvQVskzJ3+umATox1q860ipitlLyVAMgegPn5iws+4vNWBNb6afb2anPm?=
 =?us-ascii?Q?gc5Zp4NHrd02IOBxlGh6cNHdP1bz3UpD2JKf1Z+ksPMco5bFPaVFtwTjALmG?=
 =?us-ascii?Q?Mb6+gV7d+p2vGYXpgK2rgDo4KLwNszo26fWZvkno9V2XtuED+KoXapGZ4Qt3?=
 =?us-ascii?Q?tdOs9MJFgJWtq6gjnFy0e4OiH4BGogUlDimnpnZpGV3GgMd/do7IgN0kRhd/?=
 =?us-ascii?Q?hzYNAoyTH0bXl7d9t3GIGWfyNqZ1oiHrtMfMKNYh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb295b8f-8313-44bd-d119-08dd98486d0c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 09:18:19.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bg+kfnOKxunD7SzRxjv0eYWtkV3Zzt37yDoQzdYEf41GAa+/nixhLShoJiam7GNlayldCS4blfwwuASgO0JeRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com

On Fri, May 16, 2025 at 02:35:38PM -0700, Sean Christopherson wrote:
> @@ -108,15 +105,24 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  			 int *nr_entries_reset)
>  {
> +	/*
> +	 * To minimize mmu_lock contention, batch resets for harvested entries
> +	 * whose gfns are in the same slot, and are within N frame numbers of
> +	 * each other, where N is the number of bits in an unsigned long.  For
Suppose N is 64,

> +	 * simplicity, process the current set of entries when the next entry
> +	 * can't be included in the batch.
> +	 *
> +	 * Track the current batch slot, the gfn offset into the slot for the
> +	 * batch, and the bitmask of gfns that need to be reset (relative to
> +	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
> +	 * a sequence of gfns X, X-1, ... X-N can be batched.
X-N can't be batched, right?

> +	 */
>  	u32 cur_slot, next_slot;
>  	u64 cur_offset, next_offset;
> -	unsigned long mask;
> +	unsigned long mask = 0;
>  	struct kvm_dirty_gfn *entry;
>  	bool first_round = true;
>  
> -	/* This is only needed to make compilers happy */
> -	cur_slot = cur_offset = mask = 0;
> -
>  	while (likely((*nr_entries_reset) < INT_MAX)) {
>  		if (signal_pending(current))
>  			return -EINTR;
> @@ -164,14 +170,34 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  				continue;
>  			}
>  		}
> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * Reset the slot for all the harvested entries that have been
> +		 * gathered, but not yet fully processed.
> +		 */
> +		if (mask)
> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * The current slot was reset or this is the first harvested
> +		 * entry, (re)initialize the metadata.
> +		 */
>  		cur_slot = next_slot;
>  		cur_offset = next_offset;
>  		mask = 1;
>  		first_round = false;
>  	}
>  
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	/*
> +	 * Perform a final reset if there are harvested entries that haven't
> +	 * been processed, which is guaranteed if at least one harvested was
> +	 * found.  The loop only performs a reset when the "next" entry can't
> +	 * be batched with the "current" entry(s), and that reset processes the
> +	 * _current_ entry(s); i.e. the last harvested entry, a.k.a. next, will
> +	 * always be left pending.
> +	 */
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
>  	/*
>  	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
> -- 
> 2.49.0.1112.g889b7c5bd8-goog
> 

