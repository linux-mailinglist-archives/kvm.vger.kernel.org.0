Return-Path: <kvm+bounces-17934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B8A8CBBBE
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B4B6B21D62
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 07:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1137BB19;
	Wed, 22 May 2024 07:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fv2FqG35"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60297D3E6;
	Wed, 22 May 2024 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716361812; cv=fail; b=JXXZ2yLIlyYSM1SDXR+jbgSIPGb7hwV07EcLWrQkwnkQambMrQzvP2n9cJXRRIPBGrHIWB4toAEK4OZDuIk4JTO4YSFYjdgx+xBZiTtWN0H2rL1x5d1Mm71W88q+E3+tXJuAFsT5FvaU22jxFVcS53b52d0XwDQeURSHdC1ytEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716361812; c=relaxed/simple;
	bh=lxNXnec6r6QDBTZlEMuZMoTgGx/KEseZZzhj3cnOewA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WKfohheE4/00jO7c4JmKrS1E5jnDu9TUwQqGAzg9oH2VK0FwY6juv9PQffNo1ipdl/oKzRYQNttT7vRhaq56+P+ldkxfeahD/AFm6OrkXRKYUzSsbIGpglWeYhd14uqIh4kJPar8CWP3GXSuoR/d5SrIbbi87ZcpGte66RAoCnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fv2FqG35; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716361811; x=1747897811;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lxNXnec6r6QDBTZlEMuZMoTgGx/KEseZZzhj3cnOewA=;
  b=Fv2FqG35xf/ftl1wXv38F1vUTXEyDxn4qx+tXIb/hkeTP9uBD0QptRLV
   w3FkbMvfhyjPHJxJaL+NzT6WTlpZIgdf/ghiu+o19WRm9LKMNlSPZuDkT
   2FOZSPIhRGZFJ7eJrF87KuBfxoz/Gwv+3/ejPyc6Pa0Y/jDzb/9WeayM0
   3muz+b6CCBzMzFCX5H8MyID36O9EOlZO++j6n4EG0ZxpyNNFVdQc6ce55
   MPBSU6jQ04Wocu6sHnmTeWdzszbYpMSGYlEH538iJNyq5Wnq1GxKc1Kq9
   MdP7NQzYl3tEl7fSXxSXpEehkUvSlG3jgwIFffCuUTjoxCkI1ttTxPGM2
   Q==;
X-CSE-ConnectionGUID: HHdJkSAMT4SpliJ7o2Tk/g==
X-CSE-MsgGUID: Q8BwkogjQtGH7a/DFav1Og==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12710821"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12710821"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:10:11 -0700
X-CSE-ConnectionGUID: dhrb4vohRHWK/Znv6rGclA==
X-CSE-MsgGUID: GCTfkW1jR0GMsckfSGnzDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33244153"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 00:10:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 00:10:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 00:10:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 00:10:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKhA8dmy5PNtt9R0o+VrDmwQeF/wywcsNg6eG/MmfSP88g8nYOugKS/NuxLkKaBPN8fzK7jd/u1NZ5zjNL9n2rM425/PNScLDQa3MgVRCGMTEBkiG4cbACOTeLv02dEUV+TcnOc4Yl1Yr6KGkjLy3tOUKAShRjM1zDDUPI7fXZFx51tSdK86xCLXTIfzYdpk24XntCY0lrQP1nwoG+hCwqhctZHAKeyBugWiTnonBqMPv15DyP1z2AU+XMT/6aDaK5NUhfC8NlzGShF0yk3MZq/a5BN+9HJ+uaqsh8ZaxudpI4fW1o0wTUiUcG210N69sCdlS0BdvyZwH6YycbwyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxNXnec6r6QDBTZlEMuZMoTgGx/KEseZZzhj3cnOewA=;
 b=bDXMdfIbWzw2AO65b/oMp5WGHmIjzVMlXDDz1X7RIKgWwQYlS+jCkbnSRV+8/ugBhpr/uiE108buB4VdVtjBzwAR3du/a7I+mFM7X6hmq9ELiAqMvJhtY3jjm/jNQrxjL5Mu3MXMcvSTm0ZIBLLHnBsFSNoXmaLCaVD/TwEQ8yylKTge5ICWQW5TqiZklEKROJY35j/5k4yxD+eCSsIDU/33XqrU9bhBpfBymTn/kfEx76psM8lljJQqYF9d/TvW3+2P1zRpIXJegT4LX+UZI8whJZ1gDHPQI5lnUvzyymxxm93mkXOd3AOV9KBvmQkR3lrqGGQoUB6DrBzwC6kylA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6836.namprd11.prod.outlook.com (2603:10b6:510:1ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 07:10:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 07:10:08 +0000
Date: Wed, 22 May 2024 15:10:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 2/6] KVM: Rename functions related to enabling
 virtualization hardware
Message-ID: <Zk2aSIK3sbtr0WEP@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522022827.1690416-3-seanjc@google.com>
X-ClientProxiedBy: SI2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:4:197::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4898fb-ee99-458f-1d4a-08dc7a2e365b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qc9zO6kkX/3eJvQRbND5T/FtxELrAD/aHpjWmTKgqvyEE1oVRGYTAS8bLv4k?=
 =?us-ascii?Q?J5UELDv6Da7d3rsscsQupy484A0jMSEMBikD+o/rUqy7OtY89PxXF6o9sHMb?=
 =?us-ascii?Q?lnU7Am5NJBNOtIfesTjdIVdsfwHjs+etthaWgR/z7jmz1kXBzxKcsRQ74PhB?=
 =?us-ascii?Q?C+065N48ywN8ADIGRRH8kozUd+dEOBigmLdZYEF7nLZyQEob+g+XAldi+kGt?=
 =?us-ascii?Q?hB/r+dRJdzAEjKtV4UTSc1NnXeRqzd8NcH+3volIEA3VJbmHBG3nlq16JXcX?=
 =?us-ascii?Q?h3SqIw6hriA7XgpRuEYAksMMC8d1qV34BxxGRKSGNFDTUCgwAJhVQfJEIUT5?=
 =?us-ascii?Q?JHzjSTgW7MkcQvA84TeKMW0f99dHWEGprz10JcM21rVsRl66uma0qa1j3nZ1?=
 =?us-ascii?Q?Xasa8WMVcYy0gn1f1u0x/MyWDEjKTAh7r9S733NW1byrhITMilT1UnkFH+Y6?=
 =?us-ascii?Q?oTGwPv0KR5xrnS0C/48v1j1AaKoS5LHWrq2jnscAw+bG25cmoB5IYORIQ8Cz?=
 =?us-ascii?Q?EHwNITMS6YHxI2MtWZSjXEIHo+COvTgmpxfLv3oOScrH+WCuiyYhM87877Mb?=
 =?us-ascii?Q?07QxIECfDJch/HdvDxHEySPX5CbusvG5FGNTMvE458Bl2SbePNuie6zgVEJe?=
 =?us-ascii?Q?qtkSpkrGumpW8uhmM0u3hGop4HdnEtwIKQe+cA7fN4aYuLyHViJU+UV3hBZp?=
 =?us-ascii?Q?8uDHKpmhFI3+D9NFN68MZsXX4BIY2/jkSvVjDdYSURENA3iwsnjQDiyk8IOi?=
 =?us-ascii?Q?m8LxN4ErcUQWxQ4bSRkTqjnZRFc0R76hwlpCv8se+8ULk7wLavyJ7GG5EiUj?=
 =?us-ascii?Q?A2ORivX58jgtlEYdFijuYXk54ZjkYxEDGNkEbsBSWvXe9pI+y5vMEKfnAOlP?=
 =?us-ascii?Q?N9TRU+ywwZ8fJW0H1Xu6BsfwLm87lwQyU23dcCYG1lv0Fk3pAlJKZHhllpR2?=
 =?us-ascii?Q?uSNyhku5jAH8YJDk/wQ6M+5Kk69UWnWCN8tXz4dS2E5oNtf+FPV0i96jplwi?=
 =?us-ascii?Q?dmzTNJdXJlhwyPiSqMiJg4ujlxvhDwVpYfIG48XhW6s8JARenRrToAoJpZDd?=
 =?us-ascii?Q?mZLdfUBgccLA1RoYjfCSE8jwlbG+zDhpOPgQFKA0rnx55J16+Wc4Kiiwzn7y?=
 =?us-ascii?Q?8ByWhzkyJvXwZE8zhpB6vJbgfvK8jCR7Qo/YcC+ALZeBthaM0uH0Rg2x1HKu?=
 =?us-ascii?Q?C6p7TekV+UaWTfk4VSp8YgGtsgZlkB1Cpf31gLNaeFQOym2WV9PS41v+P8WR?=
 =?us-ascii?Q?mz/caXY6NAEhDUlCzxev9/5mpLDI3vyWHGiyuV66VA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42XK06Mdqh5FIyg1+DvK9mvEi6GCVomyBZdq2uCuIy1yT6yldHhkYG+V0qB/?=
 =?us-ascii?Q?mwubR/t/uA0F7ldbjbrD732RB/ux9DDZRItX1C+1FeAfl8+/GrrPZiY1/NXx?=
 =?us-ascii?Q?1wdgXY7/XMnChxa5wSpGU911qhZCg/OVmmxk4z+WGpqBbUH9WquIk4bv3UyI?=
 =?us-ascii?Q?GblzuXiC26/5uYila3+wmJLuPGue3YaBcPpuAoTG/EnXmxL9wwgOEIzuK/7J?=
 =?us-ascii?Q?wGc94fA/zeN1Q1EHg8AgpKYCpVfa2VgqaaC6byFzM+Aia1sGFkpNNRJ4YmoE?=
 =?us-ascii?Q?6R+Phfc2ufi5CueHojCfXQAnzLO7j/2q5BNp71pVU/nGZIU+TObVj+LZ7HSo?=
 =?us-ascii?Q?KhNvSYQ+ToO9d7ZjNKzuvuSBXWs57BcMyxU52f+yVw/uV48DtN9PS1TmQKkA?=
 =?us-ascii?Q?PGOLZPJHkxeBtBOAu+TJNiRvn2cpJuIBwMepsQtkIDq4je9uV26VL0gWoVZc?=
 =?us-ascii?Q?w+0WYWzR81cNjK/GGHYFe55v8DDrGt7cHL0EoDNAXvn9NHSGiSkTxuSlQax+?=
 =?us-ascii?Q?vevbDQ4FP0Y4r3bdQqVOFUgb2AhtmRWT9ffhEPO/wxA4FctP4ZVt1C29YqPE?=
 =?us-ascii?Q?BYVfUUZR5zYNxjfWpwPUl/WwRunQeYAv0IPiaH6/leQlyodwgSdb3csUPF7E?=
 =?us-ascii?Q?aoMMIQ0v5fXylJ0jySys4AFcelCd1HdQEaHbw3wY/NLd2AiqQHChQEBFsByI?=
 =?us-ascii?Q?iCZkaNYxZ6Qh/diXBcQdXbB6X5Wk6xPxvVMsDzFgtuNoI5rfQfcaL9AAUls6?=
 =?us-ascii?Q?ti0tKYwW1SO5tuvqtRdMCt71Ou62SIDVLBFadITm0046yIBlVuJDMOxGAwVC?=
 =?us-ascii?Q?zlauxTkZrbbw1QxhjhXxNrEQVmJq5QjNugPhaIw1G4hxYLUs1Ku4MhnJfkvT?=
 =?us-ascii?Q?I7N63UaLljAst7IQtZa1r4yg2bDCLtfv9O2fK51DZyaei3WyFWPhdGIjjzSV?=
 =?us-ascii?Q?terluOykxn4l7z8Mx2JiyDQWD4gWPB0P3ROliraOwb2vO6qRePqEnGGoBcbC?=
 =?us-ascii?Q?qsvkwfd6pE47/g9jmTl20dJx/VCyKPdCkAhulQlMtet1pIcT8hJ1+Z4X9kwW?=
 =?us-ascii?Q?X2z4bDq+/HbGoQsZYVMwiBg+v+5p37DWQcq8xIxObMBuAMJhVUsqFueoBmJ0?=
 =?us-ascii?Q?wgFoK95NwiXDu89VDrAY69oZLuC8wwQy0of3QVzdZ0jH+2VWK/yVhFii+vAo?=
 =?us-ascii?Q?2Qs8RyKE2dAf4FtVltBfrIkkUNVtZcNsAGagObYKspZ+aIWkjrrtjFreUGpO?=
 =?us-ascii?Q?cka58addaF2pb95UhliODU7n7OB8fEnmSyzURK/DL4yJYCG3pbWHtg15fHhJ?=
 =?us-ascii?Q?KTJ0DLEBvkBccngSWQXu9fFKZTGs3fAYcOG1ApKrhdejers6ZDsc4gYS62kh?=
 =?us-ascii?Q?P6iH0PyEwa7cTY8fnj9SVvZPEpHxpa7UzdO6UDZJug+CVTogE0aMWHamSw4U?=
 =?us-ascii?Q?353WzG3KfuMxeNdYcCNJbeO2W1N1veX4puNo8KLjwUofJAR5k1nZenaMxqhr?=
 =?us-ascii?Q?H2Y/LaUIogC5WfwjSwXvGZRrsVBvcsdf6Obs7Zh8ooVZaf7NxPAkkEeFjwmZ?=
 =?us-ascii?Q?UUwaEvVXxQQXbVPwS838fYjUdC98UiHvZGfHxv56?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4898fb-ee99-458f-1d4a-08dc7a2e365b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 07:10:07.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMoh7PYddL5eVCFC3M5MwuzDLzKmKU9j5fe23M3tCHYaZspW6ULEl3EFdA4+1pp1TYdUUr60cGJOVtfBDCJKFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6836
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:28:23PM -0700, Sean Christopherson wrote:
>Rename the various functions that enable virtualization to prepare for
>upcoming changes, and to clean up artifacts of KVM's previous behavior,
>which required manually juggling locks around kvm_usage_count.
>
>Drop the "nolock" qualifier from per-CPU functions now that there are no
>"nolock" implementations of the "all" variants, i.e. now that calling a
>non-nolock function from a nolock function isn't confusing (unlike this
>sentence).
>
>Drop "all" from the outer helpers as they no longer manually iterate
>over all CPUs, and because it might not be obvious what "all" refers to.
>Instead, use double-underscores to communicate that the per-CPU functions
>are helpers to the outer APIs.
>
>Opportunistically prepend "kvm" to all functions to help make it clear
>that they are KVM helpers, but mostly there's no reason not to.
>
>Lastly, use "virtualization" instead of "hardware", because while the
>functions do enable virtualization in hardware, there are a _lot_ of
>things that KVM enables in hardware.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

