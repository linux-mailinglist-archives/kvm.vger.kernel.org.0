Return-Path: <kvm+bounces-35282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48EE4A0B4A1
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD9497A1B1A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D0322AE63;
	Mon, 13 Jan 2025 10:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AKQD+cU5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA681B412C;
	Mon, 13 Jan 2025 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736764318; cv=fail; b=YXl7uc4FNqSPsXXAtSQA4mvI6NOk/4s4wVpSFEWAn7NbHmlLDGyDaegoqpaR9T/FR5bTDd6vx6nrkjrz3Qy7ZLqYlW1BqzhwlqzQi+f8A0EHogfcGshDMbqNWh/I6mjtuyLtox2t+hNQUTk91zUX7oCN3j/laOgIjCf4G3KEP1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736764318; c=relaxed/simple;
	bh=ClsY9NHl0rraw4TeGMuLBCSgLLGBBaolpjJs/a7zmmw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q8C9CR8HW7odkh79eQ/IDMSBGLLO+2aTfZvTDOqYzKl0BsiGDtnc/sea2V8TErOwYp6qSiPJ64phdYKhca8E1MOZnEMU5uPpIgK6FKRzDbwrySPAuB70pcymWnSUo3hE1Df3goXZHP8MaY30g2OQwopGpeXERP5shSNIcmDv6zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AKQD+cU5; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736764316; x=1768300316;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ClsY9NHl0rraw4TeGMuLBCSgLLGBBaolpjJs/a7zmmw=;
  b=AKQD+cU5I9FYYRlc7zliv5btkYTjtNyfftZ6Jisl4mlEtyiVK0dLHegL
   BqsB6pRGaMpdLa0pu77gXjJN8Tmv7RYsPf/lt5Jl+C59CgXEW7rfxstgm
   eOjUV9ru4mxCHYtaYwpx0MoaVVfMFokTAccUsjAt5o9rhT44Lb5qxqtLB
   O8Nj52OB69PVuRXHPvx2GSdmOV75xcxiaNR1oRdi3UudyBQGUC2dsRLTa
   e1S0j+pT0H3XxAOalMBgS9Wazq4qJhXbZ23xqKrGqMkbdF+k2G7exY0ot
   T8u/aD66Mw4d/JZGuwh0CTNiIbGAwsqpTb54D8SpBxz29JKfn/N88W6Hw
   A==;
X-CSE-ConnectionGUID: dkChRpP8TZmmwYUdtgYOQw==
X-CSE-MsgGUID: 1sPUp54xQ/Cre7q6FDmttw==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36900788"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36900788"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 02:31:54 -0800
X-CSE-ConnectionGUID: VKomAHrRT3qm7qL9QFU50w==
X-CSE-MsgGUID: ivtjDn0ARU69lp1BR5FG7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104248302"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 02:31:50 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 02:31:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 02:31:49 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 02:31:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTl5CMeqYourcnzZHbBBYHPC4Niwr8CV/GuJVNtQq9Cc82P/pRq5HgX3+FS/R0u1dUtGxsNtCSjbeKggs/jWwb+SEBtmXTGscj6rzQVUILNxRb0h6RRt2dAFtwZTEkRpQT3arLqv4AsTmw0iECwOixVGqASofgaHi1FGhJk07rSmnv2GVI2mmZ6Y8Zj6yciION9lihMuRNdB2v4cGIquFjk+mOaGYtp3hVNLLGDDGGfrku5YEOGxANEJMTx7ZFGmnUb8ldo043X8Wh3WuAlqdepji0rpgN9879CSKc3Ukp121nwbnKD9kAkBI/XBTrnca8qPSvvHj6WSBrO7NxY4bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAckwmSRxwL4IuNIDI4aN66WP/5K3zsraklwQ90HUDg=;
 b=r30BaCgU1kKMNPkCvDOCV+9TWyB4T7dg4YOron9Okq74keaIErGnuYralslQQnYawiip4jfCKN1q3/S7cSWA20oxWf/BUvG2F/I+04KomArBh9kJcEozFdORFBtMgWWmFO0RBFQOZmZSwBVc4lzt59Q6GbgX2I4s64wBi0eJOPYYGB/yyhj/NmOK26KMbZlVym7H8uFEhC0+IwWpBFGA6QI3kgngKepV+ujAMtuq4gdlGm3tIollr1Klv5GwXgo7VVs6taT4i9rZG4ZnjlKQ5Kta0SeODdBLbv1lLaPbq/Ubs2KwR27/vWkmpAcFYqELSCmbYZSuLJOjKFsJ1RDbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7960.namprd11.prod.outlook.com (2603:10b6:8:fe::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.17; Mon, 13 Jan 2025 10:31:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 10:31:19 +0000
Date: Mon, 13 Jan 2025 18:30:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
Message-ID: <Z4TrQedpUgNrW2OB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250111010409.1252942-5-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ddf585f-73e7-4dff-e1f0-08dd33bd6ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3Dd4YAq/a3nLsbGXCGZAGDAgy5HJZsZYTIiRa/59BPB2GA5X1qVjWSY7OFr0?=
 =?us-ascii?Q?K2nowm/DfR1UyUfFfLYPQZA61c+9Jxr3rYoTHhscWBY+LZlYHbGoOaHXN4Pb?=
 =?us-ascii?Q?63QrhCMgQUDr0pQBTecnnfTH7A3JYMSaD4Yj0H7CxKDVcVWBHQkVDtyVWQ6n?=
 =?us-ascii?Q?Zbuxwm6CU+ZPrke/ET0WOq1R6xyPXs+f5LbSW/aeiGU1c6Zefvb0pESTRhgN?=
 =?us-ascii?Q?3s9m7OnkN77TaSJsKDyX04T/eOWB6AnXyM3SFxoIIkHS4FwVYfmHfE+lHX4j?=
 =?us-ascii?Q?AJ7TPAOgG7YxGmDRcS69muqAkE8TgPbBlkm4BGsRDP5RwqWJcCr+PQukXUgw?=
 =?us-ascii?Q?InUfhiKrYDl7eQNpBrPW2V3+Q7l5BRCcoCLIfhAcDsHQraozTGZjHjikwbGc?=
 =?us-ascii?Q?jr6FnCWYzV5yqHn3aY3tdDsQynnC8/7i0HGFEoH0KOLCg1vONAL1JDVLOKI+?=
 =?us-ascii?Q?6Z3qEb1UlJBXdKbL/M0Nv33GoWLOAzi+3pEtqURDpmS7n+kGw2Lvq/GUGXWa?=
 =?us-ascii?Q?lMwKo7iFYKRoxBDCUpE81RxKomFetO6LRNTxwajkT8zvb4zlKkF7KR8HLOz0?=
 =?us-ascii?Q?bOYvSJYTmIjBKaLoZ6t/eI9oje78yNSsWmyTlRPmIovvd6d+BoshNC5vQd1D?=
 =?us-ascii?Q?bhUi+49Q1IlkfzzIoMJFACk0FajsciEnxCTKc8G1bUjoZ55ERnURH8zLfiN0?=
 =?us-ascii?Q?6fPhkzxSivU8+QR2gR1fbC2yZp8o79+SMAYnzr31OZ/7ypeIJZIxaQmfHh/e?=
 =?us-ascii?Q?2KEQO+BPXh9GaSRu4hB2OhdKmBwxtHW/1uTSNGwWxEi9oqF+hi3phXMJ7Pj9?=
 =?us-ascii?Q?dtVLeoqQmpTdj+a+ir2TlUAo9rJotr/PSUwAK3HH+3Dr+T4CEMV5iSCk6ARH?=
 =?us-ascii?Q?9ql5nhbqRr4SoV1dnCUJC96HjW9FViZvykH6SlY7OhDtz1nvMOwidGMxvuDO?=
 =?us-ascii?Q?FPQcU97omF5cJroyMo1K70sFrKEFCzRZYj4DbgKfYEnyBRswY6Tt/TJBfUR6?=
 =?us-ascii?Q?52fJsnpT+gVbPs2wS8PGE8ZRkNGHDUR56cO10o3C3bxKJ1sR8otn+YYtCCP1?=
 =?us-ascii?Q?2knmE3F9G9xUz8GyQhb5PMMxoYIWpcA4pprUtvmMKTxK7K4262ZlTjRFXRQY?=
 =?us-ascii?Q?wjPPTIlEkwrsO8lMgw24yQY3dwo18WClAnfLpoPZS+8S0x/yriT1vN7ecE3Y?=
 =?us-ascii?Q?jfHtvIOP0f2/x+9PXChMXsDVmRaRiehEsI88BxQF8L5K1gQJGJCbPXSUn63r?=
 =?us-ascii?Q?mkMttXIH0ViJtrHrr/Js7bRg7KnAhC3hMYgl+fWRAZwoBWDFQ7E+kcn9Gofg?=
 =?us-ascii?Q?vFF9MpKcRvjWsc7y5qakm+gKyqEcpp+iT+9MM+mgdQWtRGkOMs9irWnMYjmk?=
 =?us-ascii?Q?ouU7rzEhBCBJhnzHlrl08s8q1yAs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96qKvT7s76dyWwXrhELwOTpm+1r5bgiADzHxfDyYzaHoeYZryAZul77MXihO?=
 =?us-ascii?Q?WWfBBTviQP4moPBjAD/nQovJYW6W/h10sTlD98TvwCBtj77Sqwux5yXvtDln?=
 =?us-ascii?Q?WDNS8IIi4iK+eF1P4vlTnoWY9JK8KmZWEEu+Q3GzZzm+oQJ1rQXJXfwexma/?=
 =?us-ascii?Q?ql2PAeGfZYTAyUdyqWkOZheffOfl4P/mFO5xjiHYOzmWe1Uw3ey4T1Pk1aBr?=
 =?us-ascii?Q?Fp0h0nM7Cq4AbypdbAvsjMrzu0uXliZTVVmi93F4i2NTV6yDkmpmUiLU1vyq?=
 =?us-ascii?Q?07+weXN49YDQizY1v7YB0DeFguQJ1Aux0govHGduA+AzhzCHCRZP9GuoeOQJ?=
 =?us-ascii?Q?qTWllghVas8ORXHeqiaLq3l42KrL5A/D7p/AAisdNx5k3mQzT7SolXZRCsRY?=
 =?us-ascii?Q?ghmf8D6ox2yeW+Wq914aJ7LjeRSvlsphBswvJvr2G6GoPiHF4hZCCMKgyB6h?=
 =?us-ascii?Q?iRdsYKZWv6e1lZODo8LCevRaYIvQgJ6MfVHaQJ+SmsBaWlgjwL4jrL29b+Dc?=
 =?us-ascii?Q?PPaFJN8BevBdTdjKvAR2bzQRDaL1kSOcG+Nqemq0CCYA9j1k7JoQWc4FydEQ?=
 =?us-ascii?Q?hdrUBvC+BdqyqmnHfZaf1xHloEGL+JLCN2VhQV0WvKHdZbHMDLhhVvLfzTto?=
 =?us-ascii?Q?NqnSdAQWp0mBd16S764u/TDpMhoeKiRZgLneWPdm0BXSHDOABwqQKBJPwiCS?=
 =?us-ascii?Q?zE24dsk8WlCbHNbotZkKT+ypaqRkramWp2uTQYW8t/kyBDeqEKfXjlrr323Q?=
 =?us-ascii?Q?2fS8Z7bQ084ATgBt8VfBGOncAayHWwWIg1g7tRSMjo0K7jG4DGFsZiWDd83I?=
 =?us-ascii?Q?SGoWsXjozLTB/fvUC+fbJT1CvMoQ1FrMsadGmNVrg7ObM7TUK9NpSxefTVfi?=
 =?us-ascii?Q?McVY8VCYLP/OoOpvfrL0LaOyaqqUX/773L2sfz4SD8f4VHKrWJwLJtF3KS9D?=
 =?us-ascii?Q?Q3UfKS4ne8rJH2JMO4RIQSYE7LKl4FGvlno8+m/UWJOJlIotN0p/C7t9P152?=
 =?us-ascii?Q?Tgu3fkQjdO5uyWxWwEuJSlJLqU4Uixh0LhN2Z0tBXXyIV1QkK8OYv3ex18h6?=
 =?us-ascii?Q?qrwoNceWxdr6WCREh27R+G+Rr9a8KQu6gCnUTldeJfFfJFocaU6t3IrtaA+t?=
 =?us-ascii?Q?J90VQpGmCE8xO2Gb2LAJkRTzSUdYhmLmy6pqXYIAiSRFety1GU+nWz8otq8i?=
 =?us-ascii?Q?bq0sIAr8PIr/er4KR1vTWcm0hj+aghIvRdhI0j/n6hx3Ft4XInz1lTGOod1Z?=
 =?us-ascii?Q?mPWbMnK7RO+TrPeWDjNDQNCPls9mRYazKXSiZ4rWa9Xx9tfEVjpmZtdytUpS?=
 =?us-ascii?Q?QBfK77o1u1UWFBTjfzeSqtxkWTnkPH/5doqKsdvsD3NBIHgHXilKTPTAn4F2?=
 =?us-ascii?Q?eVA2923UxJe4rtdhhLbwe3SdhV7HmM5cjN7dP9zo8J93qmKSpysWwSxx0X2S?=
 =?us-ascii?Q?V00CeHUEehkL/fBMAWJS3Qy6Clm/HzLgDN/+mTFnq1BUICaGVfCFOi5Wu+nM?=
 =?us-ascii?Q?1STu3Lkbx1a2Q3DYBUtrGRjLH0q+bv+tpMLcebrUFOQDL5qOIQhpaR9N8/TA?=
 =?us-ascii?Q?aDdZmhD1fRiRKJhCWRrfeg4yRmJaNW3MyRw36HME?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddf585f-73e7-4dff-e1f0-08dd33bd6ad2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 10:31:19.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwvlGgPlZBsJCo8izlSsQ2faI3BNNmZkov+fYWZnoxvX16EiSxkBDHevXRyW7b677raFhvpyOKER8dwTBk0OdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7960
X-OriginatorOrg: intel.com

On Fri, Jan 10, 2025 at 05:04:08PM -0800, Sean Christopherson wrote:
> When resetting a dirty ring, explicitly check that there is work to be
> done before calling kvm_reset_dirty_gfn(), e.g. if no harvested entries
> are found and/or on the loop's first iteration, and delete the extremely
> misleading comment "This is only needed to make compilers happy".  KVM
> absolutely relies on mask to be zero-initialized, i.e. the comment is an
> outright lie.  Furthermore, the compiler is right to complain that KVM is
> calling a function with uninitialized data, as there are no guarantees
> the implementation details of kvm_reset_dirty_gfn() will be visible to
> kvm_dirty_ring_reset().
> 
> While the flaw could be fixed by simply deleting (or rewording) the
> comment, and duplicating the check is unfortunate, checking mask in the
> caller will allow for additional cleanups.
> 
> Opportunisticaly drop the zero-initialization of cur_slot and cur_offset.
> If a bug were introduced where either the slot or offset was consumed
> before mask is set to a non-zero value, then it is highly desirable for
> the compiler (or some other sanitizer) to yell.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/dirty_ring.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 37eb2b7142bd..95ab0e3cf9da 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -55,9 +55,6 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>  	struct kvm_memory_slot *memslot;
>  	int as_id, id;
>  
> -	if (!mask)
> -		return;
> -
>  	as_id = slot >> 16;
>  	id = (u16)slot;
>  
> @@ -109,13 +106,10 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  {
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
> @@ -163,14 +157,31 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>  				continue;
>  			}
>  		}
> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * Reset the slot for all the harvested entries that have been
> +		 * gathered, but not yet fully processed.
> +		 */
I really like the logs as it took me quite a while figuring out how this part of
the code works :)

Does "processed" mean the entries have been reset, and "gathered" means they've
been read from the ring?

I'm not sure, but do you like this version? e.g.
"Combined reset of the harvested entries that can be identified by curr_slot
plus cur_offset+mask" ?


> +		if (mask)
> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * The current slot was reset or this is the first harvested
> +		 * entry, (re)initialize the metadata.
> +		 */
What about
"Save the current slot and cur_offset (with mask initialized to 1) to check if
any future entries can be found for a combined reset." ?

>  		cur_slot = next_slot;
>  		cur_offset = next_offset;
>  		mask = 1;
>  		first_round = false;
>  	}
>  
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	/*
> +	 * Perform a final reset if there are harvested entries that haven't
> +	 * been processed. The loop only performs a reset when an entry can't
> +	 * be coalesced, i.e. always leaves at least one entry pending.
The loop only performs a reset when an entry can be coalesced?

> +	 */
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>  
>  	/*
>  	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

