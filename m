Return-Path: <kvm+bounces-46759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7148AAB94CD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 05:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD5305011AC
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 03:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A14214A60;
	Fri, 16 May 2025 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gtE5W7Hi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22F2C9D;
	Fri, 16 May 2025 03:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747366355; cv=fail; b=OE4WDe7FoaU+vFA/EJm0O89zINfn7p31iVw07aGJmOCaEQwTIg3zjBrRzUcnlaeMguvdRT73kqO2yVwHCuc604RCZCOn8EgMvsQEtHLaI+xcR70F7cB4OyezW5z9NHkd+4NlN8qIn4+x1aLhTRMfQ9MCQOpxPPYzJ72XBjkAUZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747366355; c=relaxed/simple;
	bh=B+sslfQ8yNN2S9IUHZQt+02S5x0qg21uglldSOZ0C1E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F1EMGoX04z6aqVt/5boLVnaIvzIB7QyaVI8q+TRA33OylZ9y55Zw6MmxKJL2AwiTX3uPZRM1QtDfMXW9B9EZCvd3fGzYi43w23dJZcr3DGvXzqnrFHTHgPQa1eE5C3pYVxBoWfugyVYL5rzZKQtgu4MpAYQWNxdKKYFkLyGYFaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gtE5W7Hi; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747366350; x=1778902350;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B+sslfQ8yNN2S9IUHZQt+02S5x0qg21uglldSOZ0C1E=;
  b=gtE5W7HiKK7TuSaKlV4OGCwz97yB5/PXs4Ohz8TbCt5sV+EOafdG/N5i
   C/5gBM+4ROXMrzj32gXp1hRzMs8qOSYUU1MAeWa4/b3xgTDEuay3OgIgz
   VQyiV3sgsP8TGP5qB6+ysTsUesoqbfl/ZzsFqUiop2CP24urbjKP65OTl
   1oLtuyCfzQSI3TEdaEliBiTYIu9XmIF2ebJ611HBIl8KsPhuNaa5Z3TMg
   L6Jy3kLVw4Tn3GEuhaNWRtXG4gplNf4JzDx5ueEm5Uz7N6jFiKPoPwA4o
   IAGDIBElvOJIiilfiQYXX27PI9ffxtkNNlWC0YGQw8AweOfmV34JlDUQm
   A==;
X-CSE-ConnectionGUID: AWs158pDSBOOohk6yIZKOg==
X-CSE-MsgGUID: s2q1H0lwSeyD3xnWE+Hn3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="66877184"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="66877184"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:32:28 -0700
X-CSE-ConnectionGUID: xSvQHZlqTNuMowAelB0T+Q==
X-CSE-MsgGUID: gSCIrO/BSy6TKMcak0qoHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="169503589"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 20:32:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 20:32:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 20:32:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 20:32:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2V4GfMj+u9C17MC9+1jBH0arUoP9zWG/VB3tRQU3/ITamSL0SCBK6t8nQO8SHXEcaWbkVbF+JWIStAXvkCJ7PJP2Vy70vLed2tXn6lIf5DuFsWpp6w7ZhsRwVTJWMHSvWYKMOIFZMFyYamUZokm+/JbvRiKa3LB261RJPvJHoNZUJHG2+zWzTf57pcc4MdC+XMmtXcNqBIWTELGmDdW1DAUaFCwMBS/UkuNdHf3fAJyPWLNRrwWasTn/MJ7nA+QyJ7hN0L/TwwJU3y9Kdqn4ucIznKuS8DVBWL9QJD74BRA05RD/AecJt8Z/Cf4o4LANCMnVi/v3MOttzRv2BG8fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emnP1krA2ls5HfT3u8XlA+qrq/3tlsuYag7vgtv0Sds=;
 b=LrnVYu8mqzKWBda3AQDxs0fLdxMUZg2rlnNcEWxzPANFRIBXCRjxW29wUOFrOGDLBSkB3duAzxHFc00rZV3Wo1/lPCit4hCtwFCzwdEXu4Z5s5OjBqaiez5RVeQee/zrmukqlX7V6//76EXyfcbi11/Fc1HvBfs73H++/nrF7qbsQ3fB5R1hYmWvhHb7pFA7jeCOReXIQqLvRJhZRXByUdOmPNYeiaF+RXvGJ+MvGjq/NaOVmzkrFp3n2rdAYbdDHTaQ6MqHdNlPkqhcE+SHK3RBX0zKlEqNKkZD1lgABuUsfjmSKOGDbJR89oBSvusPE5s/41/rhvnO5WYJ+tulWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB5968.namprd11.prod.outlook.com (2603:10b6:8:73::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.24; Fri, 16 May 2025 03:31:44 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 16 May 2025
 03:31:44 +0000
Date: Fri, 16 May 2025 11:31:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Sean
 Christopherson" <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	<linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl
 value given by L2
Message-ID: <aCaxlS+juu1Rl7Mv@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
 <20250515005353.952707-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250515005353.952707-4-mlevitsk@redhat.com>
X-ClientProxiedBy: KU2P306CA0064.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:39::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b6dc9e-942b-460b-20b2-08dd942a2e1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f9j0JZoJviYR5ou4fYtuuTBjZC8rTRWyRJI06+qsqkH6mOctlIjvpLKULVsF?=
 =?us-ascii?Q?YEOmLL5BHADBlFesCO7CQPhbImbSm+2TIx9TkspqNtcQoY9EE/+Sekv6namb?=
 =?us-ascii?Q?F9KW8BPVq9sXSQUvoXhrM+Faohb2za2ikIUD08vgqvh9vkH8Vrpm3vo5XKrH?=
 =?us-ascii?Q?EL4xL2Fveo4oowaN5Nyug8GxqgKRzDI+WWfpbLmQrAp42f1shR/cY2bshQOI?=
 =?us-ascii?Q?7THjCaJXm/YA049iTgIilJgiQzJhnxoPAov6z5spXV+76Ayt6qD37svMXPvB?=
 =?us-ascii?Q?ZwWfjSWvY6Vwk/EtSJjeT23qHM/NanXoJyimp98OZMJXLC/PJL6jhFedTHci?=
 =?us-ascii?Q?Va+ZwrxtUsyR3z1EXx8flxKm4TJOC7Yjz0jZg+LPDWq//3nbcW70HO1jpiZK?=
 =?us-ascii?Q?dmc1bvvKRsnq2/R3G8nEuYAeKwOfSo43k+GSMp9+sPqnFYkmwXdhDeHcgwR0?=
 =?us-ascii?Q?/R98hVg5hbqlJYTHXGC4pyIyLyZjzye/T1GRG169jV1k07VJf1sCivozIwHl?=
 =?us-ascii?Q?fw+AoLRDRot0Lk154pYnnSSYxXZudRAtQ80qM3/g830jNvNzuJwOjfSuQqft?=
 =?us-ascii?Q?mqhf83WbPsmzICMyf7ytBiBKDejNHanvE5gM8A3zZJX0VwFrMriwTIkOzU8x?=
 =?us-ascii?Q?6cuR/hEpHCoeJUPakawcwhv5QQradIR5yKdwCW679Q0goj9AjxgZyeLhLL4O?=
 =?us-ascii?Q?LOQIWwDYwXGuZP4iRaH5ZLDGgoV4KQthJuRi+SaU3FKcra/PLlgm8ftH+B/M?=
 =?us-ascii?Q?PVSN2J4PaBg1RsPBay0MUgzQC3tIkWDe1n/BXFuu6dJIuNH5hwhAzNDREU3g?=
 =?us-ascii?Q?9CU1EHuzDrY3YrkSfaKQmQKsFIoOQi116HrRz/X+33X9hFfn7YMo9gNB/tnr?=
 =?us-ascii?Q?oZUbs1HbF4jPMGBXQTfyvcmdmIcpswjigmIEsNZ58+fv3VPCPrf5QRTKR4r1?=
 =?us-ascii?Q?l1I8UQ1TGmpnXlAATDIPqr6nSWHXMhnMngb5aD2hf7Y78rVEQNTRdKJaqVDZ?=
 =?us-ascii?Q?Hpc1KEUkygWv6mAjg43/lXk/bZHu2gc33fMW79sMPiYBJDswB9zrR7o5pV1D?=
 =?us-ascii?Q?Xa61fKVM6dRCw7jx5XFkYgJdhiWuYTvgC0Bt0N/hIt7hIvRts8yRfwWI53PT?=
 =?us-ascii?Q?O86nRr3uvjEiEb6xBhZvEAEUxD2cciD6uDlIfbQR+Ek7ln6cI84gyK/u2zA7?=
 =?us-ascii?Q?4++svgxEvfuBboigTZw+RQA53ArlZGmwZGUfYVgcoOI1Haqjzs7zuPYCBMI6?=
 =?us-ascii?Q?QP/E/sy0/PmDsj9vI9OFjs7upFlO8ChF1H4BYyRV3PR83+v3tkwOdtoXJKwI?=
 =?us-ascii?Q?Ey/hFVHMbDs/M12ORdx7dcKOUEk+hr1Ho6TkEgZNWPx77I41jqMrwvXJ177T?=
 =?us-ascii?Q?yt4I1xKqE0uwCX4OkceovmpYJDVWVH0OYDWe1+cN5iLXrZsVOjKQbUiMpbGn?=
 =?us-ascii?Q?BwIJBFRuM+0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SHAqYS+03e0w9wR3SR2SPfF8hipj9IVv7up3t3/i1uxh6r2HnrarnRCR4lzj?=
 =?us-ascii?Q?K90KZe7G9vpL/zmMuZeO+fFS/8a/PjDrZgbNYWlfpaPlZe6J+KzksmHzbp4e?=
 =?us-ascii?Q?4wPAT5bK3L083+PUtfHTo5ZLds2Yj2/FEepDkAiKXS5vW7Rwke+2two5/wGB?=
 =?us-ascii?Q?INkNGmIJa+4MKYwY9WaGJ6ZhB1a6bpAST2YXtnmADEdn+ydBx/l6qSEOKmMF?=
 =?us-ascii?Q?lR6FTT1j6kCL6V2fZjYz2WcvTSBHq/Yaw5/OIcxWYDS6fWK9dECgjp1MiLBS?=
 =?us-ascii?Q?5+tMHLxIkFMi4rjdSFBJLCtIKLhEvr7YwxVoBRtZYXjG9lVzL5BMz6AIEhh0?=
 =?us-ascii?Q?wAggfVN11/1XLQZ/bwheGbDa5r3YIxxtBqPut0BvtCJGdDgf7+IusL1waiNq?=
 =?us-ascii?Q?7Y78f9GOugNexpQFphmLFThMo01t9brSGn5rpHRT7lUcIy6fW+HLH88m+7Mh?=
 =?us-ascii?Q?RO6ax0YzB8KYatfD3/4+eYWtHtQGfejY7xHNkDHC4NGBl3Gx0wc3uDxu1hla?=
 =?us-ascii?Q?fMF+gCi6z5b8R0MtayKHQGNDDC3ZyrrNaEbm3xlV+PXcVFf3qJdwDOY9LwX0?=
 =?us-ascii?Q?HHvpLVLLyIKXDKOfTNquNbCqr18CbOiKXjR8ZX3JfUpG0AK8f9S3co9sBQsR?=
 =?us-ascii?Q?UWAmLrbUMs/HJD9cahJwSUsI9w+jmRhm6Qop9uKU4NJkAjmL8UyM5/JgC2U/?=
 =?us-ascii?Q?/FyW/K7ZxnsiN1v34BgkeygV2Uwyq0p2D5H7Mwy+FSScEx6UiKGq8dmjRSh+?=
 =?us-ascii?Q?x7VzzffreuBE8JTTQYt/YYog63N6DjIGxCDvF9lE8QiaiubjfrflEREYnxKj?=
 =?us-ascii?Q?ezEVigsfZkgtrFSdksw50ScEtdcnrCaPvmxlBCVrMf+NPIYyZME5SJicRfvC?=
 =?us-ascii?Q?1E5vaYL3gOznYWur5Csz2DGdeQucIKTU24JSRj7vUrXIeXvYjeCmstZ5qMl/?=
 =?us-ascii?Q?LxEsVyWXFja8y9LkiTaj03lHbati/wBt21usaJRFKOLcDK6oavjDvvpoJK2e?=
 =?us-ascii?Q?rpdzUDGXWfknuzc21xt5e4EbhlLFJ+1JqJmc5FXqioDp1LK9XfGIPc74A8zM?=
 =?us-ascii?Q?jtjdoHeXN4zmC+voTG1nmyahNk7SFC2I17wBCpqLF3WZ0KYU0KT28ygHj0Cf?=
 =?us-ascii?Q?hg2/eFTn7jL/Fiy4aTMlnoaF54eE7OWoRQsHck43SWhjRj1mI1hjkcNl56S1?=
 =?us-ascii?Q?ZIy9fRCmhe9LfP2RAaUZKi7YWek9TQQoFSA1zz1CNLDYYlM9M3wHIEjFe9Eo?=
 =?us-ascii?Q?DOEb9hRgGxaC6wjaMAPQpvhgfVqcHzkpT7Dr/vquKhQDhGRE4dL6NpF3Ptt8?=
 =?us-ascii?Q?VFWI77k4IJlyWmwukJ/DDZ8mxh4DCAQnwQopg1MFtY9H52oWyATuUnsMvlbv?=
 =?us-ascii?Q?PrRYpMAEtJto/4CNF+LN6CEdBZsluZFqV/lnkmRYkD+3YU3Xwh7rnx4qXO5f?=
 =?us-ascii?Q?r8usDrAUM9/uNo7kx50VkLfEs7fFTI3une37FVTnyppE2AbN4gOyNYvFHme6?=
 =?us-ascii?Q?aj0SEP6J8zy74LhYG6vCUYI0rCNnhyDk1gAziRDIftpUksopv7dzKvkMpU4/?=
 =?us-ascii?Q?Kf/ZA/qBR+RHBjA8rChEh5+KD75rYF6LzbKOiMW2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b6dc9e-942b-460b-20b2-08dd942a2e1c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 03:31:44.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UM1pIG+KnVIRb6BSwq7l5qlUTJwIql1BQoFB5TzsOUf366syxGWKeO4CzDtZdtuFhcS0FOP/s5hj4eY0QKyoCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5968
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 08:53:52PM -0400, Maxim Levitsky wrote:
>Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid L2
>being able to load arbitrary values to hardware IA32_DEBUGCTL.
>
>Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>---
> arch/x86/kvm/vmx/nested.c | 4 ++++
> arch/x86/kvm/vmx/vmx.c    | 2 +-
> arch/x86/kvm/vmx/vmx.h    | 2 ++
> 3 files changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>index e073e3008b16..0bda6400e30a 100644
>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
> 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
> 		return -EINVAL;
> 
>+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
>+	     CC(vmcs12->guest_ia32_debugctl & ~vmx_get_supported_debugctl(vcpu, false)))
>+		return -EINVAL;
>+

How about grouping this check with the one against DR7 a few lines above?

> 	if (nested_check_guest_non_reg_state(vmcs12))
> 		return -EINVAL;
> 
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 9953de0cb32a..9046ee2e9a04 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -2179,7 +2179,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
> 	return (unsigned long)data;
> }
> 
>-static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
>+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
> {
> 	u64 debugctl = 0;
> 
>diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>index 6d1e40ecc024..1b80479505d3 100644
>--- a/arch/x86/kvm/vmx/vmx.h
>+++ b/arch/x86/kvm/vmx/vmx.h
>@@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
> 		vmx_disable_intercept_for_msr(vcpu, msr, type);
> }
> 
>+

stray newline.

> void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
> 
> /*
>  * Note, early Intel manuals have the write-low and read-high bitmap offsets
>-- 
>2.46.0
>
>

