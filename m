Return-Path: <kvm+bounces-29591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FB39ADD76
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 259091C21515
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE8D18B47B;
	Thu, 24 Oct 2024 07:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hq0svu+U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121E918A956;
	Thu, 24 Oct 2024 07:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729754311; cv=fail; b=Eb2VGe+4GV1PomE21/w4lm866dpCWft70apSetaIz/SzjJSBAs5kEoStkqeGSiR5IrGgL6Io8QZA28oZbmnTGv/iPT/7wr0clncnZMvNb4GlDdJYW793aeC96U8jUsdu0NbNfPqswsLujYPcnf0tjx/U0K/1ceF22XMbtMlguPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729754311; c=relaxed/simple;
	bh=R4IcraTINPODYRJwONV30sd8KC1QFSnDZLJ4dGfhUAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ITUKfPgm8b72dLN3QgIRSdxQN25Z5LX/r70E0cAoPHbHpyIvIVSERp27+oR+/iNtSZiXqkmE64l7F/vS+PPCV6ldkX/5AXOFvypHxzfYsyJfF1eK3CG+BQxOfvakfbFrYWPSp3cdqHhInBHmotUiRj9SaIIPF0m2KrakmUdqMtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hq0svu+U; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729754309; x=1761290309;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R4IcraTINPODYRJwONV30sd8KC1QFSnDZLJ4dGfhUAM=;
  b=hq0svu+U36oh/HnjSs68Vg1dSWD1JflnpDzGE9RsyGsVJJNR3028volk
   hRIZmnEE84Kf1HfORi0tKvrf2ekcTtLF7OJks9kYROXFXmT3gpiFq8ArE
   fdQScczR72lth8/WYDzJGRSnsuI6xk9K5geUGAjh8v7y2ZOtItwfQsqYs
   Y0qpp3kTwMWOpk6BqbzB2p04AQ6g8dCRuUzONDlC90W5qQUiicpiLCFzd
   +2m+tBK3Ac3qnHzlGLYaSZoSoGO7+ZCVgBMODl15tTf96p1YJZA2R6np2
   pxsA2pKaJ4RLLb7bhLiAC7t2sS7soFYVlB1DfCP9u390t/fVB8QRbdaNn
   A==;
X-CSE-ConnectionGUID: 0FKr9nm/QnWoqDcFC19HXQ==
X-CSE-MsgGUID: prmBExmJR82j5uH4ZJ7Svg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29535785"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29535785"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:18:27 -0700
X-CSE-ConnectionGUID: RavQUf9iTYeO3mXwiSVRTA==
X-CSE-MsgGUID: ximrnsMwRGykmMOQSjRCag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="84477757"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:18:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:18:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:18:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:18:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNu29gdMzP/+GiLYxMuyRGdOZqdhz8LzkjdmUOGh7pwWu5HUdizi/oHExROPzPtlqLGZ5yqou9xup5Xz7Nh1tWfajRv0XwMUz5qKG2SUURmHwuJoQ40E83iE+qylvYR8r/3ujuTufVtkc6kKViBF2/NrM4Q7JebtCp8qIfJ1AJNon+h1M2GSlylEvifd36FEKO/o/2/Lte/s/XkGzlF/5GcVu+FQks3y+L/JB80U8AXyJBTR90ORXZmfL91arAhnmMqgdP5LywZ8Yqfrt7WYMqhVKZwXs2I226PNX7mYodW2qKvN0yIFTqRW1uLsfiSSdl/jgZBQz3AJBNc1VtI+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHnTif68XwSrn3/Ls0TY2FMrOriyh6oct9+U88l9irE=;
 b=JL4OmAoyidFxnkfkUGaRf0ovaldUuNhmvAdU5+7bN9z0yQwWCuhfyhJr1GZYVSCJyW9dPNlBOlqNtacgOosgP6rPnHerPkQoSqjJ2Z0h0uBrfM5obfi1Lu+lhSU3w5SJQfSk5dLw7SlUQJuw+TBPBX4JhnPFgbz8drWp+fDgkvJht6yadwd9QJwbTeC2h1yeK9bHdQO0INtz6MbQx8EjXBsUcV8na4yB7kX3HktISxG/wFBWy2lz/MnSPt0zEyyK2yefCntHtHO5gXiTiiMMcZ0/mKRdsi+q2pI5BonQeo/O5UD5j0ZzjwVlv5vgW6+Auf7Wf19CJ6gti3bLj6XxfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7945.namprd11.prod.outlook.com (2603:10b6:930:7b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.19; Thu, 24 Oct
 2024 07:18:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 07:18:24 +0000
Date: Thu, 24 Oct 2024 15:18:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 17/27] KVM: x86: Mark CR4.FRED as not reserved when
 guest can use FRED
Message-ID: <Zxn0tfA+k4ppu2WL@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-18-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-18-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0046.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7945:EE_
X-MS-Office365-Filtering-Correlation-Id: a8428203-e19c-41d5-c725-08dcf3fc0c36
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6eL4kh6/TGqA5d9/zN0tqABdD2Wm2GVIjFLCCSmxnZEi0KNseKI5iBI3kzza?=
 =?us-ascii?Q?4BYxBHoNxV+zMns47lAeeDLEMlx0Hw7uulMwpzfq+MEZIiThA0L4d0uAx20c?=
 =?us-ascii?Q?OaSPl5Net1aGxX/LxTLab8zr9vHuwv4Xdhdkv3sCI1k+gFpHCacqRCxJFxf8?=
 =?us-ascii?Q?0A8vaWo9YdLS7Lk0OJUIwD/9GQyOE8vHKxGWaKyMLOrx/2xse04mfhm6196u?=
 =?us-ascii?Q?gi6auOP4APAJvub7PjGyB8O9WctNenBg+D9FleoYPrZ/01qx7m2Wr5UrHMRX?=
 =?us-ascii?Q?uB4Sl2gPKNc8ZadkDa1Xb2kA45uELDX6f1VGCyZrOhhrNNrpVpqW50TXE89B?=
 =?us-ascii?Q?NyvM0s0V24jwOkT4n06sYR8xEeZz+lbo0jVI1JRiDytzH33crGuLuTYa8owE?=
 =?us-ascii?Q?dv/rASccgrLjkTUW31rlpwW5ko9JHy7dBF1xCth0fmJHHQOHWqCvV/LA7VHY?=
 =?us-ascii?Q?IqcziQSsaqtxDEarkkzwx/b/vPE6G7AFjqTmHs9XMWVL3sNdEbestcHM7K6Z?=
 =?us-ascii?Q?1cb+wQTL4mM4pYJ65/3ZsB6SwwMT//mZvihjfdHOtQY9OnktytSwHH3S1y/7?=
 =?us-ascii?Q?BdLNKW3oNl2wgh/l4zcFVvjrFkffGkdyNgFO2mUJxoVnOo+4CCsdGQ9HJVN3?=
 =?us-ascii?Q?fGmRjZMD4DpX89aE5LNrFubglJgpXtvpQsr7yx+3vzGQP+NHc3RqNannETdD?=
 =?us-ascii?Q?Ii+A2qiFt6pjso/sATG9OblqGFmy20upx0c6qY5SMdhtLiQhHPhBPJFC7vxo?=
 =?us-ascii?Q?+6+UBmnKi2gXKHm3RnF+ObzOAZ3ij4ZlRB0QoFcKsNc3eRr8ha920o9Fma22?=
 =?us-ascii?Q?wRPB12NAMc1t7cqU7LJ4GPoHeV+Wv1OuGmvvhl98ommVK+i4xK8XUZh+EeGK?=
 =?us-ascii?Q?c6DCGx1b6NuLM01CxBRz+Txr0rC3OcF3KcAdDrWAWJayy+1PHboMzwqU8TL6?=
 =?us-ascii?Q?F7jS20VlwkhYH02mbC6kV0U4blkzqu6tioUu4Z1+J/VE8NIsRFsDtI53uaim?=
 =?us-ascii?Q?+SwUQ1x45M/jjdGsFLhKTaS0Ha8f0J1UPIhcQ/XgO5mO7gIFnkZqEqBPOPpg?=
 =?us-ascii?Q?ja/R7ljGvuKcBN0qHYSRBfThNo2J/emo8+tLj6TawaxhUe04f9meojiou+XY?=
 =?us-ascii?Q?RuwPtwpfccNHomppya33KfZuzI+bNS2Ps0j/Vuw4wBWMX7bkZGez9A7OyRrx?=
 =?us-ascii?Q?XcBWNBTlqC/+tGLviAN12SqE3vRiMBZXeovkVX0Bi7TQnuccY8kQK2MxuHvH?=
 =?us-ascii?Q?7EbXml3K/1JrWnqU1PFiA/g63Hg5WClko/V1VjrTk+Ov89kJD8YF7NELfvpW?=
 =?us-ascii?Q?sdF4FCl6vZDhvmrUK28T57L7?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?431i4FpcES0QofZc7VZxT+kNLChe7pIw3bEthWq07ljVz9Kmdm5PSb4S9nsv?=
 =?us-ascii?Q?80jEgcNkanqGOKrlTWdJnWZK2EBN087x19N7UmDVFbZQkN2XZ1kgdPMXHiPE?=
 =?us-ascii?Q?0FDGZg9wc8kYepUz7i3fihw+4lFO2zuq4zOtlVYTAE/KjNwj0aO0qtdHjpIo?=
 =?us-ascii?Q?zsFober4GUJ3t1nrEbFe10mLzBLckzHtafkn0EDoJ2vmw8z/Fox8n9nJBDdR?=
 =?us-ascii?Q?+QfNdb8y1ldhF22QeAtnZjQZl5VYPDXtyxuhRAAIM3PXMNv97pzQjcvUv+nL?=
 =?us-ascii?Q?ofcByOBGd7sYoFO5s0J6A96BSpB/W2G+hfknxFQI6KLLlUiSrXfE+jo0R78H?=
 =?us-ascii?Q?HQWUM1LmK74C9E7WIxDa2gEQUnwAI0pcMu5bbL0k4rmwNs4bi8CrkEmpMGmJ?=
 =?us-ascii?Q?XhunVWS+iG57AX5/Un0FYhkQyyuJw7aMXwpUq+FedyZMPfR0z0C43vhSLC/t?=
 =?us-ascii?Q?wW5wCZ7SIyJVs/1jz3lDUj37AZm9NUokfGxlcfPq7skz8P59n8/9kZpkedCc?=
 =?us-ascii?Q?fGVjUlubR2B8usRT9jltv6GZcH/RGbrg0bg/AEoMVpeXfIR1yj783DmbywbG?=
 =?us-ascii?Q?SgEJWBWIU0VYeMDuL8pX2TGWdVVRHUeRe+VxMKekUjRYt7dpDA7yLYM/YQ+L?=
 =?us-ascii?Q?GK2QqzJU5gGWfQMY/ELmLyp8fOE6vM1M+CtmsSIdcHp0nQ+Ar1LWX+dRW+V8?=
 =?us-ascii?Q?hJQz9yrU47OscXlecWv9lapNWGJRC+NFUGIkcpFLeJ0jtrpXvKC9QOC02GrJ?=
 =?us-ascii?Q?rhdXmkokFtdCKzZ2ibpsXcY2C5Z+bDXwIqU8OjFVZdbFsa/InfmTHb0iGaDt?=
 =?us-ascii?Q?F4eeFsr+gMAAHtZ/247ZZF6RZFl9G+879fESQ58A1kD7spPzhF1/pDYmLhiF?=
 =?us-ascii?Q?P5/qOUJlbz/Rmfwcu5Vp4/gEFQmzJe5f9q18yzfTfBiAnJf8H7bKQCPUl0An?=
 =?us-ascii?Q?c/5tVqXKALMDjS4ewVXUFro3Qegcftmx/S+FdsjLx/tkpUkGGJJsOanhoZRi?=
 =?us-ascii?Q?NP8G8MBDiuJ+KYxVY3BSMq9HtjoO1KirHlACiqIHrapOaIYrNZaInQbNsdbb?=
 =?us-ascii?Q?u2xfaHwWezZ3YrrJ6BiXLtTWBzVXuMIu3DD+s7hYxQSal9dpqLJml0S19iLu?=
 =?us-ascii?Q?+b2z4bxuii+BQ15PUHT9U8khPfZu9EmI0RUOe7iZft/WahjZaA4oXft17FRj?=
 =?us-ascii?Q?fdkrMiTJoO0HpuXK8KqjLGQtZUlTMO79QM5dSG0G8N1/ia0h8hBCu8TX5U6Z?=
 =?us-ascii?Q?NsCrmdZQkN58xijS/6frPrhChirUYRd1biq/JiMT6LOPaBI6mnSpCdRydTf0?=
 =?us-ascii?Q?6Eo1IONudEqqmDXNWikNRur9MnFFZtDQQAZAt2yGkFLfU9losEhD2FTDOo5T?=
 =?us-ascii?Q?ukPrr6CUugzhddxxlidDC2ScUYkDIr6LukuGp23IRYbxUQisFPlKGDPxnesc?=
 =?us-ascii?Q?aTneEYtY/dkAsR2CbU2kSSRt+ZutxKDzbXvHr0IVxax8z0XWXJ3by0R1hoV2?=
 =?us-ascii?Q?WGa1y218/oWWOKxwExvoOdSxSQmypv2S5f4oDlGjLr49MemWHjYOh7Z35TTy?=
 =?us-ascii?Q?wGeShaWRC7aP6YqmEyzdYbD9zsqxXHWnh/ZgsY03?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8428203-e19c-41d5-c725-08dcf3fc0c36
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 07:18:24.3701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTbr5Ij8b8kuZIsazcXoPZ/PkceOP7L3OvZ3UjeUPV7QKaeSGVf04Iahqi/g9lB73Pn7/+O+Ua2RgTwmCSFQkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7945
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 03f42b218554..bfdd10773136 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -8009,6 +8009,10 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
> 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
> 
>+	/* Don't allow CR4.FRED=1 before all of FRED KVM support is in place. */
>+	if (!guest_can_use(vcpu, X86_FEATURE_FRED))
>+		vcpu->arch.cr4_guest_rsvd_bits |= X86_CR4_FRED;

is this necessary? __kvm_is_valid_cr4() ensures that guests cannot set any bit
which isn't supported by the hardware.

To account for hardware/KVM caps, I think the following changes will work. This
will fix all other bits besides X86_CR4_FRED.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a93ac1b9be9..2bec3ba8e47d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1873,6 +1873,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
+extern u64 __read_mostly cr4_reserved_bits;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define kvm_x86_call(func) static_call(kvm_x86_##func)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..57d82fbcfd3f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -393,8 +393,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-	vcpu->arch.cr4_guest_rsvd_bits =
-	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+	vcpu->arch.cr4_guest_rsvd_bits = cr4_reserved_bits |
+					 __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
 						    vcpu->arch.cpuid_nent));
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34b52b49f5e6..08b42bbd2342 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -119,7 +119,7 @@ u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
+u64 __read_mostly cr4_reserved_bits;
 
 #define KVM_EXIT_HYPERCALL_VALID_MASK (1 << KVM_HC_MAP_GPA_RANGE)
 
@@ -1110,13 +1110,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-	if (cr4 & cr4_reserved_bits)
-		return false;
-
-	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
-		return false;
-
-	return true;
+	return !(cr4 & vcpu->arch.cr4_guest_rsvd_bits);
 }
 EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
 

>+
> 	vmx_setup_uret_msrs(vmx);
> 
> 	if (cpu_has_secondary_exec_ctrls())
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 992e73ee2ec5..0ed91512b757 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -561,6 +561,8 @@ enum kvm_msr_access {
> 		__reserved_bits |= X86_CR4_PCIDE;       \
> 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
> 		__reserved_bits |= X86_CR4_LAM_SUP;     \
>+	if (!__cpu_has(__c, X86_FEATURE_FRED))          \
>+		__reserved_bits |= X86_CR4_FRED;        \
> 	__reserved_bits;                                \
> })
> 
>-- 
>2.46.2
>
>

