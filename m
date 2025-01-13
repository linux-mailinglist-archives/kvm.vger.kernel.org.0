Return-Path: <kvm+bounces-35268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1269A0AF76
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 07:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06552166171
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 06:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC02231C8C;
	Mon, 13 Jan 2025 06:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+KEK/Ar"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59181BEF98;
	Mon, 13 Jan 2025 06:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736750944; cv=fail; b=ukVoSzuvBYAwAx0XlBDqpV8DA07Ew4K+MkBNWfgldn7lbvFayz5gCFMSsryawCvapeODUoWW+rL/0FJDWQ2WM/NBK9s4gmAFIimE8rxH86Ue2u6rbqi3oYFq6MJDdk1/SEOiuI9dHnD30Omb1M1MyIIOcejyAgg5AWCS+X2k4jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736750944; c=relaxed/simple;
	bh=J8suXr1qDWsDLx0jPwZV46PLJzVEdvkofxgQXOtcNIY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nFJaGsIhtyXr5Xtqk8r+zhC18kxFUgQ0WMPCWOkKopma6Wi7M5xF6Ls5fpMzYJuHK/lY7dLcBk+OUs1yRX9rGBOplAxq3sf/mpGddVK6S+y+LS7HEnDz3YzWTgjYXwu0lEObZTk2Cj4AcLYWyCB5sKL82en5Up1XqkjhjRUhgao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+KEK/Ar; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736750943; x=1768286943;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=J8suXr1qDWsDLx0jPwZV46PLJzVEdvkofxgQXOtcNIY=;
  b=M+KEK/ArTqTpU3cj75eE65SyyJ3rI6D54G47eYFvE7YUM77AfcudO5eO
   HmRyI8L28SN5e4MPe5oymEr9FMK4MX+WLZGZYYJ/BRHgesUWkmoyem7uK
   clNHqM04sb/v3VvPaYzQyn6zFuMjMv54ebmneJC56jBEN/L9Rjo1VD+q5
   wylCBsHzlelvuI4yaDvCU/pXpX+/8IYKGOHPJkrQw/HXCcLvMS63o6Usa
   RgPAlVMHT1/pN3bUnRzns7GWlpiCiNIM6ANAfWcD18y3EziQkPW5HmuWg
   ZNBtByJ0rwWo+J5vXcHAwVW1nG0A1xiuS/hyNR3niAGI6ugNCIk3mk6b/
   A==;
X-CSE-ConnectionGUID: 98v4vZ00RfiP7nujDawcBg==
X-CSE-MsgGUID: d+A8+wcfQ3O3Dups7R/SBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="47570388"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="47570388"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 22:49:02 -0800
X-CSE-ConnectionGUID: SY6uagtUS3WmJpnLYTDr1A==
X-CSE-MsgGUID: TK+9ch38SJqftaJ7onmVNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="109498568"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2025 22:49:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 12 Jan 2025 22:49:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 12 Jan 2025 22:49:01 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 12 Jan 2025 22:49:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rk0qsSDPWd95e8OIJkGs9aXS6APaaHW+4P4/oJukkO6uQPS5Zcw3vs7E8Ey+gayfKKVYyXqAFQ16T3r0d+ZPmb24SSJqZATDjHSYx99Eh3D3RulTh65ael7Sx6bY8MC5W4UcTyeZqXZiv6dtWkODikZ4peZHZqKODY+p/RefShiy/h3iVAikYIbxIfx1KfkgtNV6WhUFw6KnCfXbJpt4bdOSHgVdD4R9LCfOijTqQxz9XfbcPFaiK1FbB3LwVt0ybDjorWRmAbM5sqweKjfJfvU6ZnV0RYqTMxOYMJo4lFGq2XAZ0TEqC0junDu41aGaBFQavlbnroDjk9S1wzuyQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFhzAmgUAMJrj5LDjuo7/BRfvLxN3nm5sVmevKhKDFM=;
 b=g/0NZq84YjFE71mx6W1OKLfn1amdSQNd4KAu4HDEjf2/7hvh2iDI8AeKhG7Py4Ug7F1KUsRXYVwmuHGWm9qyIG9/jHQg1+g78KcxM3xMsPCo6HOOgZ9ZdP+u4XMr5lKSH0eXvgl/ZQiE3I6/YlKki4eKqvOReTk7bZZu8Xw7wcFs437954vmwUbPeChQBk58z5aQn2bF674GYY8QjROZylY31Aqxg1ibSPgGbMrDCbtNsuFLA5iXuDFbGoyjQRBrHfJLGOF6yvJcYTpHON+bj24n2b5U5SpJFbZymYJBjWoH+wffOuNBARFo1aPKNc6+FhzsGRuw/SRkukTPpk1v/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW5PR11MB5787.namprd11.prod.outlook.com (2603:10b6:303:192::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Mon, 13 Jan 2025 06:48:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Mon, 13 Jan 2025
 06:48:59 +0000
Date: Mon, 13 Jan 2025 14:48:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 1/5] KVM: Bound the number of dirty ring entries in a
 single reset at INT_MAX
Message-ID: <Z4S3JTP71zdJFJqD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250111010409.1252942-2-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0065.apcprd02.prod.outlook.com
 (2603:1096:4:54::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW5PR11MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: b61a1e17-d878-47e2-d578-08dd339e5baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9K34FwzEMtQUyWTIjbzh9dp0n8oYkS7g/5VlTKSbFLwyPE9spLyOQceWrS0x?=
 =?us-ascii?Q?6kCZKACjLha1YSZA4HpuFytGsevsHLeJEbdj9kaiepHoFwQC/Hx9B+tm6T8I?=
 =?us-ascii?Q?miqkvkWKbWbLYeimaHxjBgPCavdUzgUqOCl7hFqL3ezx2GunKccUjvgPBr2U?=
 =?us-ascii?Q?EQhSPPf2GP06W/sKdS2G3FX66gh9wa7gC7/GrE/oL6vilC+VsjnyKT+O0x2v?=
 =?us-ascii?Q?THdxMNia5n2CzrUAEa2Q4tB0NvX0Y0zL+cw7nmh1HeJjLjgZoWKmScN7IyqE?=
 =?us-ascii?Q?oo8DX4XHAFSsElJeEFYB/ZQH1zLgZ5KSMiW3RBE7V6WixTcb+Ds4g1gb12lS?=
 =?us-ascii?Q?fPp/wrmNQbvuQAysq3QuP5spGir/ac//pg3CjO5H+aCQ614QBKZgReVKIHJB?=
 =?us-ascii?Q?kCtmFGM1LzSVkqnnt3WW+a731RWpk8CGNFeFnj5cU/PFJhg+lKwumrkNIYa0?=
 =?us-ascii?Q?iRjPgrhNMGeqSbX2FncGUZPh4sVQrwPRkfqCXMoi7IawD6Y5Q/duUZz3mYrK?=
 =?us-ascii?Q?L1lc+cpoUS6veuzHvBo53Hq0rQ/2PLmbYUiaYngIK5f5RZkaWMGXhu4EmOeJ?=
 =?us-ascii?Q?Oa7Zp3ufC3KvYImUFbgM6TPbMptuIcEQoyS7CrirH2hgwVsAVgbOh7wrySOy?=
 =?us-ascii?Q?fwTcsEk+1/X649OFMbkj6eKQFCwxtiSgbzuRa4lEF2eO+9KEVly7nH+fx/7l?=
 =?us-ascii?Q?kJWL02gQON3ondZUW4fkdwaqoTH8QvyquVqs96gzJHHzh0y0LKOHm5Cs45ko?=
 =?us-ascii?Q?zXlAkHpfAXs1tQeLr4n7BMGGiVnNUz3LFw3Rn+X7suRa2uFj+D8vcs8pDjwm?=
 =?us-ascii?Q?mJUuBdcvYskhc3aqrhJDyNZ6xxNZMOsCSphHm3ZPlO3BHWuFxaa57TTGfoJt?=
 =?us-ascii?Q?WTWoX0Tv/OaDc8QVcg0E8TE6vQ56XE9QKn63irK4NC3YhjQlq7ju47CX8ZG2?=
 =?us-ascii?Q?VyLml9qCO/HrS6oPzmqPh+Su3MozLm/egBHfhGYf68Y7c5OKf6KoHpg7WQTK?=
 =?us-ascii?Q?NHes1Zjb3HkGBhrcWX6TNJ45zUsUeGsVS038FjMPHwApQFDyMWqMuSUK4w4D?=
 =?us-ascii?Q?Dt0ftIyDLgU43dxGCX2CCLGQDEOhD/lQA0IdUMv4qTms+VeU/MhS+xeIAKMu?=
 =?us-ascii?Q?sxuVDkmWutW1owEX99ypSY9q4Q2Szn28m+0a1hNm04JxWBpirjylM0QzfG08?=
 =?us-ascii?Q?X2glDziA5sH7fzHm126+gPkbJ+wZgZoJzUinQ5xIu3v+bBQ1fryQsEd0edFp?=
 =?us-ascii?Q?FyvDdu+k1bvVG1IFSx+QnTUmNPetHHbEMGRNton6zrwiJre2jwPN6WbNaskd?=
 =?us-ascii?Q?207TrYcJwNpnhs3GyHWSojtKT2sQT8NbYHvoHmBTbySQfj4/tDNS4CNHHKj3?=
 =?us-ascii?Q?pgZIbk+JYOa4pS+FFLgXLnwK/kfO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KhQDLkd3+JusYpbkcGKSXgS5W0R9t7lTwMLqfH6Z0MHfMz7hL7DNiHVyNoNj?=
 =?us-ascii?Q?sHSQEi2EfkpaY/6pSzxahZteXM7UAQBN0WOHDXCsuN7Hidiqp6ymCb407GoG?=
 =?us-ascii?Q?Fie5tdKbcsFN1E7sjw6mjsn7qE8UsJaacEvITjVot4FY3pBxavAif7HLlPHc?=
 =?us-ascii?Q?fzOnNmrRF/1OQWHMjkRDBe4nsi9dVZEZoGZAxqGVXEAfCAqMlbyV7peCrsHs?=
 =?us-ascii?Q?oW8ZixmSG0IAMn6A7TTkUTws0IarJWsGbQDHt0CVuO3yzjQc4VJW/pFVN5Jw?=
 =?us-ascii?Q?Y+qAv43l5bAHKfZca4MuJJiynAQTAuGEi/u2FQ3wepXNk2TYOnQbLQZO6hSn?=
 =?us-ascii?Q?VN6Sr0mVAB/sZ2Y3uEucooEj6jluRXyScpbVTmxdB+BDqiAtJePmTKgWGTlT?=
 =?us-ascii?Q?cRweHKAJNYWSu2pwiE1GERj/xeTnJ8v2mFonuK4RCDjjCrCRwMZncEOViw4T?=
 =?us-ascii?Q?HXSZXlatQfSmLtZJl5xGqP1ToVkakcwZn8ulnmr9ZVc9eU1pQPO1zxaFU+mu?=
 =?us-ascii?Q?2uTcNP7OO5FuAx/yKNMQnC41abXeXTK1SarfvI/C5f/oi42Xxmpb3b8JOz7J?=
 =?us-ascii?Q?7+InLjx2fmrkNfW7qq3/ai5DoVTUVY2gCdWlEBZp2pgICJfXuRPUz964BmL7?=
 =?us-ascii?Q?iyfMn79Vk8ot5hcntTVcxff19KUr+mUQtM8UIhnkg/h16BSwl00LAJ8VFmJ9?=
 =?us-ascii?Q?Pu22gCxWyNkuW2YwBFyClrYIey8/jqG0tt/D3yFgJQwz1ckkyM7o6EIQbP5U?=
 =?us-ascii?Q?5SfCyeF/94NLSOCZwEL9OeJy3EOkndnFHmZj4ykUErCBi1APvKQjMGQLBnGb?=
 =?us-ascii?Q?ZV/JZVwiQ/Jdih8j65HoCOSxD7RE0YR9HdmBJ/YYW2Zxuv3pgAYzrqSsB3G7?=
 =?us-ascii?Q?Q5tlchF1/LMZ1ufkJkXzjro4UVtb/4AujtJcxt7kHUgN8ujboLv1jbZjbFQM?=
 =?us-ascii?Q?LrHQPiRaAuy6wMt2em3coUWOfT4vNpraXpf3oRsMUMqoKWxUyyq3BxPdLges?=
 =?us-ascii?Q?ornWd6B6a0wmSpz8yn2MTyAiMEbEVJUWO5f/DPCs73Stu+CFYYIp+Asfet5R?=
 =?us-ascii?Q?Om4KdEcRjLicyIyWGOeojWw/puyfD/UKAbAUWV/DRv5Nkdoi8sJEEFeaua5f?=
 =?us-ascii?Q?Wsr/UUBjvCmY+/p2poqm0qaJvVbolZknpRIo4fp+xZUIk9kZ2yXFxYhenqLb?=
 =?us-ascii?Q?aY907crlrC97qixDrZzQ6sbR5zxEzhoa9xPxcwxOmKufXt0uR7dbVXfM2ujZ?=
 =?us-ascii?Q?QvUqyUhz2Ci6mjqdeBAzdwBPcRKyqegdH1uMnbvx14FIiftOyfBmIVK+2v08?=
 =?us-ascii?Q?hx/YxkkEJYflrv2YFmAYPLdbQt5pKFB87p7Jeu1IUFSN6wJdZl0ePCh2v0dd?=
 =?us-ascii?Q?X+jQeUTBgKq5lsKMzSEsSKFpufdxJkwGpyvX0Evb3cXiSu3PduK1RAZ/KyTB?=
 =?us-ascii?Q?+3UKF4cg6RNvfkoNsteMvxyVdVMRLefO7H2g55RqwtjO+sNs4TbFYXTc9uw0?=
 =?us-ascii?Q?hDTe5tXd8KUWUO70bSaoHvsRYh/dQg+0hM7374aMcL6F3y9gZW0DcOO4iXAD?=
 =?us-ascii?Q?cdACALn4mfwPhXwCv1P3pbwkG4aAPtmyyBKB42Lj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b61a1e17-d878-47e2-d578-08dd339e5baa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 06:48:59.4221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BP9FuSdD0xF0LdP6GBaBGzh6FoekC9iT/XjwJcrOWWCbMnFGkhr175fVt4emjZJd2Hl0IJ5Q8BFaI/wcMmV37g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5787
X-OriginatorOrg: intel.com

On Fri, Jan 10, 2025 at 05:04:05PM -0800, Sean Christopherson wrote:
> Cap the number of ring entries that are reset in a single ioctl to INT_MAX
> to ensure userspace isn't confused by a wrap into negative space, and so
> that, in a truly pathological scenario, KVM doesn't miss a TLB flush due
> to the count wrapping to zero.  While the size of the ring is fixed at
> 0x10000 entries and KVM (currently) supports at most 4096, userspace is
> allowed to harvest entries from the ring while the reset is in-progress,
> i.e. it's possible for the ring to always harvested entries.
> 
> Opportunistically return an actual error code from the helper so that a
> future fix to handle pending signals can gracefully return -EINTR.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_dirty_ring.h |  8 +++++---
>  virt/kvm/dirty_ring.c          | 10 +++++-----
>  virt/kvm/kvm_main.c            |  9 ++++++---
>  3 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> index 4862c98d80d3..82829243029d 100644
> --- a/include/linux/kvm_dirty_ring.h
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -49,9 +49,10 @@ static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
>  }
>  
>  static inline int kvm_dirty_ring_reset(struct kvm *kvm,
> -				       struct kvm_dirty_ring *ring)
> +				       struct kvm_dirty_ring *ring,
> +				       int *nr_entries_reset)
>  {
> -	return 0;
> +	return -ENOENT;
>  }
>  
>  static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
> @@ -81,7 +82,8 @@ int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
>   * called with kvm->slots_lock held, returns the number of
>   * processed pages.
>   */
> -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> +			 int *nr_entries_reset);
>  
>  /*
>   * returns =0: successfully pushed
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 7bc74969a819..2faf894dec5a 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -104,19 +104,19 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>  	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>  }
>  
> -int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
> +int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> +			 int *nr_entries_reset)
>  {
>  	u32 cur_slot, next_slot;
>  	u64 cur_offset, next_offset;
>  	unsigned long mask;
> -	int count = 0;
>  	struct kvm_dirty_gfn *entry;
>  	bool first_round = true;
>  
>  	/* This is only needed to make compilers happy */
>  	cur_slot = cur_offset = mask = 0;
>  
> -	while (true) {
> +	while (likely((*nr_entries_reset) < INT_MAX)) {
>  		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
>  
>  		if (!kvm_dirty_gfn_harvested(entry))
> @@ -129,7 +129,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  		kvm_dirty_gfn_set_invalid(entry);
>  
>  		ring->reset_index++;
> -		count++;
> +		(*nr_entries_reset)++;
>  		/*
>  		 * Try to coalesce the reset operations when the guest is
>  		 * scanning pages in the same slot.
> @@ -166,7 +166,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>  
>  	trace_kvm_dirty_ring_reset(ring);
>  
> -	return count;
> +	return 0;
>  }
>  
>  void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9d54473d18e3..2d63b4d46ccb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4877,15 +4877,18 @@ static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
>  {
>  	unsigned long i;
>  	struct kvm_vcpu *vcpu;
> -	int cleared = 0;
> +	int cleared = 0, r;
>  
>  	if (!kvm->dirty_ring_size)
>  		return -EINVAL;
>  
>  	mutex_lock(&kvm->slots_lock);
>  
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring);
Previously "cleared" counts all cleared count in all vCPUs.

> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		r = kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring, &cleared);
Here it's reset to the cleared count in the last vCPU, possibly causing loss of
kvm_flush_remote_tlbs(().

> +		if (r)
> +			break;
> +	}
>  
>  	mutex_unlock(&kvm->slots_lock);
>  
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

