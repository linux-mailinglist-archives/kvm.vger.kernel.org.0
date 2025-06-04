Return-Path: <kvm+bounces-48399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 79072ACDEC1
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CA551898B4C
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2DE28F935;
	Wed,  4 Jun 2025 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUWb12PZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A502226AC3;
	Wed,  4 Jun 2025 13:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749042864; cv=fail; b=qqgEf5pw+fE2A+MySoipRbiThvm+hxI6Bnj8j8wN+DTy83Hvw3nag7KcEI49OFzmIxJG7VluRq+wOZPUEYgSl1vTnuAXy16iSdE5xWin9Le2ZVYEnQCxAi8b935t8d1L4uI5XQ4iPbB6F0PUQUVDU47Kn9rVqbY3viCgO9o3a0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749042864; c=relaxed/simple;
	bh=U8IDfkvAsfYOkp92ekX/WDq4R/gPDldBVeH9Pkw/63Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R/IGuLwkRAwlmX6ZsHZeMeIqqgazDXXZACSxC090tc2XOznP8ia9bPs/F1oHXlCEmaKnMwe9oe9Es40peKgV8A0LUvDwL8l8CzJXedVNvtd1zaGdOQR1/sYZzNBrZ2OlhEIFqulqq9YVndgkD+FAfIXrnrZ6YI1AR3N54hE/iLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUWb12PZ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749042863; x=1780578863;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U8IDfkvAsfYOkp92ekX/WDq4R/gPDldBVeH9Pkw/63Q=;
  b=eUWb12PZDOb/cJFBmfrYUnzcu2qZxvZcE74ASrqKevzFmNEEeXLAUuSW
   WFkVmy1iAp7xlG77155KkHqvypqhBVsgJYcuEQpLck7apMHoAlxDgLqlZ
   kfd98ZokanMupfRaMPIk/iTU1rmK7zwLQLav4rZUMW61OUUDqDC0FC+z6
   V/Fpc4L2Yiq3zXWwA2N+tSBtssddIcA3DCUZGMAiludArmfqPBnfZ7eoU
   8YrZW+GTyZ/jfx0yFcfw2ZB/dY1izrqBeIq1+OfctPI5HIVeGx5CzDeog
   6SOFIdhFZ0XPsG69/yBr5CD6OeReri7ysOgcTAl1WY/vUm3vygEz9kIIS
   A==;
X-CSE-ConnectionGUID: fFU10l4jQtSHHXNUHE/4pQ==
X-CSE-MsgGUID: 0EvYttZkRjeg0jCRTPpYYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51270609"
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="51270609"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 06:14:21 -0700
X-CSE-ConnectionGUID: 7gyd0YZVSxeExWYQS7q9OQ==
X-CSE-MsgGUID: k8gUR2phQ7qRmBL53Qzprg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="145150195"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 06:14:21 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 06:14:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 06:14:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.75) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 06:14:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXVn7QKRQ9aZHgXMqAnXhBm0dCq0f90tBNKum6/old+bV7QYaV2d9RjMtBUopug4az5L/j/riQsYO+r1TX3C22VQ25590xZX0TvbREyfT459r6sRAEPM+PDQYVeAQr60SrxmMXouz5pKzJCgjCQpopMDNL20Y96/7mLxFkSWFF2c028QIK6h7hWspLu+fL90lXbl6qDS8KlVGLxAbMQdcqYlfyavJHGWbYMVjwilFxHc7LVh08jaVwvvn4XtzG8+pqnuPDEY2oCFTtkqPF1Z2C3TC8+3EZgO/LL8jg55KHpB1n6xgLaRZtbmRF/juccegV7AEmJ/Z63SKrUdAvO+zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3m8xOcDbAVfUw4Loz8D7XkJvp4IyZCvwNQQNBBAHPhs=;
 b=GcqARzoabm3/5oXlI1J0sHCsSxkR6sMlEVKIXQxwFR+V3prqBe833MUWaLWNcYzss/maDThyEIlt63phkm1oeRJdLleHNCl8mE2UDjYLi4h37EN4RKnAo5FTTMO28DpFiB1F9b9J4MsgxBTHktFE0gkjr/udw3jIK9S/5H8XiRKk9kKVv918mXLN7ZtJE/ksEUgiCuqnsuzFyor1G43GHO9MtQIcyHHaBiod9E4rjQ4H7k+wp79DoWPtq0GGM/IFKK4nyqiOncuA2190amvHx7P4y3l49mWcfGq3LpH7LTv+c/1zpv/Os52GBQigHHoJceB4jFgeh/IW784Oi5k9Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6456.namprd11.prod.outlook.com (2603:10b6:8:bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Wed, 4 Jun
 2025 13:14:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Wed, 4 Jun 2025
 13:14:17 +0000
Date: Wed, 4 Jun 2025 21:14:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Shutemov,
 Kirill" <kirill.shutemov@intel.com>, "Dong, Eddie" <eddie.dong@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Reshetova, Elena"
	<elena.reshetova@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 02/20] x86/virt/tdx: Prepare to support P-SEAMLDR
 SEAMCALLs
Message-ID: <aEBGnC6g6D2tmBR5@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-3-chao.gao@intel.com>
 <95c57c6d14b495f92af6bd12651b8b5ae03be80a.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <95c57c6d14b495f92af6bd12651b8b5ae03be80a.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6456:EE_
X-MS-Office365-Filtering-Correlation-Id: 9283692b-c185-445f-6403-08dda369b5ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6gU+pBCknBwMkkKV34ZfFQ1gGtRrpzC06lW8+o2NuRGS32cy+aPeEtwjI8x3?=
 =?us-ascii?Q?FU/aaTT4n75rj21zdj2zcpZLLqQHBs+VCMFzI6E/A8BQC+iuHoWyXQZu3tJE?=
 =?us-ascii?Q?3uDKcmWaHPaEXyqc0YqBzjZOfj8/HeeFFT1dL3Sd/cpFe8VrIGC+Sq83bpHO?=
 =?us-ascii?Q?dI0TPStnscTOh8an/Ms98OuBKVPYravYHVUQy1DnTG1DMYCjP63SNzTpYucn?=
 =?us-ascii?Q?1UMABeKGfWPUg6hoDT2ZwKelyxdEmVhUYWqbsd9DyjD50ip4MtV+mn2SFXuw?=
 =?us-ascii?Q?/J51VE9nzTJ7sGV6TxMuhJW37wYwRM33lFx0HfomTV2v+JpsevzfmGbffqi1?=
 =?us-ascii?Q?1296bHAQrdzfI4H+FgvfWkhQgY3qo/0in6DRiIUvqSTTN5RzTC3dNQ18ZND1?=
 =?us-ascii?Q?AXWOhYPsPN3I38LAwEOXNeyoY2JAs+ETY/VBwiuu6xalMQyDHoqFVEFYG301?=
 =?us-ascii?Q?DVvnkIWhCUbKzA1eve3fF8gip783JuBuydE9IfEEmhyq2dzzSp/Lec2qqD9u?=
 =?us-ascii?Q?HzQwAZiRDHVuvmgo7FMMa8j8nd0zTExWNnUd3FwfdNpte+hwWmcItMNBXZbY?=
 =?us-ascii?Q?/BfMJgjX+WUQXcgPw1wiD213hdO+lS8jECW/R1fLA3mFQZNbY9DGSCQggryD?=
 =?us-ascii?Q?1V4myCpsKK/lJPb9sdTVXhWglqDRSbHoJV6ALNRFACkYcDTFkaEHynsce/A4?=
 =?us-ascii?Q?VQoxn+y22MUcORH5YW4wrNWoaYW/CP97autx1LwWAxfJOux6KkmJ8wCxJ3eZ?=
 =?us-ascii?Q?m0Oh+ZZwOjyplOxHlHRNrLmUETdeS+yq1hUFk/9Yb71gfbqb58hHi+EoEV2s?=
 =?us-ascii?Q?ERMXmlFlZZN68r/7EkJmk8/+zvyLoe7WM6SkxTUes9CTgBpEqd8BvQGK3GC6?=
 =?us-ascii?Q?eDaE3UMhd8kQnihAU4yUYRB0KJJdOZsI5c4O0/hGMW0IpJbT0mVZEn6eout5?=
 =?us-ascii?Q?sX/YoXBShQ6+6ls1y8l4uXn9Ml2KCaiJV95kLUdzFHNOc2T4oCOzejFmuqKP?=
 =?us-ascii?Q?wqM6ye5kQ1YcUd5JskQdKQgnxpFL2qtpLsQo3AqbC9sTRTydc1XQoxGKtlxb?=
 =?us-ascii?Q?RQLrPVBh8DVSAsIj+LZagjq6kl07XAqEleyxK5Ey8gpV94l9MiHJtZ3r14AP?=
 =?us-ascii?Q?YW08r8p4lR+1IQPYGBEJS3G9eI32CEipDjaMnkA3m62HwaqGllJUNJ2ia2fs?=
 =?us-ascii?Q?cUI8wBSwXTJIYg2T9GGDvjL4Yy2cVAb/aYSVSbTZhpRFoRuIrgBhIIrG1CeX?=
 =?us-ascii?Q?L3yLBNwpUAYKrinbz0THWGgwGgdFZMMmzCxnv08oZvLBKjjcp7E2HnOtRiDp?=
 =?us-ascii?Q?nKn3HnPkGU+co0uBEO0zjYFwAAWr9fDo1x1bZIF6lJZknyQJmk/A9NczOEMN?=
 =?us-ascii?Q?W2CamAgPajvNzJZ2c2yZctYp9TNWsbbEj4INA8N8WhAEJABqGQNOKBGwdi3M?=
 =?us-ascii?Q?/EwK8b+UARE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ethzhZcPS0EnO1RNE8QMledyRaocXHL23pQsJ0cEL0gvPAE1T0BnSlCsfI7F?=
 =?us-ascii?Q?hf3c2S/08ryK/+h9i2sERkLcF3IVopPEtCc8za/egOcxNecJC8OZIpC+t9Y6?=
 =?us-ascii?Q?iW2+ru7cK/rze1GyB3ig2anRxYwVbT/jv582Mm6jx/n2b6wfqAK6ls0dDzQp?=
 =?us-ascii?Q?KYwRMI+pet7RoYDfHETVVojaBujLLsXBOoE30cTFnY5CUgQgK9Rqp5MD7a+A?=
 =?us-ascii?Q?tfAYTlMbeN4lHJ5nuTqV1SWeJbJM16SSvVHfq+52Og7/eJPTS9S6Of/Q690y?=
 =?us-ascii?Q?F5B2kdy3W3Hg+vrdXSPtTmscN1+HhYEaI5h5Q66DtUbjPwWY5XnAeEX73w5C?=
 =?us-ascii?Q?EMmxu0f3SR1TyNIF0rUFg/vwoaHneBLZtUhI9g95/XiLy4nkkQ/xwNHHotun?=
 =?us-ascii?Q?+W6SMnanFjVgt+8n0yO/f2PtLr3DK5QzWCU3JoBbqqDY8sl9Of6+KmlWGY8Z?=
 =?us-ascii?Q?ycaFTvLMJnkDO7VFuYt+6wnqHB42+wDky5CkQ4Cw5N4ngQTnhcxuO53I+qP8?=
 =?us-ascii?Q?dXiiiZANBxEU6QwhzeXXIcBix/TmAALy0xuH1YTmx0YRX1lc1TgtUQM+QRzE?=
 =?us-ascii?Q?C21yQEdMcKHXboU7uAJGotzmOwoPZeGXadm+M+JtieYpMXC5oDJVj4VChRow?=
 =?us-ascii?Q?Lp67Na2APbp19FzVxACGz+lDFoarr/3iQoheUntndGvVnnct8/SycFpsWF3z?=
 =?us-ascii?Q?SxN7wjATAPLVXm67Cjj4fn71Sl2ifFfFyy3AP4bnFpmlj9jJFubeS4L3BwQC?=
 =?us-ascii?Q?zonlf8K1/YSJofq5lvsIq3sMhLZomjaA2vwz2E5FyP6Ex4PxRJI0FUXoQWxc?=
 =?us-ascii?Q?NEOzbOVg85Vnq+rDLXMyGntIo1J8yvJmakjOlOt/C2vZ4Ie9gde2x/OAzm9u?=
 =?us-ascii?Q?YYh921Vcq7iVjnyo0DjddIXMWyFvM6XRGRBOwXlStuXbyrO7cFx2uNQEuMbw?=
 =?us-ascii?Q?NWJSZpK6cwwgHKqI6E1SWOEc0cixJs9EqkD+HRpSonkoMjj9Saox6NYysq8e?=
 =?us-ascii?Q?BI9fwfAs+2s1tH5uXsnmkPsKZzWGja7Ss4E/Ccy7uljxUHhNOOl0B0uXBsS2?=
 =?us-ascii?Q?aBy7QmtYCHHkruKuWeeM+lkXCm93/ASm0g3OP+lz6dw9DfPZb2GaHrkNO+za?=
 =?us-ascii?Q?GMNJb/bu15PLkqcBQk9yh3gfp7APZOn/qZLWhlUmHDv/Lm7xNaq8vPQkw4jz?=
 =?us-ascii?Q?qPyMTkSfY4nMou+P+dQhApxWj0XeSC/nBf8g5ILecUNHVgASiWCnGHYj+9qZ?=
 =?us-ascii?Q?rCbmhY5IlM5D2cr0TSyQ+HFWkKP1omFg5N4Lyl5GP9tmxloav4Bu9pBs0W1r?=
 =?us-ascii?Q?ztJUqSLz8be8L51ZmG8KjJL+BweYNj+wX/WpT0y01wf0OjHFlFNoWIoFbzKg?=
 =?us-ascii?Q?RiqTHFPeOVGi8bl5HXh+JMmDCzzVRMCXIlVe/JMpnXHig8IoGaNYHbf/8pQW?=
 =?us-ascii?Q?4nuZ8w8ZdKIQ0Id47ABvjS+Ib0sLH9XT5JbNdvPsJzQ8/qAYUISHCljS+oBL?=
 =?us-ascii?Q?pEOi+iZpW6raheo34lQ3QjbtQnWJjAK8Jq0P1TKPc8PsrdoLW4Ehb8/qoS2L?=
 =?us-ascii?Q?vSxR9bxVsGwGSAfOhqVPlBTMlj/P6bDf2TP3vB6L?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9283692b-c185-445f-6403-08dda369b5ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 13:14:17.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnLzLehbVs13G+iDkjwSmRizUj4K4WjVg7SRKWU65ILM164uxrdO22KUhInWJtHlbx2tM0wqNBySLfqQXFYetA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6456
X-OriginatorOrg: intel.com

>Given there will be a dedicated seamldr.c, I don't quite like having
>seamldr_prerr() in "tdx.h" and tdx.c.
>
>Now for all SEAMCALLs used by KVM, we have a dedicated wrapper implemented
>in tdx.c and exported for KVM to use.  I think we can move seamcall*() out
>of <asm/tdx.h> to TDX host local since no other kernel code except the TDX
>host core is supposed to use seamcall*().
>
>This also cleans up <asm/tdx.h> a little bit, which in general makes code
>cleaner IMHO.
>
>E.g., how about we do below patch, and then you can do changes to support
>P-SEAMLDR on top of it?

looks good to me. I'd like to incorporate this patch into my series if
Kirill and Dave have no objections to this cleanup. I assume
seamldr_prerr() can be added to the new seamcall.h

Thanks for this suggestion.

>diff --git a/arch/x86/virt/vmx/tdx/seamcall.h b/arch/x86/virt/vmx/tdx/seamcall.h
>new file mode 100644
>index 000000000000..54922f7bda3a
>--- /dev/null
>+++ b/arch/x86/virt/vmx/tdx/seamcall.h
>@@ -0,0 +1,71 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+/* Copyright (C) 2025 Intel Corporation */
>+#include <asm/tdx.h>

If seamcall.h is intended to provide low-level helpers, including
<asm/tdx.h>, which is meant to offer high-level APIs for other components
such as KVM, seems a bit odd to me. But I suppose we can live with this.

