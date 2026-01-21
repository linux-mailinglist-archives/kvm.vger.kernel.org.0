Return-Path: <kvm+bounces-68674-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mK8eF0I7cGmgXAAAu9opvQ
	(envelope-from <kvm+bounces-68674-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:34:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 274E74FD42
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 470224AD7D8
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 02:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D872C11D7;
	Wed, 21 Jan 2026 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QfdKQvbp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FCD217733;
	Wed, 21 Jan 2026 02:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768962844; cv=fail; b=Aza0ALN+5XQLbhLkyYrn2E+OQpUcQCpgtRl34AAzLwLga1O6JVeK1zstscjlKOVPRXVDRcrB041NVKXde16nMco9J1uJtoTrwIdhjZkc4kRvcCq3fwh3pMJ4Z4zX8XOE5Iv7Y47rSs0Ktu0+BfhGUN80JlzinNEmzAfGfPuT2wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768962844; c=relaxed/simple;
	bh=BkxhpJN9mwRvpwpAVkvTRGO1CqR7Z8wik6yQ8+clkaE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=a96lLHiGamLzWAI3Dq4bMV19xvogJOjZhtDYBCs0A/Ybi0RH+JH+pctsXk0Z8tC8W3YwHsBpugl90iyGBGk+7d0qiKp/1ApJzQH0iFDIOWRAA016jZZW4z4m0UXMkgU1qJSueNMKIv2BHKZ/IHuq3XIaFD6EquGhzxP6E8p8dvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QfdKQvbp; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768962842; x=1800498842;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=BkxhpJN9mwRvpwpAVkvTRGO1CqR7Z8wik6yQ8+clkaE=;
  b=QfdKQvbpti9brF/wwO3AjN9YJhY1YODEnCxLI9LHsmjh3rc/AgHwlFKm
   9s2ax0fn6VJhmh1lfrBYR4ld91FSTGey8kkMOgTdZ7Sblohf8d+xj2rhm
   P5lGC/u/kGMfe7y/WjwezToABmgdsajdPrOzyXjyTcmXeycpBOtoyZumD
   DAwrZ9hX5opaIy23c1Ao5oeTlrLzjizSucJiImy7JS5DL+HLXtMXdCgD8
   QUgIYZllbwotFeLauWdBet81X0Yh3ewGfONkiDxzg2MGbjofUwZpmczNJ
   rlbgWMfSONquEnafqObLdxiMEaQjziWTVTKGb9FmXI34bE6Tgfc6PsLp0
   g==;
X-CSE-ConnectionGUID: ERd/B4v1SlSp07DcgK2NQQ==
X-CSE-MsgGUID: PbEHN+BcTLmKHziuBslyGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70276581"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="70276581"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 18:34:01 -0800
X-CSE-ConnectionGUID: XigyYjw4RDWiegsiNr191g==
X-CSE-MsgGUID: YIIJGJSuRhWeVzgEgYPAPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206716385"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 18:34:01 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 18:34:00 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 18:34:00 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 18:33:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wS6hTJyAnXvXPm82V89n4ET59h1FqH84pK5mJnm3+V6JdvpHlL2MnNwp+bcWDbkXlff5L6H1zsvLpUjWHtFT7Jvy2d0SLZCAda1N3VvGHwGJmaWFd3JZyl93GzsY9m1ta/x8WfS4NnQa/u2ZXT5eWUdascfcZb7DQYazRIfXLMpsSaKcTWpGtZ/P3pQLZ+wGBDNTvsD2Qh365IP0Z2oGeGbPXWeCDr/IGhcyVSi1j6nh46R33BpHbxmCS7PhdIqz9zEI01l1yOTP723K8WkIG2sc4o0aGUWcKcRyq3SIv9COvZaxABku1VIn4rscOANycUGiRNKQV4nU21wE2dyc2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQaz6qf4wRteoHTxfA+B+OUAPNdLb9HXO9l/wHbJvck=;
 b=oK4aOOmLkOF5RAiEyMGZi21OlLbbx4WHgUvUSCucYmSGhcXCJp6/oVaSGG5T9wVx89qfTDkypFHfr3cYivPbSCsUPeIHM47pgbNGMhBvASnVgNyA1cLlux31x9u67joKDobb9jpaDc9NIoqEpvKxZCjHDG9xHZs4aCq0p0nLDhxwQWSUwkMFha+Rh1q+Uy+D8HCfln7EHhI66HGyLxGLbycKCHbKY2ZvLA2gd9eho85TnQZvBt26g8rar2KrZUylN+UxxOIPpKjwfIXWse4zOCuWTlBobAf6CsKfJ/QtLzhu03KrkshtGkuxIVgazen9HiYLpqVcVdJ6qO8EtG1bXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5240.namprd11.prod.outlook.com (2603:10b6:208:30a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 02:33:56 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 02:33:56 +0000
Date: Wed, 21 Jan 2026 10:33:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 20/22] KVM: nVMX: Validate FRED-related VMCS fields
Message-ID: <aXA7B9bbMNGBocTC@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-21-xin@zytor.com>
 <aRVJucn5t5WjS2fe@intel.com>
 <229A00D7-178E-47E4-B596-B467B2C66956@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <229A00D7-178E-47E4-B596-B467B2C66956@zytor.com>
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ddd5b07-318c-4463-8d77-08de58958651
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QUJjUEhENkR3aTB4aUdxemVFSHpSK3d5dzR5dFdBTm0rbEdNdFl0VDA5L2tF?=
 =?utf-8?B?V0ljNis0SWRnZlVDMTQ0OEx4QXUrblJsT3lqN01rc2dkNWFoMjg3L0NPMFJD?=
 =?utf-8?B?aEZQd3VHdU83WGZKK1pZdTV0U1BYUndqcFArR3NhZDBzM09NR0ZNUUF1TWtS?=
 =?utf-8?B?T0NrV2hUZm1RSCtJbEd6SHFaUDNEYjFxd3JzQitMY0ZSby9VdUdmQ0JOYnFC?=
 =?utf-8?B?TnFJWjJoa3N1VWVNeGo1YU9YdmRCV2xMbHUwV2sycFZPeTBoR0dPejhaQlVY?=
 =?utf-8?B?Sy9MSWR3c2RwZUxId3loYzVHNTFDRWFqS1h3dDVtNTdFQWsyVGM5aTdOc2N1?=
 =?utf-8?B?SHBYWjdwVUdScURNOVVrS2xONFBGV1Y5RkU2M2w4aUhUVDB2WkhFYzN3b1Ra?=
 =?utf-8?B?RWxEaXJUZm1KWUNYbi9qWnlJTEs2N044QTZqZXlWaHUzT1BTN3NJMEJ0RGZR?=
 =?utf-8?B?T1kzVHcwTFd6Wmh1Y0l2Zmo3djJjSXpHdlpmZjJlT0xvenJFazNyeEsxSC93?=
 =?utf-8?B?bDV1NmRUakVVTWx2Z2ovM2RvMVBGc2oxK1BsSWU5Z1I3MlBDOVozSWZ5dTVy?=
 =?utf-8?B?WEZZNi9EMmkzdTVJL0RMcmNJN3Y4NU1iVWlFaWZuK3dCQU04YzFPZys2NnhO?=
 =?utf-8?B?U1JWU2wyMUYwdXZiSEhqdFo2TnEwVFhtNzdkdFR1RUVIbHNKaU8wbGRoczZB?=
 =?utf-8?B?b3NkUFpyK0Z0SHdrbkVVMUtiVmVuUkdvaFZIL1BJeVZoTHZuVytCcktISTN0?=
 =?utf-8?B?TWNOWk5WS0hkRUdwdk9rTXBCMVFUOTEzTTlVV2dQL1VRWTdFak5aYUdlalBZ?=
 =?utf-8?B?N29DaHBoYjFqcXc3aml5YytkNEhsLytqVy9zSVB3MUlQOG1OeUx6d1g5aW9v?=
 =?utf-8?B?eldSZjB2enFLQk1wOHJVbm94QkdoOFgzbWMwT2tRdFlvbXZDMXFENXVYMHdI?=
 =?utf-8?B?UzNuMUljNUFpa2VaTDFSbTQ3Sm50SWFxMlladVJrWGIyR2VlTGNkRnJEQlNO?=
 =?utf-8?B?N3Q3NENWb0lwdEJUdjY0V3BMYk51RytZdmRsTE1nWWxwT3hBWThvOVJ1RFVU?=
 =?utf-8?B?anYxdFhpeGlMYkFZaEE2V0pCSEVLNWFNV1lzK2pmemtHN1NWa3loYWJQU2oz?=
 =?utf-8?B?QkIwUzRNeDFHUEExN041QUtiMllDcDh6TFFYSm04VnhuQU9DV05hMGxZRkIz?=
 =?utf-8?B?a21sdWg3RkdjZnRoczRIRDJtY0ZxNm5hVGwyR04vQVNXbjRZYlFJdWpGWkNq?=
 =?utf-8?B?K1l6YTZocGZyU0dRd09NYThKcjNzUkNRNldZTDY3TmpUby94NFBIM0QrUHd2?=
 =?utf-8?B?c0xyT3Rneko0UVdybzk5OEVkMEdwWjhzYUwwS051cWJZaFdrQzdEdWU5ZFJI?=
 =?utf-8?B?Q3JySHZFaFhLRCsxaEZMN0t6eFVPcGNBcHRNV3oySStPeExJaTU2UUUrS05U?=
 =?utf-8?B?MjByL2pjeXdaeDBBbDYyWVgrUFFibTRPWjhuMmFuMDNrRk5tWHVYVGZEUkdG?=
 =?utf-8?B?UVJGMEkrMllwanJoaFpRa3Q5c1lJMWFZdy82SEZ5RUUxQ25seGh1Y1NuTVZY?=
 =?utf-8?B?WUc3MWluNVliYVNLZUwzTDQ2WVowU3RTcEZ0bE00V1g5dUhLeG1KMElqODl6?=
 =?utf-8?B?czl3aEFFdnVyc3ZQbUIwdmJnRXM3M0F1Mmd2QWQvMUJyVWxvankvbnJJK0k5?=
 =?utf-8?B?WGlxUkZmR3N2UUFPMnViUG53K1lFeFczYmxNOHJKYVhpSHZ0WjJvQ25PWnNV?=
 =?utf-8?B?d090K2Y2dnJSZHhQb0dSUFFJVnA3MFVoYWRWWW9yVU1saXh2L2RQcGpIbHFI?=
 =?utf-8?B?QVZQdWNQY2IzKzZkWFJPQ2pNbmw3QWJBM25EWTdPdzlNWDF3YWNKZmRpZjJn?=
 =?utf-8?B?WGtic05LbWRmQVFZbi9BTE5sWlBIS2h3Nkllck9LUXRLWFplbTdEWUtUREt6?=
 =?utf-8?B?TEttbVdMa0FqUDlRSDNIb2h2aHJyMDZnS2FWN3hISWNHUkVWSUpyQi80UTB3?=
 =?utf-8?B?ZHNDQVJ3dE1aaFpvUDNnU3M5U2xobTdScU9NTjBleVgzYzVIMTlOQllGNERw?=
 =?utf-8?B?TGJmZFh5YWdiV056bkJybzN2V1dVVmJSUndXRlZvcHg1c2I4R29xTzl5cjJx?=
 =?utf-8?Q?e+WY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWhhQmJ2d0hmS0JqM09aNmlhUGsrK1oxa0NZQ283UzFGMG5pSmJLVUJIZVJT?=
 =?utf-8?B?SkFKSkczUHRQbXJSc1hqM1EzeFArcW1YekhKKzZ5RGVjTk5wREtHT3dqWHkx?=
 =?utf-8?B?cE1yWWkyUUM2dGxNR1YySUJNS0tHT2NzRitsT0FxOTFsQXdPYk8yM29nc2xO?=
 =?utf-8?B?WFovRWpkTFF1OTdod0JzTTkrUmdjUk5rMGE0ZFFWdUVxdmZpcnU4RUE3S3Bh?=
 =?utf-8?B?WVRvZlNjd01oZThKZVAvd0FUcDJ4L2lwQ2xQYUpHaW0vczROZHVGQXl3aURi?=
 =?utf-8?B?TUlJNE90b1FUSVVIRU4reTR6U0dGYzg1TWgyQWE2U1gwZXFudFNhcExta1or?=
 =?utf-8?B?b1c5NjdvTzZ1NHV2Qk0wWEU2eUtsc0p3VGsrWlF4SUdIa3lGVTFSaWY5d3RC?=
 =?utf-8?B?MmNvUGsxT1pscThlaWphV09uVEQ5QXNobHNDU3EyU1hlb0RzRG5oaVFaMDgx?=
 =?utf-8?B?djJ0RXNNQWtoWnpYa0RYVmd4aUJSRmlwM1hUZ0FQUkZzRjZaWVNYNmJGemda?=
 =?utf-8?B?eGZMZ05YRDg4RWIxbzJzbWZQcmZXT21Tbjd2Zi9BTEpuNEpRWUgrcEt0R016?=
 =?utf-8?B?Q2d6YlB0Q0JqVGowcHkxWGN4RkJzNis5Vld1Vi9kTkpWWm4wSkNHTkE0emUr?=
 =?utf-8?B?UzdJbmU4ZTdoY1U0WVJuUTNmdXYybEdRRHZGYnRzQ203T1BVcHdSc0FrR000?=
 =?utf-8?B?S0k1TlE4NUtqSHVPZXd4WCt2cFhKL2tEbTBRRWxIOERqRmFaMHUyRC9DWENY?=
 =?utf-8?B?L2F2eHcvNVpzejc3a1FST0F0NUZwS2VHSzVVNmN6eXQ1SitaVnJ5ZUpja29u?=
 =?utf-8?B?NDlPUmlaV1I0cWFqYXQxV05oRWdoSzRQYWxaMmw1aFNrb2JtNjNqOGk2d29x?=
 =?utf-8?B?ZEg2MmlMVHI0TmE3RVc4b1pVR0EwSGZHbzJjMWdNNFlxeExzeDBOU2JrbUZH?=
 =?utf-8?B?WE1jcmJZVjlxK0NOa2ZiaEd1V1lnUFBIRHdiWnBCNjlsQWVjSGxjdGFMVVAx?=
 =?utf-8?B?NWFVU3dzcFVMSWQzUkNVbkRVc1NBQ1hzd01aRGRxT1loWWNmR1FDcXlhSFN1?=
 =?utf-8?B?RVk1RzlVanV2ZHdGRG5ZOXJmMW4yNVlxV0VYSjhqVUlieHNiZUpWVkhtYzdy?=
 =?utf-8?B?K2FvbnhvSW9NQm9NSFJMWkd6YThSclFlb2g5bzQ3Y1JhS2ZUZVc4ZElNMHc5?=
 =?utf-8?B?K0lOb3kwUk8wNGtqV2JPY3F3aFJyQWZUUGFYUk9kRHBtSzgvczdzR3U3WmRv?=
 =?utf-8?B?Z1NIdVZqVWdEVTBHNFpuZ2NhSzBOaFRkdnozS2l5MUUrUk9ERm16cEN0UDVW?=
 =?utf-8?B?N3l6a0xaMitYMDlSKzY2bUpMV3FoNHh1OTFSaVhyYTE1NjN0dWRoM2NSc2sy?=
 =?utf-8?B?cXliMm5obEhPeUFaejVBNU5DUEVMZksvbDNoWmlqL1VkdC9MRFU3WUluZEVk?=
 =?utf-8?B?SGxVZDVVUFYrd3o2RVc1QVFpdGJ0M25IaUJpdlhBcWJKSGRSam5SMXZTZGJH?=
 =?utf-8?B?d0RnWHpHdFhLekw3dGwzaDdMdWw0YjRMejd2WUhWMGRFYnBmaW9Ubno1L2Zm?=
 =?utf-8?B?dFBiL0hBRExQL2l2ZFJjK2FveUtBOXVRekE2cFI3eXlKS0pQbmdhUXVEVHF5?=
 =?utf-8?B?THJyRm1VY0MwdU0wUHN4REFKN2lmU0hsVXdCY1RCZ3JQaHJreDA0T2JldXZL?=
 =?utf-8?B?SUZVWWRyQStiaHNISFhsbFNVV05MWU1WSTFtNDdVTkQwL2xPQlRWSWVUMzdX?=
 =?utf-8?B?YkhCMkVwaGJHRXJEWWN3T00zQStMZjJBN2ZsTzkrNFpoekdzeHB4NTBjYUZ1?=
 =?utf-8?B?b1BBSmVDaUZWeWh1cTBnNTM2aGRWMHFNRUoxR055UitUdytPbWEzWElRNXhs?=
 =?utf-8?B?RC8ySVY3T0J3OXlGSXlhamZyUUxlNWp0T0FHSjVUSVB2ajdQZlRYYjRzZDkx?=
 =?utf-8?B?SjY2Qmtrai9yK3JiaFRSWG1CeCt2SkVxKzhJUXBRNXNyR1hwQkhmV1QwUkl2?=
 =?utf-8?B?dHUwZzNVSmVqMUorWWxsM2FRTm5QbWtjdHFFN1E4Z056ZVZRcWwvRzdvVDVX?=
 =?utf-8?B?dzBZOUJ5OGltczY2ZWlyb2J1UDBQTzFsM1RkQVcrd2p2VktpSEFaSHJHUmFH?=
 =?utf-8?B?MGtSYU9KNW1aZ01pTWU4Q0xxVGJUQ0gzeW9ETXgzdmZScmJPdnJTRDhBR1Qy?=
 =?utf-8?B?QTJ6TzVVcGNING9iOFZTUklOVHNUQXlkMmI4eGVWRmdZV1JuUkdtWnVnK3V6?=
 =?utf-8?B?UnkrbkpyN1ZQaHhZbEQrYStCOE1Ud3RoWTNqZWpTQjJTa2hOY05nQldiYVJv?=
 =?utf-8?B?YXhOWU9oMzRrWVVidG4xOWhhRkdvVkRUTW9Obkl5TG51a1FYa3l4UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddd5b07-318c-4463-8d77-08de58958651
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 02:33:56.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5HhdHUMRjUNJNXHSTZhLxlaAOmw2Rp4GN08tDy+PBMunQpdQ3cTjn1eME8sj7lygJtL9119OiL7E5SqL6gCExw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5240
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68674-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 274E74FD42
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 01:19:55AM -0800, Xin Li wrote:
>>> @@ -3047,22 +3049,11 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>>> u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
>>> u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
>>> bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
>>> + bool has_nested_exception = vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION;
>> 
>> has_error_code reflects whether the to-be-injected event has an error code.
>> Using has_nested_exception for CPU capabilities here is a bit confusing.
>
>Looks better to just remove has_error_code.
>
>> 
>>> bool urg = nested_cpu_has2(vmcs12,
>>>    SECONDARY_EXEC_UNRESTRICTED_GUEST);
>>> bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
>>> 
>>> - /* VM-entry interruption-info field: interruption type */
>>> - if (CC(intr_type == INTR_TYPE_RESERVED) ||
>>> -     CC(intr_type == INTR_TYPE_OTHER_EVENT &&
>>> -        !nested_cpu_supports_monitor_trap_flag(vcpu)))
>>> - return -EINVAL;
>>> -
>>> - /* VM-entry interruption-info field: vector */
>>> - if (CC(intr_type == INTR_TYPE_NMI_INTR && vector != NMI_VECTOR) ||
>>> -     CC(intr_type == INTR_TYPE_HARD_EXCEPTION && vector > 31) ||
>>> -     CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
>>> - return -EINVAL;
>>> -
>>> /*
>>>  * Cannot deliver error code in real mode or if the interrupt
>>>  * type is not hardware exception. For other cases, do the
>>> @@ -3086,8 +3077,28 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>>> if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
>>> return -EINVAL;
>>> 
>>> - /* VM-entry instruction length */
>>> + /*
>>> +  * When the CPU enumerates VMX nested-exception support, bit 13
>>> +  * (set to indicate a nested exception) of the intr info field
>>> +  * may have value 1.  Otherwise bit 13 is reserved.
>>> +  */
>>> + if (CC(!(has_nested_exception && intr_type == INTR_TYPE_HARD_EXCEPTION) &&
>>> +        intr_info & INTR_INFO_NESTED_EXCEPTION_MASK))
>>> + return -EINVAL;
>>> +
>>> switch (intr_type) {
>>> + case INTR_TYPE_EXT_INTR:
>>> + break;
>> 
>> This can be dropped, as the "default" case will handle it.
>
>We don’t have a default case, as all 8 cases are listed (INTR_INFO_INTR_TYPE_MASK is 0x700).
>
>> 
>>> + case INTR_TYPE_RESERVED:
>>> + return -EINVAL;
>> 
>> I think we need to add a CC() statement to make it easier to correlate a
>> VM-entry failure with a specific consistency check.
>
>What do you want me to put in CC()?
>
>CC(intr_type == INTR_TYPE_RESERVED)?

how about this incremental change?

I prefer to make has_error_code and has_nested_exception consistent, and add a
CC() statement before all "return -EINVAL" statements for debugging.

t a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8682709d8759..f13df70405d9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3049,7 +3049,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
		u8 vector = intr_info & INTR_INFO_VECTOR_MASK;
		u32 intr_type = intr_info & INTR_INFO_INTR_TYPE_MASK;
		bool has_error_code = intr_info & INTR_INFO_DELIVER_CODE_MASK;
-		bool has_nested_exception = vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION;
+		bool has_nested_exception = intr_info & INTR_INFO_NESTED_EXCEPTION_MASK;
		bool urg = nested_cpu_has2(vmcs12,
					   SECONDARY_EXEC_UNRESTRICTED_GUEST);
		bool prot_mode = !urg || vmcs12->guest_cr0 & X86_CR0_PE;
@@ -3077,20 +3077,10 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
		if (CC(intr_info & INTR_INFO_RESVD_BITS_MASK))
			return -EINVAL;
 
-		/*
-		 * When the CPU enumerates VMX nested-exception support, bit 13
-		 * (set to indicate a nested exception) of the intr info field
-		 * may have value 1.  Otherwise bit 13 is reserved.
-		 */
-		if (CC(!(has_nested_exception && intr_type == INTR_TYPE_HARD_EXCEPTION) &&
-		       intr_info & INTR_INFO_NESTED_EXCEPTION_MASK))
+		if (CC(intr_type == INTR_TYPE_RESERVED))
			return -EINVAL;
 
		switch (intr_type) {
-		case INTR_TYPE_EXT_INTR:
-			break;
-		case INTR_TYPE_RESERVED:
-			return -EINVAL;
		case INTR_TYPE_NMI_INTR:
			if (CC(vector != NMI_VECTOR))
				return -EINVAL;
@@ -3098,6 +3088,13 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
		case INTR_TYPE_HARD_EXCEPTION:
			if (CC(vector > 31))
				return -EINVAL;
+			/*
+			 * When the CPU enumerates VMX nested-exception support, bit 13
+			 * (set to indicate a nested exception) of the intr info field
+			 * may have value 1.  Otherwise bit 13 is reserved.
+			 */
+			if (CC(has_nested_exception && !(vmx->nested.msrs.basic & VMX_BASIC_NESTED_EXCEPTION)))
+				return -EINVAL;
			break;
		case INTR_TYPE_SOFT_EXCEPTION:
		case INTR_TYPE_SOFT_INTR:
@@ -3108,6 +3105,9 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
				return -EINVAL;
			break;
		case INTR_TYPE_OTHER_EVENT:
+			if (CC(vector > 3))
+				return -EINVAL;
+
			switch (vector) {
			case 0:
				if (CC(!nested_cpu_supports_monitor_trap_flag(vcpu)))
@@ -3121,7 +3121,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
					return -EINVAL;
				break;
			default:
-				return -EINVAL;
+				break;
			}
			break;
		}
@@ -3454,14 +3454,15 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
		}
		if (vmcs12->guest_cr4 & X86_CR4_FRED) {
			unsigned int ss_dpl = VMX_AR_DPL(vmcs12->guest_ss_ar_bytes);
+
+			if (CC(ss_dpl == 1 || ss_dpl == 2))
+				return -EINVAL;
+
			switch (ss_dpl) {
			case 0:
				if (CC(!(vmcs12->guest_cs_ar_bytes & VMX_AR_L_MASK)))
					return -EINVAL;
				break;
-			case 1:
-			case 2:
-				return -EINVAL;
			case 3:
				if (CC(vmcs12->guest_rflags & X86_EFLAGS_IOPL))
					return -EINVAL;

