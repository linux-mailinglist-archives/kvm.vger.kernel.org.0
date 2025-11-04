Return-Path: <kvm+bounces-61949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F943C2FAC1
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 08:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25546189BD5E
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 07:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D12930B50D;
	Tue,  4 Nov 2025 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bjsznuVq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB9430AAB8;
	Tue,  4 Nov 2025 07:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762241860; cv=fail; b=QBtzOD4h/KP4JbITXB5xMyZKOXYiR0/OwqadqBmDxjO4m7YeJxbtEg3BWtLZfddRQCxnQzgIxsvYML6b5oYvSg5rh0lVlgXS6h2+OQbk/us23Na71wFACH7EwA85kjCaSI9D+QApXvPwc0KnqqM6vul4q8GQRGVJ05pkTKZLi5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762241860; c=relaxed/simple;
	bh=xpgb2gmccHGDd3DGecodFhq+xGkRgsfBCrshHfnFpRg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=L61kCVxLLgiRDRSD7Tz7CFGwn3cgACD8Y0drRqEdCVg0UcMU1dBgneif6UV2VW3TOUhu+ZqxU9+IjZoZByhBplZO4Mz2hehhS5sBvLwZji8KoxAvvFmFN7NIcZjP/Dfu41scFtDjEEIO+0wYo9vjmn73PvkPgWsuoJ0a6ldGLFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bjsznuVq; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762241858; x=1793777858;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xpgb2gmccHGDd3DGecodFhq+xGkRgsfBCrshHfnFpRg=;
  b=bjsznuVqU03Az4OF2D/DOfQZ+8n6wzHpvpzbLVxaW/efT3LNyN8csIf7
   uwfx/FwOPhk4oV3ReMD8+WKJN7FKyUe/a2kNkIE+mbWqsdOsxEAA0ivPc
   BySDwOCuTfWj6Bfz+cIdb+hO4ENxgGaWIpuS2k49M+SqpyJaDvGvnOsEb
   iEAABe/Xkd0uCCN7gBWWd0PLEC1lpMZDoYrxfFQFNG/A1aETe9A3qjiRE
   sfbhjftpdTM+tccR2LySZx3AIKyAFvUDCvqtxEOU+YEAO8gDvOb5gX8/3
   i4ukaogxdE/OxT2SfpVdpEbkrvvKwunzFywzLpz8YEdz9wDPx0S3bnnhs
   Q==;
X-CSE-ConnectionGUID: s4a5hfR3RZSiPncWMpwX8A==
X-CSE-MsgGUID: 82NHZH4qRGmgPFQcvH211Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74621116"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="74621116"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 23:37:38 -0800
X-CSE-ConnectionGUID: 7hFK5suPS8SfkTu9mHgeDg==
X-CSE-MsgGUID: CgDJGfgASeGOUG8rGDuumg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="192253269"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 23:37:38 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 23:37:37 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 3 Nov 2025 23:37:37 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.70) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 3 Nov 2025 23:37:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=niCjZHoqoWQxrZkFJ04hNT/7Uq4cV7vx0V/Z9HlxiSBqh9iuREIZhwvv1XmIOwb0rRuIGILmqpIJnTEP2mFWiQTYdJrLvh0HXKVMp90AfF17TOy2WElHGvHdDEXl4WIVNYi2dmJoGrQ3iJOFczRhMxYpnCfpYNb6OVMkqjL/ibv5+/x4CK0ttxFv1+JUOTOoytfTXQQY0A1AMWAnsUdpxWTTxKPi5/ghnnUwv42elYJOENuJ25V/ok5uY8GiU+PQqDmJyMSvSzzsBZM2FbeAeH45PbAShq6j1aGWKO3FB4VQ/WNLt7M8MzVBGsOMv78JsYCaQpqXR9JK7p4HdrnMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbyyemdhIzQwp9lQusmfPcb/l9LPEUnvHzT8JMt41kA=;
 b=Gz+hrNGEhDLsVVL1X2vnr32Azj1N50Zi8QujZY4s5Qkk3GW/WGzGkc6ORTsksQhD66sypk2TlPnMpu0uVVWPT3ANRfPewtqXHU1VzhiHa6d5PRls6rg+1a7qcQfRkyJnpNkcSENWmZxO4Qh23f6U/xt4ZPHRCTdaGSXtTH5794vYUUDLNTm8Hn4jLNTNSC7JxlIwa8WGKl4Cqjb1jqxjdUr6ER7XV1YMrdJ7BnVyYlDQ0aVBAU8BYEEmyYZfCcMRl+BEBWBuhKFw6zjEOd3mMTFcVOM1K+gKpOaBtXIQWuxRwPnq4LKSmDFCl1CViHCgRF8Vi9IiQ6SFVBpQXiQuEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB7181.namprd11.prod.outlook.com (2603:10b6:8:113::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 07:37:35 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 07:37:35 +0000
Date: Tue, 4 Nov 2025 15:37:24 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
CC: <kvm@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <joe.jin@oracle.com>
Subject: Re: [PATCH 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
Message-ID: <aQmtNPBv9kosarDX@intel.com>
References: <20251103214115.29430-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251103214115.29430-1-dongli.zhang@oracle.com>
X-ClientProxiedBy: KU2P306CA0076.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3a::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6ea90a-8564-4ee5-5698-08de1b7505dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r/jXAJawYQQwVkPdOpSZNso5C5UzwLxv2caMlx/J0BeMk29yD2xkcrwdEv8w?=
 =?us-ascii?Q?UZNKAH1Q7U4IPZ8eFjNvyan5gyk34alREKL8gXEMHH9RHE8PAFDVIAqrsHzm?=
 =?us-ascii?Q?9uX6PiCniqbk8+EDGtcDKjelhXhcK2OYibX+snuBy7SYq+JOkhd/mlJVii9x?=
 =?us-ascii?Q?x0ubIE7Oj0W2GDg0zBMyKyjOIUzoKbBGRL1Z8rsVvTFnkEPCJAAOcas69KB3?=
 =?us-ascii?Q?jrmRC2Cs+8nLfs3FnJlTfe4AHgmcjOxho5etIU8Ma4ggfSaZRaGgTplDHP7P?=
 =?us-ascii?Q?35aaxlOlhs9GwTgF5XNJTW1K5zTPx1TkWW8jTJwAtzx+DNEzLupWYX1cX1SJ?=
 =?us-ascii?Q?ftfECPQW+bRSGXag1E5GtlIKFifyjsewx3yQuyrXMjCJydEysZa48WG71LT1?=
 =?us-ascii?Q?/XlYbwamI/IQ5YhcI8YjIoobVCVdW26MMEMx9R2Un5edyt+rfrpVnPiW2UUY?=
 =?us-ascii?Q?dONjVRaE0VaIjZBxa79ZcgtoThmeZx/aRab+9GyLNc9OJdlCx3u0fe5ylAeq?=
 =?us-ascii?Q?jp2B7MVCgRpCkSwQg8DrDMO6Ke5rhgOCeTlbVclA8dAQ5EFO20R6/W/NdAPs?=
 =?us-ascii?Q?nvne1YHxPYM2RpOBzbm8BTLtJgohgQEX/JLZEbvI0HiNFVW5YkDbynWTi2gf?=
 =?us-ascii?Q?0qUUh+e6NoqFXMzJbTP9P04A3od3nm/ljMcLd90u5TNhUsw9DXlDoN4R4i4l?=
 =?us-ascii?Q?3Kl/DwIyvUg3VZwmjU3aKRE0i3qgMAZ36joiN5ek3teA6V2M5qs9ey/PcjNz?=
 =?us-ascii?Q?SlmRS9TtRn0NsyL26YcVvbQfjfoIflKx4iGySG5ojOju9ZqoK20xFOyFEUHp?=
 =?us-ascii?Q?ui990QjwNBNBJeIOl+H4kt7IqWUetFDYA+VdFqV3BXuawyOBegME3E8isL6y?=
 =?us-ascii?Q?YnhX0yFs1rEmsZZyyJZNSkwyDtLTsYHTq6t8u4tVAxIt2cDUFSWLmc7ajkiE?=
 =?us-ascii?Q?IawtB/zlmmex6CbN3w2qNiT5AkojoO3m4WD/b0PXhofXI8egG935iJcXKojs?=
 =?us-ascii?Q?Ya9qLM5FpedlitJKm4LmcRfwkyI+hKmlWHi+aNt6BuKqq3wTYBhIp2bJM8oe?=
 =?us-ascii?Q?3G+sbbD2oh6jy4WotZoUn8fKsUvupwi6RWGYTv7uy4yur4WnXaAG1ChILuw2?=
 =?us-ascii?Q?t1P1bRKsUoAQv4IVTZrdps/YGErbbJVsVhCO242DHhhlC0aGk0OBBdvNnxsC?=
 =?us-ascii?Q?KVz+8dkBsNEbqY4qQ6BAkClT0+bAsjXy4VPhDBVW4ic1wJiDkuswQlI29QkX?=
 =?us-ascii?Q?1gkjdzxvRza1fFOirPUFo7VLZC2W+rG/+jqmK2pfqCMhT7Weumy/szOqRYh/?=
 =?us-ascii?Q?LkNcG8+0bmc5ub84oSTfE5iKdIEfYS2QPcALjd07ClJCex9D9uurNc3uFOQZ?=
 =?us-ascii?Q?NYb5frWs2Al7jRYf1K5p+T4kGaBfiZgGlsd84pg9ITPKOmWeKC2z7NQIm6u+?=
 =?us-ascii?Q?X7QcfFux2KJaccGvagzzWRZ9GWpWh+F8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o7Aqz1pghAhYiBQLWHM2UFkKDZujL7bX1/zq1kRkFoqEipeeWQv+IW2vTDUA?=
 =?us-ascii?Q?ThtWTg4mFacbNVD1FYxT4VajMwAzGLmLeS/13OoV3inIrYggcweKxUwsUtnw?=
 =?us-ascii?Q?IuA1H1YgGIvupCoyxxkmrNRElCqjLGZvsnXlJdRNnrFTN10DzDT5uAbSgZBp?=
 =?us-ascii?Q?oKOBy9GiZSJ5AHjD/PAzNdKH4NOS0x9Qa85QjPDU/N+G651r67I/yK6hwQew?=
 =?us-ascii?Q?h9xfalydmEIK/e5jGaMBSvtfSfOpc64ejV1dZUkgtqQErXNEVtwK3vsemdVH?=
 =?us-ascii?Q?CdIBeOoWdssRagI/9M1ticisacs9z6IaFqhZR2TOVcmbbBArkW8KPYNcFVei?=
 =?us-ascii?Q?xrF+12X1IM79EQWU7Mmfgtpa4e0QkYNtQ9+8pPHpxL55oOqY5RApvmnykB7m?=
 =?us-ascii?Q?CAdg9/YvIqOjVQh6TemYlRAvjkFcP4gfV8rRurWU8pA7KXkxX6G/s7W+e+dZ?=
 =?us-ascii?Q?HiRcva4kOxbkAscc/nJSRyIDJyjaLq7j42QImwzZfecEBZ7OgTW/MhEfJVkT?=
 =?us-ascii?Q?ZYmuOp9vbIP4iwq5AWhhubJWbMGUnVz6NclC9rRMeCdTLdDeJ/J9H+pU71vP?=
 =?us-ascii?Q?jA+0Q6CVtDDn126u6Dqni0TLuOLrMahEaxVBVQIbCaeisPoTJDDiDfLh4dz+?=
 =?us-ascii?Q?gGIJHUR92BJwXZki71TL+q8hxZQ4+zJW03TU6Vr1By1RXzamWCrqvxIchpdK?=
 =?us-ascii?Q?S6gjjoKVsxVRq01E9OztGHbdCapyVBOg9NDB5ju5bBztjsrHqh81djqHg09s?=
 =?us-ascii?Q?ZXvzlMVnkQhWKw3Wgb2eCGNdLYDuhKXyd0jS/l0UBEtaqbikt0+gJNbUqEtk?=
 =?us-ascii?Q?1wziQ8+Z8fa1HC/Fb4n7bonohq8lt9R+fjnQK+8K4TXdn5WLdfjvYSWiKz0O?=
 =?us-ascii?Q?VqDZEZTiTGh1253omGm6B8aa/xqAAwwBIxfg9Zb7WZLi6ewPxK4gaQAyFGFZ?=
 =?us-ascii?Q?wOPgkvmB1uRXZHEnpGq8jqH8lYo5j4EHd61k6qK8vdXDSQ8EaOpD8/pkKwpC?=
 =?us-ascii?Q?C2KXybY6RiBGDnn8zofMShPTQH7CDw8d/FDx78AGONgrVznohMT4PL61PzRB?=
 =?us-ascii?Q?GiZgtZ8CLor9lFsIMvsBn3hzlx6QtAqHbPkmW3MIsuffWdIv1xXDpi9MxE1N?=
 =?us-ascii?Q?oImmRTHRYL1DBJi87okevIbD9Ltht5P/EH6B29/bdxWf2KBj2E5phQZZG/tr?=
 =?us-ascii?Q?u0NKLoS3B6wskUViD6Dv7j6kaen2jkKSYf2znDCJq0MUL1sWy94N1EkJDwlr?=
 =?us-ascii?Q?aiWqpiDX2+HXUOXK5guJ9m5GQw7ssgIcgjQp0ditN7mWqd7pUs5VFkuCb27T?=
 =?us-ascii?Q?1HwKwBPdg55rqtsh0IBZra3BNau41vX2t3MINY3BctnRf4g1yoxHZ42YLO8/?=
 =?us-ascii?Q?mZZ1zXz8pwced3T5lTRru1Pp8xrjbeS4P27jVRk96m7DancF54FySREAqQwv?=
 =?us-ascii?Q?VuaETDiq/SSvuPDrWUU3LrLeMNwxq4NyDUJ4SL9MtzwnP69Y2TDfKPPVfMp2?=
 =?us-ascii?Q?Sw7ufdlGHZdiwqqChs+5SaOhItln3e8kn8P7K3V+3ciWNv4RscEiy0rZX5y6?=
 =?us-ascii?Q?yAxUz0fUV2L6AgYf3shRUOMT3kDDN88105Q22GDx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6ea90a-8564-4ee5-5698-08de1b7505dd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 07:37:35.8338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YriBcxnN+sq9m+1q2iKMKS8Pru1epWrTupsMxjf+swUocHGJL/5qhwN4uAnICPyASxw8h7lbqLWS8NJyocy9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7181
X-OriginatorOrg: intel.com

On Mon, Nov 03, 2025 at 01:41:15PM -0800, Dongli Zhang wrote:
>The APICv (apic->apicv_active) can be activated or deactivated at runtime,
>for instance, because of APICv inhibit reasons. Intel VMX employs different
>mechanisms to virtualize LAPIC based on whether APICv is active.
>
>When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
>and report the current pending IRR and ISR states. Unless a specific vector
>is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
>KVM. Intel VMX automatically clears the corresponding ISR bit based on the
>GUEST_INTR_STATUS.SVI field.
>
>When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
>to specify the next interrupt vector to invoke upon VM-entry. The
>VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
>VM-exit. EOIs are always trapped to KVM, so the software can manually clear
>pending ISR bits.
>
>There are scenarios where, with APICv activated at runtime, a guest-issued
>EOI may not be able to clear the pending ISR bit.
>
>Taking vector 236 as an example, here is one scenario.
>
>1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
>2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
>and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
>3. After VM-entry, vector 236 is invoked through the guest IDT. At this
>point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
>interrupt handler for vector 236 is invoked.
>4. Suppose a VM exit occurs very early in the guest interrupt handler,
>before the EOI is issued.
>5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
>vector 236 has already been invoked in the guest.
>6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
>kvm_vcpu_update_apicv() to activate APICv.

which APICv inhibitor is cleared in this step?

<snip>

>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index b4b5d2d09634..a20cca69f2ed 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -10873,6 +10873,9 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> 	kvm_apic_update_apicv(vcpu);
> 	kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
> 
>+	if (apic->apicv_active && !is_guest_mode(vcpu))
>+		kvm_apic_update_hwapic_isr(vcpu);
>+

Why is the nested case exempted here? IIUC, kvm_apic_update_hwapic_isr()
guarantees an update to VMCS01's SVI even if the vCPU is in guest mode.

And there is already a check against apicv_active right below. So, to be
concise, how about:

	if (!apic->apicv_active)
		kvm_make_request(KVM_REQ_EVENT, vcpu);
	else
		kvm_apic_update_hwapic_isr(vcpu);

And the comment below can be extended to state that when APICv gets enabled,
updating SVI is necessary; otherwise, SVI won't reflect the highest bit in vISR
and the next EOI from the guest won't be virtualized correctly, as the CPU will
clear the SVI bit from vISR.

> 	/*
> 	 * When APICv gets disabled, we may still have injected interrupts
> 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
>-- 
>2.39.3
>
>

