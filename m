Return-Path: <kvm+bounces-43747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AC2A95E1E
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2C43B0E34
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 06:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350C51F4CBB;
	Tue, 22 Apr 2025 06:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JezSYSEj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441622F872;
	Tue, 22 Apr 2025 06:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303255; cv=fail; b=F8rc35uHOguraN760isdAlvxvd2AAYL8nMFMsS6vEtBCzBglhOVLoC53ovvfO3J4edqmHdH6R3HJBiX51CYssjpd/hN5G8S8cCaUlAjzselgks0t69xtnzk00o2H/6XUU6UQHil9o6FebHEFuUC5ETdtJPjX6ZwQnol3jaokZ5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303255; c=relaxed/simple;
	bh=QzdcTD9PvZw5BwKFkRjCtOb8E2i4HhuzOmpGZU17D04=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dSejcYgW+02tp/Bkc9im2qYnXi9HbbPZG8oCzF4ajnBki8DE3vwOvyQ4EdaMV/uG+XpL0i/YoxF9PNtfKWOQvqvrdXEvYH74FQP39J5SFAHobwuucDK1VZLb8npljx6KwcdLiF8Mbl0IG2pfOPxFLGp3Ji/1Yw3ZNBUvbjjTXGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JezSYSEj; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745303253; x=1776839253;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QzdcTD9PvZw5BwKFkRjCtOb8E2i4HhuzOmpGZU17D04=;
  b=JezSYSEjKAkXPqu+b4fEvYMA/as9E/8qHqqa4UfCRELpcwK4xaNWKMyP
   XRnnCMFeEKzHHL8ytLh0BE+7xlmlPlEkAHZz72g5nM7UKYLznb+55KxKG
   EsNJwnkz7QCAh5oIkHGHiJxj67q004/XN/Lr8EfE6TEpWWvqPWM8oeM9i
   Wi5Ds3GfAZelOp8TqkN/Mcw9AEaODvHxOVr61EHT0E8F0TawOsi8fVtWL
   8ajTP0RO6rH4DutcCkwuBEJEzLhwd1+d/MXUpz0fA+k0Vw8qOPFNJtNcX
   IbMkrC0Cz0YkokDF9UUEdnGES1BoeT6qnY8IJovVi2rPuslWS/qc6NDoh
   A==;
X-CSE-ConnectionGUID: a0Vij/DZQrKDmYTZpCag5Q==
X-CSE-MsgGUID: vsvJZS4xSzqdZglqyDnICA==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="50648153"
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="50648153"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 23:27:32 -0700
X-CSE-ConnectionGUID: tOlmzBcfQomLhN/BEiARow==
X-CSE-MsgGUID: v3B0GJAvSx2sygrqrFDbvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,230,1739865600"; 
   d="scan'208";a="132458773"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 23:27:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 21 Apr 2025 23:27:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 21 Apr 2025 23:27:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 21 Apr 2025 23:27:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYDo9MUhwjuPfEYjgWz8iGHX+TzSvS/YrP1ZwnJKdB1OPKFvQg+HcijTssIyizYK1dsTmSZywvYFokcudRZRSBIxEk51BFT0wU78OVofoqB4sPrwBBntyrWrhL4Jw85E1Rnw8BmJ6hEnK1gNRy8x+a2xK1y3Llq5pgKRuV4mgVCWprKbH0dfgiAnhAyVIKREty/C8joXdX3taxHMblhakUjVJ6GWaqjC44Cu0DDhwZJ8cn3KGyv4rKtPD7Ov2Qe1tDIaWzX68PvyQUoS+8uSGTRkrcIAOtwi/lGRP5pjn3szVEYA57TYIJMRHZ2NDd66zEP8RoPrXzobN3dFb2F7KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uZEjK8Feu7zUlQK3AvnoSpMSeHYNv3O4Ekjvf3uWRg=;
 b=W4taO8XKVLNC/76+/TFSRDbREdO5bohoRB29ofgtMVGq/Ttz/O56oznGSGwVpdAyPEs11DHUYbcYM+A3YU8JEH9vKziiE8pq/YvmQEvE7N6kBHoHkl0VZh1/7HF1BYfgkGJt9Ms+87jFugfH41HQBuhAvIhwEphW0F9CndI/EC9CRUw5RSiqRNMLud+F/6+rCb9fqn+xRgR6XMBX7qZ4H4tVhHe8x3NyvuU4tMzrCBmX9LdrnPtUqCfWD7N5u2FDn4FJFp8sJghcVIvZbscMA2Ay4jOjXaK2keoHtz5RYyyB5odojHjG37/onymk2VBnXVqxQmP1io7Ep19SoQdCmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB8418.namprd11.prod.outlook.com (2603:10b6:208:487::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Tue, 22 Apr
 2025 06:27:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 06:27:24 +0000
Date: Tue, 22 Apr 2025 14:27:14 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 05/18] KVM: x86: Add pt_guest_exec_control to
 kvm_vcpu_arch
Message-ID: <aAc2wt3nM4iXLDIR@intel.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-6-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250313203702.575156-6-jon@nutanix.com>
X-ClientProxiedBy: SI2PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:196::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fe0c78f-1010-4dc0-ce9e-08dd8166beb8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9JKj+iAtdS5rdATYyQsUba2HgzsFS7jtQh7RQDQjGPW2I7o1rYcmPDCS/Lc8?=
 =?us-ascii?Q?f3ugHjwyLkid4ElsBL0heYlSSp1CPm1AQdiygkvj72wdV0ghcotpRCVADXP5?=
 =?us-ascii?Q?I8BYaMiXGcjvbOrTVuNGEPbcAZDrGXFJvR5fNOBDQYGN4dtvNwgWd8JMYkc8?=
 =?us-ascii?Q?RjCLJNZxR3L479zLXGqiopSAdSYEUUKNEV9CxkeYL7OI7HGIVK6Bghv7EYZg?=
 =?us-ascii?Q?GqHY/xaMtnj05d3L/YZWSGgilyfmxSsFp2czMEn3l70xgJK2N00oq02chr2j?=
 =?us-ascii?Q?x3A08YoCpn+P7Qq5HNqJYxMkoF6XDXxGL40mr1+elQi5awct7YWg5qk6Ko4v?=
 =?us-ascii?Q?niwXyHavnqCEm9V2TsShagKpoNmyjAnX/6tS5j5U+2JhEqSvJpDVuz9iJ73z?=
 =?us-ascii?Q?spKSnQL6v6uX5HxY3S6EiEe5eaoqZ+ejurc6STf1k/9EMlkcoXjMIFCnLco6?=
 =?us-ascii?Q?slN79hrwmm9hM4tXQHS44yq4WaQKs3R7phe7I/suSIhbmyG+1akQYofobqHp?=
 =?us-ascii?Q?4+M3zwyzUAz3mUSB5hj+TYwo0JNVSGnPMpDxfY+IkohXEYv9uUTN4kQEMqSQ?=
 =?us-ascii?Q?4iy2ubW5g+Nr4rxbmQy7H2JCV+G8TGzhNulT8xfz5Kp4fIkDlAJf8bXA0mmh?=
 =?us-ascii?Q?SCg9TgBhqoKiYa+1Jg4mdNTLYCD/C/H+Gw5605F3xVf7n4kH44YeEwGRIfva?=
 =?us-ascii?Q?vYieXGVU5KBztacluvevbVMU81Ia1CP5LPHsx2kjoBXsey6ENJsrVtH/VnGf?=
 =?us-ascii?Q?3hPc0oQCrGUT8A6R8rryzcNk9RgExBTcnRfHRGczqf9V5hcuw0smv2NilEFJ?=
 =?us-ascii?Q?o1tv0Fzl9LfvfB1mpeXjwEKst9DUXpq8NZkR/q7t7CZGz8rqGvl0drI2aqX7?=
 =?us-ascii?Q?s2T0N7SmQm7GFe/WlHzj91scwwc6+/UHIqiUA0yFp+jSLikewNSaVkH6roEE?=
 =?us-ascii?Q?e/UGw5bRRzAlq6Qf4LCx5mH8EN0ZCmvYDpcKl8GS6cLpGYBovDBlzZbS/DFJ?=
 =?us-ascii?Q?CU0Mb4EEgkc8T8jK/m6PrHvgapJtN01FBuxYYd+ndeymmeO0LA1CN9Tzvltf?=
 =?us-ascii?Q?ql+UZBMgNfkwPpMJLEr93BK1V7mBCQWb6p2zTvxBlt2KPFlfqgi+0cLEUd5w?=
 =?us-ascii?Q?zfaSBxhINvluDW8oPoX0b0t3bVww8Tg3jYlfj95Fqfimmnhxynmqg/obmAQ/?=
 =?us-ascii?Q?xF5IgXpu4mWdiKuHxY6zee8qN3algtrBenDC8ROsLnmCnod2jhb5gBAnwQac?=
 =?us-ascii?Q?z03LUpOJM2S78nggg3LGXYqRe+SRoXkT7uUJXB7Ji56dl36DqzVufSd8qAIa?=
 =?us-ascii?Q?kuSLXnjBTuOcq17k4pmdB0hzwtwLEpuIBTNuZdidB5ow4bawFpC7DHYAAAUS?=
 =?us-ascii?Q?UFDJbQDn1rrd5VSW6fjDzeTtUpypyLh9L3+2CN7FOg4iHGBSyAo6uBsi4tqT?=
 =?us-ascii?Q?oKx0aYVl5pA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X2RET/Ei4gzXqgq+Jx5UrqfU1No56DGDaXT4EUmELsKtZu3Kkf8Ia9O4/o7r?=
 =?us-ascii?Q?gScL2lDubFL+8vTsH/yIbuYfeRttpENV+WCma77Oy1d1X1Iha1vbaG3YIFpI?=
 =?us-ascii?Q?FIOJdjBxljv9oFrJ94vppEH8igRvDKHskPRk0FvYrUL2pVi8VRCVGDsVuOcB?=
 =?us-ascii?Q?8EJzFkLFkOONdZiqDlVONjbibdYHEur89O16BqdRViXDveuBx3Z78dklR3EM?=
 =?us-ascii?Q?BeSqBmjttmQg+nqcOEYt4X7OVj3QDQIr955B7iBHNn58RHE6SEoodbPYuNJz?=
 =?us-ascii?Q?i0xN0LbYqD8V1ViZ5gVdiISsbdNeUDMihNF3HZngIDOQ2AkepfAVOYjQ3/gs?=
 =?us-ascii?Q?K21oDCNin98bqN1FO3xkkNgyb4LRM1BRPGhBcCnMxzUqy2oAn2QZ53scm8bU?=
 =?us-ascii?Q?i193rGDrzltC60t8KQnNq859A7cL4ISy/czq2CHcAe2IZsEGKBR0HaMpRhyh?=
 =?us-ascii?Q?bDPPiG4t8X4m4ACnnjX8T7oScuROaZrU4qiZ865aIKOistTQPSfrL76jJdMk?=
 =?us-ascii?Q?vBcAgccOmSK1Sesody2Wi7vdJJ+U76tkYcg169J4/a4hJ2DfDdRU4QVuCNw7?=
 =?us-ascii?Q?7XpXRUZ9P8xi5m8g3ipQrTEoFL2n2dBqsZ5JhiLmOW7Cz7TS4Kah4zXmIipI?=
 =?us-ascii?Q?6fxJEMqWkQKESaiZl0nyWRfygGQ6BS0SHHuwRLUDjazVh+n2+F70HDdSmd7b?=
 =?us-ascii?Q?PNN/8tZvrns05wCTLMht4OxOXAfymC0GYZ6onXJYYQr/JmZMQbcWpiFIn2Rh?=
 =?us-ascii?Q?JSZu/WrzmCUo3ZJ9IDTDJwdho4RILDAozX839os0Xg4g06FTy4FQS1itv5mh?=
 =?us-ascii?Q?Z2fLJARumuuOJL8tdf6yXtIIGHaOzkkgaP7x7+JRlAT5Wi5Dki2unieCU14c?=
 =?us-ascii?Q?Ku/IpB53SW2fhB3nSNc+G64aSKKem9KfWIncXjVrkdV9FVBH8b/SZEfHuUSy?=
 =?us-ascii?Q?bLhiFQe8xixOyFR3RKEWTfTFKCagOdNpxTImyw+I/WiYpPJ3o8Hf5MS19f7G?=
 =?us-ascii?Q?J8FmuAno0ye0zub353QtojWg8IjqoEGqtFjwU6vf57j7+GQhkQOd7vE8TZrU?=
 =?us-ascii?Q?LixgxqkXh5jMC6i0Q7dcO6mCQ9u5urspoaMN/O29Q7Tz+Ox+4kI9FzGwem9C?=
 =?us-ascii?Q?QEAxMzgpAE/zJ/IeW2tp87LhbncrTdPFpvFvTN8f0xasF31y4XrK2B+xouze?=
 =?us-ascii?Q?LGm1a9LFnQUHw0eXKz4+EAM88JygRWxOXLMGm4vf4CtlSl6cKCNhTOIS+0jo?=
 =?us-ascii?Q?Ih6+zmzAJGKLQfSgmtceYvE+k9Tn2H5styq1pbC0TEf5RKMT3Yxzilyfdp1+?=
 =?us-ascii?Q?PWJTHcBWnMPtBsbRvxcZsqhF0IFd9cw6Ye+fr3vhLFKdE/b1fuw9ESHOUvpC?=
 =?us-ascii?Q?CNe1TK595AZMtxazxrYWdGnJ7qS6bG6BonWCKXpKdFRNh6ERyIgAB20bhT1t?=
 =?us-ascii?Q?paedaIOSZR9+Y1Xx1zqXlbaPLghr+s2UKw7jxqSwPdwDOCb2djiSvWTlP0L5?=
 =?us-ascii?Q?nhOh0idrJ0qs86F2WPIoSyFp5WS+5VZJZ26tTDaFnhZj0gZ1h4athREy6tzx?=
 =?us-ascii?Q?o1BmRKu7Ov/PSlUZ2OW6ItBabYoz1DX9NIrFIvjG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe0c78f-1010-4dc0-ce9e-08dd8166beb8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 06:27:24.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gt/WyWCcX1WOT+iSrv09uDARrWcknN/ZeZexWTH/NqgptTDoGs8HkLP9ZoWtIwvBx9IJwXaftmDaDpDTOA/Zkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8418
X-OriginatorOrg: intel.com

On Thu, Mar 13, 2025 at 01:36:44PM -0700, Jon Kohler wrote:
>Add bool for pt_guest_exec_control to kvm_vcpu_arch, to be used for
>runtime checks for Intel Mode Based Execution Control (MBEC) and
>AMD Guest Mode Execute Control (GMET).
>
>Signed-off-by: Jon Kohler <jon@nutanix.com>
>
>---
> arch/x86/include/asm/kvm_host.h | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index fd37dad38670..192233eb557a 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -856,6 +856,8 @@ struct kvm_vcpu_arch {
> 	struct kvm_hypervisor_cpuid kvm_cpuid;
> 	bool is_amd_compatible;
> 
>+	bool pt_guest_exec_control;

What is the purpose of this field? Does it indicate whether MBEC is enabled
for L1, L2, or VMCS12?

if it is intended to track whether MBEC is enabled in VMCS12, I think you
need to introduce a new bit in kvm_mmu_page_role rather than using a
per-vCPU variable. This way, the entire shadow EPT is reconstructed if the
L1 VMM toggles the MBEC control bit in VMCS12. Reconstruction is necessary
because toggling MBEC changes the meaning of bits 2 and 10 in EPT page
table, i.e., previous shadow MMU pages cannot be reused.

