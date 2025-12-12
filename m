Return-Path: <kvm+bounces-65808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F5CCB7C35
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 04:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8BA47305E20D
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 03:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C8E2FFFA9;
	Fri, 12 Dec 2025 03:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EpLoXxm9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4581E2F068E;
	Fri, 12 Dec 2025 03:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765509928; cv=fail; b=Y2vClSmzGN6+RmqHdbSlHjV6RVFBOz13i3WJvn4+dtqsfJLvJhqXolRiBbWLLXigOZgPqFo92a9xxfSu6sPCitzyx10zq5vpz9ObgVK3HeSkmISVMrvagxqvrWKxTMb5qQHz+B3zTOM9Nmy0cfsjDYS7FHsZCGuWlJyN82nSPiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765509928; c=relaxed/simple;
	bh=9/nmhVzZL+9eYG4MxwqXErymBJXrwBEUKP5qnVaOT/8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QQkl2b4F309BYhMTWryqWXh6vrM78LW6W9NJzOFR/HMzam5B/PS03z3Nzv3J0BXA1+WOYq7Uev1NZaviGQ9slHnrqWjvpEGYPoNJu3tLh0tcXvAua/W0uWVK+2xPFcGxwPhRuYDM5olJtzWi4lYmt5o6Rm0cVaZ5NSdCnFmrMnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EpLoXxm9; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765509920; x=1797045920;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9/nmhVzZL+9eYG4MxwqXErymBJXrwBEUKP5qnVaOT/8=;
  b=EpLoXxm9KLlPBgMmM3ULpZaJW+QTgepMFp6ERMQHdBzC5UqdV+XqYArW
   FqI2plHukulPTMt/icCX8dCYWwxipa4tfTEwerIUrbMg7O3RZul20WZmC
   qQAEs3R/8AzQK3qzJoxwKm1L/d+do9mp3lg5Fs8qU70MmqNJPG5X1RD/x
   eHFghl9r4nQnAED+4YBeX1rwYU2RLQPKX+VDmJkFzKgbItHlvzsl7SU7i
   TQiPge5Bo3bMwDeNg8esjoy6Ir2ktQUzqVHYkpHx8WBPYqMqS+RCkCF0R
   NC80e2lIImdjvIQ6iGMP19ZqtaY2F62m8sunNbQcz2Db9rpSwMbXgcs/2
   A==;
X-CSE-ConnectionGUID: itBRS4fzRqS1KBznFTW/FA==
X-CSE-MsgGUID: CNcdOBw1T+aFUB63m2Nc8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="84909532"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="84909532"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 19:25:11 -0800
X-CSE-ConnectionGUID: 4Js8+F6LQYeHSLl+g2sQEA==
X-CSE-MsgGUID: 7Kqf5epzQla12IeoQDbChw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="234361823"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 19:25:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 19:25:11 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 19:25:11 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 19:25:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JA69stnuq+DAOGyGxRd/rou2moPQPnnUGG2Q3nkfPD0CjRxAXFIIsO2OZn5OnQvQNPhnwxYE5VkU0XjXn5oauPDTwxXFfmQ9ClPhaxXlAWlT8gilbkkGUcrqPnhcUzLwnB8yjPGtQZT8WrcmRlWCJTh41k9BZeu1Aojtlf+uwuo6/Ou+D4p3L+uQ06nMrfdGK+FmHh16sH+dj6y76S4rI1Z4REvJQrpmYCAlRluoa1N9QXcfJwcZbv6+8Gbd5rI8cBSa9Ik3hg4WqreWmpdKajaVCgWlerGaEWeBr+KI+FD7Qb5WVAQyM1bKpo893Uf7dVmykjubn6qn1fcD0lJsdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adfSHTuamkMsI9/tr7I4Ez6CJcge2DQiqtw/3M8QFlA=;
 b=cDsOuu+fjixCCRw75anO6Q3gaIQhtNw1nn6yT8B3xNr/REsqejECBLxAcYDOgO7SlBp7DnYp8LPxyd6auFtc5wzq5QVh6E4PCHFv0LgJKmVqURLHphtXsZ6NLbQA4WOBrsh/E+mkVd3aOKoPuD1CbjdFr5ouki3WMg2uSRQ38Z3OdwXEc6Be0xnrYMQQNSKC4a0DwMSZAKnEQ/ctfd1sDS6w+lzgo2fXK2oTk3eJEIVRIlW0Haf6lWeL+3eTvQ2Gx58Y7+d+J24N76zYi6lK2ktfZ56SGHlW63aXJUJzk6b90sk8guBJvvD/jyPG6Q1Gz3nACkZfSUnAJ0TIuihz0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB7711.namprd11.prod.outlook.com (2603:10b6:510:291::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 03:25:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 03:25:09 +0000
Date: Fri, 12 Dec 2025 11:24:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH v3 03/10] KVM: selftests: Add a test to verify APICv
 updates (while L2 is active)
Message-ID: <aTuLC/gNucl9o+Y+@intel.com>
References: <20251205231913.441872-1-seanjc@google.com>
 <20251205231913.441872-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251205231913.441872-4-seanjc@google.com>
X-ClientProxiedBy: KU3P306CA0004.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 33784adf-0bfd-441f-679b-08de392e0d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3bcDYM8zGAW1I3uRk8HlHxLIdBmSuFRW06OYa+EtGmncfWtbyVdRZntybAw6?=
 =?us-ascii?Q?OODhhLOnBO+niMvrjN2rQwdeCY5yYDpcjXnTAflNUjr71tK16nDsKZY32Zcd?=
 =?us-ascii?Q?8shiEaNqpxRQ/4xAJqfNTT6lkO1ncn2+LoAoqYL3oh6Bg+hb/D01rQPzSv1A?=
 =?us-ascii?Q?NT3QweGsBQD9RcpXpg4h4NaLlqNl98cEGIxrN3uzJEPWK5KYhCtedwC+5ke8?=
 =?us-ascii?Q?nkZXrTy5jpO+8dl2/kcE+xoRf0IRxNkLhViCrPiBDUeH57nwZ6K7AWDjv791?=
 =?us-ascii?Q?yAn4FUd08uFGmZpbC4jDTK92/LMkXk9XZHr2AoyHxabbj1nV93Squp2gfOST?=
 =?us-ascii?Q?7P0y0Noig7MMKWZVeXz4YbOo0aeMUjk2MY2m0wdGxBNfd03KDQB9afEnoGti?=
 =?us-ascii?Q?u3xVPFdtrhw9Y6YBPBRYD1W3wA9kKBJ1IsaWPOinC9yqQKWK+vxe7H+LuXif?=
 =?us-ascii?Q?xYPZxdh+L8uT6k0Zozi3i0jvw4vKAB8Zme1bgbSk5Kcpixhk6C3K4h2OC1GQ?=
 =?us-ascii?Q?BSJz2VvFzaUr7n+loPNWjZg1anZKtIgPtb8O267C5F1/g7B7j5/kBw0sV+4a?=
 =?us-ascii?Q?0VXo/CV88Wof9pTS6jBW/2L8N4m4QpMMWOdlR0D1oygAQLHXWkikyVoqlazj?=
 =?us-ascii?Q?vWzQ0Jz/6WHH2JCwXlF5y7GHP2fWhqLyvzojmuPbzdF7X0NExm9M3br0ca3q?=
 =?us-ascii?Q?X8AGVdmAvIDYWJ6f4KH1oVot0mhBz7sJ1Y7p93YYFGeAQyjXbU71JNWjDqB5?=
 =?us-ascii?Q?EBnK86e66KFkNmKBr6DYlwOrofl7y0BR1NxXUY44ngYSnKRJd7Fmp5sYcmgX?=
 =?us-ascii?Q?VubpBlIA0RqXkTLrspq739OJSUFL1EmZ08JhbdSZkDtEneO3uiqboieQy9vY?=
 =?us-ascii?Q?AhEQ2t9lLHVrysuYj5YRaytESUbFEkdFAW70uasWcLKNRYMKpVyXWSTxkRK2?=
 =?us-ascii?Q?URTPnC7+1ETBnPbFe/6nfGlEdkWjtYUg6HSJehurR4t6kmEzJmIz1Ov38T75?=
 =?us-ascii?Q?OiMvstbopDX6mjj8WqeZ7yDEfL/7Cz5VbOnF1VuBBgDP2B5FddfFX6GKitji?=
 =?us-ascii?Q?SS7pi1b+1AtWoH+PTcRchL1VWJlKwxZMwl5M+XSXquyeSGA0rsKKD5OjoF5H?=
 =?us-ascii?Q?CpZIrMoRtIiHPJun6SSeQgDyd6MVqnJ4I2c6wPWiUeQCqlg1gAUpyb5MZq6h?=
 =?us-ascii?Q?hUsDp2UUUxLGpAW/DZh94y8QVG/YJMR/lEocZdzxbEaK0+pznKJO9pl6nyEZ?=
 =?us-ascii?Q?or1mcf2RWdoz35TA2XgnwadV4Ta11YZpnwuHxM9in4jKuhB8m/r08KkI/xAR?=
 =?us-ascii?Q?1eGPgVvFfogHuy4arGw0qVV8vVJVWOrmJkO2UZpztM49yeHc9sHcYksW2OHs?=
 =?us-ascii?Q?qErLhDn2LW/NwRdrXV267bvur1UC6qejsuBLjEMiN28ofaNUKbX8pk4Qr7qM?=
 =?us-ascii?Q?K/i8v1gYq26gCMZ+dkl4JoW3wVtn3qmx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gHmytnjB9aR19frm7uTpN60H1Je5H5sDQf4brD8nmkb4gabnPTqLMUh8ZQ70?=
 =?us-ascii?Q?nntkfkshAsscd/ULFbHUJXCes6VK+2LG6Un3c/OhJz8pvRf8SkKYUNKIfQWE?=
 =?us-ascii?Q?vEl0PPQA91iSZ9Z4NkaHXNaVBnnMUSpS9x1QTiQsq36lD+DVwvSZ6KfSf0B2?=
 =?us-ascii?Q?CTvEyNBqpf1WOj+Q8uHWjd6pDz34GW5z1uxw6KV0MpZB7CgXxuc1mwHdLBda?=
 =?us-ascii?Q?cFQRiL6fO+sHYmfJts+OASqoTAZdJPO7lIpldwER7e6BTsK3hj43VYIIrhWZ?=
 =?us-ascii?Q?RW5Lvl3bG5HCMGDEFdlD0EuqNB9Y3ba9PYLQqvw1WlkYMn9s2bJNP/s13xtt?=
 =?us-ascii?Q?/T4lIl+gzrb2EL25QXsjzjE+I75m47KTT1EFvrtU0SDmLaQ+nSbk4HyaHgUL?=
 =?us-ascii?Q?pxdc5gWmWJsOZoTRR+APBb8Zt3Dy5rZpaV4qJhPLcdGY15OKNr3ajt6Or9Wo?=
 =?us-ascii?Q?BxqIpk/tzgmLejUme3Dl8/MwuhY/LbDiTVBq7+lfEO+JWAMnxOWrjSXysE1J?=
 =?us-ascii?Q?eZsJt6Wuf7es9jUR52fbghN50l6sVLu2zPGB3rxuzi93T1Gt4GsoCAhgu8+O?=
 =?us-ascii?Q?J4Nemqh8YSxYXDhHdDvl+Axy//Fo6dqmjNTQSIZGn7D2DQjg2NMIacE/Y3eh?=
 =?us-ascii?Q?dBvNmVLwvPm/FZlBy3QoR3MbbYbjrnbZx1ZMYVYo+SLDfne2uQOvOJmhMclx?=
 =?us-ascii?Q?JqsMbrtSC5deOAUZLAjUCLOTbokdPwhLpWLt2C0G5f5QB+c/jgiR/Dqx4Bok?=
 =?us-ascii?Q?IceiotEwVj4zU889MGo76zh1+atD4ZRU8AvOi/SIzfqUvCYEtqMEHqnq3pnR?=
 =?us-ascii?Q?Xg/URJ35oZ13kEFu2/9h7L67MWk1ecVO9YpZCVr/QseBYBsLxSZH9bjiNvsl?=
 =?us-ascii?Q?ZDDl6gL1o//WFA8QdBng9lo4nMh33rFddYVcKKK3iLjxC4z6ZMHMQCR3VnLc?=
 =?us-ascii?Q?LPpkpAgIf2Y/tyZp9MUN6g9lZ4fPxkmC2f1KVwGDEIKJd1u/uS8bP1VPojg6?=
 =?us-ascii?Q?jbVI1eYkBsyRBzRydGMA5UqR+la09Jbi4nEYxyJW++3vVNxpgb3yGNDIfrZK?=
 =?us-ascii?Q?I7TAH9vrIu7uNdmEKnv1un1unZrY3hc8iMR4gY4jaqYjZUt1+0vl/Oq5sSuB?=
 =?us-ascii?Q?BUKsQBLM4roYM7XemGelgy0t0oykyaIdkqHd41G/Sdf/X8C8NaD9iMYp6Sul?=
 =?us-ascii?Q?W9svO2C97/A0n9kd+UMSNR7sCez0a2516VdJT6gKoO33DEy2A1NPiwVPFy+t?=
 =?us-ascii?Q?0yaAIHfhocWtEaR+nFPcXgMVeiWgRSxEOED/pgFwKYCu64AhYR6qI/0JJQv6?=
 =?us-ascii?Q?9Vir/RrYrNH9PRkkS2fmspPax5GcDUbgXy0F/8hcaELjpF3Qhzx9cv891tDE?=
 =?us-ascii?Q?RocaezKcGTh7NETj2BqlD5B5kIvpRgMGD14dDbffH2yKgRFfc2vqp0LTpQ9X?=
 =?us-ascii?Q?PIAKMEWdm2CMOXOqHseWGQZpvjpK6p8iEwmTvdAdgDN+rR69lGcKHtP9jhRC?=
 =?us-ascii?Q?SghMJ5GEq7KQ/vEw6s0U0dhK3k+jxPPt+kKVGsWUd2qLgPP4VbvTDQnM6idZ?=
 =?us-ascii?Q?EJIS6/Mul4M22aG5HjLQlTKwj5QwCwJeU7vcfn8H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33784adf-0bfd-441f-679b-08de392e0d59
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 03:25:09.2689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iF6IXwBLhY8LiceTFddtoxaDQmQH9fip4+N5fcunuUkbtqC2CpSAQtMIC/eu6M5ojXJw1YditJc4dvCfQKj7sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7711
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 03:19:06PM -0800, Sean Christopherson wrote:
>Add a test to verify KVM correctly handles a variety of edge cases related
>to APICv updates, and in particular updates that are triggered while L2 is
>actively running.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

A few nits below:

>--- /dev/null
>+++ b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
>@@ -0,0 +1,181 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+#include "test_util.h"
>+#include "kvm_util.h"
>+#include "processor.h"
>+#include "vmx.h"
>+
>+#define GOOD_IPI_VECTOR 0xe0
>+#define BAD_IPI_VECTOR 0xf0
>+
>+static volatile int good_ipis_received;
>+
>+static void good_ipi_handler(struct ex_regs *regs)
>+{
>+	good_ipis_received++;
>+}
>+
>+static void bad_ipi_handler(struct ex_regs *regs)
>+{
>+	TEST_FAIL("Received \"bad\" IPI; ICR MMIO write should have been ignored");

is it ok to use TEST_FAIL() in guest code?

>+}
>+
>+static void l2_vmcall(void)
>+{
>+	/*
>+	 * Exit to L1.  Assume all registers may be clobbered as selftests's
>+	 * VM-Enter code doesn't preserve L2 GPRs.
>+	 */
>+	asm volatile("push %%rbp\n\t"
>+		     "push %%r15\n\t"
>+		     "push %%r14\n\t"
>+		     "push %%r13\n\t"
>+		     "push %%r12\n\t"
>+		     "push %%rbx\n\t"
>+		     "push %%rdx\n\t"
>+		     "push %%rdi\n\t"
>+		     "vmcall\n\t"
>+		     "pop %%rdi\n\t"
>+		     "pop %%rdx\n\t"
>+		     "pop %%rbx\n\t"
>+		     "pop %%r12\n\t"
>+		     "pop %%r13\n\t"
>+		     "pop %%r14\n\t"
>+		     "pop %%r15\n\t"
>+		     "pop %%rbp\n\t"
>+		::: "rax", "rcx", "rdx", "rsi", "rdx", "r8", "r9", "r10", "r11", "memory");
>+}

There's already a vmcall() helper in vmx.h. Why add a new one?

>+int main(int argc, char *argv[])
>+{
>+	vm_vaddr_t vmx_pages_gva;
>+	struct vmx_pages *vmx;
>+	struct kvm_vcpu *vcpu;
>+	struct kvm_vm *vm;
>+	struct ucall uc;
>+
>+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
>+
>+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
>+
>+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
>+	prepare_virtualize_apic_accesses(vmx, vm);
>+	vcpu_args_set(vcpu, 2, vmx_pages_gva);

s/2/1

only one argument here.

