Return-Path: <kvm+bounces-48490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24456ACEA8D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BE493AA2CD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A371FAC4E;
	Thu,  5 Jun 2025 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CG9Ad01p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F91F4CAE;
	Thu,  5 Jun 2025 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749106781; cv=fail; b=Py2lhZfscw3ENMad6hOidx2YwV/iZ/RuObsVMto2+OTRBCAEbhss6HAm35yVkfT5GCPEFztWBbLQdvrETmP7pGwmyXzttyU1xJHJIiXpiWkmpD9O9+UE8DoOoD9UQ+sz6VvPKk6/t4mz0O7tlC057cacBOobdHmPKQNWo4dTrkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749106781; c=relaxed/simple;
	bh=id1UVJCSqqlJtjHMxefHoSpFCitPRmI/dmjefPNL3EI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fumTWg4jQJTUptxy2IA7/HQXWPJO4i6YI4eId9vYnGfIkpJrs3bszn6Rhw5Jh99epPo/ZhOrNHgRXpaaDhnbbanFwgJMTqC37rshzHdnZ7vBHhD+I755ii69QgAcx41yAWkPv4VvnYiZD31AYJBMZS9cWGrHr9n7sFaBUtip8So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CG9Ad01p; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749106780; x=1780642780;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=id1UVJCSqqlJtjHMxefHoSpFCitPRmI/dmjefPNL3EI=;
  b=CG9Ad01pTWuty1aUJRrB8gV0Q2jEGWTQIyxfLslqtq6DJG3g8KC1EZmM
   zY0xNakg2uSsRWLaMF7c3mgtkn1Y1lspJxowvVmMYUCCOyA2ZDT3c/xD2
   WNj05290sst3t9tiTR7v2l3FaYRNRgw3V0mE2r2IftSqr4nZM3vs7UNVr
   67rlLRjLd7EsAgkCxVcNQHA7X48+N5VgqosJ/jfFNgdvTUitIfoYbLmbV
   lV5GC9Vsj6485136yWgiPaSqwKZCyxV1TpreS2XZoVakKhpF7auSBwFgp
   GItT3m9InFmb9jZJb094MhnFpui/zrc29wfQl/gf7UVCxcAWVD0bSFhKv
   A==;
X-CSE-ConnectionGUID: pz0+k2PXTjuPUne/pQ2Zsw==
X-CSE-MsgGUID: z/sHP/4kQsiM+IMzwUrRhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="53840372"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="53840372"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:59:39 -0700
X-CSE-ConnectionGUID: +HiCt2obQgqrovtVaVX83A==
X-CSE-MsgGUID: zD5+33KkQJCmTyelGJUljw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="146011018"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 23:59:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 23:59:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 23:59:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 23:59:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jBtNkRj6TdDYfWRrtyrmg2wnDUUL9j//bm7V2nrOVdmcKXQ0WZB35SIOvHa9cl/QpfvsdYAj2A6wm7kMEgOZ3p3wLSDmBd/sgXdl+xtIVuJ9fAwoSObaNeGeZMOn/qbz/YxBPeg2n7ZHWs4IWTIgI6jses5r7FEFuNgqSB6VWZFiq/N3uZaP+3VNgXSqbRk8uVkDUEeQ1djbkmqD/MA5VojatxIXcI25rIn2pESnXVXd1oV08PsXDdLNNA8Lyr5Az5TAXchzGqsD1wguIfVi0iD8G/BvzqVAdiD8ILsSLe0W5QDBWV99Ow69nvbfvZ+pr5KIheIL30LxGHIpyFBirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wlhPlQ0xvgWBZj3jit9F8CyYhkLC6UhcItBfdhIldQ=;
 b=KEHk1IbnqxU1kf4D7zvdUKJKQ8xz/+KRVtJ0ItXs/UFcMb4vItZnD/NtrU+u54uhpILTpuIlTWBWF7EpyL/rPjUCzXFUIMFgRvft+Wg9zRn2jxyYrM7X4rBitYHdPulblfWo4BXtJXt8rWJMI227EFwkI8pc4rtaAY9D2TIpkfChA/s7QigIpVQxChW+FgCOlu5/GG8hjIc8fPRCxPOxgGgQUZkxmOsa9jkUJuGI2R2XdeEx5cm6LsjIlsaqFP8+ip+VCIjFG6j2gULFoh5p8n0ws1Ylvs9k9jdv0Z5MTNDZc5Zocq4SKIIn82oqbJOu93FZc4ZjR+GsjnUgDDZLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9086.namprd11.prod.outlook.com (2603:10b6:208:57b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Thu, 5 Jun
 2025 06:59:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Thu, 5 Jun 2025
 06:59:22 +0000
Date: Thu, 5 Jun 2025 14:59:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 16/28] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
Message-ID: <aEFAQW2HxUu0ynVr@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-17-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-17-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 57fea47d-324f-43cb-5453-08dda3fe8026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3svIr0Fuy2QiGlw8DpidmMSlepiwrRhJ1Ko1xNhniumrGYrXsbWh9kM6d0za?=
 =?us-ascii?Q?y1f8NEUbdGMJv50YJdTZrRh6J8J7qN1OXqX1zw7mHtFDyzqCg3Ooy/xRVjms?=
 =?us-ascii?Q?jLFnvWq2fWPmaeMzWhllYNK+6un04J3nPlgQhFkfRNNHXLy2n5DQSHFAERBK?=
 =?us-ascii?Q?O5ypjtdF7LQNBR6hojYscvNFP1NY4npE/BmpHyx7QqCvJdUzq1SWKzaF9f4u?=
 =?us-ascii?Q?A6qRPkLe155LhmBtkm2kiqU3APt0SLC1ifp+Bqbp0Ws9vzLuRfhO42VoaP9V?=
 =?us-ascii?Q?Ebtcl4oaCoPXz7QvAd1vEj4DMZYWs1Fqi1DDtcvbU+nSgybHu66wgahPSAOR?=
 =?us-ascii?Q?N5LTzo9eMlhCW5u6Bb6aO3dP8XFs+P3IN1uCLZ19AayL1XoVGlkoUYocya1H?=
 =?us-ascii?Q?VCl1IDshVlBJPHOXgPOpcIKE8pLSQJOkZddp5HpXkkrMtuWODBgXF1wRRZlN?=
 =?us-ascii?Q?NCTaecBWF5bcR4qduYGEsstn6ixu/VVY/EPo9CFk2M47oUmDugQdStX0U+rt?=
 =?us-ascii?Q?BYSb7cc89zOg2rCXh8Wq5uInsbCKIY1wZ+VE6ma/FTbR+QRDazFp1qgucaSf?=
 =?us-ascii?Q?LzMxNTov0KwcNpF7ozEWenA/ck04SuZmEx0hlNMd8klnZaUy/dgCgvHUSfpF?=
 =?us-ascii?Q?kjr0yWCiG8MOTHEWiGAsTDCygiyqPRtJLzfDfRh2R6UuLzOMtqDI8o5Pj+UN?=
 =?us-ascii?Q?Q4PWobT3PPBJOSO8GYUlloD5R/lHkZJ5ujA+IFtqNLyEu6EUaBhWHp3bkqp8?=
 =?us-ascii?Q?7qI/KPytxr9cL5AdZ40D56GpPC0W3Bbk7XT4SHPfzn3h2RZuFtgaaMbjCaf/?=
 =?us-ascii?Q?eeJEggAMnuxSU+kcOlhi2V2b+D8pTvetDRCQcALpN/xNSiPf55rVg3r4TsWk?=
 =?us-ascii?Q?ZLhZC5NeYSV7rn1M8Bko03ABeKEYvgd6Izp2nzY8sxUFlSFmL7iOsHiJzg3F?=
 =?us-ascii?Q?DAopmwMqxRaAnpfaLro+cUabvL80lvcefA7Icaodbp/TEktyeLtWFoXfwe9t?=
 =?us-ascii?Q?3qsB0aE9nYiKI6BNXJ8+YRzQD2Xcn0jfURqoxSa3y2bUiOKL3zH/bOkv8c0f?=
 =?us-ascii?Q?7CCTfUBKg7m1J5XrWVi6I5T2b1d6DoNsecm2e5a9Unzj69ztJ7+foPFlbHgn?=
 =?us-ascii?Q?V6MX7GeL8diOD/gNagB01sWETTunRmp0FD4piWnN10KzRDyo19VT0vxFqBW3?=
 =?us-ascii?Q?EJmKD7Mvpwe2b8cZVgxvQpt5YR2yJ3uoI0G7klie/tY8Vj3/aCbFsb+fntEX?=
 =?us-ascii?Q?UzGHAeysbzlHW5TtqEHeoMJK5ZgYpM7xzxlUgXHfA/A17aJowrZKu43J5Q0E?=
 =?us-ascii?Q?0BoQvJz0ZY1Ue7PAGyLgbAdYdtrYQZ/OtdoWG3MzBH+MoYIOrydv7KdIwh3f?=
 =?us-ascii?Q?u0Fal0FBq8X3CmQFXeW5uEbmEkZ1?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cnrDs/TuseVcsSpkLEONXV31WUBmth5uZ3w3OuZh0LvfVsSKv1wjNC3+ulzH?=
 =?us-ascii?Q?sp6TNSUGj4703P4F2olKzU3H1jdO0qGf+AME+/vsORER4pc8gSfDi0kHxL7j?=
 =?us-ascii?Q?SHv0wR3Fe9J+Bi8uevYESmKISOcyQovSpRW4pJT6yaP5/tYjkCVBDNo4RhUh?=
 =?us-ascii?Q?ixjHiG/R0f9x4nZ3aYifgRqNia2M1zcWoRMH97BN+6y6pDOiiIo3PS8nXnCX?=
 =?us-ascii?Q?NpgPJZnHvUArAQp2mH8k4LIgfsagJD7ZA7CziaXI29w4tXpR6s/pxBvbv8Hw?=
 =?us-ascii?Q?zIPtkscog8UVTDLwfwSquEGjX5T5D4L985dj7ekj/q7DYjomQ9iiSGCo60VZ?=
 =?us-ascii?Q?T1KjkTl5gOBwUqCzYOVzPXgGU88sqMd/9nR4vaY7VKTCKW6jqSa4VXETuuhQ?=
 =?us-ascii?Q?6GVYSU4jcmc+w0S5S6VzV5HblxMHc+p2M0ER27COWFS7TiOzdB0fjLO9X/dr?=
 =?us-ascii?Q?dnk2ZQZF8YY1ze7xIobAL8RDzUDFtSgck5brUIcFiE6Wp9fKX0+i6vZBtGHx?=
 =?us-ascii?Q?T80OmY1GjiP3Gw4/U3yLm3MzyL33xfmDUVeyo+zi5/NJGFpf3dspeQuEuBkh?=
 =?us-ascii?Q?thiCQfIMz4OsiVygpY/qYiCOUkRX7epWi7qv0GnHaw6z3l383VkYoSNVNCBb?=
 =?us-ascii?Q?UnNyfAXBNohxwpY9k7NwLYExk8DIQWkFVdGCYW/wg+/c3rAi96r9SR5rx9Iq?=
 =?us-ascii?Q?b4nLsnxwmKA4QUHvEdk5v2RcmXZpusLLeeyutZSTlNmCCpXEV+YkfS42oD6N?=
 =?us-ascii?Q?kFx1NEFNE7zBb6oqOb4iCZJjwJuOe6XZErTMwJ9GMqB73iBZOm1Zuu2rEVUW?=
 =?us-ascii?Q?e0vhgHdMCE1/hlGqU6Veue/v8G9agErM6O4/ugTwCa4IGSkUuslWMQrxDKP0?=
 =?us-ascii?Q?rbJk5F8kbVsvP3EyhCvVIIFBO0EAwMODjH/rfK1w6/jvMn7vtkSnZlkMgoR0?=
 =?us-ascii?Q?mGaPx6l97U/576X8mcnBE996xZAXfnNHH93omAEsvhGVYYStqjNQYTJxUlEU?=
 =?us-ascii?Q?projHeV2xKYxJOvBBGyMHPlWJyEldSwQmn1CqvIWpcYwLR8H/3Dbqjdj5i1w?=
 =?us-ascii?Q?c67IhuXIUJsl0QjnVmcH8Y4JRh+kL4kBDLNZoiRN96Hvcb/wyzw7CgoH82M0?=
 =?us-ascii?Q?aP72wmNRdpIzVaK+jUInSN/IhAMcdAmYjOlGImMW9TNXrjEsdl/71XryjJX7?=
 =?us-ascii?Q?JS+hUTtOV4BpglbmQYDbzFO17c+wzDGUKOWsxmaaDvR0AS9sibh6QdD6gsUV?=
 =?us-ascii?Q?SVDIVKix53ywnzF6tztiAQkvtx5khY3y0N9DP3lk8ft66FZ0OQNI7aFoIS4f?=
 =?us-ascii?Q?2EhfrxT3PHnf4oLX1qCPigms7rkFZQ7sFTnd0ydoyAufEGVH8bHRTFkWFOfp?=
 =?us-ascii?Q?Ghm09wlJBM20mKno4Mk6z6aGXT/yA8tT4uEZCK8lFEpbhagO0lTQUAI++yWe?=
 =?us-ascii?Q?UOkz4aADZ0T2Gc1pb8qlV968Hpa0+QlZYcxtgolsfb08YsFtBUN3FFJOsKz/?=
 =?us-ascii?Q?CzGyin3BSIXxvGFlWCcZMQnc4Vof4O2lstlj+iJf1XLk0OqK1oHdjv7b/vNR?=
 =?us-ascii?Q?bgql/NbsY8mbHDIEnEUkEWDNq5cZ8MsHgVFBux64?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fea47d-324f-43cb-5453-08dda3fe8026
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 06:59:22.4749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YeuMZc6jvP1rlxWmtwAL2MLCvtr/OS2jPeWLLxaKSal3NOIS8PzQ4L2tN/Jw2BweD58guODS0mP0iW65XydOFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9086
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:40:01PM -0700, Sean Christopherson wrote:
>On a userspace MSR filter change, recalculate all MSR intercepts using the
>filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
>desired intercepts.  The shadow bitmaps add yet another point of failure,
>are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
>and a maintenance burden.
>
>Given that KVM *must* be able to recalculate the correct intercepts at any
>given time, and that MSR filter updates are not hot paths, there is zero
>benefit to maintaining the shadow bitmaps.
>
>Link: https://lore.kernel.org/all/aCdPbZiYmtni4Bjs@google.com
>Link: https://lore.kernel.org/all/20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local
>Cc: Borislav Petkov <bp@alien8.de>
>Cc: Xin Li <xin@zytor.com>
>Cc: Chao Gao <chao.gao@intel.com>
>Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below,

>+
>+	if (vcpu->arch.xfd_no_write_intercept)
>+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
>+
>+

Remove one newline here.

