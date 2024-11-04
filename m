Return-Path: <kvm+bounces-30468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ED129BAF4F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 425BE1C2463B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88381AF0A6;
	Mon,  4 Nov 2024 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRR57R1M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F6185B4D;
	Mon,  4 Nov 2024 09:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730711536; cv=fail; b=Pvv+oXg+T9bGeJS67WMiZy+NC1EMl5y+/aRX7MdZl5U7Gl+n/WD4CZJZhAvReaeqnaA506tNjHvMwDST7FWIb0+QfZhGW2jLj5q/ef2oYq3bVGL7qPC/0q4aiLkjVVBw5qUi6gOiYwMkmwM4d5x1je/uC50y7c421Mo+ZLU0tew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730711536; c=relaxed/simple;
	bh=gpaE0hlXYOVOEV5q6Az1O7TFSWNnooxHYy35jZUDEp4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=twBUYcFf30o8xA2M1T4GMB2FBW4lr6pNY52l9g4u2pO3YFRCKwLB4rf1vbsyh2IYSdWlm4tTG67kRDAigiz8LjTEjyhRbVL8WPysFJRtf+531JpHElUbEo7JjryYRtaaedogD0P96wKneookk0d7YoljBbzUA4YTYzsXZuejKgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRR57R1M; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730711535; x=1762247535;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=gpaE0hlXYOVOEV5q6Az1O7TFSWNnooxHYy35jZUDEp4=;
  b=DRR57R1MDXsHbfLwaK/MskZr6q0102zYC7XTe5Dw2+tmYjy3PgQeuGoL
   ivIM3DIBChVMyutkHqK5yeh62APRAwG4LQsTy7VpVFijpZUesIRI3t8RS
   gQ7aVI4uL7qdUSsz2dpQEN2R9SlAYoDr93ZTH7QbxTsJOk9+RNgeEnE+/
   m/Qp7w7TrlMTKpH0AYO5FtTAQsjTnTQCarvaIOmbXtDiuzhkDXehIrdjk
   tDjgRAQR4bLtRUVeomy/h4guuZWt3n10zz+8OwTCNwWm8J3UkozwEYQA5
   plsz3t7RXePrhU3gJpI7MwEDKQuLldm+OFQsKQ2W2VnMxbQyW3l1Oxfsq
   A==;
X-CSE-ConnectionGUID: ggDnbJIHSCW1gaS9/dPC0Q==
X-CSE-MsgGUID: gL+Z8+d1SRKVEuWQNUobgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30173724"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30173724"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 01:12:12 -0800
X-CSE-ConnectionGUID: o/ucJSB9QNuE1+L7l7HGkw==
X-CSE-MsgGUID: AgxSo3m8Tv22gr+eXhp7VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83705991"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 01:12:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 01:12:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 01:12:09 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 01:12:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SG2QumoxcPYeypVgqC8AXIq5gDvtQ1QJteB9grGZKXtT5o6oj2NusPeLy9rpbpcrRWACL6/oUo5CUwPSj6lRXulAWzz0SifqqE+MqoeWOXzG4qlUmmFE0Sr+tk3pAIB16o6RoZkemf1yMc0LmGy6dIVkHZEfOrjfR8GcsOJ4MGfuEVGhVV9xmRQRCFWYPiOVG/CSIGgR+JO2uVB3e+Os/DHBVnUZWVMhebKtplUUn3ZKibZharO3HnKdAnNpDauSL1U8/29Oy1YD4zvkxufJAp2651eXv74sYln6/58nT3RgIYocykUKZ4q7g3aUs4n7ySqZB2hXkcV2OlhZ4w3Juw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGrrhkxPmQ1WouaWguC3N/usjb0LCys+M144hbiDQpw=;
 b=FkhK7EZYhQ6TatrVvunabexHorpUYEggZgQE0BQSEUOMAnhMkSb2J3BlJ/QR2t1/Z0tQCU99NetcXmxhfUF4fWxO3Byy0Ppgl155/Q9d47Nt9jMnPZJJ8md0Yyo/NkRdaB8tSUVYbyHH131cSoFYLqxry+YiAhEw26LpPWFiEMMal8lf9OSDqQPH3bXLmNZo+Hq0Zbqri3Qh+LtUJTSvUYMnWbC+wCCWdDwlmvRtO3alB/FtAdSyx7WKo90Xx7xMKHtG/gi4t1inrc8+pNGx3Q+O8fDorMuI4s3CGB7uVQbXzYBOnhWGTICeWXBOFhwwHg8kTU645V7Z/AnHTMsHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8373.namprd11.prod.outlook.com (2603:10b6:806:38d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 09:12:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 09:12:07 +0000
Date: Mon, 4 Nov 2024 17:09:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Message-ID: <ZyiPUdNVOUvasvn2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
 <35dc9358-0b1a-4325-818e-27ccdab7669b@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35dc9358-0b1a-4325-818e-27ccdab7669b@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8373:EE_
X-MS-Office365-Filtering-Correlation-Id: 0745e136-f934-49a1-204c-08dcfcb0c163
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?ypqaBf4Dpp4HsuKNT8QrPpKcy1X1DcoCDhWhGkvwNTTYCe53W2DZwKvDKL?=
 =?iso-8859-1?Q?XTzqDaTVFxWZkpuXAIlhcT62JTtX1tvM4AQarLpMiNFYgkntePjJy6uznp?=
 =?iso-8859-1?Q?S8sKFwWYJSSxDbtSMMnB/KpzVtfxXhVqEQwViUaXtddsAS/rVnqth/xBaY?=
 =?iso-8859-1?Q?qwug9KL0SPiOVSqUaljoh9f9Pu1/qL7/7WItQfBiGhKNQbdOp5cb/Q34l+?=
 =?iso-8859-1?Q?CRZhvgoAsWcSJxhltXH5AF7jlFtvhZD7Vei4FKRgcf5sRNbJq7tjSQ+VYa?=
 =?iso-8859-1?Q?0UX+kqooZf4VQAxFfb08LGrY0zFymmndbYeLLoUxknGw5VjP2BAFajiUWp?=
 =?iso-8859-1?Q?JN63oWsV1obw7MehJ6j2JL+vcH9PoU+YvA41OPnH5ewNZgZ/wxRUmsgu/X?=
 =?iso-8859-1?Q?eo4RTJp+KClRVdvc4GpZVpSMSNxpR2Kd6Ds9FxzYqMqbZanc+M47q5wTJx?=
 =?iso-8859-1?Q?J/njEYco5WqKRAjdWJI3m+ZN0jZ8etjxhb2dN8XcfZXBsZVNZB41dESXkB?=
 =?iso-8859-1?Q?J8STew6u++mHNDysIKPx5ReSJvHq+lDCTOJSD1IqkpL9GbVLWlUwmcrOK0?=
 =?iso-8859-1?Q?6GW53Fv4nKncXakCN/r7g/OE4ja9X8lYAI74U8+ltnP1Iy8Dut65pDhlDZ?=
 =?iso-8859-1?Q?mYJb05Co9uGHo9yBdcyLMljvuT5l8Y+NDyMc/39LQLKXEp0lDXhHVtbte8?=
 =?iso-8859-1?Q?ynij2xta4YmxeXpSpWttmrPiuZsbmLNn9ua6AR/OmC2NtCGTDiHiRSLNZi?=
 =?iso-8859-1?Q?nW0A2B46Uvtsj1K+0fnxa5nuFzVGKQiwj5RBXfWk9QS9KOd5sdvXP5XvQc?=
 =?iso-8859-1?Q?keYjRV+r0wAahxRdcX4W9rAut56863nvTTq4C0D3ACXyM6xW7ebgQ2dPr9?=
 =?iso-8859-1?Q?BtnSNWeqYCbiLAnI1p+ybzBKVIlEbLi6mHKlI20UIhgvRG5TxHSCImBR+2?=
 =?iso-8859-1?Q?PH2hAQqKA4NV/0kdjLy+m/ugRschhoKP7BAXOh93y1PLfu5JsBI2mnCuVU?=
 =?iso-8859-1?Q?pjUele6cqgX38xCgMYKBklHu7vi6YH8GkRJtT5l1PkO6tac64eMtMWuJef?=
 =?iso-8859-1?Q?G8P1NxKw9hVDlmUjRX0VoY0pult2Yq3BpgAYH6NxFjykMApEA8qv9BImnl?=
 =?iso-8859-1?Q?dNOjW8sz+3H965EZSIYp+0XII8aE2oyiLGP+xXvUX56nOBaWjAC9CmfNra?=
 =?iso-8859-1?Q?E1UY/sWQBfOd4/Sm5wwdS1oZMHZzneJJypCprydDeeu5BLkzMtdbl9icXS?=
 =?iso-8859-1?Q?Mag3yecZm/7VLCiXKOkIUexWYRTrgOfdgvDUAMy9EPf5kD8wzCMPUH+xsL?=
 =?iso-8859-1?Q?NYgGAcht+lcJxjeF9mlmqdZY8/pioGhxSQlB7cNdlpCSONlCix/mQxypkG?=
 =?iso-8859-1?Q?7dRHz0Chuu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?aLEbK3l5LjmiBP9zLlj9Daanxc5Bqs+uD+fF+ryAIqeRf9fUrnbTn0Ks+x?=
 =?iso-8859-1?Q?gJbkrVAaPLfdodlAjtb43uXNyKayNl/9AqEho+jNXyrcMPgHDmZpANWdg6?=
 =?iso-8859-1?Q?6rb90+gi671HznAfpUYKlq4V2YgBCOY8Pe0z7Wg8tJ4rXBZK+lF9CLczAZ?=
 =?iso-8859-1?Q?AviGmrTD5YT1IaM7OLo2Ne3LJTWccVVHXSCdqrbr77s1YKBALgIwSMt/JV?=
 =?iso-8859-1?Q?UrjFw/Ii87cKktBnrh5Su8abpdTTG21NBctkviCuP1UI51vXBKke3E3+L/?=
 =?iso-8859-1?Q?M8gCsD2MR+Hv0LrQazVKr2DeVksNhDfBYq/Ft5yJHjpSbn49Rs8C6ukz0A?=
 =?iso-8859-1?Q?OVDA2tty49aSpivwwY4RprVTSb0s6Y92rHbIeoyuQezaFFqRsRM1efE50t?=
 =?iso-8859-1?Q?gF2mbcPrpULlM4FUPHzxPYk0Nc54NB5m3X0mcN5vIu1E5aZ/drGAw0jgnf?=
 =?iso-8859-1?Q?DlkF7IsmdI2ez4SnzgRYCGpkQY2DbQjSaKKpt3MCT09f13sQef6iL84oSP?=
 =?iso-8859-1?Q?mDYUtBAKv4FII8bO8HfSD1wjIGUAKjSU6Fzymnp2+hF34nOKQcpjiERGd/?=
 =?iso-8859-1?Q?2QwhH50vzT1+OU4eYJfrN74V7Q/vhCKqyrw0oidBEU2KfmaLuvQeHtybi1?=
 =?iso-8859-1?Q?UJqzIMhQvg0USaxvonHkvxnsvl97NAtz6YF3VwCQQBY8f9gOg+h/WK81Yq?=
 =?iso-8859-1?Q?vc/dFqM62OrVEi98S3rMiqsVN6bNaAfQyp+klRbi2SfjlSGNufJDOEvSHs?=
 =?iso-8859-1?Q?VSEuBRBfKcxj3Q6BpFR2Fo8TSHZbDfoDVaDXl3aI6shjNAnHu3agOiNd+s?=
 =?iso-8859-1?Q?780j1q50jhJTL+qnXnF1NaJxnMloFAXAYIoG+SYya8ra5StswRsX5Azj7j?=
 =?iso-8859-1?Q?3g6BXGt3LasxqMaUG1IyBrQmL2/puBqB4SXiSTAylLdMzUwRwa/xZB91uC?=
 =?iso-8859-1?Q?TvkFZCqSrzOj9neP72YYYxfwkMKGCf9FA4SDMlOAnxUchOBVGc0Wv1wttH?=
 =?iso-8859-1?Q?OP4QrdcI7TwTXpNcLlwGZwlQNBiSgYagbS9cLi98RuTYunZUjTk7hRjpR3?=
 =?iso-8859-1?Q?SJsG4fvySi/DVwJDxaeHxPjmhngIfOAtX9QeImibJwjZfmvaIsh2lT9GE5?=
 =?iso-8859-1?Q?v4ElILiLLtxq+iZiBBD1cDN7ZeAn2Bqd1gqBfOla34qqEdXNE/V+98jOT1?=
 =?iso-8859-1?Q?2gK2fIwnP9CrdaFzlhz5hknO0lZX0cdnMqpL+fx9n6GxGYptJhtma65ifU?=
 =?iso-8859-1?Q?ARtieo+rSfnkHePwN20TeVQU30Ehz1f4fzl/acbjWKqjG5oHZZKJWZ0oQ9?=
 =?iso-8859-1?Q?y9LN86xme2FAYGstAiOCBzf4lL9AfF99QntwU6dk/sCxO9Y8LqeonPb8vz?=
 =?iso-8859-1?Q?3UVLDyc1833W9B4VP9Bb+N9midOkfQ2lO78Ahf1GCIAS/Qch/syo2X4t5z?=
 =?iso-8859-1?Q?z9NiHSgDL5yAOtEwnjEqCMcxf/iAJlgRUk4DsLHEzHkcRZTO9Jv7eTKp9r?=
 =?iso-8859-1?Q?pSz7pwEftWKsnlQ0lztdPUVZme5WjBEFxIr3rF/RIRRMArDwgejSv/gL+R?=
 =?iso-8859-1?Q?FnabkXhpvkiEcG2ywQ/duHrWW/iue0rC6EG5NpbQETq7kIzLkguEmcDKos?=
 =?iso-8859-1?Q?bihncegkzdxcIwYm0cqPwTxldfRCUAXj4V?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0745e136-f934-49a1-204c-08dcfcb0c163
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 09:12:07.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHAABMpG6qH0W2D5fcJcKIEvUG1j6sKD+EqKeyp841MUu73efd2Xfcq+HiKQmhwmdv5joxGqaY+KOPddXgJjHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8373
X-OriginatorOrg: intel.com

On Wed, Oct 30, 2024 at 11:03:39AM +0800, Binbin Wu wrote:
> On 9/4/2024 11:07 AM, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> [...]
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 6feb3ab96926..b8cd5a629a80 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -447,6 +447,177 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> >   	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
> >   }
> > +static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
> > +{
> > +	struct page *page = pfn_to_page(pfn);
> > +
> > +	put_page(page);
> Nit: It can be
> put_page(pfn_to_page(pfn));
> 
Yes, thanks.

> 
> > +}
> > +
> > +static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > +			    enum pg_level level, kvm_pfn_t pfn)
> > +{
> > +	int tdx_level = pg_level_to_tdx_sept_level(level);
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	hpa_t hpa = pfn_to_hpa(pfn);
> > +	gpa_t gpa = gfn_to_gpa(gfn);
> > +	u64 entry, level_state;
> > +	u64 err;
> > +
> > +	err = tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
> Nit:
> Usually, kernel prefers to handle and return for error conditions first.
> 
> But for this case, for all error conditions, it needs to unpin the page.
> Is it better to return the successful case first, so that it only needs
> to call tdx_unpin() once?
> 
> > +	if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
> > +		tdx_unpin(kvm, pfn);
> > +		return -EAGAIN;
> > +	}
As how to handle the busy is not decided up to now, I prefer to leave this hunk
as is.

> > +	if (unlikely(err == (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))) {
> > +		if (tdx_get_sept_level(level_state) == tdx_level &&
> > +		    tdx_get_sept_state(level_state) == TDX_SEPT_PENDING &&
> > +		    is_last_spte(entry, level) &&
> > +		    spte_to_pfn(entry) == pfn &&
> > +		    entry & VMX_EPT_SUPPRESS_VE_BIT) {
> Can this condition be triggered?
> For contention from multiple vCPUs, the winner has frozen the SPTE,
> it shouldn't trigger this.
> Could KVM  do page aug for a same page multiple times somehow?
This condition should not be triggered due to the BUG_ON in
set_external_spte_present().

With Isaku's series [1], this condition will not happen either.

Will remove it. Thanks!


[1] https://lore.kernel.org/all/cover.1728718232.git.isaku.yamahata@intel.com/

> 
> > +			tdx_unpin(kvm, pfn);
> > +			return -EAGAIN;
> > +		}
> > +	}
> > +	if (KVM_BUG_ON(err, kvm)) {
> > +		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> > +		tdx_unpin(kvm, pfn);
> > +		return -EIO;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > +			      enum pg_level level, kvm_pfn_t pfn)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +
> > +	/* TODO: handle large pages. */
> > +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Because guest_memfd doesn't support page migration with
> > +	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> > +	 * migration.  Until guest_memfd supports page migration, prevent page
> > +	 * migration.
> > +	 * TODO: Once guest_memfd introduces callback on page migration,
> > +	 * implement it and remove get_page/put_page().
> > +	 */
> > +	get_page(pfn_to_page(pfn));
> > +
> > +	if (likely(is_td_finalized(kvm_tdx)))
> > +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> > +
> > +	/*
> > +	 * TODO: KVM_MAP_MEMORY support to populate before finalize comes
> > +	 * here for the initial memory.
> > +	 */
> > +	return 0;
> Is it better to return error before adding the support?
Hmm, returning error is better, though returning 0 is not wrong.
The future tdx_mem_page_record_premap_cnt() just increases
kvm_tdx->nr_premapped, while tdx_vcpu_init_mem_region() can be implemented
without checking kvm_tdx->nr_premapped.


> > +}
> > +
> [...]
> 
> 

